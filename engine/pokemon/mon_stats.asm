DrawPlayerHP:
	ld a, $1
	jr DrawHP

DrawEnemyHP:
	ld a, $2

DrawHP:
	ld [wWhichHPBar], a
	push hl
	push bc
	; box mons have full HP
	ld a, [wMonType]
	cp BOXMON
	jr z, .at_least_1_hp

	ld a, [wTempMonHP]
	ld b, a
	ld a, [wTempMonHP + 1]
	ld c, a

; Any HP?
	or b
	jr nz, .at_least_1_hp

	xor a
	ld c, a
	ld e, a
	ld a, 6
	ld d, a
	jp .fainted

.at_least_1_hp
	ld a, [wTempMonMaxHP]
	ld d, a
	ld a, [wTempMonMaxHP + 1]
	ld e, a
	ld a, [wMonType]
	cp BOXMON
	jr nz, .not_boxmon

	ld b, d
	ld c, e

.not_boxmon
	predef ComputeHPBarPixels
	ld a, 6
	ld d, a
	ld c, a

.fainted
	ld a, c
	pop bc
	ld c, a
	pop hl
	push de
	push hl
	push hl
	call DrawBattleHPBar
	pop hl

; Print HP
	bccoord 1, 1, 0
	add hl, bc
	ld de, wTempMonHP
	ld a, [wMonType]
	cp BOXMON
	jr nz, .not_boxmon_2
	ld de, wTempMonMaxHP
.not_boxmon_2
	lb bc, 2, 3
	call PrintNum

	ld a, '/'
	ld [hli], a

; Print max HP
	ld de, wTempMonMaxHP
	lb bc, 2, 3
	call PrintNum
	pop hl
	pop de
	ret

PrintTempMonStats:
; Print wTempMon's stats at hl, with spacing bc.
	push bc
	push hl
	ld de, .StatNames
	call PlaceString
	pop hl
	pop bc
	add hl, bc
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld de, wTempMonAttack
	lb bc, 2, 3
	call .PrintStat
	ld de, wTempMonDefense
	call .PrintStat
	ld de, wTempMonSpclAtk
	call .PrintStat
	ld de, wTempMonSpclDef
	call .PrintStat
	ld de, wTempMonSpeed
	jp PrintNum

.PrintStat:
	push hl
	call PrintNum
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	ret

.StatNames:
	db   "ATTACK"
	next "DEFENSE"
	next "SPCL.ATK"
	next "SPCL.DEF"
	next "SPEED"
	next "@"

GetEnemyMonGender:
; GF2: gender of the active enemy mon (battle HUD, Attract).  Builds a TEMPMON
; from wEnemyMonDVs (wEnemyBackupDVs while transformed, so a Transform does not
; change it) plus the rolled gender byte wEnemyMonStatus + 1, so no stale
; wTempMonCaughtLevel can leak in.  Same return values as GetGender.
	ld hl, wEnemyMonDVs
	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jr z, .got_dvs
	ld hl, wEnemyBackupDVs
.got_dvs
	ld a, [hli]
	ld [wTempMonDVs], a
	ld a, [hl]
	ld [wTempMonDVs + 1], a
	ld a, [wEnemyMonStatus + 1]
	ld [wTempMonCaughtLevel], a
	ld a, TEMPMON
	ld [wMonType], a
	; fallthrough

GetGender:
; Return the gender of a given monster (wCurPartyMon/wCurOTMon/wCurWildMon).
; When calling this function, a should be set to an appropriate wMonType value.

; return values:
; a = 1: f = nc|nz; male
; a = 0: f = nc|z;  female
;        f = c:  genderless

; GF2: for a mixed-ratio species, an explicit gender in bits 7-6 of the
; struct's CaughtLevel byte (wEnemyMonStatus + 1 for WILDMON) wins; otherwise
; it is determined by comparing the Attack and Speed DVs with the species'
; gender ratio, exactly as before.

; Figure out what type of monster struct we're looking at.

; 0: PartyMon
	ld hl, wPartyMon1DVs
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wMonType]
	and a
	jr z, .PartyMon

; 1: OTPartyMon
	ld hl, wOTPartyMon1DVs
	dec a
	jr z, .PartyMon

; 2: sBoxMon
	ld hl, sBoxMon1DVs
	ld bc, BOXMON_STRUCT_LENGTH
	dec a
	jr z, .sBoxMon

