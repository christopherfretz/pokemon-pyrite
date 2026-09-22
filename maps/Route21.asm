; Kanto hack: Yellow's ROUTE 21, populated (docs/M9-CINNABAR.md, 12c).  12a
; resized the map to Yellow's 10x45 and 12b cut Yellow's geometry into it; this
; step replaces the three invented Crystal trainers with Yellow's nine, at
; Yellow's coordinates (vendor/pokeyellow/data/maps/objects/Route21.asm).
; Yellow's ROUTE 21 has no warps, no coord events and no signs.
;
; Object order below is Yellow's own, and the sight ranges are Yellow's trainer
; headers (vendor/pokeyellow/scripts/Route21.asm:22-40): the four FISHERs have
; sight 0, exactly as Yellow does -- they only fight when talked to.
;
; Class substitutions (M7 10c precedent):
;   OPP_SWIMMER  -> SWIMMERM
;   OPP_FISHER   -> FISHER
;   OPP_CUE_BALL -> CUE_BALL   (a real Crystal class, $46)
; Yellow's SPRITE_SWIMMER is pixel-identical to Crystal's SPRITE_SWIMMER_GUY
; and its SPRITE_FISHER to Crystal's, so both sheets carry straight across --
; including the CUE BALL-class trainer, who is a swimmer on the overworld in
; Yellow too.
;
; The party rows are nameless (`db "@", TRAINERTYPE_NORMAL`), so PlaceEnemysName
; prints the class alone, as Gen 1 does.

	object_const_def
	const ROUTE21_FISHER1
	const ROUTE21_FISHER2
	const ROUTE21_SWIMMER1
	const ROUTE21_SWIMMER2
	const ROUTE21_SWIMMER3
	const ROUTE21_SWIMMER4
	const ROUTE21_SWIMMER5
	const ROUTE21_FISHER3
	const ROUTE21_FISHER4

Route21_MapScripts:
	def_scene_scripts

	def_callbacks

TrainerFisher1:
	trainer FISHER, FISHER_1, EVENT_BEAT_ROUTE_21_TRAINER_0, Route21Fisher1SeenText, Route21Fisher1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route21Fisher1AfterBattleText
	waitbutton
	closetext
	end

TrainerFisher2:
	trainer FISHER, FISHER_2, EVENT_BEAT_ROUTE_21_TRAINER_1, Route21Fisher2SeenText, Route21Fisher2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route21Fisher2AfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmerm11:
	trainer SWIMMERM, SWIMMERM_11, EVENT_BEAT_ROUTE_21_TRAINER_2, Route21Swimmer1SeenText, Route21Swimmer1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route21Swimmer1AfterBattleText
	waitbutton
	closetext
	end

TrainerCueBall9:
	trainer CUE_BALL, CUE_BALL_9, EVENT_BEAT_ROUTE_21_TRAINER_3, Route21Swimmer2SeenText, Route21Swimmer2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route21Swimmer2AfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmerm12:
	trainer SWIMMERM, SWIMMERM_12, EVENT_BEAT_ROUTE_21_TRAINER_4, Route21Swimmer3SeenText, Route21Swimmer3BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route21Swimmer3AfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmerm13:
	trainer SWIMMERM, SWIMMERM_13, EVENT_BEAT_ROUTE_21_TRAINER_5, Route21Swimmer4SeenText, Route21Swimmer4BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route21Swimmer4AfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmerm14:
	trainer SWIMMERM, SWIMMERM_14, EVENT_BEAT_ROUTE_21_TRAINER_6, Route21Swimmer5SeenText, Route21Swimmer5BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route21Swimmer5AfterBattleText
	waitbutton
	closetext
	end

TrainerFisher3:
	trainer FISHER, FISHER_3, EVENT_BEAT_ROUTE_21_TRAINER_7, Route21Fisher3SeenText, Route21Fisher3BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route21Fisher3AfterBattleText
	waitbutton
	closetext
	end

