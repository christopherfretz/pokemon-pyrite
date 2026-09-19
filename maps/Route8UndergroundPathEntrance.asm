; Kanto hack: Yellow's UNDERGROUND_PATH_ROUTE_8 (docs/M5-LAVENDER.md, 8b/8j).
; Yellow's only object is a GIRL at (3,4) with _UndergroundPathRoute8GirlText.
; Sprite substitution follows the shipped precedent: SPRITE_GIRL -> SPRITE_LASS
; (hack/maps/Route5UndergroundPathEntrance.asm, 7d).  Note Yellow puts THIS
; girl at (3,4), beside the stairwell, not at (2,3) like the Route 5/6 ones.
	object_const_def
	const ROUTE8UNDERGROUNDPATHENTRANCE_LASS

Route8UndergroundPathEntrance_MapScripts:
	def_scene_scripts

	def_callbacks

Route8UndergroundPathEntranceGirlScript:
	jumptextfaceplayer Route8UndergroundPathEntranceGirlText

Route8UndergroundPathEntranceGirlText:
	text "The dept. store"
	line "in CELADON has a"
	cont "great selection!"
	done

Route8UndergroundPathEntrance_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; ROUTE_8 warp 5 is Yellow's stairwell at (13,3).  8b pointed these at warp 1 as
; a placeholder because ROUTE 8 had no stairwell warp yet; 8j added it.
	warp_event  3,  7, ROUTE_8, 5
	warp_event  4,  7, ROUTE_8, 5
	warp_event  4,  4, UNDERGROUND_PATH_WEST_EAST, 2

	def_coord_events

	def_bg_events

	def_object_events
	object_event  3,  4, SPRITE_LASS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route8UndergroundPathEntranceGirlScript, -1
