; Kanto hack (M6 9v, docs/M6-CELADON.md D45): Yellow's GAME CORNER PRIZE ROOM.
; Three counters, Yellow's prize lists at Yellow's prices and levels, on
; Crystal's own prize-vendor engine.  Prices/levels are
; vendor/pokeyellow/data/events/prizes.asm and prize_mon_levels.asm verbatim;
; Crystal's Gen 2 list (TM32/TM29/TM15, PIKACHU/PORYGON/LARVITAR) is gone.
DEF CELADONGAMECORNERPRIZEROOM_ABRA_COINS        EQU 230
DEF CELADONGAMECORNERPRIZEROOM_VULPIX_COINS      EQU 1000
DEF CELADONGAMECORNERPRIZEROOM_WIGGLYTUFF_COINS  EQU 2680
DEF CELADONGAMECORNERPRIZEROOM_SCYTHER_COINS     EQU 6500
DEF CELADONGAMECORNERPRIZEROOM_PINSIR_COINS      EQU 6500
DEF CELADONGAMECORNERPRIZEROOM_PORYGON_COINS     EQU 9999
DEF CELADONGAMECORNERPRIZEROOM_DRAGON_RAGE_COINS EQU 3300
DEF CELADONGAMECORNERPRIZEROOM_HYPER_BEAM_COINS  EQU 5500
DEF CELADONGAMECORNERPRIZEROOM_SUBSTITUTE_COINS  EQU 7700

DEF CELADONGAMECORNERPRIZEROOM_ABRA_LEVEL        EQU 15
DEF CELADONGAMECORNERPRIZEROOM_VULPIX_LEVEL      EQU 18
DEF CELADONGAMECORNERPRIZEROOM_WIGGLYTUFF_LEVEL  EQU 22
DEF CELADONGAMECORNERPRIZEROOM_SCYTHER_LEVEL     EQU 30
DEF CELADONGAMECORNERPRIZEROOM_PINSIR_LEVEL      EQU 30
DEF CELADONGAMECORNERPRIZEROOM_PORYGON_LEVEL     EQU 26

	object_const_def
	const CELADONGAMECORNERPRIZEROOM_GRAMPS
	const CELADONGAMECORNERPRIZEROOM_GENTLEMAN

CeladonGameCornerPrizeRoom_MapScripts:
	def_scene_scripts

	def_callbacks

CeladonGameCornerPrizeRoomGrampsScript:
	jumptextfaceplayer CeladonGameCornerPrizeRoomGrampsText

CeladonGameCornerPrizeRoomGentlemanScript:
	jumptextfaceplayer CeladonGameCornerPrizeRoomGentlemanText

; Yellow's PrizeDifferentMenuPtrs order: the left counter is mon menu 1, the
; middle one mon menu 2, the right one the TMs.  Yellow checks for the COIN CASE
; before it says anything, asks for confirmation before it checks the coins, and
; closes after a single purchase -- no menu loop.  Crystal's prize vendor also
; runs `special GameCornerPrizeMonCheckDex`, which shows the #dex entry; Yellow's
; SetPokedexOwnedFlag only sets the flag (and `givepoke` sets it for us), so the
; entry screen is dropped.
CeladonGameCornerPrizeRoomMonVendor1:
	opentext
	checkitem COIN_CASE
	iffalse CeladonPrizeRoom_NoCoinCase
	writetext CeladonPrizeRoom_ExchangeCoinsText
	waitbutton
	writetext CeladonPrizeRoom_WhichPrizeText
	special DisplayCoinCaseBalance
	loadmenu .MenuHeader
	verticalmenu
	closewindow
	ifequal 1, .Abra
	ifequal 2, .Vulpix
	ifequal 3, .Wigglytuff
	sjump CeladonPrizeRoom_nothanks

