#!/usr/bin/env python3
"""LK1d link relay: a WebSocket "dumb pipe" that pairs two browsers by a code.

Design: docs/LK1-LINK.md section 4. Read it with the "LK1d findings / Review guide"
section at the end of that doc.

What this module does, and nothing more:
  * the server half of the RFC 6455 handshake on exactly `GET /link`;
  * reads masked client frames (text, binary, ping, pong, close; no fragmentation,
    no extensions, no subprotocols) and writes unmasked server frames;
  * parses ONE small JSON control frame per socket, `{"op":"create"}` or
    `{"op":"join","code":"w-w-w"}`, and pairs a joiner with a waiting creator;
  * after pairing, copies every data frame from one socket to the other, unchanged
    and unread (it never parses, stores or logs a payload);
  * enforces every cap in CAPS below and closes with a code from CLOSE.

It never logs a code, a payload or an IP address. It keeps no state that outlives a
room. Standard library only.

Threads: each WebSocket runs on the thread the HTTP server gave its connection
(ThreadingHTTPServer: one per connection). That thread is the only reader of its
socket. One housekeeping thread enforces every deadline. A deadline never waits
on a blocked read: the housekeeper sends a close frame without blocking, or shuts
the socket down, which wakes the reader with EOF.
Lock order: a connection's write lock may be held while taking the relay lock,
never the reverse.

Used two ways:
  * inside web/server.py: `server.py --link` routes `GET /link` to Relay.handle();
  * standalone: `python3 link_relay.py --port 8081 --origin https://example.org`.
"""

import argparse
import base64
import collections
import hashlib
import http.server
import ipaddress
import json
import os
import re
import secrets
import select
import socket
import struct
import sys
import threading
import time

# --------------------------------------------------------------------------
# Every cap the relay enforces. One per line, with the threat it closes.
# All of them can be overridden: server.py --link-cap NAME=VALUE.
# --------------------------------------------------------------------------
CAPS = {
    # Memory: a frame header claiming a huge length is refused before a single
    # payload byte is read, and nothing is ever reassembled. (close 1009)
    "frame_bytes": 4096,
    # The control frame (create/join) is tiny; refuse anything bigger. (close 1009)
    "control_bytes": 256,
    # Message floods: token bucket over every frame a client sends, control
    # frames included. 20/s sustained, 60 in a burst. (close 4003)
    "frames_per_s": 20,
    "frame_burst": 60,
    # Thread and FD exhaustion: each link socket holds one thread, so this also
    # bounds link threads. Global cap / per client IP. (HTTP 503 / 429)
    "sockets": 64,
    "sockets_per_ip": 4,
    # Upgrade floods from one IP (connect, upgrade, drop, repeat). (HTTP 429)
    "upgrades_per_ip_min": 30,
    # Room-creation floods from one IP. (close 4029)
    "creates_per_ip_min": 6,
    # Pending codes held in memory at once, across all IPs; also bounds the
    # odds of a guessed code hitting a live room. (close 4013)
    "waiting": 32,
    # Code guessing: join attempts per client IP, counted whether or not the
    # code exists. (close 4029)
    "joins_per_ip_min": 12,
    # A pending code lives this long, in seconds; then the creator is closed. (close 4001)
    "code_ttl": 120,
    # A socket must send its control frame within this many seconds of the
    # upgrade. Before the upgrade, server.py sets the same value as its
    # per-read socket timeout (slowloris on the HTTP headers). (close 4008)
    "handshake_s": 10,
    # Abandoned rooms: a side that sends no data frame for this long ends the
    # room. Pings do not count. (close 4005, both sides)
    "idle_s": 90,
    # Hard lifetime of a paired room, seconds. (close 4006, both sides)
    "lifetime_s": 3 * 3600,
    # A slow or stalled reader: a forward that cannot be written within this
    # many seconds ends the room, so nothing queues. (close 4004, both sides)
    "write_s": 5,
    # Dead TCP and idle tunnels: server ping interval; a socket that has not
    # answered with a pong for pong_s is closed. (close 4007)
    "ping_s": 30,
    "pong_s": 60,
    # After the relay sends a close frame, the client has this long to answer
    # before the socket is shut down.
    "close_wait_s": 2,
    # Oversized upgrade requests. http.server already caps 100 headers of 64 KiB. (HTTP 431)
    "header_bytes": 8192,
    # Memory held by per-IP rate windows. Past this, new IPs get HTTP 503.
    "tracked_ips": 10000,
}

