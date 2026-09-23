; Kanto hack: Yellow's BILL's GRANDPA's house (docs/M7-FUCHSIA.md 10g).  In
; Yellow this FUCHSIA CITY house belongs to BILL's grandfather, not to a sister
; of his, so the cast and every line are Yellow's
; (vendor/pokeyellow/{data/maps/objects,text}/FuchsiaBillsGrandpasHouse.asm).
; The map keeps Crystal's name -- Route 25's BillsHouse set that precedent and
; renaming would churn FUCHSIA_CITY's warps and the attributes table for no
; player-visible gain.  Crystal's two Johto-era lines (a grandpa away on
; CERULEAN CAPE, SLOWPOKE on CYCLING ROAD) are gone; nothing of BILL's sister
; survives.  Yellow's three positions all land on floor in Crystal's House1
; blockset, so the room itself is unchanged.
; Sprites follow the standing substitutions: SPRITE_POKEFAN_F for Yellow's
; MIDDLE_AGED_WOMAN (docs/AUDIT-NPC-TEXT.md:2334) and SPRITE_OLD_MAN for its
; GAMBLER -- M4 superseded the M2-era GENTLEMAN call, because Yellow's
; gfx/sprites/gambler.png is byte-identical to Crystal's gfx/sprites/old_man.png
; (see maps/VermilionCity.asm:15-17).  FUCHSIA CITY's own GAMBLER already used
; SPRITE_OLD_MAN, so M7 was shipping one Yellow sprite two ways (M7 10o).
	object_const_def
	const BILLSOLDERSISTERSHOUSE_MIDDLE_AGED_WOMAN
	const BILLSOLDERSISTERSHOUSE_BILLS_GRANDPA
	const BILLSOLDERSISTERSHOUSE_YOUNGSTER

BillsOlderSistersHouse_MapScripts:
	def_scene_scripts

	def_callbacks

BillsGrandpasHouseWomanScript:
	jumptextfaceplayer BillsGrandpasHouseWomanText

BillsGrandpaScript:
	jumptextfaceplayer BillsGrandpaText

BillsGrandpasHouseYoungsterScript:
	jumptextfaceplayer BillsGrandpasHouseYoungsterText

BillsGrandpasHouseWomanText:
	text "SAFARI ZONE's"
	line "WARDEN is old,"
	cont "but still active!"

	para "All his teeth are"
	line "false, though."
	done

BillsGrandpaText:
	text "Hmm? You've met"
	line "BILL?"

	para "He's my grandson!"

	para "He always liked"
	line "collecting things"
	cont "even as a child!"
	done

BillsGrandpasHouseYoungsterText:
	text "BILL files his"
	line "own #MON data"
	cont "on his PC!"

	para "Did he show you?"
	done

; BG1Q1 (docs/BG1-BENCH-AND-SHELVES.md): Yellow prints BookOrSculptureText
; ("Crammed full of / #MON books!") facing UP on (0,1), (1,1), (7,1)
; (engine/events/hidden_events/bookshelves.asm).  Every other bookshelf/TV/
; radio square here is silent, as in Yellow (engine/events/std_collision.asm).
BillsOlderSistersHouseBG1Q1Bookshelf:
	jumpstd PictureBookshelfScript

BillsOlderSistersHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, FUCHSIA_CITY, 2
	warp_event  3,  7, FUCHSIA_CITY, 2

	def_coord_events

	def_bg_events
	bg_event  0,  1, BGEVENT_UP, BillsOlderSistersHouseBG1Q1Bookshelf ; BG1Q1
	bg_event  1,  1, BGEVENT_UP, BillsOlderSistersHouseBG1Q1Bookshelf ; BG1Q1
	bg_event  7,  1, BGEVENT_UP, BillsOlderSistersHouseBG1Q1Bookshelf ; BG1Q1

	def_object_events
	object_event  2,  3, SPRITE_POKEFAN_F, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, BillsGrandpasHouseWomanScript, -1
	object_event  7,  2, SPRITE_OLD_MAN, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, BillsGrandpaScript, -1
	object_event  5,  5, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, BillsGrandpasHouseYoungsterScript, -1
