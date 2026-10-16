"""LK1d relay tests: tools/venv/bin/python -m unittest discover -s hack/web/test -p 'test_link*.py'

Each test starts a real server.py Handler with the relay on an ephemeral 127.0.0.1
port, drives it with a raw-socket WebSocket client written here (so malformed
frames can be sent), and uses a fake clock so deadlines are tested without waiting.
No files are written."""

import base64
import contextlib
import hashlib
import http.client
import http.server
import io
import json
import os
import select
import signal
import socket
import struct
import subprocess
import sys
import threading
import time
import unittest

WEB = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, WEB)
import link_relay  # noqa: E402
import server      # noqa: E402

ROM = os.path.join(os.path.dirname(WEB), "pokecrystal.gbc")
ORIGIN = "http://127.0.0.1"
FILES = server.load_files(ROM)


class Clock(object):
    def __init__(self):
        self.t = 1000.0

    def __call__(self):
        return self.t


class Site(object):
    """A server.py instance on 127.0.0.1:<ephemeral>, with or without the relay."""

    def __init__(self, link=True, caps=None, origins=(ORIGIN,), quiet=True):
        self.clock = Clock()
        self.logs = []
        self.relay = None
        attrs = {"files": FILES, "log_message": lambda h, fmt, *a: None}
        if link:   # as server.py main() wires --link
            self.relay = link_relay.Relay(origins, caps, clock=self.clock,
                                          log=self.logs.append, autotick=False)
            attrs.update(link=self.relay, timeout=self.relay.caps["handshake_s"],
                         header_budget=server.HEADER_BUDGET_X * self.relay.caps["handshake_s"])
        handler = type("H", (server.Handler,), attrs)
        self.httpd = http.server.ThreadingHTTPServer(("127.0.0.1", 0), handler)
        self.port = self.httpd.server_address[1]
        self.thread = threading.Thread(target=self.httpd.serve_forever, kwargs={"poll_interval": 0.05})
        self.thread.daemon = True
        self.thread.start()

    def tick(self, advance=0.0):
        self.clock.t += advance
        self.relay.tick()

    def close(self):
        if self.relay:
            self.relay.stop()
        self.httpd.shutdown()
        self.httpd.server_close()
        self.thread.join()


def raw_request(port, data):
    s = socket.create_connection(("127.0.0.1", port))
    s.settimeout(5)
    s.sendall(data)
    out = b""
    while True:
        chunk = s.recv(65536)
        if not chunk:
            break
        out += chunk
    s.close()
    return out


class WS(object):
    """Minimal client. Sends masked frames unless told otherwise."""

    def __init__(self, site, path="/link", origin=ORIGIN, ip=None, headers=None, rcvbuf=None,
                 version="HTTP/1.1"):
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        if rcvbuf:
            self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, rcvbuf)
        self.sock.connect(("127.0.0.1", site.port))
        self.sock.settimeout(5)
        self.key = base64.b64encode(os.urandom(16)).decode()
        hdrs = {"Host": "127.0.0.1:%d" % site.port, "Upgrade": "websocket",
                "Connection": "Upgrade", "Sec-WebSocket-Key": self.key,
                "Sec-WebSocket-Version": "13", "Origin": origin}
        if ip:
            hdrs["CF-Connecting-IP"] = ip
        hdrs.update(headers or {})
        req = "GET %s %s\r\n" % (path, version) + "".join(
            "%s: %s\r\n" % kv for kv in hdrs.items() if kv[1] is not None) + "\r\n"
        self.sock.sendall(req.encode("latin-1"))
        self.buf = b""
        while b"\r\n\r\n" not in self.buf:
            chunk = self.sock.recv(4096)
            if not chunk:
                break
            self.buf += chunk
        head, _, self.buf = self.buf.partition(b"\r\n\r\n")
        lines = head.decode("latin-1").split("\r\n")
        self.status = int(lines[0].split()[1]) if lines[0] else 0
        self.headers = {}
        for line in lines[1:]:
            k, _, v = line.partition(":")
            self.headers[k.strip().lower()] = v.strip()

    def _exact(self, n):
        while len(self.buf) < n:
            chunk = self.sock.recv(65536)
            if not chunk:
                raise EOFError()
            self.buf += chunk
        out, self.buf = self.buf[:n], self.buf[n:]
        return out

    def raw(self, data):
        self.sock.sendall(data)

    def frame(self, op, payload=b"", fin=True, mask=True, rsv=0, long16=False):
        if isinstance(payload, str):
            payload = payload.encode()
        b0 = (0x80 if fin else 0) | rsv | op
        n = len(payload)
        m = 0x80 if mask else 0
        if n < 126 and not long16:
            head = struct.pack("!BB", b0, m | n)
        elif n < 65536:
            head = struct.pack("!BBH", b0, m | 126, n)
        else:
            head = struct.pack("!BBQ", b0, m | 127, n)
        if mask:
            key = os.urandom(4)
            payload = bytes(b ^ key[i % 4] for i, b in enumerate(payload))
            head += key
        self.raw(head + payload)

    def text(self, s):
        self.frame(1, s)

    def recv(self):
        b0, b1 = self._exact(2)
        assert not b1 & 0x80, "server frames must not be masked"
        n = b1 & 0x7F
        if n == 126:
            n = struct.unpack("!H", self._exact(2))[0]
        elif n == 127:
            n = struct.unpack("!Q", self._exact(8))[0]
        return b0 & 0x0F, self._exact(n)

    def recv_json(self):
        op, data = self.recv()
        assert op == 1, (op, data)
        return json.loads(data)

    def expect_close(self):
        """Read until a close frame, answer it, close the socket; return the code."""
        while True:
            op, data = self.recv()
            if op == 8:
                code = struct.unpack("!H", data[:2])[0] if len(data) >= 2 else None
                try:
                    self.frame(8, data[:2])
                except OSError:
                    pass
                self.close()
                return code

    def eof(self):
        """True once the server has closed the TCP connection (after any frames)."""
        try:
            while True:
                chunk = self.sock.recv(65536)
                if not chunk:
                    return True
        except (socket.timeout, OSError):
            return False

    def create(self):
        self.text('{"op":"create"}')
        msg = self.recv_json()
        assert msg["op"] == "code" and msg["ttl"] == 120, msg
        return msg["code"]

    def join(self, code):
        self.text(json.dumps({"op": "join", "code": code}))

    def close(self):
        try:
            self.sock.close()
        except OSError:
            pass


def pair(site, ip_a=None, ip_b=None):
    a = WS(site, ip=ip_a)
    code = a.create()
    b = WS(site, ip=ip_b)
    b.join(code)
    assert b.recv_json() == {"op": "paired", "role": "b"}
    assert a.recv_json() == {"op": "paired", "role": "a"}
    return a, b, code


def wait_for(pred, timeout=5.0):
    end = time.monotonic() + timeout
    while time.monotonic() < end:
        if pred():
            return True
        time.sleep(0.01)
    return pred()


