// LK1b zero-latency cable (docs/LK1-LINK.md section 8, layer 2) -- the oracle.
//
// Two cores in one process, joined by a perfect wire.  Both run with the
// LK1a LinkPort enabled and ext_mode 0 (an external-clock slave never
// completes on its own); the cable is the only thing that clocks a slave.
// Every slice of S ticks (default 512; must divide the 3584-tick latch):
//   1. A.idle_in := B's SB if B is armed as an external-clock slave, else
//      B's bit-7 fill ($00/$FF); run A to T+S; peek() so a transfer due at
//      the slice edge is logged now (binjgb syncs serial lazily); for every
//      transfer A completed on its INTERNAL clock, clock that byte into B
//      (clockExt) -- B gets A's byte and its serial IRQ at the same moment;
//   2. the same with the roles swapped (B runs to T+S, clocks A).
// Latch rule: a byte completing now latched its in-byte 3584 ticks earlier;
// the peer is clocked only if it was armed then AND is still armed now.
// Every exchanged byte pair goes in the wire log.  A master in-byte that
// differs from what the slave shifted out is a cable-fidelity error (must be
// 0); a byte clocked at an unarmed slave is "dropped" once roles are settled
// (during the role race it is normal and counted apart).  The only drop
// allowed is the slave's own $00 from ExitLinkCommunications, which lands on
// nobody on hardware too (checkDrops).
//
// Scenarios (fixtures/link_a.sav = ALPHA = master, link_b.sav = BRAVO):
//   trade   both TRADE CENTER, two trades (MEW<->MAGIKARP, RATTATA+mail<->
//           CELEBI), cancel, walk out, SAVE, reload both saves
//   battle  both COLOSSEUM, ALPHA's MEWTWO beats BRAVO, RECORD screen,
//           walk out; result, RNs, party restore, SRAM link records
//   pacing  replay the trade's first bulk exchange into a slave snapshot with
//           ext_mode 1 at a range of ext_gap values; find the failure edge
//   gender-keep          (LK1f) explicit genders planted in CaughtLevel bits
//           7-6 cross a pyrite<->pyrite trade intact; stats screen shows them;
//           hostile bits on genderless MEW are kept but shown genderless
//   gender-mask-vanilla  (LK1f) the same with A's feature byte zeroed in
//           flight (A looks like vanilla Gen 2): B masks, A still keeps
//   bounds  (LK1f) B names trade slots 4 (== party count), 5, 6, 14 past its
//           4-mon party; A
//           refuses each via "abnormal"/"trade was canceled", parties intact
//   (the LK1f scenarios assert only; they write no oracle)
//
// Usage: node web/test/cable.mjs [--scenario trade|battle|pacing|gender-keep|
//        gender-mask-vanilla|bounds|all]
//        [--fixtures web/test/fixtures] [--oracle web/test/oracle] [--slice 512]
//        [--no-write]   (compare against the oracle snapshots, do not rewrite;
//                        rom_sha256 is shown as INFO, not compared)
// Exit status 0 = every scenario run passed.
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import path from 'node:path';
import { pathToFileURL } from 'node:url';
import {
  Rig, defaultStepper, FRAME_TICKS, REPO_DIR, sha256, bootContinue, decodeName,
  wait, tap, until, untilText, aUntil, move, face, menuTo, script,
} from './harness.mjs';
import { parseArgs } from './core.mjs';

// ------------------------------------------------------------------ cable ---
export const LATCH_TICKS = 3584;                  // a byte's in-bit latch (512) to its IRQ (4096)
const RING = 64;
export class Cable {
  constructor(rig, a, b, { slice = 512 } = {}) {
    if (LATCH_TICKS % slice) throw new Error(`slice must divide ${LATCH_TICKS}`);
    this.rig = rig;
    this.ends = [a, b];
    this.slice = slice;
    this.lag = LATCH_TICKS / slice;               // slices between a byte's latch and its completion
    this.k = 0;                                   // slice index; cable time = k * slice
    this.frameEnd = 0;
    this.base = new Map([[a, a.m.ticks()], [b, b.m.ticks()]]);
    this.armedAt = [new Uint8Array(RING), new Uint8Array(RING)];
    this.wire = [];                               // [t, masterIdx, masterOut, slaveOut]
    this.dropped = 0;                             // bytes lost after both sides had a role
    this.dropLog = [];                            // wire index of each dropped byte
    this.racing = 0;                              // bytes lost during the role race (expected)
    this.mismatch = 0;
    this.tap = null;                              // optional (entry) => void
    for (const c of this.ends) { c.link.enable(true); c.link.ext(0, 6144, 6144); c.link.drain(); }
    rig.stepper = () => this.stepFrame();
  }
  get t() { return this.k * this.slice; }
  /* Both games have settled who clocks (hSerialConnectionStatus 1 / 2). */
  linked() {
    const [a, b] = this.ends.map((c) => c.rd1('hSerialConnectionStatus'));
    return (a === 1 && b === 2) || (a === 2 && b === 1);
  }
  disconnect() {
    for (const c of this.ends) c.link.enable(false);
    this.rig.stepper = defaultStepper;
  }
  static armed(p) { return p.transferring && !p.clock; }
  half(i) {
    const me = this.ends[i], other = this.ends[1 - i];
    const end = this.t + this.slice;
    // What a master latches (at its first bit edge, 512 ticks into the byte,
    // which falls inside this slice if the byte started in the previous one):
    // the peer's SB if the peer is armed as an external-clock slave;
    // otherwise its SO line just holds SB's bit 7 (no clock reaches its shift
    // register), so $00 or $FF.  That is what lets WaitForLinkedFriend's role
    // race settle: an unarmed peer never reads as a $01/$02 role byte
    // (serial.asm .establish_connection).
    const p = other.link.peek();
    const armed = Cable.armed(p);
    this.armedAt[i][this.k % RING] = armed ? 1 : 0;
    me.link.idle(armed ? p.sb : (p.sb & 0x80 ? 0xff : 0x00));
    me.runTo(this.base.get(me) + end);
    // binjgb runs the serial unit lazily: a transfer due exactly at the end of
    // the run is only logged at the next serial_synchronize, which peek() does.
    // Sync now so it lands in this slice -- and never throw a log away: an
    // earlier version drained (and discarded) the peer's log here, which ate a
    // master byte every time the master's peek() in the other half produced
    // the completion (one byte in ~18 vanished from the master's stream).
    me.link.peek();
    this.consume(i, end);
    this.consume(1 - i, end);
  }
  consume(i, end) {
    const other = this.ends[1 - i];
    for (const e of this.ends[i].link.drain()) {
      if (!e.clock) continue;                     // a slave's completion (we clocked it)
      // A byte completing in this slice latched its in-byte `lag` slices ago.
      // Clock the peer only if it was armed then AND is still armed: a peer
      // that armed part-way through sees only the tail of the byte and, on
      // hardware, would not complete either.
      const wasArmed = this.k >= this.lag && this.armedAt[i][(this.k - this.lag) % RING];
      const r = wasArmed && Cable.armed(other.link.peek()) ? other.link.clockExt(e.out) : -1;
      if (r < 0) { if (this.linked()) { this.dropped++; this.dropLog.push(this.wire.length); } else this.racing++; }
      else if (r !== e.in) this.mismatch++;
      const entry = [end, i, e.out, r < 0 ? e.in : r];
      this.wire.push(entry);
      if (this.tap) this.tap(entry);
    }
  }
  stepFrame() {
    this.frameEnd += FRAME_TICKS;
    while (this.t < this.frameEnd) {
      this.half(0);
      this.half(1);
      this.k++;
    }
  }
}

// -------------------------------------------------------------- recording ---
export const IE_SERIAL = 0x08;
/* Annotate every wire entry with what the master was doing:
   [t, masterIdx, masterOut, slaveOut, IE, linked, frame] */
export function record(cable) {
  cable.tap = (e) => {
    const m = cable.ends[e[1]];
    e.push(m.m.read(0xffff), cable.linked() ? 1 : 0, cable.rig.frames);
  };
}

