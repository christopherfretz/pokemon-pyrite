# Kanto First — browser player

A static, self-hostable web page that plays the Kanto-first Game Boy Color ROM
hack in a phone browser: touch controls, sound, battery saves that persist, a
working **MBC3 real-time clock** (so day/night and time-gated events behave),
and `.sav` export/import that round-trips with Delta.

No build step, no framework, no bundler, no service worker. Copy the folder to
any static host, drop the ROM next to `index.html`, done.

This folder lives in the public ROM-source repo
<https://github.com/christopherfretz/pokemon-pyrite> under `web/`, next to the
ROM source it plays. `make crystal` at the repo root builds `pokecrystal.gbc`.

---

## Files

| File | Purpose |
| --- | --- |
| `index.html` | the page |
| `app.js` | all the logic (core loading, ROM loading, input, saves) |
| `style.css` | portrait + landscape layouts (player **and** editor) |
| `edit.html`, `edit.js` | the save editor (see below) |
| `gen_tables.py` | generates `tables.json` from the build — run by `make crystal` |
| `tables.json` | **derived, git-ignored** — symbol/constant tables the editor needs |
| `presets/*.sav`, `presets/manifest.json` | starting-point saves from the test harness |
| `manifest.webmanifest`, `icon-192.png`, `icon-512.png` | PWA / add-to-home-screen |
| `server.py` | optional minimal self-host server (stdlib only) |
| `vendor/binjgb/binjgb.js` | the emulator core's emscripten loader, vendored (13 KB) |
| `vendor/binjgb/binjgb.wasm` | the emulator core itself, vendored (86 KB) |
| `vendor/binjgb/LICENSE` | binjgb's licence (MIT) |
| `vendor/binjgb/LICENSE.gbstudio` | the extra MIT notice upstream ships beside `docs/` |
| `vendor/binjgb/VERSION.txt` | upstream commit, SHA-256s and refresh recipe |
| `kanto-first.gbc` | **you add this** — never committed |

---

## Hosting it

### Any static host

1. Copy the whole `web/` folder to the host.
2. Put the ROM next to `index.html`, named exactly `kanto-first.gbc`.
3. Open the page. That is the entire setup.

Everything is referenced with relative paths, so it works from a subdirectory
(`https://example.com/games/kanto/`) just as well as from a domain root.
It must be served over **HTTP(S)** — `file://` will not work, because the core
is a `.wasm` file fetched at runtime and the ROM is fetched too.

The host must send `Content-Type: application/wasm` for `vendor/binjgb/binjgb.wasm`.
Every mainstream static host already does; `server.py` does. If yours does not,
the emscripten loader falls back from `WebAssembly.instantiateStreaming()` to a
plain `ArrayBuffer` instantiation, which still works but logs a warning.

### GitHub Pages

```bash
# in a repo that has this folder as web/
git subtree push --prefix web origin gh-pages     # or simply: Settings → Pages → /web on main
```

GitHub Pages cannot host the ROM for you if the repo is public and you do not
want to publish the ROM, so either:

- keep the Pages repo **private** (Pages works on private repos for paid plans), or
- host the page on Pages and pass the ROM from elsewhere with
  `?rom=https://host.example/kanto-first.gbc` — that host must send
  `Access-Control-Allow-Origin: *`, or
- host page + ROM together somewhere else (`server.py`, a VPS, Cloudflare Pages…).

A release asset URL **will not work** as `?rom=`: GitHub's release download
redirects to a storage host that does not send permissive CORS headers for
cross-origin `fetch()`. Download the asset and host the file yourself.

### `server.py` (minimal self-host)

```bash
python3 server.py --rom kanto-first.gbc           # http://127.0.0.1:8080/
python3 server.py --rom ../pokecrystal.gbc --host 0.0.0.0 --port 8080
```

Standard library only, no dependencies, no state on disk. It reads an explicit
allowlist of files plus the ROM into memory at startup and serves only those;
the URL is never turned into a filesystem path, so there is no directory
listing and nothing to traverse. `GET`/`HEAD` only, everything else 404/501.
(The allowlist is fixed but not hand-written for the presets: every file under
`presets/` is picked up at startup, so a regenerated preset set needs a server
restart, not a code edit. Same for `tables.json` and `edit.js` — **the server
caches file contents, so restart it after any edit** or you will test the old
build.)
The page and the ROM are sent `Cache-Control: no-store`, so a phone always gets
the freshly hosted build. It refuses to start if the ROM is missing.