class FakeHandler(object):
    """Just enough of a BaseHTTPRequestHandler for Relay.client_ip."""

    def __init__(self, peer, *cf_ips):
        self.client_address = (peer, 1)
        raw = "".join("CF-Connecting-IP: %s\r\n" % v for v in cf_ips) + "\r\n"
        self.headers = http.client.parse_headers(io.BytesIO(raw.encode()))


def conn_in(relay, state):
    """The relay's one _Conn in `state` (tests drive the relay's methods directly)."""
    with relay.lock:
        found = [c for c in relay.conns if c.state == state]
    assert len(found) == 1, found
    return found[0]


class Base(unittest.TestCase):
    caps = None
    quiet = True

    def setUp(self):
        self.site = Site(caps=self.caps, quiet=self.quiet)
        self.clients = []

    def tearDown(self):
        for c in self.clients:
            c.close()
        self.site.close()

    def ws(self, **kw):
        c = WS(self.site, **kw)
        self.clients.append(c)
        return c

    def pair(self, ip_a=None, ip_b=None):
        a, b, code = pair(self.site, ip_a, ip_b)
        self.clients += [a, b]
        return a, b, code


class Handshake(Base):
    def test_rfc_example_accept(self):
        self.assertEqual(link_relay.accept_key("dGhlIHNhbXBsZSBub25jZQ=="),
                         "s3pPLMBiTxaQ9kYGzzhZRbK+xOo=")

    def test_upgrade(self):
        c = self.ws(headers={"Sec-WebSocket-Extensions": "permessage-deflate; client_max_window_bits",
                             "Sec-WebSocket-Protocol": "chat"})
        self.assertEqual(c.status, 101)
        want = base64.b64encode(hashlib.sha1((c.key + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11")
                                             .encode()).digest()).decode()
        self.assertEqual(c.headers["sec-websocket-accept"], want)
        self.assertEqual(c.headers["upgrade"].lower(), "websocket")
        self.assertEqual(c.headers["connection"].lower(), "upgrade")
        self.assertNotIn("sec-websocket-extensions", c.headers)   # deflate declined
        self.assertNotIn("sec-websocket-protocol", c.headers)

    def test_refusals(self):
        cases = [
            (dict(headers={"Upgrade": None}), 400),
            (dict(headers={"Upgrade": "h2c"}), 400),
            (dict(headers={"Connection": "keep-alive"}), 400),
            (dict(headers={"Sec-WebSocket-Key": None}), 400),
            (dict(headers={"Sec-WebSocket-Key": "c2hvcnQ="}), 400),       # not 16 bytes
            (dict(headers={"Sec-WebSocket-Key": "not base64 at all!"}), 400),
            (dict(headers={"Sec-WebSocket-Version": "8"}), 426),
            (dict(headers={"Sec-WebSocket-Version": None}), 426),
            (dict(origin="https://evil.example"), 403),
            (dict(origin=None), 403),
            (dict(origin="http://127.0.0.1:9"), 403),                     # exact match only
            (dict(path="/link?code=a-b-c"), 400),
            (dict(path="/link/"), 404),                                   # not routed at all
            (dict(version="HTTP/1.0"), 400),
            (dict(headers={"X-Pad": "x" * 9000}), 431),
        ]
        for kw, status in cases:
            c = self.ws(**kw)
            self.assertEqual(c.status, status, kw)
            if status == 426:
                self.assertEqual(c.headers.get("sec-websocket-version"), "13")
            if status != 404:             # a 404 is the static path, which keeps the connection alive
                self.assertTrue(c.eof(), kw)
        self.assertEqual(self.site.relay.snapshot()["sockets"], 0)

    def test_connection_header_token_list(self):
        c = self.ws(headers={"Connection": "keep-alive, Upgrade", "Upgrade": "WebSocket"})
        self.assertEqual(c.status, 101)


class StaticUnchanged(unittest.TestCase):
    def fetch_all(self, site):
        out = {}
        paths = sorted(FILES) + ["/nope", "/link", "/index.html?x=1"]
        for method in ("GET", "HEAD"):
            for p in paths:
                if p == "/link" and site.relay and method == "GET":
                    continue
                resp = raw_request(site.port, ("%s %s HTTP/1.1\r\nHost: x\r\nConnection: close\r\n\r\n"
                                               % (method, p)).encode())
                out[(method, p)] = b"\r\n".join(l for l in resp.split(b"\r\n")
                                                if not l.startswith(b"Date: "))
        return out

    def test_static_bytes_identical_and_link_404_without_flag(self):
        plain, linked = Site(link=False), Site(link=True)
        try:
            a, b = self.fetch_all(plain), self.fetch_all(linked)
            self.assertGreater(len(a), 40)
            for k in b:
                self.assertEqual(a[k], b[k], k)
            self.assertEqual(a[("GET", "/link")], a[("GET", "/nope")])
            self.assertTrue(a[("GET", "/link")].startswith(b"HTTP/1.1 404"))
            c = WS(plain)
            self.assertEqual(c.status, 404)
            c.close()
        finally:
            plain.close()
            linked.close()

    def test_slow_download_not_cut_by_header_timeout(self):
        # --link sets a per-read timeout for the request headers; a slow reader of the
        # ROM must still get every byte (Python applies the timeout to a whole sendall)
        site = Site(link=True, caps={"handshake_s": 0.3})
        try:
            s = socket.socket()
            s.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 4096)
            s.connect(("127.0.0.1", site.port))
            s.settimeout(5)
            s.sendall(b"GET /kanto-first.gbc HTTP/1.1\r\nHost: x\r\nConnection: close\r\n\r\n")
            time.sleep(1.0)
            out = b""
            while True:
                chunk = s.recv(1 << 20)
                if not chunk:
                    break
                out += chunk
            s.close()
            head, body = out.split(b"\r\n\r\n", 1)
            self.assertEqual(body, FILES[server.ROM_PATH][0])
        finally:
            site.close()


