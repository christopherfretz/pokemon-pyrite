#!/usr/bin/env python3
"""Generate web/tables.json for the browser save editor.

Everything the editor needs to read and rewrite a save is derived here from the
build itself -- the linker's .sym file, the constants/ sources and the linked
ROM -- so nothing is hand-copied and the tables can never drift from the ROM.

Inputs (all relative to the hack/ checkout):
  pokecrystal.sym            SRAM/WRAM/ROM symbol addresses
  pokecrystal.gbc            sha256 + cartridge header (title key)
  constants/*.asm            const_def enums, rs structs, charmap
  data/items/names.asm       item names          (id = 1-based index)
  data/pokemon/names.asm     species names       (id = 1-based index)
  data/moves/names.asm       move names          (id = 1-based index)
  data/items/attributes.asm  item pocket per id
  data/maps/spawn_points.asm spawn table
  data/growth_rates.asm      EXP curve coefficients

Usage: python3 web/gen_tables.py [--root .] [--out web/tables.json]
"""

import argparse
import datetime
import hashlib
import json
import os
import re
import sys

# ---------------------------------------------------------------- .sym parsing

SYM_RE = re.compile(r"^([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4})\s+(\S+)")


def load_syms(path):
    syms = {}
    with open(path, "r", encoding="utf-8", errors="replace") as f:
        for line in f:
            m = SYM_RE.match(line)
            if m:
                syms[m.group(3)] = (int(m.group(1), 16), int(m.group(2), 16))
    return syms


def rom_offset(bank, addr):
    """Flat offset into the .gbc image."""
    if addr < 0x4000:
        return addr
    return bank * 0x4000 + (addr - 0x4000)


def sram_offset(bank, addr):
    """Flat offset into a 32 KiB .sav (raw cartridge RAM)."""
    return bank * 0x2000 + (addr - 0xA000)


# ------------------------------------------------------- asm constant evaluator

