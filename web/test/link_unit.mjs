// LK1c unit tests for the link stand-in's message layer (link.js) and the
// block validator (link_validate.js).  No emulator: runs in well under a
// second.  docs/LK1-LINK.md "LK1c findings".
//
//   schema     every message type round-trips through encode/parse; malformed
//              frames (unknown type, missing/extra key, bad field, oversize,
//              bad base64, wrong block size, non-JSON, array) are refused
//   feed       buildFeed's framing (1061 bytes trade, 670 Colosseum, $FE
//              separators) and its payload against the LK1b cable oracle
//   baseline   the oracle's native blocks validate ok (trade + battle)
//   hostile    one mutation per case on the baseline; each must be refused
//              with the expected reason (or, for the few "native" cases,
//              accepted)
//   act        validateAct phase bounds
//
// Usage: node web/test/link_unit.mjs      exit status 0 = all passed.
//        UNIT_VERBOSE=1 also prints each validator case's reasons.
import { readFileSync } from 'node:fs';
import { createRequire } from 'node:module';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const require = createRequire(import.meta.url);
const HERE = path.dirname(fileURLToPath(import.meta.url));
const Link = require('../link.js');
const V = require('../link_validate.js');
const L = JSON.parse(readFileSync(path.join(HERE, '../tables.json'), 'utf8')).link;
const ORACLE = (n) => JSON.parse(readFileSync(path.join(HERE, 'oracle', n + '.json'), 'utf8'));
const S = L.serial, P = L.partyLayout, M = L.mailLayout, MON = L.mon;

let pass = 0, fail = 0;
function check(name, ok, detail) {
  if (ok) pass++; else fail++;
  console.log(`${ok ? 'PASS' : 'FAIL'} ${name}${!ok && detail !== undefined ? '  -- ' + detail : ''}`);
}

// ------------------------------------------------------------- schema ---
const ROM = 'ab'.repeat(32);
const blk = (n, f = 0) => new Uint8Array(n).fill(f);
const SAMPLES = {
  hello: { type: 'hello', lk: Link.PROTOCOL, rom: ROM, build: 'pyrite abc1234', core: 'binjgb', name: 'ALPHA', role: 'a' },
  desk: { type: 'desk', left: 600 }, rcpt: { type: 'rcpt' }, sync: { type: 'sync', room: 1 },
  blocks: { type: 'blocks', gen: 1, rn: blk(17, 0xfd), party: blk(450, 0x50), patch: blk(200), mail: blk(390, 0x20) },
  act: { type: 'act', gen: 1, seq: 3, v: 15, mode: 2 },
  ping: { type: 'ping', t: 12.5 }, pong: { type: 'pong', t: 12.5 }, pause: { type: 'pause' }, resume: { type: 'resume' },
  abort: { type: 'abort', stage: 'menu' }, bye: { type: 'bye', reason: 'invalid-blocks:party.species[0] $ff' },
};
const same = (a, b) => JSON.stringify(a, (k, v) => (v instanceof Uint8Array ? Array.from(v) : v)) === JSON.stringify(b, (k, v) => (v instanceof Uint8Array ? Array.from(v) : v));
for (const [t, m] of Object.entries(SAMPLES)) {
  const p = Link.parseMessage(Link.encodeMessage(m));
  check(`schema round-trip ${t}`, p.ok && same(p.msg, m), JSON.stringify(p).slice(0, 120));
}
const colo = Link.parseMessage(Link.encodeMessage({ ...SAMPLES.blocks, mail: blk(0) }));
check('schema blocks with an empty (Colosseum) mail block', colo.ok && colo.msg.mail.length === 0, colo.reason);

