; Yellow's GATE tileset (ported wholesale by M1: the museum and every Kanto
; gate), coloured the way Crystal colours its own gates -- compare
; gfx/tilesets/gate_palette_map.asm, which is the answer key here: Yellow's
; line art, Crystal's palette conventions (operator ruling, 7g-b.4).  Yellow's
; art is monochrome, so every tile is assigned by role, read off the blockset
; (128 blocks, data/tilesets/kanto_gate_metatiles.bin):
;
;   WATER  $20 $21, the window panes that run along every gate wall, and
;          $29 $2a $2b $3b, the sliding door in the north wall.  Crystal paints
;          both of those bright blue in its own gates, so we do too.
;   GREEN  the gate furniture Crystal paints green: $07 $08 the caps and
;          $17 $18 the bodies of the tall partitions/counters, $09 their long
;          desk tops -- and the potted palms, $05 $06 $15 $16 $25 $26.
;   BROWN  $35 $36 the palms' pots; $22 $23 the shelving units (the gate side
;          racks and the museum's back wall); and the museum's exhibits --
;          $46 $47 the 1F fossils, $2e the 2F moon stones, $4c $4d $5c $5d the
;          round specimen case, $4e $4f the two wall plaques.
;   ROOF   $27 $28, the tinted glass over the museum's display cases, and
;          $40-$45, the 2F space shuttle.  ROOF is white/pale-blue, which is
;          what Crystal paints the FAST SHIP's hull with and reads here as
;          glass and as a white orbiter.
;   RED    the entrance carpets Crystal always reds: $04 $14 the mat inside a
;          south doorway, $37 $38 the Saffron gates' north/south thresholds,
;          $5e the east/west ones.  Every one of those sits under a $7x warp
;          in data/tilesets/kanto_gate_collision.asm.
;   GRAY   everything else -- the checkered floor ($01 $11), the hatched upper
;          wall ($48 $4a), the wall panels under the windows ($32 $33, also
;          Yellow's second counter tile), the 2F gates' diagonal wall
;          ($2d $3a $3d $3e), the binocular stands ($24 $34 $39), the benches
;          ($02 $03 $12 $13), the stairs ($0a-$0d $1a-$1d), the display-case
;          frames and bases, and the solid border tile $10.
;
; Both VRAM banks get identical rows, as Crystal's own gate_palette_map.asm does.
	tilepal 0, GRAY, GRAY, GRAY, GRAY, RED, GREEN, GREEN, GREEN
	tilepal 0, GREEN, GREEN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, RED, GREEN, GREEN, GREEN
	tilepal 0, GREEN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, WATER, WATER, BROWN, BROWN, GRAY, GREEN, GREEN, ROOF
	tilepal 0, ROOF, WATER, WATER, WATER, GRAY, GRAY, BROWN, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, BROWN, BROWN, RED
	tilepal 0, RED, GRAY, GRAY, WATER, GRAY, GRAY, GRAY, GRAY
	tilepal 0, ROOF, ROOF, ROOF, ROOF, ROOF, ROOF, BROWN, BROWN
	tilepal 0, GRAY, GRAY, GRAY, GRAY, BROWN, BROWN, BROWN, BROWN
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, BROWN, BROWN, RED, GRAY

rept 16
	db $ff
endr

	tilepal 1, GRAY, GRAY, GRAY, GRAY, RED, GREEN, GREEN, GREEN
	tilepal 1, GREEN, GREEN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, RED, GREEN, GREEN, GREEN
	tilepal 1, GREEN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, WATER, WATER, BROWN, BROWN, GRAY, GREEN, GREEN, ROOF
	tilepal 1, ROOF, WATER, WATER, WATER, GRAY, GRAY, BROWN, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, BROWN, BROWN, RED
	tilepal 1, RED, GRAY, GRAY, WATER, GRAY, GRAY, GRAY, GRAY
	tilepal 1, ROOF, ROOF, ROOF, ROOF, ROOF, ROOF, BROWN, BROWN
	tilepal 1, GRAY, GRAY, GRAY, GRAY, BROWN, BROWN, BROWN, BROWN
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, BROWN, BROWN, RED, GRAY
