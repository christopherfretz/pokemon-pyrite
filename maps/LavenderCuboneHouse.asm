; Kanto hack (M5 8h): Yellow's LAVENDER_CUBONE_HOUSE
; (vendor/pokeyellow/data/maps/objects/LavenderCuboneHouse.asm,
; scripts/LavenderCuboneHouse.asm, text/LavenderCuboneHouse.asm).  Both of
; Yellow's objects are on Yellow's own tiles: the orphaned CUBONE at (3,5)
; looking up at the table, and the girl beside it at (2,4) facing it.  CUBONE
; is SPRITE_MONSTER and the BRUNETTE_GIRL is SPRITE_LASS, per the substitution
; table (docs/M5-LAVENDER.md 2.17) -- there is no CUBONE overworld sprite.
;
; Crystal's POKEFAN_F (and her RADIO TOWER speech) and the two bookshelves are
; gone; Yellow's room has neither.
	object_const_def
	const LAVENDERCUBONEHOUSE_CUBONE
	const LAVENDERCUBONEHOUSE_LASS

LavenderCuboneHouse_MapScripts:
	def_scene_scripts

	def_callbacks

LavenderCuboneHouseCuboneScript:
	opentext
	writetext LavenderCuboneHouseCuboneText
	cry CUBONE
	waitbutton
	closetext
	end

; Yellow: LavenderCuboneHouseBrunetteGirlText branches on EVENT_RESCUED_MR_FUJI.
LavenderCuboneHouseLassScript:
	faceplayer
	opentext
	checkevent EVENT_RESCUED_MR_FUJI
	iftrue .GhostIsGone
	writetext LavenderCuboneHouseLassPoorCubonesMotherText
	waitbutton
	closetext
	end

.GhostIsGone:
	writetext LavenderCuboneHouseLassGhostIsGoneText
	waitbutton
	closetext
	end

LavenderCuboneHouseCuboneText:
	text "CUBONE: Kyarugoo!"
	done

LavenderCuboneHouseLassPoorCubonesMotherText:
	text "I hate those"
	line "horrible ROCKETs!"

	para "That poor CUBONE's"
	line "mother…"

	para "It was killed"
	line "trying to escape"
	cont "from TEAM ROCKET!"
	done

LavenderCuboneHouseLassGhostIsGoneText:
	text "The GHOST of"
	line "#MON TOWER is"
	cont "gone!"

	para "Someone must have"
	line "soothed its"
	cont "restless soul!"
	done

LavenderCuboneHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, LAVENDER_TOWN, 5
	warp_event  3,  7, LAVENDER_TOWN, 5

	def_coord_events

	def_bg_events

	def_object_events
	object_event  3,  5, SPRITE_MONSTER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, LavenderCuboneHouseCuboneScript, -1
	object_event  2,  4, SPRITE_LASS, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, LavenderCuboneHouseLassScript, -1
