; Kanto hack (M6 9p, docs/M6-CELADON.md): CELADON CITY re-cut to Yellow's
; 25x18 map.  Warps, signs and NPCs are Yellow's, at Yellow's coordinates and
; in Yellow's order (vendor/pokeyellow/data/maps/objects/CeladonCity.asm);
; every Crystal-only object and text is gone.

	object_const_def
	const CELADONCITY_LITTLE_GIRL
	const CELADONCITY_GRAMPS1
	const CELADONCITY_GIRL
	const CELADONCITY_GRAMPS2
	const CELADONCITY_GRAMPS3
	const CELADONCITY_FISHER
	const CELADONCITY_POLIWRATH
	const CELADONCITY_ROCKET1
	const CELADONCITY_ROCKET2

CeladonCity_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_NEWMAP, CeladonCityFlypointCallback

CeladonCityFlypointCallback:
	setflag ENGINE_FLYPOINT_CELADON
	endcallback

CeladonCityLittleGirlScript:
	jumptextfaceplayer CeladonCityLittleGirlText

CeladonCityGramps1Script:
	jumptextfaceplayer CeladonCityGramps1Text

CeladonCityGirlScript:
	jumptextfaceplayer CeladonCityGirlText

CeladonCityGramps2Script:
	jumptextfaceplayer CeladonCityGramps2Text

; Yellow's TM41 SOFTBOILED gramps (scripts/CeladonCity.asm, CeladonCityGramps3Text).
CeladonCityGramps3Script:
	faceplayer
	opentext
	checkevent EVENT_GOT_TM41_SOFTBOILED
	iftrue .GotTM41
	writetext CeladonCityGramps3Text
	promptbutton
	verbosegiveitem TM_SOFTBOILED
	iffalse .NoRoom
	setevent EVENT_GOT_TM41_SOFTBOILED
	closetext
	end

.GotTM41:
	writetext CeladonCityGramps3TM41ExplanationText
	waitbutton
	closetext
	end

.NoRoom:
	writetext CeladonCityGramps3TM41NoRoomText
	waitbutton
	closetext
	end

CeladonCityFisherScript:
	jumptextfaceplayer CeladonCityFisherText

CeladonCityPoliwrathScript:
	opentext
	writetext CeladonCityPoliwrathText
	cry POLIWRATH
	waitbutton
	closetext
	end

CeladonCityRocket1Script:
	jumptextfaceplayer CeladonCityRocket1Text

CeladonCityRocket2Script:
	jumptextfaceplayer CeladonCityRocket2Text

CeladonCityTrainerTips1:
	jumptext CeladonCityTrainerTips1Text

CeladonCitySign:
	jumptext CeladonCitySignText

CeladonCityPokecenterSign:
	jumpstd PokecenterSignScript

CeladonCityGymSign:
	jumptext CeladonCityGymSignText

CeladonCityMansionSign:
	jumptext CeladonCityMansionSignText

CeladonCityDeptStoreSign:
	jumptext CeladonCityDeptStoreSignText

CeladonCityTrainerTips2:
	jumptext CeladonCityTrainerTips2Text

CeladonCityPrizeExchangeSign:
	jumptext CeladonCityPrizeExchangeSignText

CeladonCityGameCornerSign:
	jumptext CeladonCityGameCornerSignText

CeladonCityHiddenPpUp:
	hiddenitem PP_UP, EVENT_CELADON_CITY_HIDDEN_PP_UP

CeladonCityLittleGirlText:
	text "I got my KOFFING"
	line "from my friend!"

	para "We get along now,"
	line "because I was"
	cont "very nice to it!"
	done

CeladonCityGramps1Text:
	text "Heheh! This GYM"
	line "is great! It's"
	cont "full of women!"
	done

CeladonCityGirlText:
	text "The GAME CORNER"
	line "is bad for our"
	cont "city's image!"
	done

CeladonCityGramps2Text:
	text "Moan! I blew it"
	line "all at the slots!"

	para "I knew I should"
	line "have cashed in my"
	cont "coins for prizes!"
	done

CeladonCityGramps3Text:
	text "Hello, there!"

	para "I've seen you,"
	line "but I never had a"
	cont "chance to talk!"

	para "Here's a gift for"
	line "dropping by!"
	done

CeladonCityGramps3TM41ExplanationText:
	text "TM41 teaches"
	line "SOFTBOILED!"

	para "Only one #MON"
	line "can use it!"

	para "That #MON is"
	line "CHANSEY!"
	done

CeladonCityGramps3TM41NoRoomText:
	text "Oh, your pack is"
	line "full of items!"
	done

CeladonCityFisherText:
	text "This is my trusted"
	line "pal, POLIWRATH!"

	para "It evolved from"
	line "POLIWHIRL when I"
	cont "used WATER STONE!"
	done

CeladonCityPoliwrathText:
	text "POLIWRATH: Ribi"
	line "ribit!"
	done

