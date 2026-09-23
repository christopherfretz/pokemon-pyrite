; Kanto hack (M12d, docs/M12-STRETCH.md): Yellow's copyright page and GAME FREAK
; shooting-star splash, replacing Crystal's copyright + GAME FREAK/Ditto splash.
;
; A port of pokeyellow engine/movie/intro.asm (PlayShootingStar and helpers),
; engine/movie/title.asm (LoadCopyrightAndTextBoxTiles) and
; engine/movie/splash.asm (AnimateShootingStar).  The sprite data, star waves,
; frame counts and palette arithmetic are Yellow's verbatim.  Engine
; translations:
; - Yellow draws both screens with its automatic BG transfer; here each
;   screen is built in wTilemap/wAttrmap and copied to vBGMap0 with the LCD
;   off (Yellow's splash is drawn with the LCD off too).  Yellow shows the
;   copyright page through the window and the splash on vBGMap1; both are on
;   vBGMap0 here with the window hidden: same pixels.
; - SGB palette packets (SET_PAL_GAME_FREAK_INTRO) -> the CGB palettes and
;   attribute map Yellow itself shows on a GBC, read out of the Yellow
;   harness (scripts/m12d_boot.py).  UpdateCGBPal_OBP0/1 -> the same DMG->CGB
;   remap through CopyPals, from the four base palettes in wOBPals1 (OBP0
;   drives OBJ palettes 0-3, OBP1 drives 4-7, as in Yellow's
;   _UpdateCGBPal_OBP).  rOBP0/rOBP1 hold the DMG bytes, as in Yellow.
; - CheckForUserInterruption -> ShootingStar_CheckForUserInterruption (same
;   rule: A/START newly pressed, or UP+SELECT+B held; the joypad is sampled
;   after DelayFrame, as in Yellow).
; - wMoveDownSmallStarsOAMCount -> wIntroSceneFrameCounter (the intro WRAM
;   UNION, free until the Pikachu intro starts).
;
; PlayShootingStar returns carry if the player skipped the splash.

DEF SHOOTING_STAR_COPYRIGHT_FRAMES EQU 180

PlayShootingStar:
	ld de, MUSIC_NONE
	call PlayMusic
	call ClearSprites
	xor a
	ldh [hBGMapMode], a
	ldh [hSCX], a
	ldh [hSCY], a
	ld a, SCREEN_HEIGHT_PX
	ldh [hWY], a
	ld a, 7
	ldh [hWX], a

; Yellow: LoadCopyrightAndTextBoxTiles
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, ' '
	call ByteFill
	call ShootingStar_FillAttrmap
	hlcoord 2, 7
	ld de, ShootingStarCopyrightString
	call PlaceString
; Kanto hack (M12e): Yellow copies these tiles with the LCD on, over 15 more
; frames than pyrite's LCD-off copy; wait them out so the copyright page
; appears on Yellow's frame (69 from power-on).
	ld c, 15
	call DelayFrames
	call DisableLCD
	ld hl, ShootingStarCopyrightGFX
	ld de, vTiles2 tile $60
	ld bc, ShootingStarCopyrightGFXEnd - ShootingStarCopyrightGFX
	call CopyBytes
	ld hl, vTiles2 tile $7f
	ld bc, TILE_SIZE
	xor a
	call ByteFill
	call ShootingStar_CopyTilemapLCDOff
	call ShootingStar_LoadPalettes
	call EnableLCD
	ld c, SHOOTING_STAR_COPYRIGHT_FRAMES
	call DelayFrames
; Yellow: ClearScreen (blank the tilemap through the BG map transfer, Delay3)
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, ' '
	call ByteFill
	ld a, 1 ; middle third (the copyright text) first, as Yellow's transfer does
	ldh [hBGMapThird], a
	ldh [hBGMapMode], a
	ld c, 4 ; Yellow: Delay3, plus the frame Yellow's DisableLCD then waits for LY 144
	call DelayFrames
	xor a
	ldh [hBGMapMode], a

; Crystal: stop here on a DMG (Crystal's splash did the same after its copyright).
	farcall GBCOnlyScreen

; Yellow: DisableLCD, IntroDrawBlackBars
	call DisableLCD
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	call ByteFill
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * 4
	ld a, 1
	call ByteFill
	hlcoord 0, 14
	ld bc, SCREEN_WIDTH * 4
	ld a, 1
	call ByteFill
	call ShootingStar_FillAttrmap
	call ShootingStar_CopyTilemapLCDOff
; write the black and white tiles
	ld hl, vTiles2 tile 0
	ld bc, TILE_SIZE
	xor a
	call ByteFill
	ld hl, vTiles2 tile 1
	ld bc, TILE_SIZE
	ld a, $ff
	call ByteFill
; copy gamefreak logo and others
	ld hl, GameFreakIntro
	ld de, vTiles2 tile $60
	ld bc, GameFreakIntroEnd - GameFreakIntro
	call CopyBytes
	ld hl, GameFreakIntro
	ld de, vTiles1
	ld bc, GameFreakIntroEnd - GameFreakIntro
	call CopyBytes
	call EnableLCD
	ld c, 64
	call DelayFrames
	call AnimateShootingStar
	push af
	jr c, .next ; skip the delay if the user interrupted the animation
	ld c, 40
	call DelayFrames
.next
; Yellow: IntroClearMiddleOfScreen (the middle is already blank on screen)
	hlcoord 0, 4
	ld bc, SCREEN_WIDTH * 10
	xor a
	call ByteFill
	call ClearSprites
	ld c, 3 ; Yellow: Delay3
	call DelayFrames
	pop af
	ret

ShootingStar_FillAttrmap:
; Yellow: BlkPacket_GameFreakIntro, as CGB attributes
	hlcoord 0, 0, wAttrmap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	call ByteFill
	hlcoord 5, 11, wAttrmap
	ld de, SCREEN_WIDTH
	ld b, 3
.row
	push hl
	ld a, 1
	ld [hli], a
	ld [hli], a
	ld [hli], a
	inc a
	ld [hli], a
	ld [hli], a
	inc hl
	inc hl
	inc a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	pop hl
	add hl, de
	dec b
	jr nz, .row
	ret

ShootingStar_CopyTilemapLCDOff:
; Copy wTilemap and wAttrmap to vBGMap0 (LCD off).
	ld a, 1
	ldh [rVBK], a
	decoord 0, 0, wAttrmap
	call .copy
	xor a
	ldh [rVBK], a
	decoord 0, 0
.copy
	ld hl, vBGMap0
	ld c, SCREEN_HEIGHT
.row
	ld b, SCREEN_WIDTH
.col
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .col
	ld a, TILEMAP_WIDTH - SCREEN_WIDTH
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	dec c
	jr nz, .row
	ret

ShootingStar_LoadPalettes:
; BG palettes 0-3 and the OBJ base palettes are Yellow's four
; SET_PAL_GAME_FREAK_INTRO palettes; OBJ palettes start white.
	ldh a, [rWBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rWBK], a
	ld hl, ShootingStarPals
	ld de, wBGPals1
	ld bc, 4 palettes
	call CopyBytes
	ld hl, ShootingStarPals
	ld de, wBGPals2
	ld bc, 4 palettes
	call CopyBytes
	ld hl, ShootingStarPals
	ld de, wOBPals1
	ld bc, 4 palettes
	call CopyBytes
	ld hl, wOBPals2
	ld bc, 8 palettes
	ld a, $ff
	call ByteFill
	pop af
	ldh [rWBK], a
	ld a, TRUE
	ldh [hCGBPalUpdate], a
	ret

ShootingStar_UpdateOBP0:
	push hl
	push de
	push bc
	ld hl, wOBPals2
	ldh a, [rOBP0]
	jr ShootingStar_UpdateOBP

ShootingStar_UpdateOBP1:
	push hl
	push de
	push bc
	ld hl, wOBPals2 palette 4
	ldh a, [rOBP1]
	; fallthrough
ShootingStar_UpdateOBP:
; Yellow: _UpdateCGBPal_OBP
	ld b, a
	ldh a, [rWBK]
	push af
	ld a, BANK(wOBPals2)
	ldh [rWBK], a
	push hl
	ld de, wOBPals1
	ld c, 4
	call CopyPals
	pop hl
; Yellow writes the converted palettes to the hardware at once
; (TransferCurOBPData, outside mode 3); waiting for hCGBPalUpdate's VBlank
; would show every flash and blink a frame late.
	ld a, l
	sub LOW(wOBPals2)
	or OBPI_AUTOINC
	ldh [rOBPI], a
	ld c, 4 palettes
.transfer
	ldh a, [rSTAT]
	and %10 ; mode 2 or 3
	jr nz, .transfer
	ld a, [hli]
	ldh [rOBPD], a
	dec c
	jr nz, .transfer
	pop af
	ldh [rWBK], a
	ld a, TRUE
	ldh [hCGBPalUpdate], a
	pop bc
	pop de
	pop hl
	ret

ShootingStar_CheckForUserInterruption:
; Yellow: CheckForUserInterruption
; Return carry if Up+Select+B, Start or A are pressed in c frames.
	call DelayFrame
; Yellow reads the joypad here, after DelayFrame returns (JoypadLowSensitivity);
; Crystal's VBlank already read it a few hundred cycles earlier.  Read it again
; so a press lands on the same frame as in Yellow.
	push bc
	push de
	call UpdateJoypad
	pop de
	pop bc
	call GetJoypad
	ldh a, [hJoyDown]
	cp PAD_UP | PAD_SELECT | PAD_B
	jr z, .input
	ldh a, [hJoyPressed]
	and PAD_START | PAD_A
	jr nz, .input
	dec c
	jr nz, ShootingStar_CheckForUserInterruption
	and a
	ret

.input
	scf
	ret

LoadShootingStarGraphics:
	ld a, $f9
	ldh [rOBP0], a
	ld a, $a4
	ldh [rOBP1], a
	call ShootingStar_UpdateOBP0
	call ShootingStar_UpdateOBP1
; Yellow copies the two star tiles (MoveAnimationTiles1 tiles 3 and 19) in two
; CopyVideoData calls; they are adjacent here, and one request keeps Yellow's
; frame count (Yellow: 3 frames from AnimateShootingStar to the SFX).
	ld de, ShootingStarGFX ; star tiles (top and bottom left quadrants)
	ld hl, vTiles1 tile $20
	lb bc, BANK(ShootingStarGFX), 2
	call Request2bpp
	ld de, FallingStar
	ld hl, vTiles1 tile $22
	lb bc, BANK(FallingStar), (FallingStarEnd - FallingStar) / TILE_SIZE
	call Request2bpp
	ld hl, GameFreakLogoOAMData
	ld de, wShadowOAMSprite24
	ld bc, GameFreakLogoOAMDataEnd - GameFreakLogoOAMData
	call CopyBytes
	ld hl, GameFreakShootingStarOAMData
	ld de, wShadowOAM
	ld bc, GameFreakShootingStarOAMDataEnd - GameFreakShootingStarOAMData
	jp CopyBytes

AnimateShootingStar:
	call LoadShootingStarGraphics
	ld de, SFX_SHOOTING_STAR
	call PlaySFX

; Move the big star down and left across the screen.
	ld hl, wShadowOAM
	lb bc, $a0, $4
.bigStarLoop
	push hl
	push bc
.bigStarInnerLoop
	ld a, [hl] ; Y
	add 4
	ld [hli], a
	ld a, [hl] ; X
	add -4
	ld [hli], a
	inc hl
	inc hl
	dec c
	jr nz, .bigStarInnerLoop
	ld c, 1
	call ShootingStar_CheckForUserInterruption
	pop bc
	pop hl
	ret c
	ld a, [hl]
	cp 80
	jr nz, .next
	jr .bigStarLoop
.next
	cp b
	jr nz, .bigStarLoop

; Clear big star OAM.
	ld hl, wShadowOAMSprite00YCoord
	ld c, 4
	ld de, OBJ_SIZE
.clearOAMLoop
	ld [hl], SCREEN_HEIGHT_PX + OAM_Y_OFS
	add hl, de
	dec c
	jr nz, .clearOAMLoop

; Make Gamefreak logo flash.
	ld b, 3
.flashLogoLoop
	ld hl, rOBP0
	rrc [hl]
	rrc [hl]
	call ShootingStar_UpdateOBP0
	ld c, 10
	call ShootingStar_CheckForUserInterruption
	ret c
	dec b
	jr nz, .flashLogoLoop

; Copy 24 instances of the small stars OAM data.
; Note that their coordinates put them off-screen.
	ld de, wShadowOAM
	ld a, 24
.initSmallStarsOAMLoop
	push af
	ld hl, SmallStarsOAM
	ld bc, SmallStarsOAMEnd - SmallStarsOAM
	call CopyBytes
	pop af
	dec a
	jr nz, .initSmallStarsOAMLoop

; Animate the small stars falling from the Gamefreak logo.
	xor a
	ld [wIntroSceneFrameCounter], a ; Yellow: wMoveDownSmallStarsOAMCount
	ld hl, SmallStarsWaveCoordsPointerTable
	ld c, 6
.smallStarsLoop
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push bc
	push hl
	ld hl, wShadowOAMSprite20
	ld c, 4
.smallStarsInnerLoop ; introduce new wave of 4 small stars OAM entries
	ld a, [de]
	cp -1
	jr z, .next2
	ld [hli], a ; Y
	inc de
	ld a, [de]
	ld [hli], a ; X
	inc de
	inc hl
	push bc
	ld a, [de]
	ld b, a
	ld a, [hl]
	and $f0
	or b
	ld [hl], a
	inc de
	pop bc
	inc hl
	dec c
	jr nz, .smallStarsInnerLoop
	ld a, [wIntroSceneFrameCounter]
	cp 24
	jr z, .next2
	add 6 ; should be 4, but the extra 2 aren't visible on screen
	ld [wIntroSceneFrameCounter], a
.next2
	call MoveDownSmallStars
	push af

; shift the existing OAM entries down to make room for the next wave
	ld hl, wShadowOAMSprite04
	ld de, wShadowOAM
	ld bc, OBJ_SIZE * 20
	call CopyBytes

	pop af
	pop hl
	pop bc
	ret c
	dec c
	jr nz, .smallStarsLoop
	and a
	ret

SmallStarsOAM:
	dbsprite  0,  0,  0,  0, $A2, OAM_PRIO | OAM_PAL1
SmallStarsOAMEnd:

SmallStarsWaveCoordsPointerTable:
	dw SmallStarsWave1Coords
	dw SmallStarsWave2Coords
	dw SmallStarsWave3Coords
	dw SmallStarsWave4Coords
	dw SmallStarsEmptyWave
	dw SmallStarsEmptyWave

; The stars that fall from the Gamefreak logo come in 4 waves of 4 OAM entries.
; Each entry is Y, X and the CGB palette.

SmallStarsWave1Coords:
	db $68, $30, $05
	db $68, $40, $05
	db $68, $58, $04
	db $68, $78, $07
SmallStarsWave2Coords:
	db $68, $38, $05
	db $68, $48, $06
	db $68, $60, $04
	db $68, $70, $07
SmallStarsWave3Coords:
	db $68, $34, $05
	db $68, $4c, $06
	db $68, $54, $06
	db $68, $64, $07
SmallStarsWave4Coords:
	db $68, $3c, $05
	db $68, $5c, $04
	db $68, $6c, $07
	db $68, $74, $07
SmallStarsEmptyWave:
	db -1 ; end

MoveDownSmallStars:
	ld b, 8
.loop
	ld hl, wShadowOAMSprite23
	ld a, [wIntroSceneFrameCounter] ; Yellow: wMoveDownSmallStarsOAMCount
	ld de, -4
	ld c, a
.innerLoop
	inc [hl] ; Y
	add hl, de
	dec c
	jr nz, .innerLoop
; Toggle the palette so that the lower star in the small stars tile blinks in
; and out.
	ldh a, [rOBP1]
	xor %10100000
	ldh [rOBP1], a
	call ShootingStar_UpdateOBP1
	ld c, 3
	call ShootingStar_CheckForUserInterruption
	ret c
	dec b
	jr nz, .loop
	ret

GameFreakLogoOAMData:
	dbsprite 10,  9,  0,  0, $8d, 0
	dbsprite 11,  9,  0,  0, $8e, 0
	dbsprite 10, 10,  0,  0, $8f, 0
	dbsprite 11, 10,  0,  0, $90, 0
	dbsprite 10, 11,  0,  0, $91, 0
	dbsprite 11, 11,  0,  0, $92, 0
	dbsprite  6, 12,  0,  0, $80, 0
	dbsprite  7, 12,  0,  0, $81, 0
	dbsprite  8, 12,  0,  0, $82, 0
	dbsprite  9, 12,  0,  0, $83, 0
	dbsprite 10, 12,  0,  0, $93, 0
	dbsprite 11, 12,  0,  0, $84, 0
	dbsprite 12, 12,  0,  0, $85, 0
	dbsprite 13, 12,  0,  0, $83, 0
	dbsprite 14, 12,  0,  0, $81, 0
	dbsprite 15, 12,  0,  0, $86, 0
GameFreakLogoOAMDataEnd:

GameFreakShootingStarOAMData:
	dbsprite 20,  0,  0,  0, $a0, OAM_PAL1 | 1 << 2 ; Yellow: OAM_HIGH_PALS
	dbsprite 21,  0,  0,  0, $a0, OAM_PAL1 | 1 << 2 | OAM_XFLIP ; Yellow: OAM_HIGH_PALS
	dbsprite 20,  1,  0,  0, $a1, OAM_PAL1 | 1 << 2 ; Yellow: OAM_HIGH_PALS
	dbsprite 21,  1,  0,  0, $a1, OAM_PAL1 | 1 << 2 | OAM_XFLIP ; Yellow: OAM_HIGH_PALS
GameFreakShootingStarOAMDataEnd:

ShootingStarCopyrightString:
	db   $60,$61,$62,$63,$61,$62,$7c,$7f,$65,$66,$67,$68,$69,$6a             ; ©1995-1999  Nintendo
	next $60,$61,$62,$63,$61,$62,$7c,$7f,$6b,$6c,$6d,$6e,$6f,$70,$71,$72     ; ©1995-1999  Creatures inc.
	next $60,$61,$62,$63,$61,$62,$7c,$7f,$73,$74,$75,$76,$77,$78,$79,$7a,$7b ; ©1995-1999  GAME FREAK inc.
	db   "@"

ShootingStarPals:
; Yellow on a GBC: PAL_GAMEFREAK, PAL_REDMON, PAL_VIRIDIAN, PAL_BLUEMON
; (read out of the Yellow harness's palette RAM)
	dw $7fff, $027f, $0273, $0c63
	dw $7fff, $023f, $001f, $0c63
	dw $7fff, $03f3, $7eeb, $0c63
	dw $7fff, $7e50, $6420, $0c63

ShootingStarCopyrightGFX:
; Yellow: NintendoCopyrightLogoGraphics, GamefreakLogoGraphics, NineTile ($60-$7c)
	INCBIN "gfx/title/yellow/copyright.2bpp"
	INCBIN "gfx/title/yellow/gamefreak_inc.2bpp"
	INCBIN "gfx/title/yellow/nine.2bpp"
ShootingStarCopyrightGFXEnd:

GameFreakIntro:
	INCBIN "gfx/splash/yellow/gamefreak_presents.2bpp"
	INCBIN "gfx/splash/yellow/gamefreak_logo.2bpp"
	ds TILE_SIZE, $00 ; blank tile
GameFreakIntroEnd:

ShootingStarGFX:
; Yellow: MoveAnimationTiles1 tiles 3 and 19 (the big star's two left quadrants)
	INCBIN "gfx/splash/yellow/shooting_star.2bpp"

FallingStar:
	INCBIN "gfx/splash/yellow/falling_star.2bpp"
FallingStarEnd:
