	object_const_def
	const VICTORYROADGATE_OFFICER
	const VICTORYROADGATE_BLACK_BELT1
	const VICTORYROADGATE_ROUTE22_OFFICER ; Kanto hack (M10 13d): was BLACK_BELT2

; Kanto hack (M10 13d, docs/M10-INDIGO.md D112/D132): this hub is Yellow's
; ROUTE 22 GATE as well as Crystal's VICTORY ROAD GATE.
;
;  * EAST WING (Route 22 door (17,7)/(18,7)): Yellow's BOULDERBADGE guard
;    (vendor/pokeyellow/scripts/Route22Gate.asm).  The wing joins the centre
;    column only through the 1-wide row-5 corridor, entered at (16,5), and
;    (16,5) can only be stepped on from (17,5).  The OFFICER stands on (16,6),
;    off the corridor, facing it.  Crossing (16,5) without BOULDERBADGE plays
;    Yellow's text + SFX_DENIED (our SFX_WRONG) and steps the player back
;    RIGHT (Yellow steps DOWN: back the way he came).  With it, Yellow's pass
;    text + item jingle once, and the check retires for good -- Yellow's
;    SCRIPT_ROUTE22GATE_NOOP is persistent; ours is scene
;    SCENE_VICTORYROADGATE_BOULDER_PASSED.  Talking to him re-runs the check,
;    as Yellow's talk does (Route22GateGuardText is both).
;  * SOUTH (ROUTE_26) / WEST (ROUTE_28): Johto.  While EVENT_BEAT_KANTO_ELITE_FOUR
;    is clear, the (10,11) OFFICER refuses the 1-wide (10,11) choke point
;    whatever the badges and steps the player back UP, and the left BLACK BELT
;    (hidden only by EVENT_OPENED_MT_SILVER) keeps blocking the row-5 west
;    corridor.  With the flag set, both behave exactly as in Crystal (M11).
;  * NORTH door (9,0)/(10,0): ROUTE_23's south mouth (M10 13e-1), Yellow's
;    ROUTE 22 GATE north exit.  (13d parked it on itself, because Crystal's
;    VICTORY_ROAD behind it leads to Crystal's Silver fight and the Indigo
;    lobby's TELEPORT GUY -> NEW BARK, C-8/C-12.)
VictoryRoadGate_MapScripts:
	def_scene_scripts
	scene_script VictoryRoadGateNoop1Scene, SCENE_VICTORYROADGATE_BADGE_CHECK
	scene_script VictoryRoadGateNoop2Scene, SCENE_VICTORYROADGATE_NOOP
	scene_script VictoryRoadGateNoop3Scene, SCENE_VICTORYROADGATE_BOULDER_PASSED ; Kanto hack (M10 13d)

	def_callbacks

VictoryRoadGateNoop1Scene:
	end

VictoryRoadGateNoop2Scene:
	end

VictoryRoadGateNoop3Scene:
	end

VictoryRoadGateBadgeCheckScript:
	turnobject PLAYER, LEFT
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue _VictoryRoadGateBadgeCheckScript
; Kanto hack (M10 13d, D132): Kanto act -- the road south (ROUTE_26) is Johto's
; and stays shut until the Kanto HALL OF FAME.  The player can only reach this
; tile from the north here, so the step back is UP.
	opentext
	writetext VictoryRoadGateRoadClosedText
	waitbutton
	closetext
	applymovement PLAYER, VictoryRoadGateStepUpMovement
	end

VictoryRoadGateOfficerScript:
	faceplayer
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue _VictoryRoadGateBadgeCheckScript
	jumptext VictoryRoadGateRoadClosedText

_VictoryRoadGateBadgeCheckScript:
	opentext
	writetext VictoryRoadGateOfficerText
	promptbutton
	readvar VAR_BADGES
	ifgreater NUM_JOHTO_BADGES - 1, .AllEightBadges
	writetext VictoryRoadGateNotEnoughBadgesText
	waitbutton
	closetext
	applymovement PLAYER, VictoryRoadGateStepDownMovement
	end

.AllEightBadges:
	writetext VictoryRoadGateEightBadgesText
	waitbutton
	closetext
	setscene SCENE_VICTORYROADGATE_NOOP
	end

; Kanto hack (N1c, audit edit 86): the audit assumed EVENT_OPENED_MT_SILVER kept
; this Black Belt latent during the Kanto act.  It does the opposite - the
; trailing event flag is a HIDE flag, so with EVENT_OPENED_MT_SILVER clear he is
; LIVE from day one and points the player at MT.SILVER.  Retexted instead: the
; MT.SILVER line is kept verbatim for Crystal's Johto act behind ENGINE_POKEGEAR
; (the N1a Kanto-act predicate), and the Kanto act gets Yellow's Route 22 Gate
; guard line (_Route22GateGuardNoBoulderbadgeText, first paragraph).
VictoryRoadGateLeftBlackBeltScript:
	faceplayer
	opentext
	checkflag ENGINE_POKEGEAR
	iftrue .Johto
	writetext VictoryRoadGateLeftBlackBeltKantoText
	waitbutton
	closetext
	end

.Johto:
	writetext VictoryRoadGateLeftBlackBeltText
	waitbutton
	closetext
	end

; Kanto hack (M10 13d): Yellow's ROUTE 22 GATE guard (Route22GateGuardText),
; replacing Crystal's right BLACK BELT (hidden by EVENT_FOUGHT_SNORLAX, which
; nothing sets, so he sealed the corridor for good -- C-9).
VictoryRoadGateBoulderCheckScript:
	turnobject VICTORYROADGATE_ROUTE22_OFFICER, UP
	checkflag ENGINE_BOULDERBADGE
	iftrue VictoryRoadGateBoulderPassScript
	opentext
	writetext VictoryRoadGateNoBoulderBadgeText
	playsound SFX_WRONG
	waitsfx
	writetext VictoryRoadGateRulesAreRulesText
	waitbutton
	closetext
	applymovement PLAYER, VictoryRoadGateStepRightMovement
	end