/* The receiver side of Serial_ExchangeBytes / ExchangeBytes over a byte
   stream: skip until a $FD (or exactly one byte for ExchangeBytes), then take
   `len` bytes.  Returns [block, nextIndex]. */
export function recvBlock(stream, i, len, preamble = true) {
  if (preamble) { while (i < stream.length && stream[i] !== 0xfd) i++; i++; } else i++;
  return [stream.slice(i, i + len), i + len];
}
export const hex = (a) => Buffer.from(a).toString('hex');

/* Split the wire into the stages of LK1-LINK.md section 1.3.  Bulk bursts
   (master IE == IE_SERIAL) are cut into rows 10-14 by replaying each side's
   receiver; everything else is classified by its byte. */
export function segment(wire, { trade }) {
  const rows = [];        // [row, n, firstFrame, lastFrame, note]
  const blocks = [];      // per bulk burst: { burst, A->B / B->A blocks }
  const push = (row, f, note = '') => {
    const last = rows[rows.length - 1];
    if (last && last[0] === row && last[4] === note) { last[1]++; last[3] = f; } else rows.push([row, 1, f, f, note]);
  };
  const nyb = (b) => {
    if (b === 0x61) return '4';
    if ((b & 0xf0) === 0xd0) return '5';
    if (b === 0x75 || b === 0x85) return '8';
    if (b === 0x76 || b === 0x86) return '9';
    if ((b & 0xf0) === 0x70) return '16T';
    if ((b & 0xf0) === 0x80) return '16B';
    return null;
  };
  let i = 0, burst = 0;
  while (i < wire.length) {
    const e = wire[i];
    if (e[4] === IE_SERIAL) {
      let j = i;
      while (j < wire.length && wire[j][4] === IE_SERIAL) j++;
      const seg = wire.slice(i, j);
      const M = seg.map((x) => x[2]), S = seg.map((x) => x[3]);
      const lens = [['11 RN', 17, true], ['12 party', 450, true], ['13 patch', 200, true]];
      if (trade) lens.push(['14 mail', 390, false]);
      const b = { burst: burst++, frame: e[6], bytes: seg.length, toSlave: {}, toMaster: {} };
      let im = 0, is = 0;
      for (const [name, len, pre] of lens) {
        let blk;
        [blk, is] = recvBlock(M, is, len, pre); b.toSlave[name] = hex(blk);
        [blk, im] = recvBlock(S, im, len, pre); b.toMaster[name] = hex(blk);
      }
      b.slaveUsed = is; b.masterUsed = im;
      blocks.push(b);
      push('10-14', e[6], `bulk ${seg.length} B`);
      rows[rows.length - 1][3] = seg[seg.length - 1][6];
      i = j;
      continue;
    }
    if (!e[5]) push(blocks.length ? '18' : '2', e[6]);   // after the session: the exit bytes
    else {
      const r = nyb(e[2]) || nyb(e[3]);
      if (r) push(r, e[6]);
      else push('idle', e[6], `${e[2].toString(16)}/${e[3].toString(16)}`);
    }
    i++;
  }
  return { rows, blocks };
}
/* Run-length list of the non-bulk byte pairs: [masterOut, slaveOut, count]. */
export function nybbles(wire) {
  const out = [];
  for (const e of wire) {
    if (e[4] === IE_SERIAL) continue;
    const last = out[out.length - 1];
    if (last && last[0] === e[2] && last[1] === e[3]) last[2]++; else out.push([e[2], e[3], 1]);
  }
  return out;
}

// ---------------------------------------------------------------- drivers ---
export const TILE_ARROW = 0xed;                          // '▶'
/* Receptionist -> link -> save -> warp into the room -> seat -> console. */
export function* enterRoom(c, delay, room) {
  yield* wait(delay);
  if (room === 'battle') yield* script(c, 'MOVE:DOWN*1 MOVE:RIGHT*4 MOVE:UP*1 FACE:UP');
  yield* until(() => c.rd1('wPlayerWalking') === 0xff, 60, 'standing');
  yield* aUntil(c, '>YES');
  yield* tap('A');
  yield* untilText(c, 'link, you must', 1500);
  yield* aUntil(c, '>YES');
  yield* tap('A');
  yield* untilText(c, 'save file', 600);
  yield* aUntil(c, '>YES');
  yield* tap('A');
  yield* untilText(c, 'come in', 2000);
  yield* wait(30);
  yield* until(() => c.pos()[1] !== 1, 900, 'warp', 'A', 40, c);
  yield* wait(60);
  c.role = c.rd1('hSerialConnectionStatus') === 2 ? 'master' : 'slave';
  yield* script(c, c.role === 'master'
    ? 'MOVE:UP*2 MOVE:LEFT*1 MOVE:UP*1 FACE:RIGHT'
    : 'MOVE:UP*2 MOVE:RIGHT*2 MOVE:UP*1 FACE:LEFT');
  yield* tap('A');
}
/* Trade screen: pick party slot `slot` (1-based), TRADE, confirm. */
export function* tradeOne(c, slot, otName) {
  yield* untilText(c, 'CANCEL', 4000);
  yield* wait(30);
  yield* menuTo(c, slot);
  yield* tap('A');
  yield* untilText(c, 'STATS', 300);
  yield* wait(10);
  yield* tap('RIGHT');
  yield* wait(10);
  yield* tap('A');
  yield* untilText(c, `for ${otName}?`, 3000);
  yield* wait(30);
  yield* tap('A');
  yield* untilText(c, 'Trade completed!', 8000);
}
export function* cancelOut(c) {
  yield* untilText(c, 'CANCEL', 4000);
  yield* wait(30);
  for (let i = 0; i < 16 && c.rd1('wTilemap', 17 * 20 + 9) !== TILE_ARROW; i++) yield* tap('DOWN', 1, 4, 10);
  if (c.rd1('wTilemap', 17 * 20 + 9) !== TILE_ARROW) throw new Error(`${c.name}: never reached CANCEL\n${c.screen()}`);
  yield* tap('A');
}
/* Back on POKeCENTER 2F after the room's exit script. */
/* After ExitLinkCommunications the console script reloads the room
   (newloadmap MAPSETUP_LINKRETURN): the player is back on the seat and walks
   out; POKeCENTER 2F's LEAVE_*_CENTER scene then closes the link. */
export function* leaveRoom(c) {
  yield* wait(240);
  yield* until(() => c.rd1('wPlayerWalking') === 0xff, 600, 'room reloaded', null, 24, c);
  yield* script(c, c.role === 'master' ? 'MOVE:DOWN*1 MOVE:RIGHT*1 MOVE:DOWN*2' : 'MOVE:DOWN*1 MOVE:LEFT*2 MOVE:DOWN*2');
  yield* until(() => c.pos()[1] === 1, 300, 'warp to 2F', 'DOWN', 24, c);
}
export function* backOn2F(c) {
  if (c.pos()[1] !== 1) yield* leaveRoom(c);
  yield* until(() => c.pos()[1] === 1 && c.rd1('wLinkMode') === 0, 3000, 'back on 2F', null, 24, c);
  yield* wait(120);
  yield* until(() => c.rd1('wPlayerWalking') === 0xff && c.rd1('hSerialConnectionStatus') === 0xff, 600, 'exit script done', null, 24, c);
  yield* wait(60);
}
export const STARTMENU_SAVE = 4;
export function* saveGame(c) {
  yield* until(() => c.has('SAVE'), 600, 'start menu', 'START', 60, c);
  yield* wait(10);
  const items = c.rd('wMenuItemsList', 12);
  yield* menuTo(c, items.slice(1, 1 + items[0]).indexOf(STARTMENU_SAVE) + 1);
  yield* tap('A');
  yield* untilText(c, 'save the game?', 300);
  yield* wait(20);
  yield* tap('A');
  yield* until(() => c.has('overwrite?') || c.has('saved the game'), 600, 'save prompt', 'A', 30, c);
  if (c.has('overwrite?')) { yield* aUntil(c, '>YES'); yield* wait(20); yield* tap('A'); }
  yield* untilText(c, 'saved the game', 1200);
  yield* tap('B', 4, 4, 16);
  yield* wait(30);
}

