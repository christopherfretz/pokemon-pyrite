; Kanto hack (M12c, docs/M12-STRETCH.md): Yellow's title screen.
;
; A port of pokeyellow engine/movie/title.asm (DisplayTitleScreen and
; DoTitleScreenFunction) and engine/movie/title_yellow.asm, replacing Crystal's
; Suicune title.  Same VRAM layout as Yellow (both games run the BG in $8800
; tile mode), same bounce table, same blink state machine, same $c00-frame
; timeout.  Engine translations: hAutoBGTransfer* -> hBGMapMode/hBGMapAddress,
; PlaySound -> PlaySFX/PlayMusic, hJoyHeld -> hJoyDown, SGB/CGB palette
; packets -> the CGB palettes and attribute map Yellow itself shows on a GBC
; (read out of the Yellow harness: scripts/m12c_title.py).
;
; _TitleScreen blocks until the player leaves the title and returns the choice
; in wTitleScreenSelectedOption (TITLESCREENOPTION_*, engine/menus/intro_menu.asm).
;
; WRAM (Yellow name -> here):
;   wTitleScreenScene       -> wJumptableIndex          (blink jumptable index)
;   wTitleScreenTimer       -> wTitleScreenBlinkTimer    (1-byte blink clock)
;   wTitleScreenScene + 2/3 -> wTitleScreenTimer         (16-bit reset counter)

; The build id ("build <short git hash>") printed across the top of the title
; screen, so a ROM downloaded from the rolling release can be identified on
; sight.  BUILD_REV is passed in by the Makefile (rgbasm -D BUILD_REV=...).
IF !DEF(BUILD_REV)
DEF BUILD_REV EQUS "unknown"
ENDC
DEF BUILD_ID_TEXT EQUS "build {BUILD_REV}"
; Row 0 is blank on Yellow's title (the logo starts on row 1), and it is only
; on screen once the logo has landed, so the id is drawn after the bounce.
DEF BUILD_ID_ROW EQU 0
DEF BUILD_ID_COL EQU (SCREEN_WIDTH - STRLEN("{BUILD_ID_TEXT}")) / 2
; Yellow's title fills bank-0 BG tiles almost completely (logo $00-$72,
; Pikachu $80-$bf, copyright $e0-$ee, eyes $f0-$fb), so the glyphs live in
; VRAM bank 1 and the build id's attribute bytes select that bank.
DEF BUILD_ID_LETTER_TILE EQU $20 ; 'a' to 'z'
DEF BUILD_ID_DIGIT_TILE  EQU $3a ; '0' to '9'
DEF BUILD_ID_ATTR EQU 0 | OAM_BANK1 ; palette 0 (LOGO2), like the rest of the row

; Yellow waits $c00 title-loop frames (51.2 s) before it gives up and restarts.
DEF TITLE_RESET_FRAMES_HI EQU $0c
DEF TITLE_SETUP_PAD_FRAMES EQU 7
; Crystal's wMusicFade frames-per-step for the reset fade. Yellow's
; wAudioFadeOutControl = $0c fades out and reaches its intro 64 VBlanks after
; the reset; with this value pyrite reaches IntroSequence 63 VBlanks after
; it (each unit is ~7 frames: 6 gives 70, $0c gives 112; measured with
; scripts/m12c_title.py).
DEF TITLE_RESET_FADE EQU 5

_TitleScreen:
; Yellow: DisplayTitleScreen
	ld de, MUSIC_NONE
	call PlayMusic
	call ClearBGPalettes ; Yellow: GBPalWhiteOut
	call ClearSprites
	call ClearTilemap

	xor a
	ldh [hBGMapMode], a
	ldh [hLCDCPointer], a
	ldh [hSCX], a
	ld [wJumptableIndex], a
	ld [wTitleScreenSelectedOption], a
	ld a, $40
	ldh [hSCY], a
	ld a, SCREEN_HEIGHT_PX
	ldh [hWY], a
	ld a, 7
	ldh [hWX], a

	call DisableLCD

