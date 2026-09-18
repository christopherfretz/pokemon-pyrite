; Kanto hack: Yellow's POKeMON FAN CLUB (docs/M4-VERMILION.md 7f).  Objects come
; from vendor/pokeyellow/data/maps/objects/PokemonFanClub.asm, the scripts from
; vendor/pokeyellow/scripts/PokemonFanClub.asm and every line of text from
; vendor/pokeyellow/text/PokemonFanClub.asm.
;
; Crystal's whole cast is gone with 7f: the RARE CANDY chairman, the CLEFAIRY
; guy who hands over the LOST_ITEM for Copycat, the CLEFAIRY DOLL object, the
; BAYLEEF teacher and both bg_events -- Yellow's Fan Club has no signs at all.
;
; Geometry: Yellow's room is 4x4 blocks (8x8 tiles), ours is Crystal's 5x4
; (10x8), so the two side columns move out by one tile and everything else is
; Yellow's own coordinate (scripts/mapgrid.py PokemonFanClub):
;   CLEFAIRY_FAN  Yellow (6,3) -> (7,3)      CHAIRMAN     Yellow (3,1) -> (3,1)
;   SEEL_FAN      Yellow (1,3) -> (2,3)      RECEPTIONIST Yellow (5,1) -> (5,1)
;   CLEFAIRY      Yellow (6,4) -> (7,4)      warps        (2,7)/(3,7), unmoved
;   SEEL          Yellow (1,4) -> (2,4)
; and the Pikachu scene's landing tile, Yellow's (6,5) directly below the
; CLEFAIRY, is ours (7,5).
;
; Sprites: Yellow's SPRITE_SEEL and SPRITE_CLEFAIRY have no Crystal counterpart
; (Crystal's SPRITE_CLEFAIRY $8f is a SpriteMons party icon and SPRITE_FAIRY
; $4d is the CLEFAIRY DOLL sheet), so 7f added SPRITE_SEEL_OW / SPRITE_CLEFAIRY_OW
; from Yellow's own art.  SPRITE_GIRL -> SPRITE_LASS and
; SPRITE_LINK_RECEPTIONIST -> SPRITE_RECEPTIONIST are the established
; substitutions.
	object_const_def
	const POKEMONFANCLUB_CLEFAIRY_FAN
	const POKEMONFANCLUB_SEEL_FAN
	const POKEMONFANCLUB_CLEFAIRY
	const POKEMONFANCLUB_SEEL
	const POKEMONFANCLUB_CHAIRMAN
	const POKEMONFANCLUB_RECEPTIONIST

PokemonFanClub_MapScripts:
	def_scene_scripts

	def_callbacks

