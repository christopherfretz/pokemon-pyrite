; SEAFOAM ISLANDS B4F (M9 12d geometry, 12e warps/boulders/hidden item/signs,
; 12f currents + ARTICUNO).
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
	const SEAFOAMISLANDSB4F_ARTICUNO

SeafoamIslandsB4F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_NEWMAP, SeafoamIslandsB4FCurrentCallback

; --- 12f: the STRONG CURRENT ------------------------------------------------
; Two independent currents, on two different gates (see the long note in
; SeafoamIslandsB3F.asm for why the RLE lists play backwards and why
; `CheckBothEventsSet` means "current ON until both boulders are down"):
;
;   * the bottom-edge pushback, Yellow's SeafoamIslandsB4FDefaultScript.  Gated
;     on the pair pushed in on B2F (Yellow's EVENT_SEAFOAM3_*).  It fires at
;     (20,17)/(21,17) -- where B3F's current dumps the player -- with 2 UPs,
;     and at (20,16)/(21,16) with 1 UP, so both end on row 15.
;   * the hole landing, Yellow's SeafoamIslandsB4FMoveObjectScript.  Gated on
;     the pair pushed in on THIS floor's parent, B3F (Yellow's
;     EVENT_SEAFOAM4_*).  (4,14) and (5,14) both sweep to (7,10), which is dry
;     land, so Yellow dismounts (.doneForcedSurfMovement zeroes
;     wWalkBikeSurfState and jp ForceBikeOrSurf).  That is the whole ARTICUNO
;     gate: until B3F's two boulders are down the holes, the player is thrown
;     straight out of the west water and can never surf north to (7,3).
;
; Observed in vanilla Yellow (x,y), boulders still up:
;   (4,14) -> (4,13) (5,13) (6,13) (7,13) (7,12) (7,11) (7,10), on foot
;   (5,14) ->        (5,13) (6,13) (7,13) (7,12) (7,11) (7,10), on foot
;   (20,17) -> (20,15)   (21,17) -> (21,15)
;   (20,16) -> (20,15)   (21,16) -> (21,15)
;
; (20,17)/(21,17) and (4,14)/(5,14) are all WARP arrivals, so they go through
; LoadMemScript, not a coord_event (GSC's EnterMap calls DisableEvents).
; (20,16)/(21,16) are reached by swimming, so they are ordinary coord_events.

SeafoamIslandsB4FCurrentCallback:
	callasm SeafoamIslandsB4FQueueCurrent
	endcallback

SeafoamIslandsB4FQueueCurrent:
	ld b, BANK(SeafoamIslandsB4FArrivalCurrent)
	ld de, SeafoamIslandsB4FArrivalCurrent
	farcall LoadMemScript
	ret

SeafoamIslandsB4FArrivalCurrent:
	readvar VAR_YCOORD
	ifequal 17, .bottomedge
	ifequal 14, .holelanding
	end

.bottomedge:
	callasm SeafoamIslandsB4FBottomCurrentIsOff
	iftrue .nocurrent
	readvar VAR_XCOORD
	ifequal 20, .pushuptwo
	ifequal 21, .pushuptwo
	end

.pushuptwo:
	applymovement PLAYER, SeafoamIslandsB4FCurrentUpTwo
	end

.holelanding:
	callasm SeafoamIslandsB4FHoleCurrentIsOff
	iftrue .nocurrent
	readvar VAR_XCOORD
	ifequal 4, .westhole
	ifequal 5, .easthole
	end

.westhole:
	applymovement PLAYER, SeafoamIslandsB4FCurrentFromWestHole
	sjump .washedashore

.easthole:
	applymovement PLAYER, SeafoamIslandsB4FCurrentFromEastHole

.washedashore:
; Yellow's .doneForcedSurfMovement: (7,10) is land, so the player lands on foot.
	loadvar VAR_MOVEMENT, PLAYER_NORMAL
	special UpdatePlayerSprite
	special PlayMapMusic

.nocurrent:
	end

SeafoamIslandsB4FCurrentPushBack:
	callasm SeafoamIslandsB4FBottomCurrentIsOff
	iftrue .nocurrent
	applymovement PLAYER, SeafoamIslandsB4FCurrentUpOne

.nocurrent:
	end

; wScriptVar = 1 when both of B2F's boulders are down their holes.
SeafoamIslandsB4FBottomCurrentIsOff:
	ld de, EVENT_SEAFOAM_ISLANDS_B2F_BOULDER_1_DOWN_HOLE
	ld bc, EVENT_SEAFOAM_ISLANDS_B2F_BOULDER_2_DOWN_HOLE
	jr SeafoamIslandsB4FBothBouldersDown

; wScriptVar = 1 when both of B3F's boulders are down their holes.
SeafoamIslandsB4FHoleCurrentIsOff:
	ld de, EVENT_SEAFOAM_ISLANDS_B3F_BOULDER_1_DOWN_HOLE
	ld bc, EVENT_SEAFOAM_ISLANDS_B3F_BOULDER_2_DOWN_HOLE
	; fallthrough

SeafoamIslandsB4FBothBouldersDown:
	ld a, 0
	ld [wScriptVar], a
	push bc
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	pop de
	and a
	ret z
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	and a
	ret z
	ld a, 1
	ld [wScriptVar], a
	ret

; Play order, not Yellow's RLE order.
SeafoamIslandsB4FCurrentUpTwo:
; (20,17)/(21,17) -> row 15
	step UP
	step UP
	step_end

SeafoamIslandsB4FCurrentUpOne:
; (20,16)/(21,16) -> row 15
	step UP
	step_end

SeafoamIslandsB4FCurrentFromWestHole:
; (4,14) -> (7,10); Yellow's .RLEList_StrongCurrentNearLeftBoulder
	step UP
	step RIGHT
	step RIGHT
	step RIGHT
	step UP
	step UP
	step UP
	step_end

SeafoamIslandsB4FCurrentFromEastHole:
; (5,14) -> (7,10); Yellow's .RLEList_StrongCurrentNearRightBoulder
	step UP
	step RIGHT
	step RIGHT
	step UP
	step UP
	step UP
	step_end

; --- 12f: ARTICUNO ----------------------------------------------------------
; Yellow makes it a sight-range-0 "trainer" whose class is a species
; (data/maps/objects/SeafoamIslandsB4F.asm: SPRITE_BIRD, ARTICUNO, 50), so
; talking to it prints "Gyaoo!", plays the cry, and starts a WILD battle.
; EndTrainerBattle then sets EVENT_BEAT_ARTICUNO and hides the object unless
; wIsInBattle == LOST_BATTLE -- so in Yellow a WIN, a CATCH *and a successful
; RUN* all lose the bird permanently, and only blacking out leaves it there.
; GSC's wBattleResult says the same thing with `ifequal LOSE`, which is exactly
; the M5/M6 SNORLAX pattern, so the static-encounter shape is unchanged.
SeafoamIslandsB4FArticuno:
	faceplayer
	opentext
	writetext SeafoamIslandsB4FArticunoText
	cry ARTICUNO
	waitbutton
	closetext
	loadwildmon ARTICUNO, 50
	loadvar VAR_BATTLETYPE, BATTLETYPE_NORMAL
	startbattle
	ifequal LOSE, .Fainted
	setevent EVENT_BEAT_ARTICUNO ; = the object's hide flag
	disappear SEAFOAMISLANDSB4F_ARTICUNO
	reloadmapafterbattle
	end

.Fainted:
; Yellow leaves ARTICUNO in place after a blackout, so no setevent here.
	reloadmapafterbattle ; jp's straight to the whiteout
	end

SeafoamIslandsB4FStuckBoulder:
	jumptext SeafoamIslandsB4FBoulderText

SeafoamIslandsB4FHiddenUltraBall:
	hiddenitem ULTRA_BALL, EVENT_SEAFOAM_ISLANDS_B4F_HIDDEN_ULTRA_BALL

SeafoamIslandsB4FBouldersSign:
	jumptext SeafoamIslandsB4FBouldersSignText

SeafoamIslandsB4FDangerSign:
	jumptext SeafoamIslandsB4FDangerSignText

SeafoamIslandsB4FArticunoText:
	text "Gyaoo!"
	done

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
	coord_event 20, 16, -1, SeafoamIslandsB4FCurrentPushBack
	coord_event 21, 16, -1, SeafoamIslandsB4FCurrentPushBack

	def_bg_events
	bg_event  9, 15, BGEVENT_READ, SeafoamIslandsB4FBouldersSign
	bg_event 23,  1, BGEVENT_READ, SeafoamIslandsB4FDangerSign
	bg_event 25, 17, BGEVENT_ITEM, SeafoamIslandsB4FHiddenUltraBall

	def_object_events
	object_event  4, 15, SPRITE_BOULDER, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslandsB4FStuckBoulder, EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B4F_1
	object_event  5, 15, SPRITE_BOULDER, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslandsB4FStuckBoulder, EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B4F_2
	object_event  6,  1, SPRITE_MOLTRES, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SeafoamIslandsB4FArticuno, EVENT_BEAT_ARTICUNO
