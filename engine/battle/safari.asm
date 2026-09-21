; Kanto hack M7 10i -- SAFARI ZONE battles (docs/M7-FUCHSIA.md 0.6 row 10i).
;
; The battle side only: BATTLETYPE_SAFARI's four-item menu (BALL / BAIT /
; THROW ROCK / RUN), Yellow's per-turn flee roll, the bait/rock factors and the
; SAFARI BALL throw.  The field side (the zone maps, the timer, the gate) is
; 10j/10k.
;
; Like the M6 ghost engine (engine/battle/ghost.asm) everything except a
; handful of small hooks lives in one section out of the full battle banks,
; reached only by `farcall`, so $0f "Battle Core" pays almost nothing.
; farcalls nest and preserve f, so carry propagates back to Battle Core
; unharmed; only `a` is clobbered.
;
; Yellow reference:
;   engine/battle/core.asm        MainInBattleLoop .displaySafariZoneBattleMenu
;                                 (the 0-ball check and the flee roll)
;                                DisplayBattleMenu (the menu + its id dispatch)
;   engine/battle/safari_zone.asm PrintSafariZoneBattleText  -> PrintSafariBattleText
;   engine/items/item_effects.asm ItemUseBait / ItemUseRock / BaitRockCommon
;
; Factor state: NO new WRAM.  Crystal already ships the two bytes, unsaved and
; battle-local inside the wBattle union (ram/wram.asm), zero-filled by
; ClearBattleRAM at the top of every battle:
;   wSafariMonEating     == Yellow's wSafariBaitFactor
;   wSafariMonAngerCount == Yellow's wSafariEscapeFactor
; (Crystal's byte order matches Yellow's: escape/anger immediately below
; bait/eating, which HandleSafariAngerEatingStatus' `dec hl` relies on.)

SafariBattleTurn::
; Hook: BattleTurn .loop, in place of the whole normal turn (no player mon is
; ever sent out, so UpdateBattleMonInParty / AIChooseMove / ParsePlayerAction /
; DetermineMoveOrder / HandleBetweenTurnEffects must not run).
; Yellow: MainInBattleLoop .displaySafariZoneBattleMenu.
; Returns carry when the battle is over.
; Yellow checks the ball count at the TOP of the loop, before the menu, so the
; turn after the last ball is thrown ends the battle -- and a battle entered
; with no balls at all ends before the menu is ever drawn.  Same here.
	ld a, [wSafariBallsRemaining]
	and a
	jr z, .out_of_balls

	farcall BattleMenu
	ret c ; RUN succeeded, or the mon was caught
	ld a, [wBattleEnded]
	and a
	jr nz, .over

; Yellow re-displays the menu when no action was taken; Crystal's BattleMenu
; only returns once an action has been dispatched, so there is nothing to redo.

	call PrintSafariBattleText

; Yellow's flee roll, byte for byte.  wEnemyMonSpeed is big-endian in Crystal
; too, so +1 is the low byte Yellow doubles.
	ld a, [wEnemyMonSpeed + 1]
	add a
	ld b, a
	jr c, .fled ; low byte >= 128: always flees

	ld a, [wSafariMonEating] ; Yellow wSafariBaitFactor
	and a
	jr z, .check_anger
	srl b
	srl b ; eating: a quarter of the flee chance

.check_anger
	ld a, [wSafariMonAngerCount] ; Yellow wSafariEscapeFactor
	and a
	jr z, .roll
	sla b ; angry: double it
	jr nc, .roll
	ld b, $ff

.roll
	call BattleRandom
	cp b
	ret nc ; the mon stays: keep battling

.fled
	farcall WildFled_EnemyFled_LinkBattleCanceled ; sets DRAW + wBattleEnded

.over
	scf
	ret

.out_of_balls
; Yellow: .outOfSafariBallsText, printed the turn AFTER the last ball is used.
; wBattleResult gets DRAW, exactly as CheckContestBattleOver does for the bug
; contest, so 10j/10k can tell "no balls left" (wSafariBallsRemaining == 0)
; from a KO/catch (WIN) and from a plain flee (DRAW, balls left).
	call SafeLoadTempTilemapToTilemap
	ld hl, BattleText_OutOfSafariBalls
	call StdBattleTextbox
	ld a, [wBattleResult]
	and BATTLERESULT_BITMASK
	add DRAW
	ld [wBattleResult], a
	ld a, 1
	ld [wBattleEnded], a
	scf
	ret

SafariBattleAction::
; Hook: BattleMenu .next.  Yellow's DisplayBattleMenu numbers the items by
; column (0 BALL, 1 THROW ROCK, 2 BAIT, 3 RUN); Crystal's _2DMenu is ROW-major
; (engine/menus/menu.asm Place2DMenuItemStrings), so the same on-screen layout
; is 1 BALL, 2 BAIT, 3 THROW ROCK, 4 RUN.
	ld a, [wBattleMenuCursorPosition]
	cp $1
	jr z, .ball
	cp $4
	jr z, .run
	call SafeLoadTempTilemapToTilemap
	ld a, [wBattleMenuCursorPosition]
	cp $2
	jr z, .bait
	; fallthrough: THROW ROCK

; Yellow ItemUseRock: double the catch rate, raise the escape factor, clear the
; bait factor.
	ld hl, BattleText_ThrewRock
	call StdBattleTextbox
	ld hl, wEnemyMonCatchRate
	ld a, [hl]
	add a
	jr nc, .no_rate_overflow
	ld a, $ff
.no_rate_overflow
	ld [hl], a
	ld hl, wSafariMonAngerCount
	ld de, wSafariMonEating
	jr .bait_rock_common

.bait
; Yellow ItemUseBait: halve the catch rate, raise the bait factor, clear the
; escape factor.
	ld hl, BattleText_ThrewBait
	call StdBattleTextbox
	ld hl, wEnemyMonCatchRate
	srl [hl]
	ld hl, wSafariMonEating
	ld de, wSafariMonAngerCount

.bait_rock_common
; Yellow BaitRockCommon: the opposite factor is zeroed, then 1-5 (rejection
; sampled from `Random and 7`) is added to this one, capped at $ff.
	xor a
	ld [de], a
.random_loop
	call BattleRandom
	and 7
	cp 5
	jr nc, .random_loop
	inc a
	ld b, a
	ld a, [hl]
	add b
	jr nc, .no_factor_overflow
	ld a, $ff
.no_factor_overflow
	ld [hl], a
; DEVIATION: Yellow plays BAIT_ANIM / ROCK_ANIM here (predef MoveAnimation).
; Crystal has no bait or rock animation and no spare move-anim slot, so the
; throw is announced by the ball-throw SFX alone.
	ld de, SFX_THROW_BALL
	call PlaySFX
	call WaitSFX
	and a ; the turn continues -> the flee roll
	ret

.ball
; Yellow: .throwSafariBallWasSelected -> UseBagItem with SAFARI_BALL.
; BattleMenu_Pack's bug-contest branch already throws PARK_BALL straight from
; the battle menu, and D50 makes PARK_BALL double as the SAFARI BALL.
	farcall BattleMenu_Pack
	ret

.run
; Yellow: BattleMenu_RunWasSelected.  TryToRunAwayFromBattle short-circuits to
; .can_escape for BATTLETYPE_SAFARI, so running never fails.
	farcall BattleMenu_Run
	ret

PrintSafariBattleText:
; Yellow: engine/battle/safari_zone.asm PrintSafariZoneBattleText.  Moved here
; verbatim from Battle Core, where Crystal left it as dead code named
; HandleSafariAngerEatingStatus -- moving it pays for most of 10i's hooks.
; Ticks down whichever factor is set and prints its text; when the anger
; counter runs out the base catch rate is restored (Yellow never restores the
; bait halving -- kept as-is).
	ld hl, wSafariMonEating
	ld a, [hl]
	and a
	jr z, .angry
	dec [hl]
	ld hl, BattleText_WildMonIsEating
	jr .finish

.angry
	dec hl
	assert wSafariMonEating - 1 == wSafariMonAngerCount
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ld hl, BattleText_WildMonIsAngry
	jr nz, .finish
	push hl
	ld a, [wEnemyMonSpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [wBaseCatchRate]
	ld [wEnemyMonCatchRate], a
	pop hl

.finish
	push hl
	call SafeLoadTempTilemapToTilemap
	pop hl
	jp StdBattleTextbox
