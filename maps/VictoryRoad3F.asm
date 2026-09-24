; VICTORY ROAD 3F (M10 13f geometry; 13g adds boulders, switch, trainers, items).
;
; Yellow's 15x9 VICTORY_ROAD_3F on TILESET_KANTO_CAVE (CT1, scripts/ct1_kanto_cave.py).  Warps 1-4
; are Yellow's, in Yellow's order
; (vendor/pokeyellow/data/maps/objects/VictoryRoad3F.asm).  Warp 5 is the
; boulder HOLE at (23,15) (Yellow block $69 -> CT1 clone $a1, COLL_PIT): Yellow drops the player to
; 2F (22,16) (IsPlayerOnDungeonWarp + special_warps.asm fly_warp), so here it
; is an ordinary warp_event onto 2F's anchor warp 8.  Yellow drops the player
; whether or not a boulder has gone down first (VictoryRoad3FDefaultScript
; .check_switch_hole runs unconditionally), so the warp needs no gate.
;
; 13g: the switch TILE (3,5) opens BLOCK (3,5) $25 -> $1d (Yellow's ids, CT1).

	object_const_def
	const VICTORYROAD3F_COOLTRAINER_M1
	const VICTORYROAD3F_COOLTRAINER_F1
	const VICTORYROAD3F_COOLTRAINER_M2
	const VICTORYROAD3F_COOLTRAINER_F2
	const VICTORYROAD3F_MAX_REVIVE
	const VICTORYROAD3F_TM_EXPLOSION
	const VICTORYROAD3F_BOULDER1
	const VICTORYROAD3F_BOULDER2
	const VICTORYROAD3F_BOULDER3
	const VICTORYROAD3F_BOULDER4

VictoryRoad3F_MapScripts:
	def_scene_scripts
	scene_script VictoryRoad3FSwitchScene ; 0 -- wVictoryRoadSceneID, shared with 1F/2F

	def_callbacks
	callback MAPCALLBACK_TILES, VictoryRoad3FSwitchCallback
	callback MAPCALLBACK_CMDQUEUE, VictoryRoad3FSetUpStoneTableCallback

; Yellow's VictoryRoad3FCheckBoulderEventScript.
VictoryRoad3FSwitchCallback:
	checkevent EVENT_VICTORY_ROAD_3F_BOULDER_ON_SWITCH1
	iffalse .done
	changeblock 6, 10, $1d ; Yellow block (3,5) -> $1d
.done
	endcallback

VictoryRoad3FSwitchScene:
	callasm VictoryRoad3FSwitchCheck
	ifequal 1, .Switch
	end

.Switch:
	sdefer VictoryRoad3FSwitchScript
	end

VictoryRoad3FSwitchScript:
	setevent EVENT_VICTORY_ROAD_3F_BOULDER_ON_SWITCH1
	changeblock 6, 10, $1d
	reloadmappart
	end

; --- 13g: the HOLE (23,15) --------------------------------------------------
; Unlike the switches, the hole is COLL_PIT, so Seafoam's stone table works: a
; boulder that comes to rest on warp 5 runs its script.  Yellow's .handle_hole
; sets EVENT_VICTORY_ROAD_3_BOULDER_ON_SWITCH2 once, hides BOULDER4 and shows
; 2F's BOULDER3 at (23,16).  Only BOULDER4 is listed: it is the one Yellow
; hides, and the harness shows no other 3F boulder can reach (23,15)
; (docs/M10-INDIGO.md "## 13g findings").
VictoryRoad3FSetUpStoneTableCallback:
	writecmdqueue .CommandQueue
	endcallback

.CommandQueue:
	cmdqueue CMDQUEUE_STONETABLE, .StoneTable ; check if any stones are sitting on a warp

.StoneTable:
	stonetable 5, VICTORYROAD3F_BOULDER4, .Boulder4
	db -1 ; end

.Boulder4:
	disappear VICTORYROAD3F_BOULDER4
	setevent EVENT_VICTORY_ROAD_3F_BOULDER_ON_SWITCH2 ; = BOULDER4's hide flag
	clearevent EVENT_VICTORY_ROAD_2F_BOULDER_HIDDEN
	pause 15
	end

TrainerVictoryRoad3FCooltrainerM1:
	trainer COOLTRAINERM, COOLTRAINERM_VICTORY_ROAD_2, EVENT_BEAT_VICTORY_ROAD_3F_TRAINER_0, VictoryRoad3FCooltrainerM1BattleText, VictoryRoad3FCooltrainerM1EndBattleText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext VictoryRoad3FCooltrainerM1AfterBattleText
	waitbutton
	closetext
	end

TrainerVictoryRoad3FCooltrainerF1:
	trainer COOLTRAINERF, COOLTRAINERF_VICTORY_ROAD_2, EVENT_BEAT_VICTORY_ROAD_3F_TRAINER_1, VictoryRoad3FCooltrainerF1BattleText, VictoryRoad3FCooltrainerF1EndBattleText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext VictoryRoad3FCooltrainerF1AfterBattleText
	waitbutton
	closetext
	end

TrainerVictoryRoad3FCooltrainerM2:
	trainer COOLTRAINERM, COOLTRAINERM_VICTORY_ROAD_3, EVENT_BEAT_VICTORY_ROAD_3F_TRAINER_2, VictoryRoad3FCooltrainerM2BattleText, VictoryRoad3FCooltrainerM2EndBattleText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext VictoryRoad3FCooltrainerM2AfterBattleText
	waitbutton
	closetext
	end

TrainerVictoryRoad3FCooltrainerF2:
	trainer COOLTRAINERF, COOLTRAINERF_VICTORY_ROAD_3, EVENT_BEAT_VICTORY_ROAD_3F_TRAINER_3, VictoryRoad3FCooltrainerF2BattleText, VictoryRoad3FCooltrainerF2EndBattleText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext VictoryRoad3FCooltrainerF2AfterBattleText
	waitbutton
	closetext
	end

VictoryRoad3FMaxRevive:
	itemball MAX_REVIVE

VictoryRoad3FTMExplosion:
	itemball TM_EXPLOSION

VictoryRoad3FBoulder:
	jumpstd StrengthBoulderScript

VictoryRoad3FCooltrainerM1BattleText:
	text "I heard rumors of"
	line "a child prodigy!"
	done

VictoryRoad3FCooltrainerM1EndBattleText:
	text "The"
	line "rumors were true!"
	done

VictoryRoad3FCooltrainerM1AfterBattleText:
	text "You beat GIOVANNI"
	line "of TEAM ROCKET?"
	done

VictoryRoad3FCooltrainerF1BattleText:
	text "I'll show you just"
	line "how good you are!"
	done

VictoryRoad3FCooltrainerF1EndBattleText:
	text "I'm"
	line "furious!"
	done

VictoryRoad3FCooltrainerF1AfterBattleText:
	text "You showed me just"
	line "how good I was!"
	done

VictoryRoad3FCooltrainerM2BattleText:
	text "Only the chosen"
	line "can pass here!"
	done

VictoryRoad3FCooltrainerM2EndBattleText:
	text "I"
	line "don't believe it!"
	done

VictoryRoad3FCooltrainerM2AfterBattleText:
	text "All trainers here"
	line "are headed to the"
	cont "#MON LEAGUE!"
	cont "Be careful!"
	done

VictoryRoad3FCooltrainerF2BattleText:
	text "Trainers live to"
	line "seek stronger"
	cont "opponents!"
	done

VictoryRoad3FCooltrainerF2EndBattleText:
	text "Oh!"
	line "So strong!"
	done

VictoryRoad3FCooltrainerF2AfterBattleText:
	text "By fighting tough"
	line "battles, you get"
	cont "stronger!"
	done

VictoryRoad3F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 23,  7, VICTORY_ROAD_2F, 4
	warp_event 26,  8, VICTORY_ROAD_2F, 6
	warp_event 27, 15, VICTORY_ROAD_2F, 5
	warp_event  2,  0, VICTORY_ROAD_2F, 7
	warp_event 23, 15, VICTORY_ROAD_2F, 8 ; the hole

	def_coord_events

	def_bg_events

	def_object_events
	object_event 28,  5, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 1, TrainerVictoryRoad3FCooltrainerM1, -1
	object_event  7, 13, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerVictoryRoad3FCooltrainerF1, -1
	object_event  6, 14, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerVictoryRoad3FCooltrainerM2, -1
	object_event 13,  3, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerVictoryRoad3FCooltrainerF2, -1
	object_event 26,  5, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, VictoryRoad3FMaxRevive, EVENT_VICTORY_ROAD_3F_MAX_REVIVE
	object_event  7,  7, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, VictoryRoad3FTMExplosion, EVENT_VICTORY_ROAD_3F_TM_EXPLOSION
	object_event 22,  3, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VictoryRoad3FBoulder, -1
	object_event 13, 12, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VictoryRoad3FBoulder, -1
	object_event 24, 10, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VictoryRoad3FBoulder, -1
	object_event 22, 15, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VictoryRoad3FBoulder, EVENT_VICTORY_ROAD_3F_BOULDER_ON_SWITCH2 ; Yellow BOULDER4: the one that goes down the hole