; Yellow's LCDC: window on (from map 1), 8x8 objects.
	ld hl, rLCDC
	set B_LCDC_WINDOW, [hl]
	set B_LCDC_WIN_MAP, [hl]
	res B_LCDC_BG_MAP, [hl]
	res B_LCDC_OBJ_SIZE, [hl]
	set B_LCDC_OBJS, [hl]

	call LoadYellowTitleScreenGFX

; Both BG maps blank
	ld hl, vBGMap0
	ld bc, 2 * TILEMAP_AREA
	ld a, ' '
	call ByteFill

; Buffer 2: the logo and the copyright strip -> BG map 0
	call TitleScreen_PlacePokemonLogo
	call .WriteCopyrightTiles
	ld hl, vBGMap0
	call TitleScreen_CopyTilemapToVRAM

; Buffer 1: logo + Pikachu -> BG map 0 + $300, i.e. BG map 1 rows 0-9 hold
; screen rows 8-17: that is the window, parked at hWY = $40 while the logo
; bounces on the BG behind it.  wTilemap keeps this screen for later.
	call TitleScreen_PlacePikachu
	ld hl, vBGMap0 + $300
	call TitleScreen_CopyTilemapToVRAM

	call TitleScreen_SetAttributes
	call TitleScreen_LoadBuildIDGlyphs

	call EnableLCD

	ld a, $40
	ldh [hWY], a

; Yellow builds this screen with the LCD on, through Delay3-paced tilemap
; copies behind a white palette: the logo appears (GBPalNormal) 15 VBlanks
; after DisplayTitleScreen. Ours is built LCD-off in 8, so hold white for the
; difference (measured, scripts/m12c_title.py) and every later event lands on
; Yellow's frame.
	ld c, TITLE_SETUP_PAD_FRAMES
	call DelayFrames
	call TitleScreen_LoadPalettes

; make pokemon logo bounce up and down
	ld bc, hSCY
	ld hl, .TitleScreenPokemonLogoYScrolls
.bouncePokemonLogoLoop
	ld a, [hli]
	and a
	jr z, .finishedBouncingPokemonLogo
	ld d, a
	cp -3
	jr nz, .skipPlayingSound
	push de
	ld de, SFX_INTRO_CRASH
	call PlaySFX
	pop de
.skipPlayingSound
	ld a, [hli]
	ld e, a
	call .ScrollTitleScreenPokemonLogo
	jr .bouncePokemonLogoLoop

.TitleScreenPokemonLogoYScrolls:
; Controls the bouncing effect of the Pokemon logo on the title screen
	db -4,16  ; y scroll amount, number of times to scroll
	db 3,4
	db -3,4
	db 2,2
	db -2,2
	db 1,2
	db -1,2
	db 0      ; terminate list with 0

.ScrollTitleScreenPokemonLogo:
; Scrolls the Pokemon logo on the title screen to create the bouncing effect
; Scrolls d pixels e times
	call DelayFrame
	ld a, [bc] ; background scroll Y
	add d
	ld [bc], a
	dec e
	jr nz, .ScrollTitleScreenPokemonLogo
	ret

; place tiles for title screen copyright
.WriteCopyrightTiles
	hlcoord 2, 17
	ld de, .tileScreenCopyrightTiles
.titleScreenCopyrightTilesLoop
	ld a, [de]
	inc de
	cp $ff
	ret z
	ld [hli], a
	jr .titleScreenCopyrightTilesLoop

.tileScreenCopyrightTiles
	db $e0,$e1,$e2,$e3,$e1,$e2,$ee,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ff ; ©1995-1999 GAME FREAK inc.