class Consts:
    """A forgiving evaluator for the subset of rgbasm used by constants/*.asm.

    Handles const_def / const / const_skip / const_next / shift_const, the rs
    struct directives, `DEF x EQU/=/+= expr`, and the hack's TM/HM macros.
    Lines it cannot evaluate are skipped and recorded, not fatal: we only need
    a known subset of names, and every one of those is asserted for at the end.
    """

    def __init__(self):
        self.vals = {}
        self.const_value = 0
        self.const_inc = 1
        self.rs = 0
        self.skipped = []

    # -- expression evaluation
    def expr(self, text):
        t = text.split(";")[0].strip()
        if not t:
            raise ValueError("empty")
        t = re.sub(r"\bpercent\b", "* 255 / 100", t)
        t = re.sub(r"\$([0-9A-Fa-f]+)", lambda m: str(int(m.group(1), 16)), t)
        t = re.sub(r"%([01]+)", lambda m: str(int(m.group(1), 2)), t)
        t = re.sub(r"\b_RS\b", str(self.rs), t)
        t = re.sub(r"\bconst_value\b", str(self.const_value), t)
        # identifiers -> values
        def sub_ident(m):
            name = m.group(0)
            if name in self.vals:
                return "(" + str(self.vals[name]) + ")"
            raise KeyError(name)
        t = re.sub(r"[A-Za-z_][A-Za-z0-9_]*", sub_ident, t)
        if not re.fullmatch(r"[0-9()+\-*/<>|&~^ ]*", t):
            raise ValueError("unsupported expression: " + text)
        t = t.replace("/", "//")
        t = t.replace("<<", "@L@").replace(">>", "@R@")
        t = t.replace("<", "<").replace(">", ">")
        t = t.replace("@L@", "<<").replace("@R@", ">>")
        return int(eval(t, {"__builtins__": {}}, {}))  # noqa: S307 - numeric only

    def set(self, name, value):
        self.vals[name] = value

    # -- the TM/HM macros from constants/item_constants.asm
    def _tmnum(self, move):
        n = self.vals.get("__tmhm_value__", 1)
        self.set(move + "_TMNUM", n)
        self.set("__tmhm_value__", n + 1)
        return n

    def add_tm(self, move):
        self.set("TM_" + move, self.const_value)
        self.const_value += self.const_inc
        n = self.vals.get("__tmhm_value__", 1)
        self.set("TM%02d_MOVE" % n, self.vals.get(move, 0))
        self.set("TM%02d_ITEM" % n, self.vals["TM_" + move])
        self._tmnum(move)

    def add_tm_id(self, move):
        n = self.vals.get("__tmhm_value__", 1)
        self.set("TM%02d_MOVE" % n, self.vals.get(move, 0))
        self.set("TM%02d_ITEM" % n, self.vals["TM_" + move])
        self._tmnum(move)

    def add_hm(self, move):
        self.set("HM_" + move, self.const_value)
        self.const_value += self.const_inc
        n = self.vals.get("__tmhm_value__", 1) - self.vals["NUM_TMS"]
        self.set("HM%02d_MOVE" % n, self.vals.get(move, 0))
        self.set("HM%02d_ITEM" % n, self.vals["HM_" + move])
        self._tmnum(move)

    def add_mt(self, move):
        n = (self.vals.get("__tmhm_value__", 1)
             - self.vals["NUM_TMS"] - self.vals["NUM_HMS"])
        self.set("MT%02d_MOVE" % n, self.vals.get(move, 0))
        self._tmnum(move)

    # -- map_constants.asm macros
    def newgroup(self, name):
        self.const_value += self.const_inc
        self.set("MAPGROUP_" + name, self.const_value)
        self.set("__map_value__", 1)

    def map_const(self, name):
        self.set("GROUP_" + name, self.const_value)
        self.set("MAP_" + name, self.vals.get("__map_value__", 1))
        self.set("__map_value__", self.vals.get("__map_value__", 1) + 1)

    # -- line dispatch
    def feed(self, line):
        s = line.split(";")[0].rstrip()
        if not s.strip():
            return
        s = s.strip()

        m = re.match(r"^const_def\b\s*(.*)$", s)
        if m:
            args = [a.strip() for a in m.group(1).split(",") if a.strip()]
            self.const_value = self.expr(args[0]) if len(args) >= 1 else 0
            self.const_inc = self.expr(args[1]) if len(args) >= 2 else 1
            return
        m = re.match(r"^const\s+([A-Za-z_][A-Za-z0-9_]*)\s*$", s)
        if m:
            self.set(m.group(1), self.const_value)
            self.const_value += self.const_inc
            return
        m = re.match(r"^const_skip\b\s*(.*)$", s)
        if m:
            n = self.expr(m.group(1)) if m.group(1).strip() else 1
            self.const_value += self.const_inc * n
            return
        m = re.match(r"^const_next\s+(.+)$", s)
        if m:
            self.const_value = self.expr(m.group(1))
            return
        m = re.match(r"^shift_const\s+([A-Za-z_][A-Za-z0-9_]*)\s*$", s)
        if m:
            self.set(m.group(1), 1 << self.const_value)
            self.set(m.group(1) + "_F", self.const_value)
            self.const_value += self.const_inc
            return
        if s == "rsreset":
            self.rs = 0
            return
        m = re.match(r"^rsset\s+(.+)$", s)
        if m:
            self.rs = self.expr(m.group(1))
            return
        m = re.match(r"^rb_skip\b\s*(.*)$", s)
        if m:
            self.rs += self.expr(m.group(1)) if m.group(1).strip() else 1
            return
        m = re.match(r"^DEF\s+([A-Za-z_][A-Za-z0-9_]*)\s+(rb|rw)\b\s*(.*)$", s)
        if m:
            name, kind, rest = m.group(1), m.group(2), m.group(3).strip()
            n = self.expr(rest) if rest else 1
            self.set(name, self.rs)
            self.rs += n * (2 if kind == "rw" else 1)
            return
        m = re.match(r"^(?:DEF\s+)?([A-Za-z_][A-Za-z0-9_]*)\s+"
                     r"(EQU|EQUS|=|\+=|-=)\s+(.+)$", s)
        if m:
            name, op, rhs = m.group(1), m.group(2), m.group(3)
            if op == "EQUS":
                return  # string equates are not numbers
            try:
                v = self.expr(rhs)
            except Exception:
                self.skipped.append(s)
                return
            if op == "+=":
                self.set(name, self.vals.get(name, 0) + v)
            elif op == "-=":
                self.set(name, self.vals.get(name, 0) - v)
            else:
                self.set(name, v)
            return
        for macro, fn in (("add_tm_id", self.add_tm_id), ("add_tm", self.add_tm),
                          ("add_hm", self.add_hm), ("add_mt", self.add_mt),
                          ("add_tmnum", self._tmnum),
                          ("newgroup", self.newgroup), ("map_const", self.map_const)):
            m = re.match(r"^" + macro + r"\s+([A-Za-z_][A-Za-z0-9_]*)", s)
            if m:
                try:
                    fn(m.group(1))
                except Exception:
                    self.skipped.append(s)
                return
        self.skipped.append(s)

    def feed_file(self, path):
        skip_macro = False
        with open(path, "r", encoding="utf-8", errors="replace") as f:
            for line in f:
                st = line.strip()
                if re.match(r"^MACRO\b|^MACRO\?", st):
                    skip_macro = True
                    continue
                if skip_macro:
                    if st == "ENDM":
                        skip_macro = False
                    continue
                try:
                    self.feed(line)
                except Exception:
                    # forward reference or unsupported syntax: pass 2 resolves it
                    self.skipped.append(st)


# ---------------------------------------------------------------- name tables

STR_RE = re.compile(r'"((?:[^"\\]|\\.)*)"')


def parse_name_list(path, directive):
    """Pull the quoted names out of `li "..."` / `dname "..."` lines, in order."""
    out = []
    with open(path, "r", encoding="utf-8", errors="replace") as f:
        for line in f:
            s = line.split(";")[0].strip()
            m = re.match(r"^" + directive + r"\s+(.*)$", s)
            if not m:
                continue
            sm = STR_RE.search(m.group(1))
            if sm:
                out.append(sm.group(1))
    return out


