; Kanto hack: Yellow's SS_ANNE_2F (docs/M4-VERMILION.md, 7h + 7i).
;   Yellow ( 3, 7) SPRITE_WAITER, WALK UP_DOWN -> SPRITE_CLERK (5.4)
;   Yellow (36, 4) SPRITE_BLUE, STAY DOWN      -> SPRITE_KANTO_RIVAL
; The rival is Yellow's fourth rival fight (7i, 3.3).  Yellow drives it from
; SSAnne2FDefaultScript: a two-tile coordinate band at (36,8)/(37,8) in the
; corridor that leads up to the CAPTAIN's door -- row 8 is walkable ONLY at
; x=36,37 (and at x=2,3, on the far side of the map), so the band cannot be
; walked around.  Tripping it plays MUSIC_MEET_RIVAL, ShowObject's the rival on
; the door tile (36,4) and walks him down to the tile next to the player.
	object_const_def
	const SSANNE2F_WAITER
	const SSANNE2F_RIVAL

SSAnne2F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_OBJECTS, SSAnne2FObjectsCallback

; Per docs/PORTING.md 3.4 an object's hide flag is DERIVED on every map load
; rather than toggled once, so a white-out in the middle of the scene cannot
; leave a stray rival standing in the corridor.  Here the derivation really is
; the degenerate "always hidden", and deliberately so: Yellow ShowObject's the
; rival only from inside the corridor scene and HideObject's him again at the
; end of it, so at every map load -- before the fight, after a win, after a
; loss -- he is off the map.  `appear` writes through to the hide flag
; persistently (ApplyEventActionAppearDisappear), so re-setting the flag on
; each load is exactly what makes a mid-battle white-out safe; there is no
; EVENT_BEAT_RIVAL_SS_ANNE branch to add, because the answer is the same on
; both sides of it.  The coord_event scripts below are what read that event.
SSAnne2FObjectsCallback:
	setevent EVENT_SS_ANNE_2F_RIVAL_HIDDEN
	endcallback

; Player tripped (36,8), walking up the corridor: the rival comes down the same
; column and stops one tile above, on (36,7).  Yellow leaves the player's
; facing alone here -- the band is reached walking UP, so the player is already
; looking at him (SSAnne2FSetFacingDirectionScript only forces a turn in the
; x=37 case below).
SSAnne2FRivalSceneLeft:
	checkevent EVENT_BEAT_RIVAL_SS_ANNE
	iftrue .Done
	playmusic MUSIC_RIVAL_ENCOUNTER
	appear SSANNE2F_RIVAL
	applymovement SSANNE2F_RIVAL, SSAnne2F_RivalApproachLeft
	turnobject SSANNE2F_RIVAL, DOWN
	scall SSAnne2FRivalBattle
	turnobject SSANNE2F_RIVAL, DOWN
	scall SSAnne2FRivalCutMaster
	applymovement SSANNE2F_RIVAL, SSAnne2F_RivalExitLeft
	sjump SSAnne2FRivalGone

.Done:
	end

; Player tripped (37,8): the rival walks one tile further, to (36,8), and the
; two of them face each other across the corridor (Yellow's
; SSAnne2FSetFacingDirectionScript: wPlayerMovingDirection = LEFT, rival
; SPRITE_FACING_RIGHT).
SSAnne2FRivalSceneRight:
	checkevent EVENT_BEAT_RIVAL_SS_ANNE
	iftrue .Done
	playmusic MUSIC_RIVAL_ENCOUNTER
	appear SSANNE2F_RIVAL
	applymovement SSANNE2F_RIVAL, SSAnne2F_RivalApproachRight
	turnobject PLAYER, LEFT
	turnobject SSANNE2F_RIVAL, RIGHT
	scall SSAnne2FRivalBattle
	turnobject PLAYER, LEFT
	turnobject SSANNE2F_RIVAL, RIGHT
	scall SSAnne2FRivalCutMaster
	applymovement SSANNE2F_RIVAL, SSAnne2F_RivalExitRight
	sjump SSAnne2FRivalGone

.Done:
	end

; OPP_RIVAL2 / wTrainerNo = 1 in Yellow.  No `dontrestartmapmusic`: Yellow
; returns from the battle through the normal path, so MUSIC_SS_ANNE comes back
; by itself and the CUT-master line is spoken over it.
SSAnne2FRivalBattle:
	opentext
	writetext SSAnne2FRivalText
	waitbutton
	closetext
	winlosstext SSAnne2FRivalDefeatedText, SSAnne2FRivalVictoryText
	setlasttalked SSANNE2F_RIVAL
	loadtrainer KANTO_RIVAL, KANTO_RIVAL_4
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_RIVAL_SS_ANNE
	return

