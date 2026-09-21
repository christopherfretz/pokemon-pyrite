MACRO tileframe
	if _NARG == 2
		dw \2 ; argument
	else
		dw 0
	endc
	dw \1 ; function
ENDM

Tileset0Anim:
TilesetJohtoModernAnim:
TilesetKantoAnim:
	tileframe AnimateWaterTile,        vTiles2 tile $14
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe AnimateWaterPalette
	tileframe WaitTileAnimation
	tileframe AnimateFlowerTile
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe StandingTileFrame8
	tileframe DoneTileAnimation

TilesetParkAnim:
	tileframe AnimateWaterTile,        vTiles2 tile $14
	tileframe WaitTileAnimation
	tileframe AnimateFountainTile,     vTiles2 tile $5f
	tileframe WaitTileAnimation
	tileframe AnimateWaterPalette
	tileframe WaitTileAnimation
	tileframe AnimateFlowerTile
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe StandingTileFrame8
	tileframe DoneTileAnimation

TilesetForestAnim:
	tileframe ForestTreeLeftAnimation
	tileframe ForestTreeRightAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe ForestTreeLeftAnimation2
	tileframe ForestTreeRightAnimation2
	tileframe AnimateFlowerTile
	tileframe AnimateWaterTile,        vTiles2 tile $14
	tileframe AnimateWaterPalette
	tileframe StandingTileFrame8
	tileframe DoneTileAnimation

TilesetJohtoAnim:
	tileframe AnimateWaterTile,        vTiles2 tile $14
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe AnimateWaterPalette
	tileframe WaitTileAnimation
	tileframe AnimateFlowerTile
	tileframe AnimateWhirlpoolTile,    WhirlpoolFrames1
	tileframe AnimateWhirlpoolTile,    WhirlpoolFrames2
	tileframe AnimateWhirlpoolTile,    WhirlpoolFrames3
	tileframe AnimateWhirlpoolTile,    WhirlpoolFrames4
	tileframe WaitTileAnimation
	tileframe StandingTileFrame8
	tileframe DoneTileAnimation

UnusedTilesetFlowerAnim: ; unreferenced
; Leftover from pokegold-spaceworld.
; Scrolls tile $03 like cave water, but also has the standard $03 flower tile.
	tileframe ReadTileToAnimBuffer,    vTiles2 tile $03
	tileframe ScrollTileRightLeft,     wTileAnimBuffer
	tileframe WriteTileFromAnimBuffer, vTiles2 tile $03
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe AnimateFlowerTile
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe DoneTileAnimation

UnusedTilesetWaterAnim: ; unreferenced
; Leftover from pokegold-spaceworld.
; Scrolls tile $14 like cave water.
	tileframe ReadTileToAnimBuffer,    vTiles2 tile $14
	tileframe ScrollTileRightLeft,     wTileAnimBuffer
	tileframe WriteTileFromAnimBuffer, vTiles2 tile $14
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe DoneTileAnimation

TilesetPortAnim:
	tileframe AnimateWaterTile,        vTiles2 tile $14
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe AnimateWaterPalette
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe StandingTileFrame8
	tileframe DoneTileAnimation

TilesetEliteFourRoomAnim:
	tileframe AnimateLavaBubbleTile2
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe AnimateLavaBubbleTile1
	tileframe WaitTileAnimation
	tileframe StandingTileFrame8
	tileframe DoneTileAnimation

UnusedTilesetGenericAnim: ; unreferenced
; Leftover from pokegold-spaceworld.
; Scrolls tile $53 like a waterfall; scrolls tile $03 like cave water.
	tileframe ReadTileToAnimBuffer,    vTiles2 tile $53
	tileframe ScrollTileDown,          wTileAnimBuffer
	tileframe ScrollTileDown,          wTileAnimBuffer
	tileframe WriteTileFromAnimBuffer, vTiles2 tile $53
	tileframe ReadTileToAnimBuffer,    vTiles2 tile $03
	tileframe ScrollTileRightLeft,     wTileAnimBuffer
	tileframe WriteTileFromAnimBuffer, vTiles2 tile $03
	tileframe ReadTileToAnimBuffer,    vTiles2 tile $53
	tileframe ScrollTileDown,          wTileAnimBuffer
	tileframe ScrollTileDown,          wTileAnimBuffer
	tileframe WriteTileFromAnimBuffer, vTiles2 tile $53
	tileframe DoneTileAnimation