def pretty(name):
    """ALL-CAPS game name -> display form; `#` is the game's POKe glyph."""
    return name.replace("#", "POKe").replace("\\", "")


# Map-name words that must not be title-cased.  These are the only ones the
# spawn list actually hits; anything else falls through to plain title case.
TITLE_WORDS = {
    "POKECENTER": "Pokémon Center",
    "POKECOM": "PokeCom",
    "REDS": "Red's",
    "BILLS": "Bill's",
    "SS": "S.S.",
    "SW": "SW", "NW": "NW", "SE": "SE", "NE": "NE",
    "SSW": "SSW", "SSE": "SSE", "NNW": "NNW", "NNE": "NNE",
}


def title_case(const):
    """ROUTE_9 / LAVENDER_TOWN -> 'Route 9' / 'Lavender Town'."""
    words = const.split("_")
    out = []
    for w in words:
        if not w:
            continue
        if w in TITLE_WORDS:
            out.append(TITLE_WORDS[w])
        elif w.isdigit():
            out.append(w)
        elif re.match(r"^B?\d+F$", w):     # 1F, 2F, B1F -- floor numbers
            out.append(w)
        elif len(w) <= 2 and w.isupper() and not w.isalpha():
            out.append(w)
        else:
            out.append(w[0] + w[1:].lower())
    return " ".join(out)


def parse_badges(path):
    """constants/engine_flags.asm -> [{byte, bit, name, label}].

    The badge bits are plain `const`s inside the ENGINE_* enum, grouped under
    a `; wJohtoBadges` / `; wKantoBadges` comment; bit n is the nth const in
    the group.  Parsing the comment header is how the file itself documents
    which WRAM byte each run of flags lives in.
    """
    out = []
    cur = None
    bit = 0
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            s = line.strip()
            m = re.match(r"^;\s*(w[A-Za-z0-9_]+)\s*$", s)
            if m:
                cur = m.group(1) if m.group(1).endswith("Badges") else None
                bit = 0
                continue
            if cur is None:
                continue
            m = re.match(r"^const\s+ENGINE_([A-Z0-9_]+)\s*$", s)
            if not m:
                if s and not s.startswith(";"):
                    cur = None
                continue
            name = m.group(1)
            out.append({"byte": cur, "bit": bit, "name": name,
                        "label": name.replace("BADGE", "").capitalize() + " Badge"})
            bit += 1
    return out


# ---------------------------------------------------------------------- charmap

def parse_charmap(path):
    """char -> byte, first definition wins (the file re-maps "@" at the end)."""
    cmap = {}
    with open(path, "r", encoding="utf-8", errors="replace") as f:
        for line in f:
            s = line.split(";")[0].strip()
            m = re.match(r'^charmap\s+"((?:[^"\\]|\\.)*)"\s*,\s*(.+)$', s)
            if not m:
                continue
            raw, val = m.group(1), m.group(2).strip()
            raw = raw.replace('\\"', '"').replace("\\\\", "\\")
            if val.startswith("$"):
                b = int(val[1:], 16)
            elif val.isdigit():
                b = int(val)
            else:
                continue
            if len(raw) == 1 and raw not in cmap:
                cmap[raw] = b
    return cmap


CONST_FILES = (
    "misc_constants.asm", "text_constants.asm", "battle_constants.asm",
    "item_data_constants.asm", "pokemon_constants.asm", "move_constants.asm",
    "pokemon_data_constants.asm", "item_constants.asm",
    "map_data_constants.asm", "map_constants.asm", "event_flags.asm",
    "gfx_constants.asm",
)


# ------------------------------------------- the overworld block-data window

