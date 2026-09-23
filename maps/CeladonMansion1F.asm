; Kanto hack (docs/M6-CELADON.md, 9s): Yellow's CELADON MANSION 1F -- the
; manager's suite.  Objects, coordinates and text are Yellow's
; (vendor/pokeyellow/data/maps/objects/CeladonMansion1F.asm + scripts/text).
; Our floor is 4x5 blocks against Yellow's 4x6, so Yellow's (1,8) CLEFAIRY moves
; up to our equivalent corridor row (row 7); every other coordinate transfers
; unchanged.  The two Crystal bookshelf bg_events are gone -- Yellow's 1F has
; nothing to read but the sign.
	object_const_def
	const CELADONMANSION1F_MEOWTH
	const CELADONMANSION1F_GRANNY
	const CELADONMANSION1F_CLEFAIRY
	const CELADONMANSION1F_NIDORAN_F

CeladonMansion1F_MapScripts:
	def_scene_scripts

	def_callbacks

; Yellow's granny is the starter-Pikachu happiness rater
; (scripts/CeladonMansion1F_2.asm: CeladonMansion1FPrintGrannyText).  She always
; says her two lines; if the starter PIKACHU is in the party she adds the
; "adorable PIKACHU" line and then one of six verdicts picked by a threshold
; table (happiness < 51 / 101 / 131 / 161 / 201, else the last one), and at
; >= 251 Yellow plays PikachuCry23 after a 50-frame beat.  `special
; GetStarterPikachuHappiness` (engine/overworld/follower.asm) stands in for
; Yellow's IsStarterPikachuAliveInOurParty + wPikachuHappiness: it returns 0
; when the starter PIKACHU is not in the party, which is the 6g precedent.
; Decision A (docs/PIKACHU.md): every Yellow voice clip is the plain PIKACHU
; cry here, so PikachuCry23 is `cry PIKACHU`.
CeladonMansionManager:
	faceplayer
	opentext
	writetext CeladonMansionManagerText
	waitbutton
	special GetStarterPikachuHappiness
	ifequal 0, .done
	writetext CeladonMansionManagerAdorablePikachuText
	promptbutton
	ifless 51, .NotTamed
	ifless 101, .TakeMoreCare
	ifless 131, .MustBeHappy
	ifless 161, .SeemsTamed
	ifless 201, .LooksHappy
	writetext CeladonMansionManagerFantasticDuoText
	waitbutton
	special GetStarterPikachuHappiness
	ifless 251, .done
	pause 25
	cry PIKACHU
.done
	closetext
	end

.NotTamed
	writetext CeladonMansionManagerNotTamedText
	waitbutton
	sjump .done

.TakeMoreCare
	writetext CeladonMansionManagerTakeMoreCareText
	waitbutton
	sjump .done

.MustBeHappy
	writetext CeladonMansionManagerMustBeHappyText
	waitbutton
	sjump .done

.SeemsTamed
	writetext CeladonMansionManagerSeemsTamedText
	waitbutton
	sjump .done

.LooksHappy
	writetext CeladonMansionManagerLooksHappyText
	waitbutton
	sjump .done

CeladonMansion1FMeowth:
	faceplayer
	opentext
	writetext CeladonMansion1FMeowthText
	cry MEOWTH
	waitbutton
	closetext
	end

CeladonMansion1FClefairy:
	faceplayer
	opentext
	writetext CeladonMansion1FClefairyText
	cry CLEFAIRY
	waitbutton
	closetext
	end

CeladonMansion1FNidoranF:
	faceplayer
	opentext
	writetext CeladonMansion1FNidoranFText
	cry NIDORAN_F
	waitbutton
	closetext
	end

CeladonMansionManagersSuiteSign:
	jumptext CeladonMansionManagersSuiteSignText

CeladonMansionManagerText:
	text "My dear #MON"
	line "keep me company."

	para "MEOWTH even brings"
	line "money home!"
	done

CeladonMansionManagerAdorablePikachuText:
	text "Oh, you have an"
	line "adorable PIKACHU"
	cont "with you."
	done

CeladonMansionManagerNotTamedText:
	text "It seems like it"
	line "hasn't been tamed"
	cont "at all."
	done

CeladonMansionManagerTakeMoreCareText:
	text "Why don't you"
	line "take more care"
	cont "with PIKACHU?"
	done

CeladonMansionManagerMustBeHappyText:
	text "You must be happy"
	line "to have a #MON"
	cont "that cute."
	done

CeladonMansionManagerSeemsTamedText:
	text "Your PIKACHU seems"
	line "tamed."
	done

CeladonMansionManagerLooksHappyText:
	text "Your PIKACHU looks"
	line "happy with you."
	done

CeladonMansionManagerFantasticDuoText:
	text "You look like a"
	line "fantastic duo."

	para "You're making me"
	line "jealous!"
	done

CeladonMansion1FMeowthText:
	text "MEOWTH: Meow!"
	done

CeladonMansion1FClefairyText:
	text "CLEFAIRY: Pi"
	line "pippippi!"
	done

CeladonMansion1FNidoranFText:
	text "NIDORAN: Kya"
	line "kyaoo!"
	done

CeladonMansionManagersSuiteSignText:
	text "CELADON MANSION"
	line "Manager's Suite"
	done

; BG1Q1 (docs/BG1-BENCH-AND-SHELVES.md): Yellow prints BookOrSculptureText
; ("Crammed full of / #MON books!") facing UP on (2,3)
; (engine/events/hidden_events/bookshelves.asm).  Every other bookshelf/TV/
; radio square here is silent, as in Yellow (engine/events/std_collision.asm).
CeladonMansion1FBG1Q1Bookshelf:
	jumpstd PictureBookshelfScript

CeladonMansion1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  6,  9, CELADON_CITY, 3 ; Kanto hack (M6 9p): Yellow's city warp 3, the front door
	warp_event  7,  9, CELADON_CITY, 3
	warp_event  3,  0, CELADON_CITY, 5 ; Kanto hack (M6 9p): Yellow's city warp 5, the back door
	warp_event  0,  0, CELADON_MANSION_2F, 1
	warp_event  7,  0, CELADON_MANSION_2F, 4

	def_coord_events

	def_bg_events
	bg_event  2,  3, BGEVENT_UP, CeladonMansion1FBG1Q1Bookshelf ; BG1Q1
	bg_event  5,  8, BGEVENT_UP, CeladonMansionManagersSuiteSign

	def_object_events
	object_event  0,  5, SPRITE_MONSTER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, CeladonMansion1FMeowth, -1
	object_event  1,  5, SPRITE_GRANNY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeladonMansionManager, -1
	object_event  2,  7, SPRITE_FAIRY, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 2, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonMansion1FClefairy, -1
	object_event  4,  4, SPRITE_MONSTER, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 2, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonMansion1FNidoranF, -1
