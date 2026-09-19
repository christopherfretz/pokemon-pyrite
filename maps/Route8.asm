	object_const_def
	const ROUTE8_SUPER_NERD1
	const ROUTE8_GENTLEMAN1
	const ROUTE8_SUPER_NERD2
	const ROUTE8_LASS1
	const ROUTE8_SUPER_NERD3
	const ROUTE8_LASS2
	const ROUTE8_LASS3
	const ROUTE8_GENTLEMAN2
	const ROUTE8_LASS4

Route8_MapScripts:
	def_scene_scripts

	def_callbacks

; Kanto hack (M5 8j): ROUTE 8 is Yellow's, trainer for trainer.  The nine are
; Yellow's SUPER_NERD 3/4/5, GAMBLER 5/7 and LASS 13/14/15/16, in Yellow's
; object order, at Yellow's coordinates, facings and sight ranges (4, 4, 4, 2,
; 3, 3, 2, 2, 4 -- vendor/pokeyellow/scripts/Route8.asm's trainer headers).
; GAMBLER has no GSC counterpart, so it becomes GENTLEMAN, the substitution
; ROUTE 11 (M4 7l, "ARTHUR") established.

TrainerSupernerdSam:
	trainer SUPER_NERD, SAM, EVENT_BEAT_SUPER_NERD_SAM, SupernerdSamSeenText, SupernerdSamBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SupernerdSamAfterBattleText
	waitbutton
	closetext
	end

TrainerGentlemanElton:
	trainer GENTLEMAN, ELTON, EVENT_BEAT_GENTLEMAN_ELTON, GentlemanEltonSeenText, GentlemanEltonBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext GentlemanEltonAfterBattleText
	waitbutton
	closetext
	end

TrainerSupernerdTom:
	trainer SUPER_NERD, TOM, EVENT_BEAT_SUPER_NERD_TOM, SupernerdTomSeenText, SupernerdTomBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SupernerdTomAfterBattleText
	waitbutton
	closetext
	end

TrainerLassEsther:
	trainer LASS, ESTHER, EVENT_BEAT_LASS_ESTHER, LassEstherSeenText, LassEstherBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassEstherAfterBattleText
	waitbutton
	closetext
	end

TrainerSupernerdClark:
	trainer SUPER_NERD, CLARK, EVENT_BEAT_SUPER_NERD_CLARK, SupernerdClarkSeenText, SupernerdClarkBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SupernerdClarkAfterBattleText
	waitbutton
	closetext
	end

TrainerLassFlora:
	trainer LASS, FLORA, EVENT_BEAT_LASS_FLORA, LassFloraSeenText, LassFloraBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassFloraAfterBattleText
	waitbutton
	closetext
	end

TrainerLassWinnie:
	trainer LASS, WINNIE, EVENT_BEAT_LASS_WINNIE, LassWinnieSeenText, LassWinnieBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassWinnieAfterBattleText
	waitbutton
	closetext
	end

TrainerGentlemanReuben:
	trainer GENTLEMAN, REUBEN, EVENT_BEAT_GENTLEMAN_REUBEN, GentlemanReubenSeenText, GentlemanReubenBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext GentlemanReubenAfterBattleText
	waitbutton
	closetext
	end

TrainerLassTilda:
	trainer LASS, TILDA, EVENT_BEAT_LASS_TILDA, LassTildaSeenText, LassTildaBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassTildaAfterBattleText
	waitbutton
	closetext
	end

Route8UndergroundPathSign:
	jumptext Route8UndergroundPathSignText

; Yellow's _Route8SuperNerd1*Text
SupernerdSamSeenText:
	text "You look good at"
	line "#MON, but"
	cont "how's your chem?"
	done

SupernerdSamBeatenText:
	text "Ow!"
	line "Meltdown!"
	done

SupernerdSamAfterBattleText:
	text "I am better at"
	line "school than this!"
	done

; Yellow's _Route8Gambler1*Text
GentlemanEltonSeenText:
	text "All right! Let's"
	line "roll the dice!"
	done

GentlemanEltonBeatenText:
	text "Drat!"
	line "Came up short!"
	done

GentlemanEltonAfterBattleText:
	text "Lady Luck's not"
	line "with me today!"
	done

; Yellow's _Route8SuperNerd2*Text
SupernerdTomSeenText:
	text "You need strategy"
	line "to win at this!"
	done