# Close codes the relay sends. The client (link_transport.js) maps them to text.
CLOSE = {
    1000: "normal",
    1001: "relay shutting down",
    1002: "protocol error",
    1003: "fragmented frame",
    1007: "invalid UTF-8 in a text frame",
    1008: "bad control message",
    1009: "frame too big",
    4000: "peer left",
    4001: "code expired",
    4002: "code refused",  # wrong, expired, used or malformed: deliberately indistinguishable
    4003: "too many messages",
    4004: "peer too slow",
    4005: "idle",
    4006: "room lifetime reached",
    4007: "no pong",
    4008: "no control frame in time",
    4013: "relay busy",
    4029: "too many attempts",
}

DEFAULT_ORIGINS = ("https://waffle-time.christopherfretz.com",)
PATH = "/link"
WS_GUID = b"258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
WORDS_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "link_words.txt")
OP_CONT, OP_TEXT, OP_BIN, OP_CLOSE, OP_PING, OP_PONG = 0, 1, 2, 8, 9, 10


def load_words(path=WORDS_FILE):
    words = open(path, encoding="ascii").read().split()
    if len(words) != 1024 or len(set(words)) != 1024 or not all(
        re.fullmatch(r"[a-z]{4,8}", w) for w in words
    ):
        raise ValueError("%s must hold 1024 unique words of 4-8 letters a-z" % path)
    return words


def accept_key(key):
    """Sec-WebSocket-Accept for a Sec-WebSocket-Key (RFC 6455 section 4.2.2)."""
    return base64.b64encode(hashlib.sha1(key.encode("ascii") + WS_GUID).digest()).decode("ascii")


def encode_frame(op, payload=b""):
    """One unmasked, final server frame."""
    n = len(payload)
    if n < 126:
        head = struct.pack("!BB", 0x80 | op, n)
    elif n < 65536:
        head = struct.pack("!BBH", 0x80 | op, 126, n)
    else:
        head = struct.pack("!BBQ", 0x80 | op, 127, n)
    return head + payload


def close_frame(code):
    return encode_frame(OP_CLOSE, struct.pack("!H", code))


