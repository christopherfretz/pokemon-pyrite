; TILESET_KANTO_PLATEAU (M10 13e-1): Yellow's PLATEAU line art (ROUTE 23 and,
; from 13e-2, INDIGO PLATEAU), coloured Crystal-style after Crystal's own Kanto
; overworld (kanto_palette_map.asm), where cliffs and rock are BROWN, plants
; GREEN, water WATER, roofs ROOF and open ground GRAY.  Roles read off the
; blockset (73 blocks + 2 clones, data/tilesets/kanto_plateau_metatiles.bin):
;
;   BROWN  the striped cliff terraces and their pillars ($03 $05 $06 $0d-$10
;          $12 $15 $16 $25 $26 $28-$31 $20 $21), the boulders in the grass
;          ($1d $22 $2a $2b, block $02/$13/$16), the sign ($09 $0a $19 $1a)
;          and the Victory Road / lobby doorway ($0b $0c $1b $1c).
;   GREEN  $45 the tall grass; $07 $08 $17 $18 the round shrubs on the pillar
;          tops (blocks $44/$45).
;   WATER  $14 (the tile TilesetKantoPlateauAnim rotates), $32 the shore
;          strip, $33 and $1f the water-edge tiles of blocks $12/$14/$38.
;   ROOF   $3d $3e $40 $41 $44 the VICTORY ROAD GATE roof along ROUTE 23's
;          south edge (blocks $3a-$3f).
;   GRAY   the ground ($00 $23 $2c $2d, day GRAY is near-white) and the unused
;          rest.

	tilepal 0, GRAY, GRAY, GRAY, BROWN, GRAY, BROWN, BROWN, GREEN
	tilepal 0, GREEN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 0, BROWN, GRAY, BROWN, GRAY, WATER, BROWN, BROWN, GREEN
	tilepal 0, GREEN, BROWN, BROWN, BROWN, BROWN, BROWN, GRAY, WATER
	tilepal 0, BROWN, BROWN, BROWN, GRAY, GRAY, BROWN, BROWN, GRAY
	tilepal 0, BROWN, BROWN, BROWN, BROWN, GRAY, GRAY, BROWN, BROWN
	tilepal 0, BROWN, BROWN, WATER, WATER, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, ROOF, ROOF, GRAY
	tilepal 0, ROOF, ROOF, GRAY, GRAY, ROOF, GREEN, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY

rept 16
	db $ff
endr

	tilepal 1, GRAY, GRAY, GRAY, BROWN, GRAY, BROWN, BROWN, GREEN
	tilepal 1, GREEN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 1, BROWN, GRAY, BROWN, GRAY, WATER, BROWN, BROWN, GREEN
	tilepal 1, GREEN, BROWN, BROWN, BROWN, BROWN, BROWN, GRAY, WATER
	tilepal 1, BROWN, BROWN, BROWN, GRAY, GRAY, BROWN, BROWN, GRAY
	tilepal 1, BROWN, BROWN, BROWN, BROWN, GRAY, GRAY, BROWN, BROWN
	tilepal 1, BROWN, BROWN, WATER, WATER, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, ROOF, ROOF, GRAY
	tilepal 1, ROOF, ROOF, GRAY, GRAY, ROOF, GREEN, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
