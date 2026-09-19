; Kanto hack: Yellow's ROUTE_7_GATE (M5 8k), cloned from the shipped
; Route8SaffronGate.asm (M5 8j).  Yellow's gate has exactly one object, the
; SAFFRON guard, who will not let you through to SAFFRON CITY until he has been
; given a drink (vendor/pokeyellow/scripts/Route7Gate.asm +
; engine/events/saffron_guards.asm).  Yellow checks wStatusFlags1's
; BIT_GAVE_SAFFRON_GUARDS_DRINK; ours is EVENT_GAVE_SAFFRON_GUARDS_DRINK,
; shared by every SAFFRON gate exactly as Yellow's bit is -- 0 new event flags.
;
; Deleted with this rewrite: the placeholder guard who lectured about the POWER
; PLANT accident and demanded a #DEX (`EVENT_RETURNED_MACHINE_PART`), and both
; of his texts.  Yellow's ROUTE 7 guard says none of that.
;
; Yellow's own geometry, mirrored from the ROUTE 8 hut: the guard stands at
; (3,1) facing DOWN and the trigger is the two-tile COLUMN (3,3)/(3,4) --
; Yellow's `dbmapcoord 3,3 / 3,4`, x then y, NOT a pair on the guard's row.
; Yellow faces the player UP into the guard (PLAYER_DIR_UP) and pushes back
; with PAD_LEFT, i.e. WEST, away from SAFFRON.  (The ROUTE 8 hut is the mirror
; image: guard at x=2, push east.)
;
; Both doors are on ROUTE 7 -- the west pair at (11,9)/(11,10) and the east
; pair at (18,9)/(18,10).  SAFFRON CITY is reached by walking off ROUTE 7's
; east edge (`connection east, SaffronCity`), never through a warp, so the
; east door is not a placeholder: it is Yellow's geometry.  The 18-tile strip
; (18..19, 2..10) it lands in is reachable ONLY through this hut until M6
; re-cuts SAFFRON CITY.
	object_const_def
	const ROUTE7SAFFRONGATE_OFFICER

Route7SaffronGate_MapScripts:
	def_scene_scripts

	def_callbacks

Route7SaffronGateBlockScript:
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
	writetext Route7SaffronGateGuardGeeImThirstyText
	waitbutton
	closetext
	applymovement PLAYER, Route7SaffronGateStepBackMovement
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
	writetext Route7SaffronGateGuardImParchedText
	promptbutton
	playsound SFX_KEY_ITEM
	waitsfx
	writetext Route7SaffronGateGuardYouCanGoOnThroughText
	waitbutton
	closetext
	setevent EVENT_GAVE_SAFFRON_GUARDS_DRINK
	end

Route7SaffronGateGuardScript:
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
	writetext Route7SaffronGateGuardGeeImThirstyText
	waitbutton
	closetext
	end

.Thanks:
	writetext Route7SaffronGateGuardThanksForTheDrinkText
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
	writetext Route7SaffronGateGuardImParchedText
	promptbutton
	playsound SFX_KEY_ITEM
	waitsfx
	writetext Route7SaffronGateGuardYouCanGoOnThroughText
	waitbutton
	closetext
	setevent EVENT_GAVE_SAFFRON_GUARDS_DRINK
	end

Route7SaffronGateStepBackMovement:
	step LEFT
	step_end

Route7SaffronGateGuardGeeImThirstyText:
	text "I'm on guard duty."
	line "Gee, I'm thirsty,"
	cont "though!"

	para "Oh, wait there,"
	line "the road's closed."
	done

Route7SaffronGateGuardImParchedText:
	text "Whoa, boy!"
	line "I'm parched!"
	cont "…"
	cont "Huh? I can have"
	cont "this drink?"
	cont "Gee, thanks!"
	prompt

Route7SaffronGateGuardYouCanGoOnThroughText:
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

Route7SaffronGateGuardThanksForTheDrinkText:
	text "Hi, thanks for"
	line "the cool drinks!"
	done

Route7SaffronGate_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; ROUTE_7 warp order is Yellow's: 1 (18,9), 2 (18,10), 3 (11,9), 4 (11,10).
; Yellow sends both west tiles to LAST_MAP warp 4 and both east tiles to warp
; 2, i.e. always the LOWER route tile; we exit on the tile you came in by, the
; deviation 8j already shipped for ROUTE 8.
	warp_event  0,  3, ROUTE_7, 3
	warp_event  0,  4, ROUTE_7, 4
	warp_event  5,  3, ROUTE_7, 1
	warp_event  5,  4, ROUTE_7, 2

	def_coord_events
	coord_event  3,  3, -1, Route7SaffronGateBlockScript
	coord_event  3,  4, -1, Route7SaffronGateBlockScript

	def_bg_events

	def_object_events
	object_event  3,  1, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route7SaffronGateGuardScript, -1
