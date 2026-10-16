/* Pyrite link: the protocol-aware stand-in for a Game Link Cable
   (docs/LK1-LINK.md section 3, as corrected by LK1b; built in LK1c).

   Each phone runs one stand-in next to its own emulator.  The two stand-ins
   never move raw serial bytes over the network: they exchange a handful of
   JSON messages (hello, desk, rcpt, sync, blocks, act, ...) and each one
   feeds its local game, through the binjgb LinkPort, exactly the bytes a real
   partner on a cable would have sent at that point.  Timing-critical byte
   streams (the 1,061-byte bulk exchange) are therefore replayed locally at
   the paced external clock, and the network only has to carry intent.

   create(opts) -> stand-in
     opts.core       { port, read(addr, bank) }: port is the LinkPort surface
                     (enable, idle, push, pending, clear, ext, drain); read
                     returns one byte of WRAM/HRAM/IE (bank = SVBK bank for
                     $D000-$DFFF, ignored elsewhere).
     opts.transport  { send(text), close() }; the stand-in sets
                     transport.onmessage(text) and transport.onclose().
     opts.tables     tables.json's "link" section (addresses, layouts,
                     validator tables).  No address is hard-coded here.
     opts.ui         { status(s), peerName(name), accept(name) -> bool |
                     Promise<bool>, error(reason) } (all optional).
     opts.role       'a' (the code creator: master, answers the $01 probe
                     with $02) or 'b' (slave).
     opts.rom        sha256 of the running ROM (hello refuses a mismatch).
     opts.build, opts.coreRev, opts.name   shown to the peer.
     opts.now        clock in ms (default Date.now; the tests pass a
                     frame-derived virtual clock).
     opts.onBeforeLink   called once, right before the port is enabled
                     (app.js snapshots the game there).  Also settable later.
   stand-in: { onFrame(), isLinked(), disconnect(), state(), onBeforeLink }
     onFrame() must be called after every emulated frame.

   No DOM.  Loads as CommonJS in Node and as window.PyriteLink in a page. */
