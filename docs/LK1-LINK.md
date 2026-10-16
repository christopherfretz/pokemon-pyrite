# LK1 — link-cable trades and battles between two web players, over the internet

Status: **design, nothing built yet** (2026-10-15). Basis: pyrite `b208d9c`, binjgb fork
`pyrite-rtc@8fb6fda`. Every `file:line` below is relative to this repo (pyrite) at that commit.
Operator decisions taken on 2026-10-15 (relay, pairing, dumb pipe, same ROM, Trade Center and
Colosseum only, headless testing, security review, save compatibility) are inputs here. This doc
does not reopen them.

## Executive summary

1. The cable cannot be stretched over the internet. Real link code assumes the partner answers each
   byte within microseconds, which no network can do. Each phone therefore runs a **stand-in**
   (`web/link.js`), a fake partner Game Boy local to the emulator. Only *decisions* travel over the
   WebSocket, never raw serial bytes.
2. Every networked step is one of two kinds: a once-per-frame "nybble" handshake (menus, battle
   moves), or the bulk swap of four data blocks (1,057 bytes). The four blocks are already sitting
   in WRAM before the bulk swap starts. The stand-in reads them, ships them in one message, and
   replays the peer's copy into the local game at cable speed.
3. Network waits are parked where the game already waits safely: the untimed nybble loops, and the
   "action 5" handshake, which has a ~15 s budget. Nothing waits on the network inside the
   byte-timed bulk swap.
4. Disconnects become the game's own messages ("link closed", "trade canceled", battle forfeit).
   The stand-in gets them by answering the right nybble, so no ROM change is needed.
5. Emulator: binjgb drops every serial byte today. The fork gains a small link port: in/out byte
   FIFOs plus a paced "virtual master" for the externally clocked side. The port is off by default
   and kept outside `EmulatorState`, so save states and the resume snapshot keep their layout.
6. Relay: an RFC 6455 endpoint `/link` in stdlib Python, flag-gated in `server.py`. It pairs two
   sockets on a 3-word code (120 s TTL) and then forwards opaque frames. It has size, rate and idle
   caps, never logs payloads or codes, and is reached through the existing Cloudflare Tunnel.
7. Safety: the peer's blocks pass a field-by-field validator *before* the game sees them. A failure
   aborts through the native "link closed" path. A pre-link snapshot (state + battery) gives a
   one-tap rollback, and resume snapshots are suppressed while linked.
8. Gender (GF3): ship masked first. Later, LK1f adds a pyrite feature byte in the 3 padding bytes
   that vanilla Crystal sends as zeros and never reads. The ROM then keeps explicit genders on
   pyrite-to-pyrite trades. There is no SRAM change.
9. Testing: Node 24 runs two real `binjgb.wasm` instances, link.js and the relay, plus a
   zero-latency "cable mode" oracle, with injected delay, drops and hostile peers. Python tests
   cover the relay. Headless Chromium runs the full two-page E2E. Only iOS Safari behaviour needs
   the phone.
10. Work plan: seven steps, LK1a-g, about 11-13 agent-days. The first step that touches the
    product is LK1a (the emulator port). It is verified byte-identical when the link is off.

## Contents

1. Protocol survey and stage table (with *Corrections to the sketch*)
2. Emulator change (binjgb fork)
3. Stand-in state machine (`web/link.js`)
4. Relay server
5. Client validator
6. Snapshot before link
7. Gender bits across a pyrite-pyrite link
8. Headless harness plan
9. Work plan LK1a-g and open questions

---

## 1. Protocol survey

### 1.1 The hardware in one paragraph

Each Game Boy has an 8-bit shift register **SB** and a control register **SC**. One side is the
*master* (internal clock). Writing `SC = $81` makes it clock 8 bits out of its SB while
simultaneously shifting the partner's 8 bits in. That takes 4,096 CPU ticks (~1 ms) at 8,192 Hz.
The other side is the *slave* (external clock). It writes `SC = $80` to say "ready" and then simply
waits: its byte moves only when the master clocks. When the 8 bits are done, both sides get the
serial interrupt.

Nothing acknowledges or retries at the hardware level. If the slave is not ready, the master still
clocks and reads whatever the slave's SB happens to hold. In Crystal, `hSerialConnectionStatus` is
`$02` on the master, `$01` on the slave and `$FF` before a connection is made
(`constants/serial_constants.asm:24-26`).

### 1.2 How Crystal uses it

**The serial ISR** (`home/serial.asm:1-89`). On each completed byte the ISR does three things:

- copies `rSB` into `hSerialReceive`;
- loads `hSerialSend` into `rSB` *for the next transfer*, re-arming the slave (`:21-35`);
- sets `hSerialReceivedNewData`, then resets `hSerialSend` to `$FE`, SERIAL_NO_DATA_BYTE (`:78-82`).

So **each side's outgoing byte leaves one transfer late**. The higher-level loops are built to
tolerate that lag. Before a connection exists, the ISR's `.establish_connection` path (`:45-76`)
turns a received `$01` into "I am slave" and a received `$02` into "I am master".

**Byte exchange primitives.**

- `Serial_ExchangeByte` (`home/serial.asm:130-230`). The master starts a transfer (`:134-140`) and
  every caller waits for the ISR.
  - The slave gives up after `wLinkByteTimeout` = `$5000` loop iterations, but only while
    `IE == IE_SERIAL` (`:165-185`). It then **carries on with stale data**. It does not report an
    error.
  - A received `$FE` with `IE == IE_SERIAL` is simply returned to the caller (`:221-226`).
  - With other interrupts enabled, a received `$FE` makes it resend and wait another frame
    (`:227-230`).
- `Serial_ExchangeBytes` (`home/serial.asm:91-128`) is the block exchange. It **discards incoming
  bytes until it sees a `$FD` preamble byte**, resending its own first byte meanwhile (`:109-119`).
  It then stores the next `bc` bytes. The two sides send their blocks *simultaneously*: this is a
  swap, not a request/response.
  - Between bytes it spins 48 iterations (`:104-107`).
  - There is **no overall timeout** while it is skipping: the master loops for ever on `$FE`.
- `ExchangeBytes` (`engine/link/link.asm:571-604`) is the same, minus the preamble check. It
  discards exactly one first byte, then stores `bc`. It is used only for mail.

**Nybble handshakes.** `WaitLinkTransfer` (`home/serial.asm:292-350`) calls `LinkTransfer`
(`:352-394`) once per frame.

- `LinkTransfer` sends `high nybble | wPlayerLinkAction`. The high nybble is `$60` outside a
  room, `$70` in the Trade Center and `$80` in the Colosseum (`:353-364`;
  `constants/serial_constants.asm:16-18`).
- It accepts a received byte only if its high nybble matches (`:383-394`).
- `WaitLinkTransfer` loops until `wOtherPlayerLinkAction` is no longer the `$FF` it set on entry
  (`:294-319`). It then does **10 more frames of LinkTransfer and 10 frames of zero bytes**
  (`LinkDataReceived`, `:396-407`), the "ack tail" (`:321-345`).
- The timeout counter `wLinkTimeoutFrames` (big-endian frames) is only decremented if it is nonzero
  (`:299-311`). Every handshake whose caller leaves it at zero **waits for ever**.
- The battle version, `_LinkBattleSendReceiveAction` (`mobile/mobile_40.asm:1531-1619`), is the
  same shape: an untimed loop (`:1580-1587`), a 10-frame tail (`:1596-1601`) and a 10-frame zero
  tail (`:1610-1614`).

**Room sync.** `Link_EnsureSync` (`engine/link/link.asm:2643-2669`) sends `$D0|n` through
`Serial_ExchangeSyncBytes` (`home/serial.asm:256-279`, one byte per frame). It loops until it
receives any `$Dx`, and has no timeout.

**Timed handshakes.** `Link_CheckCommunicationError` (`engine/link/link.asm:2469-2539`) runs a
`WaitLinkTransfer` with a budget. If that fails it sends a 10-frame zero ack and retries with a
budget of `hl/4 + $C0` (`.ConvertDW`, `:2524-2537`). It clears the counter at the end
(`:2493-2497`). Budgets in frames, at 59.7 fps:

| caller | first try | retry | total |
|---|---|---|---|
| receptionist, action 1, `$0300` (`:2388-2407`) | 768 | 10 ack + 128 | ~906 frames ≈ **15 s** |
| `CheckLinkTimeout_Gen2` action 5, `$0300` (`:2409-2431`) | 768 | 10 + 128 | ≈ **15 s** |
| `CheckLinkTimeout_Gen2` action 6, `$0132` (`:2440-2458`) | 50 | 10 + 12 | ~72 frames ≈ **1.2 s** |
| `WaitForLinkedFriend`, `$02FF` loop (`:2329-2367`) | — | — | ~511 frames ≈ **8.5 s** |

(Nintendo's VC build raised the action-6 high byte to 3 (`:2445-2451`) and the 10-frame tails to
26 for its network link. See 1.5.)

### 1.3 The full Cable Club flow, as a stage table

Columns:

- *Who sends what* uses M = master and S = slave.
- *Timing* is one of: **hw** (byte-paced, no frame waits); **frame** (one byte per frame, untimed);
  **timed N** (the budget above).
- *Stand-in* is what `link.js` does locally (section 3).
- *Detect* is how JS recognises the stage between frames, from WRAM/HRAM reads and the out-byte
  log of section 2.

