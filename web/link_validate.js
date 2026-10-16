/* Pyrite link: the client-side validator for a peer's link blocks
   (docs/LK1-LINK.md section 5; LK1c).

   validateBlocks(L, blocks, {mode}) -> {ok, reasons}
     L       tables.json's "link" section (gen_tables.py); no address or limit
             is hard-coded here.
     blocks  {rn, party, patch, mail}: Uint8Array/Array, exactly as the peer's
             game laid them out in its own WRAM (wLinkBattleRNPreamble,
             wLinkSendParty, wPlayerPatchLists, wLinkSendMail), i.e. the bytes
             that would have gone over a cable, $FE already patched out.
     mode    LINK_TRADECENTER (2) or LINK_COLOSSEUM (3); the Colosseum sends
             no mail block (length 0).
   validateAct(L, phase, v, peerCount) -> boolean
     one nybble from an act message against the stand-in's phase model.

   Never throws: any exception inside a rule is caught and reported as a
   reason.  A block is rejected for anything a native sender cannot produce
   AND for anything that would let the receiving game index outside its
   buffers (patch offsets, mail patch offsets, counts).  The stand-in
   (link.js) aborts the link through the game's own link-closed path when
   this returns ok:false, so the ROM never sees a rejected block. */
(function (root, factory) {
  'use strict';
  const api = factory();
  if (typeof module === 'object' && module.exports) module.exports = api;
  else root.PyriteLinkValidate = api;
}(typeof self !== 'undefined' ? self : this, function () {
  'use strict';

  const TERM = 0x50, NEXT_LINE = 0x4e, FD = 0xfd, FE = 0xfe, FF = 0xff;

  function u8(x) {
    if (x instanceof Uint8Array) return x;
    if (Array.isArray(x) && x.every((b) => Number.isInteger(b) && b >= 0 && b <= 255)) return Uint8Array.from(x);
    return null;
  }
  const be16 = (b, i) => (b[i] << 8) | b[i + 1];
  const be24 = (b, i) => (b[i] << 16) | (b[i + 1] << 8) | b[i + 2];

  /* A game string field of `len` bytes: a $50 inside the field, a first byte
     that is a glyph, every byte before the $50 a glyph ($60-$FF except $FE). */
  function nameOk(L, b, off, len) {
    const glyph = (c) => c >= L.glyphMin && c !== FE;
    let end = -1;
    for (let i = 0; i < len; i++) if (b[off + i] === TERM) { end = i; break; }
    if (end <= 0) return end === 0 ? 'empty' : 'no terminator';
    if (!L.glyphs.includes(b[off]) || !glyph(b[off])) return 'first byte not a glyph';
    for (let i = 0; i < end; i++) if (!glyph(b[off + i])) return `byte ${i} $${b[off + i].toString(16)}`;
    return null;
  }

  function maxPP(base, ups) { return base + ups * Math.min(Math.floor(base / 5), 7); }
  const STATUS_OK = (s) => s === 0 || (s >= 1 && s <= 7) || s === 0x08 || s === 0x10 || s === 0x20 || s === 0x40;

  /* One 48-byte party_struct (with $FE restored), list entry `listSp`. */
  function monReasons(L, m, listSp, tag) {
    const M = L.mon, out = [];
    const r = (s) => out.push(`${tag}.${s}`);
    const sp = m[M.species];
    if (sp < 1 || sp > L.numSpecies) r(`species $${sp.toString(16)}`);
    if (listSp !== L.egg && listSp !== sp) r(`species $${sp.toString(16)} != list $${listSp.toString(16)}`);
    const item = m[M.item];
    if (item !== 0 && !L.holdable.includes(item)) r(`item $${item.toString(16)}`);
    const moves = Array.from(m.slice(M.moves, M.moves + L.numMovesPerMon));
    if (moves[0] === 0) r('move1 empty');
    let seenEmpty = false;
    moves.forEach((mv, k) => {
      const pp = m[M.pp + k];
      if (mv === 0) { seenEmpty = true; if (pp !== 0) r(`pp${k + 1} on empty slot`); return; }
      if (seenEmpty) r(`move${k + 1} after an empty slot`);
      if (mv > L.numMoves) r(`move${k + 1} $${mv.toString(16)}`);
      else if (moves.indexOf(mv) !== k) r(`move${k + 1} duplicate`);
      else if ((pp & 0x3f) > maxPP(L.movePP[mv - 1], pp >> 6)) r(`pp${k + 1} ${pp & 0x3f} > ${maxPP(L.movePP[mv - 1], pp >> 6)}`);
    });
    const lvl = m[M.level];
    if (lvl < 1 || lvl > L.maxLevel) r(`level ${lvl}`);
    else if (sp >= 1 && sp <= L.numSpecies) {
      const t = L.expTable[L.speciesGrowth[sp - 1]];
      const exp = be24(m, M.exp);
      const hi = t[L.maxLevel];
      const lo = t[lvl] > hi ? 0 : t[lvl];        // Medium Slow wraps below level 2 (24-bit)
      if (exp < lo || exp > hi) r(`exp ${exp} outside ${lo}..${hi}`);
    }
    const hp = be16(m, M.hp), maxHp = be16(m, M.maxHp);
    if (hp > maxHp) r(`hp ${hp} > max ${maxHp}`);
    for (let k = 0; k < 6; k++) {
      const s = be16(m, M.maxHp + 2 * k);
      if (s > L.maxStatValue) r(`stat${k} ${s}`);
    }
    if (!STATUS_OK(m[M.status])) r(`status $${m[M.status].toString(16)}`);
    const pk = m[M.pokerus];
    if ((pk & 0x0f) > 4) r(`pokerus days ${pk & 0x0f}`);
    else if ((pk & 0x0f) && !(pk >> 4)) r('pokerus days without strain');
    return out;
  }

  function rnReasons(L, rn) {
    const S = L.serial, out = [];
    if (rn.length !== S.SERIAL_RN_PREAMBLE_LENGTH + S.SERIAL_RNS_LENGTH) return [`rn.length ${rn.length}`];
    for (let i = 0; i < S.SERIAL_RN_PREAMBLE_LENGTH; i++) if (rn[i] !== FD) { out.push(`rn.preamble[${i}]`); break; }
    for (let i = S.SERIAL_RN_PREAMBLE_LENGTH; i < rn.length; i++) if (rn[i] >= FD) { out.push(`rn[${i}] $${rn[i].toString(16)}`); break; }
    return out;
  }

  /* Patch lists -> list of absolute party-block offsets carrying $FE, or a
     reason string.  Layout: 3 x $FD, zeros up to the first list, list 1
     (offsets 1..SERIAL_PATCH_DATA_SIZE, strictly increasing) $FF, list 2
     (offsets into the second part) $FF, zeros. */
  function patchOffsets(L, patch, party) {
    const S = L.serial, P = L.partyLayout;
    if (patch.length !== S.SERIAL_PATCH_LIST_LENGTH) return `patch.length ${patch.length}`;
    let i = 0;
    for (; i < S.SERIAL_PATCH_PREAMBLE_LENGTH; i++) if (patch[i] !== FD) return `patch.preamble[${i}]`;
    // Native: zeros after the preamble until the first list entry/terminator
    // (FixDataForLinkTransfer writes the lists at a fixed offset).
    const listStart = S.SERIAL_PATCH_PREAMBLE_LENGTH + 7;
    for (; i < listStart; i++) if (patch[i] !== 0) return `patch[${i}] not zero`;
    const base1 = P.id - 1;                                   // offset 1 -> first patched byte (player ID)
    const size1 = S.SERIAL_PATCH_DATA_SIZE;
    const size2 = P.ots - (P.id + size1);                     // rest of the mon structs
    const out = [];
    for (const [k, base, size] of [[1, base1, size1], [2, base1 + size1, size2]]) {
      let last = 0;
      for (;;) {
        if (i >= patch.length) return `patch list ${k} unterminated`;
        const c = patch[i++];
        if (c === FF) break;
        if (c < 1 || c > size) return `patch list ${k} offset ${c} out of range`;
        if (c <= last) return `patch list ${k} not increasing at ${c}`;
        last = c;
        if (party[base + c] !== FF) return `patch list ${k} offset ${c} -> party[${base + c}] is $${party[base + c].toString(16)}, not $FF`;
        out.push(base + c);
      }
    }
    for (; i < patch.length; i++) if (patch[i] !== 0) return `patch[${i}] not zero after the lists`;
    return out;
  }

  function partyReasons(L, party, patch) {
    const P = L.partyLayout, S = L.serial, out = [];
    if (party.length !== P.padding + 3) return [`party.length ${party.length}`];
    for (let i = 0; i < S.SERIAL_PREAMBLE_LENGTH; i++) if (party[i] !== FD) return [`party.preamble[${i}]`];
    for (let i = P.name; i < P.padding; i++) if (party[i] === FE) return [`party[${i}] raw $FE`];
    let n;
    if ((n = nameOk(L, party, P.name, L.nameLength))) out.push(`party.name ${n}`);
    const count = party[P.count];
    if (count < 1 || count > L.partyLength) return out.concat(`party.count ${count}`);
    if (party[P.species + count] !== FF) out.push(`party.species[${count}] not $FF`);
    const offs = patchOffsets(L, patch, party);
    if (typeof offs === 'string') return out.concat(offs);
    const fixed = Uint8Array.from(party);
    for (const o of offs) fixed[o] = FE;
    for (let i = 0; i < count; i++) {
      const sp = party[P.species + i];
      if (!(sp >= 1 && sp <= L.numSpecies) && sp !== L.egg) { out.push(`party.species[${i}] $${sp.toString(16)}`); continue; }
      const m = fixed.slice(P.mons + i * L.monStride, P.mons + (i + 1) * L.monStride);
      out.push(...monReasons(L, m, sp, `party.mon[${i}]`));
      if ((n = nameOk(L, party, P.ots + i * L.nameLength, L.nameLength))) out.push(`party.ot[${i}] ${n}`);
      if ((n = nameOk(L, party, P.nicks + i * L.monNameLength, L.monNameLength))) out.push(`party.nick[${i}] ${n}`);
    }
    return out;
  }

  /* Mail: 5 x $20, 6 messages of 33, 6 metadata of 14, a 103-byte patch set
     for the metadata.  Only slots whose mon holds a mail item are read by the
     game (the others are inert), so only those are checked; the framing and
     the patch set are always checked (the patch set writes memory). */
  function mailReasons(L, mail, party) {
    const S = L.serial, M = L.mailLayout, P = L.partyLayout, out = [];
    const len = M.patch + M.patchLength;
    if (mail.length !== len) return [`mail.length ${mail.length}`];
    for (let i = 0; i < S.SERIAL_MAIL_PREAMBLE_LENGTH; i++) if (mail[i] !== S.SERIAL_MAIL_PREAMBLE_BYTE) return [`mail.preamble[${i}]`];
    const first = mail[M.messages];
    if (first === S.SERIAL_MAIL_PREAMBLE_BYTE || first === FE) return [`mail.messages[0] starts with $${first.toString(16)}`];
    for (let i = M.messages; i < M.patch; i++) if (mail[i] === FE) return [`mail[${i}] raw $FE`];
    const metaLen = L.partyLength * M.metaLength;
    const meta = Uint8Array.from(mail.slice(M.metadata, M.metadata + metaLen));
    let i = M.patch, ok = false;
    for (; i < len; i++) {
      const c = mail[i];
      if (c === FF) { ok = true; i++; break; }
      if (c < 1 || c > metaLen) return [`mail.patch offset ${c} out of range`];
      if (meta[c - 1] !== FF) return [`mail.patch offset ${c} -> $${meta[c - 1].toString(16)}, not $FF`];
      meta[c - 1] = FE;
    }
    if (!ok) return ['mail.patch unterminated'];
    const count = party[P.count];
    for (let s = 0; s < Math.min(count, L.partyLength); s++) {
      const item = party[P.mons + s * L.monStride + L.mon.item];
      if (!L.mailItems.includes(item)) continue;
      const mo = M.messages + s * M.msgLength;
      let end = -1;
      for (let k = 0; k < M.msgLength; k++) if (mail[mo + k] === TERM) { end = k; break; }
      if (end < 0) out.push(`mail[${s}].message no terminator`);
      else {
        for (let k = 0; k < end; k++) {
          const c = mail[mo + k];
          if (!(c === NEXT_LINE || c === S.SERIAL_MAIL_REPLACEMENT_BYTE || c >= L.glyphMin)) { out.push(`mail[${s}].message byte ${k} $${c.toString(16)}`); break; }
        }
      }
      const md = s * M.metaLength;
      let n;
      if ((n = nameOk(L, meta, md + M.author, M.authorLength))) out.push(`mail[${s}].author ${n}`);
      const sp = meta[md + M.species];
      if (sp < 1 || sp > L.numSpecies) out.push(`mail[${s}].species $${sp.toString(16)}`);
      if (!L.mailItems.includes(meta[md + M.type])) out.push(`mail[${s}].type $${meta[md + M.type].toString(16)}`);
    }
    return out;
  }

  function validateBlocks(L, blocks, opts) {
    const reasons = [];
    try {
      const mode = opts && opts.mode;
      const S = L.serial;
      if (mode !== S.LINK_TRADECENTER && mode !== S.LINK_COLOSSEUM) return { ok: false, reasons: [`mode ${mode}`] };
      if (!blocks || typeof blocks !== 'object') return { ok: false, reasons: ['no blocks'] };
      const rn = u8(blocks.rn), party = u8(blocks.party), patch = u8(blocks.patch), mail = u8(blocks.mail);
      if (!rn || !party || !patch || !mail) return { ok: false, reasons: ['blocks not byte arrays'] };
      reasons.push(...rnReasons(L, rn));
      reasons.push(...partyReasons(L, party, patch));
      if (mode === S.LINK_TRADECENTER) {
        if (party.length === L.partyLayout.padding + 3) reasons.push(...mailReasons(L, mail, party));
      } else if (mail.length !== 0) reasons.push(`mail.length ${mail.length} in the Colosseum`);
    } catch (e) {
      reasons.push(`internal: ${e && e.message}`);
    }
    return { ok: reasons.length === 0, reasons };
  }

  /* phase: 'S0' | 'S1' | 'S2' | 'battle'. */
  function validateAct(L, phase, v, peerCount) {
    try {
      if (!Number.isInteger(v) || v < 0 || v > 15) return false;
      const B = L.battle;
      switch (phase) {
        case 'S0': return v === 0x0f || (v < peerCount && v < L.partyLength);
        case 'S1': return v === 1 || v === 2;
        case 'S2': return v === 0 || v === 1 || v === 2;
        case 'battle':
          return (v >= B.BATTLEACTION_MOVE1 && v < B.BATTLEACTION_MOVE1 + L.numMovesPerMon)
            || (v >= B.BATTLEACTION_SWITCH1 && v < B.BATTLEACTION_SWITCH1 + Math.min(peerCount, L.partyLength))
            || v === B.BATTLEACTION_SKIPTURN || v === B.BATTLEACTION_STRUGGLE || v === B.BATTLEACTION_FORFEIT;
        default: return false;
      }
    } catch (e) { return false; }
  }

  return { validateBlocks, validateAct, nameOk, maxPP, patchOffsets };
}));
