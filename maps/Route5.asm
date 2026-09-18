; Kanto hack: Yellow's ROUTE_5 (docs/M4-VERMILION.md, 7d).
; Yellow's Route5_Object has NO object_events and exactly one bg_event, the
; UNDERGROUND PATH sign at (17,29).  Crystal's POKEFAN_M who blocks the
; Underground Path until the POWER PLANT is fixed is gone, and so is Crystal's
; "House for Sale" sign at (11,21) -- Yellow has no sign beside the DAY-CARE
; door, so ours is deleted rather than reworded.
	object_const_def

Route5_MapScripts:
	def_scene_scripts

	def_callbacks

Route5UndergroundPathSign:
	jumptext Route5UndergroundPathSignText

Route5UndergroundPathSignText:
	text "UNDERGROUND PATH"
	line "CERULEAN CITY -"
	cont "VERMILION CITY"
	done

Route5_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 10, 29, ROUTE_5_SAFFRON_GATE, 1
	warp_event  9, 29, ROUTE_5_SAFFRON_GATE, 1
	warp_event 10, 33, ROUTE_5_SAFFRON_GATE, 3
	warp_event 17, 27, ROUTE_5_UNDERGROUND_PATH_ENTRANCE, 1
	warp_event 10, 21, ROUTE_5_DAY_CARE, 1 ; Kanto hack (docs/M4-VERMILION.md, decision (c))

	def_coord_events

	def_bg_events
	bg_event 17, 29, BGEVENT_READ, Route5UndergroundPathSign

	def_object_events
