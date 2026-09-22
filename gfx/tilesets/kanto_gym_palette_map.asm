; Yellow's GYM tileset (= DOJO; ported wholesale by M10 13a, D114, for VIRIDIAN
; GYM and later the E4 rooms, CHAMPION and HALL OF FAME), coloured Crystal-style
; per the operator's 7g-b.4 ruling -- Yellow's line art, Crystal's palette
; conventions.  GRAY is the default, as for INTERIOR/FACILITY/LAB (Crystal's
; own gyms are mostly grey); only tiles with a real-world colour are pulled out.
; Roles read off the blockset (116 blocks, data/tilesets/kanto_gym_metatiles.bin):
;
;   RED    $06 $16 -- the exit mat (block $04), the south door of every Yellow
;          GYM-tileset map.  Crystal paints its door mats RED.
;          $3c $3d $4c $4d -- the spinner arrows (Yellow's GymSpinnerArrows) on
;          VIRIDIAN GYM's twelve trigger tiles.  Coloured so the maze reads on
;          a Game Boy Color the way Crystal marks its own floor hazards, and so
;          the room is not a grey placeholder (the S1 lesson).
;   WATER  $04 $14 -- the pool water and its edge (blocks $02, $15-$23; the
;          Cerulean-style pool).  $14 is the tile Yellow's TILEANIM_WATER
;          rotates, and TilesetKantoGymAnim does too.
;   GREEN  $03 -- the flower tile of block $33 (TILEANIM_WATER_FLOWER's other
;          half; not animated here, and no shipped map uses it).
;          $07 $08 $17 $18 -- the round shrubs (blocks $06-$13).
;          $2c-$2f -- the tree/planter tops of blocks $34-$3f.
;          $40 $41 $50 $51 -- the potted plants (blocks $3c/$3d/$3f).
;   GRAY   everything else: the plank floor ($10 $11), the black partition
;          walls ($0f $24-$27 $35 $3e $42), the RHYDON statues on their plinths
;          ($02 $12 $13 $22 $23 $32 $33 $38), the landing markers ($3f), the
;          E4/HoF furniture ($45-$4b $52-$5f) -- 13f-13j colour those rooms.

	tilepal 0, GRAY, GRAY, GRAY, GREEN, WATER, GRAY, RED, GREEN
	tilepal 0, GREEN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, WATER, GRAY, RED, GREEN
	tilepal 0, GREEN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GREEN, GREEN, GREEN, GREEN
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, RED, RED, GRAY, GRAY
	tilepal 0, GREEN, GREEN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, RED, RED, GRAY, GRAY
	tilepal 0, GREEN, GREEN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY

rept 16
	db $ff
endr

	tilepal 1, GRAY, GRAY, GRAY, GREEN, WATER, GRAY, RED, GREEN
	tilepal 1, GREEN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, WATER, GRAY, RED, GREEN
	tilepal 1, GREEN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GREEN, GREEN, GREEN, GREEN
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, RED, RED, GRAY, GRAY
	tilepal 1, GREEN, GREEN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, RED, RED, GRAY, GRAY
	tilepal 1, GREEN, GREEN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
