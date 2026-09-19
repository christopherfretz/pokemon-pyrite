; Kanto hack: Yellow's UNDERGROUND_PATH_WEST_EAST (docs/M5-LAVENDER.md, 8b).
; Yellow has no objects and no hidden items in this corridor.
UndergroundPathWestEast_MapScripts:
	def_scene_scripts

	def_callbacks

UndergroundPathWestEast_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  5, ROUTE_7_UNDERGROUND_PATH_ENTRANCE, 3
	warp_event 47,  2, ROUTE_8_UNDERGROUND_PATH_ENTRANCE, 3

	def_coord_events

	def_bg_events

	def_object_events
