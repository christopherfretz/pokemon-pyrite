// LK1a identity gate (docs/LK1-LINK.md 2.4 step 4): the link-port core must
// behave byte-for-byte like the core it replaces while the link is off.
//
// Boots the same .sav on the OLD and the NEW core side by side, drives the
// same deterministic input script through both, and asserts:
//   - identical framebuffer hashes every 60 frames;
//   - identical SRAM (emulator_write_ext_ram) at the end;
//   - identical emulator_write_state bytes at the end, and equal state sizes;
//   - an OLD-core state loads into the NEW core and runs 600 frames exactly as
//     it does in the old core (and the same for a NEW-core state).
//
// Usage (from the pyrite checkout; Node 24, no npm deps):
//   node web/test/identity.mjs [--old-rev 4f09baa | --old-dir DIR] [--new-dir DIR]
//        [--rom pokecrystal.gbc] [--sav web/presets/celadon.sav]
//        [--frames 20000] [--seed 1]
// --old-rev reads the old binjgb.{js,wasm} straight out of git (no files).
// Exit status 0 = gate passed.
import { readFileSync } from 'node:fs';
import path from 'node:path';
import {
  REPO_DIR, CORE_DIR, Machine, loadCore, coreFilesFromDir, coreFilesFromRev, parseArgs, sha256,
} from './core.mjs';

const args = parseArgs(process.argv.slice(2), {
  'old-rev': '4f09baa',
  'new-dir': CORE_DIR,
  rom: path.join(REPO_DIR, 'pokecrystal.gbc'),
  sav: path.join(REPO_DIR, 'web', 'presets', 'celadon.sav'),
  frames: '20000',
  seed: '1',
  rtc: String(3 * 86400 + 10 * 3600),   // day 3, 10:00:00 -- fixed, so both runs agree
});
const FRAMES = parseInt(args.frames, 10);
const CHECK_EVERY = 60;
const TAIL_FRAMES = 600;

let failures = 0;
function check(cond, msg) {
  if (!cond) { failures++; console.log(`FAIL ${msg}`); }
  return cond;
}

// ---------------------------------------------------------- input script ---
function mulberry32(a) {
  return function () {
    a |= 0; a = a + 0x6d2b79f5 | 0;
    let t = Math.imul(a ^ a >>> 15, 1 | a);
    t = t + Math.imul(t ^ t >>> 7, 61 | t) ^ t;
    return ((t ^ t >>> 14) >>> 0) / 4294967296;
  };
}

/* Per-frame button sets: a boot phase that taps A/START through the title
   screen and CONTINUE, then a seeded mix of walking, A/B, and START-menu
   excursions. */
function makeScript(total, seed) {
  const rnd = mulberry32(seed);
  const frames = [];
  const push = (n, b) => { for (let i = 0; i < n && frames.length < total; i++) frames.push(b); };
  const tap = (btn, hold = 6, gap = 14) => { push(hold, { [btn]: true }); push(gap, {}); };
  push(240, {});
  for (let i = 0; i < 36; i++) tap(i % 3 === 2 ? 'START' : 'A', 6, 39);
  const dirs = ['UP', 'DOWN', 'LEFT', 'RIGHT'];
  while (frames.length < total) {
    const r = rnd();
    if (r < 0.5) push(16 * (1 + Math.floor(rnd() * 4)), { [dirs[Math.floor(rnd() * 4)]]: true });
    else if (r < 0.62) tap('A', 6, 24);
    else if (r < 0.72) tap('B', 6, 14);
    else if (r < 0.85) {
      tap('START', 6, 30);
      const downs = Math.floor(rnd() * 5);
      for (let i = 0; i < downs; i++) tap('DOWN', 4, 8);
      if (rnd() < 0.5) { tap('A', 6, 40); tap('B', 6, 20); }
      tap('B', 6, 20); tap('B', 6, 20);
    } else push(30, {});
  }
  return frames;
}

// ------------------------------------------------------------------- run ---
const t0 = Date.now();
const rom = readFileSync(args.rom);
const sav = readFileSync(args.sav);
const oldFiles = args['old-dir'] ? coreFilesFromDir(args['old-dir']) : coreFilesFromRev(args['old-rev']);
const newFiles = coreFilesFromDir(args['new-dir']);
const oldMod = await loadCore(oldFiles);
const newMod = await loadCore(newFiles);
console.log(`old core: ${oldMod.label}  wasm sha256 ${oldMod.wasmSha}`);
console.log(`new core: ${newMod.label}  wasm sha256 ${newMod.wasmSha}`);
console.log(`rom: ${args.rom}  sha256 ${sha256(rom).slice(0, 16)}  sav: ${args.sav}  frames: ${FRAMES}  seed: ${args.seed}`);
check(oldMod.wasmSha !== newMod.wasmSha, 'old and new wasm are the same binary (nothing under test)');
check(typeof newMod._emulator_link_enable === 'function', 'new core does not export _emulator_link_enable');
check(typeof oldMod._emulator_link_enable !== 'function', 'old core already exports _emulator_link_enable');

function boot(mod) {
  const m = new Machine(mod, rom);
  if (!m.putSram(sav)) throw new Error(`${mod.label}: read_ext_ram failed`);
  if (!m.setRtc(parseFloat(args.rtc))) throw new Error(`${mod.label}: no MBC3 RTC`);
  return m;
}

