; Yellow's BEACH_HOUSE tileset (ported wholesale by M12a for the SUMMER BEACH
; HOUSE on ROUTE 19; in Yellow it draws nothing else), coloured Crystal-style
; per the operator's 7g-b.4 ruling -- Yellow's line art, Crystal's palette
; conventions, the same call as TilesetKantoLabPalMap.  GRAY is the default and
; only tiles with a real-world colour are pulled out.  Roles read off the
; blockset (20 blocks, data/tilesets/kanto_beach_house_metatiles.bin):
;
;   BROWN  $02 $03 $12 $13 -- the square stools (blocks $01/$02/$0e).
;          $26-$2c $36-$3c -- the two snack-bar tables of blocks $01/$02.
;          Wooden furniture, as Crystal paints its own tables and chairs.
;   WATER  $06 $07 $16 $17 $24 $25 $34 $35 -- the three framed wave posters
;          on the north wall (blocks $06/$09 and $08): "30 years of waves!",
;          "SUMMER BEACH HOUSE", "The sea unites".  Sea pictures.
;          $04 $14 -- the exit mat (block $0b), blue as Yellow's CGB draws it.
;   GREEN  $08 $09 $18 $19 $44-$47 -- the two potted palms of block $0c.
;   GRAY   everything else: the walls ($00), the striped and the dotted floor
;          ($01 $11), the black border ($10), and the PRINTER machine of block
;          $10 ($20 $21 $32 $33 $40-$43), exactly as Yellow draws them.
;
; Yellow's header is `tileset BeachHouse, -1, -1, -1, -1, TILEANIM_NONE`, so
; TilesetKantoBeachHouseAnim is the shared no-op alias in
; data/tileset_anims.asm.  beach_house.png is 128x48 = 96 tile slots, so the
; twelve rows below cover $00-$5f exactly.  Both VRAM banks get identical rows.
	tilepal 0, GRAY, GRAY, BROWN, BROWN, WATER, GRAY, WATER, WATER
	tilepal 0, GREEN, GREEN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, BROWN, BROWN, WATER, GRAY, WATER, WATER
	tilepal 0, GREEN, GREEN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, WATER, WATER, BROWN, BROWN
	tilepal 0, BROWN, BROWN, BROWN, BROWN, BROWN, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, WATER, WATER, BROWN, BROWN
	tilepal 0, BROWN, BROWN, BROWN, BROWN, BROWN, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GREEN, GREEN, GREEN, GREEN
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY

rept 16
	db $ff
endr

	tilepal 1, GRAY, GRAY, BROWN, BROWN, WATER, GRAY, WATER, WATER
	tilepal 1, GREEN, GREEN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, BROWN, BROWN, WATER, GRAY, WATER, WATER
	tilepal 1, GREEN, GREEN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, WATER, WATER, BROWN, BROWN
	tilepal 1, BROWN, BROWN, BROWN, BROWN, BROWN, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, WATER, WATER, BROWN, BROWN
	tilepal 1, BROWN, BROWN, BROWN, BROWN, BROWN, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GREEN, GREEN, GREEN, GREEN
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