.finishedBouncingPokemonLogo
; Yellow: LoadScreenTilesFromBuffer1 -- wTilemap already holds buffer 1, so
; just start streaming it to BG map 0 (with the build id on row 0).
	hlcoord BUILD_ID_COL, BUILD_ID_ROW
	ld de, BuildIDString
	call PlaceBuildID
	ld a, LOW(vBGMap0)
	ldh [hBGMapAddress], a
	ld a, HIGH(vBGMap0)
	ldh [hBGMapAddress + 1], a
	ld a, 1 ; BG map 0 tiles
	ldh [hBGMapMode], a
	ld c, 36
	call DelayFrames
	ld de, SFX_INTRO_WHOOSH_YELLOW
	call PlaySFX

	call TitleScreen_PlacePikaSpeechBubble
	ld a, SCREEN_HEIGHT_PX
	ldh [hWY], a
	ld c, 3
	call DelayFrames
	ld e, PikachuCry1
	farcall PlayPikachuSoundClip
	call WaitSFX
	ld de, MUSIC_TITLE
	call PlayMusic

.loop
	xor a
	ld [wJumptableIndex], a
	ld [wTitleScreenBlinkTimer], a
	ld [wTitleScreenTimer], a
	ld [wTitleScreenTimer + 1], a
.titleScreenLoop
	call .IncrementResetCounter
	jr c, .doTitlescreenReset
	call DelayFrame
	call GetJoypad
	ldh a, [hJoyDown]
	cp PAD_UP | PAD_SELECT | PAD_B
	jr z, .go_to_main_menu
	call .CheckClockReset
	jr c, .reset_clock
	ldh a, [hJoyDown]
	and PAD_A | PAD_START
	jr nz, .go_to_main_menu
	call DoTitleScreenFunction
	jr .titleScreenLoop

.go_to_main_menu
	ld e, PikachuCry11
	farcall PlayPikachuSoundClip
	call ClearBGPalettes ; Yellow: GBPalWhiteOutWithDelay3 (waits 4 frames)
	call ClearSprites
; Yellow re-reads the held buttons here: still holding UP + SELECT + B
; after the cry means "clear the save".
	call GetJoypad
	ldh a, [hJoyDown]
	and PAD_UP | PAD_SELECT | PAD_B
	cp PAD_UP | PAD_SELECT | PAD_B
	ld a, TITLESCREENOPTION_DELETE_SAVE_DATA
	jr z, .done
	ld a, TITLESCREENOPTION_MAIN_MENU
.done
	ld [wTitleScreenSelectedOption], a
	ret

.reset_clock
	ld a, TITLESCREENOPTION_RESET_CLOCK
	jr .done

.doTitlescreenReset
; Yellow: wAudioFadeOutControl = $0c, then jp Init once the fade is done.
; Crystal's engine steps its fade differently, see TITLE_RESET_FADE.
	xor a ; MUSIC_NONE
	ld [wMusicFadeID], a
	ld [wMusicFadeID + 1], a
	ld a, TITLE_RESET_FADE
	ld [wMusicFade], a
.audioFadeLoop
	call DelayFrame
	ld a, [wMusicFade]
	and a
	jr nz, .audioFadeLoop
	ld a, TITLESCREENOPTION_RESTART
	jr .done

.IncrementResetCounter:
	ld hl, wTitleScreenTimer
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc de
	ld a, d
	cp TITLE_RESET_FRAMES_HI
	jr z, .doReset
	ld [hl], d
	dec hl
	ld [hl], e
	and a
	ret

.doReset
	scf
	ret

.CheckClockReset:
; Crystal's hidden clock reset, kept from its title screen: hold
; Down + B + Select, then (keeping Select) hold Left + Up and let go of Select.
; Returns carry to reset the clock.
	ld hl, hJoyDown
	ldh a, [hClockResetTrigger]
	cp $34
	jr z, .check_clock_reset
	ld a, [hl]
	and PAD_DOWN | PAD_B | PAD_SELECT
	cp  PAD_DOWN | PAD_B | PAD_SELECT
	jr nz, .no_reset
	ld a, $34
	ldh [hClockResetTrigger], a
.no_reset
	and a
	ret

.check_clock_reset
	bit B_PAD_SELECT, [hl]
	jr nz, .no_reset
	xor a
	ldh [hClockResetTrigger], a
	ld a, [hl]
	and PAD_LEFT | PAD_UP
	cp  PAD_LEFT | PAD_UP
	jr nz, .no_reset
	scf
	ret

