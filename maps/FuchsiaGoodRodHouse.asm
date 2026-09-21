; Kanto hack: Yellow's GOOD ROD house (docs/M7-FUCHSIA.md 10g).  The FISHING
; GURU's older brother hands out the GOOD ROD once, with Yellow's lines verbatim
; (vendor/pokeyellow/{data/maps/objects,text}/FuchsiaGoodRodHouse.asm).  The
; give follows Crystal's own OlivineGoodRodHouse shape and reuses
; EVENT_GOT_GOOD_ROD, so the two brothers can never both arm the player.
;
; The room is Yellow's .blk byte for byte on Crystal's SHIP tileset, which is a
; byte-identical port of Yellow's SHIP blockset: block $09's top-left LADDER is
; the back door at (2,0) that FUCHSIA CITY's warp 9 needs, and block $1b puts
; the front door at (2,7)/(3,7).  (10f parked the map on House1Hole.blk to keep
; the city buildable; that placeholder is retired here.)
	object_const_def
	const FUCHSIAGOODRODHOUSE_FISHING_GURU

FuchsiaGoodRodHouse_MapScripts:
	def_scene_scripts

	def_callbacks

FuchsiaGoodRodHouseGuruScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_GOOD_ROD
	iftrue .AlreadyGotGoodRod
	writetext FuchsiaGoodRodHouseOfferText
	yesorno
	iffalse .DontWantIt
	writetext FuchsiaGoodRodHouseGiveText
	promptbutton
	verbosegiveitem GOOD_ROD
	iffalse .NoRoom
	setevent EVENT_GOT_GOOD_ROD
	closetext
	end

.DontWantIt:
	writetext FuchsiaGoodRodHouseRefusedText
	waitbutton
	closetext
	end

.NoRoom:
	writetext FuchsiaGoodRodHouseNoRoomText
	waitbutton
	closetext
	end

.AlreadyGotGoodRod:
	writetext FuchsiaGoodRodHouseAfterText
	waitbutton
	closetext
	end

FuchsiaGoodRodHouseOfferText:
	text "I'm the FISHING"
	line "GURU's older"
	cont "brother!"

	para "I simply Looove"
	line "fishing!"

	para "Do you like to"
	line "fish?"
	done

FuchsiaGoodRodHouseGiveText:
	text "Grand! I like"
	line "your style!"

	para "Take this and"
	line "fish, young one!"
	done

FuchsiaGoodRodHouseRefusedText:
	text "Oh… That's so"
	line "disappointing…"
	done

FuchsiaGoodRodHouseAfterText:
	text "Hello there,"
	line "<PLAYER>!"

	para "How are the fish"
	line "biting?"
	done

FuchsiaGoodRodHouseNoRoomText:
	text "Oh no!"

	para "You have no room"
	line "for my gift!"
	done

FuchsiaGoodRodHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  0, FUCHSIA_CITY, 9 ; Yellow's back door, on SHIP block $09's LADDER
	warp_event  2,  7, FUCHSIA_CITY, 8
	warp_event  3,  7, FUCHSIA_CITY, 8

	def_coord_events

	def_bg_events

	def_object_events
	object_event  5,  3, SPRITE_FISHING_GURU, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, FuchsiaGoodRodHouseGuruScript, -1
