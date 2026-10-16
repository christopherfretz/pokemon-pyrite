// LK1c end-to-end: two cores, two link.js stand-ins, one in-process fake
// relay (docs/LK1-LINK.md section 8, layer 3).  No Cable: the cores never see
// each other's bytes.  Each stand-in feeds its own game through the LinkPort
// from the other side's JSON messages, exactly as two phones would.
//
// The relay delivers each message after RTT/2 of virtual time (frames x
// 16.74 ms), in order per direction, and has hooks to drop, tamper with or
// cut the stream.  Scenarios (fixtures/link_a.sav = ALPHA = role a = master,
// link_b.sav = BRAVO = role b):
//   trade-0 / trade-200 / trade-1000  the LK1b trade at RTT 0/200/1000 ms;
//                     end state compared with the cable oracle
//   battle-0 / battle-200 / battle-1000  the LK1b battle; result + oracle
//   never-shows       B is linked but never goes to the desk: A gets the
//                     game's own "Your friend isn't ready." and an untouched save
//   cut-blocks        the relay dies as B sends its blocks
//   cut-menu          the relay dies at B's TRADE/CANCEL confirmation (S1)
//   cut-battle        the relay dies while B picks a mon after a faint
//                     (ForcePlayerMonChoice, no FORFEIT check there)
//   cut-menu-half     informational: A's S1 TRADE reaches B, B's S1 reply is
//                     lost (the two-generals window; B trades, A cancels)
//   hostile           B's party block arrives with species[0] = $FF
//   rom-mismatch      B claims another ROM: refused at hello, port never enabled
//
// Usage: node web/test/link_e2e.mjs [--only name[,name...]] [--relay]
//   --relay (LK1d): the same scenarios through the real relay -- `server.py
//        --link` on an ephemeral loopback port, two link_transport.js
//        WebSocket connections and a fault proxy that delays, drops and cuts
//        (link_net.mjs).  PYTHON=... picks the interpreter (default
//        ../tools/venv/bin/python, then python3).
//   --realtime (with --relay): pace virtual time to wall time and keep the
//        relay's default caps (the fast mode lifts the per-socket rate cap).
//        E2E_DEBUG=1 prints the stand-in logs on a failure; E2E_TRACE=1 prints each screen text change during recovery.
// Prints PASS/FAIL per check and per scenario; exit status 0 = all passed.
import { readFileSync } from 'node:fs';
import { createRequire } from 'node:module';
import path from 'node:path';
import {
  Rig, defaultStepper, REPO_DIR, sha256, bootContinue, wait, tap, until, untilText, aUntil, menuTo,
} from './harness.mjs';
import { parseArgs } from './core.mjs';
import { Net, startRelayServer } from './link_net.mjs';
import { existsSync } from 'node:fs';
import {
  enterRoom, tradeOne, cancelOut, leaveRoom, backOn2F, saveGame, firstFit, party, sramParty, dexBit, sameMon,
  linkStats, hex, decode, Checks, SP, STRUCT, NAME, MAIL, MON_ID, MON_STAT_EXP, MON_ITEM, FLOWER_MAIL, TILE_ARROW,
} from './cable.mjs';

const require = createRequire(import.meta.url);
const Link = require('../link.js');
const TABLES = JSON.parse(readFileSync(path.join(REPO_DIR, 'web/tables.json'), 'utf8'));
const L = TABLES.link;
const FIX = path.join(REPO_DIR, 'web/test/fixtures');
const ORACLE = path.join(REPO_DIR, 'web/test/oracle');
const OPTS = parseArgs(process.argv.slice(2), { only: '', relay: false, realtime: false });
let SERVER = null;          // --relay: the spawned server.py --link
let NET = null;             // --relay: this scenario's Net (proxy + transports)
let PAIRS = 0;
const CODES = [];           // every room code used, to check the server log never shows one

// ------------------------------------------------------------------ relay ---
/* In-order, delayed, per-direction message pipe.  hook(text, dir) may return
   undefined (deliver), null (drop) or a replacement text; it runs at send. */
class Relay {
  constructor(clock, rtt) {
    this.clock = clock; this.rtt = rtt; this.q = []; this.ends = []; this.closed = false; this.hook = null;
    this.sent = { 'a>b': 0, 'b>a': 0 }; this.dropped = 0; this.seqNo = 0;
  }
  transport(i) {
    const dir = i === 0 ? 'a>b' : 'b>a';
    const t = {
      onmessage: null, onclose: null,
      send: (text) => {
        if (this.closed) return;
        let out = text;
        if (this.hook) { const r = this.hook(text, dir, this); if (r === null) { this.dropped++; return; } if (r !== undefined) out = r; }
        if (this.closed) return;
        this.sent[dir]++;
        this.q.push({ to: 1 - i, text: out, at: this.clock() + this.rtt / 2, n: this.seqNo++ });
      },
      close: () => this.close(),
    };
    this.ends[i] = t;
    return t;
  }
  /* The network goes away: whatever is in flight still lands, then each end
     hears onclose after one one-way delay. */
  close() {
    if (this.closed) return;
    this.closed = true;
    const at = this.clock() + this.rtt / 2;
    for (const i of [0, 1]) this.q.push({ to: i, close: true, at, n: this.seqNo++ });
  }
  tick() {
    const now = this.clock();
    this.q.sort((x, y) => x.at - y.at || x.n - y.n);
    while (this.q.length && this.q[0].at <= now) {
      const m = this.q.shift();
      const t = this.ends[m.to];
      if (m.close) { if (t.onclose) t.onclose(); continue; }
      if (t.onmessage) t.onmessage(m.text);
    }
  }
}