const A = boot(oldMod);
const B = boot(newMod);
const sizeA = A.stateSize(), sizeB = B.stateSize();
console.log(`state size: old ${sizeA}  new ${sizeB}`);
check(sizeA === sizeB, `state size differs: old ${sizeA} new ${sizeB}`);

const script = makeScript(FRAMES + 2 * TAIL_FRAMES, parseInt(args.seed, 10));
const distinct = new Set();
let checkpoints = 0, firstMismatch = -1;
for (let f = 0; f < FRAMES; f++) {
  A.setButtons(script[f]); B.setButtons(script[f]);
  A.frame(); B.frame();
  if ((f + 1) % CHECK_EVERY === 0) {
    const ha = A.frameHash(), hb = B.frameHash();
    checkpoints++;
    distinct.add(ha);
    if (ha !== hb && firstMismatch < 0) firstMismatch = f + 1;
  }
}
check(firstMismatch < 0, `framebuffer differs first at frame ${firstMismatch}`);
console.log(`framebuffers: ${checkpoints} checkpoints every ${CHECK_EVERY} frames, ` +
  `${firstMismatch < 0 ? 'all identical' : 'MISMATCH at ' + firstMismatch}, ${distinct.size} distinct screens`);
check(distinct.size > 20, `only ${distinct.size} distinct screens: the input script did not exercise the game`);

const sramA = A.getSram(), sramB = B.getSram();
check(sha256(sramA) === sha256(sramB), 'SRAM differs at the end');
console.log(`SRAM: ${sramA.length} bytes, old ${sha256(sramA).slice(0, 16)} new ${sha256(sramB).slice(0, 16)}, ` +
  `${Buffer.compare(Buffer.from(sramA), sav) === 0 ? 'unchanged from the .sav' : 'changed by the run (game saved)'}`);

const stA = A.getState(), stB = B.getState();
let stDiff = 0;
for (let i = 0; i < Math.min(stA.length, stB.length); i++) if (stA[i] !== stB[i]) stDiff++;
check(stA.length === stB.length && stDiff === 0, `write_state bytes differ (${stDiff} bytes)`);
console.log(`write_state: ${stA.length} bytes, old ${sha256(stA).slice(0, 16)} new ${sha256(stB).slice(0, 16)}, ${stDiff} bytes differ`);
const hdr = (s) => new DataView(s.buffer, s.byteOffset).getUint32(0, true);
check(hdr(stA) === hdr(stB), 'state header (SAVE_STATE_VERSION) differs');
console.log(`state header: old 0x${hdr(stA).toString(16)} new 0x${hdr(stB).toString(16)}`);

// --------------------------------------- cross-load states, 600 frames on ---
/* A state is loaded into a fresh machine on EACH core and both run the next
   600 frames of the script: they must agree on every 60th framebuffer and on
   the final state bytes.  The fresh machines are also compared, framebuffer
   only, with the machine that wrote the state running on.  Not its state
   bytes: a resumed core differs from one that never stopped in one APU field
   (Channel.accumulator, the audio resampler's running sum, which depends on
   the audio buffer outside EmulatorState).  That holds old->old as well, so
   it is binjgb's, not the link port's. */
function crossLoad(name, state, runner) {
  const X = new Machine(oldMod, rom), Y = new Machine(newMod, rom);
  check(X.putState(state), `${name}: old core refused the state`);
  check(Y.putState(state), `${name}: new core refused the state`);
  let mismatch = -1, runnerMismatch = -1, n = 0;
  for (let f = 0; f < TAIL_FRAMES; f++) {
    const b = script[FRAMES + f];
    for (const m of [X, Y, runner]) { m.setButtons(b); m.frame(); }
    if ((f + 1) % CHECK_EVERY === 0) {
      n++;
      const hx = X.frameHash();
      if (hx !== Y.frameHash() && mismatch < 0) mismatch = f + 1;
      if (hx !== runner.frameHash() && runnerMismatch < 0) runnerMismatch = f + 1;
    }
  }
  const same = sha256(X.getState()) === sha256(Y.getState());
  check(mismatch < 0, `${name}: old/new framebuffer differs at frame ${mismatch}`);
  check(runnerMismatch < 0, `${name}: resumed framebuffer differs from the uninterrupted run at frame ${runnerMismatch}`);
  check(same, `${name}: old/new state differs after ${TAIL_FRAMES} frames`);
  console.log(`${name}: loaded into both cores, ran ${TAIL_FRAMES} frames, ${n} checkpoints ` +
    `${mismatch < 0 ? 'identical' : 'MISMATCH'} (and ${runnerMismatch < 0 ? 'identical' : 'DIFFERENT'} to the ` +
    `uninterrupted run), end state ${same ? 'identical' : 'DIFFERENT'}`);
  X.delete(); Y.delete();
}
// The old core's end state (what a phone's resume snapshot is today) ...
crossLoad('old-core state', stA, A);
// ... and the new core's, so a rollback to the old core still loads it.
crossLoad('new-core state', B.getState(), B);

console.log(`${failures === 0 ? 'PASS' : 'FAIL'}: identity gate, ${failures} failure(s), ${((Date.now() - t0) / 1000).toFixed(1)} s`);
process.exit(failures === 0 ? 0 : 1);
