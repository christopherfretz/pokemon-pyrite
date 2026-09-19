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

SSAnneDeparture::
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
