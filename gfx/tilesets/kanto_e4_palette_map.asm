; M10 13j2: the E4 rooms' copy of Yellow's GYM palette map (TILESET_KANTO_E4
; shares TILESET_KANTO_GYM's gfx/meta/coll/anim; only this map differs, so
; VIRIDIAN GYM keeps kanto_gym_palette_map.asm untouched).  Here each slot is a
; ROLE, and LoadSpecialMapPalette (engine/tilesets/tileset_palettes.asm) loads
; per-room colours for the roles from gfx/tilesets/kanto_e4.pal:
;
;   GRAY   WALL   -- walls, pillars, the void ($0f), the top wall face ($05)
;                    and its chequered band ($10); every unreferenced tile.
;   RED    MAT    -- the exit mat ($06 $16; HALL OF FAME's entrance).
;   GREEN  ROCK   -- BRUNO's boulders ($07 $08 $17 $18; Yellow draws them
;                    with the gym's shrub tiles); the unused plant tiles.
;   WATER  WATER  -- LORELEI's pool ($04 $14).
;   YELLOW DOOR   -- the double doors ($20 $21 $30 $31; the sealed exits and
;                    LANCE's inner gate) and LANCE's staircase ($48-$4b).
;   BROWN  FLOOR  -- the plank floor ($11) and the tiled platform ($09 $0a $19
;                    $1a; LORELEI's dais, HALL OF FAME's floor).
;   ROOF   STATUE -- the statues on their plinths ($02 $12 $13 $22 $23 $32 $33
;                    $38) and the HALL OF FAME machine ($36 $37 $55-$5f).
;   TEXT   (never named: the text engine's and the pikapic box's slot)

	tilepal 0, GRAY, GRAY, ROOF, GREEN, WATER, GRAY, RED, GREEN
	tilepal 0, GREEN, BROWN, BROWN, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, BROWN, ROOF, ROOF, WATER, GRAY, RED, GREEN
	tilepal 0, GREEN, BROWN, BROWN, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, YELLOW, YELLOW, ROOF, ROOF, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GREEN, GREEN, GREEN, GREEN
	tilepal 0, YELLOW, YELLOW, ROOF, ROOF, GRAY, GRAY, ROOF, ROOF
	tilepal 0, ROOF, GRAY, GRAY, GRAY, RED, RED, GRAY, GRAY
	tilepal 0, GREEN, GREEN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, YELLOW, YELLOW, YELLOW, YELLOW, RED, RED, GRAY, GRAY
	tilepal 0, GREEN, GREEN, GRAY, GRAY, GRAY, ROOF, ROOF, ROOF
	tilepal 0, ROOF, ROOF, ROOF, ROOF, ROOF, ROOF, ROOF, ROOF

rept 16
	db $ff
endr

	tilepal 1, GRAY, GRAY, ROOF, GREEN, WATER, GRAY, RED, GREEN
	tilepal 1, GREEN, BROWN, BROWN, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, BROWN, ROOF, ROOF, WATER, GRAY, RED, GREEN
	tilepal 1, GREEN, BROWN, BROWN, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, YELLOW, YELLOW, ROOF, ROOF, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GREEN, GREEN, GREEN, GREEN
	tilepal 1, YELLOW, YELLOW, ROOF, ROOF, GRAY, GRAY, ROOF, ROOF
	tilepal 1, ROOF, GRAY, GRAY, GRAY, RED, RED, GRAY, GRAY
	tilepal 1, GREEN, GREEN, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, YELLOW, YELLOW, YELLOW, YELLOW, RED, RED, GRAY, GRAY
	tilepal 1, GREEN, GREEN, GRAY, GRAY, GRAY, ROOF, ROOF, ROOF
	tilepal 1, ROOF, ROOF, ROOF, ROOF, ROOF, ROOF, ROOF, ROOF