def _unmask(mask, data):
    if not data:
        return data
    n = len(data)
    key = (mask * (n // 4 + 1))[:n]
    return (int.from_bytes(data, "big") ^ int.from_bytes(key, "big")).to_bytes(n, "big")


def _tokens(value):
    return [t.strip().lower() for t in value.split(",") if t.strip()]


class _Fail(Exception):
    """The client broke the protocol; close with .code."""

    def __init__(self, code):
        Exception.__init__(self, code)
        self.code = code


class _Eof(Exception):
    pass


class _Conn(object):
    """One upgraded socket. Mutable fields are guarded by Relay.lock unless noted."""

    def __init__(self, sock, rfile, ip, now):
        self.sock = sock
        self.rfile = rfile          # read only by the socket's own thread
        self.ip = ip                # rate-limit key; never logged
        self.wlock = threading.Lock()  # serialises writes to sock
        self.state = "control"      # control -> waiting -> paired -> closing; or control -> closing
        self.peer = None
        self.code = None            # pending code while waiting
        self.room = None            # dict shared by both sides once paired
        self.t0 = now
        self.code_exp = 0.0
        self.last_data = now
        self.last_ping = now
        self.last_pong = now
        self.close_by = 0.0
        self.tokens = 0.0
        self.tokens_t = now
        self.dead = False           # set once the socket has been shut down


class Relay(object):
    def __init__(self, origins=DEFAULT_ORIGINS, caps=None, clock=time.monotonic, log=None,
                 autotick=True, words=None):
        self.caps = dict(CAPS)
        for name, value in (caps or {}).items():
            if name not in CAPS:
                raise ValueError("unknown link cap %r" % name)
            self.caps[name] = float(value)
        self.origins = frozenset(o.rstrip("/").lower() for o in origins)
        self.clock = clock
        self.log = log or (lambda line: sys.stderr.write(
            "%s link: %s\n" % (time.strftime("%Y-%m-%d %H:%M:%S"), line)))
        self.words = words or load_words()
        self.wordset = frozenset(self.words)
        self.lock = threading.Lock()
        self.conns = set()          # every upgraded, not yet dropped _Conn
        self.per_ip = collections.Counter()
        self.waiting = {}           # code -> creator _Conn
        self.windows = {}           # ip -> {kind: deque of clock() times}, kind in up/create/join
        self.autotick = autotick
        self._stop = threading.Event()
        self._ticker = None

    # ---------------------------------------------------------------- lifecycle
    def start(self):
        if self.autotick and self._ticker is None:
            self._ticker = threading.Thread(target=self._tick_loop, name="link-tick", daemon=True)
            self._ticker.start()
        return self

    def stop(self):
        self._stop.set()
        if self._ticker:
            self._ticker.join()
            self._ticker = None
        with self.lock:
            conns = list(self.conns)
        for c in conns:
            self._end(c, 1001)
            self._kill(c)

    def snapshot(self):
        with self.lock:
            return {
                "sockets": len(self.conns),
                "waiting": len(self.waiting),
                "paired": sum(1 for c in self.conns if c.state == "paired") // 2,
                "tracked_ips": len(self.windows),
            }

    def _tick_loop(self):
        while not self._stop.wait(0.5):
            try:
                self.tick()
            except Exception as e:  # never let the housekeeper die
                self.log("tick error %s" % type(e).__name__)

    # ---------------------------------------------------------------- admission
    def handle(self, h):
        """Serve one `GET /link` request on a BaseHTTPRequestHandler `h`.

        Returns when the socket is finished with; the HTTP server closes it."""
        h.close_connection = True
        c = self._upgrade(h)
        if c is None:
            return
        try:
            self._serve(c)
        except Exception as e:  # a relay bug must not take the server down
            self.log("socket error %s" % type(e).__name__)
            self._end(c, 1002, 4000)
        finally:
            self._drop(c)

    def _refuse(self, h, status, why, extra=()):
        body = ("%d %s\n" % (status, why)).encode("ascii")
        head = ["HTTP/1.1 %d %s" % (status, http.server.BaseHTTPRequestHandler.responses.get(
            status, ("Error",))[0]), "Content-Type: text/plain", "Content-Length: %d" % len(body),
            "Connection: close"]
        head.extend(extra)
        try:
            h.wfile.write(("\r\n".join(head) + "\r\n\r\n").encode("ascii") + body)
        except OSError:
            pass
        self.log("upgrade refused %d %s" % (status, why))

    def client_ip(self, h):
        """Rate-limit key. CF-Connecting-IP is trusted only from a loopback peer
        (the tunnel). IPv6 is keyed by its /64."""
        peer = h.client_address[0]
        ip = peer
        try:
            if ipaddress.ip_address(peer).is_loopback:
                fwd = h.headers.get_all("CF-Connecting-IP") or []
                if len(fwd) == 1:
                    ipaddress.ip_address(fwd[0].strip())
                    ip = fwd[0].strip()
        except ValueError:
            ip = peer
        try:
            addr = ipaddress.ip_address(ip)
            if addr.version == 6:
                return str(ipaddress.ip_network(ip + "/64", strict=False))
        except ValueError:
            pass
        return ip

    def _upgrade(self, h):
        hd = h.headers
        if h.path != PATH or h.command != "GET" or h.request_version != "HTTP/1.1":
            return self._refuse(h, 400, "path or method")
        if sum(len(k) + len(v) + 4 for k, v in hd.items()) > self.caps["header_bytes"]:
            return self._refuse(h, 431, "headers too large")
        keys = hd.get_all("Sec-WebSocket-Key") or []
        try:
            key_ok = len(keys) == 1 and len(base64.b64decode(keys[0].strip(), validate=True)) == 16
        except ValueError:
            key_ok = False
        if (not hd.get("Host") or not key_ok
                or "websocket" not in _tokens(hd.get("Upgrade", ""))
                or "upgrade" not in _tokens(hd.get("Connection", ""))):
            return self._refuse(h, 400, "not a websocket upgrade")
        if (hd.get_all("Sec-WebSocket-Version") or []) != ["13"]:
            return self._refuse(h, 426, "version", ["Sec-WebSocket-Version: 13"])
        origins = hd.get_all("Origin") or []
        if len(origins) != 1 or origins[0].strip().rstrip("/").lower() not in self.origins:
            return self._refuse(h, 403, "origin")
        ip = self.client_ip(h)
        now = self.clock()
        with self.lock:
            if ip not in self.windows and len(self.windows) >= self.caps["tracked_ips"]:
                why = (503, "busy")
            elif not self._hit("up", ip, self.caps["upgrades_per_ip_min"], now):
                why = (429, "upgrade rate")
            elif self.per_ip[ip] >= self.caps["sockets_per_ip"]:
                why = (429, "sockets per ip")
            elif len(self.conns) >= self.caps["sockets"]:
                why = (503, "busy")
            else:
                why = None
                c = _Conn(h.connection, h.rfile, ip, now)
                c.tokens = self.caps["frame_burst"]
                self.conns.add(c)
                self.per_ip[ip] += 1
        if why:
            return self._refuse(h, *why)
        try:
            h.connection.settimeout(None)
            h.connection.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
            h.wfile.write(("HTTP/1.1 101 Switching Protocols\r\nUpgrade: websocket\r\n"
                           "Connection: Upgrade\r\nSec-WebSocket-Accept: %s\r\n\r\n"
                           % accept_key(keys[0].strip())).encode("ascii"))
        except OSError:
            self._drop(c)
            return None
        return c

    def _hit(self, kind, ip, limit, now):
        """Sliding 60 s window. Records the attempt; False if over `limit`. Holds self.lock."""
        q = self.windows.setdefault(ip, {}).setdefault(kind, collections.deque())
        while q and q[0] <= now - 60:
            q.popleft()
        if len(q) >= limit:
            return False
        q.append(now)
        return True

    # ---------------------------------------------------------------- reading
    def _recv(self, c, n):
        try:
            data = c.rfile.read(n) if n else b""
        except (OSError, ValueError):   # reset, or shut down by another thread
            raise _Eof()
        if len(data) != n:
            raise _Eof()
        return data

    def _read_frame(self, c, limit):
        b0, b1 = self._recv(c, 2)
        fin, op, n = b0 & 0x80, b0 & 0x0F, b1 & 0x7F
        if b0 & 0x70 or op not in (OP_CONT, OP_TEXT, OP_BIN, OP_CLOSE, OP_PING, OP_PONG):
            raise _Fail(1002)                        # RSV bits (no extensions) or reserved opcode
        if not b1 & 0x80:
            raise _Fail(1002)                        # client frames must be masked
        if n == 126:
            n = struct.unpack("!H", self._recv(c, 2))[0]
            if n < 126:
                raise _Fail(1002)                    # non-minimal length
        elif n == 127:
            n = struct.unpack("!Q", self._recv(c, 8))[0]
            if n < 65536 or n >> 63:
                raise _Fail(1002)
        if op >= OP_CLOSE:
            if not fin or n > 125:
                raise _Fail(1002)                    # control frames: final and <= 125 bytes
        elif op == OP_CONT or not fin:
            raise _Fail(1003)                        # no fragmentation
        if n > limit:
            raise _Fail(1009)                        # checked before reading the payload
        mask = self._recv(c, 4)
        data = _unmask(mask, self._recv(c, n))
        if op == OP_TEXT:
            try:
                data.decode("utf-8")
            except UnicodeDecodeError:
                raise _Fail(1007)
        return op, data

    def _serve(self, c):
        while True:
            limit = self.caps["control_bytes"] if c.state == "control" else self.caps["frame_bytes"]
            try:
                op, data = self._read_frame(c, limit)
            except _Eof:
                return
            except _Fail as f:
                self._end(c, f.code, 4000)
                return self._discard(c)
            if c.state == "closing":
                if op == OP_CLOSE:
                    return                           # the client answered our close
                continue                             # drop anything else until it does
            if op == OP_CLOSE:
                self._end(c, 1000, 4000)             # the client is leaving: answer, end the room
                return
            if not self._take_token(c):
                self._end(c, 4003, 4000)
                continue
            if op == OP_PING:
                self._write(c, encode_frame(OP_PONG, data), self.caps["write_s"])
            elif op == OP_PONG:
                with self.lock:
                    c.last_pong = self.clock()
            elif c.state == "control":
                self._control(c, op, data)
            elif c.state == "waiting":
                self._end(c, 1008)                   # nothing to forward to yet
            else:
                self._forward(c, op, data)

    def _discard(self, c):
        """After a protocol error the frame stream is lost: drop raw bytes until the
        client closes, or the housekeeper shuts the socket after close_wait_s."""
        try:
            while c.rfile.read1(65536):
                pass
        except (OSError, ValueError):
            pass

    def _take_token(self, c):
        now = self.clock()
        with self.lock:
            c.tokens = min(self.caps["frame_burst"],
                           c.tokens + (now - c.tokens_t) * self.caps["frames_per_s"])
            c.tokens_t = now
            if c.tokens < 1:
                return False
            c.tokens -= 1
            return True

    # ---------------------------------------------------------------- control plane
    def normalize_code(self, text):
        words = [w for w in re.split(r"[\s\-_.]+", text.strip().lower()) if w]
        if len(words) != 3 or not all(w in self.wordset for w in words):
            return None
        return "-".join(words)

    def _control(self, c, op, data):
        try:
            msg = json.loads(data.decode("utf-8")) if op == OP_TEXT else None
        except ValueError:
            msg = None
        if msg == {"op": "create"}:
            return self._create(c)
        if (isinstance(msg, dict) and set(msg) == {"op", "code"} and msg["op"] == "join"
                and isinstance(msg["code"], str) and len(msg["code"]) <= 64):
            return self._join(c, msg["code"])
        self._end(c, 1008)

    def _create(self, c):
        now = self.clock()
        with self.lock:
            if not self._hit("create", c.ip, self.caps["creates_per_ip_min"], now):
                why = 4029
            elif len(self.waiting) >= self.caps["waiting"]:
                why = 4013
            else:
                why = None
                code = "-".join(secrets.choice(self.words) for _ in range(3))
                while code in self.waiting:
                    code = "-".join(secrets.choice(self.words) for _ in range(3))
                self.waiting[code] = c
                c.code, c.state, c.code_exp = code, "waiting", now + self.caps["code_ttl"]
                c.room = {"t0": now, "paired_t": None, "logged": False}
                n = len(self.waiting)
        if why:
            return self._end(c, why)
        self.log("room created (waiting %d)" % n)
        reply = json.dumps({"op": "code", "code": code, "ttl": int(self.caps["code_ttl"])},
                           separators=(",", ":"))
        if not self._write(c, encode_frame(OP_TEXT, reply.encode("ascii")), self.caps["write_s"]):
            self._end(c, 4004)

    def _join(self, b, text):
        code = self.normalize_code(text)
        now = self.clock()
        with b.wlock:   # nothing reaches b before its "paired" message
            with self.lock:
                a = self.waiting.get(code) if code else None
                if not self._hit("join", b.ip, self.caps["joins_per_ip_min"], now):
                    why = 4029
                elif a is None or a.state != "waiting" or now >= a.code_exp:
                    why = 4002   # one neutral answer for wrong, expired, used, malformed
                else:
                    why = None
                    del self.waiting[code]           # a code is single-use
                    a.code = None
                    a.state = b.state = "paired"
                    a.peer, b.peer = b, a
                    b.room = a.room
                    a.room["paired_t"] = now
                    a.last_data = b.last_data = now
            if why is None:
                ok_b = self._write_locked(b, encode_frame(OP_TEXT, b'{"op":"paired","role":"b"}'),
                                          self.caps["write_s"])
        if why:
            if why == 4002:
                self.log("join refused")
            return self._end(b, why)
        self.log("room paired")
        if not ok_b or not self._write(a, encode_frame(OP_TEXT, b'{"op":"paired","role":"a"}'),
                                       self.caps["write_s"]):
            self._end(b, 4004, 4004)

    def _forward(self, c, op, data):
        with self.lock:
            c.last_data = self.clock()
            peer = c.peer if c.state == "paired" else None
        if peer is None:
            return
        if not self._write(peer, encode_frame(op, data), self.caps["write_s"]):
            self._end(c, 4004, 4004)

    # ---------------------------------------------------------------- writing
    def _write(self, c, data, wait):
        """Write a whole frame within `wait` seconds of real time. False if it could not.
        A frame cut part-way leaves the stream unusable, so that socket is shut down."""
        if not c.wlock.acquire(timeout=wait):
            return False
        try:
            return self._write_locked(c, data, wait)
        finally:
            c.wlock.release()

    def _write_locked(self, c, data, wait):
        view = memoryview(data)
        deadline = time.monotonic() + wait
        poller = None
        while view:
            if c.dead:
                return False
            try:
                view = view[c.sock.send(view, socket.MSG_DONTWAIT):]
                continue
            except BlockingIOError:
                pass
            except OSError:
                self._kill(c)
                return False
            left = deadline - time.monotonic()
            if left <= 0:
                if len(view) != len(data):
                    self._kill(c)
                return False
            if poller is None:
                poller = select.poll()
                poller.register(c.sock.fileno(), select.POLLOUT)
            poller.poll(min(left, 0.25) * 1000)
        return True

    def _kill(self, c):
        """Shut the socket down; its reader wakes with EOF and the server closes it."""
        c.dead = True
        try:
            c.sock.shutdown(socket.SHUT_RDWR)
        except OSError:
            pass

    # ---------------------------------------------------------------- ending
    def _end(self, c, code, peer_code=None):
        """Send close `code` to `c` (once) and, if paired, close its peer with `peer_code`."""
        with self.lock:
            if c.state == "closing" or c not in self.conns:
                return
            c.state = "closing"
            c.close_by = self.clock() + self.caps["close_wait_s"]
            if c.code:
                self.waiting.pop(c.code, None)
                c.code = None
            peer = c.peer
            line = self._room_line(c, code)
        if line:
            self.log(line)
        if c.wlock.acquire(timeout=0.5):
            try:
                ok = self._write_locked(c, close_frame(code), 0)
            finally:
                c.wlock.release()
        else:
            ok = False
        if ok:
            try:
                c.sock.shutdown(socket.SHUT_WR)
            except OSError:
                pass
        else:
            self._kill(c)
        if peer is not None and peer_code is not None:
            self._end(peer, peer_code)

    def _room_line(self, c, code):
        """The one log line for a room's end (or a socket that never had one). Holds self.lock."""
        room = c.room
        if room is None:
            return "socket closed %d (no room)" % code
        if room["logged"]:
            return None
        room["logged"] = True
        age = self.clock() - room["t0"]
        return "room closed %d after %ds%s" % (code, age, "" if room["paired_t"] else " (unpaired)")

    def _drop(self, c):
        """The socket's thread is done with it: forget it, close the peer."""
        with self.lock:
            if c not in self.conns:
                return
            self.conns.discard(c)
            self.per_ip[c.ip] -= 1
            if not self.per_ip[c.ip]:
                del self.per_ip[c.ip]
            if c.code:
                self.waiting.pop(c.code, None)
                c.code = None
            line = self._room_line(c, 1006) if c.state != "closing" else None
            peer = c.peer
            c.state = "closing"
        if line:
            self.log(line)
        if peer is not None:
            self._end(peer, 4000)
        self._kill(c)

    # ---------------------------------------------------------------- housekeeping
    def tick(self):
        """Enforce every deadline. Called every 0.5 s by the housekeeping thread
        (or by tests, with a fake clock)."""
        now = self.clock()
        ends, pings, kills = [], [], []
        with self.lock:
            for ip in list(self.windows):
                kinds = self.windows[ip]
                for kind in [k for k, q in kinds.items() if not q or q[-1] <= now - 60]:
                    del kinds[kind]
                if not kinds:
                    del self.windows[ip]
            for c in self.conns:
                if c.state == "closing":
                    if now >= c.close_by:
                        kills.append(c)
                elif c.state == "control" and now - c.t0 >= self.caps["handshake_s"]:
                    ends.append((c, 4008, None))
                elif c.state == "waiting" and now >= c.code_exp:
                    ends.append((c, 4001, None))
                elif c.state == "paired" and now - c.room["paired_t"] >= self.caps["lifetime_s"]:
                    ends.append((c, 4006, 4006))
                elif c.state == "paired" and now - c.last_data >= self.caps["idle_s"]:
                    ends.append((c, 4005, 4005))
                elif now - c.last_pong >= self.caps["pong_s"]:
                    ends.append((c, 4007, 4000))
                elif now - c.last_ping >= self.caps["ping_s"]:
                    c.last_ping = now
                    pings.append(c)
        for c in kills:
            self._kill(c)
        for c, code, peer_code in ends:
            self._end(c, code, peer_code)
        for c in pings:
            if c.state == "closing":              # ended just above (its peer timed out)
                continue
            if c.wlock.acquire(blocking=False):   # never wait behind a forward
                try:
                    self._write_locked(c, encode_frame(OP_PING), 0)
                finally:
                    c.wlock.release()


# ---------------------------------------------------------------------- standalone
class _Handler(http.server.BaseHTTPRequestHandler):
    server_version = "LinkRelay"
    sys_version = ""
    protocol_version = "HTTP/1.1"
    relay = None
    timeout = CAPS["handshake_s"]

    def do_GET(self):
        if self.path.split("?", 1)[0] == PATH:
            return self.relay.handle(self)
        self.send_error(404)

    def log_request(self, code="-", size="-"):
        pass   # the relay logs its own events; never an IP or a URL

    def log_message(self, fmt, *args):
        sys.stderr.write("%s\n" % (fmt % args))


def parse_caps(items):
    caps = {}
    for item in items or []:
        name, _, value = item.partition("=")
        if name not in CAPS or not value:
            raise SystemExit("bad cap %r; names: %s" % (item, ", ".join(sorted(CAPS))))
        caps[name] = float(value)
    return caps


def main(argv=None):
    ap = argparse.ArgumentParser(description="Standalone link relay (LK1d).")
    ap.add_argument("--host", default="127.0.0.1")
    ap.add_argument("--port", type=int, default=8081)
    ap.add_argument("--origin", action="append", default=[],
                    help="allowed Origin (repeatable); default %s" % DEFAULT_ORIGINS[0])
    ap.add_argument("--cap", action="append", default=[], metavar="NAME=VALUE")
    args = ap.parse_args(argv)
    relay = Relay(args.origin or DEFAULT_ORIGINS, parse_caps(args.cap)).start()
    _Handler.relay = relay
    _Handler.timeout = relay.caps["handshake_s"]
    server = http.server.ThreadingHTTPServer((args.host, args.port), _Handler)
    print("link relay on ws://%s:%d%s" % (args.host, server.server_address[1], PATH), flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        relay.stop()


if __name__ == "__main__":
    main()