; 3: Unknown
	ld hl, wTempMonDVs
	dec a
	jr z, .DVs

; else: WildMon
	ld hl, wEnemyMonDVs
	jr .DVs

; Get our place in the party/box.

.PartyMon:
.sBoxMon
	ld a, [wCurPartyMon]
	call AddNTimes

.DVs:
; sBoxMon data is read directly from SRAM.
	ld a, [wMonType]
	cp BOXMON
	ld a, BANK(sBox)
	call z, OpenSRAM

; Attack DV
	ld a, [hli]
	and $f0
	ld b, a
; Speed DV
	ld a, [hl]
	and $f0
	swap a

; Put our DVs together.
	or b
	ld b, a

; GF2: c = the gender byte, read while SRAM is still open for a sBoxMon.
; party/box/temp structs: CaughtLevel = DVs + 8; WILDMON: wEnemyMonStatus + 1.
	ld a, [wMonType]
	cp WILDMON
	ld a, MON_CAUGHTLEVEL - (MON_DVS + 1)
	jr c, .got_gender_offset
	ld a, (wEnemyMonStatus + 1) - (wEnemyMonDVs + 1)
.got_gender_offset
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	ld c, [hl]

; Close SRAM if we were dealing with a sBoxMon.
	ld a, [wMonType]
	cp BOXMON
	call z, CloseSRAM

; We need the gender ratio to do anything with this.
	push bc
	ld a, [wCurPartySpecies]
	dec a
	ld hl, BaseData + BASE_GENDER
	ld bc, BASE_DATA_SIZE
	call AddNTimes
	pop bc

	ld a, BANK(BaseData)
	call GetFarByte

; The higher the ratio, the more likely the monster is to be female.

	cp GENDER_UNKNOWN
	jr z, .Genderless

	and a ; GENDER_F0?
	jr z, .Male

	cp GENDER_F100
	jr z, .Female

; GF2: an explicit gender overrides the DVs.
	bit CAUGHT_GENDER_EXPLICIT_F, c
	jr z, .from_dvs
	bit CAUGHT_GENDER_FEMALE_F, c
	jr nz, .Female
	jr .Male

.from_dvs
; Values below the ratio are male, and vice versa.
	cp b
	jr c, .Male

.Female:
	xor a
	ret

.Male:
	ld a, 1
	and a
	ret

.Genderless:
	scf
	ret

