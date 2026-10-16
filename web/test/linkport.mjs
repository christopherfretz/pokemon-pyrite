// LK1a link-port smoke (docs/LK1-LINK.md 2.2): exercises the emulator_link_*
// API of the vendored core on a tiny synthetic ROM (DI, IE=0, spin), poking
// SB/SC through emulator_write_mem the way a game would.
//   (a) internal clock: pushed bytes are shifted in MSB first and logged
//   (b) external clock: the paced virtual master completes an armed transfer
//       ext_gap ticks after arming / after the previous byte, raises IF bit 3;
//       mode 2 clocks idle_in at ext_idle_period; mode 0 never clocks
//   (c) emulator_link_peek and emulator_link_clock_external
//   (d) link disabled: SB reads back $FF after a transfer exactly as before,
//       external transfers never end, the API is inert, and the old core
//       ends in the same state bytes
// Usage: node web/test/linkport.mjs [--old-rev 4f09baa] [--new-dir DIR]
import { readFileSync } from 'node:fs';
import path from 'node:path';
import {
  REPO_DIR, CORE_DIR, Machine, loadCore, coreFilesFromDir, coreFilesFromRev, parseArgs, sha256,
} from './core.mjs';

const args = parseArgs(process.argv.slice(2), { 'old-rev': '4f09baa', 'new-dir': CORE_DIR });
const SB = 0xff01, SC = 0xff02, IF = 0xff0f;
const LOG_FROM_FIFO = 0x01, LOG_FORCED = 0x02;

let failures = 0, passes = 0;
function eq(got, want, msg) {
  if (got === want) { passes++; return true; }
  failures++;
  console.log(`FAIL ${msg}: got ${fmt(got)}, want ${fmt(want)}`);
  return false;
}
const fmt = (v) => (typeof v === 'number' ? `0x${(v >>> 0).toString(16)} (${v})` : String(v));
function ok(cond, msg) { return eq(!!cond, true, msg); }

/* 32 KB ROM-only cart: the Nintendo logo copied from pokecrystal.gbc (binjgb
   checks it), then at $0150: di / xor a / ldh [rIE], a / jr @. */
function syntheticRom() {
  const rom = new Uint8Array(0x8000);
  const real = readFileSync(path.join(REPO_DIR, 'pokecrystal.gbc'));
  rom.set([0x00, 0xc3, 0x50, 0x01], 0x100);                     // nop; jp $0150
  rom.set(real.subarray(0x104, 0x134), 0x104);                  // logo
  rom.set(Buffer.from('LINKSMOKE'), 0x134);
  rom[0x147] = 0x00; rom[0x148] = 0x00; rom[0x149] = 0x00;      // ROM only, 32 KB, no RAM
  let x = 0;
  for (let i = 0x134; i <= 0x14c; i++) x = (x - rom[i] - 1) & 0xff;
  rom[0x14d] = x;
  rom.set([0xf3, 0xaf, 0xe0, 0xff, 0x18, 0xfe], 0x150);
  return rom;
}

class Link {
  constructor(m) { this.m = m; this.mod = m.mod; this.emu = m.emu; }
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
  ext(mode, gap, idle) { this.mod._emulator_link_set_ext_clock(this.emu, mode, gap, idle); }
  drain(max = 64) {
    const p = this.mod._malloc(4 * max);
    const n = this.mod._emulator_link_drain_out(this.emu, p, max);
    const out = Array.from(this.mod.HEAPU32.subarray(p >> 2, (p >> 2) + n));
    this.mod._free(p);
    return out.map((e) => ({ out: e & 0xff, in: (e >>> 8) & 0xff, clock: (e >>> 16) & 1, flags: e >>> 24 }));
  }
  peek() { return this.mod._emulator_link_peek(this.emu) >>> 0; }
  clockExt(v) { return this.mod._emulator_link_clock_external(this.emu, v); }
}

const rom = syntheticRom();
const newMod = await loadCore(coreFilesFromDir(args['new-dir']));
const oldMod = await loadCore(args['old-dir'] ? coreFilesFromDir(args['old-dir']) : coreFilesFromRev(args['old-rev']));
console.log(`new core wasm ${newMod.wasmSha.slice(0, 16)}, old core wasm ${oldMod.wasmSha.slice(0, 16)}`);
const boot = (mod) => { const m = new Machine(mod, rom); m.runTicks(1000); return m; };
const ifSerial = (m) => m.read(IF) & 0x08;

