; Kanto hack (M6 9t): Yellow's CELADON DINER
; (vendor/pokeyellow/data/maps/objects/CeladonDiner.asm,
; vendor/pokeyellow/scripts/CeladonDiner_2.asm,
; vendor/pokeyellow/text/CeladonDiner.asm).  The map keeps Crystal's
; CELADON_CAFE id and label (docs/M6-CELADON.md 0, D46) but is rethemed to
; Yellow's DINER: the room was re-cut 6x4 -> 5x4 onto Yellow's diner layout
; (scripts/celadon_blk.py "== 9t ==") -- two round tables on the left, a chair
; column in the middle and an L-shaped counter sealing the staff area at
; x>=7, which is how Yellow reaches the cook and the woman behind it.
;
; Yellow's five NPCs keep Yellow's own tiles except the COOK, whose (8,5) is
; the counter's horizontal run here; he takes (8,4), the open tile behind it,
; and still walks left-right.  Sprite substitutions (docs/M6-CELADON.md 2.3):
; COOK -> SPRITE_CLERK (the counter-attendant sprite; SUPER_NERD is spent on
; the HOTEL), MIDDLE_AGED_WOMAN -> SPRITE_POKEFAN_F, MIDDLE_AGED_MAN ->
; SPRITE_POKEFAN_M.
;
; The door is at (4,7)/(5,7), not Yellow's (3,7)/(4,7): game_corner's only
; warp-carpet block, $0c, covers BOTH bottom tiles of a block, so a two-tile
; door has to be block-aligned.
;
; Gone with Crystal's cafe: the eatathon chef, the three eatathon fishers, the
; TEACHER who says a COIN CASE can only be found in JOHTO (this map now gives
; it), the Eatathon Contest poster and the LEFTOVERS trash can.  LEFTOVERS is
; not orphaned -- SNORLAX still holds one (data/pokemon/base_stats/snorlax.asm).
; Yellow has no hidden events here, so both bg_events go.
	object_const_def
	const CELADONCAFE_GYM_GUIDE
	const CELADONCAFE_POKEFAN_F
	const CELADONCAFE_POKEFAN_M
	const CELADONCAFE_FISHER
	const CELADONCAFE_CLERK

CeladonCafe_MapScripts:
	def_scene_scripts

	def_callbacks

; Yellow: CeladonDinerPrintGymGuideText (scripts/CeladonDiner_2.asm).
; verbosegiveitem is Crystal's GiveItem + "received COIN CASE!" +
; sound_get_key_item in one command, so only the busted speech and the no-room
; line stay as writetexts -- the MrFujisHouse POKe FLUTE idiom.
CeladonCafeGymGuideScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_COIN_CASE
	iftrue .GotCoinCase
	writetext CeladonCafeImFlatOutBustedText
	promptbutton
	verbosegiveitem COIN_CASE
	iffalse .NoRoom
	setevent EVENT_GOT_COIN_CASE
	closetext
	end

.NoRoom:
	writetext CeladonCafeCoinCaseNoRoomText
	waitbutton
	closetext
	end

.GotCoinCase:
	writetext CeladonCafeWinItBackText
	waitbutton
	closetext
	end

; Yellow: STAY NONE -- she does not turn to the player.
CeladonCafePokefanFScript:
	jumptext CeladonCafePokefanFText

CeladonCafePokefanMScript:
	jumptextfaceplayer CeladonCafePokefanMText

CeladonCafeFisherScript:
	jumptextfaceplayer CeladonCafeFisherText

CeladonCafeClerkScript:
	jumptextfaceplayer CeladonCafeClerkText

CeladonCafeImFlatOutBustedText:
	text "Go ahead! Laugh!"

	para "I'm flat out"
	line "busted!"

	para "No more slots for"
	line "me! I'm going"
	cont "straight!"

	para "Here! I won't be"
	line "needing this any-"
	cont "more!"
	done

CeladonCafeCoinCaseNoRoomText:
	text "Make room for"
	line "this!"
	done

CeladonCafeWinItBackText:
	text "I always thought"
	line "I was going to"
	cont "win it back…"
	done

CeladonCafePokefanFText:
	text "My #MON are"
	line "weak, so I often"

	para "have to go to the"
	line "DRUG STORE."
	done

CeladonCafePokefanMText:
	text "Psst! There's a"
	line "basement under"
	cont "the GAME CORNER."
	done

CeladonCafeFisherText:
	text "Munch…"

	para "The man at that"
	line "table lost it all"
	cont "at the slots."
	done

CeladonCafeClerkText:
	text "Hi!"

	para "We're taking a"
	line "break now."
	done

CeladonCafe_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4,  7, CELADON_CITY, 11 ; Kanto hack (M6 9p): Yellow's city warp 11
	warp_event  5,  7, CELADON_CITY, 11

	def_coord_events

	def_bg_events

	def_object_events
	object_event  0,  1, SPRITE_GYM_GUIDE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeladonCafeGymGuideScript, -1
	object_event  7,  2, SPRITE_POKEFAN_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonCafePokefanFScript, -1
	object_event  1,  4, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonCafePokefanMScript, -1
	object_event  5,  3, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeladonCafeFisherScript, -1
	object_event  8,  4, SPRITE_CLERK, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonCafeClerkScript, -1
