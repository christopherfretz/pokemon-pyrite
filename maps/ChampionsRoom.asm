	object_const_def
	const CHAMPIONSROOM_LANCE
	const CHAMPIONSROOM_MARY
	const CHAMPIONSROOM_OAK

ChampionsRoom_MapScripts:
	def_scene_scripts
	scene_script ChampionsRoomLockDoorScene, SCENE_CHAMPIONSROOM_LOCK_DOOR
	scene_script ChampionsRoomNoopScene,     SCENE_CHAMPIONSROOM_APPROACH_LANCE

	def_callbacks
	callback MAPCALLBACK_TILES, ChampionsRoomDoorsCallback

ChampionsRoomLockDoorScene:
	sdefer ChampionsRoomDoorLocksBehindYouScript
	end

ChampionsRoomNoopScene:
	end

ChampionsRoomDoorsCallback:
	checkevent EVENT_CHAMPIONS_ROOM_ENTRANCE_CLOSED
	iffalse .KeepEntranceOpen
	changeblock 4, 22, $34 ; wall
.KeepEntranceOpen:
	checkevent EVENT_CHAMPIONS_ROOM_EXIT_OPEN
	iffalse .KeepExitClosed
	changeblock 4, 0, $0b ; open door
.KeepExitClosed:
	endcallback

ChampionsRoomDoorLocksBehindYouScript:
	applymovement PLAYER, ChampionsRoom_EnterMovement
	reanchormap $86
	playsound SFX_STRENGTH
	earthquake 80
	changeblock 4, 22, $34 ; wall
	refreshmap
	closetext
	setscene SCENE_CHAMPIONSROOM_APPROACH_LANCE
	setevent EVENT_CHAMPIONS_ROOM_ENTRANCE_CLOSED
	end

Script_ApproachLanceFromLeft:
	special FadeOutMusic
	applymovement PLAYER, MovementData_ApproachLanceFromLeft
	sjump ChampionsRoomLanceScript

Script_ApproachLanceFromRight:
	special FadeOutMusic
	applymovement PLAYER, MovementData_ApproachLanceFromRight
ChampionsRoomLanceScript:
	turnobject CHAMPIONSROOM_LANCE, LEFT
	opentext
	writetext LanceBattleIntroText
	waitbutton
	closetext
	winlosstext LanceBattleWinText, 0
	setlasttalked CHAMPIONSROOM_LANCE
	loadtrainer CHAMPION, LANCE
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	setevent EVENT_BEAT_CHAMPION_LANCE
	opentext
	writetext LanceBattleAfterText
	waitbutton
	closetext
	playsound SFX_ENTER_DOOR
	changeblock 4, 0, $0b ; open door
	refreshmap
	closetext
	setevent EVENT_CHAMPIONS_ROOM_ENTRANCE_CLOSED
	musicfadeout MUSIC_BEAUTY_ENCOUNTER, 16
	pause 30
	showemote EMOTE_SHOCK, CHAMPIONSROOM_LANCE, 15
	turnobject CHAMPIONSROOM_LANCE, DOWN
	pause 10
	turnobject PLAYER, DOWN
	appear CHAMPIONSROOM_MARY
	applymovement CHAMPIONSROOM_MARY, ChampionsRoomMovementData_MaryRushesIn
	opentext
	writetext ChampionsRoomMaryOhNoOakText
	waitbutton
	closetext
	appear CHAMPIONSROOM_OAK
	applymovement CHAMPIONSROOM_OAK, ChampionsRoomMovementData_OakWalksIn
	follow CHAMPIONSROOM_MARY, CHAMPIONSROOM_OAK
	applymovement CHAMPIONSROOM_MARY, ChampionsRoomMovementData_MaryYieldsToOak
	stopfollow
	turnobject CHAMPIONSROOM_OAK, UP
	turnobject CHAMPIONSROOM_LANCE, LEFT
	opentext
	writetext ChampionsRoomOakCongratulationsText
	waitbutton
	closetext
	applymovement CHAMPIONSROOM_MARY, ChampionsRoomMovementData_MaryInterviewChampion
	turnobject PLAYER, LEFT
	opentext
	writetext ChampionsRoomMaryInterviewText
	waitbutton
	closetext
	applymovement CHAMPIONSROOM_LANCE, ChampionsRoomMovementData_LancePositionsSelfToGuidePlayerAway
	turnobject PLAYER, UP
	opentext
	writetext ChampionsRoomNoisyText
	waitbutton
	closetext
	follow CHAMPIONSROOM_LANCE, PLAYER
	turnobject CHAMPIONSROOM_MARY, UP
	turnobject CHAMPIONSROOM_OAK, UP
	applymovement CHAMPIONSROOM_LANCE, ChampionsRoomMovementData_LanceLeadsPlayerToHallOfFame
	stopfollow
	playsound SFX_EXIT_BUILDING
	disappear CHAMPIONSROOM_LANCE
	applymovement PLAYER, ChampionsRoomMovementData_PlayerExits
	playsound SFX_EXIT_BUILDING
	disappear PLAYER
	applymovement CHAMPIONSROOM_MARY, ChampionsRoomMovementData_MaryTriesToFollow
	showemote EMOTE_SHOCK, CHAMPIONSROOM_MARY, 15
	opentext
	writetext ChampionsRoomMaryNoInterviewText
	pause 30
	closetext
	applymovement CHAMPIONSROOM_MARY, ChampionsRoomMovementData_MaryRunsBackAndForth
	special FadeOutToWhite
	pause 15
	warpfacing UP, HALL_OF_FAME, 4, 13
	end

