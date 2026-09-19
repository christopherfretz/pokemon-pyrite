BetaLoadPlayerTrainerClass: ; unreferenced
	ld c, CAL
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .got_class
	ld c, KAREN ; not KRIS?
.got_class
	ld a, c
	ld [wTrainerClass], a
	ret

MovePlayerPicRight:
	hlcoord 6, 4
	ld de, 1
	jr MovePlayerPic

MovePlayerPicLeft:
	hlcoord 13, 4
	ld de, -1
	; fallthrough

MovePlayerPic:
; Move player pic at hl by de * 7 tiles.
	ld c, $8
.loop
	push bc
	push hl
	push de
	xor a
	ldh [hBGMapMode], a
	lb bc, 7, 7
	predef PlaceGraphic
	xor a
	ldh [hBGMapThird], a
	call WaitBGMap
	call DelayFrame
	pop de
	pop hl
	add hl, de
	pop bc
	dec c
	ret z
	push hl
	push bc
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	lb bc, 7, 7
	call ClearBox
	pop bc
	pop hl
	jr .loop

ShowPlayerNamingChoices:
	ld hl, ChrisNameMenuHeader
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .got_header
	ld hl, KrisNameMenuHeader
.got_header
	call LoadMenuHeader
	call VerticalMenu
	ld a, [wMenuCursorY]
	dec a
	call CopyNameFromMenu
	call CloseWindow
	ret

; Kanto hack (docs/RIVAL-NAMING.md): the same menu for the Kanto rival, with
; Yellow's NEW NAME / BLUE / GARY / JOHN list.
ShowRivalNamingChoices:
	ld hl, RivalNameMenuHeader
	call LoadMenuHeader
	call VerticalMenu
	ld a, [wMenuCursorY]
	dec a
	call CopyNameFromMenu
	call CloseWindow
	ret

; Kanto hack (docs/RIVAL-NAMING.md): NamePlayer's twin for the Kanto rival, and
; the pic prep OakSpeech farcalls to put his front pic on screen.  These live in
; this bank rather than beside OakSpeech because bank 1 is nearly full; every
; helper they use except ApplyMonOrTrainerPals / NamingScreen is in ROM0.
; Yellow's ChooseRivalName does exactly what ChoosePlayerName does -- slide the
; pic aside, offer the default-name list, and on NEW NAME drop into the naming
; screen, re-opening it if the name came back empty
; (vendor/pokeyellow/engine/movie/oak_speech/oak_speech2.asm).
NameRival_Intro:
	call MovePlayerPicRight
	call ShowRivalNamingChoices
	ld a, [wMenuCursorY]
	dec a
	jr z, .NewName
	call StoreRivalName
	farcall ApplyMonOrTrainerPals
	call MovePlayerPicLeft
	ret

.NewName:
	ld b, NAME_RIVAL
	ld de, wRivalName
	farcall NamingScreen

; Yellow re-opens the naming screen on an empty name instead of falling back to
; a default, so the rival can never end up nameless.
	ld a, [wRivalName]
	cp '@'
	jr z, .NewName

	call RotateThreePalettesRight
	call ClearTilemap

	call LoadFontsExtra
	call WaitBGMap

	call Intro_PrepKantoRivalPic

	ld b, SCGB_TRAINER_OR_MON_FRONTPIC_PALS
	call GetSGBLayout
	call RotateThreePalettesLeft
	ret

StoreRivalName:
	ld a, '@'
	ld bc, NAME_LENGTH
	ld hl, wRivalName
	call ByteFill
	ld hl, wRivalName
	ld de, wStringBuffer2
	call CopyName2
	ret

; Intro_PrepTrainerPic (bank 1) for the KANTO_RIVAL class pic -- Yellow's
; Rival1Pic, the same young-Blue front pic his battles use.
Intro_PrepKantoRivalPic:
	xor a
	ld [wCurPartySpecies], a
	ld a, KANTO_RIVAL
	ld [wTrainerClass], a
	ld de, vTiles2
	farcall GetTrainerPic
	xor a
	ldh [hGraphicStartTile], a
	hlcoord 6, 4
	lb bc, 7, 7
	predef PlaceGraphic
	ret

INCLUDE "data/player_names.asm"

INCLUDE "data/rival_names.asm"

GetPlayerNameArray: ; unreferenced
	ld hl, wPlayerName
	ld de, MalePlayerNameArray
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .got_array
	ld de, FemalePlayerNameArray
.got_array
	call InitName
	ret

GetPlayerIcon:
	ld de, ChrisSpriteGFX
	ld b, BANK(ChrisSpriteGFX)
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .got_gfx
	ld de, KrisSpriteGFX
	ld b, BANK(KrisSpriteGFX)
.got_gfx
	ret

GetCardPic:
	ld hl, ChrisCardPic
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .got_pic
	ld hl, KrisCardPic
.got_pic
	ld de, vTiles2 tile $00
	ld bc, $23 tiles
	ld a, BANK(ChrisCardPic) ; aka BANK(KrisCardPic)
	call FarCopyBytes
	ld hl, TrainerCardGFX
	ld de, vTiles2 tile $23
	ld bc, 6 tiles
	ld a, BANK(TrainerCardGFX)
	call FarCopyBytes
	ret

ChrisCardPic:
INCBIN "gfx/trainer_card/chris_card.2bpp"

KrisCardPic:
INCBIN "gfx/trainer_card/kris_card.2bpp"

TrainerCardGFX:
INCBIN "gfx/trainer_card/trainer_card.2bpp"

GetPlayerBackpic:
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, GetChrisBackpic
	call GetKrisBackpic
	ret

GetChrisBackpic:
	ld hl, ChrisBackpic
	ld b, BANK(ChrisBackpic)
	ld de, vTiles2 tile $31
	ld c, 7 * 7
	predef DecompressGet2bpp
	ret

HOF_LoadTrainerFrontpic:
	call WaitBGMap
	xor a
	ldh [hBGMapMode], a

; Get class
	ld e, CHRIS
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .got_class
	ld e, KRIS
.got_class
	ld a, e
	ld [wTrainerClass], a

; Load pic
	ld de, ChrisPic
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .got_pic
	ld de, KrisPic
.got_pic
	ld hl, vTiles2
	ld b, BANK(ChrisPic) ; aka BANK(KrisPic)
	ld c, 7 * 7
	call Get2bpp

	call WaitBGMap
	ld a, $1
	ldh [hBGMapMode], a
	ret

DrawIntroPlayerPic:
; Draw the player pic at (6,4).

; Get class
	ld e, CHRIS
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .got_class
	ld e, KRIS
.got_class
	ld a, e
	ld [wTrainerClass], a

; Load pic
	ld de, ChrisPic
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .got_pic
	ld de, KrisPic
.got_pic
	ld hl, vTiles2
	ld b, BANK(ChrisPic) ; aka BANK(KrisPic)
	ld c, 7 * 7 ; dimensions
	call Get2bpp

; Draw
	xor a
	ldh [hGraphicStartTile], a
	hlcoord 6, 4
	lb bc, 7, 7
	predef PlaceGraphic
	ret

ChrisPic:
INCBIN "gfx/player/chris.2bpp"

KrisPic:
INCBIN "gfx/player/kris.2bpp"

GetKrisBackpic:
; Kris's backpic is uncompressed.
	ld de, KrisBackpic
	ld hl, vTiles2 tile $31
	lb bc, BANK(KrisBackpic), 7 * 7 ; dimensions
	call Get2bpp
	ret

KrisBackpic:
INCBIN "gfx/player/kris_back.2bpp"