.Abra:
	getmonname STRING_BUFFER_3, ABRA
	scall CeladonPrizeRoom_askbuy
	iffalse CeladonPrizeRoom_declined
	checkcoins CELADONGAMECORNERPRIZEROOM_ABRA_COINS
	ifequal HAVE_LESS, CeladonPrizeRoom_notenoughcoins
	scall CeladonPrizeRoom_gotprize
	givepoke ABRA, CELADONGAMECORNERPRIZEROOM_ABRA_LEVEL
	ifequal 2, CeladonPrizeRoom_notenoughroom
	takecoins CELADONGAMECORNERPRIZEROOM_ABRA_COINS
	closetext
	end

.Vulpix:
	getmonname STRING_BUFFER_3, VULPIX
	scall CeladonPrizeRoom_askbuy
	iffalse CeladonPrizeRoom_declined
	checkcoins CELADONGAMECORNERPRIZEROOM_VULPIX_COINS
	ifequal HAVE_LESS, CeladonPrizeRoom_notenoughcoins
	scall CeladonPrizeRoom_gotprize
	givepoke VULPIX, CELADONGAMECORNERPRIZEROOM_VULPIX_LEVEL
	ifequal 2, CeladonPrizeRoom_notenoughroom
	takecoins CELADONGAMECORNERPRIZEROOM_VULPIX_COINS
	closetext
	end

.Wigglytuff:
	getmonname STRING_BUFFER_3, WIGGLYTUFF
	scall CeladonPrizeRoom_askbuy
	iffalse CeladonPrizeRoom_declined
	checkcoins CELADONGAMECORNERPRIZEROOM_WIGGLYTUFF_COINS
	ifequal HAVE_LESS, CeladonPrizeRoom_notenoughcoins
	scall CeladonPrizeRoom_gotprize
	givepoke WIGGLYTUFF, CELADONGAMECORNERPRIZEROOM_WIGGLYTUFF_LEVEL
	ifequal 2, CeladonPrizeRoom_notenoughroom
	takecoins CELADONGAMECORNERPRIZEROOM_WIGGLYTUFF_COINS
	closetext
	end

.MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 2, 17, TEXTBOX_Y - 1
	dw .MenuData
	db 1 ; default option

.MenuData:
	db STATICMENU_CURSOR ; flags
	db 4 ; items
	db "ABRA        {d:CELADONGAMECORNERPRIZEROOM_ABRA_COINS}@"
	db "VULPIX     {d:CELADONGAMECORNERPRIZEROOM_VULPIX_COINS}@"
	db "WIGGLYTUFF {d:CELADONGAMECORNERPRIZEROOM_WIGGLYTUFF_COINS}@"
	db "NO THANKS@"

CeladonGameCornerPrizeRoomMonVendor2:
	opentext
	checkitem COIN_CASE
	iffalse CeladonPrizeRoom_NoCoinCase
	writetext CeladonPrizeRoom_ExchangeCoinsText
	waitbutton
	writetext CeladonPrizeRoom_WhichPrizeText
	special DisplayCoinCaseBalance
	loadmenu .MenuHeader
	verticalmenu
	closewindow
	ifequal 1, .Scyther
	ifequal 2, .Pinsir
	ifequal 3, .Porygon
	sjump CeladonPrizeRoom_nothanks

.Scyther:
	getmonname STRING_BUFFER_3, SCYTHER
	scall CeladonPrizeRoom_askbuy
	iffalse CeladonPrizeRoom_declined
	checkcoins CELADONGAMECORNERPRIZEROOM_SCYTHER_COINS
	ifequal HAVE_LESS, CeladonPrizeRoom_notenoughcoins
	scall CeladonPrizeRoom_gotprize
	givepoke SCYTHER, CELADONGAMECORNERPRIZEROOM_SCYTHER_LEVEL
	ifequal 2, CeladonPrizeRoom_notenoughroom
	takecoins CELADONGAMECORNERPRIZEROOM_SCYTHER_COINS
	closetext
	end

.Pinsir:
	getmonname STRING_BUFFER_3, PINSIR
	scall CeladonPrizeRoom_askbuy
	iffalse CeladonPrizeRoom_declined
	checkcoins CELADONGAMECORNERPRIZEROOM_PINSIR_COINS
	ifequal HAVE_LESS, CeladonPrizeRoom_notenoughcoins
	scall CeladonPrizeRoom_gotprize
	givepoke PINSIR, CELADONGAMECORNERPRIZEROOM_PINSIR_LEVEL
	ifequal 2, CeladonPrizeRoom_notenoughroom
	takecoins CELADONGAMECORNERPRIZEROOM_PINSIR_COINS
	closetext
	end