// -------------------------------------------------------------- scenarios ---
export const SP = { PIDGEY: 0x10, RATTATA: 0x13, SPEAROW: 0x15, PIKACHU: 0x19, MAGIKARP: 0x81,
  MEWTWO: 0x96, MEW: 0x97, CELEBI: 0xfb, EGG: 0xfd };
export const STRUCT = 48, NAME = 11, MAIL = 0x2f;
export const MON_ITEM = 1, MON_ID = 6, MON_STAT_EXP = 11, MON_CAUGHT_LEVEL = 0x1d;
export const FLOWER_MAIL = 0x9e;

export function party(c) {
  const n = c.rd1('wPartyCount');
  const out = [];
  for (let i = 0; i < n; i++) {
    out.push({
      species: c.rd1('wPartySpecies', i),
      mon: c.rd('wPartyMon1', STRUCT, i * STRUCT),
      ot: c.rd('wPartyMonOTs', NAME, i * NAME),
      nick: c.rd('wPartyMonNicknames', NAME, i * NAME),
    });
  }
  return out;
}
/* The same party, read from the battery image's sPokemonData. */
export function sramParty(c, img) {
  const base = c.sramOffset('sPokemonData');
  const w0 = c.loc('wPokemonData').addr;
  const at = (sym, n, off = 0) => Array.from(img.slice(base + c.loc(sym).addr - w0 + off, base + c.loc(sym).addr - w0 + off + n));
  const n = at('wPartyCount', 1)[0];
  const out = [];
  for (let i = 0; i < n; i++) {
    out.push({
      species: at('wPartySpecies', 1, i)[0], mon: at('wPartyMon1', STRUCT, i * STRUCT),
      ot: at('wPartyMonOTs', NAME, i * NAME), nick: at('wPartyMonNicknames', NAME, i * NAME),
    });
  }
  return { out, dexCaught: at('wPokedexCaught', 32), dexSeen: at('wPokedexSeen', 32) };
}
export const dexBit = (bytes, sp) => (bytes[(sp - 1) >> 3] >> ((sp - 1) & 7)) & 1;
export const sameMon = (x, y) => {
  // GF3/LK1f: an incoming mon's CaughtLevel bits 7-6 are cleared on arrival
  // unless the peer is pyrite (link.asm LinkTrade); compare the rest.
  // (0x1d = MON_CAUGHTLEVEL; this was 0x1c, MON_POKERUS, before LK1f.)
  const a = x.slice(), b = y.slice();
  a[MON_CAUGHT_LEVEL] &= 0x3f; b[MON_CAUGHT_LEVEL] &= 0x3f;
  return hex(a) === hex(b);
};

export class Checks {
  constructor(label) { this.label = label; this.list = []; }
  ok(name, cond, detail = '') { this.list.push({ name, pass: !!cond, detail: String(detail) }); }
  get pass() { return this.list.every((c) => c.pass); }
  print() {
    for (const c of this.list) console.log(`  ${c.pass ? 'PASS' : 'FAIL'} ${c.name}${c.detail ? ' -- ' + c.detail : ''}`);
    console.log(`${this.label}: ${this.pass ? 'PASS' : 'FAIL'} (${this.list.filter((c) => c.pass).length}/${this.list.length})`);
  }
}

export async function setup(opts) {
  const rig = await Rig.create();
  const a = rig.add('A', readFileSync(path.join(opts.fixtures, 'link_a.sav')));
  const b = rig.add('B', readFileSync(path.join(opts.fixtures, 'link_b.sav')));
  a.drive(bootContinue(a)); b.drive(bootContinue(b));
  rig.settle(4000);
  const cable = new Cable(rig, a, b, { slice: opts.slice });
  record(cable);
  DEBUG.last = { rig, a, b, cable };
  return { rig, a, b, cable };
}
/* Drive both cores to completion; B starts `skew` frames late. */
export function runBoth(rig, a, b, ga, gb, max, what) {
  a.drive(ga); b.drive(gb);
  rig.settle(max, what);
}
/* A dropped byte is one an internal-clock side shifted out with the peer not
   armed.  The only legitimate one: ExitLinkCommunications (link.asm) starts an
   internal transfer of $00 on BOTH machines; the master's lands on the
   still-armed slave, the slave's lands on nobody (table 1.3 row 18).  Any
   other drop is a cable bug. */
export function checkDrops(ck, cable, slave, after) {
  const drops = cable.dropLog.map((i) => cable.wire[i]);
  const rows = segment(cable.wire, { trade: after === 'cancel' }).rows;
  const lastNyb = Math.max(...rows.filter((r) => r[0] === '16T' || r[0] === '16B').map((r) => r[3]));
  const si = cable.ends.indexOf(slave);
  const exitOnly = drops.length <= 1 && drops.every((e) => e[1] === si && e[2] === 0 && e[6] > lastNyb);
  ck.ok('cable: no dropped bytes but the slave\'s exit $00 (row 18)', exitOnly,
    `${drops.length} dropped: ${drops.map((e) => JSON.stringify(e)).join(' ')}`);
}
export const decode = (bytes) => decodeName(bytes);
const DEBUG = { last: null };

