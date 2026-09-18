	object_const_def

; Kanto hack: M4 step 7c (docs/M4-VERMILION.md).  S.S. ANNE B1F cabins.  Yellow's sixth door (bottom right) has no warp_event, so its tile is a dead end, exactly as in Yellow.
; Warps only -- Yellow's NPCs, trainers and items arrive in 7d-7g.

SSAnneB1FRooms_MapScripts:
	def_scene_scripts

	def_callbacks

SSAnneB1FRooms_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  5, SS_ANNE_B1F, 5
	warp_event  3,  5, SS_ANNE_B1F, 5
	warp_event 12,  5, SS_ANNE_B1F, 4
	warp_event 13,  5, SS_ANNE_B1F, 4
	warp_event 22,  5, SS_ANNE_B1F, 3
	warp_event 23,  5, SS_ANNE_B1F, 3
	warp_event  2, 15, SS_ANNE_B1F, 2
	warp_event  3, 15, SS_ANNE_B1F, 2
	warp_event 12, 15, SS_ANNE_B1F, 1
	warp_event 13, 15, SS_ANNE_B1F, 1

	def_coord_events

	def_bg_events

	def_object_events
