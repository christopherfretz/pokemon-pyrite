; Kanto hack (M8 11a, docs/M8-SAFFRON.md 0.6): SILPH CO. 11F -- plumbing only.
; Yellow's floor plan and its stair/elevator warps are wired so the tower is
; navigable; the trainers, item balls, card-key doors and the teleport-pad
; scripts arrive in 11f-11h.
SilphCo11F_MapScripts:
	def_scene_scripts

	def_callbacks

SilphCo11F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  9,  0, SILPH_CO_10F, 2
	warp_event 13,  0, SILPH_CO_ELEVATOR, 1
	; Yellow sends warp 3 to LAST_MAP -- it is unreachable behind the
	; president's desk.  Self-loop here so the index stays valid.
	warp_event  5,  5, SILPH_CO_11F, 1
	warp_event  3,  2, SILPH_CO_7F, 4

	def_coord_events

	def_bg_events

	def_object_events
