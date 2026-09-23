; Kanto hack (M6 9u, docs/M6-CELADON.md §3.3): Yellow's CELADON GAME CORNER --
; "ROCKET GAME CORNER".  Yellow's 10x9 room (scripts/celadon_blk.py re-cuts the
; .blk), Yellow's eleven NPCs, its 36 slot machines (three of them broken), its
; twelve patches of hidden coins, the Rocket guarding the poster and the poster
; switch that opens the staircase down to ROCKET HIDEOUT B1F.
;
; Crystal's Card Flip tables, its soda can, its lighter, its two joke posters
; and its coin-vendor std script are all gone; the CardFlip engine itself is
; untouched (nothing else uses it yet, and deleting it is not 9u's job).  The
; prize counter is next door -- M6 9v.

	object_const_def
	const CELADONGAMECORNER_BEAUTY1
	const CELADONGAMECORNER_CLERK
	const CELADONGAMECORNER_POKEFAN_M1
	const CELADONGAMECORNER_BEAUTY2
	const CELADONGAMECORNER_FISHING_GURU1
	const CELADONGAMECORNER_POKEFAN_F
	const CELADONGAMECORNER_GYM_GUIDE
	const CELADONGAMECORNER_GENTLEMAN
	const CELADONGAMECORNER_POKEFAN_M2
	const CELADONGAMECORNER_FISHING_GURU2
	const CELADONGAMECORNER_ROCKET

CeladonGameCorner_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_TILES, CeladonGameCornerHideHideoutStairsCallback

CeladonGameCornerHideHideoutStairsCallback:
; The shipped .blk holds the STAIRCASE block ($41) at block (8,2); this paints
; plain wall over it until the poster switch has been pushed, which is how
; Yellow does it too (GameCornerSetRocketHideoutDoorTile writes $2a over $43
; while the event is clear).  changeblock takes TILE coordinates, so 16,4.
	checkevent EVENT_FOUND_ROCKET_HIDEOUT
	iftrue .done
	changeblock 16, 4, $02 ; wall
.done:
	endcallback

; --- the coin vendor ------------------------------------------------------
; Yellow's clerk, not Crystal's 50/500 GameCornerCoinVendorScript: one price,
; ¥1000 for 50 coins, offered as a yes/no.

CeladonGameCornerClerkScript:
	faceplayer
	opentext
	special DisplayMoneyAndCoinBalance
	writetext CeladonGameCornerClerkDoYouNeedSomeGameCoinsText
	yesorno
	iffalse .Declined
	checkitem COIN_CASE
	iffalse .NoCoinCase
	checkcoins 9989 ; Yellow's Has9990Coins
	ifequal HAVE_MORE, .CoinCaseFull
	checkmoney YOUR_MONEY, 1000
	ifequal HAVE_LESS, .CantAfford
	givecoins 50
	takemoney YOUR_MONEY, 1000
	special DisplayMoneyAndCoinBalance
	waitsfx
	playsound SFX_TRANSACTION
	writetext CeladonGameCornerClerkThanksHereAre50CoinsText
	waitbutton
	closetext
	end

.Declined:
	writetext CeladonGameCornerClerkPleaseComePlaySometimeText
	waitbutton
	closetext
	end

.NoCoinCase:
	writetext CeladonGameCornerClerkDontHaveCoinCaseText
	waitbutton
	closetext
	end

.CoinCaseFull:
	writetext CeladonGameCornerClerkCoinCaseIsFullText
	waitbutton
	closetext
	end

.CantAfford:
	writetext CeladonGameCornerClerkCantAffordTheCoinsText
	waitbutton
	closetext
	end

; --- the talkers ----------------------------------------------------------

CeladonGameCornerBeauty1Script:
	jumptextfaceplayer CeladonGameCornerBeauty1Text

CeladonGameCornerPokefanM1Script:
	faceplayer
	opentext
	writetext CeladonGameCornerPokefanM1Text
	waitbutton
	closetext
	turnobject CELADONGAMECORNER_POKEFAN_M1, LEFT
	end

CeladonGameCornerBeauty2Script:
	faceplayer
	opentext
	writetext CeladonGameCornerBeauty2Text
	waitbutton
	closetext
	turnobject CELADONGAMECORNER_BEAUTY2, LEFT
	end

CeladonGameCornerPokefanFScript:
	faceplayer
	opentext
	writetext CeladonGameCornerPokefanFText
	waitbutton
	closetext
	turnobject CELADONGAMECORNER_POKEFAN_F, LEFT
	end

CeladonGameCornerGymGuideScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_ERIKA
	iftrue .Beaten
	writetext CeladonGameCornerGymGuideChampInMakingText
	sjump .done

.Beaten:
	writetext CeladonGameCornerGymGuideTheyOfferRarePokemonText
.done:
	waitbutton
	closetext
	turnobject CELADONGAMECORNER_GYM_GUIDE, LEFT
	end

CeladonGameCornerGentlemanScript:
	faceplayer
	opentext
	writetext CeladonGameCornerGentlemanText
	waitbutton
	closetext
	turnobject CELADONGAMECORNER_GENTLEMAN, RIGHT
	end

; --- the three coin-giving NPCs -------------------------------------------
; All three follow Yellow: no COIN CASE prints the shared "Oops! Forgot the
; COIN CASE!", 9990 or more coins gets their own brush-off, and the gift is
; one-shot on its own flag.

CeladonGameCornerFishingGuru1Script:
	faceplayer
	opentext
	checkevent EVENT_GOT_COINS_FROM_GAME_CORNER_GURU_1
	iftrue .Already
	writetext CeladonGameCornerFishingGuru1WantToPlayText
	promptbutton
	checkitem COIN_CASE
	iffalse .NoCoinCase
	checkcoins 9989
	ifequal HAVE_MORE, .Full
	givecoins 10
	setevent EVENT_GOT_COINS_FROM_GAME_CORNER_GURU_1
	writetext CeladonGameCornerFishingGuru1Received10CoinsText
	playsound SFX_ITEM
	waitsfx
	waitbutton
	closetext
	turnobject CELADONGAMECORNER_FISHING_GURU1, RIGHT
	end

.Already:
	writetext CeladonGameCornerFishingGuru1WinsComeAndGoText
	sjump .done

.Full:
	writetext CeladonGameCornerFishingGuru1DontNeedMyCoinsText
	sjump .done

.NoCoinCase:
	writetext CeladonGameCornerOopsForgotCoinCaseText
.done:
	waitbutton
	closetext
	turnobject CELADONGAMECORNER_FISHING_GURU1, RIGHT
	end

CeladonGameCornerPokefanM2Script:
	faceplayer
	opentext
	checkevent EVENT_GOT_COINS_FROM_GAME_CORNER_MAN
	iftrue .Already
	writetext CeladonGameCornerPokefanM2WantSomeCoinsText
	promptbutton
	checkitem COIN_CASE
	iffalse .NoCoinCase
	checkcoins 9989
	ifequal HAVE_MORE, .Full
	givecoins 20
	setevent EVENT_GOT_COINS_FROM_GAME_CORNER_MAN
	writetext CeladonGameCornerPokefanM2Received20CoinsText
	playsound SFX_ITEM
	waitsfx
	waitbutton
	closetext
	turnobject CELADONGAMECORNER_POKEFAN_M2, LEFT
	end

.Already:
	writetext CeladonGameCornerPokefanM2INeedMoreCoinsText
	sjump .done

.Full:
	writetext CeladonGameCornerPokefanM2YouHaveLotsOfCoinsText
	sjump .done

.NoCoinCase:
	writetext CeladonGameCornerOopsForgotCoinCaseText
.done:
	waitbutton
	closetext
	turnobject CELADONGAMECORNER_POKEFAN_M2, LEFT
	end

CeladonGameCornerFishingGuru2Script:
	faceplayer
	opentext
	checkevent EVENT_GOT_COINS_FROM_GAME_CORNER_GURU_2
	iftrue .Already
	writetext CeladonGameCornerFishingGuru2ThrowingMeOffText
	promptbutton
	checkitem COIN_CASE
	iffalse .NoCoinCase
	checkcoins 9989
	ifequal HAVE_MORE, .Full
	givecoins 20
	setevent EVENT_GOT_COINS_FROM_GAME_CORNER_GURU_2
	writetext CeladonGameCornerFishingGuru2Received20CoinsText
	playsound SFX_ITEM
	waitsfx
	waitbutton
	closetext
	turnobject CELADONGAMECORNER_FISHING_GURU2, RIGHT
	end

.Already:
	writetext CeladonGameCornerFishingGuru2CloselyWatchTheReelsText
	sjump .done

.Full:
	writetext CeladonGameCornerFishingGuru2YouGotYourOwnCoinsText
	sjump .done

.NoCoinCase:
	writetext CeladonGameCornerOopsForgotCoinCaseText
.done:
	waitbutton
	closetext
	turnobject CELADONGAMECORNER_FISHING_GURU2, RIGHT
	end

; --- the Rocket and the poster --------------------------------------------

CeladonGameCornerRocketScript:
	faceplayer
	opentext
	writetext CeladonGameCornerRocketImGuardingThisPosterText
	waitbutton
	closetext
	winlosstext CeladonGameCornerRocketBattleEndText, 0
	setlasttalked CELADONGAMECORNER_ROCKET
	loadtrainer GRUNTM, GRUNTM_30
	startbattle
	reloadmapafterbattle
	opentext
	writetext CeladonGameCornerRocketAfterBattleText
	waitbutton
	closetext
; Yellow walks him five steps east when the player stands below him
; (wYCoord 6) or beside him on the left (wXCoord 8), and around the player
; otherwise.  (Yellow's else branch also plays a PIKACHU emote; we have no
; follower here, so it is dropped.)
	readvar VAR_YCOORD
	ifequal 6, .WalkDirect
	readvar VAR_XCOORD
	ifequal 8, .WalkDirect
	applymovement CELADONGAMECORNER_ROCKET, CeladonGameCornerRocketWalkAroundPlayerMovement
	sjump .Leave

.WalkDirect:
	applymovement CELADONGAMECORNER_ROCKET, CeladonGameCornerRocketWalkDirectMovement
.Leave:
	disappear CELADONGAMECORNER_ROCKET
	end

CeladonGameCornerRocketWalkAroundPlayerMovement:
	step DOWN
	step RIGHT
	step RIGHT
	step RIGHT
	step UP
	step RIGHT
	step RIGHT
	step RIGHT
	step_end

CeladonGameCornerRocketWalkDirectMovement:
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step_end

CeladonGameCornerShelfScript: ; BG2
	jumpstd KantoMerchandiseShelfScript

CeladonGameCornerPosterScript:
	opentext
	writetext CeladonGameCornerPosterText
	playsound SFX_PUSH_BUTTON
	waitsfx
	playsound SFX_ENTER_DOOR
	waitsfx
	setevent EVENT_FOUND_ROCKET_HIDEOUT
	changeblock 16, 4, $41 ; the staircase down to ROCKET HIDEOUT B1F
	refreshmap
	waitbutton
	closetext
	end

; --- the slot machines ----------------------------------------------------
; D44: Crystal's slot engine as-is, one lucky machine per pull.  The COIN CASE
; and no-coins gates are Yellow's (AbleToPlaySlotsCheck).

CeladonGameCornerSlotMachineScript:
	checkitem COIN_CASE
	iffalse .NoCoinCase
	checkcoins 1
	ifequal HAVE_LESS, .NoCoins
	random 6
	ifequal 0, .Lucky
	reanchormap
	setval FALSE
	special SlotMachine
	closetext
	end

.Lucky:
	reanchormap
	setval TRUE
	special SlotMachine
	closetext
	end

.NoCoinCase:
	opentext
	writetext CeladonGameCornerCoinCaseRequiredText
	waitbutton
	closetext
	end

.NoCoins:
	opentext
	writetext CeladonGameCornerNoCoinsText
	waitbutton
	closetext
	end

CeladonGameCornerOutOfOrderScript:
	jumptext CeladonGameCornerOutOfOrderText

CeladonGameCornerOutToLunchScript:
	jumptext CeladonGameCornerOutToLunchText

CeladonGameCornerSomeonesKeysScript:
	jumptext CeladonGameCornerSomeonesKeysText

; --- the hidden coins -----------------------------------------------------
; Yellow's HiddenCoins: silent without a COIN CASE, silent once taken, and a
; "dropped some coins" tail when the case is already full.

CeladonGameCornerCoin1:
	conditional_event EVENT_CELADON_GAME_CORNER_COIN_1, .Script
.Script:
	checkitem COIN_CASE
	iffalse CeladonGameCornerNoCoinCaseSilentScript
	setevent EVENT_CELADON_GAME_CORNER_COIN_1
	sjump CeladonGameCornerFound10CoinsScript

CeladonGameCornerCoin2:
	conditional_event EVENT_CELADON_GAME_CORNER_COIN_2, .Script
.Script:
	checkitem COIN_CASE
	iffalse CeladonGameCornerNoCoinCaseSilentScript
	setevent EVENT_CELADON_GAME_CORNER_COIN_2
	sjump CeladonGameCornerFound10CoinsScript

CeladonGameCornerCoin3:
	conditional_event EVENT_CELADON_GAME_CORNER_COIN_3, .Script
.Script:
	checkitem COIN_CASE
	iffalse CeladonGameCornerNoCoinCaseSilentScript
	setevent EVENT_CELADON_GAME_CORNER_COIN_3
	sjump CeladonGameCornerFound20CoinsScript

CeladonGameCornerCoin4:
	conditional_event EVENT_CELADON_GAME_CORNER_COIN_4, .Script
.Script:
	checkitem COIN_CASE
	iffalse CeladonGameCornerNoCoinCaseSilentScript
	setevent EVENT_CELADON_GAME_CORNER_COIN_4
	sjump CeladonGameCornerFound10CoinsScript

CeladonGameCornerCoin5:
	conditional_event EVENT_CELADON_GAME_CORNER_COIN_5, .Script
.Script:
	checkitem COIN_CASE
	iffalse CeladonGameCornerNoCoinCaseSilentScript
	setevent EVENT_CELADON_GAME_CORNER_COIN_5
	sjump CeladonGameCornerFound10CoinsScript

CeladonGameCornerCoin6:
	conditional_event EVENT_CELADON_GAME_CORNER_COIN_6, .Script
.Script:
	checkitem COIN_CASE
	iffalse CeladonGameCornerNoCoinCaseSilentScript
	setevent EVENT_CELADON_GAME_CORNER_COIN_6
	sjump CeladonGameCornerFound20CoinsScript

CeladonGameCornerCoin7:
	conditional_event EVENT_CELADON_GAME_CORNER_COIN_7, .Script
.Script:
	checkitem COIN_CASE
	iffalse CeladonGameCornerNoCoinCaseSilentScript
	setevent EVENT_CELADON_GAME_CORNER_COIN_7
	sjump CeladonGameCornerFound10CoinsScript

CeladonGameCornerCoin8:
	conditional_event EVENT_CELADON_GAME_CORNER_COIN_8, .Script
.Script:
	checkitem COIN_CASE
	iffalse CeladonGameCornerNoCoinCaseSilentScript
	setevent EVENT_CELADON_GAME_CORNER_COIN_8
	sjump CeladonGameCornerFound10CoinsScript

CeladonGameCornerCoin9:
	conditional_event EVENT_CELADON_GAME_CORNER_COIN_9, .Script
.Script:
	checkitem COIN_CASE
	iffalse CeladonGameCornerNoCoinCaseSilentScript
	setevent EVENT_CELADON_GAME_CORNER_COIN_9
	sjump CeladonGameCornerFound10CoinsScript

CeladonGameCornerCoin10:
	conditional_event EVENT_CELADON_GAME_CORNER_COIN_10, .Script
.Script:
	checkitem COIN_CASE
	iffalse CeladonGameCornerNoCoinCaseSilentScript
	setevent EVENT_CELADON_GAME_CORNER_COIN_10
	sjump CeladonGameCornerFound40CoinsScript

CeladonGameCornerCoin11:
	conditional_event EVENT_CELADON_GAME_CORNER_COIN_11, .Script
.Script:
	checkitem COIN_CASE
	iffalse CeladonGameCornerNoCoinCaseSilentScript
	setevent EVENT_CELADON_GAME_CORNER_COIN_11
	sjump CeladonGameCornerFound100CoinsScript

; Unreachable -- and unreachable in Yellow too: the slot machine bg_event on
; the same tile comes first in the list, and both engines take the first match.
CeladonGameCornerCoin12:
	conditional_event EVENT_CELADON_GAME_CORNER_COIN_12, .Script
.Script:
	checkitem COIN_CASE
	iffalse CeladonGameCornerNoCoinCaseSilentScript
	setevent EVENT_CELADON_GAME_CORNER_COIN_12
	sjump CeladonGameCornerFound10CoinsScript

CeladonGameCornerNoCoinCaseSilentScript:
	end

CeladonGameCornerFound10CoinsScript:
	givecoins 10
	opentext
	writetext CeladonGameCornerFound10CoinsText
	sjump CeladonGameCornerFoundCoinsTailScript

CeladonGameCornerFound20CoinsScript:
	givecoins 20
	opentext
	writetext CeladonGameCornerFound20CoinsText
	sjump CeladonGameCornerFoundCoinsTailScript

CeladonGameCornerFound40CoinsScript:
	givecoins 40
	opentext
	writetext CeladonGameCornerFound40CoinsText
	sjump CeladonGameCornerFoundCoinsTailScript

CeladonGameCornerFound100CoinsScript:
	givecoins 100
	opentext
	writetext CeladonGameCornerFound100CoinsText
	sjump CeladonGameCornerFoundCoinsTailScript

CeladonGameCornerFoundCoinsTailScript:
	playsound SFX_ITEM
	waitsfx
	waitbutton
	checkcoins MAX_COINS - 1
	ifequal HAVE_MORE, .Dropped
	closetext
	end

.Dropped:
	writetext CeladonGameCornerDroppedCoinsText
	waitbutton
	closetext
	end

; --- text -----------------------------------------------------------------

CeladonGameCornerBeauty1Text:
	text "Welcome!"

	para "You can exchange"
	line "your coins for"
	cont "fabulous prizes"
	cont "next door."
	done

CeladonGameCornerClerkDoYouNeedSomeGameCoinsText:
	text "Welcome to ROCKET"
	line "GAME CORNER!"

	para "Do you need some"
	line "game coins?"

	para "It's ¥1000 for 50"
	line "coins. Would you"
	cont "like some?"
	done

CeladonGameCornerClerkThanksHereAre50CoinsText:
	text "Thanks! Here are"
	line "your 50 coins!"
	done

CeladonGameCornerClerkPleaseComePlaySometimeText:
	text "No? Please come"
	line "play sometime!"
	done

CeladonGameCornerClerkCantAffordTheCoinsText:
	text "You can't afford"
	line "the coins!"
	done

CeladonGameCornerClerkCoinCaseIsFullText:
	text "Oops! Your COIN"
	line "CASE is full."
	done

CeladonGameCornerClerkDontHaveCoinCaseText:
	text "You don't have a"
	line "COIN CASE!"
	done

CeladonGameCornerPokefanM1Text:
	text "Keep this quiet."

	para "It's rumored that"
	line "this place is run"
	cont "by TEAM ROCKET."
	done

CeladonGameCornerBeauty2Text:
	text "I think these"
	line "machines have"
	cont "different odds."
	done

CeladonGameCornerFishingGuru1WantToPlayText:
	text "Kid, do you want"
	line "to play?"
	prompt

CeladonGameCornerFishingGuru1Received10CoinsText:
	text "<PLAYER> received"
	line "10 coins!"
	done

CeladonGameCornerFishingGuru1DontNeedMyCoinsText:
	text "You don't need my"
	line "coins!"
	done

CeladonGameCornerFishingGuru1WinsComeAndGoText:
	text "Wins seem to come"
	line "and go."
	done

CeladonGameCornerPokefanFText:
	text "I'm having a"
	line "wonderful time!"
	done

CeladonGameCornerGymGuideChampInMakingText:
	text "Hey!"

	para "You have better"
	line "things to do,"
	cont "champ in making!"

	para "CELADON GYM's"
	line "LEADER is ERIKA!"
	cont "She uses grass-"
	cont "type #MON!"

	para "She might appear"
	line "docile, but don't"
	cont "be fooled!"
	done

CeladonGameCornerGymGuideTheyOfferRarePokemonText:
	text "They offer rare"
	line "#MON that can"
	cont "be exchanged for"
	cont "your coins."

	para "But, I just can't"
	line "seem to win!"
	done

CeladonGameCornerGentlemanText:
	text "Games are scary!"
	line "It's so easy to"
	cont "get hooked!"
	done

CeladonGameCornerPokefanM2WantSomeCoinsText:
	text "What's up? Want"
	line "some coins?"
	prompt

CeladonGameCornerPokefanM2Received20CoinsText:
	text "<PLAYER> received"
	line "20 coins!"
	done

CeladonGameCornerPokefanM2YouHaveLotsOfCoinsText:
	text "You have lots of"
	line "coins!"
	done

CeladonGameCornerPokefanM2INeedMoreCoinsText:
	text "Darn! I need more"
	line "coins for the"
	cont "#MON I want!"
	done

CeladonGameCornerFishingGuru2ThrowingMeOffText:
	text "Hey, what? You're"
	line "throwing me off!"
	cont "Here are some"
	cont "coins, shoo!"
	prompt

CeladonGameCornerFishingGuru2Received20CoinsText:
	text "<PLAYER> received"
	line "20 coins!"
	done

CeladonGameCornerFishingGuru2YouGotYourOwnCoinsText:
	text "You've got your"
	line "own coins!"
	done

CeladonGameCornerFishingGuru2CloselyWatchTheReelsText:
	text "The trick is to"
	line "watch the reels"
	cont "closely!"
	done

CeladonGameCornerOopsForgotCoinCaseText:
	text "Oops! Forgot the"
	line "COIN CASE!"
	done

CeladonGameCornerRocketImGuardingThisPosterText:
	text "I'm guarding this"
	line "poster!"
	cont "Go away, or else!"
	done

CeladonGameCornerRocketBattleEndText:
	text "Dang!"
	prompt

CeladonGameCornerRocketAfterBattleText:
	text "Our hideout might"
	line "be discovered! I"
	cont "better tell BOSS!"
	done

CeladonGameCornerPosterText:
	text "Hey!"

	para "A switch behind"
	line "the poster!?"
	cont "Let's push it!"
	done

CeladonGameCornerCoinCaseRequiredText:
	text "A COIN CASE is"
	line "required!"
	done

CeladonGameCornerNoCoinsText:
	text "You don't have"
	line "any coins!"
	done

CeladonGameCornerOutOfOrderText:
	text "OUT OF ORDER"
	line "This is broken."
	done

CeladonGameCornerOutToLunchText:
	text "OUT TO LUNCH"
	line "This is reserved."
	done

CeladonGameCornerSomeonesKeysText:
	text "Someone's keys!"
	line "They'll be back."
	done

CeladonGameCornerFound10CoinsText:
	text "<PLAYER> found"
	line "10 coins!"
	done

CeladonGameCornerFound20CoinsText:
	text "<PLAYER> found"
	line "20 coins!"
	done

CeladonGameCornerFound40CoinsText:
	text "<PLAYER> found"
	line "40 coins!"
	done

CeladonGameCornerFound100CoinsText:
	text "<PLAYER> found"
	line "100 coins!"
	done

CeladonGameCornerDroppedCoinsText:
	text "Oops! Dropped"
	line "some coins!"
	done

CeladonGameCorner_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 15, 17, CELADON_CITY, 8 ; Kanto hack (M6 9p): Yellow's city warp 8
	warp_event 16, 17, CELADON_CITY, 8
	warp_event 17,  4, ROCKET_HIDEOUT_B1F, 2

	def_coord_events

	def_bg_events
; Yellow's order, and the order matters: both engines take the FIRST bg_event
; whose coordinates match, so the slot machine at (12,15) shadows the twelfth
; patch of coins underneath it -- in Yellow too.
	bg_event 18, 15, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event 18, 14, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event 18, 13, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event 18, 12, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event 18, 11, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event 18, 10, BGEVENT_READ, CeladonGameCornerSomeonesKeysScript
	bg_event 13, 10, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event 13, 11, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event 13, 12, BGEVENT_READ, CeladonGameCornerOutToLunchScript
	bg_event 13, 13, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event 13, 14, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event 13, 15, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event 12, 15, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event 12, 14, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event 12, 13, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event 12, 12, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event 12, 11, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event 12, 10, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event  7, 10, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event  7, 11, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event  7, 12, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event  7, 13, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event  7, 14, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event  7, 15, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event  6, 15, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event  6, 14, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event  6, 13, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event  6, 12, BGEVENT_READ, CeladonGameCornerOutOfOrderScript
	bg_event  6, 11, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event  6, 10, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event  1, 10, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event  1, 11, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event  1, 12, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event  1, 13, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event  1, 14, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event  1, 15, BGEVENT_READ, CeladonGameCornerSlotMachineScript
	bg_event  0,  8, BGEVENT_IFNOTSET, CeladonGameCornerCoin1
	bg_event  1, 16, BGEVENT_IFNOTSET, CeladonGameCornerCoin2
	bg_event  3, 11, BGEVENT_IFNOTSET, CeladonGameCornerCoin3
	bg_event  3, 14, BGEVENT_IFNOTSET, CeladonGameCornerCoin4
	bg_event  4, 12, BGEVENT_IFNOTSET, CeladonGameCornerCoin5
	bg_event  9, 12, BGEVENT_IFNOTSET, CeladonGameCornerCoin6
	bg_event  9, 15, BGEVENT_IFNOTSET, CeladonGameCornerCoin7
	bg_event 16, 14, BGEVENT_IFNOTSET, CeladonGameCornerCoin8
	bg_event 10, 16, BGEVENT_IFNOTSET, CeladonGameCornerCoin9
	bg_event 11,  7, BGEVENT_IFNOTSET, CeladonGameCornerCoin10
	bg_event 15,  8, BGEVENT_IFNOTSET, CeladonGameCornerCoin11
	bg_event 12, 15, BGEVENT_IFNOTSET, CeladonGameCornerCoin12
	bg_event  9,  4, BGEVENT_READ, CeladonGameCornerPosterScript
; BG2: Yellow's LOBBY shelf tiles $50/$52 on (0,5)-(7,5) say PokemonStuffText,
; facing UP only (bookshelf_tile_ids.asm); here they are solid cabinet art.
	bg_event  0,  5, BGEVENT_UP, CeladonGameCornerShelfScript
	bg_event  1,  5, BGEVENT_UP, CeladonGameCornerShelfScript
	bg_event  2,  5, BGEVENT_UP, CeladonGameCornerShelfScript
	bg_event  3,  5, BGEVENT_UP, CeladonGameCornerShelfScript
	bg_event  4,  5, BGEVENT_UP, CeladonGameCornerShelfScript
	bg_event  5,  5, BGEVENT_UP, CeladonGameCornerShelfScript
	bg_event  6,  5, BGEVENT_UP, CeladonGameCornerShelfScript
	bg_event  7,  5, BGEVENT_UP, CeladonGameCornerShelfScript

	def_object_events
	object_event  2,  6, SPRITE_BEAUTY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonGameCornerBeauty1Script, -1
	object_event  5,  6, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonGameCornerClerkScript, -1
	object_event  2, 10, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonGameCornerPokefanM1Script, -1
	object_event  2, 13, SPRITE_BEAUTY, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonGameCornerBeauty2Script, -1
	object_event  5, 11, SPRITE_FISHING_GURU, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonGameCornerFishingGuru1Script, -1
	object_event  8, 11, SPRITE_POKEFAN_F, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonGameCornerPokefanFScript, -1
	object_event  8, 14, SPRITE_GYM_GUIDE, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonGameCornerGymGuideScript, -1
	object_event 11, 15, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonGameCornerGentlemanScript, -1
	object_event 14, 11, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonGameCornerPokefanM2Script, -1
	object_event 17, 13, SPRITE_FISHING_GURU, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonGameCornerFishingGuru2Script, -1
	object_event  9,  5, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonGameCornerRocketScript, EVENT_CELADON_GAME_CORNER_ROCKET_HIDDEN
