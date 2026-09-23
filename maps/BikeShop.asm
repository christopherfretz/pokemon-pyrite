; 6f: Yellow's BIKE_SHOP (vendor/pokeyellow/scripts/BikeShop.asm,
; vendor/pokeyellow/data/maps/objects/BikeShop.asm, text/BikeShop.asm).
; 6a laid in the geometry (reused CERULEAN_TRADE_SPEECH_HOUSE's slot on the
; shared House1 block group) and the two door warps.
;
; Yellow's clerk draws a FAKE shop menu -- a hand-placed TextBoxBorder with the
; strings "BICYCLE / CANCEL" and "¥1000000" -- because no mart list can carry a
; price of a million.  GSC has the same limit and worse: `pokemart` reads every
; price out of ItemAttributes, so a one-item mart would quote BICYCLE's real
; price (0).  The gag is therefore reproduced as plain text plus `yesorno`,
; which is the only deviation from Yellow in this map; the price, the "Sorry!
; You can't afford it!" refusal and the "Come back again sometime!" sign-off are
; all Yellow's, in Yellow's order.
;
; The voucher branch is live but unreachable until M4: BIKE_VOUCHER comes from
; the Vermilion Pokémon Fan Club chairman.  `EVENT_GOT_BICYCLE` is Crystal's own
; flag, reused rather than appended -- its only other reader is Goldenrod's
; clerk (hack/maps/GoldenrodBikeShop.asm), who will simply skip his loaner
; offer once the Kanto bike is in the bag.  Johto's milestone decides whether
; Goldenrod keeps that script at all.
	object_const_def
	const BIKESHOP_CLERK
	const BIKESHOP_MIDDLE_AGED_WOMAN
	const BIKESHOP_YOUNGSTER

BikeShop_MapScripts:
	def_scene_scripts

	def_callbacks

BikeShopClerkScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_BICYCLE
	iftrue .GotBicycle
	checkitem BIKE_VOUCHER
	iftrue .HasVoucher
	writetext BikeShopClerkWelcomeText
	promptbutton
	writetext BikeShopClerkDoYouLikeItText
	yesorno
	iffalse .ComeAgain
	writetext BikeShopCantAffordText
	waitbutton
.ComeAgain:
	writetext BikeShopComeAgainText
	waitbutton
	closetext
	end

.HasVoucher:
	writetext BikeShopClerkOhThatsAVoucherText
	promptbutton
	verbosegiveitem BICYCLE
	iffalse .Done
	takeitem BIKE_VOUCHER
	setevent EVENT_GOT_BICYCLE
	writetext BikeShopExchangedVoucherText
	waitbutton
.Done:
	closetext
	end

.GotBicycle:
	writetext BikeShopClerkHowDoYouLikeYourBicycleText
	waitbutton
	closetext
	end

BikeShopMiddleAgedWomanScript:
	jumptextfaceplayer BikeShopMiddleAgedWomanText

BikeShopYoungsterScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_BICYCLE
	iftrue .GotBike
	writetext BikeShopYoungsterTheseBikesAreExpensiveText
	waitbutton
	closetext
	end

.GotBike:
	writetext BikeShopYoungsterCoolBikeText
	waitbutton
	closetext
	end

BikeShopClerkWelcomeText:
	text "Hi! Welcome to"
	line "our BIKE SHOP."

	para "Have we got just"
	line "the BIKE for you!"
	done

BikeShopClerkDoYouLikeItText:
	text "It's a cool BIKE!"
	line "Do you want it?"

	para "The BICYCLE is"
	line "¥1000000."
	done

BikeShopCantAffordText:
	text "Sorry! You can't"
	line "afford it!"
	done

BikeShopComeAgainText:
	text "Come back again"
	line "sometime!"
	done

BikeShopClerkOhThatsAVoucherText:
	text "Oh, that's…"

	para "A BIKE VOUCHER!"

	para "OK! Here you go!"
	done

BikeShopExchangedVoucherText:
	text "<PLAYER> exchanged"
	line "the BIKE VOUCHER"
	cont "for a BICYCLE."
	done

BikeShopClerkHowDoYouLikeYourBicycleText:
	text "How do you like"
	line "your new BICYCLE?"

	para "You can take it"
	line "on CYCLING ROAD"
	cont "and in caves!"
	done

BikeShopMiddleAgedWomanText:
	text "A plain city BIKE"
	line "is good enough"
	cont "for me!"

	para "You can't put a"
	line "shopping basket"
	cont "on an MTB!"
	done

BikeShopYoungsterTheseBikesAreExpensiveText:
	text "These BIKEs are"
	line "cool, but they're"
	cont "way expensive!"
	done

BikeShopYoungsterCoolBikeText:
	text "Wow. Your BIKE is"
	line "really cool!"
	done

; BG1Q1 + BG2 (docs/BG1-BENCH-AND-SHELVES.md): Yellow's hidden PrintNewBikeText
; (engine/events/hidden_events/new_bike.asm, any facing) on all six of its
; BICYCLE squares (vendor/pokeyellow/data/events/hidden_events.asm BIKE_SHOP).
; BG1 did (2,1), the one that is a std-script TV tile in our room; BG2 adds the
; other five.  Text follows Yellow's square, not our House1 art: (1,2), (3,2),
; (0,4) and (1,5) are plain floor here (bikes, so solid, in Yellow) and read
; when faced from a neighbour; (1,0) is back wall behind the (1,1) bookshelf,
; so no square faces it -- kept for parity, unreachable.
BikeShopBG1Q1NewBicycle:
	jumptext BikeShopBG1Q1NewBicycleText

BikeShopBG1Q1NewBicycleText:
	text "A shiny new"
	line "BICYCLE!"
	done

BikeShop_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, CERULEAN_CITY, 5
	warp_event  3,  7, CERULEAN_CITY, 5

	def_coord_events

	def_bg_events
	bg_event  1,  0, BGEVENT_READ, BikeShopBG1Q1NewBicycle ; BG2 (unreachable: back wall)
	bg_event  2,  1, BGEVENT_READ, BikeShopBG1Q1NewBicycle ; BG1Q1
	bg_event  1,  2, BGEVENT_READ, BikeShopBG1Q1NewBicycle ; BG2
	bg_event  3,  2, BGEVENT_READ, BikeShopBG1Q1NewBicycle ; BG2
	bg_event  0,  4, BGEVENT_READ, BikeShopBG1Q1NewBicycle ; BG2
	bg_event  1,  5, BGEVENT_READ, BikeShopBG1Q1NewBicycle ; BG2

	def_object_events
	object_event  6,  2, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, BikeShopClerkScript, -1
	object_event  5,  6, SPRITE_POKEFAN_F, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, BikeShopMiddleAgedWomanScript, -1
	object_event  1,  3, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, BikeShopYoungsterScript, -1
