// Headless driver for the vendored binjgb core (web/vendor/binjgb), shared by
// the web/test/*.mjs scripts.  Node 24, no npm dependencies.  It drives the
// core the way app.js does: emulator_new_simple, the default joypad callback,
// ext-RAM upload through a FileData, run_until in ticks, set_joyp_*.
//
// The shipped glue is built with -s ENVIRONMENT=web, so it is evaluated as a
// plain script and handed the wasm bytes (wasmBinary) instead of fetching them.
import { readFileSync } from 'node:fs';
import { execFileSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

export const WEB_DIR = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
export const REPO_DIR = path.resolve(WEB_DIR, '..');
export const CORE_DIR = path.join(WEB_DIR, 'vendor', 'binjgb');

export const FRAME_TICKS = 70224;
export const EVENT_NEW_FRAME = 1;
export const EVENT_AUDIO_BUFFER_FULL = 2;
export const EVENT_UNTIL_TICKS = 4;
const RESULT_OK = 0;
const AUDIO_FRAMES = 4096;     // app.js
const CGB_COLOR_CURVE = 2;     // app.js
const SAMPLE_RATE = 48000;     // app.js's fallback rate

/* {js, wasm} of the core in a directory, or at a pyrite git revision. */
export function coreFilesFromDir(dir) {
  return {
    js: readFileSync(path.join(dir, 'binjgb.js'), 'utf8'),
    wasm: readFileSync(path.join(dir, 'binjgb.wasm')),
    label: dir,
  };
}

export function coreFilesFromRev(rev) {
  const show = (f) => execFileSync('git', ['-C', REPO_DIR, 'show', `${rev}:web/vendor/binjgb/${f}`],
    { maxBuffer: 64 << 20 });
  return { js: show('binjgb.js').toString('utf8'), wasm: show('binjgb.wasm'), label: `pyrite@${rev}` };
}

export function sha256(buf) { return createHash('sha256').update(buf).digest('hex'); }

/* Instantiate one wasm module (one heap).  Several Machines may share it. */
export async function loadCore(files) {
  const factory = new Function(`${files.js}\nreturn Binjgb;`)();
  const mod = await factory({
    wasmBinary: files.wasm,
    locateFile: (p) => p,
    print: () => {},
    printErr: (s) => process.stderr.write(`[core] ${s}\n`),
  });
  mod.label = files.label;
  mod.wasmSha = sha256(files.wasm);
  return mod;
}

export class Machine {
  constructor(mod, romBytes) {
    this.mod = mod;
    const size = (romBytes.length + 0x7fff) & ~0x7fff;
    this.romPtr = mod._malloc(size);
    if (!this.romPtr) throw new Error('out of wasm memory for the ROM');
    const heap = new Uint8Array(mod.HEAPU8.buffer, this.romPtr, size);
    heap.fill(0);
    heap.set(romBytes);
    this.emu = mod._emulator_new_simple(this.romPtr, size, SAMPLE_RATE, AUDIO_FRAMES, CGB_COLOR_CURVE);
    if (!this.emu) throw new Error('core rejected the ROM');
    this.joypadBuf = mod._joypad_new();
    mod._emulator_set_default_joypad_callback(this.emu, this.joypadBuf);
    this.frames = 0;
  }

  /* emulator_delete frees the ROM buffer itself (file_data_delete on
     e->file_data, which is our romPtr), so it must not be freed again. */
  delete() {
    const m = this.mod;
    m._emulator_delete(this.emu);
    m._joypad_delete(this.joypadBuf);
  }

  withFileData(fdPtr, cb) {
    const m = this.mod;
    try {
      const ptr = m._get_file_data_ptr(fdPtr);
      const size = m._get_file_data_size(fdPtr);
      return cb(new Uint8Array(m.HEAPU8.buffer, ptr, size), fdPtr, size);
    } finally {
      m._file_data_delete(fdPtr);
      m._free(fdPtr);
    }
  }

  getSram() {
    return this.withFileData(this.mod._ext_ram_file_data_new(this.emu), (view, fd) => {
      this.mod._emulator_write_ext_ram(this.emu, fd);
      return new Uint8Array(view);
    });
  }

  putSram(bytes) {
    return this.withFileData(this.mod._ext_ram_file_data_new(this.emu), (view, fd, size) => {
      if (bytes.length !== size) throw new Error(`sav is ${bytes.length} bytes, core wants ${size}`);
      view.set(bytes);
      return this.mod._emulator_read_ext_ram(this.emu, fd) === RESULT_OK;
    });
  }

  stateSize() {
    return this.withFileData(this.mod._state_file_data_new(this.emu), (v, p, size) => size);
  }

  getState() {
    return this.withFileData(this.mod._state_file_data_new(this.emu), (view, fd) => {
      if (this.mod._emulator_write_state(this.emu, fd) !== RESULT_OK) throw new Error('write_state failed');
      return new Uint8Array(view);
    });
  }

  putState(bytes) {
    return this.withFileData(this.mod._state_file_data_new(this.emu), (view, fd, size) => {
      if (bytes.length !== size) return false;
      view.set(bytes);
      return this.mod._emulator_read_state(this.emu, fd) === RESULT_OK;
    });
  }

  setRtc(seconds) { return this.mod._emulator_set_rtc_seconds_f64(this.emu, seconds); }

  ticks() { return this.mod._emulator_get_ticks_f64(this.emu); }

  /* Run to an absolute tick count, as app.js's runUntil does. */
  runUntil(until) {
    let events = 0;
    for (;;) {
      const ev = this.mod._emulator_run_until_f64(this.emu, until);
      events |= ev;
      if (ev & EVENT_UNTIL_TICKS) break;
    }
    return events;
  }

  runTicks(n) { return this.runUntil(this.ticks() + n); }

  /* One video frame's worth of ticks. */
  frame() { this.frames++; return this.runTicks(FRAME_TICKS); }

  setButtons(b) {
    const m = this.mod, e = this.emu;
    m._set_joyp_up(e, b.UP ? 1 : 0);
    m._set_joyp_down(e, b.DOWN ? 1 : 0);
    m._set_joyp_left(e, b.LEFT ? 1 : 0);
    m._set_joyp_right(e, b.RIGHT ? 1 : 0);
    m._set_joyp_A(e, b.A ? 1 : 0);
    m._set_joyp_B(e, b.B ? 1 : 0);
    m._set_joyp_start(e, b.START ? 1 : 0);
    m._set_joyp_select(e, b.SELECT ? 1 : 0);
  }

  frameBuffer() {
    const m = this.mod;
    return new Uint8Array(m.HEAPU8.buffer, m._get_frame_buffer_ptr(this.emu), m._get_frame_buffer_size(this.emu));
  }

  frameHash() { return sha256(this.frameBuffer()); }

  read(addr) { return this.mod._emulator_read_mem(this.emu, addr); }
  write(addr, v) { this.mod._emulator_write_mem(this.emu, addr, v); }
}

/* Tiny argv parser: --key value / --flag. */
export function parseArgs(argv, defaults) {
  const out = { ...defaults };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (!a.startsWith('--')) throw new Error(`unexpected argument ${a}`);
    const k = a.slice(2);
    if (i + 1 < argv.length && !argv[i + 1].startsWith('--')) out[k] = argv[++i];
    else out[k] = true;
  }
  return out;
}
