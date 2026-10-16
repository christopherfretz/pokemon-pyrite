// LK1b headless multi-core harness (docs/LK1-LINK.md section 8, layer 1).
//
// A library, not a test: cable.mjs and future link tests build on it.
//
//   const rig = await Rig.create();                 // one wasm module, the ROM, the .sym
//   const a = rig.add('A', readFileSync('web/test/fixtures/link_a.sav'));
//   a.drive(bootContinue(a));                       // per-core input driver (a generator)
//   rig.runUntil(() => a.idle, 3000);               // every core steps in lockstep
//   a.rd('wPlayerName', 11); a.text(); a.dump(dir, 'tag');
//
// Inputs.  Each core runs one *driver*: a generator that yields the buttons to
// hold for the next frame ({A:true}, {} for none) and may read any core's
// memory between yields, so scripts can wait on the screen or on WRAM.  The
// helpers below (tap, hold, wait, until, untilText, move, face, script) are
// generators to compose with yield*.  script(core, 'A*4 TAP:A*3 WAIT*60 ...')
// compiles play.py's grammar:
//   BTN*n        hold BTN for n frames (BTN = A B START SELECT UP DOWN LEFT RIGHT)
//   TAP:BTN*n    tap BTN n times (hold 4, gap 12)
//   WAIT*n       n frames with nothing held
//   MOVE:DIR*n   walk n tiles (holds DIR until wPlayerMapX/Y moved n)
//   FACE:DIR     turn without stepping
//   UNTIL:TEXT   wait (<= 1200 frames) until TEXT is on screen (_ = space)
//   AUNTIL:TEXT  tap A until TEXT is on screen
//   WRAM:sym[:n] record n bytes of sym into core.log
//   SHOT         record the framebuffer sha256 into core.log
//
// Stepping.  rig.frame() asks every driver for its buttons, then calls the
// rig's stepper, which must advance every core by exactly one frame of ticks
// (FRAME_TICKS) through core.runTo() (binjgb's joypad is one static shared by
// all cores in a wasm module, so buttons are applied per run, not up front).
// The default stepper runs cores one after the other with no link; cable.mjs
// swaps in a lockstep stepper that also carries the wire.
//
// Memory.  rd()/wr() take a .sym name or an address; banked WRAM ($D000-$DFFF)
// is read in the bank the .sym names (SVBK is switched and restored around the
// access, which is invisible to the game: it is not running at that moment).
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import path from 'node:path';
import { deflateSync } from 'node:zlib';
import {
  REPO_DIR, CORE_DIR, FRAME_TICKS, Machine, loadCore, coreFilesFromDir, sha256,
} from './core.mjs';

export { FRAME_TICKS, sha256, REPO_DIR };
export const RTC_DEFAULT = 3 * 86400 + 10 * 3600;   // day 3, 10:00:00, as identity.mjs
const SVBK = 0xff70;

export function loadSyms(file) {
  const syms = new Map();
  for (const line of readFileSync(file, 'utf8').split('\n')) {
    const m = /^([0-9a-f]{2}):([0-9a-f]{4}) (\S+)/i.exec(line);
    if (m && !syms.has(m[3])) syms.set(m[3], { bank: parseInt(m[1], 16), addr: parseInt(m[2], 16) });
  }
  return syms;
}