const enc = (o) => JSON.stringify(o);
const blocksJSON = JSON.parse(Link.encodeMessage(SAMPLES.blocks));
const BAD = [
  ['not text', 42],
  ['non-JSON', '{type:'],
  ['array', '[1,2]'],
  ['null', 'null'],
  ['unknown type', enc({ type: 'hax' })],
  ['type via prototype', enc({ type: 'constructor' })],
  ['missing key', enc({ type: 'desk' })],
  ['extra key', enc({ type: 'rcpt', x: 1 })],
  ['oversize frame', enc({ type: 'bye', reason: 'user', pad: 'x'.repeat(5000) })],
  ['hello lk not int', enc({ ...SAMPLES.hello, lk: '1' })],
  ['hello rom not hex', enc({ ...SAMPLES.hello, rom: 'zz'.repeat(32) })],
  ['hello rom short', enc({ ...SAMPLES.hello, rom: 'ab' })],
  ['hello name > 16', enc({ ...SAMPLES.hello, name: 'X'.repeat(17) })],
  ['hello name control char', enc({ ...SAMPLES.hello, name: 'A\nB' })],
  ['hello role c', enc({ ...SAMPLES.hello, role: 'c' })],
  ['sync room 3', enc({ type: 'sync', room: 3 })],
  ['act v 16', enc({ ...SAMPLES.act, v: 16 })],
  ['act v -1', enc({ ...SAMPLES.act, v: -1 })],
  ['act v 1.5', enc({ ...SAMPLES.act, v: 1.5 })],
  ['act mode 1', enc({ ...SAMPLES.act, mode: 1 })],
  ['act seq > 16 bits', enc({ ...SAMPLES.act, seq: 0x10000 })],
  ['ping t NaN-ish', '{"type":"ping","t":"NaN"}'],
  ['abort bad stage', enc({ type: 'abort', stage: 'battle' })],
  ['bye bad reason', enc({ type: 'bye', reason: 'because' })],
  ['blocks bad base64', enc({ ...blocksJSON, rn: '!!!!' })],
  ['blocks rn 16 bytes', enc({ ...blocksJSON, rn: Buffer.alloc(16).toString('base64') })],
  ['blocks party 451 bytes', enc({ ...blocksJSON, party: Buffer.alloc(451).toString('base64') })],
  ['blocks patch 199 bytes', enc({ ...blocksJSON, patch: Buffer.alloc(199).toString('base64') })],
  ['blocks mail 389 bytes', enc({ ...blocksJSON, mail: Buffer.alloc(389).toString('base64') })],
  ['blocks field not a string', enc({ ...blocksJSON, rn: [1, 2] })],
];
for (const [name, text] of BAD) {
  let p;
  try { p = Link.parseMessage(text); } catch (e) { p = { ok: true, threw: e.message }; }
  check(`schema refuses ${name}`, p && p.ok === false && typeof p.reason === 'string', JSON.stringify(p).slice(0, 120));
}

// ------------------------------------------------------- oracle blocks ---
/* The oracle stores each burst as it crossed the cable: a run of preamble
   bytes (its length depends on when the receiver started listening) and the
   payload.  Rebuild the sender's native WRAM block: native preamble length,
   then the payload, zero-padded (the mail block's last byte is never sent). */
function norm(hexs, pre, preLen, len) {
  const buf = Buffer.from(hexs, 'hex');
  let i = 0;
  while (i < buf.length && buf[i] === pre) i++;
  const o = new Uint8Array(len);
  o.fill(pre, 0, preLen);
  o.set(buf.subarray(i, i + len - preLen), preLen);
  return o;
}
function oracleBlocks(name, dir, mode) {
  const b = ORACLE(name).blocks[0][dir];
  return {
    rn: norm(b['11 RN'], 0xfd, S.SERIAL_RN_PREAMBLE_LENGTH, S.SERIAL_RN_PREAMBLE_LENGTH + S.SERIAL_RNS_LENGTH),
    party: norm(b['12 party'], 0xfd, S.SERIAL_PREAMBLE_LENGTH, P.padding + 3),
    patch: norm(b['13 patch'], 0xfd, S.SERIAL_PATCH_PREAMBLE_LENGTH, S.SERIAL_PATCH_LIST_LENGTH),
    mail: mode === S.LINK_TRADECENTER ? norm(b['14 mail'], S.SERIAL_MAIL_PREAMBLE_BYTE, S.SERIAL_MAIL_PREAMBLE_LENGTH, M.patch + M.patchLength) : new Uint8Array(0),
  };
}
const TRADE = oracleBlocks('trade', 'toSlave', S.LINK_TRADECENTER);    // ALPHA's (master) blocks
const BATTLE = oracleBlocks('battle', 'toSlave', S.LINK_COLOSSEUM);
const BATTLE_B = oracleBlocks('battle', 'toMaster', S.LINK_COLOSSEUM);