export async function tradeScenario(opts) {
  const t0 = Date.now();
  const ck = new Checks('trade');
  const { rig, a, b, cable } = await setup(opts);
  const pre = { A: party(a), B: party(b) };
  const mailOff = (c, slot) => c.sramOffset('sPartyMail') + slot * MAIL;
  const preMailA = Array.from(a.sram().slice(mailOff(a, 3), mailOff(a, 3) + MAIL));   // RATTATA is slot 4
  const snaps = {};
  // Into the TRADE CENTER and two trades: A's MEW (3) <-> B's MAGIKARP (1),
  // then A's RATTATA w/ mail (3 after the shift) <-> B's CELEBI (1).
  function* side(c, picks, ot) {
    yield* enterRoom(c, c === b ? 37 : 0, 'trade');
    yield* untilText(c, 'CANCEL', 4000);
    snaps[c.name] = { otCount: c.rd1('wOTPartyCount'), otSpecies: c.rd('wOTPartySpecies', 6),
      otName: decode(c.rd('wOTPlayerName', NAME)), rns: c.rd('wLinkBattleRNs', 10) };
    for (let i = 0; i < picks.length; i++) yield* tradeOne(c, picks[i], ot[i]);
    yield* cancelOut(c);
    yield* backOn2F(c);
    yield* saveGame(c);
  }
  runBoth(rig, a, b, side(a, [3, 3], ['MAGIKARP', 'CELEBI']), side(b, [1, 1], ['MEW', 'RATTATA']), 40000, 'trade scenario');
  const post = { A: party(a), B: party(b) };
  const img = { A: a.sram(), B: b.sram() };
  const sp = { A: sramParty(a, img.A), B: sramParty(b, img.B) };

  checkDrops(ck, cable, b, 'cancel');
  ck.ok('cable: no master/slave byte mismatch', cable.mismatch === 0, cable.mismatch);
  ck.ok('roles: A master, B slave', a.role === 'master' && b.role === 'slave', `${a.role}/${b.role}`);
  ck.ok('A saw BRAVO\'s party before trading', snaps.A.otName === 'BRAVO' && snaps.A.otCount === 4
    && hex(snaps.A.otSpecies.slice(0, 5)) === hex([SP.MAGIKARP, SP.CELEBI, SP.EGG, SP.PIKACHU, 0xff]),
  `${snaps.A.otName} ${snaps.A.otCount} ${hex(snaps.A.otSpecies)}`);
  ck.ok('B saw ALPHA\'s party before trading', snaps.B.otName === 'ALPHA' && snaps.B.otCount === 6
    && hex(snaps.B.otSpecies) === hex([SP.MEWTWO, SP.PIKACHU, SP.MEW, SP.RATTATA, SP.PIDGEY, SP.SPEAROW]),
  `${snaps.B.otName} ${snaps.B.otCount} ${hex(snaps.B.otSpecies)}`);
  ck.ok('slave adopted the master\'s battle RNs', hex(snaps.A.rns) === hex(snaps.B.rns), `${hex(snaps.A.rns)} / ${hex(snaps.B.rns)}`);

  const wantA = [SP.MEWTWO, SP.PIKACHU, SP.PIDGEY, SP.SPEAROW, SP.MAGIKARP, SP.CELEBI];
  const wantB = [SP.EGG, SP.PIKACHU, SP.MEW, SP.RATTATA];
  for (const [who, want, p] of [['A', wantA, post.A], ['B', wantB, post.B]]) {
    ck.ok(`${who} WRAM party species`, hex(p.map((m) => m.species)) === hex(want), hex(p.map((m) => m.species)));
    ck.ok(`${who} SRAM party = WRAM party`, JSON.stringify(sp[who].out) === JSON.stringify(p));
  }
  // what moved, byte for byte (struct, OT name, nickname)
  const moved = [
    ['MAGIKARP B->A', pre.B[0], post.A[4], 'BRAVO'], ['CELEBI B->A', pre.B[1], post.A[5], 'BRAVO'],
    ['MEW A->B', pre.A[2], post.B[2], 'ALPHA'], ['RATTATA A->B', pre.A[3], post.B[3], 'ALPHA'],
  ];
  for (const [what, from, to, otName] of moved) {
    ck.ok(`${what}: struct identical`, to && sameMon(from.mon, to.mon));
    ck.ok(`${what}: OT ${otName}, nickname kept`, to && decode(to.ot) === otName && hex(to.nick) === hex(from.nick),
      to && `${decode(to.ot)} "${decode(to.nick)}"`);
  }
  // $FE through the patch lists
  ck.ok('$FE: BRAVO ID $FE42 arrived in A\'s MAGIKARP and CELEBI',
    post.A[4] && post.A[4].mon[MON_ID] === 0xfe && post.A[4].mon[MON_ID + 1] === 0x42 && post.A[5].mon[MON_ID] === 0xfe);
  ck.ok('$FE: MEW\'s HP stat exp $FE00 arrived at B',
    post.B[2] && post.B[2].mon[MON_STAT_EXP] === 0xfe && post.B[2].mon[MON_STAT_EXP + 1] === 0x00);
  const seg = segment(cable.wire, { trade: true });
  const first = seg.blocks[0];
  const noFe = (h) => !Buffer.from(h, 'hex').includes(0xfe);
  ck.ok('$FE: no raw $FE on the wire in either party block', first && noFe(first.toMaster['12 party']) && noFe(first.toSlave['12 party']));
  ck.ok('$FE: both patch lists non-empty', first && !first.toMaster['13 patch'].startsWith('fdfdfdff')
    && !first.toSlave['13 patch'].startsWith('fdfdfdff'), first && `${first.toMaster['13 patch'].slice(0, 24)} / ${first.toSlave['13 patch'].slice(0, 24)}`);
  // mail
  ck.ok('mail: RATTATA still holds FLOWER_MAIL at B', post.B[3] && post.B[3].mon[MON_ITEM] === FLOWER_MAIL);
  const mailB = Array.from(img.B.slice(mailOff(b, 3), mailOff(b, 3) + MAIL));
  ck.ok('mail: letter in B\'s sPartyMail slot 4 equals A\'s', hex(mailB) === hex(preMailA), decode(mailB.slice(0, 16)));
  // POKeDEX
  for (const [who, c, list] of [['A', a, [SP.MAGIKARP, SP.CELEBI]], ['B', b, [SP.MEW, SP.RATTATA]]]) {
    const w = c.rd('wPokedexCaught', 32);
    for (const s of list) {
      ck.ok(`${who} POKeDEX caught ${s.toString(16)} (WRAM, SRAM)`, dexBit(w, s) && dexBit(sp[who].dexCaught, s) && dexBit(sp[who].dexSeen, s));
    }
  }
  // same end stage
  for (const c of [a, b]) {
    ck.ok(`${c.name} back on 2F, link closed`, c.pos()[0] === 20 && c.pos()[1] === 1 && c.rd1('wLinkMode') === 0
      && c.rd1('hSerialConnectionStatus') === 0xff, `${c.pos()} mode ${c.rd1('wLinkMode')}`);
  }
  ck.ok('three bulk exchanges (enter + after each trade)', seg.blocks.length === 3, seg.blocks.length);
  const wall = Date.now() - t0;
  // the saves load
  cable.disconnect();
  for (const [who, image] of Object.entries(img)) {
    const c2 = rig.add(`${who}2`, image);
    c2.drive(bootContinue(c2));
    let ok = true;
    try { rig.settle(4000, 'reload'); } catch (e) { ok = false; }
    ck.ok(`${who} save reloads via CONTINUE with the traded party`, ok && hex(party(c2).map((m) => m.species)) === hex(who === 'A' ? wantA : wantB));
  }
  return { ck, rig, a, b, cable, seg, wall, frames: rig.frames, img, extra: { snaps } };
}

// ------------------------------------------------------- LK1f: gender + bounds ---
// The pyrite feature byte (link.asm Link_PrepPartyData_Gen2, first padding
// byte of the party block) and the conditional GF3 mask in LinkTrade; the
// slot bound in ValidateOTTrademon (time_capsule.asm).
export const LINK_PYRITE_FEATURES = 0x8f;               // constants/serial_constants.asm
export const MON_DVS = 0x15, GENDER_EXPLICIT = 0x80, GENDER_FEMALE = 0x40;
export const TILE_MALE = 0xef, TILE_FEMALE = 0xf5, TILE_BLANK = 0x7f;
export const PARTY_PADDING_AT = 441;                    // name 11 + party 8 + structs 288 + OTs 66 + nicks 66 + mail-less
/* GetGender's DV rule for a GENDER_F50 species: (atk hi | spd hi) > 127 is male. */
export const dvMale = (mon) => ((mon[MON_DVS] & 0xf0) | (mon[MON_DVS + 1] >> 4)) > 127;
/* The gender tile .PlaceGenderChar puts at hlcoord 18,0 of stats page 1. */
const genderTile = (g) => (g === 'M' ? TILE_MALE : g === 'F' ? TILE_FEMALE : TILE_BLANK);
const tileName = (t) => ({ [TILE_MALE]: 'male', [TILE_FEMALE]: 'female', [TILE_BLANK]: 'blank' }[t] || `$${t.toString(16)}`);
/* Run `fn` once per frame (before the frame is stepped) for as long as `gen` drives. */
export function* everyFrame(gen, fn) {
  let r = gen.next();
  while (!r.done) { fn(); yield r.value; r = gen.next(); }
  return r.value;
}
/* Trade menu: open STATS on party slot `slot` (1-based), read the gender tile, back out. */
export function* statsGender(c, slot, out) {
  yield* untilText(c, 'CANCEL', 4000);
  yield* wait(30);
  yield* menuTo(c, slot);
  yield* tap('A');
  yield* untilText(c, 'STATS', 300);
  yield* wait(10);
  yield* tap('A');                                       // STATS (cursor starts there)
  yield* until(() => c.rd1('wTilemap', 8) === 0x74 && c.rd1('wCurPartyMon') === slot - 1, 600, 'stats page 1', null, 24, c);
  yield* wait(40);
  out.push({ slot, species: c.rd1('wPartySpecies', slot - 1), tile: c.rd1('wTilemap', 18), screen: c.screen() });
  yield* until(() => c.has('CANCEL'), 2000, 'stats screen closed', 'B', 60, c);
}
/* The party block's first padding byte as it crossed the wire (leading $FD stripped). */
const wirePadding = (h) => {
  const buf = Buffer.from(h, 'hex');
  let i = 0;
  while (i < buf.length && buf[i] === 0xfd) i++;
  return buf[i + PARTY_PADDING_AT];
};

