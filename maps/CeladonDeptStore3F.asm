; Kanto hack (M6 9r, docs/M6-CELADON.md §3.5): Yellow's CELADON MART 3F, the
; TV GAME SHOP.  It sells NOTHING -- MART_CELADON_3F is gone -- and its clerk is
; the one-off giver of Yellow's TM18 COUNTER (our TM64, see docs/TM-LEDGER.md).
; Yellow's twelve bg_events are all here: eight display consoles/games, three
; #MON posters and the current-floor sign.

	object_const_def
	const CELADONDEPTSTORE3F_CLERK
	const CELADONDEPTSTORE3F_GAMEBOY_KID1
	const CELADONDEPTSTORE3F_GAMEBOY_KID2
	const CELADONDEPTSTORE3F_GAMEBOY_KID3
	const CELADONDEPTSTORE3F_LITTLE_BOY

CeladonDeptStore3F_MapScripts:
	def_scene_scripts

	def_callbacks

CeladonDeptStore3FClerkScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_TM18_COUNTER
	iftrue .GotTM18
	writetext CeladonDeptStore3FClerkTM18PreReceiveText
	promptbutton
	verbosegiveitem TM_COUNTER
	iffalse .NoRoomForTM
	setevent EVENT_GOT_TM18_COUNTER
	closetext
	end

.GotTM18:
; Yellow prints the explanation only on the SECOND and later talks -- the first
; talk ends on "<PLAYER> received TM64!" (scripts/CeladonMart3F_2.asm).
	writetext CeladonDeptStore3FClerkTM18ExplanationText
	waitbutton
	closetext
	end

.NoRoomForTM:
	writetext CeladonDeptStore3FClerkTM18NoRoomText
	waitbutton
	closetext
	end

CeladonDeptStore3FGameboyKid1Script:
	faceplayer
	opentext
	writetext CeladonDeptStore3FGameboyKid1Text
	waitbutton
	closetext
	turnobject CELADONDEPTSTORE3F_GAMEBOY_KID1, RIGHT
	end

CeladonDeptStore3FGameboyKid2Script:
	faceplayer
	opentext
	writetext CeladonDeptStore3FGameboyKid2Text
	waitbutton
	closetext
	turnobject CELADONDEPTSTORE3F_GAMEBOY_KID2, DOWN
	end

CeladonDeptStore3FGameboyKid3Script:
	faceplayer
	opentext
	writetext CeladonDeptStore3FGameboyKid3Text
	waitbutton
	closetext
	turnobject CELADONDEPTSTORE3F_GAMEBOY_KID3, DOWN
	end

CeladonDeptStore3FLittleBoyScript:
	jumptextfaceplayer CeladonDeptStore3FLittleBoyText

CeladonDeptStore3FSNES:
	jumptext CeladonDeptStore3FSNESText

CeladonDeptStore3FRPG:
	jumptext CeladonDeptStore3FRPGText

CeladonDeptStore3FSportsGame:
	jumptext CeladonDeptStore3FSportsGameText

CeladonDeptStore3FPuzzleGame:
	jumptext CeladonDeptStore3FPuzzleGameText

CeladonDeptStore3FFightingGame:
	jumptext CeladonDeptStore3FFightingGameText

CeladonDeptStore3FPokemonPoster:
	jumptext CeladonDeptStore3FPokemonPosterText

CeladonDeptStore3FFloorSign:
	jumptext CeladonDeptStore3FFloorSignText

CeladonDeptStore3FElevatorButton:
	jumpstd ElevatorButtonScript

CeladonDeptStore3FClerkTM18PreReceiveText:
	text "Oh, hi! I finally"
	line "finished #MON!"

	para "Not done yet?"
	line "This might be"
	cont "useful!"
	done

CeladonDeptStore3FClerkTM18ExplanationText:
; Yellow says "TM18"; our TM union numbers COUNTER as TM64
; (docs/TM-LEDGER.md, docs/M3B-TM-UNION.md) -- same treatment as Lt. Surge's TM86.
	text "TM64 is COUNTER!"
	line "Not like the one"
	cont "I'm leaning on,"
	cont "mind you!"
	done

CeladonDeptStore3FClerkTM18NoRoomText:
	text "Your pack is full"
	line "of items!"
	done

