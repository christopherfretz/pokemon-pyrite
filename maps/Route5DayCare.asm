	object_const_def

; Kanto hack: M4 step 7c (docs/M4-VERMILION.md).  Yellow's Route 5 DAY-CARE (decision (c)), replacing Crystal's
; CLEANSE TAG house.  The DAY-CARE couple is 7d work.
; Warps only -- Yellow's NPCs, trainers and items arrive in 7d-7g.

Route5DayCare_MapScripts:
	def_scene_scripts

	def_callbacks

Route5DayCare_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, ROUTE_5, 5
	warp_event  3,  7, ROUTE_5, 5

	def_coord_events

	def_bg_events

	def_object_events
