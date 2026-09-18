; Yellow's SHIP_PORT tileset, ported wholesale by M4 step 7g-b
; (docs/M4-VERMILION.md).  Yellow is monochrome, so the palettes are chosen by
; tile role, read off the blockset (scripts/vermilion_blk.py, KANTO_DOCK):
;   WATER  $14 the sea, $3a the dark strip of water under the quay wall
;   BROWN  $01 $50 $56 $57  the crates in the map's four corners
;   RED    $3c $48-$4c $58 $59  the lorry; $40-$45 $4d-$4f $51-$53 $55
;          $5a $5b $5d  the S.S. ANNE's hull below the white superstructure,
;          so she reads white-over-red like Crystal's own FAST SHIP
;   GRAY   everything else: the pavement $0a, the quay $31 $32 $3b, the
;          gangway, the deck, and the solid-black border block tile $5c
	tilepal 0, GRAY, BROWN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, WATER, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, WATER, GRAY, RED, GRAY, GRAY, GRAY
	tilepal 0, RED, RED, RED, RED, RED, RED, GRAY, GRAY
	tilepal 0, RED, RED, RED, RED, RED, RED, RED, RED
	tilepal 0, BROWN, RED, RED, RED, GRAY, RED, BROWN, BROWN
	tilepal 0, RED, RED, RED, RED, GRAY, RED, GRAY, GRAY

rept 16
	db $ff
endr

	tilepal 1, GRAY, BROWN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, WATER, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, WATER, GRAY, RED, GRAY, GRAY, GRAY
	tilepal 1, RED, RED, RED, RED, RED, RED, GRAY, GRAY
	tilepal 1, RED, RED, RED, RED, RED, RED, RED, RED
	tilepal 1, BROWN, RED, RED, RED, GRAY, RED, BROWN, BROWN
	tilepal 1, RED, RED, RED, RED, GRAY, RED, GRAY, GRAY