CeladonCityRocket1Text:
	text "What are you"
	line "staring at?"
	done

CeladonCityRocket2Text:
	text "Keep out of TEAM"
	line "ROCKET's way!"
	done

CeladonCityTrainerTips1Text:
	text "TRAINER TIPS"

	para "X ACCURACY boosts"
	line "the accuracy of"
	cont "techniques!"

	para "DIRE HIT jacks up"
	line "the likelihood of"
	cont "critical hits!"

	para "Get your items at"
	line "CELADON DEPT."
	cont "STORE!"
	done

CeladonCitySignText:
	text "CELADON CITY"
	line "The City of"
	cont "Rainbow Dreams"
	done

CeladonCityGymSignText:
	text "CELADON CITY"
	line "#MON GYM"
	cont "LEADER: ERIKA"

	para "The Nature-Loving"
	line "Princess!"
	done

CeladonCityMansionSignText:
	text "CELADON MANSION"
	done

CeladonCityDeptStoreSignText:
	text "Find what you"
	line "need at CELADON"
	cont "DEPT. STORE!"
	done

CeladonCityTrainerTips2Text:
	text "TRAINER TIPS"

	para "GUARD SPEC."
	line "protects #MON"
	cont "against SPECIAL"
	cont "attacks such as"
	cont "fire and water!"

	para "Get your items at"
	line "CELADON DEPT."
	cont "STORE!"
	done

CeladonCityPrizeExchangeSignText:
	text "Coins exchanged"
	line "for prizes!"
	cont "PRIZE EXCHANGE"
	done

CeladonCityGameCornerSignText:
	text "ROCKET GAME CORNER"
	line "The playground"
	cont "for grownups!"
	done

CeladonCity_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; Yellow's thirteen warp_events, in Yellow's order.  The order is load-bearing:
; every CELADON interior warps back to CELADON_CITY by *index*, so warp 9 -- the
; door to CELADON MART 5F that Yellow itself marks "; inaccessible" and walls in
; -- is kept as a placeholder rather than deleted, which would renumber 10-13.
	warp_event  8, 13, CELADON_DEPT_STORE_1F, 1
	warp_event 10, 13, CELADON_DEPT_STORE_1F, 1 ; Yellow: MART_1F warp 3, its east door; our 1F is Crystal's one-door room until 9q
	warp_event 24,  9, CELADON_MANSION_1F, 1
	warp_event 24,  3, CELADON_MANSION_1F, 3
	warp_event 25,  3, CELADON_MANSION_1F, 3
	warp_event 41,  9, CELADON_POKECENTER_1F, 1
	warp_event 12, 27, CELADON_GYM, 1
	warp_event 28, 19, CELADON_GAME_CORNER, 1
	warp_event 39, 19, CELADON_DEPT_STORE_5F, 1 ; inaccessible (walled in), as in Yellow
	warp_event 33, 19, CELADON_GAME_CORNER_PRIZE_ROOM, 1
	warp_event 31, 27, CELADON_CAFE, 1
	warp_event 35, 27, CELADON_CHIEF_HOUSE, 1
	warp_event 43, 27, CELADON_HOTEL, 1

	def_coord_events

	def_bg_events
	bg_event 27, 15, BGEVENT_READ, CeladonCityTrainerTips1
	bg_event 19, 15, BGEVENT_READ, CeladonCitySign
	bg_event 42,  9, BGEVENT_READ, CeladonCityPokecenterSign
	bg_event 13, 29, BGEVENT_READ, CeladonCityGymSign
	bg_event 21,  9, BGEVENT_READ, CeladonCityMansionSign
	bg_event 12, 13, BGEVENT_READ, CeladonCityDeptStoreSign
	bg_event 39, 21, BGEVENT_READ, CeladonCityTrainerTips2
	bg_event 33, 21, BGEVENT_READ, CeladonCityPrizeExchangeSign
	bg_event 27, 21, BGEVENT_READ, CeladonCityGameCornerSign
	bg_event 48, 15, BGEVENT_ITEM, CeladonCityHiddenPpUp ; Yellow's hidden PP UP (data/events/hidden_events.asm)

	def_object_events
	object_event  8, 17, SPRITE_TWIN, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonCityLittleGirlScript, -1
	object_event 11, 28, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, CeladonCityGramps1Script, -1
	object_event 14, 19, SPRITE_LASS, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 2, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonCityGirlScript, -1
	object_event 25, 22, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, CeladonCityGramps2Script, -1
	object_event 22, 16, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, CeladonCityGramps3Script, -1
	object_event 32, 12, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonCityFisherScript, -1
	object_event 30, 12, SPRITE_POLIWAG, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonCityPoliwrathScript, -1
	object_event 32, 29, SPRITE_ROCKET, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonCityRocket1Script, -1
	object_event 42, 14, SPRITE_ROCKET, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonCityRocket2Script, -1