TLS, authentication and public exposure are the host's job — put it behind a
reverse proxy (Caddy, nginx, a Cloudflare Tunnel) rather than binding it to
`0.0.0.0` on the open internet.

### Where the ROM comes from

`scripts/release_rom.sh` (in the private helper repo `pokemon-romhack-helper`,
where this repo is checked out as the submodule `hack/`) uploads the built
`pokecrystal.gbc` to this repo's rolling GitHub pre-release `latest` under the
fixed name **`kanto-first.gbc`** — the same name this page fetches. So the
deploy loop, run from the helper repo, is:

```bash
make -C hack crystal                 # builds hack/pokecrystal.gbc
scripts/release_rom.sh "what is playable"
gh release download latest -p kanto-first.gbc -D /path/to/site --clobber
```

From a standalone clone of this repo it is just `make crystal`, then host the
resulting `pokecrystal.gbc` as `kanto-first.gbc` next to `index.html`.

The status line under the screen prints the ROM's byte length and the first 8
hex of its SHA-256. `release_rom.sh` prints the full SHA-256 in the release
notes — compare the first 8 characters to confirm the phone is running the
build you think it is. (JavaScript cannot read the build id burned into the
title screen, so the hash is the check.)

---

## ROM loading order

1. `?rom=<url>` if present (CORS permitting) — the explicit override.
2. `./kanto-first.gbc` next to the page.
3. A copy previously stored in IndexedDB (only if you ever picked a ROM by hand).
4. **Menu → Load ROM file…** — a file picker.

Give it a raw `.gb`/`.gbc` file — zips are not unpacked, unzip first.

---

## Controls

Touch: 8-way D-pad (drag your thumb; there is a dead zone in the middle),
A, B, START, SELECT. Multitouch works — hold a direction and press A. Page
scroll, pinch zoom and double-tap zoom are disabled over the play area, and
nothing vibrates.

Keyboard: arrows, <kbd>Z</kbd>/<kbd>A</kbd> = A, <kbd>X</kbd>/<kbd>S</kbd> = B,
<kbd>Enter</kbd> = START, <kbd>Shift</kbd> = SELECT, hold <kbd>Space</kbd> to
fast-forward.

Sound is unlocked by your first tap (iOS requires a gesture); until then a "Tap
to start" badge sits over the screen. **Menu → Sound** toggles mute,
**Speed** toggles 2×.

---

## Saves

**In-game (battery) saves** are the real thing: the page snapshots cartridge RAM
to IndexedDB every 10 seconds when it has changed, and whenever you leave or
background the page. On the next visit it is restored before the ROM starts.

- **Export .sav** downloads `kanto-first.sav` — **raw 32 KB cartridge RAM and
  nothing else, no RTC footer.** That is byte for byte what binjgb itself
  writes (`emulator_write_ext_ram()` copies the external RAM region only) and
  what Delta expects. Import it in Delta with: tap the `.sav` in Files → Delta →
  Restart.
- **Import .sav** accepts either shape:
  - exactly 32 KB — raw cartridge RAM, used as-is;
  - **32 KB + a trailer** — VBA/mGBA/Gambatte and friends append an RTC footer
    (commonly 44 or 48 bytes, sometimes more). **The trailer is dropped**, with
    a note in the status line saying how many bytes went. binjgb keeps its clock
    inside its save *state*, not in the `.sav`, and exposes no way to push RTC
    registers in from JavaScript, so an imported save keeps all your progress
    but inherits this page's current clock rather than the source emulator's;
  - shorter than 32 KB — zero-padded.

  After an import the cartridge is rebooted from the imported RAM, and the
  auto-resume snapshot (below) is discarded.
- **3 save-state slots** (full machine state, not just SRAM) live in IndexedDB
  under **Menu**. They are a raw dump of binjgb's internal `EmulatorState`, so
  they are tied to this browser, this page and this exact core build: each slot
  is stamped with the core commit and a mismatched slot is refused rather than
  loaded. They are not portable to Delta.