/* gender-keep (vanillaA false) / gender-mask-vanilla (vanillaA true).
   Planted before the room: B's MAGIKARP and A's RATTATA get an explicit gender
   opposite to their DV gender; A's MEW (genderless) gets hostile bits %10.
   Trades: A's MEW <-> B's MAGIKARP, A's RATTATA <-> B's CELEBI.
   vanillaA zeroes A's feature byte every frame, so B sees A as a vanilla
   Gen 2 peer (B must mask) while A still sees B as pyrite (A must keep). */
export async function genderScenario(opts, { vanillaA = false } = {}) {
  const name = vanillaA ? 'gender-mask-vanilla' : 'gender-keep';
  const ck = new Checks(name);
  const { rig, a, b, cable } = await setup(opts);
  const plant = (c, idx, bits) => {
    const mon = c.rd('wPartyMon1', STRUCT, idx * STRUCT);
    const v = (mon[MON_CAUGHT_LEVEL] & 0x3f) | bits;
    c.wr('wPartyMon1', [v], idx * STRUCT + MON_CAUGHT_LEVEL);
    return v;
  };
  const opposite = (c, idx) => (dvMale(c.rd('wPartyMon1', STRUCT, idx * STRUCT)) ? GENDER_EXPLICIT | GENDER_FEMALE : GENDER_EXPLICIT);
  const bitsOf = { karp: opposite(b, 0), rat: opposite(a, 3), mew: GENDER_EXPLICIT };
  plant(b, 0, bitsOf.karp); plant(a, 3, bitsOf.rat); plant(a, 2, bitsOf.mew);
  const pre = { A: party(a), B: party(b) };
  const latch = { A: [], B: [] }, stats = { A: [], B: [] }, looked = {};
  function* side(c, picks, ot, look) {
    yield* enterRoom(c, c === b ? 37 : 0, 'trade');
    for (let i = 0; i < picks.length; i++) {
      yield* untilText(c, 'CANCEL', 4000);
      latch[c.name].push(c.rd1('wLinkPeerFeatures'));
      yield* tradeOne(c, picks[i], ot[i]);
    }
    yield* untilText(c, 'CANCEL', 4000);
    latch[c.name].push(c.rd1('wLinkPeerFeatures'));
    for (const s of look) yield* statsGender(c, s, stats[c.name]);
    // leave together: backOn2F expects the CANCEL exchange to finish promptly
    looked[c.name] = true;
    yield* until(() => looked.A && looked.B, 4000, 'both read the stats screens', null, 24, c);
    yield* cancelOut(c);
    yield* backOn2F(c);
  }
  const ga = side(a, [3, 3], ['MAGIKARP', 'CELEBI'], [5]);
  runBoth(rig, a, b, vanillaA ? everyFrame(ga, () => a.wr('wLinkSendPartyPadding', [0])) : ga,
    side(b, [1, 1], ['MEW', 'RATTATA'], [3, 4]), 40000, name);
  const post = { A: party(a), B: party(b) };
  const seg = segment(cable.wire, { trade: true });
  const keepAtB = !vanillaA;

  checkDrops(ck, cable, b, 'cancel');
  ck.ok('cable: no master/slave byte mismatch', cable.mismatch === 0, cable.mismatch);
  ck.ok('three bulk exchanges', seg.blocks.length === 3, seg.blocks.length);
  // the feature byte on the wire: toMaster = B's block, toSlave = A's block
  const wireB = seg.blocks.map((k) => wirePadding(k.toMaster['12 party']));
  const wireA = seg.blocks.map((k) => wirePadding(k.toSlave['12 party']));
  ck.ok('wire: B\'s party block carries $8F in padding byte 0 (every exchange)', wireB.every((v) => v === LINK_PYRITE_FEATURES), hex(wireB));
  ck.ok(`wire: A's party block carries ${vanillaA ? '$00 (zeroed in flight)' : '$8F'} in padding byte 0`,
    wireA.every((v) => v === (vanillaA ? 0 : LINK_PYRITE_FEATURES)), hex(wireA));
  ck.ok('latch: A\'s wLinkPeerFeatures = $8F after every exchange', latch.A.every((v) => v === LINK_PYRITE_FEATURES), hex(latch.A));
  ck.ok(`latch: B's wLinkPeerFeatures = ${vanillaA ? '$00' : '$8F'} after every exchange`,
    latch.B.every((v) => v === (vanillaA ? 0 : LINK_PYRITE_FEATURES)), hex(latch.B));
  // CaughtLevel bits 7-6 on arrival
  const karp = post.A[4], mew = post.B[2], rat = post.B[3];
  const bits = (m) => m && (m.mon[MON_CAUGHT_LEVEL] & 0xc0);
  ck.ok('species landed: A slot 5 MAGIKARP, B slots 3-4 MEW RATTATA',
    karp && karp.species === SP.MAGIKARP && mew && mew.species === SP.MEW && rat && rat.species === SP.RATTATA,
    hex(post.A.map((m) => m.species)) + ' / ' + hex(post.B.map((m) => m.species)));
  ck.ok(`MAGIKARP B->A: explicit bits kept (%${(bitsOf.karp >> 6).toString(2)})`, bits(karp) === bitsOf.karp, karp && hex([karp.mon[MON_CAUGHT_LEVEL]]));
  ck.ok(`RATTATA A->B: explicit bits ${keepAtB ? `kept (%${(bitsOf.rat >> 6).toString(2)})` : 'masked'}`,
    bits(rat) === (keepAtB ? bitsOf.rat : 0), rat && hex([rat.mon[MON_CAUGHT_LEVEL]]));
  ck.ok(`MEW A->B (hostile %10 on a genderless species): bits ${keepAtB ? 'kept' : 'masked'}`,
    bits(mew) === (keepAtB ? bitsOf.mew : 0), mew && hex([mew.mon[MON_CAUGHT_LEVEL]]));
  for (const [what, from, to] of [['MAGIKARP B->A', pre.B[0], karp], ['MEW A->B', pre.A[2], mew], ['RATTATA A->B', pre.A[3], rat]]) {
    ck.ok(`${what}: rest of the struct identical`, to && sameMon(from.mon, to.mon));
  }
  // what the receiver's stats screen shows (GetGender)
  const expect = [
    ['A', 5, 'MAGIKARP', genderTile(bitsOf.karp & GENDER_FEMALE ? 'F' : 'M'), 'explicit'],
    ['B', 3, 'MEW', TILE_BLANK, 'genderless despite the bits'],
    ['B', 4, 'RATTATA', keepAtB ? genderTile(bitsOf.rat & GENDER_FEMALE ? 'F' : 'M') : genderTile(dvMale(pre.A[3].mon) ? 'M' : 'F'),
      keepAtB ? 'explicit' : 'DV gender'],
  ];
  for (const [who, slot, sp, tile, why] of expect) {
    const s = stats[who].find((x) => x.slot === slot);
    ck.ok(`${who} stats screen, ${sp}: ${tileName(tile)} (${why})`, s && s.tile === tile, s ? `tile ${tileName(s.tile)}` : 'not read');
  }
  ck.ok('explicit genders oppose the DV gender (the check can tell them apart)',
    dvMale(pre.B[0].mon) === !!(bitsOf.karp & GENDER_FEMALE) && dvMale(pre.A[3].mon) === !!(bitsOf.rat & GENDER_FEMALE));
  for (const c of [a, b]) {
    ck.ok(`${c.name} back on 2F, link closed`, c.pos()[1] === 1 && c.rd1('wLinkMode') === 0 && c.rd1('hSerialConnectionStatus') === 0xff);
  }
  return { ck, rig, a, b, cable, seg, frames: rig.frames, oracle: false,
    extra: { latch, wireA, wireB, bitsOf, stats: Object.fromEntries(Object.entries(stats).map(([k, v]) => [k, v.map((x) => [x.slot, tileName(x.tile)])])) } };
}

/* bounds: B (slave) is made hostile by holding its wPlayerLinkAction at a slot
   at or past the end of its 4-mon party (slot 4 is the exact boundary,
   slot == wOTPartyCount) while the trade nybbles are exchanged.  A must refuse
   through "<mon> appears to be abnormal!" / "trade was canceled", with no
   crash, both parties untouched and both back at the trade menu. */
