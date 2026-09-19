; Kanto hack: Yellow's UNDERGROUND_PATH_ROUTE_8 (docs/M5-LAVENDER.md, 8b).
; 8b registers geometry only -- Yellow's GIRL and her text are 8k's.
; Warps 1/2 point at ROUTE_8 warp 1 as a PLACEHOLDER: Yellow's stairwell warp on
; Route 8 does not exist yet, 8k adds it and re-points these two.
Route8UndergroundPathEntrance_MapScripts:
	def_scene_scripts

	def_callbacks

Route8UndergroundPathEntrance_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, ROUTE_8, 1
	warp_event  4,  7, ROUTE_8, 1
	warp_event  4,  4, UNDERGROUND_PATH_WEST_EAST, 2

	def_coord_events

	def_bg_events

	def_object_events