// ------------------------------------------------------------------ setup ---
async function setup({ rtt = 0, romB = null, fixtures = ['link_a', 'link_b'] } = {}) {
  const rig = await Rig.create();
  const a = rig.add('A', readFileSync(path.join(FIX, `${fixtures[0]}.sav`)));
  const b = rig.add('B', readFileSync(path.join(FIX, `${fixtures[1]}.sav`)));
  a.drive(bootContinue(a)); b.drive(bootContinue(b));
  rig.settle(4000, 'boot');
  const clock = () => rig.frames * Link.FRAME_MS;
  let relay;
  if (SERVER) {
    relay = NET = new Net({ relayPort: SERVER.port, clock, rtt, pair: ++PAIRS, realtime: !!OPTS.realtime });
    CODES.push(await NET.pairUp());
  } else relay = new Relay(clock, rtt);
  const romSha = sha256(rig.rom);
  const enables = { A: [], B: [] };
  const mk = (c, i, role, rom) => {
    const port = c.link;
    const wrapped = Object.create(port);
    wrapped.enable = (on) => { enables[c.name].push(on); port.enable(on); };
    const ui = { log: [], status: (s) => ui.log.push(['status', s]), peerName: (n) => ui.log.push(['peer', n]),
      accept: () => true, error: (e) => ui.log.push(['error', e]) };
    const s = Link.create({
      core: { port: wrapped, read: (addr, bank) => c.withBank(bank, addr, 1, () => c.m.read(addr)) },
      transport: relay.transport(i), tables: L, ui, role, rom, build: 'e2e', coreRev: 'test',
      name: c.name === 'A' ? 'ALPHA' : 'BRAVO', now: clock,
    });
    s.ui = ui;
    return s;
  };
  const sa = mk(a, 0, 'a', romSha);
  const sb = mk(b, 1, 'b', romB || romSha);
  rig.stepper = (r) => { defaultStepper(r); sa.onFrame(); sb.onFrame(); relay.tick(); };
  relay.tick();                                     // RTT 0: hellos land before the first frame
  if (NET) await NET.quiesce();
  globalThis.__S = { sa, sb };
  return { rig, a, b, sa, sb, relay, enables, t0: Date.now() };
}
/* rig.settle, but with --relay each frame first waits (in wall time) for the
   real network to catch up with virtual time (link_net.mjs quiesce). */
async function settle(rig, max, what) {
  if (!NET) return rig.settle(max, what);
  for (let i = 0; i < max; i++) {
    if (rig.cores.every((c) => c.idle)) return i;
    await NET.quiesce();
    rig.frame();
  }
  return rig.settle(0, what);                       // throws with the screens
}
async function runBoth(rig, a, b, ga, gb, max, what) { a.drive(ga); b.drive(gb); return settle(rig, max, what); }
const pokemonDataSha = (c) => sha256(Uint8Array.from(c.rd('wPokemonData', c.loc('wPokemonDataEnd').addr - c.loc('wPokemonData').addr)));
const oracle = (name) => JSON.parse(readFileSync(path.join(ORACLE, `${name}.json`), 'utf8'));
const evs = (s, e) => s.state().log.filter((x) => x.e === e);
function linkChecks(ck, S, extra = {}) {
  for (const [who, s] of [['A', S.sa], ['B', S.sb]]) {
    const st = s.state();
    const fails = st.log.filter((x) => x.e === 'fail' || x.e === 'bad-message');
    if (!extra.allowFail) ck.ok(`${who} stand-in: no protocol failure`, fails.length === 0, JSON.stringify(fails));
    ck.ok(`${who} stand-in: FIFO empty after every bulk exchange`, st.stats.fifoLeft.every((n) => n === 0), JSON.stringify(st.stats.fifoLeft));
  }
}
function onTwoF(ck, c) {
  ck.ok(`${c.name} back on 2F, link closed`, c.pos()[0] === 20 && c.pos()[1] === 1 && c.rd1('wLinkMode') === 0
    && c.rd1('hSerialConnectionStatus') === 0xff, `${c.pos()} mode ${c.rd1('wLinkMode')}`);
}
/* Remember every distinct line of on-screen text a core shows. */
function watchText(rig, cores) {
  const seen = Object.fromEntries(cores.map((c) => [c.name, new Set()]));
  const inner = rig.stepper;
  rig.stepper = (r) => { inner(r); if (rig.frames % 4 === 0) for (const c of cores) seen[c.name].add(c.text()); };
  return (c, re) => [...seen[c.name]].some((t) => re.test(t));
}