CeladonDeptStore3FGameboyKid1Text:
	text "Captured #MON"
	line "are registered"
	cont "with an ID No."
	cont "and OT, the name"
	cont "of the Original"
	cont "Trainer that"
	cont "caught it!"
	done

CeladonDeptStore3FGameboyKid2Text:
	text "All right!"

	para "My buddy's going"
	line "to trade me his"
	cont "KANGASKHAN for my"
	cont "GRAVELER!"
	done

CeladonDeptStore3FGameboyKid3Text:
	text "Come on GRAVELER!"

	para "I love GRAVELER!"
	line "I collect them!"

	para "Huh?"

	para "GRAVELER turned"
	line "into a different"
	cont "#MON!"
	done

CeladonDeptStore3FLittleBoyText:
	text "You can identify"
	line "#MON you got"
	cont "in trades by"
	cont "their ID Numbers!"
	done

CeladonDeptStore3FSNESText:
	text "It's an SNES!"
	done

CeladonDeptStore3FRPGText:
	text "An RPG! There's"
	line "no time for that!"
	done

CeladonDeptStore3FSportsGameText:
	text "A sports game!"
	line "Dad'll like that!"
	done

CeladonDeptStore3FPuzzleGameText:
	text "A puzzle game!"
	line "Looks addictive!"
	done

CeladonDeptStore3FFightingGameText:
	text "A fighting game!"
	line "Looks tough!"
	done

CeladonDeptStore3FPokemonPosterText:
	text "Red and Blue!"
	line "Both are #MON!"
	done

CeladonDeptStore3FFloorSignText:
	text "3F: TV GAME SHOP"
	done

CeladonDeptStore3F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 12,  0, CELADON_DEPT_STORE_2F, 1
	warp_event 15,  0, CELADON_DEPT_STORE_4F, 2
	warp_event  2,  0, CELADON_DEPT_STORE_ELEVATOR, 1

	def_coord_events

	def_bg_events
; The eight display units sit on the two reachable MART_SHELF columns of
; maps/DeptStore3F.blk (x=1 and x=5, y=4..7); the three #MON posters and the
; floor sign are on the north wall.  Yellow's own coordinates do not survive the
; 20->16 tile width, and its poster row (y=1) is inside our counter alcove.
; The poster columns must also be ones the player can STAND in front of: x=5 and
; x=8 are wall, x=6/7 are the clerk's alcove (walled off at x=5 and along y=2, so
; the player can never stand there), x=2/12/15 are the elevator and the two
; staircases, x=3 is the elevator button, x=14 is the floor sign, and x=9/10 are
; the two trading GAMEBOY kids -- so the three posters are at x=4, 11 and 13
; (harness-verified, M6 9r).
	bg_event  1,  4, BGEVENT_READ, CeladonDeptStore3FSNES
	bg_event  1,  5, BGEVENT_READ, CeladonDeptStore3FRPG
	bg_event  5,  4, BGEVENT_READ, CeladonDeptStore3FSNES
	bg_event  5,  5, BGEVENT_READ, CeladonDeptStore3FSportsGame
	bg_event  1,  6, BGEVENT_READ, CeladonDeptStore3FSNES
	bg_event  1,  7, BGEVENT_READ, CeladonDeptStore3FPuzzleGame
	bg_event  5,  6, BGEVENT_READ, CeladonDeptStore3FSNES
	bg_event  5,  7, BGEVENT_READ, CeladonDeptStore3FFightingGame
	bg_event  4,  0, BGEVENT_READ, CeladonDeptStore3FPokemonPoster
	bg_event 13,  0, BGEVENT_READ, CeladonDeptStore3FPokemonPoster
	bg_event 11,  0, BGEVENT_READ, CeladonDeptStore3FPokemonPoster
	bg_event 14,  0, BGEVENT_READ, CeladonDeptStore3FFloorSign
	bg_event  3,  0, BGEVENT_READ, CeladonDeptStore3FElevatorButton

	def_object_events
	object_event  7,  1, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore3FClerkScript, -1
	object_event 11,  6, SPRITE_GAMEBOY_KID, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore3FGameboyKid1Script, -1
	object_event  9,  1, SPRITE_GAMEBOY_KID, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore3FGameboyKid2Script, -1
	object_event 10,  1, SPRITE_GAMEBOY_KID, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore3FGameboyKid3Script, -1
	object_event  2,  5, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore3FLittleBoyScript, -1
