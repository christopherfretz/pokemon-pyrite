/* Kanto First - a self-hostable browser Game Boy Color player.
 *
 * Core: binjgb (https://github.com/binji/binjgb), MIT, vendored under
 * ./vendor/binjgb/ as the prebuilt emscripten artefacts upstream commits in
 * its docs/ directory.  See vendor/binjgb/VERSION.txt for the exact commit and
 * hashes, and web/README.md for why this core and not another.
 *
 * The glue below (the run loop, the wasm FileData helpers, the audio
 * scheduler, the WebGL-less Canvas2D renderer) is adapted from binjgb's own
 * docs/simple.js and docs/demo.js, MIT, (c) 2016-2020 Ben Smith - see
 * vendor/binjgb/LICENSE and vendor/binjgb/LICENSE.gbstudio.
 *
 * Why binjgb: our cartridge is type 0x10, MBC3+TIMER+RAM+BATTERY, and Pokemon
 * Crystal reads the MBC3 real-time clock for time of day.  binjgb implements
 * it (src/emulator.c: mbc3_write_rom latches at 6000-7fff, mbc3_read_ext_ram /
 * mbc3_write_ext_ram serve registers $08-$0c, and the Mbc3 struct lives in
 * EmulatorState so a save state carries the clock).  WasmBoy, which this page
 * used to run on, does not: its RTC register writes fall through into SRAM
 * banks and corrupt save data.
 *
 * Battery saves: binjgb's .sav is EXACTLY cartridge RAM - 32768 bytes for this
 * cart, no RTC footer (emulator_write_ext_ram copies EXT_RAM.data and nothing
 * else).  We mirror that region into IndexedDB keyed by the cartridge *title*
 * (stable across builds of the hack, unlike the header checksum) and export it
 * verbatim, so the file round-trips with Delta.
 *
 * The clock: binjgb keeps the RTC in its save state, not in the .sav, and
 * advances it from emulated CPU ticks rather than the host clock.  So we also
 * snapshot a full save state ("resume") next to the battery save and restore
 * it on the next visit, which is what keeps time of day continuous across
 * reloads.  It is keyed by ROM hash + core commit and is only ever an
 * optimisation: if anything about it does not match, we fall back to booting
 * the cartridge with the battery save, exactly as a real Game Boy would.
 *
 * No service worker on purpose: the ROM must always be the freshly hosted one.
 * No navigator.vibrate() anywhere: haptics stay off.
 */
