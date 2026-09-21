; Kanto hack (M8 11d, docs/M8-SAFFRON.md D75): Yellow's COPYCAT's room.
; Crystal's LOST_ITEM -> PASS chain is retired here -- Yellow's COPYCAT trades a
; POKe DOLL for TM31 MIMIC -- and with it go the gender callback and the second
; gender-gated COPYCAT object: Yellow's COPYCAT is always the BRUNETTE GIRL
; (SPRITE_LASS by the standing substitution, docs/M5-LAVENDER.md:1941), so she
; no longer mirrors the player's sprite.  The LOST_ITEM and PASS item consts
; stay compiled for the Johto act's MAGNET TRAIN; only the SAFFRON quest is
; gone.  Cast, coordinates, bg events and every line are Yellow's
; (vendor/pokeyellow/{data/maps/objects,scripts,text}/CopycatsHouse2F.asm),
; including the hidden NUGGET at (1,1) (data/events/hidden_item_coords.asm:54).
; Two positions shift by one tile because the players_house art puts a block's
; STAIRCASE collision on its top row only: the stairs down are (7,0), not
; Yellow's (7,1).  The SNES sign keeps Yellow's (3,5); the console art sits one
; tile above it on Crystal's table block.
	object_const_def
	const COPYCATSHOUSE2F_COPYCAT
	const COPYCATSHOUSE2F_DODUO
	const COPYCATSHOUSE2F_MONSTER
	const COPYCATSHOUSE2F_BIRD
	const COPYCATSHOUSE2F_FAIRY

CopycatsHouse2F_MapScripts:
	def_scene_scripts

	def_callbacks

Copycat:
	faceplayer
	opentext
	checkevent EVENT_GOT_TM31_MIMIC
	iftrue .GotTM31
	writetext CopycatDoYouLikePokemonText
	promptbutton
	checkitem POKE_DOLL
	iffalse .Done
	writetext CopycatTM31PreReceiveText
	promptbutton
	verbosegiveitem TM_MIMIC
	iffalse .NoRoom
	takeitem POKE_DOLL
	setevent EVENT_GOT_TM31_MIMIC
	writetext CopycatTM31Explanation1Text
	waitbutton
.Done:
	closetext
	end

.NoRoom:
	writetext CopycatTM31NoRoomText
	waitbutton
	closetext
	end

.GotTM31:
	writetext CopycatTM31Explanation2Text
	waitbutton
	closetext
	end

CopycatsDoduo:
	opentext
	writetext CopycatsDoduoText
	cry DODUO
	waitbutton
	closetext
	end

CopycatsHouse2FDoll:
	jumptext CopycatsHouse2FDollText

CopycatsHouse2FSNES:
	jumptext CopycatsHouse2FSNESText

; Yellow branches on the player's facing: you only read her diary from directly
; in front of the screen (vendor/pokeyellow/scripts/CopycatsHouse2F.asm).
CopycatsHouse2FPC:
	opentext
	readvar VAR_FACING
	ifequal UP, .Secrets
	writetext CopycatsHouse2FPCCantSeeText
	waitbutton
	closetext
	end

.Secrets:
	writetext CopycatsHouse2FPCMySecretsText
	waitbutton
	closetext
	end

CopycatsHouse2FHiddenNugget:
	hiddenitem NUGGET, EVENT_COPYCATS_HOUSE_2F_HIDDEN_NUGGET

CopycatDoYouLikePokemonText:
	text "<PLAYER>: Hi! Do"
	line "you like #MON?"

	para "<PLAYER>: Uh no, I"
	line "just asked you."

	para "<PLAYER>: Huh?"
	line "You're strange!"

	para "COPYCAT: Hmm?"
	line "Quit mimicking?"

	para "But, that's my"
	line "favorite hobby!"
	done

CopycatTM31PreReceiveText:
	text "Oh wow!"
	line "A # DOLL!"

	para "For me?"
	line "Thank you!"

	para "You can have"
	line "this, then!"
	done

CopycatTM31Explanation1Text:
; Yellow says "TM31"; our TM union numbers MIMIC as TM71
; (docs/TM-LEDGER.md, docs/M3B-TM-UNION.md) -- same treatment as ERIKA's TM67
; and MISTY's TM60.
	text "TM71 contains my"
	line "favorite, MIMIC!"

	para "Use it on a good"
	line "#MON!"
	done

CopycatTM31Explanation2Text:
; "TM31" -> "TM71", as above.
	text "<PLAYER>: Hi!"
	line "Thanks for TM71!"

	para "<PLAYER>: Pardon?"

	para "<PLAYER>: Is it"
	line "that fun to mimic"
	cont "my every move?"

	para "COPYCAT: You bet!"
	line "It's a scream!"
	done

CopycatTM31NoRoomText:
	text "Don't you want"
	line "this?"
	done

CopycatsDoduoText:
	text "DODUO: Giiih!"

	para "MIRROR MIRROR ON"
	line "THE WALL, WHO IS"
	cont "THE FAIREST ONE"
	cont "OF ALL?"
	done

CopycatsHouse2FDollText:
	text "This is a rare"
	line "#MON! Huh?"
	cont "It's only a doll!"
	done

CopycatsHouse2FSNESText:
	text "A game with MARIO"
	line "wearing a bucket"
	cont "on his head!"
	done

CopycatsHouse2FPCMySecretsText:
	text "…"

	para "My Secrets!"

	para "Skill: Mimicry!"
	line "Hobby: Collecting"
	cont "dolls!"
	cont "Favorite #MON:"
	cont "CLEFAIRY!"
	done

CopycatsHouse2FPCCantSeeText:
	text "Huh? Can't see!"
	done

CopycatsHouse2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  7,  0, COPYCATS_HOUSE_1F, 3

	def_coord_events

	def_bg_events
	bg_event  3,  5, BGEVENT_READ, CopycatsHouse2FSNES
	bg_event  0,  1, BGEVENT_READ, CopycatsHouse2FPC
	bg_event  1,  1, BGEVENT_ITEM, CopycatsHouse2FHiddenNugget ; Yellow's hidden NUGGET

	def_object_events
	object_event  4,  3, SPRITE_LASS, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Copycat, -1
	object_event  4,  6, SPRITE_BIRD, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, CopycatsDoduo, -1
	object_event  5,  1, SPRITE_MONSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CopycatsHouse2FDoll, -1
	object_event  2,  0, SPRITE_BIRD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CopycatsHouse2FDoll, -1
	object_event  1,  6, SPRITE_FAIRY, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CopycatsHouse2FDoll, -1
