; TrainerCard.Jumptable indexes
	const_def
	const TRAINERCARDSTATE_PAGE1_LOADGFX ; 0
	const TRAINERCARDSTATE_PAGE1_JOYPAD  ; 1
	const TRAINERCARDSTATE_PAGE2_LOADGFX ; 2
	const TRAINERCARDSTATE_PAGE2_JOYPAD  ; 3
	const TRAINERCARDSTATE_PAGE3_LOADGFX ; 4
	const TRAINERCARDSTATE_PAGE3_JOYPAD  ; 5
	const TRAINERCARDSTATE_QUIT          ; 6

TrainerCard:
	ld a, [wStateFlags]
	push af
	xor a
	ld [wStateFlags], a
	ld hl, wOptions
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	call .InitRAM
.loop
	call UpdateTime
	call JoyTextDelay
	ld a, [wJumptableIndex]
	bit JUMPTABLE_EXIT_F, a
	jr nz, .quit
	ldh a, [hJoyLast]
	and PAD_B
	jr nz, .quit
	call .RunJumptable
	call DelayFrame
	jr .loop

.quit
	pop af
	ld [wOptions], a
	pop af
	ld [wStateFlags], a
	ret

.InitRAM:
	call ClearBGPalettes
	call ClearSprites
	call ClearTilemap
	call DisableLCD

	farcall GetCardPic

	ld hl, CardRightCornerGFX
	ld de, vTiles2 tile $1c
	ld bc, 1 tiles
	ld a, BANK(CardRightCornerGFX)
	call FarCopyBytes

	ld hl, CardStatusGFX
	ld de, vTiles2 tile $29
	ld bc, 86 tiles
	ld a, BANK(CardStatusGFX)
	call FarCopyBytes

	call TrainerCard_PrintTopHalfOfCard

	hlcoord 0, 8
	ld d, 6
	call TrainerCard_InitBorder

	call EnableLCD
	call WaitBGMap
	ld b, SCGB_TRAINER_CARD
	call GetSGBLayout
	call SetDefaultBGPAndOBP
	call WaitBGMap
	ld hl, wJumptableIndex
	xor a ; TRAINERCARDSTATE_PAGE1_LOADGFX
	ld [hli], a ; wJumptableIndex
	ld [hli], a ; wTrainerCardBadgeFrameCounter
	ld [hli], a ; wTrainerCardBadgeTileID
	ld [hl], a  ; wTrainerCardBadgeAttributes
	ret

.RunJumptable:
	jumptable .Jumptable, wJumptableIndex

.Jumptable:
; entries correspond to TRAINERCARDSTATE_* constants
	dw TrainerCard_Page1_LoadGFX
	dw TrainerCard_Page1_Joypad
	dw TrainerCard_Page2_LoadGFX
	dw TrainerCard_Page2_Joypad
	dw TrainerCard_Page3_LoadGFX
	dw TrainerCard_Page3_Joypad
	dw TrainerCard_Quit

TrainerCard_IncrementJumptable:
	ld hl, wJumptableIndex
	inc [hl]
	ret

TrainerCard_Quit:
	ld hl, wJumptableIndex
	set JUMPTABLE_EXIT_F, [hl]
	ret

TrainerCard_Page1_LoadGFX:
	call ClearSprites
	hlcoord 0, 8
	ld d, 6
	call TrainerCard_InitBorder
	call WaitBGMap
	call TrainerCard_RestorePals
	ld de, CardStatusGFX
	ld hl, vTiles2 tile $29
	lb bc, BANK(CardStatusGFX), 86
	call Request2bpp
	call TrainerCard_Page1_PrintDexCaught_GameTime
	call TrainerCard_IncrementJumptable
	ret

TrainerCard_Page1_Joypad:
	call TrainerCard_Page1_PrintGameTime
	ld hl, hJoyLast
	ld a, [hl]
	and PAD_RIGHT | PAD_A
	jr nz, .pressed_right_a
	ret

