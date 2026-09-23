; 6g: Yellow's CERULEAN_MELANIES_HOUSE, the BULBASAUR gift
; (vendor/pokeyellow/scripts/CeruleanMelaniesHouse.asm,
; data/maps/objects/CeruleanMelaniesHouse.asm, text/CeruleanMelaniesHouse.asm).
; 6a laid in the geometry: the map rides CERULEAN_POLICE_STATION's old slot on
; the shared House1 block group, with Yellow's two door warps at (2,7)/(3,7).
;
; All four of Yellow's objects sit on floor tiles of Crystal's House1 layout, so
; every coordinate is Yellow's, unmoved.  The three Pokemon use Yellow's own
; 16x48 overworld sheets, ported in this step (SPRITE_SANDSHREW $6f,
; SPRITE_ODDISH_OW $70, SPRITE_BULBASAUR_OW $71); Crystal's SPRITE_ODDISH /
; SPRITE_BULBASAUR exist but are SpriteMons entries drawn from the party-menu
; icons, which would not match the Chansey ported in 6b.
;
; The gate: Yellow reads wPikachuHappiness and refuses below 147.  Our follower
; Pikachu IS the starter party mon, so the equivalent byte is that mon's
; Crystal MON_HAPPINESS -- the same 0-255 scale, base 70 -- and the threshold is
; unchanged.  `special GetStarterPikachuHappiness`
; (hack/engine/overworld/follower.asm) walks the party with
; IsStarterPikachuInSlot and puts that byte in wScriptVar, or 0 when the starter
; is not in the party at all; 0 takes Yellow's low-happiness branch, which is
; simply Melanie's first speech and nothing more (Yellow has no separate refusal
; line, and no "where is your PIKACHU" line here).
DEF MELANIE_HAPPINESS_GATE EQU 147

	object_const_def
	const CERULEANMELANIESHOUSE_MELANIE
	const CERULEANMELANIESHOUSE_BULBASAUR
	const CERULEANMELANIESHOUSE_ODDISH
	const CERULEANMELANIESHOUSE_SANDSHREW

CeruleanMelaniesHouse_MapScripts:
	def_scene_scripts

	def_callbacks

CeruleanMelaniesHouseMelanieScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_BULBASAUR_FROM_MELANIE
	iftrue .AlreadyGave
	writetext CeruleanMelaniesHouseMelanieIntroText
	promptbutton
	special GetStarterPikachuHappiness
	ifless MELANIE_HAPPINESS_GATE, .NotYet
	writetext CeruleanMelaniesHouseMelanieOfferText
	yesorno
	iffalse .Refused
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .PartyFull
	writetext CeruleanMelaniesHouseReceivedBulbasaurText
	playsound SFX_CAUGHT_MON
	waitsfx
	givepoke BULBASAUR, 10
	setevent EVENT_GOT_BULBASAUR_FROM_MELANIE
	disappear CERULEANMELANIESHOUSE_BULBASAUR
	writetext CeruleanMelaniesHouseMelanieThanksText
	waitbutton
	closetext
	end

.NotYet:
	closetext
	end

.Refused:
	writetext CeruleanMelaniesHouseMelanieRefusedText
	waitbutton
	closetext
	end

.PartyFull:
	writetext CeruleanMelaniesHouseMelaniePartyFullText
	waitbutton
	closetext
	end

.AlreadyGave:
	writetext CeruleanMelaniesHouseMelanieAfterText
	waitbutton
	closetext
	end

CeruleanMelaniesHouseBulbasaurScript:
	opentext
	writetext CeruleanMelaniesHouseBulbasaurText
	cry BULBASAUR
	waitbutton
	closetext
	end

CeruleanMelaniesHouseOddishScript:
	opentext
	writetext CeruleanMelaniesHouseOddishText
	cry ODDISH
	waitbutton
	closetext
	end

CeruleanMelaniesHouseSandshrewScript:
	opentext
	writetext CeruleanMelaniesHouseSandshrewText
	cry SANDSHREW
	waitbutton
	closetext
	end

CeruleanMelaniesHouseMelanieIntroText:
	text "I take care of"
	line "injured #MON."

	para "I nursed this"
	line "BULBASAUR back to"
	cont "health."

	para "It needs a good"
	line "trainer to take"
	cont "care of it now."
	done

CeruleanMelaniesHouseMelanieOfferText:
	text "I know! Would you"
	line "take care of this"
	cont "BULBASAUR?"
	done

CeruleanMelaniesHouseReceivedBulbasaurText:
	text "<PLAYER> received"
	line "BULBASAUR!"
	done

CeruleanMelaniesHouseMelanieThanksText:
	text "Please take care"
	line "of BULBASAUR!"
	done

CeruleanMelaniesHouseMelanieAfterText:
	text "Is BULBASAUR"
	line "doing well?"
	done

CeruleanMelaniesHouseMelanieRefusedText:
	text "Oh…"
	line "That's too bad…"
	done

; Yellow has no line for this: its GivePokemon would have boxed the BULBASAUR.
; Like the Mt. Moon MAGIKARP salesman (docs/M2-MTMOON.md 5g) the party is
; checked before anything happens, so Melanie keeps the BULBASAUR instead.
CeruleanMelaniesHouseMelaniePartyFullText:
	text "Oh! You're already"
	line "carrying six"
	cont "#MON."

	para "Come back when you"
	line "have room for"
	cont "BULBASAUR."
	done

CeruleanMelaniesHouseBulbasaurText:
	text "BULBASAUR: Bubba!"
	line "Zoar!"
	done

CeruleanMelaniesHouseOddishText:
	text "ODDISH: Orddissh!"
	done

CeruleanMelaniesHouseSandshrewText:
	text "SANDSHREW: Pikii!"
	done

; BG1Q1 (docs/BG1-BENCH-AND-SHELVES.md): Yellow prints BookOrSculptureText
; ("Crammed full of / #MON books!") facing UP on (0,1), (1,1), (7,1)
; (engine/events/hidden_events/bookshelves.asm).  Every other bookshelf/TV/
; radio square here is silent, as in Yellow (engine/events/std_collision.asm).
CeruleanMelaniesHouseBG1Q1Bookshelf:
	jumpstd PictureBookshelfScript

CeruleanMelaniesHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, CERULEAN_CITY, 2
	warp_event  3,  7, CERULEAN_CITY, 2

	def_coord_events

	def_bg_events
	bg_event  0,  1, BGEVENT_UP, CeruleanMelaniesHouseBG1Q1Bookshelf ; BG1Q1
	bg_event  1,  1, BGEVENT_UP, CeruleanMelaniesHouseBG1Q1Bookshelf ; BG1Q1
	bg_event  7,  1, BGEVENT_UP, CeruleanMelaniesHouseBG1Q1Bookshelf ; BG1Q1

	def_object_events
	object_event  3,  1, SPRITE_LASS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeruleanMelaniesHouseMelanieScript, -1
	object_event  4,  1, SPRITE_BULBASAUR_OW, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeruleanMelaniesHouseBulbasaurScript, EVENT_GOT_BULBASAUR_FROM_MELANIE
	object_event  1,  4, SPRITE_ODDISH_OW, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeruleanMelaniesHouseOddishScript, -1
	object_event  5,  3, SPRITE_SANDSHREW, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeruleanMelaniesHouseSandshrewScript, -1
