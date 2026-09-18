PrintItemDescription:
; Print the description for item [wCurSpecies] at de.

	ld a, [wCurSpecies]
; Kanto hack (M3b TM union): TM item ids are no longer one contiguous range.
	ld c, a
	farcall IsTMHMItem
	jr nc, .not_a_tm

	ld a, [wCurSpecies]
	ld [wCurItem], a
	push de
	farcall GetTMHMItemMove
	pop hl
	ld a, [wTempTMHM]
	ld [wCurSpecies], a
	predef PrintMoveDescription
	ret

.not_a_tm
	push de
	ld hl, ItemDescriptions
	ld a, [wCurSpecies]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	jp PlaceString

INCLUDE "data/items/descriptions.asm"
