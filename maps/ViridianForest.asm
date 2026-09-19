	object_const_def
	const VIRIDIANFOREST_YOUNGSTER1
	const VIRIDIANFOREST_BUG_CATCHER1
	const VIRIDIANFOREST_BUG_CATCHER2
	const VIRIDIANFOREST_BUG_CATCHER3
	const VIRIDIANFOREST_LASS
	const VIRIDIANFOREST_BUG_CATCHER4
	const VIRIDIANFOREST_POKE_BALL1
	const VIRIDIANFOREST_POKE_BALL2
	const VIRIDIANFOREST_POKE_BALL3
	const VIRIDIANFOREST_YOUNGSTER2

; Kanto hack: Yellow's Viridian Forest, which Crystal does not have at all
; (docs/M2-FOREST.md). The map, its objects, signs and hidden items are ported
; 1:1 from vendor/pokeyellow (Gen 1 object coordinates are already in GSC tile
; units). Yellow's five anonymous trainers get GSC names: BUG_CATCHER 1/2/3/15
; are SAMMY/ELIJAH/ANTHONY/WESLEY and LASS 19 is SARAH; their parties and sight
; ranges are Yellow's. Yellow's two tip YOUNGSTERs keep SPRITE_YOUNGSTER.
ViridianForest_MapScripts:
	def_scene_scripts

	def_callbacks

TrainerBugCatcherSammy:
	trainer BUG_CATCHER, SAMMY, EVENT_BEAT_BUG_CATCHER_SAMMY, BugCatcherSammySeenText, BugCatcherSammyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BugCatcherSammyAfterBattleText
	waitbutton
	closetext
	end

TrainerBugCatcherElijah:
	trainer BUG_CATCHER, ELIJAH, EVENT_BEAT_BUG_CATCHER_ELIJAH, BugCatcherElijahSeenText, BugCatcherElijahBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BugCatcherElijahAfterBattleText
	waitbutton
	closetext
	end

TrainerBugCatcherAnthony:
	trainer BUG_CATCHER, ANTHONY, EVENT_BEAT_BUG_CATCHER_ANTHONY, BugCatcherAnthonySeenText, BugCatcherAnthonyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BugCatcherAnthonyAfterBattleText
	waitbutton
	closetext
	end

TrainerLassSarah:
	trainer LASS, SARAH, EVENT_BEAT_LASS_SARAH, LassSarahSeenText, LassSarahBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassSarahAfterBattleText
	waitbutton
	closetext
	end

TrainerBugCatcherWesley:
	trainer BUG_CATCHER, WESLEY, EVENT_BEAT_BUG_CATCHER_WESLEY, BugCatcherWesleySeenText, BugCatcherWesleyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BugCatcherWesleyAfterBattleText
	waitbutton
	closetext
	end

ViridianForestYoungster1Script:
	jumptextfaceplayer ViridianForestYoungster1Text

ViridianForestYoungster2Script:
	jumptextfaceplayer ViridianForestYoungster2Text

ViridianForestPotion1:
	itemball POTION

ViridianForestPotion2:
	itemball POTION

ViridianForestPokeBall:
	itemball POKE_BALL

ViridianForestHiddenPotion:
	hiddenitem POTION, EVENT_VIRIDIAN_FOREST_HIDDEN_POTION

ViridianForestHiddenAntidote:
	hiddenitem ANTIDOTE, EVENT_VIRIDIAN_FOREST_HIDDEN_ANTIDOTE

ViridianForestTrainerTips1Sign:
	jumptext ViridianForestTrainerTips1Text

ViridianForestTrainerTips2Sign:
	jumptext ViridianForestTrainerTips2Text

ViridianForestTrainerTips3Sign:
	jumptext ViridianForestTrainerTips3Text

ViridianForestTrainerTips4Sign:
	jumptext ViridianForestTrainerTips4Text

ViridianForestUseAntidoteSign:
	jumptext ViridianForestUseAntidoteSignText

ViridianForestLeavingSign:
	jumptext ViridianForestLeavingSignText

ViridianForestYoungster1Text:
	text "I came here with"
	line "some friends!"

	para "They're out for"
	line "#MON fights!"
	done

BugCatcherSammySeenText:
	text "Hey! You have"
	line "#MON! Come on!"
	cont "Let's battle 'em!"
	done

BugCatcherSammyBeatenText:
	text "No!"
	line "CATERPIE can't"
	cont "cut it!"
	done

BugCatcherSammyAfterBattleText:
	text "Ssh! You'll scare"
	line "the bugs away!"
	done

BugCatcherElijahSeenText:
	text "Yo! You can't jam"
	line "out if you're a"
	cont "#MON trainer!"
	done

BugCatcherElijahBeatenText:
	text "Huh?"
	line "I ran out of"
	cont "#MON!"
	done