class Framing(Base):
    def test_unmasked_frame_1002(self):
        a, b, _ = self.pair()
        a.frame(1, "hi", mask=False)
        self.assertEqual(a.expect_close(), 1002)
        self.assertEqual(b.expect_close(), 4000)

    def test_oversize_1009_before_payload(self):
        a, b, _ = self.pair()
        a.text("x" * 4096)
        self.assertEqual(b.recv(), (1, b"x" * 4096))
        # header claims 4097 bytes; the relay refuses without waiting for the payload
        a.raw(struct.pack("!BBH", 0x82, 0xFE, 4097) + b"mask")
        self.assertEqual(a.expect_close(), 1009)
        self.assertEqual(b.expect_close(), 4000)

    def test_oversize_64bit_length_1009(self):
        a, b, _ = self.pair()
        a.raw(struct.pack("!BBQ", 0x82, 0xFF, 1 << 40) + b"mask")
        self.assertEqual(a.expect_close(), 1009)

    def test_control_frame_over_256_1009(self):
        c = self.ws()
        c.text('{"op":"create","pad":"%s"}' % ("x" * 250))
        self.assertEqual(c.expect_close(), 1009)

    def test_fragmentation_1003(self):
        a, b, _ = self.pair()
        a.frame(1, "part", fin=False)
        self.assertEqual(a.expect_close(), 1003)
        self.assertEqual(b.expect_close(), 4000)
        c, d, _ = self.pair()
        c.frame(0, "cont")
        self.assertEqual(c.expect_close(), 1003)

    def test_protocol_errors_1002(self):
        bad = [dict(op=1, payload="x", rsv=0x40), dict(op=3, payload="x"), dict(op=0xB),
               dict(op=9, payload=b"p" * 126), dict(op=9, payload="p", fin=False),
               dict(op=1, payload="short", long16=True)]                  # non-minimal length
        for kw in bad:
            a, b, _ = self.pair()
            a.frame(**kw)
            self.assertEqual(a.expect_close(), 1002, kw)
            self.assertEqual(b.expect_close(), 4000, kw)

    def test_invalid_utf8_text_1007(self):
        a, b, _ = self.pair()
        a.frame(1, b"\xff\xfe")
        self.assertEqual(a.expect_close(), 1007)


class Rooms(Base):
    def test_pair_and_forward_both_ways(self):
        a, b, code = self.pair()
        self.assertRegex(code, r"^[a-z]{4,8}-[a-z]{4,8}-[a-z]{4,8}$")
        for size in (0, 1, 125, 126, 4095):
            blob = base64.b64encode(os.urandom(size))[:size]
            a.frame(1, blob)
            self.assertEqual(b.recv(), (1, blob))
            b.frame(1, blob)
            self.assertEqual(a.recv(), (1, blob))
        a.text('{"type":"hello","name":"ALPHA"}')
        self.assertEqual(b.recv(), (1, b'{"type":"hello","name":"ALPHA"}'))
        b.text("é ✓ not json")
        self.assertEqual(a.recv(), (1, "é ✓ not json".encode()))
        self.assertEqual(self.site.relay.snapshot(), {"sockets": 2, "waiting": 0, "paired": 1,
                                                       "tracked_ips": 1})

    def test_code_case_and_separators(self):
        a = self.ws()
        code = a.create()
        b = self.ws()
        b.join("  " + code.upper().replace("-", " ") + " ")
        self.assertEqual(b.recv_json()["role"], "b")
        self.assertEqual(a.recv_json()["role"], "a")

    def test_code_deleted_after_pairing(self):
        a, b, code = self.pair()
        self.assertEqual(self.site.relay.waiting, {})
        c = self.ws()
        c.join(code)
        self.assertEqual(c.expect_close(), 4002)
        a.text("still here")
        self.assertEqual(b.recv(), (1, b"still here"))

    def test_wrong_code_neutral(self):
        a = self.ws()
        real = a.create()
        words = self.site.relay.words
        fake = "-".join(w for w in words[:3]) if "-".join(words[:3]) != real else "-".join(words[3:6])
        frames = []
        for code in (fake, "nope-nope-nope", "", "a" * 64, real + "-" + words[0], "x"):
            c = self.ws()
            c.join(code)
            op, data = c.recv()
            frames.append((op, data))
            c.close()
        self.assertEqual(set(frames), {(8, struct.pack("!H", 4002))})
        # the real room is untouched by the failed guesses
        b = self.ws()
        b.join(real)
        self.assertEqual(b.recv_json()["role"], "b")

    def test_bad_control_1008(self):
        for msg in ('{"op":"create","x":1}', '{"op":"join"}', '{"op":"join","code":5}',
                    "not json", "[]", '{"op":"hello"}'):
            c = self.ws()
            c.text(msg)
            self.assertEqual(c.expect_close(), 1008, msg)
        c = self.ws()
        c.frame(2, b'{"op":"create"}')
        self.assertEqual(c.expect_close(), 1008)
        a = self.ws()
        a.create()
        a.text("data before a peer")
        self.assertEqual(a.expect_close(), 1008)

    def test_join_flood_4029(self):
        a = self.ws()
        real = a.create()
        for _ in range(12):
            c = self.ws(ip="198.51.100.7")
            c.join("nope-nope-nope")
            self.assertEqual(c.expect_close(), 4002)
        c = self.ws(ip="198.51.100.7")
        c.join(real)                  # even the right code, once over the cap
        self.assertEqual(c.expect_close(), 4029)
        d = self.ws(ip="198.51.100.8")  # another IP is unaffected
        d.join(real)
        self.assertEqual(d.recv_json()["role"], "b")
        self.site.tick(60.1)
        e = self.ws(ip="198.51.100.7")
        e.join("nope-nope-nope")
        self.assertEqual(e.expect_close(), 4002)

    def test_create_rate_4029(self):
        for i in range(6):
            c = self.ws(ip="203.0.113.5")
            c.create()
            c.text('{"op":"x"}')     # leaves; frees its socket slot
            c.expect_close()
        c = self.ws(ip="203.0.113.5")
        c.text('{"op":"create"}')
        self.assertEqual(c.expect_close(), 4029)

    def test_client_ip_key(self):
        # CF-Connecting-IP only from a trusted (default: loopback) peer; IPv6 keyed by /56
        relay = self.site.relay

        def key(peer, *hdrs):
            h = FakeHandler(peer, *hdrs)
            return relay.client_ip(h)
        self.assertEqual(key("192.0.2.1", "10.0.0.1"), "192.0.2.1")        # untrusted peer
        self.assertEqual(key("127.0.0.1", "10.0.0.1"), "10.0.0.1")
        self.assertEqual(key("127.0.0.1", "2001:db8::1:2"), "2001:db8::/56")
        self.assertEqual(key("127.0.0.1", "junk"), "127.0.0.1")
        self.assertEqual(key("127.0.0.1", ""), "127.0.0.1")                  # empty header
        self.assertEqual(key("127.0.0.1", "10.0.0.1", "10.0.0.2"), "127.0.0.1")   # two headers
        self.assertEqual(key("127.0.0.1", " ::ffff:198.51.100.4 "), "198.51.100.4")   # v4-mapped
        self.assertEqual(key("127.0.0.1", "fe80::1%eth0"), "fe80::/56")      # scoped
        self.assertEqual(key("::ffff:127.0.0.1", "10.0.0.1"), "10.0.0.1")    # dual-stack loopback
        self.assertEqual(key("::1", "10.0.0.1"), "10.0.0.1")
        self.assertEqual(key("2001:db8:aa:bb::7"), "2001:db8:aa::/56")       # raw IPv6 peer
        # /64 rotation inside one /56 is one key; the next /56 is another
        keys = {key("127.0.0.1", "2001:db8:1:%x::1" % i) for i in range(256)}
        self.assertEqual(keys, {"2001:db8:1::/56"})
        self.assertEqual(key("127.0.0.1", "2001:db8:1:100::1"), "2001:db8:1:100::/56")

    def test_closing_one_side_closes_other(self):
        a, b, _ = self.pair()
        a.frame(8, struct.pack("!H", 1000))
        self.assertEqual(a.expect_close(), 1000)
        self.assertEqual(b.expect_close(), 4000)
        c, d, _ = self.pair()
        c.close()                     # abrupt TCP close, no close frame
        self.assertEqual(d.expect_close(), 4000)
        self.assertTrue(wait_for(lambda: self.site.relay.snapshot()["sockets"] == 0))

    def test_creator_leaving_frees_code(self):
        a = self.ws()
        code = a.create()
        a.close()
        self.assertTrue(wait_for(lambda: not self.site.relay.waiting))
        b = self.ws()
        b.join(code)
        self.assertEqual(b.expect_close(), 4002)

    def test_handshake_deadline_4008(self):
        c = self.ws()
        self.site.tick(9.9)
        self.assertEqual(self.site.relay.snapshot()["sockets"], 1)
        self.site.tick(0.1)
        self.assertEqual(c.expect_close(), 4008)

    def test_unanswered_close_is_cut(self):
        a, b, _ = self.pair()
        a.frame(1, "x", mask=False)           # protocol error; then a ignores our close
        self.assertEqual(a.recv(), (8, struct.pack("!H", 1002)))
        self.site.tick(2)
        self.assertTrue(a.eof())
        self.assertTrue(wait_for(lambda: self.site.relay.snapshot()["sockets"] <= 1))


