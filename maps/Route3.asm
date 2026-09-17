	object_const_def
	const ROUTE3_SUPER_NERD
	const ROUTE3_BUG_CATCHER1
	const ROUTE3_YOUNGSTER1
	const ROUTE3_LASS1
	const ROUTE3_BUG_CATCHER2
	const ROUTE3_LASS2
	const ROUTE3_YOUNGSTER2
	const ROUTE3_BUG_CATCHER3
	const ROUTE3_LASS3

; Kanto hack: Yellow's Route 3 (docs/M2-MTMOON.md). The map was re-cut from
; Yellow in 5b (35x9, north to Route 4); 5c replaces Crystal's four trainers
; with Yellow's eight plus the resting SUPER_NERD and the MT.MOON sign.
; Coordinates, facings and sight ranges are Yellow's
; (vendor/pokeyellow/data/maps/objects/Route3.asm + scripts/Route3.asm's
; trainer headers); text is Yellow's, verbatim. Yellow draws its three
; OPP_BUG_CATCHERs with the youngster overworld sprite; we use
; SPRITE_BUG_CATCHER so the overworld sprite matches the battle class, as
; Viridian Forest does (docs/M2-FOREST.md). Yellow's anonymous trainers get
; GSC names: BUG_CATCHER 4/5/6 are COLTON/DION/BRETT, YOUNGSTER 1/2 reuse
; Crystal's dead WARREN/JIMMY slots, LASS 1/2/3 are JANICE/SALLY/ROBIN.
;
; One deliberate deviation: SALLY's sight range is 3, where Yellow gives LASS 2
; a range of 4. The upper path is exactly two tiles tall here (rows 4-5; row 6
; is the one-way ledge), and DION's body sits on (19,5). With range 4 SALLY
; spots the player on (19,4) and walks to (20,4), boxing the player in against
; DION with no way east - a soft lock. Range 3 makes her spot the player a tile
; later, so she stops on (21,4) and (20,5) stays open.
Route3_MapScripts:
	def_scene_scripts

	def_callbacks

TrainerBugCatcherColton:
	trainer BUG_CATCHER, COLTON, EVENT_BEAT_BUG_CATCHER_COLTON, BugCatcherColtonSeenText, BugCatcherColtonBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BugCatcherColtonAfterBattleText
	waitbutton
	closetext
	end

TrainerYoungsterWarren:
	trainer YOUNGSTER, WARREN, EVENT_BEAT_YOUNGSTER_WARREN, YoungsterWarrenSeenText, YoungsterWarrenBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext YoungsterWarrenAfterBattleText
	waitbutton
	closetext
	end

TrainerLassJanice:
	trainer LASS, JANICE, EVENT_BEAT_LASS_JANICE, LassJaniceSeenText, LassJaniceBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassJaniceAfterBattleText
	waitbutton
	closetext
	end

TrainerBugCatcherDion:
	trainer BUG_CATCHER, DION, EVENT_BEAT_BUG_CATCHER_DION, BugCatcherDionSeenText, BugCatcherDionBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BugCatcherDionAfterBattleText
	waitbutton
	closetext
	end

TrainerLassSally:
	trainer LASS, SALLY, EVENT_BEAT_LASS_SALLY, LassSallySeenText, LassSallyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassSallyAfterBattleText
	waitbutton
	closetext
	end

TrainerYoungsterJimmy:
	trainer YOUNGSTER, JIMMY, EVENT_BEAT_YOUNGSTER_JIMMY, YoungsterJimmySeenText, YoungsterJimmyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext YoungsterJimmyAfterBattleText
	waitbutton
	closetext
	end

TrainerBugCatcherBrett:
	trainer BUG_CATCHER, BRETT, EVENT_BEAT_BUG_CATCHER_BRETT, BugCatcherBrettSeenText, BugCatcherBrettBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BugCatcherBrettAfterBattleText
	waitbutton
	closetext
	end

TrainerLassRobin:
	trainer LASS, ROBIN, EVENT_BEAT_LASS_ROBIN, LassRobinSeenText, LassRobinBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassRobinAfterBattleText
	waitbutton
	closetext
	end