// -------------------------------------------------------------- scenarios ---
async function tradeScenario(rtt) {
  const ck = new Checks(`trade-${rtt}`);
  const S = await setup({ rtt });
  const { rig, a, b } = S;
  const pre = { A: party(a), B: party(b) };
  const mailOff = (c, slot) => c.sramOffset('sPartyMail') + slot * MAIL;
  const preMailA = Array.from(a.sram().slice(mailOff(a, 3), mailOff(a, 3) + MAIL));
  const snaps = {};
  function* side(c, picks, ot) {
    yield* enterRoom(c, c === b ? 37 : 0, 'trade');
    yield* untilText(c, 'CANCEL', 4000 + rtt);
    snaps[c.name] = { otCount: c.rd1('wOTPartyCount'), otSpecies: c.rd('wOTPartySpecies', 6),
      otName: decode(c.rd('wOTPlayerName', NAME)), rns: c.rd('wLinkBattleRNs', 10) };
    for (let i = 0; i < picks.length; i++) yield* tradeOne(c, picks[i], ot[i]);
    yield* cancelOut(c);
    yield* backOn2F(c);
    yield* saveGame(c);
  }
  await runBoth(rig, a, b, side(a, [3, 3], ['MAGIKARP', 'CELEBI']), side(b, [1, 1], ['MEW', 'RATTATA']), 60000, `trade-${rtt}`);
  const wall = Date.now() - S.t0;
  const post = { A: party(a), B: party(b) };
  const img = { A: a.sram(), B: b.sram() };
  const sp = { A: sramParty(a, img.A), B: sramParty(b, img.B) };
  linkChecks(ck, S);
  ck.ok('roles: A master, B slave', a.role === 'master' && b.role === 'slave', `${a.role}/${b.role}`);
  ck.ok('A saw BRAVO\'s party', snaps.A.otName === 'BRAVO' && snaps.A.otCount === 4, `${snaps.A.otName} ${snaps.A.otCount}`);
  ck.ok('B saw ALPHA\'s party', snaps.B.otName === 'ALPHA' && snaps.B.otCount === 6, `${snaps.B.otName} ${snaps.B.otCount}`);
  ck.ok('slave adopted the master\'s battle RNs', hex(snaps.A.rns) === hex(snaps.B.rns), `${hex(snaps.A.rns)} / ${hex(snaps.B.rns)}`);
  const wantA = [SP.MEWTWO, SP.PIKACHU, SP.PIDGEY, SP.SPEAROW, SP.MAGIKARP, SP.CELEBI];
  const wantB = [SP.EGG, SP.PIKACHU, SP.MEW, SP.RATTATA];
  for (const [who, want, p] of [['A', wantA, post.A], ['B', wantB, post.B]]) {
    ck.ok(`${who} party species`, hex(p.map((m) => m.species)) === hex(want), hex(p.map((m) => m.species)));
    ck.ok(`${who} SRAM party = WRAM party`, JSON.stringify(sp[who].out) === JSON.stringify(p));
  }
  for (const [what, from, to, otName] of [
    ['MAGIKARP B->A', pre.B[0], post.A[4], 'BRAVO'], ['CELEBI B->A', pre.B[1], post.A[5], 'BRAVO'],
    ['MEW A->B', pre.A[2], post.B[2], 'ALPHA'], ['RATTATA A->B', pre.A[3], post.B[3], 'ALPHA']]) {
    ck.ok(`${what}: struct, OT ${otName}, nickname`, to && sameMon(from.mon, to.mon) && decode(to.ot) === otName && hex(to.nick) === hex(from.nick));
  }
  ck.ok('$FE: ID $FE42 and MEW stat exp $FE00 survived', post.A[4] && post.A[4].mon[MON_ID] === 0xfe && post.A[4].mon[MON_ID + 1] === 0x42
    && post.B[2] && post.B[2].mon[MON_STAT_EXP] === 0xfe && post.B[2].mon[MON_STAT_EXP + 1] === 0);
  const mailB = Array.from(img.B.slice(mailOff(b, 3), mailOff(b, 3) + MAIL));
  ck.ok('mail: RATTATA\'s FLOWER_MAIL letter arrived intact', post.B[3] && post.B[3].mon[MON_ITEM] === FLOWER_MAIL && hex(mailB) === hex(preMailA));
  for (const [who, list] of [['A', [SP.MAGIKARP, SP.CELEBI]], ['B', [SP.MEW, SP.RATTATA]]]) {
    ck.ok(`${who} POKeDEX caught the arrivals (SRAM)`, list.every((s) => dexBit(sp[who].dexCaught, s) && dexBit(sp[who].dexSeen, s)));
  }
  onTwoF(ck, a); onTwoF(ck, b);
  ck.ok('three bulk exchanges on each side', S.sa.state().stats.bulk.length === 3 && S.sb.state().stats.bulk.length === 3,
    `${S.sa.state().stats.bulk.length}/${S.sb.state().stats.bulk.length}`);
  const o = oracle('trade');
  ck.ok('A wPokemonData = cable oracle', pokemonDataSha(a) === o.end.A.wram_pokemon_data_sha256);
  ck.ok('B wPokemonData = cable oracle', pokemonDataSha(b) === o.end.B.wram_pokemon_data_sha256);
  ck.ok('both stand-ins still linked (room open for another visit)', S.sa.isLinked() && S.sb.isLinked());
  // LK1f: the party block's first padding byte (pyrite feature byte $8F) went
  // through link.js untouched, so each side latched the other as pyrite.
  ck.ok('LK1f: both latched the peer\'s feature byte $8F (stand-in passed it untouched)',
    a.rd1('wLinkPeerFeatures') === 0x8f && b.rd1('wLinkPeerFeatures') === 0x8f, hex([a.rd1('wLinkPeerFeatures'), b.rd1('wLinkPeerFeatures')]));
  const frames = rig.frames;
  rig.stepper = defaultStepper;
  for (const [who, image] of Object.entries(img)) {
    const c2 = rig.add(`${who}2`, image);
    c2.drive(bootContinue(c2));
    let ok = true;
    try { rig.settle(4000, 'reload'); } catch (e) { ok = false; }
    ck.ok(`${who} save reloads via CONTINUE with the traded party`, ok && hex(party(c2).map((m) => m.species)) === hex(who === 'A' ? wantA : wantB));
  }
  const acts = evs(S.sa, 'act-in');
  return { ck, rig, frames, wall, key: `${frames} frames, ${acts.length} act pairs, max act wait ${Math.max(...acts.map((x) => x.wait))} f, bulk ${JSON.stringify(S.sa.state().stats.bulk.map((x) => x.frames))} f` };
}