VictoryRoadGateRoute22OfficerScript:
	faceplayer
	checkflag ENGINE_BOULDERBADGE
	iftrue VictoryRoadGateBoulderPassScript
; Talking from beside him (not on the corridor): the same lines, but no step
; back -- there is nothing to undo.
	opentext
	writetext VictoryRoadGateNoBoulderBadgeText
	playsound SFX_WRONG
	waitsfx
	writetext VictoryRoadGateRulesAreRulesText
	waitbutton
	closetext
	end

VictoryRoadGateBoulderPassScript:
	opentext
	writetext VictoryRoadGateGoRightAheadText
	waitbutton
	closetext
	checkscene
	ifnotequal SCENE_VICTORYROADGATE_BADGE_CHECK, .done
	setscene SCENE_VICTORYROADGATE_BOULDER_PASSED
.done
	end

VictoryRoadGateStepDownMovement:
	step DOWN
	step_end

VictoryRoadGateStepUpMovement:
	step UP
	step_end

VictoryRoadGateStepRightMovement:
	step RIGHT
	step_end

VictoryRoadGateOfficerText:
	text "Only trainers who"
	line "have proven them-"
	cont "selves may pass."
	done

; Kanto hack (N1c): region-neutral.  Kanto is played first, so "the GYM BADGES
; of JOHTO" is wrong here; VAR_BADGES counts wJohtoBadges + wKantoBadges and
; NUM_JOHTO_BADGES - 1 == NUM_KANTO_BADGES - 1 == 7, so the test itself is
; already right for both acts.  Yellow's Route 23 guard is the wording model
; (_Route23YouDontHaveTheBadgeYetText / _Route23GoRightAheadText).
VictoryRoadGateNotEnoughBadgesText:
	text "You don't have all"
	line "eight GYM BADGES."

	para "I'm sorry, but I"
	line "can't let you go"
	cont "through."
	done

