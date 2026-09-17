	object_const_def
	const PALLETTOWN_TEACHER
	const PALLETTOWN_FISHER
	const PALLETTOWN_OAK

PalletTown_MapScripts:
	def_scene_scripts
	scene_script PalletTownNoop1Scene, SCENE_PALLETTOWN_OAK_INTRO
	scene_script PalletTownNoop2Scene, SCENE_PALLETTOWN_OAK_LEFT
	scene_script PalletTownNoop3Scene, SCENE_PALLETTOWN_OAK_RIGHT
	scene_script PalletTownNoop4Scene, SCENE_PALLETTOWN_NOOP

	def_callbacks
	callback MAPCALLBACK_NEWMAP, PalletTownFlypointCallback
	callback MAPCALLBACK_OBJECTS, PalletTownOakCallback

PalletTownNoop1Scene:
PalletTownNoop2Scene:
PalletTownNoop3Scene:
PalletTownNoop4Scene:
	end

PalletTownFlypointCallback:
	setflag ENGINE_FLYPOINT_PALLET
	endcallback

; The catch tutorial reloads the map mid-cutscene, which puts Oak back at his
; object_event position. The LEFT/RIGHT scenes mark which exit column the
; player took so he is re-placed right behind them (docs/M2-INTRO.md).
PalletTownOakCallback:
	checkscene
	ifequal SCENE_PALLETTOWN_OAK_LEFT, .Left
	ifequal SCENE_PALLETTOWN_OAK_RIGHT, .Right
	endcallback

.Left:
	moveobject PALLETTOWN_OAK, 8, 1
	endcallback

.Right:
	moveobject PALLETTOWN_OAK, 9, 1
	endcallback

; Yellow's intro beat: the player tries to leave north through the grass,
; Oak stops them, catches a wild Pikachu, then leads them into his lab.
; Oak appears at row 5, one row below the screen: CheckObjectStillVisible
; deletes objects whose stored y (+4) is >= 11 rows past the player, so
; Yellow's row 6 would despawn him the frame he appears.
PalletTownOakInterceptLeft:
	moveobject PALLETTOWN_OAK, 8, 5
	setscene SCENE_PALLETTOWN_OAK_LEFT
	scall PalletTownOakHeyWait
	turnobject PALLETTOWN_OAK, RIGHT
	scall PalletTownOakCatchesPikachu
	follow PALLETTOWN_OAK, PLAYER
	applymovement PALLETTOWN_OAK, PalletTown_OakToLabLeftMovement
	sjump PalletTownOakIntoLab

PalletTownOakInterceptRight:
	moveobject PALLETTOWN_OAK, 9, 5
	setscene SCENE_PALLETTOWN_OAK_RIGHT
	scall PalletTownOakHeyWait
	turnobject PALLETTOWN_OAK, LEFT
	scall PalletTownOakCatchesPikachu
	follow PALLETTOWN_OAK, PLAYER
	applymovement PALLETTOWN_OAK, PalletTown_OakToLabRightMovement
	sjump PalletTownOakIntoLab

PalletTownOakHeyWait:
	playmusic MUSIC_PROF_OAK
	opentext
	writetext PalletTownOakHeyWaitText
	waitbutton
	closetext
	showemote EMOTE_SHOCK, PLAYER, 15
	turnobject PLAYER, DOWN
	clearevent EVENT_PALLET_TOWN_OAK
	appear PALLETTOWN_OAK
	applymovement PALLETTOWN_OAK, PalletTown_OakWalksUpMovement
	opentext
	writetext PalletTownOakThatWasCloseText
	waitbutton
	closetext
	end

PalletTownOakCatchesPikachu:
	pause 15
	loadwildmon PIKACHU, 5
	special OakCatchTutorial
	dontrestartmapmusic
	reloadmap
	playmusic MUSIC_PROF_OAK
	turnobject PALLETTOWN_OAK, UP
	opentext
	writetext PalletTownOakWhewText
	waitbutton
	writetext PalletTownOakComeWithMeText
	waitbutton
	closetext
	end