DoTitleScreenFunction:
; Yellow: Pikachu blinks at blink-clock 0, $80 and $90 (every 256 frames).
	call .CheckTimer
	ld a, [wJumptableIndex]
	ld e, a
	ld d, 0
	ld hl, .Jumptable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.Jumptable:
	dw .Nop
	dw .BlinkHalf
	dw .BlinkWait
	dw .BlinkWait
	dw .BlinkClosed
	dw .BlinkWait
	dw .BlinkWait
	dw .BlinkHalf
	dw .BlinkWait
	dw .BlinkWait
	dw .BlinkOpen
	dw .GoBackToStart

.GoBackToStart:
	xor a
	ld [wJumptableIndex], a
.Nop
	ret

.BlinkOpen:
	ld e, 0
	jr .LoadBlinkFrame

.BlinkHalf:
	ld e, 4
	jr .LoadBlinkFrame

.BlinkClosed:
	ld e, 8
.LoadBlinkFrame:
	ld hl, wShadowOAMSprite00TileID
	ld c, 8
.loop
	ld a, [hl]
	and $f3
	or e
	ld [hli], a
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, .loop
.BlinkWait:
	ld hl, wJumptableIndex
	inc [hl]
	ret

.CheckTimer:
	ld hl, wTitleScreenBlinkTimer
	ld a, [hl]
	inc [hl]
	and a
	jr z, .restart
	cp $80
	jr z, .restart
	cp $90
	ret nz
.restart
	ld a, $1
	ld [wJumptableIndex], a
	ret

TitleScreen_CopyTilemapToVRAM:
; Copy the whole of wTilemap to the BG map at hl, LCD off.
; (Yellow's TitleScreenCopyTileMapToVRAM streams it through the auto-transfer.)
	ld de, wTilemap
	ld b, SCREEN_HEIGHT
.row
	ld c, SCREEN_WIDTH
.col
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .col
	ld a, TILEMAP_WIDTH - SCREEN_WIDTH
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	dec b
	jr nz, .row
	ret

TitleScreen_SetAttributes:
; The attribute map Yellow's own CGB palette code gives its title (BLK packet
; BlkPacket_Titlescreen; measured in the Yellow harness): palette 0 (LOGO2)
; on rows 0-7 and the bubble's tail, palette 2 (MEWMON) everywhere else.
; Yellow applies it to BG map 1 with the same row numbers, so the window's
; row 8 (screen row 16 during the bounce) carries the tail's palette 0 too.
	ld a, 1
	ldh [rVBK], a
	ld hl, vBGMap0
	ld bc, 2 * TILEMAP_AREA
	ld a, 2
	call ByteFill
	ld hl, vBGMap0
	ld bc, 8 * TILEMAP_WIDTH
	xor a
	call ByteFill
	xor a
	hlbgcoord 9, 8
	ld [hli], a
	ld [hl], a
	hlbgcoord 9, 8, vBGMap1
	ld [hli], a
	ld [hl], a
; the build id reads its glyphs from VRAM bank 1
	hlbgcoord BUILD_ID_COL, BUILD_ID_ROW
	ld bc, STRLEN("{BUILD_ID_TEXT}")
	ld a, BUILD_ID_ATTR
	call ByteFill
	xor a
	ldh [rVBK], a
	ret

TitleScreen_LoadBuildIDGlyphs:
; Into VRAM bank 1, LCD off.  Tile ' ' there is cleared, since the id's
; spaces (and the row before it is drawn) point at it.
	ld a, 1
	ldh [rVBK], a
	ld de, Font + (CHARVAL("a") - CHARVAL("A")) * TILE_1BPP_SIZE
	ld hl, vTiles2 tile BUILD_ID_LETTER_TILE
	lb bc, BANK(Font), CHARVAL("z") - CHARVAL("a") + 1
	call Copy1bpp
	ld de, Font + (CHARVAL("0") - CHARVAL("A")) * TILE_1BPP_SIZE
	ld hl, vTiles2 tile BUILD_ID_DIGIT_TILE
	lb bc, BANK(Font), CHARVAL("9") - CHARVAL("0") + 1
	call Copy1bpp
	ld hl, vTiles2 tile ' '
	ld bc, 1 tiles
	xor a
	call ByteFill
	xor a
	ldh [rVBK], a
	ret