(function (root, factory) {
  'use strict';
  if (typeof module === 'object' && module.exports) module.exports = factory(require('./link_validate.js'));
  else root.PyriteLink = factory(root.PyriteLinkValidate);
}(typeof self !== 'undefined' ? self : this, function (V) {
  'use strict';

  const PROTOCOL = 1;
  const MAX_MESSAGE = 4096;
  const FRAME_MS = 70224 / 4194304 * 1000;        // 16.7427 ms
  const PING_MS = 15000, PEER_GONE_MS = 45000, PAUSE_GONE_MS = 60000;
  const DESK_RESEND_FRAMES = 30;
  const DESK_FRESH_MS = 1500;                     // peer desk must be this recent
  const DESK_PEER_MARGIN_MS = 1500;               // ...with this much of ITS row-2 budget left
  const DESK_OWN_MARGIN_MS = 1000;                // ...and this much of ours
  const DESK_GONE_FRAMES = 10;                    // no $01 probe for this long = row 2 is over
  const EXT_GAP = 6144, EXT_HOLD = 70224;         // bulk pacing / one idle byte per frame
  const TAIL_FRAMES = 10;
  const MAX_ACT_QUEUE = 8;
  const MAX_HELD = 64;                            // peer game messages held while our Accept is up
  const BYE_REASONS = /^(user|rom-mismatch|role|invalid-blocks:[a-z0-9_.[\]$ -]{1,60}|invalid-act|timeout|internal|peer-gone)$/;
  const ABORT_STAGES = new Set(['desk', 'connected', 'rcpt', 'sync', 'blocks', 'menu']);

  // ---------------------------------------------------------------- base64 ---
  function b64enc(u8) {
    let s = '';
    for (let i = 0; i < u8.length; i++) s += String.fromCharCode(u8[i]);
    return btoa(s);
  }
  function b64dec(s) {
    if (typeof s !== 'string' || s.length > 2048 || !/^[A-Za-z0-9+/]*={0,2}$/.test(s) || s.length % 4) return null;
    let bin;
    try { bin = atob(s); } catch (e) { return null; }
    const out = new Uint8Array(bin.length);
    for (let i = 0; i < bin.length; i++) out[i] = bin.charCodeAt(i);
    return out;
  }

  // ------------------------------------------------------------ messages ---
  const isInt = (v, lo, hi) => Number.isInteger(v) && v >= lo && v <= hi;
  const FIELD = {
    lk: (v) => isInt(v, 0, 1000),
    rom: (v) => typeof v === 'string' && /^[0-9a-f]{64}$/.test(v),
    build: (v) => typeof v === 'string' && /^[\x20-\x7e]{0,40}$/.test(v),
    core: (v) => typeof v === 'string' && /^[\x20-\x7e]{0,64}$/.test(v),
    name: (v) => typeof v === 'string' && v.length <= 16 && !/[\x00-\x1f\x7f]/.test(v),
    role: (v) => v === 'a' || v === 'b',
    left: (v) => isInt(v, 0, 60000),
    room: (v) => v === 1 || v === 2,
    gen: (v) => isInt(v, 0, 0xffff),
    seq: (v) => isInt(v, 0, 0xffff),
    v: (v) => isInt(v, 0, 15),
    mode: (v) => v === 2 || v === 3,
    t: (v) => typeof v === 'number' && Number.isFinite(v),
    stage: (v) => ABORT_STAGES.has(v),
    reason: (v) => typeof v === 'string' && BYE_REASONS.test(v),
    rn: (v) => typeof v === 'string', party: (v) => typeof v === 'string',
    patch: (v) => typeof v === 'string', mail: (v) => typeof v === 'string',
  };
  const SCHEMA = {
    hello: ['lk', 'rom', 'build', 'core', 'name', 'role'],
    desk: ['left'], rcpt: [], sync: ['room'],
    blocks: ['gen', 'rn', 'party', 'patch', 'mail'],
    act: ['gen', 'seq', 'v', 'mode'],
    ping: ['t'], pong: ['t'], pause: [], resume: [],
    abort: ['stage'], bye: ['reason'],
  };
  const BLOCK_SIZES = { rn: [17], party: [450], patch: [200], mail: [390, 0] };

  /* Strict parse of one peer frame: {ok:true, msg} | {ok:false, reason}.
     blocks messages come back with Uint8Array fields. */
  function parseMessage(text) {
    if (typeof text !== 'string') return { ok: false, reason: 'not text' };
    if (text.length > MAX_MESSAGE) return { ok: false, reason: 'too long' };
    let m;
    try { m = JSON.parse(text); } catch (e) { return { ok: false, reason: 'bad json' }; }
    if (!m || typeof m !== 'object' || Array.isArray(m)) return { ok: false, reason: 'not an object' };
    const keys = SCHEMA[m.type];
    if (!keys || !Object.prototype.hasOwnProperty.call(SCHEMA, m.type)) return { ok: false, reason: `unknown type ${String(m.type).slice(0, 20)}` };
    const have = Object.keys(m).filter((k) => k !== 'type');
    if (have.length !== keys.length || !keys.every((k) => Object.prototype.hasOwnProperty.call(m, k))) {
      return { ok: false, reason: `${m.type}: fields ${have.join(',')}` };
    }
    for (const k of keys) if (!FIELD[k](m[k])) return { ok: false, reason: `${m.type}.${k}` };
    if (m.type === 'blocks') {
      const out = { type: 'blocks', gen: m.gen };
      for (const k of ['rn', 'party', 'patch', 'mail']) {
        const b = b64dec(m[k]);
        if (!b || !BLOCK_SIZES[k].includes(b.length)) return { ok: false, reason: `blocks.${k} size` };
        out[k] = b;
      }
      return { ok: true, msg: out };
    }
    return { ok: true, msg: m };
  }
  function encodeMessage(m) {
    if (m.type !== 'blocks') return JSON.stringify(m);
    return JSON.stringify({ type: 'blocks', gen: m.gen, rn: b64enc(m.rn), party: b64enc(m.party), patch: b64enc(m.patch), mail: b64enc(m.mail) });
  }

  /* The bytes a real partner's Serial_ExchangeBytes/ExchangeBytes would put
     on the wire, built from the partner's own (sender-side) blocks: each
     preamble block plus one $FE (the receiver keeps everything after its
     first $FD for `len` bytes), then one discarded byte and the mail block
     (ExchangeBytes has no preamble skip).  LK1-LINK.md 3.3. */
  function buildFeed(blocks, mode, L) {
    const S = L ? L.serial : { LINK_TRADECENTER: 2 };
    const parts = [blocks.rn, [0xfe], blocks.party, [0xfe], blocks.patch, [0xfe]];
    if (mode === S.LINK_TRADECENTER) parts.push([0xfe], blocks.mail);
    const n = parts.reduce((a, p) => a + p.length, 0);
    const out = new Uint8Array(n);
    let o = 0;
    for (const p of parts) { out.set(p, o); o += p.length; }
    return out;
  }

  // ---------------------------------------------------------- stand-in ---
  function create(opts) {
    const L = opts.tables;
    const port = opts.core.port, rd = opts.core.read;
    const transport = opts.transport;
    const ui = Object.assign({ status() {}, peerName() {}, accept() { return true; }, error() {} }, opts.ui || {});
    const role = opts.role;
    const now = opts.now || (() => Date.now());
    const S = L.serial, B = L.battle;
    const W = (name) => L.wram[name];
    const HI = { 0: S.SERIAL_TIMECAPSULE, 1: S.SERIAL_TIMECAPSULE, 2: S.SERIAL_TRADECENTER, 3: S.SERIAL_BATTLE };
    const ROLE_BYTE = role === 'a' ? S.USING_INTERNAL_CLOCK : S.USING_EXTERNAL_CLOCK;   // what we shift into the probe
    const WANT_STATUS = role === 'a' ? S.USING_INTERNAL_CLOCK : S.USING_EXTERNAL_CLOCK;

    const self = {
      onBeforeLink: opts.onBeforeLink || null,
      onFrame, isLinked, disconnect, state: () => snapshot(),
    };
    // session
    let session = 'hello';                      // hello | accepting | linked | draining | closed
    let drainReason = null;
    let frame = 0;
    let lastRx = now(), lastPing = now();
    let peerPaused = null;
    const log = [];
    const stats = { sent: {}, recv: {}, bulk: [], fifoLeft: [], feeds: 0, visits: 0 };
    let peerHello = null;
    // A peer that accepted first can reach the desk (desk, abort, ...) while our
    // Accept is still up: hold those messages, with their arrival time, and
    // replay them at link-up. Bounded; the oldest is dropped when full.
    let held = [];
    let rxAt = null;                            // arrival time of the message being replayed
    // peer stream (independent of our own visit)
    let peer = freshPeer();
    // our visit
    let v = freshVisit();
    let idleNow = -1;

    function freshPeer() {
      return { stage: 'none', desk: null, rcpt: false, sync: null, gen: -1, seq: -1, blocks: null, acts: [] };
    }
    function freshVisit() {
      return {
        stage: 'outside', left: 0, deskFrame: -1, lastProbe: -1, deskSent: -1,
        feeder: null, override: null, gen: 0, seq: 0, afterBulk: false, phase: null,
        pendingAct: null, peerCount: 0, feed: null, peerAborted: false, localAborted: false,
        blocksSent: false, blocksOk: null, bulkFrame: -1, enterFrame: frame, sawProbe: false,
      };
    }
    const ev = (e, extra) => { const x = Object.assign({ f: frame, e }, extra || {}); log.push(x); if (log.length > 2000) log.shift(); };

    function send(m) {
      if (session === 'closed' && m.type !== 'bye') return;
      stats.sent[m.type] = (stats.sent[m.type] || 0) + 1;
      try { transport.send(encodeMessage(m)); } catch (e) { /* transport gone: liveness handles it */ }
    }
    function setIdle(b) { if (b !== idleNow) { port.idle(b); idleNow = b; } }
    function readBank(name, n) {
      const [bank, addr] = W(name);
      const out = new Uint8Array(n);
      for (let i = 0; i < n; i++) out[i] = rd(addr + i, bank);
      return out;
    }
    const r1 = (name) => { const [bank, addr] = W(name); return rd(addr, bank); };

    // ---------------------------------------------------------- incoming ---
    transport.onmessage = (text) => {
      if (session === 'closed') return;
      lastRx = now();
      const p = parseMessage(typeof text === 'string' ? text : String(text));
      if (!p.ok) { ev('bad-message', { reason: p.reason }); return fail('internal', `bad message: ${p.reason}`); }
      const m = p.msg;
      stats.recv[m.type] = (stats.recv[m.type] || 0) + 1;
      handle(m);
    };
    transport.onclose = () => {
      if (session === 'closed') return;
      ev('transport-closed');
      startDrain('peer-gone');
    };

    function handle(m) {
      if (m.type === 'bye') { ev('bye-in', { reason: m.reason }); ui.error(`peer: ${m.reason}`); return startDrain(`peer:${m.reason}`); }
      if (m.type === 'ping') return send({ type: 'pong', t: m.t });
      if (m.type === 'pong') return;
      if (m.type === 'pause') { peerPaused = now(); return; }
      if (m.type === 'resume') { peerPaused = null; return; }
      if (m.type === 'hello') {
        if (peerHello) return fail('internal', 'second hello');
        peerHello = m;
        if (m.lk !== PROTOCOL || m.rom !== opts.rom) return refuse('rom-mismatch');
        if (m.role === role) return refuse('role');
        ui.peerName(m.name);
        session = 'accepting';
        let a;
        try { a = ui.accept(m.name); } catch (e) { a = false; }
        const decide = (yes) => {
          if (session !== 'accepting') return;
          if (!yes) { send({ type: 'bye', reason: 'user' }); return closeNow('declined'); }
          linkUp();
        };
        if (a && typeof a.then === 'function') a.then(decide, () => decide(false));
        else decide(!!a);                           // synchronous answer: link up on this turn
        return;
      }
      if (session === 'accepting') {                // the peer is linked, we are not yet: hold it
        const last = held[held.length - 1];
        // consecutive desks: only the newest matters (it carries the budget left)
        if (m.type === 'desk' && last && last.m.type === 'desk') held.pop();
        if (held.length >= MAX_HELD) {
          // drop the oldest, then up to the next desk, so the replay starts at a visit
          do { ev('held-dropped', { type: held.shift().m.type }); } while (held.length && held[0].m.type !== 'desk');
        }
        held.push({ m, t: now() });
        ev('held', { type: m.type, n: held.length });
        return;
      }
      if (session !== 'linked' && session !== 'draining') return fail('internal', `${m.type} before hello`);
      if (session === 'draining') return;           // nothing the peer says matters any more
      switch (m.type) {
        case 'desk':
          if (peer.stage !== 'none' && peer.stage !== 'desk' && peer.stage !== 'ignoring') {
            // the peer started a new visit: its old one is over
            ev('peer-new-visit', { from: peer.stage });
            if (v.stage !== 'outside' && v.stage !== 'desk') v.peerAborted = true;
          }
          if (peer.stage !== 'desk') peer = freshPeer();
          peer.stage = 'desk';
          peer.desk = { left: m.left, at: rxAt === null ? now() : rxAt };
          return;
        case 'abort':
          if (peer.stage === 'ignoring') return;
          if (peer.stage === 'none') return fail('internal', 'abort outside a visit');
          ev('peer-abort', { stage: m.stage });
          peer = freshPeer();
          peer.stage = 'ignoring';
          if (v.stage !== 'outside') v.peerAborted = true;
          return;
      }
      if (peer.stage === 'ignoring') return;          // in flight before our abort reached the peer
      switch (m.type) {
        case 'rcpt':
          if (peer.stage !== 'desk') return fail('internal', `rcpt after ${peer.stage}`);
          peer.stage = 'rcpt'; peer.rcpt = true; return;
        case 'sync':
          if (peer.stage !== 'rcpt') return fail('internal', `sync after ${peer.stage}`);
          peer.stage = 'sync'; peer.sync = m.room; return;
        case 'blocks':
          if (!['sync', 'blocks', 'act'].includes(peer.stage)) return fail('internal', `blocks after ${peer.stage}`);
          if (m.gen !== peer.gen + 1) return fail('internal', `blocks gen ${m.gen} after ${peer.gen}`);
          if (peer.blocks) return fail('internal', 'blocks queue full');
          // acts of the previous gen still queued stay queued: they pair first
          peer.stage = 'blocks'; peer.gen = m.gen; peer.seq = -1; peer.blocks = m;
          return;
        case 'act':
          if (peer.stage !== 'blocks' && peer.stage !== 'act') return fail('internal', `act after ${peer.stage}`);
          if (m.gen !== peer.gen || m.seq !== peer.seq + 1) return fail('internal', `act ${m.gen}/${m.seq} after ${peer.gen}/${peer.seq}`);
          if (peer.acts.length >= MAX_ACT_QUEUE) return fail('internal', 'act queue full');
          peer.stage = 'act'; peer.seq = m.seq; peer.acts.push(m);
          return;
        default:
          return fail('internal', `unexpected ${m.type}`);
      }
    }

    function refuse(reason) {
      ev('refuse', { reason });
      send({ type: 'bye', reason });
      ui.error(reason);
      closeNow(reason);
    }
    function fail(reason, detail) {
      ev('fail', { reason, detail });
      if (session === 'hello' || session === 'accepting') return refuse(reason);
      send({ type: 'bye', reason });
      ui.error(`${reason}${detail ? ': ' + detail : ''}`);
      startDrain(reason);
    }
    function closeNow(why) {
      held = [];
      if (session === 'linked' || session === 'draining') { try { port.enable(false); } catch (e) { /* */ } }
      session = 'closed';
      ev('closed', { why });
      ui.status('closed');
      try { transport.close(); } catch (e) { /* */ }
    }
    function linkUp() {
      try { if (self.onBeforeLink) self.onBeforeLink(); } catch (e) { /* the hook must not stop the link */ }
      port.enable(true);
      port.ext(0, EXT_GAP, EXT_HOLD);
      port.clear();
      port.drain(512);
      idleNow = -1;
      setIdle(0xff);
      session = 'linked';
      lastRx = now();
      ev('linked', { peer: peerHello.name });
      ui.status('linked');
      // replay what the peer sent while our Accept was up, in order, at its arrival time
      const q = held;
      held = [];
      if (q.length) ev('held-replay', { n: q.length });
      for (const h of q) {
        if (session !== 'linked') break;
        rxAt = h.t;
        try { handle(h.m); } finally { rxAt = null; }
      }
    }
    /* Graceful end: keep answering the local game with whatever leads it out
       (section 3.5), then disable the port once it is back outside. */
    function startDrain(reason) {
      if (session === 'closed' || session === 'draining') return;
      if (session !== 'linked') return closeNow(reason);
      session = 'draining';
      drainReason = reason;
      ev('drain', { reason, stage: v.stage });
      ui.status(`draining:${reason}`);
      try { transport.close(); } catch (e) { /* a bye, if any, went out first */ }
      // not linked to the peer in-game yet: nothing to lead out, close at once
      if (v.stage === 'outside' || (v.stage === 'desk' && !connectedStatus(rd(L.hram.hSerialConnectionStatus)))) closeNow(reason);
    }
    function disconnect() {
      if (session === 'closed') return;
      send({ type: 'bye', reason: 'user' });
      if (session === 'linked') startDrain('user');
      else closeNow('user');
      try { transport.close(); } catch (e) { /* */ }
    }
    function isLinked() { return session === 'linked'; }
    const connectedStatus = (s) => s === S.USING_INTERNAL_CLOCK || s === S.USING_EXTERNAL_CLOCK;
    const quiet = () => session === 'draining' || v.peerAborted || v.localAborted;

    // ------------------------------------------------------------- feeder ---
    /* A nybble answer: hi|val until the game shows receipt (wOtherPlayerLinkAction
       != $FF), then 10 more frames of it, then 10 frames of $00, then idle. */
    function feedNybble(hi, val, what) {
      v.feeder = { hi, val, phase: 'answer', n: 0, what };
      ev('feed', { what, b: hi | val });
      stats.feeds++;
    }
    function stepFeeder(oa, status) {
      const f = v.feeder;
      if (!f) return null;
      if (f.phase === 'answer') {
        if (oa !== 0xff) { f.phase = 'tail'; f.n = TAIL_FRAMES; }
        else if (!connectedStatus(status)) { v.feeder = null; return null; }
        return f.hi | f.val;
      }
      if (f.phase === 'tail') { if (--f.n <= 0) { f.phase = 'zero'; f.n = TAIL_FRAMES; } return f.hi | f.val; }
      if (--f.n <= 0) { v.feeder = null; }
      return 0x00;
    }

    // ------------------------------------------------------------- visits ---
    function endVisit(why, abort) {
      ev('visit-end', { why, stage: v.stage, abort: !!abort });
      if (abort && session === 'linked' && !v.peerAborted && !v.localAborted) {
        send({ type: 'abort', stage: abortStage(v.stage) });
        peer = freshPeer();
        peer.stage = 'ignoring';
      }
      if (role === 'b') port.ext(0, EXT_GAP, EXT_HOLD);
      port.clear();
      v = freshVisit();
      setIdle(0xff);
      if (session === 'draining') closeNow(drainReason);
    }
    function abortStage(st) {
      if (st === 'bulk' || st === 'battle') return 'menu';
      return ABORT_STAGES.has(st) ? st : 'menu';
    }

    function onFrame() {
      frame++;
      if (session === 'closed') return;
      const t = now();
      if (session === 'linked') {
        if (t - lastPing >= PING_MS) { lastPing = t; send({ type: 'ping', t }); }
        if (t - lastRx > PEER_GONE_MS || (peerPaused !== null && t - peerPaused > PAUSE_GONE_MS)) {
          ev('peer-gone', { quiet: t - lastRx });
          send({ type: 'bye', reason: 'peer-gone' });
          startDrain('peer-gone');
          if (session === 'closed') return;
        }
      }
      if (session !== 'linked' && session !== 'draining') return;

      const out = port.drain(512);
      const status = rd(L.hram.hSerialConnectionStatus);
      const mode = r1('wLinkMode');
      const pa = r1('wPlayerLinkAction');
      const oa = r1('wOtherPlayerLinkAction');
      const [tfBank, tfAddr] = W('wLinkTimeoutFrames');
      const tf0 = rd(tfAddr, tfBank), tf1 = rd(tfAddr + 1, tfBank);
      const ie = rd(L.rIE, 0);
      const outHas = (b) => out.some((e) => e.out === b);
      const probe = out.some((e) => e.clock === 1 && e.out === 0x01);
      const hi = HI[mode] || S.SERIAL_TIMECAPSULE;

      let idle = 0xfe;
      switch (v.stage) {
        case 'outside': {
          idle = 0xff;
          if (status === S.CONNECTION_NOT_ESTABLISHED && mode === 0 && probe && (pa === 1 || pa === 2)) {
            if (session === 'draining') { closeNow(drainReason); return; }
            v.stage = 'desk'; v.deskFrame = frame; v.enterFrame = frame; stats.visits++;
            ev('desk', { pa });
          } else break;
        }
        // falls through
        case 'desk': {
          idle = 0xff;
          if (connectedStatus(status)) {
            if (status !== WANT_STATUS) return fail('internal', `became ${status}, wanted ${WANT_STATUS}`);
            v.stage = 'connected';
            ev('connected', { status });
            if (role === 'b') port.ext(2, EXT_GAP, EXT_HOLD);
            idle = 0xfe;
            break;
          }
          if (probe) {
            v.lastProbe = frame;
            v.left = Math.max(0, Math.round(((tf1 - 1) * 256 + tf0) * FRAME_MS));
            if (session === 'linked' && (v.deskSent < 0 || frame - v.deskSent >= DESK_RESEND_FRAMES)) {
              v.deskSent = frame;
              send({ type: 'desk', left: Math.min(60000, v.left) });
            }
          }
          if (frame - v.lastProbe > DESK_GONE_FRAMES && !connectedStatus(status)) {
            // row 2 ended without a link ("Your friend isn't ready.")
            if (session === 'linked' && v.deskSent >= 0) send({ type: 'abort', stage: 'desk' });
            endVisit('row 2 over', false);
            return;
          }
          const pd = peer.stage === 'desk' ? peer.desk : null;
          if (session === 'linked' && pd) {
            const age = t - pd.at;
            if (age <= DESK_FRESH_MS && pd.left - age > DESK_PEER_MARGIN_MS && v.left > DESK_OWN_MARGIN_MS) idle = ROLE_BYTE;
          }
          break;
        }
        case 'connected':
          if (!connectedStatus(status)) { endVisit('closed before row 4', true); return; }
          if (mode === 0 && pa === 1 && outHas(S.SERIAL_TIMECAPSULE | 1)) {
            v.stage = 'rcpt';
            ev('rcpt');
            send({ type: 'rcpt' });
          }
          if (v.stage !== 'rcpt') break;
        // falls through
        case 'rcpt':
          if (!connectedStatus(status)) { endVisit('row 4 timed out', true); return; }
          if (!v.feeder && !v.rcptFed && peer.rcpt && !quiet()) { v.rcptFed = true; feedNybble(S.SERIAL_TIMECAPSULE, 1, 'rcpt'); }
          if (outHas(0xd0 | 1) || outHas(0xd0 | 2)) {
            v.stage = 'sync';
            const room = r1('wChosenCableClubRoom');
            ev('sync', { room });
            send({ type: 'sync', room });
          }
          if (v.stage !== 'sync') break;
        // falls through
        case 'sync':
          if (mode !== 0) {
            v.stage = 'room'; v.feeder = null; v.override = null;
            ev('room', { mode });
            break;
          }
          if (!connectedStatus(status)) { endVisit('sync failed', false); return; }
          if (quiet()) v.override = 0xd0;
          else if (peer.sync) v.override = 0xd0 | peer.sync;
          break;
        case 'room':
        case 'menu':
          if (mode === 0 && !connectedStatus(status)) { endVisit('left the room', !v.afterBulk || v.pendingAct !== null); return; }
          if (pa === 5 && tf0 + tf1 !== 0 && outHas(hi | 5)) {
            v.stage = 'blocks';
            v.blocksSent = false; v.blocksOk = null; v.feed = null; v.enterFrame = frame;
            v.pendingAct = null;
            const blocks = {
              rn: readBlock('rn'), party: readBlock('party'), patch: readBlock('patch'),
              mail: mode === S.LINK_TRADECENTER ? readBlock('mail') : new Uint8Array(0),
            };
            v.myBlocks = blocks;
            ev('blocks-out', { gen: v.gen, mode });
            if (!quiet()) send({ type: 'blocks', gen: v.gen, rn: blocks.rn, party: blocks.party, patch: blocks.patch, mail: blocks.mail });
          } else {
            exchange(mode, pa, oa, tf0, tf1, hi, status);
            break;
          }
        // falls through
        case 'blocks':
          if (mode === 0 && !connectedStatus(status)) { endVisit('left during blocks', true); return; }
          if (v.blocksOk === null) {
            if (quiet()) { v.blocksOk = false; feedNybble(hi, 0, 'blocks-refuse'); }
            else if (peer.blocks && peer.blocks.gen === v.gen) {
              const pb = peer.blocks;
              peer.blocks = null;
              const r = V.validateBlocks(L, pb, { mode });
              if (r.ok) {
                v.blocksOk = true;
                v.feed = buildFeed(pb, mode, L);
                v.peerCount = pb.party[L.partyLayout.count];
                feedNybble(hi, 5, 'blocks-ok');
              } else {
                v.blocksOk = false;
                ev('invalid-blocks', { reasons: r.reasons.slice(0, 8) });
                const field = String(r.reasons[0] || 'unknown').split(' ')[0].toLowerCase().replace(/[^a-z0-9_.[\]$-]/g, '').slice(0, 60) || 'unknown';
                feedNybble(hi, 0, 'blocks-invalid');
                fail(`invalid-blocks:${field}`, r.reasons.join('; '));
              }
            } else if (peer.blocks && peer.blocks.gen !== v.gen) {
              return fail('internal', `peer blocks gen ${peer.blocks.gen}, ours ${v.gen}`);
            }
          } else if (v.blocksOk === false && v.feeder && v.feeder.val === 5 && v.feeder.phase === 'answer') {
            feedNybble(hi, 0, 'blocks-refuse');
          }
          if (pa === 6 && outHas(hi | 6) && !(v.feeder && v.feeder.val === 6)) feedNybble(hi, 6, 'hs6');
          if (oa === 0xff && tf0 === 0 && tf1 === 0 && pa === 5 && frame - v.enterFrame > 2 && !v.feeder) {
            // action 5 timed out locally ("Too much time has elapsed."): no bulk this visit
            if (!v.localAborted) {
              ev('blocks-timeout');
              if (session === 'linked' && !v.peerAborted) { send({ type: 'abort', stage: 'blocks' }); peer = freshPeer(); peer.stage = 'ignoring'; }
              v.localAborted = true;
            }
          }
          if (ie === L.IE_SERIAL && v.blocksOk && v.feed) {
            const n = port.push(v.feed);
            if (role === 'b') port.ext(1, EXT_GAP, EXT_GAP);
            v.feeder = null;
            v.stage = 'bulk'; v.bulkFrame = frame;
            ev('bulk', { pushed: n, of: v.feed.length });
            if (n !== v.feed.length) return fail('internal', `FIFO took ${n}/${v.feed.length}`);
          } else if (ie === L.IE_SERIAL && !v.feed) {
            return fail('internal', 'bulk without peer blocks');
          }
          break;
        case 'bulk':
          if (ie !== L.IE_SERIAL) {
            const left = port.pending();
            stats.fifoLeft.push(left);
            stats.bulk.push({ gen: v.gen, frames: frame - v.bulkFrame });
            if (role === 'b') port.ext(2, EXT_GAP, EXT_HOLD);
            ev('bulk-done', { frames: frame - v.bulkFrame, fifoLeft: left });
            if (left !== 0) { port.clear(); return fail('internal', `FIFO not empty after the bulk exchange (${left})`); }
            v.afterBulk = true;
            v.phase = mode === S.LINK_TRADECENTER ? 'S0' : 'battle';
            v.gen++; v.seq = 0; v.pendingAct = null;
            v.stage = 'menu';
          }
          break;
        default:
          break;
      }
      // what goes into the next byte
      const fed = stepFeeder(oa, status);
      if (v.override !== null && v.override !== undefined) idle = v.override;
      if (fed !== null) idle = fed;
      setIdle(idle);
      if (v.stage === 'bulk' && role === 'a') setIdle(0xfe);
    }

    function readBlock(k) {
      const [bank, addr, len] = L.blocks[k];
      const out = new Uint8Array(len);
      for (let i = 0; i < len; i++) out[i] = rd(addr + i, bank);
      return out;
    }

    /* Rows 16T/16B: an untimed nybble exchange is running when the game has
       armed wOtherPlayerLinkAction ($FF) with no timeout, and our previous
       answer (with its tails) is finished. */
    function exchange(mode, pa, oa, tf0, tf1, hi, status) {
      if (!v.afterBulk || (mode !== S.LINK_TRADECENTER && mode !== S.LINK_COLOSSEUM)) return;
      if (!connectedStatus(status)) return;
      if (!v.pendingAct && !v.feeder && oa === 0xff && (mode === S.LINK_COLOSSEUM || (tf0 === 0 && tf1 === 0))) {
        v.pendingAct = { seq: v.seq, v: pa & 0x0f, gen: v.gen - 1, frame };
        ev('act-out', { seq: v.seq, v: pa & 0x0f, phase: v.phase });
        if (!quiet()) send({ type: 'act', gen: v.gen - 1, seq: v.seq, v: pa & 0x0f, mode });
        v.seq++;
      }
      const pend = v.pendingAct;
      if (!pend) return;
      let peerV = null;
      if (quiet()) {
        peerV = drainAnswer(pend.v);
      } else if (peer.acts.length) {
        const m = peer.acts[0];
        if (m.gen !== pend.gen || m.seq !== pend.seq || m.mode !== mode) return fail('internal', `act ${m.gen}/${m.seq} for ${pend.gen}/${pend.seq}`);
        peer.acts.shift();
        if (!V.validateAct(L, v.phase, m.v, v.peerCount)) {
          ev('invalid-act', { v: m.v, phase: v.phase });
          fail('invalid-act', `${v.phase} ${m.v}`);
          peerV = drainAnswer(pend.v);
        } else peerV = m.v;
      }
      if (peerV === null) return;
      ev('act-in', { seq: pend.seq, mine: pend.v, peer: peerV, phase: v.phase, wait: frame - pend.frame });
      feedNybble(hi, peerV, `act ${pend.seq}`);
      v.pendingAct = null;
      // the trade-menu phase model (section 3.5)
      if (v.phase === 'S0') { if (pend.v !== 0x0f && peerV !== 0x0f) v.phase = 'S1'; }
      else if (v.phase === 'S1') v.phase = pend.v === 2 && peerV === 2 ? 'S2' : 'S0';
    }
    /* What leads the local game out when the peer is gone (table 3.5). */
    function drainAnswer(mine) {
      switch (v.phase) {
        case 'S0': return 0x0f;
        case 'S1': return 1;
        case 'S2': return mine;
        default: return B.BATTLEACTION_FORFEIT;
      }
    }

    function snapshot() {
      return {
        session, drainReason, frame, stage: v.stage, phase: v.phase, gen: v.gen, seq: v.seq,
        peerStage: peer.stage, peerName: peerHello && peerHello.name, idle: idleNow, held: held.length,
        stats, log,
      };
    }

    // hello goes out at once: the transport is already paired
    send({ type: 'hello', lk: PROTOCOL, rom: opts.rom, build: String(opts.build || ''), core: String(opts.coreRev || ''),
      name: String(opts.name || '').slice(0, 16), role });
    ui.status('hello');
    return self;
  }

  return { create, parseMessage, encodeMessage, buildFeed, PROTOCOL, FRAME_MS };
}));
