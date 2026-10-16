# LK1d review fixes: what changed in the link relay after the security review

The independent security review of the LK1d relay (REVIEW-LK1D, kept in the private context repo)
reported 11 findings: F1-F3 MEDIUM, F4-F7 LOW and F8-F11 INFO. This change fixes or mitigates
every finding the relay itself can fix, adds a test for each one, and closes the cheap coverage
gaps the review listed.

- **Code changed:** only `web/link_relay.py` and `web/test/test_link_relay.py`.
- **Not changed:** `server.py`, the client, the ROM, `link.js` and `link_transport.js`.
- **No player-visible change.** `link_transport.js` already has player text for every close code
  the relay now uses (1003, 4003, 4006, 4029).
- **`LK1-LINK.md` is not edited here**, because another work item (LK1e) is editing it
  concurrently. The edits it needs are listed under *Edits for LK1-LINK.md* below.

| suite | result |
|---|---|
| `test_link_relay.py` (unittest) | PASS 59/59 (was 38), ~7.5 s |
| `link_e2e.mjs --relay` (fast mode: ~20x real time, the new byte caps at their **defaults**) | PASS 13/13, 85.7 s, relay log check PASS |
| `link_e2e.mjs --relay --realtime --only trade-200` (default caps, paced to wall time) | PASS 1/1, 206.2 s, same frame count and key values as before (13070 frames, max act wait 13 f) |
| `scripts/link_relay_smoke.py` against a standalone `link_relay.py` | PASS 9/9, twice (default and `--trusted-proxy 127.0.0.1`) |

## Per-finding status

| # | sev | status | what was done |
|---|---|---|---|
| F1 | MEDIUM | **fixed** | (a) A per-socket **byte** token bucket (`bytes_per_s` 512, `byte_burst` 16 KiB) over every client frame, control frames and pings included (close 4003). (b) **Text only after pairing**: a binary frame closes 1003, peer 4000. (d) A per-room **total-bytes** cap (`room_bytes` 8 MiB, both directions, 4006 to both sides). Not done: (c) lowering `frame_bytes`, because `link_transport.js` `MAX_BYTES` is 4096 and the two must move together; the byte bucket makes it moot. (e) A global bytes/s ceiling, because 64 sockets × 512 B/s = 32 KiB/s already bounds it. |
| F2 | MEDIUM | **fixed** | `tracked_ips` overflow **evicts the least-recently-used rate window** instead of answering HTTP 503, so a key flood can't lock anyone out. Windows are an LRU `OrderedDict`, so admission costs O(1). The residual is that an attacker with more than 10,000 keys can also evict its own windows. At that scale the global caps are what bind: 64 sockets, 32 codes and the F5 failed-join ceiling. **IPv6 is keyed by /56** (`IPV6_PREFIX`): an ISP delegates a /56 or /48 to one home, so a /64 key gave one subscriber 256+ keys, and a free tunnel-broker /48 gave 65,536; at /56 that /48 is 256 keys. **`waiting_per_ip` 2** (4029): 8 keys can no longer hold all 32 codes. The 64 sockets for 3 h vector is unchanged. It needs 16 keys, it is bounded by `idle_s`/`lifetime_s`, and its byte value is now ~0 (F1). |
| F3 | MEDIUM (deploy) | **mitigated, still a deploy precondition** | `TRUSTED_PROXIES` (module level; `None` = any loopback, the default) or `Relay(trusted_proxies=...)`; the standalone relay also takes `--trusted-proxy`. `client_ip` logs **one line per kind of rate-key source** (never the address): `rate key: CF-Connecting-IP from a trusted proxy (per-client caps work); trusted proxies: loopback (default)` in the good case. If an untrusted peer sends the header, it logs **once**: `... CF-Connecting-IP from an untrusted peer IGNORED, so every client behind that proxy shares one key and per-IP caps act as global caps (set TRUSTED_PROXIES)`. Loopback spoofing by co-tenant processes is a topology question; see the deploy precondition below. |
| F4 | LOW | **fixed** | `_create` and `_join` re-check `state == "control"` under the relay lock. A socket that `_end`/`_drop` already moved to `closing` is neither registered as waiting nor paired, and its join does not consume the code. |
| F5 | LOW | **fixed** | A **relay-wide failed-join ceiling**, `join_failures_min` 60. Once 60 joins have failed across all clients in the last 60 s, every join gets the same neutral 4002 without a lookup. That bounds guessing however many addresses an attacker has: at most 60 guesses/min against ≤ 32 live codes out of 2^30 is ~1.8×10⁻⁶ per minute. The cost is that correct codes are refused while it is tripped. 3 words stay sufficient with this ceiling plus the LK1e Accept step. |
| F6 | LOW | **deferred (server.py)** | The pre-upgrade header timeout is per read in `server.py`, which this change may not edit. Behind Cloudflare the edge buffers the request, so the origin never sees a trickle. Follow-up: a total pre-upgrade deadline in `server.py` (or count pre-upgrade connections). |
| F7 | LOW | **fixed (relay side)** | Every refusal (upgrade refused, join refused, global ceiling, socket closed with no room, rate windows evicted) is **tallied and logged once per `LOG_EVERY_S` (60 s) per reason**, e.g. `join refused x37 in 60s`. No code, payload or IP, as before. The relay's log volume is now O(reasons) per minute. The tally is flushed by the housekeeper and on `stop()`; the standalone relay maps SIGTERM to a clean stop. Room events (`created`/`paired`/`closed`) stay one line each, because they are bounded by the create caps. **Remaining:** `server.py`'s `log_link` still prints `- "GET /link"` per attempt (follow-up). |
| F8 | INFO | **doc fix** | The "no write queue" claim should read "no **user-space** queue". The kernel send buffer and cloudflared are the real queue, and memory is bounded by the byte bucket (F1). Wording below. |
| F9 | INFO | **fixed** | A client close must carry an empty payload, or a 2-byte code in 1000-1003, 1007-1014 or 3000-4999 plus a UTF-8 reason. Otherwise the relay answers 1002 instead of 1000 (the peer still gets 4000). |
| F10 | INFO | **relay part fixed; client part deferred to LK1e** | The relay no longer forwards binary (F1b), so a hostile peer can't hand `link.js` an `ArrayBuffer`. Still for LK1e (`link_transport.js`/`link.js`, not editable here): render `code`/`ttl` via `textContent`, coerce `ttl` to a bounded number, and coalesce pongs (or answer pings ≥ 1 s apart). (A ping flood answered pong-for-pong still trips the victim's frame bucket first, 4003, so the coalescing is about which side the message blames, as the review says.) |
| F11 | INFO | **deploy note** | If static requests show sporadic 502s after deploy, set the tunnel's `originRequest.keepAliveTimeout` below 10 s. Nothing in the relay to change. |

