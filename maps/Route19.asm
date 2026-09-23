; Kanto hack: Yellow's ROUTE 19, populated (docs/M9-CINNABAR.md, 12c).  12a
; resized the map to Yellow's 10x27 and 12b cut Yellow's geometry into it; this
; step replaces the four invented Crystal swimmers and the two invented signs
; with Yellow's ten trainers and Yellow's one sign, at Yellow's coordinates
; (vendor/pokeyellow/data/maps/objects/Route19.asm).
;
; D98: ROUTE_19_FUCHSIA_GATE is retired here.  Yellow has no gate between
; FUCHSIA and ROUTE 19 -- the city's south edge walks straight onto the
; HOP_DOWN terrace at row 0 -- so this map has no gate warp_events now, and
; 12b's $cb LEDGE_TWIN fence at blocks (4,0)/(5,0) is gone with it.
; The map const ROUTE_19_FUCHSIA_GATE stays registered as a dead id (D49) and
; maps/Route19FuchsiaGate.asm stays in the build, unreferenced, exactly like
; FuchsiaPokecenter2FBeta.
;
; D107 (closed by M12a): Yellow's SUMMER BEACH HOUSE door at (5,9) is warp 1,
; into maps/SummerBeachHouse.asm, exactly as Yellow's own
; `warp_event 5, 9, SUMMER_BEACH_HOUSE, 1`.  Until M12a it kept its art and
; DOOR collision with no warp_event and bounced the player back to (5,10).
;
; Object order below is Yellow's own, and the sight ranges are Yellow's trainer
; headers (vendor/pokeyellow/scripts/Route19.asm:30-49).
;
; Class substitutions (M7 10c precedent):
;   OPP_SWIMMER -> SWIMMERM   (Crystal's only male swimmer class; the Cerulean
;                              Gym port already made this substitution)
;   OPP_BEAUTY  -> BEAUTY     straight across
; Yellow's SPRITE_SWIMMER is pixel-identical to Crystal's SPRITE_SWIMMER_GUY,
; so every Yellow swimmer -- including the BEAUTY-class ones -- keeps that one
; overworld sheet, as in Yellow.  SPRITE_COOLTRAINER_M is identical too.
;
; The party rows are nameless (`db "@", TRAINERTYPE_NORMAL`), so PlaceEnemysName
; prints the class alone, as Gen 1 does.

	object_const_def
	const ROUTE19_COOLTRAINER_M1
	const ROUTE19_COOLTRAINER_M2
	const ROUTE19_SWIMMER1
	const ROUTE19_SWIMMER2
	const ROUTE19_SWIMMER3
	const ROUTE19_SWIMMER4
	const ROUTE19_SWIMMER5
	const ROUTE19_SWIMMER6
	const ROUTE19_SWIMMER7
	const ROUTE19_SWIMMER8

Route19_MapScripts:
	def_scene_scripts

	def_callbacks

TrainerSwimmerm1:
	trainer SWIMMERM, SWIMMERM_1, EVENT_BEAT_ROUTE_19_TRAINER_0, Route19CooltrainerM1SeenText, Route19CooltrainerM1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route19CooltrainerM1AfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmerm2:
	trainer SWIMMERM, SWIMMERM_2, EVENT_BEAT_ROUTE_19_TRAINER_1, Route19CooltrainerM2SeenText, Route19CooltrainerM2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route19CooltrainerM2AfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmerm3:
	trainer SWIMMERM, SWIMMERM_3, EVENT_BEAT_ROUTE_19_TRAINER_2, Route19Swimmer1SeenText, Route19Swimmer1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route19Swimmer1AfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmerm4:
	trainer SWIMMERM, SWIMMERM_4, EVENT_BEAT_ROUTE_19_TRAINER_3, Route19Swimmer2SeenText, Route19Swimmer2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route19Swimmer2AfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmerm5:
	trainer SWIMMERM, SWIMMERM_5, EVENT_BEAT_ROUTE_19_TRAINER_4, Route19Swimmer3SeenText, Route19Swimmer3BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route19Swimmer3AfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmerm6:
	trainer SWIMMERM, SWIMMERM_6, EVENT_BEAT_ROUTE_19_TRAINER_5, Route19Swimmer4SeenText, Route19Swimmer4BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route19Swimmer4AfterBattleText
	waitbutton
	closetext
	end

TrainerBeauty5:
	trainer BEAUTY, BEAUTY_5, EVENT_BEAT_ROUTE_19_TRAINER_6, Route19Swimmer5SeenText, Route19Swimmer5BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route19Swimmer5AfterBattleText
	waitbutton
	closetext
	end

TrainerBeauty6:
	trainer BEAUTY, BEAUTY_6, EVENT_BEAT_ROUTE_19_TRAINER_7, Route19Swimmer6SeenText, Route19Swimmer6BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route19Swimmer6AfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmerm7:
	trainer SWIMMERM, SWIMMERM_7, EVENT_BEAT_ROUTE_19_TRAINER_8, Route19Swimmer7SeenText, Route19Swimmer7BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route19Swimmer7AfterBattleText
	waitbutton
	closetext
	end

