; Kanto hack (M6 9r, docs/M6-CELADON.md §3.5): Yellow's CELADON MART ROOF --
; ROOFTOP SQUARE.  The vending machines are Crystal's (rooftop-square art and
; the same three drinks at Yellow's prices); the drink girl is Yellow's, and she
; is the only source of three TMs.  Yellow's roof is NOT on the elevator: the
; only way up is the 5F staircase, so the elevator door and its button are
; walled off by the tile callback below and the warp is gone.

DEF CELADONDEPTSTORE6F_FRESH_WATER_PRICE EQU 200
DEF CELADONDEPTSTORE6F_SODA_POP_PRICE    EQU 300
DEF CELADONDEPTSTORE6F_LEMONADE_PRICE    EQU 350

	object_const_def
	const CELADONDEPTSTORE6F_SUPER_NERD
	const CELADONDEPTSTORE6F_LITTLE_GIRL

CeladonDeptStore6F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_TILES, CeladonDeptStore6FHideRooftopStairsCallback

CeladonDeptStore6FHideRooftopStairsCallback:
; changeblock takes TILE coordinates.  12,0 is Goldenrod's stairs up to its own
; roof; 2,0 is the elevator door plus its call button, which Yellow's roof lacks.
	changeblock 12, 0, $03 ; wall
	changeblock  2, 0, $03 ; wall
	endcallback

CeladonDeptStore6FSuperNerdScript:
	jumptextfaceplayer CeladonDeptStore6FSuperNerdText

CeladonDeptStore6FLittleGirlScript:
; Yellow's CeladonMartRoofScript_GetDrinksInBag builds a menu of just the drinks
; you are carrying (scripts/CeladonMartRoof.asm).  Crystal's verticalmenu needs a
; static list, so the seven possible lists are pre-baked below and the checkitem
; ladder picks one.  FRESH WATER, SODA POP, LEMONADE keep Yellow's order.
	faceplayer
	opentext
	checkitem FRESH_WATER
	iftrue .HasDrink
	checkitem SODA_POP
	iftrue .HasDrink
	checkitem LEMONADE
	iftrue .HasDrink
	writetext CeladonDeptStore6FLittleGirlImThirstyText
	waitbutton
	closetext
	end

.HasDrink:
	writetext CeladonDeptStore6FLittleGirlGiveHerADrinkText
	yesorno
	iffalse .Done
	writetext CeladonDeptStore6FLittleGirlWhichDrinkText
	checkitem FRESH_WATER
	iftrue .MenuWithFreshWater
	checkitem SODA_POP
	iftrue .MenuWithSodaPop
	loadmenu .MenuHeaderL
	verticalmenu
	closewindow
	ifequal 1, .GiveLemonade
	sjump .Done

.MenuWithFreshWater:
	checkitem SODA_POP
	iftrue .MenuWithFreshWaterAndSodaPop
	checkitem LEMONADE
	iftrue .MenuWL
	loadmenu .MenuHeaderW
	sjump .RunFreshWaterFirst

.MenuWithFreshWaterAndSodaPop:
	checkitem LEMONADE
	iftrue .MenuWSL
	loadmenu .MenuHeaderWS
	sjump .RunFreshWaterFirst

.MenuWSL:
	loadmenu .MenuHeaderWSL
	sjump .RunFreshWaterFirst

.MenuWL:
	loadmenu .MenuHeaderWL
	verticalmenu
	closewindow
	ifequal 1, .GiveFreshWater
	ifequal 2, .GiveLemonade
	sjump .Done

.MenuWithSodaPop:
	checkitem LEMONADE
	iftrue .MenuSL
	loadmenu .MenuHeaderS
	sjump .RunSodaPopFirst

.MenuSL:
	loadmenu .MenuHeaderSL
	sjump .RunSodaPopFirst

.RunFreshWaterFirst:
; shared by the W, WS and WSL lists -- a one- or two-entry list can never return
; the index that is missing from it.
	verticalmenu
	closewindow
	ifequal 1, .GiveFreshWater
	ifequal 2, .GiveSodaPop
	ifequal 3, .GiveLemonade
	sjump .Done

.RunSodaPopFirst:
	verticalmenu
	closewindow
	ifequal 1, .GiveSodaPop
	ifequal 2, .GiveLemonade
	sjump .Done

.GiveFreshWater:
	checkevent EVENT_GOT_TM13_ICE_BEAM
	iftrue .NotThirsty
	writetext CeladonDeptStore6FLittleGirlYayFreshWaterText
	promptbutton
	takeitem FRESH_WATER
	verbosegiveitem TM_ICE_BEAM
	iffalse .NoRoom
	setevent EVENT_GOT_TM13_ICE_BEAM
	writetext CeladonDeptStore6FTM87ExplanationText
	waitbutton
	closetext
	end

