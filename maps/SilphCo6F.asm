; Kanto hack (M8 11a, docs/M8-SAFFRON.md 0.6): SILPH CO. 6F -- plumbing only.
; Yellow's floor plan and its stair/elevator warps are wired so the tower is
; navigable; the trainers, item balls, card-key doors and the teleport-pad
; scripts arrive in 11f-11h.
SilphCo6F_MapScripts:
	def_scene_scripts

	def_callbacks

SilphCo6F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 16,  0, SILPH_CO_7F, 2
	warp_event 14,  0, SILPH_CO_5F, 1
	warp_event 18,  0, SILPH_CO_ELEVATOR, 1
	warp_event  3,  3, SILPH_CO_4F, 5
	warp_event 23,  3, SILPH_CO_2F, 7

	def_coord_events

	def_bg_events

	def_object_events