// ------------------------------------------------------- battle scenarios ---
function* fight(c, rec, stuckTap = false) {
  // cable.mjs fightBattle, plus (for the cut scenarios) an A press on any
  // screen that sits unchanged for 150 frames (a prompt nobody else answers)
  yield* until(() => c.rd1('wBattleMode') !== 0, 6000, 'battle start', null, 24, c);
  rec.rnsAtStart = hex(c.rd('wLinkBattleRNs', 10));
  rec.menus = 0; rec.moves = 0; rec.switches = []; rec.texts = new Set();
  let last = '', same = 0;
  for (let i = 0; c.rd1('wBattleMode') !== 0; i++) {
    if (i > 40000) throw new Error(`${c.name}: battle did not end\n${c.screen()}`);
    const t = c.text();
    if (/Link error|fled|canceled|was defeated|Lost against|Tied against/.test(t)) rec.texts.add(t);
    if (!rec.end && /was defeated|Lost against|Tied against/.test(t)) {
      rec.end = t; rec.result = c.rd1('wBattleResult') & 0x3f; rec.rnCount = c.rd1('wLinkBattleRNCount');
    }
    if (c.has('RECORD') && c.has('TOTAL')) {
      if (!rec.recordScreen) { yield* wait(30); rec.recordScreen = c.text(); }
      yield* tap('B'); yield* wait(30); continue;
    }
    if (c.has('TYPE/')) { rec.moves++; yield* tap('A'); yield* wait(30); continue; }
    if (c.has('FIGHT') && c.has('PACK') && c.has('RUN')) { rec.menus++; yield* tap('A'); yield* wait(30); continue; }
    if (c.has('Which') && !c.has('FIGHT')) {
      rec.whichFrame = c.frames;
      if (rec.onWhich) rec.onWhich();
      const slot = firstFit(c);
      yield* wait(20); yield* menuTo(c, slot); yield* tap('A');
      rec.switches.push(slot);
      yield* until(() => !c.has('Which'), 1200, 'switch accepted', null, 24, c);
      continue;
    }
    if (stuckTap) { same = t === last ? same + 1 : 0; last = t; if (same > 150) { same = 0; yield* tap('A'); continue; } }
    yield {};
  }
  rec.result = rec.result === undefined ? c.rd1('wBattleResult') & 0x3f : rec.result;
}
async function battleScenario(rtt) {
  const ck = new Checks(`battle-${rtt}`);
  const S = await setup({ rtt });
  const { rig, a, b } = S;
  const before = { A: linkStats(a, a.sram()), B: linkStats(b, b.sram()) };
  const pre = { A: party(a), B: party(b) };
  const rec = { A: {}, B: {} };
  function* side(c, r) { yield* enterRoom(c, c === b ? 37 : 0, 'battle'); yield* fight(c, r); yield* backOn2F(c); }
  await runBoth(rig, a, b, side(a, rec.A), side(b, rec.B), 40000, `battle-${rtt}`);
  const wall = Date.now() - S.t0;
  const after = { A: linkStats(a, a.sram()), B: linkStats(b, b.sram()) };
  linkChecks(ck, S);
  ck.ok('roles: A master, B slave', a.role === 'master' && b.role === 'slave', `${a.role}/${b.role}`);
  ck.ok('one bulk exchange each, 670-byte feed (no mail in the COLOSSEUM)', S.sa.state().stats.bulk.length === 1
    && S.sb.state().stats.bulk.length === 1 && evs(S.sa, 'bulk')[0].of === 670 && evs(S.sb, 'bulk')[0].of === 670,
    JSON.stringify(evs(S.sa, 'bulk')));
  ck.ok('slave adopted the master\'s battle RNs', rec.A.rnsAtStart === rec.B.rnsAtStart, `${rec.A.rnsAtStart} / ${rec.B.rnsAtStart}`);
  ck.ok('both consumed the same number of RNs', rec.A.rnCount === rec.B.rnCount, `${rec.A.rnCount} / ${rec.B.rnCount}`);
  ck.ok('A won (wBattleResult 0, "was defeated")', rec.A.result === 0 && /was defeated/.test(rec.A.end || ''), `${rec.A.result} "${rec.A.end}"`);
  ck.ok('B lost (wBattleResult 1, "Lost against")', rec.B.result === 1 && /Lost against/.test(rec.B.end || ''), `${rec.B.result} "${rec.B.end}"`);
  ck.ok('B was forced to switch twice: CELEBI (2) then PIKACHU (4)', JSON.stringify(rec.B.switches) === '[2,4]', JSON.stringify(rec.B.switches));
  ck.ok('A fought three turns', rec.A.moves === 3, rec.A.moves);
  ck.ok('RECORD screens agree (A 1-0-0 vs BRAVO, B 0-1-0 vs ALPHA)',
    /ALPHA RECORD TOTAL WIN LOSE DRAW 1 0 0 RESULT WIN LOSE DRAW BRAVO 1 0 0/.test(rec.A.recordScreen || '')
    && /BRAVO RECORD TOTAL WIN LOSE DRAW 0 1 0 RESULT WIN LOSE DRAW ALPHA 0 1 0/.test(rec.B.recordScreen || ''));
  for (const [who, c] of [['A', a], ['B', b]]) ck.ok(`${who} party unchanged after the battle`, JSON.stringify(party(c)) === JSON.stringify(pre[who]));
  ck.ok('link record: A +1 win, B +1 loss (SRAM)', after.A.wins === before.A.wins + 1 && after.B.losses === before.B.losses + 1);
  onTwoF(ck, a); onTwoF(ck, b);
  const o = oracle('battle');
  for (const [who, c] of [['A', a], ['B', b]]) {
    ck.ok(`${who} wPokemonData = cable oracle`, pokemonDataSha(c) === o.end[who].wram_pokemon_data_sha256);
  }
  // the RNs themselves are rolled by the master's Random at the bulk exchange,
  // so they differ from the cable run by however many frames earlier/later it ran
  ck.ok('end wLinkBattleRNs equal on both sides', hex(a.rd('wLinkBattleRNs', 10)) === hex(b.rd('wLinkBattleRNs', 10)));
  const acts = evs(S.sa, 'act-in');
  return { ck, rig, wall, key: `${rig.frames} frames, ${acts.length} act pairs, max act wait ${Math.max(...acts.map((x) => x.wait))} f` };
}

// ----------------------------------------------------- failure scenarios ---
/* Lead a core out after a failure, whatever the game shows: answer prompts
   that sit for 90 frames, CANCEL out of the trade menu, walk out of the room
   once it is reloaded, end on 2F with the link closed.  `seen` collects text. */
const PROMPTS = /Too much time|closed because|not ready|Incompatible|Link error|fled|canceled|Please come again/;
function* recover(c, seen, { ended: endedIn = false } = {}, max = 20000) {
  // `ended`: the game has visibly finished the visit (a prompt answered, the
  // trade menu cancelled, a battle over) -- only then is "standing still on a
  // non-blank screen" the reloaded room rather than the PLEASE WAIT! screen
  const since = {};
  let idle = 0, ended = endedIn;
  for (let i = 0; i < max; i++) {
    const t = c.text();
    const hit = t.match(/(Too much time|closed because|not ready|Incompatible|Link error|fled|canceled|Too bad|Please come again)/);
    if (hit) { seen.add(hit[1]); if (hit[1] !== 'Too bad') ended = true; }
    if (process.env.E2E_TRACE && t !== (recover.last ||= {})[c.name]) { console.log(`${c.name} f${c.frames} ${t.slice(0, 100)}`); recover.last[c.name] = t; }
    if (c.pos()[0] === 20 && c.pos()[1] === 1) { yield* backOn2F(c); return; }
    if (c.rd1('wBattleMode') !== 0) { const r = {}; yield* fight(c, r, true); for (const x of r.texts) seen.add(x); ended = true; continue; }
    if (c.has('CANCEL') && !c.has('TRADE') && !/Too bad/.test(t)) { seen.add('menu'); yield* cancelOut(c); yield* until(() => !c.has('WAITING'), 4000, 'cancel answered', null, 24, c);
      yield* until(() => !c.has('CANCEL') || c.rd1('wTilemap', 17 * 20 + 9) === TILE_ARROW, 600, 'menu left or redrawn', null, 24, c); ended = true; continue; }
    if (PROMPTS.test(t)) { since[t] = (since[t] || 0) + 1; if (since[t] > 90) { since[t] = 0; if (process.env.E2E_DEBUG) console.log(`${c.name} f${c.frames} tap A on: ${t}`); yield* tap('A'); ended = true; continue; } }
    idle = ended && c.rd1('wPlayerWalking') === 0xff && !hit && !/CANCEL|PLEASE WAIT/.test(t) ? idle + 1 : 0;
    if (idle > 120) { yield* leaveRoom(c); continue; }
    yield {};
  }
  throw new Error(`${c.name}: recover did not reach 2F (mode ${c.rd1('wLinkMode')} st ${c.rd1('hSerialConnectionStatus')} vb ${c.rd1('hVBlank')} IE ${c.m.read(0xffff)} walk ${c.rd1('wPlayerWalking')} seen ${[...seen]} ${dbgPC(c)})\n${c.screen()}`);
}
function dbgPC(c) {
  const M = c.m.mod, e = c.m.emu, sp = M._emulator_get_SP(e);
  const st = []; for (let k = 0; k < 16; k += 2) st.push((c.m.read(sp + k) | (c.m.read(sp + k + 1) << 8)).toString(16));
  return `PC ${M._emulator_get_PC(e).toString(16)} bank ${c.m.read(0xff9d)} SP ${sp.toString(16)} stack ${st.join(' ')}`;
}
const tail = (s, n = 6) => s.state().log.slice(-n).map((x) => x.e + (x.reason ? `:${x.reason}` : x.why ? `:${x.why}` : '')).join(' ');
function closedChecks(ck, S, who, s) {
  const st = s.state();
  ck.ok(`${who} stand-in closed, port disabled last`, st.session === 'closed' && S.enables[who][S.enables[who].length - 1] === false,
    `${st.session} enables ${JSON.stringify(S.enables[who])} / ${tail(s)}`);
}

