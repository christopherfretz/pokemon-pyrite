	object_const_def

; Kanto hack: M4 step 7c (docs/M4-VERMILION.md).  S.S. ANNE B1F.
; Warps only -- Yellow's NPCs, trainers and items arrive in 7d-7g.

SSAnneB1F_MapScripts:
	def_scene_scripts

	def_callbacks

SSAnneB1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 23,  3, SS_ANNE_B1F_ROOMS, 9
	warp_event 19,  3, SS_ANNE_B1F_ROOMS, 7
	warp_event 15,  3, SS_ANNE_B1F_ROOMS, 5
	warp_event 11,  3, SS_ANNE_B1F_ROOMS, 3
	warp_event  7,  3, SS_ANNE_B1F_ROOMS, 1
	warp_event 27,  5, SS_ANNE_1F, 10

	def_coord_events

	def_bg_events

	def_object_events