// --------------------------------------------------------------- feed ---
{
  const f = Link.buildFeed(TRADE, S.LINK_TRADECENTER, L);
  const c = Link.buildFeed(BATTLE, S.LINK_COLOSSEUM, L);
  check('feed trade length 1061', f.length === 1061, f.length);
  check('feed Colosseum length 670', c.length === 670, c.length);
  const sep = [17, 17 + 1 + 450, 17 + 1 + 450 + 1 + 200, 17 + 1 + 450 + 1 + 200 + 1];
  check('feed $FE after rn, party, patch (+ discarded byte before mail)', sep.every((i) => f[i] === 0xfe) && sep.slice(0, 3).every((i) => c[i] === 0xfe), sep.map((i) => f[i]));
  // Payload against the cable: each section of the feed, preamble run
  // stripped, must start with exactly the payload bytes the master put on
  // the oracle wire (preamble run stripped) for that section.
  const tb = ORACLE('trade').blocks[0].toSlave;
  const secs = [['11 RN', 0, 17, 0xfd], ['12 party', 18, 450, 0xfd], ['13 patch', 469, 200, 0xfd], ['14 mail', 671, 390, 0x20]];
  for (const [k, at, len, pre] of secs) {
    const wire = Buffer.from(tb[k], 'hex');
    let w = 0; while (w < wire.length && wire[w] === pre) w++;
    let o = at; while (o < at + len && f[o] === pre) o++;
    const payload = wire.subarray(w);
    const mine = Buffer.from(f.subarray(o, o + payload.length));
    check(`feed ${k} payload == oracle wire (${payload.length} bytes)`, mine.equals(payload), `${mine.toString('hex').slice(0, 40)} vs ${payload.toString('hex').slice(0, 40)}`);
  }
}

// ----------------------------------------------------------- baseline ---
const TC = { mode: S.LINK_TRADECENTER }, COL = { mode: S.LINK_COLOSSEUM };
const clone = (b) => ({ rn: Uint8Array.from(b.rn), party: Uint8Array.from(b.party), patch: Uint8Array.from(b.patch), mail: Uint8Array.from(b.mail) });
{
  const r1 = V.validateBlocks(L, TRADE, TC), r2 = V.validateBlocks(L, BATTLE, COL), r3 = V.validateBlocks(L, BATTLE_B, COL);
  check('baseline oracle trade blocks (ALPHA) ok', r1.ok, r1.reasons.join('; '));
  check('baseline oracle battle blocks (ALPHA) ok', r2.ok, r2.reasons.join('; '));
  check('baseline oracle battle blocks (BRAVO) ok', r3.ok, r3.reasons.join('; '));
}

// ------------------------------------------------------------ hostile ---
const monAt = (i) => P.mons + i * L.monStride;
const put16 = (b, o, v) => { b[o] = v >> 8; b[o + 1] = v & 0xff; };
const get16 = (b, o) => (b[o] << 8) | b[o + 1];
const glyphA = 0x80;                       // "A"
/* A trade baseline whose slot 0 holds valid mail, for the mail rules. */
function withMail() {
  const b = clone(TRADE);
  b.party[monAt(0) + MON.item] = L.mailItems[0];
  const mo = M.messages;
  b.mail.set([0x87, 0x88, 0x50], mo);                         // "HI@"
  const md = M.metadata;
  b.mail.set([0x80, 0x8b, 0x8f, 0x87, 0x80, 0x50], md + M.author);  // "ALPHA@"
  b.mail[md + M.species] = b.party[P.species];
  b.mail[md + M.type] = L.mailItems[0];
  return b;
}
const firstNonHoldable = (() => { for (let i = 1; i < 256; i++) if (!L.holdable.includes(i)) return i; return 0; })();

