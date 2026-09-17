	object_const_def
	const OAKSLAB_OAK
	const OAKSLAB_SCIENTIST1
	const OAKSLAB_SCIENTIST2
	const OAKSLAB_SCIENTIST3
	const OAKSLAB_RIVAL
	const OAKSLAB_EEVEE_BALL

OaksLab_MapScripts:
	def_scene_scripts
	scene_script OaksLabNoopScene,  SCENE_OAKSLAB_NOOP
	scene_script OaksLabIntroScene, SCENE_OAKSLAB_INTRO

	def_callbacks

OaksLabNoopScene:
	end

OaksLabIntroScene:
	sdefer OaksLabIntroScript
	end

; Yellow's lab beat (docs/M2-INTRO.md): Oak has just led the player in.
; The rival (shown because Pallet cleared EVENT_OAKS_LAB_RIVAL) takes the
; Eevee on the table, the player gets Oak's Pikachu, the rival battles and
; leaves, and Pikachu refuses its ball and starts following.
OaksLabIntroScript:
	applymovement PLAYER, OaksLab_PlayerWalksToOakMovement
	opentext
	writetext OaksLabRivalFedUpText
	waitbutton
	writetext OaksLabOakChooseMonText
	waitbutton
	writetext OaksLabRivalWhatAboutMeText
	waitbutton
	writetext OaksLabOakBePatientText
	waitbutton
	writetext OaksLabRivalIWantThisText
	waitbutton
	closetext
	applymovement OAKSLAB_RIVAL, OaksLab_RivalToTableMovement
	disappear OAKSLAB_EEVEE_BALL
	setevent EVENT_OAKS_LAB_EEVEE_BALL
	opentext
	writetext OaksLabRivalSnatchedText
	waitbutton
	writetext OaksLabOakWhatAreYouDoingText
	waitbutton
	writetext OaksLabRivalIWantThisOneText
	waitbutton
	writetext OaksLabOakAllRightThenText
	waitbutton
	closetext
	turnobject PLAYER, UP
	opentext
	writetext OaksLabOakGivesPikachuText
	promptbutton
	playsound SFX_CAUGHT_MON
	waitsfx
	givepoke PIKACHU, 5
	setevent EVENT_GOT_STARTER_PIKACHU
	closetext
	applymovement OAKSLAB_RIVAL, OaksLab_RivalToPlayerMovement
	turnobject PLAYER, RIGHT
	playmusic MUSIC_RIVAL_ENCOUNTER
	opentext
	writetext OaksLabRivalTakeYouOnText
	waitbutton
	closetext
	winlosstext OaksLabRivalWinText, OaksLabRivalLossText
	setlasttalked OAKSLAB_RIVAL
	loadtrainer KANTO_RIVAL, KANTO_RIVAL_1
	loadvar VAR_BATTLETYPE, BATTLETYPE_CANLOSE
	startbattle
	dontrestartmapmusic
	reloadmap
	special HealParty
	turnobject OAKSLAB_RIVAL, LEFT
	playmusic MUSIC_RIVAL_AFTER
	opentext
	writetext OaksLabRivalSmellYouLaterText
	waitbutton
	closetext
	applymovement OAKSLAB_RIVAL, OaksLab_RivalLeavesMovement
	disappear OAKSLAB_RIVAL
	setevent EVENT_OAKS_LAB_RIVAL
	playmapmusic
	turnobject PLAYER, UP
	pause 20
	cry PIKACHU
	opentext
	writetext OaksLabOakWhatText
	waitbutton
	closetext
	special EnablePikaFollower
	opentext
	writetext OaksLabPikachuDislikesBallsText
	waitbutton
	closetext
	setevent EVENT_BATTLED_RIVAL_IN_OAKS_LAB
	setscene SCENE_OAKSLAB_NOOP
	end

OaksLabRivalScript:
	jumptextfaceplayer OaksLabRivalFedUpText

OaksLabEeveeBallScript:
	jumptext OaksLabThatsAPokeBallText

