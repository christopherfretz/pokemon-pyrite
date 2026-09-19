; Kanto hack: Yellow's ROUTE_11 (docs/M4-VERMILION.md, 7l).
; Yellow's ten trainers, in Yellow's object order, at Yellow's coordinates and
; facings, with Yellow's sight ranges from Route11TrainerHeaders
; (3/2/3/3/4/3/3/4/3/4) and Yellow's before/win/after text.  Class
; substitutions are docs/M4-VERMILION.md 5.4: GAMBLER -> GENTLEMAN,
; ENGINEER -> SCIENTIST, YOUNGSTER unchanged.  Overworld sprites are Yellow's
; own (SPRITE_GAMBLER has no GSC equivalent, so the GENTLEMAN sprite stands in;
; Yellow already draws its ENGINEERs with SPRITE_SUPER_NERD).
;   Yellow (10,14) GAMBLER 1    -> TrainerGentlemanArthur
;   Yellow (26, 9) GAMBLER 2    -> TrainerGentlemanLeopold
;   Yellow (13, 5) YOUNGSTER 9  -> TrainerYoungsterFloyd
;   Yellow (36,11) ENGINEER 2   -> TrainerScientistMaxwell
;   Yellow (22, 4) YOUNGSTER 10 -> TrainerYoungsterRudy
;   Yellow (45, 7) GAMBLER 3    -> TrainerGentlemanWinston
;   Yellow (33, 3) GAMBLER 4    -> TrainerGentlemanHorace
;   Yellow (43, 5) YOUNGSTER 11 -> TrainerYoungsterGordy
;   Yellow (45,16) ENGINEER 3   -> TrainerScientistThurston
;   Yellow (22,12) YOUNGSTER 12 -> TrainerYoungsterCliff
; Deleted: Crystal's YOUNGSTER OWEN/JASON and PSYCHIC_T HERMAN/FIDEL (their
; party entries are reused/reclaimed, docs/M4-VERMILION.md 5.3).
; Kept (Crystal-only, operator ruling): the FRUITTREE_ROUTE_11 at (30,2) and
; the hidden REVIVE at (32,5) -- both still land on sensible tiles after 7b's
; re-cut and neither collides with a Yellow object.
; Yellow's one bg_event is the DIGLETT's CAVE sign at (1,5).
	object_const_def
	const ROUTE11_GENTLEMAN1
	const ROUTE11_GENTLEMAN2
	const ROUTE11_YOUNGSTER1
	const ROUTE11_SUPER_NERD1
	const ROUTE11_YOUNGSTER2
	const ROUTE11_GENTLEMAN3
	const ROUTE11_GENTLEMAN4
	const ROUTE11_YOUNGSTER3
	const ROUTE11_SUPER_NERD2
	const ROUTE11_YOUNGSTER4
	const ROUTE11_FRUIT_TREE

Route11_MapScripts:
	def_scene_scripts

	def_callbacks

TrainerGentlemanArthur:
	trainer GENTLEMAN, ARTHUR, EVENT_BEAT_GENTLEMAN_ARTHUR, GentlemanArthurSeenText, GentlemanArthurBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext GentlemanArthurAfterBattleText
	waitbutton
	closetext
	end

TrainerGentlemanLeopold:
	trainer GENTLEMAN, LEOPOLD, EVENT_BEAT_GENTLEMAN_LEOPOLD, GentlemanLeopoldSeenText, GentlemanLeopoldBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext GentlemanLeopoldAfterBattleText
	waitbutton
	closetext
	end

TrainerYoungsterFloyd:
	trainer YOUNGSTER, FLOYD, EVENT_BEAT_YOUNGSTER_FLOYD, YoungsterFloydSeenText, YoungsterFloydBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext YoungsterFloydAfterBattleText
	waitbutton
	closetext
	end

