PlaceMenuItemName:
	push de
	ld a, [wMenuSelection]
	ld [wNamedObjectIndex], a
	call GetItemName
	pop hl
	call PlaceString
	ret

PlaceMenuItemQuantity:
	push de
	ld a, [wMenuSelection]
	ld [wCurItem], a
	farcall _CheckTossableItem
	ld a, [wItemAttributeValue]
	pop hl
	and a
	jr nz, .done
	ld de, SCREEN_WIDTH + 1
	add hl, de
	ld [hl], '×'
	inc hl
	ld de, wMenuSelectionQuantity
	lb bc, 1, 2
	call PrintNum

.done
	ret

PlaceMoneyTopRight:
	ld hl, MoneyTopRightMenuHeader
	call CopyMenuHeader
	jr PlaceMoneyTextbox

PlaceMoneyBottomLeft:
	ld hl, MoneyBottomLeftMenuHeader
	call CopyMenuHeader
	jr PlaceMoneyTextbox

PlaceMoneyAtTopLeftOfTextbox:
	ld hl, MoneyTopRightMenuHeader
	lb de, 0, 11
	call OffsetMenuHeader

PlaceMoneyTextbox:
	call MenuBox
	call MenuBoxCoord2Tile
	ld de, SCREEN_WIDTH + 1
	add hl, de
	ld de, wMoney
	lb bc, PRINTNUM_MONEY | 3, 6
	call PrintNum
	ret

MoneyTopRightMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 11, 0, SCREEN_WIDTH - 1, 2
	dw NULL
	db 1 ; default option

MoneyBottomLeftMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 11, 8, 13
	dw NULL
	db 1 ; default option

DisplayCoinCaseBalance:
	; Place a text box of size 1x7 at 11, 0.
	hlcoord 11, 0
	ld b, 1
	ld c, 7
	call Textbox
	hlcoord 12, 0
	ld de, CoinString
	call PlaceString
	hlcoord 17, 1
	ld de, ShowMoney_TerminatorString
	call PlaceString
	ld de, wCoins
	lb bc, 2, 4
	hlcoord 13, 1
	call PrintNum
	ret

DisplayMoneyAndCoinBalance:
	hlcoord 5, 0
	ld b, 3
	ld c, 13
	call Textbox
	hlcoord 6, 1
	ld de, MoneyString
	call PlaceString
	hlcoord 12, 1
	ld de, wMoney
	lb bc, PRINTNUM_MONEY | 3, 6
	call PrintNum
	hlcoord 6, 3
	ld de, CoinString
	call PlaceString
	hlcoord 15, 3
	ld de, wCoins
	lb bc, 2, 4
	call PrintNum
	ret

MoneyString:
	db "MONEY@"
CoinString:
	db "COIN@"
ShowMoney_TerminatorString:
	db "@"

StartMenu_DrawSafariGameStatusBox:
; Kanto hack M7 10j.
	hlcoord 0, 0
	ld b, 3
	ld c, 7
	call Textbox
	ret

StartMenu_PrintSafariGameStatus:
; Kanto hack M7 10j: re-Englished and re-laid out to match Yellow's
; PrintSafariZoneSteps (vendor/pokeyellow/engine/overworld/player_state.asm),
; down to blanking the first "×" when fewer than ten balls are left.  Yellow's
; box really does read "/500" while the gate hands out 502 steps.
	ld hl, wOptions
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	call StartMenu_DrawSafariGameStatusBox
	hlcoord 1, 1
	ld de, wSafariTimeRemaining
	lb bc, 2, 3
	call PrintNum
	hlcoord 4, 1
	ld de, .SafariStepsString
	call PlaceString
	hlcoord 1, 3
	ld de, .SafariBallString
	call PlaceString
	ld a, [wSafariBallsRemaining]
	cp 10
	jr nc, .ten_or_more
; Yellow blanks one column here, because its PrintNumber space-pads the tens
; digit; Crystal's PrintNum leaves that cell alone instead, so both multiply-sign
; columns have to be cleared to land on Yellow's "BALL  9".
	hlcoord 5, 3
	ld [hl], CHARVAL(" ")
	inc hl
	ld [hl], CHARVAL(" ")
.ten_or_more
	hlcoord 6, 3
	ld de, wSafariBallsRemaining
	lb bc, 1, 2
	call PrintNum
	pop af
	ld [wOptions], a
	ret

.SafariStepsString:
	db "/500@"
.SafariBallString:
	db "BALL×× @"

StartMenu_DrawBugContestStatusBox:
	hlcoord 0, 0
	ld b, 5
	ld c, 17
	call Textbox
	ret

StartMenu_PrintBugContestStatus:
	ld hl, wOptions
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	call StartMenu_DrawBugContestStatusBox
	hlcoord 1, 5
	ld de, .BallsString
	call PlaceString
	hlcoord 8, 5
	ld de, wParkBallsRemaining
	lb bc, PRINTNUM_LEFTALIGN | 1, 2
	call PrintNum
	hlcoord 1, 1
	ld de, .CaughtString
	call PlaceString
	ld a, [wContestMon]
	and a
	ld de, .NoneString
	jr z, .no_contest_mon
	ld [wNamedObjectIndex], a
	call GetPokemonName

.no_contest_mon
	hlcoord 8, 1
	call PlaceString
	ld a, [wContestMon]
	and a
	jr z, .skip_level
	hlcoord 1, 3
	ld de, .LevelString
	call PlaceString
	ld a, [wContestMonLevel]
	ld h, b
	ld l, c
	inc hl
	ld c, 3
	call Print8BitNumLeftAlign

.skip_level
	pop af
	ld [wOptions], a
	ret

.BallsJPString: ; unreferenced
	db "ボール　　　こ@"
.CaughtString:
	db "CAUGHT@"
.BallsString:
	db "BALLS:@"
.NoneString:
	db "None@"
.LevelString:
	db "LEVEL@"

FindApricornsInBag:
; Checks the bag for Apricorns.
	ld hl, wKurtApricornCount
	xor a
	ld [hli], a
	assert wKurtApricornCount + 1 == wKurtApricornItems
	dec a
	ld bc, 10
	call ByteFill

	ld hl, ApricornBalls
.loop
	ld a, [hl]
	cp -1
	jr z, .done
	push hl
	ld [wCurItem], a
	ld hl, wNumItems
	call CheckItem
	pop hl
	jr nc, .nope
	ld a, [hl]
	call .addtobuffer
.nope
	inc hl
	inc hl
	jr .loop

.done
	ld a, [wKurtApricornCount]
	and a
	ret nz
	scf
	ret

.addtobuffer:
	push hl
	ld hl, wKurtApricornCount
	inc [hl]
	ld e, [hl]
	ld d, 0
	add hl, de
	ld [hl], a
	pop hl
	ret

INCLUDE "data/items/apricorn_balls.asm"
