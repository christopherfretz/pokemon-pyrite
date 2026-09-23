; Kanto hack (docs/M5-LAVENDER.md, 8l): Yellow's ROUTE 12 SUPER ROD HOUSE.
; Crystal kept the house but rewrote the FISHING GURU's brother; 8l restores
; Yellow's six lines and moves him to Yellow's (2,4) facing RIGHT.  The house
; door on ROUTE 12 moved with the re-cut, to Yellow's (11,77).
	object_const_def
	const ROUTE12SUPERRODHOUSE_FISHING_GURU

Route12SuperRodHouse_MapScripts:
	def_scene_scripts

	def_callbacks

Route12SuperRodHouseFishingGuruScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_SUPER_ROD
	iftrue .GotSuperRod
	writetext DoYouLikeToFishText
	yesorno
	iffalse .Refused
	writetext ReceivedSuperRodText
	promptbutton
	verbosegiveitem SUPER_ROD
	iffalse .NoRoom
	setevent EVENT_GOT_SUPER_ROD
	writetext FishingWayOfLifeText
	waitbutton
	closetext
	end

.GotSuperRod:
	writetext TryFishingText
	waitbutton
	closetext
	end

.Refused:
	writetext ThatsDisappointingText
	waitbutton
.NoRoom:
	closetext
	end

SuperRodHouseBookshelf: ; unreferenced
	jumpstd PictureBookshelfScript

DoYouLikeToFishText:
	text "I'm the FISHING"
	line "GURU's brother!"

	para "I simply Looove"
	line "fishing!"

	para "Do you like to"
	line "fish?"
	done

ReceivedSuperRodText:
	text "Grand! I like"
	line "your style!"

	para "Take this and"
	line "fish, young one!"
	done

FishingWayOfLifeText:
	text "Fishing is a way"
	line "of life!"

	para "From the seas to"
	line "rivers, go out"
	cont "and land the big"
	cont "one!"
	done

ThatsDisappointingText:
	text "Oh… That's so"
	line "disappointing…"
	done

TryFishingText:
	text "Hello there,"
	line "<PLAYER>!"

	para "Use the SUPER ROD"
	line "in any water!"
	cont "You can catch"
	cont "different kinds"
	cont "of #MON."

	para "Try fishing"
	line "wherever you can!"
	done

; BG1Q1 (docs/BG1-BENCH-AND-SHELVES.md): Yellow prints BookOrSculptureText
; ("Crammed full of / #MON books!") facing UP on (0,1), (1,1), (7,1)
; (engine/events/hidden_events/bookshelves.asm).  Every other bookshelf/TV/
; radio square here is silent, as in Yellow (engine/events/std_collision.asm).
Route12SuperRodHouseBG1Q1Bookshelf:
	jumpstd PictureBookshelfScript

Route12SuperRodHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, ROUTE_12, 4 ; ROUTE 12's house door is its 4th warp now (the gate took warps 1-3)
	warp_event  3,  7, ROUTE_12, 4

	def_coord_events

	def_bg_events
	bg_event  0,  1, BGEVENT_UP, Route12SuperRodHouseBG1Q1Bookshelf ; BG1Q1
	bg_event  1,  1, BGEVENT_UP, Route12SuperRodHouseBG1Q1Bookshelf ; BG1Q1
	bg_event  7,  1, BGEVENT_UP, Route12SuperRodHouseBG1Q1Bookshelf ; BG1Q1

	def_object_events
	object_event  2,  4, SPRITE_FISHING_GURU, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route12SuperRodHouseFishingGuruScript, -1
