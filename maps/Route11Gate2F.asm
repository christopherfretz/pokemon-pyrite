	object_const_def

; Kanto hack: M4 step 7c (docs/M4-VERMILION.md).  Route 11's west gate, upper floor (the binoculars room).
; Warps only -- Yellow's NPCs, trainers and items arrive in 7d-7g.

Route11Gate2F_MapScripts:
	def_scene_scripts

	def_callbacks

Route11Gate2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  7,  7, ROUTE_11_GATE_1F, 5

	def_coord_events

	def_bg_events

	def_object_events
