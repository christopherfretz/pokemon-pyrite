	object_const_def

; Kanto hack: Yellow's DIGLETT'S CAVE (docs/M4-VERMILION.md, 7l).  Yellow's
; DiglettsCave_Object has NO objects and NO bg_events at all -- just the two
; warps -- so Crystal's POKeFAN_M at (34,31) and its hidden MAX REVIVE at
; (6,11) are removed here.  The wild table stays Crystal's until 7m.

DiglettsCave_MapScripts:
	def_scene_scripts

	def_callbacks

DiglettsCave_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  5,  5, DIGLETTS_CAVE_ROUTE_2, 3 ; Kanto hack (docs/M4-VERMILION.md, 7c)
	warp_event 37, 31, DIGLETTS_CAVE_ROUTE_11, 3 ; Kanto hack (docs/M4-VERMILION.md, 7c)

	def_coord_events

	def_bg_events

	def_object_events
