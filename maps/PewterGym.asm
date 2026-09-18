	object_const_def
	const PEWTERGYM_BROCK
	const PEWTERGYM_YOUNGSTER
	const PEWTERGYM_GYM_GUIDE

PewterGym_MapScripts:
	def_scene_scripts

	def_callbacks

; Kanto hack (docs/M2-PEWTER-CITY.md): Yellow's BROCK. He hands out TM_BIDE,
; exactly as Yellow's TM34 does (the TM item was added by M3b, see
; docs/M3B-TM-UNION.md; it shipped as TM_ROLLOUT until then).
PewterGymBrockScript:
	faceplayer
	opentext
	checkflag ENGINE_BOULDERBADGE
	iftrue .FightDone
	writetext BrockIntroText
	waitbutton
	closetext
	winlosstext BrockWinLossText, 0
	loadtrainer BROCK, BROCK1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_BROCK
	setevent EVENT_BEAT_CAMPER_JERRY
	opentext
	writetext ReceivedBoulderBadgeText
	playsound SFX_GET_BADGE
	waitsfx
	setflag ENGINE_BOULDERBADGE
	writetext BrockBoulderBadgeText
	waitbutton
.FightDone:
	checkevent EVENT_GOT_TM_FROM_BROCK
	iftrue .SpeechAfterTM
	writetext BrockTakeThisText
	promptbutton
	verbosegiveitem TM_BIDE
	iffalse .NoRoomForTM
	setevent EVENT_GOT_TM_FROM_BROCK
	writetext BrockTMBideText
	waitbutton
	closetext
	end

.SpeechAfterTM:
	writetext BrockFightDoneText
	waitbutton
	closetext
	end

.NoRoomForTM:
	writetext BrockTMNoRoomText
	waitbutton
	closetext
	end

TrainerCamperJerry:
	trainer CAMPER, JERRY, EVENT_BEAT_CAMPER_JERRY, CamperJerrySeenText, CamperJerryBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext CamperJerryAfterBattleText
	waitbutton
	closetext
	end

; Yellow's guide asks before he advises (vendor/pokeyellow/scripts/PewterGym.asm
; :182-213). NO gets "It's a free service!" and the advice anyway; YES with a
; PIKACHU gets the PIKACHU warning instead of the advice.
PewterGymGuideScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_BROCK
	iftrue .PewterGymGuideWinScript
	writetext PewterGymGuidePreAdviceText
	yesorno
	iffalse .PewterGymGuideFreeServiceScript
	checkevent EVENT_GOT_STARTER_PIKACHU
	iftrue .PewterGymGuidePikachuScript
	writetext PewterGymGuideBeginAdviceText
	waitbutton
	sjump .PewterGymGuideAdviceScript

.PewterGymGuideFreeServiceScript:
	writetext PewterGymGuideFreeServiceText
	waitbutton
.PewterGymGuideAdviceScript:
	writetext PewterGymGuideAdviceText
	waitbutton
	closetext
	end

.PewterGymGuidePikachuScript:
	writetext PewterGymGuidePikachuText
	waitbutton
	closetext
	end

.PewterGymGuideWinScript:
	writetext PewterGymGuideWinText
	waitbutton
	closetext
	end

PewterGymStatue:
	; Kanto hack (N1a): Yellow's pre-badge statue names the LEADER too
	; (_GymStatueText1), so wStringBuffer4 must be filled for BOTH statues.
	gettrainername STRING_BUFFER_4, BROCK, BROCK1
	checkflag ENGINE_BOULDERBADGE
	iftrue .Beaten
	jumpstd GymStatue1Script
.Beaten:
	jumpstd GymStatue2Script

BrockIntroText:
	text "I'm BROCK!"
	line "I'm PEWTER's GYM"
	cont "LEADER!"

	para "I believe in rock"
	line "hard defense and"
	cont "determination!"

	para "That's why my"
	line "#MON are all"
	cont "the rock-type!"

	para "Do you still want"
	line "to challenge me?"

	para "Fine then! Show"
	line "me your best!"
	done

