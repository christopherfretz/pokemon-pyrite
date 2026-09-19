; Kanto hack: Yellow's ROUTE 12, re-cut wholesale (docs/M5-LAVENDER.md, 8l).
; Crystal's ROUTE 12 was the northern 10x27 half of Yellow's 10x54 map with
; four invented fishers on it; 8l replaces the whole thing with Yellow's --
; layout, seven trainers, two item balls, two signs and the SNORLAX.
;
; Object order below is Yellow's own (data/maps/objects/Route12.asm), and the
; sight ranges are Yellow's trainer headers (scripts/Route12.asm:81-96): 4 for
; every trainer except FISHER 11 at the far south, which is 1.
;
; Class substitutions, both already established:
;   OPP_JR_TRAINER_M -> CAMPER   (Crystal has no JR.TRAINER^M; CAMPER is the
;                                 stand-in used since Nugget Bridge)
;   OPP_ROCKER       -> GUITARIST (Crystal has no ROCKER; see VERMILION GYM's
;                                 VINCENT, docs/M4-VERMILION.md 5.1)
	object_const_def
	const ROUTE12_SNORLAX
	const ROUTE12_FISHER1
	const ROUTE12_FISHER2
	const ROUTE12_COOLTRAINER_M
	const ROUTE12_SUPER_NERD
	const ROUTE12_FISHER3
	const ROUTE12_FISHER4
	const ROUTE12_FISHER5
	const ROUTE12_TM_PAY_DAY
	const ROUTE12_IRON

Route12_MapScripts:
	def_scene_scripts

	def_callbacks

; M6: POKE FLUTE wake branch goes here (docs/M5-LAVENDER.md 3.8).
; Yellow's Route12DefaultScript wakes the SNORLAX when EVENT_FIGHT_ROUTE12_SNORLAX
; is set (the POKe FLUTE sets it), prints "SNORLAX woke up!", fights it at L30,
; hides the object and prints "SNORLAX calmed down!".  8l ships only the
; sleeping text -- no wake branch, no cry (Yellow plays none with this text).
Route12Snorlax:
	jumptext Route12SnorlaxText

TrainerFisherKyle:
	trainer FISHER, KYLE, EVENT_BEAT_FISHER_KYLE, FisherKyleSeenText, FisherKyleBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext FisherKyleAfterBattleText
	waitbutton
	closetext
	end

TrainerFisherMartin:
	trainer FISHER, MARTIN, EVENT_BEAT_FISHER_MARTIN, FisherMartinSeenText, FisherMartinBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext FisherMartinAfterBattleText
	waitbutton
	closetext
	end

TrainerCamperLester:
	trainer CAMPER, LESTER, EVENT_BEAT_CAMPER_LESTER, CamperLesterSeenText, CamperLesterBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext CamperLesterAfterBattleText
	waitbutton
	closetext
	end

TrainerGuitaristSparky:
	trainer GUITARIST, SPARKY, EVENT_BEAT_GUITARIST_SPARKY, GuitaristSparkySeenText, GuitaristSparkyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext GuitaristSparkyAfterBattleText
	waitbutton
	closetext
	end

TrainerFisherStephen:
	trainer FISHER, STEPHEN, EVENT_BEAT_FISHER_STEPHEN, FisherStephenSeenText, FisherStephenBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext FisherStephenAfterBattleText
	waitbutton
	closetext
	end

TrainerFisherBarney:
	trainer FISHER, BARNEY, EVENT_BEAT_FISHER_BARNEY, FisherBarneySeenText, FisherBarneyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext FisherBarneyAfterBattleText
	waitbutton
	closetext
	end

TrainerFisherElwood:
	trainer FISHER, ELWOOD, EVENT_BEAT_FISHER_ELWOOD, FisherElwoodSeenText, FisherElwoodBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext FisherElwoodAfterBattleText
	waitbutton
	closetext
	end

Route12Sign:
	jumptext Route12SignText

Route12SportFishingSign:
	jumptext Route12SportFishingSignText

Route12TMPayDay:
	itemball TM_PAY_DAY