.Porygon:
	getmonname STRING_BUFFER_3, PORYGON
	scall CeladonPrizeRoom_askbuy
	iffalse CeladonPrizeRoom_declined
	checkcoins CELADONGAMECORNERPRIZEROOM_PORYGON_COINS
	ifequal HAVE_LESS, CeladonPrizeRoom_notenoughcoins
	scall CeladonPrizeRoom_gotprize
	givepoke PORYGON, CELADONGAMECORNERPRIZEROOM_PORYGON_LEVEL
	ifequal 2, CeladonPrizeRoom_notenoughroom
	takecoins CELADONGAMECORNERPRIZEROOM_PORYGON_COINS
	closetext
	end

.MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 2, 17, TEXTBOX_Y - 1
	dw .MenuData
	db 1 ; default option

.MenuData:
	db STATICMENU_CURSOR ; flags
	db 4 ; items
	db "SCYTHER    {d:CELADONGAMECORNERPRIZEROOM_SCYTHER_COINS}@"
	db "PINSIR     {d:CELADONGAMECORNERPRIZEROOM_PINSIR_COINS}@"
	db "PORYGON    {d:CELADONGAMECORNERPRIZEROOM_PORYGON_COINS}@"
	db "NO THANKS@"

CeladonGameCornerPrizeRoomTMVendor:
	opentext
	checkitem COIN_CASE
	iffalse CeladonPrizeRoom_NoCoinCase
	writetext CeladonPrizeRoom_ExchangeCoinsText
	waitbutton
	writetext CeladonPrizeRoom_WhichPrizeText
	special DisplayCoinCaseBalance
	loadmenu .MenuHeader
	verticalmenu
	closewindow
	ifequal 1, .DragonRage
	ifequal 2, .HyperBeam
	ifequal 3, .Substitute
	sjump CeladonPrizeRoom_nothanks

.DragonRage:
	getitemname STRING_BUFFER_3, TM_DRAGON_RAGE
	scall CeladonPrizeRoom_askbuy
	iffalse CeladonPrizeRoom_declined
	checkcoins CELADONGAMECORNERPRIZEROOM_DRAGON_RAGE_COINS
	ifequal HAVE_LESS, CeladonPrizeRoom_notenoughcoins
	giveitem TM_DRAGON_RAGE
	iffalse CeladonPrizeRoom_notenoughroom
	takecoins CELADONGAMECORNERPRIZEROOM_DRAGON_RAGE_COINS
	sjump CeladonPrizeRoom_paid

.HyperBeam:
	getitemname STRING_BUFFER_3, TM_HYPER_BEAM
	scall CeladonPrizeRoom_askbuy
	iffalse CeladonPrizeRoom_declined
	checkcoins CELADONGAMECORNERPRIZEROOM_HYPER_BEAM_COINS
	ifequal HAVE_LESS, CeladonPrizeRoom_notenoughcoins
	giveitem TM_HYPER_BEAM
	iffalse CeladonPrizeRoom_notenoughroom
	takecoins CELADONGAMECORNERPRIZEROOM_HYPER_BEAM_COINS
	sjump CeladonPrizeRoom_paid

.Substitute:
	getitemname STRING_BUFFER_3, TM_SUBSTITUTE
	scall CeladonPrizeRoom_askbuy
	iffalse CeladonPrizeRoom_declined
	checkcoins CELADONGAMECORNERPRIZEROOM_SUBSTITUTE_COINS
	ifequal HAVE_LESS, CeladonPrizeRoom_notenoughcoins
	giveitem TM_SUBSTITUTE
	iffalse CeladonPrizeRoom_notenoughroom
	takecoins CELADONGAMECORNERPRIZEROOM_SUBSTITUTE_COINS
	sjump CeladonPrizeRoom_paid

.MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 2, 15, TEXTBOX_Y - 1
	dw .MenuData
	db 1 ; default option

.MenuData:
	db STATICMENU_CURSOR ; flags
	db 4 ; items
	db "TM{d:DRAGON_RAGE_TMNUM}    {d:CELADONGAMECORNERPRIZEROOM_DRAGON_RAGE_COINS}@"
	db "TM{d:HYPER_BEAM_TMNUM}    {d:CELADONGAMECORNERPRIZEROOM_HYPER_BEAM_COINS}@"
	db "TM{d:SUBSTITUTE_TMNUM}    {d:CELADONGAMECORNERPRIZEROOM_SUBSTITUTE_COINS}@"
	db "NO THANKS@"

CeladonPrizeRoom_askbuy:
	writetext CeladonPrizeRoom_SoYouWantText
	yesorno
	end

CeladonPrizeRoom_gotprize:
	waitsfx
	playsound SFX_TRANSACTION
	writetext CeladonPrizeRoom_GotPrizeText
	waitbutton
	end

CeladonPrizeRoom_paid:
	waitsfx
	playsound SFX_TRANSACTION
	closetext
	end

; Yellow asks for confirmation first and only then counts the coins.
CeladonPrizeRoom_notenoughcoins:
	writetext CeladonPrizeRoom_NeedMoreCoinsText
	waitbutton
	closetext
	end

CeladonPrizeRoom_notenoughroom:
	writetext CeladonPrizeRoom_NoRoomText
	waitbutton
	closetext
	end

CeladonPrizeRoom_declined:
	writetext CeladonPrizeRoom_OhFineThenText
	waitbutton
	closetext
	end

; "NO THANKS" and B close the counter without a word, as Yellow's do.
CeladonPrizeRoom_nothanks:
	closetext
	end

CeladonPrizeRoom_NoCoinCase:
	writetext CeladonPrizeRoom_RequireCoinCaseText
	waitbutton
	closetext
	end

CeladonGameCornerPrizeRoomGrampsText:
	text "I sure do fancy"
	line "that PORYGON!"

	para "But, it's hard to"
	line "win at slots!"
	done

CeladonGameCornerPrizeRoomGentlemanText:
	text "I had a major"
	line "haul today!"
	done

CeladonPrizeRoom_ExchangeCoinsText:
	text "We exchange your"
	line "coins for prizes."
	done

CeladonPrizeRoom_WhichPrizeText:
	text "Which prize do"
	line "you want?"
	done

CeladonPrizeRoom_SoYouWantText:
	text "So, you want"
	line "@"
	text_ram wStringBuffer3
	text "?"
	done

CeladonPrizeRoom_GotPrizeText:
	text "<PLAYER> got"
	line "@"
	text_ram wStringBuffer3
	text "!"
	done

CeladonPrizeRoom_NeedMoreCoinsText:
	text "Sorry, you need"
	line "more coins."
	done

CeladonPrizeRoom_NoRoomText:
	text "Oops! You don't"
	line "have enough room."
	done

CeladonPrizeRoom_OhFineThenText:
	text "Oh, fine then."
	done

CeladonPrizeRoom_RequireCoinCaseText:
	text "A COIN CASE is"
	line "required!"
	done

CeladonGameCornerPrizeRoom_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4,  7, CELADON_CITY, 10 ; Kanto hack (M6 9p): Yellow's city warp 10
	warp_event  5,  7, CELADON_CITY, 10

	def_coord_events

	def_bg_events
	bg_event  2,  2, BGEVENT_READ, CeladonGameCornerPrizeRoomMonVendor1
	bg_event  4,  2, BGEVENT_READ, CeladonGameCornerPrizeRoomMonVendor2
	bg_event  6,  2, BGEVENT_READ, CeladonGameCornerPrizeRoomTMVendor

	def_object_events
	object_event  1,  4, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, CeladonGameCornerPrizeRoomGrampsScript, -1
	object_event  7,  3, SPRITE_GENTLEMAN, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonGameCornerPrizeRoomGentlemanScript, -1