BrockWinLossText:
	text "BROCK: I took"
	line "you for granted."

	para "As proof of your"
	line "victory, here's"
	cont "the BOULDERBADGE!"
	done

ReceivedBoulderBadgeText:
	text "<PLAYER> received"
	line "the BOULDERBADGE!"
	done

BrockBoulderBadgeText:
	text "That's an official"
	line "#MON LEAGUE"
	cont "BADGE!"

	para "Its bearer's"
	line "#MON become"
	cont "more powerful!"

	para "The technique"
	line "FLASH can now be"
	cont "used anytime!"
	done

BrockTakeThisText:
	text "BROCK: Wait!"
	line "Take this with"
	cont "you!"
	done

BrockTMBideText:
	text "A TM contains a"
	line "technique that"
	cont "can be taught to"
	cont "#MON!"

	para "A TM is good only"
	line "once! So when you"
	cont "use one to teach"
	cont "a new technique,"
	cont "pick the #MON"
	cont "carefully!"

	para "That TM contains"
	line "BIDE!"

	para "Your #MON will"
	line "absorb damage in"
	cont "battle then pay"
	cont "it back double!"
	done

BrockTMNoRoomText:
	text "You don't have"
	line "room for this!"
	done

BrockFightDoneText:
	text "BROCK: There are"
	line "all kinds of"
	cont "trainers in the"
	cont "world!"

	para "Some raise #MON"
	line "for fights. Some"
	cont "see them as pets."

	para "I'm in training to"
	line "become a #MON"
	cont "breeder."

	para "If you take your"
	line "#MON training"
	cont "seriously, go"

	para "visit the GYM in"
	line "CERULEAN and test"
	cont "your abilities!"
	done

CamperJerrySeenText:
	text "Stop right there,"
	line "kid!"

	para "You're still light"
	line "years from facing"
	cont "BROCK!"
	done

CamperJerryBeatenText:
	text "Darn!"

	para "Light years isn't"
	line "time! It measures"
	cont "distance!"
	done

CamperJerryAfterBattleText:
	text "You're pretty hot,"
	line "but not as hot"
	cont "as BROCK!"
	done

PewterGymGuidePreAdviceText:
	text "Hiya! I can tell"
	line "you have what it"
	cont "takes to become a"
	cont "#MON champ!"

	para "I'm no trainer,"
	line "but I can tell"
	cont "you how to win!"

	para "Let me take you"
	line "to the top!"
	done

PewterGymGuideBeginAdviceText:
	text "All right! Let's"
	line "get happening!"
	done

PewterGymGuideFreeServiceText:
	text "It's a free"
	line "service! Let's"
	cont "get happening!"
	done

PewterGymGuideAdviceText:
	text "The 1st #MON"
	line "out in a match is"
	cont "at the top of the"
	cont "#MON LIST!"

	para "By changing the"
	line "order of #MON,"
	cont "matches could be"
	cont "made easier!"
	done

PewterGymGuidePikachuText:
	text "All right! Let's"
	line "get happening!"

	para "It will be tough"
	line "for your PIKACHU"
	cont "at this GYM!"

	para "Electric attacks"
	line "are harmless to"
	cont "BROCK's ground-"
	cont "type #MON."
	done

PewterGymGuideWinText:
	text "Just as I thought!"
	line "You're #MON"
	cont "champ material!"
	done

PewterGym_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 13, PEWTER_CITY, 2
	warp_event  5, 13, PEWTER_CITY, 2

	def_coord_events

	def_bg_events
	bg_event  2, 11, BGEVENT_READ, PewterGymStatue
	bg_event  7, 11, BGEVENT_READ, PewterGymStatue

	def_object_events
	object_event  5,  1, SPRITE_BROCK, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, PewterGymBrockScript, -1
	object_event  2,  5, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 3, TrainerCamperJerry, -1
	object_event  6, 11, SPRITE_GYM_GUIDE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 1, PewterGymGuideScript, -1