Route12Iron:
	itemball IRON

Route12SnorlaxText:
	text "A sleeping #MON"
	line "blocks the way!"
	done

FisherKyleSeenText:
	text "Yeah! I got a"
	line "bite, here!"
	done

FisherKyleBeatenText:
	text "Tch!"
	line "Just a small fry!"
	done

FisherKyleAfterBattleText:
	text "Hang on! My line's"
	line "snagged!"
	done

FisherMartinSeenText:
	text "Be patient!"
	line "Fishing is a"
	cont "waiting game!"
	done

FisherMartinBeatenText:
	text "That"
	line "one got away!"
	done

FisherMartinAfterBattleText:
	text "With a better ROD,"
	line "I could catch"
	cont "better #MON!"
	done

CamperLesterSeenText:
	text "Have you found a"
	line "MOON STONE?"
	done

CamperLesterBeatenText:
	text "Oww!"
	done

CamperLesterAfterBattleText:
	text "I could have made"
	line "my #MON evolve"
	cont "with MOON STONE!"
	done

GuitaristSparkySeenText:
	text "Electricity is my"
	line "specialty!"
	done

GuitaristSparkyBeatenText:
	text "Unplugged!"
	done

GuitaristSparkyAfterBattleText:
	text "Water conducts"
	line "electricity, so"
	cont "you should zap"
	cont "sea #MON!"
	done

FisherStephenSeenText:
	text "The FISHING FOOL"
	line "vs. #MON KID!"
	done

FisherStephenBeatenText:
	text "Too"
	line "much!"
	done

FisherStephenAfterBattleText:
	text "You beat me at"
	line "#MON, but I'm"
	cont "good at fishing!"
	done

FisherBarneySeenText:
	text "I'd rather be"
	line "working!"
	done

FisherBarneyBeatenText:
	text "It's"
	line "not easy…"
	done

FisherBarneyAfterBattleText:
	text "It's all right."
	line "Losing doesn't"
	cont "bug me anymore."
	done

FisherElwoodSeenText:
	text "You never know"
	line "what you could"
	cont "catch!"
	done

FisherElwoodBeatenText:
	text "Lost"
	line "it!"
	done

FisherElwoodAfterBattleText:
	text "I catch MAGIKARP"
	line "all the time, but"
	cont "they're so weak!"
	done

Route12SignText:
	text "ROUTE 12 "
	line "North to LAVENDER"
	done

Route12SportFishingSignText:
	text "SPORT FISHING AREA"
	done

Route12_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 10, 15, ROUTE_12_GATE_1F, 1
	warp_event 11, 15, ROUTE_12_GATE_1F, 1 ; Yellow points BOTH north tiles at the gate's warp 1, the same duplicate ROUTE 11 has
	warp_event 10, 21, ROUTE_12_GATE_1F, 3
	warp_event 11, 77, ROUTE_12_SUPER_ROD_HOUSE, 1

	def_coord_events

	def_bg_events
	bg_event 13, 13, BGEVENT_READ, Route12Sign
	bg_event 11, 63, BGEVENT_READ, Route12SportFishingSign

	def_object_events
	object_event 10, 62, SPRITE_BIG_SNORLAX, SPRITEMOVEDATA_BIGDOLLSYM, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route12Snorlax, EVENT_BEAT_ROUTE_12_SNORLAX ; palette 0 = the sprite's own, as vanilla Crystal's VERMILION CITY SNORLAX has it
	object_event 14, 31, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 4, TrainerFisherKyle, -1
	object_event  5, 39, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 4, TrainerFisherMartin, -1
	object_event 11, 92, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerCamperLester, -1
	object_event 14, 76, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 4, TrainerGuitaristSparky, -1
	object_event 12, 40, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 4, TrainerFisherStephen, -1
	object_event  9, 52, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 4, TrainerFisherBarney, -1
	object_event  6, 87, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 1, TrainerFisherElwood, -1
	object_event 14, 35, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route12TMPayDay, EVENT_ROUTE_12_TM_PAY_DAY
	object_event  5, 89, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route12Iron, EVENT_ROUTE_12_IRON
