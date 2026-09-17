CatchTutorial::
	ld a, [wBattleType]
	dec a
	ld c, a
	ld hl, .dw
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.dw
	dw .DudeTutorial
	dw .DudeTutorial
	dw .DudeTutorial

.DudeTutorial:
	ld hl, .Dude
	; fallthrough

.RunTutorial:
; hl: the catcher's name, shown in place of the player's.
; Back up your name to your Mom's name.
	push hl
	ld hl, wPlayerName
	ld de, wMomsName
	ld bc, NAME_LENGTH
	call CopyBytes
; Copy the catcher's name to your name
	pop hl
	ld de, wPlayerName
	ld bc, NAME_LENGTH
	call CopyBytes

	call .LoadDudeData

	xor a
	ldh [hJoyDown], a
	ldh [hJoyPressed], a
	ld a, [wOptions]
	push af
	and ~TEXT_DELAY_MASK
	add TEXT_DELAY_MED
	ld [wOptions], a
	ld hl, .AutoInput
	ld a, BANK(.AutoInput)
	call StartAutoInput
	callfar StartBattle
	call StopAutoInput
	pop af

	ld [wOptions], a
	ld hl, wMomsName
	ld de, wPlayerName
	ld bc, NAME_LENGTH
	call CopyBytes
	ret

.LoadDudeData:
	ld hl, wDudeNumItems
	ld [hl], 1
	inc hl
	ld [hl], POTION
	inc hl
	ld [hl], 1
	inc hl
	ld [hl], -1
	ld hl, wDudeNumKeyItems
	ld [hl], 0
	inc hl
	ld [hl], -1
	ld hl, wDudeNumBalls
	ld a, 1
	ld [hli], a
	ld a, POKE_BALL
	ld [hli], a
	ld [hli], a
	ld [hl], -1
	ret

.Dude:
	db "DUDE@"

.Oak:
	db "PROF.OAK@"

.OldMan:
	db "OLD MAN@"

.AutoInput:
	db NO_INPUT, $ff ; end

OakCatchTutorial::
; Kanto intro (docs/M2-INTRO.md): Prof. Oak catches a wild Pokemon in front
; of the player, who owns none yet. The map script loads the wild mon first
; (loadwildmon) and reloads the map afterwards (reloadmap), mirroring the
; catchtutorial script command. The catcher flag selects Oak's back-pic.
	ld a, BATTLETYPE_TUTORIAL
	ld [wBattleType], a
	ld a, CATCHTUTORIAL_OAK
	ld [wCatchTutorialCatcher], a
	call BufferScreen
	ld hl, CatchTutorial.Oak
	call CatchTutorial.RunTutorial
	xor a
	ld [wCatchTutorialCatcher], a
	ret

OldManCatchTutorial::
; Viridian City's old man (docs/M2-CATCH.md), Yellow's catch tutorial. Same
; contract as OakCatchTutorial (loadwildmon before, reloadmap after).
; wScriptVar nonzero: his first demo, the ball wobbles three times and the
; RATTATA breaks free ("I must be losing my touch"); zero: he catches it.
	ld a, BATTLETYPE_TUTORIAL
	ld [wBattleType], a
	ld a, [wScriptVar]
	and a
	ld a, CATCHTUTORIAL_OLD_MAN
	jr z, .got_catcher
	ld a, CATCHTUTORIAL_OLD_MAN_FAIL
.got_catcher
	ld [wCatchTutorialCatcher], a
	call BufferScreen
	ld hl, CatchTutorial.OldMan
	call CatchTutorial.RunTutorial
	xor a
	ld [wCatchTutorialCatcher], a
	ret