; Yellow's PokemonFanClubScript0/1 (vendor/pokeyellow/scripts/PokemonFanClub.asm:11).
; Yellow runs this from the map script, i.e. on the frame the map comes up, and
; re-arms it from VERMILION_CITY; GSC has no per-frame map script, so it is a
; coord_event on the two tiles in front of the two doors -- the first step the
; player takes into the room, which is also exactly where Yellow's scene starts
; (Pikachu is left standing on the door tile behind them, Yellow's (3,7)).
; First qualifying entry always fires, later ones are Yellow's dice roll.
PokemonFanClubPikachuSceneScript:
	checkevent EVENT_POKEMON_FAN_CLUB_PIKACHU_SCENE
	iffalse .roll_not_needed
; Yellow: `cp 25` on a 0-255 Random, i.e. 25/256 = 9.8%.  Script `random` cannot
; take 256 (Script_random returns 0 for an input of 0), so this is 12/128 = 9.4%.
	random 128
	ifgreater 11, .done
.roll_not_needed
	special FanClubPikachuScene
	iffalse .done
	setevent EVENT_POKEMON_FAN_CLUB_PIKACHU_SCENE
; Yellow pokes the CLEFAIRY's sprite-state block directly (`ld a, $2 /
; ld [wSprite03StateData1MovementStatus]`, mis-commented "Seel" in pret --
; Pikachu is sprite struct 15, so struct 3 is the third object_event).
	turnobject POKEMONFANCLUB_CLEFAIRY, DOWN
	special FanClubPikachuFace
.done
	end

; Yellow's PokemonFanClubChairmanText (scripts/PokemonFanClub.asm:180).  Three
; states: before the voucher, after the voucher but still inside the building,
; and -- once EVENT_LEFT_FANCLUB_AFTER_BIKE_VOUCHER has been set on the way out
; (VermilionCityFlypointCallback) -- the GB Printer photo offer.
PokemonFanClubChairmanScript:
	faceplayer
	opentext
	checkevent EVENT_LEFT_FANCLUB_AFTER_BIKE_VOUCHER
	iftrue .Photo
	checkevent EVENT_GOT_BIKE_VOUCHER
	iftrue .NothingLeft
	writetext PokemonFanClubChairmanIntroText
	yesorno
	iffalse .NoStory
	writetext PokemonFanClubChairmanStoryText
	promptbutton
	verbosegiveitem BIKE_VOUCHER
	iffalse .BagFull
	setevent EVENT_GOT_BIKE_VOUCHER
	writetext PokemonFanClubExplainBikeVoucherText
	waitbutton
	closetext
	end

.NoStory:
	writetext PokemonFanClubNoStoryText
	waitbutton
	closetext
	end

; Yellow prints its own line after the failed GiveItem; verbosegiveitem has
; already shown the shared "The KEY ITEMS is full…" page (the same pairing
; MtMoonB2F's fossils use).
.BagFull:
	writetext PokemonFanClubBagFullText
	waitbutton
	closetext
	end

.NothingLeft:
	writetext PokemonFanClubChairFinalText
	waitbutton
	closetext
	end

.Photo:
	writetext PokemonFanClubChairPrintText1
	yesorno
	iffalse .NoPhoto
	special FanClubPhoto
	iffalse .NoPhoto
	ifequal FANCLUB_PHOTO_CANCELLED, .PhotoCancelled
	writetext PokemonFanClubChairPrintText3
	waitbutton
	closetext
	end

.PhotoCancelled:
	writetext PokemonFanClubChairPrintText4
	waitbutton
	closetext
	end

.NoPhoto:
	writetext PokemonFanClubChairPrintText2
	waitbutton
	closetext
	end

; Yellow's PokemonFanClubClefairyFanText / PokemonFanClubSeelFanText: not a gate
; on the chairman (he never reads either flag) but a pair of braggarts talking
; past each other.  Each one, when the OTHER has just boasted, one-ups them and
; clears the other's flag; otherwise it sets its own.  Yellow's flag names are
; kept: EVENT_PIKACHU_FAN_BOAST is the CLEFAIRY fan's "I went first" bit (the
; Japanese release's fan had a PIKACHU), EVENT_SEEL_FAN_BOAST the SEEL fan's.
PokemonFanClubClefairyFanScript:
	faceplayer
	opentext
	checkevent EVENT_LEFT_FANCLUB_AFTER_BIKE_VOUCHER
	iftrue .Print
	checkevent EVENT_PIKACHU_FAN_BOAST
	iftrue .MineIsBetter
	setevent EVENT_SEEL_FAN_BOAST
	writetext PokemonFanClubClefairyFanNormalText
	waitbutton
	closetext
	end

.MineIsBetter:
	clearevent EVENT_PIKACHU_FAN_BOAST
	writetext PokemonFanClubClefairyFanBetterText
	waitbutton
	closetext
	end

.Print:
	writetext PokemonFanClubClefairyFanText
	waitbutton
	closetext
	end

PokemonFanClubSeelFanScript:
	faceplayer
	opentext
	checkevent EVENT_LEFT_FANCLUB_AFTER_BIKE_VOUCHER
	iftrue .Print
	checkevent EVENT_SEEL_FAN_BOAST
	iftrue .MineIsBetter
	setevent EVENT_PIKACHU_FAN_BOAST
	writetext PokemonFanClubSeelFanNormalText
	waitbutton
	closetext
	end

.MineIsBetter:
	clearevent EVENT_SEEL_FAN_BOAST
	writetext PokemonFanClubSeelFanBetterText
	waitbutton
	closetext
	end

.Print:
	writetext PokemonFanClubSeelFanText
	waitbutton
	closetext
	end

PokemonFanClubClefairyScript:
	opentext
	writetext PokemonFanClubClefairyText
	cry CLEFAIRY
	waitbutton
	closetext
	end

PokemonFanClubSeelScript:
	opentext
	writetext PokemonFanClubSeelText
	cry SEEL
	waitbutton
	closetext
	end

PokemonFanClubReceptionistScript:
	jumptextfaceplayer PokemonFanClubReceptionistText

PokemonFanClubChairmanIntroText:
	text "I chair the"
	line "#MON Fan Club!"

	para "I have more than"
	line "100 #MON. I"
	cont "love them all!"

	para "I'm very fussy"
	line "when it comes to"
	cont "#MON!"

	para "So…"

	para "Did you come to"
	line "hear me brag"
	cont "about my #MON?"
	done

PokemonFanClubChairmanStoryText:
	text "Good!"
	line "Then listen up!"

	para "My favorite"
	line "RAPIDASH…"

	para "It…cute…"
	line "lovely…smart…"
	cont "plus…amazing…"
	cont "you think so?…"
	cont "oh yes…it…"
	cont "stunning…"
	cont "kindly…"
	cont "love it!"

	para "Hug it…when…"
	line "sleeping…warm"
	cont "and cuddly…"
	cont "spectacular…"
	cont "ravishing…"
	cont "…Oops! Look at"
	cont "the time! I kept"
	cont "you too long!"

	para "Thanks for hearing"
	line "me out! I want"
	cont "you to have this!"
	prompt

; Yellow's _PokemonFanClubReceivedBikeVoucherText ("<PLAYER> received a BIKE
; VOUCHER!") and its sound_get_key_item are verbosegiveitem's shared
; _ReceivedItemText + specialsound here, so this picks up straight afterwards.
PokemonFanClubExplainBikeVoucherText:
	text "Exchange that for"
	line "a BICYCLE!"

	para "Don't worry, my"
	line "FEAROW will FLY"
	cont "me anywhere!"

	para "So, I don't need a"
	line "BICYCLE!"

	para "I hope you like"
	line "cycling!"
	done

PokemonFanClubNoStoryText:
	text "Oh. Come back"
	line "when you want to"
	cont "hear my story!"
	done

PokemonFanClubChairFinalText:
	text "Hello, <PLAYER>!"

	para "Did you come see"
	line "me about my"
	cont "#MON again?"

	para "No? Too bad!"
	done

PokemonFanClubBagFullText:
	text "Make room for"
	line "this!"
	done

PokemonFanClubChairPrintText1:
	text "Hi there, <PLAYER>!"
	line "Have you seen my"
	cont "#MON photos?"

	para "I have them framed"
	line "up on that wall."

	para "Ah, I know!"

	para "Would you like me"
	line "to take a photo"
	cont "of your #MON?"
	done

PokemonFanClubChairPrintText2:
	text "No? That's really"
	line "disappointing."
	done

PokemonFanClubChairPrintText3:
	text "OK, I'm done."
	done

PokemonFanClubChairPrintText4:
	text "Maybe we won't"
	line "PRINT this now."
	done

PokemonFanClubClefairyFanNormalText:
	text "Won't you admire"
	line "my CLEFAIRY's"
	cont "adorable tail?"
	done

PokemonFanClubClefairyFanBetterText:
	text "Humph! My CLEFAIRY"
	line "is twice as cute"
	cont "as that one!"
	done

PokemonFanClubClefairyFanText:
	text "Our CHAIRMAN's new"
	line "hobby is taking"
	cont "#MON photos."

	para "He gave me a nice"
	line "PRINT of my cute"
	cont "CLEFAIRY."
	done

PokemonFanClubSeelFanNormalText:
	text "I just love my"
	line "SEEL!"

	para "It squeals when I"
	line "hug it!"
	done

PokemonFanClubSeelFanBetterText:
	text "Oh dear!"

	para "My SEEL is far"
	line "more attractive!"
	done

PokemonFanClubSeelFanText:
	text "I'm going to hook"
	line "up the cable to"
	cont "get a photo PRINT"
	cont "of my SEEL!"
	done

PokemonFanClubClefairyText:
	text "CLEFAIRY: Pippii!"
	done

PokemonFanClubSeelText:
	text "SEEL: Kyuoo!"
	done

PokemonFanClubReceptionistText:
	text "Our CHAIRMAN is"
	line "very vocal about"
	cont "#MON."
	done

PokemonFanClub_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, VERMILION_CITY, 2
	warp_event  3,  7, VERMILION_CITY, 2

	def_coord_events
	coord_event  2,  6, -1, PokemonFanClubPikachuSceneScript
	coord_event  3,  6, -1, PokemonFanClubPikachuSceneScript

	def_bg_events

	def_object_events
	object_event  7,  3, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PokemonFanClubClefairyFanScript, -1
	object_event  2,  3, SPRITE_LASS, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PokemonFanClubSeelFanScript, -1
	object_event  7,  4, SPRITE_CLEFAIRY_OW, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PokemonFanClubClefairyScript, -1
	object_event  2,  4, SPRITE_SEEL_OW, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PokemonFanClubSeelScript, -1
	object_event  3,  1, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PokemonFanClubChairmanScript, -1
	object_event  5,  1, SPRITE_RECEPTIONIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, PokemonFanClubReceptionistScript, -1
