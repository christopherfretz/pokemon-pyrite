; Yellow's SHIP_PORT tileset (ported wholesale by M4 step 7g-b), coloured in
; step P1 the way Crystal colours its own VERMILION PORT and the FAST SHIP
; (compare gfx/tilesets/port_palette_map.asm): Yellow's line art, Crystal's
; palette conventions.  Yellow's art is monochrome, so every tile is assigned
; by role, read off the blockset (23 blocks, data/tilesets/kanto_dock_metatiles.bin):
;
;   WATER  $14 the sea, $3a the dark strip of water under the quay wall.
;          Same palette Crystal's port gives its sea.
;   GRAY   the concrete: pavement/road $0a $1a, the quay wall and its tyre
;          fenders $31, the gangway $32 $3b, the post in the unused block $14
;          ($08 $3f $47 $54), and the solid-black border tile $5c (every GSC
;          outdoor palette's colour 3 is RGB 07,07,07, so "black" is near-black
;          by engine design - see 7g-b.4).
;   BROWN  $01 $50 $56 $57, the crates in the map's four corners.
;   RED    $3c $48-$4c $58 $59, the lorry.
;   ROOF   the S.S. ANNE's superstructure and decks - $00 $02-$07 $09 $0b-$0f
;          $10-$13 $15-$19 $1c-$1f $20-$29 $2c-$2f $30 $33-$39 $3d $3e.  ROOF is
;          white/pale-cyan/blue, which is exactly what Crystal paints the FAST
;          SHIP's hull with, so she reads as a white liner with blue trim.
;   RED    the S.S. ANNE's hull below the deck line - $40-$45 $4d-$4f $51-$53
;          $55 $5a $5b $5d - giving Crystal's white-over-red ship.
;
; Both VRAM banks get identical rows, as Crystal's own port_palette_map.asm does.
	tilepal 0, ROOF, BROWN, ROOF, ROOF, ROOF, ROOF, ROOF, ROOF
	tilepal 0, GRAY, ROOF, GRAY, ROOF, ROOF, ROOF, ROOF, ROOF
	tilepal 0, ROOF, ROOF, ROOF, ROOF, WATER, ROOF, ROOF, ROOF
	tilepal 0, ROOF, ROOF, GRAY, GRAY, ROOF, ROOF, ROOF, ROOF
	tilepal 0, ROOF, ROOF, ROOF, ROOF, ROOF, ROOF, ROOF, ROOF
	tilepal 0, ROOF, ROOF, GRAY, GRAY, ROOF, ROOF, ROOF, ROOF
	tilepal 0, ROOF, GRAY, GRAY, ROOF, ROOF, ROOF, ROOF, ROOF
	tilepal 0, ROOF, ROOF, WATER, GRAY, RED, ROOF, ROOF, GRAY
	tilepal 0, RED, RED, RED, RED, RED, RED, GRAY, GRAY
	tilepal 0, RED, RED, RED, RED, RED, RED, RED, RED
	tilepal 0, BROWN, RED, RED, RED, GRAY, RED, BROWN, BROWN
	tilepal 0, RED, RED, RED, RED, GRAY, RED, GRAY, GRAY

rept 16
	db $ff
endr

	tilepal 1, ROOF, BROWN, ROOF, ROOF, ROOF, ROOF, ROOF, ROOF
	tilepal 1, GRAY, ROOF, GRAY, ROOF, ROOF, ROOF, ROOF, ROOF
	tilepal 1, ROOF, ROOF, ROOF, ROOF, WATER, ROOF, ROOF, ROOF
	tilepal 1, ROOF, ROOF, GRAY, GRAY, ROOF, ROOF, ROOF, ROOF
	tilepal 1, ROOF, ROOF, ROOF, ROOF, ROOF, ROOF, ROOF, ROOF
	tilepal 1, ROOF, ROOF, GRAY, GRAY, ROOF, ROOF, ROOF, ROOF
	tilepal 1, ROOF, GRAY, GRAY, ROOF, ROOF, ROOF, ROOF, ROOF
	tilepal 1, ROOF, ROOF, WATER, GRAY, RED, ROOF, ROOF, GRAY
	tilepal 1, RED, RED, RED, RED, RED, RED, GRAY, GRAY
	tilepal 1, RED, RED, RED, RED, RED, RED, RED, RED
	tilepal 1, BROWN, RED, RED, RED, GRAY, RED, BROWN, BROWN
	tilepal 1, RED, RED, RED, RED, GRAY, RED, GRAY, GRAY