Oak:
	faceplayer
	opentext
	checkevent EVENT_GOT_STARTER_PIKACHU
	iffalse .BeforeIntro
	; TODO(M2 step 2): the parcel quest replaces this. The vanilla Kanto
	; logic below is kept for the Johto act.
	writetext OakYourPokemonCanFightText
	waitbutton
	closetext
	end

.BeforeIntro:
	writetext OakBusyText
	waitbutton
	closetext
	end

.KantoAct2: ; unreferenced until the Johto act
	checkevent EVENT_OPENED_MT_SILVER
	iftrue .CheckPokedex
	checkevent EVENT_TALKED_TO_OAK_IN_KANTO
	iftrue .CheckBadges
	writetext OakWelcomeKantoText
	promptbutton
	setevent EVENT_TALKED_TO_OAK_IN_KANTO
.CheckBadges:
	readvar VAR_BADGES
	ifequal NUM_BADGES, .OpenMtSilver
	ifequal NUM_JOHTO_BADGES, .Complain
	sjump .AhGood

.CheckPokedex:
	writetext OakLabDexCheckText
	waitbutton
	special ProfOaksPCBoot
	writetext OakLabGoodbyeText
	waitbutton
	closetext
	end

.OpenMtSilver:
	writetext OakOpenMtSilverText
	promptbutton
	setevent EVENT_OPENED_MT_SILVER
	sjump .CheckPokedex

.Complain:
	writetext OakNoKantoBadgesText
	promptbutton
	sjump .CheckPokedex

.AhGood:
	writetext OakYesKantoBadgesText
	promptbutton
	sjump .CheckPokedex

OaksAssistant1Script:
	jumptextfaceplayer OaksAssistant1Text

OaksAssistant2Script:
	jumptextfaceplayer OaksAssistant2Text

OaksAssistant3Script:
	jumptextfaceplayer OaksAssistant3Text

OaksLabBookshelf:
	jumpstd DifficultBookshelfScript

OaksLab_PlayerWalksToOakMovement:
	step UP
	step UP
	step UP
	step UP
	step UP
	step UP
	step UP
	step_end

OaksLab_RivalToTableMovement:
	step RIGHT
	step RIGHT
	turn_head UP
	step_end

OaksLab_RivalToPlayerMovement:
	step LEFT
	step LEFT
	turn_head LEFT
	step_end

OaksLab_RivalLeavesMovement:
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step_end

OaksLabRivalFedUpText:
	text "<RIVAL>: Gramps!"
	line "I'm fed up with"
	cont "waiting!"
	done

OaksLabOakChooseMonText:
	text "OAK: Hmm? <RIVAL>?"
	line "Why are you here"
	cont "already?"

	para "I said for you to"
	line "come by later…"

	para "Ah, whatever!"
	line "Just wait there."

	para "Look, <PLAYER>! Do"
	line "you see that ball"
	cont "on the table?"

	para "It's called a #"
	line "BALL. It holds a"
	cont "#MON inside."

	para "You may have it!"
	line "Go on, take it!"
	done

OaksLabRivalWhatAboutMeText:
	text "<RIVAL>: Hey!"
	line "Gramps! What"
	cont "about me?"
	done

OaksLabOakBePatientText:
	text "OAK: Be patient,"
	line "<RIVAL>, I'll give"
	cont "you one later."
	done

OaksLabRivalIWantThisText:
	text "<RIVAL>: No way!"
	line "<PLAYER>, I want"
	cont "this #MON!"
	done

OaksLabRivalSnatchedText:
	text "<RIVAL> snatched"
	line "the #MON!"
	done

OaksLabOakWhatAreYouDoingText:
	text "OAK: <RIVAL>! What"
	line "are you doing?"
	done

OaksLabRivalIWantThisOneText:
	text "<RIVAL>: Gramps, I"
	line "want this one!"
	done

