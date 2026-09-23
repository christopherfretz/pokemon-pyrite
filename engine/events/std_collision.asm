CheckFacingTileForStdScript::
; Checks to see if the tile you're facing has a std script associated with it.  If so, executes the script and returns carry.
	call KantoSilentStdTile
	jr c, .notintable
	ld a, c
	ld de, 3
	ld hl, TileCollisionStdScripts
	call IsInArray
	jr nc, .notintable

	ld a, jumpstd_command
	ld [wJumpStdScriptBuffer], a
	inc hl
	ld a, [hli]
	ld [wJumpStdScriptBuffer + 1], a
	ld a, [hli]
	ld [wJumpStdScriptBuffer + 2], a
	ld a, BANK(Script_JumpStdFromRAM)
	ld hl, Script_JumpStdFromRAM
	call CallScript
	scf
	ret

.notintable
	xor a
	ret

KantoSilentStdTile:
; Kanto hack BG1 (docs/BG1-BENCH-AND-SHELVES.md, audit Q1): on a Kanto-side map
; a BOOKSHELF, TV or RADIO tile does nothing -- no text, no sound -- as in
; Yellow, whose shelves are per-tileset tile lists read only facing UP
; (vendor/pokeyellow/engine/events/hidden_events/bookshelves.asm) and which has
; no TV or radio at all.  The squares where Yellow does print something carry
; their own bg_event (BGEVENT_UP -> PictureBookshelfScript, Yellow's
; BookOrSculptureText verbatim).  Crystal's std scripts (the #MON PAL magazines,
; the POKeMON CHANNEL, "It's a TV.") stay for Johto, including the four
; Johto-act houses that carry a Kanto landmark.
; In: c = collision.  Out: carry = silent.  Preserves c.
	ld a, c
	cp COLL_BOOKSHELF
	jr z, .q1
	cp COLL_TV
	jr z, .q1
	cp COLL_RADIO
	jr z, .q1
.crystal
	and a
	ret

.q1
	push bc
	call IsInJohto
	pop bc
	and a ; JOHTO_REGION
	jr z, .crystal
	ld a, [wMapGroup]
	ld d, a
	ld a, [wMapNumber]
	ld e, a
	ld hl, .JohtoSideHouses
.loop
	ld a, [hli]
	cp -1
	jr z, .silent
	cp d
	ld a, [hli]
	jr nz, .loop
	cp e
	jr nz, .loop
	jr .crystal

.silent
	scf
	ret

.JohtoSideHouses:
	map_id ROUTE_26_HEAL_HOUSE
	map_id DAY_OF_WEEK_SIBLINGS_HOUSE
	map_id ROUTE_27_SANDSTORM_HOUSE
	map_id ROUTE_28_STEEL_WING_HOUSE
	db -1

INCLUDE "data/collision/collision_stdscripts.asm"

Script_JumpStdFromRAM:
	sjump wJumpStdScriptBuffer
