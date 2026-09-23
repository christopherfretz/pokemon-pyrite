; Kanto hack (M10 13k): Yellow's CHAMPIONS_ROOM
; (vendor/pokeyellow/data/maps/objects/ChampionsRoom.asm, scripts/ChampionsRoom.asm,
; text/ChampionsRoom.asm), re-cut to Yellow's 4x4 on TILESET_KANTO_GYM.
; The .blk is Yellow's except (1,0)/(2,0) = $8a/$8b (the north exit, the same
; $31/$32 twins as LANCE's) and (1,3)/(2,3) = $8e/$8f (the south entrance,
; WARP_CARPET_DOWN twins) -- scripts/kanto_gym_blk.py.
;
; Yellow's sequence (docs/M10-INDIGO.md "13k findings"):
; * The player arrives at (3,7) and walks UP 3, RIGHT 1, UP 1 to (4,3), below
;   the rival at (4,2).  Yellow forces battle animations on (res
;   BIT_BATTLE_ANIMATION, [wOptions]); so do we.
; * Intro text, then OPP_RIVAL3 by rival starter -> KANTO_CHAMPION 1/2/3.  A
;   loss is a white-out.  A win keeps the victory tune playing on the map
;   (Yellow's BIT_NO_MAP_MUSIC for RIVAL3), then the after-battle text, the
;   CITIES1 alternate-tempo fade (MUSIC_VIRIDIAN_CITY here), "OAK: <PLAYER>!",
;   OAK walks UP 5 from (3,7), congratulates, scolds the rival, walks UP 2 into
;   the north exit, and the player follows him to the HALL OF FAME.
; * No flag is set here; HALL_OF_FAME sets EVENT_BEAT_KANTO_ELITE_FOUR.
; * Post-E4 (operator ruling 2026-09-22): the rival has gone to VIRIDIAN, so
;   the room is empty and walkable both ways (the warps are baked in).
	object_const_def
	const CHAMPIONSROOM_RIVAL
	const CHAMPIONSROOM_OAK

ChampionsRoom_MapScripts:
	def_scene_scripts
	scene_script ChampionsRoomEnterScene, SCENE_CHAMPIONSROOM_ENTER
	scene_script ChampionsRoomNoopScene,  SCENE_CHAMPIONSROOM_NOOP

	def_callbacks

ChampionsRoomEnterScene:
	sdefer ChampionsRoomRivalScript
	end

ChampionsRoomNoopScene:
	end

ChampionsRoomRivalScript:
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue .league_open
	applymovement PLAYER, ChampionsRoomWalkToRivalMovement
	; Yellow: res BIT_BATTLE_ANIMATION, [wOptions] (BATTLE_SCENE, bit 7)
	readmem wOptions
	ifless 1 << BATTLE_SCENE, .anims_on
	addval 1 << BATTLE_SCENE ; wraps: clears bit 7, keeps the rest
	writemem wOptions
.anims_on:
	opentext
	writetext ChampionsRoomRivalIntroText
	waitbutton
	closetext
	winlosstext ChampionsRoomRivalDefeatedText, ChampionsRoomRivalVictoryText
	setlasttalked CHAMPIONSROOM_RIVAL
	special GetKantoRivalStarter
	ifequal RIVAL_STARTER_JOLTEON, .Jolteon
	ifequal RIVAL_STARTER_FLAREON, .Flareon
	loadtrainer KANTO_CHAMPION, KANTO_CHAMPION_3 ; RIVAL_STARTER_VAPOREON
	sjump .Fight

.Jolteon:
	loadtrainer KANTO_CHAMPION, KANTO_CHAMPION_1
	sjump .Fight

.Flareon:
	loadtrainer KANTO_CHAMPION, KANTO_CHAMPION_2

.Fight:
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	; Yellow's BIT_NO_MAP_MUSIC: the victory tune carries on over the map
	playmusic MUSIC_GYM_VICTORY
	opentext
	writetext ChampionsRoomRivalAfterBattleText
	waitbutton
	closetext
	; Yellow's Music_Cities1AlternateTempo: fade, 100 frames, CITIES1
	musicfadeout MUSIC_VIRIDIAN_CITY, 10
	pause 50
	opentext
	writetext ChampionsRoomOakText
	waitbutton
	closetext
	appear CHAMPIONSROOM_OAK
	applymovement CHAMPIONSROOM_OAK, ChampionsRoomOakWalksInMovement
	turnobject PLAYER, LEFT
	turnobject CHAMPIONSROOM_RIVAL, LEFT
	turnobject CHAMPIONSROOM_OAK, DOWN
	opentext
	writetext ChampionsRoomOakCongratulatesPlayerText
	waitbutton
	closetext
	turnobject CHAMPIONSROOM_OAK, RIGHT
	opentext
	writetext ChampionsRoomOakDisappointedWithRivalText
	waitbutton
	closetext
	turnobject CHAMPIONSROOM_OAK, DOWN
	opentext
	writetext ChampionsRoomOakComeWithMeText
	waitbutton
	closetext
	applymovement CHAMPIONSROOM_OAK, ChampionsRoomOakExitsMovement
	disappear CHAMPIONSROOM_OAK
	setscene SCENE_CHAMPIONSROOM_NOOP
	applymovement PLAYER, ChampionsRoomPlayerFollowsOakMovement
	warpfacing UP, HALL_OF_FAME, 4, 7
	end

.league_open:
	setscene SCENE_CHAMPIONSROOM_NOOP
	end

ChampionsRoomWalkToRivalMovement:
	step UP
	step UP
	step UP
	step RIGHT
	step UP
	step_end

ChampionsRoomOakWalksInMovement:
	step UP
	step UP
	step UP
	step UP
	step UP
	step_end

ChampionsRoomOakExitsMovement:
	step UP
	step UP
	step_end

ChampionsRoomPlayerFollowsOakMovement:
	step LEFT
	step UP
	step UP
	step UP
	step_end

ChampionsRoomRivalIntroText:
	text "<RIVAL>: Hey!"

	para "I was looking"
	line "forward to seeing"
	cont "you, <PLAYER>!"

	para "My rival should"
	line "be strong to keep"
	cont "me sharp!"

	para "While working on"
	line "#DEX, I looked"
	cont "all over for"
	cont "powerful #MON!"

	para "Not only that, I"
	line "assembled teams"
	cont "that would beat"
	cont "any #MON type!"

	para "And now!"

	para "I'm the #MON"
	line "LEAGUE champion!"

	para "<PLAYER>! Do you"
	line "know what that"
	cont "means?"

	para "I'll tell you!"

	para "I am the most"
	line "powerful trainer"
	cont "in the world!"
	done

ChampionsRoomRivalDefeatedText:
	text "NO!"
	line "That can't be!"
	cont "You beat my best!"

	para "After all that"
	line "work to become"
	cont "LEAGUE champ?"

	para "My reign is over"
	line "already?"
	cont "It's not fair!"
	done

ChampionsRoomRivalVictoryText:
	text "Hahaha!"
	line "I won, I won!"

	para "I'm too good for"
	line "you, <PLAYER>!"

	para "You did well to"
	line "even reach me,"
	cont "<RIVAL>, the"
	cont "#MON genius!"

	para "Nice try, loser!"
	line "Hahaha!"
	done

ChampionsRoomRivalAfterBattleText:
	text "Why?"
	line "Why did I lose?"

	para "I never made any"
	line "mistakes raising"
	cont "my #MON…"

	para "Darn it! You're"
	line "the new #MON"
	cont "LEAGUE champion!"

	para "Although I don't"
	line "like to admit it."
	done

ChampionsRoomOakText:
	text "OAK: <PLAYER>!"
	done

; Yellow prints the starter's species from wNameBuffer: always PIKACHU.
ChampionsRoomOakCongratulatesPlayerText:
	text "OAK: So, you won!"
	line "Congratulations!"
	cont "You're the new"
	cont "#MON LEAGUE"
	cont "champion!"

	para "You've grown up so"
	line "much since you"
	cont "first left with"
	cont "PIKACHU!"

	para "<PLAYER>, you have"
	line "come of age!"
	done

ChampionsRoomOakDisappointedWithRivalText:
	text "OAK: <RIVAL>! I'm"
	line "disappointed!"

	para "I came when I"
	line "heard you beat"
	cont "the ELITE FOUR!"

	para "But, when I got"
	line "here, you had"
	cont "already lost!"

	para "<RIVAL>! Do you"
	line "understand why"
	cont "you lost?"

	para "You have forgotten"
	line "to treat your"
	cont "#MON with"
	cont "trust and love!"

	para "Without them, you"
	line "will never become"
	cont "a champ again!"
	done

ChampionsRoomOakComeWithMeText:
	text "OAK: <PLAYER>!"

	para "You understand"
	line "that your victory"
	cont "was not just your"
	cont "own doing!"

	para "The bond you share"
	line "with your #MON"
	cont "is marvelous!"

	para "<PLAYER>!"
	line "Come with me!"
	done

ChampionsRoom_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, LANCES_ROOM, 2
	warp_event  4,  7, LANCES_ROOM, 3
	warp_event  3,  0, HALL_OF_FAME, 1
	warp_event  4,  0, HALL_OF_FAME, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  4,  2, SPRITE_KANTO_RIVAL, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_BEAT_KANTO_ELITE_FOUR ; post-E4: gone to VIRIDIAN
	object_event  3,  7, SPRITE_OAK, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_CHAMPIONS_ROOM_OAK_AND_MARY
