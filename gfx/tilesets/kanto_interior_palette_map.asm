; Yellow's INTERIOR tileset (ported wholesale by M8 11b for SILPH CO. 11F, and
; by BH1 for BILL's house; in Yellow it also draws the POKeMON FAN CLUB),
; coloured Crystal-style per the operator's 7g-b.4 ruling -- Yellow's line
; art, Crystal's palette conventions.
;
; CA1/BH3 (2026-10-05): this map used to be all GRAY except the PC screen, on
; the theory that Crystal's important rooms are mostly grey.  The operator
; read BILL's house as uncoloured ("The machine in Bill's house needs coloring
; then too"), so it now follows Crystal's own drawing of the same room.
; Crystal puts BillsHouse (and the Fan Club) on TILESET_HOUSE, and that is
; the reference wherever a tile has a counterpart; the room-wide tiles take
; HOUSE's colours and every object without a counterpart borrows the palette
; Crystal gives its nearest equivalent.  Roles read off the blockset
; (58 blocks, data/tilesets/kanto_interior_metatiles.bin):
;
;   RED    $1f        -- the floor hatch.  Crystal's house floors are the pink
;                        hatch on cream (house.pal RED = indoor RED), so this
;                        is a straight copy.  The hatch is colour 1, so every
;                        tile that sits on the floor and shows hatch has to be
;                        RED (or the hatch changes colour at the tile edge):
;          $3b-$3e    -- the chair (no clean Crystal twin; pink keeps the seam
;                        rule and reads as a cushion).
;          $31-$33 $41-$43 -- SILPH 11F's sofa, same reason.
;          $53-$56    -- SILPH 11F's teleport pad: a red chevron on the pink
;                        carpet (its frame is floor, so the seam rule decides).
;          $46 $47    -- the exit mat, RED as every Crystal house mat is.
;   WATER  $10        -- the striped back wall: Crystal's house back wall is
;                        the blue stripe, again a straight copy.
;          BILL's teleporter pods, all of them -- domes $07-$09 $17-$19 $20,
;          bodies $27-$29 $30, pipe collars $0a $1a $2a, feet $37-$3a $50
;          $01 $02 $0f.  Crystal has no Cell Separator, so this is the
;          nearest-object rule: Crystal colours its people-scale machines by
;          their working face (the PCs and the Radio Tower's banks WATER, the
;          Pokecenter link machines' columns blue), and a pod is all working
;          face.  A whole-pod WATER also keeps the floor-hatch rule above,
;          because WATER's colour 0 is the same cream.  The pipe between the
;          pods ($25 $26 $35 $36) stays GRAY: the plain conduit, as Crystal's
;          Power Plant draws its piping.  The wall band under the pods ($45)
;          stays GRAY too -- a blue strip there read as a second wall.
;          $0b $0c $1b $1c -- the computer console's lit screen (blocks $01
;                        and $38), unchanged since M8 11b; matches the
;                        Rocket terminals in TilesetKantoFacilityPalMap.
;          $34 $44    -- SILPH 11F's wainscot strip, the same wall as $10.
;          $03 $04    -- window panes (block $1d), Crystal's blue windows.
;          $05 $06 $15 $16 -- the wall chart (block $1e) sits on the $10
;                        stripes, so it takes the wall's palette.
;   BROWN  $13 $14 $23 $24 -- the framed picture: Crystal's house frames are
;                        wood.  No floor pixels in these four, so no seam.
;   GRAY   everything else: the PC box and the console's desk front ($0d
;          $0e $1d $1e $2b $2c $5b $5c -- Crystal draws its PCs grey with a
;          blue face), the president's desk and table (their light top is
;          colour 1, the same index as the floor hatch, so any other palette
;          tints the carpet around the diagonals; grey reads clean), the black
;          walls ($2d-$2f $57-$5e), and the pipe/band named above.
;
; Palette-map only: 0 bytes of layout, no WRAM/SRAM, save-safe.
;
; Yellow's INTERIOR header is TILEANIM_NONE, so TilesetKantoInteriorAnim is
; the shared no-op alias in data/tileset_anims.asm -- there is nothing to
; animate here.
;
; interior.png is 128x48 = 96 tiles, so the twelve rows below cover $00-$5f.
;
; Both VRAM banks get identical rows, as Crystal's own palette maps do.
	tilepal 0, GRAY, WATER, WATER, WATER, WATER, WATER, WATER, WATER
	tilepal 0, WATER, WATER, WATER, WATER, WATER, GRAY, GRAY, WATER
	tilepal 0, WATER, GRAY, GRAY, BROWN, BROWN, WATER, WATER, WATER
	tilepal 0, WATER, WATER, WATER, WATER, WATER, GRAY, GRAY, RED
	tilepal 0, WATER, GRAY, GRAY, BROWN, BROWN, GRAY, GRAY, WATER
	tilepal 0, WATER, WATER, WATER, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, WATER, RED, RED, RED, WATER, GRAY, GRAY, WATER
	tilepal 0, WATER, WATER, WATER, RED, RED, RED, RED, GRAY
	tilepal 0, GRAY, RED, RED, RED, WATER, GRAY, RED, RED
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 0, WATER, GRAY, GRAY, RED, RED, RED, RED, GRAY
	tilepal 0, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY

rept 16
	db $ff
endr

	tilepal 1, GRAY, WATER, WATER, WATER, WATER, WATER, WATER, WATER
	tilepal 1, WATER, WATER, WATER, WATER, WATER, GRAY, GRAY, WATER
	tilepal 1, WATER, GRAY, GRAY, BROWN, BROWN, WATER, WATER, WATER
	tilepal 1, WATER, WATER, WATER, WATER, WATER, GRAY, GRAY, RED
	tilepal 1, WATER, GRAY, GRAY, BROWN, BROWN, GRAY, GRAY, WATER
	tilepal 1, WATER, WATER, WATER, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, WATER, RED, RED, RED, WATER, GRAY, GRAY, WATER
	tilepal 1, WATER, WATER, WATER, RED, RED, RED, RED, GRAY
	tilepal 1, GRAY, RED, RED, RED, WATER, GRAY, RED, RED
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
	tilepal 1, WATER, GRAY, GRAY, RED, RED, RED, RED, GRAY
	tilepal 1, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY, GRAY
