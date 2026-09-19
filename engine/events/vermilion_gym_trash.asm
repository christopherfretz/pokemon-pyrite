; Kanto hack: M4 step 7k (docs/M4-VERMILION.md 3.9).  VERMILION GYM's
; trash-can puzzle -- two switches hidden in fifteen bins.
;
; Ported from Yellow:
;   scripts/VermilionCity.asm .setFirstLockTrashCanIndex   (the roll)
;   engine/events/hidden_events/vermilion_gym_trash.asm    (GymTrashScript)
;   engine/events/hidden_events/vermilion_gym_trash2.asm   (sampler + table)
;
; Yellow rolls the first switch on VERMILION CITY's BIT_CUR_MAP_LOADED_1 rather
; than the gym's, because Gen 1 gives the gym's two map-script bits to the gym
; leader and the door.  We roll it in the gym's own MAPCALLBACK_NEWMAP instead.
; That is behaviourally the same: the gym is only reachable through the city, so
; every path that re-rolled in Yellow re-rolls here, and EVENT_1ST_LOCK_OPENED
; is a saved flag, so a hunt already under way survives the re-roll exactly as
; it does in Yellow (only the FIRST index is re-rolled; the second pair, once
; sampled, is left alone).
;
; The fifteen bg_events hand their can index to VermilionGymTrashCan in
; wScriptVar and read a TRASHCAN_* code back out of the same byte; all of
; Yellow's text is said from the map bank (maps/VermilionGym.asm).

InitVermilionGymTrashCans::
; Special. Chooses the can hiding the first switch.
;
; Yellow adds its two random bytes together before masking:
;	call Random / ldh a, [hRandomAdd] / ld b, a / ldh a, [hRandomSub] / adc b
; Crystal's Random updates the same two hram bytes (home/random.asm), so this is
; the same expression over the same generator.
;
; `and $e` forces the index EVEN, so the first switch is only ever in cans
; 0, 2, 4, 6, 8, 10, 12 or 14 -- eight of the fifteen.  That is not a tidying
; mask, it is the puzzle: GymTrashCans3c's odd rows are never reached from a
; fresh roll, and it is why two thirds of the second-switch draws avoid the
; `.three` bug below.
	call Random
	ldh a, [hRandomAdd]
	ld b, a
	ldh a, [hRandomSub]
	adc b
	and $e
	ld [wFirstLockTrashCanIndex], a
	ret

VermilionGymTrashCan::
; Special. wScriptVar in: the can's index, 0-14. Out: a TRASHCAN_* code.
	ld a, [wScriptVar]
	ld [wGymTrashCanIndex], a

; Don't do the trash can puzzle if it's already been done.
	ld de, EVENT_2ND_LOCK_OPENED
	call .CheckEvent
	jr nz, .nothing

	ld de, EVENT_1ST_LOCK_OPENED
	call .CheckEvent
	jr nz, .try_second_lock

; Hunting the first switch.
	ld a, [wFirstLockTrashCanIndex]
	ld b, a
	ld a, [wGymTrashCanIndex]
	cp b
	jr nz, .nothing

	ld de, EVENT_1ST_LOCK_OPENED
	call .SetEvent
	call SampleSecondTrashCan
	ld a, TRASHCAN_1ST_LOCK
	jr .done

.try_second_lock
; Either of the sampled pair opens the second lock.
	ld a, [wGymTrashCanIndex]
	ld b, a
	ld a, [wSecondLockTrashCanIndex]
	cp b
	jr z, .open_second_lock
	ld a, [wSecondLockTrashCanIndex + 1]
	cp b
	jr z, .open_second_lock

; Missed. Reset the cans and re-roll the first switch.  Yellow re-rolls with a
; bare `call Random / and $e` here -- one byte, not the sum of two -- so this
; one really is just the generator's low bits.
	ld de, EVENT_1ST_LOCK_OPENED
	call .ResetEvent
	call Random
	and $e
	ld [wFirstLockTrashCanIndex], a
	ld a, TRASHCAN_RESET
	jr .done

