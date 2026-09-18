; Kanto hack (L1, docs/AUDIT-KANTO-LEFTOVERS.md 1 / 4.8): Yellow's ROUTE 1 has
; no trainers at all -- it is the tutorial road -- so Crystal's SCHOOLBOY DANNY
; and COOLTRAINERF QUINN are gone, and Yellow's second youngster (the one who
; explains the ledges) takes their place.
	object_const_def
	const ROUTE1_FRUIT_TREE
	const ROUTE1_MART_YOUNGSTER
	const ROUTE1_LEDGE_YOUNGSTER

Route1_MapScripts:
	def_scene_scripts

	def_callbacks

; Yellow's mart youngster with the free POTION (docs/M2-PARCEL.md).
Route1MartYoungsterScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_POTION_SAMPLE
	iftrue .GotSample
	writetext Route1MartYoungsterSampleText
	promptbutton
	verbosegiveitem POTION
	iffalse .NoRoom
	setevent EVENT_GOT_POTION_SAMPLE
.GotSample:
	writetext Route1MartYoungsterPokeBallsText
	waitbutton
	closetext
	end

.NoRoom:
	writetext Route1MartYoungsterNoRoomText
	waitbutton
	closetext
	end

Route1Sign:
	jumptext Route1SignText

Route1FruitTree:
	fruittree FRUITTREE_ROUTE_1

; Yellow's second ROUTE 1 youngster (vendor/pokeyellow/text/Route1.asm:33-45).
Route1LedgeYoungsterScript:
	jumptextfaceplayer Route1LedgeYoungsterText

Route1MartYoungsterSampleText:
	text "Hi! I work at a"
	line "#MON MART."

	para "It's a convenient"
	line "shop, so please"
	cont "visit us in"
	cont "VIRIDIAN CITY."

	para "I know, I'll give"
	line "you a sample!"
	cont "Here you go!"
	done

Route1MartYoungsterPokeBallsText:
	text "We also carry"
	line "# BALLs for"
	cont "catching #MON!"
	done

Route1MartYoungsterNoRoomText:
	text "You have too much"
	line "stuff with you!"
	done

Route1LedgeYoungsterText:
	text "See those ledges"
	line "along the road?"

	para "It's a bit scary,"
	line "but you can jump"
	cont "from them."

	para "You can get back"
	line "to PALLET TOWN"
	cont "quicker that way."
	done

Route1SignText:
	text "ROUTE 1"

	para "PALLET TOWN -"
	line "VIRIDIAN CITY"
	done

Route1_MapEvents:
	db 0, 0 ; filler

	def_warp_events

	def_coord_events

	def_bg_events
	bg_event  7, 27, BGEVENT_READ, Route1Sign

	def_object_events
	object_event  3,  7, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route1FruitTree, -1
	object_event  4, 24, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, Route1MartYoungsterScript, -1
	object_event  9, 11, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route1LedgeYoungsterScript, -1
