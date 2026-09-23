; VICTORY ROAD 1F (M10 13f geometry; 13g adds boulders, switch, trainers, items).
;
; Yellow's 10x9 VICTORY_ROAD_1F re-cut on TILESET_CAVE by scripts/vr_blk.py.
; This map is Crystal's old VICTORY_ROAD (id 90) renamed; Crystal's 10x36
; layout, its Silver fight and its five items are gone (docs/M10-INDIGO.md
; "## 13f findings", C-12).
;
; Warps are Yellow's (vendor/pokeyellow/data/maps/objects/VictoryRoad1F.asm):
; the mouth (8,17)/(9,17) returns to ROUTE_23 warp 3 (Yellow: LAST_MAP, 3),
; the ladder (1,1) climbs to 2F.
;
; 13g: boulder switch TILE (17,13); the barrier is BLOCK (4,6) -- $60 closed,
; changeblock to stock $0d when open (Yellow's ReplaceTileBlock $1d).

	object_const_def
	const VICTORYROAD1F_COOLTRAINER_F
	const VICTORYROAD1F_COOLTRAINER_M
	const VICTORYROAD1F_TM_SKY_ATTACK
	const VICTORYROAD1F_RARE_CANDY
	const VICTORYROAD1F_BOULDER1
	const VICTORYROAD1F_BOULDER2
	const VICTORYROAD1F_BOULDER3

VictoryRoad1F_MapScripts:
	def_scene_scripts
	scene_script VictoryRoad1FSwitchScene ; 0 -- wVictoryRoadSceneID, shared by all three floors and never changed

	def_callbacks
	callback MAPCALLBACK_TILES, VictoryRoad1FSwitchCallback

; 13g: Yellow's VictoryRoad1F_Script re-applies the open barrier from the flag
; on map load; so does this.  2F clears the flag on every entry (Yellow's
; VictoryRoad2FResetBoulderEventScript), so the barrier re-closes behind a
; player who climbs to 2F and comes back down.
VictoryRoad1FSwitchCallback:
	checkevent EVENT_VICTORY_ROAD_1F_BOULDER_ON_SWITCH
	iffalse .done
	changeblock 8, 12, $0d ; Yellow block (4,6) -> $1d
.done
	endcallback

; 13g: Yellow's VictoryRoad1FDefaultScript checks the boulder the player just
; pushed against the switch tile every frame.  The scene script polls the same
; thing: VictoryRoadBoulderSwitchCheck (VictoryRoad2F.asm) returns the 1-based
; index of the first switch whose flag is clear and that has a resting
; STRENGTH boulder on it.  No sound: Yellow's ReplaceTileBlock plays none.
VictoryRoad1FSwitchScene:
	callasm VictoryRoad1FSwitchCheck
	ifequal 1, .Switch
	end

.Switch:
	sdefer VictoryRoad1FSwitchScript
	end

VictoryRoad1FSwitchScript:
	setevent EVENT_VICTORY_ROAD_1F_BOULDER_ON_SWITCH
	changeblock 8, 12, $0d
	reloadmappart
	end

TrainerVictoryRoad1FCooltrainerF:
	trainer COOLTRAINERF, COOLTRAINERF_VICTORY_ROAD_1, EVENT_BEAT_VICTORY_ROAD_1F_TRAINER_0, VictoryRoad1FCooltrainerFBattleText, VictoryRoad1FCooltrainerFEndBattleText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext VictoryRoad1FCooltrainerFAfterBattleText
	waitbutton
	closetext
	end

TrainerVictoryRoad1FCooltrainerM:
	trainer COOLTRAINERM, COOLTRAINERM_VICTORY_ROAD_1, EVENT_BEAT_VICTORY_ROAD_1F_TRAINER_1, VictoryRoad1FCooltrainerMBattleText, VictoryRoad1FCooltrainerMEndBattleText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext VictoryRoad1FCooltrainerMAfterBattleText
	waitbutton
	closetext
	end

VictoryRoad1FTMSkyAttack:
	itemball TM_SKY_ATTACK

VictoryRoad1FRareCandy:
	itemball RARE_CANDY

VictoryRoad1FBoulder:
	jumpstd StrengthBoulderScript

VictoryRoad1FCooltrainerFBattleText:
	text "I wonder if you"
	line "are good enough"
	cont "for me!"
	done

VictoryRoad1FCooltrainerFEndBattleText:
	text "I"
	line "lost out!"
	done

VictoryRoad1FCooltrainerFAfterBattleText:
	text "I never wanted to"
	line "lose to anybody!"
	done

VictoryRoad1FCooltrainerMBattleText:
	text "I can see you're"
	line "good! Let me see"
	cont "exactly how good!"
	done

VictoryRoad1FCooltrainerMEndBattleText:
	text "I"
	line "had a chance..."
	done

VictoryRoad1FCooltrainerMAfterBattleText:
	text "I concede, you're"
	line "better than me!"
	done

VictoryRoad1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  8, 17, ROUTE_23, 3
	warp_event  9, 17, ROUTE_23, 3
	warp_event  1,  1, VICTORY_ROAD_2F, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  7,  5, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerVictoryRoad1FCooltrainerF, -1
	object_event  3,  2, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerVictoryRoad1FCooltrainerM, -1
	object_event 11,  0, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, VictoryRoad1FTMSkyAttack, EVENT_VICTORY_ROAD_1F_TM_SKY_ATTACK
	object_event  9,  2, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, VictoryRoad1FRareCandy, EVENT_VICTORY_ROAD_1F_RARE_CANDY
	object_event  5, 15, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VictoryRoad1FBoulder, -1
	object_event 14,  2, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VictoryRoad1FBoulder, -1
	object_event  2, 10, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VictoryRoad1FBoulder, -1