class Caps(Base):
    caps = {"waiting": 3, "sockets": 6, "sockets_per_ip": 4, "upgrades_per_ip_min": 30}

    def test_waiting_room_cap_4013(self):
        for i in range(3):
            self.ws(ip="10.1.0.%d" % i).create()
        c = self.ws(ip="10.1.0.9")
        c.text('{"op":"create"}')
        self.assertEqual(c.expect_close(), 4013)

    def test_socket_caps(self):
        for i in range(4):
            self.assertEqual(self.ws(ip="10.2.0.1").status, 101)
        self.assertEqual(self.ws(ip="10.2.0.1").status, 429)
        self.assertEqual(self.ws(ip="10.2.0.2").status, 101)
        self.assertEqual(self.ws(ip="10.2.0.3").status, 101)
        self.assertEqual(self.ws(ip="10.2.0.4").status, 503)

    def test_upgrade_rate_429(self):
        for i in range(30):
            c = self.ws(ip="10.3.0.1")
            self.assertEqual(c.status, 101)
            c.close()
            self.assertTrue(wait_for(lambda: self.site.relay.snapshot()["sockets"] == 0))
        self.assertEqual(self.ws(ip="10.3.0.1").status, 429)


NO_PINGS = {"ping_s": 10 ** 6, "pong_s": 10 ** 6}


class Deadlines(Base):
    caps = NO_PINGS

    def test_expiry_at_120s(self):
        a = self.ws()
        code = a.create()
        self.site.tick(119.9)
        self.assertEqual(self.site.relay.snapshot()["waiting"], 1)
        self.site.tick(0.1)
        self.assertEqual(a.expect_close(), 4001)
        self.assertEqual(self.site.relay.waiting, {})
        b = self.ws()
        b.join(code)
        self.assertEqual(b.expect_close(), 4002)

    def test_idle_90s_closes_both(self):
        a, b, _ = self.pair()
        self.site.tick(60)
        a.text("a is alive")
        self.assertEqual(b.recv(), (1, b"a is alive"))
        self.site.tick(29.9)
        self.assertEqual(self.site.relay.snapshot()["paired"], 1)
        self.site.tick(0.1)                # b silent for 90 s
        self.assertEqual(a.expect_close(), 4005)
        self.assertEqual(b.expect_close(), 4005)

    def test_message_rate_4003(self):
        a, b, _ = self.pair()
        for i in range(58):              # burst 60, the control frame used one
            a.text("m")
        a.text("last ok")
        for i in range(59):
            b.recv()
        a.text("one too many")
        self.assertEqual(a.expect_close(), 4003)
        self.assertEqual(b.expect_close(), 4000)


class PingPong(Base):
    caps = {"idle_s": 10 ** 6}

    def test_ping_pong_and_no_pong_4007(self):
        a, b, _ = self.pair()
        a.frame(9, b"abc")
        self.assertEqual(a.recv(), (10, b"abc"))      # client ping answered
        self.site.tick(30)
        self.assertEqual(a.recv(), (9, b""))          # server pings both
        self.assertEqual(b.recv(), (9, b""))
        a.frame(10)                                   # only a answers
        a.text("sync")
        self.assertEqual(b.recv(), (1, b"sync"))      # a's pong has been read by now
        self.site.tick(29.9)
        self.assertEqual(self.site.relay.snapshot()["paired"], 1)
        self.site.tick(0.1)               # 60 s since b's last pong (the upgrade)
        self.assertEqual(b.expect_close(), 4007)
        self.assertEqual(a.expect_close(), 4000)


class Lifetime(Base):
    caps = {"idle_s": 10 ** 6, "pong_s": 10 ** 6, "ping_s": 10 ** 6}

    def test_lifetime_3h(self):
        a, b, _ = self.pair()
        self.site.tick(3 * 3600 - 1)
        self.assertEqual(self.site.relay.snapshot()["paired"], 1)
        self.site.tick(1)
        self.assertEqual(a.expect_close(), 4006)
        self.assertEqual(b.expect_close(), 4006)


class SlowReader(Base):
    caps = {"write_s": 0.5, "frames_per_s": 10 ** 6, "frame_burst": 10 ** 6,
            "bytes_per_s": 10 ** 9, "byte_burst": 10 ** 9, "room_bytes": 10 ** 12}

    def test_stalled_reader_closes_both(self):
        a = self.ws()
        code = a.create()
        b = self.ws(rcvbuf=4096)
        b.join(code)
        self.assertEqual(b.recv_json()["role"], "b")
        self.assertEqual(a.recv_json()["role"], "a")
        got = []
        reader = threading.Thread(target=lambda: got.append(a.expect_close()))
        reader.start()
        t0 = time.monotonic()
        try:
            while not got and time.monotonic() - t0 < 10:   # b never reads
                a.text("x" * 4096)
        except OSError:
            pass
        reader.join(10)
        self.assertEqual(got, [4004])
        self.assertLess(time.monotonic() - t0, 5)
        self.assertTrue(wait_for(lambda: self.site.relay.snapshot()["sockets"] == 0))


