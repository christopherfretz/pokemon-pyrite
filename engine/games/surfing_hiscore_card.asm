; Kanto hack (M12b-4): the SUMMER BEACH HOUSE PRINTER's Surfing Pikachu Hi-Score
; card -- Yellow's Printer_PrepareSurfingMinigameHighScoreTileMap
; (vendor/pokeyellow/engine/printer/printer.asm) with its art
; (surfing_pikachu_2, 96 tiles) and two tilemaps, plus the PRINTER's NO branch
; (the card on screen until A or B).  The YES branch (the Game Boy Printer) is
; PrintSurfingHiScore in engine/printer/print_surfing_hiscore.asm, next to
; Crystal's printer engine in bank $21; it draws this same card.
; Findings: docs/M12-STRETCH.md "## M12b-4 findings".

SECTION "Surfing Pikachu Hi-Score Card", ROMX

SurfingHiScoreCard::
; Special.  Yellow's SummerBeachHousePrinterText NO branch: SaveScreenTiles
; ToBuffer2, the card, WaitForTextScrollButtonPress, then GBPalWhiteOutWith
; Delay3 / reload tiles / restore the text box / Delay3 / GBPalNormal.
	call LoadStandardMenuHeader ; Yellow: SaveScreenTilesToBuffer2
	call ClearSprites
	call DisableSpriteUpdates
	call SurfingHiScoreCard_Draw
.wait
; Yellow's WaitForTextScrollButtonPress: A or B.  Its ▼ blink at (18,16) never
; shows here (hDownArrowBlinkCount1 starts at 0, so the arrow is never drawn).
	call DelayFrame
	call GetJoypad
	ldh a, [hJoyPressed]
	and PAD_A | PAD_B
	jr z, .wait
	; fallthrough

SurfingHiScoreCard_Close::
; Yellow: GBPalWhiteOutWithDelay3, ReloadTilesetTilePatterns,
; RestoreScreenTilesAndReloadTilePatterns, LoadScreenTilesFromBuffer2, Delay3,
; GBPalNormal (no fade).  Crystal: CloseSubmenu's order (the text box comes
; back from the menu backup) with the palettes applied at once.
	call ClearBGPalettes
	ld c, 3
	call DelayFrames
	call ReloadTilesetAndPalettes
	call UpdateSprites
	call Call_ExitMenu
	ld b, SCGB_MAPPALS
	call GetSGBLayout
	farcall LoadOW_BGPal7
	call WaitBGMap2
	farcall ApplyPals
	ld a, TRUE
	ldh [hCGBPalUpdate], a
	jp EnableSpriteUpdates