(function () {
  'use strict';

  var CORE_NAME = 'binjgb';
  var CORE_COMMIT = 'c60e138da5a795ebb55e56b11b7e90024e41112c';
  var CORE_DIR = './vendor/binjgb/';
  var CORE_JS = CORE_DIR + 'binjgb.js';
  var DEFAULT_ROM = './kanto-first.gbc';
  var SAV_NAME = 'kanto-first.sav';

  var DB_NAME = 'kanto-first-web';
  var DB_VERSION = 1;
  var STORE = 'kv';

  var AUTOSAVE_MS = 10000;
  /* A full EmulatorState embeds VRAM + WRAM + cartridge RAM (a few hundred KB),
     so the resume snapshot is written on a slower cadence than the battery
     mirror - plus unconditionally whenever the page is backgrounded or closed,
     which is when it actually matters. Worst case the clock loses a minute. */
  var RESUME_MS = 60000;
  var DEADZONE = 0.30;

  // binjgb constants (src/emulator.h, src/emscripten/wrapper.c).
  var SCREEN_W = 160;
  var SCREEN_H = 144;
  var CPU_TICKS_PER_SECOND = 4194304;
  var RESULT_OK = 0;
  var EVENT_NEW_FRAME = 1;
  var EVENT_AUDIO_BUFFER_FULL = 2;
  var EVENT_UNTIL_TICKS = 4;
  var AUDIO_FRAMES = 4096;
  var AUDIO_LATENCY_SEC = 0.1;
  var VOLUME = 0.5;              // upstream's default; samples are 0..255 unsigned
  var MAX_UPDATE_SEC = 5 / 60;   // never emulate more than 5 frames per rAF
  var CGB_COLOR_CURVE = 2;       // 0 none, 1 Sameboy, 2 Gambatte/GB Online
  var FF_SPEED = 2;

  // ---------------------------------------------------------------- DOM ----

  var $ = function (sel) { return document.querySelector(sel); };
  var statusEl = $('#status');
  var canvas = $('#canvas');
  var overlay = $('#overlay');
  var dpadEl = $('#dpad');

  var statusParts = { rom: '', state: 'Starting...', save: '' };

  function renderStatus(isError) {
    var line = [statusParts.state, statusParts.rom, statusParts.save]
      .filter(function (s) { return !!s; }).join('  |  ');
    statusEl.textContent = line;
    statusEl.classList.toggle('err', !!isError);
  }
  function say(msg, isError) { statusParts.state = msg; renderStatus(isError); }
  function fail(msg, err) {
    console.error(msg, err || '');
    say(msg + (err && err.message ? ': ' + err.message : ''), true);
  }

  // ------------------------------------------------------------- helpers ---

  function hex(bytes, n) {
    var out = '';
    for (var i = 0; i < n && i < bytes.length; i++) {
      out += (bytes[i] < 16 ? '0' : '') + bytes[i].toString(16);
    }
    return out;
  }

  /* SHA-256.  crypto.subtle is only available in a secure context, and the
     operator may well host this over plain http on a LAN, so keep a small
     pure-JS fallback rather than losing the build fingerprint. */
  var K = [
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2];

  function sha256Sync(bytes) {
    var h = [0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19];
    var len = bytes.length;
    var withPad = ((len + 9 + 63) >> 6) << 6;
    var m = new Uint8Array(withPad);
    m.set(bytes);
    m[len] = 0x80;
    var bits = len * 8;
    // 2^53 is plenty for a ROM; write the low 48 bits of the length.
    m[withPad - 1] = bits & 0xff;
    m[withPad - 2] = (bits / 0x100) & 0xff;
    m[withPad - 3] = (bits / 0x10000) & 0xff;
    m[withPad - 4] = (bits / 0x1000000) & 0xff;
    m[withPad - 5] = (bits / 0x100000000) & 0xff;
    m[withPad - 6] = (bits / 0x10000000000) & 0xff;

    var w = new Int32Array(64);
    for (var off = 0; off < withPad; off += 64) {
      for (var i = 0; i < 16; i++) {
        w[i] = (m[off + i * 4] << 24) | (m[off + i * 4 + 1] << 16) | (m[off + i * 4 + 2] << 8) | m[off + i * 4 + 3];
      }
      for (i = 16; i < 64; i++) {
        var g0 = w[i - 15], g1 = w[i - 2];
        var s0 = ((g0 >>> 7) | (g0 << 25)) ^ ((g0 >>> 18) | (g0 << 14)) ^ (g0 >>> 3);
        var s1 = ((g1 >>> 17) | (g1 << 15)) ^ ((g1 >>> 19) | (g1 << 13)) ^ (g1 >>> 10);
        w[i] = (w[i - 16] + s0 + w[i - 7] + s1) | 0;
      }
      var a = h[0], b = h[1], c = h[2], d = h[3], e = h[4], f = h[5], gg = h[6], hh = h[7];
      for (i = 0; i < 64; i++) {
        var S1 = ((e >>> 6) | (e << 26)) ^ ((e >>> 11) | (e << 21)) ^ ((e >>> 25) | (e << 7));
        var ch = (e & f) ^ (~e & gg);
        var t1 = (hh + S1 + ch + K[i] + w[i]) | 0;
        var S0 = ((a >>> 2) | (a << 30)) ^ ((a >>> 13) | (a << 19)) ^ ((a >>> 22) | (a << 10));
        var maj = (a & b) ^ (a & c) ^ (b & c);
        var t2 = (S0 + maj) | 0;
        hh = gg; gg = f; f = e; e = (d + t1) | 0; d = c; c = b; b = a; a = (t1 + t2) | 0;
      }
      h[0] = (h[0] + a) | 0; h[1] = (h[1] + b) | 0; h[2] = (h[2] + c) | 0; h[3] = (h[3] + d) | 0;
      h[4] = (h[4] + e) | 0; h[5] = (h[5] + f) | 0; h[6] = (h[6] + gg) | 0; h[7] = (h[7] + hh) | 0;
    }
    var out = '';
    for (i = 0; i < 8; i++) { out += ('00000000' + (h[i] >>> 0).toString(16)).slice(-8); }
    return out;
  }

  function sha256(bytes) {
    if (window.crypto && window.crypto.subtle && window.crypto.subtle.digest) {
      var copy = bytes.slice(0);
      return window.crypto.subtle.digest('SHA-256', copy.buffer).then(function (buf) {
        return hex(new Uint8Array(buf), 32);
      }).catch(function () { return sha256Sync(bytes); });
    }
    return Promise.resolve(sha256Sync(bytes));
  }

  // ----------------------------------------------------------- IndexedDB ---

  function openDb(name, version, upgrade) {
    return new Promise(function (resolve, reject) {
      var req = indexedDB.open(name, version);
      req.onupgradeneeded = function (ev) { upgrade(req.result, ev); };
      req.onsuccess = function () { resolve(req.result); };
      req.onerror = function () { reject(req.error); };
      req.onblocked = function () { reject(new Error('IndexedDB blocked')); };
    });
  }

  var dbPromise = null;
  function db() {
    if (!dbPromise) {
      dbPromise = openDb(DB_NAME, DB_VERSION, function (d) {
        if (!d.objectStoreNames.contains(STORE)) { d.createObjectStore(STORE); }
      });
    }
    return dbPromise;
  }

  function tx(dbh, store, mode, fn) {
    return new Promise(function (resolve, reject) {
      var t = dbh.transaction(store, mode);
      var req = fn(t.objectStore(store));
      t.oncomplete = function () { resolve(req ? req.result : undefined); };
      t.onerror = function () { reject(t.error); };
      t.onabort = function () { reject(t.error); };
    });
  }

  function kvGet(key) {
    return db().then(function (d) { return tx(d, STORE, 'readonly', function (s) { return s.get(key); }); });
  }
  function kvPut(key, value) {
    return db().then(function (d) { return tx(d, STORE, 'readwrite', function (s) { return s.put(value, key); }); });
  }
  function kvDel(key) {
    return db().then(function (d) { return tx(d, STORE, 'readwrite', function (s) { return s.delete(key); }); });
  }

  // ------------------------------------------------------- core + ROM ------

  function loadScript(src) {
    return new Promise(function (resolve, reject) {
      var s = document.createElement('script');
      s.src = src;
      s.async = false;
      s.onload = function () { resolve(src); };
      s.onerror = function () { reject(new Error('could not load ' + src)); };
      document.head.appendChild(s);
    });
  }

  function loadCore() {
    return loadScript(CORE_JS).then(function () {
      if (typeof window.Binjgb !== 'function') {
        throw new Error('core loaded but window.Binjgb is missing');
      }
      // Emscripten resolves binjgb.wasm relative to the script URL on its own;
      // say it explicitly so the page still works if the script is inlined or
      // moved.  If the host sends the wrong MIME type for .wasm, emscripten
      // falls back from instantiateStreaming to ArrayBuffer instantiation by
      // itself.
      return window.Binjgb({
        locateFile: function (path) { return CORE_DIR + path; }
      });
    }).then(function (m) {
      $('#corenote').textContent =
        'Core: ' + CORE_NAME + ' ' + CORE_COMMIT.slice(0, 8) + ' (vendored), MIT. MBC3 RTC supported.';
      return m;
    });
  }

  function fetchRom(url) {
    return fetch(url, { cache: 'no-store' }).then(function (r) {
      if (!r.ok) { throw new Error(url + ' -> HTTP ' + r.status); }
      return r.arrayBuffer();
    }).then(function (buf) {
      if (buf.byteLength < 0x8000) { throw new Error(url + ' is too small to be a ROM'); }
      return new Uint8Array(buf);
    });
  }

  function readFile(file) {
    return new Promise(function (resolve, reject) {
      var fr = new FileReader();
      fr.onload = function () { resolve(new Uint8Array(fr.result)); };
      fr.onerror = function () { reject(fr.error || new Error('could not read file')); };
      fr.readAsArrayBuffer(file);
    });
  }

  // ---------------------------------------------------- cartridge header ---

  function titleKeyOf(rom) {
    var t = '';
    for (var i = 0x134; i < 0x144; i++) {
      var c = rom[i];
      if (c >= 0x20 && c <= 0x7e) { t += String.fromCharCode(c); }
    }
    return (t.replace(/[^A-Za-z0-9_.-]/g, '') || 'UNKNOWN') + '-' + rom[0x147].toString(16);
  }

  // -------------------------------------------------------------- state ---

  var mod = null;          // the emscripten Module
  var emu = 0;             // Emulator*
  var romPtr = 0;          // wasm-side copy of the ROM (binjgb does not copy it)
  var rom = null;
  var romSha = null;
  var romTitleKey = null;
  var extRamSize = 0;
  var stateSize = 0;
  var frameView = null;    // Uint8Array over the core's RGBA frame buffer
  var audioView = null;    // Uint8Array over the core's audio buffer

  var started = false;
  var wantPlaying = false;
  var muted = false;
  var fastForward = false;
  var extRamDirty = false;
  var lastSramSig = null;
  var lastResumeWriteMs = 0;
  var audioUnlocked = false;
  var framesSinceStart = 0;

  var RESUME_GUARD = 'kf-resume-pending';

  function batteryKey() { return 'battery:' + romTitleKey; }
  function resumeKey() { return 'resume:' + romTitleKey; }
  function slotKey(n) { return 'state:' + romTitleKey + ':' + n; }

  function sig(bytes) {
    // Cheap change detector (FNV-1a over the whole region).
    var h = 0x811c9dc5;
    for (var i = 0; i < bytes.length; i++) {
      h ^= bytes[i];
      h = (h + ((h << 1) + (h << 4) + (h << 7) + (h << 8) + (h << 24))) >>> 0;
    }
    return h + ':' + bytes.length;
  }

  function ss(key, value) {           // sessionStorage, never fatal
    try {
      if (value === undefined) { return sessionStorage.getItem(key); }
      if (value === null) { sessionStorage.removeItem(key); return null; }
      sessionStorage.setItem(key, value);
      return value;
    } catch (e) { return null; }
  }

  // --------------------------------------------------------- wasm bridge ---

  /* binjgb hands out heap blobs as a FileData struct: a {size, data} pair,
     both malloc'd.  file_data_delete() frees only ->data, so free the struct
     too or a long session dribbles away the fixed 16.5 MB heap. */
  function withFileData(fdPtr, cb) {
    if (!fdPtr) { return null; }
    try {
      var ptr = mod._get_file_data_ptr(fdPtr);
      var size = mod._get_file_data_size(fdPtr);
      return cb(new Uint8Array(mod.HEAPU8.buffer, ptr, size), fdPtr, size);
    } finally {
      mod._file_data_delete(fdPtr);
      mod._free(fdPtr);
    }
  }

  function getExtRam() {
    if (!emu) { return null; }
    return withFileData(mod._ext_ram_file_data_new(emu), function (view, fdPtr) {
      mod._emulator_write_ext_ram(emu, fdPtr);
      return new Uint8Array(view);          // copy out of the wasm heap
    });
  }

  function putExtRam(bytes) {
    if (!emu) { return false; }
    return withFileData(mod._ext_ram_file_data_new(emu), function (view, fdPtr, size) {
      if (!size || bytes.length !== size) { return false; }
      view.set(bytes);
      return mod._emulator_read_ext_ram(emu, fdPtr) === RESULT_OK;
    });
  }

  function getState() {
    if (!emu) { return null; }
    return withFileData(mod._state_file_data_new(emu), function (view, fdPtr) {
      if (mod._emulator_write_state(emu, fdPtr) !== RESULT_OK) { return null; }
      return new Uint8Array(view);
    });
  }

  function putState(bytes) {
    if (!emu) { return false; }
    return withFileData(mod._state_file_data_new(emu), function (view, fdPtr, size) {
      if (!size || bytes.length !== size) { return false; }
      view.set(bytes);
      return mod._emulator_read_state(emu, fdPtr) === RESULT_OK;
    });
  }

  function measureSizes() {
    extRamSize = withFileData(mod._ext_ram_file_data_new(emu), function (v, p, size) { return size; }) || 0;
    stateSize = withFileData(mod._state_file_data_new(emu), function (v, p, size) { return size; }) || 0;
  }

  // -------------------------------------------------------------- audio ---

  var audioCtx = null;
  var audioStartSec = 0;

  function audioContext() {
    if (audioCtx) { return audioCtx; }
    var Ctor = window.AudioContext || window.webkitAudioContext;
    if (!Ctor) { return null; }
    try { audioCtx = new Ctor(); } catch (e) { audioCtx = null; }
    return audioCtx;
  }

  function sampleRate() {
    var ctx = audioContext();
    return ctx ? ctx.sampleRate : 48000;
  }

  /* binjgb's audio buffer is unsigned 8-bit stereo, interleaved, in the core's
     own heap; scale it the way binjgb's demo does.  Mute is done here because
     the prebuilt core is not a GBSTUDIO build, so its _set_audio_channel_mute
     is the no-op stub. */
  function pushAudio() {
    var ctx = audioCtx;
    if (!ctx || !audioUnlocked || muted || fastForward || !audioView) { return; }
    var nowSec = ctx.currentTime;
    var nowPlusLatency = nowSec + AUDIO_LATENCY_SEC;
    audioStartSec = audioStartSec || nowPlusLatency;
    if (audioStartSec < nowSec) {
      audioStartSec = nowPlusLatency;   // we fell behind; resync
      return;
    }
    var buffer = ctx.createBuffer(2, AUDIO_FRAMES, ctx.sampleRate);
    var left = buffer.getChannelData(0);
    var right = buffer.getChannelData(1);
    for (var i = 0; i < AUDIO_FRAMES; i++) {
      left[i] = audioView[2 * i] * VOLUME / 255;
      right[i] = audioView[2 * i + 1] * VOLUME / 255;
    }
    var src = ctx.createBufferSource();
    src.buffer = buffer;
    src.connect(ctx.destination);
    src.start(audioStartSec);
    audioStartSec += AUDIO_FRAMES / ctx.sampleRate;
  }

  // ------------------------------------------------------------ emulator ---

  function destroyEmulator() {
    stopLoop();
    if (emu) { mod._emulator_delete(emu); emu = 0; }
    if (romPtr) { mod._free(romPtr); romPtr = 0; }
    frameView = null;
    audioView = null;
    started = false;
  }

  function createEmulator(bytes) {
    // binjgb wants the ROM padded up to a 32 KB boundary and keeps the
    // pointer, so the buffer has to stay alive for the emulator's lifetime.
    var size = (bytes.length + 0x7fff) & ~0x7fff;
    romPtr = mod._malloc(size);
    if (!romPtr) { throw new Error('out of wasm memory for a ' + size + '-byte ROM'); }
    var heap = new Uint8Array(mod.HEAPU8.buffer, romPtr, size);
    heap.fill(0);
    heap.set(bytes);

    emu = mod._emulator_new_simple(romPtr, size, sampleRate(), AUDIO_FRAMES, CGB_COLOR_CURVE);
    if (!emu) {
      mod._free(romPtr); romPtr = 0;
      throw new Error('binjgb rejected this ROM (unsupported cartridge type?)');
    }
    frameView = new Uint8Array(mod.HEAPU8.buffer,
      mod._get_frame_buffer_ptr(emu), mod._get_frame_buffer_size(emu));
    audioView = new Uint8Array(mod.HEAPU8.buffer,
      mod._get_audio_buffer_ptr(emu), mod._get_audio_buffer_capacity(emu));
    measureSizes();
  }

  // ------------------------------------------------------------ renderer ---

  var ctx2d = null;
  var imageData = null;

  function initRenderer() {
    // Canvas2D on purpose: iOS Safari will not nearest-neighbour-upscale a
    // WebGL canvas (webkit bug 193895) and this is a phone-first page.  The
    // core's frame buffer is already RGBA8 in ImageData byte order.
    ctx2d = canvas.getContext('2d');
    imageData = ctx2d.createImageData(SCREEN_W, SCREEN_H);
  }

  function drawFrame() {
    if (!ctx2d || !frameView) { return; }
    imageData.data.set(frameView);
    ctx2d.putImageData(imageData, 0, 0);
  }

  // ------------------------------------------------------------ run loop ---

  var rafToken = null;
  var lastRafSec = 0;
  var leftoverTicks = 0;

  function ticks() { return mod._emulator_get_ticks_f64(emu); }

  function runUntil(until) {
    var newFrame = false;
    for (;;) {
      var event = mod._emulator_run_until_f64(emu, until);
      if (event & EVENT_NEW_FRAME) { newFrame = true; }
      if (event & EVENT_AUDIO_BUFFER_FULL) { pushAudio(); }
      if (event & EVENT_UNTIL_TICKS) { break; }
    }
    if (mod._emulator_was_ext_ram_updated(emu)) { extRamDirty = true; }
    return newFrame;
  }

  function rafCallback(startMs) {
    rafToken = requestAnimationFrame(rafCallback);
    var startSec = startMs / 1000;
    var deltaSec = Math.max(startSec - (lastRafSec || startSec), 0);
    lastRafSec = startSec;

    var speed = fastForward ? FF_SPEED : 1;
    var deltaTicks = Math.min(deltaSec, MAX_UPDATE_SEC) * speed * CPU_TICKS_PER_SECOND;
    var until = ticks() + deltaTicks - leftoverTicks;
    runUntil(until);
    // Not |0: the tick counter passes 2^31 after about eight minutes of play.
    leftoverTicks = Math.max(ticks() - until, 0);
    drawFrame();

    if (framesSinceStart < 120) {
      framesSinceStart++;
      // Survived long enough that the restored state is clearly not poison.
      if (framesSinceStart === 30) { ss(RESUME_GUARD, null); }
    }
  }

  function startLoop() {
    if (rafToken !== null) { return; }
    lastRafSec = 0;
    leftoverTicks = 0;
    audioStartSec = 0;
    rafToken = requestAnimationFrame(rafCallback);
  }

  function stopLoop() {
    if (rafToken === null) { return; }
    cancelAnimationFrame(rafToken);
    rafToken = null;
  }

  // ------------------------------------------------------------ boot ------

  function boot() {
    var params = new URLSearchParams(window.location.search);
    var romOverride = params.get('rom');

    initRenderer();
    audioContext();            // created suspended on iOS; we need its rate now

    return loadCore().then(function (m) {
      mod = m;
      say('Fetching ROM...');
      if (romOverride) {
        return fetchRom(romOverride).then(function (r) { return { rom: r, from: 'rom= override' }; });
      }
      return fetchRom(DEFAULT_ROM).then(function (r) {
        return { rom: r, from: DEFAULT_ROM };
      }).catch(function (e) {
        console.warn('relative ROM fetch failed', e);
        return kvGet('rom:last').then(function (stash) {
          if (stash && stash.rom && stash.rom.length) {
            return { rom: new Uint8Array(stash.rom), from: 'stored copy' };
          }
          throw e;
        });
      });
    }).then(function (got) {
      return startWithRom(got.rom, got.from);
    }).catch(function (e) {
      // startWithRom reports its own failures; don't overwrite them here.
      if (!(e && e.kfReported)) {
        fail('No ROM loaded', e);
        statusParts.rom = 'put kanto-first.gbc next to index.html, or use Menu > Load ROM file';
        renderStatus(true);
      }
      $('#menu').open = true;
    });
  }

  /* Boot the cartridge.  `resume` false means a deliberate power cycle: the
     saved machine state is discarded and we start from the battery save. */
  function startWithRom(bytes, fromLabel, resume) {
    rom = bytes;
    romTitleKey = titleKeyOf(rom);
    lastSramSig = null;
    lastResumeWriteMs = 0;
    extRamDirty = false;
    framesSinceStart = 0;

    return sha256(rom).then(function (digest) {
      romSha = digest;
      statusParts.rom = rom.length.toLocaleString() + ' bytes  sha256 ' + digest.slice(0, 8) + '  (' + fromLabel + ')';
      renderStatus();
      say('Starting emulator...');

      destroyEmulator();
      createEmulator(rom);

      if (resume === false) { return { mode: 'battery' }; }

      // A resume snapshot that crashed us last time is still marked pending.
      var poisoned = ss(RESUME_GUARD) === '1';
      if (poisoned) { ss(RESUME_GUARD, null); }

      return kvGet(resumeKey()).then(function (entry) {
        var usable = !poisoned && entry && entry.state &&
          entry.state.byteLength === stateSize &&
          entry.core === CORE_COMMIT && entry.romSha === romSha;
        if (usable) {
          ss(RESUME_GUARD, '1');
          if (putState(new Uint8Array(entry.state))) { return { mode: 'resume' }; }
          ss(RESUME_GUARD, null);
        }
        if (poisoned) { console.warn('previous resume snapshot looked unhealthy; ignoring it'); }
        return kvDel(resumeKey()).catch(function () { return null; })
          .then(function () { return { mode: 'battery' }; });
      }).catch(function (e) {
        console.warn('could not read the resume snapshot', e);
        return { mode: 'battery' };
      });
    }).then(function (how) {
      if (how.mode === 'resume') { return how; }
      return kvGet(batteryKey()).then(function (entry) {
        if (entry && entry.ram && entry.ram.length) {
          var ram = normalizeSram(new Uint8Array(entry.ram));
          if (!putExtRam(ram)) { console.warn('battery save did not fit cartridge RAM'); }
          lastSramSig = sig(ram);
        }
        return how;
      }).catch(function (e) {
        console.warn('could not read the battery save', e);
        return how;
      });
    }).then(function (how) {
      started = true;
      wantPlaying = true;
      fitScreen();
      refreshSlotLabels();
      pushJoypad(true);
      say(how.mode === 'resume' ? 'Running (picked up where you left off)' : 'Running');
      if (!audioUnlocked) { overlay.hidden = false; }
      startLoop();
    }).catch(function (e) {
      fail('Emulator failed to start', e);
      if (e && typeof e === 'object') { e.kfReported = true; }
      throw e;
    });
  }

  // ------------------------------------------------------------- saves ----

  function normalizeSram(bytes) {
    var size = extRamSize || bytes.length;
    if (bytes.length === size) { return bytes; }
    var out = new Uint8Array(size);
    out.set(bytes.subarray(0, Math.min(bytes.length, size)));
    return out;
  }

  /* One IndexedDB write covers both halves of "where you were": the battery
     save (portable, what Export writes) and a full machine state (this core
     only, but it is the thing that carries the MBC3 clock). */
  function saveProgress(force) {
    if (!started || !emu) { return Promise.resolve(false); }
    if (!force && !extRamDirty) { return Promise.resolve(false); }
    extRamDirty = false;

    var wantState = force || (Date.now() - lastResumeWriteMs) >= RESUME_MS;
    var ram = null, state = null;
    try {
      ram = getExtRam();
      if (wantState) { state = getState(); }
    } catch (e) {
      console.warn('could not read save data out of the core', e);
      return Promise.resolve(false);
    }
    if (!ram || !ram.length) { return Promise.resolve(false); }

    var s = sig(ram);
    var ramChanged = s !== lastSramSig;
    lastSramSig = s;

    var writes = [];
    if (ramChanged || force) {
      writes.push(kvPut(batteryKey(), { ram: ram, date: Date.now(), title: romTitleKey }));
    }
    if (state) {
      lastResumeWriteMs = Date.now();
      writes.push(kvPut(resumeKey(), {
        state: state, date: Date.now(), core: CORE_COMMIT, romSha: romSha, title: romTitleKey
      }));
    }
    if (!writes.length) { return Promise.resolve(false); }

    return Promise.all(writes).then(function () {
      var d = new Date();
      statusParts.save = 'saved ' + ('0' + d.getHours()).slice(-2) + ':' + ('0' + d.getMinutes()).slice(-2);
      renderStatus();
      return true;
    }).catch(function (e) { console.warn('save failed', e); return false; });
  }

  function download(name, bytes) {
    var blob = new Blob([bytes], { type: 'application/octet-stream' });
    var url = URL.createObjectURL(blob);
    var a = document.createElement('a');
    a.href = url;
    a.download = name;
    a.rel = 'noopener';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    setTimeout(function () { URL.revokeObjectURL(url); }, 4000);
  }

  /* Exported format: raw cartridge RAM, nothing appended.  That is exactly
     what binjgb's own emulator_write_ext_ram() produces and what Delta and
     mGBA read back; emulators that also write a 44/48-byte RTC footer accept
     a footerless file. */
  function exportSav() {
    if (!started) { say('Nothing to export yet', true); return; }
    var ram = getExtRam();
    if (!ram || !ram.length) { say('Could not read cartridge RAM', true); return; }
    download(SAV_NAME, ram);
    say('Exported ' + SAV_NAME + ' (' + ram.length + ' bytes, no RTC footer)');
  }

  /* Accepted formats: raw cartridge RAM, or cartridge RAM followed by an RTC
     footer (VBA/mGBA/Gambatte write 44, 48 or a few other trailer lengths).
     The footer is DROPPED - binjgb keeps its clock in its save state, not in
     the .sav, and there is no supported way to push RTC registers into it - so
     an imported save keeps its progress but starts the clock where this core's
     clock already is. */
  function importSav(file) {
    if (!started) { say('Load a ROM first', true); return; }
    readFile(file).then(function (bytes) {
      var extra = bytes.length - extRamSize;
      var note = extra > 0 ? ' (' + extra + ' trailing bytes dropped - RTC footer not imported)'
        : extra < 0 ? ' (zero-padded)' : '';
      if (extra !== 0) {
        console.warn('imported .sav is ' + bytes.length + ' bytes, cartridge RAM is ' + extRamSize);
      }
      var ram = normalizeSram(bytes);
      if (!putExtRam(ram)) { throw new Error('core refused ' + ram.length + ' bytes of cartridge RAM'); }
      lastSramSig = sig(ram);
      // The imported RAM is now the truth; the old resume snapshot is not.
      return Promise.all([
        kvPut(batteryKey(), { ram: ram, date: Date.now(), title: romTitleKey }),
        kvDel(resumeKey()),
        stashRomIfNeeded()
      ]).then(function () {
        say('Imported ' + file.name + note + ' - rebooting the cartridge...');
        return startWithRom(rom, 'imported save', false);
      });
    }).catch(function (e) { fail('Import failed', e); });
  }

  /* Keep a picker-loaded ROM around so the page can come back after a reload
     without asking for the file again. */
  function stashRomIfNeeded() {
    if (!rom) { return Promise.resolve(); }
    return kvGet('rom:last').then(function (cur) {
      if (cur && cur.title === romTitleKey && cur.rom && cur.rom.length === rom.length) { return null; }
      return kvPut('rom:last', { rom: rom, title: romTitleKey, date: Date.now() });
    }).catch(function () { return null; });
  }

  function saveSlot(n) {
    if (!started) { return; }
    var state;
    try { state = getState(); } catch (e) { fail('Save state failed', e); return; }
    if (!state) { say('Could not read a save state', true); return; }
    kvPut(slotKey(n), { state: state, date: Date.now(), core: CORE_COMMIT, romSha: romSha })
      .then(function () {
        say('Saved state to slot ' + n);
        refreshSlotLabels();
      }).catch(function (e) { fail('Save state failed', e); });
  }

  function loadSlot(n) {
    if (!started) { return; }
    kvGet(slotKey(n)).then(function (entry) {
      if (!entry || !entry.state) { say('Slot ' + n + ' is empty', true); return; }
      if (entry.core !== CORE_COMMIT || entry.state.byteLength !== stateSize) {
        say('Slot ' + n + ' was written by a different emulator core - cannot load it', true);
        return;
      }
      if (entry.romSha && entry.romSha !== romSha) {
        console.warn('slot ' + n + ' was saved on a different ROM build; loading anyway');
      }
      if (!putState(new Uint8Array(entry.state))) {
        say('Slot ' + n + ' would not load', true);
        return;
      }
      lastSramSig = null;
      extRamDirty = true;
      audioStartSec = 0;
      say('Loaded state from slot ' + n);
    }).catch(function (e) { fail('Load state failed', e); });
  }

  function refreshSlotLabels() {
    [1, 2, 3].forEach(function (n) {
      var el = document.querySelector('[data-slotinfo="' + n + '"]');
      kvGet(slotKey(n)).then(function (entry) {
        if (!entry || !entry.date) { el.textContent = 'empty'; return; }
        el.textContent = (entry.core !== CORE_COMMIT ? 'stale: ' : '') + new Date(entry.date).toLocaleString();
      }).catch(function () { el.textContent = 'empty'; });
    });
  }

  /* Reset is a power cycle: keep the battery save, drop the machine state (and
     with it the emulated clock), boot the cartridge from scratch. */
  function resetEmulator() {
    if (!started || !rom) { return; }
    say('Resetting...');
    saveProgress(true).then(function () {
      return kvDel(resumeKey()).catch(function () { return null; });
    }).then(function () {
      return startWithRom(rom, 'reset', false);
    }).catch(function (e) { fail('Reset failed', e); });
  }

  // -------------------------------------------------------------- audio ---

  function unlockAudio() {
    if (audioUnlocked) { return; }
    audioUnlocked = true;
    overlay.hidden = true;
    audioStartSec = 0;
    var ctx = audioContext();
    if (ctx && ctx.resume) { ctx.resume().catch(function () { /* ignore */ }); }
  }

  function setMuted(next) {
    muted = next;
    audioStartSec = 0;
    $('#btn-mute').textContent = 'Sound: ' + (muted ? 'off' : 'on');
  }

  function setFastForward(next) {
    if (fastForward === next) { return; }
    fastForward = next;
    audioStartSec = 0;      // audio is skipped while fast-forwarding
    $('#btn-ff').textContent = 'Speed: ' + (fastForward ? FF_SPEED + '×' : '1×');
  }

  // -------------------------------------------------------------- input ---

  var joypad = { UP: false, DOWN: false, LEFT: false, RIGHT: false, A: false, B: false, START: false, SELECT: false };
  var lastMask = -1;

  function pushJoypad(force) {
    var mask = (joypad.UP ? 1 : 0) | (joypad.DOWN ? 2 : 0) | (joypad.LEFT ? 4 : 0) | (joypad.RIGHT ? 8 : 0) |
      (joypad.A ? 16 : 0) | (joypad.B ? 32 : 0) | (joypad.START ? 64 : 0) | (joypad.SELECT ? 128 : 0);
    if (mask === lastMask && !force) { return; }
    lastMask = mask;
    if (!started || !emu) { return; }
    mod._set_joyp_up(emu, joypad.UP ? 1 : 0);
    mod._set_joyp_down(emu, joypad.DOWN ? 1 : 0);
    mod._set_joyp_left(emu, joypad.LEFT ? 1 : 0);
    mod._set_joyp_right(emu, joypad.RIGHT ? 1 : 0);
    mod._set_joyp_A(emu, joypad.A ? 1 : 0);
    mod._set_joyp_B(emu, joypad.B ? 1 : 0);
    mod._set_joyp_start(emu, joypad.START ? 1 : 0);
    mod._set_joyp_select(emu, joypad.SELECT ? 1 : 0);
  }

  function setDirs(u, d, l, r) {
    joypad.UP = u; joypad.DOWN = d; joypad.LEFT = l; joypad.RIGHT = r;
    dpadEl.classList.toggle('u', u);
    dpadEl.classList.toggle('d', d);
    dpadEl.classList.toggle('l', l);
    dpadEl.classList.toggle('r', r);
    pushJoypad();
  }

  // 8-way from a thumb position, with a dead zone in the middle.
  var SECTORS = [
    [0, 0, 0, 1], [1, 0, 0, 1], [1, 0, 0, 0], [1, 0, 1, 0],
    [0, 0, 1, 0], [0, 1, 1, 0], [0, 1, 0, 0], [0, 1, 0, 1]
  ];

  function dpadAt(x, y) {
    var r = dpadEl.getBoundingClientRect();
    var dx = (x - (r.left + r.width / 2)) / (r.width / 2);
    var dy = (y - (r.top + r.height / 2)) / (r.height / 2);
    if (Math.sqrt(dx * dx + dy * dy) < DEADZONE) { setDirs(false, false, false, false); return; }
    var ang = Math.atan2(-dy, dx) * 180 / Math.PI;
    if (ang < 0) { ang += 360; }
    var s = SECTORS[Math.round(ang / 45) % 8];
    setDirs(!!s[0], !!s[1], !!s[2], !!s[3]);
  }

  var dpadPointer = null;
  dpadEl.addEventListener('pointerdown', function (e) {
    e.preventDefault();
    unlockAudio();
    dpadPointer = e.pointerId;
    try { dpadEl.setPointerCapture(e.pointerId); } catch (err) { /* ignore */ }
    dpadAt(e.clientX, e.clientY);
  });
  dpadEl.addEventListener('pointermove', function (e) {
    if (e.pointerId !== dpadPointer) { return; }
    e.preventDefault();
    dpadAt(e.clientX, e.clientY);
  });
  function endDpad(e) {
    if (e.pointerId !== dpadPointer) { return; }
    dpadPointer = null;
    setDirs(false, false, false, false);
  }
  dpadEl.addEventListener('pointerup', endDpad);
  dpadEl.addEventListener('pointercancel', endDpad);
  dpadEl.addEventListener('lostpointercapture', endDpad);

  Array.prototype.forEach.call(document.querySelectorAll('[data-btn]'), function (el) {
    var name = el.getAttribute('data-btn');
    var owner = null;
    el.addEventListener('pointerdown', function (e) {
      e.preventDefault();
      unlockAudio();
      owner = e.pointerId;
      try { el.setPointerCapture(e.pointerId); } catch (err) { /* ignore */ }
      el.classList.add('on');
      joypad[name] = true;
      pushJoypad();
    });
    function up(e) {
      if (owner !== null && e.pointerId !== owner) { return; }
      owner = null;
      el.classList.remove('on');
      joypad[name] = false;
      pushJoypad();
    }
    el.addEventListener('pointerup', up);
    el.addEventListener('pointercancel', up);
    el.addEventListener('lostpointercapture', up);
    el.addEventListener('contextmenu', function (e) { e.preventDefault(); });
  });

  var KEYS = {
    ArrowUp: 'UP', ArrowDown: 'DOWN', ArrowLeft: 'LEFT', ArrowRight: 'RIGHT',
    KeyZ: 'A', KeyA: 'A', KeyX: 'B', KeyS: 'B',
    Enter: 'START', ShiftLeft: 'SELECT', ShiftRight: 'SELECT'
  };

  window.addEventListener('keydown', function (e) {
    if (e.target && /^(INPUT|TEXTAREA|SELECT)$/.test(e.target.tagName)) { return; }
    if (e.code === 'Space') { e.preventDefault(); setFastForward(true); return; }
    var btn = KEYS[e.code];
    if (!btn) { return; }
    e.preventDefault();
    unlockAudio();
    if (btn === 'UP' || btn === 'DOWN' || btn === 'LEFT' || btn === 'RIGHT') {
      joypad[btn] = true;
      setDirs(joypad.UP, joypad.DOWN, joypad.LEFT, joypad.RIGHT);
    } else {
      joypad[btn] = true;
      pushJoypad();
    }
  });

  window.addEventListener('keyup', function (e) {
    if (e.code === 'Space') { setFastForward(false); return; }
    var btn = KEYS[e.code];
    if (!btn) { return; }
    e.preventDefault();
    joypad[btn] = false;
    if (btn === 'UP' || btn === 'DOWN' || btn === 'LEFT' || btn === 'RIGHT') {
      setDirs(joypad.UP, joypad.DOWN, joypad.LEFT, joypad.RIGHT);
    } else {
      pushJoypad();
    }
  });

  window.addEventListener('blur', function () {
    setDirs(false, false, false, false);
    joypad.A = joypad.B = joypad.START = joypad.SELECT = false;
    pushJoypad();
  });

  // ------------------------------------------------------------- layout ---

  function fitScreen() {
    var wrap = $('#screenwrap');
    var w = wrap.clientWidth - 12;
    var h = wrap.clientHeight - 12;
    if (w <= 0 || h <= 0) { return; }
    var scale = Math.min(w / SCREEN_W, h / SCREEN_H);
    var integer = Math.floor(scale);
    document.documentElement.style.setProperty('--scale', integer >= 1 ? integer : scale.toFixed(3));
  }

  window.addEventListener('resize', fitScreen);
  window.addEventListener('orientationchange', function () { setTimeout(fitScreen, 250); });
  if (window.visualViewport) { window.visualViewport.addEventListener('resize', fitScreen); }

  // Stop iOS rubber-banding / pinch zoom over the play area.
  document.addEventListener('gesturestart', function (e) { e.preventDefault(); });
  document.addEventListener('touchmove', function (e) {
    if (e.target && e.target.closest && e.target.closest('#menu')) { return; }
    if (e.cancelable) { e.preventDefault(); }
  }, { passive: false });

  // ----------------------------------------------------------- lifecycle --

  setInterval(function () { saveProgress(false); }, AUTOSAVE_MS);

  document.addEventListener('visibilitychange', function () {
    if (document.visibilityState === 'hidden') {
      saveProgress(true);
      stopLoop();
      if (audioCtx && audioCtx.suspend) { audioCtx.suspend().catch(function () { /* ignore */ }); }
    } else if (started && wantPlaying) {
      if (audioUnlocked && audioCtx && audioCtx.resume) { audioCtx.resume().catch(function () { /* ignore */ }); }
      startLoop();
    }
  });
  window.addEventListener('pagehide', function () { saveProgress(true); });

  // --------------------------------------------------------------- wiring -

  $('#tapstart').addEventListener('click', unlockAudio);
  overlay.addEventListener('pointerdown', function (e) { e.preventDefault(); unlockAudio(); });
  canvas.addEventListener('pointerdown', unlockAudio);

  $('#btn-mute').addEventListener('click', function () { setMuted(!muted); });
  $('#btn-ff').addEventListener('click', function () { setFastForward(!fastForward); });
  $('#btn-reset').addEventListener('click', resetEmulator);
  $('#btn-export').addEventListener('click', exportSav);
  $('#btn-import').addEventListener('click', function () { $('#file-sav').click(); });
  $('#file-sav').addEventListener('change', function (e) {
    if (e.target.files && e.target.files[0]) { importSav(e.target.files[0]); }
    e.target.value = '';
  });
  $('#btn-rom').addEventListener('click', function () { $('#file-rom').click(); });
  $('#file-rom').addEventListener('change', function (e) {
    var file = e.target.files && e.target.files[0];
    e.target.value = '';
    if (!file) { return; }
    readFile(file).then(function (bytes) {
      return startWithRom(bytes, 'file: ' + file.name).then(stashRomIfNeeded);
    }).catch(function (err) { fail('Could not load that ROM', err); });
  });

  Array.prototype.forEach.call(document.querySelectorAll('[data-save]'), function (el) {
    el.addEventListener('click', function () { saveSlot(el.getAttribute('data-save')); });
  });
  Array.prototype.forEach.call(document.querySelectorAll('[data-load]'), function (el) {
    el.addEventListener('click', function () { loadSlot(el.getAttribute('data-load')); });
  });

  fitScreen();
  boot();
})();
