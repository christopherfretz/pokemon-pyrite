; Yellow's FACILITY tileset (ported wholesale by M6 9o: ROCKET HIDEOUT B1F-B4F,
; and later SILPH CO, POKeMON MANSION, the POWER PLANT, CINNABAR GYM and
; SAFFRON GYM), coloured Crystal-style per the operator's 7g-b.4 ruling --
; Yellow's line art, Crystal's palette conventions.  Yellow renders the whole
; hideout in PAL_GRAYMON, and Crystal's own steel interiors (its FACILITY, the
; Radio Tower, the Team Rocket base) are likewise mostly GRAY, so GRAY is the
; default here and only the tiles that are plainly *plant* or *screen* are
; pulled out.  Roles read off the blockset (128 blocks,
; data/tilesets/kanto_facility_metatiles.bin):
;
;   GREEN  $05 $06 $15 $16 -- the fronds of the potted palm, block $0b (and
;          its neighbours $09 $0c-$0f).  The palm is the only greenery in the
;          hideout and the one splash of colour a player sees down there.
;   BROWN  $07 $0f $17 $1f -- that palm's pot, the bottom half of block $0b.
;   WATER  $09 $0a $19 $1a -- the lit computer screen, a 2x2 that the hideout
;          places in blocks $1d $26 $35 and friends.  Crystal tints its own
;          machine banks (lab, Radio Tower) blue the same way, and it makes the
;          Rocket terminals read as equipment rather than as more wall.
;   GRAY   everything else -- the plain floor ($01 $11), the panelled and
;          riveted walls ($2a $2b $2c $3a $32 $52), the doorways ($43 $58),
;          the lift doors, the stairs, the counter tile ($12), the white
;          shrub clumps ($22 $26 $36 $52-$54) that only SILPH CO and the
;          MANSION use, and -- deliberately -- the four spinner-arrow tiles
;          $20 $21 $30 $31, which Yellow draws in plain mono.
;
; (M8 11b correction: Yellow's FACILITY header is TILEANIM_WATER, but Gen 1's
; TILEANIM_WATER rotates tile $14 -- the planter water -- and NOT the arrows.
; The arrows are swapped in by LoadSpinnerArrowTiles only while the player is
; spinning.  TilesetKantoFacilityAnim in data/tileset_anims.asm now does the
; real thing, so the arrows staying mono here is right twice over.)
;
; facility.png is 128x48 = 96 tiles, so the twelve rows below cover $00-$5f
; exactly, with no padding.
;
; Both VRAM banks get identical rows, as Crystal's own facility_palette_map.asm
; does.
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GREEN, GREEN, BROWN
	tilepal 0, GRAY, WATER, WATER, GRAY, GRAY, GRAY, GRAY, BROWN
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GREEN, GREEN, BROWN
	tilepal 0, GRAY, WATER, WATER, GRAY, GRAY, GRAY, GRAY, BROWN
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY

rept 16
	db $ff
endr

	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GREEN, GREEN, BROWN
	tilepal 1, GRAY, WATER, WATER, GRAY, GRAY, GRAY, GRAY, BROWN
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GREEN, GREEN, BROWN
	tilepal 1, GRAY, WATER, WATER, GRAY, GRAY, GRAY, GRAY, BROWN
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