| # | Stage (code) | Who sends what | Length | Timing | Stand-in | Detect |
|---|---|---|---|---|---|---|
| 1 | Receptionist sets action, `SetBitsForLinkTradeRequest`/`BattleRequest` (`link.asm:2282-2292`), script `maps/Pokecenter2F.asm:88-123` (trade), `:190-224` (battle) | none | — | — | none | — |
| 2 | `WaitForLinkedFriend` (`link.asm:2308-2386`): arm external with `SB=$02` for 3 frames, then each frame arm external and immediately start internal with `SB=$01` (`:2343-2367`) | both sides poll; first received `$01`/`$02` decides the role (`serial.asm:45-76`) | 1 B/attempt | timed ~8.5 s | when paired + hello OK, shift `$02` (we become M) or `$01` (we become S) into the next attempt | `hSerialConnectionStatus==$FF`, out-log shows `$01` internal |
| 3 | `TryQuickSave` (`link.asm:2541-2556`): the game saves | local | — | — | none (battery write lands; see 6) | — |
| 4 | `CheckLinkTimeout_Receptionist`, action 1 (`link.asm:2388-2407`); script then needs `wOtherPlayerLinkMode≠0` (`Pokecenter2F.asm:113-114`) | `$61` both ways | nybble | timed ~15 s | send `rcpt`; answer `$61` when the peer's `rcpt` arrives | `wOtherPlayerLinkAction==$FF`, `wPlayerLinkAction==1`, `wLinkTimeoutFrames≠0`, `wLinkMode==0` |
| 5 | `CheckBothSelectedSameRoom` → `Link_EnsureSync(room)` (`link.asm:2558-2581`, `:2643-2669`) | `$D1`/`$D2` | 2 B, frame | untimed | send `sync{room}`; feed `$D0|peerRoom` | out-log `$Dx` |
| 6 | warp, console, `special TradeCenter`/`Colosseum` (`link.asm:2595-2615`), `LinkCommunications` 160-frame fade (`link.asm:1-34`) | none | — | — | none | `wLinkMode` 2/3 |
| 7 | `Gen2ToGen2LinkComms` prep: `ClearLinkData`, `Link_PrepPartyData_Gen2`, `FixDataForLinkTransfer` (`link.asm:205-208`) | none; **all four outgoing blocks now final in WRAM** | — | — | none | — |
| 8 | `CheckLinkTimeout_Gen2` action 5 (`link.asm:2409-2431`); then must read 5 (`:2440-2443`) | `$75`/`$85` | nybble | timed ~15 s | on entry read the 4 local blocks and send `blocks`; answer `$x5` **only after the peer's blocks arrive and pass the validator**, else answer `$x0` → native `LinkTimeout` | as row 4 with `wPlayerLinkAction==5`, `wLinkMode` 2/3 |
| 9 | busy wait ~0.44 s (`link.asm:2433-2438`), then action 6 (`:2445-2458`) | `$x6` | nybble | timed ~1.2 s | answer `$x6` **locally and at once** (peer blocks already in hand) | `wPlayerLinkAction==6` |
| 10 | master's two kick bytes and 3 frames (`link.asm:213-232`), then `IE=IE_SERIAL` (`:245-248`) | M sends `$00`,`$00` | 2 B | hw | nothing to do (idle byte `$FE`) | — |
| 11 | RN block (`link.asm:250-256`) `wLinkBattleRNPreamble`→`wOTLinkBattleRNData` | both: 7×`$FD` + 10 RNs | 17 B | **hw** | when `IE==IE_SERIAL` is seen, push the whole feed (rows 11-14) into the in-FIFO | `IE ($FFFF)==IE_SERIAL` |
| 12 | party block (`link.asm:258-264`) `wLinkSendParty`→`wLinkReceivedPartyData` | 6×`$FD` + name, count, species, ID, 6 structs, OTs, nicks, 3 padding (`ram/wram.asm:1061-1081`) | 450 B | hw | (same feed) | — |
| 13 | patch lists (`link.asm:266-270`) | 3×`$FD` + list 1 … `$FF` + list 2 … `$FF` | 200 B | hw | (same feed) | — |
| 14 | mail (Trade Center only, `link.asm:272-280`) via `ExchangeBytes` | 5×`$20` + 6×33 messages + 6×14 metadata + patch set (`ram/wram.asm:1086-1091`) | 390 B | hw | (same feed) | — |
| 15 | apply: `Link_CopyRandomNumbers` (slave adopts master's RNs, `link.asm:1217-1235`), `Link_CopyOTData` 441 B skipping `$FE` (`:1204-1215`), patch loop (`:296-326`), mail (`:328-445`), OT copies (`:447-463`); M waits 66 frames (`:472-475`) | none | — | — | assert in-FIFO empty | — |
| 16T | Trade menu exchanges (`link.asm:1516`, `:1572`, `:1634`, `:1782`, `:1788`, check byte `:2036`) through `WaitLinkTransfer` | `$7x` | nybble | **frame, untimed** | `act{seq,v}`; hold until the peer's matching `seq`, then feed `$70|v` for the receipt + 10 frames, then `$00` | `wOtherPlayerLinkAction==$FF` and `wLinkTimeoutFrames==0` and `wLinkMode==2` |
| 17T | after a trade: `SaveAfterLinkTrade` then `jp Gen2ToGen2LinkComms` (`link.asm:2049-2068`): **rows 7-15 repeat** with fresh RNs | | | | | |
| 16B | Colosseum: `predef StartBattle` (`link.asm:512`), every `LinkBattleSendReceiveAction` (`engine/battle/core.asm:2411, 2856, 3951, 5365, 5961, 6122`; `engine/battle/move_effects/baton_pass.asm:88,102`) | `$8x` | nybble | **frame, untimed** | `act{seq,v}` as 16T | as 16T, `wLinkMode==3` |
| 18 | leave: `ExitLinkCommunications` sends one `$00` (`link.asm:1640-1656`); `WaitForOtherPlayerToExit` is local (`:2234-2280`); `CloseLink`/reset (`:2617-2641`) | M: 1 B | — | — | link-session end; keep the room open for another visit | `wLinkMode==0`, status `$FF` |

Action values in battle are 0-3 for a move, 4-9 for a switch, `$D` skip, `$E` Struggle and
`$F` forfeit (`constants/battle_constants.asm:252-269`). `$A`-`$C` are unused.

Battle randomness lives entirely in the RN block. `_BattleRandom` reads `wLinkBattleRNs`
(`engine/battle/core.asm:7078-7110`), and the slave copies the master's list
(`engine/link/link.asm:1217-1235`). So after stage 15, only action nybbles cross the network
during a battle.

### 1.4 Corrections to the sketch

1. **"The slave's reply is pre-staged in SB."** Not quite. *Both* sides are one transfer late,
   because the ISR loads `hSerialSend` into `rSB` for the *next* transfer (`home/serial.asm:24-25,
   78-82`). The preamble skip in `Serial_ExchangeBytes` (`:109-119`) absorbs that lag. The design
   doesn't depend on it, because the stand-in feeds bytes straight into the local receive side.
2. **"The bulk block exchange"** is not one block. It is a **timed two-step handshake** (action 5,
   then action 6, `link.asm:2409-2458`) followed by **four back-to-back exchanges**: RN 17, party
   450, patches 200, and mail 390. Mail uses the preamble-less `ExchangeBytes` (`:250-280`,
   `:571-604`).
   - It **repeats after every completed trade** with fresh RNs (`:2068`).
   - The party data is escaped: `$FE` bytes become `$FF` and are listed in the patch lists
     (`:621-700`), because `Link_CopyOTData` drops every `$FE` (`:1204-1215`).
3. **"The master clocks at 8 kHz."** The bit rate is 8,192 Hz (4,096 ticks/byte,
   `web/vendor/binjgb-src/src/emulator.c:849`). But the master's byte *rate* is lower:
   transfer + ISR + the 48-iteration spin (`home/serial.asm:104-107`) ≈ 5,100 ticks per byte.
   The slave's ~1,100-tick turnaround means a replay faster than the master's natural pace corrupts
   the stream. Section 2 paces it.
4. **"No ack or retry."** True at the byte level. Worse, a slave that misses a byte for
   `$5000` iterations **proceeds silently with stale data** (`home/serial.asm:165-185`), so a
   network stall inside the bulk exchange would corrupt the trade instead of failing it. **Nothing
   may wait on the network inside rows 10-14.**
5. **"Hold the game in the preceding stage."** The natural-looking hold point is the preamble-skip
   loop of `Serial_ExchangeBytes`. It is untimed on the master, and on the slave if it is fed
   `$FE` once per frame. But it shows no "waiting" text and gives no clean way to abort. The right
   hold point is **the action-5 nybble**:
   - its budget is ~15 s;
   - all four local blocks are already final in WRAM (row 7);
   - answering it with a wrong value makes the game print its own "link closed" message at once
     (`link.asm:2440-2443` → `jp z, LinkTimeout` at `:209-212`, text at `:535-569`).
   
   Action 6 then has only a ~1.2 s budget, so the stand-in **answers 6 locally** instead of
   waiting for a round trip.
6. **"Get the local block, swap blocks over the WebSocket."** It is one message, not four round
   trips. The stand-in reads the four outgoing blocks directly from WRAM by address
   (`wLinkBattleRNPreamble`, `wLinkSendParty`, `wPlayerPatchLists`, `wLinkSendMail`). The
   addresses come from this build's `.sym` via `tables.json`, and the ROM sha guarantees both
   phones match.
7. **"Everything else is polling with SERIAL_NO_DATA_BYTE filler."** Partly. `$FE` is the ISR's
   post-transfer default (`home/serial.asm:81-82`) and the bulk filler. The polls carry other
   bytes:
   - **nybbles** `$6x/$7x/$8x`;
   - **`$00` acks** (`LinkDataReceived`);
   - **`$Dx`** sync;
   - **`$01/$02`** role bytes.
   
   Several of these loops have **no timeout at all**: trade-menu `WaitLinkTransfer`,
   `Link_EnsureSync`, the battle action loop, and the Mew/Celebi "check byte" (`link.asm:2030-2047`).
   A disconnect therefore has to be *synthesized* as a believable answer (section 3.5).
8. **"Slave adopts the master's RNs, only the action byte crosses."** Confirmed (row 15,
   `core.asm:7078-7110`). Two additions:
   - **Roles must be complementary.** The stand-in, not the cable, picks them. Two masters would
     each use their own RNs and the battles would diverge. (Nintendo's VC made both sides master
     with its `Link_fake_connection_status` hook, `link.asm:2343-2350`; that only worked because
     its proxy carried the real byte stream.)
   - The 10+10-frame tails are local, and each exchange costs one message each way.
9. **"binjgb needs a host-driven external-clock API plus a synchronous JS hook for master
   transfers."** Half right.
   - External transfers never complete today (`emulator.c:4034-4048` schedules internal only).
   - Internal transfers *also* always shift in `$FF` (`emulator.c:4058-4062`), so the master side
     needs an input source too.
   - A synchronous per-byte JS callback is **not** needed and would be slow. In-C byte FIFOs plus a
     paced virtual master do the hardware-speed part. JS only ever acts between frames.
10. **Role choice needs no cable trick.** Answering the local `$01` probe with `$02` makes the local
    game master. Answering it with `$01` makes it slave (`home/serial.asm:46-56`). Either works
    from the internal-clock probe it sends every frame (`link.asm:2359-2365`).

### 1.5 Precedent: Nintendo's Virtual Console did exactly this

Crystal 1.1 on 3DS VC offered "wireless" link trades by patching the same points this design uses.
`vc/pokecrystal11.patch.template:29-204` hooks:

- each block-exchange call (`Wireless_ExchangeBytes_*`, `link.asm:253, 261, 269, 278`);
- `WaitLinkTransfer` entry and exit (`home/serial.asm:293, 349`);
- the battle action exchange (`mobile/mobile_40.asm:1534, 1589, 1603, 1617`);
- the communication-error retry (`link.asm:2472, 2503`);
- the Trade Center/Colosseum entry (`link.asm:2596, 2607`).

It also stretched the frame delays from 10 to 26 under `_CRYSTAL11_VC`. That is a strong sign that
block-level substitution is the proven shape. We cannot reuse its patch: it ran on Nintendo's
emulator with its own proxy. We also **do not adopt its longer delays**. Those would be a ROM
change that breaks vanilla-cable timing for no gain, since our stand-in answers the timed steps
locally.

---

## 2. Emulator change (binjgb fork, branch `pyrite-rtc`)

### 2.1 What binjgb does today

- `Serial` (`web/vendor/binjgb-src/src/emulator.c:472-480`) lives inside `EmulatorState`
  (`:664-692`). A save state is a raw dump of `EmulatorState`: version 2 (`:770-771`), and
  `read_state` demands an exact size (`:5040-5047`).
- Writing SC (`:2636-2645`) starts a transfer. `calculate_next_serial_intr` (`:4034-4048`) only
  schedules internal-clock transfers, so **an external-clock transfer never completes**.
- `serial_synchronize` (`:4050-4078`) shifts in `1` bits ("we're never connected", `:4058`) and
  raises `IF_SERIAL` after 8 bits. So an internal transfer always reads `$FF`, which is "no cable".
- The `RGBDS_LIVE` serial callback (`:2629-2634`) is compiled out of our build
  (`CMakeLists.txt:11, 153-160`).

### 2.2 The change: a link port that lives outside the save state

All new state goes in `struct Emulator` (`emulator.c:707-729`), next to `joypad_info` and
`apu_log`. That struct is *not* serialized. **`EmulatorState` is untouched**, so:

- `SAVE_STATE_VERSION` and `sizeof(EmulatorState)` are unchanged;
- existing resume snapshots and slot states load;
- app.js adds the current core id to `COMPAT_CORES` (`web/app.js:66-70`), exactly as the RTC
  commit did.

```c
typedef struct {
  Bool enabled;              /* FALSE: every path below is skipped -> byte-identical core */
  u8   idle_in;              /* shifted in when in_fifo is empty (default 0xff = no cable) */
  u8   in_fifo[2048];  u32 in_head, in_tail;      /* bytes "the peer" sends us */
  u32  out_log[512];   u32 out_head, out_tail;    /* {out, in, clock, flags} per completed byte */
  u32  ext_mode;             /* 0 = never clock external; 1 = clock from FIFO; 2 = also clock idle_in */
  Ticks ext_gap;             /* min ticks from arm -> completion and between completions (pacing) */
  Ticks ext_idle_period;     /* mode 2 cadence, default one frame (70224) */
  Ticks ext_armed_at, ext_last;
} LinkPort;                  /* member `LinkPort link;` of struct Emulator */
```

Behaviour when `link.enabled`:

- **Internal-clock completion** (`serial_synchronize`, master side): shift in the bits of
  `pop(in_fifo) ?: idle_in` instead of `1`s, MSB first. Then append
  `{out = SB at start, in, clock = INTERNAL}` to `out_log`.
- **External-clock completion** (slave side). This is new. When `transferring &&
  clock == EXTERNAL` and the virtual master is allowed to clock:
  - `ext_mode == 1` and the FIFO is non-empty, or
  - `ext_mode == 2`, which also clocks `idle_in` every `ext_idle_period`,
  
  then the transfer completes at
  `max(ext_armed_at + ext_gap, ext_last + ext_gap)` (idle cadence for idle bytes). On completion:
  `SB = in`, raise `IF_SERIAL`, log. `calculate_next_serial_intr` schedules this tick, so the CPU
  loop wakes at the right moment with no per-tick polling. It is recalculated whenever SC is
  written or JS pushes bytes.
- **Pacing (§1.4 point 3).** Default `ext_gap = 6144` ticks (1.5 byte-times), slightly slower than
  a real master's ~5,100. The harness sweeps it to find the corruption edge and asserts at least
  a 2× margin. At 6,144 ticks the 1,061-byte trade feed replays in ~1.55 s of emulated time.
  - **Hold cadence:** mode 2 with `idle_in = $FE` at one byte per frame is what a real master
    sends while waiting. It keeps a slave inside `Serial_ExchangeBytes` from hitting its byte
    timeout (`home/serial.asm:165-185`, `:221-226`).

JS surface (added to `src/emscripten/exported.json`). All of these are no-ops until enabled:

```c
void emulator_link_enable(Emulator*, Bool);
void emulator_link_set_idle_in(Emulator*, u8);
u32  emulator_link_push_in(Emulator*, const u8* bytes, u32 len);   /* returns bytes accepted */
u32  emulator_link_in_pending(Emulator*);
void emulator_link_clear_in(Emulator*);
void emulator_link_set_ext_clock(Emulator*, u32 mode, u32 gap_ticks, u32 idle_period_ticks);
u32  emulator_link_drain_out(Emulator*, u32* dst, u32 max);        /* oldest first */
u32  emulator_link_peek(Emulator*);         /* (transferring<<9)|(clock<<8)|SB, for cable mode */
s32  emulator_link_clock_external(Emulator*, u8 in);  /* complete an armed external transfer now;
                                                       returns the byte shifted out, -1 if not armed */
```

`_emulator_read_mem` (already exported) covers `IE` and the WRAM/HRAM reads used for detection.
JS calls these between `run_until` slices only (`web/app.js:1002-1011`). No callback from C into
JS is added, so the run loop's cost is unchanged.

### 2.3 "Off by default, normal path byte-identical"

- Every new branch tests `e->link.enabled` first (`UNLIKELY`).
- app.js never calls `emulator_link_enable` unless the Link panel connects.
- The wasm *binary* changes (new code and exports), so its sha256 changes, but the *behaviour* and
  the state layout do not.

That is proven, not assumed (2.4, step 4).

### 2.4 Rebuild and verify recipe

1. Commit the C change on the fork (`christopherfretz/binjgb`, branch `pyrite-rtc`, on top of
   `8fb6fda`) and push. Bump the submodule `web/vendor/binjgb-src`.
2. `PROVISION_EMSDK=1 scripts/provision.sh` (workspace), then `web/vendor/binjgb/build.sh`. This
   uses Emscripten 5.0.7, the same flags and the same prefix map (`web/vendor/binjgb/build.sh`,
   `VERSION.txt`). Commit the new `binjgb.js`/`binjgb.wasm`.
3. Update `VERSION.txt`: new fork commit, the API list above, and the new sha256s, replacing
   `f011e737…`/`3818651d…`. In app.js, set `CORE_COMMIT` to `…+pyrite-rtc@<new>` and add
   `'c60e138d…+pyrite-rtc@8fb6fda5550d'` to `COMPAT_CORES`. `make crystal` regenerates `sw.js`
   (`web/gen_sw.py`) so phones pick up the new core.
4. **Identity gate** (Node, LK1b harness). Load the old and new wasm side by side, boot the same
   `.sav`, and drive the same 20,000-frame input script. Assert:
   - identical framebuffer hashes every 60 frames;
   - identical SRAM at the end;
   - identical `emulator_write_state` bytes at the end;
   - equal state size.
   
   Then load an *old-core* resume state into the new core and run 600 frames.
5. The existing browser checks still pass: `scripts/web_clock_check.py`,
   `scripts/web_offline_check.py` and `scripts/web_layout_check.py`.

---

## 3. Stand-in state machine (`web/link.js`)

### 3.1 Where it sits

`link.js` is a new file, added to `server.py`'s `STATIC` allowlist and to the `sw.js` precache. It
owns:

- the WebSocket;
- the emulator link port (section 2);
- a per-frame `onFrame()` hook that app.js calls after every `NEW_FRAME` in `runUntil`
  (`web/app.js:1002-1011`).

It reads WRAM, HRAM and `IE` with the existing helpers (`readWram`, `web/app.js:627-638`;
`_emulator_read_mem`), using addresses from `tables.json`. `web/gen_tables.py` gains a `link`
section with symbols from the same build's `.sym`:

- `wLinkMode`, `wPlayerLinkAction`, `wOtherPlayerLinkAction`, `wLinkTimeoutFrames`,
  `wChosenCableClubRoom`;
- the four block addresses and lengths;
- `hSerialConnectionStatus`;
- `wOTPartyCount` and the species/item/move tables needed by the validator.

### 3.2 Messages (JSON text frames, `v:1`)

> As built in LK1c, the schema differs (no per-message `v`, plus `desk`/`abort`): see "LK1c findings".

| type | fields | when |
|---|---|---|
| `hello` | `lk:1, rom:<sha256>, build:<BUILD_REV>, core:<CORE_COMMIT>, name:<trainer name, ≤7 chars>` | right after `paired` |
| `rcpt` | — | local entered the receptionist's action-1 handshake (row 4) |
| `sync` | `room:1\|2` | local entered `Link_EnsureSync` (row 5) |
| `blocks` | `gen:<n>, rn, party, patch, mail` (base64; mail empty in the Colosseum) | local entered action 5 (row 8); `gen` counts re-exchanges |
| `act` | `gen, seq, v:0-15, mode:2\|3` | local entered an untimed nybble exchange (rows 16T/16B) |
| `pause` / `resume` | — | `visibilitychange` (iOS stops rAF; the peer shows an overlay) |
| `ping` / `pong` | `t` | every 15 s (liveness; keeps Cloudflare's ~100 s idle limit away) |
| `bye` | `reason: user\|rom-mismatch\|invalid-blocks:<field>\|invalid-act\|timeout\|internal` | any abort; the sender then closes |

Rules:

- Unknown types or extra fields close the link with `bye{internal}`.
- Each message is capped at 4 KiB client-side too. A `blocks` message is 1,057 bytes raw, about
  1.5 KB as JSON.
- Peer strings (`name`) are shown with `textContent` only.
- `act` messages pair 1:1 in order. `seq` restarts at 0 after every `blocks`, which keeps a
  mis-step from spreading past one trade.

### 3.3 States

```
IDLE ──Connect──▶ PAIRING (relay: create|join) ──paired──▶ HELLO ──both OK──▶ LINKED_OUTSIDE
LINKED_OUTSIDE ── row 2 seen ──▶ ROLE (shift $02|$01 into the next probe) ──▶ RCPT (row 4)
RCPT ──peer rcpt──▶ answer $61 ──▶ SYNC (row 5) ──peer sync──▶ feed $D0|peerRoom ──▶ ROOM
ROOM ── row 8 seen ──▶ BLOCKS_OUT (send blocks) ──peer blocks valid──▶ answer $x5 ──▶ HS6
HS6 ── row 9 seen ──▶ answer $x6 locally ──▶ BULK_ARMED ── IE==IE_SERIAL ──▶ feed ──▶ BULK
BULK ── IE restored, FIFO empty ──▶ MENU (Trade Center) | BATTLE (Colosseum)
MENU/BATTLE ── act exchange seen ──▶ ACT_WAIT ──peer act──▶ ACT_FEED (receipt + 10 frames) ──▶ MENU/BATTLE
MENU ── row 8 seen again (after a trade) ──▶ BLOCKS_OUT        (gen++)
MENU/BATTLE ── row 18 ──▶ LINKED_OUTSIDE   (the room stays open for another visit)
any ── peer gone / bye / invalid ──▶ DRAINING (section 3.5) ──▶ CLOSED
```

**Roles.** The relay names the code creator `a` and the joiner `b`. `a` is master. The roles are
fixed for the room's life, so every visit pairs master with slave.

- **Master setup:** `ext_mode=0`; internal transfers read the FIFO or `idle_in`.
- **Slave setup:** `ext_mode=2` with `idle_in=$FE` (the frame-cadence hold). Bulk bytes are clocked
  at `ext_gap`.

**Feeding a nybble answer.** Set `idle_in = hi|v` until the local game shows receipt
(`wOtherPlayerLinkAction≠$FF`). Keep it for 10 more frames, mirroring the real partner's tail, then
set `idle_in = $00` for the zero tail. The game cannot start its next exchange before its own 20
tail frames end, so a stale answer can never satisfy the next exchange.

**Building the bulk feed.** The local receiver keeps everything after the first `$FD` it sees, for
`bc` bytes. For each preamble block, the feed is therefore the peer's block followed by one `$FE`.
For mail, it is one discarded `$FE` followed by the 390 bytes (`link.asm:571-604`). The feed is:

```
RN(17) + $FE | party(450) + $FE | patch(200) + $FE | $FE + mail(390)   (Colosseum: no mail part)
```

That is 1,061 bytes, pushed in one call when `IE==IE_SERIAL` is first seen. Until then, idle
`$FE` holds the master in its preamble skip and the slave on the frame cadence. The harness asserts
the FIFO is empty when `IE` is restored (`link.asm:282-285`) and that the received WRAM matches the
cable-mode oracle (section 8).

### 3.4 Buffering and the peer that never shows

- **Messages that arrive early are queued per kind**: `rcpt`, `sync`, `blocks`, and `act` by
  `seq`. One phone running ahead of the other is therefore harmless. Each queue is bounded: one
  `blocks`, 8 `act`s. Overflow means `bye{internal}`.
- **Timed stages need no stand-in timer.**
  - Rows 2, 4 and 8 use the game's own budgets (8.5 s, 15 s, 15 s). If the peer has not reached the
    same point in time, the local game prints its own failure ("Your friend isn't ready", "link
    timed out", or "The link has been closed") and the player can simply try again.
  - The Link panel says what is being waited for, e.g. "Waiting for Ash to reach the
    receptionist".
- **Untimed stages wait as long as a real cable would.** The game shows its own "Waiting…!". The
  panel shows peer state from `pause`/`ping`. The **Disconnect** button is always live.
- **Peer liveness.** No frame from the peer for 45 s (three missed pings), or `pause` lasting more
  than 60 s, counts as *peer gone*.

### 3.5 Disconnect → graceful in-game ending

On *peer gone*, `bye`, a validator failure or the user's Disconnect, the stand-in enters
**DRAINING**. It keeps answering the local game with whatever leads it out cleanly, then disables
the port once the game is back outside (`wLinkMode==0`, status `$FF`).

| local stage | answer | what the player sees |
|---|---|---|
| rows 2/4 (receptionist probes, action 1) | nothing | the game's own timeout text after ≤ 15 s |
| row 5 `Link_EnsureSync` (untimed) | `$D0` (room 0 ≠ ours) | "incompatible rooms" path, `CheckBothSelectedSameRoom .fail` (`link.asm:2579-2581`) |
| row 8 action 5 | `$x0` | `LinkTimeout`: "The link has been closed…" (`link.asm:535-569`), immediately |
| row 9 onward to row 15 | (cannot happen: 6 and the feed are local once blocks are in hand) | — |
| trade menu, **choosing** (stage S0) | `$F` | at `.try_trade`: back to the menu (`link.asm:1517-1519`); at Cancel: exit (`:1630-1637`). Next Cancel → `ExitLinkCommunications` |
| trade menu, **confirm** TRADE/CANCEL (S1) | `$1` | "Too bad the trade was canceled" (`link.asm:1787-1800`). **Never `$F` here**: `dec a; jr nz, .do_trade` (`:1789-1791`) would trade |
| **check byte** after a confirmed trade (S2) | echo the local value | the save completes (`link.asm:2030-2049`); see open question Q5 |
| battle (any exchange) | `$F` FORFEIT, every time | `EnemyTriesToFlee` → "link battle canceled" (`engine/battle/core.asm:450-465`); also honoured at `:2413`, `:3958`, `:5387` |

**Trade-menu phase.** S0/S1/S2 come from a small model driven by the *pairs* already exchanged:

- `blocks` → S0;
- in S0, a pair with neither side `$F` → S1;
- in S1, the pair (2, 2) → S2, any other pair → S0;
- in S2, any pair → S0, then the next `blocks`.

The harness cross-checks the model against the true call site (the return address on the GB stack,
via the `.sym`) at every exchange of every test.

**Battle caveat.** `ForcePlayerMonChoice` (`core.asm:2845-2860`) exchanges without a FORFEIT
check. The harness must cover "peer gone while I pick a replacement after a faint". If that path
misbehaves, the fix is a stand-in rule (answer a legal switch value there, then FORFEIT at the
next exchange), not a ROM change.

**Side effects that remain real:**

- A link battle that ends by forfeit still writes the link record (`core.asm:8610`,
  `AddLastLinkBattleToLinkRecord` `:8903`), as on hardware.
- A trade that reached S2 is saved on this side. Whether the other side got its copy depends on
  timing. Hardware has the same exposure.

---

## 4. Relay server

### 4.1 Where it runs: stdlib, in `server.py`, flag-gated

| option | for | against |
|---|---|---|
| **A. Stdlib RFC 6455 in `server.py`** (recommended) | one process, one tunnel rule, no new dependency (the server is stdlib today, `web/server.py:16-26`); `ThreadingHTTPServer` already gives a thread per connection (`:147`) | must hand-roll ~250 lines of framing; a bug shares a process with the static site |
| B. `websockets` (asyncio) library | battle-tested framing | a pip dependency on the host, and a second event model beside `http.server` |
| C. Separate process (A's module run alone on another port) | failure isolation | a second service for manager-helper, plus a path-routed ingress rule |

**Recommendation: A.**

- The relay lives in a new module `web/link_relay.py`, imported by `server.py` and enabled only by
  `--link`. Without the flag, `/link` is a 404 and the server is byte-for-byte today's behaviour.
- The same module can run standalone (option C) with no code change if isolation is ever wanted.
- RFC 6455 for this subset is small and well specified:
  - the server side of the handshake only;
  - client frames must be masked;
  - text, binary, ping, pong and close;
  - 7/16/64-bit lengths;
  - **no fragmentation** (continuation frames → close 1003);
  - **no extensions**: `permessage-deflate` is declined, by not echoing it.

### 4.2 Protocol at the relay

- **Endpoint.** Only `GET /link` with `Upgrade: websocket`, `Connection: Upgrade` and
  `Sec-WebSocket-Version: 13` is accepted. Anything else gets `400`, or `426` for a bad version.
  The response carries `Sec-WebSocket-Accept = base64(sha1(key + 258EAFA5-E914-47DA-95CA-C5AB0DC85B11))`.
- **Origin check.** `Origin` must equal `https://waffle-time.christopherfretz.com`.
  `--link-origin` adds `http://127.0.0.1:<port>` for development and the harness.
- **Control plane.** The client's first frame is the only one the relay parses: ≤ 256 bytes of
  JSON.
  - `{"op":"create"}` → the server replies `{"op":"code","code":"word-word-word","ttl":120}`.
  - `{"op":"join","code":"…"}`.
  - On pairing, both sides get `{"op":"paired","role":"a"|"b"}`.
  - From then on, every frame from one socket is written unchanged to the other, as opaque bytes.
  - The code is **in-band**, so it never appears in a URL or an access log.
- **Codes.**
  - The format is three words drawn with `secrets.choice` from a fixed 1,024-word list
    `web/link_words.txt`: short, common, unambiguous, curated for no offensive words. That gives
    2^30 combinations. Codes are case-insensitive and joined with hyphens.
  - An unused code expires after **120 s** (close 4001).
  - A wrong code closes with 4002.
  - On pairing, the code is deleted from memory.
  - At most one pending code per creating socket.
- **The room dies with either connection.** The survivor gets close 4000, "peer gone". No state
  outlives the room.

### 4.3 Caps and timeouts (defaults; all `--link-*` flags)

| cap | default | on breach |
|---|---|---|
| frame payload | 4 KiB | close 1009 |
| messages per socket | 20/s sustained, burst 60 | close 4003 |
| room creations per client IP | 6/min | HTTP 429 at upgrade |
| join attempts per client IP | 12/min | 429 |
| concurrent link sockets (global / per IP) | 64 / 4 | 503 / 429 |
| handshake + first control frame | 10 s | drop |
| per-room idle (no data frame from a side) | 90 s | close 4005 both |
| room hard lifetime | 3 h | close 4006 |
| peer write blocked (slow reader) | 5 s | close both |
| server WebSocket ping (keeps the tunnel warm, detects dead TCP) | every 30 s, no pong in 60 s → close | — |

- **Client IP.** `CF-Connecting-IP` is trusted only when the TCP peer is `127.0.0.1`, which is
  always the case behind the tunnel. Otherwise the socket address is used.
- **Threads.** A separate semaphore bounds link threads, so a link flood cannot starve the static
  site's threads.
- **Logging.** One line per room event: created, paired or closed, with the close code, a duration
  and **no code, payload or IP**. The existing per-request `log_message` (`web/server.py:134-135`)
  prints only `GET /link`.

### 4.4 Cloudflare and what manager-helper must change

**Cloudflare Tunnel** proxies WebSockets on the same hostname/ingress rule with no extra
configuration. The zone's *Network → WebSockets* toggle must be on; it is on by default.
Cloudflare closes a WebSocket after ~100 s with no traffic. The 15 s client ping and 30 s server
ping keep connections well inside that.

**Asks for manager-helper (deploy owner):**

1. Run `server.py` with `--link` and the production origin. No other flag is needed; the defaults
   above apply.
2. Confirm the tunnel's ingress for `waffle-time.christopherfretz.com` points at the same local
   port and has no path filter that would exclude `/link`. Confirm `noTLSVerify`/`http2Origin`
   settings don't disable upgrades. With cloudflared's defaults, nothing needs changing.
3. Confirm that whatever supervises the process allows ~150 threads.
4. Run the smoke test after deploy:
   `scripts/link_relay_smoke.py wss://waffle-time.christopherfretz.com/link`. It creates, joins,
   echoes a frame, and checks the 4 KiB cap and the bad-code close.
5. Schedule the independent security review (section 4.5) before the Link panel is shown to
   players.

### 4.5 Threat model

**Against the server:**

| threat | mitigation |
|---|---|
| code guessing to hijack a pending room | 2^30 codes, 120 s TTL, 12 joins/min/IP. With 10 pending rooms an attacker with 100 IPs has ~4×10⁻⁵ odds per 2 minutes. The creator also sees the joiner's trainer name (from `hello`) and must tap **Accept** before the game links |
| connection, room or message floods | per-IP and global caps, per-socket rate limits, separate thread semaphore |
| slowloris on the upgrade | 10 s handshake deadline; `http.server` header limits |
| oversize frames and memory | 4 KiB cap checked *before* reading the payload; no reassembly; bounded per-room write queue |
| cross-site use of the relay | `Origin` check (no cookies or credentials exist, so this is about abuse, not CSRF) |
| privacy | the payload is never parsed after pairing and never logged; codes never logged; no persistence |
| spoofed client IP | `CF-Connecting-IP` honoured only from 127.0.0.1 |
| relay bug takes down the static site | flag-gated module, own semaphore, every exception caught per connection; option C exists |

**Against a player, from a hostile or buggy peer:**

| threat | mitigation |
|---|---|
| crafted blocks: overflowing patch offsets write past `wLinkPlayerPatchedData` (`link.asm:296-326`: up to +502 into a 422-byte region); unterminated mail patch loops (`:328-445`); unterminated names reach the text engine | the validator (section 5) rejects them **before** the ROM sees a byte; abort through `LinkTimeout` |
| out-of-range `act` (e.g. choosing OT mon 5 of 2: `ValidateOTTrademon` does not bound-check, `engine/link/time_capsule.asm:3-65`) | the validator bounds every `act` by stage and party count; optional ROM hardening (LK1f) |
| holding the player hostage (never answering) | Disconnect is always live; liveness timeouts |
| learning trainer name, ID and party | inherent to trading; the Accept step shows who you are linking with |
| JS injection through JSON | strict schema, no `eval`/`innerHTML`, peer text via `textContent` |
| the residual: a mon the validator accepts that is still "weird" (legal-shaped but hacked) | accepted risk (operator, 2026-10-15); pre-link snapshot (section 6) |

**ROM-sha check in `hello`.**

- Each side sends the sha256 of its ROM, already computed at boot (`romSha`, `web/app.js:402`,
  `:1113-1114`). The other side compares it with its own.
- A mismatch means `bye{rom-mismatch}` and the panel shows "Your friend is on build X, you are on
  Y. Both reload the page."
- The relay does not check this; it is a dumb pipe.
- `lk` (protocol version) must also match. `core` is informational: the link layer is
  core-version independent above the port API.

---

## 5. Client validator (`web/link_validate.js`)

**When it runs.** On the receiving side, on every `blocks` and `act`, *before* anything reaches the
emulator.

**What happens on failure.**

- **`blocks` failure:** send `bye{invalid-blocks:<field>}`, answer the pending action 5 with `$x0`.
  The local game prints "The link has been closed" (`link.asm:535-569`), and the panel names the
  failing field.
- **`act` failure:** treat it as a disconnect (section 3.5) with `bye{invalid-act}`.

**The peer's game never sees a byte that failed.**

The rules work on the decoded blocks. `tables.json` from the same build supplies species, moves,
items, base stats, growth rates, the charmap and the party layout.

| block | rule |
|---|---|
| RN (17) | bytes 0-6 = `$FD`; bytes 7-16 each ≤ `$FC` (the sender's own rule, `link.asm:630-638`) |
| party framing (450) | bytes 0-5 = `$FD`; **no `$FE` anywhere in bytes 6-446**, since `Link_CopyOTData` would silently drop it and shift every field (`link.asm:1204-1215`) |
| player name (11) | contains the terminator `$50` within 11 bytes; every byte before it is a printable charmap glyph; first byte not `$00`/`$FD` (`Link_FindFirstNonControlCharacter_SkipZero`, `link.asm:1237`) |
| count + species list (8) | count 1-6; species[i] for i < count ∈ 1..`$FC` or `$FD` (EGG); species[count] = `$FF`; entries after that `$FF` or `$00` |
| ID (2) | any |
| each struct i < count (48) | species byte = list species (or the egg's real species when the list says EGG); species ≤ `$FC` (MISSINGNO `$FC` per Q1); item 0 or a real holdable item in `tables.json` (no TERU-SAMA placeholders); moves ∈ 0..251, no duplicates except 0, move 1 ≠ 0; PP ≤ max PP incl. PP-ups for that move; level 1-100; exp ≤ exp(100) for its growth rate and ≥ exp(level); HP ≤ max HP; stats ≤ 999; status byte is one valid status (sleep 1-7 / PSN / BRN / FRZ / PAR, one at a time); CaughtLevel bits 5-0 ≤ 63 and the location byte any (gender bits handled by GF3) |
| structs i ≥ count | ignored by the game; required to be all `$00` (vanilla `ClearLinkData` leaves zeros, `link.asm:609-619`); rejects junk smuggling |
| OT names, nicknames (6×11 each) | for i < count: terminator within 11, printable glyphs; egg nickname free-form but terminated |
| padding (3) | `$00 $00 $00`, or the LK1f pyrite feature bytes (section 7) |
| patch lists (200) | bytes 0-2 = `$FD`; bytes 3-9 `$00` (the sender starts writing at `wPlayerPatchLists + SERIAL_RNS_LENGTH`, `link.asm:657`); then list 1 up to `$FF`, list 2 up to `$FF`, **both terminators inside the 200 bytes**. Entries are `$00` (skipped), or offsets 1..`$FC` (list 1) / 1..38 (list 2, since `2+6×48-$FC = 38`, `link.asm:658-672`). Each offset must point at a `$FF` byte in the received party data (only `$FE`→`$FF` replacements are ever listed, `:676-688`). No `$FD`/`$FE` after byte 2 |
| mail (390, Trade Center) | bytes 0-4 = `$20`; for every party mon holding a mail item, its 33-byte message is terminated and printable; metadata patch set: offsets 1..84 (`wLinkReceivedMailMetadata` is 6×14 bytes, `ram/wram.asm:1107`), terminated by `$FF` inside its 103 bytes; mon slots without mail all `$00`/`$21` filler as vanilla produces |
| mail (Colosseum) | must be empty |
| `act` Trade Center | v ∈ {0..count-1, `$F`} in S0; {1, 2} in S1; {0, 1, 2} in S2 (check byte) |
| `act` Colosseum | v ∈ 0-3 (move slot that exists), 4..4+count-1 (switch), `$D`, `$E`, `$F` |

All of this is pure functions over byte arrays, with no DOM. It is tested in Node with fixtures,
including every hostile case in section 8.

**Optional ROM hardening (LK1f).** Add `wCurOTTradePartyMon < wOTPartyCount` to
`ValidateOTTrademon` (`engine/link/time_capsule.asm:3-65`). It defends a pyrite player on a *real*
cable, where no validator runs. It is two instructions, with no WRAM/SRAM layout change.

---

## 6. Snapshot before link

**At Connect** (before the relay is even contacted), app.js writes one IndexedDB record,
`'prelink:' + romTitleKey`. It holds:

- `{state, battery, date, core, romSha, title, saveSig}`;
- the same fields `saveProgress` already writes (`web/app.js:1246-1300`).

There is one record, overwritten at the next Connect.

**While a link is active** (from Connect until the stand-in reports `LINKED_OUTSIDE` *and* the room
is closed, or the user disconnects):

- **Resume-state writes are suppressed; the battery is still written.** A resume state taken
  mid-link would restore the game inside an untimed link loop with no partner, a permanent
  "Waiting…". This covers the periodic save (`:2437-2439`), the 60 s timer (`RESUME_MS`, `:91`),
  `pagehide`/`visibilitychange` (`:2456-2472`), and `saveProgress(force)`.
  - The game's own saves (`TryQuickSave` before entering, `SaveAfterLinkTrade` after each trade,
    `link.asm:2541`, `:2049`) still reach the battery. They are the real record of a trade.
- **Disabled:** slot save and load (`:1386-1430`), fast-forward (`FF_SPEED`, `:130`; it would halve
  the game's handshake budgets in wall-clock time), preset loading, and the save editor's write
  path.
- **Wake lock:** a screen Wake Lock (`navigator.wakeLock`, Safari 16.4+) is held to keep iOS from
  locking the screen mid-trade.

**If the page dies mid-link** (iOS kills the tab, a crash): the boot logic already discards a
resume snapshot older than a newer battery save (`web/app.js:1150-1193`). The player boots from the
in-game save, which is the state after the last completed trade. The room is gone; the peer's
stand-in drains (section 3.5).

**Rollback.** The Link panel shows "Restore pre-link save (taken 14:32)" until the next Connect.

- It asks for confirmation, then writes the record's battery and loads its state through the same
  path as `loadSlot` (`web/app.js:1398-1430`): `coreOk`/size/`romSha` checks, `putState`,
  `syncClock`, `stirRng`, `huntRebaseline`, `huntReset`, `armFlush`.
- It then runs `saveProgress(true)` so the resume record agrees.
- **It is offered prominently after any abnormal end** (validator abort, peer gone mid-trade) and
  quietly otherwise.
- The panel says plainly that rollback does not take anything back from the friend's game.
  Rollback after a completed trade duplicates the mon; that is accepted between friends.

**Save compatibility.** No WRAM, SRAM, event-flag or map change in LK1a-e. The new IndexedDB key is
additive. Old builds ignore it.

---

## 7. Gender bits across a pyrite-pyrite link

**Background.**

- Pyrite stores explicit gender in CaughtLevel bits 7-6: `%10` male, `%11` female (GF2,
  `docs/GENDER-FIELD.md`).
- Vanilla Crystal uses those bits for time of day, so GF3 masks them on every link receive
  (`engine/link/link.asm:1994-1998`). Pyrite cannot tell a vanilla partner from a pyrite one
  (`docs/GENDER-FIELD.md:301-306`, `:563`).
- GF3 rolls wild gender independently of DVs. Masking therefore really flips the gender of about
  half of the traded mixed-ratio mons.

| option | how | pros | cons |
|---|---|---|---|
| **(a) ROM feature byte** (recommended) | `Link_PrepPartyData_Gen2` writes a pyrite marker into `wLinkSendPartyPadding` (3 bytes, `ram/wram.asm:1080`), e.g. `'P' 'Y' <feature bits>`. These bytes are sent but never read: vanilla zeroes them (`ClearLinkData`, `link.asm:609-619`), and `Link_CopyOTData` copies only the first 441 of the 450 (`link.asm:288-294`). On receive, pyrite latches "peer is pyrite with explicit gender" into a free, non-saved WRAM byte, and the GF3 mask (`:1994-1998`) is skipped when it is set | works on **every** transport: web, real cable, other emulators; a vanilla partner sends zeros, so it is masked exactly as now; no SRAM change | a ROM change: link code needs the cable-mode harness against a vanilla Crystal ROM to prove vanilla trades are unchanged |
| (b) WRAM flag set by the stand-in | link.js pokes "peer is pyrite" (known from the `hello` ROM sha) into a WRAM byte the ROM reads | simplest; no wire change | still needs the same ROM change to *read* the flag; works only in the web player; couples ROM behaviour to JS |
| (c) leave masked | — | zero risk | pyrite-to-pyrite trades lose explicit gender (the GF3 status quo) |

**Recommendation: (a), shipped as LK1f after the transport works.** LK1a-e ship with (c), the
current behaviour. For save compatibility:

- the latch is a WRAM byte in an unused hole that is not part of SRAM (choose and assert it in
  LK1f; `ram/wram.asm:2042` documents one candidate region);
- the padding is outside every saved structure;
- no SRAM byte changes meaning.

**Verification:**

- cable mode with pyrite ↔ vanilla `pokecrystal11.gbc`: vanilla's received data and the mask
  behaviour are unchanged;
- pyrite ↔ pyrite: gender is preserved;
- a hostile marker with the wrong feature bits: the mask is applied.

---

## 8. Headless harness plan

**Runtime.** Node 24 (`tools/emsdk/node/24.19.0_64bit/bin/node`, provisioned). Files go under
`web/test/`, which is not served (`STATIC` is an allowlist). Logs go to the session scratchpad
only.

**Loading the core.** Use the **shipped** `binjgb.js` + `binjgb.wasm`.

- The build is `-s ENVIRONMENT=web` (`web/vendor/binjgb-src/CMakeLists.txt:167`), so the harness
  passes `wasmBinary` (read from disk) and a minimal `window` shim.
- If the glue refuses, LK1b adds a test-only `ENVIRONMENT=web,node` build from the same source and
  records it. The shipped wasm then remains the one under test for behaviour via the identity
  gate.
- The joypad is driven through the existing `_set_joyp_*` exports.

**Fixtures.**

- Two battery saves made by the existing machinery (`scripts/gen_states.sh` →
  `scripts/state_to_sav.py`, as `scripts/gen_presets.py` does). In each, the player stands in a
  Pokémon Center 2F facing the trade/battle receptionists, with the Pokédex obtained
  (`maps/Pokecenter2F.asm:89, 191`).
- **`link_a`:** 6 mons, one holding mail, one Mew (exercises check byte b=1).
- **`link_b`:** 3 mons, one Egg, one Celebi (b=2). Includes a `$FE`-containing struct, e.g. a mon
  with an exp/stat byte of `$FE`, so the patch lists are non-empty.
- They live in `web/test/fixtures/`, not in the public preset manifest.

**Layers:**

1. **Unit** (Node): the validator over golden and hostile byte arrays; the message schema; the
   S0/S1/S2 model; feed construction.
2. **Cable mode (oracle).** Two instances, A and B, wired directly with no relay and no stand-in.
   - Run both in lockstep slices of ≤ 1,024 ticks.
   - When A completes an internal transfer, `emulator_link_clock_external(B, out)` completes B's
     armed transfer and returns B's byte. A's `idle_in` is kept equal to B's staged SB
     (`emulator_link_peek`).
   - This approximates a real cable at slice granularity. That is enough for Crystal's link code,
     which was built to tolerate jitter.
   - Record each side's WRAM after row 15 and the final SRAM.
3. **Stand-in mode.** The same two instances, each with its own link.js, connected through the
   **real relay** (`server.py --link` on 127.0.0.1) via a delay/fault proxy in the harness.
   - Assert that post-row-15 WRAM equals the oracle's: `wOTPartyData`, `wOTPlayerName`,
     `wLinkPlayer*` and mail. RNs are expected to differ, because they depend on frame timing;
     the harness instead asserts that the slave's `wLinkBattleRNs` equal the master's.
   - Assert that final SRAM matches the oracle for the same inputs.
4. **Browser E2E.** Two headless Chromium pages (Playwright, as in `scripts/web_clock_check.py`)
   run the real UI: Connect, code entry, Accept, one trade and one battle, through the same relay.

**Test matrix** (layer 3 unless noted):

| case | expectation |
|---|---|
| happy trade, both orders of arrival | both parties swapped, SRAM = oracle, check byte paths b=0/1/2 |
| two trades in a row | `gen` increments, second exchange correct |
| happy battle to the end | identical move-by-move logs on both sides (wBattleAction stream), link record written |
| one-way delay 0 / 200 / 1,000 ms, plus 30 % jitter | all pass; at 1,000 ms each stage still lands inside its native budget |
| peer never reaches the receptionist | native timeout text, link stays open, retry succeeds |
| peer 20 s late at action 5 | native "link closed", retry succeeds |
| disconnect mid-blocks (before the peer's blocks arrive) | `LinkTimeout` immediately, no WRAM change to the party |
| disconnect mid-menu, at S0, S1 and S2 | the endings of section 3.5, no trade on S0/S1, saved trade on S2 |
| disconnect mid-battle, incl. at `ForcePlayerMonChoice` | forfeit text, back in the Colosseum, no hang |
| hostile `blocks`: each validator rule violated once (≥ 30 cases incl. patch offset 251 in list 2, missing terminators, `$FE` in party data, name without `$50`, count 7, move 252, item TERU-SAMA) | `bye{invalid-blocks:<field>}`, the local ROM never received a byte, "link closed" shown |
| hostile `act`: out of range per stage | `bye{invalid-act}` and the graceful ending |
| ROM sha mismatch | `bye{rom-mismatch}` before anything touches the emulator |
| background tab (`pause` for 70 s) | peer sees the overlay, liveness timeout, graceful ending |
| slave pacing sweep (layer 2/3) | `ext_gap` corruption edge found; default has ≥ 2× margin |
| identity gate (section 2.4) | byte-identical with the link off |

**Relay unit tests** (Python `unittest`, stdlib, `web/test/test_link_relay.py`, real sockets on
127.0.0.1):

- handshake accept/reject (bad version, missing headers, bad `Origin`, wrong path);
- create/join/paired, bad code (4002), expired code (4001, using an injected clock), code reused
  after pairing;
- oversized frame (1009), unmasked client frame, fragmented frame (1003);
- message flood (4003), creation flood (429), concurrent-socket cap;
- idle (4005), lifetime (4006), slow reader;
- peer close → 4000 to the survivor;
- server pings;
- a log capture asserting no code, payload or IP appears.

**What cannot be tested headlessly:**

- iOS Safari's WebSocket behaviour when the screen locks or the app is backgrounded;
- the Wake Lock on iOS;
- cellular NAT and carrier-proxy behaviour;
- real Cloudflare tunnel latency (the smoke test covers reachability only);
- touch and keyboard UX for code entry.

These go to a two-phone playtest checklist in LK1g (cell ↔ cell and cell ↔ Wi-Fi; one trade, one
battle, one deliberate lock-screen mid-menu).

---

## 9. Work plan

| step | what | files | effort | verification |
|---|---|---|---|---|
| **LK1a** | binjgb link port | fork `src/emulator.c`, `emulator.h`, `emscripten/exported.json`; `web/vendor/binjgb/{binjgb.js,binjgb.wasm,VERSION.txt}`; `web/app.js` (`CORE_COMMIT`, `COMPAT_CORES`) | 1 day | identity gate (2.4), old resume state loads, browser checks pass |
| **LK1b** | Node harness + cable-mode oracle + fixtures | `web/test/harness.mjs`, `web/test/cable.mjs`, `web/test/fixtures/link_{a,b}.sav`, `scripts/gen_states.sh` (2 fixtures) | 2 days | a vanilla-style cable trade and battle complete in cable mode; WRAM snapshots recorded |
| **LK1c** | stand-in + validator | `web/link.js`, `web/link_validate.js`, `web/gen_tables.py` (`link` section) → `tables.json` | 3 days | layer 1, plus layer 3 against an in-process loopback relay: whole matrix except relay abuse |
| **LK1d** | relay | `web/link_relay.py`, `web/server.py` (`--link*` flags), `web/link_words.txt`, `web/test/test_link_relay.py`, `scripts/link_relay_smoke.py` | 1.5 days | Python suite; layer 3 through the real relay with the delay/fault proxy |
| **LK1e** | page integration | `web/index.html` (Link panel), `web/app.js` (onFrame hook, suppression, snapshot/rollback, wake lock, FF/slot disable), `web/server.py` `STATIC`, `web/gen_sw.py` precache | 2 days | layer 4 E2E in Chromium; `web_offline_check.py`, `web_layout_check.py` |
| **LK1f** | ROM: pyrite gender feature byte + `ValidateOTTrademon` bound | `engine/link/link.asm`, `engine/link/time_capsule.asm`, `ram/wram.asm` (one unused byte, asserted), `docs/GENDER-FIELD.md` | 1.5 days | cable mode pyrite ↔ vanilla Crystal (unchanged) and pyrite ↔ pyrite (gender kept); both real saves load (save-compat rule); independent review (engine change) |
| **LK1g** | security review, deploy, phone test | review brief; manager-helper deploy request (4.4); playtest checklist | 1 day + operator time | review findings closed; smoke test against production; two-phone playtest |

Order: a → b → c → d → e → (release) → f → g. The review in g covers d.

**Shipping.** Nothing player-visible ships before LK1e. LK1e's release note states:

- no WRAM, SRAM, flag or map change;
- the core is layout-identical and old resume states load.

### Open questions (with the default this doc assumes)

| # | question | default |
|---|---|---|
| Q1 | Is MISSINGNO. (`$FC`) tradable over the link? | **Yes.** It is a real pyrite species entry (`tables.json` marks it `glitch:true`), the vanilla link code accepts it, and the validator still checks its struct |
| Q2 | Where does the Link UI live? | **A "Link" panel in the existing menu**: Create code / Enter code, the peer's trainer name with Accept, live status, Disconnect, "Restore pre-link save" |
| Q3 | Which Kanto Cable Club? | **The existing Pokémon Center 2F behind every Center** (`maps/Pokecenter2F.asm:1070-1074`), gated on the Pokédex as now (`:89`, `:191`). No new map |
| Q4 | Battle Tower / Time Capsule ever? | **Not in LK1.** Time Capsule needs a Gen 1 partner (out of scope); the Battle Tower is not a link feature in Crystal without the mobile adapter |
| Q5 | Disconnect at the check byte (S2): complete the trade locally, or try to undo it? | **Complete it locally** (echo the value): the trade was already confirmed by both and the game saves next. Undo is what the pre-link snapshot is for |
| Q6 | Adopt the VC's 26-frame delays / longer action-6 budget in the ROM? | **No.** The stand-in answers timed steps locally; changing them would break vanilla-cable timing |
| Q7 | Gender handshake timing | **LK1f, after the transport ships** (section 7); masked until then |
| Q8 | Relay in `server.py` or a separate process? | **In-process stdlib behind `--link`** (4.1), with the standalone mode as the escape hatch |
| Q9 | Code length | **3 words / 1,024-word list / 120 s TTL.** 4 words if the security review asks |

---

## LK1a findings

**Status: done (2026-10-15).** The fork has the link port. The rebuilt core is committed. Both
the identity gate and the link smoke pass. Nothing player-visible changes: app.js never enables
the port; that waits for LK1e.

### What changed

**Fork:** `christopherfretz/binjgb`, branch `pyrite-rtc`, commit
`b91486087e74a6ab74eefd71143e96dd2401c5bd` on top of `8fb6fda`. The `web/vendor/binjgb-src`
submodule points at it.

In `src/emulator.c`:

| what | lines |
|---|---|
| `LinkPort` struct, defines, log-entry layout | `:696-728` |
| member `LinkPort link;` in `struct Emulator` | `:760` |
| comment pinning `SAVE_STATE_VERSION (2)` | `:805-808` |
| SC write stamps `ext_armed_at` | `:2685` |
| helpers `link_in_count` … `link_reschedule` | `:4080-4175` |
| `calculate_next_serial_intr` schedules the external completion | `:4180` |
| `serial_synchronize`: internal bits from the FIFO | `:4206`, `:4217` |
| `serial_synchronize`: external completion | `:4231-4234` |
| `emulator_read_state` re-arms or reschedules | `:5214` |
| defaults in `emulator_new` | `:5315` |
| the nine API functions | `:5424-5511` |

The nine prototypes are in `src/emulator.h`. The exports are in `src/emscripten/exported.json`
(`:16-24`).

**Core build** (`web/vendor/binjgb/build.sh`, unchanged; emcc 5.0.7, `-DWERROR=ON`, no
warnings). It reproduces byte-for-byte from the fork commit:

| file | new sha256 (b914860) | old sha256 (8fb6fda) |
|---|---|---|
| `binjgb.js` | `6d448da28611d53d8d57f0fdf0ea7788a1d35211346bed8ecee7cb37fdee1233` | `f011e737…720f` |
| `binjgb.wasm` | `056cf5b50366fd9a5b5591c39f7c1ee55f595c74fb2658f5367cba78a029254d` | `3818651d…18c8` |

The old pair also rebuilt byte-identically from a clean `8fb6fda` checkout, so the toolchain is
the same one.

`web/vendor/binjgb/VERSION.txt` now has the fork commit, the API list, the hashes and the gate
commands.

**`web/app.js:63-72`:**

- `CORE_COMMIT = 'c60e138d…+pyrite-rtc@b91486087e74'`.
- `COMPAT_CORES` gains `'c60e138d…+pyrite-rtc@8fb6fda5550d'`, so today's resume snapshots and
  slot states keep loading. The identity gate checks the layout claim behind that (`sizeof`
  unchanged); the existing state-size check in app.js remains the backstop.
- `make crystal` regenerated `web/sw.js` (untracked, built at deploy). Its precache manifest now
  lists the new hashes.

**Tests:** `web/test/`, Node 24, no npm deps.

- `core.mjs`: a small Node driver for the wasm core that mirrors app.js's boot sequence. This is
  the seed of LK1b's `harness.mjs`.
- `identity.mjs`: the 2.4 step 4 gate.
- `linkport.mjs`: a behavioural smoke test of the port on a synthetic 32 KB ROM (`di`, then
  `jr @`). It pokes SB/SC directly, so it tests the core rather than Crystal's link code.

### Identity gate (2.4 step 4)

Reference run: old core = `git show 4f09baa:web/vendor/binjgb/*` (8fb6fda); new core = the
committed blobs; ROM = `pokecrystal.gbc` built at `4f09baa` (`54d5da4d24e4`); fixed RTC (day 3,
10:00). The input script is seeded (mulberry32):

- it taps A/START through the title and Continue;
- then it walks, presses A/B and makes START-menu excursions (Pokédex, save dialog).

Screenshots of the run confirm each of those screens is reached.

| preset / seed | frames | checkpoints (every 60) | distinct screens | result |
|---|---|---|---|---|
| `celadon.sav` / 1 (default) | 20,000 | 333 identical | 253 | PASS (13.9 s) |
| `cerulean.sav` / 2 | 20,000 | 333 identical | 276 | PASS |
| `route4.sav` / 3 | 20,000 | 333 identical | 199 | PASS |
| `johto_complete.sav` / 4 | 20,000 | 333 identical | 248 | PASS |

In every run:

- state size is 199,608 on both cores;
- end SRAM is identical; the game saved during the run, so the check is not vacuous (celadon
  `126f0a95…`);
- end `emulator_write_state` bytes are identical (0 bytes differ; celadon `7fa96870…`);
- the header (`0x6b57a7e2`, version 2) is identical.

Cross-load: an **old-core** end state and a **new-core** end state are each loaded into a fresh
old core and a fresh new core and run for 600 frames. Old and new agree on every framebuffer
checkpoint and on the end state. Both also match the uninterrupted run's framebuffers.

### Link smoke (`linkport.mjs`): 46 checks, 0 failed

- **(a) Internal clock.**
  - Halfway through a byte, `SB = out<<4 | in>>4` (MSB first).
  - The peer byte is taken from the FIFO at the first clock edge.
  - IF bit 3 is raised.
  - With an empty FIFO, `idle_in` is shifted in.
  - Log: `{12→a5, int, FIFO}`, `{34→3c, int, FIFO}`, `{56→fe, int, idle}`.
- **(b) External clock.**
  - Still armed at +6,000 ticks; complete at +6,208 (gap 6,144 plus the 64-tick `run_until`
    granularity), with IF bit 3 raised.
  - A second byte armed straight away is held until `ext_last + gap`.
  - Mode 1 with an empty FIFO never clocks; a later `push_in` completes it at once (the armed
    and last stamps are already old).
  - Mode 2 sends `idle_in` at the gap, then the next idle byte only at `ext_last + ext_idle_period`
    (70,224).
  - Mode 0 never clocks.
- **(c) peek / clock_external.**
  - `peek = 0x25b` while armed external.
  - `clock_external(0x42)` returns `0x5b`; SB becomes `0x42`, IF is visible at once, and the
    entry is logged with the FORCED flag.
  - A second call returns -1. The FIFO is untouched.
  - `clear_in` empties it. Disabling while armed means no completion.
- **(d) Link disabled.**
  - Every API call is inert: push 0, pending 0, peek 0, drain 0, clock -1.
  - An internal transfer reads SB `$FF`, SC `$7F`, IF 8.
  - An external transfer never completes (SB `$34`, SC `$FE`).
  - All of these read-backs, and the state sha (`37e83049…`), equal the old core's.

### Browser checks (2.4 step 5): not run

`web_clock_check.py`, `web_offline_check.py` and `web_layout_check.py` need headless Chromium.
This container has the `playwright` Python package but no browser (`~/.cache/ms-playwright`
absent). The brief said not to install one, so they still need running with
`PROVISION_BROWSER=1 scripts/provision.sh`, then the three scripts with `tools/venv/bin/python`.

Mitigations so far:

- `node --check web/app.js` passes.
- The only app.js change is the two constants.
- The core's JS surface used by app.js is a strict superset of the old one: same glue options,
  same exports plus nine.

### Deviations from section 2 (and why)

1. **Extra private fields in `LinkPort`:** `int_latched`, `int_out`, `int_in`, `int_flags`,
   `out_overflow`.
   - The internal-clock byte is shifted in one bit per edge, so the peer byte and the outgoing
     SB must be latched at the first edge. The log needs the SB from the *start* of the
     transfer, which section 2.2 asks for.
   - `out_overflow` marks a dropped log entry. When `out_log` is full, the oldest entry is
     dropped and the next entry carries flag `0x80`, so the stand-in can tell it lost bytes.
2. **Log entry packing** (section 2.2 left it open):
   - bits 0-7 = out, 8-15 = in, bit 16 = clock (1 = internal);
   - bits 24-31 = flags (`0x01` from FIFO, `0x02` forced by `clock_external`, `0x80` overflow
     before this entry).
3. **Idle cadence formula.** A FIFO byte completes at `max(armed_at, last) + gap`. A mode-2 idle
   byte completes at `max(armed_at + gap, last + ext_idle_period)`. This is section 2.2's
   "(idle cadence for idle bytes)" made explicit.
4. **`emulator_read_state` re-arms the port.** It sets `ext_armed_at = TICKS`, `ext_last = 0` and
   drops a half-latched internal byte, then reschedules. A state loaded mid-transfer is then
   paced from the load, not from stale ticks. When the port is disabled this only recomputes
   `next_intr_ticks` to the value the state already holds, which the gate confirms.
5. **`clock_external` also sets `INTR.if_`**, as well as `new_if`, so JS sees the interrupt
   immediately without another `run_until`. **`peek` returns 0 while disabled**, in line with
   "no-ops until enabled".
6. **Known benign asymmetry.** Suppose the new core saves a state while the port is enabled and
   an external transfer is armed. That state holds a finite `serial.next_intr_ticks`. Loaded into
   an *old* core:
   - the transfer still never completes there, as before;
   - it only costs one extra `serial_synchronize` per instruction until SC is rewritten.
   
   The identity gate cannot hit this because the port stays off. It only matters if someone
   rolls the core back during a link session.
7. **Pre-existing, not ours: APU resample accumulator.** `apu.channel[1].accumulator`
   (state offset 198,440) can differ by one after a load → run, because it depends on the audio
   buffer, which is outside the state. Old→old does it too. The cross-load therefore compares
   fresh old against fresh new, and the framebuffers against the uninterrupted run, rather than
   byte-comparing a resumed state against the uninterrupted one.
8. **Pre-existing app.js bug, reported only (out of scope).** `destroyEmulator`
   (`web/app.js:898-903`) calls `_emulator_delete` and then `_free(romPtr)`. `emulator_delete`
   already frees the ROM (`emulator.c:5331`, `file_data_delete`), so this is a double free. In the Node driver it caused
   "memory access out of bounds" on the next allocation. In the page it fires on ROM swap and
   reset; emmalloc seems to tolerate it there so far. It is worth a one-line fix (drop the
   `_free`) in LK1e.
9. **Tooling.** `cmake` was installed in the container with apt, which is what
   `PROVISION_EMSDK=1` does. `make` came from `scripts/provision.sh`.

### Re-running the gate

From the pyrite checkout (`hack/`), with the workspace's emsdk Node 24:

```sh
NODE=../tools/emsdk/node/24.19.0_64bit/bin/node
$NODE web/test/identity.mjs                      # old = 4f09baa's blobs, new = working tree
$NODE web/test/identity.mjs --sav web/presets/cerulean.sav --seed 2
$NODE web/test/linkport.mjs
```

Both exit 0 on pass. For the *next* core change, pass `--old-rev <the last pyrite commit that
shipped a core>` (or `--old-dir`), so the gate compares against what phones actually run.

Rebuilding the core:

```sh
PROVISION_EMSDK=1 scripts/provision.sh
EMSDK=$PWD/tools/emsdk hack/web/vendor/binjgb/build.sh
```

Then compare the printed sha256s with `VERSION.txt`.

---

## LK1b findings

LK1b delivers section 8's harness and cable-mode oracle (layer 2), the two fixtures and the
oracle snapshots. All three cable scenarios pass and are deterministic: a second run with
`--no-write` reports every oracle file identical.

| scenario | result | frames | wire bytes | wall time |
|---|---|---|---|---|
| trade | PASS 33/33 | 14,982 | 3,589 | 14 s |
| battle | PASS 17/17 | 9,816 | 1,119 | 10 s |
| pacing | PASS 3/3 | 3,552 + replays | 1,196 fed | 6 s |
| all (`cable.mjs`) | exit 0 | | | 30 s |

### Files

- **`web/test/harness.mjs`** is the library. It provides:
  - N cores on one wasm module, the shipped `binjgb.js`/`.wasm`, booted from a `.sav` + ROM;
  - lockstep frames;
  - per-core input *drivers*, which are generators;
  - play.py's grammar (`script()`: `A*4 TAP:A*3 WAIT*60 MOVE:UP*3 FACE:UP UNTIL:TEXT AUNTIL:TEXT
    WRAM:sym SHOT`);
  - `.sym` reads and writes, with banked WRAM handled;
  - screen text, the framebuffer sha256 and a PNG;
  - the LK1a `LinkPort` per core (`enable/ext/idle/peek/drain/clockExt/putState`);
  - JSON dumps (`core.dump()`).
- **`web/test/cable.mjs`** contains the zero-latency cable, the stage segmenter and the three
  scenarios.
- **`web/test/fixtures/link_{a,b}.sav`** are the fixtures. `*.sa*` is git-ignored, so they were
  added with `-f`. They are made by `scripts/gen_link_fixtures.py` in the context repo.
- **`web/test/oracle/{trade,battle,pacing}.json`** hold the snapshots (17 KB, 7 KB and 2.5 KB).
  Each one records:
  - the ROM and fixture sha256s;
  - the stage rows;
  - the nybble run-lengths;
  - every bulk block as the receiver stored it;
  - end-of-run WRAM excerpts and the SRAM/framebuffer hashes.

### Fixtures

Both fixtures start from the `cerulean` web preset, which has the POKéDEX that the receptionists
require. Each one is booted through CONTINUE in the PyBoy harness and walked to CERULEAN
POKéCENTER 2F (map 20,1), at (5,3) facing the TRADE receptionist. The generator then does four
things:

1. It rewrites the trainer name and ID, re-badging the starter PIKACHU.
2. It rebuilds the party with the ROM's own `TryAddMonToParty`. The EGG goes in through `GiveEgg`,
   which gives it HP 0. This matters: `CheckPlayerPartyForFitMon` only ORs HP, so an egg with HP
   would count as able to fight and the battle would never end.
3. It makes the POKéDEX agree with the party and clears the species each side will receive.
4. It saves through START > SAVE and pokes the mail letter into `sPartyMail` and its backup.

The output is deterministic and takes about 1 s.

| | trainer | ID | party (species/level) | planted bytes |
|---|---|---|---|---|
| `link_a` (master) | ALPHA | 11111 ($2B67) | MEWTWO 70 (PSYCHIC only), PIKACHU 6, MEW 5, RATTATA 4, PIDGEY 4, SPEAROW 4 | MEW HP stat exp $FE00; RATTATA holds FLOWER_MAIL "HELLO FROM / THE CABLE!" |
| `link_b` (slave) | BRAVO | 65090 ($FE42) | MAGIKARP 5, CELEBI 5, EGG (TOGEPI) 5, PIKACHU 6 | ID $FE42, so a $FE in the header and in every struct |

Deviations from section 8:

- `link_b` has 4 mons, not 3, because the starter PIKACHU is kept.
- The fixtures come from a dedicated generator, not from `scripts/gen_states.sh` (section 9). The
  chain has no link-ready state, and patching identities on top of a preset is simpler.

The roles come out as A master and B slave every run. This is deterministic, not designed: A
reaches the receptionist first.

### Scripted paths

- **Trade.**
  1. Both sides talk to the receptionist at (5,2) and say YES to save.
  2. Both walk to their seats and sit.
  3. Trade 1: A's MEW (slot 3) for B's MAGIKARP (slot 1).
  4. Trade 2: A's RATTATA + mail (now slot 3) for B's CELEBI (slot 1).
  5. Both CANCEL.
  6. After `ExitLinkCommunications`, `MAPSETUP_LINKRETURN` reloads the room with the player still
     on the seat, so each side walks out:
     - master from (3,4): `MOVE:DOWN*1 MOVE:RIGHT*1 MOVE:DOWN*2`;
     - slave from (6,4): `MOVE:DOWN*1 MOVE:LEFT*2 MOVE:DOWN*2`;
     - then hold DOWN to the 2F.
  7. Both SAVE, then reload through CONTINUE.
- **Battle.**
  1. From (5,3), walk `MOVE:DOWN*1 MOVE:RIGHT*4 MOVE:UP*1 FACE:UP` to the COLOSSEUM receptionist
     at (9,2). The direct route is blocked by the counter at (7,3).
  2. The fight is a state machine on screen cues:
     - FIGHT/PACK/RUN menu: A. "PKMN" renders as "PM" in this font, so it is not a usable cue.
     - Move menu (`TYPE/`): A.
     - Forced switch (`Which PM?`, no FIGHT on screen): cursor to the first fit mon, then A.
     - RECORD screen: B. It appears while `wBattleMode` is still nonzero.
  3. Walk out as for the trade.

### Asserted values

**Trade (33 checks).**

- **Cable:**
  - 0 mismatches;
  - exactly 1 dropped byte, which is the slave's exit $00 (see below);
  - roles A master, B slave;
  - 3 bulk exchanges: one on entry and one after each trade.
- **Before trading:** each side saw the other's party and name. The slave adopted the master's RNs
  (`2884e03a93ec4399ef43` on both).
- **Final party species, WRAM = SRAM:**
  - A: MEWTWO PIKACHU PIDGEY SPEAROW MAGIKARP CELEBI;
  - B: EGG PIKACHU MEW RATTATA.
- **Each traded mon:** its 48-byte struct is byte-identical on the receiving side, its OT name is
  the sender's, and its nickname is kept.
- **$FE handling:**
  - BRAVO's ID $FE42 arrived in A's MAGIKARP and CELEBI;
  - MEW's stat exp $FE00 arrived at B;
  - no raw $FE in either party block on the wire;
  - both patch lists are non-empty: toMaster `fdfdfdfdfd00…0109396999ffff`, toSlave
    `fdfdfd00…006effff`.
- **Mail:** RATTATA still holds FLOWER_MAIL at B, and B's `sPartyMail` slot 4 equals A's letter.
- **POKéDEX:** caught set for each received species, in WRAM and SRAM (A: MAGIKARP, CELEBI; B:
  MEW, RATTATA).
- **Ending:** both back on 2F with `wLinkMode` 0, and both saves reload through CONTINUE with the
  traded party.

**Battle (17 checks).**

- **Cable:** the same drop and mismatch rules; 1 bulk exchange, with no mail block.
- **RNs:** the slave adopted the master's (`be57ef851baf43d667f8`). The RNs on the wire equal the
  RNs in both games. Both sides consumed the same number of RNs (2 / 2).
- **Result:**
  - A: `wBattleResult` 0, "BRAVO was defeated";
  - B: `wBattleResult` 1, "Lost against".
- **Moves:** B was forced to switch twice, to CELEBI (slot 2) and then to PIKACHU (slot 4, past
  the EGG). A used PSYCHIC 3 times.
- **RECORD screens:** both agree.
- **Party:** both parties are byte-unchanged after the battle, because `LoadPokemonData` restores
  the party saved at the receptionist.
- **SRAM `sLinkBattleStats`:** A 1-0-0 against BRAVO (65090); B 0-1-0 against ALPHA (11111).
- **Ending:** both back on 2F.

### Observed stage sequence (trade), against the 1.3 table

Frames are from boot. "idle" is a byte pair outside any stage, shown as master/slave.

| row | frames | observed |
|---|---|---|
| 2 | 1537-1572 | 36 × `$01`/`$00` (the slave is not yet armed, so it reads as its bit-7 fill), then one `$01`/`$02` that settles the roles |
| 4 | 2596-2611 | `$61`, 15 bytes |
| 5 | 2624-2626 | `$D1`, 3 bytes |
| 8 | 3230-3259 | `$75`, 29 bytes |
| 9 | 3307-3320 | `$76`, 13 bytes |
| 10 | 3333 | one `$00/$FD` idle, then 3 frames |
| 11-14 | 3336-3422 | bulk, 1,063 bytes |
| 16T | 3690-7083 | 3 nybble exchanges of 13 bytes |
| 17T | 7210-7378 | rows 8, 9 and the 1,063-byte bulk again |
| 16T | 7644-11007 | 3 more |
| 17T | 11134-11303 | rows 8, 9 and the bulk again |
| 16T | 11629-11648 | CANCEL, `$7F` × 18 |
| 18 | 11702 | linked: the slave's exit `$00`, dropped |
| 18 | 11953-11974 | 2 unlinked bytes after `CloseLink` |

The battle follows the same rows 2-9 at almost the same frames. It has a 672-byte bulk at
3343-3397. Its 16B nybbles (`$80`/`$84`/`$85`/`$87`) run from 4889 to 7919, in runs of 13 to 103
bytes, because the side that waits keeps resending its byte. Row 18 bytes fall at 9576-9625.

**Discrepancies with the table:**

1. **Row 18, "M: 1 B".** Both sides start an internal `$00` in `ExitLinkCommunications`. The
   master's lands on the still-armed slave. The slave's goes to nobody, which is also true on
   hardware. Later, 2 more bytes go out unlinked during `CloseLink`/reset. The stand-in must
   tolerate a stray `$00` from the slave after the session; `checkDrops` asserts exactly this
   case.
2. **Row 10, "idle byte $FE".** Between nybble runs, the slave's idle byte is `$FE` and the
   master's is `$00`. The byte just before the bulk is `$FD`, because the slave has already
   staged its preamble.
3. **Row 8 length.** On entry the run is 29 bytes, because the second side arrives later. In the
   two repeats it is 13-14 bytes.
4. **Rows 11-14 byte count.** The sum of the blocks is 17+450+200+390 = 1,057, but the burst is
   1,063 bytes, 6 more. The battle shows the same: 17+450+200 = 667 against 672. The cause is
   `Serial_ExchangeBytes`, which resends the current byte for every non-`$FD` it receives before
   the first `$FD`. With the one-transfer lag (1.4 item 1), that is at least one extra byte per
   block.

   Replaying each receiver over the wire, the slave consumes 1,064 bytes of the master's stream
   (673 in battle). That is one byte past the burst cut, so the oracle's last slave-side block
   reads one byte short (mail 389, battle patch 199). This is an artefact of the segmentation
   only: the game data checks above pass.
5. **Block starts.** The receiver stores everything after the first `$FD`, so each stored block
   starts with the leftover preamble bytes. One example is toMaster RN = 9 × `$FD` + 8 bytes.
   `Link_CopyOTData` and the patch loop skip `$FD` by value.

   The mail block comes through `ExchangeBytes`, which drops exactly one byte. The slave stores
   `$20` × 5 first; the master stores `$00 $20 …`. This is the same one-transfer lag. The game
   skips `$20` by value.

   The stand-in feed (LK1c) should therefore be built from the *sender's* blocks with the native
   preambles, not from the oracle's stored blocks.

The first 16T run of each trade carries the menu choices. Master `$72` against slave `$70` is
party index 2 (MEW) against index 0 (MAGIKARP). The later runs are the confirmations and the
Mew/Celebi check byte (`link.asm:2036`). The check byte is not asserted separately.

### Pacing sweep (`ext_gap`)

**Method.**

- **Snapshot:** the slave's state is snapshotted at frame 3334, two frames before the trade's
  first bulk exchange.
- **Feed:** the master's 1,063 burst bytes, taken from the cable run.
- **Replay at each gap:** restore the snapshot with the LinkPort in `ext_mode 1` at that gap, push
  the whole feed into the in-FIFO, and run until the FIFO is empty and the trade menu (CANCEL) is
  on screen.
- **Pass criteria** (both by sha256):
  - the slave's received WRAM equals the cable run's (`wOTPlayerName` to `wOTPartyDataEnd`,
    `wLinkOTMail`, `wLinkReceivedMail`, `wLinkBattleRNs`);
  - the slave's own out bytes equal what it sent on the cable.

**Results.**

| gap | result |
|---|---|
| 12288 to 1568 | pass. 6144 replays the cable result exactly; 195 frames to the menu |
| 1536 | **fail**. Received data is still right, but the slave's out stream goes wrong at byte 472: it is clocked before it has staged its next SB |
| ≤ 1280 | fail. Received data is corrupt from byte 2 and the menu is never reached |

- **Edge:** 1,568 ticks, found by bisection to 32-tick resolution.
- **Margin:** the default 6144 is **3.92×** the edge. **No change to the C default is
  recommended.**
- **Scope:** this covers only the bulk exchange. That is the only hardware-paced stage; the
  nybble stages are frame-paced.

### Re-running

From `hack/`:

```sh
NODE=../tools/emsdk/node/24.19.0_64bit/bin/node
$NODE web/test/cable.mjs --no-write                  # all three; compare with the oracle
$NODE web/test/cable.mjs --scenario battle --no-write
$NODE web/test/cable.mjs                             # rewrite the oracle (after a ROM or fixture change)
```

Options:

- `--scenario trade|battle|pacing|all`;
- `--fixtures DIR`;
- `--oracle DIR`;
- `--slice N`, the cable granularity: a divisor of 3584, default 512.

The run exits 0 on pass. It is single-threaded, about 30 s total. On a failure it prints both
cores' position, frame, `wLinkMode`, serial status and screen, plus the cable counters and stage
rows.

To rebuild the fixtures, run this from the context repo. It needs `hack/pokecrystal.gbc` built:

```sh
tools/venv/bin/python scripts/gen_link_fixtures.py   # writes hack/web/test/fixtures/
```

After rebuilding the ROM or the fixtures, rerun without `--no-write` and commit the oracle
diff.

### Harness lessons (for LK1c-e)

- **Shared joypad.** binjgb's joypad is a single static per wasm module. Each core's buttons must
  be set immediately before that core runs, never for all cores up front.
- **Lazy serial sync.** binjgb synchronises serial lazily. A transfer due exactly at the end of a
  run is only logged at the next `serial_synchronize`, which `peek()` performs. So `peek()` before
  `drain()`, and never discard a drained log.

  An early cable version drained and discarded the peer's log inside `peek()`. It lost about one
  master byte in 18. The game still traded, because the preamble skip absorbed the loss, but the
  wire log was wrong.
- **Unarmed peer.** An unarmed peer must read as its bit-7 fill (`$00`/`$FF`), not as its SB.
  Otherwise the role race in `WaitForLinkedFriend` settles on a stale `$01`/`$02`.
- **Latch rule.** Clock a peer only if it was armed when the byte latched (3,584 ticks before
  completion) *and* is still armed. A peer that arms part-way through a byte must not complete.
- **Room reload.** After a trade or battle the room reloads with the player still seated, and the
  stand-in must not assume the player is back on 2F. LEAVE's `CloseLink` runs only once the player
  walks out.
- **Link battle UI.** It shows "PM" for PKMN. The RECORD screen waits for A or B before the battle
  ends.

### Not done / not verified

- **Layer 1 unit tests** (validator, message schema, feed construction) and **layers 3-4** belong
  to LK1c-e. The modules they test do not exist yet.
- The pacing sweep covers the trade's first bulk exchange only. It does not cover the battle bulk
  or the nybble stages.
- Only the default slice of 512 ticks was run for the oracle. `--slice` accepts other divisors of
  3584, but no result is recorded for them.
- **Not exercised:**
  - the check-byte paths b=1/2 are not asserted directly; the MEW and CELEBI trades exercise them
    and both trades complete;
  - the `$FE` path through the mail patch set;
  - a draw, a forfeit or a time-out;
  - the battle with the slave winning.
- **Fixture ROM dependency.** The fixtures and oracle are tied to the ROM sha256 recorded in each
  oracle file (`54d5da4d…`). Any ROM change that moves WRAM or Cable Club code means regenerating
  both.

---

## LK1c findings

LK1c delivers the stand-in (`web/link.js`), the validator (`web/link_validate.js`), the `link`
section of `tables.json`, and test layers 1 and 3: unit tests, and two cores driven by two
stand-ins through an in-process fake relay. **No ROM change.** `tables.json` is still a build
product (`make crystal` runs `gen_tables.py`) and is not committed.

| suite | result | wall time |
|---|---|---|
| `link_unit.mjs` | PASS 161/161 (63 hostile validator cases, 12 garbage inputs) | < 1 s |
| `link_e2e.mjs` | PASS 12/12 scenarios (202 checks) | 81 s |

### Files

| file | what | where to look |
|---|---|---|
| `web/link.js` (652 lines) | stand-in, UMD/CommonJS, no DOM | constants `:42-55`; base64 `:58-70`; message schema `FIELD`/`SCHEMA` `:74-101`; `parseMessage` `:105`; `encodeMessage` `:129`; `buildFeed` `:139`; `create` `:151`; peer-message handler `handle` `:226` (peer stage machine `:252-295`); `refuse`/`fail`/`closeNow`/`linkUp`/`startDrain`/`disconnect` `:298-350`; nybble feeder `feedNybble`/`stepFeeder` `:358-375`; `endVisit` `:377`; `onFrame` `:395` (stages: outside+desk `:424`, connected `:464`, rcpt `:473`, sync `:484`, room/menu `:494`, blocks `:513`, bulk `:559`); `readBlock` `:584`; act exchange + trade-menu phase model `exchange` `:594`; drain answers `drainAnswer` `:627`; `state()` `:636`; hello `:645` |
| `web/link_validate.js` (250 lines) | validator, UMD/CommonJS, pure | `nameOk` `:42`; `maxPP` `:52`; `monReasons` `:56`; `rnReasons` `:97`; `patchOffsets` `:109`; `partyReasons` `:139`; `mailReasons` `:168`; `validateBlocks` `:211`; `validateAct` `:232` |
| `web/gen_tables.py` | `link` section (`:934` on) | WRAM/HRAM addresses, block banks/addresses/lengths, party and mail layouts (asserted against the `.sym` spans), serial and battle constants, species growth rates, exp table (with the 24-bit wrap), move PP, holdable items, mail items, charmap glyphs |
| `web/test/link_unit.mjs` | layer 1 | schema, feed, validator, `validateAct` |
| `web/test/link_e2e.mjs` | layer 3 | `Relay` `:49`; `setup` `:92`; `recover` (drives a game home from any link screen) `:294`; scenarios `:148-530`; `main` `:532` |
| `web/test/cable.mjs` | LK1b, unchanged behaviour | helpers now `export`ed for the e2e; `main()` runs only when executed directly |

**API.** `create({core: {port, read}, transport, tables, ui, role, rom, build, coreRev, name, now,
onBeforeLink})` returns `{onFrame(), isLinked(), disconnect(), state(), onBeforeLink}`.
`onFrame()` must run after every emulated frame. `state()` returns the session, visit stage,
trade phase, gen/seq, the peer's stage, counters (`sent`, `recv`, `bulk[]`, `fifoLeft[]`,
`visits`) and an event log (`linked`, `desk`, `connected`, `rcpt`, `sync`, `room`,
`blocks-out`, `invalid-blocks`, `bulk`, `bulk-done`, `act-out`, `act-in`, `visit-end`,
`refuse`, `fail`, `drain`, `closed`, ...), which is what the e2e asserts on.

### Message schema (as built)

Every frame is one JSON object. Every type has an exact key set: a missing key, an extra key, an
unknown `type` (including prototype names such as `constructor`), a field out of range, a frame
over 4,096 characters, non-JSON or a non-object fails parsing. A failed parse is
`fail('internal')`: `bye{internal}`, then drain.

| type | fields (validated) | sent when |
|---|---|---|
| `hello` | `lk` int 0-1000 (=1), `rom` 64 lowercase hex, `build` ≤ 40 printable, `core` ≤ 64 printable, `name` ≤ 16 chars without control characters, `role` `a`\|`b` | at `create()` |
| `desk` | `left` int ms 0-60000 (the sender's row-2 budget left) | every 30 frames while the local game probes at the receptionist (row 2) |
| `rcpt` | — | row 4 seen (`hi\|1` shifted out) |
| `sync` | `room` 1\|2 | row 5 seen (`$D0\|room` shifted out) |
| `blocks` | `gen` int, `rn` 17 B, `party` 450 B, `patch` 200 B, `mail` 390 B or 0 B (base64; sizes checked after decode) | action 5 seen (`hi\|5` shifted out with the timeout armed) |
| `act` | `gen`, `seq` int 0-65535, `v` int 0-15, `mode` 2\|3 | an untimed nybble exchange armed (`wOtherPlayerLinkAction=$FF`) |
| `ping` / `pong` | `t` finite number | every 15 s while linked / reply |
| `pause` / `resume` | — | parsed and honoured (60 s pause = peer gone); **sent by the page (LK1e), not by `link.js`** |
| `abort` | `stage` ∈ desk, connected, rcpt, sync, blocks, menu | the local visit ended early (row 2 over, action-5 timeout) |
| `bye` | `reason` ∈ user, rom-mismatch, role, `invalid-blocks:<field>`, invalid-act, timeout, internal, peer-gone | any end of the session; the sender then drains and closes |

Ordering is enforced per peer visit: `desk → rcpt → sync → blocks(gen n+1) → act(gen, seq+1)…`.
Anything out of order is `fail('internal')`. Early messages are queued (one `blocks`, 8 `act`s).
A `desk` after `rcpt` means the peer started a new visit; an `abort` makes the stand-in ignore
the rest of that peer visit (messages already in flight).

### Deviations from section 3 (and why)

1. **No per-message `v:1`.** The protocol version travels once, in `hello.lk`; a mismatch is
   refused as `rom-mismatch` together with the ROM sha. Saves 6 bytes per frame and there is no
   mixed-version session to route.
2. **`hello` carries `role`**, and a same-role pair is refused (`bye{role}`). The relay assigns the
   roles; this catches a relay bug before both games try to be master.
3. **`name` is ≤ 16 characters**, not ≤ 7. It is a page-level display name (`textContent`), not the
   in-game trainer name, which travels inside the party block and is validated there.
4. **Two new messages, `desk` and `abort`.**
   - Row 2's role race is timed (the game's own budget). The stand-in shifts its role byte into the
     local game's `$01` probe only when the peer's `desk` is fresh (≤ 1.5 s old), the peer has
     > 1.5 s of its budget left and we have > 1 s of ours. Otherwise one game connects while the
     other times out, which leaves the two visits out of step. `left` is computed from
     `wLinkTimeoutFrames`.
   - `abort{stage}` tells the peer that this visit ended locally (row 2 over, action-5 timeout), so
     the peer stops waiting for messages that will never come and drops ones in flight.
5. **Stage detection uses the bytes the game shifts out** (from the LinkPort drain log: the `$01`
   probe, `hi|1`, `$D0|room`, `hi|5`, `hi|6`) plus `wLinkMode`, `wPlayerLinkAction`,
   `wOtherPlayerLinkAction`, `wLinkTimeoutFrames`, `hSerialConnectionStatus` and `IE`. There is
   no PC or return-address tracking.
6. **The phase-model cross-check against the GB stack return address (3.5) was not built.** The
   e2e instead asserts the outcomes the model drives: the oracle's end state on the happy paths,
   and the right in-game text on every cut.
7. **Row 8 drain (`$x0`) prints "Too much time has elapsed. Please try again."**
   (`_LinkTimeoutText`), not "The link has been closed…". The validator-failure path is the same
   `$x0`. Section 3.5 and section 5 name the wrong string; behaviour is as intended.
8. **Prompts auto-advance.** In link mode `PromptButton` is `DelayFrames 65`
   (`home/joypad.asm:397`), so every timeout text clears by itself. After `LinkTimeout` the special
   returns and the room reloads (`newloadmap MAPSETUP_LINKRETURN`) with the player seated and
   `wLinkMode` still 2/3; `CloseLink` runs when the player walks out to 2F. The stand-in ends the
   visit at that point (`visit-end`), and the session itself stays open for another visit.
9. **`ForcePlayerMonChoice` needs no special rule.** Draining answers FORFEIT at every battle
   exchange. At the replacement pick (no FORFEIT check) the game takes it as a switch byte, and the
   very next exchange's FORFEIT ends the battle with "Enemy <mon> fled!" on both sides
   (cut-battle).
10. **Battle-end `wLinkBattleRNs` differ from the cable oracle.** The master rolls them at a
    timing-dependent frame. The e2e asserts A's RNs = B's RNs, and `wPokemonData` against the
    oracle.

### Validator rules (as built)

The ruleset is section 5's, with these differences. **Stricter or added:** patch-list entries must
be strictly increasing and in 1..252 / 1..38 (`$00` inside a list is rejected; a native sender
never writes one); the exp lower bound uses the 24-bit wrapped Medium Slow table; Pokérus (days
≤ 4, and days only with a strain); every string's first byte must be a charmap glyph; the mail
message's first byte cannot be `$20`/`$FE`; the mail patch set may not hit the same offset twice.
**Not implemented (follow-ups, none lets the receiver index outside its buffers):** structs and
names for i ≥ count all `$00`; species-list entries after the `$FF`; padding bytes; CaughtLevel
bits; filler in mail slots whose mon holds no mail; the Colosseum move slot must exist on the
active mon (0-3 are always accepted); the egg nickname is checked like any nickname.

| rule (reason string prefix) | unit cases |
|---|---|
| `mode N` (only 2, 3) | mode 1 |
| `rn.length`, `rn.preamble[i]`, `rn[i] $FD/$FE` | 16 bytes, preamble byte, `$FE`, `$FD` |
| `party.length`, `party.preamble[i]`, `party[i] raw $FE` | 449 bytes, preamble byte, raw `$FE` |
| `party.name …` (empty / no terminator / first byte not a glyph / control byte) | empty, control byte |
| `party.count N` (1-6) | 0, 7, 255 |
| `party.species[count] not $FF`, `party.species[i] $xx` (1..252 or EGG) | both; list 0, list `$FF` |
| `party.mon[i].species` (1..252, = list unless list is EGG) | 0, 253, `$FF`, list mismatch; 252 and EGG-in-list **accepted** |
| `…item` (0 or holdable) | non-holdable |
| `…move1 empty`, `…moveN after an empty slot`, `…moveN $xx`, `…moveN duplicate`, `…ppN on empty slot`, `…ppN x > max` | all six; PP 63 with 0 and 3 PP Ups |
| `…level` (1-100), `…exp outside lo..hi` | 0, 101, exp 0, exp `$FDFDFD` |
| `…hp > max`, `…statN` (≤ 999), `…status`, `…pokerus` | all |
| `party.ot[i] …`, `party.nick[i] …` | no terminator (both), first byte not a glyph |
| `patch.length`, `patch.preamble[i]`, `patch[i] not zero` (before/after the lists), `patch list K offset N out of range`, `… not increasing`, `… -> party[x] is $yy, not $FF`, `… unterminated` | 199 bytes, preamble, both zero areas, 253 / 0 / list-2 39, not increasing, non-`$FF` target, unterminated (`patchOffsets` directly) |
| `mail.length`, `mail.preamble[i]`, `mail.messages[0] starts with …`, `mail[i] raw $FE`, `mail.patch offset N out of range`, `… -> $xx, not $FF`, `mail.patch unterminated` | 389 bytes, preamble, raw `$FE`, offsets 0 / 85, non-`$FF` target, repeated offset |
| per mail-holding mon: `mail[s].message no terminator`/`byte k`, `mail[s].author …`, `mail[s].species`, `mail[s].type` | all five, plus a valid held mail **accepted** |
| `mail.length 390 in the Colosseum` | Colosseum with mail |
| `internal: …` (never throws) | 11 garbage inputs and a broken tables object |
| `validateAct`: S0 `$F` or < peer count; S1 {1, 2}; S2 {0, 1, 2}; battle 0-3, 4..4+count-1, 13, 14, 15 | 30 cases incl. 16, 1.5, `"1"`, unknown phase |

The baseline for every hostile case is the LK1b cable oracle's own blocks (ALPHA's trade blocks,
both battle sides), re-framed to the native preamble length; all three validate clean. A
mutation check (validator stubbed to "always ok", then "always reject") fails 74 and 68 of the
161 checks respectively, so the cases are live.

### End-to-end matrix (`link_e2e.mjs`)

Fixtures `link_a.sav` (ALPHA, role a, master) and `link_b.sav` (BRAVO, role b). The relay delivers
each message RTT/2 of virtual time later (frames × 16.74 ms), in order per direction. Every
scenario also asserts: no `fail`/`bad-message` events unless the scenario expects one, the FIFO
empty after every bulk exchange, and on a cut that the session closed and the last `port.enable`
call was `false`.

| scenario | checks | wall s | frames / key values |
|---|---|---|---|
| trade-0 | PASS 28/28 | 12.1 | 13,003 frames; 7 act pairs, max act wait 3 f; 3 bulk exchanges of 87 f each; `wPokemonData` sha256 = cable oracle on both sides; mail, `$FE` patching, Pokédex bits, both saves reload via CONTINUE |
| trade-200 | PASS 28/28 | 12.1 | 13,070 frames; max act wait 13 f |
| trade-1000 | PASS 28/28 | 12.2 | 13,338 frames; max act wait 62 f |
| battle-0 | PASS 21/21 | 8.5 | 9,814 frames; 5 act pairs, max act wait 102 f; result and `wPokemonData` = oracle; A RNs = B RNs |
| battle-1000 | PASS 21/21 | 8.8 | 10,058 frames; max act wait 164 f |
| never-shows | PASS 11/11 | 1.7 | "Your friend is not ready." 639 f (10.7 s) after YES; save untouched |
| cut-blocks | PASS 11/11 | 3.4 | cut at B's first `blocks`; both "Too much time has elapsed." |
| cut-menu | PASS 11/11 | 3.9 | cut at A's S1 act; both "Too bad! The trade was canceled!", then menu cancel |
| cut-battle | PASS 11/11 | 6.8 | cut while B picks a replacement (`ForcePlayerMonChoice`); A "Enemy MAGIKARP fled!", B "Enemy MEWTWO fled!" |
| cut-menu-half | PASS 10/10 (informational) | 6.8 | A's S1 act delivered, B's lost: A keeps `96 19 97 13 10 15` (SRAM same), B traded `FB FD 19 97` (SRAM same); A "Too bad!", B "Too much time" at the post-trade re-exchange |
| hostile | PASS 13/13 | 3.5 | B's party arrives with species[0] = `$FF`: A rejects `party.species[0] $ff`, A's party and save untouched; B reaches the menu and is cancelled out |
| rom-mismatch | PASS 9/9 | 0.9 | refused at `hello`, port never enabled |
| **all** | **PASS 12/12** | **80.8** | |

**Disconnect paths, as the player sees them** (all verified on screen by the e2e):

| where the link dies | what the player sees | save |
|---|---|---|
| peer never reaches the desk | "Your friend is not ready." after ~10.7 s; back on 2F | untouched |
| blocks exchange (action 5) | "Too much time has elapsed. Please try again." (auto-advances), room reloads, walk out | untouched |
| peer's blocks invalid | same as above on the validating side; the peer reaches the trade menu and is cancelled out by its drain | untouched on both |
| trade menu, choosing (S0) | the game's own cancel: the menu exits | untouched |
| trade menu, confirm (S1) | "Too bad! The trade was canceled!", then the menu cancels out | untouched |
| after both confirmed (S2) | the trade completes and saves locally (Q5) | traded |
| battle, any exchange incl. the replacement pick | "Enemy <mon> fled!", the battle ends | link record written, as on hardware |
| ROM or protocol mismatch | refused at `hello`; the port is never enabled | untouched |

### Known exposure: the S1 two-generals window (measured)

`cut-menu-half` loses exactly one message: A's S1 TRADE reaches B, B's S1 TRADE never reaches A.
B sees (TRADE, TRADE), enters S2, trades and saves (party `FB FD 19 97`). A drains with `$1`
("Too bad! The trade was canceled!") and keeps its MEW (party `96 19 97 13 10 15`). Net: B's
MAGIKARP is gone and A's MEW is duplicated. Section 3.5 already accepts this ("hardware has the
same exposure"); an extra ack round only moves the window, it does not close it. Recovery is the
pre-link snapshot (Q2/Q5, LK1e). The scenario is informational: it asserts the outcome above, so a
protocol change that closes or widens the window will show up.

### Not working / not verified

- **Not exercised:** a second desk visit in the same session (re-exchanges inside one visit are:
  the trade does 3 bulk gens); peer-gone by silence (45 s) or by `pause` (60 s) — cuts use a
  transport close; `bye{invalid-act}` from a live peer; battle at RTT 200 (trade covers 0/200/1000,
  battle 0/1000); Disconnect pressed by the user mid-stage (`disconnect()` shares `startDrain`
  with the cuts).
- **No browser, no real relay.** The transport is the in-process fake; LK1d builds the relay and
  re-runs this matrix through it. `onBeforeLink` (the snapshot hook) is called but the page's
  snapshot/rollback is LK1e.
- **The phase-model stack cross-check** (deviation 6).
- **Validator gaps** listed above.
- **Tied to the ROM** like LK1b: the fixtures and oracle carry the ROM sha256.

### Re-running

From `hack/` (needs `tables.json`, i.e. a `make crystal` build of the same ROM):

```sh
NODE=../tools/emsdk/node/24.19.0_64bit/bin/node
$NODE web/test/link_unit.mjs                         # < 1 s; UNIT_VERBOSE=1 prints each case's reasons
$NODE web/test/link_e2e.mjs                          # all 12 scenarios, ~80-100 s
$NODE web/test/link_e2e.mjs --only cut-battle,hostile
E2E_DEBUG=1 $NODE web/test/link_e2e.mjs --only trade-0   # stand-in logs on failure
```

Both exit 0 on pass. Single-threaded.
