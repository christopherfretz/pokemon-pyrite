; Kanto hack: the PEWTER MUSEUM OF SCIENCE, ground floor (docs/M2-PEWTER.md, 4d).
; Yellow's MUSEUM tileset is literally an alias of its GATE tileset
; (vendor/pokeyellow/gfx/tilesets.asm), so this map uses Crystal's TILESET_GATE
; and needs no new metatiles or art.  The layout is Yellow's re-cut for Crystal's
; gate blocks: two rooms that do NOT connect, west (lobby, fossil cases and the
; stairs) and east (the ticket clerk, the OLD AMBER display and the side door).
; The only way west is past the clerk at y=4, which is what the coord events are.

	object_const_def
	const MUSEUM1F_CLERK
	const MUSEUM1F_GENTLEMAN
	const MUSEUM1F_AMBER_SCIENTIST
	const MUSEUM1F_SCIENTIST
	const MUSEUM1F_OLD_AMBER

DEF MUSEUM_TICKET_PRICE EQU 50

Museum1F_MapScripts:
	def_scene_scripts

	def_callbacks

; The two tiles in front of the ticket counter.  Scene id -1 fires in every
; scene (home/map.asm .CoordEventCheck), so the script itself is the guard;
; that saves a scene var and a wram byte.  Yellow re-runs this every time
; because it clears EVENT_BOUGHT_MUSEUM_TICKET on each Pewter City load; we
; deliberately keep the ticket bought forever (see "4d findings").
Museum1FTicketCounterScript:
	checkevent EVENT_BOUGHT_MUSEUM_TICKET
	iftrue .AlreadyPaid
	turnobject MUSEUM1F_CLERK, LEFT
	opentext
	special PlaceMoneyTopRight
	writetext Museum1FClerkPriceText
	yesorno
	iffalse .Declined
	checkmoney YOUR_MONEY, MUSEUM_TICKET_PRICE
	ifequal HAVE_LESS, .NotEnoughMoney
	takemoney YOUR_MONEY, MUSEUM_TICKET_PRICE
	special PlaceMoneyTopRight
	playsound SFX_TRANSACTION
	waitsfx
	setevent EVENT_BOUGHT_MUSEUM_TICKET
	writetext Museum1FClerkThankYouText
	waitbutton
	writetext Museum1FClerkTakePlentyOfTimeText
	waitbutton
	closetext
	end

.NotEnoughMoney:
	writetext Museum1FClerkNotEnoughMoneyText
	waitbutton
.Declined:
	writetext Museum1FClerkComeAgainText
	waitbutton
	closetext
; GSC has no wJoyIgnore/simulated joypad, so Yellow's "push PAD_DOWN" eject is
; an applymovement instead.
	applymovement PLAYER, Museum1FPlayerStepBackMovement
	end

.AlreadyPaid:
	end

; Reachable only from the east room, i.e. from Pewter City's side door, which
; is exactly the situation Yellow's "you can't sneak in the back way" line is
; written for.  Over the counter from the west he just greets you.
Museum1FClerkScript:
	faceplayer
	opentext
	checkevent EVENT_BOUGHT_MUSEUM_TICKET
	iftrue .Greet
	writetext Museum1FClerkBackWayText
	yesorno
	iffalse .AmberIsSap
	writetext Museum1FClerkTheresALabText
	waitbutton
	closetext
	end

.AmberIsSap:
	writetext Museum1FClerkAmberIsSapText
	waitbutton
	closetext
	end

.Greet:
	writetext Museum1FClerkTakePlentyOfTimeText
	waitbutton
	closetext
	end

Museum1FGentlemanScript:
	jumptextfaceplayer Museum1FGentlemanText

Museum1FScientistScript:
	jumptextfaceplayer Museum1FScientistText

Museum1FAmberScientistScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_OLD_AMBER
	iftrue .AlreadyGiven
	writetext Museum1FAmberScientistText
	promptbutton
	verbosegiveitem OLD_AMBER
	iffalse .NoRoom
	setevent EVENT_GOT_OLD_AMBER
	disappear MUSEUM1F_OLD_AMBER
	writetext Museum1FAmberScientistCheckItText
	waitbutton
	closetext
	end