UnusedTilesetFontAnim: ; unreferenced
; Leftover from pokegold-spaceworld.
; Scrolls tile $54 like a waterfall; scrolls tile $03 like cave water.
	tileframe ReadTileToAnimBuffer,    vTiles2 tile $54
	tileframe ScrollTileDown,          wTileAnimBuffer
	tileframe ScrollTileDown,          wTileAnimBuffer
	tileframe WriteTileFromAnimBuffer, vTiles2 tile $54
	tileframe WaitTileAnimation
	tileframe ReadTileToAnimBuffer,    vTiles2 tile $03
	tileframe ScrollTileRightLeft,     wTileAnimBuffer
	tileframe WriteTileFromAnimBuffer, vTiles2 tile $03
	tileframe WaitTileAnimation
	tileframe ReadTileToAnimBuffer,    vTiles2 tile $54
	tileframe ScrollTileDown,          wTileAnimBuffer
	tileframe ScrollTileDown,          wTileAnimBuffer
	tileframe WriteTileFromAnimBuffer, vTiles2 tile $54
	tileframe DoneTileAnimation

TilesetCaveAnim:
TilesetDarkCaveAnim:
	tileframe ReadTileToAnimBuffer,    vTiles2 tile $14
	tileframe FlickeringCaveEntrancePalette
	tileframe ScrollTileRightLeft,     wTileAnimBuffer
	tileframe FlickeringCaveEntrancePalette
	tileframe WriteTileFromAnimBuffer, vTiles2 tile $14
	tileframe FlickeringCaveEntrancePalette
	tileframe AnimateWaterPalette
	tileframe FlickeringCaveEntrancePalette
	tileframe ReadTileToAnimBuffer,    vTiles2 tile $40
	tileframe FlickeringCaveEntrancePalette
	tileframe ScrollTileDown,          wTileAnimBuffer
	tileframe FlickeringCaveEntrancePalette
	tileframe ScrollTileDown,          wTileAnimBuffer
	tileframe FlickeringCaveEntrancePalette
	tileframe ScrollTileDown,          wTileAnimBuffer
	tileframe FlickeringCaveEntrancePalette
	tileframe WriteTileFromAnimBuffer, vTiles2 tile $40
	tileframe FlickeringCaveEntrancePalette
	tileframe DoneTileAnimation

TilesetIcePathAnim:
	tileframe ReadTileToAnimBuffer,    vTiles2 tile $35
	tileframe FlickeringCaveEntrancePalette
	tileframe ScrollTileRightLeft,     wTileAnimBuffer
	tileframe FlickeringCaveEntrancePalette
	tileframe WriteTileFromAnimBuffer, vTiles2 tile $35
	tileframe FlickeringCaveEntrancePalette
	tileframe AnimateWaterPalette
	tileframe FlickeringCaveEntrancePalette
	tileframe ReadTileToAnimBuffer,    vTiles2 tile $31
	tileframe FlickeringCaveEntrancePalette
	tileframe ScrollTileDown,          wTileAnimBuffer
	tileframe FlickeringCaveEntrancePalette
	tileframe ScrollTileDown,          wTileAnimBuffer
	tileframe FlickeringCaveEntrancePalette
	tileframe ScrollTileDown,          wTileAnimBuffer
	tileframe FlickeringCaveEntrancePalette
	tileframe WriteTileFromAnimBuffer, vTiles2 tile $31
	tileframe FlickeringCaveEntrancePalette
	tileframe DoneTileAnimation

TilesetTowerAnim:
	tileframe AnimateTowerPillarTile,  TowerPillarTilePointer9
	tileframe AnimateTowerPillarTile,  TowerPillarTilePointer10
	tileframe AnimateTowerPillarTile,  TowerPillarTilePointer7
	tileframe AnimateTowerPillarTile,  TowerPillarTilePointer8
	tileframe AnimateTowerPillarTile,  TowerPillarTilePointer5
	tileframe AnimateTowerPillarTile,  TowerPillarTilePointer6
	tileframe AnimateTowerPillarTile,  TowerPillarTilePointer3
	tileframe AnimateTowerPillarTile,  TowerPillarTilePointer4
	tileframe AnimateTowerPillarTile,  TowerPillarTilePointer1
	tileframe AnimateTowerPillarTile,  TowerPillarTilePointer2
	tileframe StandingTileFrame
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe DoneTileAnimation