BugCatcherElijahAfterBattleText:
	text "Darn! I'm going"
	line "to catch some"
	cont "stronger ones!"
	done

BugCatcherAnthonySeenText:
	text "Hey, wait up!"
	line "What's the hurry?"
	done

BugCatcherAnthonyBeatenText:
	text "I"
	line "give! You're good"
	cont "at this!"
	done

BugCatcherAnthonyAfterBattleText:
	text "Sometimes, you"
	line "can find stuff on"
	cont "the ground!"

	para "I'm looking for"
	line "the stuff I"
	cont "dropped!"
	done

LassSarahSeenText:
	text "Hi, do you have a"
	line "PIKACHU?"
	done

LassSarahBeatenText:
	text "Oh no,"
	line "really?"
	done

LassSarahAfterBattleText:
	text "I looked forever,"
	line "but I never found"
	cont "a PIKACHU here!"
	done

BugCatcherWesleySeenText:
	text "I'm gonna be the"
	line "best. You just"
	cont "can't beat me!"
	done

BugCatcherWesleyBeatenText:
	text "After"
	line "all I did…"
	done

BugCatcherWesleyAfterBattleText:
	text "A METAPOD is cool"
	line "because its"
	cont "attack is its"
	cont "defense!"
	done

ViridianForestYoungster2Text:
	text "I ran out of #"
	line "BALLs to catch"
	cont "#MON with!"

	para "You should carry"
	line "extras!"
	done

ViridianForestTrainerTips1Text:
	text "TRAINER TIPS"

	para "If you want to"
	line "avoid battles,"
	cont "stay away from"
	cont "grassy areas!"
	done

ViridianForestUseAntidoteSignText:
	text "For poison, use"
	line "ANTIDOTE! Get it"
	cont "at #MON MARTs!"
	done

ViridianForestTrainerTips2Text:
	text "TRAINER TIPS"

	para "Contact PROF.OAK"
	line "via PC to get"
	cont "your #DEX"
	cont "evaluated!"
	done

ViridianForestTrainerTips3Text:
	text "TRAINER TIPS"

	para "No stealing of"
	line "#MON from"
	cont "other trainers!"
	cont "Catch only wild"
	cont "#MON!"
	done

ViridianForestTrainerTips4Text:
	text "TRAINER TIPS"

	para "Weaken #MON"
	line "before attempting"
	cont "capture!"

	para "When healthy,"
	line "they may escape!"
	done

ViridianForestLeavingSignText:
	text "LEAVING"
	line "VIRIDIAN FOREST"
	cont "PEWTER CITY AHEAD"
	done

ViridianForest_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  1,  0, VIRIDIAN_FOREST_NORTH_GATE, 3
	warp_event  2,  0, VIRIDIAN_FOREST_NORTH_GATE, 4
	warp_event 16, 47, VIRIDIAN_FOREST_SOUTH_GATE, 2 ; M1: Yellow's gate has only ONE north door tile (the west half is wall); warp 1 is Yellow's dead duplicate
	warp_event 17, 47, VIRIDIAN_FOREST_SOUTH_GATE, 2

	def_coord_events

	def_bg_events
	bg_event 24, 40, BGEVENT_READ, ViridianForestTrainerTips1Sign
	bg_event 16, 32, BGEVENT_READ, ViridianForestUseAntidoteSign
	bg_event 26, 17, BGEVENT_READ, ViridianForestTrainerTips2Sign
	bg_event  4, 24, BGEVENT_READ, ViridianForestTrainerTips3Sign
	bg_event 18, 45, BGEVENT_READ, ViridianForestTrainerTips4Sign
	bg_event  2,  1, BGEVENT_READ, ViridianForestLeavingSign
	bg_event  1, 18, BGEVENT_ITEM, ViridianForestHiddenPotion
	bg_event 16, 42, BGEVENT_ITEM, ViridianForestHiddenAntidote

	def_object_events
	object_event 16, 43, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ViridianForestYoungster1Script, -1
	object_event 30, 33, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerBugCatcherSammy, -1
	object_event 30, 19, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerBugCatcherElijah, -1
	object_event  2, 18, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 1, TrainerBugCatcherAnthony, -1
	object_event  2, 41, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 0, TrainerLassSarah, -1
	object_event 13, 17, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerBugCatcherWesley, -1
	object_event 25, 11, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, ViridianForestPotion1, EVENT_VIRIDIAN_FOREST_POTION_1
	object_event 12, 29, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, ViridianForestPotion2, EVENT_VIRIDIAN_FOREST_POTION_2
	object_event  1, 31, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, ViridianForestPokeBall, EVENT_VIRIDIAN_FOREST_POKE_BALL
	object_event 27, 40, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ViridianForestYoungster2Script, -1