/* The LinkPort API of the LK1a core (docs/LK1-LINK.md 2.2), one per core. */
export class LinkPort {
  constructor(machine) { this.m = machine; this.mod = machine.mod; this.emu = machine.emu; }
  enable(on) { this.mod._emulator_link_enable(this.emu, on ? 1 : 0); }
  idle(v) { this.mod._emulator_link_set_idle_in(this.emu, v); }
  push(bytes) {
    const p = this.mod._malloc(bytes.length);
    this.mod.HEAPU8.set(bytes, p);
    const n = this.mod._emulator_link_push_in(this.emu, p, bytes.length);
    this.mod._free(p);
    return n;
  }
  pending() { return this.mod._emulator_link_in_pending(this.emu); }
  clear() { this.mod._emulator_link_clear_in(this.emu); }
  ext(mode, gap = 6144, idlePeriod = 6144) { this.mod._emulator_link_set_ext_clock(this.emu, mode, gap, idlePeriod); }
  /* Completed transfers since the last drain: {out, in, clock(1=internal), flags}. */
  drain(max = 256) {
    const p = this.mod._malloc(4 * max);
    const n = this.mod._emulator_link_drain_out(this.emu, p, max);
    const raw = Array.from(this.mod.HEAPU32.subarray(p >> 2, (p >> 2) + n));
    this.mod._free(p);
    return raw.map((e) => ({ out: e & 0xff, in: (e >>> 8) & 0xff, clock: (e >>> 16) & 1, flags: e >>> 24 }));
  }
  /* {sb, clock, transferring} as the core sees them now (0 while disabled). */
  peek() {
    const v = this.mod._emulator_link_peek(this.emu) >>> 0;
    return { sb: v & 0xff, clock: (v >> 8) & 1, transferring: (v >> 9) & 1 };
  }
  /* Clock one byte into an armed external-clock slave; returns the byte it
     shifted out, or -1 if it was not armed (the byte is lost, as on a cable). */
  clockExt(v) { return this.mod._emulator_link_clock_external(this.emu, v); }
}

// ------------------------------------------------------------------ text ---
export function charOf(b) {
  if (b >= 0x80 && b <= 0x99) return String.fromCharCode(65 + b - 0x80);
  if (b >= 0xa0 && b <= 0xb9) return String.fromCharCode(97 + b - 0xa0);
  if (b >= 0xf6) return String.fromCharCode(48 + b - 0xf6);
  return {
    0x7f: ' ', 0x75: '~', 0xe0: "'", 0xe1: 'P', 0xe2: 'M', 0xe3: '-', 0xe6: '?', 0xe7: '!',
    0xe8: '.', 0xea: 'e', 0xed: '>', 0xe4: "'", 0xe5: "'", 0xf4: ',', 0xf3: '/',
  }[b] ?? ' ';
}
/* Game text bytes up to the $50 terminator. */
export function decodeName(bytes) {
  let s = '';
  for (const b of bytes) { if (b === 0x50) break; s += charOf(b); }
  return s;
}
export function encodeName(s, n = 11) {
  const out = [];
  for (const c of s) {
    if (c >= 'A' && c <= 'Z') out.push(0x80 + c.charCodeAt(0) - 65);
    else if (c === ' ') out.push(0x7f);
    else throw new Error(`encodeName: ${c}`);
  }
  while (out.length < n) out.push(0x50);
  return out;
}

// ------------------------------------------------------------------- png ---
const CRC_TABLE = Array.from({ length: 256 }, (_, n) => {
  let c = n;
  for (let k = 0; k < 8; k++) c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
  return c >>> 0;
});
function crc32(buf) {
  let c = 0xffffffff;
  for (const b of buf) c = CRC_TABLE[(c ^ b) & 0xff] ^ (c >>> 8);
  return (c ^ 0xffffffff) >>> 0;
}
export function encodePng(rgba, w, h) {
  const chunk = (type, data) => {
    const len = Buffer.alloc(4); len.writeUInt32BE(data.length);
    const td = Buffer.concat([Buffer.from(type, 'ascii'), data]);
    const crc = Buffer.alloc(4); crc.writeUInt32BE(crc32(td));
    return Buffer.concat([len, td, crc]);
  };
  const ihdr = Buffer.alloc(13);
  ihdr.writeUInt32BE(w, 0); ihdr.writeUInt32BE(h, 4); ihdr[8] = 8; ihdr[9] = 6;
  const raw = Buffer.alloc((w * 4 + 1) * h);
  for (let y = 0; y < h; y++) {
    raw[y * (w * 4 + 1)] = 0;
    Buffer.from(rgba.buffer, rgba.byteOffset + y * w * 4, w * 4).copy(raw, y * (w * 4 + 1) + 1);
  }
  return Buffer.concat([Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]), chunk('IHDR', ihdr),
    chunk('IDAT', deflateSync(raw)), chunk('IEND', Buffer.alloc(0))]);
}