.pressed_right_a
; Kanto hack (F5): the Kanto act has no Johto badges, so page 1 goes straight
; to the Kanto page (Yellow's single badge card); the Johto act keeps 1 -> 2.
	farcall PCPC_CheckKantoAct
	ld a, TRAINERCARDSTATE_PAGE2_LOADGFX
	jr z, .got_page
	ld a, TRAINERCARDSTATE_PAGE3_LOADGFX
.got_page
	ld [wJumptableIndex], a
	ret

.KantoBadgeCheck: ; unreferenced
	ld a, [wKantoBadges]
	and a
	ret z
	ld a, TRAINERCARDSTATE_PAGE3_LOADGFX
	ld [wJumptableIndex], a
	ret

TrainerCard_Page2_LoadGFX:
	call ClearSprites
	hlcoord 0, 8
	ld d, 6
	call TrainerCard_InitBorder
	call WaitBGMap
	call TrainerCard_RestorePals
	ld de, LeaderGFX
	ld hl, vTiles2 tile $29
	lb bc, BANK(LeaderGFX), 86
	call Request2bpp
	ld de, BadgeGFX
	ld hl, vTiles0 tile $00
	lb bc, BANK(BadgeGFX), 44
	call Request2bpp
	call TrainerCard_Page2_3_InitObjectsAndStrings
	call TrainerCard_IncrementJumptable
	ret

TrainerCard_Page2_Joypad:
	ld hl, TrainerCard_JohtoBadgesOAM
	call TrainerCard_Page2_3_AnimateBadges
	ld hl, hJoyLast
	ld a, [hl]
	and PAD_A
	jr nz, .Quit
	ld a, [hl]
	and PAD_LEFT
	jr nz, .d_left
	ld a, [hl]
	and PAD_RIGHT ; Kanto hack (F5): Johto act, page 2 -> Kanto page
	jr nz, .KantoBadgeCheck
	ret

.d_left
	ld a, TRAINERCARDSTATE_PAGE1_LOADGFX
	ld [wJumptableIndex], a
	ret

.KantoBadgeCheck:
	ld a, [wKantoBadges]
	and a
	ret z
	ld a, TRAINERCARDSTATE_PAGE3_LOADGFX
	ld [wJumptableIndex], a
	ret

.Quit:
	ld a, TRAINERCARDSTATE_QUIT
	ld [wJumptableIndex], a
	ret

TrainerCard_Page3_LoadGFX:
; Kanto hack (F5): page 3 is Yellow's badge card (pokeyellow
; engine/menus/draw_badges.asm): eight numbered KANTO leader faces, each
; replaced by its badge once earned, all BG tiles at Yellow's own coordinates,
; coloured like Yellow's CGB card (SetPal_TrainerCard).
	call ClearSprites
	hlcoord 0, 8
	ld d, 6
	call TrainerCard_InitBorder
	call WaitBGMap
	ld de, KantoBadgeNumbersGFX
	ld hl, vTiles2 tile KANTO_CARD_NUMBER_TILE
	lb bc, BANK(KantoBadgeNumbersGFX), NUM_KANTO_BADGES
	call Request2bpp
	ld de, KantoLeaderBadgeGFX
	ld hl, vTiles2 tile KANTO_CARD_FACE_TILE
	lb bc, BANK(KantoLeaderBadgeGFX), NUM_KANTO_BADGES * 8
	call Request2bpp
	ld de, LeaderGFX tile 80 ; "BADGES" (TrainerCard_Page2_3_InitObjectsAndStrings.BadgesTilemap)
	ld hl, vTiles2 tile $79
	lb bc, BANK(LeaderGFX), 5
	call Request2bpp
	call TrainerCard_Page3_PlaceKantoBadges
	call TrainerCard_Page3_KantoPals
	call TrainerCard_IncrementJumptable
	ret

DEF KANTO_CARD_NUMBER_TILE EQU $29 ; 8 badge numbers
DEF KANTO_CARD_FACE_TILE   EQU $31 ; Yellow's badges.png: face i at +8i, badge i at +8i+4

