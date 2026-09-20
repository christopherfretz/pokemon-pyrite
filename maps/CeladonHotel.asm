; Kanto hack (M6 9t): Yellow's CELADON_HOTEL
; (vendor/pokeyellow/data/maps/objects/CeladonHotel.asm,
; vendor/pokeyellow/text/CeladonHotel.asm).
;
; Yellow's 7x4 room on the POKECENTER tileset, re-cut block for block
; (scripts/celadon_blk.py "== 9t =="): a full-width reception desk at y=2
; sealing the strip at y=1 where the GRANNY stands, an open lobby, and the
; two-tile door at (3,7)/(4,7) -- Yellow's own door tiles, so the (2,7)/(3,7)
; placeholder from 9p moves one tile right.
;
; All three NPCs keep Yellow's own tiles.  The GRANNY is reached over the
; counter from (3,3) facing up, the way Yellow reaches her.
;
; Deviations from Yellow's art, recorded in docs/M6-CELADON.md "9t findings":
; Crystal's pokecenter tileset has no potted plants, so Yellow's plant
; clusters in the bottom corners become Crystal's couches on the right, and
; Yellow's three-tile bench down the left wall becomes the single couch seat
; at (0,4).  That seat is deliberately Yellow's bench-guy tile: Yellow has a
; hidden event there (hidden_event 0, 4, PrintBenchGuyText, SPRITE_FACING_LEFT)
; and it is BG1's bench pass that adds the guy, not 9t's, so the slot is left
; empty here with a real seat to sit on.
	object_const_def
	const CELADONHOTEL_GRANNY
	const CELADONHOTEL_BEAUTY
	const CELADONHOTEL_SUPER_NERD

CeladonHotel_MapScripts:
	def_scene_scripts

	def_callbacks

CeladonHotelGrannyScript:
	jumptextfaceplayer CeladonHotelGrannyText

; Yellow: STAY NONE -- she does not turn to the player.
CeladonHotelBeautyScript:
	jumptext CeladonHotelBeautyText

CeladonHotelSuperNerdScript:
	jumptextfaceplayer CeladonHotelSuperNerdText

CeladonHotelGrannyText:
	text "#MON? No, this"
	line "is a hotel for"
	cont "people."

	para "We're full up."
	done

CeladonHotelBeautyText:
	text "I'm on vacation"
	line "with my brother"
	cont "and boy friend."

	para "CELADON is such a"
	line "pretty city!"
	done

CeladonHotelSuperNerdText:
	text "Why did she bring"
	line "her brother?"
	done

CeladonHotel_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, CELADON_CITY, 13 ; Kanto hack (M6 9p): Yellow's city warp 13
	warp_event  4,  7, CELADON_CITY, 13

	def_coord_events

	def_bg_events

	def_object_events
	object_event  3,  1, SPRITE_GRANNY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeladonHotelGrannyScript, -1
	object_event  2,  4, SPRITE_BEAUTY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonHotelBeautyScript, -1
	object_event  8,  4, SPRITE_SUPER_NERD, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonHotelSuperNerdScript, -1