RollWildGender:
; GF2: roll the gender of the wild mon LoadEnemyMon just built and store it in
; wEnemyMonStatus + 1 (the battle struct's unused byte): %10 male, %11 female.
; One roll byte r; female iff r <= the species' gender ratio, so F12_5
; (ratio 31) is female 32/256 = 1/8 of the time, F50 (127) 1/2, F75 (191) 3/4.
; r is not Random's return value (hRandomSub) itself but swap(hRandomSub) xor
; hRandomAdd after the call: the DV roll a frame earlier already consumed the
; RNG, and at a fixed button timing hRandomSub here takes only a few top-3-bit
; values for every seed (1 in 8 DIV phases could never give an F12_5 female,
; others gave 1/4).  The swapped low nibble varies with the frame's DIV and
; the add byte decorrelates seeds, so r is ~uniform both over seeds at one
; timing and over timings at one seed (docs/GENDER-FIELD.md, GF2 findings, F5).
; Unset (%00, derive from the DVs) for trainer mons, gifts built through
; LoadEnemyMon outside battle, the catch tutorial, roamers (their struct has
; no room to keep a roll between encounters) and genderless/F0/F100 species.
; The forced-shiny red GYARADOS rolls like any other wild mon.
; wBaseGender is the enemy species' (LoadEnemyMon called GetBaseData).
	ld a, [wBattleMode]
	cp WILD_BATTLE
	jr nz, .unset
	ld a, [wBattleType]
	cp BATTLETYPE_TUTORIAL
	jr z, .unset
	cp BATTLETYPE_ROAMING
	jr z, .unset
	ld a, [wBaseGender]
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
	jr c, .store
	or CAUGHT_GENDER_FEMALE
	jr .store
.unset
	xor a
.store
	ld [wEnemyMonStatus + 1], a
	ret

ListMovePP:
	ld a, [wNumMoves]
	inc a
	ld c, a
	ld a, NUM_MOVES
	sub c
	ld b, a
	push hl
	ld a, [wListMovesLineSpacing]
	ld e, a
	ld d, 0
	ld a, $3e ; P
	call .load_loop
	ld a, b
	and a
	jr z, .skip
	ld c, a
	ld a, '-'
	call .load_loop

.skip
	pop hl
	inc hl
	inc hl
	inc hl
	ld d, h
	ld e, l
	ld hl, wTempMonMoves
	ld b, 0
.loop
	ld a, [hli]
	and a
	jr z, .done
	push bc
	push hl
	push de
	ld hl, wMenuCursorY
	ld a, [hl]
	push af
	ld [hl], b
	push hl
	callfar GetMaxPPOfMove
	pop hl
	pop af
	ld [hl], a
	pop de
	pop hl
	push hl
	ld bc, wTempMonPP - (wTempMonMoves + 1)
	add hl, bc
	ld a, [hl]
	and $3f
	ld [wStringBuffer1 + 4], a
	ld h, d
	ld l, e
	push hl
	ld de, wStringBuffer1 + 4
	lb bc, 1, 2
	call PrintNum
	ld a, '/'
	ld [hli], a
	ld de, wTempPP
	lb bc, 1, 2
	call PrintNum
	pop hl
	ld a, [wListMovesLineSpacing]
	ld e, a
	ld d, 0
	add hl, de
	ld d, h
	ld e, l
	pop hl
	pop bc
	inc b
	ld a, b
	cp NUM_MOVES
	jr nz, .loop

.done
	ret

.load_loop
	ld [hli], a
	ld [hld], a
	add hl, de
	dec c
	jr nz, .load_loop
	ret

; "AP" is german for "PP"
; The german translation uses this instead of the loop above
.load_ap_loop ; unreferenced
	ld [hl], $32 ; A
	inc hl
	ld [hl], $3e ; P
	dec hl
	add hl, de
	dec c
	jr nz, .load_ap_loop
	ret

Unused_PlaceEnemyHPLevel:
	push hl
	push hl
	ld hl, wPartyMonNicknames
	ld a, [wCurPartyMon]
	call GetNickname
	pop hl
	call PlaceString
	call CopyMonToTempMon
	pop hl
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg
	push hl
	ld bc, -12
	add hl, bc
	ld b, 0
	call DrawEnemyHP
	pop hl
	ld bc, 5
	add hl, bc
	push de
	call PrintLevel
	pop de

.egg
	ret

PlaceStatusString:
; Return nz if the status is not OK
	push de
	inc de
	inc de
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	or b
	pop de
	jr nz, PlaceNonFaintStatus
	push de
	ld de, FntString
	call CopyStatusString
	pop de
	ld a, TRUE
	and a
	ret

FntString:
	db "FNT@"

CopyStatusString:
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hl], a
	ret

PlaceNonFaintStatus:
	push de
	ld a, [de]
	ld de, PsnString
	bit PSN, a
	jr nz, .place
	ld de, BrnString
	bit BRN, a
	jr nz, .place
	ld de, FrzString
	bit FRZ, a
	jr nz, .place
	ld de, ParString
	bit PAR, a
	jr nz, .place
	ld de, SlpString
	and SLP_MASK
	jr z, .no_status

.place
	call CopyStatusString
	ld a, TRUE
	and a

.no_status
	pop de
	ret

SlpString: db "SLP@"
PsnString: db "PSN@"
BrnString: db "BRN@"
FrzString: db "FRZ@"
ParString: db "PAR@"

ListMoves:
; List moves at hl, spaced every [wListMovesLineSpacing] tiles.
	ld de, wListMoves_MoveIndicesBuffer
	ld b, 0
.moves_loop
	ld a, [de]
	inc de
	and a
	jr z, .no_more_moves
	push de
	push hl
	push hl
	ld [wCurSpecies], a
	ld a, MOVE_NAME
	ld [wNamedObjectType], a
	call GetName
	ld de, wStringBuffer1
	pop hl
	push bc
	call PlaceString
	pop bc
	ld a, b
	ld [wNumMoves], a
	inc b
	pop hl
	push bc
	ld a, [wListMovesLineSpacing]
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
	pop de
	ld a, b
	cp NUM_MOVES
	jr z, .done
	jr .moves_loop

.no_more_moves
	ld a, b
.nonmove_loop
	push af
	ld [hl], '-'
	ld a, [wListMovesLineSpacing]
	ld c, a
	ld b, 0
	add hl, bc
	pop af
	inc a
	cp NUM_MOVES
	jr nz, .nonmove_loop

.done
	ret