/* [name, mutate(blocks) | null, expected reason regex (null = must be accepted), opts] */
const CASES = [
  // species
  ['species list[0] = 0', (b) => { b.party[P.species] = 0; }, /party\.species\[0\] \$0\b/],
  ['species list[0] = $FF', (b) => { b.party[P.species] = 0xff; }, /party\.species\[0\] \$ff/],
  ['struct species 0', (b) => { b.party[monAt(0)] = 0; }, /party\.mon\[0\]\.species \$0\b/],
  ['struct species 253 (EGG id in the struct)', (b) => { b.party[monAt(0)] = L.egg; b.party[P.species] = L.egg; }, /party\.mon\[0\]\.species \$fd/],
  ['struct species $FF', (b) => { b.party[monAt(0)] = 0xff; }, /party\.mon\[0\]\.species \$ff/],
  ['species-list mismatch', (b) => { b.party[P.species + 1] = b.party[P.species]; }, /party\.mon\[1\]\.species \$[0-9a-f]+ != list/],
  ['species[count] not $FF', (b) => { b.party[P.species + b.party[P.count]] = 0x19; }, /party\.species\[\d\] not \$FF/],
  // count
  ['party count 0', (b) => { b.party[P.count] = 0; }, /party\.count 0/],
  ['party count 7', (b) => { b.party[P.count] = 7; }, /party\.count 7/],
  ['party count $FF', (b) => { b.party[P.count] = 0xff; }, /party\.count 255/],
  // moves / PP
  ['move 1 = 0', (b) => { b.party[monAt(0) + MON.moves] = 0; b.party[monAt(0) + MON.pp] = 0; }, /mon\[0\]\.move1 empty/],
  ['move after an empty slot', (b) => { const m = monAt(0); b.party[m + MON.moves + 1] = 0; b.party[m + MON.pp + 1] = 0; b.party[m + MON.moves + 2] = 1; }, /move3 after an empty slot/],
  ['move id 252 (past the table)', (b) => { b.party[monAt(0) + MON.moves] = 252; }, /move1 \$fc/],
  ['duplicate move', (b) => { const m = monAt(0); b.party[m + MON.moves + 1] = b.party[m + MON.moves]; }, /move2 duplicate/],
  ['PP overflow (63, no PP Ups)', (b) => { b.party[monAt(0) + MON.pp] = 63; }, /pp1 63 >/],
  ['PP Ups past max (3 Ups, 63)', (b) => { b.party[monAt(0) + MON.pp] = 0xff; }, /pp1 63 >/],
  ['PP on an empty slot', (b) => { const m = monAt(3); let k = 0; while (k < 4 && b.party[m + MON.moves + k]) k++; if (k === 4) { b.party[m + MON.moves + 3] = 0; k = 3; } b.party[m + MON.pp + k] = 5; }, /mon\[3\]\.pp\d on empty slot/],
  // level / exp / stats
  ['level 0', (b) => { b.party[monAt(0) + MON.level] = 0; }, /mon\[0\]\.level 0/],
  ['level 101', (b) => { b.party[monAt(0) + MON.level] = 101; }, /mon\[0\]\.level 101/],
  ['exp below the level minimum', (b) => { b.party.fill(0, monAt(0) + MON.exp, monAt(0) + MON.exp + 3); }, /mon\[0\]\.exp 0 outside/],
  ['exp above the level-100 cap', (b) => { b.party.fill(0xfd, monAt(0) + MON.exp, monAt(0) + MON.exp + 3); }, /mon\[0\]\.exp \d+ outside/],
  ['HP above max HP', (b) => { const m = monAt(0); put16(b.party, m + MON.hp, get16(b.party, m + MON.maxHp) + 1); }, /mon\[0\]\.hp \d+ > max/],
  ['stat above 999', (b) => { put16(b.party, monAt(0) + MON.maxHp + 2, 1000); }, /mon\[0\]\.stat1 1000/],
  ['bad status byte', (b) => { b.party[monAt(0) + MON.status] = 0x09; }, /mon\[0\]\.status \$9/],
  ['non-holdable item', (b) => { b.party[monAt(0) + MON.item] = firstNonHoldable; }, /mon\[0\]\.item/],
  ['Pokerus 5 days', (b) => { b.party[monAt(0) + MON.pokerus] = 0x15; }, /pokerus days 5/],
  ['Pokerus days without a strain', (b) => { b.party[monAt(0) + MON.pokerus] = 0x03; }, /pokerus days without strain/],
  // strings
  ['nickname with no terminator', (b) => { b.party.fill(glyphA, P.nicks, P.nicks + L.monNameLength); }, /party\.nick\[0\] no terminator/],
  ['OT name with no terminator', (b) => { b.party.fill(glyphA, P.ots, P.ots + L.nameLength); }, /party\.ot\[0\] no terminator/],
  ['player name empty', (b) => { b.party[P.name] = 0x50; }, /party\.name empty/],
  ['player name control byte', (b) => { b.party[P.name + 1] = 0x00; }, /party\.name byte 1 \$0/],
  ['nickname first byte not a glyph', (b) => { b.party[P.nicks] = 0x4e; }, /party\.nick\[0\] first byte not a glyph/],
  ['raw $FE inside the party block', (b) => { b.party[P.nicks + 3] = 0xfe; }, /raw \$FE/],
  ['party preamble byte', (b) => { b.party[2] = 0; }, /party\.preamble\[2\]/],
  // RN block
  ['RN value $FE', (b) => { b.rn[10] = 0xfe; }, /rn\[10\] \$fe/],
  ['RN value $FD', (b) => { b.rn[16] = 0xfd; }, /rn\[16\] \$fd/],
  ['RN preamble byte', (b) => { b.rn[0] = 0x12; }, /rn\.preamble\[0\]/],
  // patch lists (index out of range / garbage)
  ['patch list 1 offset 253 (past SERIAL_PATCH_DATA_SIZE)', (b) => { b.patch[10] = 253; }, /patch list 1 offset 253 out of range/],
  ['patch list 1 offset 0', (b) => { b.patch[10] = 0; }, /patch list 1 offset 0 out of range|patch\[\d+\] not zero after/],
  ['patch list 2 offset 39 (past the mon structs)', (b) => { let i = 10; while (b.patch[i] !== 0xff) i++; b.patch[i + 1] = 39; b.patch[i + 2] = 0xff; }, /patch list 2 offset 39 out of range/],
  ['patch offset pointing at a non-$FF byte', (b) => { b.patch[10] = 1; }, /patch list 1 offset 1 -> party\[\d+\] is \$[0-9a-f]+, not \$FF/],
  ['patch list not increasing', (b) => { const x = b.patch[10]; b.party[P.id - 1 + 1] = 0xff; b.patch.set([x, 1, 0xff, 0xff], 10); }, /patch list 1 not increasing at 1/],
  ['patch preamble byte', (b) => { b.patch[1] = 0; }, /patch\.preamble\[1\]/],
  ['patch bytes after the lists', (b) => { b.patch[199] = 7; }, /patch\[199\] not zero after the lists/],
  ['patch bytes before the lists', (b) => { b.patch[5] = 7; }, /patch\[5\] not zero/],
  // mail (pointer garbage first: the patch set writes memory)
  ['mail patch offset 0', (b) => { b.mail[M.patch] = 0; }, /mail\.patch offset 0 out of range/],
  ['mail patch offset 85 (past the metadata)', (b) => { b.mail[M.patch] = 85; }, /mail\.patch offset 85 out of range/],
  ['mail patch offset at a non-$FF byte', (b) => { b.mail[M.patch] = 1; b.mail[M.patch + 1] = 0xff; }, /mail\.patch offset 1 -> \$[0-9a-f]+, not \$FF/],
  ['mail patch set repeating an offset (103 entries, no terminator)', (b) => { b.mail.fill(0xff, M.metadata, M.metadata + 84); for (let k = 0; k < M.patchLength; k++) b.mail[M.patch + k] = 1 + (k % 84); }, /mail\.patch offset \d+ -> \$fe, not \$FF/],
  ['mail preamble byte', (b) => { b.mail[0] = 0; }, /mail\.preamble\[0\]/],
  ['mail raw $FE', (b) => { b.mail[M.messages + 40] = 0xfe; }, /mail\[\d+\] raw \$FE/],
  ['valid held mail accepted', null, null, { base: withMail }],
  ['mail message with no terminator', (b) => { b.mail.fill(glyphA, M.messages, M.messages + M.msgLength); }, /mail\[0\]\.message no terminator/, { base: withMail }],
  ['mail message control byte', (b) => { b.mail[M.messages] = 0x01; }, /mail\[0\]\.message byte 0 \$1/, { base: withMail }],
  ['mail author with no terminator', (b) => { b.mail.fill(glyphA, M.metadata + M.author, M.metadata + M.author + M.authorLength); }, /mail\[0\]\.author no terminator/, { base: withMail }],
  ['mail species 0', (b) => { b.mail[M.metadata + M.species] = 0; }, /mail\[0\]\.species \$0/, { base: withMail }],
  ['mail type not a mail item', (b) => { b.mail[M.metadata + M.type] = 1; }, /mail\[0\]\.type \$1/, { base: withMail }],
  // sizes / mode
  ['Colosseum with a mail block', (b) => { b.mail = new Uint8Array(390).fill(0x20); }, /mail\.length 390 in the Colosseum/, { base: () => clone(BATTLE), opts: COL }],
  ['party block 449 bytes', (b) => { b.party = b.party.slice(0, 449); }, /party\.length 449/],
  ['rn block 16 bytes', (b) => { b.rn = b.rn.slice(0, 16); }, /rn\.length 16/],
  ['patch block 199 bytes', (b) => { b.patch = b.patch.slice(0, 199); }, /patch\.length 199/],
  ['mail block 389 bytes', (b) => { b.mail = b.mail.slice(0, 389); }, /mail\.length 389/],
  ['mode 1 (Time Capsule)', null, /mode 1/, { opts: { mode: 1 } }],
  // native edge cases that must be ACCEPTED
  ['species 252 list+struct (Q1: allowed)', (b) => { b.party[P.species] = 252; b.party[monAt(0)] = 252; }, null],
  ['EGG in the list with a real struct species', (b) => { b.party[P.species] = L.egg; }, null],
];
for (const [name, mutate, want, o = {}] of CASES) {
  const b = (o.base || (() => clone(TRADE)))();
  if (mutate) mutate(b);
  let r;
  try { r = V.validateBlocks(L, b, o.opts || TC); } catch (e) { r = { threw: e.message }; }
  if (r.threw) { check(`hostile ${name}`, false, 'threw ' + r.threw); continue; }
  if (process.env.UNIT_VERBOSE) console.log("   ", r.reasons.join("; "));
  if (want === null) check(`accept ${name}`, r.ok, r.reasons.join('; '));
  else check(`hostile ${name}`, !r.ok && r.reasons.some((s) => want.test(s)), r.reasons.join('; ') || 'accepted');
}