class Leaks(Base):
    caps = {"sockets": 200, "sockets_per_ip": 200, "upgrades_per_ip_min": 10 ** 9,
            "creates_per_ip_min": 10 ** 9, "joins_per_ip_min": 10 ** 9, "waiting": 200}

    def fds(self):
        for d in ("/proc/self/fd", "/dev/fd"):
            if os.path.isdir(d):
                return len(os.listdir(d))
        return 0

    def test_1000_rooms_no_thread_or_fd_leak(self):
        a, b, _ = pair(self.site)       # warm up
        a.close(), b.close()
        self.assertTrue(wait_for(lambda: self.site.relay.snapshot()["sockets"] == 0))
        time.sleep(0.2)
        threads0, fds0 = threading.active_count(), self.fds()
        t0 = time.monotonic()
        for batch in range(40):
            rooms = [pair(self.site) for _ in range(25)]
            for a, b, _ in rooms:
                a.frame(1, b"ping")
                b.frame(1, "pong")
            for a, b, _ in rooms:
                self.assertEqual(b.recv(), (1, b"ping"))
                self.assertEqual(a.recv(), (1, b"pong"))
                a.frame(8, struct.pack("!H", 1000))
                self.assertEqual(a.expect_close(), 1000)
                self.assertEqual(b.expect_close(), 4000)
        elapsed = time.monotonic() - t0
        self.assertTrue(wait_for(lambda: self.site.relay.snapshot()["sockets"] == 0, 10))
        self.assertTrue(wait_for(lambda: threading.active_count() <= threads0, 10),
                        (threading.active_count(), threads0))
        self.assertTrue(wait_for(lambda: self.fds() <= fds0, 10), (self.fds(), fds0))
        snap = self.site.relay.snapshot()
        self.assertEqual((snap["waiting"], snap["paired"]), (0, 0))
        sys.stderr.write("[1000 rooms in %.1fs] " % elapsed)


class ErrorPaths(Base):
    """Review coverage gaps 4 and 5: sockets that die on error paths, and random
    frames, leave no thread, FD or room behind and never raise out of a thread."""
    caps = Leaks.caps
    fds = Leaks.fds

    def setUp(self):
        Base.setUp(self)
        self.crashes = []
        self.site.httpd.handle_error = lambda req, addr: self.crashes.append(sys.exc_info()[0])
        old_hook = threading.excepthook
        threading.excepthook = lambda a: self.crashes.append(a.exc_type)
        self.addCleanup(setattr, threading, "excepthook", old_hook)

    def settle(self, threads0, fds0):
        for _ in range(3):              # cut sockets still waiting for a close reply
            self.site.tick(self.site.relay.caps["close_wait_s"] + 1)
            time.sleep(0.05)
        self.assertTrue(wait_for(lambda: self.site.relay.snapshot()["sockets"] == 0, 10),
                        self.site.relay.snapshot())
        self.assertTrue(wait_for(lambda: threading.active_count() <= threads0, 10),
                        (threading.active_count(), threads0))
        self.assertTrue(wait_for(lambda: self.fds() <= fds0, 10), (self.fds(), fds0))
        snap = self.site.relay.snapshot()
        self.assertEqual((snap["waiting"], snap["paired"]), (0, 0))
        self.assertEqual(self.crashes, [])
        for line in self.site.logs:
            self.assertNotRegex(line, r"10\.\d+\.\d+\.\d+|Traceback|\"op\"")
        a, b, _ = pair(self.site)       # still serving
        a.text("after")
        self.assertEqual(b.recv(), (1, b"after"))
        a.close(), b.close()

    def baseline(self):
        a, b, _ = pair(self.site)
        a.close(), b.close()
        self.assertTrue(wait_for(lambda: self.site.relay.snapshot()["sockets"] == 0))
        time.sleep(0.2)
        return threading.active_count(), self.fds()

    def test_error_path_sockets_leak_nothing(self):
        threads0, fds0 = self.baseline()
        held = []
        for i in range(200):
            ip = "10.5.%d.%d" % (i >> 8, i & 255)
            c = WS(self.site, ip=ip)
            held.append(c)
            k = i % 10
            if k == 0:
                c.frame(1, "x", mask=False)                     # 1002, then vanish
                c.close()
            elif k == 1:
                c.raw(b"\x82\xfe\x10")                          # partial header
                c.close()
            elif k == 2:
                c.raw(b"\x82\x85abcd")                           # gone mid-payload
                c.close()
            elif k == 3:
                c.frame(1, "x" * 300)                           # 1009, then vanish
                c.close()
            elif k == 4:
                c.join("a-b-c")                                 # 4002, never answered
                c.close()
            elif k == 5:
                c.frame(1, "x", mask=False)                     # 1002, held open, silent
            elif k == 6:                                        # paired; one side dies mid-frame
                code = c.create()
                d = WS(self.site, ip="10.6.%d.%d" % (i >> 8, i & 255))
                held.append(d)
                d.join(code)
                d.recv(), c.recv()
                d.raw(b"\x81\x85ab")
                d.close()
            elif k == 7:
                c.sock.shutdown(socket.SHUT_WR)                 # half-close, never read
            elif k == 8:
                c.text('{"op":"create"}')                       # data while waiting
                c.text("data while waiting")
                c.close()
            else:
                c.close()
            if len(held) > 40:
                for h in held[:20]:
                    h.close()
                held = held[20:]
        for h in held:
            h.close()
        self.settle(threads0, fds0)

    def test_random_frames_never_crash(self):
        import random
        rng = random.Random(7)
        threads0, fds0 = self.baseline()
        for i in range(150):
            if i % 2:
                a, b, _ = pair(self.site, "10.3.0.%d" % i, "10.4.0.%d" % i)
            else:
                a, b = WS(self.site, ip="10.3.0.%d" % i), None
            try:
                for _ in range(5):
                    op = rng.choice([0, 1, 2, 3, 8, 9, 10, 11, 15])
                    n = rng.choice([0, 1, 2, 125, 126, 127, 200, 4096, 4097])
                    if rng.random() < 0.8:
                        pl = os.urandom(n) if rng.random() < 0.5 else ("\u00e9" * n).encode()[:n]
                        a.frame(op, pl, fin=rng.random() < 0.8,
                                rsv=rng.choice([0, 0, 0x40, 0x10]))
                    else:
                        a.raw(os.urandom(rng.randint(1, 64)))
                a.frame(8, struct.pack("!H", 1000))
            except OSError:
                pass
            a.close()
            if b:
                b.close()
        self.settle(threads0, fds0)


class Logs(Base):
    quiet = False
    def test_no_code_payload_or_ip_in_logs(self):
        err = io.StringIO()
        with contextlib.redirect_stderr(err):
            a = self.ws(ip="198.51.100.77")
            code = a.create()
            b = self.ws(ip="198.51.100.78")
            b.join(code)
            b.recv_json(), a.recv_json()
            a.text("SECRET-PAYLOAD-123")
            b.recv()
            c = self.ws(ip="198.51.100.79")
            c.join(code)                      # used code: refused
            c.expect_close()
            d = self.ws(origin="https://evil.example")
            a.frame(8, struct.pack("!H", 1000))
            a.expect_close(), b.expect_close()
            wait_for(lambda: self.site.relay.snapshot()["sockets"] == 0)
            self.site.tick(60)                # refusals are summarised once a minute
        text = "\n".join(self.site.logs) + "\n" + err.getvalue()
        for secret in [code, "SECRET", "198.51.100", "127.0.0.1"] + code.split("-"):
            self.assertNotIn(secret, text)
        self.assertNotIn('"GET /link"', text)   # review F7: no access-log line per attempt
        for event in ("room created", "room paired", "join refused x1",
                      "room closed 1000", "upgrade refused 403 origin x1",
                      "rate key: CF-Connecting-IP from a trusted proxy"):
            self.assertIn(event, text)
        self.assertEqual(d.status, 403)