## New caps (rows for the "Caps as built" table)

| name | default | threat | on breach |
|---|---|---|---|
| `bytes_per_s` / `byte_burst` | 512 B/s / 16384 B | bandwidth: the frame bucket alone allowed 20 × 4 KiB/s per socket, ~42 Mbit/s each way at the socket cap, an anonymous pipe through the host's uplink (F1). Payload bytes of every client frame, control and pings included | 4003, peer 4000 |
| `room_bytes` | 8 MiB (8388608) | a room used as a bulk pipe for its 3 h lifetime (F1); payload bytes forwarded, both directions | 4006 both |
| `waiting_per_ip` | 2 | 8 keys × 4 sockets holding all 32 pending codes (F2) | 4029 |
| `join_failures_min` | 60 | code guessing from many addresses (F5); failed joins relay-wide per 60 s | 4002 (neutral, no lookup) |
| `tracked_ips` (changed) | 10000 | memory held by per-IP rate windows | **least-recently-used window evicted** (was HTTP 503) |

Module settings (not caps; `server.py` can set them before it creates the `Relay`):

| setting | default | meaning |
|---|---|---|
| `TRUSTED_PROXIES` | `None` = any loopback (127.0.0.0/8, ::1, ::ffff:127.x) | peers whose `CF-Connecting-IP` is believed; else a sequence of addresses/CIDRs. Also `Relay(trusted_proxies=...)` and the standalone `--trusted-proxy` |
| `IPV6_PREFIX` | 56 | IPv6 rate-key prefix (F2) |
| `LOG_EVERY_S` | 60 | refusal summary interval (F7) |

## Measured real play against the caps

