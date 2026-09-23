; Kanto hack (M10 13j): Yellow's AGATHAS_ROOM
; (vendor/pokeyellow/data/maps/objects/AgathasRoom.asm, scripts/AgathasRoom.asm,
; text/AgathasRoom.asm), re-cut to Yellow's 5x6 on TILESET_KANTO_TOWER (Yellow's
; CEMETERY); the .blk is Yellow's.  Music: Yellow MUSIC_POKEMON_TOWER -> MUSIC_LAVENDER_TOWN (D131, K6).
;
; Yellow's mechanics, not Crystal's (docs/M10-INDIGO.md "13j findings"):
; * Arriving on (4,11)/(5,11) walks the player six steps UP, once
;   (Yellow: EVENT_AUTOWALKED_INTO_AGATHAS_ROOM = our
;   EVENT_AGATHAS_ROOM_ENTRANCE_CLOSED).  There is no entrance block swap.
; * Afterwards, stepping on (4,10)/(5,10) prints "Don't run away!" and pushes
;   the player one step back UP, so (4,11)/(5,11) are arrival points only.
; * The exit, block (2,0) = tiles (4-5,0-1), is $3b (row 0 wall) until the
;   AGATHA is beaten, then $6f (Yellow's $0e; $6f = $0e + WARP_CARPET_UP (TILESET_KANTO_TOWER)).
;   EVENT_AGATHAS_ROOM_EXIT_OPEN holds it; MAPCALLBACK_TILES sets it both ways
;   (Yellow: AgathaShowOrHideExitBlock).
; * AGATHA has sight 0: talk to battle.  A loss is a normal whiteout; the
;   lobby's PrepareElite4Callback resets every flag and scene.
; * Post-E4 hook (operator ruling 2026-09-22): once EVENT_BEAT_KANTO_ELITE_FOUR
;   is set the League is "left in shambles" and freely walkable -- no walk-in,
;   no push-back, no battle; the exit is open and the entrance block (2,5)
;   becomes $70, a WARP_CARPET_DOWN twin, so the player can walk back out.
	object_const_def
	const AGATHASROOM_AGATHA

AgathasRoom_MapScripts:
	def_scene_scripts
	scene_script AgathasRoomWalkInScene, SCENE_AGATHASROOM_WALK_IN
	scene_script AgathasRoomNoopScene,   SCENE_AGATHASROOM_NOOP
	scene_script AgathasRoomNoopScene,   SCENE_AGATHASROOM_POST_E4 ; League open: no coord_events

	def_callbacks
	callback MAPCALLBACK_TILES, AgathasRoomExitCallback

AgathasRoomWalkInScene:
	sdefer AgathasRoomWalkInScript
	end

AgathasRoomNoopScene:
	end

AgathasRoomExitCallback:
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue .league_open
	checkevent EVENT_AGATHAS_ROOM_EXIT_OPEN
	iftrue .open
	changeblock 4, 0, $3b ; Yellow: exit shut
	endcallback

.open:
	changeblock 4, 0, $6f ; Yellow $0e, with warps
	endcallback

.league_open:
	changeblock 4, 0, $6f
	changeblock 4, 10, $70 ; post-E4: the entrance warps too
	endcallback

AgathasRoomWalkInScript:
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue .league_open
	applymovement PLAYER, AgathasRoomWalkInMovement
	setevent EVENT_AGATHAS_ROOM_ENTRANCE_CLOSED
	setscene SCENE_AGATHASROOM_NOOP
	end

.league_open:
	setscene SCENE_AGATHASROOM_POST_E4
	end

AgathasRoomDontRunAwayScript:
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue .league_open
	opentext
	writetext AgathasRoomDontRunAwayText
	waitbutton
	closetext
	applymovement PLAYER, AgathasRoomPushBackMovement
.league_open:
	end

AgathasRoomAgathaScript:
	faceplayer
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue .league_open
	opentext
	checkevent EVENT_BEAT_ELITE_4_AGATHA
	iftrue .after
	writetext AgathasRoomAgathaBeforeBattleText
	waitbutton
	closetext
	winlosstext AgathasRoomAgathaEndBattleText, 0
	loadtrainer AGATHA, AGATHA1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_ELITE_4_AGATHA
	setevent EVENT_AGATHAS_ROOM_EXIT_OPEN
	changeblock 4, 0, $6f
	refreshmap
	opentext
.after:
	writetext AgathasRoomAgathaAfterBattleText
	waitbutton
	closetext
	end

; Post-E4 (ours, not Yellow's -- operator ruling 2026-09-22): the member
; acknowledges the League's state and offers a rematch with the same team.
; A loss is a normal white-out; a win or a refusal sets no flag.
.league_open:
	opentext
	writetext AgathasRoomAgathaPostE4Text
	yesorno
	iffalse .no_rematch
	closetext
	winlosstext AgathasRoomAgathaEndBattleText, 0
	loadtrainer AGATHA, AGATHA1
	startbattle
	reloadmapafterbattle
	opentext
	writetext AgathasRoomAgathaRematchWinText
	waitbutton
	closetext
	end

.no_rematch:
	writetext AgathasRoomAgathaNoRematchText
	waitbutton
	closetext
	end

AgathasRoomWalkInMovement:
	step UP
	step UP
	step UP
	step UP
	step UP
	step UP
	step_end

AgathasRoomPushBackMovement:
	step UP
	step_end

; Yellow: _AgathaBeforeBattleText.
AgathasRoomAgathaBeforeBattleText:
	text "I am AGATHA of"
	line "the ELITE FOUR!"

	para "OAK's taken a lot"
	line "of interest in"
	cont "you, child!"

	para "That old duff was"
	line "once tough and"
	cont "handsome! That"
	cont "was decades ago!"

	para "Now he just wants"
	line "to fiddle with"
	cont "his #DEX! He's"
	cont "wrong! #MON"
	cont "are for fighting!"

	para "<PLAYER>! I'll show"
	line "you how a real"
	cont "trainer fights!"
	done

; Yellow: _AgathaEndBattleText (its `prompt` is `done` here).
AgathasRoomAgathaEndBattleText:
	text "Woo-hoo!"
	line "You're something"
	cont "special, child!"
	done

; Yellow: _AgathaAfterBattleText.
AgathasRoomAgathaAfterBattleText:
	text "You win! I see"
	line "what the old duff"
	cont "sees in you now!"

	para "I have nothing"
	line "else to say! Run"
	cont "along now, child!"
	done

; Yellow: _AgathasRoomAgathaDontRunAwayText.
AgathasRoomDontRunAwayText:
	text "Someone's voice:"
	line "Don't run away!"
	done

; Post-E4 lines: ours (M10 13k), in Yellow's register.
AgathasRoomAgathaPostE4Text:
	text "Ohoho! You again,"
	line "child!"

	para "LANCE stormed off"
	line "after his loss,"
	cont "and that brat"
	cont "<RIVAL> scurried"
	cont "home to VIRIDIAN!"

	para "The LEAGUE still"
	line "hasn't found any-"
	cont "one to take their"
	cont "places!"

	para "Shall an old woman"
	line "show you a real"
	cont "battle again?"
	done

AgathasRoomAgathaRematchWinText:
	text "Hmph! You've"
	line "still got it,"
	cont "child!"
	done

AgathasRoomAgathaNoRematchText:
	text "Run along now,"
	line "child!"
	done

AgathasRoom_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 11, BRUNOS_ROOM, 3 ; arrival only (Yellow's push-back)
	warp_event  5, 11, BRUNOS_ROOM, 4 ; arrival only
	warp_event  4,  0, LANCES_ROOM, 1
	warp_event  5,  0, LANCES_ROOM, 1

	def_coord_events
	coord_event  4, 10, SCENE_AGATHASROOM_NOOP, AgathasRoomDontRunAwayScript
	coord_event  5, 10, SCENE_AGATHASROOM_NOOP, AgathasRoomDontRunAwayScript

	def_bg_events

	def_object_events
	object_event  5,  2, SPRITE_KAREN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, AgathasRoomAgathaScript, -1
