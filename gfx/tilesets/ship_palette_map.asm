; TILESET_SHIP (S.S. ANNE interior, ported from Yellow) -- Crystal-style colour
; pass (M4 S1).  Reference: Crystal's own S.S. AQUA interior, which runs on
; TILESET_LIGHTHOUSE (vendor/pokecrystal/data/maps/maps.asm: FastShip1F ...
; TILESET_LIGHTHOUSE); this tileset shares that tileset's metatile table, so
; gfx/tilesets/lighthouse_palette_map.asm is a tile-for-tile reference and is
; followed except where Yellow's art gives a tile a different meaning (the
; Bow's sea/railing/capstan, the Kitchen's burners, the bins, the gangway).
; Only bank 0 is ever consulted (the highest tile any metatile uses is $59);
; the bank 1 half mirrors it, as Crystal's own palette maps do.

; $00     GRAY   blank (unused by any metatile)
; $01     WATER  black void
; $02-$03 WATER  porthole
; $04     BROWN  plank floor / deck
; $05-$06 WATER  void corner
; $07-$08 RED    stool, upper
; $09-$0a ROOF   table top edge
; $0b     BROWN  table apron / base
; $0c     ROOF   table top-right corner
; $0d     RED    checker floor, light square
; $0e-$0f RED    cabin door, upper
; $10     ROOF   wall panel
; $11     WATER  ceiling band above wall
; $12-$13 ROOF   wall base moulding
; $14     WATER  sea (Bow)
; $15-$16 WATER  void edge
; $17-$18 RED    stool, lower
; $19     ROOF   table left edge
; $1a     ROOF   small plate on table
; $1b     GRAY   blank (unused by any metatile)
; $1c     ROOF   table right edge
; $1d     RED    checker floor, dark square
; $1e-$1f RED    cabin door, lower
; $20-$21 ROOF   wall panel corner
; $22     WATER  void corner
; $23     BROWN  deck dither / plank shadow
; $24     RED    cabin rug, upper
; $25-$26 WATER  void corner
; $27-$28 GRAY   stairs up, upper
; $29-$2a GRAY   stairs down, upper
; $2b     BROWN  cupboard side
; $2c     ROOF   table surface
; $2d     GRAY   capstan / bollard, upper (Bow)
; $2e-$2f ROOF   bulwark railing panel, upper (Bow)
; $30-$31 ROOF   wall base corner
; $32-$33 WATER  void / ceiling band
; $34     RED    cabin rug, lower
; $35     GRAY   stove burner grate (Kitchen)
; $36     BROWN  cupboard shelves
; $37-$38 GRAY   stairs up, lower
; $39-$3a GRAY   stairs down, lower
; $3b-$3c BROWN  table apron / bed footboard
; $3d     GRAY   capstan / bollard, lower (Bow)
; $3e-$3f ROOF   bulwark railing panel, lower (Bow)
; $40-$41 ROOF   platter on table, upper
; $42-$43 ROOF   wardrobe, lower
; $44-$45 BROWN  open book on the captain's desk
; $46-$47 BROWN  bed headboard
; $48-$49 RED    bin / stacked pans, upper
; $4a     BROWN  gangway ramp (1F)
; $4b-$4f GRAY   blank (unused by any metatile)
; $50-$51 ROOF   platter on table, lower
; $52-$53 GRAY   blank (unused by any metatile)
; $54-$55 ROOF   wardrobe, upper
; $56-$57 GRAY   bed mattress
; $58-$59 RED    bin / stacked pans, lower
; $5a-$5f GRAY   blank (unused by any metatile)

	tilepal 0, GRAY, WATER, WATER, WATER, BROWN, WATER, WATER, RED ; $00-$07
	tilepal 0, RED, ROOF, ROOF, BROWN, ROOF, RED, RED, RED ; $08-$0f
	tilepal 0, ROOF, WATER, ROOF, ROOF, WATER, WATER, WATER, RED ; $10-$17
	tilepal 0, RED, ROOF, ROOF, GRAY, ROOF, RED, RED, RED ; $18-$1f
	tilepal 0, ROOF, ROOF, WATER, BROWN, RED, WATER, WATER, GRAY ; $20-$27
	tilepal 0, GRAY, GRAY, GRAY, BROWN, ROOF, GRAY, ROOF, ROOF ; $28-$2f
	tilepal 0, ROOF, ROOF, WATER, WATER, RED, GRAY, BROWN, GRAY ; $30-$37
	tilepal 0, GRAY, GRAY, GRAY, BROWN, BROWN, GRAY, ROOF, ROOF ; $38-$3f
	tilepal 0, ROOF, ROOF, ROOF, ROOF, BROWN, BROWN, BROWN, BROWN ; $40-$47
	tilepal 0, RED, RED, BROWN, GRAY, GRAY, GRAY, GRAY, GRAY ; $48-$4f
	tilepal 0, ROOF, ROOF, GRAY, GRAY, ROOF, ROOF, GRAY, GRAY ; $50-$57
	tilepal 0, RED, RED, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY ; $58-$5f

rept 16
	db $ff
endr

	tilepal 1, GRAY, WATER, WATER, WATER, BROWN, WATER, WATER, RED ; $00-$07
	tilepal 1, RED, ROOF, ROOF, BROWN, ROOF, RED, RED, RED ; $08-$0f
	tilepal 1, ROOF, WATER, ROOF, ROOF, WATER, WATER, WATER, RED ; $10-$17
	tilepal 1, RED, ROOF, ROOF, GRAY, ROOF, RED, RED, RED ; $18-$1f
	tilepal 1, ROOF, ROOF, WATER, BROWN, RED, WATER, WATER, GRAY ; $20-$27
	tilepal 1, GRAY, GRAY, GRAY, BROWN, ROOF, GRAY, ROOF, ROOF ; $28-$2f
	tilepal 1, ROOF, ROOF, WATER, WATER, RED, GRAY, BROWN, GRAY ; $30-$37
	tilepal 1, GRAY, GRAY, GRAY, BROWN, BROWN, GRAY, ROOF, ROOF ; $38-$3f
	tilepal 1, ROOF, ROOF, ROOF, ROOF, BROWN, BROWN, BROWN, BROWN ; $40-$47
	tilepal 1, RED, RED, BROWN, GRAY, GRAY, GRAY, GRAY, GRAY ; $48-$4f
	tilepal 1, ROOF, ROOF, GRAY, GRAY, ROOF, ROOF, GRAY, GRAY ; $50-$57
	tilepal 1, RED, RED, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY ; $58-$5f
