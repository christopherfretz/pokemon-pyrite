Pokepic::
	ld hl, PokepicMenuHeader
	call CopyMenuHeader
	call MenuBox
	call UpdateSprites
	call ApplyTilemap
	ld b, SCGB_POKEPIC
	call GetSGBLayout
	xor a
	ldh [hBGMapMode], a
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld de, vTiles1
	predef GetMonFrontpic
	ld a, [wMenuBorderTopCoord]
	inc a
	ld b, a
	ld a, [wMenuBorderLeftCoord]
	inc a
	ld c, a
	call Coord2Tile
	ld a, $80
	ldh [hGraphicStartTile], a
	lb bc, 7, 7
	predef PlaceGraphic
	call WaitBGMap
	ret

ClosePokepic::
	ld hl, PokepicMenuHeader
	call CopyMenuHeader
	call ClearMenuBoxInterior
	call WaitBGMap
	call GetMemSGBLayout
	xor a
	ldh [hBGMapMode], a
	call LoadOverworldTilemapAndAttrmapPals
	call ApplyTilemap
	call UpdateSprites
	call LoadStandardFont
; SS2: ApplyTilemap leaves hBGMapMode = 1. Stock Crystal only ever follows
; closepokepic with opentext/closetext (ElmsLab), whose CloseText clears it; a
; script that ENDS on closepokepic (SS.ANNE 2F storyteller, Route 15 gate
; binoculars) returned to the overworld with VBlank still streaming the static
; wTilemap/wAttrmap into the BG map, so the first steps drew the room shifted
; and in the wrong palettes. Clear it here, as CloseText does.
	xor a
	ldh [hBGMapMode], a
	ret

PokepicMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 6, 4, 14, 13
	dw NULL
	db 1 ; default option
