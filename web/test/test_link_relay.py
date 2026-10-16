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
import socket
import struct
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
        if quiet:
            attrs["log_link"] = lambda h: None
        if link:
            self.relay = link_relay.Relay(origins, caps, clock=self.clock,
                                          log=self.logs.append, autotick=False)
            attrs.update(link=self.relay, timeout=self.relay.caps["handshake_s"])
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
        a.frame(2, b"\0" * 4096)
        self.assertEqual(b.recv(), (2, b"\0" * 4096))
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
        for size in (0, 1, 125, 126, 4095, 4096):
            blob = os.urandom(size)
            a.frame(2, blob)
            self.assertEqual(b.recv(), (2, blob))
            b.frame(2, blob)
            self.assertEqual(a.recv(), (2, blob))
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
        # CF-Connecting-IP only from a loopback peer (the tunnel); IPv6 keyed by /64
        class H(object):
            pass
        h = H()
        h.client_address = ("192.0.2.1", 1)
        h.headers = http.client.parse_headers(io.BytesIO(b"CF-Connecting-IP: 10.0.0.1\r\n\r\n"))
        self.assertEqual(self.site.relay.client_ip(h), "192.0.2.1")
        h.client_address = ("127.0.0.1", 1)
        self.assertEqual(self.site.relay.client_ip(h), "10.0.0.1")
        h.headers = http.client.parse_headers(io.BytesIO(b"CF-Connecting-IP: 2001:db8::1:2\r\n\r\n"))
        self.assertEqual(self.site.relay.client_ip(h), "2001:db8::/64")
        h.headers = http.client.parse_headers(io.BytesIO(b"CF-Connecting-IP: junk\r\n\r\n"))
        self.assertEqual(self.site.relay.client_ip(h), "127.0.0.1")

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
    caps = {"write_s": 0.5, "frames_per_s": 10 ** 6, "frame_burst": 10 ** 6}

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
                a.frame(2, b"\0" * 4096)
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
                a.frame(2, b"ping")
                b.frame(1, "pong")
            for a, b, _ in rooms:
                self.assertEqual(b.recv(), (2, b"ping"))
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
        text = "\n".join(self.site.logs) + "\n" + err.getvalue()
        for secret in [code, "SECRET", "198.51.100", "127.0.0.1"] + code.split("-"):
            self.assertNotIn(secret, text)
        for event in ('- "GET /link"', "room created", "room paired", "join refused", "room closed 1000",
                      "upgrade refused 403 origin"):
            self.assertIn(event, text)
        self.assertEqual(d.status, 403)


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


if __name__ == "__main__":
    unittest.main()