.GiveSodaPop:
	checkevent EVENT_GOT_TM48_ROCK_SLIDE
	iftrue .NotThirsty
	writetext CeladonDeptStore6FLittleGirlYaySodaPopText
	promptbutton
	takeitem SODA_POP
	verbosegiveitem TM_ROCK_SLIDE
	iffalse .NoRoom
	setevent EVENT_GOT_TM48_ROCK_SLIDE
	writetext CeladonDeptStore6FTM83ExplanationText
	waitbutton
	closetext
	end

.GiveLemonade:
	checkevent EVENT_GOT_TM49_TRI_ATTACK
	iftrue .NotThirsty
	writetext CeladonDeptStore6FLittleGirlYayLemonadeText
	promptbutton
	takeitem LEMONADE
	verbosegiveitem TM_TRI_ATTACK
	iffalse .NoRoom
	setevent EVENT_GOT_TM49_TRI_ATTACK
	writetext CeladonDeptStore6FTM84ExplanationText
	waitbutton
	closetext
	end

.NotThirsty:
; Yellow checks the flag only AFTER the submenu, and does not take the drink.
	writetext CeladonDeptStore6FLittleGirlImNotThirstyText
	waitbutton
	closetext
	end

.NoRoom:
	writetext CeladonDeptStore6FLittleGirlNoRoomText
	waitbutton
	closetext
	end

.Done:
	closetext
	end

.MenuHeaderWSL:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 13, 7
	dw .MenuDataWSL
	db 1 ; default option

.MenuDataWSL:
	db STATICMENU_CURSOR ; flags
	db 3 ; items
	db "FRESH WATER@"
	db "SODA POP@"
	db "LEMONADE@"

.MenuHeaderWS:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 13, 5
	dw .MenuDataWS
	db 1 ; default option

.MenuDataWS:
	db STATICMENU_CURSOR ; flags
	db 2 ; items
	db "FRESH WATER@"
	db "SODA POP@"

.MenuHeaderWL:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 13, 5
	dw .MenuDataWL
	db 1 ; default option

.MenuDataWL:
	db STATICMENU_CURSOR ; flags
	db 2 ; items
	db "FRESH WATER@"
	db "LEMONADE@"

.MenuHeaderSL:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 13, 5
	dw .MenuDataSL
	db 1 ; default option

.MenuDataSL:
	db STATICMENU_CURSOR ; flags
	db 2 ; items
	db "SODA POP@"
	db "LEMONADE@"

.MenuHeaderW:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 13, 3
	dw .MenuDataW
	db 1 ; default option

.MenuDataW:
	db STATICMENU_CURSOR ; flags
	db 1 ; items
	db "FRESH WATER@"

.MenuHeaderS:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 13, 3
	dw .MenuDataS
	db 1 ; default option

.MenuDataS:
	db STATICMENU_CURSOR ; flags
	db 1 ; items
	db "SODA POP@"

.MenuHeaderL:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 13, 3
	dw .MenuDataL
	db 1 ; default option

.MenuDataL:
	db STATICMENU_CURSOR ; flags
	db 1 ; items
	db "LEMONADE@"

CeladonDeptStore6FVendingMachine:
	opentext
	writetext CeladonVendingText
.Start:
	special PlaceMoneyTopRight
	loadmenu .MenuHeader
	verticalmenu
	closewindow
	ifequal 1, .FreshWater
	ifequal 2, .SodaPop
	ifequal 3, .Lemonade
; Yellow: both CANCEL and a B press fall through to `.notThirsty`, which prints
; _VendingMachineText7 before the routine returns
; (vendor/pokeyellow/engine/events/vending_machine.asm).  `verticalmenu` leaves
; 0 here on B and 4 on CANCEL, so anything that is not a drink lands here.
	writetext CeladonVendingNotThirstyText
	waitbutton
	closetext
	end

.FreshWater:
	checkmoney YOUR_MONEY, CELADONDEPTSTORE6F_FRESH_WATER_PRICE
	ifequal HAVE_LESS, .NotEnoughMoney
	giveitem FRESH_WATER
	iffalse .NotEnoughSpace
	takemoney YOUR_MONEY, CELADONDEPTSTORE6F_FRESH_WATER_PRICE
	getitemname STRING_BUFFER_3, FRESH_WATER
	sjump .VendItem

.SodaPop:
	checkmoney YOUR_MONEY, CELADONDEPTSTORE6F_SODA_POP_PRICE
	ifequal HAVE_LESS, .NotEnoughMoney
	giveitem SODA_POP
	iffalse .NotEnoughSpace
	takemoney YOUR_MONEY, CELADONDEPTSTORE6F_SODA_POP_PRICE
	getitemname STRING_BUFFER_3, SODA_POP
	sjump .VendItem

.Lemonade:
	checkmoney YOUR_MONEY, CELADONDEPTSTORE6F_LEMONADE_PRICE
	ifequal HAVE_LESS, .NotEnoughMoney
	giveitem LEMONADE
	iffalse .NotEnoughSpace
	takemoney YOUR_MONEY, CELADONDEPTSTORE6F_LEMONADE_PRICE
	getitemname STRING_BUFFER_3, LEMONADE
	sjump .VendItem