export const HOSTILE_SLOTS = [4, 5, 6, 14];
export async function boundsScenario(opts) {
  const ck = new Checks('bounds');
  const { rig, a, b, cable } = await setup(opts);
  const pre = { A: party(a), B: party(b) };
  const hostile = { slot: null };
  const seen = [];
  function* sideA() {
    yield* enterRoom(a, 0, 'trade');
    for (const slot of HOSTILE_SLOTS) {
      yield* untilText(a, 'CANCEL', 4000);
      yield* wait(30);
      yield* menuTo(a, 3);
      yield* tap('A');
      yield* untilText(a, 'STATS', 300);
      yield* wait(10);
      yield* tap('RIGHT');
      yield* wait(10);
      yield* until(() => b.has('WAITING'), 3000, 'B waiting first', null, 24, a);
      yield* wait(20);
      yield* tap('A');
      yield* until(() => a.has('abnormal') || a.has('for BRAVO') || a.has('for '), 3000, 'A verdict', null, 24, a);
      const otSp = a.rd('wOTPartySpecies', 15);
      const at = a.rd1('wCurOTTradePartyMon');
      seen.push({ slot, at, abnormal: a.has('abnormal'), otCount: a.rd1('wOTPartyCount'),
        listSpecies: at < 15 ? otSp[at] : null, structSpecies: a.rd1('wOTPartyMon1Species', at * STRUCT) });
      yield* until(() => a.has('canceled'), 1200, 'A canceled', 'A', 40, a);
      seen[seen.length - 1].canceled = true;
    }
    yield* cancelOut(a);
    yield* backOn2F(a);
  }
  function* sideB() {
    yield* enterRoom(b, 37, 'trade');
    for (const slot of HOSTILE_SLOTS) {
      yield* untilText(b, 'CANCEL', 4000);
      yield* wait(30);
      yield* menuTo(b, 1);
      yield* tap('A');
      yield* untilText(b, 'STATS', 300);
      yield* wait(10);
      yield* tap('RIGHT');
      yield* wait(10);
      yield* tap('A');
      hostile.slot = slot;
      yield* untilText(b, 'for MEW?', 3000);
      hostile.slot = null;
      yield* wait(30);
      yield* tap('A');
      yield* untilText(b, 'canceled', 1200);
    }
    yield* cancelOut(b);
    yield* backOn2F(b);
  }
  runBoth(rig, a, b, sideA(), everyFrame(sideB(), () => { if (hostile.slot !== null) b.wr('wPlayerLinkAction', [hostile.slot]); }), 40000, 'bounds');
  const post = { A: party(a), B: party(b) };
  ck.ok('cable: no master/slave byte mismatch', cable.mismatch === 0, cable.mismatch);
  for (const s of HOSTILE_SLOTS) {
    const r = seen.find((x) => x.slot === s);
    ck.ok(`slot ${s} (B has ${pre.B.length}): A took the hostile nybble and refused it ("abnormal", "trade was canceled")`,
      r && r.at === s && r.abnormal && r.canceled,
      r && `at ${r.at} otCount ${r.otCount} list $${(r.listSpecies ?? 0).toString(16)} struct $${r.structSpecies.toString(16)}`);
  }
  ck.ok('A party untouched', JSON.stringify(post.A) === JSON.stringify(pre.A));
  ck.ok('B party untouched', JSON.stringify(post.B) === JSON.stringify(pre.B));
  for (const c of [a, b]) {
    ck.ok(`${c.name} back on 2F, link closed (no crash)`, c.pos()[1] === 1 && c.rd1('wLinkMode') === 0 && c.rd1('hSerialConnectionStatus') === 0xff,
      `${c.pos()} mode ${c.rd1('wLinkMode')}`);
  }
  return { ck, rig, a, b, cable, seg: segment(cable.wire, { trade: true }), frames: rig.frames, oracle: false, extra: { seen } };
}

// ------------------------------------------------------------------- main ---
const ORACLE_RANGES = [['wPartyCount', 8], ['wOTPartyCount', 8], ['wOTPlayerName', NAME], ['wLinkBattleRNs', 10]];
function oracleOf(name, r, opts) {
  const end = {};
  for (const c of [r.a, r.b]) {
    const s = c.snapshot(`${name}-end`, ORACLE_RANGES);
    s.wram_pokemon_data_sha256 = sha256(Uint8Array.from(c.rd('wPokemonData', c.loc('wPokemonDataEnd').addr - c.loc('wPokemonData').addr)));
    delete s.ticks;
    end[c.name] = s;
  }
  return {
    scenario: name, slice: opts.slice,
    fixtures: Object.fromEntries(['link_a', 'link_b'].map((f) => [f, sha256(readFileSync(path.join(opts.fixtures, `${f}.sav`)))])),
    rom_sha256: sha256(r.rig.rom),
    frames: r.frames, wire_bytes: r.cable.wire.length,
    stages: r.seg.rows, blocks: r.seg.blocks, nybbles: nybbles(r.cable.wire), end,
    extra: r.extra,
  };
}
/* Deterministic parts only (frames/ticks/stage frame numbers are included:
   with fixed fixtures, RTC and inputs they must not move either).
   rom_sha256 is recorded but NOT compared: BUILD_REV (the pyrite short hash)
   is baked into the ROM, so an oracle recorded before a commit can never match
   the committed build's sha (REVIEW-LK1F INFO-5).  The stored and current
   values are returned as an INFO line so a drift stays visible. */
function compareOracle(file, now) {
  let old;
  try { old = JSON.parse(readFileSync(file, 'utf8')); } catch { return { diff: 'no oracle on disk', info: null }; }
  const cur = JSON.parse(JSON.stringify(now));
  const info = `INFO rom_sha256 stored ${old.rom_sha256 ?? '-'} current ${cur.rom_sha256 ?? '-'}` +
    (old.rom_sha256 === cur.rom_sha256 ? ' (same)' : ' (differs; not compared)');
  delete old.rom_sha256;
  delete cur.rom_sha256;
  return { diff: JSON.stringify(old) === JSON.stringify(cur) ? null : 'differs from the oracle on disk', info };
}