// patch list unterminated cannot be reached through validateBlocks with a
// real party (an earlier rule fires first); drive patchOffsets directly.
{
  const party = new Uint8Array(P.padding + 3).fill(0xff);
  const patch = new Uint8Array(S.SERIAL_PATCH_LIST_LENGTH);
  patch.fill(0xfd, 0, 3);
  for (let i = 10; i < patch.length; i++) patch[i] = i - 9;
  const r = V.patchOffsets(L, patch, party);
  check('hostile patch list 1 unterminated (patchOffsets)', r === 'patch list 1 unterminated', r);
}

// garbage never throws
const GARBAGE = [undefined, null, 0, 'x', [], {}, { rn: 'x', party: 'y', patch: 'z', mail: 'w' },
  { rn: [256], party: [], patch: [], mail: [] }, { rn: [-1], party: [], patch: [], mail: [] },
  { rn: new Uint8Array(17), party: new Uint8Array(450), patch: new Uint8Array(200), mail: new Uint8Array(390) },
  { rn: new Uint8Array(17).fill(0xfd), party: new Uint8Array(450).fill(0xfd), patch: new Uint8Array(200).fill(0xfd), mail: new Uint8Array(390).fill(0xff) }];
GARBAGE.forEach((g, i) => {
  let r, threw = null;
  try { r = V.validateBlocks(L, g, TC); } catch (e) { threw = e.message; }
  check(`garbage input #${i} refused without throwing`, !threw && r && r.ok === false && Array.isArray(r.reasons) && r.reasons.length > 0, threw || JSON.stringify(r));
});
{
  let r, threw = null;
  try { r = V.validateBlocks({}, TRADE, TC); } catch (e) { threw = e.message; }
  check('broken tables -> reason, no throw', !threw && r && r.ok === false, threw || JSON.stringify(r));
}

