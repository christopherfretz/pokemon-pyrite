; Kanto hack (M8 11a, docs/M8-SAFFRON.md 0.6): SILPH CO. 5F -- plumbing only.
; Yellow's floor plan and its stair/elevator warps are wired so the tower is
; navigable; the trainers, item balls, card-key doors and the teleport-pad
; scripts arrive in 11f-11h.
SilphCo5F_MapScripts:
	def_scene_scripts

	def_callbacks

SilphCo5F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 24,  0, SILPH_CO_6F, 2
	warp_event 26,  0, SILPH_CO_4F, 2
	warp_event 20,  0, SILPH_CO_ELEVATOR, 1
	warp_event 27,  3, SILPH_CO_7F, 6
	warp_event  9, 15, SILPH_CO_9F, 5
	warp_event 11,  5, SILPH_CO_3F, 5
	warp_event  3, 15, SILPH_CO_3F, 6

	def_coord_events

	def_bg_events

	def_object_events