TrainerFisher4:
	trainer FISHER, FISHER_4, EVENT_BEAT_ROUTE_21_TRAINER_8, Route21Fisher4SeenText, Route21Fisher4BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route21Fisher4AfterBattleText
	waitbutton
	closetext
	end

Route21Fisher1SeenText:
	text "You want to know"
	line "if the fish are"
	cont "biting?"
	done

Route21Fisher1BeatenText:
	text "Dang!"
	done

Route21Fisher1AfterBattleText:
	text "I can't catch"
	line "anything good!"
	done

Route21Fisher2SeenText:
	text "I got a big haul!"
	line "Wanna go for it?"
	done

Route21Fisher2BeatenText:
	text "Darn"
	line "MAGIKARP!"
	done

Route21Fisher2AfterBattleText:
	text "I seem to only"
	line "catch MAGIKARP!"
	done

Route21Swimmer1SeenText:
	text "The sea cleanses"
	line "my body and soul!"
	done

Route21Swimmer1BeatenText:
	text "Ayah!"
	done

Route21Swimmer1AfterBattleText:
	text "I like the"
	line "mountains too!"
	done

Route21Swimmer2SeenText:
	text "What's wrong with"
	line "me swimming?"
	done

Route21Swimmer2BeatenText:
	text "Cheap"
	line "shot!"
	done

Route21Swimmer2AfterBattleText:
	text "I look like what?"
	line "A studded inner"
	cont "tube? Get lost!"
	done

Route21Swimmer3SeenText:
	text "I caught all my"
	line "#MON at sea!"
	done

Route21Swimmer3BeatenText:
	text "Diver!!"
	line "Down!!"
	done

Route21Swimmer3AfterBattleText:
	text "Where'd you catch"
	line "your #MON?"
	done

Route21Swimmer4SeenText:
	text "Right now, I'm in"
	line "a triathlon meet!"
	done

Route21Swimmer4BeatenText:
	text "Pant…"
	line "pant…pant…"
	done

Route21Swimmer4AfterBattleText:
	text "I'm beat!"
	line "But, I still have"
	cont "the bike race and"
	cont "marathon left!"
	done

Route21Swimmer5SeenText:
	text "Ahh! Feel the sun"
	line "and the wind!"
	done

Route21Swimmer5BeatenText:
	text "Yow!"
	line "I lost!"
	done

Route21Swimmer5AfterBattleText:
	text "I'm sunburnt to a"
	line "crisp!"
	done

Route21Fisher3SeenText:
	text "Hey, don't scare"
	line "away the fish!"
	done

Route21Fisher3BeatenText:
	text "Sorry!"
	line "I didn't mean it!"
	done

Route21Fisher3AfterBattleText:
	text "I was just angry"
	line "that I couldn't"
	cont "catch anything."
	done

Route21Fisher4SeenText:
	text "Keep me company"
	line "'til I get a hit!"
	done

Route21Fisher4BeatenText:
	text "That"
	line "burned some time."
	done

Route21Fisher4AfterBattleText:
	text "Oh wait! I got a"
	line "bite! Yeah!"
	done

Route21_MapEvents:
	db 0, 0 ; filler

	def_warp_events

	def_coord_events

	def_bg_events

	def_object_events
	object_event  4, 24, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 0, TrainerFisher1, -1 ; Yellow's FISHER 7
	object_event  6, 25, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 0, TrainerFisher2, -1 ; Yellow's FISHER 9
	object_event 10, 31, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerSwimmerm11, -1 ; Yellow's SWIMMER 12
	object_event 12, 30, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerCueBall9, -1 ; Yellow's CUE BALL 9
	object_event 16, 63, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerSwimmerm12, -1 ; Yellow's SWIMMER 13
	object_event  5, 71, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerSwimmerm13, -1 ; Yellow's SWIMMER 14
	object_event 15, 71, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerSwimmerm14, -1 ; Yellow's SWIMMER 15
	object_event 14, 56, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 0, TrainerFisher3, -1 ; Yellow's FISHER 8
	object_event 17, 57, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 0, TrainerFisher4, -1 ; Yellow's FISHER 10
