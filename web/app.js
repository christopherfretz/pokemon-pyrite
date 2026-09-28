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
 * advances it from emulated CPU ticks rather than the host clock, so on its
 * own it stops whenever the tab is closed or backgrounded.  The vendored core
 * is therefore our fork (christopherfretz/binjgb, branch pyrite-rtc), which
 * exports emulator_get/set_rtc_seconds_f64, and the page sets the clock
 * itself (CLK1, re-ruled in CLK2): the game DISPLAYS RTC + the offset it keeps
 * in wStartDay/Hour/Minute/Second (set by Oak's "what time is it?", restored
 * on CONTINUE, nudged by Mom's DST switch), so the page reads that offset and
 * sets the RTC to (local weekday/time - offset) mod 1 week - the congruent
 * value nearest the current RTC, forwards or backwards - whenever it is off by
 * more than CLOCK_SLACK_SEC.  That runs at boot (snapshot or battery), after a
 * slot load or .sav import, when the tab comes back, every CLOCK_POLL_MS, and
 * at once when the offset bytes change.  Result: the in-game clock and weekday
 * read what the phone says.  The phone's local time is the only reference;
 * the `clock:<title>` record is diagnostics.  See syncClock().
 * The .sav is untouched by all of this.
 *
 * We also snapshot a full save state ("resume") next to the battery save and
 * restore it on the next visit, so you pick up mid-route instead of at your
 * last SAVE.  It is keyed by ROM hash + core commit and is only ever an
 * optimisation: if anything about it does not match, we fall back to booting
 * the cartridge with the battery save, exactly as a real Game Boy would.
 *
 * No service worker on purpose: the ROM must always be the freshly hosted one.
 * No navigator.vibrate() anywhere: haptics stay off.
 */
(function () {
  'use strict';

  var CORE_NAME = 'binjgb';
  /* Upstream commit + our fork commit (vendor/binjgb/VERSION.txt).  Stamped on
     every stored machine state. */
  var CORE_COMMIT = 'c60e138da5a795ebb55e56b11b7e90024e41112c+pyrite-rtc@8fb6fda5550d';
  /* Cores whose EmulatorState layout is identical to this one, so their states
     still load: the pyrite-rtc commit adds two functions and touches no struct.
     (The state size check below still guards against a real layout change.) */
  var COMPAT_CORES = ['c60e138da5a795ebb55e56b11b7e90024e41112c'];
  var CORE_DIR = './vendor/binjgb/';
  var CORE_JS = CORE_DIR + 'binjgb.js';
  var DEFAULT_ROM = './kanto-first.gbc';
  var SAV_NAME = 'kanto-first.sav';

  var DB_NAME = 'kanto-first-web';
  var DB_VERSION = 1;
  var STORE = 'kv';

  /* Battery mirror: flushed about a second after the game writes cartridge
     RAM (FLUSH_MS, one coalesced timer), with the 10-second tick as a fallback
     retry. */
  var AUTOSAVE_MS = 10000;
  var FLUSH_MS = 1000;
  /* A full EmulatorState embeds VRAM + WRAM + cartridge RAM (a few hundred KB),
     so the resume snapshot is written on a slower cadence than the battery
     mirror when only the scratch area of SRAM churns - but IMMEDIATELY whenever
     the save region (SAVE_REGION_START..end) changes, so a snapshot is never
     older than an in-game SAVE - plus unconditionally whenever the page is
     backgrounded or closed.  Worst case the clock loses a minute. */
  var RESUME_MS = 60000;
  /* SRAM $a000-$a5ff is sScratch (ram/sram.asm: `ds $60 tiles`), a
     decompression buffer the game churns during normal play.  Everything from
     here on (backup save, main save + checksum, boxes, Hall of Fame...) only
     changes on SAVE / box / event writes. */
  var SAVE_REGION_START = 0x600;
  /* A hung IndexedDB connection (iOS Safari after long backgrounding) must
     not swallow saves silently: every open/transaction gets a deadline. */
  var IDB_TIMEOUT_MS = 8000;
  /* Wall-clock sync of the MBC3 RTC (CLK1/CLK2).  The RTC is re-set when the
     game's displayed time is off local time by more than CLOCK_SLACK_SEC;
     checked every CLOCK_POLL_MS while the page is visible (four WRAM bytes and
     one RTC read), and the diagnostic record is written every CLOCK_SYNC_MS.
     The 9-bit day counter must never
     overflow (that sets day-carry, which the game treats as a dead clock and
     answers with a reset prompt), so long absences fold whole 140-day blocks
     out: 140 days = 20 weeks, the same fold the game's own FixDays does, so the
     weekday is preserved. */
  var CLOCK_SYNC_MS = 30000;
  var CLOCK_POLL_MS = 1000;
  var CLOCK_SLACK_SEC = 2;
  var RTC_DAY_SEC = 86400;
  var RTC_FOLD_SEC = 140 * RTC_DAY_SEC;
  var RTC_MAX_SEC = 400 * RTC_DAY_SEC;
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
      var settled = false;
      var timer = setTimeout(function () {
        if (settled) { return; }
        settled = true;
        reject(new Error('IndexedDB open timed out'));
      }, IDB_TIMEOUT_MS);
      var req = indexedDB.open(name, version);
      req.onupgradeneeded = function (ev) { upgrade(req.result, ev); };
      req.onsuccess = function () {
        var d = req.result;
        if (settled) { try { d.close(); } catch (e) { /* ignore */ } return; }
        settled = true; clearTimeout(timer); resolve(d);
      };
      req.onerror = function () {
        if (settled) { return; }
        settled = true; clearTimeout(timer); reject(req.error);
      };
      req.onblocked = function () {
        if (settled) { return; }
        settled = true; clearTimeout(timer); reject(new Error('IndexedDB blocked'));
      };
    });
  }

  /* The connection is cached, but never trusted forever: a failed open, a
     timed-out transaction, a browser-initiated close or a version change all
     drop it so the next call reopens. */
  var dbPromise = null;
  var dbHandle = null;
  function dropDb(d) {
    if (d && dbHandle !== d) { return; }      // already replaced
    if (dbHandle) { try { dbHandle.close(); } catch (e) { /* ignore */ } }
    dbHandle = null;
    dbPromise = null;
  }
  function db() {
    if (!dbPromise) {
      var p = openDb(DB_NAME, DB_VERSION, function (d) {
        if (!d.objectStoreNames.contains(STORE)) { d.createObjectStore(STORE); }
      }).then(function (d) {
        if (dbPromise !== p) { try { d.close(); } catch (e) { /* ignore */ } return db(); }
        dbHandle = d;
        d.onclose = function () { if (dbHandle === d) { dbHandle = null; dbPromise = null; } };
        d.onversionchange = function () { dropDb(d); };
        return d;
      }, function (e) {
        if (dbPromise === p) { dbPromise = null; }
        throw e;
      });
      dbPromise = p;
    }
    return dbPromise;
  }

  function tx(dbh, store, mode, fn) {
    return new Promise(function (resolve, reject) {
      var done = false;
      var t;
      var timer = setTimeout(function () {
        if (done) { return; }
        done = true;
        try { if (t) { t.abort(); } } catch (e) { /* ignore */ }
        dropDb(dbh);
        reject(new Error('IndexedDB ' + mode + ' timed out'));
      }, IDB_TIMEOUT_MS);
      function finish(ok, val) {
        if (done) { return; }
        done = true;
        clearTimeout(timer);
        if (ok) { resolve(val); } else { reject(val); }
      }
      try {
        t = dbh.transaction(store, mode);
        var req = fn(t.objectStore(store));
        t.oncomplete = function () { finish(true, req ? req.result : undefined); };
        t.onerror = function () { finish(false, t.error || new Error('IndexedDB transaction error')); };
        t.onabort = function () { finish(false, t.error || new Error('IndexedDB transaction aborted')); };
      } catch (e) {
        // InvalidStateError: the connection is closing/closed. Reopen next time.
        dropDb(dbh);
        finish(false, e);
      }
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
        'Core: ' + CORE_NAME + ' ' + CORE_COMMIT.slice(0, 8) + ' + pyrite-rtc ' + CORE_COMMIT.split('@')[1].slice(0, 7) +
        ' (vendored), MIT. MBC3 RTC kept on real time.';
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
  var joypadBuf = 0;       // JoypadBuffer* the core's input callback records into
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
  var lastSaveSig = null;
  var flushTimer = null;
  var saveFailing = false;
  var lastResumeWriteMs = 0;
  var audioUnlocked = false;
  var framesSinceStart = 0;

  var RESUME_GUARD = 'kf-resume-pending';

  function batteryKey() { return 'battery:' + romTitleKey; }
  function resumeKey() { return 'resume:' + romTitleKey; }
  function slotKey(n) { return 'state:' + romTitleKey + ':' + n; }
  function clockKey() { return 'clock:' + romTitleKey; }
  function coreOk(core) { return core === CORE_COMMIT || COMPAT_CORES.indexOf(core) >= 0; }

  function sig(bytes) {
    // Cheap change detector (FNV-1a over the whole region).
    var h = 0x811c9dc5;
    for (var i = 0; i < bytes.length; i++) {
      h ^= bytes[i];
      h = (h + ((h << 1) + (h << 4) + (h << 7) + (h << 8) + (h << 24))) >>> 0;
    }
    return h + ':' + bytes.length;
  }

  // Signature of the save region only (everything past sScratch).  edit.js
  // computes the same thing; keep the two in step.
  function saveSig(ram) {
    return sig(ram.subarray(Math.min(SAVE_REGION_START, ram.length)));
  }

  function hhmm() {
    var d = new Date();
    return ('0' + d.getHours()).slice(-2) + ':' + ('0' + d.getMinutes()).slice(-2);
  }

  function clearFlush() {
    if (flushTimer !== null) { clearTimeout(flushTimer); flushTimer = null; }
  }
  // One pending timer: the first SRAM write in a burst arms it, later ones
  // coalesce into it, so a steady trickle cannot postpone the flush forever.
  function armFlush() {
    if (flushTimer !== null) { return; }
    flushTimer = setTimeout(function () {
      flushTimer = null;
      saveProgress(false);
    }, FLUSH_MS);
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

  // --------------------------------------------------------------- clock ---

  /* The MBC3 RTC as seconds (day*86400 + h*3600 + m*60 + s), or -1 when the
     core or the cartridge has no RTC. */
  function getRtc() {
    if (!emu || !mod._emulator_get_rtc_seconds_f64) { return -1; }
    return mod._emulator_get_rtc_seconds_f64(emu);
  }

  function setRtc(sec) {
    if (!emu || !mod._emulator_set_rtc_seconds_f64) { return false; }
    sec = Math.floor(sec);
    while (sec >= RTC_MAX_SEC) { sec -= RTC_FOLD_SEC; }
    return !!mod._emulator_set_rtc_seconds_f64(emu, Math.max(sec, 0));
  }

  /* Where the game keeps its clock offset.  Displayed time = RTC + wStartDay/
     Hour/Minute/Second (FixTime, home/time.asm): the offset is what Oak's "what
     time is it?" answer set (_InitTime), CONTINUE restores from the save, and
     Mom's DST toggle nudges.  The addresses are found in the ROM itself - the
     FixTime routine's `ld a, [wStartSecond] / [wStartMinute] / [wStartHour] /
     [wStartDay]` operands - so a rebuild that moves WRAM, or a picked ROM, can
     never make the page read the wrong bytes.  null = not found (then the RTC
     alone is put on local time, i.e. offset 0 is assumed). */
  var clockVars = null;

  function findClockVars(bytes) {
    // F0 ss 4F FA <sec> 81 D6 3C 30 02 C6 3C E0 xx 3F  F0 mm 4F FA <min> 89 D6 3C 30 02 C6 3C E0 xx 3F
    // F0 hh 4F FA <hour> 89 D6 18 30 02 C6 18 E0 xx 3F  F0 dd 4F FA <day> 89 EA <wCurDay>
    var P = [0xf0, -1, 0x4f, 0xfa, -1, -1, 0x81, 0xd6, 0x3c, 0x30, 0x02, 0xc6, 0x3c, 0xe0, -1, 0x3f,
             0xf0, -1, 0x4f, 0xfa, -1, -1, 0x89, 0xd6, 0x3c, 0x30, 0x02, 0xc6, 0x3c, 0xe0, -1, 0x3f,
             0xf0, -1, 0x4f, 0xfa, -1, -1, 0x89, 0xd6, 0x18, 0x30, 0x02, 0xc6, 0x18, 0xe0, -1, 0x3f,
             0xf0, -1, 0x4f, 0xfa, -1, -1, 0x89, 0xea, -1, -1];
    var lim = Math.min(bytes.length, 0x4000) - P.length;   // home bank only
    outer: for (var i = 0; i < lim; i++) {
      for (var j = 0; j < P.length; j++) {
        if (P[j] >= 0 && bytes[i + j] !== P[j]) { continue outer; }
      }
      var w = function (o) { return bytes[i + o] | (bytes[i + o + 1] << 8); };
      var v = { sec: w(4), min: w(20), hour: w(36), day: w(52), curDay: w(56) };
      var ok = [v.sec, v.min, v.hour, v.day, v.curDay].every(function (a) { return a >= 0xc000 && a < 0xe000; });
      return ok ? v : null;
    }
    return null;
  }

  /* WRAM by address, independent of the bank the game has switched in right
     now: $c000-$cfff is bank 0, $d000-$dfff is read as bank 1 (where home code
     keeps these variables).  binjgb lays WRAM out as 8 banks of $1000. */
  function readWram(addr, bank) {
    if (!emu || !mod._emulator_get_wram_ptr) { return -1; }
    var off = addr < 0xd000 ? addr - 0xc000 : ((bank || 1) << 12) + (addr - 0xd000);
    return mod.HEAPU8[mod._emulator_get_wram_ptr(emu) + off];
  }
  function writeWram(addr, val, bank) {
    if (!emu || !mod._emulator_get_wram_ptr) { return false; }
    var off = addr < 0xd000 ? addr - 0xc000 : ((bank || 1) << 12) + (addr - 0xd000);
    mod.HEAPU8[mod._emulator_get_wram_ptr(emu) + off] = val & 0xff;
    return true;
  }

  /* The offset {d, h, m, s} the game adds to the RTC, or null if it is not a
     value the game could have written (WRAM before the intro clears it). */
  function readClockOffset() {
    if (!clockVars) { return { d: 0, h: 0, m: 0, s: 0, assumed: true }; }
    var o = { d: readWram(clockVars.day), h: readWram(clockVars.hour),
              m: readWram(clockVars.min), s: readWram(clockVars.sec) };
    if (!(o.d >= 0 && o.d < 140 && o.h >= 0 && o.h < 24 && o.m >= 0 && o.m < 60 && o.s >= 0 && o.s < 60)) {
      return null;
    }
    return o;
  }
  function offsetKey(o) { return o ? o.d + ':' + o.h + ':' + o.m + ':' + o.s : 'invalid'; }

  var WEEK_SEC = 7 * RTC_DAY_SEC;
  function mod7d(x) { return ((x % WEEK_SEC) + WEEK_SEC) % WEEK_SEC; }

  /* Local wall-clock time as seconds into the week (Sunday 00:00 = 0, the
     game's SUNDAY = 0 too), fractional. */
  function localWeekSec(now) {
    var d = new Date(now);
    return d.getDay() * RTC_DAY_SEC + d.getHours() * 3600 + d.getMinutes() * 60 + d.getSeconds() +
      d.getMilliseconds() / 1000;
  }

  /* The RTC value that makes the game DISPLAY local time: congruent to
     local - offset modulo a week, and of those the one closest to the current
     RTC (so the day counter does not jump by weeks for nothing; never below 0). */
  function clockTarget(cur, off, now) {
    var base = mod7d(localWeekSec(now) - (off.d * RTC_DAY_SEC + off.h * 3600 + off.m * 60 + off.s));
    var k = Math.round((cur - base) / WEEK_SEC);
    var want = base + Math.max(k, 0) * WEEK_SEC;
    return want;
  }

  var lastOffsetKey = null;
  var lastClockInfo = null;   // for kfDebug / diagnostics
  var clockAutoSync = true;   // kfDebug can hold it off to stage a skewed clock

  /* CLK2: put the RTC where the game displays the phone's local time.  Called
     at boot (snapshot or battery), after a slot load, when the tab comes back,
     every CLOCK_POLL_MS (drift, fast-forward) and as soon as the game's offset
     changes (CONTINUE, Oak's time prompt, Mom's DST toggle).  Moves either way:
     real time is the only reference. */
  function syncClock(why) {
    if (!started || !emu) { return; }
    var cur = getRtc();
    if (cur < 0) { return; }
    var off = readClockOffset();
    lastOffsetKey = offsetKey(off);
    if (!off) { lastClockInfo = { rtc: cur, offset: null, why: why }; return; }
    var now = Date.now();
    var want = clockTarget(cur, off, now);
    var info = { rtc: cur, target: want, offset: off, local: localWeekSec(now), why: why };
    if (Math.abs(cur - want) > CLOCK_SLACK_SEC) {
      if (setRtc(want)) {
        var d = Math.round(want - cur);
        console.info('clock: ' + (d >= 0 ? '+' : '') + d + ' s (' + why + '; offset ' + offsetKey(off) +
          (off.assumed ? ' assumed' : '') + ')');
        info.jump = d;
        info.rtc = getRtc();
      }
    }
    lastClockInfo = info;
  }

  /* Cheap poll: re-sync at once if the game's offset changed, otherwise only
     if the RTC drifted past the slack (syncClock checks that itself). */
  function pollClock() {
    if (!started || !emu || !clockAutoSync || document.visibilityState === 'hidden') { return; }
    var k = offsetKey(readClockOffset());
    syncClock(k !== lastOffsetKey ? 'offset ' + lastOffsetKey + ' -> ' + k : 'tick');
  }

  /* The record persisted beside the battery mirror.  Diagnostics only since
     CLK2 (local time is the reference); nothing reads it back but the boot log. */
  function clockRecord() {
    if (clockAutoSync) { syncClock('flush'); }
    var cur = getRtc();
    if (cur < 0) { return null; }
    return { rtc: cur, wall: Date.now(), offset: offsetKey(readClockOffset()), title: romTitleKey, core: CORE_COMMIT };
  }

  function writeClock() {
    var rec = clockRecord();
    return rec ? kvPut(clockKey(), rec) : Promise.resolve();
  }

  /* At boot, after the snapshot (or the battery save) is in. */
  function applyStoredClock(rec) {
    lastOffsetKey = null;
    if (rec && typeof rec.rtc === 'number' && typeof rec.wall === 'number') {
      console.info('clock: last record rtc ' + Math.round(rec.rtc) + ' at ' + new Date(rec.wall).toISOString() +
        (rec.offset ? ' offset ' + rec.offset : ''));
    }
    syncClock('boot');
  }

  // -------------------------------------------------------------- audio ---

  var audioCtx = null;
  var audioStartSec = 0;
  var emuRate = 0;              // the rate the emulator was created with (samples are made at it)
  var audioDead = false;        // the current context was caught with a frozen clock: replace it
  var audioNeedsRekick = false; // back from the background: the next gesture replaces the context
  var audioReplaced = 0;        // contexts replaced this session (shown on the Sound button)
  var resumeFailed = false;     // a gesture's resume() left the context not running
  var watchdogArmed = true;     // the stall watchdog may replace a context once per gesture/return
  var stallClock = -1;          // ctx.currentTime at the last live push
  var stallCount = 0;           // consecutive live pushes that saw that clock not move
  var stallSinceMs = 0;         // wall-clock time of the first of them

  /* AU2 (operator, 2026-09-28): on the phone the music died on EVERY return to
     the tab, and taps did not bring it back, while Safari's speaker icon said
     sound was playing - a context that reports 'running' but plays nothing.
     The page cannot see that directly, so every transition is logged with a
     timestamp and the Sound button shows the context's state (the operator
     cannot read an iPhone's console). */
  function audioLog(msg) {
    console.info('[audio ' + new Date().toISOString().slice(11, 23) + '] ' + msg);
  }

  function updateSoundLabel() {
    var el = $('#btn-mute');
    if (!el) { return; }
    var text = 'Sound: ' + (muted ? 'off' : 'on');
    if (audioCtx) { text += ' · ctx ' + (audioDead ? 'dead' : audioCtx.state); }
    if (audioReplaced) { text += ' · new ' + audioReplaced + '×'; }
    el.textContent = text;
  }

  function resetStall() {
    stallClock = -1;
    stallCount = 0;
    stallSinceMs = 0;
  }

  function audioContext() {
    if (audioCtx) { return audioCtx; }
    var Ctor = window.AudioContext || window.webkitAudioContext;
    if (!Ctor) { return null; }
    // Ask a replacement for the emulator's rate (older WebKit rejects the
    // options bag; fall back to the default).
    if (emuRate) {
      try { audioCtx = new Ctor({ sampleRate: emuRate }); } catch (e) { audioCtx = null; }
    }
    if (!audioCtx) {
      try { audioCtx = new Ctor(); } catch (e) { audioCtx = null; }
    }
    if (!audioCtx) { return null; }
    var ctx = audioCtx;
    var onState = function () {
      if (ctx !== audioCtx) { return; }   // a replaced context's last words
      audioLog('state -> ' + ctx.state);
      updateSoundLabel();
    };
    if (ctx.addEventListener) { ctx.addEventListener('statechange', onState); } else { ctx.onstatechange = onState; }
    audioLog('new context, ' + ctx.sampleRate + ' Hz, ' + ctx.state);
    if (emuRate && ctx.sampleRate !== emuRate) {
      console.warn('audio: new context at ' + ctx.sampleRate + ' Hz, emulator runs at ' + emuRate + ' (buffers are resampled)');
    }
    return ctx;
  }

  function sampleRate() {
    var ctx = audioContext();
    return ctx ? ctx.sampleRate : 48000;
  }

  /* Throw the context away and make a fresh one.  Inside a user gesture the
     caller resumes it; outside one (the watchdog) it stays suspended on iOS
     until the next tap's unlockAudio().  close() releases the old one - Safari
     and Chrome cap how many contexts a page may hold. */
  function replaceAudioContext(why) {
    var old = audioCtx;
    audioCtx = null;
    if (old && old.close && old.state !== 'closed') {
      try { old.close().catch(function () { /* ignore */ }); } catch (e) { /* ignore */ }
    }
    audioDead = false;
    audioNeedsRekick = false;
    resumeFailed = false;
    audioStartSec = 0;
    resetStall();
    audioReplaced++;
    var ctx = audioContext();
    console.warn('audio: context replaced (' + why + '), now ' + (ctx ? ctx.state : 'none'));
    updateSoundLabel();
    return ctx;
  }

  /* The stall watchdog: on a live context the clock moves ~93 ms between two
     pushes.  WebKit can hand a context back from the background 'running' with
     a clock that never moves; every buffer is then scheduled against a frozen
     now and none of them ever plays.  Ten stalled pushes spanning a real second
     = dead.  Only live pushes count (muted / fast-forward / hidden skip this),
     and a fresh schedule (audioStartSec === 0) starts a fresh count, so a
     paused loop or a mute toggle never looks like a stall. */
  function audioStalled(ctx) {
    if (document.visibilityState !== 'visible') { resetStall(); return false; }
    var t = ctx.currentTime;
    var nowMs = Date.now();
    if (stallClock < 0 || t !== stallClock) {
      stallClock = t;
      stallCount = 0;
      stallSinceMs = nowMs;
      return false;
    }
    stallCount++;
    if (stallCount < 10 || nowMs - stallSinceMs < 1000) { return false; }
    console.warn('audio: context says running but its clock is stuck at ' + t + ' s');
    audioDead = true;
    resetStall();
    audioStartSec = 0;
    if (watchdogArmed) {
      watchdogArmed = false;        // once per gesture/return: no replacement churn
      replaceAudioContext('clock stuck');
    } else {
      updateSoundLabel();           // the next gesture replaces it
    }
    return true;
  }

  /* binjgb's audio buffer is unsigned 8-bit stereo, interleaved, in the core's
     own heap; scale it the way binjgb's demo does.  Mute is done here because
     the prebuilt core is not a GBSTUDIO build, so its _set_audio_channel_mute
     is the no-op stub. */
  function pushAudio() {
    var ctx = audioCtx;
    if (!ctx || !audioUnlocked || muted || fastForward || !audioView || audioDead) { return; }
    if (ctx.state !== 'running') { audioStartSec = 0; resetStall(); return; }   // don't queue a backlog on a stopped context
    if (!audioStartSec) { resetStall(); }
    if (audioStalled(ctx)) { return; }
    var nowSec = ctx.currentTime;
    var nowPlusLatency = nowSec + AUDIO_LATENCY_SEC;
    audioStartSec = audioStartSec || nowPlusLatency;
    if (audioStartSec < nowSec) {
      audioStartSec = nowPlusLatency;   // we fell behind; resync
      return;
    }
    // Made at the emulator's rate, not the context's: a replacement context
    // at another rate then resamples instead of pitch-shifting.
    var buffer = ctx.createBuffer(2, AUDIO_FRAMES, emuRate || ctx.sampleRate);
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
    audioStartSec += buffer.duration;
  }

  // ------------------------------------------------------------ emulator ---

  function destroyEmulator() {
    stopLoop();
    clearFlush();
    if (emu) { mod._emulator_delete(emu); emu = 0; }
    if (joypadBuf) { mod._joypad_delete(joypadBuf); joypadBuf = 0; }
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

    emuRate = sampleRate();
    emu = mod._emulator_new_simple(romPtr, size, emuRate, AUDIO_FRAMES, CGB_COLOR_CURVE);
    if (!emu) {
      mod._free(romPtr); romPtr = 0;
      throw new Error('binjgb rejected this ROM (unsupported cartridge type?)');
    }
    // emulator_new_simple installs NO joypad callback: set_joyp_* only write
    // a static that default_joypad_callback copies from, and that callback is
    // installed by this call (wrapper.c).  Without it every button is dead
    // while the game runs on happily — the first real-browser bug (2026-09-19).
    installJoypad();
    frameView = new Uint8Array(mod.HEAPU8.buffer,
      mod._get_frame_buffer_ptr(emu), mod._get_frame_buffer_size(emu));
    audioView = new Uint8Array(mod.HEAPU8.buffer,
      mod._get_audio_buffer_ptr(emu), mod._get_audio_buffer_capacity(emu));
    measureSizes();
  }

  /* The callback appends every button change to a JoypadBuffer (binjgb keeps
     it for rewind, which we never use).  The heap is fixed-size, so recycle
     the buffer now and then instead of letting it grow for a whole session. */
  function installJoypad() {
    if (joypadBuf) { mod._joypad_delete(joypadBuf); joypadBuf = 0; }
    joypadBuf = mod._joypad_new();
    if (!joypadBuf) { throw new Error('out of wasm memory for the joypad buffer'); }
    mod._emulator_set_default_joypad_callback(emu, joypadBuf);
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

  /* VT1 (operator screenshot, 2026-09-28): walking past the Pokemon Center
     tore it sideways - its lower tile rows lagged its upper ones.  The loop
     runs the core for a wall-clock tick budget, which usually stops the CPU
     mid-frame, and binjgb draws scanline by scanline into ONE buffer, so
     copying it after the budget blitted the top of the new frame over the
     bottom of the old one.  So the frame is captured at the core's own frame
     boundary instead: run_until returns on EVENT_NEW_FRAME as LY reaches 144
     (VBlank; or right after the display-off clear), when all 144 lines are
     done.  The last capture of a rAF wins (fast-forward, catch-up). */
  var frameCaptured = false;
  var frameStats = null;     // ?debug=1 only: {captured, drawn, badLy}

  function captureFrame() {
    if (!imageData || !frameView) { return; }
    imageData.data.set(frameView);
    frameCaptured = true;
    if (frameStats) {
      frameStats.captured++;
      var ly = mod._emulator_read_mem(emu, 0xff44);
      if (ly !== 144 && ly !== 0) { frameStats.badLy++; }   // 0 = display just switched off
    }
  }

  /* Blit the last captured frame, once.  force: nothing captured yet (e.g. a
     state just loaded) - copy the live buffer rather than show nothing. */
  function drawFrame(force) {
    if (!ctx2d || !frameView) { return; }
    if (!frameCaptured) {
      if (!force) { return; }
      imageData.data.set(frameView);
    }
    ctx2d.putImageData(imageData, 0, 0);
    frameCaptured = false;
    if (frameStats) { frameStats.drawn++; }
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
      if (event & EVENT_NEW_FRAME) { newFrame = true; captureFrame(); }
      if (event & EVENT_AUDIO_BUFFER_FULL) { pushAudio(); }
      if (event & EVENT_UNTIL_TICKS) { break; }
    }
    if (mod._emulator_was_ext_ram_updated(emu)) { extRamDirty = true; armFlush(); }
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
    clockVars = findClockVars(rom);
    if (!clockVars) { console.warn('clock: FixTime not found in this ROM; assuming a zero clock offset'); }
    lastSramSig = null;
    lastSaveSig = null;
    lastResumeWriteMs = 0;
    extRamDirty = false;
    clearFlush();
    framesSinceStart = 0;
    var wantResume = resume !== false;
    var poisoned = false;
    var storedClock = null;

    return sha256(rom).then(function (digest) {
      romSha = digest;
      statusParts.rom = rom.length.toLocaleString() + ' bytes  sha256 ' + digest.slice(0, 8) + '  (' + fromLabel + ')';
      renderStatus();
      say('Starting emulator...');

      destroyEmulator();
      createEmulator(rom);

      if (wantResume) {
        // A resume snapshot that crashed us last time is still marked pending.
        poisoned = ss(RESUME_GUARD) === '1';
        if (poisoned) { ss(RESUME_GUARD, null); }
      }

      // Read both records up front: the battery save is the source of truth,
      // and it decides whether the snapshot is still worth restoring.
      return Promise.all([
        kvGet(batteryKey()).catch(function (e) {
          console.warn('could not read the battery save', e);
          return null;
        }),
        wantResume ? kvGet(resumeKey()).catch(function (e) {
          console.warn('could not read the resume snapshot', e);
          return null;
        }) : null,
        kvGet(clockKey()).catch(function (e) {
          console.warn('could not read the clock record', e);
          return null;
        })
      ]);
    }).then(function (got) {
      var battery = got[0];
      var entry = got[1];
      storedClock = got[2];
      if (!(battery && battery.ram && battery.ram.length)) { battery = null; }
      var batteryRam = battery ? normalizeSram(new Uint8Array(battery.ram)) : null;
      var how = { mode: 'battery', stale: false };
      if (!wantResume) { return { how: how, ram: batteryRam }; }

      var usable = !poisoned && entry && entry.state &&
        entry.state.byteLength === stateSize &&
        coreOk(entry.core) && entry.romSha === romSha;
      var batteryNewer = !!(battery && entry && typeof battery.date === 'number' &&
        typeof entry.date === 'number' && battery.date > entry.date);

      // Precedence rule, cheap form: both records carry the save-region
      // signature, so we can tell without restoring anything.
      if (usable && battery && battery.saveSig && entry.saveSig &&
          battery.saveSig !== entry.saveSig && batteryNewer) {
        usable = false;
        how.stale = true;
      }
      if (usable) {
        ss(RESUME_GUARD, '1');
        if (putState(new Uint8Array(entry.state))) {
          how.mode = 'resume';
          // Old records without saveSig: compare the restored cartridge RAM
          // against the battery save directly.
          if (battery && !(battery.saveSig && entry.saveSig) && batteryNewer) {
            var restored = getExtRam();
            if (restored && saveSig(restored) !== saveSig(batteryRam)) {
              ss(RESUME_GUARD, null);
              destroyEmulator();
              createEmulator(rom);
              how.mode = 'battery';
              how.stale = true;
            }
          }
        } else {
          ss(RESUME_GUARD, null);
        }
      }
      if (how.mode === 'resume') { return { how: how, ram: null }; }
      if (how.stale) {
        console.warn('the resume snapshot predates the newer battery save; discarding it');
      } else if (poisoned) {
        console.warn('previous resume snapshot looked unhealthy; ignoring it');
      }
      if (!entry) { return { how: how, ram: batteryRam }; }
      return kvDel(resumeKey()).catch(function () { return null; })
        .then(function () { return { how: how, ram: batteryRam }; });
    }).then(function (r) {
      var how = r.how;
      if (how.mode === 'battery' && r.ram) {
        if (!putExtRam(r.ram)) { console.warn('battery save did not fit cartridge RAM'); }
        lastSramSig = sig(r.ram);
        lastSaveSig = saveSig(r.ram);
      }
      started = true;
      wantPlaying = true;
      applyStoredClock(storedClock);
      storedClock = null;
      writeClock().catch(function (e) { console.warn('could not write the clock record', e); });
      fitScreen();
      refreshSlotLabels();
      pushJoypad(true);
      say(how.mode === 'resume' ? 'Running (picked up where you left off)'
        : how.stale ? 'Booted from your last SAVE - the resume snapshot was older'
        : 'Running');
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
     only, but it is the thing that carries the MBC3 clock).  Both records
     carry saveSig so the boot path can tell whether the snapshot predates an
     in-game SAVE (see startWithRom). */
  function saveProgress(force) {
    if (!started || !emu) { return Promise.resolve(false); }
    if (!force && !extRamDirty) { return Promise.resolve(false); }
    extRamDirty = false;

    var ram = null, state = null;
    try {
      ram = getExtRam();
    } catch (e) {
      console.warn('could not read cartridge RAM out of the core', e);
      extRamDirty = true;
      return Promise.resolve(false);
    }
    if (!ram || !ram.length) { extRamDirty = true; return Promise.resolve(false); }

    var s = sig(ram);
    var sv = saveSig(ram);
    var ramChanged = s !== lastSramSig;
    var saveChanged = sv !== lastSaveSig;
    // The machine state is written whenever the save region changed (so the
    // snapshot is never older than a SAVE), on the 60 s cadence for scratch
    // churn, and always when forced (page hidden / closing).
    var wantState = force || saveChanged || (Date.now() - lastResumeWriteMs) >= RESUME_MS;
    if (wantState) {
      try { state = getState(); } catch (e) {
        console.warn('could not read the machine state out of the core', e);
        state = null;
      }
    }
    lastSramSig = s;
    lastSaveSig = sv;

    var now = Date.now();
    var writes = [];
    if (ramChanged || force) {
      writes.push(kvPut(batteryKey(), { ram: ram, date: now, title: romTitleKey, saveSig: sv }));
    }
    if (state) {
      lastResumeWriteMs = now;
      writes.push(kvPut(resumeKey(), {
        state: state, date: now, core: CORE_COMMIT, romSha: romSha, title: romTitleKey, saveSig: sv
      }));
    }
    if (!writes.length) { return Promise.resolve(false); }
    var clock = clockRecord();
    if (clock) { writes.push(kvPut(clockKey(), clock)); }

    return Promise.all(writes).then(function () {
      statusParts.save = 'saved ' + hhmm();
      if (saveFailing) {
        saveFailing = false;
        say('Saving to browser storage works again');
      } else {
        renderStatus();
      }
      return true;
    }).catch(function (e) {
      console.warn('save failed', e);
      // Never believe the mirror is current after a failed or hung write:
      // forget what we "wrote" so the next tick writes everything again.
      lastSramSig = null;
      lastSaveSig = null;
      lastResumeWriteMs = 0;
      extRamDirty = true;
      statusParts.save = 'SAVE FAILED ' + hhmm() + ' - export .sav';
      if (!saveFailing) {
        saveFailing = true;
        say('Could not write your save to browser storage - use Menu > Export .sav to keep it', true);
      } else {
        renderStatus(true);
      }
      return false;
    });
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
     The footer is DROPPED - this page sets the RTC from the phone's local
     time (syncClock), not from the file - so an imported save keeps its
     progress and shows local time once it is CONTINUEd. */
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
      lastSaveSig = saveSig(ram);
      // The imported RAM is now the truth; the old resume snapshot is not.
      return Promise.all([
        kvPut(batteryKey(), { ram: ram, date: Date.now(), title: romTitleKey, saveSig: saveSig(ram) }),
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
      if (!coreOk(entry.core) || entry.state.byteLength !== stateSize) {
        say('Slot ' + n + ' was written by a different emulator core - cannot load it', true);
        return;
      }
      // A state embeds WRAM pointers into the ROM's banks, so a state from
      // another build can corrupt the map the moment it loads.  The battery
      // save (in-game SAVE) is what carries progress across builds.
      if (entry.romSha && entry.romSha !== romSha) {
        say('Slot ' + n + ' was saved on an older ROM build - use the in-game SAVE to carry progress across builds', true);
        return;
      }
      if (!putState(new Uint8Array(entry.state))) {
        say('Slot ' + n + ' would not load', true);
        return;
      }
      // The state carries the clock it was saved with; real time moved on.
      syncClock('slot ' + n);
      lastSramSig = null;
      lastSaveSig = null;
      extRamDirty = true;
      armFlush();
      audioStartSec = 0;
      say('Loaded state from slot ' + n);
    }).catch(function (e) { fail('Load state failed', e); });
  }

  function refreshSlotLabels() {
    [1, 2, 3].forEach(function (n) {
      var el = document.querySelector('[data-slotinfo="' + n + '"]');
      kvGet(slotKey(n)).then(function (entry) {
        if (!entry || !entry.date) { el.textContent = 'empty'; return; }
        var stale = !coreOk(entry.core) || (entry.romSha && romSha && entry.romSha !== romSha);
        el.textContent = (stale ? 'stale (older build): ' : '') + new Date(entry.date).toLocaleString();
      }).catch(function () { el.textContent = 'empty'; });
    });
  }

  /* Reset is a power cycle: keep the battery save, drop the machine state,
     boot the cartridge from scratch.  The boot sync puts the RTC back on
     local time, as a cartridge's clock would have kept running. */
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

  /* Called from every user gesture (tap, key; once unlocked, also every
     touchend / pointerup / click on the page, because WebKit only counts some
     of those as the activation a resume() needs).  The first call is the audio
     unlock; later calls re-kick or replace a context that stopped playing
     behind our back.
     AU1 (2026-09-27) resumed a non-running context here and replaced a closed
     one.  It did not help: the operator (2026-09-28) lost the music on EVERY
     return to the tab, even after a second away, with Safari's speaker icon
     still lit.  Hypothesis: our own suspend() on hidden followed by a
     non-gesture resume() on visible - WebKit flips the state back to
     'running' without reconnecting the output.  So the hidden handler no
     longer suspends, and the first gesture after a return REPLACES the
     context, whatever it claims: a running-but-silent context cannot be told
     apart from a healthy one (its clock may even move), and a fresh context
     resumed inside a gesture is the one thing iOS reliably plays.  The cost
     elsewhere is a ~0.1 s gap on the first tap/key after a tab switch.
     A context is also replaced here when it is closed, when the watchdog
     caught its clock stuck, or when the last gesture's resume() left it not
     running ('interrupted' on iOS). */
  function unlockAudio() {
    var first = !audioUnlocked;
    audioUnlocked = true;
    overlay.hidden = true;
    watchdogArmed = true;
    var ctx = audioContext();
    if (!ctx) { return; }
    var why = null;
    if (ctx.state === 'closed') { why = 'closed'; }
    else if (audioDead) { why = 'clock stuck'; }
    else if (audioNeedsRekick) { why = 'first tap after returning to the tab'; }
    else if (resumeFailed && ctx.state !== 'running') { why = 'still ' + ctx.state + ' after a tap'; }
    if (why) {
      ctx = replaceAudioContext(why);
      if (!ctx) { return; }
    }
    if (first || why || ctx.state !== 'running') {
      audioStartSec = 0;
      if (ctx.resume) {
        var c = ctx;
        c.resume().then(function () {
          if (c !== audioCtx) { return; }
          resumeFailed = c.state !== 'running';
          if (resumeFailed) { audioLog('context ' + c.state + ' after a tap\'s resume()'); }
          updateSoundLabel();
        }).catch(function (e) {
          if (c !== audioCtx) { return; }
          resumeFailed = true;
          audioLog('a tap\'s resume() was rejected: ' + e);
        });
      }
    }
    updateSoundLabel();
  }

  /* After the tab comes back: restart the schedule, try a plain resume if the
     context is not running (enough on desktop), and probe that its clock
     moves; a context whose clock is stuck is replaced now.  Either way the
     next gesture replaces it once more (audioNeedsRekick, see unlockAudio);
     the probe does not clear that, because a moving clock does not prove
     that anything is audible. */
  function resumeAudio() {
    audioStartSec = 0;
    resetStall();
    watchdogArmed = true;
    var ctx = audioCtx;
    if (!audioUnlocked || !ctx) { updateSoundLabel(); return; }
    audioNeedsRekick = true;
    audioLog('back to the tab, context ' + ctx.state);
    if (ctx.state === 'closed') { replaceAudioContext('closed while away'); audioNeedsRekick = true; return; }
    var probe = function () {
      if (ctx !== audioCtx || ctx.state !== 'running') { updateSoundLabel(); return; }
      var t0 = ctx.currentTime;
      setTimeout(function () {
        if (ctx !== audioCtx || document.visibilityState !== 'visible' || ctx.state !== 'running') { return; }
        if (ctx.currentTime === t0) {
          console.warn('audio: back-to-tab probe: running but the clock is stuck at ' + t0 + ' s');
          watchdogArmed = false;
          replaceAudioContext('clock stuck after return');
          audioNeedsRekick = true;
        } else {
          audioLog('back-to-tab probe: clock moved ' + t0.toFixed(3) + ' -> ' + ctx.currentTime.toFixed(3));
        }
      }, 400);
    };
    if (ctx.state !== 'running' && ctx.resume) {
      ctx.resume().then(function () {
        if (ctx !== audioCtx) { return; }
        if (ctx.state !== 'running') { audioLog('context ' + ctx.state + ' after resume(); waiting for a tap'); }
        probe();
      }).catch(function (e) { audioLog('resume() on return rejected: ' + e); });
    } else {
      probe();
    }
    updateSoundLabel();
  }

  function setMuted(next) {
    muted = next;
    audioStartSec = 0;
    resetStall();
    updateSoundLabel();
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
  // iOS Safari decides double-tap zoom, text selection and the magnifier
  // loupe from the *touch* events, and preventDefault on pointerdown does not
  // reach them (operator report 2026-09-19: the d-pad zoomed the page on a
  // double tap and brought up the loupe on a long press).  Cancel the raw
  // touch events on the whole control pad; pointer events still fire first,
  // so the joypad handlers above are unaffected.
  var padEl = document.getElementById('pad');
  if (padEl) {
    ['touchstart', 'touchend', 'touchmove', 'touchcancel'].forEach(function (t) {
      padEl.addEventListener(t, function (e) {
        if (e.cancelable) { e.preventDefault(); }
      }, { passive: false });
    });
  }
  document.addEventListener('touchmove', function (e) {
    if (e.target && e.target.closest && e.target.closest('#menu')) { return; }
    if (e.cancelable) { e.preventDefault(); }
  }, { passive: false });

  // ----------------------------------------------------------- lifecycle --

  setInterval(function () {
    saveProgress(false);
    if (started && emu) { installJoypad(); }   // drop the recorded-input log
  }, AUTOSAVE_MS);

  // The RTC follows emulated time (slow when rAF is throttled, fast under
  // fast-forward, and binjgb's latch drops a frame a second), and the game's
  // offset changes on CONTINUE / the time prompt / DST: keep it on local time.
  setInterval(pollClock, CLOCK_POLL_MS);
  setInterval(function () {
    if (!started || document.visibilityState === 'hidden') { return; }
    writeClock().catch(function (e) { console.warn('could not write the clock record', e); });
  }, CLOCK_SYNC_MS);

  // A menu that is open when the emulator (re)starts shrinks #screenwrap, and
  // closing it fires no resize event — so refit when it toggles.
  $('#menu').addEventListener('toggle', function () { setTimeout(fitScreen, 0); });

  document.addEventListener('visibilitychange', function () {
    if (document.visibilityState === 'hidden') {
      saveProgress(true);
      stopLoop();
      // No audioCtx.suspend() any more (AU2, 2026-09-28): WebKit's non-gesture
      // resume() of a page-suspended context came back 'running' but silent.
      // iOS pauses the context itself; the stopped loop queues nothing.
      audioStartSec = 0;
      resetStall();
    } else if (started && wantPlaying) {
      // iOS freezes the page in the background; the phone's clock did not.
      syncClock('back to the tab');
      resumeAudio();
      startLoop();
    }
  });
  window.addEventListener('pagehide', function () { saveProgress(true); });
  // Page Lifecycle: a frozen tab may be discarded without another event.
  document.addEventListener('freeze', function () { saveProgress(true); });

  // --------------------------------------------------------------- wiring -

  $('#tapstart').addEventListener('click', unlockAudio);
  overlay.addEventListener('pointerdown', function (e) { e.preventDefault(); unlockAudio(); });
  canvas.addEventListener('pointerdown', unlockAudio);
  // Once unlocked, every gesture re-checks the audio (AU2): WebKit grants a
  // resume() on touchend / pointerup / click / keydown, not on a touch's
  // pointerdown, which is all the pad buttons listen to.
  ['touchend', 'pointerup', 'click', 'keydown'].forEach(function (type) {
    document.addEventListener(type, function () { if (audioUnlocked) { unlockAudio(); } }, true);
  });

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

  /* ?debug=1: a read-mostly handle for the headless clock test
     (scripts/web_clock_check.py in the helper repo).  Never used by the page. */
  if (/[?&]debug=1(&|$)/.test(window.location.search)) {
    window.kfDebug = {
      rtc: getRtc,
      setRtc: function (s) { return setRtc(s); },
      sync: function (why) { syncClock(why || 'debug'); return getRtc(); },
      /* last sync: {rtc, target, offset {d,h,m,s}, local (s into the week), jump?, why} */
      clockInfo: function () { return lastClockInfo; },
      clockVars: function () { return clockVars; },
      offset: readClockOffset,
      localWeekSec: function () { return localWeekSec(Date.now()); },
      autoSync: function (on) { clockAutoSync = !!on; return clockAutoSync; },
      readWram: function (addr, bank) { return readWram(addr, bank); },
      writeWram: function (addr, val, bank) { return writeWram(addr, val, bank); },
      flush: function () { return saveProgress(true); },
      readMem: function (addr) { return emu ? mod._emulator_read_mem(emu, addr) : -1; },
      running: function () { return started && rafToken !== null; },
      /* VT1: {captured, drawn, badLy}; canvasMatchesCapture() is true when the
         canvas shows exactly the last frame captured at a frame boundary. */
      frames: function () { frameStats = frameStats || { captured: 0, drawn: 0, badLy: 0 }; return frameStats; },
      canvasMatchesCapture: function () {
        var px = ctx2d.getImageData(0, 0, SCREEN_W, SCREEN_H).data;
        var ref = imageData.data;
        for (var i = 0; i < px.length; i++) { if (px[i] !== ref[i]) { return false; } }
        return true;
      },
      liveEqualsCapture: function () {
        var ref = imageData.data;
        for (var i = 0; i < ref.length; i++) { if (frameView[i] !== ref[i]) { return false; } }
        return true;
      },
      audio: function () {
        return { state: audioCtx ? audioCtx.state : null, time: audioCtx ? audioCtx.currentTime : null,
          dead: audioDead, rekick: audioNeedsRekick, replaced: audioReplaced, unlocked: audioUnlocked,
          rate: audioCtx ? audioCtx.sampleRate : null, emuRate: emuRate, label: $('#btn-mute').textContent };
      },
      core: CORE_COMMIT
    };
  }

  fitScreen();
  boot();
})();
