	object_const_def

; Kanto hack: M4 step 7c (docs/M4-VERMILION.md).  S.S. ANNE kitchen.
; Warps only -- Yellow's NPCs, trainers and items arrive in 7d-7g.

SSAnneKitchen_MapScripts:
	def_scene_scripts

	def_callbacks

SSAnneKitchen_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  6,  0, SS_ANNE_1F, 11

	def_coord_events

	def_bg_events

	def_object_events