Route3SuperNerdScript:
	jumptextfaceplayer Route3SuperNerdText

Route3Sign:
	jumptext Route3SignText

Route3SuperNerdText:
	text "Whew… I better"
	line "take a rest…"
	cont "Groan…"

	para "That tunnel from"
	line "CERULEAN takes a"
	cont "lot out of you!"
	done

BugCatcherColtonSeenText:
	text "Hey! I met you in"
	line "VIRIDIAN FOREST!"
	done

BugCatcherColtonBeatenText:
	text "You"
	line "beat me again!"
	done

BugCatcherColtonAfterBattleText:
	text "There are other"
	line "kinds of #MON"
	cont "than those found"
	cont "in the forest!"
	done

YoungsterWarrenSeenText:
	text "Hi! I like shorts!"
	line "They're comfy and"
	cont "easy to wear!"
	done

YoungsterWarrenBeatenText:
	text "I don't"
	line "believe it!"
	done

YoungsterWarrenAfterBattleText:
	text "Are you storing"
	line "your #MON on"
	cont "PC? Each BOX can"
	cont "hold 20 #MON!"
	done

LassJaniceSeenText:
	text "You looked at me,"
	line "didn't you?"
	done

LassJaniceBeatenText:
	text "You're"
	line "mean!"
	done

LassJaniceAfterBattleText:
	text "Quit staring if"
	line "you don't want to"
	cont "fight!"
	done

BugCatcherDionSeenText:
	text "Are you a trainer?"
	line "Let's fight!"
	done

BugCatcherDionBeatenText:
	text "If I"
	line "had new #MON,"
	cont "I would've won!"
	done

BugCatcherDionAfterBattleText:
	text "If a #MON BOX"
	line "on the PC gets"
	cont "full, just switch"
	cont "to another BOX!"
	done

LassSallySeenText:
	text "That look you"
	line "gave me, it's so"
	cont "intriguing!"
	done

LassSallyBeatenText:
	text "Be nice!"
	done

LassSallyAfterBattleText:
	text "Avoid fights by"
	line "not letting"
	cont "people see you!"
	done

YoungsterJimmySeenText:
	text "Hey! You're not"
	line "wearing shorts!"
	done

YoungsterJimmyBeatenText:
	text "Lost!"
	line "Lost! Lost!"
	done

YoungsterJimmyAfterBattleText:
	text "I always wear"
	line "shorts, even in"
	cont "winter!"
	done

BugCatcherBrettSeenText:
	text "You can fight my"
	line "new #MON!"
	done

BugCatcherBrettBeatenText:
	text "Done"
	line "like dinner!"
	done

BugCatcherBrettAfterBattleText:
	text "Trained #MON"
	line "are stronger than"
	cont "the wild ones!"
	done

LassRobinSeenText:
	text "Eek! Did you"
	line "touch me?"
	done

LassRobinBeatenText:
	text "That's it?"
	done

LassRobinAfterBattleText:
	text "ROUTE 4 is at the"
	line "foot of MT.MOON."
	done

Route3SignText:
	text "ROUTE 3"
	line "MT.MOON AHEAD"
	done

Route3_MapEvents:
	db 0, 0 ; filler

	def_warp_events

	def_coord_events

	def_bg_events
	bg_event 59,  9, BGEVENT_READ, Route3Sign

	def_object_events
	object_event 57, 11, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route3SuperNerdScript, -1
	object_event 10,  6, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 2, TrainerBugCatcherColton, -1
	object_event 14,  4, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerYoungsterWarren, -1
	object_event 16,  9, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerLassJanice, -1
	object_event 19,  5, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 1, TrainerBugCatcherDion, -1
	object_event 23,  4, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerLassSally, -1 ; sight 3, not Yellow's 4: see the header
	object_event 22,  9, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerYoungsterJimmy, -1
	object_event 24,  6, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerBugCatcherBrett, -1
	object_event 33, 10, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerLassRobin, -1