// ------------------------------------------------------------------ core ---
export class Core {
  constructor(rig, name, savBytes, { rtc = RTC_DEFAULT } = {}) {
    this.rig = rig;
    this.name = name;
    this.m = new Machine(rig.mod, rig.rom);
    if (savBytes && !this.m.putSram(savBytes)) throw new Error(`${name}: core refused the .sav`);
    this.m.setRtc(rtc);
    this.link = new LinkPort(this.m);
    this.driver = null;
    this.buttons = {};
    this.frames = 0;
    this.log = [];
  }
  get idle() { return this.driver === null; }
  get syms() { return this.rig.syms; }

  /* Install a driver (generator yielding per-frame button objects). */
  drive(gen) { this.driver = gen; return this; }
  nextButtons() {
    if (!this.driver) return {};
    const r = this.driver.next();
    if (r.done) { this.driver = null; return {}; }
    return r.value || {};
  }

  loc(name) {
    if (typeof name === 'number') return { bank: name >= 0xd000 && name < 0xe000 ? 1 : 0, addr: name };
    const s = this.syms.get(name);
    if (!s) throw new Error(`unknown symbol ${name}`);
    return s;
  }
  withBank(bank, addr, len, fn) {
    if (addr + len <= 0xd000 || addr >= 0xe000) return fn();
    const old = this.m.read(SVBK);
    const want = bank || 1;
    if ((old & 7 || 1) === want) return fn();
    this.m.write(SVBK, want);
    try { return fn(); } finally { this.m.write(SVBK, old); }
  }
  rd(name, n = 1, off = 0) {
    const { bank, addr } = this.loc(name);
    const a = addr + off;
    return this.withBank(bank, a, n, () => {
      const out = new Array(n);
      for (let i = 0; i < n; i++) out[i] = this.m.read(a + i);
      return out;
    });
  }
  rd1(name, off = 0) { return this.rd(name, 1, off)[0]; }
  rd16(name, off = 0) { const [h, l] = this.rd(name, 2, off); return (h << 8) | l; }
  wr(name, bytes, off = 0) {
    const { bank, addr } = this.loc(name);
    const a = addr + off;
    this.withBank(bank, a, bytes.length, () => bytes.forEach((v, i) => this.m.write(a + i, v)));
  }
  /* Offset of an SRAM symbol in the 32 KiB .sav image. */
  sramOffset(name) { const { bank, addr } = this.loc(name); return bank * 0x2000 + (addr - 0xa000); }

  /* The 20x18 BG tilemap (wTilemap) as text. */
  screen() {
    const t = this.rd('wTilemap', 360);
    const rows = [];
    for (let r = 0; r < 18; r++) rows.push(t.slice(r * 20, r * 20 + 20).map(charOf).join(''));
    return rows.join('\n');
  }
  text() { return this.screen().split(/\s+/).filter(Boolean).join(' '); }
  has(s) { return this.text().includes(s); }
  pos() {
    return [this.rd1('wMapGroup'), this.rd1('wMapNumber'), this.rd1('wPlayerMapX') - 4, this.rd1('wPlayerMapY') - 4];
  }
  /* Run this core to an absolute tick count with its own buttons held. */
  runTo(abs) { this.m.setButtons(this.buttons); return this.m.runUntil(abs); }
  sram() { return this.m.getSram(); }
  /* The current frame as a PNG file (160x144 RGBA), for eyeballing a failure. */
  png(file) { writeFileSync(file, encodePng(this.m.frameBuffer(), 160, 144)); return file; }
  fbHash() { return this.m.frameHash(); }

  /* Snapshot to JSON: framebuffer + SRAM hashes, ticks, and the given WRAM
     ranges as hex (array of [sym, length] or [sym, length, offset]). */
  snapshot(tag, ranges = []) {
    const wram = {};
    for (const [sym, len, off = 0] of ranges) {
      wram[off ? `${sym}+${off}` : sym] = Buffer.from(this.rd(sym, len, off)).toString('hex');
    }
    return {
      core: this.name, tag, frames: this.frames, ticks: this.m.ticks(), pos: this.pos(),
      fb_sha256: this.fbHash(), sram_sha256: sha256(this.sram()), wram,
    };
  }
  dump(dir, tag, ranges = []) {
    mkdirSync(dir, { recursive: true });
    const snap = this.snapshot(tag, ranges);
    const file = path.join(dir, `${this.name}-${tag}.json`);
    writeFileSync(file, JSON.stringify(snap, null, 1) + '\n');
    return file;
  }
}

