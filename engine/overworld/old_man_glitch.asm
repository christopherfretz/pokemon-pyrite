; Kanto hack (OMG1): the Red/Blue Old Man glitch (docs/OLD-MAN-GLITCH.md).
;
; Gen 1 shows the old man's name during his catch tutorial by writing it over
; the player's name, and parks the real name in the wild-grass buffer, which
; no grass-less map (Viridian, Cinnabar, Route 20...) ever reloads.  Surfing
; along Cinnabar's east shore then rolls the grass table: name letters 3/5/7
; become species, 2/4/6 levels, and "@" padding becomes MISSINGNO.
;
; hook A  OMG_ArmLeak      catch tutorial (old man and Oak's demo)
; hook B  OMG_GrassLoaded  LoadWildMonData found a grass/cave table
; hook C  OMG_TryEncounter ChooseWildEncounter, Route 20 x=0 rows 2-13
; hook D  OMG_SawEnemyMon  LoadEnemyMon's "saw this mon" dex flag

DEF OMG_STRIP_X     EQU 0
DEF OMG_STRIP_Y_MIN EQU 2
DEF OMG_STRIP_Y_MAX EQU 13
DEF OMG_LEAK_ITEM   EQU 6 ; the 6th ITEMS-pocket slot gets bit 7 of its quantity
DEF OMG_GEN1_GLITCH EQU $bf ; Gen 1 indices >= this are glitch mons

OMG_ArmLeak::
; Copy wPlayerName+1..+10 into wOldManLeak, every byte after the first "@"
; as "@" (Gen 1's name buffer is "@"-padded), and arm the leak.
	ld hl, wPlayerName
	ld de, wOldManLeak
	ld a, [hli]
	cp '@'
	ld b, 0 ; nonzero once the name has ended
	jr nz, .start
	inc b
.start
	ld c, 10
.loop
	ld a, b
	and a
	ld a, '@'
	jr nz, .put
	ld a, [hl]
	cp '@'
	jr nz, .put
	inc b
.put
	ld [de], a
	inc hl
	inc de
	dec c
	jr nz, .loop
	ld a, 1
	ld [wOldManLeakStale], a
	ret

OMG_GrassLoaded:
; A grass (or cave) wild table replaced the grass buffer: the leak is gone.
; Remember the map, whose table still fills Gen 1 slots 5-9.
	xor a
	ld [wOldManLeakStale], a
	ld a, [wMapGroup]
	ld [wOldManLastGrassMap], a
	ld a, [wMapNumber]
	ld [wOldManLastGrassMap + 1], a
	ret

OMG_TryEncounter:
; Return carry with wTempWildMonSpecies and wCurPartyLevel set when the
; player is surfing the Route 20 strip with the leak armed.
	ld a, [wOldManLeakStale]
	and a
	ret z
	ld a, [wMapGroup]
	cp GROUP_ROUTE_20
	jp nz, .no
	ld a, [wMapNumber]
	cp MAP_ROUTE_20
	jp nz, .no
	ld a, [wXCoord]
	cp OMG_STRIP_X
	jp nz, .no
	ld a, [wYCoord]
	cp OMG_STRIP_Y_MIN
	jp c, .no
	cp OMG_STRIP_Y_MAX + 1
	jp nc, .no
	call CheckOnWater
	jp nz, .no

.roll
	call Random
	ld hl, .SlotThresholds
	ld c, 0
.find
	cp [hl]
	jr c, .got_slot
	jr z, .got_slot
	inc hl
	inc c
	jr .find

.got_slot
	ld a, c
	cp 5
	jr nc, .grass_slot
	; slots 0-4: the leaked name, (level, Gen 1 index) pairs
	add a
	ld e, a
	ld d, 0
	ld hl, wOldManLeak
	add hl, de
	ld a, [hli]
	ld b, a
	ld a, [hl]
	call OMG_Gen1IndexToSpecies
	jr .got_mon

.grass_slot
	; slots 5-9: the last grass map's table, Crystal slots 2-6
	ld a, [wOldManLastGrassMap]
	ld d, a
	ld a, [wOldManLastGrassMap + 1]
	ld e, a
	or d
	jr z, .roll ; no grass map since boot: only the leaked slots exist
	push bc
	ld hl, KantoGrassWildMons
	ld bc, GRASS_WILDDATA_LENGTH
	call LookUpWildmonsForMapDE
	jr c, .found_table
	ld hl, JohtoGrassWildMons
	ld bc, GRASS_WILDDATA_LENGTH
	call LookUpWildmonsForMapDE
.found_table
	pop bc
	jr nc, .roll
	ld de, 2 + 3 ; map group/number, 3 encounter rates
	add hl, de
	ld a, [wTimeOfDay]
	push bc
	ld bc, NUM_GRASSMON * 2
	call AddNTimes
	pop bc
	ld a, c
	sub 5 - 2
	add a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hli]
	ld b, a
	ld a, [hl]

.got_mon
	ld [wTempWildMonSpecies], a
	ld a, b
	ld [wCurPartyLevel], a
	scf
	ret

.no
	and a
	ret

.SlotThresholds:
; Gen 1's grass slot odds out of 256: 51/51/39/25/25/25/13/13/11/3
	db 50, 101, 140, 165, 190, 215, 228, 241, 252, 255

OMG_Gen1IndexToSpecies:
; a = Gen 1 internal index -> a = species.  Index 0, the 39 MissingNo. rows of
; Pokered_MonIndices (which the Time Capsule fills with Gen 2 species) and the
; glitch mons >= $BF all become MISSINGNO., so no Gen 2 species ever leaks.
	and a
	jr z, .missingno
	cp OMG_GEN1_GLITCH
	jr nc, .missingno
	dec a
	ld e, a
	ld d, 0
	ld hl, Pokered_MonIndices
	add hl, de
	ld a, BANK(Pokered_MonIndices)
	call GetFarByte
	cp JOHTO_POKEMON
	ret c
.missingno
	ld a, MISSINGNO
	ret

OMG_SawEnemyMon::
; Replaces LoadEnemyMon's "saw this mon" flag.  MISSINGNO. is never seen;
; instead it sets bit 7 of the 6th item's quantity (Gen 1 sets its dex-seen
; bit, which lands in the bag), and gets Gen 1's WATER GUN x2 + SKY ATTACK.
	ld a, [wTempEnemyMonSpecies]
	cp MISSINGNO
	jr z, .missingno
	dec a
	ld c, a
	ld b, SET_FLAG
	ld hl, wPokedexSeen
	predef_jump SmallFarFlagAction

.missingno
	ld a, [wNumItems]
	cp OMG_LEAK_ITEM
	jr c, .moves
	ld hl, wItems + (OMG_LEAK_ITEM - 1) * 2 + 1
	set 7, [hl]
.moves
	ld hl, wEnemyMonMoves
	ld a, WATER_GUN
	ld [hli], a
	ld [hli], a
	ld a, SKY_ATTACK
	ld [hli], a
	xor a
	ld [hl], a
	ld hl, wEnemyMonMoves
	ld de, wEnemyMonPP
	predef_jump FillPP