PalletTownOakIntoLab:
	stopfollow
	disappear PALLETTOWN_OAK
	setevent EVENT_PALLET_TOWN_OAK
	clearevent EVENT_OAKS_LAB_RIVAL
	setmapscene OAKS_LAB, SCENE_OAKSLAB_INTRO
	setscene SCENE_PALLETTOWN_NOOP
	special FadeOutMusic
	applymovement PLAYER, PalletTown_PlayerIntoLabMovement
	warpcheck
	end

PalletTownOakScript:
	jumptextfaceplayer PalletTownOakComeWithMeText

PalletTownTeacherScript:
	jumptextfaceplayer PalletTownTeacherText

PalletTownFisherScript:
	jumptextfaceplayer PalletTownFisherText

PalletTownSign:
	jumptext PalletTownSignText

RedsHouseSign:
	jumptext RedsHouseSignText

OaksLabSign:
	jumptext OaksLabSignText

BluesHouseSign:
	jumptext BluesHouseSignText

PalletTown_OakWalksUpMovement:
	step UP
	step UP
	step UP
	step UP
	step_end

PalletTown_OakToLabLeftMovement:
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step UP
	step_end

PalletTown_OakToLabRightMovement:
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step RIGHT
	step RIGHT
	step RIGHT
	step UP
	step_end

PalletTown_PlayerIntoLabMovement:
	step UP
	step_end

PalletTownOakHeyWaitText:
	text "OAK: Hey! Wait!"
	line "Don't go out!"
	done

PalletTownOakThatWasCloseText:
	text "OAK: That was"
	line "close!"

	para "Wild #MON live"
	line "in tall grass!"
	done

PalletTownOakWhewText:
	text "OAK: Whew…"
	done

PalletTownOakComeWithMeText:
	text "OAK: A #MON can"
	line "appear anytime in"
	cont "tall grass."

	para "You need your own"
	line "#MON for your"
	cont "protection."
	cont "I know!"

	para "Here, come with"
	line "me!"
	done

PalletTownTeacherText:
	text "I'm raising #-"
	line "MON too."

	para "They serve as my"
	line "private guards."
	done

PalletTownFisherText:
	text "Technology is"
	line "incredible!"

	para "You can now trade"
	line "#MON across"
	cont "time like e-mail."
	done

PalletTownSignText:
	text "PALLET TOWN"

	para "A Tranquil Setting"
	line "of Peace & Purity"
	done

RedsHouseSignText:
	text "RED'S HOUSE"
	done

OaksLabSignText:
	text "OAK #MON"
	line "RESEARCH LAB"
	done

BluesHouseSignText:
	text "BLUE'S HOUSE"
	done

PalletTown_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  5,  5, REDS_HOUSE_1F, 1
	warp_event 13,  5, BLUES_HOUSE, 1
	warp_event 12, 11, OAKS_LAB, 1

	def_coord_events
	coord_event  8,  0, SCENE_PALLETTOWN_OAK_INTRO, PalletTownOakInterceptLeft
	coord_event  9,  0, SCENE_PALLETTOWN_OAK_INTRO, PalletTownOakInterceptRight

	def_bg_events
	bg_event  7,  9, BGEVENT_READ, PalletTownSign
	bg_event  3,  5, BGEVENT_READ, RedsHouseSign
	bg_event 13, 13, BGEVENT_READ, OaksLabSign
	bg_event 11,  5, BGEVENT_READ, BluesHouseSign

	def_object_events
	object_event  3,  8, SPRITE_TEACHER, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PalletTownTeacherScript, -1
	object_event 12, 14, SPRITE_FISHER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 2, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, PalletTownFisherScript, -1
	object_event  8,  5, SPRITE_OAK, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PalletTownOakScript, EVENT_PALLET_TOWN_OAK
