	object_const_def
	const ROUTE9_PICNICKER1
	const ROUTE9_YOUNGSTER
	const ROUTE9_CAMPER
	const ROUTE9_PICNICKER2
	const ROUTE9_HIKER1
	const ROUTE9_HIKER2
	const ROUTE9_BUG_CATCHER1
	const ROUTE9_HIKER3
	const ROUTE9_BUG_CATCHER2
	const ROUTE9_TM_TELEPORT

Route9_MapScripts:
	def_scene_scripts

	def_callbacks

TrainerPicnickerHeidi:
	trainer PICNICKER, HEIDI, EVENT_BEAT_PICNICKER_HEIDI, PicnickerHeidiSeenText, PicnickerHeidiBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PicnickerHeidiAfterBattleText
	waitbutton
	closetext
	end

TrainerYoungsterAJ:
	trainer YOUNGSTER, AJ, EVENT_BEAT_YOUNGSTER_AJ, YoungsterAJSeenText, YoungsterAJBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext YoungsterAJAfterBattleText
	waitbutton
	closetext
	end

TrainerCamperDean:
	trainer CAMPER, DEAN, EVENT_BEAT_CAMPER_DEAN, CamperDeanSeenText, CamperDeanBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext CamperDeanAfterBattleText
	waitbutton
	closetext
	end

TrainerPicnickerEdna:
	trainer PICNICKER, EDNA, EVENT_BEAT_PICNICKER_EDNA, PicnickerEdnaSeenText, PicnickerEdnaBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PicnickerEdnaAfterBattleText
	waitbutton
	closetext
	end

TrainerHikerTim:
	trainer HIKER, TIM, EVENT_BEAT_HIKER_TIM, HikerTimSeenText, HikerTimBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext HikerTimAfterBattleText
	waitbutton
	closetext
	end

TrainerHikerSidney:
	trainer HIKER, SIDNEY, EVENT_BEAT_HIKER_SIDNEY, HikerSidneySeenText, HikerSidneyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext HikerSidneyAfterBattleText
	waitbutton
	closetext
	end

TrainerBugCatcherEllis:
	trainer BUG_CATCHER, ELLIS, EVENT_BEAT_BUG_CATCHER_ELLIS, BugCatcherEllisSeenText, BugCatcherEllisBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BugCatcherEllisAfterBattleText
	waitbutton
	closetext
	end

TrainerHikerLamont:
	trainer HIKER, LAMONT, EVENT_BEAT_HIKER_LAMONT, HikerLamontSeenText, HikerLamontBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext HikerLamontAfterBattleText
	waitbutton
	closetext
	end

TrainerBugCatcherMerv:
	trainer BUG_CATCHER, MERV, EVENT_BEAT_BUG_CATCHER_MERV, BugCatcherMervSeenText, BugCatcherMervBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BugCatcherMervAfterBattleText
	waitbutton
	closetext
	end

Route9TMTeleport:
	itemball TM_TELEPORT

Route9Sign:
	jumptext Route9SignText

Route9HiddenEther:
	hiddenitem ETHER, EVENT_ROUTE_9_HIDDEN_ETHER

PicnickerHeidiSeenText:
	text "You have #MON"
	line "with you!"
	cont "You're mine!"
	done

PicnickerHeidiBeatenText:
	text "You"
	line "deceived me!"
	done

PicnickerHeidiAfterBattleText:
	text "You need light to"
	line "get through that"
	cont "dark tunnel ahead."
	done

YoungsterAJSeenText:
	text "I aim to be the"
	line "ultimate trainer!"
	done

YoungsterAJBeatenText:
	text "My"
	line "SANDSHREW lost?"
	done

YoungsterAJAfterBattleText:
	text "I'll restart my"
	line "100-win streak"
	cont "with SANDSHREW."
	done

CamperDeanSeenText:
	text "I'm taking ROCK"
	line "TUNNEL to go to"
	cont "LAVENDER…"
	done

CamperDeanBeatenText:
	text "Can't"
	line "measure up!"
	done

CamperDeanAfterBattleText:
	text "Are you off to"
	line "ROCK TUNNEL too?"
	done

PicnickerEdnaSeenText:
	text "Don't you dare"
	line "condescend me!"
	done

PicnickerEdnaBeatenText:
	text "No!"
	line "You're too much!"
	done

PicnickerEdnaAfterBattleText:
	text "You're obviously"
	line "talented! Good"
	cont "luck to you!"
	done

HikerTimSeenText:
	text "Bwahaha!"
	line "Great! I was"
	cont "bored, eh!"
	done

HikerTimBeatenText:
	text "Keep it"
	line "coming, eh!"

	para "Oh wait. I'm out"
	line "of #MON!"
	done

HikerTimAfterBattleText:
	text "You sure had guts"
	line "standing up to me"
	cont "there, eh?"
	done

HikerSidneySeenText:
	text "Hahaha!"
	line "Aren't you a"
	cont "little toughie!"
	done

HikerSidneyBeatenText:
	text "What's"
	line "that?"
	done

HikerSidneyAfterBattleText:
	text "Hahaha! Kids"
	line "should be tough!"
	done

BugCatcherEllisSeenText:
	text "I got up early"
	line "every day to"
	cont "raise my #MON"
	cont "from cocoons!"
	done

BugCatcherEllisBeatenText:
	text "WHAT?"

	para "What a total"
	line "waste of time!"
	done

BugCatcherEllisAfterBattleText:
	text "I have to collect"
	line "more than bugs to"
	cont "get stronger…"
	done

HikerLamontSeenText:
	text "Hahahaha!"
	line "Come on, dude!"
	done

HikerLamontBeatenText:
	text "Hahahaha!"
	line "You beat me fair!"
	done

HikerLamontAfterBattleText:
	text "Hahahaha!"
	line "Us hearty guys"
	cont "always laugh!"
	done

BugCatcherMervSeenText:
	text "Go, my super bug"
	line "#MON!"
	done

BugCatcherMervBeatenText:
	text "My"
	line "bugs…"
	done

BugCatcherMervAfterBattleText:
	text "If you don't like"
	line "bug #MON, you"
	cont "bug me!"
	done

Route9SignText:
	text "ROUTE 9"
	line "CERULEAN CITY-"
	cont "ROCK TUNNEL"
	done

Route9_MapEvents:
	db 0, 0 ; filler

	def_warp_events

	def_coord_events

	def_bg_events
	bg_event 25,  7, BGEVENT_READ, Route9Sign
	bg_event 14,  7, BGEVENT_ITEM, Route9HiddenEther

	def_object_events
	object_event 13, 10, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerPicnickerHeidi, -1
	object_event 24,  7, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, TrainerYoungsterAJ, -1
	object_event 31,  7, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 4, TrainerCamperDean, -1
	object_event 48,  8, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerPicnickerEdna, -1
	object_event 16, 15, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 2, TrainerHikerTim, -1
	object_event 43,  3, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerHikerSidney, -1
	object_event 22,  2, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerBugCatcherEllis, -1
	object_event 45, 15, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 2, TrainerHikerLamont, -1
	object_event 40,  8, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 2, TrainerBugCatcherMerv, -1
	object_event 10, 15, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route9TMTeleport, EVENT_ROUTE_9_TM_TELEPORT
