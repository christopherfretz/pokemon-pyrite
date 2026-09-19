; Kanto hack: Yellow's UNDERGROUND_PATH_ROUTE_7 (docs/M5-LAVENDER.md, 8b).
; 8b registers geometry only -- Yellow's MIDDLE_AGED_MAN and his text are 8j's.
; Warps 1/2 point at ROUTE_7 warp 1 as a PLACEHOLDER: Yellow's stairwell warp on
; Route 7 does not exist yet, 8j adds it and re-points these two.
Route7UndergroundPathEntrance_MapScripts:
	def_scene_scripts

	def_callbacks

Route7UndergroundPathEntrance_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, ROUTE_7, 1
	warp_event  4,  7, ROUTE_7, 1
	warp_event  4,  4, UNDERGROUND_PATH_WEST_EAST, 1

	def_coord_events

	def_bg_events

	def_object_events