UnusedTilesetRocketHouseAnim: ; unreferenced
; Leftover from pokegold-spaceworld.
; Scrolls tile $4f like cave water.
	tileframe ReadTileToAnimBuffer,    vTiles2 tile $4f
	tileframe ScrollTileRightLeft,     wTileAnimBuffer
	tileframe WriteTileFromAnimBuffer, vTiles2 tile $4f
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe DoneTileAnimation

TilesetKantoDockAnim:
; Kanto hack (docs/M4-VERMILION.md P1/A): Yellow's SHIP_PORT sea, tile $14.
; Crystal's TilesetPortAnim uses AnimateWaterTile, which REPLACES tile $14 with
; a frame of Crystal's own water.2bpp and would throw away Yellow's art, so we
; rotate the tile in place instead (Read/Scroll/Write, as TilesetCaveAnim does),
; which is what Yellow's own UpdateMovingBgTiles:: does to its water tiles.
; Crystal's port cadence otherwise: one pixel step and one palette step per
; 11 frames.  ScrollTileRightLeft ticks wTileAnimationTimer itself, so no
; StandingTileFrame8 frame is needed.
	tileframe ReadTileToAnimBuffer,    vTiles2 tile $14
	tileframe ScrollTileRightLeft,     wTileAnimBuffer
	tileframe WriteTileFromAnimBuffer, vTiles2 tile $14
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe AnimateWaterPalette
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe DoneTileAnimation

TilesetBattleTowerOutsideAnim:
TilesetHouseAnim:
TilesetPlayersHouseAnim:
TilesetPokecenterAnim:
TilesetGateAnim:
TilesetShipAnim:
TilesetLabAnim:
TilesetFacilityAnim:
TilesetMartAnim:
TilesetMansionAnim:
TilesetGameCornerAnim:
TilesetTraditionalHouseAnim:
TilesetTrainStationAnim:
TilesetChampionsRoomAnim:
TilesetLighthouseAnim:
TilesetPlayersRoomAnim:
TilesetPokeComCenterAnim:
TilesetBattleTowerInsideAnim:
TilesetRuinsOfAlphAnim:
TilesetRadioTowerAnim:
TilesetUndergroundAnim:
TilesetBetaWordRoomAnim:
TilesetHoOhWordRoomAnim:
TilesetKabutoWordRoomAnim:
TilesetOmanyteWordRoomAnim:
TilesetAerodactylWordRoomAnim:
TilesetKantoGateAnim:
TilesetKantoTowerAnim:
TilesetKantoInteriorAnim:
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe DoneTileAnimation

TilesetKantoFacilityAnim:
; Kanto hack (docs/M8-SAFFRON.md, M8 11b / D71).  Yellow's FACILITY header is
; `tileset Facility, $12, -1, -1, -1, TILEANIM_WATER`, and TILEANIM_WATER in
; Gen 1 is UpdateMovingBgTiles:: (home/vcopy.asm), which bit-rotates ONE tile
; -- vTileset tile $14 -- by one pixel every 20 vblanks, flipping direction
; every 4 steps (`wMovingBGTilesCounter2 and 4` over an 8-step cycle).  It has
; nothing to do with the teleport pads: the spinner arrows at $20 $21 $30 $31
; are swapped in by LoadSpinnerArrowTiles (engine/overworld/spinners.asm) only
; while BIT_SPINNING is set, i.e. during a forced spin-tile run, and the M8
; survey's claim that TILEANIM_WATER animates them is wrong.
;
; Tile $14 is the rippling water in the planter blocks $5b/$75/$76; of every
; FACILITY map only SILPH CO. 1F uses one ($5b, the lobby plant clusters).
;
; Structured like TilesetKantoDockAnim above: rotate Yellow's own tile in
; place (Read/Scroll/Write) rather than AnimateWaterTile, which would
; overwrite it with a frame of Crystal's water.2bpp.  Crystal runs one
; tileframe per frame, so the list length IS the period: 20 entries = Yellow's
; 20-vblank cadence exactly, and ScrollTileRightLeft's own `and %100` over an
; 8-tick wTileAnimationTimer reproduces Yellow's direction flip every 4 steps.
; No AnimateWaterPalette frame: Yellow's FACILITY has no palette cycle.
	tileframe ReadTileToAnimBuffer,    vTiles2 tile $14
	tileframe ScrollTileRightLeft,     wTileAnimBuffer
	tileframe WriteTileFromAnimBuffer, vTiles2 tile $14
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe WaitTileAnimation
	tileframe DoneTileAnimation
