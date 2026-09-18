; Kanto hack: Yellow's ROUTE_6 (docs/M4-VERMILION.md, 7d).
; Yellow's six trainers, in Yellow's object order, at Yellow's coordinates and
; facings, with Yellow's sight ranges from Route6TrainerHeaders (0/0/4/3/3/3)
; and Yellow's before/win/after text.  Class substitutions are docs
; M4-VERMILION.md 5.4: JR_TRAINER_M -> CAMPER, JR_TRAINER_F -> PICNICKER,
; BUG_CATCHER unchanged.  Overworld sprites follow the M2/M3 precedent
; (Yellow SPRITE_YOUNGSTER on a BUG_CATCHER becomes SPRITE_BUG_CATCHER, as on
; Route 3 / Route 24 / Viridian Forest).
;   Yellow (10,21) JR_TRAINER_M 10 -> TrainerCamperNolan
;   Yellow (11,21) JR_TRAINER_F 25 -> TrainerPicnickerMarcy
;   Yellow ( 0,15) BUG_CATCHER 10  -> TrainerBugCatcherLogan
;   Yellow (11,31) JR_TRAINER_M 5  -> TrainerCamperOliver
;   Yellow (11,30) JR_TRAINER_F 3  -> TrainerPicnickerGreta
;   Yellow (19,26) BUG_CATCHER 11  -> TrainerBugCatcherFelix
; Deleted: Crystal's POKEFAN_M Underground Path blocker at (17,14) and the two
; POKEFANM trainers REX and ALLAN, which stood on Yellow's trainer-0/1 tiles.
	object_const_def
	const ROUTE6_COOLTRAINER_M1
	const ROUTE6_COOLTRAINER_F1
	const ROUTE6_BUG_CATCHER1
	const ROUTE6_COOLTRAINER_M2
	const ROUTE6_COOLTRAINER_F2
	const ROUTE6_BUG_CATCHER2

Route6_MapScripts:
	def_scene_scripts

	def_callbacks

TrainerCamperNolan:
	trainer CAMPER, NOLAN, EVENT_BEAT_CAMPER_NOLAN, CamperNolanSeenText, CamperNolanBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext CamperNolanAfterBattleText
	waitbutton
	closetext
	end

TrainerPicnickerMarcy:
	trainer PICNICKER, MARCY, EVENT_BEAT_PICNICKER_MARCY, PicnickerMarcySeenText, PicnickerMarcyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PicnickerMarcyAfterBattleText
	waitbutton
	closetext
	end

TrainerBugCatcherLogan:
	trainer BUG_CATCHER, LOGAN, EVENT_BEAT_BUG_CATCHER_LOGAN, BugCatcherLoganSeenText, BugCatcherLoganBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BugCatcherLoganAfterBattleText
	waitbutton
	closetext
	end

TrainerCamperOliver:
	trainer CAMPER, OLIVER, EVENT_BEAT_CAMPER_OLIVER, CamperOliverSeenText, CamperOliverBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext CamperOliverAfterBattleText
	waitbutton
	closetext
	end

TrainerPicnickerGreta:
	trainer PICNICKER, GRETA, EVENT_BEAT_PICNICKER_GRETA, PicnickerGretaSeenText, PicnickerGretaBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PicnickerGretaAfterBattleText
	waitbutton
	closetext
	end

TrainerBugCatcherFelix:
	trainer BUG_CATCHER, FELIX, EVENT_BEAT_BUG_CATCHER_FELIX, BugCatcherFelixSeenText, BugCatcherFelixBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BugCatcherFelixAfterBattleText
	waitbutton
	closetext
	end

Route6UndergroundPathSign:
	jumptext Route6UndergroundPathSignText

Route6UndergroundPathSignText:
	text "UNDERGROUND PATH"
	line "CERULEAN CITY -"
	cont "VERMILION CITY"
	done

CamperNolanSeenText:
	text "I'm doing this"
	line "out of love."
	cont "Leave me alone!"
	done

CamperNolanBeatenText:
	text "No,"
	line "this can't be…"
	done

CamperNolanAfterBattleText:
	text "My love will leave"
	line "me in disgust."
	done

PicnickerMarcySeenText:
	text "I'm training for"
	line "my love. Don't"
	cont "bother me!"
	done

PicnickerMarcyBeatenText:
	text "My"
	line "textbook never…"
	done

PicnickerMarcyAfterBattleText:
	text "Now I understand,"
	line "#MON isn't"
	cont "about calculated"
	cont "numbers."
	done

BugCatcherLoganSeenText:
	text "There aren't many"
	line "bugs out here."
	done

BugCatcherLoganBeatenText:
	text "No!"
	line "You're kidding!"
	done

BugCatcherLoganAfterBattleText:
	text "I like bugs, so"
	line "I'm going back to"
	cont "VIRIDIAN FOREST."
	done

CamperOliverSeenText:
	text "Huh? You want"
	line "to talk to me?"
	done

CamperOliverBeatenText:
	text "I"
	line "didn't start it!"
	done

CamperOliverAfterBattleText:
	text "I should carry"
	line "more #MON with"
	cont "me for safety."
	done

PicnickerGretaSeenText:
	text "Me? Well, OK."
	line "I'll play!"
	done

PicnickerGretaBeatenText:
	text "Just"
	line "didn't work!"
	done

PicnickerGretaAfterBattleText:
	text "I want to get"
	line "stronger! What's"
	cont "your secret?"
	done

BugCatcherFelixSeenText:
	text "I've never seen"
	line "you around!"
	cont "Are you good?"
	done

BugCatcherFelixBeatenText:
	text "You"
	line "are too good!"
	done

BugCatcherFelixAfterBattleText:
	text "Are my #MON"
	line "weak? Or, am I"
	cont "just bad?"
	done

Route6_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  9,  1, ROUTE_6_SAFFRON_GATE, 1
	warp_event 10,  1, ROUTE_6_SAFFRON_GATE, 1
	warp_event 10,  7, ROUTE_6_SAFFRON_GATE, 3
	warp_event 17, 13, ROUTE_6_UNDERGROUND_PATH_ENTRANCE, 1

	def_coord_events

	def_bg_events
	bg_event 19, 15, BGEVENT_READ, Route6UndergroundPathSign

	def_object_events
	object_event 10, 21, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 0, TrainerCamperNolan, -1
	object_event 11, 21, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 0, TrainerPicnickerMarcy, -1
	object_event  0, 15, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerBugCatcherLogan, -1
	object_event 11, 31, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 3, TrainerCamperOliver, -1
	object_event 11, 30, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerPicnickerGreta, -1
	object_event 19, 26, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerBugCatcherFelix, -1