.VendItem:
	pause 10
	playsound SFX_ENTER_DOOR
	writetext CeladonPoppedOutText
	promptbutton
	itemnotify
	sjump .Start

.NotEnoughMoney:
	writetext CeladonVendingNoMoneyText
	waitbutton
	sjump .Start

.NotEnoughSpace:
	writetext CeladonVendingNoSpaceText
	waitbutton
	sjump .Start

.MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 2, SCREEN_WIDTH - 1, TEXTBOX_Y - 1
	dw .MenuData
	db 1 ; default option

.MenuData:
	db STATICMENU_CURSOR ; flags
	db 4 ; items
	db "FRESH WATER  ¥{d:CELADONDEPTSTORE6F_FRESH_WATER_PRICE}@"
	db "SODA POP     ¥{d:CELADONDEPTSTORE6F_SODA_POP_PRICE}@"
	db "LEMONADE     ¥{d:CELADONDEPTSTORE6F_LEMONADE_PRICE}@"
	db "CANCEL@"

CeladonDeptStore6FFloorSign:
	jumptext CeladonDeptStore6FFloorSignText

CeladonVendingText:
	text "A vending machine!"
	line "Here's the menu!"
	done

CeladonPoppedOutText:
	text "@"
	text_ram wStringBuffer3
	text_start
	line "popped out!"
	done

CeladonVendingNoMoneyText:
	text "Oops, not enough"
	line "money!"
	done

CeladonVendingNoSpaceText:
	text "There's no more"
	line "room for stuff!"
	done

CeladonVendingNotThirstyText:
	text "Not thirsty!"
	done

CeladonDeptStore6FSuperNerdText:
	text "My sister is a"
	line "trainer, believe"
	cont "it or not."

	para "But, she's so"
	line "immature, she"
	cont "drives me nuts!"
	done

CeladonDeptStore6FLittleGirlImThirstyText:
	text "I'm thirsty!"
	line "I want something"
	cont "to drink!"
	done

CeladonDeptStore6FLittleGirlGiveHerADrinkText:
	text "I'm thirsty!"
	line "I want something"
	cont "to drink!"

	para "Give her a drink?"
	done

CeladonDeptStore6FLittleGirlWhichDrinkText:
	text "Give her which"
	line "drink?"
	done

CeladonDeptStore6FLittleGirlYayFreshWaterText:
	text "Yay!"

	para "FRESH WATER!"

	para "Thank you!"

	para "You can have this"
	line "from me!"
	done

CeladonDeptStore6FLittleGirlYaySodaPopText:
	text "Yay!"

	para "SODA POP!"

	para "Thank you!"

	para "You can have this"
	line "from me!"
	done

CeladonDeptStore6FLittleGirlYayLemonadeText:
	text "Yay!"

	para "LEMONADE!"

	para "Thank you!"

	para "You can have this"
	line "from me!"
	done

CeladonDeptStore6FTM87ExplanationText:
; Yellow says "TM13"; our TM union numbers ICE BEAM as TM87
; (docs/TM-LEDGER.md, docs/M3B-TM-UNION.md) -- same treatment as Lt. Surge's TM86.
	text "TM87 contains"
	line "ICE BEAM!"

	para "It can freeze the"
	line "target sometimes!"
	done

CeladonDeptStore6FTM83ExplanationText:
; Yellow says "TM48"; ours numbers ROCK SLIDE as TM83.
	text "TM83 contains"
	line "ROCK SLIDE!"
	done

CeladonDeptStore6FTM84ExplanationText:
; Yellow says "TM49"; ours numbers TRI ATTACK as TM84.
	text "TM84 contains"
	line "TRI ATTACK!"
	done

CeladonDeptStore6FLittleGirlNoRoomText:
	text "You don't have"
	line "space for this!"
	done

CeladonDeptStore6FLittleGirlImNotThirstyText:
	text "No thank you!"
	line "I'm not thirsty"
	cont "after all!"
	done

CeladonDeptStore6FFloorSignText:
	text "ROOFTOP SQUARE:"
	line "VENDING MACHINES"
	done

CeladonDeptStore6F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 15,  0, CELADON_DEPT_STORE_5F, 2

	def_coord_events

	def_bg_events
	bg_event 14,  0, BGEVENT_READ, CeladonDeptStore6FFloorSign
	bg_event  8,  1, BGEVENT_UP, CeladonDeptStore6FVendingMachine
	bg_event  9,  1, BGEVENT_UP, CeladonDeptStore6FVendingMachine
	bg_event 10,  1, BGEVENT_UP, CeladonDeptStore6FVendingMachine
	bg_event 11,  1, BGEVENT_UP, CeladonDeptStore6FVendingMachine

	def_object_events
	object_event 10,  4, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore6FSuperNerdScript, -1
	object_event  4,  5, SPRITE_TWIN, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore6FLittleGirlScript, -1