.NoRoom:
	writetext Museum1FAmberScientistNoSpaceText
	waitbutton
	closetext
	end

.AlreadyGiven:
	writetext Museum1FAmberScientistCheckItText
	waitbutton
	closetext
	end

Museum1FOldAmberScript:
	jumptext Museum1FOldAmberText

Museum1FAerodactylFossilScript:
	jumptext Museum1FAerodactylFossilText

Museum1FKabutopsFossilScript:
	jumptext Museum1FKabutopsFossilText

Museum1FPlayerStepBackMovement:
	step DOWN
	step_end

Museum1FClerkPriceText:
	text "It's ¥50 for a"
	line "child's ticket."

	para "Would you like to"
	line "come in?"
	done

Museum1FClerkThankYouText:
	text "Right, ¥50!"
	line "Thank you!"
	done

Museum1FClerkNotEnoughMoneyText:
	text "You don't have"
	line "enough money."
	done

Museum1FClerkComeAgainText:
	text "Come again!"
	done

Museum1FClerkTakePlentyOfTimeText:
	text "Take plenty of"
	line "time to look!"
	done

Museum1FClerkBackWayText:
	text "You can't sneak"
	line "in the back way!"

	para "Oh, whatever!"
	line "Do you know what"
	cont "AMBER is?"
	done

Museum1FClerkTheresALabText:
	text "There's a lab"
	line "somewhere trying"
	cont "to resurrect"
	cont "ancient #MON"
	cont "from AMBER."
	done

Museum1FClerkAmberIsSapText:
	text "AMBER is fossil-"
	line "ized tree sap."
	done

Museum1FGentlemanText:
	text "That is one"
	line "magnificent"
	cont "fossil!"
	done

Museum1FScientistText:
	text "We are proud of 2"
	line "fossils of very"
	cont "rare, prehistoric"
	cont "#MON!"
	done

Museum1FAmberScientistText:
	text "Ssh! I think that"
	line "this chunk of"
	cont "AMBER contains"
	cont "#MON DNA!"

	para "It would be great"
	line "if #MON could"
	cont "be resurrected"
	cont "from it!"

	para "But, my colleagues"
	line "just ignore me!"

	para "So, I have a favor"
	line "to ask!"

	para "Take this to a"
	line "#MON LAB and"
	cont "get it examined!"
	done

Museum1FAmberScientistCheckItText:
	text "Ssh! Get the OLD"
	line "AMBER checked!"
	done

Museum1FAmberScientistNoSpaceText:
	text "You don't have"
	line "space for this!"
	done

Museum1FOldAmberText:
	text "The AMBER is"
	line "clear and gold!"
	done

Museum1FAerodactylFossilText:
	text "AERODACTYL Fossil"
	line "A primitive and"
	cont "rare #MON."
	done

Museum1FKabutopsFossilText:
	text "KABUTOPS Fossil"
	line "A primitive and"
	cont "rare #MON."
	done

Museum1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 10,  7, PEWTER_CITY, 6
	warp_event 11,  7, PEWTER_CITY, 6
	warp_event 16,  7, PEWTER_CITY, 7
	warp_event 17,  7, PEWTER_CITY, 7
	warp_event  7,  6, MUSEUM_2F, 1

	def_coord_events
	coord_event  9,  4, -1, Museum1FTicketCounterScript
	coord_event 10,  4, -1, Museum1FTicketCounterScript

	def_bg_events
	bg_event  2,  2, BGEVENT_READ, Museum1FAerodactylFossilScript
	bg_event  2,  6, BGEVENT_READ, Museum1FKabutopsFossilScript

	def_object_events
	object_event 12,  4, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Museum1FClerkScript, -1
	object_event  1,  4, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Museum1FGentlemanScript, -1
	object_event 15,  2, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Museum1FAmberScientistScript, -1
	object_event 17,  4, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Museum1FScientistScript, -1
	object_event 16,  2, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Museum1FOldAmberScript, EVENT_GOT_OLD_AMBER
