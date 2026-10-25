; Yellow's FACILITY tileset (ported wholesale by M6 9o: ROCKET HIDEOUT B1F-B4F,
; and later SILPH CO, POKeMON MANSION, the POWER PLANT, CINNABAR GYM and
; SAFFRON GYM), coloured Crystal-style per the operator's 7g-b.4 ruling --
; Yellow's line art, Crystal's palette conventions.  Yellow renders the whole
; hideout in one palette, its town's (PAL_CELADON via wLastMap, SetPal_Overworld
; .normalDungeonOrBuilding; HC1 checked it in the harness), and Crystal's own steel interiors (its FACILITY, the
; Radio Tower, the Team Rocket base) are likewise mostly GRAY, so GRAY is the
; default here and only the tiles that are plainly *plant* or *screen* are
; pulled out.  Roles read off the blockset (128 blocks,
; data/tilesets/kanto_facility_metatiles.bin):
;
;   ROOF   $01 -- the checker floor (CA1, 2026-10-05).  It used to be GRAY,
;          which left all 21 FACILITY maps reading as uncoloured; Crystal's
;          own FACILITY maps (Silph 1F, the Rocket base, the Power Plant)
;          all lay a pale-blue checker, so the floor now does too.  $01 is
;          the only tile in the set that carries the checker (no wall, desk
;          or arrow tile shares its pixels), so there is no tile-edge seam.
;          ROOF rather than WATER on purpose: indoors the two are nearly the
;          same light blue (17,19,31 vs 15,16,31), but the MANSION and the
;          POWER PLANT are DUNGEON maps on the PALETTE_DAY outdoor set, where
;          WATER is the saturated sea blue (8,12,31) and ROOF is a pale cyan
;          -- the closest that set gets to Crystal's facility floor.  Both
;          keep colour 0 equal to GRAY's, so the white squares do not move.
;   GREEN  $05 $06 $15 $16 -- the fronds of the potted palm, block $0b (and
;          its neighbours $09 $0c-$0f).  The palm is the only greenery in the
;          hideout and the one splash of colour a player sees down there.
;   BROWN  $07 $0f $17 $1f -- that palm's pot, the bottom half of block $0b.
;   WATER  $09 $0a $19 $1a -- the lit computer screen, a 2x2 that the hideout
;          places in blocks $1d $26 $35 and friends.  Crystal tints its own
;          machine banks (lab, Radio Tower) blue the same way, and it makes the
;          Rocket terminals read as equipment rather than as more wall.
;   RED    $20 $21 $30 $31 -- the spinner-arrow pads (HC1, 2026-10-24).  The
;          operator found the hideout's spin pads, stop pads and tables
;          "grayscale"; Yellow on a GBC paints the whole hideout one
;          palette, so there is nothing per-object to copy, and Crystal's
;          Team Rocket base marks its trap floor with RED hazard stripes.
;          The same four tiles draw the diamond warp pads of SILPH CO 2F-10F
;          and SAFFRON GYM, so those pads turn red too (Crystal's own warp
;          pads are GRAY; splitting them needs duplicate tiles -- by-feel
;          question Q-HC1b in docs/M6-CELADON.md).
;   YELLOW $5e -- the stop / landing pad (HC1).  Only HIDEOUT B2F/B3F use
;          it.  Yellow so it reads apart from the red arrows.
;   BROWN  $02 $35 $0d $0e $1d $1e (HC1) -- table interior ($02 $35) and the
;          table / counter top edges.  Crystal's desks and Rocket-base
;          tables are brown.  $0d $0e $1d $1e also cap the wall cabinets and
;          machines (faces $4a-$4d stay GRAY), so those get a brown work-top
;          over a steel front -- in SILPH, the MANSION and the POWER PLANT too.
;   GRAY   everything else -- the solid dark fill ($11), the panelled and
;          riveted walls ($2a $2b $2c $3a $32 $52; Q-CA1d keeps them grey),
;          the doorways ($43 $58), the lift doors, the stairs, the counter
;          tile ($12), the table legs ($44 $45), the machine faces, the exit
;          mat $42 $52 (it doubles as the MANSION 1F carpet runner, so RED
;          would tint that carpet) and the white shrub clumps ($22 $26 $36
;          $52-$54) that only SILPH CO and the MANSION use.

; (M8 11b correction: Yellow's FACILITY header is TILEANIM_WATER, but Gen 1's
; TILEANIM_WATER rotates tile $14 -- the planter water -- and NOT the arrows.
; The arrows are swapped in by LoadSpinnerArrowTiles only while the player is
; spinning.  TilesetKantoFacilityAnim in data/tileset_anims.asm now does the
; real thing; HC1 then gives the arrow tiles their RED.)
;
; facility.png is 128x48 = 96 tiles, so the twelve rows below cover $00-$5f
; exactly, with no padding.
;
; Both VRAM banks get identical rows, as Crystal's own facility_palette_map.asm
; does.
	tilepal 0, GRAY, ROOF, BROWN, GRAY, GRAY, GREEN, GREEN, BROWN
	tilepal 0, GRAY, WATER, WATER, GRAY, GRAY, BROWN, BROWN, BROWN
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GREEN, GREEN, BROWN
	tilepal 0, GRAY, WATER, WATER, GRAY, GRAY, BROWN, BROWN, BROWN
	tilepal 0, RED, RED, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, RED, RED, GRAY, GRAY, GRAY, BROWN, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, YELLOW, GRAY

rept 16
	db $ff
endr

	tilepal 1, GRAY, ROOF, BROWN, GRAY, GRAY, GREEN, GREEN, BROWN
	tilepal 1, GRAY, WATER, WATER, GRAY, GRAY, BROWN, BROWN, BROWN
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GREEN, GREEN, BROWN
	tilepal 1, GRAY, WATER, WATER, GRAY, GRAY, BROWN, BROWN, BROWN
	tilepal 1, RED, RED, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, RED, RED, GRAY, GRAY, GRAY, BROWN, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, YELLOW, GRAY
