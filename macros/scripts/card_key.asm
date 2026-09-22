; Kanto hack (M8 11j, docs/M8-SAFFRON.md 0.6 row 11j and D72): the shared body
; of a SILPH CO. card-key door.
;
; Yellow's card-key engine (vendor/pokeyellow/engine/events/card_key.asm) is
; TILE-driven, not coordinate-driven: on any Silph map, facing a door tile ($18
; or $24, plus $5e on 11F) with the CARD KEY in the bag prints "Bingo! / The
; CARD KEY opened the door!", replaces the door's block with open floor ($0e,
; or $3 on 11F) and plays SFX_GO_INSIDE; without the key it prints "Darn! It
; needs a CARD KEY!".  Using the CARD KEY from the pack does nothing on a Silph
; floor -- that is Yellow too, so engine/events/card_key.asm (our Radio Tower
; path) is untouched.
;
; GSC has no tile-driven hook, so every door tile carries a BGEVENT_READ whose
; script is one invocation of this macro.  It is deliberately only the per-door
; part: the text, the sound and the redraw live once in SilphCoCardKeyDoors.asm,
; reached by a 2-byte same-bank sjump (every Silph floor shares SECTION
; "Map Scripts 31", bank $7a).
;
; \1 = the door's unlock event flag.  The floor's MAPCALLBACK_TILES callback
;      re-shuts the door on every map load until this flag is set; the
;      changeblock below is what opens it *now*, since a callback only runs on
;      a map LOAD (11f findings).
; \2, \3 = the door block's MAP TILE coordinates (2x Yellow's block coords).
; \4 = the OPEN block id: $0e on 2F-10F, $03 on 11F -- Yellow's own two
;      replacement ids (card_key.asm .replaceCardKeyDoorTileBlock).
MACRO silph_card_key_door
	checkevent \1
	iftrue .alreadyopen\@
	checkitem CARD_KEY
	iffalse SilphCoCardKeyLockedScript
	setevent \1
	changeblock \2, \3, \4
	sjump SilphCoCardKeyOpenedScript
.alreadyopen\@
	end
ENDM
