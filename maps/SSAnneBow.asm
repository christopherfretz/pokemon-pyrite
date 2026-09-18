	object_const_def

; Kanto hack: M4 step 7c (docs/M4-VERMILION.md).  S.S. ANNE bow -- the CAPTAIN's deck (CUT is taught here in 7d).
; Warps only -- Yellow's NPCs, trainers and items arrive in 7d-7g.

SSAnneBow_MapScripts:
	def_scene_scripts

	def_callbacks

SSAnneBow_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 13,  6, SS_ANNE_3F, 1
	warp_event 13,  7, SS_ANNE_3F, 1

	def_coord_events

	def_bg_events

	def_object_events
