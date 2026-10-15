CheckPartyFullAfterContest:
	ld a, [wContestMonSpecies]
	and a
	jp z, .DidntCatchAnything
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call GetBaseData
	ld hl, wPartyCount
	ld a, [hl]
	cp PARTY_LENGTH
	jp nc, .TryAddToBox
	inc a
	ld [hl], a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wContestMonSpecies]
	ld [hli], a
	ld [wCurSpecies], a
	ld a, -1
	ld [hl], a
	ld hl, wPartyMon1Species
	ld a, [wPartyCount]
	dec a
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, wContestMon
	ld bc, PARTYMON_STRUCT_LENGTH
	call CopyBytes
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMonOTs
	call SkipNames
	ld d, h
	ld e, l
	ld hl, wPlayerName
	call CopyBytes
	ld a, [wCurPartySpecies]
	ld [wNamedObjectIndex], a
	call GetPokemonName
	ld hl, wStringBuffer1
	ld de, wMonOrItemNameBuffer
	ld bc, MON_NAME_LENGTH
	call CopyBytes
	call GiveANickname_YesNo
	jr c, .Party_SkipNickname
	ld a, [wPartyCount]
	dec a
	ld [wCurPartyMon], a
	xor a
	ld [wMonType], a
	ld de, wMonOrItemNameBuffer
	callfar InitNickname

.Party_SkipNickname:
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMonNicknames
	call SkipNames
	ld d, h
	ld e, l
	ld hl, wMonOrItemNameBuffer
	call CopyBytes
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1Level
	call GetPartyLocation
	ld a, [hl]
	ld [wCurPartyLevel], a
	call SetCaughtData
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1CaughtLocation
	call GetPartyLocation
	ld a, [hl]
	and CAUGHT_GENDER_MASK
	ld b, LANDMARK_NATIONAL_PARK
	or b
	ld [hl], a
	xor a
	ld [wContestMonSpecies], a
	and a ; BUGCONTEST_CAUGHT_MON
	ld [wScriptVar], a
	ret

.TryAddToBox:
	ld a, BANK(sBoxCount)
	call OpenSRAM
	ld hl, sBoxCount
	ld a, [hl]
	cp MONS_PER_BOX
	call CloseSRAM
	jr nc, .BoxFull
	xor a
	ld [wCurPartyMon], a
	ld hl, wContestMon
	ld de, wBufferMon
	ld bc, BOXMON_STRUCT_LENGTH
	call CopyBytes
	ld hl, wPlayerName
	ld de, wBufferMonOT
	ld bc, NAME_LENGTH
	call CopyBytes
	callfar InsertPokemonIntoBox
	ld a, [wCurPartySpecies]
	ld [wNamedObjectIndex], a
	call GetPokemonName
	call GiveANickname_YesNo
	ld hl, wStringBuffer1
	jr c, .Box_SkipNickname
	ld a, BOXMON
	ld [wMonType], a
	ld de, wMonOrItemNameBuffer
	callfar InitNickname
	ld hl, wMonOrItemNameBuffer

.Box_SkipNickname:
	ld a, BANK(sBoxMonNicknames)
	call OpenSRAM
	ld de, sBoxMonNicknames
	ld bc, MON_NAME_LENGTH
	call CopyBytes
	call CloseSRAM

.BoxFull:
	ld a, BANK(sBoxMon1Level)
	call OpenSRAM
	ld a, [sBoxMon1Level]
	ld [wCurPartyLevel], a
	call CloseSRAM
	call SetBoxMonCaughtData
	ld a, BANK(sBoxMon1CaughtLocation)
	call OpenSRAM
	ld hl, sBoxMon1CaughtLocation
	ld a, [hl]
	and CAUGHT_GENDER_MASK
	ld b, LANDMARK_NATIONAL_PARK
	or b
	ld [hl], a
	call CloseSRAM
	xor a
	ld [wContestMon], a
	ld a, BUGCONTEST_BOXED_MON
	ld [wScriptVar], a
	ret

.DidntCatchAnything:
	ld a, BUGCONTEST_NO_CATCH
	ld [wScriptVar], a
	ret

GiveANickname_YesNo:
	ld hl, CaughtAskNicknameText
	call PrintText
	jp YesNoBox

CaughtAskNicknameText:
	text_far _CaughtAskNicknameText
	text_end

SetCaughtData:
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1CaughtLevel
	call GetPartyLocation
