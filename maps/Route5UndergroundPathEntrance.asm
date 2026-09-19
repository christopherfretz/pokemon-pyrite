; Kanto hack: Yellow's UNDERGROUND_PATH_ROUTE_5 (docs/M4-VERMILION.md, 7d).
; Yellow's only object is a LITTLE_GIRL at (2,3) running TRADE_FOR_RICKY
; (CUBONE -> MACHOKE "RICKY", TRADE_DIALOGSET_HAPPY).  Crystal's wandering
; TEACHER and her JOHTO line are deleted.  Sprite substitution follows the
; shipped precedent (docs/AUDIT-NPC-TEXT.md): SPRITE_LITTLE_GIRL -> SPRITE_TWIN.
	object_const_def
	const ROUTE5UNDERGROUNDPATHENTRANCE_TWIN

Route5UndergroundPathEntrance_MapScripts:
	def_scene_scripts

	def_callbacks

Route5UndergroundPathEntranceLittleGirlScript:
	faceplayer
	opentext
	trade NPC_TRADE_RICKY
	waitbutton
	closetext
	end

Route5UndergroundPathEntrance_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, ROUTE_5, 4
	warp_event  4,  7, ROUTE_5, 4
	warp_event  4,  4, UNDERGROUND_PATH, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  2,  3, SPRITE_TWIN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route5UndergroundPathEntranceLittleGirlScript, -1