Measured with a wrapper that logs each frame the relay reads: time, socket, opcode and length,
never the payload. The run was `link_e2e.mjs --relay --realtime`, paced to wall time, with no cap
overrides. Every data message is JSON text.

| run | per side | bytes | duration | average | largest message | busiest 1 s | busiest 10 s | busiest 60 s |
|---|---|---|---|---|---|---|---|---|
| trade-200, old relay (baseline) | 48-49 frames | 5,985-5,986 | 205 s | 29.2 B/s | 1,477 | 1,553 | 1,643 | 2,048 |
| battle-200, old relay (baseline) | 34-35 frames | 2,114-2,116 | 149 s | 14.2 B/s | 957 | 957 | 1,031 | 1,437 |
| **trade-200, new relay (default caps incl. byte caps)** | 48-49 frames | 5,984-5,985 | 205 s | 29.2 B/s | 1,477 | 1,553 | 1,643 | 2,047 |

Under the new caps the byte bucket of each side never fell below ~14.8 KB of its 16 KB (the trade needed
1,477 B of burst at 512 B/s), and the room forwarded 11.9 KB of its 8 MiB (0.14%).

| cap | value | real play needs | headroom |
|---|---|---|---|
| `bytes_per_s` | 512 B/s | 29.2 B/s average, 34 B/s over the busiest minute | **17x** average, 15x busiest minute |
| `byte_burst` | 16,384 B | 1,553 B in the busiest second; a bucket refilling at 51 B/s (a tenth of the cap) needs a 1,543 B burst for the whole trade | **10.5x** |
| `room_bytes` | 8 MiB | a trade ~12 KB per room; back-to-back trades for the full 3 h lifetime at 29.2 B/s per side ≈ 0.63 MB | **13x** over a 3 h session, ~700x over one trade |
| `frames_per_s` / `frame_burst` (unchanged) | 20/s / 60 | at most 3-4 frames in any second | 5x / 15x |

**What the abuse is worth now** (the review's measurements were 78 KiB/s per side per room, and
42 Mbit/s each way at the socket cap):

| | before | after | cut |
|---|---|---|---|
| per socket, sustained | 80 KiB/s | 0.5 KiB/s | **160x** |
| whole relay at the socket cap | 64 × 80 KiB/s ≈ 5.1 MiB/s ≈ 42 Mbit/s each way | 64 × 0.5 KiB/s = 32 KiB/s ≈ 0.26 Mbit/s each way | **160x** |
| one room over its 3 h lifetime | 2 × 80 KiB/s × 3 h ≈ 1.7 GB | 8 MiB, then 4006 | **~200x**, then the pair must create and join a new room (6 creates/min per key) |
| payload types | any binary or text | UTF-8 text only | a binary pipe needs ~33% base64 overhead |

The brief asked for "≥ 10x margin over real play, abuse value cut ~1000x". On a per-socket rate
those two targets conflict: 1000x below 80 KiB/s is 80 B/s, under 3x the trade average. Margin
won. The rate is cut 160x and the per-room total ~200x. Combined with text-only forwarding and the
per-key create caps, the relay is useless as a bulk pipe. At 32 KiB/s for the whole relay it can't
dent a residential uplink.

## Tests (21 new; `test_link_relay.py` is now 59 tests in 21 classes)

| finding | test(s) |
|---|---|
| F1 | `Bandwidth.test_byte_bucket_trips_while_frame_bucket_does_not`, `Bandwidth.test_pings_count_against_bytes`, `Bandwidth.test_binary_after_pairing_1003`, `RoomBytes.test_room_byte_cap_4006` |
| F2 | `Admission.test_full_table_evicts_instead_of_503`, `Admission.test_10k_key_flood_does_not_lock_out`, `Admission.test_tick_prunes_windows`, `Admission.test_ipv6_56_is_one_key_for_socket_cap`, `Admission.test_waiting_per_ip_4029`; `Rooms.test_client_ip_key` (extended: /56, 256 /64s → one key, two headers, empty header, v4-mapped, scoped `fe80::1%eth0`, `::1` and `::ffff:127.0.0.1` peers trusted) |
| F3 | `TrustedProxy.test_untrusted_loopback_collapses_and_logs_once`, `TrustedProxy.test_module_setting_and_default`; `Logs.test_no_code_payload_or_ip_in_logs` (asserts the key-source line) |
| F4 | `Races.test_create_after_end_does_not_revive`, `Races.test_join_after_end_does_not_consume_code` |
| F5 | `Admission.test_global_join_failure_ceiling` |
| F7 | `LogSummary.test_refusals_aggregated`, `LogSummary.test_exception_path_logs_type_only` (gap 8) |
| F9 | `CloseFrames.test_close_payload_validated` |
| gaps 4, 5 | `ErrorPaths.test_error_path_sockets_leak_nothing` (200 sockets over 10 error paths), `ErrorPaths.test_random_frames_never_crash` (150 sockets of seeded random frames/bytes; no thread or server exception, threads/FDs/rooms back to baseline, still serving) |
| gap 10 | `Liveness.test_pings_do_not_extend_code_ttl`, `Liveness.test_pongs_do_not_extend_idle` |

