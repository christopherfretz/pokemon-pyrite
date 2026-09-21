; Kanto hack: Yellow's ROUTE 18 GATE 1F (docs/M6-CELADON.md, 9aa, decision
; D38).  This REPLACES the M1 provisional (an invented OFFICER speech, an
; invented refusal and, since 9z, four warps parked on ROUTE 18's own tiles
; because Crystal's ROUTE 17 had nowhere left for them to point).
;
; The map keeps Crystal's name -- ROUTE_17_ROUTE_18_GATE -- the way ROUTE 16's
; hut keeps ROUTE_16_GATE; in Yellow it is ROUTE_18_GATE_1F and it stands
; wholly on ROUTE 18, so its landmark and its music row moved with it.
;
; Yellow's hut is one east-west corridor (rows 4-5) with the guard's counter at
; row 2 and the staircase to 2F at (6,8).  WEST is CYCLING ROAD (ROUTE 18's
; west half and ROUTE 17 above it), EAST is FUCHSIA -- so the guard's push is
; a shove back east, and the checkpoint only bites a player walking west.
	object_const_def
	const ROUTE17ROUTE18GATE_OFFICER

Route17Route18Gate_MapScripts:
	def_scene_scripts
	scene_script Route17Route18GateNoopScene, SCENE_ROUTE17ROUTE18GATE_BICYCLE_CHECK

	def_callbacks
	callback MAPCALLBACK_NEWMAP, Route17Route18GateClearAlwaysOnBikeCallback

Route17Route18GateNoopScene:
	end

; Yellow's Route18Gate1F_Script opens with `res BIT_ALWAYS_ON_BIKE, [hl]`
; (vendor/pokeyellow/scripts/Route18Gate1F.asm:2-3) -- walking into a gate hut
; is how you get off the forced bike.  ROUTE 18's own NEWMAP callback re-arms
; it when you step back out of the WEST doors onto CYCLING ROAD.
Route17Route18GateClearAlwaysOnBikeCallback:
	clearflag ENGINE_ALWAYS_ON_BIKE
	endcallback

; The BICYCLE check.  Yellow blocks the four corridor-column tiles at x=4
; (dbmapcoord 4,3 / 4,4 / 4,5 / 4,6), prints "Excuse me!", walks the player UP
; to the counter row -- wCoordIndex - 1 simulated PAD_UP presses, so 0 steps
; from (4,3) and 3 from (4,6) -- prints the guard's refusal, then pushes one
; PAD_RIGHT, back toward FUCHSIA.  With the BICYCLE in the bag the whole script
; returns before any of that and the guard is just another NPC.
Route17Route18GateBicycleCheck3:
	checkitem BICYCLE
	iftrue .Pass
	opentext
	writetext Route17Route18GateGuardExcuseMeText
	waitbutton
	closetext
	sjump Route17Route18GateGuardRefusal

.Pass:
	end

Route17Route18GateBicycleCheck4:
	checkitem BICYCLE
	iftrue .Pass
	opentext
	writetext Route17Route18GateGuardExcuseMeText
	waitbutton
	closetext
	applymovement PLAYER, Route17Route18GateWalkUp1Movement
	sjump Route17Route18GateGuardRefusal

.Pass:
	end

Route17Route18GateBicycleCheck5:
	checkitem BICYCLE
	iftrue .Pass
	opentext
	writetext Route17Route18GateGuardExcuseMeText
	waitbutton
	closetext
	applymovement PLAYER, Route17Route18GateWalkUp2Movement
	sjump Route17Route18GateGuardRefusal

.Pass:
	end

Route17Route18GateBicycleCheck6:
	checkitem BICYCLE
	iftrue .Pass
	opentext
	writetext Route17Route18GateGuardExcuseMeText
	waitbutton
	closetext
	applymovement PLAYER, Route17Route18GateWalkUp3Movement
	sjump Route17Route18GateGuardRefusal

.Pass:
	end

Route17Route18GateGuardRefusal:
	opentext
	writetext Route17Route18GateGuardYouNeedABicycleText
	waitbutton
	closetext
	applymovement PLAYER, Route17Route18GateStepRightMovement
	end

Route17Route18GateWalkUp1Movement:
	step UP
	step_end

Route17Route18GateWalkUp2Movement:
	step UP
	step UP
	step_end

Route17Route18GateWalkUp3Movement:
	step UP
	step UP
	step UP
	step_end

Route17Route18GateStepRightMovement:
	step RIGHT
	step_end

; Yellow's Route18Gate1FGuardText is a text_asm that branches on the BICYCLE.
Route17Route18GateOfficerScript:
	faceplayer
	opentext
	checkitem BICYCLE
	iftrue .HasBicycle
	writetext Route17Route18GateGuardYouNeedABicycleText
	waitbutton
	closetext
	end

.HasBicycle:
	writetext Route17Route18GateGuardCyclingRoadUphillText
	waitbutton
	closetext
	end

Route17Route18GateGuardYouNeedABicycleText:
	text "You need a BICYCLE"
	line "for CYCLING ROAD!"
	done

Route17Route18GateGuardCyclingRoadUphillText:
	text "CYCLING ROAD is"
	line "all uphill from"
	cont "here."
	done

; Shorter than ROUTE 16's "Excuse me! Wait up please!" -- Yellow gives this
; hut its own, one-line version.
Route17Route18GateGuardExcuseMeText:
	text "Excuse me!"
	done

Route17Route18Gate_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; Yellow's five warps in Yellow's order.  1-2 are the WEST doorway (CYCLING
; ROAD), 3-4 the EAST doorway (FUCHSIA), 5 the staircase to 2F.  ROUTE 18's
; own warp list points back at these indices, so the order is load-bearing.
	warp_event  0,  4, ROUTE_18, 1
	warp_event  0,  5, ROUTE_18, 2
	warp_event  7,  4, ROUTE_18, 3
	warp_event  7,  5, ROUTE_18, 4
	warp_event  6,  8, ROUTE_18_GATE_2F, 1

	def_coord_events
	coord_event  4,  3, SCENE_ROUTE17ROUTE18GATE_BICYCLE_CHECK, Route17Route18GateBicycleCheck3
	coord_event  4,  4, SCENE_ROUTE17ROUTE18GATE_BICYCLE_CHECK, Route17Route18GateBicycleCheck4
	coord_event  4,  5, SCENE_ROUTE17ROUTE18GATE_BICYCLE_CHECK, Route17Route18GateBicycleCheck5
	coord_event  4,  6, SCENE_ROUTE17ROUTE18GATE_BICYCLE_CHECK, Route17Route18GateBicycleCheck6

	def_bg_events

	def_object_events
	object_event  4,  1, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route17Route18GateOfficerScript, -1
