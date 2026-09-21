; Kanto hack: Yellow's ROUTE 14, re-cut wholesale (docs/M7-FUCHSIA.md, 10d).
; Crystal's ROUTE 14 was 10x18 with three invented trainers and a Gen 2 in-game
; trade; 10a grew the map to Yellow's 10x27 with a placeholder fill, and 10d
; replaces the layout (scripts/vermilion_blk.py, M7 10d), the objects and the
; connections with Yellow's -- ten trainers and one sign.  Yellow's ROUTE 14 has
; no warps, no coord events and no hidden items.
;
; Deleted with Crystal's version: POKEFANM CARTER (11,15), BIRD KEEPER ROY
; (11,27), POKEFANM TREVOR (6,11) and TEACHER Kim (7,5), whose only script was
; `trade NPC_TRADE_KIM` -- a Gen 2 in-game trade with no Yellow counterpart
; (docs/M7-FUCHSIA.md 0.5).
;
; Object order below is Yellow's own (data/maps/objects/Route14.asm), and the
; sight ranges are Yellow's trainer headers (scripts/Route14.asm:32-51):
; 2, 2, 4, 3, 3, 4, 4, 4, 3, 4.
;
; Class substitutions: none needed.  Yellow's OPP_BIRD_KEEPER and OPP_BIKER map
; straight onto BIRD_KEEPER and BIKER, which Crystal has.
;
; The party rows are nameless (`db "@", TRAINERTYPE_NORMAL`), so
; PlaceEnemysName prints the class alone, as Gen 1 does.  Const/flag pairs:
;   BIRD_KEEPER_7..12  EVENT_BEAT_ROUTE_14_BIRD_KEEPER_7..12
;   BIKER_10..13       EVENT_BEAT_ROUTE_14_BIKER_10..13
; (BIRD_KEEPER_1-6 and BIKER_1-9 are M6/M7's ROUTE 13/16/17/18 trainers; the
; numbers continue that per-class hack sequence, they are not Yellow's opponent
; ids -- Yellow's are OPP_BIRD_KEEPER 14/15/16/17/4/5 and OPP_BIKER 13/14/15/2,
; in that order.)
	object_const_def
	const ROUTE14_BIRD_KEEPER1
	const ROUTE14_BIRD_KEEPER2
	const ROUTE14_BIRD_KEEPER3
	const ROUTE14_BIRD_KEEPER4
	const ROUTE14_BIRD_KEEPER5
	const ROUTE14_BIRD_KEEPER6
	const ROUTE14_BIKER1
	const ROUTE14_BIKER2
	const ROUTE14_BIKER3
	const ROUTE14_BIKER4

Route14_MapScripts:
	def_scene_scripts

	def_callbacks

TrainerBirdKeeper7:
	trainer BIRD_KEEPER, BIRD_KEEPER_7, EVENT_BEAT_ROUTE_14_BIRD_KEEPER_7, Route14BirdKeeper7SeenText, Route14BirdKeeper7BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route14BirdKeeper7AfterBattleText
	waitbutton
	closetext
	end

TrainerBirdKeeper8:
	trainer BIRD_KEEPER, BIRD_KEEPER_8, EVENT_BEAT_ROUTE_14_BIRD_KEEPER_8, Route14BirdKeeper8SeenText, Route14BirdKeeper8BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route14BirdKeeper8AfterBattleText
	waitbutton
	closetext
	end

TrainerBirdKeeper9:
	trainer BIRD_KEEPER, BIRD_KEEPER_9, EVENT_BEAT_ROUTE_14_BIRD_KEEPER_9, Route14BirdKeeper9SeenText, Route14BirdKeeper9BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route14BirdKeeper9AfterBattleText
	waitbutton
	closetext
	end

TrainerBirdKeeper10:
	trainer BIRD_KEEPER, BIRD_KEEPER_10, EVENT_BEAT_ROUTE_14_BIRD_KEEPER_10, Route14BirdKeeper10SeenText, Route14BirdKeeper10BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route14BirdKeeper10AfterBattleText
	waitbutton
	closetext
	end

TrainerBirdKeeper11:
	trainer BIRD_KEEPER, BIRD_KEEPER_11, EVENT_BEAT_ROUTE_14_BIRD_KEEPER_11, Route14BirdKeeper11SeenText, Route14BirdKeeper11BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route14BirdKeeper11AfterBattleText
	waitbutton
	closetext
	end

TrainerBirdKeeper12:
	trainer BIRD_KEEPER, BIRD_KEEPER_12, EVENT_BEAT_ROUTE_14_BIRD_KEEPER_12, Route14BirdKeeper12SeenText, Route14BirdKeeper12BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route14BirdKeeper12AfterBattleText
	waitbutton
	closetext
	end

TrainerBiker10:
	trainer BIKER, BIKER_10, EVENT_BEAT_ROUTE_14_BIKER_10, Route14Biker10SeenText, Route14Biker10BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route14Biker10AfterBattleText
	waitbutton
	closetext
	end

