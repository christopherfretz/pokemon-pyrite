	object_const_def
	const ROUTE11GATE2F_YOUNGSTER
	const ROUTE11GATE2F_OAKS_AIDE

; Kanto hack: Yellow's ROUTE_11_GATE_2F (docs/M4-VERMILION.md, 7l).  Yellow has
; two NPCs and the two binoculars:
;   (4,2) YOUNGSTER, WALK LEFT_RIGHT -- the in-game trade TRADE_FOR_GURIO
;         (LICKITUNG for DUGTRIO), ported as NPC_TRADE_GURIO.
;   (2,6) SCIENTIST, STAY          -- PROF.OAK's AIDE, hands over the
;         ITEMFINDER once the POKeDEX shows 30 owned species.  Yellow's
;         `predef OaksAideScript` is inlined as a normal GSC script, the M2
;         Route 2 gate precedent (hack/maps/Route2Gate.asm): VAR_DEXCAUGHT is
;         GSC's CountSetBits over wPokedexCaught and it leaves the count in
;         wStringBuffer2 for text_decimal.
;   (1,2)/(6,2) binoculars.  The left pair reads the SNORLAX on ROUTE 12; the
;         flag is EVENT_BEAT_ROUTE_12_SNORLAX (appended in 7l -- Crystal's
;         EVENT_FOUGHT_SNORLAX is still live in VictoryRoadGate and
;         irwin_gossip, so it could not be renamed in place).
DEF ROUTE11GATE2F_ITEMFINDER_DEX_REQUIREMENT EQU 30

Route11Gate2F_MapScripts:
	def_scene_scripts

	def_callbacks

Route11Gate2FYoungsterScript:
	faceplayer
	opentext
	trade NPC_TRADE_GURIO
	waitbutton
	closetext
	end

Route11Gate2FOaksAideScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_ITEMFINDER
	iftrue .GotItemfinder
	writetext Route11Gate2FOaksAideHiText
	yesorno
	iffalse .ComeBack
	readvar VAR_DEXCAUGHT
	ifless ROUTE11GATE2F_ITEMFINDER_DEX_REQUIREMENT, .NotEnough
	writetext Route11Gate2FOaksAideHereYouGoText
	promptbutton
	verbosegiveitem ITEMFINDER
	iffalse .Done
	setevent EVENT_GOT_ITEMFINDER
.GotItemfinder:
	writetext Route11Gate2FOaksAideItemfinderDescriptionText
	waitbutton
.Done:
	closetext
	end

.NotEnough:
	writetext Route11Gate2FOaksAideUhOhText
	waitbutton
	closetext
	end

.ComeBack:
	writetext Route11Gate2FOaksAideComeBackText
	waitbutton
	closetext
	end

Route11Gate2FLeftBinocularsScript:
	opentext
	checkevent EVENT_BEAT_ROUTE_12_SNORLAX
	iftrue .NoSnorlax
	writetext Route11Gate2FLeftBinocularsSnorlaxText
	waitbutton
	closetext
	end

.NoSnorlax:
	writetext Route11Gate2FLeftBinocularsNoSnorlaxText
	waitbutton
	closetext
	end

Route11Gate2FRightBinocularsScript:
	jumptext Route11Gate2FRightBinocularsText

Route11Gate2FOaksAideHiText:
	text "Hi! Remember me?"
	line "I'm PROF.OAK's"
	cont "AIDE!"

	para "If you caught 30"
	line "kinds of #MON,"
	cont "I'm supposed to"
	cont "give you an"
	cont "ITEMFINDER!"

	para "So, <PLAYER>! Have"
	line "you caught at"
	cont "least 30 kinds of"
	cont "#MON?"
	done

Route11Gate2FOaksAideUhOhText:
	text "Let's see…"
	line "Uh-oh! You have"
	cont "caught only @"
	text_decimal wStringBuffer2, 1, 3
	text_start
	cont "kinds of #MON!"

	para "You need 30 kinds"
	line "if you want the"
	cont "ITEMFINDER."
	done

Route11Gate2FOaksAideComeBackText:
	text "Oh. I see."

	para "When you get 30"
	line "kinds, come back"
	cont "for ITEMFINDER."
	done

Route11Gate2FOaksAideHereYouGoText:
	text "Great! You have"
	line "caught @"
	text_decimal wStringBuffer2, 1, 3
	text " kinds "
	cont "of #MON!"
	cont "Congratulations!"

	para "Here you go!"
	done

Route11Gate2FOaksAideItemfinderDescriptionText:
	text "There are items on"
	line "the ground that"
	cont "can't be seen."

	para "ITEMFINDER will"
	line "detect an item"
	cont "close to you."

	para "It can't pinpoint"
	line "it, so you have"
	cont "to look yourself!"
	done

Route11Gate2FLeftBinocularsSnorlaxText:
	text "Looked into the"
	line "binoculars."

	para "A big #MON is"
	line "asleep on a road!"
	done

Route11Gate2FLeftBinocularsNoSnorlaxText:
	text "Looked into the"
	line "binoculars."

	para "It's a beautiful"
	line "view!"
	done

Route11Gate2FRightBinocularsText:
	text "Looked into the"
	line "binoculars."

	para "The only way to"
	line "get from CERULEAN"
	cont "CITY to LAVENDER"
	cont "is by way of the"
	cont "ROCK TUNNEL."
	done

Route11Gate2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  7,  7, ROUTE_11_GATE_1F, 5

	def_coord_events

	def_bg_events
	bg_event  1,  2, BGEVENT_READ, Route11Gate2FLeftBinocularsScript
	bg_event  6,  2, BGEVENT_READ, Route11Gate2FRightBinocularsScript

	def_object_events
	object_event  4,  2, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route11Gate2FYoungsterScript, -1
	object_event  2,  6, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route11Gate2FOaksAideScript, -1