; Yellow stops the map music and restarts MUSIC_MEET_RIVAL at its alternate
; entry point (Music_RivalAlternateStart) as he walks off; MUSIC_RIVAL_AFTER is
; Crystal's equivalent piece (CeruleanCity uses it the same way).
SSAnne2FRivalCutMaster:
	opentext
	writetext SSAnne2FRivalCutMasterText
	waitbutton
	closetext
	playmusic MUSIC_RIVAL_AFTER
	return

; `special RestartMapMusic`, not `playmapmusic`: PlayMapMusic is a no-op when
; wMapMusic already holds the map's song (home/audio.asm), and it does here --
; this script does not use `dontrestartmapmusic`, so the battle put MUSIC_SS_ANNE
; back and left wMapMusic set, and MUSIC_RIVAL_AFTER would simply keep playing.
; (The Crystal scenes that end in `playmapmusic` all suppress the post-battle
; music first, which zeroes wMapMusic and is what makes their call fire.)
SSAnne2FRivalGone:
	disappear SSANNE2F_RIVAL
	special RestartMapMusic
	end

SSAnne2FWaiterScript:
	jumptextfaceplayer SSAnne2FWaiterText

; Unreachable: the rival is only ever on the map inside the scene above, and
; the scene holds the player's input from `appear` to `disappear`.  The object
; still needs a script pointer.
SSAnne2FRivalScript:
	end

; (36,4) -> (36,7), one tile above the player on (36,8).
; Yellow .RivalDownThreeMovement.
SSAnne2F_RivalApproachLeft:
	step DOWN
	step DOWN
	step DOWN
	step_end

; (36,4) -> (36,8), one tile left of the player on (37,8).
; Yellow .RivalDownFourMovement.
SSAnne2F_RivalApproachRight:
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step_end

; He leaves down the corridor.  From (36,7) he has to step around the player
; standing on (36,8) first -- Yellow .RivalWalkAroundPlayerMovement, RIGHT then
; falling into the four DOWNs, so RIGHT + five DOWNs, (36,7) -> (37,12).
SSAnne2F_RivalExitLeft:
	step RIGHT
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step_end

; From (36,8) the column below him is clear: Yellow .RivalDownFourMovement,
; (36,8) -> (36,12).
SSAnne2F_RivalExitRight:
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step_end

SSAnne2FWaiterText:
	text "This ship, she is"
	line "a luxury liner"
	cont "for trainers!"

	para "At every port, we"
	line "hold parties with"
	cont "invited trainers!"
	done

SSAnne2FRivalText:
	text "<RIVAL>: Bonjour!"
	line "<PLAYER>!"

	para "Imagine seeing"
	line "you here!"

	para "<PLAYER>, were you"
	line "really invited?"

	para "So how's your"
	line "#DEX coming?"

	para "I already caught"
	line "40 kinds, pal!"

	para "Different kinds"
	line "are everywhere!"

	para "Crawl around in"
	line "grassy areas!"
	done

SSAnne2FRivalDefeatedText:
	text "Humph!"

	para "At least you're"
	line "raising your"
	cont "#MON!"
	prompt

SSAnne2FRivalVictoryText:
	text "<PLAYER>! What are"
	line "you, seasick?"

	para "You should shape"
	line "up, pal!"
	prompt

SSAnne2FRivalCutMasterText:
	text "<RIVAL>: I heard"
	line "there was a CUT"
	cont "master on board."

	para "But, he was just a"
	line "seasick, old man!"

	para "But, CUT itself is"
	line "really useful!"

	para "You should go see"
	line "him! Smell ya!"
	done

SSAnne2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  9, 11, SS_ANNE_2F_ROOMS, 1
	warp_event 13, 11, SS_ANNE_2F_ROOMS, 3
	warp_event 17, 11, SS_ANNE_2F_ROOMS, 5
	warp_event 21, 11, SS_ANNE_2F_ROOMS, 7
	warp_event 25, 11, SS_ANNE_2F_ROOMS, 9
	warp_event 29, 11, SS_ANNE_2F_ROOMS, 11
	warp_event  2,  4, SS_ANNE_1F, 9
	warp_event  2, 12, SS_ANNE_3F, 2
	warp_event 36,  4, SS_ANNE_CAPTAINS_ROOM, 1

	def_coord_events
	coord_event 36,  8, -1, SSAnne2FRivalSceneLeft
	coord_event 37,  8, -1, SSAnne2FRivalSceneRight

	def_bg_events

	def_object_events
	object_event  3,  7, SPRITE_CLERK, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnne2FWaiterScript, -1
	object_event 36,  4, SPRITE_KANTO_RIVAL, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SSAnne2FRivalScript, EVENT_SS_ANNE_2F_RIVAL_HIDDEN