TitleScreen_LoadPalettes:
; Yellow's GBPalNormal + OBP0 = %11100000 on a GBC: the four title palettes of
; CGBBasePalettes (LOGO2, LOGO1, MEWMON, PURPLEMON), and OBJ palettes that are
; the same colours seen through OBP0 (colour 1 -> white).
	ldh a, [rWBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rWBK], a
	ld hl, TitleScreenPalettes
	ld de, wBGPals1
	ld bc, 16 palettes
	call CopyBytes
	ld hl, TitleScreenPalettes
	ld de, wBGPals2
	ld bc, 16 palettes
	call CopyBytes
	pop af
	ldh [rWBK], a
	ld a, TRUE
	ldh [hCGBPalUpdate], a
	ret

TitleScreenPalettes:
; BG (measured from BCPD in the Yellow harness)
	RGB 31,31,31, 31,31,00, 07,07,25, 00,00,17 ; PAL_LOGO2
	RGB 31,31,31, 31,31,00, 31,00,00, 31,00,00 ; PAL_LOGO1
	RGB 31,31,31, 31,31,00, 31,01,01, 03,03,03 ; PAL_MEWMON
	RGB 31,31,31, 25,15,31, 19,00,22, 03,03,03 ; PAL_PURPLEMON
rept 4 ; unused on the title (Yellow leaves these as they were)
	RGB 31,31,31, 31,31,31, 31,31,31, 31,31,31
endr
; OBJ (measured from OCPD): Pikachu's eyes use palette 2
	RGB 31,31,31, 31,31,31, 07,07,25, 00,00,17
	RGB 31,31,31, 31,31,31, 31,00,00, 31,00,00
	RGB 31,31,31, 31,31,31, 31,01,01, 03,03,03
	RGB 31,31,31, 31,31,31, 19,00,22, 03,03,03
rept 4
	RGB 31,31,31, 31,31,31, 31,31,31, 31,31,31
endr

PlaceBuildID:
; Print the build id at de to the tilemap at hl.  The title screen has no font
; loaded, so this maps each character onto the glyphs copied into VRAM bank 1
; by TitleScreen_LoadBuildIDGlyphs instead of going through PlaceString.
.loop
	ld a, [de]
	cp CHARVAL("@")
	ret z
	inc de
	cp CHARVAL(" ") ; already a blank tile
	jr z, .place
	cp CHARVAL("0")
	jr c, .letter
	sub CHARVAL("0") - BUILD_ID_DIGIT_TILE
	jr .place
.letter
	sub CHARVAL("a") - BUILD_ID_LETTER_TILE
.place
	ld [hli], a
	jr .loop

BuildIDString:
	db "{BUILD_ID_TEXT}", "@"

; Yellow: engine/movie/title_yellow.asm, plus the copyright tiles that
; DisplayTitleScreen loads itself.
LoadYellowTitleScreenGFX:
	ld hl, TitleCopyrightGraphics
	ld de, vTiles1 tile $60
	ld bc, 5 tiles
	call CopyBytes
	ld hl, TitleNineTile
	ld de, vTiles1 tile $6e
	ld bc, 1 tiles
	call CopyBytes
	ld hl, TitleGameFreakLogoGraphics
	ld de, vTiles1 tile $65
	ld bc, 9 tiles
	call CopyBytes
	ld hl, PokemonLogoGraphics
	ld de, vTiles2
	ld bc, PokemonLogoGraphicsEnd - PokemonLogoGraphics
	call CopyBytes
	ld hl, PokemonLogoCornerGraphics
	ld de, vTiles1 tile $7d
	ld bc, PokemonLogoCornerGraphicsEnd - PokemonLogoCornerGraphics
	call CopyBytes
	ld hl, TitlePikachuBGGraphics
	ld de, vTiles1
	ld bc, TitlePikachuBGGraphicsEnd - TitlePikachuBGGraphics
	call CopyBytes
	ld hl, TitlePikachuOBGraphics
	ld de, vTiles1 tile $70
	ld bc, TitlePikachuOBGraphicsEnd - TitlePikachuOBGraphics
	call CopyBytes