async function neverShows() {
  const ck = new Checks('never-shows');
  const S = await setup({ rtt: 200 });
  const { rig, a, b } = S;
  const pre = a.sram();
  const preParty = JSON.stringify(party(a));
  let tYes = 0, tText = 0;
  function* sideA() {
    yield* until(() => a.rd1('wPlayerWalking') === 0xff, 60, 'standing');
    yield* aUntil(a, '>YES');
    yield* tap('A'); tYes = a.frames;
    yield* untilText(a, 'not ready', 3000); tText = a.frames;
    yield* wait(30);
    yield* until(() => !a.has('not ready'), 600, 'prompt closed', 'A', 40, a);
    yield* until(() => a.rd1('wPlayerWalking') === 0xff && a.rd1('hSerialConnectionStatus') === 0xff, 600, 'free', null, 24, a);
    yield* wait(60);
  }
  await runBoth(rig, a, b, sideA(), wait(10), 6000, 'never-shows');
  const wall = Date.now() - S.t0;
  ck.ok('A shows the game\'s own "Your friend is not ready."', tText > 0, `${tText - tYes} frames after YES`);
  ck.ok('A link status back to $FF, mode 0', a.rd1('hSerialConnectionStatus') === 0xff && a.rd1('wLinkMode') === 0);
  ck.ok('A SRAM untouched (no save was offered)', sha256(a.sram()) === sha256(pre));
  ck.ok('A party untouched', JSON.stringify(party(a)) === preParty);
  ck.ok('A stand-in announced the desk, then aborted it', evs(S.sa, 'desk').length === 1 && evs(S.sa, 'visit-end').length === 1
    && S.relay.sent['a>b'] >= 3, tail(S.sa));
  ck.ok('A stand-in never answered a probe (no peer at its desk)', !evs(S.sa, 'connected').length);
  ck.ok('both stand-ins still linked, ready for a later visit', S.sa.isLinked() && S.sb.isLinked());
  linkChecks(ck, S);
  return { ck, rig, wall, key: `text ${tText - tYes} f (${((tText - tYes) * Link.FRAME_MS / 1000).toFixed(1)} s) after YES` };
}

