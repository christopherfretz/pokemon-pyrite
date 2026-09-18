; Kanto hack: Yellow's UNDERGROUND_PATH_ROUTE_6 (docs/M4-VERMILION.md, 7d).
; Yellow's only object is a GIRL at (2,3) with _UndergroundPathRoute6GirlText.
; Sprite substitution follows the shipped precedent: SPRITE_GIRL -> SPRITE_LASS.
	object_const_def
	const ROUTE6UNDERGROUNDPATHENTRANCE_LASS

Route6UndergroundPathEntrance_MapScripts:
	def_scene_scripts

	def_callbacks

Route6UndergroundPathEntranceGirlScript:
	jumptextfaceplayer Route6UndergroundPathEntranceGirlText

Route6UndergroundPathEntranceGirlText:
	text "People often lose"
	line "things in that"
	cont "UNDERGROUND PATH."
	done

Route6UndergroundPathEntrance_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, ROUTE_6, 4
	warp_event  4,  7, ROUTE_6, 4
	warp_event  4,  3, UNDERGROUND_PATH, 2

	def_coord_events

	def_bg_events

	def_object_events
	object_event  2,  3, SPRITE_LASS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route6UndergroundPathEntranceGirlScript, -1