class Bandwidth(Base):
    """Review F1: byte budget, text-only forwarding, per-room byte cap."""

    def test_byte_bucket_trips_while_frame_bucket_does_not(self):
        a, b, _ = self.pair()               # a's control frame used 15 of the 16,384-byte burst
        for i in range(3):
            a.text("x" * 4096)
            self.assertEqual(b.recv(), (1, b"x" * 4096))
        a.text("x" * 4096)                  # 5 frames (frame burst 60), 16,399 bytes: over
        self.assertEqual(a.expect_close(), 4003)
        self.assertEqual(b.expect_close(), 4000)
        # the bucket refills at bytes_per_s (512/s): 8 s later the same frame passes
        c, d, _ = self.pair()
        for i in range(3):
            c.text("x" * 4096)
            self.assertEqual(d.recv(), (1, b"x" * 4096))
        self.site.clock.t += 8.0
        c.text("x" * 4096)
        self.assertEqual(d.recv(), (1, b"x" * 4096))

    def test_pings_count_against_bytes(self):
        a, b, _ = self.pair()
        for i in range(33):                 # 33 x 125-byte pings (4,125 bytes) ...
            a.frame(9, b"p" * 125)
            self.assertEqual(a.recv(), (10, b"p" * 125))
        a.text("x" * 4096)
        a.text("x" * 4096)
        a.text("x" * 4096)                  # ... leave less than 3 x 4,096 bytes
        self.assertEqual(b.recv(), (1, b"x" * 4096))
        self.assertEqual(b.recv(), (1, b"x" * 4096))
        self.assertEqual(a.expect_close(), 4003)

    def test_binary_after_pairing_1003(self):
        a, b, _ = self.pair()
        a.text("text is fine")
        self.assertEqual(b.recv(), (1, b"text is fine"))
        a.frame(2, b"\x00\x01")
        self.assertEqual(a.expect_close(), 1003)
        self.assertEqual(b.expect_close(), 4000)
        c, d, _ = self.pair()
        d.frame(2, b"")                     # even empty, even from the joiner
        self.assertEqual(d.expect_close(), 1003)
        self.assertEqual(c.expect_close(), 4000)


class RoomBytes(Base):
    caps = {"room_bytes": 10000}

    def test_room_byte_cap_4006(self):
        a, b, _ = self.pair()
        a.text("x" * 4096)
        self.assertEqual(b.recv(), (1, b"x" * 4096))
        b.text("y" * 4096)                  # both directions count: 8,192
        self.assertEqual(a.recv(), (1, b"y" * 4096))
        a.text("z" * 4096)                  # 12,288 > 10,000: not forwarded, room ends
        self.assertEqual(b.expect_close(), 4006)
        self.assertEqual(a.expect_close(), 4006)


class Admission(Base):
    """Review F2/F3/F5: LRU rate windows, /56 keys, waiting per IP, global join ceiling."""
    caps = {"tracked_ips": 50, "join_failures_min": 5, "joins_per_ip_min": 1000,
            "upgrades_per_ip_min": 1000, "ping_s": 10 ** 6, "pong_s": 10 ** 6}

    def test_full_table_evicts_instead_of_503(self):
        for i in range(60):                  # 60 distinct keys through a 50-key table
            c = WS(self.site, ip="2001:db8:%x::1" % (i << 8))
            self.assertEqual(c.status, 101, i)
            c.close()
        self.assertTrue(wait_for(lambda: self.site.relay.snapshot()["sockets"] == 0))
        self.assertEqual(self.site.relay.snapshot()["tracked_ips"], 50)
        self.assertNotIn("2001:db8::/56", self.site.relay.windows)   # the oldest went first
        c = self.ws(ip="192.0.2.200")                                  # a newcomer still gets in
        self.assertEqual(c.status, 101)
        self.site.tick(60)
        self.assertIn("rate windows evicted (tracked_ips full) x11 in 60s", self.site.logs)

    def test_10k_key_flood_does_not_lock_out(self):
        relay = link_relay.Relay(caps={}, clock=self.site.clock, log=self.site.logs.append,
                                 autotick=False)
        now = self.site.clock()
        with relay.lock:
            for i in range(10000):
                relay._hit("up", "2001:db8:%x::/56" % i, 30, now)
            relay._hit("up", "198.51.100.1", 30, now)            # 10,001st key
        self.assertEqual(len(relay.windows), 10000)
        self.assertIn("198.51.100.1", relay.windows)
        self.assertNotIn("2001:db8::/56", relay.windows)
        # and through the real admission path of this site, a flood then a newcomer
        with self.site.relay.lock:
            for i in range(49):
                self.site.relay._hit("up", "2001:db8:%x::/56" % i, 30, now)
        self.assertEqual(self.ws(ip="192.0.2.9").status, 101)

    def test_tick_prunes_windows(self):
        c = self.ws(ip="192.0.2.10")
        c.close()
        self.assertEqual(self.site.relay.snapshot()["tracked_ips"], 1)
        self.site.tick(59.9)
        self.assertEqual(self.site.relay.snapshot()["tracked_ips"], 1)
        self.site.tick(0.1)
        self.assertEqual(self.site.relay.snapshot()["tracked_ips"], 0)

    def test_ipv6_56_is_one_key_for_socket_cap(self):
        for i in range(4):                   # four /64s of one /56
            self.assertEqual(self.ws(ip="2001:db8:5:%x::1" % i).status, 101)
        self.assertEqual(self.ws(ip="2001:db8:5:ff::9").status, 429)
        self.assertEqual(self.ws(ip="2001:db8:5:100::1").status, 101)   # the next /56

    def test_waiting_per_ip_4029(self):
        self.ws(ip="203.0.113.9").create()
        self.ws(ip="203.0.113.9").create()
        c = self.ws(ip="203.0.113.9")
        c.text('{"op":"create"}')
        self.assertEqual(c.expect_close(), 4029)
        self.ws(ip="203.0.113.10").create()   # another key is unaffected

    def test_global_join_failure_ceiling(self):
        a = self.ws(ip="203.0.113.20")
        real = a.create()
        for i in range(5):                   # 5 failures from 5 keys
            c = self.ws(ip="198.51.100.%d" % (30 + i))
            c.join("nope-nope-nope")
            self.assertEqual(c.expect_close(), 4002)
        c = self.ws(ip="198.51.100.99")     # a fresh key, the right code: still the neutral 4002
        c.join(real)
        self.assertEqual(c.expect_close(), 4002)
        self.assertIn(real, self.site.relay.waiting)   # not consumed, not looked up
        self.site.clock.t += 60.1            # the window slides
        d = self.ws(ip="198.51.100.100")
        d.join(real)
        self.assertEqual(d.recv_json()["role"], "b")
        self.site.tick()
        self.assertTrue(any(l.startswith("join refused (relay-wide failure ceiling) x1 ")
                            for l in self.site.logs), self.site.logs)


