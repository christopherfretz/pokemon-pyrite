; SEAFOAM ISLANDS B2F (M9 12d geometry, 12e warps/boulders/hidden item).
;
; Warps 1-7 Yellow's; 8-9 the anchors for B1F's holes ((19,7)/(22,7), Yellow's
; DungeonWarpData); 10-11 this floor's holes.  Note Yellow's crossing here:
; boulder 1 sits at (18,6) and falls into the hole at (19,6) on its RIGHT,
; boulder 2 sits at (23,6) and falls into the hole at (22,6) on its LEFT.
;
; The boulders that land on B3F are the two that stop the strong current --
; 12f reads EVENT_SEAFOAM_ISLANDS_B2F_BOULDER_{1,2}_DOWN_HOLE for that, not
; the objects, exactly as Yellow's SeafoamIslandsB3FDefaultScript does.

	object_const_def
	const SEAFOAMISLANDSB2F_BOULDER1
	const SEAFOAMISLANDSB2F_BOULDER2

SeafoamIslandsB2F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_CMDQUEUE, SeafoamIslandsB2FSetUpStoneTableCallback

SeafoamIslandsB2FSetUpStoneTableCallback:
	writecmdqueue .CommandQueue
	endcallback

.CommandQueue:
	cmdqueue CMDQUEUE_STONETABLE, .StoneTable

.StoneTable:
	stonetable 10, SEAFOAMISLANDSB2F_BOULDER1, .Boulder1
	stonetable 11, SEAFOAMISLANDSB2F_BOULDER2, .Boulder2
	db -1 ; end

.Boulder1:
	disappear SEAFOAMISLANDSB2F_BOULDER1
	clearevent EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B3F_3
	setevent EVENT_SEAFOAM_ISLANDS_B2F_BOULDER_1_DOWN_HOLE
	sjump .FinishBoulder

.Boulder2:
	disappear SEAFOAMISLANDSB2F_BOULDER2
	clearevent EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B3F_4
	setevent EVENT_SEAFOAM_ISLANDS_B2F_BOULDER_2_DOWN_HOLE
	sjump .FinishBoulder

.FinishBoulder:
	pause 15
	end

SeafoamIslandsB2FBoulder:
	jumpstd StrengthBoulderScript

SeafoamIslandsB2FHiddenNugget:
	hiddenitem NUGGET, EVENT_SEAFOAM_ISLANDS_B2F_HIDDEN_NUGGET

SeafoamIslandsB2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  5,  3, SEAFOAM_ISLANDS_B1F, 1
	warp_event  5, 13, SEAFOAM_ISLANDS_B3F, 1
	warp_event 13,  7, SEAFOAM_ISLANDS_B1F, 3
	warp_event 19, 15, SEAFOAM_ISLANDS_B1F, 4
	warp_event 25,  3, SEAFOAM_ISLANDS_B3F, 4
	warp_event 25, 11, SEAFOAM_ISLANDS_B1F, 6
	warp_event 25, 14, SEAFOAM_ISLANDS_B3F, 5
	warp_event 19,  7, SEAFOAM_ISLANDS_B1F, 10 ; landing from B1F's west hole
	warp_event 22,  7, SEAFOAM_ISLANDS_B1F, 11 ; landing from B1F's east hole
	warp_event 19,  6, SEAFOAM_ISLANDS_B3F, 8 ; hole
	warp_event 22,  6, SEAFOAM_ISLANDS_B3F, 9 ; hole

	def_coord_events

	def_bg_events
	bg_event 15, 15, BGEVENT_ITEM, SeafoamIslandsB2FHiddenNugget

	def_object_events
	object_event 18,  6, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslandsB2FBoulder, EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B2F_1
	object_event 23,  6, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslandsB2FBoulder, EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B2F_2
