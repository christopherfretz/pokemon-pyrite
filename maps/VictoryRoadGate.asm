	object_const_def
	const VICTORYROADGATE_OFFICER
	const VICTORYROADGATE_BLACK_BELT1
	const VICTORYROADGATE_BLACK_BELT2

VictoryRoadGate_MapScripts:
	def_scene_scripts
	scene_script VictoryRoadGateNoop1Scene, SCENE_VICTORYROADGATE_BADGE_CHECK
	scene_script VictoryRoadGateNoop2Scene, SCENE_VICTORYROADGATE_NOOP

	def_callbacks

VictoryRoadGateNoop1Scene:
	end

VictoryRoadGateNoop2Scene:
	end

VictoryRoadGateBadgeCheckScript:
	turnobject PLAYER, LEFT
	sjump _VictoryRoadGateBadgeCheckScript

VictoryRoadGateOfficerScript:
	faceplayer
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

VictoryRoadGateRightBlackBeltScript:
	jumptextfaceplayer VictoryRoadGateRightBlackBeltText

VictoryRoadGateStepDownMovement:
	step DOWN
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

VictoryRoadGateRightBlackBeltText:
	text "Off to the #MON"
	line "LEAGUE, are you?"

	para "The ELITE FOUR are"
	line "so strong it's"

	para "scary, and they're"
	line "ready for you!"
	done

VictoryRoadGate_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 17,  7, ROUTE_22, 1
	warp_event 18,  7, ROUTE_22, 1
	warp_event  9, 17, ROUTE_26, 1
	warp_event 10, 17, ROUTE_26, 1
	warp_event  9,  0, VICTORY_ROAD, 1
	warp_event 10,  0, VICTORY_ROAD, 1
	warp_event  1,  7, ROUTE_28, 2
	warp_event  2,  7, ROUTE_28, 2

	def_coord_events
	coord_event 10, 11, SCENE_VICTORYROADGATE_BADGE_CHECK, VictoryRoadGateBadgeCheckScript

	def_bg_events

	def_object_events
	object_event  8, 11, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VictoryRoadGateOfficerScript, -1
	object_event  7,  5, SPRITE_BLACK_BELT, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VictoryRoadGateLeftBlackBeltScript, EVENT_OPENED_MT_SILVER
	object_event 12,  5, SPRITE_BLACK_BELT, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VictoryRoadGateRightBlackBeltScript, EVENT_FOUGHT_SNORLAX