/* The relay dies at a chosen moment; both sides must find their way home. */
async function cutScenario(name, { room, cutWhen, sides, expect }) {
  const ck = new Checks(name);
  const S = await setup({ rtt: 200 });
  const { rig, a, b, relay } = S;
  const pre = { A: JSON.stringify(party(a)), B: JSON.stringify(party(b)) };
  const seen = { A: new Set(), B: new Set() };
  const cut = { frame: 0 };
  const doCut = (why) => { if (!relay.closed) { cut.frame = rig.frames; cut.why = why; relay.close(); } };
  cutWhen(S, doCut);
  const saw = watchText(rig, [a, b]);
  function* side(c, scenarioPart) {
    yield* enterRoom(c, c === b ? 37 : 0, room);
    let res = {};
    try { res = (yield* scenarioPart(c, doCut)) || {}; } catch (e) { if (!relay.closed) throw e; seen[c.name].add(`(driver: ${String(e.message).split('\n')[0]})`); }
    for (const x of res.texts || []) seen[c.name].add(x);
    yield* recover(c, seen[c.name], res);
  }
  await runBoth(rig, a, b, side(a, sides.A), side(b, sides.B), 40000, name);
  const wall = Date.now() - S.t0;
  ck.ok('the relay was cut', relay.closed && cut.frame > 0, cut.why);
  for (const [who, c, s] of [['A', a, S.sa], ['B', b, S.sb]]) {
    onTwoF(ck, c);
    closedChecks(ck, S, who, s);
    const re = expect[who];
    ck.ok(`${who} saw ${re}`, saw(c, re) || [...seen[who]].some((x) => re.test(x)), [...seen[who]].join(' | '));
    if (expect.partyUnchanged) ck.ok(`${who} party unchanged`, JSON.stringify(party(c)) === pre[who]);
  }
  linkChecks(ck, S, { allowFail: true });
  const short = (set) => [...new Set([...set].map((x) => (x.match(/Enemy \S+ fled|Link error|Too much time|Too bad|Trade completed|menu|\(driver/) || [x])[0]))].join('/');
  return { ck, rig, wall, key: `cut at f${cut.frame} (${cut.why}); A: ${short(seen.A)}; B: ${short(seen.B)}`, S, seen };
}
/* tradeOne up to and including the TRADE confirmation (the S1 exchange). */
function* tradeConfirm(c, slot, otName) {
  yield* untilText(c, 'CANCEL', 4000);
  yield* wait(30); yield* menuTo(c, slot); yield* tap('A');
  yield* untilText(c, 'STATS', 300);
  yield* wait(10); yield* tap('RIGHT'); yield* wait(10); yield* tap('A');
  yield* untilText(c, `for ${otName}?`, 3000);
  yield* wait(30); yield* tap('A');
}
const cutBlocks = () => cutScenario('cut-blocks', {
  room: 'trade',
  // the first `blocks` message, from either side, is lost and the relay dies with it
  cutWhen: (S, doCut) => { S.relay.hook = (text) => { if (JSON.parse(text).type === 'blocks') { doCut('first blocks message'); return null; } return undefined; }; },
  sides: { A: function* () {}, B: function* () {} },
  expect: { A: /Too much time/, B: /Too much time/, partyUnchanged: true },
});
const cutMenu = () => cutScenario('cut-menu', {
  room: 'trade',
  // the first S1 (TRADE/CANCEL) act, from either side, is lost with the relay
  cutWhen: (S, doCut) => {
    S.relay.hook = (text, dir) => {
      const m = JSON.parse(text);
      const s = dir === 'a>b' ? S.sa : S.sb;
      if (m.type === 'act' && s.state().phase === 'S1') { doCut(`${dir} S1 act`); return null; }
      return undefined;
    };
  },
  sides: { A: (c) => tradeConfirm(c, 3, 'MAGIKARP'), B: (c) => tradeConfirm(c, 1, 'MEW') },
  expect: { A: /Too bad/, B: /Too bad/, partyUnchanged: true },
});
/* Informational: A's S1 TRADE reaches B, then B's is lost with the relay.
   B's game sees (2, 2) and trades; A's sees the drain answer 1 and cancels.
   This is the two-generals window section 3.5 accepts ("hardware has the
   same exposure"); the scenario measures it rather than hiding it. */
async function cutMenuHalf() {
  const r = await cutScenario('cut-menu-half', {
    room: 'trade',
    cutWhen: (S, doCut) => {
      S.relay.hook = (text, dir) => {
        const m = JSON.parse(text);
        if (dir === 'b>a' && m.type === 'act' && S.sb.state().phase === 'S1') { doCut('b>a S1 act (a>b already delivered)'); return null; }
        return undefined;
      };
    },
    sides: { A: (c) => tradeConfirm(c, 3, 'MAGIKARP'), B: (c) => tradeConfirm(c, 1, 'MEW') },
    expect: { A: /Too bad/, B: /Trade completed|menu/ },
  });
  const { a, b } = r.S;
  const sa = party(a).map((m) => m.species), sb = party(b).map((m) => m.species);
  const sbS = sramParty(b, b.sram()).out.map((m) => m.species), saS = sramParty(a, a.sram()).out.map((m) => m.species);
  r.key = `A party ${hex(sa)} (SRAM ${hex(saS)}), B party ${hex(sb)} (SRAM ${hex(sbS)}); ${r.key}`;
  r.ck.ok('outcome recorded: B traded its MAGIKARP for a copy of MEW, A kept MEW and has no MAGIKARP (two-generals window)',
    sb.includes(SP.MEW) && sa.includes(SP.MEW) && !sa.includes(SP.MAGIKARP) && !sb.includes(SP.MAGIKARP), `A ${hex(sa)} B ${hex(sb)}`);
  return r;
}
const cutBattle = () => cutScenario('cut-battle', {
  room: 'battle',
  cutWhen: () => {},
  sides: {
    A: function* (c) { const r = {}; yield* fight(c, r, true); return { ended: true, texts: r.texts }; },
    // the relay dies the moment B's game asks "Which?" after its first faint
    B: function* (c, doCut) {
      const r = { onWhich: () => doCut('B at ForcePlayerMonChoice') };
      yield* fight(c, r, true);
      return { ended: true, texts: r.texts };
    },
  },
  expect: { A: /Link error|fled|canceled/, B: /Link error|fled|canceled/, partyUnchanged: true },
});

async function hostile() {
  const ck = new Checks('hostile');
  const S = await setup({ rtt: 200 });
  const { rig, a, b, relay } = S;
  const pre = { A: JSON.stringify(party(a)), B: JSON.stringify(party(b)) };
  const preOT = hex(a.rd('wOTPartyCount', 8));
  let tampered = false;
  relay.hook = (text, dir) => {
    const m = JSON.parse(text);
    if (dir !== 'b>a' || m.type !== 'blocks' || tampered) return undefined;
    const party_ = Buffer.from(m.party, 'base64');
    party_[L.partyLayout ? L.partyLayout.species : 18] = 0xff;     // species[0] = $FF
    m.party = party_.toString('base64');
    tampered = true;
    return JSON.stringify(m);
  };
  const seen = { A: new Set(), B: new Set() };
  watchText(rig, [a, b]);
  function* side(c) { yield* enterRoom(c, c === b ? 37 : 0, 'trade'); yield* recover(c, seen[c.name]); }
  await runBoth(rig, a, b, side(a), side(b), 40000, 'hostile');
  const wall = Date.now() - S.t0;
  const inv = evs(S.sa, 'invalid-blocks');
  ck.ok('B\'s blocks were tampered in flight', tampered);
  ck.ok('A\'s validator rejected them', inv.length === 1, JSON.stringify(inv));
  ck.ok('A sent bye invalid-blocks:<field>', evs(S.sa, 'fail').some((x) => /^invalid-blocks:/.test(x.reason)), tail(S.sa));
  ck.ok('B heard the bye', evs(S.sb, 'bye-in').some((x) => /^invalid-blocks:/.test(x.reason)), tail(S.sb));
  ck.ok('A never pushed a byte of the bad blocks into its game', S.sa.state().stats.bulk.length === 0);
  ck.ok('A\'s OT party area untouched', hex(a.rd('wOTPartyCount', 8)) === preOT);
  ck.ok('A saw "Too much time has elapsed"', seen.A.has('Too much time'), [...seen.A].join(' | '));
  for (const [who, c, s] of [['A', a, S.sa], ['B', b, S.sb]]) {
    ck.ok(`${who} party unchanged`, JSON.stringify(party(c)) === pre[who]);
    onTwoF(ck, c);
    closedChecks(ck, S, who, s);
  }
  return { ck, rig, wall, key: `A rejected: ${(inv[0] && inv[0].reasons || []).slice(0, 2).join('; ')}; B: ${[...seen.B].join('/')}` };
}

async function romMismatch() {
  const ck = new Checks('rom-mismatch');
  const S = await setup({ rtt: 200, romB: 'ab'.repeat(32) });
  const { rig } = S;
  rig.stepper = ((inner) => (r) => inner(r))(rig.stepper);
  for (let i = 0; i < 120; i++) { if (NET) await NET.quiesce(); rig.frame(); }
  const wall = Date.now() - S.t0;
  for (const [who, s] of [['A', S.sa], ['B', S.sb]]) {
    ck.ok(`${who} refused at hello (rom-mismatch)`, evs(s, 'refuse').some((x) => x.reason === 'rom-mismatch'), tail(s));
    ck.ok(`${who} stand-in closed`, s.state().session === 'closed');
    ck.ok(`${who} LinkPort never enabled`, S.enables[who].length === 0, JSON.stringify(S.enables[who]));
    ck.ok(`${who} told the UI`, s.ui.log.some((x) => x[0] === 'error' && /rom-mismatch/.test(x[1])));
  }
  // the first refusal closes the relay, so the second side's bye may never leave
  ck.ok('nothing but hello (+ bye) crossed the relay', S.relay.sent['a>b'] <= 2 && S.relay.sent['b>a'] <= 2
    && S.relay.sent['a>b'] + S.relay.sent['b>a'] >= 3, JSON.stringify(S.relay.sent));
  return { ck, rig, wall, key: 'refused before any port access' };
}

const SCENARIOS = {
  'trade-0': () => tradeScenario(0),
  'trade-200': () => tradeScenario(200),
  'trade-1000': () => tradeScenario(1000),
  'battle-0': () => battleScenario(0),
  'battle-200': () => battleScenario(200),
  'battle-1000': () => battleScenario(1000),
  'never-shows': neverShows,
  'cut-blocks': cutBlocks,
  'cut-menu': cutMenu,
  'cut-battle': cutBattle,
  'cut-menu-half': cutMenuHalf,
  hostile,
  'rom-mismatch': romMismatch,
};

async function main() {
  const opts = OPTS;
  if (opts.relay) {
    const venv = path.join(REPO_DIR, '../tools/venv/bin/python');
    const python = process.env.PYTHON || (existsSync(venv) ? venv : 'python3');
    // the e2e runs faster than real time, so the per-socket frame rate cap is lifted
    const caps = opts.realtime ? [] : ['frames_per_s=100000', 'frame_burst=100000'];
    SERVER = await startRelayServer({ repoDir: REPO_DIR, python, caps });
    console.log(`relay mode${opts.realtime ? ' (real time, default caps)' : ''}: server.py --link on 127.0.0.1:${SERVER.port}`);
  }
  const names = opts.only ? opts.only.split(',') : Object.keys(SCENARIOS);
  const rows = [];
  let ok = true;
  const T0 = Date.now();
  for (const name of names) {
    if (!SCENARIOS[name]) { console.log(`unknown scenario ${name}`); ok = false; continue; }
    const t0 = Date.now();
    let r;
    NET = null;
    try { r = await SCENARIOS[name](); } catch (e) {
      if (NET && process.env.E2E_DEBUG) console.log(`net: ${NET.busy()}`);
      if (NET) await NET.shutdown().catch(() => {});
      console.log(`${name}: FAIL (exception)\n${e.stack || e}`);
      if (process.env.E2E_DEBUG && globalThis.__S) for (const s of [globalThis.__S.sa, globalThis.__S.sb]) console.log(JSON.stringify(s.state().log.slice(-25)));
      rows.push([name, 'FAIL', ((Date.now() - t0) / 1000).toFixed(1), 'exception']);
      ok = false;
      continue;
    }
    if (NET) {
      r.ck.ok('every message fit the relay frame cap', NET.oversize === 0, NET.oversize);
      await NET.shutdown();
    }
    r.ck.print();
    const secs = ((Date.now() - t0) / 1000).toFixed(1);
    console.log(`${name}: ${r.ck.pass ? 'PASS' : 'FAIL'} ${secs} s wall -- ${r.key || ''}`);
    rows.push([name, r.ck.pass ? 'PASS' : 'FAIL', secs, r.key || '']);
    ok = ok && r.ck.pass;
    r.rig.delete();
  }
  if (SERVER) {
    await new Promise((res) => setTimeout(res, 300));    // let the relay log the last closes
    await SERVER.stop();
    const log = SERVER.stderr();
    const leaks = CODES.filter((c) => log.includes(c)).length + (/"type"|"op"|10\.\d+\.\d+\.\d+/.test(log) ? 1 : 0);
    const rooms = (log.match(/room paired/g) || []).length;
    console.log(`relay log: ${log.split('\n').length - 1} lines, ${rooms} rooms paired, no code/payload/IP: ${leaks === 0 ? 'PASS' : 'FAIL'}`);
    if (process.env.E2E_DEBUG) console.log(log);
    ok = ok && leaks === 0 && rooms === CODES.length;
  }
  console.log('\n| scenario | result | wall s | key values |\n|---|---|---|---|');
  for (const row of rows) console.log(`| ${row.join(' | ')} |`);
  console.log(`\nlink_e2e: ${ok ? 'PASS' : 'FAIL'} (${rows.filter((x) => x[1] === 'PASS').length}/${rows.length}) in ${((Date.now() - T0) / 1000).toFixed(1)} s`);
  process.exit(ok ? 0 : 1);
}
main();
