	object_const_def

; Kanto hack: M4 step 7c (docs/M4-VERMILION.md).  S.S. ANNE captain's room.
; Warps only -- Yellow's NPCs, trainers and items arrive in 7d-7g.

SSAnneCaptainsRoom_MapScripts:
	def_scene_scripts

	def_callbacks

SSAnneCaptainsRoom_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  0,  7, SS_ANNE_2F, 9

	def_coord_events

	def_bg_events

	def_object_events