TrainerCard_Page3_PlaceKantoBadges:
	hlcoord 2, 8
	ld de, TrainerCard_Page2_3_InitObjectsAndStrings.BadgesTilemap
	call TrainerCardSetup_PlaceTilemapString
	ld a, [wKantoBadges]
	ld e, a
	ld d, KANTO_CARD_NUMBER_TILE
	hlcoord 2, 11 ; Yellow DrawBadges: rows 11 and 14, 4 leaders each
	call .Row
	hlcoord 2, 14
.Row:
	ld c, 4
.loop
	push hl
	ld [hl], d ; badge number
	ld a, d
	sub KANTO_CARD_NUMBER_TILE
	add a
	add a
	add a
	add KANTO_CARD_FACE_TILE ; face
	srl e
	jr nc, .got_tile
	add 4 ; badge art follows each face
.got_tile
	push de
	ld de, SCREEN_WIDTH + 1
	add hl, de
	ld [hli], a
	inc a
	ld [hl], a
	inc a
	ld de, SCREEN_WIDTH - 1
	add hl, de
	ld [hli], a
	inc a
	ld [hl], a
	pop de
	inc d
	pop hl
rept 4
	inc hl
endr
	dec c
	jr nz, .loop
	ret

TrainerCard_Page3_KantoPals:
; BG palettes 2-5 = Yellow's CGB MEWMON/BADGE/REDMON/YELLOWMON (pokeyellow
; data/sgb/sgb_palettes.asm CGBBasePalettes, PalPacket_TrainerCard); the leader
; area is MEWMON like Yellow's card, and each earned badge gets Yellow's
; BlkPacket_TrainerCard blocks (data/sgb/sgb_packets.asm).
	ld hl, .Pals
	ld de, wBGPals1 palette 2
	ld bc, 4 palettes
	ld a, BANK(wBGPals1)
	call FarCopyWRAM
	hlcoord 2, 11, wAttrmap
	lb bc, 6, 16
	ld a, 2
	call .Fill
	ld a, [wKantoBadges]
	ld e, a
	ld hl, .Blocks
.block_loop
	ld a, [hli]
	cp -1
	jr z, .apply
	and e
	jr z, .next_block
	push de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	push hl
	ld h, d
	ld l, e
	call .Fill
	pop hl
	pop de
	jr .block_loop

.next_block
	ld bc, 5
	add hl, bc
	jr .block_loop

.apply
	farcall ApplyAttrmap
	farcall ApplyPals
	ld a, TRUE
	ldh [hCGBPalUpdate], a
	ret

.Fill:
; fill b rows x c columns of wAttrmap at hl with a
.row
	push bc
	push hl
.col
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

.Pals:
	RGB 31,31,31, 31,31,00, 31,01,01, 03,03,03 ; PAL_MEWMON
	RGB 31,31,31, 23,08,00, 17,14,11, 03,03,03 ; PAL_BADGE
	RGB 31,31,31, 31,17,00, 31,00,00, 03,03,03 ; PAL_REDMON
	RGB 31,31,31, 31,31,00, 28,14,00, 03,03,03 ; PAL_YELLOWMON

MACRO kanto_card_blk
; badge flag, x1, y1, x2, y2, Yellow palette (0 MEWMON .. 3 YELLOWMON)
	db 1 << \1
	dw wAttrmap + (\3) * SCREEN_WIDTH + (\2)
	db (\5) - (\3) + 1, (\4) - (\2) + 1, (\6) + 2
ENDM

.Blocks:
	; Boulder Badge (03,12)-(04,13) stays MEWMON
	kanto_card_blk CASCADEBADGE, 07, 12, 08, 13, 1
	kanto_card_blk THUNDERBADGE, 11, 12, 12, 13, 3
	kanto_card_blk RAINBOWBADGE, 16, 11, 17, 12, 2
	kanto_card_blk RAINBOWBADGE, 14, 13, 15, 13, 1
	kanto_card_blk RAINBOWBADGE, 16, 13, 17, 13, 3
	kanto_card_blk SOULBADGE,    03, 15, 04, 16, 2
	kanto_card_blk MARSHBADGE,   07, 15, 08, 16, 3
	kanto_card_blk VOLCANOBADGE, 11, 15, 12, 16, 2
	kanto_card_blk EARTHBADGE,   15, 15, 16, 16, 1
	db -1

