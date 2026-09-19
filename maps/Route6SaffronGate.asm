; Kanto hack: Yellow's ROUTE_6_GATE (docs/M4-VERMILION.md, 7d).
; Same SAFFRON guard as ROUTE_5_GATE and the same shared flag
; (EVENT_GAVE_SAFFRON_GUARDS_DRINK, Yellow's BIT_GAVE_SAFFRON_GUARDS_DRINK).
; Yellow's Route6Gate guard stands at (6,2), on the EAST side of the corridor,
; facing LEFT, and the trigger is dbmapcoord 3,2 / 4,2 -- the guard's row, the
; full corridor width -- pushing the player back DOWN (south, to VERMILION).
; Ours is Yellow's exactly: guard at (6,2) facing LEFT, band on (3,2)/(4,2).
; (An earlier draft put the guard in Crystal's (9,4) niche behind the east
; counter with a six-tile band; that plan was dropped before 7d shipped.)
; Crystal's MAGNET TRAIN / POWER PLANT guard text is a Gen 2 anachronism and is
; deleted, along with the unusable scene_script.
	object_const_def
	const ROUTE6SAFFRONGATE_OFFICER

Route6SaffronGate_MapScripts:
	def_scene_scripts

	def_callbacks

Route6SaffronGateBlockScript:
	checkevent EVENT_GAVE_SAFFRON_GUARDS_DRINK
	iftrue .AlreadyPaid
	turnobject PLAYER, RIGHT ; Yellow sets PLAYER_DIR_RIGHT: you face the guard
	opentext
	checkitem FRESH_WATER
	iftrue .FreshWater
	checkitem SODA_POP
	iftrue .SodaPop
	checkitem LEMONADE
	iftrue .Lemonade
	writetext Route6SaffronGateGuardGeeImThirstyText
	waitbutton
	closetext
	applymovement PLAYER, Route6SaffronGateStepBackMovement
.AlreadyPaid:
	end

.FreshWater:
	takeitem FRESH_WATER
	sjump .GiveDrink

.SodaPop:
	takeitem SODA_POP
	sjump .GiveDrink

.Lemonade:
	takeitem LEMONADE
.GiveDrink:
	writetext Route6SaffronGateGuardImParchedText
	promptbutton
	playsound SFX_KEY_ITEM
	waitsfx
	writetext Route6SaffronGateGuardYouCanGoOnThroughText
	waitbutton
	closetext
	setevent EVENT_GAVE_SAFFRON_GUARDS_DRINK
	end

Route6SaffronGateGuardScript:
	faceplayer
	opentext
	checkevent EVENT_GAVE_SAFFRON_GUARDS_DRINK
	iftrue .Thanks
	checkitem FRESH_WATER
	iftrue .FreshWater
	checkitem SODA_POP
	iftrue .SodaPop
	checkitem LEMONADE
	iftrue .Lemonade
	writetext Route6SaffronGateGuardGeeImThirstyText
	waitbutton
	closetext
	end

.Thanks:
	writetext Route6SaffronGateGuardThanksForTheDrinkText
	waitbutton
	closetext
	end

.FreshWater:
	takeitem FRESH_WATER
	sjump .GiveDrink

.SodaPop:
	takeitem SODA_POP
	sjump .GiveDrink

.Lemonade:
	takeitem LEMONADE
.GiveDrink:
	writetext Route6SaffronGateGuardImParchedText
	promptbutton
	playsound SFX_KEY_ITEM
	waitsfx
	writetext Route6SaffronGateGuardYouCanGoOnThroughText
	waitbutton
	closetext
	setevent EVENT_GAVE_SAFFRON_GUARDS_DRINK
	end

Route6SaffronGateStepBackMovement:
	step DOWN
	step_end

Route6SaffronGateGuardGeeImThirstyText:
	text "I'm on guard duty."
	line "Gee, I'm thirsty,"
	cont "though!"

	para "Oh, wait there,"
	line "the road's closed."
	done

Route6SaffronGateGuardImParchedText:
	text "Whoa, boy!"
	line "I'm parched!"
	cont "…"
	cont "Huh? I can have"
	cont "this drink?"
	cont "Gee, thanks!"
	prompt

Route6SaffronGateGuardYouCanGoOnThroughText:
	text "…"
	line "Glug, glug…"
	cont "…"
	cont "Gulp…"
	cont "If you want to go"
	cont "to SAFFRON CITY…"
	cont "…"
	cont "You can go on"
	cont "through. I'll"
	cont "share this with"
	cont "the other guards!"
	done

Route6SaffronGateGuardThanksForTheDrinkText:
	text "Hi, thanks for"
	line "the cool drinks!"
	done

Route6SaffronGate_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  0, ROUTE_6, 2
	warp_event  4,  0, ROUTE_6, 2
	warp_event  3,  5, ROUTE_6, 3
	warp_event  4,  5, ROUTE_6, 3

	def_coord_events
	coord_event  3,  2, -1, Route6SaffronGateBlockScript
	coord_event  4,  2, -1, Route6SaffronGateBlockScript

	def_bg_events

	def_object_events
	object_event  6,  2, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route6SaffronGateGuardScript, -1