// ------------------------------------------------- (a) internal clock ---
{
  const m = boot(newMod), L = new Link(m);
  L.enable(true);
  eq(L.push([0xa5, 0x3c]), 2, '(a) push accepted');
  eq(L.pending(), 2, '(a) in_pending');
  m.write(IF, 0);
  m.write(SB, 0x12); m.write(SC, 0x81);
  m.runTicks(4 * 512 + 100);                       // four bit-times
  eq(m.read(SB), ((0x12 << 4) | (0xa5 >> 4)) & 0xff, '(a) after 4 bits SB = out<<4 | in>>4 (MSB first)');
  eq(L.pending(), 1, '(a) byte taken from the FIFO at the first clock edge');
  m.runTicks(4096);
  eq(m.read(SB), 0xa5, '(a) SB after transfer 1');
  eq(m.read(SC) & 0x80, 0, '(a) transfer 1 finished');
  ok(ifSerial(m), '(a) IF serial bit raised');
  m.write(IF, 0);
  m.write(SB, 0x34); m.write(SC, 0x81); m.runTicks(5000);
  eq(m.read(SB), 0x3c, '(a) SB after transfer 2');
  L.idle(0xfe);
  m.write(SB, 0x56); m.write(SC, 0x81); m.runTicks(5000);
  eq(m.read(SB), 0xfe, '(a) empty FIFO shifts in idle_in');
  const log = L.drain();
  eq(log.length, 3, '(a) three log entries');
  eq(JSON.stringify(log), JSON.stringify([
    { out: 0x12, in: 0xa5, clock: 1, flags: LOG_FROM_FIFO },
    { out: 0x34, in: 0x3c, clock: 1, flags: LOG_FROM_FIFO },
    { out: 0x56, in: 0xfe, clock: 1, flags: 0 },
  ]), '(a) log {out,in,clock,flags}');
  eq(L.drain().length, 0, '(a) drain empties the log');
  console.log(`(a) internal clock: ${JSON.stringify(log)}`);
  m.delete();
}

// ------------------------------------------------- (b) external clock ---
{
  const m = boot(newMod), L = new Link(m);
  L.enable(true);
  L.ext(1, 6144, 70224);
  m.write(IF, 0);
  m.write(SB, 0x56); m.write(SC, 0x80);
  const t0 = m.ticks();
  L.push([0x99]);
  m.runUntil(t0 + 6000);
  eq(m.read(SC) & 0x80, 0x80, '(b) still armed before ext_gap');
  eq(ifSerial(m), 0, '(b) no interrupt before ext_gap');
  m.runUntil(t0 + 6144 + 64);
  eq(m.read(SB), 0x99, '(b) SB = pushed byte after ext_gap');
  eq(m.read(SC) & 0x80, 0, '(b) transfer finished');
  ok(ifSerial(m), '(b) IF bit 3 raised by the virtual master');
  // pacing: re-armed at once, the next byte waits ext_gap after the previous
  m.write(IF, 0);
  m.write(SB, 0x57); m.write(SC, 0x80);
  const t1 = m.ticks();
  L.push([0x77]);
  m.runUntil(t1 + 6000);
  eq(m.read(SC) & 0x80, 0x80, '(b) paced: second byte not before ext_gap');
  m.runUntil(t1 + 6144 + 64);
  eq(m.read(SB), 0x77, '(b) paced: second byte after ext_gap');
  // mode 1, FIFO empty: no clock; a later push completes it right away
  m.write(SB, 0x58); m.write(SC, 0x80);
  m.runTicks(200000);
  eq(m.read(SC) & 0x80, 0x80, '(b) mode 1 with an empty FIFO never clocks');
  L.push([0x66]);
  m.runTicks(64);
  eq(m.read(SB), 0x66, '(b) push into a long-armed transfer completes it at once');
  // mode 2: idle_in at the idle cadence
  L.idle(0xfe); L.ext(2, 6144, 70224);
  m.runTicks(100000);
  m.write(SB, 0x59); m.write(SC, 0x80);
  const t2 = m.ticks();
  m.runUntil(t2 + 6144 + 64);
  eq(m.read(SB), 0xfe, '(b) mode 2 clocks idle_in after ext_gap');
  m.write(SB, 0x5a); m.write(SC, 0x80);
  const t3 = m.ticks();
  m.runUntil(t3 + 60000);
  eq(m.read(SC) & 0x80, 0x80, '(b) mode 2 idle bytes wait ext_idle_period');
  m.runUntil(t3 + 70224 + 64);
  eq(m.read(SB), 0xfe, '(b) mode 2 second idle byte at ext_idle_period');
  // mode 0: never
  L.ext(0, 6144, 70224);
  m.write(SB, 0x5b); m.write(SC, 0x80);
  L.push([0x44]);
  m.runTicks(200000);
  eq(m.read(SC) & 0x80, 0x80, '(b) mode 0 never clocks');
  const log = L.drain();
  eq(JSON.stringify(log.map((e) => [e.out, e.in, e.clock, e.flags])), JSON.stringify([
    [0x56, 0x99, 0, LOG_FROM_FIFO], [0x57, 0x77, 0, LOG_FROM_FIFO], [0x58, 0x66, 0, LOG_FROM_FIFO],
    [0x59, 0xfe, 0, 0], [0x5a, 0xfe, 0, 0],
  ]), '(b) log');
  console.log(`(b) external clock: ${JSON.stringify(log)}`);

  // ------------------------------------- (c) peek and clock_external ---
  eq(L.peek(), 0x200 | 0x5b, '(c) peek = transferring<<9 | clock<<8 | SB (armed external)');
  m.write(IF, 0);
  eq(L.clockExt(0x42), 0x5b, '(c) clock_external returns the byte shifted out');
  eq(m.read(SB), 0x42, '(c) SB = byte clocked in');
  ok(ifSerial(m), '(c) IF bit 3 visible at once');
  eq(L.peek(), 0x42, '(c) peek after: idle');
  eq(L.clockExt(0x43), -1, '(c) clock_external with nothing armed = -1');
  eq(L.pending(), 1, '(c) clock_external leaves the FIFO alone');
  m.write(SB, 0x60); m.write(SC, 0x81);
  eq(L.peek() & 0x300, 0x300, '(c) peek shows an internal transfer in flight');
  m.runTicks(5000);
  const log2 = L.drain();
  eq(JSON.stringify(log2), JSON.stringify([
    { out: 0x5b, in: 0x42, clock: 0, flags: LOG_FORCED },
    { out: 0x60, in: 0x44, clock: 1, flags: LOG_FROM_FIFO },
  ]), '(c) log of the forced byte and the next internal one');
  L.clear(); eq(L.pending(), 0, '(c) clear_in');
  console.log(`(c) peek/clock_external: ${JSON.stringify(log2)}`);
  // disabling mid-transfer stops the virtual master
  L.ext(1, 6144, 70224); L.push([0x10]);
  m.write(SB, 0x61); m.write(SC, 0x80);
  L.enable(false);
  m.runTicks(20000);
  eq(m.read(SC) & 0x80, 0x80, '(c) link disabled while armed: no completion');
  m.delete();
}

