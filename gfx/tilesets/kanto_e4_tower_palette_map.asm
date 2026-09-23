; M10 13j2: AGATHA's room's copy of Yellow's CEMETERY palette map
; (TILESET_KANTO_E4_TOWER shares TILESET_KANTO_TOWER's gfx/meta/coll/anim, so
; POKeMON TOWER keeps kanto_tower_palette_map.asm untouched).  Slots are roles,
; coloured per room by LoadSpecialMapPalette from gfx/tilesets/kanto_e4.pal:
;
;   GRAY   WALL   -- everything not listed below (AGATHA's room shows none).
;   RED    POT    -- the palm's pot ($3d $3e).
;   GREEN  PALM   -- the palm's fronds ($27 $2f $37 $3f).
;   YELLOW DOOR   -- the top wall ($20 $30, block $47) and the sealed-exit
;                    cabinets ($07 $08 $17 $18, block $3b).
;   BROWN  FLOOR  -- the hatched floor ($01).
;   ROOF   STATUE -- the gravestones ($05 $06 $15 $16).
;   Also BROWN in POKeMON TOWER's map: the desk/door woodwork ($20-$23
;   $28 $29 $30-$33 $38 $39 $48 $49) no E4 block uses; they fall to WALL here
;   except $20/$30 above.

	tilepal 0, GRAY, BROWN, GRAY, GRAY, GRAY, ROOF, ROOF, YELLOW
	tilepal 0, YELLOW, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, ROOF, ROOF, YELLOW
	tilepal 0, YELLOW, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, YELLOW, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GREEN
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GREEN
	tilepal 0, YELLOW, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GREEN
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, RED, RED, GREEN
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY

rept 16
	db $ff
endr

	tilepal 1, GRAY, BROWN, GRAY, GRAY, GRAY, ROOF, ROOF, YELLOW
	tilepal 1, YELLOW, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, ROOF, ROOF, YELLOW
	tilepal 1, YELLOW, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, YELLOW, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GREEN
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GREEN
	tilepal 1, YELLOW, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GREEN
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, RED, RED, GREEN
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