.open_second_lock
	ld de, EVENT_2ND_LOCK_OPENED
	call .SetEvent
	ld a, TRASHCAN_2ND_LOCK
	jr .done

.nothing
	ld a, TRASHCAN_NOTHING
.done
	ld [wScriptVar], a
	ret

.CheckEvent:
; nz if event de is set.
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	and a
	ret

.SetEvent:
	ld b, SET_FLAG
	jp EventFlagAction

.ResetEvent:
	ld b, RESET_FLAG
	jp EventFlagAction

SampleSecondTrashCan:
; Yellow's Yellow_SampleSecondTrashCan, verbatim.  hl walks to row
; [wGymTrashCanIndex] of GymTrashCans3c (9 bytes each), the row's count byte
; picks a sampler, and the sampler's offset picks one of the four index pairs.
;
; The second `call AddNTimes` is Yellow's, and is a no-op: AddNTimes leaves a
; at 0 and returns immediately on `and a / ret z`.  Kept so the port reads
; against the original line for line.  Yellow also stashes the count byte in
; hGymTrashCanRandNumMask, which nothing ever reads back; dropped.
	ld hl, GymTrashCans3c
	ld a, [wGymTrashCanIndex]
	ld c, a
	ld b, 0
	ld a, 9
	call AddNTimes
	call AddNTimes ; ????
	ld a, [hli]
	ld e, a
	push hl
	call TrashCanRandom
	pop hl
	add hl, de
	add hl, de
	ld a, [hli]
	ld [wSecondLockTrashCanIndex], a
	ld a, [hl]
	ld [wSecondLockTrashCanIndex + 1], a
	ret

TrashCanRandom:
; e = the row's count byte. Returns de = the pair to use, 0-3.
	ld d, 0
	ld hl, .Jumptable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call _hl_
	ld e, a
	ld d, 0
	ret

.Jumptable:
	dw .zero
	dw .one
	dw .two
	dw .three
	dw .four

.zero:
.one:
	ld a, 0
	ret

.two:
	call Random
	and $1
	ret

.three:
; BUG (Yellow, ported deliberately -- see docs/PORTING.md): this leaves the
; chosen third in b and returns the SWAPPED RANDOM BYTE in a, so the caller's
; offset is 0-255 instead of 0-2 and `add hl, de` twice reads up to 510 bytes
; past the row.  Rows of three are only ever reached from first-switch indices
; 6 and 8 (every other even index has a row of four), so two of the eight
; possible first switches make the second switch unfindable until a miss
; re-rolls the puzzle.  That is what Yellow does, and the walk stays inside
; GymTrashCans3c's own bank, so it reads ROM and never wanders into VRAM.
	call Random
	swap a
	cp 1 * $ff / 3
	ld b, 0
	ret c
	cp 2 * $ff / 3
	ld b, 1
	ret c
	ld b, 2
	ret

.four:
	call Random
	and $3
	ret

GymTrashCans3c:
; First byte: number of trashcan entries
; Following four byte pairs: indices for the second trash can.
; Yellow's table verbatim (its older, unused 5-byte GymTrashCans is not ported).
	db 4
	db  1,3,   3,1,   1,-1,  3,-1
	db 3
	db  0,2,   2,4,   4,0,  -1,-1
	db 4
	db  1,5,   5,1,   1,-1,  5,-1
	db 3
	db  0,4,   4,6,   6,0,  -1,-1
	db 4
	db  1,3,   3,1,   5,5,   7,7
	db 3
	db  2,4,   4,8,   8,2,  -1,-1
	db 3
	db  3,7,   7,9,   9,3,  -1,-1
	db 4
	db  4,8,   6,10,  8,4,  10,6
	db 3
	db  5,7,   7,11, 11,5,  -1,-1
	db 3
	db  6,10, 10,12, 12,6,  -1,-1
	db 4
	db  7,9,   9,7,  11,13, 13,11
	db 3
	db  8,10, 10,14, 14,8,  -1,-1
	db 4
	db  9,13, 13,9,   9,-1, 13,-1
	db 3
	db 10,12, 12,14, 14,10, -1,-1
	db 4
	db 11,13, 13,11, 11,-1, 13,-1
