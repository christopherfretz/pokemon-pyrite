; Kanto hack: Yellow's ROUTE_5_GATE (docs/M4-VERMILION.md, 7d).
; Yellow's gate has exactly one object, the SAFFRON guard, who will not let you
; south to SAFFRON CITY until he has been given a drink (scripts/Route5Gate.asm
; + engine/events/saffron_guards.asm).  Yellow checks wStatusFlags1's
; BIT_GAVE_SAFFRON_GUARDS_DRINK; ours is EVENT_GAVE_SAFFRON_GUARDS_DRINK (the
; renamed EVENT_ROUTE_5_6_POKEFAN_M_BLOCKS_UNDERGROUND_PATH), shared by every
; SAFFRON gate exactly as Yellow's bit is.
; Yellow's guard stands at (1,3) on the west side of a 2-wide corridor and the
; trigger is the whole corridor width, dbmapcoord 3,3 / 4,3.  Crystal's
; NorthSouthGate.blk is 6 tiles wide between the counters, so the faithful
; "whole corridor" band is the six tiles (2..7, 4) -- the guard's row.  The
; guard keeps Crystal's (0,4) niche behind the west counter, which is the same
; side Yellow puts him on.
	object_const_def
	const ROUTE5SAFFRONGATE_OFFICER

Route5SaffronGate_MapScripts:
	def_scene_scripts

	def_callbacks

Route5SaffronGateBlockScript:
	checkevent EVENT_GAVE_SAFFRON_GUARDS_DRINK
	iftrue .AlreadyPaid
	turnobject PLAYER, LEFT ; Yellow sets PLAYER_DIR_LEFT: you face the guard
	opentext
	checkitem FRESH_WATER
	iftrue .FreshWater
	checkitem SODA_POP
	iftrue .SodaPop
	checkitem LEMONADE
	iftrue .Lemonade
	writetext Route5SaffronGateGuardGeeImThirstyText
	waitbutton
	closetext
	applymovement PLAYER, Route5SaffronGateStepBackMovement
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
	writetext Route5SaffronGateGuardImParchedText
	promptbutton
	playsound SFX_KEY_ITEM
	waitsfx
	writetext Route5SaffronGateGuardYouCanGoOnThroughText
	waitbutton
	closetext
	setevent EVENT_GAVE_SAFFRON_GUARDS_DRINK
	end

Route5SaffronGateGuardScript:
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
	writetext Route5SaffronGateGuardGeeImThirstyText
	waitbutton
	closetext
	end

.Thanks:
	writetext Route5SaffronGateGuardThanksForTheDrinkText
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
	writetext Route5SaffronGateGuardImParchedText
	promptbutton
	playsound SFX_KEY_ITEM
	waitsfx
	writetext Route5SaffronGateGuardYouCanGoOnThroughText
	waitbutton
	closetext
	setevent EVENT_GAVE_SAFFRON_GUARDS_DRINK
	end

Route5SaffronGateStepBackMovement:
	step UP
	step_end

Route5SaffronGateGuardGeeImThirstyText:
	text "I'm on guard duty."
	line "Gee, I'm thirsty,"
	cont "though!"

	para "Oh, wait there,"
	line "the road's closed."
	done

Route5SaffronGateGuardImParchedText:
	text "Whoa, boy!"
	line "I'm parched!"
	cont "…"
	cont "Huh? I can have"
	cont "this drink?"
	cont "Gee, thanks!"
	prompt

Route5SaffronGateGuardYouCanGoOnThroughText:
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

Route5SaffronGateGuardThanksForTheDrinkText:
	text "Hi, thanks for"
	line "the cool drinks!"
	done

Route5SaffronGate_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4,  0, ROUTE_5, 2
	warp_event  5,  0, ROUTE_5, 1
	warp_event  4,  7, ROUTE_5, 3
	warp_event  5,  7, ROUTE_5, 3

	def_coord_events
	coord_event  2,  4, -1, Route5SaffronGateBlockScript
	coord_event  3,  4, -1, Route5SaffronGateBlockScript
	coord_event  4,  4, -1, Route5SaffronGateBlockScript
	coord_event  5,  4, -1, Route5SaffronGateBlockScript
	coord_event  6,  4, -1, Route5SaffronGateBlockScript
	coord_event  7,  4, -1, Route5SaffronGateBlockScript

	def_bg_events

	def_object_events
	object_event  0,  4, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route5SaffronGateGuardScript, -1
