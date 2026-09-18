	object_const_def

; Kanto hack: M4 step 7c (docs/M4-VERMILION.md).  S.S. ANNE 1F cabins (six rooms on one map).
; Warps only -- Yellow's NPCs, trainers and items arrive in 7d-7g.

SSAnne1FRooms_MapScripts:
	def_scene_scripts

	def_callbacks

SSAnne1FRooms_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  0,  0, SS_ANNE_1F, 3
	warp_event 10,  0, SS_ANNE_1F, 4
	warp_event 20,  0, SS_ANNE_1F, 5
	warp_event  0, 10, SS_ANNE_1F, 6
	warp_event 10, 10, SS_ANNE_1F, 7
	warp_event 20, 10, SS_ANNE_1F, 8

	def_coord_events

	def_bg_events

	def_object_events
