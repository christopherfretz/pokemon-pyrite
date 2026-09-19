; Kanto hack: Yellow's UNDERGROUND_PATH_ROUTE_7 (docs/M5-LAVENDER.md, 8b/8k).
; Yellow's only object is a MIDDLE_AGED_MAN at (2,4) with
; _UndergroundPathRoute7MiddleAgedManText.  Sprite substitution follows the
; shipped precedent: SPRITE_MIDDLE_AGED_MAN -> SPRITE_POKEFAN_M
; (docs/M2-MTMOON.md:1465, hack/maps/CeruleanBadgeHouse.asm).  Yellow's STAY /
; NONE keeps his default southward facing, so SPRITEMOVEDATA_STANDING_DOWN.
	object_const_def
	const ROUTE7UNDERGROUNDPATHENTRANCE_POKEFAN_M

Route7UndergroundPathEntrance_MapScripts:
	def_scene_scripts

	def_callbacks

Route7UndergroundPathEntranceMiddleAgedManScript:
	jumptextfaceplayer Route7UndergroundPathEntranceMiddleAgedManText

Route7UndergroundPathEntranceMiddleAgedManText:
	text "I heard a sleepy"
	line "#MON appeared"
	cont "near CELADON CITY."
	done

Route7UndergroundPathEntrance_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; ROUTE_7 warp 5 is Yellow's stairwell at (5,13).  8b pointed these at warp 1
; as a placeholder because ROUTE 7 had no stairwell warp yet; 8k added it.
	warp_event  3,  7, ROUTE_7, 5
	warp_event  4,  7, ROUTE_7, 5
	warp_event  4,  4, UNDERGROUND_PATH_WEST_EAST, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  2,  4, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, Route7UndergroundPathEntranceMiddleAgedManScript, -1
