; Yellow's INTERIOR tileset (ported wholesale by M8 11b for SILPH CO. 11F; in
; Yellow it also draws BILL's house and the POKeMON FAN CLUB), coloured
; Crystal-style per the operator's 7g-b.4 ruling -- Yellow's line art,
; Crystal's palette conventions.  Same call as TilesetKantoFacilityPalMap
; next door: Yellow renders the whole room in PAL_GRAYMON, Crystal's own
; important-room interiors are mostly GRAY, so GRAY is the default and only
; the tiles that are plainly *screen* are pulled out.  Roles read off the
; blockset (58 blocks, data/tilesets/kanto_interior_metatiles.bin):
;
;   WATER  $0b $0c $1b $1c -- the face of the computer console: the lit screen
;          and the button row under it.  It is blocks $01 (the console on its
;          own) and $38 (the console built into a bench, which is what SILPH
;          CO. 11F puts in the south-east corner of the president's office).
;          Crystal tints its own machine banks -- the lab, the Radio Tower --
;          blue the same way, and TilesetKantoFacilityPalMap already does it
;          for the Rocket terminals, so the two Silph tilesets agree.
;   GRAY   everything else.  There is no greenery in INTERIOR at all: the
;          leafy-looking 2x3 at $01/$02/$11/$12/$21/$22 is not a plant but the
;          stippled shading of BILL's teleporter ($08/$0b) and of the
;          president's desk ($10/$11), so colouring it would tint furniture.
;          The carpet ($1f), the black walls ($2f $57-$5c), the doorways
;          ($04 $15), the framed picture ($13 $14 $23 $24), the desk, the
;          shelving and the teleport pad's chevrons ($53-$56) all stay mono,
;          exactly as Yellow draws them.
;
; Yellow's INTERIOR header is TILEANIM_NONE, so TilesetKantoInteriorAnim is
; the shared no-op alias in data/tileset_anims.asm -- there is nothing to
; animate here.
;
; interior.png is 128x48 = 96 tiles, so the twelve rows below cover $00-$5f
; exactly, with no padding.
;
; Both VRAM banks get identical rows, as Crystal's own palette maps do.
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, WATER, WATER, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, WATER, WATER, GRAY, GRAY, GRAY
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

	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, WATER, WATER, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, WATER, WATER, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