- **Reset** is a power cycle: it reboots the cartridge from the battery save and
  throws the machine state (and with it the emulated clock) away.

### The clock, and why there is an auto-resume snapshot

binjgb advances the MBC3 real-time clock from emulated CPU ticks and stores it
in its save state, not in the `.sav`. A `.sav`-only mirror would therefore reset
time of day on every page load. So alongside the battery save the page also
keeps one full save state per cartridge (`resume:<title>`) and restores it on
the next visit, which is what makes the clock carry over.

It is only ever an optimisation. The snapshot is stamped with the ROM's SHA-256
and the core commit, and it is ignored — falling back to a normal boot from the
battery save — if either differs, if its size does not match, or if the previous
attempt to restore it did not survive its first half-second (a `sessionStorage`
guard, so a bad snapshot cannot wedge the page in a reload loop). **Reset** and
**Import .sav** both delete it.

Caveat worth knowing: the clock only advances while the page is actually
running. Close the tab for a week and the game will think a few minutes passed,
not a week. Real hardware (and Delta) keep counting.

### Saves survive new builds

The battery mirror is keyed by the cartridge *title* (`PM_CRYSTAL`), which is
stable across builds of the hack, not by the header bytes — the header contains
the ROM's global checksum, so every rebuild would otherwise look like a
brand-new cartridge with an empty save. Drop in a new `kanto-first.gbc` and your
in-game save is still there. (Save *states* and the resume snapshot are a
different matter: those are matched on the exact ROM hash and core commit.)

### Storage caveats — read this

- **iOS Safari deletes all site storage after 7 days without a visit.** That
  includes your in-game save. Two mitigations, use both: **add the page to your
  Home Screen** (Share → Add to Home Screen; storage for an installed web app is
  treated more durably and the 7-day cap does not apply), and **Export .sav**
  before any long break.
- Private/incognito windows, "Clear website data", and Low Storage cleanups all
  wipe the save. The export file is the only copy you control.
- Storage is per-origin: the save on `example.com` is invisible to
  `192.168.1.5:8080`. Pick one URL and stay on it.

---

## Save editor

**Menu → Edit save**, or `/edit` (`edit.html`). Same origin, same stylesheet,
same battery save the player uses — it is not a separate app, it just opens the
32 KB of cartridge RAM sitting in IndexedDB and writes it back.

What it edits: **where you are** (a dropdown of every Kanto map with a real
spawn point — no raw coordinates), **party** (species, level, nickname, four
moves, current HP, plus "recalculate stats & heal" from the ROM's own base
stats and growth curve), **badges** (8 Kanto + 8 Johto), **money and coins**,
**player / rival name**, the **bag** (all four pockets, by name, capacity
enforced), and **event flags** (all of them, searchable, set ones shown first).
It also lists the **presets** below, and does `.sav` download/upload with the
same normalising the player's Import does.

**Apply** writes both save copies with recomputed checksums and magic bytes,
stashes the pre-edit save as the restore point ("Restore previous save" puts it
back), deletes the auto-resume snapshot so the game genuinely reboots from the
edited SRAM, and returns you to the player. **If the player is open in another
tab, reload it** — that tab still holds the old RAM and will overwrite you on
its next autosave.

### tables.json

`edit.js` hard-codes no addresses, no species list and no flag numbers. It
reads `tables.json`, which `web/gen_tables.py` generates from
`pokecrystal.sym`, `pokecrystal.gbc` and `constants/*.asm` + `data/maps/
spawn_points.asm` at build time — `make crystal` produces it, and it is
git-ignored because it is derived. The file is stamped with the ROM's SHA-256
and **the editor refuses to touch a save if that does not match the ROM the
page loaded**, so a stale table can never scribble on a save at the wrong
offsets.

### Presets

`presets/` holds `.sav` files captured from the repo's own playtest fixtures
(`scripts/gen_states.sh` upstream), with a `manifest.json` describing each one.
"Load preset" **replaces the whole save** (the previous one becomes the restore
point). Several fixtures fake progress to reach a state quickly — a badge
written rather than fought, trainers pre-flagged — and each description says so
in as many words. Regenerate with `scripts/gen_presets.py` in the helper repo
after the fixtures change.

