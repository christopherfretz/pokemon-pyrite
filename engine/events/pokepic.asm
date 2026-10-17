Pokepic::
; SS3b: the box interior is ' ' ($7f), and the 7x7 picture leaves one interior
; row under it showing that tile.  In the overworld vTiles2 tile $7f is not
; blank: CloseText (and map entry) runs LoadOverworldFont, which puts
; overworld_space.2bpp there -- a solid colour-1 tile, the map name sign's
; background.  ElmsLab and the Fan Club reach pokepic through reanchormap,
; whose font reload (LoadFrame) blanks $7f, so their row is white; the S.S.
; ANNE storyteller and the Route 15 binoculars come straight from closetext,
; so their row was a colour-1 bar (grey, then the mon's light colour once SS3
; coloured the box).  Load the blank textbox space here, as LoadFrame does,
; before the box is drawn.  The next CloseText or map entry reloads the
; overworld one.
	ld de, TextboxSpaceGFX
	ld hl, vTiles2 tile ' '
	lb bc, BANK(TextboxSpaceGFX), 1
	call Get2bpp
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
; SS3b: the box interior is ' ' ($7f), and the 7x7 picture leaves one interior
; row under it showing that tile.  In the overworld vTiles2 tile $7f is not
; blank: CloseText (and map entry) runs LoadOverworldFont, which puts
; overworld_space.2bpp there -- a solid colour-1 tile, the map name sign's
; background.  ElmsLab and the Fan Club reach pokepic through reanchormap,
; whose font reload (LoadFrame) blanks $7f, so their row is white; the S.S.
; ANNE storyteller and the Route 15 binoculars come straight from closetext,
; so their row was a colour-1 bar (grey, then the mon's light colour once SS3
; coloured the box).  Load the blank textbox space here, as LoadFrame does,
; before the box is drawn.  The next CloseText or map entry reloads the
; overworld one.
	ld de, TextboxSpaceGFX
	ld hl, vTiles2 tile ' '
	lb bc, BANK(TextboxSpaceGFX), 1
	call Get2bpp
	ld hl, PokepicMenuHeader
	call CopyMenuHeader
	call ClearMenuBoxInterior
	call WaitBGMap
	call GetMemSGBLayout
	xor a
	ldh [hBGMapMode], a
	call LoadOverworldTilemapAndAttrmapPals
; SS3: _CGB_Pokepic borrowed PAL_BG_TEXT for the species' palette.
; GetMemSGBLayout only refills wBGPals1; push it to the shadow buffer and the
; hardware (as ClosePikapicBox does), or the next textbox -- ElmsLab's opentext
; right after closepokepic -- draws in the mon's colours.
	farcall RestorePikapicMapPals
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
