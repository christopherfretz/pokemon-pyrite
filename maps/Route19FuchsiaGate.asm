; Kanto hack (M7 10o): Yellow has no map here at all -- ROUTE 19 runs straight
; out of FUCHSIA's south edge.  D62/D63 keep Crystal's gate standing as the
; fence across that seam until M9 ports ROUTES 19-21, but its OFFICER told
; Crystal's story: CINNABAR's volcano erupting and closing ROUTE 19
; "indefinitely", with a second branch gated on EVENT_CINNABAR_ROCKS_CLEARED
; (set only by maps/Route20.asm, unreachable in the Kanto act, so the eruption
; text always printed).  That is a Gen 2 story beat with no Yellow counterpart,
; and it was the first NPC a player met walking south out of FUCHSIA.  Gotcha
; G10 handed it to the leftover audit; there is no Yellow text to port in its
; place, so the gate is a silent pass-through until M9 retires the map.
Route19FuchsiaGate_MapScripts:
	def_scene_scripts

	def_callbacks

Route19FuchsiaGate_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4,  0, FUCHSIA_CITY, 10
	warp_event  5,  0, FUCHSIA_CITY, 11
	warp_event  4,  7, ROUTE_19, 1
	warp_event  5,  7, ROUTE_19, 1

	def_coord_events

	def_bg_events

	def_object_events