// ------------------------------------------------- (d) link disabled ---
function disabledRun(mod, poke) {
  const m = boot(mod), r = {};
  if (poke) {
    const L = new Link(m);
    r.push = L.push([1, 2, 3]); r.pending = L.pending(); r.peek = L.peek();
    r.clock = L.clockExt(0x42); r.drain = L.drain().length;
    L.idle(0x00); L.ext(2, 1, 1);
  }
  m.write(IF, 0);
  m.write(SB, 0x12); m.write(SC, 0x81); m.runTicks(5000);
  r.sbInternal = m.read(SB); r.scInternal = m.read(SC); r.ifInternal = ifSerial(m);
  m.write(IF, 0);
  m.write(SB, 0x34); m.write(SC, 0x80); m.runTicks(300000);
  r.sbExternal = m.read(SB); r.scExternal = m.read(SC); r.ifExternal = ifSerial(m);
  r.state = sha256(m.getState());
  m.delete();
  return r;
}
{
  const nw = disabledRun(newMod, true), od = disabledRun(oldMod, false);
  eq(nw.push, 0, '(d) push while disabled accepts nothing');
  eq(nw.pending + nw.peek + nw.drain, 0, '(d) pending/peek/drain inert while disabled');
  eq(nw.clock, -1, '(d) clock_external while disabled = -1');
  eq(nw.sbInternal, 0xff, '(d) SB reads $FF after an internal transfer');
  eq(od.sbInternal, 0xff, '(d) old core: SB reads $FF too');
  eq(nw.ifInternal, od.ifInternal, '(d) IF after the internal transfer as old');
  eq(nw.scExternal & 0x80, 0x80, '(d) external transfer never ends');
  eq(JSON.stringify([nw.sbInternal, nw.scInternal, nw.ifInternal, nw.sbExternal, nw.scExternal, nw.ifExternal]),
    JSON.stringify([od.sbInternal, od.scInternal, od.ifInternal, od.sbExternal, od.scExternal, od.ifExternal]),
    '(d) SB/SC/IF read-backs identical to the old core');
  eq(nw.state, od.state, '(d) state bytes identical to the old core');
  console.log(`(d) disabled: new ${JSON.stringify({ ...nw, state: nw.state.slice(0, 16) })}`);
  console.log(`(d) disabled: old ${JSON.stringify({ ...od, state: od.state.slice(0, 16) })}`);
}

console.log(`${failures === 0 ? 'PASS' : 'FAIL'}: link-port smoke, ${passes} checks passed, ${failures} failed`);
process.exit(failures === 0 ? 0 : 1);