SetBoxmonOrEggmonCaughtData:
; GF2 (docs/GENDER-FIELD.md): bits 7-6 of the CaughtLevel byte are the mon's
; gender, no longer the time of day.  Keep an explicit gender already in [hl]
; (TryAddMonToParty/SendMonIntoBox copy the wild roll there; a hatching egg
; carries its own), turn a non-explicit %01 into %00, and store the level in
; bits 5-0, clamped to 63: a Lv64+ catch used to spill into bits 7-6.
	ld a, [hl]
	and CAUGHT_GENDER_BITS
	bit CAUGHT_GENDER_EXPLICIT_F, a
	jr nz, .got_gender
	xor a
.got_gender
	ld b, a
	ld a, [wCurPartyLevel]
	cp CAUGHT_LEVEL_MAX + 1
	jr c, .got_level
	ld a, CAUGHT_LEVEL_MAX
.got_level
	or b
	ld [hli], a
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
	cp MAP_POKECENTER_2F
	jr nz, .NotPokecenter2F
	ld a, b
	cp GROUP_POKECENTER_2F
	jr nz, .NotPokecenter2F

	ld a, [wBackupMapGroup]
	ld b, a
	ld a, [wBackupMapNumber]
	ld c, a

.NotPokecenter2F:
	call GetWorldMapLocation
	ld b, a
	ld a, [wPlayerGender]
	rrca ; shift bit 0 (PLAYERGENDER_FEMALE_F) to bit 7 (CAUGHT_GENDER_MASK)
	or b
	ld [hl], a
	ret

SetBoxMonCaughtData:
	ld a, BANK(sBoxMon1CaughtLevel)
	call OpenSRAM
	ld hl, sBoxMon1CaughtLevel
	call SetBoxmonOrEggmonCaughtData
	call CloseSRAM
	ret

SetGiftBoxMonCaughtData:
	push bc
	ld a, BANK(sBoxMon1CaughtLevel)
	call OpenSRAM
	ld hl, sBoxMon1CaughtLevel
	pop bc
	call SetGiftMonCaughtData
	call CloseSRAM
	ret

SetGiftPartyMonCaughtData:
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1CaughtLevel
	push bc
	call GetPartyLocation
	pop bc
SetGiftMonCaughtData:
	xor a
	ld [hli], a
	ld a, LANDMARK_GIFT
	rrc b
	or b
	ld [hl], a
	ret

SetEggMonCaughtData:
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1CaughtLevel
	call GetPartyLocation
	ld a, [wCurPartyLevel]
	push af
	ld a, CAUGHT_EGG_LEVEL
	ld [wCurPartyLevel], a
	call SetBoxmonOrEggmonCaughtData
	pop af
	ld [wCurPartyLevel], a
	ret

; GF3 (docs/GENDER-FIELD.md, "GF3 findings"): the explicit gender for mons that
; are not caught in a wild battle -- gifts, eggs, the Day-Care's egg, the Odd
; Egg -- and for a link opponent's mons.  Wild battles roll in RollWildGender.

DayCareEggGender:
; DayCare_InitBreeding (bank $05): roll the egg's gender (wCurPartySpecies =
; the egg species) into wTempMonCaughtLevel and wEggMonCaughtLevel.  A
; wrapper because farcall does not return a (ReturnFarCall reloads it).
; Preserves bc, de and hl.
	call GenderBitsForCurPartySpecies
	ld [wTempMonCaughtLevel], a
	ld [wEggMonCaughtLevel], a
	ret

GenderBitsForCurPartySpecies:
	ld a, [wCurPartySpecies]
GenderBitsForSpecies:
; a = species -> a = CaughtLevel bits 7-6: %10 male / %11 female, rolled with
; RollWildGender's formula for a mixed-ratio species; 0 (derive from the DVs,
; which the species' ratio decides anyway) for genderless, F0 and F100 ones.
; Reads the ratio straight from BaseData, so the loaded base data and
; wCurSpecies are untouched.  Preserves bc, de and hl.
	push hl
	push de
	push bc
	dec a
	ld hl, BaseData + BASE_GENDER
	ld bc, BASE_DATA_SIZE
	call AddNTimes
	ld a, BANK(BaseData)
	call GetFarByte
	and a ; GENDER_F0
	jr z, .unset
	cp GENDER_F100
	jr nc, .unset ; GENDER_F100 or GENDER_UNKNOWN
	ld b, a
	call Random ; a = hRandomSub
	swap a
	ld c, a
	ldh a, [hRandomAdd]
	xor c
	ld c, a ; r = swap(hRandomSub) ^ hRandomAdd
	ld a, b
	cp c ; nc iff r <= ratio
	ld a, CAUGHT_GENDER_EXPLICIT
	jr c, .done
	or CAUGHT_GENDER_FEMALE
	jr .done