ChampionsRoom_EnterMovement:
	step UP
	step UP
	step UP
	step UP
	step_end

MovementData_ApproachLanceFromLeft:
	step UP
	step UP
	turn_head RIGHT
	step_end

MovementData_ApproachLanceFromRight:
	step UP
	step LEFT
	step UP
	turn_head RIGHT
	step_end

ChampionsRoomMovementData_MaryRushesIn:
	big_step UP
	big_step UP
	big_step UP
	turn_head DOWN
	step_end

ChampionsRoomMovementData_OakWalksIn:
	step UP
	step UP
	step_end

ChampionsRoomMovementData_MaryYieldsToOak:
	step LEFT
	turn_head RIGHT
	step_end

ChampionsRoomMovementData_MaryInterviewChampion:
	big_step UP
	turn_head RIGHT
	step_end

ChampionsRoomMovementData_LancePositionsSelfToGuidePlayerAway:
	step UP
	step LEFT
	turn_head DOWN
	step_end

ChampionsRoomMovementData_LanceLeadsPlayerToHallOfFame:
	step UP
	step_end

ChampionsRoomMovementData_PlayerExits:
	step UP
	step_end

ChampionsRoomMovementData_MaryTriesToFollow:
	step UP
	step RIGHT
	turn_head UP
	step_end

ChampionsRoomMovementData_MaryRunsBackAndForth:
	big_step RIGHT
	big_step RIGHT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step RIGHT
	big_step RIGHT
	big_step RIGHT
	big_step LEFT
	big_step LEFT
	turn_head UP
	step_end

LanceBattleIntroText:
	text "LANCE: I've been"
	line "waiting for you."

	para "<PLAY_G>!"

	para "I knew that you,"
	line "with your skills,"

	para "would eventually"
	line "reach me here."

	para "There's no need"
	line "for words now."

	para "We will battle to"
	line "determine who is"

	para "the stronger of"
	line "the two of us."

	para "As the most power-"
	line "ful trainer and as"

	para "the #MON LEAGUE"
	line "CHAMPION…"

	para "I, LANCE the drag-"
	line "on master, accept"
	cont "your challenge!"
	done

LanceBattleWinText:
	text "…It's over."

	para "But it's an odd"
	line "feeling."

	para "I'm not angry that"
	line "I lost. In fact, I"
	cont "feel happy."

	para "Happy that I"
	line "witnessed the rise"

	para "of a great new"
	line "CHAMPION!"
	done

LanceBattleAfterText:
	text "…Whew."

	para "You have become"
	line "truly powerful,"
	cont "<PLAY_G>."

	para "Your #MON have"
	line "responded to your"

	para "strong and up-"
	line "standing nature."

	para "As a trainer, you"
	line "will continue to"

	para "grow strong with"
	line "your #MON."
	done

ChampionsRoomMaryOhNoOakText:
	text "MARY: Oh, no!"
	line "It's all over!"

	para "PROF.OAK, if you"
	line "weren't so slow…"
	done

ChampionsRoomOakCongratulationsText:
	text "PROF.OAK: Ah,"
	line "<PLAY_G>!"

	para "It's been a long"
	line "while."

	para "You certainly look"
	line "more impressive."

	para "Your conquest of"
	line "the LEAGUE is just"
	cont "fantastic!"

	para "Your dedication,"
	line "trust and love for"

	para "your #MON made"
	line "this happen."

	para "Your #MON were"
	line "outstanding too."

	para "Because they be-"
	line "lieved in you as a"

	para "trainer, they per-"
	line "severed."

	para "Congratulations,"
	line "<PLAY_G>!"
	done

ChampionsRoomMaryInterviewText:
	text "MARY: Let's inter-"
	line "view the brand new"
	cont "CHAMPION!"
	done

ChampionsRoomNoisyText:
	text "LANCE: This is"
	line "getting to be a"
	cont "bit too noisy…"

	para "<PLAY_G>, could you"
	line "come with me?"
	done

ChampionsRoomMaryNoInterviewText:
	text "MARY: Oh, wait!"
	line "We haven't done"
	cont "the interview!"
	done

ChampionsRoom_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 23, LANCES_ROOM, 2 ; M10 13j: LANCE's exits are warps 2/3 (Yellow); 13k re-cuts this room
	warp_event  5, 23, LANCES_ROOM, 3
	warp_event  4,  1, HALL_OF_FAME, 1
	warp_event  5,  1, HALL_OF_FAME, 2

	def_coord_events
	coord_event  4,  5, SCENE_CHAMPIONSROOM_APPROACH_LANCE, Script_ApproachLanceFromLeft
	coord_event  5,  5, SCENE_CHAMPIONSROOM_APPROACH_LANCE, Script_ApproachLanceFromRight

	def_bg_events

	def_object_events
	object_event  5,  3, SPRITE_LANCE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ChampionsRoomLanceScript, -1
	object_event  4,  7, SPRITE_TEACHER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_CHAMPIONS_ROOM_OAK_AND_MARY
	object_event  4,  7, SPRITE_OAK, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_CHAMPIONS_ROOM_OAK_AND_MARY
