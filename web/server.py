#!/usr/bin/env python3
"""Minimal static server for the Kanto First web player.

Python 3 standard library only, no state, no configuration files.  It serves an
explicit allowlist of files (read into memory at startup) plus the ROM passed
with --rom.  Every other path is a 404: there is no directory listing and the
URL is never turned into a filesystem path, so path traversal has nothing to
traverse.

    python3 server.py --rom kanto-first.gbc

TLS and any public exposure are the host's job -- put this behind a reverse
proxy (nginx, Caddy, Cloudflare Tunnel) rather than binding it to 0.0.0.0.
"""

import argparse
import http.server
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))

# published path -> (file relative to this directory, content type, cacheable)
STATIC = {
    "/": ("index.html", "text/html; charset=utf-8", False),
    "/index.html": ("index.html", "text/html; charset=utf-8", False),
    "/app.js": ("app.js", "text/javascript; charset=utf-8", False),
    "/style.css": ("style.css", "text/css; charset=utf-8", False),
    "/manifest.webmanifest": ("manifest.webmanifest", "application/manifest+json", True),
    "/icon-192.png": ("icon-192.png", "image/png", True),
    "/icon-512.png": ("icon-512.png", "image/png", True),
    # binjgb, the emulator core (MIT).  binjgb.wasm MUST be served as
    # application/wasm or WebAssembly.instantiateStreaming refuses it.
    "/vendor/binjgb/binjgb.js": ("vendor/binjgb/binjgb.js", "text/javascript; charset=utf-8", True),
    "/vendor/binjgb/binjgb.wasm": ("vendor/binjgb/binjgb.wasm", "application/wasm", True),
    "/vendor/binjgb/LICENSE": ("vendor/binjgb/LICENSE", "text/plain; charset=utf-8", True),
    "/vendor/binjgb/LICENSE.gbstudio": ("vendor/binjgb/LICENSE.gbstudio", "text/plain; charset=utf-8", True),
    "/vendor/binjgb/VERSION.txt": ("vendor/binjgb/VERSION.txt", "text/plain; charset=utf-8", True),
}

ROM_PATH = "/kanto-first.gbc"


def load_files(rom_file):
    """Read the allowlist and the ROM into memory once, at startup."""
    served = {}
    for url, (rel, ctype, cacheable) in STATIC.items():
        path = os.path.join(HERE, rel)
        if not os.path.isfile(path):
            if url == "/":
                sys.exit("missing required file: %s" % path)
            continue
        with open(path, "rb") as handle:
            served[url] = (handle.read(), ctype, cacheable)
    if not os.path.isfile(rom_file):
        sys.exit("no ROM at %s -- pass --rom /path/to/kanto-first.gbc" % rom_file)
    with open(rom_file, "rb") as handle:
        served[ROM_PATH] = (handle.read(), "application/octet-stream", False)
    return served


class Handler(http.server.BaseHTTPRequestHandler):
    server_version = "KantoFirst"
    sys_version = ""
    protocol_version = "HTTP/1.1"
    files = {}

    def _respond(self, send_body):
        entry = self.files.get(self.path.split("?", 1)[0])
        if entry is None:
            body = b"404\n"
            self.send_response(404)
            self.send_header("Content-Type", "text/plain; charset=utf-8")
            self.send_header("Content-Length", str(len(body)))
            self.send_header("Cache-Control", "no-store")
            self.end_headers()
            if send_body:
                self.wfile.write(body)
            return
        body, ctype, cacheable = entry
        self.send_response(200)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "max-age=3600" if cacheable else "no-store")
        self.send_header("X-Content-Type-Options", "nosniff")
        self.end_headers()
        if send_body:
            self.wfile.write(body)

    def do_GET(self):
        self._respond(True)

    def do_HEAD(self):
        self._respond(False)

    def log_message(self, fmt, *args):  # one line per request, on stderr
        sys.stderr.write("%s %s\n" % (self.address_string(), fmt % args))


def main():
    parser = argparse.ArgumentParser(description="Serve the Kanto First web player.")
    parser.add_argument("--rom", default="kanto-first.gbc", help="path to the .gbc ROM (default: ./kanto-first.gbc)")
    parser.add_argument("--host", default="127.0.0.1", help="bind address (default: 127.0.0.1)")
    parser.add_argument("--port", type=int, default=8080, help="port (default: 8080)")
    args = parser.parse_args()

    Handler.files = load_files(args.rom)
    rom_bytes = len(Handler.files[ROM_PATH][0])
    server = http.server.ThreadingHTTPServer((args.host, args.port), Handler)
    print("Kanto First on http://%s:%d/  (%d files, ROM %d bytes from %s)"
          % (args.host, args.port, len(Handler.files) - 1, rom_bytes, args.rom), flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()


if __name__ == "__main__":
    main()
