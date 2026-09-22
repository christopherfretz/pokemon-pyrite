; Kanto hack: Yellow's ROUTE 20, populated (docs/M9-CINNABAR.md, 12c).  12a
; resized the map to Yellow's 50x9 and 12b cut Yellow's geometry into it; this
; step replaces the three invented Crystal swimmers and the invented CINNABAR
; GYM sign with Yellow's ten trainers and Yellow's two SEAFOAM ISLANDS signs,
; at Yellow's coordinates (vendor/pokeyellow/data/maps/objects/Route20.asm).
;
; Object order below is Yellow's own, and the sight ranges are Yellow's trainer
; headers (vendor/pokeyellow/scripts/Route20.asm:75-94).
;
; Class substitutions (M7 10c precedent):
;   OPP_SWIMMER      -> SWIMMERM
;   OPP_BEAUTY       -> BEAUTY
;   OPP_JR_TRAINER_F -> PICNICKER   (Crystal has no JR.TRAINER^F)
;   OPP_BIRD_KEEPER  -> BIRD_KEEPER
; Yellow's SPRITE_SWIMMER is pixel-identical to Crystal's SPRITE_SWIMMER_GUY,
; so every Yellow swimmer keeps that one overworld sheet, as in Yellow.
;
; The party rows are nameless (`db "@", TRAINERTYPE_NORMAL`), so PlaceEnemysName
; prints the class alone, as Gen 1 does.
;
; The two warps are 12b's SEAFOAM ISLANDS mouths.  Yellow's east mouth lands on
; its SEAFOAM_ISLANDS_1F warp 3; the 12a stub only has two warps, so it still
; points at warp 2 -- 12d re-points it when the real 1F lands.

	object_const_def
	const ROUTE20_SWIMMER1
	const ROUTE20_SWIMMER2
	const ROUTE20_SWIMMER3
	const ROUTE20_SWIMMER4
	const ROUTE20_SWIMMER5
	const ROUTE20_SWIMMER6
	const ROUTE20_COOLTRAINER_M
	const ROUTE20_SWIMMER7
	const ROUTE20_SWIMMER8
	const ROUTE20_SWIMMER9

Route20_MapScripts:
	def_scene_scripts

	def_callbacks

TrainerSwimmerm8:
	trainer SWIMMERM, SWIMMERM_8, EVENT_BEAT_ROUTE_20_TRAINER_0, Route20Swimmer1SeenText, Route20Swimmer1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route20Swimmer1AfterBattleText
	waitbutton
	closetext
	end

TrainerBeauty8:
	trainer BEAUTY, BEAUTY_8, EVENT_BEAT_ROUTE_20_TRAINER_1, Route20Swimmer2SeenText, Route20Swimmer2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route20Swimmer2AfterBattleText
	waitbutton
	closetext
	end

TrainerBeauty9:
	trainer BEAUTY, BEAUTY_9, EVENT_BEAT_ROUTE_20_TRAINER_2, Route20Swimmer3SeenText, Route20Swimmer3BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route20Swimmer3AfterBattleText
	waitbutton
	closetext
	end

TrainerPicnicker9:
	trainer PICNICKER, PICNICKER_9, EVENT_BEAT_ROUTE_20_TRAINER_3, Route20Swimmer4SeenText, Route20Swimmer4BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route20Swimmer4AfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmerm9:
	trainer SWIMMERM, SWIMMERM_9, EVENT_BEAT_ROUTE_20_TRAINER_4, Route20Swimmer5SeenText, Route20Swimmer5BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route20Swimmer5AfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmerm10:
	trainer SWIMMERM, SWIMMERM_10, EVENT_BEAT_ROUTE_20_TRAINER_5, Route20Swimmer6SeenText, Route20Swimmer6BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route20Swimmer6AfterBattleText
	waitbutton
	closetext
	end

TrainerBirdKeeper15:
	trainer BIRD_KEEPER, BIRD_KEEPER_15, EVENT_BEAT_ROUTE_20_TRAINER_6, Route20CooltrainerMSeenText, Route20CooltrainerMBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route20CooltrainerMAfterBattleText
	waitbutton
	closetext
	end

TrainerBeauty10:
	trainer BEAUTY, BEAUTY_10, EVENT_BEAT_ROUTE_20_TRAINER_7, Route20Swimmer7SeenText, Route20Swimmer7BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route20Swimmer7AfterBattleText
	waitbutton
	closetext
	end

TrainerPicnicker10:
	trainer PICNICKER, PICNICKER_10, EVENT_BEAT_ROUTE_20_TRAINER_8, Route20Swimmer8SeenText, Route20Swimmer8BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route20Swimmer8AfterBattleText
	waitbutton
	closetext
	end

TrainerBeauty11:
	trainer BEAUTY, BEAUTY_11, EVENT_BEAT_ROUTE_20_TRAINER_9, Route20Swimmer9SeenText, Route20Swimmer9BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route20Swimmer9AfterBattleText
	waitbutton
	closetext
	end