// ------------------------------------------------------------------- rig ---
/* NB: binjgb's emscripten wrapper keeps the joypad in ONE static
   (wrapper.c s_buttons), shared by every emulator in the module, so a core's
   buttons must be set immediately before that core runs -- never for all
   cores up front.  Steppers go through Core.runTo(), which does that. */
export function defaultStepper(rig) { for (const c of rig.cores) c.runTo(c.m.ticks() + FRAME_TICKS); }

export class Rig {
  static async create({
    coreDir = CORE_DIR, rom = path.join(REPO_DIR, 'pokecrystal.gbc'),
    sym = path.join(REPO_DIR, 'pokecrystal.sym'),
  } = {}) {
    const mod = await loadCore(coreFilesFromDir(coreDir));
    return new Rig(mod, readFileSync(rom), loadSyms(sym));
  }
  constructor(mod, rom, syms) {
    this.mod = mod;
    this.rom = rom;
    this.syms = syms;
    this.cores = [];
    this.frames = 0;
    this.stepper = defaultStepper;
  }
  add(name, savBytes, opts) { const c = new Core(this, name, savBytes, opts); this.cores.push(c); return c; }
  core(name) { return this.cores.find((c) => c.name === name); }
  delete() { for (const c of this.cores) c.m.delete(); this.cores = []; }

  /* One lockstep frame: latch every driver's buttons, then step every core. */
  frame() {
    for (const c of this.cores) c.buttons = c.nextButtons();
    this.stepper(this);
    for (const c of this.cores) c.frames++;
    this.frames++;
  }
  run(n) { for (let i = 0; i < n; i++) this.frame(); }
  /* Step until pred() (checked before each frame) or throw after max frames. */
  runUntil(pred, max, what = 'condition') {
    for (let i = 0; i < max; i++) { if (pred()) return i; this.frame(); }
    if (pred()) return max;
    const screens = this.cores.map((c) => `--- ${c.name} pos ${c.pos()}\n${c.screen()}`).join('\n');
    throw new Error(`runUntil(${what}): not after ${max} frames\n${screens}`);
  }
  /* Run until every core's driver has finished. */
  settle(max, what = 'drivers') { return this.runUntil(() => this.cores.every((c) => c.idle), max, what); }
}

// --------------------------------------------------------------- drivers ---
export const BUTTONS = ['A', 'B', 'START', 'SELECT', 'UP', 'DOWN', 'LEFT', 'RIGHT'];
export function* wait(n) { for (let i = 0; i < n; i++) yield {}; }
export function* hold(btn, n) { for (let i = 0; i < n; i++) yield { [btn]: true }; yield {}; }
export function* tap(btn, n = 1, h = 4, gap = 12) {
  for (let i = 0; i < n; i++) { for (let j = 0; j < h; j++) yield { [btn]: true }; yield* wait(gap); }
}
/* Wait for pred(); `btn` (optional) is tapped every `every` frames meanwhile. */
export function* until(pred, max = 1200, what = 'predicate', btn = null, every = 24, core = null) {
  for (let i = 0; i < max; i++) {
    if (pred()) return i;
    yield (btn && i % every < 4) ? { [btn]: true } : {};
  }
  if (pred()) return max;
  throw new Error(`until(${what}) timed out after ${max} frames` + (core ? ` on ${core.name} pos ${core.pos()} frame ${core.frames}\n${core.screen()}` : ''));
}
export function untilText(core, s, max = 1200, btn = null, every = 24) {
  return until(() => core.has(s), max, `"${s}" on ${core.name}`, btn, every, core);
}
/* Tap `btn` until `s` is on screen: press-and-verify, as Crystal drops a
   press that lands while a box is still drawing (clone_glitch a_until). */
