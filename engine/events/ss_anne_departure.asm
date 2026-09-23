; Kanto hack: M4 step 7j (docs/M4-VERMILION.md).  The S.S. ANNE sails.
;
; Port of Yellow's VermilionDockSSAnneLeavesScript
; (vendor/pokeyellow/scripts/VermilionDock.asm).  Yellow splits the screen with
; an rLY-synced rSCX write: scanlines $50-$7F -- wTileMap rows 10-15, which at
; the dock is exactly the liner and nothing else -- scroll right while the quay,
; the gangway and the player above them stay put, so the ship slides west out of
; frame.  It runs 8 * 16 * 8 = 1024 frames, feeding a fresh column of open sea
; into the band's east edge every 16 px of scroll (ScheduleEastColumnRedraw),
; then hides the screen behind the window map, repaints the band by hand
; (VermilionDock_EraseSSAnne) and drops the window again.
;
; Crystal already has the hardware split Yellow open-codes: wLYOverrides plus
; hLCDCPointer, latched per scanline by LCD:: in home/lcd.asm -- which indexes
; wLYOverrides by rLY and so assumes rWBK == BANK(wLYOverrides) for as long as
; the pointer is set (engine/events/magnet_train.asm does the same push/pop).
; The STAT interrupt is armed for us: home/init.asm leaves rSTAT = STAT_MODE_0
; and IE_DEFAULT includes IE_STAT, so LCD:: fires on every HBlank in the
; overworld and returns immediately while hLCDCPointer is 0.
;
; The column feed is hand-rolled below rather than borrowed from ScrollMapRight,
; because ScrollMapRight rewrites all 18 rows of a column: from the 7th feed on,
; its target column has wrapped around the 32-tile BG map and lands back on the
; visible left edge -- which is exactly the stray quay strip Yellow flashes in
; the last seconds of its animation.  Feeding only the six band rows is
; artifact-free, and it means nothing outside the band is ever touched, so no
; window-map cover-up is needed either: by the last frame the whole band is open
; sea at every scroll offset, and dropping the split is invisible.
;
; The map blocks are `changeblock`ed by the caller
; (VermilionPortSSAnneDepartsScene) before this runs.  changeblock only writes
; wOverworldMapBlocks and buffers the screen, so the new quay stays invisible
; until the `refreshmap` after we return, which rebuilds wTilemap and HDMAs the
; lot back over our hand-written columns.

; Yellow: `ld l, $50` / `ld l, $80` in VermilionDock_SyncScrollWithLY.
DEF SSANNE_BAND_TOP       EQU $50
DEF SSANNE_BAND_BOTTOM    EQU $80
DEF SSANNE_BAND_FIRST_ROW EQU SSANNE_BAND_TOP / 8
DEF SSANNE_BAND_ROWS      EQU (SSANNE_BAND_BOTTOM - SSANNE_BAND_TOP) / 8

; Yellow: `ld e, $8` (columns) / `ld b, $10` (px per column) / `ld c, $8`
; (frames per px).  8 * 16 = 128 px of scroll -- the ship is exactly 4 blocks
; wide -- over 8 * 16 * 8 = 1024 frames.
DEF SSANNE_COLUMNS        EQU 8
DEF SSANNE_STEPS          EQU 16
DEF SSANNE_FRAMES         EQU 8

; A cell of wTilemap/wAttrmap that is open sea for the whole scene, read at
; runtime so the tile id and the CGB attribute both come from the live tileset
; instead of being hardcoded.  Screen (0,17) is map block (5,3) = $0d, all sea.
DEF SSANNE_SEA_CELL       EQU 17 * SCREEN_WIDTH

; wBGMapAnchor is in WRAM bank 1 and we hold rWBK at BANK(wLYOverrides) for the
; whole scene (LCD:: indexes wLYOverrides with whatever bank is mapped), so the
; anchor has to be copied somewhere bank-independent first.  wBGMapBuffer is
; WRAM0 and 2 * SCREEN_WIDTH bytes long; UpdateBGMapBuffer only ever reads the
; first [hBGMapTileCount] * 2 of them -- 12 here -- so its last two are dead
; space for the length of the animation.
DEF wSSAnneBGMapAnchor    EQUS "(wBGMapBuffer + 2 * SCREEN_WIDTH - 2)"