Existing tests that sent binary data after pairing now send text: `Rooms.test_pair_and_forward_both_ways`
(0-4,096 bytes), `Framing.test_oversize_1009_before_payload`, `SlowReader` and `Leaks`.
`SlowReader` lifts the byte caps along with the frame caps, since it needs a flood. Gap 7 (the
pre-upgrade trickle) is F6, which belongs to `server.py`, and is not pinned here.

## Edits for LK1-LINK.md

These apply once LK1e's edits to the file have landed. Wording is given as find → replace.

**§4.3 table.** Add these rows after "messages per socket":

```
| bytes per socket | 512 B/s sustained, burst 16 KiB | close 4003 |
| bytes per room (both directions, lifetime) | 8 MiB | close 4006 both |
| binary frames after pairing | refused (link.js sends only JSON text) | close 1003 |
| pending codes per client IP | 2 | close 4029 |
| failed joins, all clients | 60/min, then every join refused unlooked-up | close 4002 |
```

Also in §4.3:

- **"Client IP"** bullet → "`CF-Connecting-IP` is trusted only from a trusted proxy
  (`TRUSTED_PROXIES`, default any loopback address), which is the case behind a same-host tunnel.
  Otherwise the socket address is used. IPv6 clients are keyed by their /56. The relay logs once
  which key source it sees."
- **"Logging"** bullet → "One line per room event (created, paired, closed with code and
  duration). Refusals are summarised once a minute per reason with a count. **No code, payload or
  IP.**"

**§4.5 rows:**

- **code guessing**: append "; relay-wide, at most 60 failed joins per minute (then every join is
  refused), so many IPs don't multiply the odds".
- **connection, room or message floods**: → "per-IP and global caps, per-socket frame **and byte**
  rate limits, a per-room byte cap, text-only forwarding; a full rate-window table evicts the
  oldest key instead of refusing; the socket cap bounds link threads".
- **oversize frames and memory**: "no write queue at all" → "no user-space write queue (the kernel
  buffer and cloudflared are the only queue, bounded by the byte rate)".
- **spoofed client IP**: → "`CF-Connecting-IP` honoured only from `TRUSTED_PROXIES` (default
  loopback); the relay logs which key source it sees, and logs once if it ignores the header from an
  untrusted peer".

**`## LK1d findings`:**

- **Summary table:** the unittest row becomes `PASS 59/59 | ~7.5 s`; add a row pointing to this
  file.
- **Caps as built:** add the rows from *New caps* above, and change the `tracked_ips` row's last
  cell from "HTTP 503 for new IPs" to "least-recently-used window evicted (no refusal)". In the
  close-code paragraph: 1003 → "fragmented frame, or binary after pairing"; 4003 → "rate (frames
  or bytes)"; 4006 → "lifetime or room data cap".
- **Control plane:** "After pairing nothing is parsed: opcode and payload are copied as they are."
  → "After pairing nothing is parsed: text frames are copied as they are; a binary frame ends the
  room (1003, peer 4000)."
- **RFC 6455 subset, client frames:** "binary frames are forwarded as binary" → "binary frames are
  refused after pairing (1003)". **close:** append "; a close payload must be empty or a valid
  code (1000-1003, 1007-1014, 3000-4999) plus UTF-8, else the reply is 1002".
