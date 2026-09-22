; SEAFOAM ISLANDS B1F (M9 12d geometry, 12e warps/boulders).
;
; Warps 1-7 are Yellow's, unchanged.  Warps 8-9 are the inert anchors the two
; 1F holes land the player on -- Yellow's DungeonWarpData coordinates, (18,7)
; and (23,7); they sit on plain FLOOR, so they never fire, exactly like ICE
; PATH B2F's hole anchors.  Warps 10-11 are this floor's own two holes.
;
; Both boulders start HIDDEN (Yellow: toggle_object_state ... OFF) and appear
; when the boulder above them falls; see constants/event_flags.asm.

	object_const_def
	const SEAFOAMISLANDSB1F_BOULDER1
	const SEAFOAMISLANDSB1F_BOULDER2

SeafoamIslandsB1F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_CMDQUEUE, SeafoamIslandsB1FSetUpStoneTableCallback

SeafoamIslandsB1FSetUpStoneTableCallback:
	writecmdqueue .CommandQueue
	endcallback

.CommandQueue:
	cmdqueue CMDQUEUE_STONETABLE, .StoneTable

.StoneTable:
	stonetable 10, SEAFOAMISLANDSB1F_BOULDER1, .Boulder1
	stonetable 11, SEAFOAMISLANDSB1F_BOULDER2, .Boulder2
	db -1 ; end

.Boulder1:
	disappear SEAFOAMISLANDSB1F_BOULDER1
	clearevent EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B2F_1
	setevent EVENT_SEAFOAM_ISLANDS_B1F_BOULDER_1_DOWN_HOLE
	sjump .FinishBoulder

.Boulder2:
	disappear SEAFOAMISLANDSB1F_BOULDER2
	clearevent EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B2F_2
	setevent EVENT_SEAFOAM_ISLANDS_B1F_BOULDER_2_DOWN_HOLE
	sjump .FinishBoulder

.FinishBoulder:
	pause 15
	end

SeafoamIslandsB1FBoulder:
	jumpstd StrengthBoulderScript

SeafoamIslandsB1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4,  2, SEAFOAM_ISLANDS_B2F, 1
	warp_event  7,  5, SEAFOAM_ISLANDS_1F, 5
	warp_event 13,  7, SEAFOAM_ISLANDS_B2F, 3
	warp_event 19, 15, SEAFOAM_ISLANDS_B2F, 4
	warp_event 23, 15, SEAFOAM_ISLANDS_1F, 7
	warp_event 25, 11, SEAFOAM_ISLANDS_B2F, 6
	warp_event 25,  3, SEAFOAM_ISLANDS_1F, 6
	warp_event 18,  7, SEAFOAM_ISLANDS_1F, 8 ; landing from 1F's west hole
	warp_event 23,  7, SEAFOAM_ISLANDS_1F, 9 ; landing from 1F's east hole
	warp_event 18,  6, SEAFOAM_ISLANDS_B2F, 8 ; hole
	warp_event 23,  6, SEAFOAM_ISLANDS_B2F, 9 ; hole

	def_coord_events

	def_bg_events

	def_object_events
	object_event 17,  6, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslandsB1FBoulder, EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B1F_1
	object_event 22,  6, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslandsB1FBoulder, EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B1F_2
