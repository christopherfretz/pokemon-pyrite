// LK1d: the e2e's network layer when it runs through the real relay
// (link_e2e.mjs --relay).  Two link_transport.js connections talk to a real
// `server.py --link` through an in-process fault proxy, one per side:
//
//   stand-in A -> wrapper -> conn A (WebSocket) -> proxy A -> relay -> proxy B -> conn B -> wrapper -> stand-in B
//
// The e2e runs in virtual time (frames x 16.74 ms), so the proxy holds every
// data and close frame the relay sends and releases it RTT/2 of VIRTUAL time
// after it arrived; pings and pongs pass straight through.  Before each frame
// the e2e awaits quiesce(), which waits (in wall time) until everything that
// was sent has reached the far proxy and everything released has reached the
// far WebSocket.  That makes a run through the real relay as deterministic as
// the in-process fake, and every byte still crosses the real relay.
//
// The fault hooks keep the fake relay's contract (link_e2e.mjs class Relay):
//   hook(text, dir, net) at send: undefined = deliver, null = drop, string = replace;
//   close(): no new message from either side; what is already in flight still
//   lands; then side A's TCP connection to the relay is cut (the relay closes
//   B with 4000) and A's socket is dropped RTT/2 later, so both sides hear
//   onclose after one one-way delay.
import { spawn } from 'node:child_process';
import net from 'node:net';
import path from 'node:path';
import { createRequire } from 'node:module';

const require = createRequire(import.meta.url);
const Transport = require('../link_transport.js');
const ORIGIN = 'http://127.0.0.1';
const DIRS = ['a>b', 'b>a'];