SupernerdTomBeatenText:
	text "It's"
	line "not logical!"
	done

SupernerdTomAfterBattleText:
	text "Go with GRIMER"
	line "first…and…"
	cont "…and…then…"
	done

; Yellow's _Route8CooltrainerF1*Text
LassEstherSeenText:
	text "I like NIDORAN, so"
	line "I collect them!"
	done

LassEstherBeatenText:
	text "Why? Why??"
	done

LassEstherAfterBattleText:
	text "When #MON grow"
	line "up they get ugly!"
	cont "They shouldn't"
	cont "evolve!"
	done

; Yellow's _Route8SuperNerd3*Text
SupernerdClarkSeenText:
	text "School is fun, but"
	line "so are #MON."
	done

SupernerdClarkBeatenText:
	text "I'll"
	line "stay with school."
	done

SupernerdClarkAfterBattleText:
	text "We're stuck here"
	line "because of the"
	cont "gates at SAFFRON."
	done

; Yellow's _Route8CooltrainerF2*Text
LassFloraSeenText:
	text "MEOWTH is so cute,"
	line "meow, meow, meow!"
	done

LassFloraBeatenText:
	text "Meow!"
	done

LassFloraAfterBattleText:
	text "I think PIDGEY"
	line "and RATTATA"
	cont "are cute too!"
	done

; Yellow's _Route8CooltrainerF3*Text
LassWinnieSeenText:
	text "We must look"
	line "silly standing"
	cont "here like this!"
	done

LassWinnieBeatenText:
	text "Look what"
	line "you did!"
	done

LassWinnieAfterBattleText:
	text "SAFFRON's gate-"
	line "keeper won't let"
	cont "us through."
	cont "He's so mean!"
	done

; Yellow's _Route8Gambler2*Text
GentlemanReubenSeenText:
	text "I'm a rambling,"
	line "gambling dude!"
	done

GentlemanReubenBeatenText:
	text "Missed"
	line "the big score!"
	done

GentlemanReubenAfterBattleText:
	text "Gambling and"
	line "#MON are like"
	cont "eating peanuts!"
	cont "Just can't stop!"
	done

; Yellow's _Route8CooltrainerF4*Text
LassTildaSeenText:
	text "What's a cute,"
	line "round and fluffy"
	cont "#MON?"
	done

LassTildaBeatenText:
	text "Stop!"

	para "Don't be so mean"
	line "to my CLEFAIRY!"
	done

LassTildaAfterBattleText:
	text "I heard that"
	line "CLEFAIRY evolves"
	cont "when it's exposed"
	cont "to a MOON STONE."
	done

; Yellow's _Route8UndergroundSignText
Route8UndergroundPathSignText:
	text "UNDERGROUND PATH"
	line "CELADON CITY -"
	cont "LAVENDER TOWN"
	done

Route8_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; Yellow's ROUTE 8 gate has BOTH its doors on ROUTE 8 -- SAFFRON is reached by
; walking off the route's west map edge (Yellow's `connection west, SaffronCity`),
; never through a warp.  So warps 1/2 are the hut's west door into the little
; pocket at (0..1, 8..10), which is reachable ONLY through the hut, and nothing
; here needs re-pointing at the SAFFRON milestone.
	warp_event  1,  9, ROUTE_8_SAFFRON_GATE, 1
	warp_event  1, 10, ROUTE_8_SAFFRON_GATE, 1
	warp_event  8,  9, ROUTE_8_SAFFRON_GATE, 3
	warp_event  8, 10, ROUTE_8_SAFFRON_GATE, 3
	warp_event 13,  3, ROUTE_8_UNDERGROUND_PATH_ENTRANCE, 1

	def_coord_events

	def_bg_events
	bg_event 17,  3, BGEVENT_READ, Route8UndergroundPathSign

	def_object_events
	object_event  8,  5, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerSupernerdSam, -1
	object_event 13,  9, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerGentlemanElton, -1
	object_event 42,  6, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerSupernerdTom, -1
	object_event 26,  3, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerLassEsther, -1
	object_event 26,  4, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerSupernerdClark, -1
	object_event 26,  5, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerLassFlora, -1
	object_event 26,  6, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerLassWinnie, -1
	object_event 46, 13, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerGentlemanReuben, -1
	object_event 51, 12, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerLassTilda, -1