TrainerScientistMaxwell:
	trainer SCIENTIST, MAXWELL, EVENT_BEAT_SCIENTIST_MAXWELL, ScientistMaxwellSeenText, ScientistMaxwellBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext ScientistMaxwellAfterBattleText
	waitbutton
	closetext
	end

TrainerYoungsterRudy:
	trainer YOUNGSTER, RUDY, EVENT_BEAT_YOUNGSTER_RUDY, YoungsterRudySeenText, YoungsterRudyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext YoungsterRudyAfterBattleText
	waitbutton
	closetext
	end

TrainerGentlemanWinston:
	trainer GENTLEMAN, WINSTON, EVENT_BEAT_GENTLEMAN_WINSTON, GentlemanWinstonSeenText, GentlemanWinstonBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext GentlemanWinstonAfterBattleText
	waitbutton
	closetext
	end

TrainerGentlemanHorace:
	trainer GENTLEMAN, HORACE, EVENT_BEAT_GENTLEMAN_HORACE, GentlemanHoraceSeenText, GentlemanHoraceBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext GentlemanHoraceAfterBattleText
	waitbutton
	closetext
	end

TrainerYoungsterGordy:
	trainer YOUNGSTER, GORDY, EVENT_BEAT_YOUNGSTER_GORDY, YoungsterGordySeenText, YoungsterGordyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext YoungsterGordyAfterBattleText
	waitbutton
	closetext
	end

TrainerScientistThurston:
	trainer SCIENTIST, THURSTON, EVENT_BEAT_SCIENTIST_THURSTON, ScientistThurstonSeenText, ScientistThurstonBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext ScientistThurstonAfterBattleText
	waitbutton
	closetext
	end

TrainerYoungsterCliff:
	trainer YOUNGSTER, CLIFF, EVENT_BEAT_YOUNGSTER_CLIFF, YoungsterCliffSeenText, YoungsterCliffBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext YoungsterCliffAfterBattleText
	waitbutton
	closetext
	end

Route11DiglettsCaveSign:
	jumptext Route11DiglettsCaveSignText

Route11FruitTree:
	fruittree FRUITTREE_ROUTE_11

; Kanto hack (M4 audit): Yellow's only ROUTE 11 hidden item is an ESCAPE_ROPE at
; (48,5) (vendor/pokeyellow/data/events/hidden_events.asm:226,
; hidden_item_coords.asm:36). Crystal's REVIVE at (32,5) was a leftover -- the
; 7l survey kept it on my own judgement, not an operator ruling, and
; docs/PORTING.md §15 lists no hidden-item carry-over, so it goes.
Route11HiddenEscapeRope:
	hiddenitem ESCAPE_ROPE, EVENT_ROUTE_11_HIDDEN_ESCAPE_ROPE

GentlemanArthurSeenText:
	text "Win, lose or draw!"
	done

GentlemanArthurBeatenText:
	text "Atcha!"
	line "Didn't go my way!"
	done

GentlemanArthurAfterBattleText:
	text "#MON is life!"
	line "And to live is to"
	cont "gamble!"
	done

GentlemanLeopoldSeenText:
	text "Competition! I"
	line "can't get enough!"
	done

GentlemanLeopoldBeatenText:
	text "I had"
	line "a chance!"
	done

GentlemanLeopoldAfterBattleText:
	text "You can't be a"
	line "coward in the"
	cont "world of #MON!"
	done

YoungsterFloydSeenText:
	text "Let's go, but"
	line "don't cheat!"
	done

YoungsterFloydBeatenText:
	text "Huh?"
	line "That's not right!"
	done

YoungsterFloydAfterBattleText:
	text "I did my best! I"
	line "have no regrets!"
	done

ScientistMaxwellSeenText:
	text "Careful!"
	line "I'm laying down"
	cont "some cables!"
	done

ScientistMaxwellBeatenText:
	text "That"
	line "was electric!"
	done