class MapReader:
    """Reads map headers / attributes / block data straight out of the ROM.

    Why the editor needs this: MapSetupScript_Continue (data/maps/setup_scripts
    .asm) runs LoadBlockData -- which loads the real blocks for wMapGroup /
    wMapNumber -- and then LoadConnectionBlockData, which copies the saved
    6x5 metatile window in wScreenSave straight back over the blocks around the
    player.  A save whose map was edited but whose wScreenSave still holds the
    old map's window boots into a 6x5 patch of the WRONG map and the player is
    usually walled in.  build_window replays ChangeMap + FillMapConnections +
    GetMapScreenCoords so the editor can write the window the game would have
    produced itself.
    """

    EAST, WEST, SOUTH, NORTH = 1, 2, 4, 8  # shift_const order, map_data_constants

    def __init__(self, rom, syms, K):
        self.rom = rom
        self.map_len = K["MAP_LENGTH"]
        self.pad = K["MAP_CONNECTION_PADDING_WIDTH"]
        self.sw = K["SCREEN_META_WIDTH"]
        self.sh = K["SCREEN_META_HEIGHT"]
        self.blocks_wram = syms["wOverworldMapBlocks"][1]
        gb, ga = syms["MapGroupPointers"]
        self.group_bank = gb
        self.group_table = rom_offset(gb, ga)
        self.scene_table = rom_offset(*syms["MapScenes"])

    def _u16(self, off):
        return self.rom[off] | (self.rom[off + 1] << 8)

    def scene_pointer(self, group, number):
        """The WRAM scene variable for a map, or 0 -- GetMapSceneID (home/map
        .asm).  wCurMapSceneScriptPointer is saved in SRAM, and the continue
        path does not reload it, so a save moved to another map would keep
        pointing at the old map's scene id and run whichever scene of the NEW
        map's scene_scripts table happens to have that number.  (Found the hard
        way: a Pewter save moved to Vermilion ran Vermilion's `left the S.S.
        Anne` scene and walked the player off the top of the map.)
        """
        off = self.scene_table
        while self.rom[off] != 0xFF:
            if self.rom[off] == group and self.rom[off + 1] == number:
                return self._u16(off + 2)
            off += 4
        return 0

    def header(self, group, number):
        gp = self._u16(self.group_table + 2 * (group - 1))
        return rom_offset(self.group_bank, gp) + self.map_len * (number - 1)

    def attributes(self, group, number):
        h = self.header(group, number)
        return rom_offset(self.rom[h], self._u16(h + 3))

    def blocks_bank(self, group, number):
        return self.rom[self.attributes(group, number) + 3]

    def build_window(self, group, number, x, y):
        """-> list of SCREEN_META_WIDTH*SCREEN_META_HEIGHT block ids."""
        rom = self.rom
        a = self.attributes(group, number)
        height, width = rom[a + 1], rom[a + 2]
        blocks = rom_offset(rom[a + 3], self._u16(a + 4))
        conn = rom[a + 11]
        stride = width + 2 * self.pad

        # LoadBlockData: zero-fill, then ChangeMap copies the map in at (3, 3)
        buf = bytearray(0x2000)
        start = self.pad * stride + self.pad
        for row in range(height):
            src = blocks + row * width
            dst = start + row * stride
            buf[dst:dst + width] = rom[src:src + width]

        # FillMapConnections: the connection structs are laid out north, south,
        # west, east (the order home/map.asm's GetMapConnections reads them in)
        # and already carry absolute source/destination pointers.
        off = a + 12
        for bit in (self.NORTH, self.SOUTH, self.WEST, self.EAST):
            if not conn & bit:
                continue
            c = off
            off += 12
            cgroup, cnumber = rom[c], rom[c + 1]
            src = rom_offset(self.blocks_bank(cgroup, cnumber), self._u16(c + 2))
            dst = self._u16(c + 4) - self.blocks_wram
            strip_len, cwidth = rom[c + 6], rom[c + 7]
            if bit in (self.NORTH, self.SOUTH):
                rows, run, step = self.pad, strip_len, cwidth
            else:
                rows, run, step = strip_len, self.pad, cwidth
            for _ in range(rows):
                if 0 <= dst and dst + run <= len(buf):
                    buf[dst:dst + run] = rom[src:src + run]
                src += step
                dst += stride

        # GetMapScreenCoords (engine/overworld/warp_connection.asm)
        bx = (x >> 1) + 1 if x % 2 == 0 else (x + 1) >> 1
        by = (y >> 1) + 1 if y % 2 == 0 else (y + 1) >> 1
        anchor = by * stride + bx
        out = []
        for r in range(self.sh):
            row = anchor + r * stride
            out.extend(buf[row:row + self.sw])
        return out


# ------------------------------------------------------------------------ main

