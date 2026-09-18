; Kanto hack (docs/M3-CERULEAN.md, 6e): Yellow's CERULEAN GYM.
;
; Crystal's gym is kept as geometry only -- same .blk, same two warps, same
; statue bg_events -- but everything in it is Yellow's: MISTY with Yellow's
; L18 STARYU / L21 STARMIE, Yellow's two gym trainers (JR.TRAINER^F -> a
; PICNICKER, SWIMMER -> a SWIMMERM), Yellow's gym guide, the CASCADEBADGE and
; Yellow's TM reward, TM11 BUBBLEBEAM, made a real TM item by M3b
; (docs/M3B-TM-UNION.md); it shipped as the stand-in TM_RAIN_DANCE until then.
;
; Deleted with Crystal's Johto plot: the Rocket grunt object and his
; SCENE_CERULEANGYM_GRUNT_RUNS_OUT cutscene, the two "MISTY is out on a date"
; statue notes, Crystal's third swimmer, and the hidden MACHINE_PART at (3,8).
; NOTE for M5 (Johto re-route): the MACHINE_PART for the Power Plant quest no
; longer has a location -- PowerPlant.asm still clears
; EVENT_FOUND_MACHINE_PART_IN_CERULEAN_GYM and still points the gym at
; SCENE_CERULEANGYM_GRUNT_RUNS_OUT, so that scene id is deliberately kept below
; (bound to the no-op scene) and both of those lines are now inert.

	object_const_def
	const CERULEANGYM_MISTY
	const CERULEANGYM_PICNICKER
	const CERULEANGYM_SWIMMER_GUY
	const CERULEANGYM_GYM_GUIDE

CeruleanGym_MapScripts:
	def_scene_scripts
	scene_script CeruleanGymNoopScene, SCENE_CERULEANGYM_NOOP
; 6e: Crystal's Rocket-grunt scene is gone, but PowerPlant.asm (Johto, M5) still
; does `setmapscene CERULEAN_GYM, SCENE_CERULEANGYM_GRUNT_RUNS_OUT`.  Keep the
; constant defined and bind it to the no-op script so that line stays harmless.
	scene_script CeruleanGymNoopScene, SCENE_CERULEANGYM_GRUNT_RUNS_OUT

	def_callbacks

CeruleanGymNoopScene:
	end

; Yellow's flow (vendor/pokeyellow/scripts/CeruleanGym.asm,
; text/CeruleanGym.asm): pre-battle speech -> battle -> "I can't believe I
; lost!" + CASCADEBADGE -> the badge explanation, which ends by offering her
; favourite TM -> the TM -> the TM explanation, which is also what she says
; every time you talk to her afterwards.  Structured like PewterGym.asm (4e).
CeruleanGymMistyScript:
	faceplayer
	opentext
	checkflag ENGINE_CASCADEBADGE
	iftrue .FightDone
	writetext MistyIntroText
	waitbutton
	closetext
	winlosstext MistyWinLossText, 0
	loadtrainer MISTY, MISTY1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_MISTY
	setevent EVENT_BEAT_PICNICKER_DIANA
	setevent EVENT_BEAT_SWIMMERM_LUIS
	opentext
	writetext ReceivedCascadeBadgeText
	playsound SFX_GET_BADGE
	waitsfx
	setflag ENGINE_CASCADEBADGE
	writetext MistyCascadeBadgeInfoText
	waitbutton
.FightDone:
	checkevent EVENT_GOT_TM_FROM_MISTY
	iftrue .SpeechAfterTM
	verbosegiveitem TM_BUBBLEBEAM
	iffalse .NoRoomForTM
	setevent EVENT_GOT_TM_FROM_MISTY
.SpeechAfterTM:
	writetext MistyTMBubblebeamText
	waitbutton
.NoRoomForTM:
	closetext
	end

TrainerPicnickerDiana:
	trainer PICNICKER, DIANA, EVENT_BEAT_PICNICKER_DIANA, PicnickerDianaSeenText, PicnickerDianaBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PicnickerDianaAfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmermLuis:
	trainer SWIMMERM, LUIS, EVENT_BEAT_SWIMMERM_LUIS, SwimmermLuisSeenText, SwimmermLuisBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SwimmermLuisAfterBattleText
	waitbutton
	closetext
	end

CeruleanGymGuideScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_MISTY
	iftrue .CeruleanGymGuideWinScript
	writetext CeruleanGymGuideText
	waitbutton
	closetext
	end