OaksLabOakAllRightThenText:
	text "OAK: But, I… Oh,"
	line "all right then."
	cont "That #MON is"
	cont "yours."

	para "I was going to"
	line "give you one"
	cont "anyway…"

	para "<PLAYER>, come over"
	line "here."
	done

OaksLabOakGivesPikachuText:
	text "OAK: <PLAYER>, this"
	line "is the #MON I"
	cont "caught earlier."

	para "You can have it."
	line "I caught it in"
	cont "the wild and it's"
	cont "not tame yet."
	done

OaksLabRivalTakeYouOnText:
	text "<RIVAL>: Wait"
	line "<PLAYER>!"
	cont "Let's check out"
	cont "our #MON!"

	para "Come on, I'll take"
	line "you on!"
	done

OaksLabRivalWinText:
	text "WHAT?"
	line "Unbelievable!"
	cont "I picked the"
	cont "wrong #MON!"
	done

OaksLabRivalLossText:
	text "<RIVAL>: Yeah! Am"
	line "I great or what?"
	done

OaksLabRivalSmellYouLaterText:
	text "<RIVAL>: Okay!"
	line "I'll make my"
	cont "#MON fight to"
	cont "toughen it up!"

	para "<PLAYER>! Gramps!"
	line "Smell you later!"
	done

OaksLabOakWhatText:
	text "OAK: What?"
	done

OaksLabPikachuDislikesBallsText:
	text "OAK: Would you"
	line "look at that!"

	para "It's odd, but it"
	line "appears that your"
	cont "PIKACHU dislikes"
	cont "# BALLs."

	para "You should just"
	line "keep it with you."

	para "That should make"
	line "it happy!"

	para "You can talk to it"
	line "and see how it"
	cont "feels about you."
	done

OaksLabThatsAPokeBallText:
	text "That's a #"
	line "BALL. There's a"
	cont "#MON inside!"
	done

OakYourPokemonCanFightText:
	text "OAK: If a wild"
	line "#MON appears,"
	cont "your #MON can"
	cont "fight against it!"

	para "Afterward, go on"
	line "to the next town."
	done

OakBusyText:
	text "OAK: Hmm? Oh,"
	line "<PLAYER>. I'm a bit"
	cont "busy right now."

	para "Come back a little"
	line "later."
	done

OaksLabPoster1:
	jumptext OaksLabPoster1Text

OaksLabPoster2:
	jumptext OaksLabPoster2Text

OaksLabTrashcan:
	jumptext OaksLabTrashcanText

OaksLabPC:
	jumptext OaksLabPCText

OakWelcomeKantoText:
	text "OAK: Ah, <PLAY_G>!"
	line "It's good of you"

	para "to come all this"
	line "way to KANTO."

	para "What do you think"
	line "of the trainers"

	para "out here?"
	line "Pretty tough, huh?"
	done

OakLabDexCheckText:
	text "How is your #-"
	line "DEX coming?"

	para "Let's see…"
	done

OakLabGoodbyeText:
	text "If you're in the"
	line "area, I hope you"
	cont "come visit again."
	done

OakOpenMtSilverText:
	text "OAK: Wow! That's"
	line "excellent!"

	para "You collected the"
	line "BADGES of GYMS in"
	cont "KANTO. Well done!"

	para "I was right in my"
	line "assessment of you."

	para "Tell you what,"
	line "<PLAY_G>. I'll make"

	para "arrangements so"
	line "that you can go to"
	cont "MT.SILVER."

	para "MT.SILVER is a big"
	line "mountain that is"

	para "home to many wild"
	line "#MON."

	para "It's too dangerous"
	line "for your average"

	para "trainer, so it's"
	line "off limits. But"

	para "we can make an"
	line "exception in your"
	cont "case, <PLAY_G>."

	para "Go up to INDIGO"
	line "PLATEAU. You can"

	para "reach MT.SILVER"
	line "from there."
	done

OakNoKantoBadgesText:
	text "OAK: Hmm? You're"
	line "not collecting"
	cont "KANTO GYM BADGES?"

	para "The GYM LEADERS in"
	line "KANTO are as tough"

	para "as any you battled"
	line "in JOHTO."

	para "I recommend that"
	line "you challenge"
	cont "them."
	done

