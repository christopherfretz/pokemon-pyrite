; Yellow's HOUSE tileset (CH1: ported for the CERULEAN TRASHED HOUSE, whose
; 4x4 room is Yellow's verbatim), coloured Crystal-style per the 7g-b.4 ruling
; -- Yellow's line art, Crystal's palette conventions.  TILESET_KANTO_HOUSE
; also loads Crystal's own house.pal (LoadSpecialMapPalette .house), so these
; names are the same colours as the neighbouring Cerulean houses on
; TILESET_HOUSE: pink floor, blue back wall, brown shelves and table, red
; stools, green plants.  Only the 54 tiles the trashed house draws are pulled
; out; every other slot is GRAY (nothing else uses this tileset).
;
;   WATER  $00 $3f -- the striped back wall; $23 $4a $54 $55 -- the hole
;          knocked through it (the back exit, block $1f), kept the wall's
;          colour so it does not change at a tile edge; $24 $34 -- the window.
;   RED    $01 -- the hatched floor (Crystal's pink), and everything that sits
;          on it: $28 $37 the litter, $22 the dropped box, $02 $03 $12 $13 the
;          stools, $1c $1d $44 $45 the knocked-over stools, $1a $1b $18 $19 the
;          pot and $2c $25 $35 $38 the toppled pot (terracotta); $04 $14 the
;          exit mat, red as in Crystal's houses.
;   BROWN  $26 $29 $30 $31 $1e $1f -- the two bookshelves; $26 $27 $29 $36
;          $2f $39 $50-$53 $3a $3b -- the table (and what was smashed on it).
;   GREEN  $0a $0b $08 $09 -- the potted plant; $2a $2b $0c $0d -- the spilled
;          plant beside the toppled pot.
;
; kanto_house.png is 128x48 = 96 tile slots, so the twelve rows below cover
; $00-$5f exactly.  Both VRAM banks get identical rows.  Roles read off
; the blockset written by scripts/kanto_house_blk.py; see docs/M3-CERULEAN.md
; "## CH1 findings".
	tilepal 0, WATER, RED, RED, RED, RED, GRAY, GRAY, GRAY
	tilepal 0, GREEN, GREEN, GREEN, GREEN, GREEN, GREEN, GRAY, GRAY
	tilepal 0, GRAY, GRAY, RED, RED, RED, GRAY, GRAY, GRAY
	tilepal 0, RED, RED, RED, RED, RED, RED, BROWN, BROWN
	tilepal 0, GRAY, GRAY, RED, WATER, WATER, RED, BROWN, BROWN
	tilepal 0, RED, BROWN, GREEN, GREEN, RED, GRAY, GRAY, BROWN
	tilepal 0, BROWN, BROWN, GRAY, GRAY, WATER, RED, BROWN, RED
	tilepal 0, RED, BROWN, BROWN, BROWN, GRAY, GRAY, GRAY, WATER
	tilepal 0, GRAY, GRAY, GRAY, GRAY, RED, RED, GRAY, GRAY
	tilepal 0, GRAY, GRAY, WATER, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, BROWN, BROWN, BROWN, BROWN, WATER, WATER, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY

rept 16
	db $ff
endr

	tilepal 1, WATER, RED, RED, RED, RED, GRAY, GRAY, GRAY
	tilepal 1, GREEN, GREEN, GREEN, GREEN, GREEN, GREEN, GRAY, GRAY
	tilepal 1, GRAY, GRAY, RED, RED, RED, GRAY, GRAY, GRAY
	tilepal 1, RED, RED, RED, RED, RED, RED, BROWN, BROWN
	tilepal 1, GRAY, GRAY, RED, WATER, WATER, RED, BROWN, BROWN
	tilepal 1, RED, BROWN, GREEN, GREEN, RED, GRAY, GRAY, BROWN
	tilepal 1, BROWN, BROWN, GRAY, GRAY, WATER, RED, BROWN, RED
	tilepal 1, RED, BROWN, BROWN, BROWN, GRAY, GRAY, GRAY, WATER
	tilepal 1, GRAY, GRAY, GRAY, GRAY, RED, RED, GRAY, GRAY
	tilepal 1, GRAY, GRAY, WATER, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, BROWN, BROWN, BROWN, BROWN, WATER, WATER, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