.CeruleanGymGuideWinScript:
	writetext CeruleanGymGuideWinText
	waitbutton
	closetext
	end

CeruleanGymStatue:
	; Kanto hack (N1a): Yellow's pre-badge statue names the LEADER too
	; (_GymStatueText1), so wStringBuffer4 must be filled for BOTH statues.
	gettrainername STRING_BUFFER_4, MISTY, MISTY1
	checkflag ENGINE_CASCADEBADGE
	iftrue .Beaten
	jumpstd GymStatue1Script
.Beaten:
	jumpstd GymStatue2Script

MistyIntroText:
	text "Hi, you're a new"
	line "face!"

	para "What's your policy"
	line "on #MON? What"
	cont "is your approach?"

	para "My policy is an"
	line "all-out offensive"
	cont "with water-type"
	cont "#MON!"

	para "MISTY, the world-"
	line "famous beauty, is"
	cont "your host!"

	para "Are you ready,"
	line "sweetie?"
	done

MistyWinLossText:
	text "MISTY: I can't"
	line "believe I lost!"

	para "All right!"

	para "You can have the"
	line "CASCADEBADGE to"
	cont "show you beat me!"
	done

ReceivedCascadeBadgeText:
	text "<PLAYER> received"
	line "CASCADEBADGE."
	done

MistyCascadeBadgeInfoText:
	text "The CASCADEBADGE"
	line "makes all #MON"
	cont "up to L30 obey!"

	para "That includes"
	line "even outsiders!"

	para "There's more, you"
	line "can now use CUT"
	cont "anytime!"

	para "You can CUT down"
	line "small bushes to"
	cont "open new paths!"

	para "You can also have"
	line "my favorite TM!"
	done

MistyTMBubblebeamText:
; Yellow says "TM11"; our TM union numbers BUBBLEBEAM as TM60
; (docs/M3B-TM-UNION.md).
	text "TM60 teaches"
	line "BUBBLEBEAM!"

	para "Use it on an"
	line "aquatic #MON!"
	done

PicnickerDianaSeenText:
	text "I'm more than good"
	line "enough for you!"

	para "MISTY can wait!"
	done

PicnickerDianaBeatenText:
	text "You"
	line "overwhelmed me!"
	done

PicnickerDianaAfterBattleText:
	text "You have to face"
	line "other trainers to"
	cont "find out how good"
	cont "you really are."
	done

SwimmermLuisSeenText:
	text "Splash!"

	para "I'm first up!"
	line "Let's do it!"
	done

SwimmermLuisBeatenText:
	text "That"
	line "can't be!"
	done

SwimmermLuisAfterBattleText:
	text "MISTY is going to"
	line "keep improving!"

	para "She won't lose to"
	line "someone like you!"
	done

CeruleanGymGuideText:
	text "Yo! Champ in"
	line "making!"

	para "Here's my advice!"

	para "The LEADER, MISTY,"
	line "is a pro who uses"
	cont "water #MON!"

	para "You can drain all"
	line "their water with"
	cont "plant #MON!"

	para "Or, zap them with"
	line "electricity!"
	done

CeruleanGymGuideWinText:
	text "You beat MISTY!"
	line "What'd I tell ya?"

	para "You and me, kid,"
	line "we make a pretty"
	cont "darn good team!"
	done

CeruleanGym_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 15, CERULEAN_CITY, 4
	warp_event  5, 15, CERULEAN_CITY, 4

	def_coord_events

	def_bg_events
	bg_event  2, 13, BGEVENT_READ, CeruleanGymStatue
	bg_event  6, 13, BGEVENT_READ, CeruleanGymStatue

	def_object_events
; All four are always visible (-1), as in PewterGym.asm.  Crystal hid them
; behind EVENT_TRAINERS_IN_CERULEAN_GYM, which InitializeEventsScript set at
; new game and only Route 25's Misty's-date scene ever cleared -- so under the
; Kanto start the gym would have been empty.  6i deleted that Route 25 scene
; and the two stale setevents with it; the flag itself is now dead.
	object_event  5,  3, SPRITE_MISTY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeruleanGymMistyScript, -1
	object_event  2,  4, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerPicnickerDiana, -1
	object_event  8,  9, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerSwimmermLuis, -1
	object_event  7, 13, SPRITE_GYM_GUIDE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeruleanGymGuideScript, -1
