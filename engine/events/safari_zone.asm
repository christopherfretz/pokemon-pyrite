; Kanto hack M7 10j: the FIELD side of Pokemon Yellow's SAFARI ZONE game
; (docs/M7-FUCHSIA.md D53/D54/D59/D60 and SS0.6 row 10j).  The battle side is
; engine/battle/safari.asm (10i); the SAFARI ZONE GATE script that starts and
; finishes a game is maps/SafariZoneGate.asm (10k).
;
; Yellow's original is vendor/pokeyellow/engine/events/hidden_events/safari_game.asm
; plus its two call sites in home/overworld.asm.  Structurally this is Crystal's
; Bug-Catching Contest with a step counter instead of a clock, so it is written
; the same way: an asm hook that returns carry, and scripts reached through
; CallScript.
;
; Saved state is Crystal's own (no new saved bytes):
;   wSafariBallsRemaining  db  - SAFARI BALLs left        (Yellow wNumSafariBalls)
;   wSafariTimeRemaining   dw  - steps left, BIG-endian   (Yellow wSafariSteps)
;   ENGINE_SAFARI_ZONE         - the game is running      (Yellow EVENT_IN_SAFARI_ZONE)
;   ENGINE_SAFARI_GAME_OVER    - the game ended and the player was ejected to the
;                                gate (Yellow EVENT_SAFARI_GAME_OVER); D54's latch,
;                                wStatusFlags2 bit STATUSFLAGS2_UNUSED_3_F.


SafariZoneStart::
; special.  Starts a game: wScriptVar SAFARI BALLs (0 => SAFARI_BALLS),
; SAFARI_STEPS steps, the game flag on, the game-over latch off.
; Yellow does the same in vendor/pokeyellow/scripts/SafariZoneGate_2.asm, where
; the poor man's discount hands the ball count in a and 502 is unconditional.
	ld a, [wScriptVar]
	and a
	jr nz, .got_balls
	ld a, SAFARI_BALLS
.got_balls
	ld [wSafariBallsRemaining], a
	ld a, HIGH(SAFARI_STEPS)
	ld [wSafariTimeRemaining], a
	ld a, LOW(SAFARI_STEPS)
	ld [wSafariTimeRemaining + 1], a
	ld hl, wStatusFlags2
	set STATUSFLAGS2_SAFARI_GAME_F, [hl]
	res STATUSFLAGS2_UNUSED_3_F, [hl]
	ret

SafariZoneEnd::
; special.  Ends a game and clears every trace of it: no balls, no steps, game
; flag off, game-over latch off.  Yellow scatters this over ItemUseEscapeRope,
; DisplayPlayerBlackedOutText and SafariZoneGateLeavingSafariScript.
; WarpToSpawnPoint farcalls it, so Fly, Dig, Escape Rope and a whiteout all end
; the game on their own.
	xor a
	ld [wSafariBallsRemaining], a
	ld [wSafariTimeRemaining], a
	ld [wSafariTimeRemaining + 1], a
	ld hl, wStatusFlags2
	res STATUSFLAGS2_SAFARI_GAME_F, [hl]
	res STATUSFLAGS2_UNUSED_3_F, [hl]
	ret

SafariZoneStepCountdown::
; Yellow SafariZoneCheckSteps.  One step of the countdown; carry means the game
; just ran out.  Yellow checks for zero BEFORE decrementing, so 502 steps buys
; 502 moves and the eject fires on the 503rd.
; Called from the TOP of CheckTileEvent (engine/overworld/events.asm), behind
; CheckStepCountEnabled, so that it runs before the warp check and an
; area-to-area border crossing costs a step as it does in Yellow (M7 10n; it
; was inside CountStep in 10j, which the warp check returns ahead of).
	ld hl, wStatusFlags2
	bit STATUSFLAGS2_SAFARI_GAME_F, [hl]
	jr z, .not_playing
; Time has already run out and the ejecting warp has not happened yet.
	bit STATUSFLAGS2_UNUSED_3_F, [hl]
	jr nz, .not_playing
	ld hl, wSafariTimeRemaining
	ld a, [hli]
	ld b, a
	ld c, [hl]
	or c
	jr z, .game_over
	dec bc
	ld a, b
	ld [wSafariTimeRemaining], a
	ld a, c
	ld [wSafariTimeRemaining + 1], a
.not_playing
	and a
	ret

.game_over
	scf
	ret

SafariZoneBattleScript::
; Reached from RandomEncounter (and from Sweet Scent) while the game is running.
; Yellow picks BATTLE_TYPE_SAFARI from the map id in InitBattleVariables; here
; the flag does it, exactly like BugCatchingContestBattleScript.
	loadvar VAR_BATTLETYPE, BATTLETYPE_SAFARI
	randomwildmon
	startbattle
	reloadmapafterbattle
	readmem wSafariBallsRemaining
	iffalse SafariZoneOutOfBallsScript
	end

SafariZoneTimesUpScript::
; Yellow SafariZoneGameOver reached with balls still in the bag: SafariGameOverText
; prints TimesUpText and then GameOverText.
; Yellow's SafariZoneGameOver stops the music (StopAllMusic, no fade) before the
; PA chime; the gate's own song starts with the warp (K6d).
	playmusic MUSIC_NONE
	playsound SFX_ELEVATOR_END
	opentext
	writetext SafariZoneTimesUpText
	waitbutton
	writetext SafariZoneGameOverText
	waitbutton
	closetext
	sjump SafariZoneEjectScript

SafariZoneOutOfBallsScript::
; Yellow SafariZoneGameOver reached with an empty bag: SafariGameOverText skips
; TimesUpText, because the battle has just said "You are out of SAFARI BALLs!"
; (BattleText_OutOfSafariBalls, 10i).
	playmusic MUSIC_NONE ; Yellow: StopAllMusic before the PA chime (K6d)
	playsound SFX_ELEVATOR_END
	opentext
	writetext SafariZoneGameOverText
	waitbutton
	closetext
	; fallthrough

SafariZoneEjectScript:
; Yellow forces warp 4 of the SAFARI ZONE GATE (hWarpDestinationMap /
; wDestinationWarpID $3, 0-based) with wPlayerMovingDirection cleared, and arms
; SCRIPT_SAFARIZONEGATE_LEAVING_SAFARI.  Warp 4 is the gate's own north-east
; doorway tile, x=4 y=0; the latch replaces the forced gate script id and the
; gate's scene (10k) does the "good haul, come again" dialogue and the walk out.
	setflag ENGINE_SAFARI_GAME_OVER
	special ClearBGPalettes
	warpfacing DOWN, SAFARI_ZONE_GATE, 4, 0
	end

SafariZoneTimesUpText:
	text "PA: Ding-dong!"

	para "Time's up!"
	done

SafariZoneGameOverText:
	text "PA: Your SAFARI"
	line "GAME is over!"
	done