// ----------------------------------------------------------- validateAct ---
const ACT = [
  ['S0', 0x0f, 3, true], ['S0', 0, 3, true], ['S0', 2, 3, true], ['S0', 3, 3, false], ['S0', 6, 7, false], ['S0', 14, 6, false],
  ['S1', 1, 6, true], ['S1', 2, 6, true], ['S1', 0, 6, false], ['S1', 3, 6, false], ['S1', 15, 6, false],
  ['S2', 0, 6, true], ['S2', 1, 6, true], ['S2', 2, 6, true], ['S2', 3, 6, false],
  ['battle', 0, 2, true], ['battle', 3, 2, true], ['battle', 4, 2, true], ['battle', 5, 2, true], ['battle', 6, 2, false],
  ['battle', 10, 6, false], ['battle', 9, 6, true], ['battle', 12, 6, false], ['battle', 13, 6, true], ['battle', 14, 6, true], ['battle', 15, 6, true],
  ['battle', 16, 6, false], ['battle', 1.5, 6, false], ['battle', '1', 6, false], ['nope', 1, 6, false],
];
for (const [ph, v, n, want] of ACT) {
  let got;
  try { got = V.validateAct(L, ph, v, n); } catch (e) { got = 'threw'; }
  check(`act ${ph} v=${JSON.stringify(v)} peerCount=${n} -> ${want}`, got === want, got);
}