class TrustedProxy(unittest.TestCase):
    """Review F3: the header is believed only from TRUSTED_PROXIES; the key source is logged once."""

    def test_untrusted_loopback_collapses_and_logs_once(self):
        site = Site(caps={"sockets_per_ip": 2})
        site.relay.trusted = (__import__("ipaddress").ip_network("10.9.9.9/32"),)
        try:
            a = WS(site, ip="198.51.100.1")
            b = WS(site, ip="198.51.100.2")
            c = WS(site, ip="198.51.100.3")         # all share the TCP peer's key
            self.assertEqual([a.status, b.status, c.status], [101, 101, 429])
            lines = [l for l in site.logs if l.startswith("rate key:")]
            self.assertEqual(len(lines), 1, lines)
            self.assertIn("IGNORED", lines[0])
            self.assertIn("1 configured", lines[0])
            for x in (a, b, c):
                x.close()
        finally:
            site.close()

    def test_module_setting_and_default(self):
        old = link_relay.TRUSTED_PROXIES
        try:
            link_relay.TRUSTED_PROXIES = ("192.0.2.0/24",)
            r = link_relay.Relay(autotick=False, log=lambda l: None)
            self.assertEqual(r.client_ip(FakeHandler("192.0.2.7", "10.0.0.1")), "10.0.0.1")
            self.assertEqual(r.client_ip(FakeHandler("127.0.0.1", "10.0.0.1")), "127.0.0.1")
        finally:
            link_relay.TRUSTED_PROXIES = old
        logs = []
        r = link_relay.Relay(autotick=False, log=logs.append)
        self.assertEqual(r.client_ip(FakeHandler("127.0.0.1", "10.0.0.1")), "10.0.0.1")
        self.assertEqual(r.client_ip(FakeHandler("127.0.0.1", "10.0.0.2")), "10.0.0.2")
        self.assertEqual(r.client_ip(FakeHandler("127.0.0.1")), "127.0.0.1")
        self.assertEqual(logs, [
            "rate key: CF-Connecting-IP from a trusted proxy (per-client caps work); "
            "trusted proxies: loopback (default)",
            "rate key: TCP peer (a trusted proxy sent no CF-Connecting-IP); "
            "trusted proxies: loopback (default)"])


class Races(Base):
    """Review F4: a socket the housekeeper is closing must not be revived by create/join."""

    def test_create_after_end_does_not_revive(self):
        c = self.ws()
        conn = conn_in(self.site.relay, "control")
        self.site.relay._end(conn, 4008)     # the housekeeper wins the race ...
        self.site.relay._create(conn)        # ... then the reader thread's create runs
        self.assertEqual(conn.state, "closing")
        self.assertEqual(self.site.relay.waiting, {})
        self.assertEqual(c.recv(), (8, struct.pack("!H", 4008)))   # no code frame before the close
        self.site.tick(2)                    # close_wait_s still applies
        self.assertTrue(c.eof())

    def test_join_after_end_does_not_consume_code(self):
        a = self.ws()
        code = a.create()
        b = self.ws()
        conn = conn_in(self.site.relay, "control")
        self.site.relay._end(conn, 4008)
        self.site.relay._join(conn, code)
        self.assertEqual(conn.state, "closing")
        self.assertIn(code, self.site.relay.waiting)
        self.assertEqual(b.recv(), (8, struct.pack("!H", 4008)))
        d = self.ws()
        d.join(code)                         # the real friend still gets in
        self.assertEqual(d.recv_json()["role"], "b")
        self.assertEqual(a.recv_json()["role"], "a")


class CloseFrames(Base):
    """Review F9: a client close must be empty, or a valid code plus UTF-8."""
    caps = {"creates_per_ip_min": 100}

    def test_close_payload_validated(self):
        for payload, want in ((b"", 1000), (struct.pack("!H", 1000) + b"bye", 1000),
                              (struct.pack("!H", 4321), 1000), (b"\x03", 1002),
                              (struct.pack("!H", 1005), 1002), (struct.pack("!H", 999), 1002),
                              (struct.pack("!H", 2000), 1002),
                              (struct.pack("!H", 1000) + b"\xff", 1002)):
            a, b, _ = self.pair()
            a.frame(8, payload)
            self.assertEqual(a.expect_close(), want, payload)
            self.assertEqual(b.expect_close(), 4000, payload)


class Liveness(Base):
    caps = NO_PINGS

    def test_pings_do_not_extend_code_ttl(self):
        a = self.ws()
        a.create()
        for t in range(11):
            self.site.tick(10)
            a.frame(9, b"k")
            self.assertEqual(a.recv(), (10, b"k"))
        self.site.tick(10)                   # 120 s since create
        self.assertEqual(a.expect_close(), 4001)

    def test_pongs_do_not_extend_idle(self):
        a, b, _ = self.pair()
        for t in range(8):
            self.site.tick(10)
            a.frame(10, b"")                 # unsolicited pongs from a; b sends data
            b.text("data")
            self.assertEqual(a.recv(), (1, b"data"))
        self.site.tick(10)                   # a: 90 s with no data frame
        self.assertEqual(a.expect_close(), 4005)
        self.assertEqual(b.expect_close(), 4005)


class LogSummary(Base):
    """Review F7: refusals are one line per reason per minute, with no code or IP."""
    caps = dict(NO_PINGS, joins_per_ip_min=1000)

    def test_refusals_aggregated(self):
        a = self.ws(ip="198.51.100.50")
        code = a.create()
        for i in range(5):
            c = self.ws(ip="198.51.100.%d" % (60 + i))
            c.join("nope-nope-nope")
            self.assertEqual(c.expect_close(), 4002)
        for i in range(3):
            self.assertEqual(self.ws(origin="https://evil.example").status, 403)
        self.assertTrue(wait_for(lambda: self.site.relay.snapshot()["sockets"] == 1))
        before = list(self.site.logs)
        self.assertFalse([l for l in before if "refused" in l or "no room" in l], before)
        self.site.tick(59)
        self.assertEqual(self.site.logs, before)          # not yet a minute
        self.site.tick(1)
        new = self.site.logs[len(before):]
        self.assertEqual(sorted(new), ["join refused x5 in 60s",
                                       "socket closed 4002 (no room) x5 in 60s",
                                       "upgrade refused 403 origin x3 in 60s"])
        self.site.tick(60)                   # nothing repeated (the code expiring is a room event)
        later = self.site.logs[len(before) + 3:]
        self.assertFalse([l for l in later if "refused" in l or "no room" in l], later)
        text = "\n".join(self.site.logs)
        for secret in [code, "198.51.100", "127.0.0.1", "nope"] + code.split("-"):
            self.assertNotIn(secret, text)

    def test_exception_path_logs_type_only(self):
        a, b, _ = self.pair(ip_a="198.51.100.70", ip_b="198.51.100.71")

        def boom(c, op, data):
            raise RuntimeError("SECRET 198.51.100.70 %s" % data.decode())
        self.site.relay._forward = boom
        a.text("PAYLOAD-XYZ")
        self.assertEqual(a.expect_close(), 1002)
        self.assertEqual(b.expect_close(), 4000)
        self.assertIn("socket error RuntimeError", self.site.logs)
        text = "\n".join(self.site.logs)
        for secret in ("SECRET", "198.51.100", "PAYLOAD"):
            self.assertNotIn(secret, text)