OakYesKantoBadgesText:
	text "OAK: Ah, you're"
	line "collecting KANTO"
	cont "GYM BADGES."

	para "I imagine that"
	line "it's hard, but the"

	para "experience is sure"
	line "to help you."

	para "Come see me when"
	line "you get them all."

	para "I'll have a gift"
	line "for you."

	para "Keep trying hard,"
	line "<PLAY_G>!"
	done

OaksAssistant1Text:
	text "The PROF's #MON"
	line "TALK radio program"

	para "isn't aired here"
	line "in KANTO."

	para "It's a shame--I'd"
	line "like to hear it."
	done

OaksAssistant2Text:
	text "Thanks to your"
	line "work on the #-"
	cont "DEX, the PROF's"

	para "research is coming"
	line "along great."
	done

OaksAssistant3Text:
	text "Don't tell anyone,"
	line "but PROF.OAK'S"

	para "#MON TALK isn't"
	line "a live broadcast."
	done

OaksLabPoster1Text:
	text "Press START to"
	line "open the MENU."
	done

OaksLabPoster2Text:
	text "The SAVE option is"
	line "on the MENU."

	para "Use it in a timely"
	line "manner."
	done

OaksLabTrashcanText:
	text "There's nothing in"
	line "here…"
	done

OaksLabPCText:
	text "There's an e-mail"
	line "message on the PC."

	para "…"

	para "PROF.OAK, how is"
	line "your research"
	cont "coming along?"

	para "I'm still plugging"
	line "away."

	para "I heard rumors"
	line "that <PLAY_G> is"

	para "getting quite a"
	line "reputation."

	para "I'm delighted to"
	line "hear that."

	para "ELM in NEW BARK"
	line "TOWN 8-)"
	done

OaksLab_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 11, PALLET_TOWN, 3
	warp_event  5, 11, PALLET_TOWN, 3

	def_coord_events

	def_bg_events
	bg_event  6,  1, BGEVENT_READ, OaksLabBookshelf
	bg_event  7,  1, BGEVENT_READ, OaksLabBookshelf
	bg_event  8,  1, BGEVENT_READ, OaksLabBookshelf
	bg_event  9,  1, BGEVENT_READ, OaksLabBookshelf
	bg_event  0,  7, BGEVENT_READ, OaksLabBookshelf
	bg_event  1,  7, BGEVENT_READ, OaksLabBookshelf
	bg_event  2,  7, BGEVENT_READ, OaksLabBookshelf
	bg_event  3,  7, BGEVENT_READ, OaksLabBookshelf
	bg_event  6,  7, BGEVENT_READ, OaksLabBookshelf
	bg_event  7,  7, BGEVENT_READ, OaksLabBookshelf
	bg_event  8,  7, BGEVENT_READ, OaksLabBookshelf
	bg_event  9,  7, BGEVENT_READ, OaksLabBookshelf
	bg_event  4,  0, BGEVENT_READ, OaksLabPoster1
	bg_event  5,  0, BGEVENT_READ, OaksLabPoster2
	bg_event  9,  3, BGEVENT_READ, OaksLabTrashcan
	bg_event  0,  1, BGEVENT_READ, OaksLabPC

	def_object_events
	object_event  4,  2, SPRITE_OAK, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Oak, -1
	object_event  1,  8, SPRITE_SCIENTIST, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, OaksAssistant1Script, -1
	object_event  8,  9, SPRITE_SCIENTIST, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, OaksAssistant2Script, -1
	object_event  1,  4, SPRITE_SCIENTIST, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, OaksAssistant3Script, -1
	object_event  5,  4, SPRITE_BLUE, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, OaksLabRivalScript, EVENT_OAKS_LAB_RIVAL
	object_event  7,  3, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, OaksLabEeveeBallScript, EVENT_OAKS_LAB_EEVEE_BALL