async function main() {
  const opts = parseArgs(process.argv.slice(2), {
    scenario: 'all', fixtures: path.join(REPO_DIR, 'web/test/fixtures'),
    oracle: path.join(REPO_DIR, 'web/test/oracle'), slice: '512',
  });
  opts.slice = parseInt(opts.slice, 10);
  const want = opts.scenario === 'all' ? ['trade', 'battle', 'pacing', 'gender-keep', 'gender-mask-vanilla', 'bounds'] : [opts.scenario];
  const runners = { trade: tradeScenario, battle: battleScenario, pacing: pacingScenario,
    'gender-keep': (o) => genderScenario(o), 'gender-mask-vanilla': (o) => genderScenario(o, { vanillaA: true }),
    bounds: boundsScenario };
  let ok = true;
  for (const name of want) {
    let r;
    const t0 = Date.now();
    try { r = await runners[name](opts); } catch (e) {
      console.log(`${name}: FAIL (exception)\n${e.stack || e}`);
      const L = DEBUG.last;
      if (L) {
        for (const c of [L.a, L.b]) console.log(`${c.name}: pos ${c.pos()} frame ${c.frames} linkMode ${c.rd1('wLinkMode')} status ${c.rd1('hSerialConnectionStatus').toString(16)} walking ${c.rd1('wPlayerWalking').toString(16)}\n${c.screen()}`);
        console.log(`cable: wire ${L.cable.wire.length} dropped ${L.cable.dropped} mismatch ${L.cable.mismatch} racing ${L.cable.racing}`);
        try { for (const row of segment(L.cable.wire, { trade: name === 'trade' }).rows) console.log(`  stage ${row[0].padEnd(5)} x${String(row[1]).padStart(4)}  frames ${row[2]}-${row[3]} ${row[4]}`); } catch (e2) { console.log('segment failed', e2.message); }
      }
      ok = false;
      continue;
    }
    if (r.write) r.write(opts);
    r.ck.print();
    console.log(`${name}: ${r.frames} frames, ${r.cable ? r.cable.wire.length : 0} wire bytes, ${((Date.now() - t0) / 1000).toFixed(1)} s wall`);
    if (r.seg) for (const row of r.seg.rows) console.log(`  stage ${row[0].padEnd(5)} x${String(row[1]).padStart(4)}  frames ${row[2]}-${row[3]} ${row[4]}`);
    if (r.oracle !== false && r.seg) {
      const o = oracleOf(name, r, opts);
      const file = path.join(opts.oracle, `${name}.json`);
      const { diff, info } = compareOracle(file, o);
      if (opts['no-write']) {
        console.log(`  oracle ${file}: ${diff || 'identical'}`);
        if (diff) ok = false;
      } else {
        mkdirSync(opts.oracle, { recursive: true });
        writeFileSync(file, JSON.stringify(o) + '\n');
        console.log(`  oracle ${file}: written (${diff || 'unchanged'})`);
      }
      if (info) console.log(`  ${info}`);
    }
    ok = ok && r.ck.pass;
    r.rig.delete();
  }
  process.exit(ok ? 0 : 1);
}
// ---------------------------------------------------------------- battle ---
export const MON_HP = 0x22;
/* First party slot (1-based) that can fight: HP > 0 and not an EGG. */
export function firstFit(c) {
  const n = c.rd1('wPartyCount'), sp = c.rd('wPartySpecies', n), mons = c.rd('wPartyMon1', n * STRUCT);
  for (let i = 0; i < n; i++) {
    if (sp[i] !== SP.EGG && (mons[i * STRUCT + MON_HP] | mons[i * STRUCT + MON_HP + 1])) return i + 1;
  }
  return 0;
}
/* One side of a link battle, as a little state machine polled every frame:
   battle menu -> FIGHT, move menu -> first move, forced switch ("Which PKMN?")
   -> first mon that can fight.  Link battle text needs no button (wLinkMode
   makes prompts time out), so nothing else is pressed. */
export function* fightBattle(c, rec) {
  yield* until(() => c.rd1('wBattleMode') !== 0, 6000, 'battle start', null, 24, c);
  rec.rnsAtStart = hex(c.rd('wLinkBattleRNs', 10));
  rec.startFrame = c.frames;
  rec.menus = 0; rec.moves = 0; rec.switches = [];
  for (let i = 0; c.rd1('wBattleMode') !== 0; i++) {
    if (i > 40000) throw new Error(`${c.name}: battle did not end\n${c.screen()}`);
    if (!rec.end && /was defeated|Lost against|Tied against/.test(c.text())) {
      rec.end = c.text(); rec.endFrame = c.frames;
      rec.result = c.rd1('wBattleResult') & 0x3f;
      rec.rnCount = c.rd1('wLinkBattleRNCount');
      rec.rns = hex(c.rd('wLinkBattleRNs', 10));
    }
    if (c.has('RECORD') && c.has('TOTAL')) {   // DisplayLinkRecord, waits for A/B
      if (!rec.recordScreen) { yield* wait(30); rec.recordScreen = c.text(); }
      yield* tap('B');
      yield* wait(30);
      continue;
    }
    if (c.has('TYPE/')) { rec.moves++; yield* tap('A'); yield* wait(30); continue; }
    if (c.has('FIGHT') && c.has('PACK') && c.has('RUN')) { rec.menus++; yield* tap('A'); yield* wait(30); continue; }
    if (c.has('Which') && !c.has('FIGHT')) {
      const slot = firstFit(c);
      yield* wait(20);
      yield* menuTo(c, slot);
      yield* tap('A');
      rec.switches.push(slot);
      yield* until(() => !c.has('Which'), 1200, 'switch accepted', null, 24, c);
      continue;
    }
    yield {};
  }
}
export const LBR_LEN = 2 + 10 + 6;
export function linkStats(c, img) {
  const o = c.sramOffset('sLinkBattleStats'), be = (k) => (img[o + k] << 8) | img[o + k + 1];
  const recs = [];
  for (let r = 0; r < 5; r++) {
    const b = o + 6 + r * LBR_LEN;
    if (!img[b + 2]) continue;
    const g = (k) => (img[b + k] << 8) | img[b + k + 1];
    recs.push({ id: g(0), name: decodeName(Array.from(img.slice(b + 2, b + 12))), wins: g(12), losses: g(14), draws: g(16) });
  }
  return { wins: be(0), losses: be(2), draws: be(4), records: recs };
}
async function battleScenario(opts) {
  const ck = new Checks('battle');
  const { rig, a, b, cable } = await setup(opts);
  const t0 = Date.now();
  const before = { A: linkStats(a, a.sram()), B: linkStats(b, b.sram()) };
  const pre = { A: party(a), B: party(b) };
  const rec = { A: {}, B: {} };
  function* side(c, r) {
    yield* enterRoom(c, c === b ? 37 : 0, 'battle');
    yield* fightBattle(c, r);
    yield* backOn2F(c);
  }
  runBoth(rig, a, b, side(a, rec.A), side(b, rec.B), 40000, 'battle scenario');
  const wall = Date.now() - t0;
  const after = { A: linkStats(a, a.sram()), B: linkStats(b, b.sram()) };
  const seg = segment(cable.wire, { trade: false });

  checkDrops(ck, cable, b, 'battle');
  ck.ok('cable: no master/slave byte mismatch', cable.mismatch === 0, cable.mismatch);
  ck.ok('roles: A master, B slave', a.role === 'master' && b.role === 'slave', `${a.role}/${b.role}`);
  ck.ok('one bulk exchange (no mail block in the COLOSSEUM)', seg.blocks.length === 1, seg.blocks.length);
  ck.ok('slave adopted the master\'s battle RNs (at battle start)', rec.A.rnsAtStart === rec.B.rnsAtStart, `${rec.A.rnsAtStart} / ${rec.B.rnsAtStart}`);
  ck.ok('RNs on the wire = RNs in both games', seg.blocks[0] && seg.blocks[0].toSlave['11 RN'].slice(-20) === rec.A.rnsAtStart,
    seg.blocks[0] && seg.blocks[0].toSlave['11 RN']);
  ck.ok('both consumed the same number of RNs', rec.A.rnCount === rec.B.rnCount, `${rec.A.rnCount} / ${rec.B.rnCount}`);
  ck.ok('A won (wBattleResult 0, "was defeated")', rec.A.result === 0 && /was defeated/.test(rec.A.end || ''), `${rec.A.result} "${rec.A.end}"`);
  ck.ok('B lost (wBattleResult 1, "Lost against")', rec.B.result === 1 && /Lost against/.test(rec.B.end || ''), `${rec.B.result} "${rec.B.end}"`);
  ck.ok('B was forced to switch twice: CELEBI (2) then PIKACHU (4, past the EGG)', JSON.stringify(rec.B.switches) === '[2,4]', JSON.stringify(rec.B.switches));
  ck.ok('A fought three turns of PSYCHIC', rec.A.moves === 3, rec.A.moves);
  ck.ok('RECORD screens agree (A 1-0-0 vs BRAVO, B 0-1-0 vs ALPHA)',
    /ALPHA RECORD TOTAL WIN LOSE DRAW 1 0 0 RESULT WIN LOSE DRAW BRAVO 1 0 0/.test(rec.A.recordScreen || '')
    && /BRAVO RECORD TOTAL WIN LOSE DRAW 0 1 0 RESULT WIN LOSE DRAW ALPHA 0 1 0/.test(rec.B.recordScreen || ''));
  // link battles change nothing: LoadPokemonData puts back the party saved at the receptionist
  for (const [who, c] of [['A', a], ['B', b]]) {
    ck.ok(`${who} party unchanged after the battle (HP restored)`, JSON.stringify(party(c)) === JSON.stringify(pre[who]));
  }
  ck.ok('link record: A +1 win vs BRAVO, B +1 loss vs ALPHA (SRAM)',
    after.A.wins === before.A.wins + 1 && after.B.losses === before.B.losses + 1
    && after.A.records.some((x) => x.name === 'BRAVO' && x.id === 0xfe42 && x.wins === 1)
    && after.B.records.some((x) => x.name === 'ALPHA' && x.id === 11111 && x.losses === 1),
    JSON.stringify({ A: after.A, B: after.B }));
  for (const c of [a, b]) {
    ck.ok(`${c.name} back on 2F, link closed`, c.pos()[0] === 20 && c.pos()[1] === 1 && c.rd1('wLinkMode') === 0
      && c.rd1('hSerialConnectionStatus') === 0xff, `${c.pos()} mode ${c.rd1('wLinkMode')}`);
  }
  return { ck, rig, a, b, cable, seg, wall, frames: rig.frames, extra: { rec, linkStats: after } };
}
// ---------------------------------------------------------------- pacing ---
/* How fast may the web player's virtual master (ext_mode 1) clock received
   bytes into a slave?  Record a real cable session up to the TRADE CENTER
   menu, keeping the slave's machine state for the last frames before the bulk
   exchange.  Then, for each ext_gap G, restore that state into a lone core,
   push the master's recorded bytes into its FIFO, let binjgb clock them in at
   G-tick spacing, and run to the trade menu.  A gap is good if the slave ends
   with the same OT/party/mail/RN data as on the cable AND shifted out the same
   bytes the cable master received. */
