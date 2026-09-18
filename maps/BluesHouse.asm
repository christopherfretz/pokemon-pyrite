; Kanto hack (L1, docs/AUDIT-KANTO-LEFTOVERS.md 4.1 / 7.12): Yellow's BLUE'S
; HOUSE.  Crystal's Daisy offered a 3 PM grooming service that belongs to the
; post-E4 Johto game; Yellow's Daisy hands over the TOWN MAP once OAK has given
; the #DEX, which is the only source of the TOWN MAP in the ported world.
; Ported from vendor/pokeyellow/scripts/BluesHouse.asm:20-56 and
; vendor/pokeyellow/text/BluesHouse.asm:1-45.
	object_const_def
	const BLUESHOUSE_DAISY
	const BLUESHOUSE_DAISY2
	const BLUESHOUSE_TOWN_MAP

BluesHouse_MapScripts:
	def_scene_scripts

	def_callbacks

DaisyScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_TOWN_MAP
	iftrue .UseMap
	; ENGINE_POKEDEX is the port's "OAK has given the #DEX" predicate
	; (docs/M2-PARCEL.md), standing in for Yellow's EVENT_GOT_POKEDEX.
	checkflag ENGINE_POKEDEX
	iffalse .RivalAtLab
	writetext DaisyOfferMapText
	promptbutton
	verbosegiveitem TOWN_MAP
	iffalse .BagFull
	; disappear also sets the object's event flag, so this one flag both
	; hides the table prop and locks Daisy into her .UseMap line.
	disappear BLUESHOUSE_TOWN_MAP
	setevent EVENT_GOT_TOWN_MAP
	closetext
	end

.RivalAtLab:
	writetext DaisyRivalAtLabText
	waitbutton
	closetext
	end

.UseMap:
	writetext DaisyUseMapText
	waitbutton
	closetext
	end

.BagFull:
	writetext DaisyBagFullText
	waitbutton
	closetext
	end

DaisyWalkingScript:
	jumptextfaceplayer DaisyWalkingText

BluesHouseTownMapScript:
	jumptext BluesHouseTownMapText

; Yellow's three bookcases (vendor/pokeyellow/data/maps/objects/BluesHouse.asm
; hidden-object texts): all three print _BookcaseText, which our shared
; PictureBookshelfText already carries verbatim after N1a.
BluesHouseBookshelf:
	jumpstd PictureBookshelfScript

DaisyRivalAtLabText:
	text "Hi <PLAYER>!"
	line "<RIVAL> is out at"
	cont "Grandpa's lab."
	done

DaisyOfferMapText:
	text "Grandpa asked you"
	line "to run an errand?"
	cont "Here, this will"
	cont "help you!"
	prompt

DaisyBagFullText:
	text "You have too much"
	line "stuff with you."
	done

DaisyUseMapText:
	text "Use the TOWN MAP"
	line "to find out where"
	cont "you are."
	done

DaisyWalkingText:
	text "Spending time"
	line "with your #MON"
	cont "makes them more"
	cont "friendly to you."
	done

BluesHouseTownMapText:
	text "It's a big map!"
	line "This is useful!"
	done

BluesHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, PALLET_TOWN, 2
	warp_event  3,  7, PALLET_TOWN, 2

	def_coord_events

	def_bg_events
	bg_event  0,  1, BGEVENT_READ, BluesHouseBookshelf
	bg_event  1,  1, BGEVENT_READ, BluesHouseBookshelf
	bg_event  7,  1, BGEVENT_READ, BluesHouseBookshelf

	def_object_events
	object_event  2,  3, SPRITE_DAISY, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, DaisyScript, -1
	object_event  6,  4, SPRITE_DAISY, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, DaisyWalkingScript, -1
	object_event  3,  3, SPRITE_POKEDEX, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, BluesHouseTownMapScript, EVENT_GOT_TOWN_MAP
