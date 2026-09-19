; Kanto hack: Yellow's ROUTE_8_GATE (M5 8j), cloned from Route5SaffronGate.asm
; (docs/M4-VERMILION.md, 7d).  Yellow's gate has exactly one object, the SAFFRON
; guard, who will not let you west to SAFFRON CITY until he has been given a
; drink (vendor/pokeyellow/scripts/Route8Gate.asm + engine/events/saffron_guards.asm).
; Yellow checks wStatusFlags1's BIT_GAVE_SAFFRON_GUARDS_DRINK; ours is
; EVENT_GAVE_SAFFRON_GUARDS_DRINK, shared by every SAFFRON gate exactly as
; Yellow's bit is -- 0 new event flags.
;
; Differences from the ROUTE 5 gate, all of them Yellow's own: this hut is the
; east-west one, so the guard stands at (2,1) facing DOWN behind the counter and
; the trigger is the two-tile column (2,3)/(2,4) -- Yellow's `dbmapcoord 2,3 /
; 2,4`, NOT a pair on the guard's own row.  Yellow faces the player UP into the
; guard (PLAYER_DIR_UP) and pushes back with PAD_RIGHT, i.e. east, away from
; SAFFRON.
;
; Both doors are on ROUTE 8: Yellow reaches SAFFRON by walking off Route 8's
; west edge (connection west, SaffronCity), not through a warp, so the west
; door's pair is not a placeholder -- it is Yellow's geometry.  The west pocket
; (0..1, 8..10) it lands in is reachable ONLY through this hut.
	object_const_def
	const ROUTE8SAFFRONGATE_OFFICER

Route8SaffronGate_MapScripts:
	def_scene_scripts

	def_callbacks

Route8SaffronGateBlockScript:
	checkevent EVENT_GAVE_SAFFRON_GUARDS_DRINK
	iftrue .AlreadyPaid
	turnobject PLAYER, UP ; Yellow sets PLAYER_DIR_UP: you face the guard
	opentext
	checkitem FRESH_WATER
	iftrue .FreshWater
	checkitem SODA_POP
	iftrue .SodaPop
	checkitem LEMONADE
	iftrue .Lemonade
	writetext Route8SaffronGateGuardGeeImThirstyText
	waitbutton
	closetext
	applymovement PLAYER, Route8SaffronGateStepBackMovement
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
	writetext Route8SaffronGateGuardImParchedText
	promptbutton
	playsound SFX_KEY_ITEM
	waitsfx
	writetext Route8SaffronGateGuardYouCanGoOnThroughText
	waitbutton
	closetext
	setevent EVENT_GAVE_SAFFRON_GUARDS_DRINK
	end

Route8SaffronGateGuardScript:
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
	writetext Route8SaffronGateGuardGeeImThirstyText
	waitbutton
	closetext
	end

.Thanks:
	writetext Route8SaffronGateGuardThanksForTheDrinkText
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
	writetext Route8SaffronGateGuardImParchedText
	promptbutton
	playsound SFX_KEY_ITEM
	waitsfx
	writetext Route8SaffronGateGuardYouCanGoOnThroughText
	waitbutton
	closetext
	setevent EVENT_GAVE_SAFFRON_GUARDS_DRINK
	end

Route8SaffronGateStepBackMovement:
	step RIGHT
	step_end

Route8SaffronGateGuardGeeImThirstyText:
	text "I'm on guard duty."
	line "Gee, I'm thirsty,"
	cont "though!"

	para "Oh, wait there,"
	line "the road's closed."
	done

Route8SaffronGateGuardImParchedText:
	text "Whoa, boy!"
	line "I'm parched!"
	cont "…"
	cont "Huh? I can have"
	cont "this drink?"
	cont "Gee, thanks!"
	prompt

Route8SaffronGateGuardYouCanGoOnThroughText:
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

Route8SaffronGateGuardThanksForTheDrinkText:
	text "Hi, thanks for"
	line "the cool drinks!"
	done

Route8SaffronGate_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  0,  3, ROUTE_8, 1
	warp_event  0,  4, ROUTE_8, 2
	warp_event  5,  3, ROUTE_8, 3
	warp_event  5,  4, ROUTE_8, 4

	def_coord_events
	coord_event  2,  3, -1, Route8SaffronGateBlockScript
	coord_event  2,  4, -1, Route8SaffronGateBlockScript

	def_bg_events

	def_object_events
	object_event  2,  1, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route8SaffronGateGuardScript, -1