TrainerCard_Page3_Joypad:
	ld hl, hJoyLast
	ld a, [hl]
	and PAD_A
	jr nz, .quit
	ld a, [hl]
	and PAD_LEFT
	jr nz, .left
	ld a, [hl]
	and PAD_RIGHT
	jr nz, .right
	ret

.quit
	ld a, TRAINERCARDSTATE_QUIT
	ld [wJumptableIndex], a
	ret

.left
; Kanto hack (F5): back to page 1 in the Kanto act (no Johto page), else page 2
	farcall PCPC_CheckKantoAct
	ld a, TRAINERCARDSTATE_PAGE2_LOADGFX
	jr z, .got_page
.right
	ld a, TRAINERCARDSTATE_PAGE1_LOADGFX
.got_page
	ld [wJumptableIndex], a
	ret

TrainerCard_RestorePals:
; Kanto hack (F5): the Kanto page repaints BG palettes 2-5 and the leader
; area's attributes; pages 1 and 2 put Crystal's layout back.
	ld b, SCGB_TRAINER_CARD
	jp GetSGBLayout

TrainerCard_PrintTopHalfOfCard:
	hlcoord 0, 0
	ld d, 5
	call TrainerCard_InitBorder
	hlcoord 2, 2
	ld de, .Name_Money
	call PlaceString
	hlcoord 2, 4
	ld de, .ID_No
	call TrainerCardSetup_PlaceTilemapString
	hlcoord 7, 2
	ld de, wPlayerName
	call PlaceString
	hlcoord 5, 4
	ld de, wPlayerID
	lb bc, PRINTNUM_LEADINGZEROS | 2, 5
	call PrintNum
	hlcoord 7, 6
	ld de, wMoney
	lb bc, PRINTNUM_MONEY | 3, 6
	call PrintNum
	hlcoord 1, 3
	ld de, .HorizontalDivider
	call TrainerCardSetup_PlaceTilemapString
	hlcoord 14, 1
	lb bc, 5, 7
	xor a
	ldh [hGraphicStartTile], a
	predef PlaceGraphic
	ret

.Name_Money:
	db   "NAME/"
	next ""
	next "MONEY@"

.ID_No:
	db $27, $28, -1 ; ID NO

.HorizontalDivider:
	db $25, $25, $25, $25, $25, $25, $25, $25, $25, $25, $25, $25, $26, -1 ; ____________>

TrainerCard_Page1_PrintDexCaught_GameTime:
	hlcoord 2, 10
	ld de, .Dex_PlayTime
	call PlaceString
	hlcoord 10, 15
	ld de, .Badges
	call PlaceString
	ld hl, wPokedexCaught
	ld b, wEndPokedexCaught - wPokedexCaught
	call CountSetBits
	ld de, wNumSetBits
	hlcoord 15, 10
	lb bc, 1, 3
	call PrintNum
	call TrainerCard_Page1_PrintGameTime
	hlcoord 2, 8
	ld de, .StatusTilemap
	call TrainerCardSetup_PlaceTilemapString
	ld a, [wStatusFlags]
	bit STATUSFLAGS_POKEDEX_F, a
	ret nz
	hlcoord 1, 9
	lb bc, 2, 17
	call ClearBox
	ret

.Dex_PlayTime:
	db   "#DEX"
	next "PLAY TIME@"

.Unused: ; unreferenced
	db "@"

.Badges:
	db "  BADGES▶@"

.StatusTilemap:
	db $29, $2a, $2b, $2c, $2d, -1

TrainerCard_Page2_3_InitObjectsAndStrings:
	hlcoord 2, 8
	ld de, .BadgesTilemap
	call TrainerCardSetup_PlaceTilemapString
	hlcoord 2, 10
	ld a, $29
	ld c, 4