TrainerBiker11:
	trainer BIKER, BIKER_11, EVENT_BEAT_ROUTE_14_BIKER_11, Route14Biker11SeenText, Route14Biker11BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route14Biker11AfterBattleText
	waitbutton
	closetext
	end

TrainerBiker12:
	trainer BIKER, BIKER_12, EVENT_BEAT_ROUTE_14_BIKER_12, Route14Biker12SeenText, Route14Biker12BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route14Biker12AfterBattleText
	waitbutton
	closetext
	end

TrainerBiker13:
	trainer BIKER, BIKER_13, EVENT_BEAT_ROUTE_14_BIKER_13, Route14Biker13SeenText, Route14Biker13BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route14Biker13AfterBattleText
	waitbutton
	closetext
	end

Route14Sign:
	jumptext Route14SignText

Route14BirdKeeper7SeenText:
	text "You need to use"
	line "TMs to teach good"
	cont "moves to #MON!"
	done

Route14BirdKeeper7BeatenText:
	text "Not"
	line "good enough!"
	done

Route14BirdKeeper7AfterBattleText:
	text "You have some HMs,"
	line "right? #MON"
	cont "can't ever forget"
	cont "those moves."
	done

Route14BirdKeeper8SeenText:
	text "My bird #MON"
	line "should be ready"
	cont "for battle."
	done

Route14BirdKeeper8BeatenText:
	text "Not"
	line "ready yet!"
	done

Route14BirdKeeper8AfterBattleText:
	text "They need to learn"
	line "better moves."
	done

Route14BirdKeeper9SeenText:
	text "TMs are on sale"
	line "in CELADON!"
	cont "But, only a few"
	cont "people have HMs!"
	done

Route14BirdKeeper9BeatenText:
	text "Aww,"
	line "bummer!"
	done

Route14BirdKeeper9AfterBattleText:
	text "Teach #MON"
	line "moves of the same"
	cont "element type for"
	cont "more power."
	done

Route14BirdKeeper10SeenText:
	text "Have you taught"
	line "your bird #MON"
	cont "how to FLY?"
	done

Route14BirdKeeper10BeatenText:
	text "Shot"
	line "down in flames!"
	done

Route14BirdKeeper10AfterBattleText:
	text "Bird #MON are"
	line "my true love!"
	done

Route14BirdKeeper11SeenText:
	text "Have you heard of"
	line "the legendary"
	cont "#MON?"
	done

Route14BirdKeeper11BeatenText:
	text "Why?"
	line "Why'd I lose?"
	done

Route14BirdKeeper11AfterBattleText:
	text "The 3 legendary"
	line "#MON are all"
	cont "birds of prey."
	done

Route14BirdKeeper12SeenText:
	text "I'm not into it,"
	line "but OK! Let's go!"
	done

Route14BirdKeeper12BeatenText:
	text "I"
	line "knew it!"
	done

Route14BirdKeeper12AfterBattleText:
	text "Winning, losing,"
	line "it doesn't matter"
	cont "in the long run!"
	done

Route14Biker10SeenText:
	text "C'mon, c'mon."
	line "Let's go, let's"
	cont "go, let's go!"
	done

Route14Biker10BeatenText:
	text "Arrg!"
	line "Lost! Get lost!"
	done

Route14Biker10AfterBattleText:
	text "What, what, what?"
	line "What do you want?"
	done

Route14Biker11SeenText:
	text "Perfect! I need to"
	line "burn some time!"
	done

Route14Biker11BeatenText:
	text "What?"
	line "You!?"
	done

Route14Biker11AfterBattleText:
	text "Raising #MON"
	line "is a drag, man."
	done

Route14Biker12SeenText:
	text "We ride out here"
	line "because there's"
	cont "more room!"
	done

Route14Biker12BeatenText:
	text "Wipe out!"
	done

Route14Biker12AfterBattleText:
	text "It's cool you"
	line "made your #MON"
	cont "so strong!"

	para "Might is right!"
	line "And you know it!"
	done

Route14Biker13SeenText:
	text "#MON fight?"
	line "Cool! Rumble!"
	done

Route14Biker13BeatenText:
	text "Blown"
	line "away!"
	done

Route14Biker13AfterBattleText:
	text "You know who'd"
	line "win, you and me"
	cont "one on one!"
	done

Route14SignText:
	text "ROUTE 14"
	line "West to FUCHSIA"
	cont "CITY"
	done

Route14_MapEvents:
	db 0, 0 ; filler

	def_warp_events

	def_coord_events

	def_bg_events
	bg_event 17, 13, BGEVENT_READ, Route14Sign

	def_object_events
	object_event  4,  4, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerBirdKeeper7, -1
	object_event 15,  6, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerBirdKeeper8, -1
	object_event 12, 11, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerBirdKeeper9, -1
	object_event 14, 15, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerBirdKeeper10, -1
	object_event 15, 31, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerBirdKeeper11, -1
	object_event  6, 49, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerBirdKeeper12, -1
	object_event  5, 39, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerBiker10, -1
	object_event  4, 30, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerBiker11, -1
	object_event 15, 30, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerBiker12, -1
	object_event  4, 31, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerBiker13, -1
