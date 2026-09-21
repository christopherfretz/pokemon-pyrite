; Kanto hack: Yellow's WARDEN's house (docs/M7-FUCHSIA.md 10g).  The WARDEN
; mumbles -- his teeth are somewhere in the SAFARI ZONE -- until the player
; brings him the GOLD TEETH, whereupon he takes them and hands over HM04
; STRENGTH.  Every line is Yellow's verbatim
; (vendor/pokeyellow/{data/maps/objects,text}/WardensHouse.asm); Crystal's
; granddaughter and her two "SAFARI ZONE closed down" speeches are gone (D65).
;
; The room is re-cut to Yellow's 5x4 on the LAB tileset with the door at
; Yellow's (4,7)/(5,7); the two display bg_events sit on the one bookshelf block
; in the back wall, at (4,1)/(5,1) rather than Yellow's (4,3)/(5,3), because
; Crystal reads a display by facing the shelf tile itself.  Yellow's RARE CANDY
; ball and STRENGTH boulder keep their tiles.
;
; The HM04 give reuses EVENT_GOT_HM04_STRENGTH, the flag Crystal's OLIVINE CAFE
; giver already owns, so the player can never be handed STRENGTH twice; and the
; GOLD TEETH are taken only AFTER verbosegiveitem reports success, which makes
; Yellow's "pack is stuffed full" retry safe (TMs/HMs live in a fixed array in
; GSC, so the failure branch is in practice unreachable).
	object_const_def
	const SAFARIZONEWARDENSHOME_WARDEN
	const SAFARIZONEWARDENSHOME_RARE_CANDY
	const SAFARIZONEWARDENSHOME_BOULDER

SafariZoneWardensHome_MapScripts:
	def_scene_scripts

	def_callbacks

WardenScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_HM04_STRENGTH
	iftrue .Explanation
	checkitem GOLD_TEETH
	iftrue .GoldTeeth
	writetext WardenGibberish1Text
	yesorno
	iffalse .Gibberish3
	writetext WardenGibberish2Text
	waitbutton
	closetext
	end

.Gibberish3:
	writetext WardenGibberish3Text
	waitbutton
	closetext
	end

.GoldTeeth:
	writetext GaveGoldTeethText
	playsound SFX_ITEM
	waitsfx
	writetext WardenThanksText
	promptbutton
	verbosegiveitem HM_STRENGTH
	iffalse .NoRoom
	takeitem GOLD_TEETH
	setevent EVENT_GOT_HM04_STRENGTH
	writetext WardenExplanationText
	waitbutton
	closetext
	end

.NoRoom:
	writetext WardenNoRoomText
	waitbutton
	closetext
	end

.Explanation:
	writetext WardenExplanationText
	waitbutton
	closetext
	end

WardensHomeRareCandy:
	itemball RARE_CANDY

WardensHomeBoulder:
	jumpstd StrengthBoulderScript

WardensHomeDisplayLeft:
	jumptext WardensHomeDisplayLeftText

WardensHomeDisplayRight:
	jumptext WardensHomeDisplayRightText

WardenGibberish1Text:
	text "WARDEN: Hif fuff"
	line "hefifoo!"

	para "Ha lof ha feef ee"
	line "hafahi ho. Heff"
	cont "hee fwee!"
	done

WardenGibberish2Text:
	text "Ah howhee ho hoo!"
	line "Eef ee hafahi ho!"
	done

WardenGibberish3Text:
	text "Ha? He ohay heh"
	line "ha hoo ee haheh!"
	done

GaveGoldTeethText:
	text "<PLAYER> gave the"
	line "GOLD TEETH to the"
	cont "WARDEN!"
	done

WardenThanksText:
	text "WARDEN: Thanks,"
	line "kid! No one could"
	cont "understand a word"
	cont "that I said."

	para "I couldn't work"
	line "that way."

	para "Let me give you"
	line "something for"
	cont "your trouble."
	done

WardenExplanationText:
	text "WARDEN: HM04"
	line "teaches STRENGTH!"

	para "It lets #MON"
	line "move boulders"
	cont "when you're out-"
	cont "side of battle."

	para "Oh yes, did you"
	line "find SECRET HOUSE"
	cont "in SAFARI ZONE?"

	para "If you do, you"
	line "win an HM!"

	para "I hear it's the"
	line "rare SURF HM."
	done

WardenNoRoomText:
	text "Your pack is"
	line "stuffed full!"
	done

WardensHomeDisplayLeftText:
	text "#MON photos"
	line "and fossils."
	done

WardensHomeDisplayRightText:
	text "Old #MON"
	line "merchandise."
	done

SafariZoneWardensHome_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4,  7, FUCHSIA_CITY, 4
	warp_event  5,  7, FUCHSIA_CITY, 4

	def_coord_events

	def_bg_events
	bg_event  4,  1, BGEVENT_READ, WardensHomeDisplayLeft
	bg_event  5,  1, BGEVENT_READ, WardensHomeDisplayRight

	def_object_events
	object_event  2,  3, SPRITE_WARDEN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, WardenScript, -1
	object_event  8,  3, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, WardensHomeRareCandy, EVENT_WARDENS_HOME_RARE_CANDY
	object_event  8,  4, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, WardensHomeBoulder, -1