class Words(unittest.TestCase):
    def test_word_list(self):
        words = link_relay.load_words()
        self.assertEqual(len(words), 1024)
        s = set(words)
        for w in words:
            self.assertNotIn(w + "s", s)

    def test_normalize(self):
        r = link_relay.Relay(autotick=False)
        w = r.words
        self.assertEqual(r.normalize_code("%s %s_%s" % (w[0].upper(), w[1], w[2])),
                         "-".join(w[:3]))
        for bad in ("", "%s-%s" % (w[0], w[1]), "zz-zz-zz", "-".join(w[:4])):
            self.assertIsNone(r.normalize_code(bad))


def trickle_until_closed(port, limit=8.0, gap=0.3):
    """Send a never-ending request one byte every `gap` s (each read well inside the
    per-read timeout); return the seconds until the server closes the connection."""
    data = b"GET / HTTP/1.1\r\nHost: x\r\n" + b"X-Slow: y\r\n" * 1000
    s = socket.create_connection(("127.0.0.1", port))
    t0 = time.monotonic()
    try:
        for i in range(len(data)):
            if time.monotonic() - t0 > limit:
                return None
            try:
                s.send(data[i:i + 1])
            except OSError:
                return time.monotonic() - t0
            r, _, _ = select.select([s], [], [], gap)
            if r:
                try:
                    if not s.recv(4096):
                        return time.monotonic() - t0
                except OSError:
                    return time.monotonic() - t0
        return None
    finally:
        s.close()


class HeaderDeadline(unittest.TestCase):
    """Review F6: a total budget for one request's line + headers in --link mode,
    on top of the per-read timeout (handshake_s); 1.5 x handshake_s."""

    def setUp(self):
        self.site = Site(caps={"handshake_s": 1.0})          # per read 1.0 s, budget 1.5 s

    def tearDown(self):
        self.site.close()

    def test_trickled_headers_cut_at_total_budget(self):
        took = trickle_until_closed(self.site.port)
        self.assertIsNotNone(took, "a trickle every 0.3 s held the connection for 8 s")
        self.assertGreater(took, 1.3)
        self.assertLess(took, 2.5)

    def test_budget_is_per_request_on_keep_alive(self):
        conn = http.client.HTTPConnection("127.0.0.1", self.site.port, timeout=5)
        try:
            conn.request("GET", "/index.html")
            sock = conn.sock
            for i in range(3):             # 3 requests over ~1.8 s on one connection
                r = conn.getresponse()
                self.assertEqual(r.status, 200)
                r.read()
                time.sleep(0.6)
                if i < 2:
                    conn.request("GET", "/index.html")
            self.assertIs(conn.sock, sock)
        finally:
            conn.close()

    def test_upgraded_socket_not_cut(self):
        a, b, _ = pair(self.site)
        try:
            time.sleep(2.0)                # past the header budget, in wall time
            a.text("hi")
            self.assertEqual(b.recv(), (1, b"hi"))
        finally:
            a.close()
            b.close()

    def test_static_unchanged_without_link(self):
        site = Site(link=False)
        try:
            h = site.httpd.RequestHandlerClass
            self.assertIsNone(h.header_budget)
            self.assertIsNone(h.timeout)
        finally:
            site.close()


class ServerFlags(unittest.TestCase):
    """server.py main(): --link-trusted-proxy, the header budget and the access log, run
    as a real process on 127.0.0.1:0."""

    def start(self, *args):
        p = subprocess.Popen([sys.executable, os.path.join(WEB, "server.py"), "--rom", ROM,
                              "--port", "0"] + list(args),
                             stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        line = p.stdout.readline()
        self.assertIn("link relay at /link", line)
        p.port = int(line.split("http://127.0.0.1:")[1].split("/")[0])
        return p

    def stop(self, p):
        p.send_signal(signal.SIGINT)
        out, err = p.communicate(timeout=10)
        return err

    def upgrade_with_header(self, p):
        c = WS(p, origin="http://127.0.0.1", ip="198.51.100.9")
        self.assertEqual(c.status, 101)
        c.create()
        c.close()

    def test_trusted_proxy_flag(self):
        p = self.start("--link", "--link-origin", "http://127.0.0.1",
                       "--link-trusted-proxy", "10.0.0.0/8", "--link-trusted-proxy", "fd00::/8")
        self.upgrade_with_header(p)
        err = self.stop(p)
        self.assertIn("CF-Connecting-IP from an untrusted peer IGNORED", err)
        self.assertIn("trusted proxies: 2 configured", err)
        self.assertNotIn('"GET /link"', err)
        p = self.start("--link", "--link-origin", "http://127.0.0.1", "--link-trusted-proxy", "127.0.0.1")
        self.upgrade_with_header(p)
        err = self.stop(p)
        self.assertIn("rate key: CF-Connecting-IP from a trusted proxy (per-client caps work); "
                      "trusted proxies: 1 configured", err)
        p = self.start("--link", "--link-origin", "http://127.0.0.1")
        self.upgrade_with_header(p)
        err = self.stop(p)
        self.assertIn("rate key: CF-Connecting-IP from a trusted proxy (per-client caps work); "
                      "trusted proxies: loopback (default)", err)
        for secret in ("198.51.100", "127.0.0.1"):
            self.assertNotIn(secret, err)

    def test_header_budget_wired(self):
        p = self.start("--link", "--link-cap", "handshake_s=1")
        try:
            took = trickle_until_closed(p.port)
        finally:
            self.stop(p)
        self.assertIsNotNone(took)
        self.assertLess(took, 2.5)

    def test_bad_flags(self):
        for args in (["--link-trusted-proxy", "127.0.0.1"], ["--link", "--link-trusted-proxy", "not-an-ip"]):
            r = subprocess.run([sys.executable, os.path.join(WEB, "server.py"), "--rom", ROM,
                                "--port", "0"] + args, capture_output=True, text=True, timeout=10)
            self.assertEqual(r.returncode, 2, args)
            self.assertIn("--link-trusted-proxy", r.stderr)


if __name__ == "__main__":
    unittest.main()