; K6b: the funnel smoke.  Yellow (VermilionDock_EmitSmokePuff) draws ONE 16x16
; puff -- four OAM entries sharing one 8x8 smoke tile -- at OAM Y 100, emitted
; at X 72 - 16n at the start of column n and drifted +2 px per 8-frame step
; (VermilionDock_AnimSmokePuffDriftRight), so relative to the scrolling hull it
; is always born over the funnel and trails east.  Keyed to the scroll offset d
; here: X = 72 - (d & $f0) + 2 * ((d & 15) + 1), which is Yellow's position at
; every scroll value (measured frame by frame in the Yellow harness).
;
; OBJ tile $7c of VRAM bank 0 is free while this runs: the follower's own tiles
; are $6c-$77 (+ $ec-$f7), emotes use $f8+, the dock has no NPCs, and $7c is
; the slot Crystal's own heal-machine animation borrows (heal_machine_anim.asm)
; for the same reason.  Sprites 36-39 are the tail of wShadowOAM; nothing else
; writes wShadowOAM while a special holds the script, so they stay put.
; Palette: PAL_OW_EMOTE (silver: white/white/grey/black at every time of day).
; Yellow's CGB colours tint colour 2 lavender only because OBP1 follows the
; purple Vermilion map palette; silver is the same smoke on our dock.
DEF SSANNE_PUFF_TILE      EQU $7c
DEF SSANNE_PUFF_Y         EQU 100
DEF SSANNE_PUFF_X         EQU 72
DEF wSSAnnePuffOAM        EQUS "wShadowOAMSprite36"

SSAnneDeparture::
	ld de, SSAnneSmokeGFX
	ld hl, vTiles0 tile SSANNE_PUFF_TILE
	lb bc, BANK(SSAnneSmokeGFX), 1
	call Request2bpp

	ldh a, [rWBK]
	push af
	ld a, BANK(wBGMapAnchor)
	ldh [rWBK], a
	ld a, [wBGMapAnchor]
	ld [wSSAnneBGMapAnchor], a
	ld a, [wBGMapAnchor + 1]
	ld [wSSAnneBGMapAnchor + 1], a
	ld a, BANK(wLYOverrides)
	ldh [rWBK], a

; The overworld leaves this at 0; make sure, or UpdateBGMap would repaint the
; whole BG map from the (still shipbearing) wTilemap behind our backs.
	xor a
	ldh [hBGMapMode], a

	call .InitLYOverrides

; Yellow: SFX_SS_ANNE_HORN, which Gen 1 audio has not been ported yet (K6).
	ld de, SFX_BOAT
	call PlaySFX

	ld d, 0 ; scroll offset, in pixels
	ld c, SSANNE_COLUMNS
.column_loop
; Feed sea into the BG map column pair about to enter the band's east edge.
; At the top of iteration n the offset is 16n px, so the band shows columns
; 2n..2n+19 and the pair to fill is 2n+20, 2n+21.
	ld a, SSANNE_COLUMNS
	sub c
	add a
	add SCREEN_WIDTH
	push bc
	push de
	ld e, a
	call .FeedSeaColumn
	pop de
	pop bc

	ld b, SSANNE_STEPS
.step_loop
	inc d
	push bc
	push de
	call .SetBandScroll
	pop de
	push de
	call .SetSmokePuff
	pop de
	pop bc
	ld e, SSANNE_FRAMES
.frame_loop
	push bc
	push de
	call DelayFrame
	pop de
	pop bc
	dec e
	jr nz, .frame_loop
	dec b
	jr nz, .step_loop
	dec c
	jr nz, .column_loop

; Yellow's last puff has drifted off the east edge by now (X 248); hide it for
; good before the band is repainted.
	ld hl, wSSAnnePuffOAM
	ld a, OAM_YCOORD_HIDDEN
	ld c, 4
.hide_loop
	ld [hli], a
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, .hide_loop

; d is 128 now, so the band shows BG map columns 16..35 -> 16-31 and 0-3, every
; one of them fed above (16-19 never held the ship).  Columns 4-15 are the ones
; that did, and they are off-screen at this offset: repaint them before dropping
; the split, or the band would snap back to the hull.
	ld c, 6
	ld e, 4
.repaint_loop
	push bc
	push de
	call .FeedSeaColumn
	call DelayFrame ; one feed per VBlank
	pop de
	pop bc
	inc e
	inc e
	dec c
	jr nz, .repaint_loop

	call DelayFrame ; let the last VBlank write land
	xor a
	ldh [hLCDCPointer], a

	pop af
	ldh [rWBK], a
	ret