TrainerBeauty7:
	trainer BEAUTY, BEAUTY_7, EVENT_BEAT_ROUTE_19_TRAINER_9, Route19Swimmer8SeenText, Route19Swimmer8BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route19Swimmer8AfterBattleText
	waitbutton
	closetext
	end

Route19Sign:
	jumptext Route19SignText

Route19CooltrainerM1SeenText:
	text "Have to warm up"
	line "before my swim!"
	done

Route19CooltrainerM1BeatenText:
	text "All"
	line "warmed up!"
	done

Route19CooltrainerM1AfterBattleText:
	text "Thanks, kid! I'm"
	line "ready for a swim!"
	done

Route19CooltrainerM2SeenText:
	text "Wait! You'll have"
	line "a heart attack!"
	done

Route19CooltrainerM2BeatenText:
	text "Ooh!"
	line "That's chilly!"
	done

Route19CooltrainerM2AfterBattleText:
	text "Watch out for"
	line "TENTACOOL!"
	done

Route19Swimmer1SeenText:
	text "I love swimming!"
	line "What about you?"
	done

Route19Swimmer1BeatenText:
	text "Belly"
	line "flop!"
	done

Route19Swimmer1AfterBattleText:
	text "I can beat #MON"
	line "at swimming!"
	done

Route19Swimmer2SeenText:
	text "What's beyond the"
	line "horizon?"
	done

Route19Swimmer2BeatenText:
	text "Glub!"
	done

Route19Swimmer2AfterBattleText:
	text "I see a couple of"
	line "islands!"
	done

Route19Swimmer3SeenText:
	text "I tried diving"
	line "for #MON, but"
	cont "it was a no go!"
	done

Route19Swimmer3BeatenText:
	text "Help!"
	done

Route19Swimmer3AfterBattleText:
	text "You have to fish"
	line "for sea #MON!"
	done

Route19Swimmer4SeenText:
	text "I look at the"
	line "sea to forget!"
	done

Route19Swimmer4BeatenText:
	text "Ooh!"
	line "Traumatic!"
	done

Route19Swimmer4AfterBattleText:
	text "I'm looking at the"
	line "sea to forget!"
	done

Route19Swimmer5SeenText:
	text "Oh, I just love"
	line "your ride! Can I"
	cont "have it if I win?"
	done

Route19Swimmer5BeatenText:
	text "Oh!"
	line "I lost!"
	done

Route19Swimmer5AfterBattleText:
	text "It's still a long"
	line "way to go to"
	cont "SEAFOAM ISLANDS."
	done

Route19Swimmer6SeenText:
	text "Swimming's great!"
	line "Sunburns aren't!"
	done

Route19Swimmer6BeatenText:
	text "Shocker!"
	done

Route19Swimmer6AfterBattleText:
	text "My boy friend"
	line "wanted to swim to"
	cont "SEAFOAM ISLANDS."
	done

Route19Swimmer7SeenText:
	text "These waters are"
	line "treacherous!"
	done

Route19Swimmer7BeatenText:
	text "Ooh!"
	line "Dangerous!"
	done

Route19Swimmer7AfterBattleText:
	text "I got a cramp!"
	line "Glub, glub…"
	done

Route19Swimmer8SeenText:
	text "I swam here, but"
	line "I'm tired."
	done

Route19Swimmer8BeatenText:
	text "I'm"
	line "exhausted…"
	done

Route19Swimmer8AfterBattleText:
	text "LAPRAS is so big,"
	line "it must keep you"
	cont "dry on water."
	done

Route19SignText:
	text "SEA ROUTE 19"
	line "FUCHSIA CITY -"
	cont "SEAFOAM ISLANDS"
	done

Route19_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  5,  9, SUMMER_BEACH_HOUSE, 1

	def_coord_events

	def_bg_events
	bg_event 11, 11, BGEVENT_READ, Route19Sign

	def_object_events
	object_event  9,  7, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerSwimmerm1, -1 ; Yellow's SWIMMER 2
	object_event 12,  9, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerSwimmerm2, -1 ; Yellow's SWIMMER 3
	object_event 13, 25, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerSwimmerm3, -1 ; Yellow's SWIMMER 4
	object_event  4, 27, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerSwimmerm4, -1 ; Yellow's SWIMMER 5
	object_event 16, 31, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerSwimmerm5, -1 ; Yellow's SWIMMER 6
	object_event  9, 13, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerSwimmerm6, -1 ; Yellow's SWIMMER 7
	object_event  8, 43, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerBeauty5, -1 ; Yellow's BEAUTY 12
	object_event 11, 43, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerBeauty6, -1 ; Yellow's BEAUTY 13
	object_event  9, 42, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerSwimmerm7, -1 ; Yellow's SWIMMER 8
	object_event 10, 44, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerBeauty7, -1 ; Yellow's BEAUTY 14
