; Kanto hack (M10 13j): Yellow's LANCES_ROOM
; (vendor/pokeyellow/data/maps/objects/LancesRoom.asm, scripts/LancesRoom.asm,
; text/LancesRoom.asm), re-cut to Yellow's 13x13 on TILESET_KANTO_GYM (Yellow's
; DOJO = GYM).  Music: Yellow MUSIC_DUNGEON1 -> MUSIC_INDIGO_PLATEAU (D131, K6).
; The .blk is Yellow's except (2,0)/(3,0) = $8a/$8b, the $31/$32 exit twins
; with WARP_CARPET_UP (scripts/kanto_gym_blk.py).
;
; Yellow's mechanics (docs/M10-INDIGO.md "13j findings"):
; * Arriving on (24,16) walks the player LEFT 6, DOWN 7, LEFT 12, UP 13 to
;   (6,10) (Yellow: WalkToLance).  (24,16) is one-way: block $70's warp tile
;   stays FLOOR and Yellow has no way back to AGATHA.
; * The door blocks (2,6)/(3,6) = tiles (4-7,12-13) are open ($31/$32) until
;   the player steps on (5,11)/(6,11); then SFX, $72/$73, and
;   EVENT_LANCES_ROOM_ENTRANCE_CLOSED (Yellow: EVENT_LANCES_ROOM_LOCK_DOOR).
;   MAPCALLBACK_TILES sets them both ways (Yellow: LanceShowOrHideEntranceBlocks).
; * Until LANCE is beaten, stepping on (5,1) or (6,2) makes him talk.
; * The exit (5,0)/(6,0) is always open and leads to CHAMPIONS_ROOM.
; * Post-E4 hook (operator ruling 2026-09-22): once EVENT_BEAT_KANTO_ELITE_FOUR
;   is set LANCE has left the League (his object is hidden behind the flag),
;   there is no walk-in and no lock, the door stays open and (24,16) becomes
;   $8d, a WARP_PANEL twin of $70, so the player can walk back to AGATHA.
	object_const_def
	const LANCESROOM_LANCE

LancesRoom_MapScripts:
	def_scene_scripts
	scene_script LancesRoomWalkInScene,   SCENE_LANCESROOM_WALK_IN
	scene_script LancesRoomApproachScene, SCENE_LANCESROOM_APPROACH
	scene_script LancesRoomNoopScene,     SCENE_LANCESROOM_NOOP

	def_callbacks
	callback MAPCALLBACK_TILES, LancesRoomDoorCallback

LancesRoomWalkInScene:
	sdefer LancesRoomWalkInScript
	end

LancesRoomApproachScene:
LancesRoomNoopScene:
	end

LancesRoomDoorCallback:
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue .league_open
	checkevent EVENT_LANCES_ROOM_ENTRANCE_CLOSED
	iftrue .closed
	changeblock 4, 12, $31 ; Yellow: entrance open
	changeblock 6, 12, $32
	endcallback

.closed:
	changeblock 4, 12, $72 ; Yellow: entrance shut
	changeblock 6, 12, $73
	endcallback

.league_open:
	changeblock 4, 12, $31
	changeblock 6, 12, $32
	changeblock 24, 16, $8d ; post-E4: the entrance warps back to AGATHA
	endcallback

LancesRoomWalkInScript:
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue .league_open
	applymovement PLAYER, LancesRoomWalkInMovement
	setscene SCENE_LANCESROOM_APPROACH
	end

.league_open:
	setscene SCENE_LANCESROOM_NOOP
	end

; Yellow: CheckAndSetEvent EVENT_LANCES_ROOM_LOCK_DOOR / SFX_GO_INSIDE.
LancesRoomLockDoorScript:
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue .done
	checkevent EVENT_LANCES_ROOM_ENTRANCE_CLOSED
	iftrue .done
	setevent EVENT_LANCES_ROOM_ENTRANCE_CLOSED
	playsound SFX_ENTER_DOOR
	changeblock 4, 12, $72
	changeblock 6, 12, $73
	refreshmap
	waitsfx
.done:
	end