.InitLYOverrides:
; Every scanline scrolls with the camera to begin with; .SetBandScroll is what
; moves the ship's.  The ten bytes past wLYOverridesEnd matter too: LCD:: keeps
; indexing by rLY through lines 144-153, and whatever it reads there is the rSCX
; line 0 renders with.
	ld hl, wLYOverrides
	ld bc, SCREEN_HEIGHT_PX + 10
	ldh a, [hSCX]
	call ByteFill
	ld a, LOW(rSCX)
	ldh [hLCDCPointer], a
	ret

.SetBandScroll:
; Yellow: rSCX = d from rLY $50, 0 from rLY $80.  LCD:: runs in the HBlank of
; line rLY and so sets the scroll of line rLY + 1, hence the -1.
	ldh a, [hSCX]
	add d
	ld b, a
	ld hl, wLYOverrides + SSANNE_BAND_TOP - 1
	ld c, SSANNE_BAND_BOTTOM - SSANNE_BAND_TOP
.band_loop
	ld [hl], b
	inc hl
	dec c
	jr nz, .band_loop
	ret

.SetSmokePuff:
; b := 72 + 2 * ((d & 15) + 1) - (d & $f0), the puff's left OAM X.
	ld a, d
	and $0f
	add a
	add SSANNE_PUFF_X + 2
	ld b, a
	ld a, d
	and $f0
	cpl
	inc a
	add b
	ld b, a
	ld hl, wSSAnnePuffOAM
	ld c, SSANNE_PUFF_Y
	call .PuffRow
	ld c, SSANNE_PUFF_Y + TILE_WIDTH
.PuffRow:
; Two entries, (c, b) and (c, b + 8): Yellow's WriteOAMBlock, one row of it.
	call .PuffEntry
	ld a, b
	add TILE_WIDTH
	ld b, a
	call .PuffEntry
	ld a, b
	sub TILE_WIDTH
	ld b, a
	ret

.PuffEntry:
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, SSANNE_PUFF_TILE
	ld [hli], a
	ld a, PAL_OW_EMOTE
	ld [hli], a
	ret

.FeedSeaColumn:
; Schedule a VBlank write of open sea over the two 8x8 columns e tiles east of
; wBGMapAnchor, band rows only.  Yellow's ScheduleEastColumnRedraw, narrowed.
; UpdateBGMapBuffer consumes [hBGMapTileCount] pointers, two tiles wide each.
	ld hl, wBGMapBuffer
	ld bc, 2 * SSANNE_BAND_ROWS
	ld a, [wTilemap + SSANNE_SEA_CELL]
	call ByteFill
	ld hl, wBGMapPalBuffer
	ld bc, 2 * SSANNE_BAND_ROWS
	ld a, [wAttrmap + SSANNE_SEA_CELL]
	call ByteFill

	ld a, [wSSAnneBGMapAnchor]
	ld l, a
	ld a, [wSSAnneBGMapAnchor + 1]
	ld h, a
; column := (column + e) mod 32, row kept (ScrollMapRight's idiom)
	ld a, l
	and %11100000
	ld b, a
	ld a, l
	add e
	and %00011111
	or b
	ld l, a
; down to the first band row, capped to the $9800-$9bff BG map
	ld bc, SSANNE_BAND_FIRST_ROW * TILEMAP_WIDTH
	add hl, bc
	ld a, h
	and %11
	or HIGH(vBGMap0)
	ld h, a

	ld d, h
	ld e, l
	ld hl, wBGMapBufferPointers
	ld c, SSANNE_BAND_ROWS
.pointer_loop
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, TILEMAP_WIDTH
	add e
	ld e, a
	jr nc, .pointer_next
	inc d
	ld a, d
	and %11
	or HIGH(vBGMap0)
	ld d, a
.pointer_next
	dec c
	jr nz, .pointer_loop

	ld a, SSANNE_BAND_ROWS
	ldh [hBGMapTileCount], a
	ld a, 1
	ldh [hBGMapUpdate], a
	ret

SSAnneSmokeGFX:
; Yellow's gfx/overworld/smoke.png, unchanged.
INCBIN "gfx/overworld/smoke.2bpp"
