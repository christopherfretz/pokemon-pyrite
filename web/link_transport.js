/* Pyrite link transport: a WebSocket to the LK1d relay (web/link_relay.py),
   shaped as the transport link.js expects (docs/LK1-LINK.md section 4).

   The relay is a dumb pipe.  This file does the relay's tiny control plane
   (create or join a room by code) and then gets out of the way: after
   pairing, every text message is handed to link.js unchanged.

   const conn = PyriteLinkTransport.connect(url, opts);
     url            ws(s)://host/link; defaultUrl(location) builds it.
     opts.WebSocket the constructor (default: globalThis.WebSocket).
     opts.wsOptions second constructor argument (Node only: { headers }).
   conn.create(onCode)   ask for a room; onCode('word-word-word', ttlSeconds).
   conn.join(code)       join a friend's room (case and separators are free).
   conn.onpaired(role)   both phones are connected; role 'a' (creator) or 'b'.
                         Hand conn to Link.create({ transport: conn, role, ... }).
   conn.onrefused(code, reason)   the socket closed before pairing (wrong or
                         expired code, relay busy, network): nothing to drain.

   The link.js transport interface, valid once paired:
     conn.send(text) -> bool      false if not open or over 4,096 bytes.
     conn.close()
     conn.onmessage = (text) => {}  set by link.js; messages that arrive
                         before it is set are buffered (up to 64).
     conn.onclose = (code, reason) => {}  set by link.js; fires once.
   LK1e hooks: conn.pause() / conn.resume() tell the peer the app was
   backgrounded or returned ({"type":"pause"} / {"type":"resume"}).

   There is no reconnect: a dropped socket is a dropped link (section 6).
   conn.state: connecting, open, waiting, paired, closed.  conn.closeCode,
   conn.closeReason, conn.stats { sent, recv } (data messages only). */
(function (root, factory) {
  if (typeof module === 'object' && module.exports) module.exports = factory();
  else root.PyriteLinkTransport = factory();
}(typeof self !== 'undefined' ? self : this, function () {
  'use strict';

  const MAX_BYTES = 4096;   // the relay's frame cap (link_relay.py CAPS.frame_bytes)
  const MAX_BUFFER = 64;

  // Close codes from link_relay.py CLOSE, as text a player can act on.
  const REASONS = {
    1000: 'closed',
    1001: 'the link server restarted',
    1002: 'protocol error',
    1003: 'protocol error',
    1006: 'connection lost',
    1007: 'protocol error',
    1008: 'protocol error',
    1009: 'message too big',
    4000: 'your friend disconnected',
    4001: 'the code expired',
    4002: 'that code did not work',
    4003: 'too many messages',
    4004: 'the connection was too slow',
    4005: 'the link was idle too long',
    4006: 'the link reached its time limit',
    4007: 'connection lost',
    4008: 'connection timed out',
    4013: 'the link server is busy, try again soon',
    4029: 'too many attempts, wait a minute',
  };

  function reasonFor(code) { return REASONS[code] || 'connection lost'; }

  function normalizeCode(text) {
    return String(text || '').trim().toLowerCase().split(/[\s\-_.]+/).filter(Boolean).join('-');
  }

  function defaultUrl(loc) {
    return (loc.protocol === 'https:' ? 'wss://' : 'ws://') + loc.host + '/link';
  }

  function utf8Length(s) {
    if (typeof TextEncoder !== 'undefined') return new TextEncoder().encode(s).length;
    return unescape(encodeURIComponent(s)).length;
  }

  function connect(url, opts) {
    opts = opts || {};
    const WS = opts.WebSocket || (typeof WebSocket !== 'undefined' ? WebSocket : null);
    if (!WS) throw new Error('no WebSocket available');
    const ws = opts.wsOptions ? new WS(url, opts.wsOptions) : new WS(url);
    ws.binaryType = 'arraybuffer';

    let onmessage = null;
    let pendingControl = null;   // what to send once open
    let onCode = null;
    let closedFired = false;
    const buffer = [];

    const conn = {
      state: 'connecting', role: null, code: null, closeCode: null, closeReason: null,
      stats: { sent: 0, recv: 0 },
      onpaired: null, onrefused: null, onclose: null,
      get onmessage() { return onmessage; },
      set onmessage(fn) {
        onmessage = fn;
        if (fn && buffer.length) Promise.resolve().then(flush);
      },
      create(cb) { onCode = cb || null; control({ op: 'create' }); },
      join(code) { control({ op: 'join', code: normalizeCode(code) }); },
      send(text) {
        if (conn.state !== 'paired' || ws.readyState !== 1) return false;
        text = String(text);
        if (utf8Length(text) > MAX_BYTES) return false;
        ws.send(text);
        conn.stats.sent++;
        return true;
      },
      close() {
        if (conn.state === 'closed') return;
        try { ws.close(1000); } catch (e) { /* already closing */ }
      },
      pause() { return conn.send('{"type":"pause"}'); },
      resume() { return conn.send('{"type":"resume"}'); },
    };

    function control(msg) {
      if (conn.state === 'open') { ws.send(JSON.stringify(msg)); conn.state = 'waiting'; }
      else if (conn.state === 'connecting') pendingControl = msg;
    }

    function flush() {
      while (buffer.length && onmessage && conn.state !== 'closed') onmessage(buffer.shift());
    }

    ws.onopen = () => {
      conn.state = 'open';
      if (pendingControl) { const m = pendingControl; pendingControl = null; control(m); }
    };

    ws.onmessage = (ev) => {
      if (conn.state === 'paired') {
        conn.stats.recv++;
        if (onmessage && !buffer.length) onmessage(ev.data);
        else if (buffer.length < MAX_BUFFER) buffer.push(ev.data);
        else conn.close();
        return;
      }
      // before pairing, only the relay speaks, in JSON
      let m = null;
      try { m = typeof ev.data === 'string' ? JSON.parse(ev.data) : null; } catch (e) { m = null; }
      if (m && m.op === 'code' && typeof m.code === 'string') {
        conn.code = m.code;
        if (onCode) onCode(m.code, m.ttl);
      } else if (m && m.op === 'paired' && (m.role === 'a' || m.role === 'b')) {
        conn.state = 'paired';
        conn.role = m.role;
        conn.code = null;
        if (conn.onpaired) conn.onpaired(m.role);
      } else {
        conn.close();
      }
    };

    ws.onerror = () => { /* onclose follows with the code */ };

    ws.onclose = (ev) => {
      const wasPaired = conn.state === 'paired';
      conn.state = 'closed';
      conn.closeCode = ev.code;
      conn.closeReason = reasonFor(ev.code);
      if (closedFired) return;
      closedFired = true;
      const fire = () => {
        if (wasPaired) { if (conn.onclose) conn.onclose(ev.code, conn.closeReason); }
        else if (conn.onrefused) conn.onrefused(ev.code, conn.closeReason);
      };
      // deliver anything still buffered first, so link.js sees in-flight messages before onclose
      if (wasPaired && buffer.length && onmessage) {
        while (buffer.length) onmessage(buffer.shift());
      }
      fire();
    };

    return conn;
  }

  return { connect, normalizeCode, defaultUrl, reasonFor, REASONS, MAX_BYTES };
}));
