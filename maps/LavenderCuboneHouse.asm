	object_const_def
	const LAVENDERCUBONEHOUSE_POKEFAN_F

LavenderCuboneHouse_MapScripts:
	def_scene_scripts

	def_callbacks

LavenderCuboneHousePokefanFScript:
	jumptextfaceplayer LavenderCuboneHousePokefanFText

LavenderCuboneHouseBookshelf:
	jumpstd PictureBookshelfScript

LavenderCuboneHousePokefanFText:
	text "LAVENDER is a"
	line "tiny, quiet town"

	para "at the foot of the"
	line "mountains."

	para "It's gotten a bit"
	line "busier since the"

	para "RADIO TOWER was"
	line "built."
	done

LavenderCuboneHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, LAVENDER_TOWN, 5
	warp_event  3,  7, LAVENDER_TOWN, 5

	def_coord_events

	def_bg_events
	bg_event  0,  1, BGEVENT_READ, LavenderCuboneHouseBookshelf
	bg_event  1,  1, BGEVENT_READ, LavenderCuboneHouseBookshelf

	def_object_events
	object_event  2,  3, SPRITE_POKEFAN_F, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, LavenderCuboneHousePokefanFScript, -1