// ------------------------------------------------- held while accepting ---
// A peer that accepted first reaches the desk while our Accept is still up:
// link.js holds its game messages (bounded) and replays them at link-up.
function session(opts = {}) {
  const sent = [];
  const transport = { send(t) { sent.push(JSON.parse(t)); }, close() { transport.closed = true; } };
  let answer;
  const port = { enable() {}, ext() {}, clear() {}, drain() { return []; }, idle() {} };
  let t = 1000;
  const lk = Link.create({
    tables: L, core: { port, read: () => 0 }, transport, role: 'a', rom: ROM, name: 'ALPHA',
    now: () => t, ui: { accept: () => new Promise((r) => { answer = r; }) }, ...opts,
  });
  const peer = (m) => transport.onmessage(JSON.stringify(m));
  peer({ type: 'hello', lk: Link.PROTOCOL, rom: ROM, build: 'x', core: 'y', name: 'BRAVO', role: 'b' });
  return { lk, sent, peer, answer: (y) => answer(y), tick: (ms) => { t += ms; } };
}
const byes = (s) => s.sent.filter((m) => m.type === 'bye').map((m) => m.reason);
const logOf = (s, e) => s.lk.state().log.filter((x) => x.e === e);
{
  const s = session();
  check('held: accepting after the peer hello', s.lk.state().session === 'accepting');
  for (let i = 0; i < 5; i++) { s.peer({ type: 'desk', left: 9000 - i * 500 }); s.tick(500); }
  s.peer({ type: 'abort', stage: 'desk' });
  s.peer({ type: 'desk', left: 12000 });
  s.peer({ type: 'ping', t: 1 });
  const st = s.lk.state();
  check('held: desk/abort while accepting are held, not refused', st.session === 'accepting' && !byes(s).length, JSON.stringify(byes(s)));
  check('held: consecutive desks coalesce (5 desks, abort, desk -> 3)', st.held === 3, st.held);
  check('held: a ping is still answered while accepting', s.sent.some((m) => m.type === 'pong'));
  s.answer(true);
  await Promise.resolve();
  const st2 = s.lk.state();
  const rp = logOf(s, 'held-replay');
  check('held: replayed in order at link-up', st2.session === 'linked' && st2.held === 0 && rp.length === 1 && rp[0].n === 3
    && st2.peerStage === 'desk' && !byes(s).length, JSON.stringify({ s: st2.session, held: st2.held, rp, peer: st2.peerStage, byes: byes(s) }));
}
{
  const s = session();
  for (let i = 0; i < 200; i++) s.peer(i % 2 ? { type: 'abort', stage: 'desk' } : { type: 'desk', left: 5000 });
  const st = s.lk.state();
  check('held: bounded at 64, oldest dropped with a log note', st.held <= 64 && logOf(s, 'held-dropped').length > 0 && !byes(s).length,
    JSON.stringify({ held: st.held, dropped: logOf(s, 'held-dropped').length }));
  s.answer(true);
  await Promise.resolve();
  check('held: after overflow the replay starts at a desk (no protocol error)', s.lk.state().session === 'linked' && !byes(s).length,
    JSON.stringify({ s: s.lk.state().session, byes: byes(s) }));
}
{
  const s = session();
  s.peer({ type: 'desk', left: 5000 });
  s.answer(false);
  await Promise.resolve();
  const st = s.lk.state();
  check('held: Decline drops the held messages', st.session === 'closed' && st.held === 0 && JSON.stringify(byes(s)) === '["user"]',
    JSON.stringify({ s: st.session, held: st.held, byes: byes(s) }));
}
{
  const s = session();
  s.peer({ type: 'rcpt' });
  s.answer(true);
  await Promise.resolve();
  check('held: a hostile out-of-order message still fails, at replay', JSON.stringify(byes(s)) === '["internal"]', JSON.stringify(byes(s)));
}

const hostileN = CASES.filter((c) => c[2] !== null).length + 1;
console.log(`\n${fail ? 'FAIL' : 'PASS'} link_unit: ${pass}/${pass + fail} checks (${hostileN} hostile validator cases, ${GARBAGE.length + 1} garbage inputs)`);
process.exit(fail ? 1 : 0);
