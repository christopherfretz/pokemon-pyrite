	object_const_def

; Kanto hack: M4 step 7c (docs/M4-VERMILION.md).  Diglett's Cave north entrance room (decision (d)).
; Warps only -- Yellow's NPCs, trainers and items arrive in 7d-7g.

DiglettsCaveRoute2_MapScripts:
	def_scene_scripts

	def_callbacks

DiglettsCaveRoute2_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, ROUTE_2, 5
	warp_event  3,  7, ROUTE_2, 5
	warp_event  4,  4, DIGLETTS_CAVE, 1

	def_coord_events

	def_bg_events

	def_object_events
