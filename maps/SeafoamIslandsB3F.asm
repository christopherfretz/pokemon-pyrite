; SEAFOAM ISLANDS B3F (M9 12d geometry, 12e warps/boulders/hidden item;
; currents in 12f).
;
; Warps 1-7 Yellow's; 8-9 the anchors for B2F's holes ((18,7)/(19,7), Yellow's
; DungeonWarpData -- both on WATER, and GSC's map_setup .CheckSurfing puts the
; player straight into PLAYER_SURF on arrival, which is Yellow's
; force_bike_surf table for free); 10-11 this floor's two holes.
;
; Six boulders, Yellow's order.  BOULDER1 (5,14) and BOULDER4 (9,14) are not
; in Yellow's toggleable list at all -- permanently visible decoys, so they
; take no event flag (-1).  BOULDER2 (3,15) and BOULDER3 (8,14) are Yellow's
; TOGGLE_B3F_BOULDER_1/2 and are the ones that go down the holes; BOULDER5
; (18,6) and BOULDER6 (19,6) are TOGGLE_B3F_BOULDER_3/4, the two that arrive
; from B2F and sit in the current channel.  Yellow gives 5 and 6 movement byte
; NONE (not pushable), so they are SPRITEMOVEDATA_STILL here.

	object_const_def
	const SEAFOAMISLANDSB3F_BOULDER1
	const SEAFOAMISLANDSB3F_BOULDER2
	const SEAFOAMISLANDSB3F_BOULDER3
	const SEAFOAMISLANDSB3F_BOULDER4
	const SEAFOAMISLANDSB3F_BOULDER5
	const SEAFOAMISLANDSB3F_BOULDER6

SeafoamIslandsB3F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_CMDQUEUE, SeafoamIslandsB3FSetUpStoneTableCallback

SeafoamIslandsB3FSetUpStoneTableCallback:
	writecmdqueue .CommandQueue
	endcallback

.CommandQueue:
	cmdqueue CMDQUEUE_STONETABLE, .StoneTable

.StoneTable:
	stonetable 10, SEAFOAMISLANDSB3F_BOULDER2, .Boulder1
	stonetable 11, SEAFOAMISLANDSB3F_BOULDER3, .Boulder2
	db -1 ; end

.Boulder1:
	disappear SEAFOAMISLANDSB3F_BOULDER2
	clearevent EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B4F_1
	setevent EVENT_SEAFOAM_ISLANDS_B3F_BOULDER_1_DOWN_HOLE
	sjump .FinishBoulder

.Boulder2:
	disappear SEAFOAMISLANDSB3F_BOULDER3
	clearevent EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B4F_2
	setevent EVENT_SEAFOAM_ISLANDS_B3F_BOULDER_2_DOWN_HOLE
	sjump .FinishBoulder

.FinishBoulder:
	pause 15
	end

SeafoamIslandsB3FBoulder:
	jumpstd StrengthBoulderScript

SeafoamIslandsB3FStuckBoulder:
	jumptext SeafoamIslandsBoulderText

SeafoamIslandsB3FHiddenMaxElixer:
	hiddenitem MAX_ELIXER, EVENT_SEAFOAM_ISLANDS_B3F_HIDDEN_MAX_ELIXER

SeafoamIslandsBoulderText:
	text "This requires"
	line "STRENGTH to move!"
	done

SeafoamIslandsB3F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  5, 12, SEAFOAM_ISLANDS_B2F, 2
	warp_event  8,  6, SEAFOAM_ISLANDS_B4F, 3
	warp_event 25,  4, SEAFOAM_ISLANDS_B4F, 4
	warp_event 25,  3, SEAFOAM_ISLANDS_B2F, 5
	warp_event 25, 14, SEAFOAM_ISLANDS_B2F, 7
	warp_event 20, 17, SEAFOAM_ISLANDS_B4F, 1 ; water; 12f's current only
	warp_event 21, 17, SEAFOAM_ISLANDS_B4F, 2 ; water; 12f's current only
	warp_event 18,  7, SEAFOAM_ISLANDS_B2F, 10 ; landing from B2F's west hole
	warp_event 19,  7, SEAFOAM_ISLANDS_B2F, 11 ; landing from B2F's east hole
	warp_event  3, 16, SEAFOAM_ISLANDS_B4F, 5 ; hole
	warp_event  6, 16, SEAFOAM_ISLANDS_B4F, 6 ; hole

	def_coord_events

	def_bg_events
	bg_event  9, 16, BGEVENT_ITEM, SeafoamIslandsB3FHiddenMaxElixer

	def_object_events
	object_event  5, 14, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslandsB3FBoulder, -1
	object_event  3, 15, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslandsB3FBoulder, EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B3F_1
	object_event  8, 14, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslandsB3FBoulder, EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B3F_2
	object_event  9, 14, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslandsB3FBoulder, -1
	object_event 18,  6, SPRITE_BOULDER, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslandsB3FStuckBoulder, EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B3F_3
	object_event 19,  6, SPRITE_BOULDER, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslandsB3FStuckBoulder, EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B3F_4