Route20SeafoamIslandsSign:
	jumptext Route20SeafoamIslandsSignText

Route20Swimmer1SeenText:
	text "The water is"
	line "shallow here."
	done

Route20Swimmer1BeatenText:
	text "Splash!"
	done

Route20Swimmer1AfterBattleText:
	text "I wish I could"
	line "ride my #MON."
	done

Route20Swimmer2SeenText:
	text "SEAFOAM is a"
	line "quiet getaway!"
	done

Route20Swimmer2BeatenText:
	text "Quit it!"
	done

Route20Swimmer2AfterBattleText:
	text "There's a huge"
	line "cavern underneath"
	cont "this island."
	done

Route20Swimmer3SeenText:
	text "I love floating"
	line "with the fishes!"
	done

Route20Swimmer3BeatenText:
	text "Yowch!"
	done

Route20Swimmer3AfterBattleText:
	text "Want to float"
	line "with me?"
	done

Route20Swimmer4SeenText:
	text "Are you on"
	line "vacation too?"
	done

Route20Swimmer4BeatenText:
	text "No"
	line "mercy at all!"
	done

Route20Swimmer4AfterBattleText:
	text "SEAFOAM used to"
	line "be one island!"
	done

Route20Swimmer5SeenText:
	text "Check out my buff"
	line "physique!"
	done

Route20Swimmer5BeatenText:
	text "Wimpy!"
	done

Route20Swimmer5AfterBattleText:
	text "I should've been"
	line "buffing up my"
	cont "#MON, not me!"
	done

Route20Swimmer6SeenText:
	text "Why are you"
	line "riding a #MON?"
	cont "Can't you swim?"
	done

Route20Swimmer6BeatenText:
	text "Ouch!"
	line "Torpedoed!"
	done

Route20Swimmer6AfterBattleText:
	text "Riding a #MON"
	line "sure looks fun!"
	done

Route20CooltrainerMSeenText:
	text "I rode my bird"
	line "#MON here!"
	done

Route20CooltrainerMBeatenText:
	text "Oh"
	line "no!"
	done

Route20CooltrainerMAfterBattleText:
	text "My birds can't"
	line "FLY me back!"
	done

Route20Swimmer7SeenText:
	text "My boy friend gave"
	line "me big pearls!"
	done

Route20Swimmer7BeatenText:
	text "Don't"
	line "touch my pearls!"
	done

Route20Swimmer7AfterBattleText:
	text "Will my pearls"
	line "grow bigger"
	cont "inside CLOYSTER?"
	done

Route20Swimmer8SeenText:
	text "I swam here from"
	line "CINNABAR ISLAND!"
	done

Route20Swimmer8BeatenText:
	text "I'm"
	line "so disappointed!"
	done

Route20Swimmer8AfterBattleText:
	text "#MON have"
	line "taken over an"
	cont "abandoned mansion"
	cont "on CINNABAR!"
	done

Route20Swimmer9SeenText:
	text "CINNABAR, in the"
	line "west, has a LAB"
	cont "for #MON."
	done

Route20Swimmer9BeatenText:
	text "Wait!"
	done

Route20Swimmer9AfterBattleText:
	text "CINNABAR is a "
	line "volcanic island!"
	done

Route20SeafoamIslandsSignText:
	text "SEAFOAM ISLANDS"
	done

Route20_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 48,  5, SEAFOAM_ISLANDS_1F, 1
	warp_event 58,  9, SEAFOAM_ISLANDS_1F, 2 ; Yellow: warp 3 (12d)

	def_coord_events

	def_bg_events
	bg_event 51,  7, BGEVENT_READ, Route20SeafoamIslandsSign
	bg_event 57, 11, BGEVENT_READ, Route20SeafoamIslandsSign

	def_object_events
	object_event 87,  8, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerSwimmerm8, -1 ; Yellow's SWIMMER 9
	object_event 68, 11, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerBeauty8, -1 ; Yellow's BEAUTY 15
	object_event 45, 10, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerBeauty9, -1 ; Yellow's BEAUTY 6
	object_event 55, 14, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerPicnicker9, -1 ; Yellow's JR.TRAINER^F 24
	object_event 38, 13, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerSwimmerm9, -1 ; Yellow's SWIMMER 10
	object_event 87, 13, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerSwimmerm10, -1 ; Yellow's SWIMMER 11
	object_event 34,  9, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerBirdKeeper15, -1 ; Yellow's BIRD KEEPER 11
	object_event 25,  7, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerBeauty10, -1 ; Yellow's BEAUTY 7
	object_event 24, 12, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerPicnicker10, -1 ; Yellow's JR.TRAINER^F 16
	object_event 15,  8, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerBeauty11, -1 ; Yellow's BEAUTY 8