.loop
	call TrainerCard_Page2_3_PlaceLeadersFaces
rept 4
	inc hl
endr
	dec c
	jr nz, .loop
	hlcoord 2, 13
	ld a, $51
	ld c, 4
.loop2
	call TrainerCard_Page2_3_PlaceLeadersFaces
rept 4
	inc hl
endr
	dec c
	jr nz, .loop2
	xor a
	ld [wTrainerCardBadgeFrameCounter], a
	ld hl, TrainerCard_JohtoBadgesOAM
	call TrainerCard_Page2_3_OAMUpdate
	ret

.BadgesTilemap:
	db $79, $7a, $7b, $7c, $7d, -1 ; "BADGES"

TrainerCardSetup_PlaceTilemapString:
.loop
	ld a, [de]
	cp -1
	ret z
	ld [hli], a
	inc de
	jr .loop

TrainerCard_InitBorder:
	ld e, SCREEN_WIDTH
.loop1
	ld a, $23
	ld [hli], a
	dec e
	jr nz, .loop1

	ld a, $23
	ld [hli], a

	ld e, SCREEN_WIDTH - 3
	ld a, ' '
.loop2
	ld [hli], a
	dec e
	jr nz, .loop2

	ld a, $1c
	ld [hli], a
	ld a, $23
	ld [hli], a

.loop3
	ld a, $23
	ld [hli], a

	ld e, SCREEN_WIDTH - 2
	ld a, ' '
.loop4
	ld [hli], a
	dec e
	jr nz, .loop4

	ld a, $23
	ld [hli], a

	dec d
	jr nz, .loop3

	ld a, $23
	ld [hli], a
	ld a, $24
	ld [hli], a

	ld e, SCREEN_WIDTH - 3
	ld a, ' '
.loop5
	ld [hli], a
	dec e
	jr nz, .loop5

	ld a, $23
	ld [hli], a

	ld e, SCREEN_WIDTH
.loop6
	ld a, $23
	ld [hli], a
	dec e
	jr nz, .loop6
	ret

TrainerCard_Page2_3_PlaceLeadersFaces:
	push de
	push hl
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld de, SCREEN_WIDTH - 3
	add hl, de
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld de, SCREEN_WIDTH - 3
	add hl, de
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	pop hl
	pop de
	ret

TrainerCard_Page1_PrintGameTime:
	hlcoord 11, 12
	ld de, wGameTimeHours
	lb bc, 2, 4
	call PrintNum
	inc hl
	ld de, wGameTimeMinutes
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	call PrintNum
	ldh a, [hVBlankCounter]
	and $1f
	ret nz
	hlcoord 15, 12
	ld a, [hl]
	xor ' ' ^ $2e ; alternate between space and small colon ($2e) tiles
	ld [hl], a
	ret

TrainerCard_Page2_3_AnimateBadges:
	ldh a, [hVBlankCounter]
	and %111
	ret nz
	ld a, [wTrainerCardBadgeFrameCounter]
	inc a
	and %111
	ld [wTrainerCardBadgeFrameCounter], a
	jr TrainerCard_Page2_3_OAMUpdate

TrainerCard_Page2_3_OAMUpdate:
; copy flag array pointer
	ld a, [hli]
	ld e, a
	ld a, [hli]
; get flag array
	ld d, a
	ld a, [de]
	ld c, a
	ld de, wShadowOAMSprite00
	ld b, NUM_JOHTO_BADGES
.loop
	srl c
	push bc
	jr nc, .skip_badge
	push hl
	ld a, [hli] ; y
	ld b, a
	ld a, [hli] ; x
	ld c, a
	ld a, [hli] ; pal
	ld [wTrainerCardBadgeAttributes], a
	ld a, [wTrainerCardBadgeFrameCounter]
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a
	ld a, [hl]
	ld [wTrainerCardBadgeTileID], a
	call .PrepOAM
	pop hl
.skip_badge
	ld bc, $b ; 3 + 2 * 4
	add hl, bc
	pop bc
	dec b
	jr nz, .loop
	ret