ScientistMaxwellAfterBattleText:
	text "Spread the word"
	line "to save energy!"
	done

YoungsterRudySeenText:
	text "I just became a"
	line "trainer! But, I"
	cont "think I can win!"
	done

YoungsterRudyBeatenText:
	text "My"
	line "#MON couldn't!"
	done

YoungsterRudyAfterBattleText:
	text "What do you want?"
	line "Leave me alone!"
	done

GentlemanWinstonSeenText:
	text "Fwahaha! I have"
	line "never lost!"
	done

GentlemanWinstonBeatenText:
	text "My"
	line "first loss!"
	done

GentlemanWinstonAfterBattleText:
	text "Luck of the draw!"
	line "Just luck!"
	done

GentlemanHoraceSeenText:
	text "I have never won"
	line "before…"
	done

GentlemanHoraceBeatenText:
	text "I saw"
	line "this coming…"
	done

GentlemanHoraceAfterBattleText:
	text "It's just luck."
	line "Luck of the draw."
	done

YoungsterGordySeenText:
	text "I'm the best in"
	line "my class!"
	done

YoungsterGordyBeatenText:
	text "Darn!"
	line "I need to make my"
	cont "#MON stronger!"
	done

YoungsterGordyAfterBattleText:
	text "There's a fat"
	line "#MON that"
	cont "comes down from"
	cont "the mountains."

	para "It's strong if"
	line "you can get it."
	done

ScientistThurstonSeenText:
	text "Watch out for"
	line "live wires!"
	done

ScientistThurstonBeatenText:
	text "Whoa!"
	line "You spark plug!"
	done

ScientistThurstonAfterBattleText:
	text "Well, better get"
	line "back to work."
	done

YoungsterCliffSeenText:
	text "My #MON should"
	line "be ready by now!"
	done

YoungsterCliffBeatenText:
	text "Too"
	line "much, too young!"
	done

YoungsterCliffAfterBattleText:
	text "I better go find"
	line "stronger ones!"
	done

Route11DiglettsCaveSignText:
	text "DIGLETT's CAVE"
	done

Route11_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 49,  8, ROUTE_11_GATE_1F, 1 ; Kanto hack (docs/M4-VERMILION.md, 7c)
	warp_event 49,  9, ROUTE_11_GATE_1F, 1 ; Kanto hack (docs/M4-VERMILION.md, 7c)
	warp_event 58,  8, ROUTE_11_GATE_1F, 3 ; Kanto hack (docs/M4-VERMILION.md, 7c)
	warp_event 58,  9, ROUTE_11_GATE_1F, 3 ; Kanto hack (docs/M4-VERMILION.md, 7c)
	warp_event  4,  5, DIGLETTS_CAVE_ROUTE_11, 1 ; Kanto hack (docs/M4-VERMILION.md, 7c)

	def_coord_events

	def_bg_events
	bg_event  1,  5, BGEVENT_READ, Route11DiglettsCaveSign
	bg_event 48,  5, BGEVENT_ITEM, Route11HiddenEscapeRope ; Kanto hack (M4 audit): Yellow's tile; a WALL block, and correctly so -- BGEVENT_ITEM triggers on FACING it, from (48,6) or (49,5)

	def_object_events
	object_event 10, 14, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerGentlemanArthur, -1
	object_event 26,  9, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerGentlemanLeopold, -1
	object_event 13,  5, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerYoungsterFloyd, -1
	object_event 36, 11, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerScientistMaxwell, -1
	object_event 22,  4, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 4, TrainerYoungsterRudy, -1
	object_event 45,  7, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerGentlemanWinston, -1
	object_event 33,  3, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerGentlemanHorace, -1
	object_event 43,  5, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 4, TrainerYoungsterGordy, -1
	object_event 45, 16, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerScientistThurston, -1
	object_event 22, 12, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 4, TrainerYoungsterCliff, -1
	object_event 30,  2, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route11FruitTree, -1
