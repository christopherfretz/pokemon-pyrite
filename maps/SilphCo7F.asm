; Kanto hack (M8 11a, docs/M8-SAFFRON.md 0.6): SILPH CO. 7F -- plumbing only.
; Yellow's floor plan and its stair/elevator warps are wired so the tower is
; navigable; the trainers, item balls, card-key doors and the teleport-pad
; scripts arrive in 11f-11h.
SilphCo7F_MapScripts:
	def_scene_scripts

	def_callbacks

SilphCo7F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 16,  0, SILPH_CO_8F, 2
	warp_event 22,  0, SILPH_CO_6F, 1
	warp_event 18,  0, SILPH_CO_ELEVATOR, 1
	warp_event  5,  7, SILPH_CO_11F, 4
	warp_event  5,  3, SILPH_CO_3F, 9
	warp_event 21, 15, SILPH_CO_5F, 4

	def_coord_events

	def_bg_events

	def_object_events
