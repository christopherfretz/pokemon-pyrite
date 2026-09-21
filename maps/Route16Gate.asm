; Kanto hack: Yellow's ROUTE 16 GATE 1F (docs/M6-CELADON.md, 9y, decision D38).
; This REPLACES the M1 provisional, which had an invented OFFICER speech, an
; invented refusal text and four fake 2F doors pointed back at the lower pair
; because Crystal's ROUTE 16 had nowhere for them to go.
;
; Yellow's hut is two independent east-west pass-throughs on one floor: the
; UPPER corridor (rows 2-3) joins the two halves of ROUTE 16's north path, the
; LOWER corridor (rows 7-10) is the CELADON -> CYCLING ROAD checkpoint, and the
; only thing linking them is the staircase at (6,12) up to 2F.  The GAMBLER at
; (4,3) is stranded in the upper corridor and says so.
	object_const_def
	const ROUTE16GATE_OFFICER
	const ROUTE16GATE_GENTLEMAN

Route16Gate_MapScripts:
	def_scene_scripts
	scene_script Route16GateNoopScene, SCENE_ROUTE16GATE_BICYCLE_CHECK

	def_callbacks
	callback MAPCALLBACK_NEWMAP, Route16GateClearAlwaysOnBikeCallback

Route16GateNoopScene:
	end

; Yellow's Route16Gate1F_Script opens with `res BIT_ALWAYS_ON_BIKE, [hl]`
; (vendor/pokeyellow/scripts/Route16Gate1F.asm:2-3) -- walking into a gate hut
; is how you get off the forced bike.  ROUTE 16's own NEWMAP callback re-arms it
; when you step back out onto the CYCLING ROAD side.
Route16GateClearAlwaysOnBikeCallback:
	clearflag ENGINE_ALWAYS_ON_BIKE
	endcallback

; The BICYCLE check.  Yellow blocks the four lower-corridor tiles at x=4
; (dbmapcoord 4,7 / 4,8 / 4,9 / 4,10), prints "Excuse me! Wait up please!",
; walks the player UP to the counter row -- wCoordIndex - 1 simulated PAD_UP
; presses, so 0 steps from (4,7) and 3 from (4,10) -- prints the guard's
; refusal, then pushes one PAD_RIGHT.  With the BICYCLE in the bag the whole
; script returns before any of that and the guard is just another NPC.
Route16GateBicycleCheck7:
	checkitem BICYCLE
	iftrue .Pass
	opentext
	writetext Route16GateGuardWaitUpText
	waitbutton
	closetext
	sjump Route16GateGuardRefusal

.Pass:
	end

Route16GateBicycleCheck8:
	checkitem BICYCLE
	iftrue .Pass
	opentext
	writetext Route16GateGuardWaitUpText
	waitbutton
	closetext
	applymovement PLAYER, Route16GateWalkUp1Movement
	sjump Route16GateGuardRefusal

.Pass:
	end

Route16GateBicycleCheck9:
	checkitem BICYCLE
	iftrue .Pass
	opentext
	writetext Route16GateGuardWaitUpText
	waitbutton
	closetext
	applymovement PLAYER, Route16GateWalkUp2Movement
	sjump Route16GateGuardRefusal

.Pass:
	end

Route16GateBicycleCheck10:
	checkitem BICYCLE
	iftrue .Pass
	opentext
	writetext Route16GateGuardWaitUpText
	waitbutton
	closetext
	applymovement PLAYER, Route16GateWalkUp3Movement
	sjump Route16GateGuardRefusal

.Pass:
	end

Route16GateGuardRefusal:
	opentext
	writetext Route16GateGuardNoPedestriansText
	waitbutton
	closetext
	applymovement PLAYER, Route16GateStepRightMovement
	end

Route16GateWalkUp1Movement:
	step UP
	step_end

Route16GateWalkUp2Movement:
	step UP
	step UP
	step_end

Route16GateWalkUp3Movement:
	step UP
	step UP
	step UP
	step_end

Route16GateStepRightMovement:
	step RIGHT
	step_end

; Yellow's Route16Gate1FGuardText is a text_asm that branches on the BICYCLE.
Route16GateOfficerScript:
	faceplayer
	opentext
	checkitem BICYCLE
	iftrue .HasBicycle
	writetext Route16GateGuardNoPedestriansText
	waitbutton
	closetext
	end

.HasBicycle:
	writetext Route16GateGuardCyclingRoadText
	waitbutton
	closetext
	end

Route16GateGentlemanScript:
	jumptextfaceplayer Route16GateGentlemanText

Route16GateGuardNoPedestriansText:
	text "No pedestrians"
	line "are allowed on"
	cont "CYCLING ROAD!"
	done

Route16GateGuardCyclingRoadText:
	text "CYCLING ROAD is a"
	line "downhill course"
	cont "by the sea. It's"
	cont "a great ride."
	done

Route16GateGuardWaitUpText:
	text "Excuse me! Wait"
	line "up please!"
	done

Route16GateGentlemanText:
	text "How'd you get in?"
	line "Good effort!"
	done

Route16Gate_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; Yellow's nine warps in Yellow's order.  1-4 are the lower (CYCLING ROAD)
; corridor, 5-8 the upper (north path) corridor, 9 the staircase.  Warp 4
; points at ROUTE 16's warp 3, not 4, exactly as Yellow has it.
	warp_event  0,  8, ROUTE_16, 1
	warp_event  0,  9, ROUTE_16, 2
	warp_event  7,  8, ROUTE_16, 3
	warp_event  7,  9, ROUTE_16, 3
	warp_event  0,  2, ROUTE_16, 5
	warp_event  0,  3, ROUTE_16, 6
	warp_event  7,  2, ROUTE_16, 7
	warp_event  7,  3, ROUTE_16, 8
	warp_event  6, 12, ROUTE_16_GATE_2F, 1

	def_coord_events
	coord_event  4,  7, SCENE_ROUTE16GATE_BICYCLE_CHECK, Route16GateBicycleCheck7
	coord_event  4,  8, SCENE_ROUTE16GATE_BICYCLE_CHECK, Route16GateBicycleCheck8
	coord_event  4,  9, SCENE_ROUTE16GATE_BICYCLE_CHECK, Route16GateBicycleCheck9
	coord_event  4, 10, SCENE_ROUTE16GATE_BICYCLE_CHECK, Route16GateBicycleCheck10

	def_bg_events

	def_object_events
	object_event  4,  5, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route16GateOfficerScript, -1
	object_event  4,  3, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route16GateGentlemanScript, -1
