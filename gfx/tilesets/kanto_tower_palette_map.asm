; Yellow's CEMETERY tileset (ported wholesale by M5 8a: POKeMON TOWER's seven
; floors), coloured Crystal-style per the operator's 7g-b.4 ruling -- Yellow's
; line art, Crystal's palette conventions.  Yellow renders the whole tower in
; PAL_GRAYMON, and Crystal's own crypt-ish interiors (tower, mansion) are
; likewise mostly GRAY, so GRAY is the default here and only the handful of
; tiles that are plainly *wood* or *plant* are pulled out.  Roles read off the
; blockset (110 blocks, data/tilesets/kanto_tower_metatiles.bin):
;
;   GREEN  $27 $2f $37 $3f -- the fronds of the potted palm, blocks $45 $4b
;          $6c $6d.  Those four blocks are the only decoration the seven tower
;          floors actually place, so this is the one splash of colour a player
;          ever sees in here.
;   BROWN  the woodwork.  $3d $3e, the palm's pot (shared with the desk block
;          $2c, which is the same wooden tone); $07 $08 $17 $18, the stacked
;          cabinets of blocks $2d and $3b; $20 $21 $23 $30 $31 $33, the desk
;          and its drawers, block $2c; and $28 $29 $38 $39 $48 $49, the tall
;          double doors of block $43.
;   GRAY   everything else -- the diagonally hatched floor ($01), the black
;          walls and their lips ($09 $0a $19 $1a $11), the gravestones
;          ($05 $06 $15 $16), the staircases ($03 $04 $13 $14 $0b $0c $1b $1c),
;          the chequered and white-tiled floors ($10 $1f $22 $33), the window
;          and doorway frames ($2a-$2e $3a-$3c), the counter ($02 $12) and the
;          solid border tile $47 of block $00.
;
; Tiles $4a-$5f and $00 $24 $25 $26 $32 $34 $35 $36 $40-$46 are unreferenced by
; any block; they get GRAY so the rows stay readable.
;
; Both VRAM banks get identical rows, as Crystal's own tower_palette_map.asm does.
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, BROWN
	tilepal 0, BROWN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, BROWN
	tilepal 0, BROWN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, BROWN, BROWN, GRAY, BROWN, GRAY, GRAY, GRAY, GREEN
	tilepal 0, BROWN, BROWN, GRAY, GRAY, GRAY, GRAY, GRAY, GREEN
	tilepal 0, BROWN, BROWN, GRAY, BROWN, GRAY, GRAY, GRAY, GREEN
	tilepal 0, BROWN, BROWN, GRAY, GRAY, GRAY, BROWN, BROWN, GREEN
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, BROWN, BROWN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY

rept 16
	db $ff
endr

	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, BROWN
	tilepal 1, BROWN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, BROWN
	tilepal 1, BROWN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, BROWN, BROWN, GRAY, BROWN, GRAY, GRAY, GRAY, GREEN
	tilepal 1, BROWN, BROWN, GRAY, GRAY, GRAY, GRAY, GRAY, GREEN
	tilepal 1, BROWN, BROWN, GRAY, BROWN, GRAY, GRAY, GRAY, GREEN
	tilepal 1, BROWN, BROWN, GRAY, GRAY, GRAY, BROWN, BROWN, GREEN
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, BROWN, BROWN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