- **Python suite heading:** "38 tests, 4.4 s" → "59 tests, ~7.5 s"; add bullets for Bandwidth,
  RoomBytes, Admission, TrustedProxy, Races, CloseFrames, Liveness, LogSummary and ErrorPaths
  (see *Tests* above).
- **Deploying step 2:** replace the last two sentences ("The relay trusts … apply to everyone
  together.") with: "The relay trusts `CF-Connecting-IP` only from `TRUSTED_PROXIES` (default: any
  loopback address, i.e. cloudflared on the same host or network namespace). **Deploy check:** after
  the first real connection, stderr must show `link: rate key: CF-Connecting-IP from a trusted proxy
  (per-client caps work)`. If it shows `… IGNORED …` or `rate key: TCP peer …`, every player shares
  one set of caps (two rooms in total). Set `TRUSTED_PROXIES` to cloudflared's address and redeploy."
- **Deploying step 5:** the list of log lines becomes:
  - per room event: `room created (waiting N)`, `room paired`, `room closed CODE after Ns`;
  - once per key source: `rate key: …; trusted proxies: …`;
  - once a minute per reason, only when non-zero: `REASON xN in Ss`, where REASON is one of
    `join refused`, `join refused (relay-wide failure ceiling)`, `socket closed CODE (no room)`,
    `upgrade refused STATUS why`, `rate windows evicted (tracked_ips full)`.

  No codes, payloads or IPs. (`server.py`'s `- "GET /link"` per attempt remains until the F7
  follow-up.)
- **Review guide rows:**
  - **flood row**: add "`_take_token` (frames and bytes), `_forward` (room byte cap), `_hit`/`_window`
    (LRU eviction)".
  - **spoofed IP row**: "IPv6 keyed by /64" → "IPv6 keyed by /56 (`IPV6_PREFIX`); trusted peers
    from `TRUSTED_PROXIES`; key-source log line", tests "Rooms, TrustedProxy".
  - **code guessing row**: add "`join_failures_min` ceiling (`_join`)", test "Admission".
- **Deliberately not done:** "No write queue: …" → "No user-space write queue: …".
- **Known limits, Shared rate keys:** "IPv6 /64s likewise" → "IPv6 /56s likewise (one home's
  delegation)". Add: "**Global failed-join ceiling.** While 60 joins/min are failing relay-wide,
  correct codes are refused too (4002); a guessing flood therefore denies joins for its duration."

## Follow-ups outside this change (for the main session)

**Status (LK1 pre-deploy follow-up):** 1-3 are done in `server.py` (`--link-trusted-proxy`; no
per-attempt `/link` log line; a 15 s total request-line + header budget, 1.5 x `handshake_s`, with
tests in `HeaderDeadline` and `ServerFlags`). 4 landed in LK1e. 5 is step 3 of the deploy list in
LK1-LINK.md, and the edits in the previous section are applied there.

1. **`server.py`:** a `--link-trusted-proxy IP_OR_CIDR` flag (repeatable) that sets
   `link_relay.TRUSTED_PROXIES`, or passes `trusted_proxies=` to `Relay(...)`. The standalone
   `link_relay.py --trusted-proxy` already does this.
2. **`server.py` (F7):** drop or aggregate `log_link`'s per-attempt `- "GET /link"` line. The relay
   already summarises refusals, and room events cover the successful upgrades.
3. **`server.py` (F6):** a total pre-upgrade deadline (for example, record the accept time and refuse
   once more than `handshake_s` has passed since then), or count pre-upgrade connections against the
   socket caps.
4. **LK1e (F10):** coalesce pongs; `textContent` and a bounded number for `code`/`ttl`.
5. **Deploy (F11):** watch for static 502s; if they appear, set `originRequest.keepAliveTimeout` < 10 s.

## F3 deploy precondition

> cloudflared reaches `server.py` from a `TRUSTED_PROXIES` address (default: loopback, i.e. same host or network namespace), `server.py` is bound to 127.0.0.1 only, and after the first real connection stderr shows `link: rate key: CF-Connecting-IP from a trusted proxy (per-client caps work)` and never `IGNORED` or `rate key: TCP peer`; if other tenants share that loopback, they can still set `CF-Connecting-IP`, so confirm with the deploy owner that nothing else on the host can reach port 8080.
