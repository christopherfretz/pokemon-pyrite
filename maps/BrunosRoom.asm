; Kanto hack (M10 13j): Yellow's BRUNOS_ROOM
; (vendor/pokeyellow/data/maps/objects/BrunosRoom.asm, scripts/BrunosRoom.asm,
; text/BrunosRoom.asm), re-cut to Yellow's 5x6 on TILESET_KANTO_GYM (Yellow's
; GYM); the .blk is Yellow's.  Music: Yellow MUSIC_DUNGEON1 -> MUSIC_INDIGO_PLATEAU (D131, K6).
;
; Yellow's mechanics, not Crystal's (docs/M10-INDIGO.md "13j findings"):
; * Arriving on (4,11)/(5,11) walks the player six steps UP, once
;   (Yellow: EVENT_AUTOWALKED_INTO_BRUNOS_ROOM = our
;   EVENT_BRUNOS_ROOM_ENTRANCE_CLOSED).  There is no entrance block swap.
; * Afterwards, stepping on (4,10)/(5,10) prints "Don't run away!" and pushes
;   the player one step back UP, so (4,11)/(5,11) are arrival points only.
; * The exit, block (2,0) = tiles (4-5,0-1), is $24 (row 0 wall) until the
;   BRUNO is beaten, then $89 (Yellow's $05; $89 = $05 + WARP_CARPET_UP (TILESET_KANTO_GYM)).
;   EVENT_BRUNOS_ROOM_EXIT_OPEN holds it; MAPCALLBACK_TILES sets it both ways
;   (Yellow: BrunoShowOrHideExitBlock).
; * BRUNO has sight 0: talk to battle.  A loss is a normal whiteout; the
;   lobby's PrepareElite4Callback resets every flag and scene.
; * Post-E4 hook (operator ruling 2026-09-22): once EVENT_BEAT_KANTO_ELITE_FOUR
;   is set the League is "left in shambles" and freely walkable -- no walk-in,
;   no push-back, no battle; the exit is open and the entrance block (2,5)
;   becomes $8c, a WARP_CARPET_DOWN twin, so the player can walk back out.
	object_const_def
	const BRUNOSROOM_BRUNO

BrunosRoom_MapScripts:
	def_scene_scripts
	scene_script BrunosRoomWalkInScene, SCENE_BRUNOSROOM_WALK_IN
	scene_script BrunosRoomNoopScene,   SCENE_BRUNOSROOM_NOOP
	scene_script BrunosRoomNoopScene,   SCENE_BRUNOSROOM_POST_E4 ; League open: no coord_events

	def_callbacks
	callback MAPCALLBACK_TILES, BrunosRoomExitCallback

BrunosRoomWalkInScene:
	sdefer BrunosRoomWalkInScript
	end

BrunosRoomNoopScene:
	end

BrunosRoomExitCallback:
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue .league_open
	checkevent EVENT_BRUNOS_ROOM_EXIT_OPEN
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

BrunosRoomWalkInScript:
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue .league_open
	applymovement PLAYER, BrunosRoomWalkInMovement
	setevent EVENT_BRUNOS_ROOM_ENTRANCE_CLOSED
	setscene SCENE_BRUNOSROOM_NOOP
	end

.league_open:
	setscene SCENE_BRUNOSROOM_POST_E4
	end

BrunosRoomDontRunAwayScript:
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue .league_open
	opentext
	writetext BrunosRoomDontRunAwayText
	waitbutton
	closetext
	applymovement PLAYER, BrunosRoomPushBackMovement
.league_open:
	end

BrunosRoomBrunoScript:
	faceplayer
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue .league_open
	opentext
	checkevent EVENT_BEAT_ELITE_4_BRUNO
	iftrue .after
	writetext BrunosRoomBrunoBeforeBattleText
	waitbutton
	closetext
	winlosstext BrunosRoomBrunoEndBattleText, 0
	loadtrainer BRUNO, BRUNO1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_ELITE_4_BRUNO
	setevent EVENT_BRUNOS_ROOM_EXIT_OPEN
	changeblock 4, 0, $89
	refreshmap
	opentext
.after:
	writetext BrunosRoomBrunoAfterBattleText
	waitbutton
	closetext
	end

; Post-E4 (ours, not Yellow's -- operator ruling 2026-09-22): the member
; acknowledges the League's state and offers a rematch with the same team.
; A loss is a normal white-out; a win or a refusal sets no flag.
.league_open:
	opentext
	writetext BrunosRoomBrunoPostE4Text
	yesorno
	iffalse .no_rematch
	closetext
	winlosstext BrunosRoomBrunoEndBattleText, 0
	loadtrainer BRUNO, BRUNO1
	startbattle
	reloadmapafterbattle
	opentext
	writetext BrunosRoomBrunoRematchWinText
	waitbutton
	closetext
	end

.no_rematch:
	writetext BrunosRoomBrunoNoRematchText
	waitbutton
	closetext
	end

BrunosRoomWalkInMovement:
	step UP
	step UP
	step UP
	step UP
	step UP
	step UP
	step_end

BrunosRoomPushBackMovement:
	step UP
	step_end

; Yellow: _BrunoBeforeBattleText.
BrunosRoomBrunoBeforeBattleText:
	text "I am BRUNO of"
	line "the ELITE FOUR!"

	para "Through rigorous"
	line "training, people"
	cont "and #MON can"
	cont "become stronger!"

	para "I've weight"
	line "trained with"
	cont "my #MON!"

	para "<PLAYER>!"

	para "We will grind you"
	line "down with our"
	cont "superior power!"

	para "Hoo hah!"
	done

; Yellow: _BrunoEndBattleText (its `prompt` is `done` here).
BrunosRoomBrunoEndBattleText:
	text "Why?"
	line "How could I lose?"
	done

; Yellow: _BrunoAfterBattleText.
BrunosRoomBrunoAfterBattleText:
	text "My job is done!"
	line "Go face your next"
	cont "challenge!"
	done

; Yellow: _BrunosRoomBrunoDontRunAwayText.
BrunosRoomDontRunAwayText:
	text "Someone's voice:"
	line "Don't run away!"
	done

; Post-E4 lines: ours (M10 13k), in Yellow's register.
BrunosRoomBrunoPostE4Text:
	text "LANCE is gone."
	line "He walked out"
	cont "after you beat"
	cont "him."

	para "<RIVAL> went home"
	line "to VIRIDIAN."

	para "No one has come"
	line "to take their"
	cont "places yet."

	para "But my training"
	line "never stops!"

	para "Will you fight me"
	line "again?"
	done

BrunosRoomBrunoRematchWinText:
	text "Hm! You are"
	line "stronger still!"
	done

BrunosRoomBrunoNoRematchText:
	text "Then I will keep"
	line "training!"
	done

BrunosRoom_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 11, LORELEIS_ROOM, 3 ; arrival only (Yellow's push-back)
	warp_event  5, 11, LORELEIS_ROOM, 4 ; arrival only
	warp_event  4,  0, AGATHAS_ROOM, 1
	warp_event  5,  0, AGATHAS_ROOM, 2

	def_coord_events
	coord_event  4, 10, SCENE_BRUNOSROOM_NOOP, BrunosRoomDontRunAwayScript
	coord_event  5, 10, SCENE_BRUNOSROOM_NOOP, BrunosRoomDontRunAwayScript

	def_bg_events

	def_object_events
	object_event  5,  2, SPRITE_BRUNO, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, BrunosRoomBrunoScript, -1