### Moving a save to another map: what the editor has to fix

Worth knowing if you ever touch this code, because none of it is obvious. The
continue path (`MapSetupScript_Continue`) calls `LoadMapAttributes_SkipObjects`
— it never respawns the player — so almost everything about "standing on a
tile" is saved state the editor must rebuild:

- the player's **and the follower's** object struct and map object: coordinates
  (tile + 4), sprite offsets, *and* the motion members, or a save captured
  mid-step resumes that step on the new map and walks off it;
- **`wScreenSave`**, the 6×5 metatile window `LoadConnectionBlockData` copies
  back over the blocks around you — otherwise a patch of the old map is painted
  onto the new one. `gen_tables.py` precomputes the right window per spawn;
- **`wCurMapSceneScriptPointer`**, which is saved and never reloaded. It still
  points at the *old* map's scene id, so the new map runs whichever of its
  `scene_scripts` happens to have that number. (Found the hard way: a Pewter
  save moved to Vermilion ran the "left the S.S. Anne" scene.) Repointed from
  the ROM's `MapScenes` table.

The old map's NPCs are evicted rather than replaced, so a freshly-moved map is
empty of people until you step out and back in. That is the one visible
artefact, and the editor says so on the page.

---

## PWA

`manifest.webmanifest` + `apple-mobile-web-app-capable` + `viewport-fit=cover`
with safe-area insets, so Home-Screen launch is fullscreen with no notch
clipping.

**There is deliberately no service worker.** A service worker would cache the
ROM and the page, which is exactly wrong here: the ROM must always be the
freshly hosted build. The trade-off is that the page needs a network connection
to start (the core is a small local file, so only the ROM really matters), and
that you never have to think about a stale cached build on the phone.

---

## The emulator core