export function* aUntil(core, s, tries = 8, waitFrames = 120, btn = 'A') {
  for (let i = 0; i < tries; i++) {
    if (core.has(s)) return;
    yield* tap(btn, 1, 4, 8);
    for (let j = 0; j < waitFrames && !core.has(s); j++) yield {};
  }
  if (!core.has(s)) throw new Error(`${core.name}: never saw "${s}" (tapping ${btn})\n${core.screen()}`);
}
export function* menuTo(core, pos, sym = 'wMenuCursorY') {
  for (let i = 0; i < 30; i++) {
    const cur = core.rd1(sym);
    if (cur === pos) return;
    yield* tap(cur < pos ? 'DOWN' : 'UP', 1, 4, 10);
  }
  throw new Error(`${core.name}: menu cursor never reached ${pos}`);
}
export function* move(core, dir, tiles, timeoutPerTile = 120) {
  const axis = dir === 'LEFT' || dir === 'RIGHT' ? 'wPlayerMapX' : 'wPlayerMapY';
  yield* until(() => core.rd1('wPlayerWalking') === 0xff, 90, 'step finished');
  const start = core.rd1(axis);
  let moved = 0;
  for (let i = 0; i < tiles * timeoutPerTile && moved < tiles; i++) {
    yield { [dir]: true };
    moved = Math.abs(core.rd1(axis) - start);
  }
  for (let i = 0; i < 24; i++) { yield {}; if (core.rd1('wPlayerWalking') === 0xff) break; }
  yield* wait(2);
  if (moved < tiles) throw new Error(`${core.name}: MOVE:${dir}*${tiles} moved ${moved}`);
}
const FACING = { DOWN: 0, UP: 4, LEFT: 8, RIGHT: 12 };
export function* face(core, dir) {
  if ((core.rd1('wPlayerDirection') & 12) === FACING[dir]) { yield* wait(2); return; }
  for (let i = 0; i < 16; i++) { yield { [dir]: true }; if ((core.rd1('wPlayerDirection') & 12) === FACING[dir]) break; }
  yield* wait(10);
}
export function* script(core, src) {
  for (const tok of src.split(/\s+/).filter(Boolean)) {
    let m;
    if (tok === 'SHOT') { core.log.push({ frame: core.frames, shot: core.fbHash() }); continue; }
    if ((m = /^WRAM:(\w+)(?::(\d+))?$/.exec(tok))) {
      core.log.push({ frame: core.frames, sym: m[1], bytes: core.rd(m[1], parseInt(m[2] || '1', 10)) });
      continue;
    }
    if ((m = /^(A?)UNTIL:(.+)$/.exec(tok))) {
      yield* untilText(core, m[2].replace(/_/g, ' '), 1200, m[1] ? 'A' : null);
      continue;
    }
    if ((m = /^MOVE:([A-Z]+)\*(\d+)$/.exec(tok))) { yield* move(core, m[1], parseInt(m[2], 10)); continue; }
    if ((m = /^FACE:([A-Z]+)$/.exec(tok))) { yield* face(core, m[1]); continue; }
    if ((m = /^(TAP:)?([A-Z]+)\*(\d+)$/.exec(tok))) {
      const n = parseInt(m[3], 10);
      if (m[2] === 'WAIT') yield* wait(n);
      else if (!BUTTONS.includes(m[2])) throw new Error(`bad button ${m[2]}`);
      else if (m[1]) yield* tap(m[2], n);
      else yield* hold(m[2], n);
      continue;
    }
    throw new Error(`bad token ${tok}`);
  }
}

/* Title screen -> CONTINUE -> overworld, driven by what is on screen. */
export function* bootContinue(core) {
  yield* wait(60);
  yield* until(() => core.has('CONTINUE') && core.has('NEW GAME'), 2400, 'main menu', 'START', 32, core);
  yield* wait(20);
  yield* menuTo(core, 1);
  yield* tap('A');
  yield* untilText(core, 'TIME', 600);
  yield* until(() => !core.has('TIME'), 600, 'save summary closed', 'A', 30, core);
  yield* wait(240);
  if (core.rd1('wMapGroup') === 0) throw new Error(`${core.name}: CONTINUE did not reach the overworld`);
}