VictoryRoadGateEightBadgesText:
	text "Oh! All eight of"
	line "the GYM BADGES!"

	para "Please, go right"
	line "on through!"
	done

; Kanto hack (N1c): Yellow's _Route22GateGuardNoBoulderbadgeText, first
; paragraph verbatim (the badge sentence belongs to the officer's check).
VictoryRoadGateLeftBlackBeltKantoText:
	text "Only truly skilled"
	line "trainers are"
	cont "allowed through."
	done

VictoryRoadGateLeftBlackBeltText:
	text "This way leads to"
	line "MT.SILVER."

	para "You'll see scary-"
	line "strong #MON out"
	cont "there."
	done

; Kanto hack (M10 13d): Yellow text/Route22Gate.asm, verbatim.  Yellow ends the
; first text with "@" and plays SFX_DENIED from its text_asm before the second,
; which opens with a paragraph break; writetext + playsound + writetext is the
; same sequence (the <PARA> waits for A over the first text, then clears).
VictoryRoadGateNoBoulderBadgeText:
	text "Only truly skilled"
	line "trainers are"
	cont "allowed through."

	para "You don't have the"
	line "BOULDERBADGE yet!"
	done

VictoryRoadGateRulesAreRulesText:
	text_start

	para "The rules are"
	line "rules. I can't"
	cont "let you pass."
	done

; Yellow: "...Go right ahead!@" then sound_get_item_1 -- GSC's TX_SOUND_ITEM
; is a text command, so the string is closed first (SilphCoCardKeyDoors.asm).
VictoryRoadGateGoRightAheadText:
	text "Oh! That is the"
	line "BOULDERBADGE!"
	cont "Go right ahead!@"
	sound_item
	text_end

; Kanto hack (M10 13d, D132): OUR text, not Yellow's (Yellow's gate has no
; south door).  Written in the Yellow guards' register.
VictoryRoadGateRoadClosedText:
	text "Sorry! The road"
	line "beyond is closed."

	para "The #MON LEAGUE"
	line "is up north!"
	done

VictoryRoadGate_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 17,  7, ROUTE_22, 1
	warp_event 18,  7, ROUTE_22, 1
	warp_event  9, 17, ROUTE_26, 1
	warp_event 10, 17, ROUTE_26, 1
	; Kanto hack (M10 13e-1): the north door is Yellow's ROUTE 22 GATE north
	; exit, onto ROUTE_23's south mouth (7,139)/(8,139) (Crystal had
	; VICTORY_ROAD, 1).
	warp_event  9,  0, ROUTE_23, 1
	warp_event 10,  0, ROUTE_23, 2
	warp_event  1,  7, ROUTE_28, 2
	warp_event  2,  7, ROUTE_28, 2

	def_coord_events
	coord_event 10, 11, SCENE_VICTORYROADGATE_BADGE_CHECK, VictoryRoadGateBadgeCheckScript
	coord_event 10, 11, SCENE_VICTORYROADGATE_BOULDER_PASSED, VictoryRoadGateBadgeCheckScript ; Kanto hack (M10 13d)
	coord_event 16,  5, SCENE_VICTORYROADGATE_BADGE_CHECK, VictoryRoadGateBoulderCheckScript ; Kanto hack (M10 13d): Yellow's ROUTE 22 GATE

	def_bg_events

	def_object_events
	object_event  8, 11, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VictoryRoadGateOfficerScript, -1
	object_event  7,  5, SPRITE_BLACK_BELT, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VictoryRoadGateLeftBlackBeltScript, EVENT_OPENED_MT_SILVER
	object_event 16,  6, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VictoryRoadGateRoute22OfficerScript, -1 ; Kanto hack (M10 13d): was Crystal's right BLACK BELT (12,5)
