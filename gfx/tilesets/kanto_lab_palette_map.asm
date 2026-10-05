; Yellow's LAB tileset (ported wholesale by M9 12i for CINNABAR LAB, its three
; side rooms and MEW1's POKeMON MANSION SEALED LAB), coloured Crystal-style per
; the operator's 7g-b.4 ruling -- Yellow's line art, Crystal's palette
; conventions.
;
; LC1 (operator, 2026-10-05: "we need to colorize that room. Still
; grayscale."): 12i's all-GRAY default is replaced by Crystal's own colouring
; of this very tileset.  Crystal's FACILITY tileset (gfx/tilesets/facility.png,
; the RUINS OF ALPH RESEARCH CENTER and the Rocket base) is GSC's redraw of
; Gen 1's LAB: same tile slots, same 2x2 metatiles in the same order (machine
; banks $02/$12/$13/$16, bookshelf $06, PC desk $08, ferns $09/$0a/$0d/$0e,
; exit mat $0c, desk $0f, chairs+table $10/$11/$14/$15, wall $01/$19).  So
; every tile below takes the palette facility_palette_map.asm gives the tile
; that sits in the same slot of the same block, unless the art differs:
;
;   WATER  $01 -- the checkerboard floor: Crystal's facility floor is the
;          light-blue check of the RESEARCH CENTER.  ($00/$26, the plain
;          white half of the checker, stay GRAY; WATER's lightest shade is the
;          same cream, so the floor is seamless.)
;          $02 $03 $12 $13 -- the PC screen + key row (blocks $08/$28).
;          Crystal browns its facility PC whole; kept WATER as 12i had it,
;          the same call as TilesetKantoInteriorPalMap's console.
;          $38 $39 -- the specimen cylinders (glassware, MEW1's tube racks).
;   GREEN  $22 $23 -- the striped wall: facility $22 is GREEN, the RESEARCH
;          CENTER's green back wall.  ($22 is also the front face of the
;          long counters in the SEALED LAB, so those read green-fronted.)
;          $2c $2d $3c $3d -- fern leaves; $32 $33 $43 $44 -- the hedge.
;   BROWN  $28 $29 $40 $42 -- the bookshelf and its cap ($40/$42 also cap
;          the tape machines, as in facility block $02).
;          $06-$09 $16 $17 -- the PC desk and its stool; $0e $0f $1e $1f the
;          meeting-room chairs.  $40-$42 $50-$54 $3a $4e $1c $1d $24 $25
;          $2a $2b $57-$59 -- every table/desk/counter surface and edge,
;          including block $0f and its paper ($48 $49), which facility draws
;          as a desk with a document on it.
;          $46 $56 $4b $5b $3b -- the narrow racks between the machine banks
;          (facility colours exactly these slots BROWN).
;          $2e $2f $3e $3f -- the fern pots.  $34 $35 $4c $4d -- the doors.
;   RED    $27 $37 -- the exit mat: the red mat every Crystal interior has.
;          $0c $0d -- the striped cable run in front of the machines (block
;          $0b, TESTING ROOM): facility colours that block RED.
;   YELLOW $30 $31 -- the amber pipe ("An amber pipe!").
;   GRAY   the machine faces and housings ($0a $0b $1a $1b $45 $55 $4a $5a,
;          the CRT $04 $05 $14 $15, $47), DR. FUJI's photo ($10 $11 $20
;          $21), the door plaques ($18 $19), the black border ($36) and the
;          plain floor -- as facility leaves its machines GRAY.
;
; Yellow's LAB header is `tileset Lab, -1, -1, -1, -1, TILEANIM_NONE`, so
; TilesetKantoLabAnim is the shared no-op alias in data/tileset_anims.asm.
;
; lab.png is 128x48 = 96 tiles, so the twelve rows below cover $00-$5f exactly,
; with no padding.  ($4f and $5c-$5f are unused by the blockset.)
;
; Both VRAM banks get identical rows, as Crystal's own palette maps do.
	tilepal 0, GRAY, WATER, WATER, WATER, GRAY, GRAY, BROWN, BROWN
	tilepal 0, BROWN, BROWN, GRAY, GRAY, RED, RED, BROWN, BROWN
	tilepal 0, GRAY, GRAY, WATER, WATER, GRAY, GRAY, BROWN, BROWN
	tilepal 0, GRAY, GRAY, GRAY, GRAY, BROWN, BROWN, BROWN, BROWN
	tilepal 0, GRAY, GRAY, GREEN, GREEN, BROWN, BROWN, GRAY, RED
	tilepal 0, BROWN, BROWN, BROWN, BROWN, GREEN, GREEN, BROWN, BROWN
	tilepal 0, YELLOW, YELLOW, GREEN, GREEN, BROWN, BROWN, GRAY, RED
	tilepal 0, WATER, WATER, BROWN, BROWN, GREEN, GREEN, BROWN, BROWN
	tilepal 0, BROWN, BROWN, BROWN, GREEN, GREEN, GRAY, BROWN, GRAY
	tilepal 0, BROWN, BROWN, GRAY, BROWN, BROWN, BROWN, BROWN, GRAY
	tilepal 0, BROWN, BROWN, BROWN, BROWN, BROWN, GRAY, BROWN, BROWN
	tilepal 0, BROWN, BROWN, GRAY, BROWN, GRAY, GRAY, GRAY, GRAY

rept 16
	db $ff
endr

	tilepal 1, GRAY, WATER, WATER, WATER, GRAY, GRAY, BROWN, BROWN
	tilepal 1, BROWN, BROWN, GRAY, GRAY, RED, RED, BROWN, BROWN
	tilepal 1, GRAY, GRAY, WATER, WATER, GRAY, GRAY, BROWN, BROWN
	tilepal 1, GRAY, GRAY, GRAY, GRAY, BROWN, BROWN, BROWN, BROWN
	tilepal 1, GRAY, GRAY, GREEN, GREEN, BROWN, BROWN, GRAY, RED
	tilepal 1, BROWN, BROWN, BROWN, BROWN, GREEN, GREEN, BROWN, BROWN
	tilepal 1, YELLOW, YELLOW, GREEN, GREEN, BROWN, BROWN, GRAY, RED
	tilepal 1, WATER, WATER, BROWN, BROWN, GREEN, GREEN, BROWN, BROWN
	tilepal 1, BROWN, BROWN, BROWN, GREEN, GREEN, GRAY, BROWN, GRAY
	tilepal 1, BROWN, BROWN, GRAY, BROWN, BROWN, BROWN, BROWN, GRAY
	tilepal 1, BROWN, BROWN, BROWN, BROWN, BROWN, GRAY, BROWN, BROWN
	tilepal 1, BROWN, BROWN, GRAY, BROWN, GRAY, GRAY, GRAY, GRAY
