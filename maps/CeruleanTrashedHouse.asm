; 6c: Yellow's CERULEAN_TRASHED_HOUSE, the robbed house whose back wall the
; Rocket thief smashed through (vendor/pokeyellow/scripts/CeruleanTrashedHouse.asm
; + text/CeruleanTrashedHouse.asm).  6a laid in the geometry and the three warps;
; warp 3 is the hole, at OUR interior (2,0) rather than Yellow's (3,0), because
; the reused House1 block grid puts the usable gap one tile left (see 6a
; findings).  The bg_event for the hole moved with it, and so did the fishing
; guru: Yellow stands him at (2,1), beside the hole, but with the hole one tile
; left that is the tile the arrival's forced DOWN step lands on, which leaves
; the player parked on the warp tile.  He is at (3,1) here instead - the same
; "beside the hole" spot, mirrored.
	object_const_def
	const CERULEANTRASHEDHOUSE_FISHING_GURU
	const CERULEANTRASHEDHOUSE_GIRL

CeruleanTrashedHouse_MapScripts:
	def_scene_scripts

	def_callbacks

; Yellow branches on whether TM_DIG is actually in the bag, not on a story flag:
; recover it and he shrugs the theft off, lose it again (or never collect it)
; and he is still complaining.  GSC's `checkitem` dispatches by pocket
; (_CheckItem -> .TMHM -> CheckTMHM), so it reads wTMsHMs for a TM and the
; branch ports across unchanged.
CeruleanTrashedHouseFishingGuruScript:
	faceplayer
	opentext
	checkitem TM_DIG
	iftrue .GotItBack
	writetext CeruleanTrashedHouseFishingGuruTheyStoleATMText
	waitbutton
	closetext
	end

.GotItBack:
	writetext CeruleanTrashedHouseFishingGuruWhatsLostIsLostText
	waitbutton
	closetext
	end

CeruleanTrashedHouseGirlScript:
	jumptextfaceplayer CeruleanTrashedHouseGirlText

CeruleanTrashedHouseWallHole:
	jumptext CeruleanTrashedHouseWallHoleText

CeruleanTrashedHouseFishingGuruTheyStoleATMText:
	text "Those miserable"
	line "ROCKETs!"

	para "Look what they"
	line "did here!"

	para "They stole a TM"
	line "for teaching"
	cont "#MON how to"
	cont "DIG holes!"

	para "That cost me a"
	line "bundle, it did!"
	done

CeruleanTrashedHouseFishingGuruWhatsLostIsLostText:
	text "I figure what's"
	line "lost is lost!"

	para "I decided to teach"
	line "DIGLETT how to"
	cont "DIG without a TM!"
	done

CeruleanTrashedHouseGirlText:
	text "TEAM ROCKET must"
	line "be trying to DIG"
	cont "their way into no"
	cont "good!"
	done

CeruleanTrashedHouseWallHoleText:
	text "TEAM ROCKET left"
	line "a way out!"
	done

; BG1Q1 (docs/BG1-BENCH-AND-SHELVES.md): Yellow prints BookOrSculptureText
; ("Crammed full of / #MON books!") facing UP on (0,1), (1,1)
; (engine/events/hidden_events/bookshelves.asm).  Every other bookshelf/TV/
; radio square here is silent, as in Yellow (engine/events/std_collision.asm).
CeruleanTrashedHouseBG1Q1Bookshelf:
	jumpstd PictureBookshelfScript

CeruleanTrashedHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, CERULEAN_CITY, 1
	warp_event  3,  7, CERULEAN_CITY, 1
	warp_event  2,  0, CERULEAN_CITY, 8 ; hole in the back wall (Yellow: 3, 0)

	def_coord_events

	def_bg_events
	bg_event  0,  1, BGEVENT_UP, CeruleanTrashedHouseBG1Q1Bookshelf ; BG1Q1
	bg_event  1,  1, BGEVENT_UP, CeruleanTrashedHouseBG1Q1Bookshelf ; BG1Q1
	bg_event  2,  0, BGEVENT_READ, CeruleanTrashedHouseWallHole

	def_object_events
	object_event  3,  1, SPRITE_FISHING_GURU, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeruleanTrashedHouseFishingGuruScript, -1
	object_event  5,  6, SPRITE_LASS, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeruleanTrashedHouseGirlScript, -1
