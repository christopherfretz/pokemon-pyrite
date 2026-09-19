; Kanto hack: Yellow's ROUTE_7 (docs/M5-LAVENDER.md, 8k).
;
; Yellow's ROUTE 7 is the short green strip between CELADON CITY and SAFFRON
; CITY: no trainers, no items, one sign, and two doors into the same SAFFRON
; gate hut -- one on the CELADON side at (11,9)/(11,10) and one on the SAFFRON
; side at (18,9)/(18,10).  Both tiles of a pair share a single warp index, the
; way Yellow wires them (data/maps/objects/Route7.asm) and the way M5 8j
; shipped ROUTE 8's gate.
;
; The UNDERGROUND PATH stairwell at (5,13) is new here: Crystal had sealed the
; corridor off with a locked door at (6,9) and a "CELADON POLICE" flyer at
; (5,11).  Both are deleted; Yellow's own sign goes back at (3,13).
;
; SAFFRON CITY is reached by walking off the map's east edge (`connection east,
; SaffronCity`), never through a warp -- the east strip beyond the hut is only
; 18 tiles and only the hut reaches it.
Route7_MapScripts:
	def_scene_scripts

	def_callbacks

Route7UndergroundPathSign:
	jumptext Route7UndergroundPathSignText

Route7UndergroundPathSignText:
	text "UNDERGROUND PATH"
	line "CELADON CITY -"
	cont "LAVENDER TOWN"
	done

Route7_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; Yellow points both tiles of each door pair at ONE gate warp: the east pair at
; ROUTE_7_GATE warp 3, the west pair at warp 1.  Kept verbatim (8j did the same
; on ROUTE 8), so entering by either tile of a door lands on the hut's upper
; tile, exactly as in Yellow.
	warp_event 18,  9, ROUTE_7_SAFFRON_GATE, 3
	warp_event 18, 10, ROUTE_7_SAFFRON_GATE, 3
	warp_event 11,  9, ROUTE_7_SAFFRON_GATE, 1
	warp_event 11, 10, ROUTE_7_SAFFRON_GATE, 1
	warp_event  5, 13, ROUTE_7_UNDERGROUND_PATH_ENTRANCE, 1

	def_coord_events

	def_bg_events
	bg_event  3, 13, BGEVENT_READ, Route7UndergroundPathSign

	def_object_events
