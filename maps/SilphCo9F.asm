; Kanto hack (M8 11a, docs/M8-SAFFRON.md 0.6): SILPH CO. 9F -- plumbing only.
; Yellow's floor plan and its stair/elevator warps are wired so the tower is
; navigable; the trainers, item balls, card-key doors and the teleport-pad
; scripts arrive in 11f-11h.
SilphCo9F_MapScripts:
	def_scene_scripts

	def_callbacks

SilphCo9F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 14,  0, SILPH_CO_10F, 1
	warp_event 16,  0, SILPH_CO_8F, 1
	warp_event 18,  0, SILPH_CO_ELEVATOR, 1
	warp_event  9,  3, SILPH_CO_3F, 8
	warp_event 17, 15, SILPH_CO_5F, 5

	def_coord_events

	def_bg_events

	def_object_events
