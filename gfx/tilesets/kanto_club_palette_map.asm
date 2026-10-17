; Yellow's CLUB tileset (BS1: ported for CERULEAN's BIKE SHOP, whose 4x4 room
; is Yellow's verbatim), coloured Crystal-style per the 7g-b.4 ruling -- Yellow's
; line art, Crystal's palette conventions.  Standard indoor palettes (no
; LoadSpecialMapPalette case).  Only the 29 tiles the Bike Shop draws are
; pulled out; every other slot is GRAY (nothing else uses this tileset).
;
;   ROOF   $0f $1f -- the checkered floor (periwinkle on cream; Yellow's is a purple
;          checker; ROOF as for KANTO_FACILITY's floor in CA1), and the bikes
;          standing on it, $0b $0c $0e $1e $1b $1c $09, so the checker does not
;          change colour at a tile edge (BH3's floor rule).
;   WATER  $06 -- the striped back wall (Yellow's is blue too); $01-$03
;          $11-$13 -- the two bikes hung on it; $1d $0d $15 $16 -- the two
;          blue display stands by the door.
;   BROWN  $07 $08 $17 $18 $36 $10 $05 -- the clerk's L-shaped counter, wood
;          as Crystal draws its shop counters.
;   RED    $0a $1a -- the exit mat, red as in Crystal's houses.
;
; kanto_club.png is 128x40 = 80 tile slots ($00-$4f); the twelve rows below
; cover $00-$5f as every tileset palette map does, the tail GRAY.  Both VRAM
; banks get identical rows.  See docs/M3-CERULEAN.md "## BS1 findings".
	tilepal 0, GRAY, WATER, WATER, WATER, GRAY, BROWN, WATER, BROWN
	tilepal 0, BROWN, ROOF, RED, ROOF, ROOF, WATER, ROOF, ROOF
	tilepal 0, BROWN, WATER, WATER, WATER, GRAY, WATER, WATER, BROWN
	tilepal 0, BROWN, GRAY, RED, ROOF, ROOF, WATER, ROOF, ROOF
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, BROWN, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY

rept 16
	db $ff
endr

	tilepal 1, GRAY, WATER, WATER, WATER, GRAY, BROWN, WATER, BROWN
	tilepal 1, BROWN, ROOF, RED, ROOF, ROOF, WATER, ROOF, ROOF
	tilepal 1, BROWN, WATER, WATER, WATER, GRAY, WATER, WATER, BROWN
	tilepal 1, BROWN, GRAY, RED, ROOF, ROOF, WATER, ROOF, ROOF
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, BROWN, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
