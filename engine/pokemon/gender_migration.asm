; GF2 (docs/GENDER-FIELD.md section 5): bits 7-6 of a mon's CaughtLevel byte
; used to hold the time of day it was caught; they now hold its explicit
; gender.  A pre-GF2 save's time-of-day bits must not be read as genders, so
; on Continue every stored mon has them cleared ("unset" = DV-derived, exactly
; the gender it had before).  The pass runs once per container, gated by a
; 2-byte marker that is written after the container is clean:
;   wGenderFieldMigrated  - saved with wPokemonData (party, Day-Care, egg,
;                           contest mon), under the same checksum
;   sGenderFieldMigrated  - SRAM bank 1, unchecksummed; covers sBox and the
;                           14 boxes in SRAM banks 2-3, which Continue's
;                           pass edits in place
; Re-running either pass is harmless (it only clears bits that a migrated
; save never has set on a legacy mon), so a power cut mid-pass just repeats it.

MigrateGenderField::
; Called by Continue once the save is loaded, before anything can be saved.
	ld hl, wGenderFieldMigrated
	call .CheckMagic
	jr z, .party_done
	ld hl, wPartyMon1CaughtLevel
	ld de, PARTYMON_STRUCT_LENGTH
	ld b, PARTY_LENGTH
	call .ClearBits
	ld hl, wBreedMon1CaughtLevel
	call .ClearOne
	ld hl, wBreedMon2CaughtLevel
	call .ClearOne
	ld hl, wEggMonCaughtLevel
	call .ClearOne
	ld hl, wContestMonCaughtLevel
	call .ClearOne
	call SetGenderFieldPartyMarker

.party_done
	ld a, BANK(sGenderFieldMigrated)
	call OpenSRAM
	ld hl, sGenderFieldMigrated
	call .CheckMagic
	jr z, .boxes_done
	ld hl, sBoxMon1CaughtLevel
	call .ClearBox
	ld hl, .BoxAddresses
	ld c, NUM_BOXES
.box_loop
	push bc
	ld a, [hli]
	call OpenSRAM
	ld a, [hli]
	ld e, a
	ld a, [hli]
	push hl
	ld h, a
	ld l, e
	ld de, sBoxMon1CaughtLevel - sBox
	add hl, de
	call .ClearBox
	pop hl
	pop bc
	dec c
	jr nz, .box_loop
	ld a, BANK(sGenderFieldMigrated)
	call OpenSRAM
	ld hl, sGenderFieldMigrated
	call WriteGenderFieldMagic ; last, once every box is clean
.boxes_done
	jp CloseSRAM

.CheckMagic:
; z if [hl], [hl+1] hold the marker
	ld a, [hli]
	cp GENDER_MIGRATED_MAGIC_1
	ret nz
	ld a, [hl]
	cp GENDER_MIGRATED_MAGIC_2
	ret

.ClearBox:
; all MONS_PER_BOX slots (stale slots past the count included; harmless)
	ld de, BOXMON_STRUCT_LENGTH
	ld b, MONS_PER_BOX
	jr .ClearBits

.ClearOne:
	ld b, 1
.ClearBits:
; clear bits 7-6 of b bytes at hl, stride de
	ld a, [hl]
	and CAUGHT_LEVEL_MASK
	ld [hl], a
	add hl, de
	dec b
	jr nz, .ClearBits
	ret

.BoxAddresses:
	for n, 1, NUM_BOXES + 1
		dba sBox{d:n}
	endr

SetGenderFieldBoxMarker::
; ErasePreviousSave: a freshly erased file's boxes need no migration.
	ld a, BANK(sGenderFieldMigrated)
	call OpenSRAM
	ld hl, sGenderFieldMigrated
	call WriteGenderFieldMagic
	jp CloseSRAM

SetGenderFieldPartyMarker::
; NewGame: a new file's party needs no migration.
	ld hl, wGenderFieldMigrated
	; fallthrough
WriteGenderFieldMagic:
	ld a, GENDER_MIGRATED_MAGIC_1
	ld [hli], a
	ld [hl], GENDER_MIGRATED_MAGIC_2
	ret
