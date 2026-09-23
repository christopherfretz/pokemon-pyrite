GetLandmarkCoords:
; Return coordinates (d, e) of landmark e.
	push hl
	ld l, e
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, Landmarks
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	pop hl
	ret

GetLandmarkName::
; Copy the name of landmark e to wStringBuffer1.
	push hl
	push de
	push bc

	ld l, e
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, Landmarks + 2
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld de, wStringBuffer1
	ld c, 18
.copy
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copy

	pop bc
	pop de
	pop hl
	ret

INCLUDE "data/maps/landmarks.asm"

RegionCheck:
; Checks if the player is in Kanto or Johto.
; If in Johto, returns 0 in e.
; If in Kanto, returns 1 in e.
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
	call GetWorldMapLocation
	cp LANDMARK_FAST_SHIP ; S.S. Aqua
	jr z, .johto
	cp LANDMARK_SPECIAL
	jr nz, .checkagain

; In a special map, get the backup map group / map id
	ld a, [wBackupMapGroup]
	ld b, a
	ld a, [wBackupMapNumber]
	ld c, a
	call GetWorldMapLocation

.checkagain
	cp KANTO_LANDMARK
	jr c, .johto

; Victory Road area is considered to be Johto.
; Kanto hack (M10 13i): only from ROUTE 26 on.  VICTORY ROAD, ROUTE 23 and the
; INDIGO PLATEAU (the ELITE FOUR rooms) are Yellow's Kanto, where every trainer
; and wild battle plays Yellow's one MUSIC_TRAINER_BATTLE / MUSIC_WILD_BATTLE --
; Crystal's cutoff gave LORELEI, BRUNO, AGATHA and the VICTORY ROAD trainers the
; Johto themes.  RegionCheck's only callers are the two in start_battle.asm.
	cp LANDMARK_ROUTE_26
	jr c, .kanto

.johto
	ld e, JOHTO_REGION
	ret
.kanto
	ld e, KANTO_REGION
	ret
