; SEAFOAM ISLANDS B4F (M9 12d geometry, 12e warps/boulders/hidden item/signs;
; currents and ARTICUNO in 12f).
;
; Warps 1-4 Yellow's; 5-6 the anchors for B3F's two holes, at Yellow's
; DungeonWarpData coordinates (4,14)/(5,14) -- both WATER, so the player
; arrives surfing.  Warps 1-2 sit on water at the map's bottom edge and, as in
; Yellow, only ever fire from the forced current (12f).
;
; Both boulders start HIDDEN and arrive from B3F; Yellow gives them movement
; byte NONE, so they are SPRITEMOVEDATA_STILL.

	object_const_def
	const SEAFOAMISLANDSB4F_BOULDER1
	const SEAFOAMISLANDSB4F_BOULDER2

SeafoamIslandsB4F_MapScripts:
	def_scene_scripts

	def_callbacks

SeafoamIslandsB4FStuckBoulder:
	jumptext SeafoamIslandsB4FBoulderText

SeafoamIslandsB4FHiddenUltraBall:
	hiddenitem ULTRA_BALL, EVENT_SEAFOAM_ISLANDS_B4F_HIDDEN_ULTRA_BALL

SeafoamIslandsB4FBouldersSign:
	jumptext SeafoamIslandsB4FBouldersSignText

SeafoamIslandsB4FDangerSign:
	jumptext SeafoamIslandsB4FDangerSignText

SeafoamIslandsB4FBoulderText:
	text "This requires"
	line "STRENGTH to move!"
	done

SeafoamIslandsB4FBouldersSignText:
	text "Boulders might"
	line "change the flow"
	cont "of water!"
	done

SeafoamIslandsB4FDangerSignText:
	text "DANGER"
	line "Fast current!"
	done

SeafoamIslandsB4F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 20, 17, SEAFOAM_ISLANDS_B3F, 6 ; water; 12f's current only
	warp_event 21, 17, SEAFOAM_ISLANDS_B3F, 7 ; water; 12f's current only
	warp_event 11,  7, SEAFOAM_ISLANDS_B3F, 2
	warp_event 25,  4, SEAFOAM_ISLANDS_B3F, 3
	warp_event  4, 14, SEAFOAM_ISLANDS_B3F, 10 ; landing from B3F's west hole
	warp_event  5, 14, SEAFOAM_ISLANDS_B3F, 11 ; landing from B3F's east hole

	def_coord_events

	def_bg_events
	bg_event  9, 15, BGEVENT_READ, SeafoamIslandsB4FBouldersSign
	bg_event 23,  1, BGEVENT_READ, SeafoamIslandsB4FDangerSign
	bg_event 25, 17, BGEVENT_ITEM, SeafoamIslandsB4FHiddenUltraBall

	def_object_events
	object_event  4, 15, SPRITE_BOULDER, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslandsB4FStuckBoulder, EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B4F_1
	object_event  5, 15, SPRITE_BOULDER, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslandsB4FStuckBoulder, EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B4F_2