SurfingHiScoreCard_Draw::
; Yellow's Printer_PrepareSurfingMinigameHighScoreTileMap, step for step.
	; GBPalWhiteOutWithDelay3
	call ClearBGPalettes
	ld c, 3
	call DelayFrames
	; ClearScreen (Yellow's ends in Delay3); the attributes go now too: every
	; tile is VRAM bank 0, palette 0 (Yellow: one SET_PAL_GENERIC palette)
	hlcoord 0, 0
	ld a, ' '
	ld bc, SCREEN_AREA
	call ByteFill
	hlcoord 0, 0, wAttrmap
	xor a
	ld bc, SCREEN_AREA
	call ByteFill
	ld a, 2 ; attributes
	ldh [hBGMapMode], a
	ld c, 3
	call DelayFrames
	xor a
	ldh [hBGMapMode], a
	; CopyVideoData: 96 tiles to vChars2
	ld de, SurfingPikachu2Graphics
	ld hl, vTiles2
	lb bc, BANK(SurfingPikachu2Graphics), (SurfingPikachu2GraphicsEnd - SurfingPikachu2Graphics) / TILE_SIZE
	call Get2bpp
	hlcoord 0, 0
	call .PlaceRowAlternatingTiles
	hlcoord 0, SCREEN_HEIGHT - 1
	call .PlaceRowAlternatingTiles
	hlcoord 0, 0
	call .PlaceColumnAlternatingTiles
	hlcoord SCREEN_WIDTH - 1, 0
	call .PlaceColumnAlternatingTiles
	ld a, $4
	hlcoord 0, 0
	ld [hl], a
	hlcoord 0, SCREEN_HEIGHT - 1
	ld [hl], a
	hlcoord SCREEN_WIDTH - 1, 0
	ld [hl], a
	hlcoord SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1
	ld [hl], a
	ld de, .Tilemap1
	hlcoord 10, 8
	lb bc, 3, 8
	call .CopyBox
	ld de, .Tilemap2
	hlcoord 2, 11
	lb bc, 6, 16
	call .CopyBox
	ld de, .PikachusBeachString
	hlcoord 3, 2
	call PlaceString
	ld de, .HiScoreString
	hlcoord 9, 4
	call PlaceString
	ld de, .PointsString
	hlcoord 12, 6
	call PlaceString
	; the player's name, right-aligned to end at (8,4): Yellow's arithmetic
	ld hl, wPlayerName
	ld bc, 0
.find_end_of_name
	ld a, [hli]
	inc c
	cp '@'
	jr nz, .find_end_of_name
	ld a, 8
	sub c
	jr nc, .got_name_length
	xor a
.got_name_length
	ld c, a
	hlcoord 2, 4
	add hl, bc
	ld de, wPlayerName
	call PlaceString
	call .CopyScore
	; SET_PAL_GENERIC: PAL_MEWMON over the whole screen
	ldh a, [rWBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rWBK], a
	ld hl, .MewmonPal
	ld de, wBGPals1
	ld bc, 1 palettes
	call CopyBytes
	pop af
	ldh [rWBK], a
	; hAutoBGTransferEnabled = 1, Delay3
	ld a, 1 ; tiles
	ldh [hBGMapMode], a
	ld c, 3
	call DelayFrames
	; GBPalNormal
	farcall ApplyPals
	ld a, TRUE
	ldh [hCGBPalUpdate], a
	ret

.PlaceRowAlternatingTiles:
	ld c, SCREEN_WIDTH / 2
.row_loop
	ld [hl], $0
	inc hl
	ld [hl], $1
	inc hl
	dec c
	jr nz, .row_loop
	ret

.PlaceColumnAlternatingTiles:
	ld c, SCREEN_HEIGHT / 2
	ld de, SCREEN_WIDTH
.col_loop
	ld [hl], $2
	add hl, de
	ld [hl], $3
	add hl, de
	dec c
	jr nz, .col_loop
	ret

.CopyBox:
; Yellow's Diploma_Surfing_CopyBox
.y
	push bc
	push hl
.x
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .x
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .y
	ret

.CopyScore:
; Yellow's CopySurfingMinigameScore: four BCD digits, high byte first, no
; leading-zero suppression.  The Hi-Score is saved state (WRAM bank 1, which
; is mapped on the overworld).
	ld de, wSurfingMinigameHiScore + 1
	hlcoord 7, 6
	ld a, [de]
	call .BCDConvertScore
	ld a, [de]
.BCDConvertScore:
	ld c, a
	swap a
	and $f
	add '0'
	ld [hli], a
	ld a, c
	and $f
	add '0'
	ld [hli], a
	dec de
	ret

.MewmonPal:
; Yellow's CGB PAL_MEWMON (data/sgb/sgb_palettes.asm CGBBasePalettes)
	RGB 31, 31, 31
	RGB 31, 31, 00
	RGB 31, 01, 01
	RGB 03, 03, 03

.Tilemap1:
INCBIN "gfx/surfing_pikachu/high_score_1.tilemap"

.Tilemap2:
INCBIN "gfx/surfing_pikachu/high_score_2.tilemap"

.PikachusBeachString:
	db "Pikachu's Beach@"
.HiScoreString:
	db "'s Hi-Score@"
.PointsString:
	db "Points@"

SurfingPikachu2Graphics: INCBIN "gfx/surfing_pikachu/surfing_pikachu_2.2bpp"
SurfingPikachu2GraphicsEnd:
