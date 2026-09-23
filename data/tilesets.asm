MACRO tileset
	dba \1GFX, \1Meta, \1Coll
	dw \1Anim
	dw NULL
	dw \1PalMap
ENDM

; Associated data:
; - The *GFX, *Meta, and *Coll are defined in gfx/tilesets.asm
; - The *PalMap are defined in gfx/tileset_palette_maps.asm
; - The *Anim are defined in data/tileset_anims.asm

Tilesets::
; entries correspond to TILESET_* constants (see constants/tileset_constants.asm)
	table_width TILESET_LENGTH
	tileset Tileset0
	tileset TilesetJohto
	tileset TilesetJohtoModern
	tileset TilesetKanto
	tileset TilesetBattleTowerOutside
	tileset TilesetHouse
	tileset TilesetPlayersHouse
	tileset TilesetPokecenter
	tileset TilesetGate
	tileset TilesetPort
	tileset TilesetLab
	tileset TilesetFacility
	tileset TilesetMart
	tileset TilesetMansion
	tileset TilesetGameCorner
	tileset TilesetEliteFourRoom
	tileset TilesetTraditionalHouse
	tileset TilesetTrainStation
	tileset TilesetChampionsRoom
	tileset TilesetLighthouse
	tileset TilesetPlayersRoom
	tileset TilesetPokeComCenter
	tileset TilesetBattleTowerInside
	tileset TilesetTower
	tileset TilesetCave
	tileset TilesetPark
	tileset TilesetRuinsOfAlph
	tileset TilesetRadioTower
	tileset TilesetUnderground
	tileset TilesetIcePath
	tileset TilesetDarkCave
	tileset TilesetForest
	tileset TilesetBetaWordRoom
	tileset TilesetHoOhWordRoom
	tileset TilesetKabutoWordRoom
	tileset TilesetOmanyteWordRoom
	tileset TilesetAerodactylWordRoom
	tileset TilesetShip
	tileset TilesetKantoDock
	tileset TilesetKantoGate
	tileset TilesetKantoTower
	tileset TilesetKantoFacility
	tileset TilesetKantoInterior
	tileset TilesetKantoLab
	tileset TilesetKantoGym
	tileset TilesetKantoPlateau
; M10 13j2: the E4 wing's clones -- KANTO_GYM's / KANTO_TOWER's gfx, blocks,
; collision and animation; only the palette map differs (the per-room colours
; come from LoadSpecialMapPalette).
	dba TilesetKantoGymGFX, TilesetKantoGymMeta, TilesetKantoGymColl
	dw TilesetKantoGymAnim
	dw NULL
	dw TilesetKantoE4PalMap
	dba TilesetKantoTowerGFX, TilesetKantoTowerMeta, TilesetKantoTowerColl
	dw TilesetKantoTowerAnim
	dw NULL
	dw TilesetKantoE4TowerPalMap
; M12a: Yellow's BEACH_HOUSE, the SUMMER BEACH HOUSE on ROUTE 19.
	tileset TilesetKantoBeachHouse
	assert_table_length NUM_TILESETS + 1