LancesRoomLanceScript:
	faceplayer
LancesRoomLanceTalkScript:
	opentext
	checkevent EVENT_BEAT_ELITE_4_LANCE
	iftrue .after
	writetext LancesRoomLanceBeforeBattleText
	waitbutton
	closetext
	winlosstext LancesRoomLanceEndBattleText, 0
	loadtrainer LANCE_E4, LANCE_E4_1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_ELITE_4_LANCE
	setevent EVENT_LANCES_ROOM_EXIT_OPEN
	setscene SCENE_LANCESROOM_NOOP
	opentext
.after:
	writetext LancesRoomLanceAfterBattleText
	waitbutton
	closetext
	end

; Yellow: LanceTriggerMovementCoords (5,1)/(6,2) -> TEXT_LANCESROOM_LANCE.
LancesRoomApproachLanceScript:
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue .done
	checkevent EVENT_BEAT_ELITE_4_LANCE
	iftrue .done
	sjump LancesRoomLanceTalkScript
.done:
	end

LancesRoomApproachLanceBelowScript:
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue .done
	checkevent EVENT_BEAT_ELITE_4_LANCE
	iftrue .done
	sjump LancesRoomLanceTalkScript
.done:
	end

; Yellow: WalkToLance_RLEList, played back last entry first.
LancesRoomWalkInMovement:
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step UP
	step UP
	step UP
	step UP
	step UP
	step UP
	step UP
	step UP
	step UP
	step UP
	step UP
	step UP
	step UP
	step_end

; Yellow: _LancesRoomLanceBeforeBattleText.
LancesRoomLanceBeforeBattleText:
	text "Ah! I heard about"
	line "you, <PLAYER>!"

	para "I lead the ELITE"
	line "FOUR! You can"
	cont "call me LANCE the"
	cont "dragon trainer!"

	para "You know that"
	line "dragons are"
	cont "mythical #MON!"

	para "They're hard to"
	line "catch and raise,"
	cont "but their powers"
	cont "are superior!"

	para "They're virtually"
	line "indestructible!"

	para "Well, are you"
	line "ready to lose?"

	para "Your LEAGUE"
	line "challenge ends"
	cont "with me, <PLAYER>!"
	done

; Yellow: _LancesRoomLanceEndBattleText (its `prompt` is `done` here).
LancesRoomLanceEndBattleText:
	text "That's it!"

	para "I hate to admit"
	line "it, but you are a"
	cont "#MON master!"
	done

; Yellow: _LancesRoomLanceAfterBattleText (its `@` + text_end is `done`).
LancesRoomLanceAfterBattleText:
	text "I still can't"
	line "believe my"
	cont "dragons lost to"
	cont "you, <PLAYER>!"

	para "You are now the"
	line "#MON LEAGUE"
	cont "champion!"

	para "...Or, you would"
	line "have been, but"
	cont "you have one more"
	cont "challenge ahead."

	para "You have to face"
	line "another trainer!"
	cont "His name is..."

	para "<RIVAL>!"
	line "He beat the ELITE"
	cont "FOUR before you!"

	para "He is the real"
	line "#MON LEAGUE"
	cont "champion!"
	done

LancesRoom_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 24, 16, AGATHAS_ROOM, 3 ; arrival only (Yellow: one-way)
	warp_event  5,  0, CHAMPIONS_ROOM, 1
	warp_event  6,  0, CHAMPIONS_ROOM, 1

	def_coord_events
	coord_event  5,  1, SCENE_LANCESROOM_APPROACH, LancesRoomApproachLanceScript
	coord_event  6,  2, SCENE_LANCESROOM_APPROACH, LancesRoomApproachLanceBelowScript
	coord_event  5, 11, SCENE_LANCESROOM_APPROACH, LancesRoomLockDoorScript
	coord_event  6, 11, SCENE_LANCESROOM_APPROACH, LancesRoomLockDoorScript

	def_bg_events

	def_object_events
	object_event  6,  1, SPRITE_LANCE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, LancesRoomLanceScript, EVENT_BEAT_KANTO_ELITE_FOUR ; post-E4: LANCE has left
