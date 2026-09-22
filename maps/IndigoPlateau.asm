IndigoPlateau_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_NEWMAP, IndigoPlateauFlypointCallback

IndigoPlateauFlypointCallback:
	setflag ENGINE_FLYPOINT_INDIGO_PLATEAU
	endcallback

IndigoPlateauSign:
	jumptext IndigoPlateauSignText

IndigoPlateauSignText:
	text "INDIGO PLATEAU"

	para "The Ultimate Goal"
	line "for Trainers!"

	para "#MON LEAGUE HQ"
	done

IndigoPlateau_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  9,  5, INDIGO_PLATEAU_POKECENTER_1F, 1
	warp_event 10,  5, INDIGO_PLATEAU_POKECENTER_1F, 2
	warp_event  9, 13, VICTORY_ROAD, 10
	warp_event 10, 13, VICTORY_ROAD, 10
	; Kanto hack (M10 13e-1): arrival-only, from ROUTE_23's (9,0)/(10,0)
	; carpet warps -- the interim stand-in for Yellow's ROUTE 23 <-> INDIGO
	; PLATEAU connection until 13e-2 re-cuts this map on TILESET_KANTO_PLATEAU.
	; They land on the FLOOR just above the VICTORY ROAD mouth: everything
	; south of row 13 is Crystal's scenery pocket behind one-way UP_WALLs
	; (a player landed on row 17 could never leave it), and a FLOOR arrival
	; never fires on a walk-over.  No warp back: ROUTE_23 is reached from
	; here by VICTORY ROAD as in Crystal until then.
	warp_event  9, 12, ROUTE_23, 5
	warp_event 10, 12, ROUTE_23, 6

	def_coord_events

	def_bg_events
	bg_event 11,  7, BGEVENT_READ, IndigoPlateauSign

	def_object_events
