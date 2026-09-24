; TILESET_KANTO_CAVE (CT1, docs/CT1-KANTO-CAVE.md): Yellow's CAVERN line art
; (Mt. Moon, Rock Tunnel, Victory Road, Diglett's Cave, Seafoam Islands),
; coloured the way Crystal colours its own caves (cave_palette_map.asm): the
; floor and the rock are both BROWN -- under the caves' PALETTE_NITE that
; gives a dark red-brown floor under lavender-lit rock, which is exactly the
; floor/wall contrast the operator found missing (Q3) -- and the water WATER.
;
;   WATER  $14 (the tile TilesetKantoCaveAnim rotates; Seafoam's currents).
;   BROWN  everything else, ladders ($08-$0b $18-$1b) and holes ($22 $2f)
;          included: a GRAY ladder shows a blue square on the brown floor.
;
; Rock Tunnel keeps PALETTE_DARK: without FLASH ReplaceTimeOfDayPals turns it
; black, with FLASH it lights to these NITE colours.

	tilepal 0, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 0, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 0, BROWN, BROWN, BROWN, BROWN, WATER, BROWN, BROWN, BROWN
	tilepal 0, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 0, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 0, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 0, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 0, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 0, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 0, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 0, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 0, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN

rept 16
	db $ff
endr

	tilepal 1, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 1, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 1, BROWN, BROWN, BROWN, BROWN, WATER, BROWN, BROWN, BROWN
	tilepal 1, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 1, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 1, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 1, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 1, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 1, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 1, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 1, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
	tilepal 1, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
