; Kanto hack: Yellow's SAFARI ZONE GATE and its admission machine
; (docs/M7-FUCHSIA.md, 10k).  Yellow's original is
; vendor/pokeyellow/scripts/SafariZoneGate.asm + SafariZoneGate_2.asm, a
; seven-state per-frame machine; the field engine it drives is 10j's
; engine/events/safari_zone.asm and the battle side is 10i's.
;
; The room is Yellow's own 4x3 gate, re-cut in M1 onto TILESET_KANTO_GATE, and
; its blocks are byte-identical to Yellow's maps/SafariZoneGate.blk -- which is
; also byte-identical to the SAFFRON north/south gates', so this map shares
; maps/KantoGateSaffronNorthSouth.blk rather than spending twelve more bytes
; (data/maps/blocks.asm).  The corridor is x=3,4; the two SAFARI ZONE WORKERs
; stand in the alcoves at (6,2) and (1,4) and are talked to ACROSS the COUNTER
; tiles at x=5 / x=2, exactly as in Yellow.
;
; Yellow's machine is per-frame state; ours is a coord event with scene id -1,
; which fires in every scene (home/map.asm .CoordEventCheck), so the script
; itself is the guard -- the same trick maps/Museum1F.asm uses for the ticket
; counter, and it costs no scene var and no wram byte.  There are two bands:
;
;   (3,2) / (4,2)  the counter row.  Yellow's dbmapcoord 3,2 / 4,2: you cannot
;                  pass north without answering, and (3,2) is auto-walked one
;                  tile RIGHT first because worker1 is only reachable over the
;                  counter from (4,2).
;   (3,1) / (4,1)  the row inside the north doors, for the two ways you come
;                  BACK: walking out of the SAFARI ZONE mid-game, and 10j's
;                  ejection warp (SAFARI_ZONE_GATE 4,0 with
;                  ENGINE_SAFARI_GAME_OVER set).  Yellow prints those the
;                  instant you re-enter, from (4,1), and so do we; if the
;                  arrival step is swallowed the counter row catches it one
;                  tile later.
;
; State is 10j's, all of it already saved: ENGINE_SAFARI_ZONE (game running),
; ENGINE_SAFARI_GAME_OVER (ejected, D54's latch), and the SafariZoneStart /
; SafariZoneEnd specials for the balls, the steps and the flags.

	object_const_def
	const SAFARIZONEGATE_WORKER1
	const SAFARIZONEGATE_WORKER2

; Yellow's price, and the divisor of its poor-man's-discount easter egg (D56).
; The easter egg reads `ld a, 23` in vendor/pokeyellow/engine/... SafariZoneGate_2.asm,
; but DivideBCDPredef3 divides in BCD, so $17 is SEVENTEEN, not twenty-three --
; and only /17 can ever reach the 29-ball clamp Yellow codes right below it.
DEF SAFARI_ZONE_ADMISSION EQU 500
DEF SAFARI_ZONE_DISCOUNT_DIVISOR EQU 17
DEF SAFARI_ZONE_DISCOUNT_MAX_BALLS EQU 29

; Yellow keeps the "how many times has he asked?" count in wSafariSteps, which
; is zero whenever no game is running.  Ours goes in the low byte of 10j's
; wSafariTimeRemaining (`wSafariTimeRemaining + 1`, big-endian) for the same
; reason: SafariZoneStart overwrites it with LOW(SAFARI_STEPS) and
; SafariZoneEnd zeroes it, so it is scratch exactly as long as Yellow's is.
; It doubles as the quotient of the /17 division below.

SafariZoneGate_MapScripts:
	def_scene_scripts

	def_callbacks

; --- the counter row ------------------------------------------------------

SafariZoneGateCounterScript:
	checkflag ENGINE_SAFARI_GAME_OVER
	iftrue SafariZoneGateGoodHaulScript
	checkflag ENGINE_SAFARI_ZONE
	iftrue SafariZoneGateLeavingEarlyScript
	turnobject PLAYER, RIGHT
	opentext
	writetext SafariZoneGateWelcomeText
	waitbutton
	closetext
	readvar VAR_XCOORD
	ifequal 4, SafariZoneGateWouldYouLikeToJoinScript
	applymovement PLAYER, SafariZoneGateStepRightMovement
	; fallthrough

SafariZoneGateWouldYouLikeToJoinScript:
	opentext
	special PlaceMoneyTopRight
	writetext SafariZoneGateWouldYouLikeToJoinText
	yesorno
	iffalse .Declined
	checkmoney YOUR_MONEY, 0
	ifequal HAVE_AMOUNT, SafariZoneGateNoMoneyScript
	checkmoney YOUR_MONEY, SAFARI_ZONE_ADMISSION
	ifequal HAVE_LESS, SafariZoneGatePayWhatYouHaveScript
	takemoney YOUR_MONEY, SAFARI_ZONE_ADMISSION
	special PlaceMoneyTopRight
	playsound SFX_TRANSACTION
	waitsfx
	writetext SafariZoneGateThatllBe500Text
	promptbutton
	playsound SFX_GOT_SAFARI_BALLS
	waitsfx
	writetext SafariZoneGateCallYouOnThePAText
	waitbutton
	setval 0 ; SAFARI_BALLS
	special SafariZoneStart
	sjump SafariZoneGateEnterTheZoneScript

.Declined:
	writetext SafariZoneGatePleaseComeAgainText
	waitbutton
	sjump SafariZoneGateStepBackScript

; Money, but under ¥500: Yellow says so, then takes every last yen and hands
; out money/17 + 1 BALLs, clamped to 29 (vendor/pokeyellow SafariZoneEntrance-
; CalculateLowCostAdmission).  GSC money is 3-byte BINARY, not BCD, so the
; division is a subtract loop -- there is no DivideBCDPredef3 to borrow and
; engine/ is 10j's.
SafariZoneGatePayWhatYouHaveScript:
	writetext SafariZoneGateNotEnoughMoneyText
	waitbutton
	loadmem wSafariTimeRemaining + 1, 0
.divide:
	checkmoney YOUR_MONEY, SAFARI_ZONE_DISCOUNT_DIVISOR
	ifequal HAVE_LESS, .divided
	takemoney YOUR_MONEY, SAFARI_ZONE_DISCOUNT_DIVISOR
	readmem wSafariTimeRemaining + 1
	addval 1
	writemem wSafariTimeRemaining + 1
	sjump .divide

.divided:
	takemoney YOUR_MONEY, SAFARI_ZONE_ADMISSION ; the remainder; TakeMoney clamps at 0
	special PlaceMoneyTopRight
	writetext SafariZoneGatePayMeWhatYouHaveText
	promptbutton
	writetext SafariZoneGateCantGiveYouAll30Text
	waitbutton
	readmem wSafariTimeRemaining + 1
	addval 1
	ifless SAFARI_ZONE_DISCOUNT_MAX_BALLS + 1, .not_clamped
	setval SAFARI_ZONE_DISCOUNT_MAX_BALLS
.not_clamped:
	special SafariZoneStart
	sjump SafariZoneGateEnterTheZoneScript

; No money at all: the D56 easter egg.  Yellow refuses three times and lets you
; in for ONE free BALL on the fourth ask.  Yellow's fifth ask would index off
; the end of its own five-entry pointer table; ours repeats the fourth refusal,
; which is the only deviation in this file (see "10k findings").
SafariZoneGateNoMoneyScript:
	readmem wSafariTimeRemaining + 1
	addval 1
	writemem wSafariTimeRemaining + 1
	ifequal 1, .first
	ifequal 2, .second
	ifequal 3, .third
	ifequal 4, .free
	writetext SafariZoneGateReadMyLipsText
	sjump SafariZoneGateWalkDownScript

.first:
	writetext SafariZoneGateHaveToPayText
	sjump SafariZoneGateWalkDownScript

.second:
	writetext SafariZoneGateCantEnterWithoutPayingText
	sjump SafariZoneGateWalkDownScript

.third:
	writetext SafariZoneGateNoMoneyNoEntryText
	sjump SafariZoneGateWalkDownScript

.free:
	writetext SafariZoneGateReadMyLipsText
	waitbutton
	writetext SafariZoneGateYourePersistentText
	promptbutton
	playsound SFX_GOT_SAFARI_BALLS
	waitsfx
	setval 1
	special SafariZoneStart
	; fallthrough

; Yellow walks you UP 3 from the counter row, which spends the third step on
; the north door's warp.  GSC fires warps on player input, not on applymovement,
; so the door is a warpfacing of its own -- the same shape Crystal's own
; Route35NationalParkGate uses to walk you into the Bug Contest.  x is always 4
; here, so this is always Yellow's warp 4 -> SAFARI_ZONE_CENTER warp 2 (15,25).
SafariZoneGateEnterTheZoneScript:
	closetext
	applymovement PLAYER, SafariZoneGateEnterMovement
	playsound SFX_ENTER_DOOR
	special FadeOutToWhite
	waitsfx
	warpfacing UP, SAFARI_ZONE_CENTER, 15, 25
	end

SafariZoneGateWalkDownScript:
	waitbutton
SafariZoneGateStepBackScript:
	closetext
	applymovement PLAYER, SafariZoneGateStepBackMovement
	end

; --- the row inside the north doors ---------------------------------------

SafariZoneGateNorthDoorScript:
	checkflag ENGINE_SAFARI_GAME_OVER
	iftrue SafariZoneGateGoodHaulScript
	checkflag ENGINE_SAFARI_ZONE
	iftrue SafariZoneGateLeavingEarlyScript
	end

; Yellow's SafariZoneGateLeavingSafariScript, .leaving_early: you are on your
; way out with a game still running.  "No" sends you straight back in.
SafariZoneGateLeavingEarlyScript:
	turnobject PLAYER, DOWN
	opentext
	writetext SafariZoneGateLeavingEarlyText
	yesorno
	iffalse .NotReady
	writetext SafariZoneGateReturnSafariBallsText
	waitbutton
	closetext
	special SafariZoneEnd
	sjump SafariZoneGateWalkOutScript

.NotReady:
	writetext SafariZoneGateGoodLuckText
	waitbutton
	sjump SafariZoneGateEnterTheZoneScript

; Yellow's same script with EVENT_SAFARI_GAME_OVER set: 10j has just ejected
; you onto (4,0) because the steps or the BALLs ran out.
SafariZoneGateGoodHaulScript:
	turnobject PLAYER, DOWN
	opentext
	writetext SafariZoneGateGoodHaulComeAgainText
	waitbutton
	closetext
	special SafariZoneEnd
	; fallthrough

; Yellow walks you DOWN 3 from (4,1).  From the counter row that would land on
; the south door's warp tile, so from there it is two steps: either way you end
; up on y=4, clear of both bands.
SafariZoneGateWalkOutScript:
	readvar VAR_YCOORD
	ifequal 1, .from_the_door
	applymovement PLAYER, SafariZoneGateWalkOutFromCounterMovement
	end

.from_the_door:
	applymovement PLAYER, SafariZoneGateWalkOutMovement
	end

; --- the workers ----------------------------------------------------------

SafariZoneGateWorker1Script:
	jumptextfaceplayer SafariZoneGateWelcomeText

SafariZoneGateWorker2Script:
	faceplayer
	opentext
	writetext SafariZoneGateFirstTimeHereText
	yesorno
	iffalse .Regular
	writetext SafariZoneGateSafariZoneExplanationText
	waitbutton
	closetext
	end

.Regular:
	writetext SafariZoneGateYoureARegularHereText
	waitbutton
	closetext
	end

; --- movement -------------------------------------------------------------

SafariZoneGateStepRightMovement:
	step RIGHT
	step_end

SafariZoneGateStepBackMovement:
	step DOWN
	step_end

SafariZoneGateEnterMovement:
	step UP
	step_end

SafariZoneGateWalkOutFromCounterMovement:
	step DOWN
	step DOWN
	step_end

SafariZoneGateWalkOutMovement:
	step DOWN
	step DOWN
	step DOWN
	step_end

; --- text -----------------------------------------------------------------

SafariZoneGateWelcomeText:
	text "Welcome to the"
	line "SAFARI ZONE!"
	done

SafariZoneGateWouldYouLikeToJoinText:
	text "For just ¥{d:SAFARI_ZONE_ADMISSION},"
	line "you can catch all"
	cont "the #MON you"
	cont "want in the park!"

	para "Would you like to"
	line "join the hunt?"
	done

SafariZoneGateThatllBe500Text:
	text "That'll be ¥{d:SAFARI_ZONE_ADMISSION},"
	line "please!"

	para "We only use a"
	line "special # BALL"
	cont "here."

	para "<PLAYER> received"
	line "30 SAFARI BALLs!"
	prompt

SafariZoneGateCallYouOnThePAText:
	text "We'll call you on"
	line "the PA when you"
	cont "run out of time"
	cont "or SAFARI BALLs!"
	done

SafariZoneGatePleaseComeAgainText:
	text "OK! Please come"
	line "again!"
	done

SafariZoneGateNotEnoughMoneyText:
	text "Oops! Not enough"
	line "money!"
	done

SafariZoneGatePayMeWhatYouHaveText:
	text "Oh, all right, pay"
	line "me what you have."
	prompt

SafariZoneGateCantGiveYouAll30Text:
	text "But, I can't give"
	line "you all 30 BALLs."
	done

SafariZoneGateHaveToPayText:
	text "I'm sorry, but you"
	line "have to pay to"
	cont "enter."
	done

SafariZoneGateCantEnterWithoutPayingText:
	text "You can't enter"
	line "without paying!"
	done

SafariZoneGateNoMoneyNoEntryText:
	text "I said, no money,"
	line "no entry!"
	done

SafariZoneGateReadMyLipsText:
	text "Read my lips, NO!"
	line "Get it?"
	done

SafariZoneGateYourePersistentText:
	text "You're persistent,"
	line "aren't you?"

	para "OK, you can go in"
	line "for free, but"
	cont "just this once!"
	prompt

SafariZoneGateLeavingEarlyText:
	text "Leaving early?"
	done

SafariZoneGateReturnSafariBallsText:
	text "Please return any"
	line "SAFARI BALLs you"
	cont "have left."
	done

SafariZoneGateGoodLuckText:
	text "Good Luck!"
	done

SafariZoneGateGoodHaulComeAgainText:
	text "Did you get a"
	line "good haul?"
	cont "Come again!"
	done

SafariZoneGateFirstTimeHereText:
	text "Hi! Is it your"
	line "first time here?"
	done

SafariZoneGateSafariZoneExplanationText:
	text "SAFARI ZONE has 4"
	line "zones in it."

	para "Each zone has"
	line "different kinds"
	cont "of #MON. Use"
	cont "SAFARI BALLs to"
	cont "catch them!"

	para "When you run out"
	line "of time or SAFARI"
	cont "BALLs, it's game"
	cont "over for you!"

	para "Before you go,"
	line "open an unused"
	cont "#MON BOX so"
	cont "there's room for"
	cont "new #MON!"
	done

SafariZoneGateYoureARegularHereText:
	text "Sorry, you're a"
	line "regular here!"
	done

SafariZoneGate_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  5, FUCHSIA_CITY, 5
	warp_event  4,  5, FUCHSIA_CITY, 5
	warp_event  3,  0, SAFARI_ZONE_CENTER, 1
	warp_event  4,  0, SAFARI_ZONE_CENTER, 2

	def_coord_events
	coord_event  3,  1, -1, SafariZoneGateNorthDoorScript
	coord_event  4,  1, -1, SafariZoneGateNorthDoorScript
	coord_event  3,  2, -1, SafariZoneGateCounterScript
	coord_event  4,  2, -1, SafariZoneGateCounterScript

	def_bg_events

	def_object_events
	object_event  6,  2, SPRITE_SAFARI_ZONE_WORKER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, SafariZoneGateWorker1Script, -1
	object_event  1,  4, SPRITE_SAFARI_ZONE_WORKER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, SafariZoneGateWorker2Script, -1
