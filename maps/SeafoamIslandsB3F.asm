; SEAFOAM ISLANDS B3F (M9 12d geometry, 12e warps/boulders/hidden item,
; 12f currents).
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
	callback MAPCALLBACK_NEWMAP, SeafoamIslandsB3FCurrentCallback
	callback MAPCALLBACK_CMDQUEUE, SeafoamIslandsB3FSetUpStoneTableCallback

; --- 12f: the STRONG CURRENT ------------------------------------------------
; Yellow drives the currents with StartSimulatingJoypadStates over an RLE list
; (vendor/pokeyellow/scripts/SeafoamIslandsB3F.asm).  Two things about that
; data are easy to get wrong and were checked in the Yellow harness before
; these paths were written:
;
;   * the simulated-joypad buffer is consumed BACKWARDS, so Yellow's
;     `DOWN 6 / RIGHT 5 / DOWN 3` actually plays as DOWN 3, RIGHT 5, DOWN 6.
;     The movement data below is in play order.
;   * `CheckBothEventsSet` sets Z when BOTH events ARE set, and the scripts
;     `ret z` on it -- so the current is ON until both boulders are down the
;     holes, and OFF afterwards.  B3F's currents are gated on the pair pushed
;     in on B2F (Yellow's EVENT_SEAFOAM3_*), NOT on this floor's own pair.
;
; Observed in vanilla Yellow (map, x, y), boulders still up:
;   (15, 8) -> ... -> B3F (20,17) -> B4F (20,17) -> B4F (20,15)
;   (18, 7) -> ... -> B3F (20,17) -> B4F (20,17) -> B4F (20,15)
;   (19, 7) -> LEFT to (18,7) -> ... -> B3F (20,17) -> B4F (20,15)
;
; (18,7)/(19,7) are the landings from B2F's two holes, i.e. WARP arrivals, and
; GSC's EnterMap calls DisableEvents, so a coord_event there would never fire.
; The arrival paths are queued with LoadMemScript instead (engine/overworld/
; events.asm): RunMemScript is the one PlayerEvents entry that is not gated on
; wEnabledPlayerEvents, so it runs on the first frame after the map loads.
; A scene script would have been the other option but every map with scenes
; needs its own saved WRAM byte, and WRAM1 is full.

SeafoamIslandsB3FCurrentCallback:
	callasm SeafoamIslandsB3FQueueCurrent
	endcallback

SeafoamIslandsB3FQueueCurrent:
	ld b, BANK(SeafoamIslandsB3FArrivalCurrent)
	ld de, SeafoamIslandsB3FArrivalCurrent
	farcall LoadMemScript
	ret

SeafoamIslandsB3FArrivalCurrent:
	callasm SeafoamIslandsB3FCurrentIsOff
	iftrue .nocurrent
	readvar VAR_YCOORD
	ifnotequal 7, .nocurrent
	readvar VAR_XCOORD
	ifequal 18, .westhole
	ifequal 19, .easthole
	sjump .nocurrent

.westhole:
	applymovement PLAYER, SeafoamIslandsB3FCurrentFromWestHole
	sjump .sweptdown

.easthole:
	applymovement PLAYER, SeafoamIslandsB3FCurrentFromEastHole

.sweptdown:
	warp SEAFOAM_ISLANDS_B4F, 20, 17

.nocurrent:
	end

SeafoamIslandsB3FCurrentNearSteps:
	callasm SeafoamIslandsB3FCurrentIsOff
	iftrue .nocurrent
	applymovement PLAYER, SeafoamIslandsB3FCurrentNearStepsMovement
	warp SEAFOAM_ISLANDS_B4F, 20, 17

.nocurrent:
	end

; SF2: surfing off the (15,7) steps onto (15,8) fires the current in vanilla
; Yellow (its default script polls the coordinate every frame), but GSC's
; coord_event only fires after a WALKED step, and UsedSurfScript's old
; applymovement hop landed with wEnabledPlayerEvents clear, so UsedSurfScript
; callasm'd this after every surf-on.  CS1: the hop is now a walked step (auto
; input, SurfStartStep), the (15,8) coord_event fires on it by itself, and this
; hook is UNREFERENCED.  Left in place only so no *_MapEvents block moves
; (savestates); delete it next time this section is repacked anyway.
SeafoamIslandsB3FSurfLanding::
	ld a, [wMapGroup]
	cp GROUP_SEAFOAM_ISLANDS_B3F
	ret nz
	ld a, [wMapNumber]
	cp MAP_SEAFOAM_ISLANDS_B3F
	ret nz
	ld b, BANK(SeafoamIslandsB3FSurfLandingCurrent)
	ld de, SeafoamIslandsB3FSurfLandingCurrent
	farcall LoadMemScript
	ret

SeafoamIslandsB3FSurfLandingCurrent:
	readvar VAR_YCOORD
	ifnotequal 8, .nocurrent
	readvar VAR_XCOORD
	ifnotequal 15, .nocurrent
	sjump SeafoamIslandsB3FCurrentNearSteps

.nocurrent:
	end

; wScriptVar = 1 when BOTH of B2F's boulders are down their holes, i.e. when
; Yellow's `CheckBothEventsSet` / `ret z` would have stopped the current.
SeafoamIslandsB3FCurrentIsOff:
	ld a, 0
	ld [wScriptVar], a
	ld de, EVENT_SEAFOAM_ISLANDS_B2F_BOULDER_1_DOWN_HOLE
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	and a
	ret z
	ld de, EVENT_SEAFOAM_ISLANDS_B2F_BOULDER_2_DOWN_HOLE
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	and a
	ret z
	ld a, 1
	ld [wScriptVar], a
	ret

; Play order, not Yellow's RLE order (see above).
SeafoamIslandsB3FCurrentNearStepsMovement:
; (15,8) -> (20,17); Yellow's RLEList_ForcedSurfingStrongCurrentNearSteps
	step DOWN
	step DOWN
	step DOWN
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step_end

SeafoamIslandsB3FCurrentFromWestHole:
; (18,7) -> (20,17); Yellow's .RLEList_StrongCurrentNearLeftBoulder
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step RIGHT
	step RIGHT
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step_end

SeafoamIslandsB3FCurrentFromEastHole:
; (19,7) -> (20,17); Yellow's .RLEList_StrongCurrentNearRightBoulder
	step LEFT
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step RIGHT
	step RIGHT
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step_end

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
	coord_event 15,  8, -1, SeafoamIslandsB3FCurrentNearSteps

	def_bg_events
	bg_event  9, 16, BGEVENT_ITEM, SeafoamIslandsB3FHiddenMaxElixer

	def_object_events
	object_event  5, 14, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslandsB3FBoulder, -1
	object_event  3, 15, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslandsB3FBoulder, EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B3F_1
	object_event  8, 14, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslandsB3FBoulder, EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B3F_2
	object_event  9, 14, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslandsB3FBoulder, -1
	object_event 18,  6, SPRITE_BOULDER, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslandsB3FStuckBoulder, EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B3F_3
	object_event 19,  6, SPRITE_BOULDER, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslandsB3FStuckBoulder, EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B3F_4