def main():
    here = os.path.dirname(os.path.abspath(__file__))
    default_root = os.path.dirname(here)
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=default_root, help="hack/ checkout root")
    ap.add_argument("--sym", default=None)
    ap.add_argument("--rom", default=None)
    ap.add_argument("--out", default=None)
    args = ap.parse_args()

    root = os.path.abspath(args.root)
    sym_path = args.sym or os.path.join(root, "pokecrystal.sym")
    rom_path = args.rom or os.path.join(root, "pokecrystal.gbc")
    out_path = args.out or os.path.join(root, "web", "tables.json")

    def p(*parts):
        return os.path.join(root, *parts)

    syms = load_syms(sym_path)
    with open(rom_path, "rb") as f:
        rom = f.read()

    C = Consts()
    for name in CONST_FILES:
        C.feed_file(p("constants", name))
    # second pass: resolve forward references (rs sizes depend on later files)
    C2 = Consts()
    C2.vals.update(C.vals)
    for name in CONST_FILES:
        C2.feed_file(p("constants", name))
    # NUM_SQUARE_ROOTS lives with the routine, not in constants/; the editor's
    # stat calculator needs it to clamp the stat-EXP square root like the game.
    C2.feed_file(p("engine", "math", "get_square_root.asm"))
    K = C2.vals

    def need(name):
        if name not in K:
            sys.exit("gen_tables: constant %s not resolved" % name)
        return K[name]

    # --- SRAM copies -------------------------------------------------------
    def soff(name):
        if name not in syms:
            sys.exit("gen_tables: symbol %s missing from %s" % (name, sym_path))
        return sram_offset(*syms[name])

    prim = {
        "name": "primary",
        "options": soff("sOptions"),
        "checkValue1": soff("sCheckValue1"),
        "gameData": soff("sGameData"),
        "gameDataEnd": soff("sGameDataEnd"),
        "playerData": soff("sPlayerData"),
        "curMapData": soff("sCurMapData"),
        "pokemonData": soff("sPokemonData"),
        "checksum": soff("sChecksum"),
        "checkValue2": soff("sCheckValue2"),
    }
    back = {
        "name": "backup",
        "options": soff("sBackupOptions"),
        "checkValue1": soff("sBackupCheckValue1"),
        "gameData": soff("sBackupGameData"),
        "gameDataEnd": soff("sBackupGameDataEnd"),
        "playerData": soff("sBackupPlayerData"),
        "curMapData": soff("sBackupCurMapData"),
        "pokemonData": soff("sBackupPokemonData"),
        "checksum": soff("sBackupChecksum"),
        "checkValue2": soff("sBackupCheckValue2"),
    }
    for k in ("gameData", "playerData", "curMapData", "pokemonData",
              "gameDataEnd", "checksum", "checkValue2", "options", "checkValue1"):
        prim[k] = prim[k]
    delta = back["gameData"] - prim["gameData"]
    for k in ("options", "checkValue1", "playerData", "curMapData",
              "pokemonData", "gameDataEnd", "checksum", "checkValue2"):
        if back[k] - prim[k] != delta:
            sys.exit("gen_tables: backup copy is not a uniform -0x%x shift (%s)"
                     % (-delta, k))
    for c in (prim, back):
        c["gameDataLen"] = c["gameDataEnd"] - c["gameData"]

    # --- WRAM symbol -> primary .sav offset --------------------------------
    blocks = []
    for wname, sname in (("wPlayerData", "sPlayerData"),
                         ("wCurMapData", "sCurMapData"),
                         ("wPokemonData", "sPokemonData"),
                         ("wCrystalData", "sCrystalData")):
        if wname not in syms or sname not in syms:
            sys.exit("gen_tables: missing block symbol %s/%s" % (wname, sname))
        end = syms.get(wname + "End")
        if end is None:
            sys.exit("gen_tables: missing %sEnd" % wname)
        blocks.append((syms[wname][1], end[1], soff(sname)))

    # sizes: distance to the next distinct WRAM address in the same bank
    wram_addrs = sorted({a for (b, a) in syms.values() if 0xC000 <= a < 0xE000})

    def wsize(addr):
        i = 0
        lo, hi = 0, len(wram_addrs)
        while lo < hi:
            mid = (lo + hi) // 2
            if wram_addrs[mid] <= addr:
                lo = mid + 1
            else:
                hi = mid
        i = lo
        return (wram_addrs[i] - addr) if i < len(wram_addrs) else 1

    def field(wname):
        if wname not in syms:
            sys.exit("gen_tables: WRAM symbol %s missing" % wname)
        addr = syms[wname][1]
        for lo, hi, base in blocks:
            if lo <= addr < hi:
                return [base + (addr - lo), wsize(addr)]
        sys.exit("gen_tables: %s ($%04x) is outside every saved block" % (wname, addr))

    field_names = [
        # player data
        "wPlayerID", "wPlayerName", "wRivalName", "wGameTimeHours",
        "wGameTimeMinutes", "wGameTimeSeconds", "wPikaFollowFlags", "wPikaMood",
        "wStatusFlags", "wMoney", "wCoins", "wJohtoBadges", "wKantoBadges",
        "wTMsHMs", "wNumItems", "wItems", "wNumKeyItems", "wKeyItems",
        "wNumBalls", "wBalls", "wNumPCItems", "wPCItems", "wEventFlags",
        "wCurBox",
        # current map
        "wVisitedSpawns", "wDigWarpNumber", "wDigMapGroup", "wDigMapNumber",
        "wBackupWarpNumber", "wBackupMapGroup", "wBackupMapNumber",
        "wLastSpawnMapGroup", "wLastSpawnMapNumber", "wWarpNumber",
        "wMapGroup", "wMapNumber", "wYCoord", "wXCoord", "wScreenSave",
        # the player's own object -- MapSetupScript_Continue does NOT respawn
        # the player, so moving the save to another map means rewriting these
        # by hand (see MapReader.build_window for the same story about blocks).
        # wMapObjects / wObjectStructs are saved whole, so a cross-map edit also
        # has to evict the old map's NPCs.
        "wMapObjects", "wObjectStructs", "wCurMapSceneScriptPointer",
        "wPlayerObjectYCoord", "wPlayerObjectXCoord",
        # party
        "wPartyCount", "wPartySpecies", "wPartyEnd", "wPartyMons",
        "wPartyMonOTs", "wPartyMonNicknames",
    ]
    # object_struct (macros/ram.asm) members the editor has to re-initialise
    # for the player and the Pikachu follower when it moves a save to another
    # map: the coordinates, and the motion state that would otherwise resume
    # the walk the fixture was saved in the middle of.
    for _pfx in ("wPlayer", "wFollower"):
        for _suf in ("Walking", "Direction", "StepType", "StepDuration",
                     "Action", "StepFrame", "Facing", "TileCollision",
                     "LastTile", "MapX", "MapY", "LastMapX", "LastMapY",
                     "InitX", "InitY", "SpriteX", "SpriteY", "SpriteXOffset",
                     "SpriteYOffset", "MovementIndex", "StepIndex",
                     "Field1d", "Field1e", "JumpHeight"):
            field_names.append(_pfx + _suf)
    # explicit lengths for the array fields: the symbol-gap heuristic below can
    # be fooled by an unrelated label landing inside a `ds` block.
    length_override = {
        "wTMsHMs": need("NUM_TMS") + need("NUM_HMS"),
        "wEventFlags": need("NUM_EVENTS") // 8,
        "wItems": need("MAX_ITEMS") * 2 + 1,
        "wKeyItems": need("MAX_KEY_ITEMS") + 1,
        "wBalls": need("MAX_BALLS") * 2 + 1,
        "wPCItems": need("MAX_PC_ITEMS") * 2 + 1,
        "wPlayerName": need("NAME_LENGTH"),
        "wRivalName": need("NAME_LENGTH"),
        "wMoney": 3,
        "wPartySpecies": need("PARTY_LENGTH"),
        "wPartyMons": 0,   # use party.stride * party.length
        "wPartyMonOTs": need("NAME_LENGTH") * need("PARTY_LENGTH"),
        "wPartyMonNicknames": need("MON_NAME_LENGTH") * need("PARTY_LENGTH"),
        "wVisitedSpawns": (need("NUM_SPAWNS") + 7) // 8,
        "wCurBox": 1,
        "wScreenSave": need("SCREEN_META_WIDTH") * need("SCREEN_META_HEIGHT"),
    }
    fields = {}
    for n in field_names:
        fields[n] = field(n)
        if n in length_override:
            fields[n][1] = length_override[n]
    fields["wPartyMons"][1] = (syms["wPartyMon2Species"][1]
                               - syms["wPartyMon1Species"][1]) * need("PARTY_LENGTH")

    # object arrays.  MAPOBJECT_LENGTH / OBJECT_LENGTH are `_RS` counters in
    # constants/map_object_constants.asm (not plain DEFs), so take them from the
    # symbol gaps instead: wPlayerObject is map object 0, wPlayerStruct is
    # object struct 0 and wFollowerStruct is struct FOLLOWER_OBJECT.
    map_obj_len = syms["wMap1Object"][1] - syms["wPlayerObject"][1]
    struct_len = syms["wObject1Struct"][1] - syms["wPlayerStruct"][1]
    follower_index = (syms["wFollowerStruct"][1] - syms["wObjectStructs"][1]) // struct_len
    num_objects = (syms["wObjectMasks"][1] - syms["wMapObjects"][1]) // map_obj_len
    # STANDING (constants/ram_constants.asm) is what a fresh spawn puts in
    # OBJECT_FACING / OBJECT_DIRECTION_WALKING.  Read it from its own Consts so
    # ram_constants' very generic names (DOWN, UP, LEFT, RIGHT) cannot shadow
    # anything in CONST_FILES.
    CR = Consts()
    CR.feed_file(p("constants", "ram_constants.asm"))
    if "STANDING" not in CR.vals:
        sys.exit("gen_tables: constant STANDING not resolved")
    objects = {
        "standing": CR.vals["STANDING"] & 0xFF,
        "mapObjectLength": map_obj_len,
        "numObjects": num_objects,
        "structLength": struct_len,
        "numStructs": follower_index + 1,
        "followerIndex": follower_index,
    }
    fields["wMapObjects"][1] = map_obj_len * num_objects
    fields["wObjectStructs"][1] = struct_len * (follower_index + 1)

    # party struct member offsets, relative to wPartyMon1
    base_mon = syms["wPartyMon1"][1]
    mon = {}
    for key, s in (("species", "wPartyMon1Species"), ("item", "wPartyMon1Item"),
                   ("moves", "wPartyMon1Moves"), ("id", "wPartyMon1ID"),
                   ("exp", "wPartyMon1Exp"), ("statExp", "wPartyMon1StatExp"),
                   ("dvs", "wPartyMon1DVs"), ("pp", "wPartyMon1PP"),
                   ("happiness", "wPartyMon1Happiness"),
                   ("pokerus", "wPartyMon1PokerusStatus"),
                   ("caughtData", "wPartyMon1CaughtData"),
                   ("level", "wPartyMon1Level"), ("status", "wPartyMon1Status"),
                   ("hp", "wPartyMon1HP"), ("maxHp", "wPartyMon1MaxHP"),
                   ("stats", "wPartyMon1Stats")):
        mon[key] = syms[s][1] - base_mon
    party = {
        "stride": syms["wPartyMon2Species"][1] - syms["wPartyMon1Species"][1],
        "length": need("PARTY_LENGTH"),
        "mon": mon,
        "otLength": need("NAME_LENGTH"),
        "nickLength": need("MON_NAME_LENGTH"),
        "numMoves": need("NUM_MOVES"),
    }

    # --- ROM tables --------------------------------------------------------
    base_stats_off = rom_offset(*syms["BaseData"])
    base_stats = {
        "rom": base_stats_off,
        "stride": need("BASE_DATA_SIZE"),
        "count": need("NUM_POKEMON"),
        "fields": {
            "dexNo": need("BASE_DEX_NO"),
            "hp": need("BASE_HP"), "atk": need("BASE_ATK"),
            "def": need("BASE_DEF"), "spd": need("BASE_SPD"),
            "sat": need("BASE_SAT"), "sdf": need("BASE_SDF"),
            "growthRate": need("BASE_GROWTH_RATE"),
        },
    }

    # The move table: the editor reads each move's PP straight out of the ROM
    # image it already holds, so "give this mon MOVE X" can fill the PP byte.
    move_stats = {
        "rom": rom_offset(*syms["Moves"]),
        "stride": need("MOVE_LENGTH"),
        "count": need("NUM_ATTACKS"),
        "fields": {
            "animation": need("MOVE_ANIM"), "effect": need("MOVE_EFFECT"),
            "power": need("MOVE_POWER"), "type": need("MOVE_TYPE"),
            "accuracy": need("MOVE_ACC"), "pp": need("MOVE_PP"),
            "effectChance": need("MOVE_CHANCE"),
        },
    }

    growth = []
    with open(p("data", "growth_rates.asm"), "r", encoding="utf-8") as f:
        for line in f:
            s = line.split(";")[0].strip()
            m = re.match(r"^growth_rate\s+(.*)$", s)
            if m:
                growth.append([int(x.strip()) for x in m.group(1).split(",")])

    # --- names -------------------------------------------------------------
    species_names = parse_name_list(p("data", "pokemon", "names.asm"), "dname")
    move_names = parse_name_list(p("data", "moves", "names.asm"), "li")
    item_names = parse_name_list(p("data", "items", "names.asm"), "li")
    # the name lists are padded past the real end of each enum; truncate
    if len(species_names) < need("NUM_POKEMON"):
        sys.exit("gen_tables: %d species names < NUM_POKEMON %d"
                 % (len(species_names), need("NUM_POKEMON")))
    species_names = species_names[:need("NUM_POKEMON")]
    if len(move_names) < need("NUM_ATTACKS"):
        sys.exit("gen_tables: %d move names < NUM_ATTACKS %d"
                 % (len(move_names), need("NUM_ATTACKS")))
    move_names = move_names[:need("NUM_ATTACKS")]

    # --- item pockets ------------------------------------------------------
    pockets = []
    with open(p("data", "items", "attributes.asm"), "r", encoding="utf-8") as f:
        inmacro = False
        for line in f:
            s = line.split(";")[0].strip()
            if s.startswith("MACRO"):
                inmacro = True
                continue
            if inmacro:
                if s == "ENDM":
                    inmacro = False
                continue
            m = re.match(r"^item_attribute\s+(.*)$", s)
            if m:
                a = [x.strip() for x in m.group(1).split(",")]
                pockets.append(a[4] if len(a) > 4 else "ITEM")
    if len(pockets) != len(item_names):
        sys.exit("gen_tables: %d item attributes != %d names"
                 % (len(pockets), len(item_names)))

    POCKET_KEY = {"ITEM": "item", "KEY_ITEM": "key", "BALL": "ball",
                  "TM_HM": "tm"}
    items = []
    for i, nm in enumerate(item_names):
        items.append({"id": i + 1, "name": pretty(nm),
                      "pocket": POCKET_KEY.get(pockets[i], "item")})

    # --- TMs / HMs ---------------------------------------------------------
    num_tms, num_hms = need("NUM_TMS"), need("NUM_HMS")
    tms = []
    for n in range(1, num_tms + 1):
        item_id = K["TM%02d_ITEM" % n]
        move_id = K["TM%02d_MOVE" % n]
        tms.append({"num": n, "item": item_id, "move": move_id,
                    "label": "TM%02d %s" % (n, pretty(move_names[move_id - 1]))})
    for n in range(1, num_hms + 1):
        item_id = K["HM%02d_ITEM" % n]
        move_id = K["HM%02d_MOVE" % n]
        tms.append({"num": num_tms + n, "item": item_id, "move": move_id,
                    "label": "HM%02d %s" % (n, pretty(move_names[move_id - 1]))})

    # --- maps + spawn points ----------------------------------------------
    maps = MapReader(rom, syms, K)
    spawns = []
    with open(p("data", "maps", "spawn_points.asm"), "r", encoding="utf-8") as f:
        inmacro = False
        idx = 0
        for line in f:
            s = line.split(";")[0].strip()
            if s.startswith("MACRO"):
                inmacro = True
                continue
            if inmacro:
                if s == "ENDM":
                    inmacro = False
                continue
            m = re.match(r"^spawn\s+(.*)$", s)
            if not m:
                continue
            a = [x.strip() for x in m.group(1).split(",")]
            const, xs, ys = a[0], a[1], a[2]
            if const == "N_A":
                continue
            g, mn = K.get("GROUP_" + const), K.get("MAP_" + const)
            if g is None or mn is None:
                sys.exit("gen_tables: spawn map %s has no GROUP_/MAP_ const" % const)
            region = "johto" if idx >= K.get("SPAWN_NEW_BARK", 1 << 30) \
                else "kanto"
            sx, sy = int(xs), int(ys)
            # SPAWN_PALLET_LANCE (M11 W5) repeats PALLET_TOWN 5, 6 only as a
            # distinct post-credits marker; list each tile once.
            if any(q["group"] == g and q["number"] == mn and q["x"] == sx
                   and q["y"] == sy for q in spawns):
                idx += 1
                continue
            spawns.append({"index": idx, "map": const, "group": g, "number": mn,
                           "x": sx, "y": sy, "region": region,
                           "label": title_case(const),
                           "screen": maps.build_window(g, mn, sx, sy),
                           "scene": maps.scene_pointer(g, mn)})
            idx += 1

    # --- event flags -------------------------------------------------------
    E = Consts()
    E.feed_file(p("constants", "event_flags.asm"))
    events = sorted(((v, k) for k, v in E.vals.items()
                     if k.startswith("EVENT_") and isinstance(v, int)),
                    key=lambda t: t[0])
    events = [[v, k] for v, k in events]

    # --- charmap -----------------------------------------------------------
    charmap = parse_charmap(p("constants", "charmap.asm"))

    sha = hashlib.sha256(rom).hexdigest()
    title = "".join(chr(c) for c in rom[0x134:0x144] if 0x20 <= c < 0x7F)
    title_key = (re.sub(r"[^A-Za-z0-9_.-]", "", title) or "UNKNOWN") \
        + "-" + format(rom[0x147], "x")

    build_rev = ""
    rev_file = p("build_rev.txt")
    if os.path.exists(rev_file):
        with open(rev_file, "r", encoding="utf-8") as f:
            build_rev = f.read().strip()

    out = {
        "generated": datetime.datetime.now(datetime.timezone.utc)
        .strftime("%Y-%m-%dT%H:%M:%SZ"),
        "buildRev": build_rev,
        "rom": {"sha256": sha, "size": len(rom), "title": title,
                "titleKey": title_key},
        "sav": {
            "size": 0x8000,
            "copies": [prim, back],
            "backupDelta": delta,
            "checkValue1": need("SAVE_CHECK_VALUE_1"),
            "checkValue2": need("SAVE_CHECK_VALUE_2"),
            "box": soff("sBox"),
            "boxLength": need("BOX_LENGTH"),
            "crystalData": soff("sCrystalData"),
            "crystalDataLength": (syms["wCrystalDataEnd"][1]
                                  - syms["wCrystalData"][1]),
            "optionsLength": syms["sCheckValue1"][1] - syms["sOptions"][1],
        },
        "fields": fields,
        "party": party,
        "objects": objects,
        "baseStats": base_stats,
        "moveStats": move_stats,
        "growthRates": growth,
        "limits": {
            "maxItems": need("MAX_ITEMS"), "maxBalls": need("MAX_BALLS"),
            "maxKeyItems": need("MAX_KEY_ITEMS"),
            "maxPCItems": need("MAX_PC_ITEMS"),
            "maxItemStack": need("MAX_ITEM_STACK"),
            "maxLevel": need("MAX_LEVEL"),
            "maxStatValue": need("MAX_STAT_VALUE"),
            "statMinNormal": need("STAT_MIN_NORMAL"),
            "statMinHP": need("STAT_MIN_HP"),
            "numSquareRoots": need("NUM_SQUARE_ROOTS"),
            "baseHappiness": need("BASE_HAPPINESS"),
            "numEvents": need("NUM_EVENTS"),
            "playerNameLength": need("PLAYER_NAME_LENGTH"),
            "nameLength": need("NAME_LENGTH"),
            "monNameLength": need("MON_NAME_LENGTH"),
            "numTMs": num_tms, "numHMs": num_hms,
            "numTMHMTutor": need("NUM_TM_HM_TUTOR"),
        },
        "species": [{"id": i + 1, "name": pretty(n)}
                    for i, n in enumerate(species_names)],
        "moves": [{"id": i + 1, "name": pretty(n)}
                  for i, n in enumerate(move_names)],
        "items": items,
        "tms": tms,
        "spawns": spawns,
        "events": events,
        "badges": parse_badges(p("constants", "engine_flags.asm")),
        "charmap": charmap,
    }

    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(out, f, separators=(",", ":"), ensure_ascii=False)
        f.write("\n")
    sys.stderr.write(
        "gen_tables: %s (rom sha %s, %d species, %d moves, %d items, %d TM/HM, "
        "%d spawns, %d events)\n"
        % (os.path.relpath(out_path, root), sha[:12], len(species_names),
           len(move_names), len(items), len(tms), len(spawns), len(events)))


if __name__ == "__main__":
    main()