**binjgb** (<https://github.com/binji/binjgb>), commit
`c60e138da5a795ebb55e56b11b7e90024e41112c`, vendored under `vendor/binjgb/`.
Full provenance — upstream paths, SHA-256s, build flags, refresh recipe — is in
`vendor/binjgb/VERSION.txt`.

### Why this core

The page used to run **WasmBoy 0.7.1**, which was replaced because it does not
implement the MBC3 real-time clock: `core/memory/banking.ts` carries
`// TODO: MBC3 RTC Register Select` and `// TODO: MBC3 Latch Clock Data` where
the registers should be, and writes aimed at an RTC register fall through into
SRAM banks 0–3 (`value & 0x03`) — i.e. a clock-set screen could scribble on save
data. Our cartridge is type `0x10`, MBC3+TIMER+RAM+BATTERY, and the game reads
the clock for time of day, so that was a real, save-corrupting problem rather
than a cosmetic one.

binjgb implements it. Verified by reading `src/emulator.c` at the vendored
commit before adopting it:

- the cartridge table has
  `V(CART_TYPE_MBC3_TIMER_RAM_BATTERY, 0x10, MBC3, WITH_RAM, WITH_BATTERY, WITH_TIMER)`
  — our exact cartridge type;
- `mbc3_write_rom()` handles the `$4000–$5fff` register select (`value < 8`
  selects a RAM bank, `8..0xc` selects an RTC register — it does **not** mask
  the value into a RAM bank) and the `$6000–$7fff` latch, latching on the `0 → 1`
  transition via `emulator_ticks_to_time()`;
- `mbc3_read_ext_ram()` / `mbc3_write_ext_ram()` serve registers `$08–$0c`
  (seconds, minutes, hours, day-low, day-high + halt + carry);
- the `Mbc3` struct (`latch_ticks`, `rtc_reg`, `rtc_halt`, `latched`) lives
  inside `MemoryMapState`, which is part of `EmulatorState` — so a save state
  carries the clock.

Other properties that made it the right pick here: MIT rather than GPL; upstream
**commits its prebuilt emscripten artefacts** under `docs/`, so vendoring needs
no emscripten toolchain; the core is one 86 KB `.wasm` with no web workers; and
the exported C API gives direct access to cartridge RAM and to a full machine
state, which is what `.sav` export and the save slots are built on.

### Licence

- `vendor/binjgb/binjgb.js`, `vendor/binjgb/binjgb.wasm` — **MIT**, © 2016 Ben
  Smith. Text in `vendor/binjgb/LICENSE`.
- `vendor/binjgb/LICENSE.gbstudio` — the additional MIT notice upstream ships
  next to the `docs/` demo sources. It applies because the run loop, the wasm
  `FileData` helpers and the audio scheduler in `app.js` are adapted from
  binjgb's own `docs/simple.js` and `docs/demo.js`.
- Everything else in this folder is part of this project.

No GPL code is left in `web/`: `vendor/wasmboy.wasm.umd.js` and
`vendor/wasmboy-LICENSE.txt` were deleted with the core swap.

### How `app.js` drives it

The whole core-specific surface is the top third of `app.js`. The loader is a
`MODULARIZE=1` emscripten module (`window.Binjgb({locateFile})` → a Promise of
the Module), and the API used is:

`_emulator_new_simple` / `_emulator_delete`, `_emulator_get_ticks_f64` /
`_emulator_run_until_f64` (returns a bitmask: new frame, audio buffer full,
until-ticks), `_get_frame_buffer_ptr`/`_size`, `_get_audio_buffer_ptr`/
`_capacity`, the eight `_set_joyp_*` setters, `_ext_ram_file_data_new` /
`_emulator_read_ext_ram` / `_emulator_write_ext_ram`, `_state_file_data_new` /
`_emulator_read_state` / `_emulator_write_state`, and
`_emulator_was_ext_ram_updated` to decide when a save is worth writing.

Three things worth knowing if you touch that code:

- The frame buffer is already RGBA in `ImageData` byte order, so rendering is a
  plain Canvas2D `putImageData`. No WebGL on purpose: iOS Safari will not
  nearest-neighbour-upscale a WebGL canvas.
- The wasm heap is **fixed at 16.5 MB with no growth** in this build, and
  `file_data_delete()` frees only the payload, not the little struct that points
  at it — so every `FileData` is released through a helper that calls both
  `_file_data_delete` and `_free`.
- `_set_audio_channel_mute` is a **no-op stub** in the committed artefacts (they
  are not a `GBSTUDIO` build), so mute is done in JavaScript by not scheduling
  audio buffers.

### Vendoring / updating the core

There is no CDN fallback and no build step: the four files under
`vendor/binjgb/` are copied verbatim from upstream. To refresh:

```bash
git clone --depth 1 https://github.com/binji/binjgb /tmp/binjgb
cp /tmp/binjgb/docs/binjgb.js /tmp/binjgb/docs/binjgb.wasm web/vendor/binjgb/
cp /tmp/binjgb/LICENSE /tmp/binjgb/docs/LICENSE.gbstudio web/vendor/binjgb/
# then update CORE_COMMIT in web/app.js and web/vendor/binjgb/VERSION.txt
```

**Export a `.sav` first.** Changing `CORE_COMMIT` invalidates every save state
and the auto-resume snapshot (they are raw `EmulatorState` dumps); `app.js`
refuses to load a mismatched one rather than crashing on it. Battery saves are
unaffected.

---

## Known rough edges

- The emulated clock only ticks while the page is open (see "The clock" above).
- Save *states* embed the core's internal memory layout. They are not portable
  between core builds — export a `.sav` before changing `CORE_COMMIT`.
- Fast-forward is 2× and runs **silent**: the audio scheduler is fed real-time
  sample counts, so the simplest correct thing is to skip audio while
  fast-forwarding rather than play it pitched.
- Audio is scheduled ~100 ms ahead with `createBufferSource`. If the tab is
  starved the scheduler notices it has fallen behind the `AudioContext` clock
  and resynchronises, which is audible as a brief gap rather than a crackle.
- The page re-derives the screen scale on `resize`/`orientationchange`; iOS
  sometimes reports stale dimensions mid-rotation, hence the 250 ms delay.

---

## What was actually tested (and what wasn't)

Built and checked in a container with **no browser and no JavaScript runtime of
any kind** (no `node`, `deno`, `bun`, `qjs`, `d8`). So:

**Verified, by running it:**

- `server.py` compiles, and serving it live with
  `python3 web/server.py --rom pokecrystal.gbc` on a loopback port returns
  **200 with the right `Content-Type` for all 13 allowlisted paths** — including
  `application/wasm` for `vendor/binjgb/binjgb.wasm` — and **404** for
  `/vendor/wasmboy.wasm.umd.js` (gone), `/vendor/`, `/server.py`, `/etc/passwd`,
  `/..%2f..%2fetc/passwd`, `/index.html/../server.py` and any unknown path.
  `HEAD` answers 200, `POST` is 501. `Cache-Control: no-store` on the page and
  the ROM, `max-age=3600` + `X-Content-Type-Options: nosniff` on the vendored
  assets. The ROM and `binjgb.wasm` came back **byte-identical** (SHA-256
  matched the files on disk). `manifest.webmanifest` parses as JSON.
- `app.js` **parses clean** as an ES5 script (esprima 4.0.1 run under Python),
  and an AST walk found **no identifier referenced that is not declared in the
  file or a standard global** — i.e. no typo'd variable or function names.
- Every `mod._*` call in `app.js` (28 of them, plus `HEAPU8`) was cross-checked
  against `assignWasmExports()` in the vendored `binjgb.js`: **all present**.
  The API contract itself was read from binjgb's `src/emscripten/wrapper.c` and
  `docs/simple.js`, not guessed — the ROM padding, the `_emulator_new_simple`
  argument order, the run-loop event mask and the audio scheduler follow
  upstream's own demo.
- Every `#id` and `[data-*]` selector `app.js` uses exists in `index.html`.
- The MBC3 RTC claim was verified by reading `src/emulator.c` at the vendored
  commit (see "Why this core" above) — not taken from a feature list.
- The cartridge really is type `0x10` with a 32 KB RAM size code, and its title
  bytes (`PM_CRYSTAL`) contain no checksum, which is what makes the
  title-keyed save mirror survive rebuilds.

**Not verified — be blunt about this:**

- The page has **never been executed in a real browser, or anywhere else.**
  There is no JS runtime in this container and no headless browser, and no
  global package was installed to get one. Rendering, input, audio, the
  emulator actually booting the ROM, the battery-save round-trip, the resume
  snapshot and the `.sav` import path have all been **reasoned about and
  statically checked, never observed running.**
- Specifically unproven at runtime: that binjgb accepts this 2 MB ROM, that the
  frame pacing and the Web Audio scheduling behave on a phone, that iOS unlocks
  audio on the "Tap to start" gesture, and that the `.sav` this page exports
  imports into Delta.

**The save editor is the exception — that one was run in a browser.** Headless
Chromium (Playwright) against `server.py`: load a preset, move the save to
Lavender Town, set money to 12345 and tick a badge, **Apply**, then re-open the
player and watch it boot from the edited SRAM standing in Lavender Town. Both
save copies' checksums verified, the resume snapshot was deleted and the
restore point written. Separately, a Python replica of the editor's map-move
ran all 12 named Kanto spawns through PyBoy: every one lands on the expected
tile and can walk off it. Not covered there: iOS Safari specifically, the
`.sav` upload path inside the editor, and the party/bag/flag editors beyond
"the bytes land where `tables.json` says" (they were not booted field by field).

### First-run checklist for the operator

1. The screen draws and the status line shows the ROM's size + hash, and
   **Menu** ends with `Core: binjgb c60e138d (vendored), MIT. MBC3 RTC supported.`
2. The first tap dismisses "Tap to start" and **sound comes on**.
3. D-pad diagonals work, and you can hold a direction while pressing A.
4. Save in-game, reload the page — the save is still there, **and the in-game
   clock has not jumped back** (that is the whole point of the core swap; check
   the time in the Pokégear/clock screen or just whether it is still day/night).
5. **Export .sav**, open it in Delta, and check it loads your file. Then
   **Import** a Delta-exported `.sav` back and check the status line reports how
   many trailer bytes it dropped.
6. Rotate the phone; check both layouts and that nothing scrolls or zooms.
7. Hold <kbd>Space</kbd> (or **Speed: 2×**) and confirm it speeds up and goes
   quiet, and that normal speed and sound come back.