.PrepOAM:
	ld a, [wTrainerCardBadgeTileID]
	and 1 << 7
	jr nz, .xflip
	ld hl, .facing1
	jr .loop2

.xflip
	ld hl, .facing2
.loop2
	ld a, [hli]
	cp -1
	ret z
	add b
	ld [de], a ; y
	inc de

	ld a, [hli]
	add c
	ld [de], a ; x
	inc de

	ld a, [wTrainerCardBadgeTileID]
	and ~(1 << 7)
	add [hl]
	ld [de], a ; tile id
	inc hl
	inc de

	ld a, [wTrainerCardBadgeAttributes]
	add [hl]
	ld [de], a ; attributes
	inc hl
	inc de
	jr .loop2

.facing1
	dbsprite  0,  0,  0,  0, $00, 0
	dbsprite  1,  0,  0,  0, $01, 0
	dbsprite  0,  1,  0,  0, $02, 0
	dbsprite  1,  1,  0,  0, $03, 0
	db -1

.facing2
	dbsprite  0,  0,  0,  0, $01, 0 | OAM_XFLIP
	dbsprite  1,  0,  0,  0, $00, 0 | OAM_XFLIP
	dbsprite  0,  1,  0,  0, $03, 0 | OAM_XFLIP
	dbsprite  1,  1,  0,  0, $02, 0 | OAM_XFLIP
	db -1

TrainerCard_JohtoBadgesOAM:
; Template OAM data for each badge on the trainer card.
; Format:
	; y, x, palette
	; cycle 1: face tile, in1 tile, in2 tile, in3 tile
	; cycle 2: face tile, in1 tile, in2 tile, in3 tile

	dw wJohtoBadges

	; Zephyrbadge
	db $68, $18, 0
	db $00, $20, $24, $20 | (1 << 7)
	db $00, $20, $24, $20 | (1 << 7)

	; Hivebadge
	db $68, $38, 0
	db $04, $20, $24, $20 | (1 << 7)
	db $04, $20, $24, $20 | (1 << 7)

	; Plainbadge
	db $68, $58, 0
	db $08, $20, $24, $20 | (1 << 7)
	db $08, $20, $24, $20 | (1 << 7)

	; Fogbadge
	db $68, $78, 0
	db $0c, $20, $24, $20 | (1 << 7)
	db $0c, $20, $24, $20 | (1 << 7)

	; Mineralbadge
	db $80, $38, 0
	db $10, $20, $24, $20 | (1 << 7)
	db $10, $20, $24, $20 | (1 << 7)

	; Stormbadge
	db $80, $18, 0
	db $14, $20, $24, $20 | (1 << 7)
	db $14, $20, $24, $20 | (1 << 7)

	; Glacierbadge
	db $80, $58, 0
	db $18, $20, $24, $20 | (1 << 7)
	db $18, $20, $24, $20 | (1 << 7)

	; Risingbadge
	; X-flips on alternate cycles.
	db $80, $78, 0
	db $1c,            $20, $24, $20 | (1 << 7)
	db $1c | (1 << 7), $20, $24, $20 | (1 << 7)

CardStatusGFX: INCBIN "gfx/trainer_card/card_status.2bpp"

LeaderGFX:  INCBIN "gfx/trainer_card/leaders.2bpp"
BadgeGFX:   INCBIN "gfx/trainer_card/badges.2bpp"
; Kanto hack (F5): Crystal's unused page-3 copies (LeaderGFX2/BadgeGFX2, the
; same Johto files again) are replaced by Yellow's card art.
KantoLeaderBadgeGFX:  INCBIN "gfx/trainer_card/kanto_badges.2bpp"  ; pokeyellow gfx/trainer_card/badges.png
KantoBadgeNumbersGFX: INCBIN "gfx/trainer_card/kanto_badge_numbers.2bpp" ; pokeyellow gfx/trainer_card/badge_numbers.png

CardRightCornerGFX: INCBIN "gfx/trainer_card/card_right_corner.2bpp"