const PACE_RANGES = [['wOTPlayerName', 'wOTPartyDataEnd'], ['wLinkOTMail', 'wLinkOTMailEnd'],
  ['wLinkReceivedMail', 'wLinkReceivedMailEnd'], ['wLinkBattleRNs', 10]];
function paceRef(c) {
  return PACE_RANGES.map(([from, to]) => {
    const n = typeof to === 'number' ? to : c.loc(to).addr - c.loc(from).addr;
    return sha256(Uint8Array.from(c.rd(from, n)));
  }).join(',');
}
function paceTrial(T, snap, feed, gap, maxFrames) {
  T.m.putState(snap.state);
  T.link.enable(true); T.link.clear(); T.link.drain(); T.link.idle(0xff);
  T.link.ext(1, gap, gap);
  if (T.link.push(Uint8Array.from(feed)) !== feed.length) throw new Error('FIFO too small');
  const outs = [];
  let f = 0;
  for (; f < maxFrames; f++) {
    T.buttons = {};
    T.runTo(T.m.ticks() + FRAME_TICKS);
    for (const e of T.link.drain(512)) if (!e.clock) outs.push(e.out);
    if (T.link.pending() === 0 && T.has('CANCEL')) break;
  }
  return { outs, frames: f, menu: T.has('CANCEL'), left: T.link.pending(), ref: paceRef(T) };
}
async function pacingScenario(opts) {
  const ck = new Checks('pacing');
  const { rig, a, b, cable } = await setup(opts);
  const t0 = Date.now();
  const ring = [];
  let burst = -1, seen = 0;
  const inner = rig.stepper;
  rig.stepper = (r) => {
    if (burst < 0 && cable.linked()) {
      ring.push({ frame: rig.frames, wireLen: cable.wire.length, state: b.m.getState() });
      if (ring.length > 6) ring.shift();
    }
    inner(r);
    for (; burst < 0 && seen < cable.wire.length; seen++) if (cable.wire[seen][4] === IE_SERIAL) burst = seen;
  };
  function* side(c) { yield* enterRoom(c, c === b ? 37 : 0, 'trade'); yield* untilText(c, 'CANCEL', 4000); yield* wait(30); }
  runBoth(rig, a, b, side(a), side(b), 20000, 'pacing: to the trade menu');
  rig.stepper = inner;
  if (burst < 0) throw new Error('no bulk exchange seen');
  const w = cable.wire, mi = cable.ends.indexOf(a);
  let end = burst;
  while (end + 1 < w.length && w[end + 1][4] === IE_SERIAL) end++;
  const burstFrame = w[burst][6];
  const snap = ring.filter((x) => x.frame <= burstFrame - 2).pop();
  if (!snap) throw new Error('no slave snapshot before the bulk exchange');
  const span = w.slice(snap.wireLen, end + 1).filter((e) => e[1] === mi);
  const feed = span.map((e) => e[2]), want = span.map((e) => e[3]);
  const ref = paceRef(b);
  const maxFrames = b.frames - snap.frame + 600;
  const T = rig.add('T', null);
  const results = [];
  const test = (gap) => {
    const r = paceTrial(T, snap, feed, gap, maxFrames);
    const outOk = r.outs.length === want.length && r.outs.every((v, i) => v === want[i]);
    const firstBad = r.outs.findIndex((v, i) => v !== want[i]);
    const ok = r.menu && r.left === 0 && r.ref === ref && outOk;
    const row = { gap, ok, menu: r.menu, fifo_left: r.left, slave_data_ok: r.ref === ref, slave_out_ok: outOk,
      first_bad_out: firstBad, frames: r.frames };
    results.push(row);
    return ok;
  };
  const grid = [12288, 8192, 6144, 4096, 3584, 3072, 2560, 2048, 1792, 1536, 1280, 1024, 768, 512];
  for (const g of grid) test(g);
  // refine the edge: largest failing gap below the smallest passing one with no failure above it
  let good = null;
  for (const g of grid) { if (results.find((x) => x.gap === g).ok) good = g; else break; }
  const firstFail = grid.find((g) => !results.find((x) => x.gap === g).ok);
  let lo = firstFail ?? null, hi = good;
  if (lo !== null && hi !== null) {
    while (hi - lo > 32) { const mid = Math.round((hi + lo) / 2 / 16) * 16; if (test(mid)) hi = mid; else lo = mid; }
  }
  results.sort((x, y) => y.gap - x.gap);
  const edge = hi;                 // smallest gap that still passed, every larger tested gap passed too
  const wall = Date.now() - t0;
  ck.ok('replay: default 6144 reproduces the cable result', results.find((x) => x.gap === 6144).ok);
  ck.ok('pacing edge found (smallest passing gap, all larger tested gaps pass)', edge !== null, `edge ${edge}, first failure ${lo}`);
  ck.ok('default ext_gap 6144 has >= 2x margin over the edge', edge !== null && 6144 >= 2 * edge,
    `6144 / ${edge} = ${edge ? (6144 / edge).toFixed(2) : '-'}x`);
  return {
    ck, rig, a, b, cable, wall, frames: rig.frames, oracle: false,
    pacing: { snap_frame: snap.frame, burst_frame: burstFrame, fed_bytes: feed.length, edge, first_fail: lo, results },
    write: (o) => {
      mkdirSync(o.oracle, { recursive: true });
      const file = path.join(o.oracle, 'pacing.json');
      const doc = { scenario: 'pacing', fixtures: Object.fromEntries(['link_a', 'link_b'].map((f) => [f, sha256(readFileSync(path.join(o.fixtures, `${f}.sav`)))])),
        rom_sha256: sha256(rig.rom), snap_frame: snap.frame, burst_frame: burstFrame, fed_bytes: feed.length,
        edge, first_fail: lo, default_gap: 6144, results };
      if (o['no-write']) {
        const { diff, info } = compareOracle(file, doc);
        console.log(`  oracle ${file}: ${diff || 'identical'}`);
        if (info) console.log(`  ${info}`);
        if (diff) ck.ok('pacing oracle identical', false);
      } else {
        writeFileSync(file, JSON.stringify(doc) + '\n');
        console.log(`  oracle ${file}: written`);
      }
      for (const x of results) console.log(`  gap ${String(x.gap).padStart(5)}: ${x.ok ? 'ok  ' : 'BAD '} menu ${x.menu} fifo_left ${x.fifo_left} data ${x.slave_data_ok} out ${x.slave_out_ok} (first bad ${x.first_bad_out}) ${x.frames} frames`);
    },
  };
}

if (import.meta.url === pathToFileURL(process.argv[1]).href) main();
