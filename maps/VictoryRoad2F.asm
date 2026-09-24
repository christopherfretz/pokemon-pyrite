; VICTORY ROAD 2F (M10 13f geometry; 13g adds boulders, switches, trainers,
; items and MOLTRES).
;
; Yellow's 15x9 VICTORY_ROAD_2F on TILESET_KANTO_CAVE (CT1, scripts/ct1_kanto_cave.py).  Warps 1-7
; are Yellow's, in Yellow's order
; (vendor/pokeyellow/data/maps/objects/VictoryRoad2F.asm).  Warps 2-3 are the
; east exit onto ROUTE_23 (14,31) (Yellow: LAST_MAP, 4): Yellow walks off the
; map edge there, so the tiles are WARP_CARPET_RIGHT.
; Warp 8 is the inert landing anchor for 3F's hole at (23,15): Yellow's
; fly_warp VICTORY_ROAD_2F, 22, 16 (vendor/pokeyellow/data/maps/special_warps.asm).
; It sits on plain floor, so stepping on it does nothing.
;
; 13g: switch 1 TILE (1,16) opens BLOCK (3,4) $98 -> $83 (CT1 clones of Yellow $37 -> $15);
; switch 2 TILE (9,16) opens BLOCK (11,7) $25 -> $1d (Yellow's ids, CT1).

MACRO vr_switch
; x, y, event flag
	db \1, \2
	dw \3
ENDM

	object_const_def
	const VICTORYROAD2F_BLACKBELT
	const VICTORYROAD2F_JUGGLER1
	const VICTORYROAD2F_TAMER
	const VICTORYROAD2F_POKEMANIAC
	const VICTORYROAD2F_JUGGLER2
	const VICTORYROAD2F_MOLTRES
	const VICTORYROAD2F_TM_SUBMISSION
	const VICTORYROAD2F_FULL_HEAL
	const VICTORYROAD2F_TM_MEGA_KICK
	const VICTORYROAD2F_GUARD_SPEC
	const VICTORYROAD2F_BOULDER1
	const VICTORYROAD2F_BOULDER2
	const VICTORYROAD2F_BOULDER3

VictoryRoad2F_MapScripts:
	def_scene_scripts
	scene_script VictoryRoad2FSwitchScene ; 0 -- wVictoryRoadSceneID, shared with 1F/3F

	def_callbacks
	callback MAPCALLBACK_NEWMAP, VictoryRoad2FResetCallback
	callback MAPCALLBACK_TILES, VictoryRoad2FSwitchCallback

; 13g: Yellow's VictoryRoad2FResetBoulderEventScript runs on every 2F load and
; clears the 1F switch, so 1F's barrier is shut again when the player returns.
VictoryRoad2FResetCallback:
	clearevent EVENT_VICTORY_ROAD_1F_BOULDER_ON_SWITCH
	endcallback

; Yellow's VictoryRoad2FCheckBoulderEventScript: re-open both barriers from
; their flags.  Only ROUTE 23's NEWMAP clears these two.
VictoryRoad2FSwitchCallback:
	checkevent EVENT_VICTORY_ROAD_2F_BOULDER_ON_SWITCH1
	iffalse .switch2
	changeblock 6, 8, $83 ; Yellow block (3,4) -> $15; CT1 clone $83 keeps its UP_WALL top edge
.switch2
	checkevent EVENT_VICTORY_ROAD_2F_BOULDER_ON_SWITCH2
	iffalse .done
	changeblock 22, 14, $1d ; Yellow block (11,7) -> $1d
.done
	endcallback

VictoryRoad2FSwitchScene:
	callasm VictoryRoad2FSwitchCheck
	ifequal 1, .Switch1
	ifequal 2, .Switch2
	end

.Switch1:
	sdefer VictoryRoad2FSwitch1Script
	end

.Switch2:
	sdefer VictoryRoad2FSwitch2Script
	end

VictoryRoad2FSwitch1Script:
	setevent EVENT_VICTORY_ROAD_2F_BOULDER_ON_SWITCH1
	changeblock 6, 8, $83
	reloadmappart
	end

VictoryRoad2FSwitch2Script:
	setevent EVENT_VICTORY_ROAD_2F_BOULDER_ON_SWITCH2
	changeblock 22, 14, $1d
	reloadmappart
	end

; --- 13g: the boulder-switch poll, shared by all three floors ---------------
; Crystal's stone queue (CmdQueue_StoneTable) only looks at boulders resting on
; a PIT tile, so it cannot see a boulder on a FLOOR switch (D121's warp_event
; plan does not fire).  Instead each floor's scene script calls one of the
; entry points below every overworld frame.  wScriptVar <- the 1-based index
; of the first table entry whose flag is still clear and on whose tile a
; STRENGTH boulder is standing (not mid-push), else 0.  The Pikachu follower is
; never SPRITEMOVEDATA_STRENGTH_BOULDER, which is Yellow's
; `cp PIKACHU_SPRITE_INDEX` exclusion for free.
VictoryRoad1FSwitchCheck:
	ld hl, .Switches
	jr VictoryRoadBoulderSwitchCheck

.Switches:
	vr_switch 17, 13, EVENT_VICTORY_ROAD_1F_BOULDER_ON_SWITCH
	db -1

VictoryRoad2FSwitchCheck:
	ld hl, .Switches
	jr VictoryRoadBoulderSwitchCheck

.Switches:
	vr_switch  1, 16, EVENT_VICTORY_ROAD_2F_BOULDER_ON_SWITCH1
	vr_switch  9, 16, EVENT_VICTORY_ROAD_2F_BOULDER_ON_SWITCH2
	db -1

VictoryRoad3FSwitchCheck:
	ld hl, .Switches
	jr VictoryRoadBoulderSwitchCheck

.Switches:
	vr_switch  3,  5, EVENT_VICTORY_ROAD_3F_BOULDER_ON_SWITCH1
	db -1

VictoryRoadBoulderSwitchCheck:
	ld c, 0
.loop
	inc c
	ld a, [hli] ; x
	cp -1
	jr z, .none
	ld d, a
	ld a, [hli] ; y
	ld e, a
	push hl
	push bc
	call .BoulderAt
	pop bc
	pop hl
	jr nc, .skip
	push hl
	push bc
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	pop bc
	pop hl
	and a
	jr z, .found
.skip
	inc hl
	inc hl
	jr .loop

.found
	ld a, c
	ld [wScriptVar], a
	ret

.none
	xor a
	ld [wScriptVar], a
	ret

.BoulderAt:
; carry iff a STANDING strength boulder sits on tile (d, e)
	ld hl, wPlayerStruct
	ld a, NUM_OBJECT_STRUCTS
.oloop
	push af
	push hl
	ld a, [hl] ; OBJECT_SPRITE
	and a
	jr z, .onext
	ld bc, OBJECT_MOVEMENT_TYPE
	add hl, bc
	ld a, [hl]
	cp SPRITEMOVEDATA_STRENGTH_BOULDER
	jr nz, .onext
	pop hl
	push hl
	ld bc, OBJECT_WALKING
	add hl, bc
	ld a, [hl]
	cp STANDING
	jr nz, .onext
	pop hl
	push hl
	ld bc, OBJECT_MAP_X
	add hl, bc
	ld a, [hli]
	sub 4
	cp d
	jr nz, .onext
	ld a, [hl] ; OBJECT_MAP_Y
	sub 4
	cp e
	jr nz, .onext
	pop hl
	pop af
	scf
	ret

.onext
	pop hl
	ld bc, OBJECT_LENGTH
	add hl, bc
	pop af
	dec a
	jr nz, .oloop
	and a
	ret

; --- trainers ----------------------------------------------------------------
TrainerVictoryRoad2FBlackbelt:
	trainer BLACKBELT_T, BLACKBELT_VICTORY_ROAD, EVENT_BEAT_VICTORY_ROAD_2F_TRAINER_0, VictoryRoad2FHikerBattleText, VictoryRoad2FHikerEndBattleText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext VictoryRoad2FHikerAfterBattleText
	waitbutton
	closetext
	end

TrainerVictoryRoad2FJuggler1:
	trainer JUGGLER, JUGGLER_10, EVENT_BEAT_VICTORY_ROAD_2F_TRAINER_1, VictoryRoad2FSuperNerd1BattleText, VictoryRoad2FSuperNerd1EndBattleText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext VictoryRoad2FSuperNerd1AfterBattleText
	waitbutton
	closetext
	end

TrainerVictoryRoad2FTamer:
	trainer TAMER, TAMER_5, EVENT_BEAT_VICTORY_ROAD_2F_TRAINER_2, VictoryRoad2FCooltrainerMBattleText, VictoryRoad2FCooltrainerMEndBattleText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext VictoryRoad2FCooltrainerMAfterBattleText
	waitbutton
	closetext
	end

TrainerVictoryRoad2FPokemaniac:
	trainer POKEMANIAC, POKEMANIAC_VICTORY_ROAD, EVENT_BEAT_VICTORY_ROAD_2F_TRAINER_3, VictoryRoad2FSuperNerd2BattleText, VictoryRoad2FSuperNerd2EndBattleText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext VictoryRoad2FSuperNerd2AfterBattleText
	waitbutton
	closetext
	end

TrainerVictoryRoad2FJuggler2:
	trainer JUGGLER, JUGGLER_11, EVENT_BEAT_VICTORY_ROAD_2F_TRAINER_4, VictoryRoad2FSuperNerd3BattleText, VictoryRoad2FSuperNerd3EndBattleText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext VictoryRoad2FSuperNerd3AfterBattleText
	waitbutton
	closetext
	end

; --- 13g: MOLTRES -----------------------------------------------------------
; M9 12f's ARTICUNO pattern (SeafoamIslandsB4F.asm): Yellow's bird is a
; sight-0 "trainer" whose EndTrainerBattle hides it on a WIN, a CATCH *and* a
; successful RUN; only a blackout leaves it in place.
VictoryRoad2FMoltres:
	faceplayer
	opentext
	writetext VictoryRoad2FMoltresText
	cry MOLTRES
	waitbutton
	closetext
	loadwildmon MOLTRES, 50
	loadvar VAR_BATTLETYPE, BATTLETYPE_NORMAL
	startbattle
	ifequal LOSE, .Fainted
	setevent EVENT_BEAT_MOLTRES ; = the object's hide flag
	disappear VICTORYROAD2F_MOLTRES
	reloadmapafterbattle
	end

.Fainted:
	reloadmapafterbattle ; jp's straight to the whiteout
	end

VictoryRoad2FTMSubmission:
	itemball TM_SUBMISSION

VictoryRoad2FFullHeal:
	itemball FULL_HEAL

VictoryRoad2FTMMegaKick:
	itemball TM_MEGA_KICK

VictoryRoad2FGuardSpec:
	itemball GUARD_SPEC

VictoryRoad2FHiddenUltraBall:
	hiddenitem ULTRA_BALL, EVENT_VICTORY_ROAD_2F_HIDDEN_ULTRA_BALL

VictoryRoad2FHiddenFullRestore:
	hiddenitem FULL_RESTORE, EVENT_VICTORY_ROAD_2F_HIDDEN_FULL_RESTORE

VictoryRoad2FBoulder:
	jumpstd StrengthBoulderScript

VictoryRoad2FMoltresText:
	text "Gyaoo!"
	done

VictoryRoad2FHikerBattleText:
	text "VICTORY ROAD is"
	line "the final test"
	cont "for trainers!"
	done

VictoryRoad2FHikerEndBattleText:
	text "Aiyah!"
	done

VictoryRoad2FHikerAfterBattleText:
	text "If you get stuck,"
	line "try moving some"
	cont "boulders around!"
	done

VictoryRoad2FSuperNerd1BattleText:
	text "Ah, so you wish"
	line "to challenge the"
	cont "ELITE FOUR?"
	done

VictoryRoad2FSuperNerd1EndBattleText:
	text "You"
	line "got me!"
	done

VictoryRoad2FSuperNerd1AfterBattleText:
	text "<RIVAL> also came"
	line "through here!"
	done

VictoryRoad2FCooltrainerMBattleText:
	text "Come on!"
	line "I'll whip you!"
	done

VictoryRoad2FCooltrainerMEndBattleText:
	text "I got"
	line "whipped!"
	done

VictoryRoad2FCooltrainerMAfterBattleText:
	text "You earned the"
	line "right to be on"
	cont "VICTORY ROAD!"
	done

VictoryRoad2FSuperNerd2BattleText:
	text "If you can get"
	line "through here, you"
	cont "can go meet the"
	cont "ELITE FOUR!"
	done

VictoryRoad2FSuperNerd2EndBattleText:
	text "No!"
	line "Unbelievable!"
	done

VictoryRoad2FSuperNerd2AfterBattleText:
	text "I can beat you"
	line "when it comes to"
	cont "knowledge about"
	cont "#MON!"
	done

VictoryRoad2FSuperNerd3BattleText:
	text "Is VICTORY ROAD"
	line "too tough?"
	done

VictoryRoad2FSuperNerd3EndBattleText:
	text "Well"
	line "done!"
	done

VictoryRoad2FSuperNerd3AfterBattleText:
	text "Many trainers give"
	line "up the challenge"
	cont "here."
	done

VictoryRoad2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  0,  8, VICTORY_ROAD_1F, 3
	warp_event 29,  7, ROUTE_23, 4
	warp_event 29,  8, ROUTE_23, 4
	warp_event 23,  7, VICTORY_ROAD_3F, 1
	warp_event 25, 14, VICTORY_ROAD_3F, 3
	warp_event 27,  7, VICTORY_ROAD_3F, 2
	warp_event  1,  1, VICTORY_ROAD_3F, 4
	warp_event 22, 16, VICTORY_ROAD_3F, 5 ; hole landing (anchor)

	def_coord_events

	def_bg_events
	bg_event  5,  2, BGEVENT_ITEM, VictoryRoad2FHiddenUltraBall ; Yellow data/events/hidden_events.asm
	bg_event 26,  7, BGEVENT_ITEM, VictoryRoad2FHiddenFullRestore

	def_object_events
	object_event 12,  9, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerVictoryRoad2FBlackbelt, -1 ; Yellow SPRITE_HIKER
	object_event 21, 13, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerVictoryRoad2FJuggler1, -1
	object_event 19,  8, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerVictoryRoad2FTamer, -1
	object_event  4,  2, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 1, TrainerVictoryRoad2FPokemaniac, -1
	object_event 26,  3, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerVictoryRoad2FJuggler2, -1
	object_event 11,  5, SPRITE_MOLTRES, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, VictoryRoad2FMoltres, EVENT_BEAT_MOLTRES
	object_event 27,  5, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, VictoryRoad2FTMSubmission, EVENT_VICTORY_ROAD_2F_TM_SUBMISSION
	object_event 18,  9, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, VictoryRoad2FFullHeal, EVENT_VICTORY_ROAD_2F_FULL_HEAL
	object_event  9, 11, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, VictoryRoad2FTMMegaKick, EVENT_VICTORY_ROAD_2F_TM_MEGA_KICK
	object_event 11,  0, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, VictoryRoad2FGuardSpec, EVENT_VICTORY_ROAD_2F_GUARD_SPEC
	object_event  4, 14, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VictoryRoad2FBoulder, -1
	object_event  5,  5, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VictoryRoad2FBoulder, -1
	object_event 23, 16, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VictoryRoad2FBoulder, EVENT_VICTORY_ROAD_2F_BOULDER_HIDDEN ; Yellow BOULDER3: appears when a boulder drops through 3F's hole