/* Spawn `server.py --link` on an ephemeral loopback port. */
export async function startRelayServer({ repoDir, python, caps = [] }) {
  const args = [path.join(repoDir, 'web/server.py'), '--rom', path.join(repoDir, 'pokecrystal.gbc'),
    '--host', '127.0.0.1', '--port', '0', '--link', '--link-origin', ORIGIN];
  for (const c of caps) args.push('--link-cap', c);
  const proc = spawn(python, args, { cwd: path.join(repoDir, 'web'), stdio: ['ignore', 'pipe', 'pipe'] });
  let stderr = '';
  proc.stderr.on('data', (d) => { stderr += d; });
  const port = await new Promise((resolve, reject) => {
    let out = '';
    const t = setTimeout(() => reject(new Error(`server.py did not start\n${stderr}`)), 15000);
    proc.stdout.on('data', (d) => {
      out += d;
      const m = out.match(/http:\/\/127\.0\.0\.1:(\d+)\//);
      if (m) { clearTimeout(t); resolve(Number(m[1])); }
    });
    proc.on('exit', (code) => { clearTimeout(t); reject(new Error(`server.py exited ${code}\n${stderr}`)); });
  });
  return { port, proc, stderr: () => stderr, stop: () => new Promise((r) => { proc.once('exit', r); proc.kill('SIGINT'); }) };
}

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const turn = () => new Promise((r) => setImmediate(r));

export class Net {
  constructor({ relayPort, clock, rtt, pair = 0, realtime = false }) {
    this.relayPort = relayPort; this.clock = clock; this.rtt = rtt; this.pair = pair;
    this.realtime = realtime; this.wall0 = null;    // --realtime: virtual time never runs ahead of wall time
    this.hook = null; this.closed = false; this.dropped = 0; this.oversize = 0;
    this.sent = { 'a>b': 0, 'b>a': 0 };     // like the fake: counted at send, after the hook
    this.arrived = { 'a>b': 0, 'b>a': 0 };  // data frames the relay delivered to the far proxy
    this.gated = false; this.cutPending = false; this.cutDone = false; this.closePending = null;
    this.seq = 0; this.lastYield = Date.now();
    this.sides = [0, 1].map((i) => ({
      i, server: null, client: null, up: null, queue: [], buf: Buffer.alloc(0), headDone: false,
      delivered: 0, upClosed: false, upEnded: false, terminalWritten: false, cut: false, conn: null, wrapper: null,
    }));
  }

  // ------------------------------------------------------------ proxies --
  async listen() {
    for (const s of this.sides) {
      s.server = net.createServer((client) => this.accept(s, client));
      await new Promise((r) => s.server.listen(0, '127.0.0.1', r));
    }
  }
  accept(s, client) {
    s.client = client;
    client.setNoDelay(true);
    const up = s.up = net.connect(this.relayPort, '127.0.0.1');
    up.setNoDelay(true);
    client.on('data', (d) => { if (!up.destroyed) up.write(d); });
    client.on('end', () => { if (!up.destroyed) up.end(); });
    client.on('error', () => {});
    client.on('close', () => { if (!up.destroyed) up.destroy(); });
    up.on('data', (d) => this.fromRelay(s, d));
    const ended = () => {
      if (s.upEnded) return;
      s.upEnded = true;
      this.enqueue(s, { kind: s.cut ? 'none' : 'end' }, true);
    };
    up.on('end', ended);
    up.on('close', ended);
    up.on('error', () => {});
  }
  /* Server -> client bytes: pass the 101 head through, then frame by frame. */
  fromRelay(s, d) {
    s.buf = Buffer.concat([s.buf, d]);
    if (!s.headDone) {
      const k = s.buf.indexOf('\r\n\r\n');
      if (k < 0) return;
      s.client.write(s.buf.subarray(0, k + 4));
      s.buf = s.buf.subarray(k + 4);
      s.headDone = true;
    }
    for (;;) {
      if (s.buf.length < 2) return;
      let n = s.buf[1] & 0x7f, h = 2;
      if (n === 126) { if (s.buf.length < 4) return; n = s.buf.readUInt16BE(2); h = 4; }
      else if (n === 127) { if (s.buf.length < 10) return; n = Number(s.buf.readBigUInt64BE(2)); h = 10; }
      if (s.buf.length < h + n) return;
      const frame = s.buf.subarray(0, h + n);
      s.buf = s.buf.subarray(h + n);
      const op = frame[0] & 0x0f;
      if (op === 9 || op === 10 || !this.gated) { s.client.write(frame); continue; }
      if (op === 8) { s.upClosed = true; this.enqueue(s, { kind: 'close', frame }); continue; }
      this.arrived[s.i === 1 ? 'a>b' : 'b>a']++;
      this.enqueue(s, { kind: 'data', frame });
    }
  }
  enqueue(s, item, afterLast = false) {
    const last = s.queue.length ? s.queue[s.queue.length - 1].at : -Infinity;
    item.at = afterLast ? Math.max(last, this.clock()) : this.clock() + this.rtt / 2;
    item.n = this.seq++;
    s.queue.push(item);
    s.queue.sort((x, y) => x.at - y.at || x.n - y.n);
  }
  /* Release every frame that is due (called once per emulated frame). */
  tick() {
    const now = this.clock();
    for (const s of this.sides) {
      while (s.queue.length && s.queue[0].at <= now) {
        const m = s.queue.shift();
        if (!s.client || s.client.destroyed) continue;
        if (m.kind === 'data') { s.client.write(m.frame); s.delivered++; }
        else if (m.kind === 'close') { s.client.write(m.frame); s.terminalWritten = true; }
        else if (m.kind === 'end') { s.client.end(); s.terminalWritten = true; }
        else if (m.kind === 'destroy') { s.client.destroy(); s.terminalWritten = true; }
      }
    }
  }

  // ------------------------------------------------------------ pairing --
  connect(i, opts = {}) {
    const ip = `10.${(this.pair >> 8) & 255}.${this.pair & 255}.${i + 1}`;
    return Transport.connect(`ws://127.0.0.1:${this.sides[i].server.address().port}/link`, {
      WebSocket, wsOptions: { headers: { Origin: ORIGIN, 'CF-Connecting-IP': ip } }, ...opts,
    });
  }
  /* Create on A, join on B, wait for both "paired"; then start gating. */
  async pairUp() {
    await this.listen();
    const a = this.connect(0);
    const code = await new Promise((resolve, reject) => {
      a.onrefused = (c, why) => reject(new Error(`create refused ${c} ${why}`));
      a.create((c) => resolve(c));
    });
    const b = this.connect(1);
    const paired = (conn) => new Promise((resolve, reject) => {
      conn.onpaired = (role) => resolve(role);
      conn.onrefused = (c, why) => reject(new Error(`refused ${c} ${why}`));
    });
    const pa = paired(a), pb = paired(b);
    b.join(code.toUpperCase());
    const roles = [await pa, await pb];
    if (roles.join() !== 'a,b') throw new Error(`roles ${roles}`);
    this.sides[0].conn = a; this.sides[1].conn = b;
    this.gated = true;
    this.code = code;
    return code;
  }
  /* The link.js-facing transport for side i: hooks and counts like the fake. */
  transport(i) {
    const dir = DIRS[i], s = this.sides[i], conn = s.conn;
    const t = {
      onmessage: null, onclose: null,
      send: (text) => {
        if (this.closed) return;
        let out = text;
        if (this.hook) { const r = this.hook(text, dir, this); if (r === null) { this.dropped++; return; } if (r !== undefined) out = r; }
        if (this.closed) return;
        if (conn.send(out)) this.sent[dir]++;
        else if (conn.state === 'paired') this.oversize++;     // over the 4 KiB frame cap
      },
      close: () => { if (!this.closed) { this.closed = true; this.closePending = i; } },
    };
    conn.onmessage = (text) => { if (t.onmessage) t.onmessage(text); };
    conn.onclose = () => { if (t.onclose) t.onclose(); };
    s.wrapper = t;
    return t;
  }
  /* The fake's relay.close(): a network cut. */
  close() {
    if (this.closed) return;
    this.closed = true;
    this.cutPending = true;
  }

  // ------------------------------------------------------------ syncing --
  closing() {
    return this.cutDone || this.closePending !== null || this.closeStarted
      || this.sides.some((s) => s.upClosed || s.upEnded || s.conn.state === 'closed');
  }
  busy() {
    const [A, B] = this.sides;
    const settled = this.sent['a>b'] === this.arrived['a>b'] && this.sent['b>a'] === this.arrived['b>a'];
    if ((this.cutPending || this.closePending !== null) && settled) {
      if (this.cutPending) {
        // in flight before the cut has all reached the far proxies: now cut A's TCP to the relay
        this.cutPending = false; this.cutDone = true;
        A.cut = true; A.up.destroy();
        A.queue.push({ kind: 'destroy', at: this.clock() + this.rtt / 2, n: this.seq++ });
        A.queue.sort((x, y) => x.at - y.at || x.n - y.n);
      } else {
        const i = this.closePending; this.closePending = null; this.closeStarted = true;
        this.sides[i].conn.close();
      }
    }
    if (this.cutPending || this.closePending !== null) return 'pending close/cut';
    if (!this.closing() && !settled) return `in flight ${JSON.stringify(this.sent)} vs ${JSON.stringify(this.arrived)}`;
    for (const s of this.sides) {
      if (this.closing() && !(s.upClosed || s.upEnded || s.cut)) return `side ${s.i}: waiting for the relay's close`;
      if (s.conn.state !== 'closed' && s.delivered !== s.conn.stats.recv) return `side ${s.i}: ${s.delivered} released, ${s.conn.stats.recv} received`;
      if (s.terminalWritten && s.conn.state !== 'closed') return `side ${s.i}: close released, WebSocket not closed yet`;
    }
    return null;
  }
  /* Called before each emulated frame. */
  async quiesce(timeoutMs = 10000) {
    const t0 = Date.now();
    for (;;) {
      this.tick();
      const why = this.busy();
      if (!why) break;
      if (Date.now() - t0 > timeoutMs) throw new Error(`relay net stuck (${why}) at virtual ${this.clock().toFixed(0)} ms`);
      await turn();
    }
    if (this.realtime) {
      if (this.wall0 === null) this.wall0 = Date.now() - this.clock();
      const ahead = this.clock() - (Date.now() - this.wall0);
      if (ahead > 1) await sleep(ahead);
    }
    if (Date.now() - this.lastYield > 50) { this.lastYield = Date.now(); await turn(); }   // let pings through
  }
  async shutdown() {
    for (const s of this.sides) {
      if (s.conn && s.conn.state !== 'closed') s.conn.close();
    }
    const t0 = Date.now();
    while (this.sides.some((s) => s.conn && s.conn.state !== 'closed') && Date.now() - t0 < 3000) { this.tick(); this.forceRelease(); await sleep(5); }
    for (const s of this.sides) {
      if (s.client) s.client.destroy();
      if (s.up) s.up.destroy();
      await new Promise((r) => s.server.close(r));
    }
  }
  forceRelease() { for (const s of this.sides) for (const m of s.queue) m.at = -Infinity; }
}
