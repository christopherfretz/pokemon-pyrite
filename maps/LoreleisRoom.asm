; Kanto hack (M10 13j): Yellow's LORELEIS_ROOM
; (vendor/pokeyellow/data/maps/objects/LoreleisRoom.asm, scripts/LoreleisRoom.asm,
; text/LoreleisRoom.asm), re-cut to Yellow's 5x6 on TILESET_KANTO_GYM (Yellow's
; GYM); the .blk is Yellow's.  Music: Yellow MUSIC_GYM (D131, K6).
;
; Yellow's mechanics, not Crystal's (docs/M10-INDIGO.md "13j findings"):
; * Arriving on (4,11)/(5,11) walks the player six steps UP, once
;   (Yellow: EVENT_AUTOWALKED_INTO_LORELEIS_ROOM = our
;   EVENT_LORELEIS_ROOM_ENTRANCE_CLOSED).  There is no entrance block swap.
; * Afterwards, stepping on (4,10)/(5,10) prints "Don't run away!" and pushes
;   the player one step back UP, so (4,11)/(5,11) are arrival points only.
; * The exit, block (2,0) = tiles (4-5,0-1), is $24 (row 0 wall) until the
;   LORELEI is beaten, then $89 (Yellow's $05; $89 = $05 + WARP_CARPET_UP (TILESET_KANTO_GYM)).
;   EVENT_LORELEIS_ROOM_EXIT_OPEN holds it; MAPCALLBACK_TILES sets it both ways
;   (Yellow: LoreleiShowOrHideExitBlock).
; * LORELEI has sight 0: talk to battle.  A loss is a normal whiteout; the
;   lobby's PrepareElite4Callback resets every flag and scene.
; * Post-E4 hook (operator ruling 2026-09-22): once EVENT_BEAT_KANTO_ELITE_FOUR
;   is set the League is "left in shambles" and freely walkable -- no walk-in,
;   no push-back, no battle; the exit is open and the entrance block (2,5)
;   becomes $8c, a WARP_CARPET_DOWN twin, so the player can walk back out.
	object_const_def
	const LORELEISROOM_LORELEI

LoreleisRoom_MapScripts:
	def_scene_scripts
	scene_script LoreleisRoomWalkInScene, SCENE_LORELEISROOM_WALK_IN
	scene_script LoreleisRoomNoopScene,   SCENE_LORELEISROOM_NOOP
	scene_script LoreleisRoomNoopScene,   SCENE_LORELEISROOM_POST_E4 ; League open: no coord_events

	def_callbacks
	callback MAPCALLBACK_TILES, LoreleisRoomExitCallback

LoreleisRoomWalkInScene:
	sdefer LoreleisRoomWalkInScript
	end

LoreleisRoomNoopScene:
	end

LoreleisRoomExitCallback:
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue .league_open
	checkevent EVENT_LORELEIS_ROOM_EXIT_OPEN
	iftrue .open
	changeblock 4, 0, $24 ; Yellow: exit shut
	endcallback

.open:
	changeblock 4, 0, $89 ; Yellow $05, with warps
	endcallback

.league_open:
	changeblock 4, 0, $89
	changeblock 4, 10, $8c ; post-E4: the entrance warps too
	endcallback

LoreleisRoomWalkInScript:
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue .league_open
	applymovement PLAYER, LoreleisRoomWalkInMovement
	setevent EVENT_LORELEIS_ROOM_ENTRANCE_CLOSED
	setscene SCENE_LORELEISROOM_NOOP
	end

.league_open:
	setscene SCENE_LORELEISROOM_POST_E4
	end

LoreleisRoomDontRunAwayScript:
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue .league_open
	opentext
	writetext LoreleisRoomDontRunAwayText
	waitbutton
	closetext
	applymovement PLAYER, LoreleisRoomPushBackMovement
.league_open:
	end

LoreleisRoomLoreleiScript:
	faceplayer
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue .league_open
	opentext
	checkevent EVENT_BEAT_ELITE_4_LORELEI
	iftrue .after
	writetext LoreleisRoomLoreleiBeforeBattleText
	waitbutton
	closetext
	winlosstext LoreleisRoomLoreleiEndBattleText, 0
	loadtrainer LORELEI, LORELEI1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_ELITE_4_LORELEI
	setevent EVENT_LORELEIS_ROOM_EXIT_OPEN
	changeblock 4, 0, $89
	refreshmap
	opentext
.after:
	writetext LoreleisRoomLoreleiAfterBattleText
	waitbutton
	closetext
	end

; Post-E4 (ours, not Yellow's -- operator ruling 2026-09-22): the member
; acknowledges the League's state and offers a rematch with the same team.
; A loss is a normal white-out; a win or a refusal sets no flag.
.league_open:
	opentext
	writetext LoreleisRoomLoreleiPostE4Text
	yesorno
	iffalse .no_rematch
	closetext
	winlosstext LoreleisRoomLoreleiEndBattleText, 0
	loadtrainer LORELEI, LORELEI1
	startbattle
	reloadmapafterbattle
	opentext
	writetext LoreleisRoomLoreleiRematchWinText
	waitbutton
	closetext
	end

.no_rematch:
	writetext LoreleisRoomLoreleiNoRematchText
	waitbutton
	closetext
	end

LoreleisRoomWalkInMovement:
	step UP
	step UP
	step UP
	step UP
	step UP
	step UP
	step_end

LoreleisRoomPushBackMovement:
	step UP
	step_end

; Yellow: _LoreleisRoomLoreleiBeforeBattleText.
LoreleisRoomLoreleiBeforeBattleText:
	text "Welcome to"
	line "#MON LEAGUE!"

	para "I am LORELEI of"
	line "the ELITE FOUR!"

	para "No one can best"
	line "me when it comes"
	cont "to icy #MON!"

	para "Freezing moves"
	line "are powerful!"

	para "Your #MON will"
	line "be at my mercy"
	cont "when they are"
	cont "frozen solid!"

	para "Hahaha!"
	line "Are you ready?"
	done

; Yellow: _LoreleisRoomLoreleiEndBattleText (its `prompt` is `done` here).
LoreleisRoomLoreleiEndBattleText:
	text "How"
	line "dare you!"
	done

; Yellow: _LoreleisRoomLoreleiAfterBattleText.
LoreleisRoomLoreleiAfterBattleText:
	text "You're better"
	line "than I thought!"
	cont "Go on ahead!"

	para "You only got a"
	line "taste of #MON"
	cont "LEAGUE power!"
	done

; Yellow: _LoreleisRoomLoreleiDontRunAwayText.
LoreleisRoomDontRunAwayText:
	text "Someone's voice:"
	line "Don't run away!"
	done

; Post-E4 lines: ours (M10 13k), in Yellow's register.
LoreleisRoomLoreleiPostE4Text:
	text "Oh! It's the new"
	line "champion!"

	para "LANCE walked out"
	line "after you beat"
	cont "him, and <RIVAL>"
	cont "went home to"
	cont "VIRIDIAN."

	para "The LEAGUE hasn't"
	line "found anyone to"
	cont "replace them yet."

	para "Care for another"
	line "icy battle?"
	done

LoreleisRoomLoreleiRematchWinText:
	text "You're still too"
	line "hot for my ice!"
	done

LoreleisRoomLoreleiNoRematchText:
	text "Come back when"
	line "you want a chill!"
	done

LoreleisRoom_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 11, INDIGO_PLATEAU_POKECENTER_1F, 4 ; arrival only (Yellow's push-back)
	warp_event  5, 11, INDIGO_PLATEAU_POKECENTER_1F, 4 ; arrival only
	warp_event  4,  0, BRUNOS_ROOM, 1
	warp_event  5,  0, BRUNOS_ROOM, 2

	def_coord_events
	coord_event  4, 10, SCENE_LORELEISROOM_NOOP, LoreleisRoomDontRunAwayScript
	coord_event  5, 10, SCENE_LORELEISROOM_NOOP, LoreleisRoomDontRunAwayScript

	def_bg_events

	def_object_events
	object_event  5,  2, SPRITE_WILL, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, LoreleisRoomLoreleiScript, -1
