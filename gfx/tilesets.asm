MACRO tilecoll
; used in data/tilesets/*_collision.asm
	db COLL_\1, COLL_\2, COLL_\3, COLL_\4
ENDM


SECTION "Tileset Data 1", ROMX

TilesetKantoGFX::
INCBIN "gfx/tilesets/kanto.2bpp.lz"

Tileset0GFX::
TilesetJohtoGFX::
INCBIN "gfx/tilesets/johto.2bpp.lz"

Tileset0Meta::
TilesetJohtoMeta::
INCBIN "data/tilesets/johto_metatiles.bin"

Tileset0Coll::
TilesetJohtoColl::
INCLUDE "data/tilesets/johto_collision.asm"

TilesetIcePathGFX::
INCBIN "gfx/tilesets/ice_path.2bpp.lz"

TilesetIcePathMeta::
INCBIN "data/tilesets/ice_path_metatiles.bin"

TilesetIcePathColl::
INCLUDE "data/tilesets/ice_path_collision.asm"

TilesetPlayersRoomGFX::
INCBIN "gfx/tilesets/players_room.2bpp.lz"

TilesetPlayersRoomMeta::
INCBIN "data/tilesets/players_room_metatiles.bin"

TilesetPlayersRoomColl::
INCLUDE "data/tilesets/players_room_collision.asm"


SECTION "Tileset Data 2", ROMX

TilesetPokecenterGFX::
INCBIN "gfx/tilesets/pokecenter.2bpp.lz"

TilesetPokecenterMeta::
INCBIN "data/tilesets/pokecenter_metatiles.bin"

TilesetPokecenterColl::
INCLUDE "data/tilesets/pokecenter_collision.asm"

TilesetPortGFX::
INCBIN "gfx/tilesets/port.2bpp.lz"

TilesetPortMeta::
INCBIN "data/tilesets/port_metatiles.bin"

TilesetPortColl::
INCLUDE "data/tilesets/port_collision.asm"

TilesetPlayersHouseGFX::
INCBIN "gfx/tilesets/players_house.2bpp.lz"

TilesetPlayersHouseMeta::
INCBIN "data/tilesets/players_house_metatiles.bin"

TilesetPlayersHouseColl::
INCLUDE "data/tilesets/players_house_collision.asm"

TilesetMansionGFX::
INCBIN "gfx/tilesets/mansion.2bpp.lz"

TilesetMansionMeta::
INCBIN "data/tilesets/mansion_metatiles.bin"

TilesetMansionColl::
INCLUDE "data/tilesets/mansion_collision.asm"

TilesetCaveGFX::
INCBIN "gfx/tilesets/cave.2bpp.lz"

TilesetCaveMeta::
TilesetDarkCaveMeta::
INCBIN "data/tilesets/cave_metatiles.bin"

TilesetCaveColl::
TilesetDarkCaveColl::
INCLUDE "data/tilesets/cave_collision.asm"


SECTION "Tileset Data 3", ROMX

TilesetTowerGFX::
INCBIN "gfx/tilesets/tower.2bpp.lz"

TilesetTowerMeta::
INCBIN "data/tilesets/tower_metatiles.bin"

TilesetTowerColl::
INCLUDE "data/tilesets/tower_collision.asm"

TilesetLabGFX::
INCBIN "gfx/tilesets/lab.2bpp.lz"

TilesetLabMeta::
INCBIN "data/tilesets/lab_metatiles.bin"

TilesetLabColl::
INCLUDE "data/tilesets/lab_collision.asm"

TilesetMartGFX::
INCBIN "gfx/tilesets/mart.2bpp.lz"

TilesetMartMeta::
INCBIN "data/tilesets/mart_metatiles.bin"

TilesetMartColl::
INCLUDE "data/tilesets/mart_collision.asm"

TilesetGameCornerGFX::
INCBIN "gfx/tilesets/game_corner.2bpp.lz"

TilesetGameCornerMeta::
INCBIN "data/tilesets/game_corner_metatiles.bin"

TilesetGameCornerColl::
INCLUDE "data/tilesets/game_corner_collision.asm"

TilesetTrainStationGFX::
INCBIN "gfx/tilesets/train_station.2bpp.lz"

TilesetTrainStationMeta::
INCBIN "data/tilesets/train_station_metatiles.bin"

TilesetTrainStationColl::
INCLUDE "data/tilesets/train_station_collision.asm"

TilesetForestMeta::
INCBIN "data/tilesets/forest_metatiles.bin"


SECTION "Tileset Data 4", ROMX

TilesetEliteFourRoomGFX::
INCBIN "gfx/tilesets/elite_four_room.2bpp.lz"

TilesetEliteFourRoomMeta::
INCBIN "data/tilesets/elite_four_room_metatiles.bin"

TilesetEliteFourRoomColl::
INCLUDE "data/tilesets/elite_four_room_collision.asm"

TilesetParkGFX::
INCBIN "gfx/tilesets/park.2bpp.lz"

TilesetParkMeta::
INCBIN "data/tilesets/park_metatiles.bin"

TilesetParkColl::
INCLUDE "data/tilesets/park_collision.asm"

TilesetRadioTowerGFX::
INCBIN "gfx/tilesets/radio_tower.2bpp.lz"

TilesetRadioTowerMeta::
INCBIN "data/tilesets/radio_tower_metatiles.bin"

TilesetRadioTowerColl::
INCLUDE "data/tilesets/radio_tower_collision.asm"

TilesetUndergroundGFX::
INCBIN "gfx/tilesets/underground.2bpp.lz"

TilesetUndergroundMeta::
INCBIN "data/tilesets/underground_metatiles.bin"

TilesetUndergroundColl::
INCLUDE "data/tilesets/underground_collision.asm"

TilesetDarkCaveGFX::
INCBIN "gfx/tilesets/dark_cave.2bpp.lz"

UnusedTilesetJohtoMeta:: ; unreferenced
INCBIN "data/tilesets/unused_johto_metatiles.bin"

UnusedTilesetJohtoColl:: ; unreferenced
INCLUDE "data/tilesets/unused_johto_collision.asm"


SECTION "Tileset Data 5", ROMX

TilesetPokeComCenterGFX::
INCBIN "gfx/tilesets/pokecom_center.2bpp.lz"

TilesetPokeComCenterMeta::
INCBIN "data/tilesets/pokecom_center_metatiles.bin"

TilesetPokeComCenterColl::
INCLUDE "data/tilesets/pokecom_center_collision.asm"

TilesetBattleTowerInsideGFX::
INCBIN "gfx/tilesets/battle_tower_inside.2bpp.lz"

TilesetBattleTowerInsideMeta::
INCBIN "data/tilesets/battle_tower_inside_metatiles.bin"

TilesetBattleTowerInsideColl::
INCLUDE "data/tilesets/battle_tower_inside_collision.asm"

TilesetGateGFX::
INCBIN "gfx/tilesets/gate.2bpp.lz"

TilesetGateMeta::
INCBIN "data/tilesets/gate_metatiles.bin"

TilesetGateColl::
INCLUDE "data/tilesets/gate_collision.asm"

TilesetJohtoModernGFX::
TilesetBattleTowerOutsideGFX::
INCBIN "gfx/tilesets/johto_modern.2bpp.lz"

TilesetJohtoModernMeta::
INCBIN "data/tilesets/johto_modern_metatiles.bin"

TilesetJohtoModernColl::
INCLUDE "data/tilesets/johto_modern_collision.asm"

TilesetTraditionalHouseGFX::
INCBIN "gfx/tilesets/traditional_house.2bpp.lz"

TilesetTraditionalHouseMeta::
INCBIN "data/tilesets/traditional_house_metatiles.bin"

TilesetTraditionalHouseColl::
INCLUDE "data/tilesets/traditional_house_collision.asm"


SECTION "Tileset Data 6", ROMX

TilesetForestGFX::
INCBIN "gfx/tilesets/forest.2bpp.lz"

TilesetChampionsRoomGFX::
INCBIN "gfx/tilesets/champions_room.2bpp.lz"

TilesetChampionsRoomMeta::
INCBIN "data/tilesets/champions_room_metatiles.bin"

TilesetChampionsRoomColl::
INCLUDE "data/tilesets/champions_room_collision.asm"

TilesetHouseGFX::
INCBIN "gfx/tilesets/house.2bpp.lz"

TilesetHouseMeta::
INCBIN "data/tilesets/house_metatiles.bin"

TilesetHouseColl::
INCLUDE "data/tilesets/house_collision.asm"

TilesetLighthouseGFX::
INCBIN "gfx/tilesets/lighthouse.2bpp.lz"

TilesetLighthouseMeta::
INCBIN "data/tilesets/lighthouse_metatiles.bin"

TilesetLighthouseColl::
INCLUDE "data/tilesets/lighthouse_collision.asm"

TilesetForestColl::
INCLUDE "data/tilesets/forest_collision.asm"

TilesetFacilityGFX::
INCBIN "gfx/tilesets/facility.2bpp.lz"

TilesetFacilityMeta::
INCBIN "data/tilesets/facility_metatiles.bin"

TilesetFacilityColl::
INCLUDE "data/tilesets/facility_collision.asm"

TilesetBattleTowerOutsideMeta::
INCBIN "data/tilesets/battle_tower_outside_metatiles.bin"

TilesetBattleTowerOutsideColl::
INCLUDE "data/tilesets/battle_tower_outside_collision.asm"

TilesetBetaWordRoomMeta::
INCBIN "data/tilesets/beta_word_room_metatiles.bin"

TilesetBetaWordRoomColl::
TilesetHoOhWordRoomColl::
TilesetKabutoWordRoomColl::
TilesetOmanyteWordRoomColl::
TilesetAerodactylWordRoomColl::
INCLUDE "data/tilesets/beta_word_room_collision.asm"


SECTION "Tileset Data 7", ROMX

TilesetRuinsOfAlphGFX::
TilesetBetaWordRoomGFX::
TilesetHoOhWordRoomGFX::
TilesetKabutoWordRoomGFX::
TilesetOmanyteWordRoomGFX::
TilesetAerodactylWordRoomGFX::
INCBIN "gfx/tilesets/ruins_of_alph.2bpp.lz"

TilesetRuinsOfAlphMeta::
INCBIN "data/tilesets/ruins_of_alph_metatiles.bin"

TilesetRuinsOfAlphColl::
INCLUDE "data/tilesets/ruins_of_alph_collision.asm"


SECTION "Tileset Data 8", ROMX

TilesetHoOhWordRoomMeta::
INCBIN "data/tilesets/ho_oh_word_room_metatiles.bin"

TilesetKabutoWordRoomMeta::
INCBIN "data/tilesets/kabuto_word_room_metatiles.bin"

TilesetOmanyteWordRoomMeta::
INCBIN "data/tilesets/omanyte_word_room_metatiles.bin"

TilesetAerodactylWordRoomMeta::
INCBIN "data/tilesets/aerodactyl_word_room_metatiles.bin"

; Yellow's FACILITY tileset, ported wholesale by M6 9o for ROCKET HIDEOUT
; B1F-B4F (and, later, SILPH CO, POKeMON MANSION, the POWER PLANT, CINNABAR
; GYM and SAFFRON GYM).  Crystal has a tileset *named* FACILITY -- the
; Mahogany Rocket HQ / Radio Tower one, above -- but it is unrelated art, so
; this is the same call M5 8a made for CEMETERY -> TILESET_KANTO_TOWER.
; 128 blocks, 96 tiles, counter tile $12.  Yellow's header says TILEANIM_WATER,
; which in Gen 1 rotates tile $14 (the planter water) and NOT, as the M8 survey
; assumed, the spinner arrows -- M8 11b replaced 9o's no-op alias with the real
; thing; see TilesetKantoFacilityAnim in data/tileset_anims.asm.
; Generated by scripts/celadon_blk.py.
TilesetKantoFacilityGFX::
INCBIN "gfx/tilesets/kanto_facility.2bpp.lz"

TilesetKantoFacilityMeta::
INCBIN "data/tilesets/kanto_facility_metatiles.bin"

TilesetKantoFacilityColl::
INCLUDE "data/tilesets/kanto_facility_collision.asm"


SECTION "Tileset Data 10", ROMX

; S.S. Anne's tileset, ported wholesale from Yellow by M4 step 7c
; (docs/M4-VERMILION.md decision (a)): Yellow's 62-block SHIP blockset has no
; Crystal counterpart -- Crystal's own ship is the Fast Ship, drawn with the
; outdoor `port` tileset -- so the ten SS_ANNE_* maps keep Yellow's own art and
; their .blk files are byte-identical copies of Yellow's.
TilesetShipGFX::
INCBIN "gfx/tilesets/ship.2bpp.lz"

TilesetShipMeta::
INCBIN "data/tilesets/ship_metatiles.bin"

TilesetShipColl::
INCLUDE "data/tilesets/ship_collision.asm"


SECTION "Tileset Data 11", ROMX

; Vermilion Port's tileset, ported wholesale from Yellow by M4 step 7g-b
; (docs/M4-VERMILION.md, "## 7g-b findings") -- the same call 7c made for the
; S.S. Anne herself.  7b had drawn Yellow's dock with Crystal's `port`
; tileset on the assumption that Crystal's $18-$1f were a 4x2 FAST SHIP; they
; are two unrelated pieces of it, so the dock came out corrupt.  With Yellow's
; own 23-block blockset the map is a byte-identical copy of Yellow's
; VermilionDock.blk, border block $0f (solid black) included.
TilesetKantoDockGFX::
INCBIN "gfx/tilesets/kanto_dock.2bpp.lz"

TilesetKantoDockMeta::
INCBIN "data/tilesets/kanto_dock_metatiles.bin"

TilesetKantoDockColl::
INCLUDE "data/tilesets/kanto_dock_collision.asm"


SECTION "Tileset Data 12", ROMX

; Yellow's GATE tileset (which Yellow aliases MUSEUM and FOREST_GATE onto),
; ported wholesale by M1 -- the same call 7c made for the S.S. ANNE and 7g-b
; for Vermilion's dock.  Step 4d had drawn Pewter Museum with Crystal's own
; TILESET_GATE on the strength of that Yellow alias; Crystal's gate blockset
; is unrelated art (PC cabinets where the display cases go), and so are
; Crystal's gates.  Crystal's TILESET_GATE is untouched and still serves every
; Johto gate.  128 blocks, 96 tiles, no tile animation (Yellow's header says
; TILEANIM_NONE).
TilesetKantoGateGFX::
INCBIN "gfx/tilesets/kanto_gate.2bpp.lz"

TilesetKantoGateMeta::
INCBIN "data/tilesets/kanto_gate_metatiles.bin"

TilesetKantoGateColl::
INCLUDE "data/tilesets/kanto_gate_collision.asm"


SECTION "Tileset Data 13", ROMX

; Yellow's CEMETERY tileset, ported wholesale by M5 8a for POKeMON TOWER's
; seven floors.  Crystal's own TILESET_TOWER is Sprout/Tin Tower -- wooden
; pagoda floors, a central pillar, a stair well -- and shares no art at all
; with Lavender's black-walled crypt and its rows of gravestones, so this is
; the same call 7c made for the S.S. ANNE, 7g-b for the dock and M1 for the
; Kanto gates.  110 blocks, 96 tiles, no tile animation (Yellow's header says
; TILEANIM_NONE), counter tile $12.  Generated by scripts/lavender_blk.py.
TilesetKantoTowerGFX::
INCBIN "gfx/tilesets/kanto_tower.2bpp.lz"

TilesetKantoTowerMeta::
INCBIN "data/tilesets/kanto_tower_metatiles.bin"

TilesetKantoTowerColl::
INCLUDE "data/tilesets/kanto_tower_collision.asm"


SECTION "Tileset Data 14", ROMX

; Kanto's metatile and collision tables.  Moved out of "Tileset Data 1" by M4
; step 7b (docs/M4-VERMILION.md) as the floating "Tileset Data 9", and moved
; again -- renamed, and PINNED to bank $79 -- by M7 10l (docs/M7-FUCHSIA.md
; D48).  The Safari Zone's four area-to-area warp metatiles ($c6-$c9, 80 B)
; left the floated section with 6 free bytes in bank $0a, and Kanto still has
; milestones to go, so the tables now own a wholly empty bank of their own:
; $79 was one of the four empty banks M7 10a found, and at 4040 B of table
; there are ~12.3 KB of headroom for every Kanto metatile still to come.
; `tileset` (data/tilesets.asm) emits a separate `dba` for GFX, Meta and Coll,
; so the three are free to sit in different banks.
TilesetKantoMeta::
INCBIN "data/tilesets/kanto_metatiles.bin"

TilesetKantoColl::
INCLUDE "data/tilesets/kanto_collision.asm"

; Yellow's INTERIOR tileset, ported wholesale by M8 11b (docs/M8-SAFFRON.md
; D70) for SILPH CO. 11F -- the president's office, and the one Silph floor
; Yellow does not draw with FACILITY.  Crystal has nothing like it, so this is
; the same call M1 made for GATE, M5 8a for CEMETERY and M6 9o for FACILITY.
; 58 blocks, 96 tiles, no counter tile, TILEANIM_NONE.  Generated by
; scripts/kanto_interior_blk.py.  It lands in this bank rather than beside the
; other tilesets' GFX because $79 is Kanto's own empty bank and has room; the
; `tileset` macro emits a separate `dba` for GFX, Meta and Coll, so all three
; are free to sit wherever they fit.
TilesetKantoInteriorGFX::
INCBIN "gfx/tilesets/kanto_interior.2bpp.lz"

TilesetKantoInteriorMeta::
INCBIN "data/tilesets/kanto_interior_metatiles.bin"

TilesetKantoInteriorColl::
INCLUDE "data/tilesets/kanto_interior_collision.asm"

; Yellow's LAB tileset, ported wholesale by M9 12i (docs/M9-CINNABAR.md D95)
; for CINNABAR LAB and its TRADE / R&D / TESTING rooms.  A blockset of its
; own -- docs/M9-CINNABAR.md C-4 confirmed it shares nothing with INTERIOR --
; so the same call again: 58 blocks, 96 tiles, no counter tile, TILEANIM_NONE.
; Generated by scripts/kanto_lab_blk.py.  It joins the INTERIOR set in this
; bank because $79 is Kanto's own empty bank and still had ~10 KB free.
TilesetKantoLabGFX::
INCBIN "gfx/tilesets/kanto_lab.2bpp.lz"

TilesetKantoLabMeta::
INCBIN "data/tilesets/kanto_lab_metatiles.bin"

TilesetKantoLabColl::
INCLUDE "data/tilesets/kanto_lab_collision.asm"

; Yellow's GYM (= DOJO) tileset, ported wholesale by M10 13a (docs/M10-INDIGO.md
; D114) for VIRIDIAN GYM and, later, the E4 rooms, CHAMPION and HALL OF FAME:
; 96 tiles, Yellow's 116 blocks plus the D115 arrow-run clones from $74.
; Generated by scripts/kanto_gym_blk.py.
TilesetKantoGymGFX::
INCBIN "gfx/tilesets/kanto_gym.2bpp.lz"

TilesetKantoGymMeta::
INCBIN "data/tilesets/kanto_gym_metatiles.bin"

TilesetKantoGymColl::
INCLUDE "data/tilesets/kanto_gym_collision.asm"

; Yellow's PLATEAU tileset, ported wholesale by M10 13e-1 (docs/M10-INDIGO.md)
; for ROUTE 23 and, from 13e-2, INDIGO PLATEAU: 70 tiles, Yellow's 73 blocks
; plus the two ROUTE 23 south-mouth warp clones at $49/$4a.
; Generated by scripts/kanto_plateau_blk.py.
TilesetKantoPlateauGFX::
INCBIN "gfx/tilesets/kanto_plateau.2bpp.lz"

TilesetKantoPlateauMeta::
INCBIN "data/tilesets/kanto_plateau_metatiles.bin"

TilesetKantoPlateauColl::
INCLUDE "data/tilesets/kanto_plateau_collision.asm"

; Yellow's BEACH_HOUSE tileset, ported wholesale by M12a (docs/M12-STRETCH.md)
; for the SUMMER BEACH HOUSE on ROUTE 19, the only map that uses it: 20
; blocks, 96 tile slots (72 drawn), no counter, TILEANIM_NONE.
; Generated by scripts/kanto_beach_house_blk.py.
TilesetKantoBeachHouseGFX::
INCBIN "gfx/tilesets/kanto_beach_house.2bpp.lz"

TilesetKantoBeachHouseMeta::
INCBIN "data/tilesets/kanto_beach_house_metatiles.bin"

TilesetKantoBeachHouseColl::
INCLUDE "data/tilesets/kanto_beach_house_collision.asm"


SECTION "Tileset Data 15", ROMX

; Yellow's CAVERN tileset, ported wholesale by CT1 (docs/CT1-KANTO-CAVE.md)
; for every Kanto cave: Mt. Moon, Rock Tunnel, Victory Road, Diglett's Cave
; and the Seafoam Islands.  66 tiles, Yellow's 128 blocks (Yellow block N ==
; metatile N) plus collision clones at $80+ for the tile-pair seals and the
; GSC warp collisions.  Generated by scripts/ct1_kanto_cave.py.
TilesetKantoCaveGFX::
INCBIN "gfx/tilesets/kanto_cave.2bpp.lz"

TilesetKantoCaveMeta::
INCBIN "data/tilesets/kanto_cave_metatiles.bin"

TilesetKantoCaveColl::
INCLUDE "data/tilesets/kanto_cave_collision.asm"
