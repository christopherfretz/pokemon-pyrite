RefreshMapObjectScripts::
; Kanto hack (CH1b): save compatibility across releases, for every map.
;
; A game saved on a map keeps that map's wMapObjects in the save, and
; Continue (MapSetupScript_Continue) loads the map with
; LoadMapAttributes_SkipObjects, which never calls ReadObjectEvents.  Each
; slot's MAPOBJECT_SCRIPT_POINTER is an absolute address into the map's
; scripts bank, so a release that moves any script in that bank (CH1 grew
; CeruleanTrashedHouse, the first map in "Map Scripts 15") left every later
; map's saved NPCs pointing into the middle of someone else's code: talk to
; the Cerulean nurse after Continue and garbage bytes run as a script.
;
; So, on Continue only, re-copy from the map's ROM object_event list the two
; things that are addresses or select how the address is used:
;   MAPOBJECT_TYPE (+ palette nybble)  script vs. itemball vs. trainer
;   MAPOBJECT_SCRIPT_POINTER
; for slots 1..count.  Position, sprite, movement, struct id (and with it a
; `disappear`ed object's state) and every slot past the ROM count stay exactly
; as saved, so this is a no-op on a save made by the same release.  Object
; order is fixed by the save-compat rule (CLAUDE.md), so slot i is object i.
; wCurMapObjectEventCount/Pointer are refreshed too; ReadObjectEvents sets
; them on every other path and they were just as stale here.
;
; Runs right after LoadMapAttributes_SkipObjects, which has set
; wMapScriptsBank and wCurMapBGEventsPointer/Count; the object_event count
; byte follows the last bg_event.
	ld hl, wCurMapBGEventsPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wCurMapBGEventCount]
	ld bc, BG_EVENT_SIZE
	call AddNTimes ; returns at once for 0
	ld a, [wMapScriptsBank]
	call GetFarByte ; object_event count
	inc hl
	ld [wCurMapObjectEventCount], a
	ld c, a
	ld a, l
	ld [wCurMapObjectEventsPointer], a
	ld a, h
	ld [wCurMapObjectEventsPointer + 1], a
	ld a, c
	and a
	ret z
	ld de, wMap1Object + MAPOBJECT_TYPE
.loop
	push bc
	push hl
	ld bc, MAPOBJECT_TYPE - 1 ; object_event = map object minus its struct id byte
	add hl, bc
	ld a, [wMapScriptsBank]
	call GetFarByte
	ld [de], a ; MAPOBJECT_TYPE
	inc hl
	inc hl ; skip the sight range
	inc de
	inc de ; MAPOBJECT_SCRIPT_POINTER
	ld a, [wMapScriptsBank]
	call GetFarByte
	ld [de], a
	inc hl
	inc de
	ld a, [wMapScriptsBank]
	call GetFarByte
	ld [de], a
	ld hl, MAPOBJECT_LENGTH - (MAPOBJECT_SCRIPT_POINTER + 1 - MAPOBJECT_TYPE)
	add hl, de
	ld d, h
	ld e, l ; next slot's MAPOBJECT_TYPE
	pop hl
	ld bc, OBJECT_EVENT_SIZE
	add hl, bc
	pop bc
	dec c
	jr nz, .loop
	ret