; ' ' is the blank tile everywhere on this screen
	ld hl, vTiles2 tile ' '
	ld bc, 1 tiles
	xor a
	jp ByteFill

TitleScreen_PlacePokemonLogo:
	hlcoord 2, 1
	ld de, TitleScreenPokemonLogoTilemap
	lb bc, 7, 16
	jr TitleScreen_CopyBox

TitleScreen_PlacePikaSpeechBubble:
	hlcoord 6, 4
	ld de, TitleScreenPikaBubbleTilemap
	lb bc, 4, 7
	call TitleScreen_CopyBox
	hlcoord 9, 8
	ld [hl], $64
	inc hl
	ld [hl], $65
	ret

TitleScreen_PlacePikachu:
	hlcoord 4, 8
	ld de, TitleScreenPikachuTilemap
	lb bc, 9, 12
	call TitleScreen_CopyBox
	hlcoord 16, 10
	ld [hl], $96
	hlcoord 16, 11
	ld [hl], $9d
	hlcoord 16, 12
	ld [hl], $a7
	hlcoord 16, 13
	ld [hl], $b1
	ld hl, TitleScreenPikachuEyesOAMData
	ld de, wShadowOAM
	ld bc, TitleScreenPikachuEyesOAMDataEnd - TitleScreenPikachuEyesOAMData
	jp CopyBytes

TitleScreenPikachuEyesOAMData:
; y, x, tile, attributes ($20 = X flip; CGB OBJ palette 2)
	db $60, $40, $f1, $22
	db $60, $48, $f0, $22
	db $68, $40, $f3, $22
	db $68, $48, $f2, $22
	db $60, $60, $f0, $02
	db $60, $68, $f1, $02
	db $68, $60, $f2, $02
	db $68, $68, $f3, $02
TitleScreenPikachuEyesOAMDataEnd:

TitleScreen_CopyBox:
; Yellow: Bank3D_CopyBox -- copy a c x b box from de to the tilemap at hl.
.row
	push bc
	push hl
.col
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	ret

TitleScreenPokemonLogoTilemap: ; 16x7
	INCBIN "gfx/title/yellow/pokemon_logo.tilemap"

TitleScreenPikaBubbleTilemap: ; 7x4
	INCBIN "gfx/title/yellow/pika_bubble.tilemap"

TitleScreenPikachuTilemap: ; 12x9
	INCBIN "gfx/title/yellow/pikachu.tilemap"

; Yellow's NintendoCopyrightLogoGraphics (gfx/splash/copyright.png, which is
; not Crystal's): only the first five tiles, "©1995-", are used here.
TitleCopyrightGraphics: INCBIN "gfx/title/yellow/copyright.2bpp", 0, 5 * TILE_SIZE
TitleGameFreakLogoGraphics: INCBIN "gfx/title/yellow/gamefreak_inc.2bpp"
TitleNineTile: INCBIN "gfx/title/yellow/nine.2bpp"
PokemonLogoGraphics: INCBIN "gfx/title/yellow/pokemon_logo.2bpp"
PokemonLogoGraphicsEnd:
PokemonLogoCornerGraphics: INCBIN "gfx/title/yellow/pokemon_logo_corner.2bpp"
PokemonLogoCornerGraphicsEnd:
TitlePikachuBGGraphics: INCBIN "gfx/title/yellow/pikachu_bg.2bpp"
TitlePikachuBGGraphicsEnd:
TitlePikachuOBGraphics: INCBIN "gfx/title/yellow/pikachu_ob.2bpp"
TitlePikachuOBGraphicsEnd:
