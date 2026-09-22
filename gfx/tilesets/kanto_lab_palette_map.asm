; Yellow's LAB tileset (ported wholesale by M9 12i for CINNABAR LAB and its
; three side rooms; in Yellow it draws nothing else), coloured Crystal-style
; per the operator's 7g-b.4 ruling -- Yellow's line art, Crystal's palette
; conventions.  Same call as TilesetKantoInteriorPalMap and
; TilesetKantoFacilityPalMap: Yellow renders the whole lab in PAL_GRAYMON,
; Crystal's own research interiors are mostly GRAY, so GRAY is the default and
; only the tiles with a real-world colour are pulled out.  Roles read off the
; blockset (58 blocks, data/tilesets/kanto_lab_metatiles.bin; every tile below
; was checked for reuse, and none of these groups is shared with anything
; else):
;
;   WATER  $02 $03 $12 $13 -- the face of the computer console in block $08:
;          the lit screen and the key rows under it.  That block is the R&D
;          room's PC, whose two bg_events Yellow calls PC_KEYBOARD and
;          PC_MONITOR (the e-mail about the three legendary birds).  Same call
;          TilesetKantoInteriorPalMap makes for INTERIOR's console, and
;          Crystal tints its own machine banks blue the same way.
;          $48 $49 -- the readout and round dial on the face of the big grey
;          machine in block $0f.  That is the fossil room's Resurrection
;          Machine, so its one lit panel reads as a screen rather than as more
;          grey casing.
;          $38 $39 -- the capped specimen cylinders of block $1f.  Glassware,
;          and the only other thing in the set that is plainly not metal.
;   YELLOW $30 $31 -- the amber pipe (blocks $04 and $05).  The R&D room's
;          third bg_event is literally "An amber pipe!", and amber is the one
;          object in the lab Yellow names by its colour, so leaving it grey
;          would lose the joke.  This is the tileset's only YELLOW.
;   BROWN  $28 $29 -- the white-boxed cabinet in blocks $05/$06.  It is
;          Yellow's `bookshelf_tile LAB, $28` ("Crammed full of #MON books!"),
;          i.e. shelving, and Crystal paints its bookshelves BROWN.  (The
;          bookshelf *script* is not ported -- see scripts/kanto_lab_blk.py --
;          but the colour still reads correctly as furniture.)
;   GREEN  $2c-$2f $3c-$3f -- the potted ferns of blocks $09/$0a/$0d/$0e, the
;          planters along the hall's north wall and in the corners.
;          $32 $33 $43 $44 -- the low hedge of blocks $1d/$1e.  Both are
;          genuine foliage here, unlike INTERIOR's stippled machine shading.
;   GRAY   everything else: the checkerboard floor ($01 $26), the walls
;          ($22 $23), the black border ($36), the exit mat ($27 $37), the three
;          doors ($34 $35), DR. FUJI's framed photo ($10 $11 $20 $21), the
;          chairs and desks, the tape-reel machine banks and the body of the
;          Resurrection Machine -- exactly as Yellow draws them.
;
; Yellow's LAB header is `tileset Lab, -1, -1, -1, -1, TILEANIM_NONE`, so
; TilesetKantoLabAnim is the shared no-op alias in data/tileset_anims.asm --
; there is nothing to animate here, and no counter tile.
;
; lab.png is 128x48 = 96 tiles, so the twelve rows below cover $00-$5f exactly,
; with no padding.  ($4f and $5c-$5f are unused by the blockset.)
;
; Both VRAM banks get identical rows, as Crystal's own palette maps do.
	tilepal 0, GRAY, GRAY, WATER, WATER, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, WATER, WATER, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, BROWN, BROWN, GRAY, GRAY, GREEN, GREEN, GREEN, GREEN
	tilepal 0, YELLOW, YELLOW, GREEN, GREEN, GRAY, GRAY, GRAY, GRAY
	tilepal 0, WATER, WATER, GRAY, GRAY, GREEN, GREEN, GREEN, GREEN
	tilepal 0, GRAY, GRAY, GRAY, GREEN, GREEN, GRAY, GRAY, GRAY
	tilepal 0, WATER, WATER, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY

rept 16
	db $ff
endr

	tilepal 1, GRAY, GRAY, WATER, WATER, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, WATER, WATER, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, BROWN, BROWN, GRAY, GRAY, GREEN, GREEN, GREEN, GREEN
	tilepal 1, YELLOW, YELLOW, GREEN, GREEN, GRAY, GRAY, GRAY, GRAY
	tilepal 1, WATER, WATER, GRAY, GRAY, GREEN, GREEN, GREEN, GREEN
	tilepal 1, GRAY, GRAY, GRAY, GREEN, GREEN, GRAY, GRAY, GRAY
	tilepal 1, WATER, WATER, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