.unset
	xor a
.done
	pop bc
	pop de
	pop hl
	ret

GivenMonGenderBits:
; a = the gender bits for a GivePoke/GiveShuckle mon of species wCurPartySpecies.
; The OAK'S LAB PIKACHU (PK1_StarterDVsOrRandom left the state pending) takes
; the gender Oak's tutorial PIKACHU rolled; everything else rolls.
; Preserves bc, de and hl.
	ld a, [wCurPartySpecies]
	cp PIKACHU
	jr nz, GenderBitsForSpecies
	ld a, [wPK1StarterDVsState]
	cp PK1_STARTER_GENDER_PENDING
	ld a, PIKACHU
	jr nz, GenderBitsForSpecies
	xor a
	ld [wPK1StarterDVsState], a
	ld a, [wPK1StarterGender]
	ret

SetGivenPartyMonCaughtData:
; GivePoke's SetCaughtData, with the gender rolled first (SetCaughtData keeps an
; explicit gender), so the nickname prompt that follows already shows it.
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1CaughtLevel
	call GetPartyLocation
	call GivenMonGenderBits
	ld [hl], a
	jp SetBoxmonOrEggmonCaughtData

SetGivenBoxMonCaughtData:
; GivePoke's SetBoxMonCaughtData, with the gender rolled first.
	call GivenMonGenderBits
	ld b, a
	ld a, BANK(sBoxMon1CaughtLevel)
	call OpenSRAM
	ld hl, sBoxMon1CaughtLevel
	ld [hl], b
	call SetBoxmonOrEggmonCaughtData
	jp CloseSRAM

SetGiftPartyMonCaughtDataRolled:
; SetGiftPartyMonCaughtData (b = the OT gender flag) plus a rolled gender in the
; CaughtLevel byte, whose level stays 0 ("unknown"), as for every gift.
	call SetGiftPartyMonCaughtData ; hl -> CaughtLocation
	dec hl
	call GivenMonGenderBits
	ld [hl], a
	ret

SetGiftBoxMonCaughtDataRolled:
; SetGiftBoxMonCaughtData (b = the OT gender flag) plus a rolled gender.
	call SetGiftBoxMonCaughtData
	call GivenMonGenderBits
	ld b, a
	ld a, BANK(sBoxMon1CaughtLevel)
	call OpenSRAM
	ld a, b
	ld [sBoxMon1CaughtLevel], a
	jp CloseSRAM

GiveEggGender:
; GiveEgg (the giveegg script command): roll the gender of the egg it just put
; last in the party.  Its species is wCurPartySpecies (GiveEgg restored it).
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1CaughtLevel
	call GetPartyLocation
	call GenderBitsForCurPartySpecies
	ld b, a
	ld a, [hl]
	and CAUGHT_LEVEL_MASK
	or b
	ld [hl], a
	ret

OddEggGender:
; _GiveOddEgg: roll the gender of the Odd Egg in wOddEgg before it joins the
; party.  Its DVs (and so its shininess) stay the table's.
	ld a, [wOddEggSpecies]
	call GenderBitsForSpecies
	ld b, a
	ld a, [wOddEggCaughtLevel]
	and CAUGHT_LEVEL_MASK
	or b
	ld [wOddEggCaughtLevel], a
	ret

LinkEnemyMonGender:
; InitEnemyMon (link and Battle Tower battles): the enemy's gender byte is the
; OT party mon's explicit gender, so that a pyrite opponent's mon has the same
; gender on both Game Boys (Attract, the HUD).  Anything but %10/%11 is %00:
; derive it from the DVs, as before (Battle Tower data has 0 there).
	ld a, [wCurPartyMon]
	ld hl, wOTPartyMon1CaughtLevel
	call GetPartyLocation
	ld a, [hl]
	and CAUGHT_GENDER_BITS
	bit CAUGHT_GENDER_EXPLICIT_F, a
	jr nz, .got_gender
	xor a
.got_gender
	ld [wEnemyMonStatus + 1], a
	ret
