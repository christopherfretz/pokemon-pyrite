MACRO map_attributes
;\1: map name
;\2: map id
;\3: border block
	REDEF CURRENT_MAP_ID EQUS "\2"
	DEF CURRENT_MAP_WIDTH = \2_WIDTH
	DEF CURRENT_MAP_HEIGHT = \2_HEIGHT
\1_MapAttributes::
	db \3
	db CURRENT_MAP_HEIGHT, CURRENT_MAP_WIDTH
	db BANK(\1_Blocks)
	dw \1_Blocks
	db BANK(\1_MapScripts) ; aka BANK(\1_MapEvents)
	dw \1_MapScripts
	dw \1_MapEvents
	db MAP_CONNECTIONS_\2
	; Define `MAP_CONNECTIONS_\2` after `db`ing it so that the `db`ed value
	; gets updated when subsequent `connection`s modify `MAP_CONNECTIONS_\2`.
	DEF MAP_CONNECTIONS_\2 = 0
ENDM

; Connections go in order: north, south, west, east
MACRO connection
;\1: direction
;\2: map name
;\3: map id
;\4: offset of the target map relative to the current map
;    (x offset for east/west, y offset for north/south)

	; LEGACY: Support for old connection macro
	if _NARG == 6
		connection \1, \2, \3, (\4) - (\5)
	else

		; Calculate tile offsets for source (current) and target maps
		DEF _src = 0
		DEF _tgt = (\4) + MAP_CONNECTION_PADDING_WIDTH
		if _tgt < 0
			DEF _src = -_tgt
			DEF _tgt = 0
		endc

		if "\1" === "north"
			if MAP_CONNECTIONS_{CURRENT_MAP_ID} & (NORTH | SOUTH | WEST | EAST)
				fail "Invalid order for 'connection' (must be north, south, west, east)"
			endc
			DEF MAP_CONNECTIONS_{CURRENT_MAP_ID} |= NORTH
			DEF _blk = \3_WIDTH * (\3_HEIGHT - MAP_CONNECTION_PADDING_WIDTH) + _src
			DEF _map = _tgt
			DEF _win = (\3_WIDTH + MAP_CONNECTION_PADDING_WIDTH * 2) * \3_HEIGHT + 1
			DEF _y = \3_HEIGHT * 2 - 1
			DEF _x = (\4) * -2
			DEF _len = CURRENT_MAP_WIDTH + MAP_CONNECTION_PADDING_WIDTH - (\4)
			if _len > \3_WIDTH
				DEF _len = \3_WIDTH
			endc

		elif "\1" === "south"
			if MAP_CONNECTIONS_{CURRENT_MAP_ID} & (SOUTH | WEST | EAST)
				fail "Invalid order for 'connection' (must be north, south, west, east)"
			endc
			DEF MAP_CONNECTIONS_{CURRENT_MAP_ID} |= SOUTH
			DEF _blk = _src
			DEF _map = (CURRENT_MAP_WIDTH + MAP_CONNECTION_PADDING_WIDTH * 2) * (CURRENT_MAP_HEIGHT + MAP_CONNECTION_PADDING_WIDTH) + _tgt
			DEF _win = \3_WIDTH + MAP_CONNECTION_PADDING_WIDTH * 2 + 1
			DEF _y = 0
			DEF _x = (\4) * -2
			DEF _len = CURRENT_MAP_WIDTH + MAP_CONNECTION_PADDING_WIDTH - (\4)
			if _len > \3_WIDTH
				DEF _len = \3_WIDTH
			endc

		elif "\1" === "west"
			if MAP_CONNECTIONS_{CURRENT_MAP_ID} & (WEST | EAST)
				fail "Invalid order for 'connection' (must be north, south, west, east)"
			endc
			DEF MAP_CONNECTIONS_{CURRENT_MAP_ID} |= WEST
			DEF _blk = (\3_WIDTH * _src) + \3_WIDTH - MAP_CONNECTION_PADDING_WIDTH
			DEF _map = (CURRENT_MAP_WIDTH + MAP_CONNECTION_PADDING_WIDTH * 2) * _tgt
			DEF _win = (\3_WIDTH + MAP_CONNECTION_PADDING_WIDTH * 2) * 2 - MAP_CONNECTION_PADDING_WIDTH * 2
			DEF _y = (\4) * -2
			DEF _x = \3_WIDTH * 2 - 1
			DEF _len = CURRENT_MAP_HEIGHT + MAP_CONNECTION_PADDING_WIDTH - (\4)
			if _len > \3_HEIGHT
				DEF _len = \3_HEIGHT
			endc

		elif "\1" === "east"
			if MAP_CONNECTIONS_{CURRENT_MAP_ID} & EAST
				fail "Invalid order for 'connection' (must be north, south, west, east)"
			endc
			DEF MAP_CONNECTIONS_{CURRENT_MAP_ID} |= EAST
			DEF _blk = (\3_WIDTH * _src)
			DEF _map = (CURRENT_MAP_WIDTH + MAP_CONNECTION_PADDING_WIDTH * 2) * _tgt + CURRENT_MAP_WIDTH + MAP_CONNECTION_PADDING_WIDTH
			DEF _win = \3_WIDTH + MAP_CONNECTION_PADDING_WIDTH * 2 + 1
			DEF _y = (\4) * -2
			DEF _x = 0
			DEF _len = CURRENT_MAP_HEIGHT + MAP_CONNECTION_PADDING_WIDTH - (\4)
			if _len > \3_HEIGHT
				DEF _len = \3_HEIGHT
			endc

		else
			fail "Invalid direction for 'connection'."
		endc

	map_id \3
	dw \2_Blocks + _blk
	dw wOverworldMapBlocks + _map
	db _len - _src
	db \3_WIDTH
	db _y, _x
	dw wOverworldMapBlocks + _win

	endc
ENDM


	map_attributes NewBarkTown, NEW_BARK_TOWN, $05
	connection west, Route29, ROUTE_29, 0
	connection east, Route27, ROUTE_27, 0

	map_attributes CherrygroveCity, CHERRYGROVE_CITY, $35
	connection north, Route30, ROUTE_30, 5
	connection east, Route29, ROUTE_29, 0

	map_attributes VioletCity, VIOLET_CITY, $05
	connection south, Route32, ROUTE_32, 0
	connection west, Route36, ROUTE_36, 0
	connection east, Route31, ROUTE_31, 9

	map_attributes AzaleaTown, AZALEA_TOWN, $05
	connection west, Route34, ROUTE_34, -18
	connection east, Route33, ROUTE_33, 0

	map_attributes CianwoodCity, CIANWOOD_CITY, $35
	connection east, Route41, ROUTE_41, 0

	map_attributes GoldenrodCity, GOLDENROD_CITY, $35
	connection north, Route35, ROUTE_35, 5
	connection south, Route34, ROUTE_34, 5

	map_attributes OlivineCity, OLIVINE_CITY, $35
	connection north, Route39, ROUTE_39, 5
	connection west, Route40, ROUTE_40, 9

	map_attributes EcruteakCity, ECRUTEAK_CITY, $05
	connection south, Route37, ROUTE_37, 5
	connection west, Route38, ROUTE_38, 5
	connection east, Route42, ROUTE_42, 9

	map_attributes MahoganyTown, MAHOGANY_TOWN, $71
	connection north, Route43, ROUTE_43, 0
	connection west, Route42, ROUTE_42, 0
	connection east, Route44, ROUTE_44, 0

	map_attributes LakeOfRage, LAKE_OF_RAGE, $05
	connection south, Route43, ROUTE_43, 5

	map_attributes BlackthornCity, BLACKTHORN_CITY, $71
	connection south, Route45, ROUTE_45, 0
	connection west, Route44, ROUTE_44, 9

	map_attributes SilverCaveOutside, SILVER_CAVE_OUTSIDE, $2c
	connection east, Route28, ROUTE_28, 9

	map_attributes Route26, ROUTE_26, $05
	connection west, Route27, ROUTE_27, 45

	map_attributes Route27, ROUTE_27, $35
	connection west, NewBarkTown, NEW_BARK_TOWN, 0
	connection east, Route26, ROUTE_26, -45

	map_attributes Route28, ROUTE_28, $2c
	connection west, SilverCaveOutside, SILVER_CAVE_OUTSIDE, -9

	map_attributes Route29, ROUTE_29, $05
	connection north, Route46, ROUTE_46, 10
	connection west, CherrygroveCity, CHERRYGROVE_CITY, 0
	connection east, NewBarkTown, NEW_BARK_TOWN, 0

	map_attributes Route30, ROUTE_30, $05
	connection north, Route31, ROUTE_31, -10
	connection south, CherrygroveCity, CHERRYGROVE_CITY, -5

	map_attributes Route31, ROUTE_31, $05
	connection south, Route30, ROUTE_30, 10
	connection west, VioletCity, VIOLET_CITY, -9

	map_attributes Route32, ROUTE_32, $05
	connection north, VioletCity, VIOLET_CITY, 0
	connection south, Route33, ROUTE_33, 0

	map_attributes Route33, ROUTE_33, $05
	connection north, Route32, ROUTE_32, 0
	connection west, AzaleaTown, AZALEA_TOWN, 0

	map_attributes Route34, ROUTE_34, $05
	connection north, GoldenrodCity, GOLDENROD_CITY, -5
	connection east, AzaleaTown, AZALEA_TOWN, 18

	map_attributes Route35, ROUTE_35, $05
	connection north, Route36, ROUTE_36, 0
	connection south, GoldenrodCity, GOLDENROD_CITY, -5

	map_attributes Route36, ROUTE_36, $05
	connection north, Route37, ROUTE_37, 10
	connection south, Route35, ROUTE_35, 0
	connection east, VioletCity, VIOLET_CITY, 0

	map_attributes Route37, ROUTE_37, $05
	connection north, EcruteakCity, ECRUTEAK_CITY, -5
	connection south, Route36, ROUTE_36, -10

	map_attributes Route38, ROUTE_38, $05
	connection west, Route39, ROUTE_39, 0
	connection east, EcruteakCity, ECRUTEAK_CITY, -5

	map_attributes Route39, ROUTE_39, $05
	connection south, OlivineCity, OLIVINE_CITY, -5
	connection east, Route38, ROUTE_38, 0

	map_attributes Route40, ROUTE_40, $35
	connection south, Route41, ROUTE_41, -15
	connection east, OlivineCity, OLIVINE_CITY, -9

	map_attributes Route41, ROUTE_41, $35
	connection north, Route40, ROUTE_40, 15
	connection west, CianwoodCity, CIANWOOD_CITY, 0

	map_attributes Route42, ROUTE_42, $05
	connection west, EcruteakCity, ECRUTEAK_CITY, -9
	connection east, MahoganyTown, MAHOGANY_TOWN, 0

	map_attributes Route43, ROUTE_43, $05
	connection north, LakeOfRage, LAKE_OF_RAGE, -5
	connection south, MahoganyTown, MAHOGANY_TOWN, 0

	map_attributes Route44, ROUTE_44, $71
	connection west, MahoganyTown, MAHOGANY_TOWN, 0
	connection east, BlackthornCity, BLACKTHORN_CITY, -9

	map_attributes Route45, ROUTE_45, $71
	connection north, BlackthornCity, BLACKTHORN_CITY, 0
	connection west, Route46, ROUTE_46, 36

	map_attributes Route46, ROUTE_46, $05
	connection south, Route29, ROUTE_29, -10
	connection east, Route45, ROUTE_45, -36

	map_attributes PewterCity, PEWTER_CITY, $0f
	connection south, Route2, ROUTE_2, 5
	connection east, Route3, ROUTE_3, 5

	map_attributes Route2, ROUTE_2, $0f
	connection north, PewterCity, PEWTER_CITY, -5
	connection south, ViridianCity, VIRIDIAN_CITY, -5

	map_attributes ViridianCity, VIRIDIAN_CITY, $0f
	connection north, Route2, ROUTE_2, 5
	connection south, Route1, ROUTE_1, 10
	connection west, Route22, ROUTE_22, 4

	map_attributes Route22, ROUTE_22, $2c
	connection east, ViridianCity, VIRIDIAN_CITY, -4

	map_attributes Route1, ROUTE_1, $0f
	connection north, ViridianCity, VIRIDIAN_CITY, -10
	connection south, PalletTown, PALLET_TOWN, 0

	map_attributes PalletTown, PALLET_TOWN, $0f
	connection north, Route1, ROUTE_1, 0
	connection south, Route21, ROUTE_21, 0

	map_attributes Route21, ROUTE_21, $43
	connection north, PalletTown, PALLET_TOWN, 0
	connection south, CinnabarIsland, CINNABAR_ISLAND, 0

	map_attributes CinnabarIsland, CINNABAR_ISLAND, $43
	connection north, Route21, ROUTE_21, 0
	connection east, Route20, ROUTE_20, 0

	map_attributes Route20, ROUTE_20, $43
	connection west, CinnabarIsland, CINNABAR_ISLAND, 0
	; Kanto hack (M9 12b): Yellow's own offset (Route20.asm
	; `connection east, Route19, ROUTE_19, -18`), now that ROUTE 19 is 10x27.
	connection east, Route19, ROUTE_19, -18

	map_attributes Route19, ROUTE_19, $43
	; Kanto hack (M9 12b): Yellow's own offsets (Route19.asm
	; `connection north, FuchsiaCity, FUCHSIA_CITY, -5` and
	; `connection west, Route20, ROUTE_20, 18`).  ROUTE 19 column 13 is
	; FUCHSIA column 23; ROUTE 19 row 18 is ROUTE 20 row 0.
	connection north, FuchsiaCity, FUCHSIA_CITY, -5
	connection west, Route20, ROUTE_20, 18

	map_attributes FuchsiaCity, FUCHSIA_CITY, $0f
	; Kanto hack (M9 12b): Yellow's own offset (FuchsiaCity.asm
	; `connection south, Route19, ROUTE_19, 5`), now that ROUTE 19 is 10x27.
	connection south, Route19, ROUTE_19, 5
	; Kanto hack (M6 9aa): Yellow's own offset (FuchsiaCity.asm
	; `connection west, Route18, ROUTE_18, 4`), now that ROUTE 18 is 25x9.
	connection west, Route18, ROUTE_18, 4
	; Kanto hack (M7 10e): Yellow's own offset (FuchsiaCity.asm
	; `connection east, Route15, ROUTE_15, 4`), now that ROUTE 15 is 30x9.
	connection east, Route15, ROUTE_15, 4

	map_attributes Route18, ROUTE_18, $43
	; Kanto hack (M6 9z/9aa): Yellow puts ROUTE 18 *below* ROUTE 17, not beside
	; it (Yellow's Route18 `connection north, Route17, ROUTE_17, 0`); Crystal's
	; `connection west, Route17, -38` is gone.  9aa re-cut the map to Yellow's
	; 25x9, so the FUCHSIA seam is Yellow's number too (Route18.asm
	; `connection east, FuchsiaCity, FUCHSIA_CITY, -4`).
	connection north, Route17, ROUTE_17, 0
	connection east, FuchsiaCity, FUCHSIA_CITY, -4

	map_attributes Route17, ROUTE_17, $43
	connection north, Route16, ROUTE_16, 0
	connection south, Route18, ROUTE_18, 0

	map_attributes Route16, ROUTE_16, $0f
	connection south, Route17, ROUTE_17, 0
	connection east, CeladonCity, CELADON_CITY, -4

	map_attributes CeladonCity, CELADON_CITY, $0f
	connection west, Route16, ROUTE_16, 4
	connection east, Route7, ROUTE_7, 4

	map_attributes Route7, ROUTE_7, $0f
	connection west, CeladonCity, CELADON_CITY, -4
	connection east, SaffronCity, SAFFRON_CITY, -4

; Kanto hack (M7 10e, docs/M7-FUCHSIA.md): ROUTE 15 re-cut to Yellow's 30x9.
; Border block $43 is Yellow's own (vendor/pokeyellow/data/maps/objects/Route15.asm
; `db $43`), the same one ROUTE 13 and ROUTE 14 already use; $0f was Crystal's.
	map_attributes Route15, ROUTE_15, $43
	connection west, FuchsiaCity, FUCHSIA_CITY, -4 ; Kanto hack (M7 10e): was -9; Yellow's vendor/pokeyellow/data/maps/headers/Route15.asm says -4
	connection east, Route14, ROUTE_14, -18 ; Kanto hack (M7 10d): reciprocal of ROUTE 14's west 18 (Yellow's own value); ROUTE 15's own re-cut is 10e

; Kanto hack (M7 10c, docs/M7-FUCHSIA.md): Yellow's ROUTE 13 runs EAST-WEST and
; hands off to ROUTE 14 through its WEST edge, not its south one --
; vendor/pokeyellow/data/maps/headers/Route13.asm is "north Route12 20 / west
; Route14 0".  Crystal had ROUTE 13 stacked above ROUTE 14, so both sides of
; that seam are re-pointed here.  The ROUTE 14 side is the minimal reciprocal
; edit only (10d owns ROUTE 14's own re-cut); note Yellow says "west Route15 18"
; where we still carry 9, left over from before 10a resized ROUTE_14 to 10x27
; and ROUTE_15 to 30x9 -- 10d must fix that offset with the re-cut.
	map_attributes Route14, ROUTE_14, $43
	connection west, Route15, ROUTE_15, 18 ; Kanto hack (M7 10d): was 9, the middle-of-map row 10a left behind; Yellow's vendor/pokeyellow/data/maps/headers/Route14.asm says 18
	connection east, Route13, ROUTE_13, 0 ; Kanto hack (M7 10c): was "north Route13 0"

	map_attributes Route13, ROUTE_13, $43
	connection north, Route12, ROUTE_12, 20
	connection west, Route14, ROUTE_14, 0 ; Kanto hack (M7 10c): was "south Route14 0"

; Kanto hack (M5 8l): ROUTE 12 is Yellow's full 10x54 now, not Crystal's 10x27
; northern half, so the Route 11 seam moves to Yellow's own y-offset --
; vendor/pokeyellow/data/maps/headers/Route12.asm says west Route11 27, i.e.
; Route 11's block row 0 sits at Route 12's block row 27, which puts Route 11's
; east opening at Route 12 tile rows 62/63 -- exactly the SNORLAX junction.
; The north (Lavender, 0) and south (Route 13, -20) offsets are Yellow's
; already and are deliberately untouched.
	map_attributes Route12, ROUTE_12, $43
	connection north, LavenderTown, LAVENDER_TOWN, 0
	connection south, Route13, ROUTE_13, -20
	connection west, Route11, ROUTE_11, 27

; Kanto hack: Vermilion, Routes 5/6/11 re-cut from Yellow (docs/M4-VERMILION.md,
; 7b).  Route 11 is 30x9 now and meets Vermilion City four blocks down its east
; edge -- Yellow's own offsets (headers/Route11.asm, headers/VermilionCity.asm),
; transferred unchanged the way M3 did for Cerulean.  (M5 8l: the Route 12
; y-offset IS Yellow's now too -- see the Route 12 block above.)
	map_attributes Route11, ROUTE_11, $0f
	connection west, VermilionCity, VERMILION_CITY, -4
	connection east, Route12, ROUTE_12, -27 ; Kanto hack (M5 8l): Yellow's own offset, was -9 while ROUTE_12 was half-height

	map_attributes LavenderTown, LAVENDER_TOWN, $90
	connection north, Route10, ROUTE_10, 0
	connection south, Route12, ROUTE_12, 0
	connection west, Route8, ROUTE_8, 0

	map_attributes VermilionCity, VERMILION_CITY, $43
	connection north, Route6, ROUTE_6, 5
	connection east, Route11, ROUTE_11, 4

	map_attributes Route6, ROUTE_6, $0f
	connection north, SaffronCity, SAFFRON_CITY, -5
	connection south, VermilionCity, VERMILION_CITY, -5

	map_attributes SaffronCity, SAFFRON_CITY, $0f
	connection north, Route5, ROUTE_5, 5
	connection south, Route6, ROUTE_6, 5
	connection west, Route7, ROUTE_7, 4
	connection east, Route8, ROUTE_8, 4

	map_attributes Route5, ROUTE_5, $0f
	connection north, CeruleanCity, CERULEAN_CITY, -5
	connection south, SaffronCity, SAFFRON_CITY, -5

; Kanto hack: Cerulean, Routes 24/25 re-cut from Yellow (docs/M3-CERULEAN.md,
; 6a).  Every offset below is Yellow's own.  Route 24 is now 10x18 and meets
; Route 25 east/west, not north/south, and the Route 4 offset is -4, not -5 --
; that is what puts Route 4's east plateau (Lass TAMARA) back in reach.
	map_attributes CeruleanCity, CERULEAN_CITY, $0f
	connection north, Route24, ROUTE_24, 5
	connection south, Route5, ROUTE_5, 5
	connection west, Route4, ROUTE_4, 4
	connection east, Route9, ROUTE_9, 4

	map_attributes Route9, ROUTE_9, $90
	connection west, CeruleanCity, CERULEAN_CITY, -4
	connection east, Route10, ROUTE_10, 0

	map_attributes Route24, ROUTE_24, $90
	connection south, CeruleanCity, CERULEAN_CITY, -5
	connection east, Route25, ROUTE_25, 0

	map_attributes Route25, ROUTE_25, $90
	connection west, Route24, ROUTE_24, 0

	map_attributes Route3, ROUTE_3, $94
	connection north, Route4, ROUTE_4, 25
	connection west, PewterCity, PEWTER_CITY, -5

	map_attributes Route4, ROUTE_4, $94
	connection south, Route3, ROUTE_3, -25
	connection east, CeruleanCity, CERULEAN_CITY, -4

	map_attributes Route8, ROUTE_8, $90
	connection west, SaffronCity, SAFFRON_CITY, -4
	connection east, LavenderTown, LAVENDER_TOWN, 0

	map_attributes Route10, ROUTE_10, $90
	connection south, LavenderTown, LAVENDER_TOWN, 0
	connection west, Route9, ROUTE_9, 0

	map_attributes Route23, ROUTE_23, $0f
	map_attributes SproutTower1F, SPROUT_TOWER_1F, $00
	map_attributes SproutTower2F, SPROUT_TOWER_2F, $00
	map_attributes SproutTower3F, SPROUT_TOWER_3F, $00
	map_attributes TinTower1F, TIN_TOWER_1F, $00
	map_attributes TinTower2F, TIN_TOWER_2F, $00
	map_attributes TinTower3F, TIN_TOWER_3F, $00
	map_attributes TinTower4F, TIN_TOWER_4F, $00
	map_attributes TinTower5F, TIN_TOWER_5F, $00
	map_attributes TinTower6F, TIN_TOWER_6F, $00
	map_attributes TinTower7F, TIN_TOWER_7F, $00
	map_attributes TinTower8F, TIN_TOWER_8F, $00
	map_attributes TinTower9F, TIN_TOWER_9F, $00
	map_attributes BurnedTower1F, BURNED_TOWER_1F, $00
	map_attributes BurnedTowerB1F, BURNED_TOWER_B1F, $09
	map_attributes NationalPark, NATIONAL_PARK, $00
	map_attributes NationalParkBugContest, NATIONAL_PARK_BUG_CONTEST, $00
	map_attributes RadioTower1F, RADIO_TOWER_1F, $00
	map_attributes RadioTower2F, RADIO_TOWER_2F, $00
	map_attributes RadioTower3F, RADIO_TOWER_3F, $00
	map_attributes RadioTower4F, RADIO_TOWER_4F, $00
	map_attributes RadioTower5F, RADIO_TOWER_5F, $00
	map_attributes RuinsOfAlphOutside, RUINS_OF_ALPH_OUTSIDE, $05
	map_attributes RuinsOfAlphHoOhChamber, RUINS_OF_ALPH_HO_OH_CHAMBER, $00
	map_attributes RuinsOfAlphKabutoChamber, RUINS_OF_ALPH_KABUTO_CHAMBER, $00
	map_attributes RuinsOfAlphOmanyteChamber, RUINS_OF_ALPH_OMANYTE_CHAMBER, $00
	map_attributes RuinsOfAlphAerodactylChamber, RUINS_OF_ALPH_AERODACTYL_CHAMBER, $00
	map_attributes RuinsOfAlphInnerChamber, RUINS_OF_ALPH_INNER_CHAMBER, $00
	map_attributes RuinsOfAlphResearchCenter, RUINS_OF_ALPH_RESEARCH_CENTER, $00
	map_attributes RuinsOfAlphHoOhItemRoom, RUINS_OF_ALPH_HO_OH_ITEM_ROOM, $00
	map_attributes RuinsOfAlphKabutoItemRoom, RUINS_OF_ALPH_KABUTO_ITEM_ROOM, $00
	map_attributes RuinsOfAlphOmanyteItemRoom, RUINS_OF_ALPH_OMANYTE_ITEM_ROOM, $00
	map_attributes RuinsOfAlphAerodactylItemRoom, RUINS_OF_ALPH_AERODACTYL_ITEM_ROOM, $00
	map_attributes RuinsOfAlphHoOhWordRoom, RUINS_OF_ALPH_HO_OH_WORD_ROOM, $00
	map_attributes RuinsOfAlphKabutoWordRoom, RUINS_OF_ALPH_KABUTO_WORD_ROOM, $00
	map_attributes RuinsOfAlphOmanyteWordRoom, RUINS_OF_ALPH_OMANYTE_WORD_ROOM, $00
	map_attributes RuinsOfAlphAerodactylWordRoom, RUINS_OF_ALPH_AERODACTYL_WORD_ROOM, $00
	map_attributes UnionCave1F, UNION_CAVE_1F, $09
	map_attributes UnionCaveB1F, UNION_CAVE_B1F, $09
	map_attributes UnionCaveB2F, UNION_CAVE_B2F, $09
	map_attributes SlowpokeWellB1F, SLOWPOKE_WELL_B1F, $09
	map_attributes SlowpokeWellB2F, SLOWPOKE_WELL_B2F, $09
	map_attributes OlivineLighthouse1F, OLIVINE_LIGHTHOUSE_1F, $00
	map_attributes OlivineLighthouse2F, OLIVINE_LIGHTHOUSE_2F, $00
	map_attributes OlivineLighthouse3F, OLIVINE_LIGHTHOUSE_3F, $00
	map_attributes OlivineLighthouse4F, OLIVINE_LIGHTHOUSE_4F, $00
	map_attributes OlivineLighthouse5F, OLIVINE_LIGHTHOUSE_5F, $00
	map_attributes OlivineLighthouse6F, OLIVINE_LIGHTHOUSE_6F, $00
	map_attributes MahoganyMart1F, MAHOGANY_MART_1F, $00
	map_attributes TeamRocketBaseB1F, TEAM_ROCKET_BASE_B1F, $00
	map_attributes TeamRocketBaseB2F, TEAM_ROCKET_BASE_B2F, $00
	map_attributes TeamRocketBaseB3F, TEAM_ROCKET_BASE_B3F, $00
	map_attributes IlexForest, ILEX_FOREST, $05
	map_attributes GoldenrodUnderground, GOLDENROD_UNDERGROUND, $00
	map_attributes GoldenrodUndergroundSwitchRoomEntrances, GOLDENROD_UNDERGROUND_SWITCH_ROOM_ENTRANCES, $00
	map_attributes GoldenrodDeptStoreB1F, GOLDENROD_DEPT_STORE_B1F, $00
	map_attributes GoldenrodUndergroundWarehouse, GOLDENROD_UNDERGROUND_WAREHOUSE, $00
	map_attributes MountMortar1FOutside, MOUNT_MORTAR_1F_OUTSIDE, $09
	map_attributes MountMortar1FInside, MOUNT_MORTAR_1F_INSIDE, $09
	map_attributes MountMortar2FInside, MOUNT_MORTAR_2F_INSIDE, $09
	map_attributes MountMortarB1F, MOUNT_MORTAR_B1F, $09
	map_attributes IcePath1F, ICE_PATH_1F, $09
	map_attributes IcePathB1F, ICE_PATH_B1F, $19
	map_attributes IcePathB2FMahoganySide, ICE_PATH_B2F_MAHOGANY_SIDE, $19
	map_attributes IcePathB2FBlackthornSide, ICE_PATH_B2F_BLACKTHORN_SIDE, $19
	map_attributes IcePathB3F, ICE_PATH_B3F, $19
	map_attributes WhirlIslandNW, WHIRL_ISLAND_NW, $09
	map_attributes WhirlIslandNE, WHIRL_ISLAND_NE, $09
	map_attributes WhirlIslandSW, WHIRL_ISLAND_SW, $09
	map_attributes WhirlIslandCave, WHIRL_ISLAND_CAVE, $09
	map_attributes WhirlIslandSE, WHIRL_ISLAND_SE, $0f
	map_attributes WhirlIslandB1F, WHIRL_ISLAND_B1F, $09
	map_attributes WhirlIslandB2F, WHIRL_ISLAND_B2F, $2e
	map_attributes WhirlIslandLugiaChamber, WHIRL_ISLAND_LUGIA_CHAMBER, $0f
	map_attributes SilverCaveRoom1, SILVER_CAVE_ROOM_1, $09
	map_attributes SilverCaveRoom2, SILVER_CAVE_ROOM_2, $09
	map_attributes SilverCaveRoom3, SILVER_CAVE_ROOM_3, $09
	map_attributes SilverCaveItemRooms, SILVER_CAVE_ITEM_ROOMS, $09
	map_attributes DarkCaveVioletEntrance, DARK_CAVE_VIOLET_ENTRANCE, $09
	map_attributes DarkCaveBlackthornEntrance, DARK_CAVE_BLACKTHORN_ENTRANCE, $09
	map_attributes DragonsDen1F, DRAGONS_DEN_1F, $09
	map_attributes DragonsDenB1F, DRAGONS_DEN_B1F, $71
	map_attributes DragonShrine, DRAGON_SHRINE, $00
	map_attributes TohjoFalls, TOHJO_FALLS, $09
	map_attributes OlivinePokecenter1F, OLIVINE_POKECENTER_1F, $00
	map_attributes OlivineGym, OLIVINE_GYM, $00
	map_attributes OlivineTimsHouse, OLIVINE_TIMS_HOUSE, $00
	map_attributes OlivineHouseBeta, OLIVINE_HOUSE_BETA, $00
	map_attributes OlivinePunishmentSpeechHouse, OLIVINE_PUNISHMENT_SPEECH_HOUSE, $00
	map_attributes OlivineGoodRodHouse, OLIVINE_GOOD_ROD_HOUSE, $00
	map_attributes OlivineCafe, OLIVINE_CAFE, $00
	map_attributes OlivineMart, OLIVINE_MART, $00
	map_attributes Route38EcruteakGate, ROUTE_38_ECRUTEAK_GATE, $00
	map_attributes Route39Barn, ROUTE_39_BARN, $00
	map_attributes Route39Farmhouse, ROUTE_39_FARMHOUSE, $00
	map_attributes MahoganyRedGyaradosSpeechHouse, MAHOGANY_RED_GYARADOS_SPEECH_HOUSE, $00
	map_attributes MahoganyGym, MAHOGANY_GYM, $00
	map_attributes MahoganyPokecenter1F, MAHOGANY_POKECENTER_1F, $00
	map_attributes Route42EcruteakGate, ROUTE_42_ECRUTEAK_GATE, $00
	map_attributes DiglettsCave, DIGLETTS_CAVE, $09
	map_attributes UndergroundPath, UNDERGROUND_PATH, $00

	map_attributes UndergroundPathWestEast, UNDERGROUND_PATH_WEST_EAST, $01
	map_attributes RockTunnel1F, ROCK_TUNNEL_1F, $2e
	map_attributes RockTunnelB1F, ROCK_TUNNEL_B1F, $2e
	map_attributes SafariZoneFuchsiaGateBeta, SAFARI_ZONE_FUCHSIA_GATE_BETA, $00
	map_attributes SafariZoneBeta, SAFARI_ZONE_BETA, $13
	map_attributes VictoryRoad, VICTORY_ROAD, $1d
	map_attributes MtMoon1F, MT_MOON_1F, $01
	map_attributes MtMoonB1F, MT_MOON_B1F, $01
	map_attributes MtMoonB2F, MT_MOON_B2F, $01
	map_attributes EcruteakTinTowerEntrance, ECRUTEAK_TIN_TOWER_ENTRANCE, $00
	map_attributes WiseTriosRoom, WISE_TRIOS_ROOM, $00
	map_attributes EcruteakPokecenter1F, ECRUTEAK_POKECENTER_1F, $00
	map_attributes EcruteakLugiaSpeechHouse, ECRUTEAK_LUGIA_SPEECH_HOUSE, $00
	map_attributes DanceTheater, DANCE_THEATER, $00
	map_attributes EcruteakMart, ECRUTEAK_MART, $00
	map_attributes EcruteakGym, ECRUTEAK_GYM, $00
	map_attributes EcruteakItemfinderHouse, ECRUTEAK_ITEMFINDER_HOUSE, $00
	map_attributes BlackthornGym1F, BLACKTHORN_GYM_1F, $00
	map_attributes BlackthornGym2F, BLACKTHORN_GYM_2F, $00
	map_attributes BlackthornDragonSpeechHouse, BLACKTHORN_DRAGON_SPEECH_HOUSE, $00
	map_attributes BlackthornEmysHouse, BLACKTHORN_EMYS_HOUSE, $00
	map_attributes BlackthornMart, BLACKTHORN_MART, $00
	map_attributes BlackthornPokecenter1F, BLACKTHORN_POKECENTER_1F, $00
	map_attributes MoveDeletersHouse, MOVE_DELETERS_HOUSE, $00
	map_attributes CinnabarPokecenter1F, CINNABAR_POKECENTER_1F, $00
	map_attributes CinnabarPokecenter2FBeta, CINNABAR_POKECENTER_2F_BETA, $00
	map_attributes Route19FuchsiaGate, ROUTE_19_FUCHSIA_GATE, $0a
	map_attributes SeafoamGym, SEAFOAM_GYM, $09
; Kanto hack (M9 12a): Yellow's CINNABAR arc.  Borders follow the nearest
; precedent -- $2e is SilphCo2F's TILESET_KANTO_FACILITY wall, $00 is the plain
; indoor border every Kanto house/mart/centre uses.  No connections: all
; fifteen are indoor maps.
; 12d: the Seafoam floors take Yellow's own border, cavern block $7d (a 2x2
; boulder field), whose exact TILESET_CAVE twin is metatile $1d.
	map_attributes SeafoamIslands1F, SEAFOAM_ISLANDS_1F, $1d
	map_attributes SeafoamIslandsB1F, SEAFOAM_ISLANDS_B1F, $1d
	map_attributes SeafoamIslandsB2F, SEAFOAM_ISLANDS_B2F, $1d
	map_attributes SeafoamIslandsB3F, SEAFOAM_ISLANDS_B3F, $1d
	map_attributes SeafoamIslandsB4F, SEAFOAM_ISLANDS_B4F, $1d
	map_attributes CinnabarMart, CINNABAR_MART, $00
; 12i: the four LAB maps take Yellow's own border, block $17 (`db $17 ; border
; block` in all four of vendor/pokeyellow/data/maps/objects/CinnabarLab*.asm) --
; a 2x2 of the LAB wall tile $36, which TILESET_KANTO_LAB carries at the same
; index because kanto_lab_metatiles.bin IS lab.bst.
	map_attributes CinnabarLab, CINNABAR_LAB, $17
	map_attributes CinnabarLabTradeRoom, CINNABAR_LAB_TRADE_ROOM, $17
	map_attributes CinnabarLabMetronomeRoom, CINNABAR_LAB_METRONOME_ROOM, $17
	map_attributes CinnabarLabFossilRoom, CINNABAR_LAB_FOSSIL_ROOM, $17
	map_attributes PokemonMansion1F, POKEMON_MANSION_1F, $2e
	map_attributes PokemonMansion2F, POKEMON_MANSION_2F, $01
	map_attributes PokemonMansion3F, POKEMON_MANSION_3F, $01
	map_attributes PokemonMansionB1F, POKEMON_MANSION_B1F, $01
	map_attributes CinnabarGym, CINNABAR_GYM, $2e
	map_attributes CeruleanTrashedHouse, CERULEAN_TRASHED_HOUSE, $00
	map_attributes CeruleanMelaniesHouse, CERULEAN_MELANIES_HOUSE, $00
	map_attributes BikeShop, BIKE_SHOP, $00
	map_attributes CeruleanBadgeHouse, CERULEAN_BADGE_HOUSE, $00
	map_attributes CeruleanCave1F, CERULEAN_CAVE_1F, $01
	map_attributes CeruleanPokecenter1F, CERULEAN_POKECENTER_1F, $00
	map_attributes CeruleanPokecenter2FBeta, CERULEAN_POKECENTER_2F_BETA, $00
	map_attributes CeruleanGym, CERULEAN_GYM, $00
	map_attributes CeruleanMart, CERULEAN_MART, $00
	map_attributes Route10Pokecenter1F, ROUTE_10_POKECENTER_1F, $00
	map_attributes Route10Pokecenter2FBeta, ROUTE_10_POKECENTER_2F_BETA, $00
	map_attributes PowerPlant, POWER_PLANT, $00
	map_attributes BillsHouse, BILLS_HOUSE, $00
	map_attributes AzaleaPokecenter1F, AZALEA_POKECENTER_1F, $00
	map_attributes CharcoalKiln, CHARCOAL_KILN, $00
	map_attributes AzaleaMart, AZALEA_MART, $00
	map_attributes KurtsHouse, KURTS_HOUSE, $00
	map_attributes AzaleaGym, AZALEA_GYM, $00
	map_attributes LakeOfRageHiddenPowerHouse, LAKE_OF_RAGE_HIDDEN_POWER_HOUSE, $00
	map_attributes LakeOfRageMagikarpHouse, LAKE_OF_RAGE_MAGIKARP_HOUSE, $00
	map_attributes Route43MahoganyGate, ROUTE_43_MAHOGANY_GATE, $00
	map_attributes Route43Gate, ROUTE_43_GATE, $00
	map_attributes VioletMart, VIOLET_MART, $00
	map_attributes VioletGym, VIOLET_GYM, $00
	map_attributes EarlsPokemonAcademy, EARLS_POKEMON_ACADEMY, $00
	map_attributes VioletNicknameSpeechHouse, VIOLET_NICKNAME_SPEECH_HOUSE, $00
	map_attributes VioletPokecenter1F, VIOLET_POKECENTER_1F, $00
	map_attributes VioletKylesHouse, VIOLET_KYLES_HOUSE, $00
	map_attributes Route32RuinsOfAlphGate, ROUTE_32_RUINS_OF_ALPH_GATE, $00
	map_attributes Route32Pokecenter1F, ROUTE_32_POKECENTER_1F, $00
	map_attributes MtMoonPokecenter, MT_MOON_POKECENTER, $00
	map_attributes Route35GoldenrodGate, ROUTE_35_GOLDENROD_GATE, $00
	map_attributes Route35NationalParkGate, ROUTE_35_NATIONAL_PARK_GATE, $00
	map_attributes Route36RuinsOfAlphGate, ROUTE_36_RUINS_OF_ALPH_GATE, $00
	map_attributes Route36NationalParkGate, ROUTE_36_NATIONAL_PARK_GATE, $00
	map_attributes GoldenrodGym, GOLDENROD_GYM, $00
	map_attributes GoldenrodBikeShop, GOLDENROD_BIKE_SHOP, $00
	map_attributes GoldenrodHappinessRater, GOLDENROD_HAPPINESS_RATER, $00
	map_attributes BillsFamilysHouse, BILLS_FAMILYS_HOUSE, $00
	map_attributes GoldenrodMagnetTrainStation, GOLDENROD_MAGNET_TRAIN_STATION, $00
	map_attributes GoldenrodFlowerShop, GOLDENROD_FLOWER_SHOP, $00
	map_attributes GoldenrodPPSpeechHouse, GOLDENROD_PP_SPEECH_HOUSE, $00
	map_attributes GoldenrodNameRater, GOLDENROD_NAME_RATER, $00
	map_attributes GoldenrodDeptStore1F, GOLDENROD_DEPT_STORE_1F, $00
	map_attributes GoldenrodDeptStore2F, GOLDENROD_DEPT_STORE_2F, $00
	map_attributes GoldenrodDeptStore3F, GOLDENROD_DEPT_STORE_3F, $00
	map_attributes GoldenrodDeptStore4F, GOLDENROD_DEPT_STORE_4F, $00
	map_attributes GoldenrodDeptStore5F, GOLDENROD_DEPT_STORE_5F, $00
	map_attributes GoldenrodDeptStore6F, GOLDENROD_DEPT_STORE_6F, $00
	map_attributes GoldenrodDeptStoreElevator, GOLDENROD_DEPT_STORE_ELEVATOR, $00
	map_attributes GoldenrodDeptStoreRoof, GOLDENROD_DEPT_STORE_ROOF, $24
	map_attributes GoldenrodGameCorner, GOLDENROD_GAME_CORNER, $00
	map_attributes GoldenrodPokecenter1F, GOLDENROD_POKECENTER_1F, $00
	map_attributes PokecomCenterAdminOfficeMobile, POKECOM_CENTER_ADMIN_OFFICE_MOBILE, $00
	map_attributes IlexForestAzaleaGate, ILEX_FOREST_AZALEA_GATE, $00
	map_attributes Route34IlexForestGate, ROUTE_34_ILEX_FOREST_GATE, $00
	map_attributes DayCare, DAY_CARE, $00
	map_attributes VermilionPidgeyHouse, VERMILION_PIDGEY_HOUSE, $00
	map_attributes VermilionPokecenter1F, VERMILION_POKECENTER_1F, $00
	map_attributes VermilionPokecenter2FBeta, VERMILION_POKECENTER_2F_BETA, $00
	map_attributes PokemonFanClub, POKEMON_FAN_CLUB, $00
	map_attributes VermilionTradeHouse, VERMILION_TRADE_HOUSE, $00
	map_attributes VermilionMart, VERMILION_MART, $00
	map_attributes VermilionOldRodHouse, VERMILION_OLD_ROD_HOUSE, $00
	map_attributes VermilionGym, VERMILION_GYM, $00
	map_attributes Route6SaffronGate, ROUTE_6_SAFFRON_GATE, $0a
	map_attributes Route6UndergroundPathEntrance, ROUTE_6_UNDERGROUND_PATH_ENTRANCE, $0a

	map_attributes Route7UndergroundPathEntrance, ROUTE_7_UNDERGROUND_PATH_ENTRANCE, $0a
; Kanto hack (M6 9o): Yellow's nine missing CELADON interiors.  Border blocks
; are Yellow's own for the FACILITY floors ($2e, its solid black surround) and
; the two gate 2Fs ($0a, the same block Route16Gate already uses); the three
; Crystal-tileset rooms take the ordinary indoor $00.
	map_attributes RocketHideoutB1F, ROCKET_HIDEOUT_B1F, $2e
	map_attributes RocketHideoutB2F, ROCKET_HIDEOUT_B2F, $2e
	map_attributes RocketHideoutB3F, ROCKET_HIDEOUT_B3F, $2e
	map_attributes RocketHideoutB4F, ROCKET_HIDEOUT_B4F, $2e
	map_attributes RocketHideoutElevator, ROCKET_HIDEOUT_ELEVATOR, $00
	map_attributes CeladonChiefHouse, CELADON_CHIEF_HOUSE, $0a
	map_attributes CeladonHotel, CELADON_HOTEL, $00
	map_attributes Route16Gate2F, ROUTE_16_GATE_2F, $0a
	map_attributes Route18Gate2F, ROUTE_18_GATE_2F, $0a

	map_attributes Route8UndergroundPathEntrance, ROUTE_8_UNDERGROUND_PATH_ENTRANCE, $0a
	map_attributes Route11Gate1F, ROUTE_11_GATE_1F, $0a
	map_attributes Route11Gate2F, ROUTE_11_GATE_2F, $0a
	map_attributes Route12Gate1F, ROUTE_12_GATE_1F, $0a ; Kanto hack (M5 8l)
	map_attributes Route12Gate2F, ROUTE_12_GATE_2F, $0a ; Kanto hack (M5 8l)
	map_attributes DiglettsCaveRoute11, DIGLETTS_CAVE_ROUTE_11, $1d ; Kanto hack (M4 audit): Yellow's $7d, vendor/pokeyellow/data/maps/objects/DiglettsCaveRoute11.asm
	map_attributes RedsHouse1F, REDS_HOUSE_1F, $00
	map_attributes RedsHouse2F, REDS_HOUSE_2F, $00
	map_attributes BluesHouse, BLUES_HOUSE, $00
	map_attributes OaksLab, OAKS_LAB, $00
	map_attributes PewterNidoranSpeechHouse, PEWTER_NIDORAN_SPEECH_HOUSE, $00
	map_attributes PewterGym, PEWTER_GYM, $00
	map_attributes PewterMart, PEWTER_MART, $00
	map_attributes PewterPokecenter1F, PEWTER_POKECENTER_1F, $00
	map_attributes PewterPokecenter2FBeta, PEWTER_POKECENTER_2F_BETA, $00
	map_attributes PewterSnoozeSpeechHouse, PEWTER_SNOOZE_SPEECH_HOUSE, $00
	map_attributes Museum1F, MUSEUM_1F, $0a
	map_attributes Museum2F, MUSEUM_2F, $0a
	map_attributes OlivinePort, OLIVINE_PORT, $0a
	map_attributes VermilionPort, VERMILION_PORT, $0f
	map_attributes FastShip1F, FAST_SHIP_1F, $00
	map_attributes FastShipCabins_NNW_NNE_NE, FAST_SHIP_CABINS_NNW_NNE_NE, $00
	map_attributes FastShipCabins_SW_SSW_NW, FAST_SHIP_CABINS_SW_SSW_NW, $00
	map_attributes FastShipCabins_SE_SSE_CaptainsCabin, FAST_SHIP_CABINS_SE_SSE_CAPTAINS_CABIN, $00
	map_attributes FastShipB1F, FAST_SHIP_B1F, $00
	map_attributes OlivinePortPassage, OLIVINE_PORT_PASSAGE, $00
	map_attributes TinTowerRoof, TIN_TOWER_ROOF, $00
	map_attributes SSAnne1F, SS_ANNE_1F, $0c
	map_attributes SSAnne2F, SS_ANNE_2F, $0c
	map_attributes SSAnne3F, SS_ANNE_3F, $0c
	map_attributes SSAnneB1F, SS_ANNE_B1F, $0c
	map_attributes SSAnneBow, SS_ANNE_BOW, $23 ; Kanto hack (M4 audit): Yellow's open-sea border, vendor/pokeyellow/data/maps/objects/SSAnneBow.asm
	map_attributes SSAnneKitchen, SS_ANNE_KITCHEN, $0c
	map_attributes SSAnneCaptainsRoom, SS_ANNE_CAPTAINS_ROOM, $0c
	map_attributes SSAnne1FRooms, SS_ANNE_1F_ROOMS, $0c
	map_attributes SSAnne2FRooms, SS_ANNE_2F_ROOMS, $0c
	map_attributes SSAnneB1FRooms, SS_ANNE_B1F_ROOMS, $0c
	map_attributes IndigoPlateauPokecenter1F, INDIGO_PLATEAU_POKECENTER_1F, $00
	map_attributes WillsRoom, WILLS_ROOM, $00
	map_attributes KogasRoom, KOGAS_ROOM, $00
	map_attributes BrunosRoom, BRUNOS_ROOM, $00
	map_attributes KarensRoom, KARENS_ROOM, $00
	map_attributes LancesRoom, LANCES_ROOM, $00
	map_attributes HallOfFame, HALL_OF_FAME, $00
	map_attributes FuchsiaMart, FUCHSIA_MART, $00
	map_attributes FuchsiaMeetingRoom, FUCHSIA_MEETING_ROOM, $00
	map_attributes FuchsiaGym, FUCHSIA_GYM, $00
	map_attributes BillsOlderSistersHouse, BILLS_OLDER_SISTERS_HOUSE, $00
	map_attributes FuchsiaPokecenter1F, FUCHSIA_POKECENTER_1F, $00
	map_attributes FuchsiaPokecenter2FBeta, FUCHSIA_POKECENTER_2F_BETA, $00
	map_attributes SafariZoneWardensHome, SAFARI_ZONE_WARDENS_HOME, $00
	map_attributes Route15FuchsiaGate, ROUTE_15_FUCHSIA_GATE, $0a
; Kanto hack (M7 10a, docs/M7-FUCHSIA.md): the SAFARI ZONE and FUCHSIA's last
; Yellow interiors.  Border blocks are real blocks of each map's own tileset, not
; $00: the gate rooms and rest houses take $0a (what Route15FuchsiaGate above
; uses, and Yellow's own border for all of them), the four outdoor areas take
; $0f (ViridianForest's, the other TILESET_KANTO map whose edge is solid trees).
; No connections: the areas are joined by warps in Yellow, not by map seams.
	map_attributes Route15Gate2F, ROUTE_15_GATE_2F, $0a
	map_attributes FuchsiaGoodRodHouse, FUCHSIA_GOOD_ROD_HOUSE, $0c ; Kanto hack (M7 10g): Yellow's own border (db $c) on the SHIP tileset
	map_attributes SafariZoneGate, SAFARI_ZONE_GATE, $0a
	map_attributes SafariZoneEast, SAFARI_ZONE_EAST, $0f
	map_attributes SafariZoneNorth, SAFARI_ZONE_NORTH, $0f
	map_attributes SafariZoneWest, SAFARI_ZONE_WEST, $0f
	map_attributes SafariZoneCenter, SAFARI_ZONE_CENTER, $0f
	map_attributes SafariZoneCenterRestHouse, SAFARI_ZONE_CENTER_REST_HOUSE, $0a
	map_attributes SafariZoneSecretHouse, SAFARI_ZONE_SECRET_HOUSE, $00
	map_attributes SafariZoneWestRestHouse, SAFARI_ZONE_WEST_REST_HOUSE, $0a
	map_attributes SafariZoneEastRestHouse, SAFARI_ZONE_EAST_REST_HOUSE, $0a
	map_attributes SafariZoneNorthRestHouse, SAFARI_ZONE_NORTH_REST_HOUSE, $0a
	map_attributes LavenderPokecenter1F, LAVENDER_POKECENTER_1F, $00
	map_attributes LavenderPokecenter2FBeta, LAVENDER_POKECENTER_2F_BETA, $00
	map_attributes MrFujisHouse, MR_FUJIS_HOUSE, $0a
	map_attributes LavenderCuboneHouse, LAVENDER_CUBONE_HOUSE, $0a
	map_attributes LavenderNameRater, LAVENDER_NAME_RATER, $0a
	map_attributes LavenderMart, LAVENDER_MART, $00
	map_attributes SoulHouse, SOUL_HOUSE, $0a
	map_attributes PokemonTower1F, POKEMON_TOWER_1F, $01
; Kanto hack (docs/M6-TOWER.md, 9a): POKéMON TOWER 2F-7F.  Border block $01 on
; every floor, exactly as Yellow's `db $1 ; border block`
; (vendor/pokeyellow/data/maps/objects/PokemonTower{2..7}F.asm), and no
; connections -- the Tower is reached only by its warps.
	map_attributes PokemonTower2F, POKEMON_TOWER_2F, $01
	map_attributes PokemonTower3F, POKEMON_TOWER_3F, $01
	map_attributes PokemonTower4F, POKEMON_TOWER_4F, $01
	map_attributes PokemonTower5F, POKEMON_TOWER_5F, $01
	map_attributes PokemonTower6F, POKEMON_TOWER_6F, $01
	map_attributes PokemonTower7F, POKEMON_TOWER_7F, $01
	map_attributes Route8SaffronGate, ROUTE_8_SAFFRON_GATE, $0a
	map_attributes Route12SuperRodHouse, ROUTE_12_SUPER_ROD_HOUSE, $0a
	map_attributes SilverCavePokecenter1F, SILVER_CAVE_POKECENTER_1F, $00
	map_attributes Route28SteelWingHouse, ROUTE_28_STEEL_WING_HOUSE, $00
	map_attributes Pokecenter2F, POKECENTER_2F, $00
	map_attributes TradeCenter, TRADE_CENTER, $00
	map_attributes Colosseum, COLOSSEUM, $00
	map_attributes TimeCapsule, TIME_CAPSULE, $00
	map_attributes MobileTradeRoom, MOBILE_TRADE_ROOM, $00
	map_attributes MobileBattleRoom, MOBILE_BATTLE_ROOM, $00
	map_attributes CeladonDeptStore1F, CELADON_DEPT_STORE_1F, $00
	map_attributes CeladonDeptStore2F, CELADON_DEPT_STORE_2F, $00
	map_attributes CeladonDeptStore3F, CELADON_DEPT_STORE_3F, $00
	map_attributes CeladonDeptStore4F, CELADON_DEPT_STORE_4F, $00
	map_attributes CeladonDeptStore5F, CELADON_DEPT_STORE_5F, $00
	map_attributes CeladonDeptStore6F, CELADON_DEPT_STORE_6F, $00
	map_attributes CeladonDeptStoreElevator, CELADON_DEPT_STORE_ELEVATOR, $00
	map_attributes CeladonMansion1F, CELADON_MANSION_1F, $00
	map_attributes CeladonMansion2F, CELADON_MANSION_2F, $00
	map_attributes CeladonMansion3F, CELADON_MANSION_3F, $00
	map_attributes CeladonMansionRoof, CELADON_MANSION_ROOF, $01
	map_attributes CeladonMansionRoofHouse, CELADON_MANSION_ROOF_HOUSE, $00
	map_attributes CeladonPokecenter1F, CELADON_POKECENTER_1F, $00
	map_attributes CeladonPokecenter2FBeta, CELADON_POKECENTER_2F_BETA, $00
	map_attributes CeladonGameCorner, CELADON_GAME_CORNER, $00
	map_attributes CeladonGameCornerPrizeRoom, CELADON_GAME_CORNER_PRIZE_ROOM, $00
	map_attributes CeladonGym, CELADON_GYM, $00
	map_attributes CeladonCafe, CELADON_CAFE, $00
	map_attributes Route16FuchsiaSpeechHouse, ROUTE_16_FUCHSIA_SPEECH_HOUSE, $0a ; Kanto hack (M6 9y): Yellow's FLY HOUSE border block, like the other House1 rooms
	map_attributes Route16Gate, ROUTE_16_GATE, $0a
	map_attributes Route7SaffronGate, ROUTE_7_SAFFRON_GATE, $0a
	map_attributes Route17Route18Gate, ROUTE_17_ROUTE_18_GATE, $0a
	map_attributes ManiasHouse, MANIAS_HOUSE, $00
	map_attributes CianwoodGym, CIANWOOD_GYM, $00
	map_attributes CianwoodPokecenter1F, CIANWOOD_POKECENTER_1F, $00
	map_attributes CianwoodPharmacy, CIANWOOD_PHARMACY, $00
	map_attributes CianwoodPhotoStudio, CIANWOOD_PHOTO_STUDIO, $00
	map_attributes CianwoodLugiaSpeechHouse, CIANWOOD_LUGIA_SPEECH_HOUSE, $00
	map_attributes PokeSeersHouse, POKE_SEERS_HOUSE, $00
	map_attributes BattleTower1F, BATTLE_TOWER_1F, $00
	map_attributes BattleTowerBattleRoom, BATTLE_TOWER_BATTLE_ROOM, $00
	map_attributes BattleTowerElevator, BATTLE_TOWER_ELEVATOR, $00
	map_attributes BattleTowerHallway, BATTLE_TOWER_HALLWAY, $00
	map_attributes Route40BattleTowerGate, ROUTE_40_BATTLE_TOWER_GATE, $00
	map_attributes BattleTowerOutside, BATTLE_TOWER_OUTSIDE, $05
	map_attributes ViridianGym, VIRIDIAN_GYM, $00
	map_attributes ViridianNicknameSpeechHouse, VIRIDIAN_NICKNAME_SPEECH_HOUSE, $00
	map_attributes TrainerHouse1F, TRAINER_HOUSE_1F, $00
	map_attributes TrainerHouseB1F, TRAINER_HOUSE_B1F, $00
	map_attributes ViridianMart, VIRIDIAN_MART, $00
	map_attributes ViridianPokecenter1F, VIRIDIAN_POKECENTER_1F, $00
	map_attributes ViridianPokecenter2FBeta, VIRIDIAN_POKECENTER_2F_BETA, $00
	map_attributes Route2NuggetHouse, ROUTE_2_NUGGET_HOUSE, $00
	map_attributes Route2Gate, ROUTE_2_GATE, $0a
	map_attributes VictoryRoadGate, VICTORY_ROAD_GATE, $00
	map_attributes ViridianForest, VIRIDIAN_FOREST, $0f
	map_attributes ViridianForestSouthGate, VIRIDIAN_FOREST_SOUTH_GATE, $0a
	map_attributes ViridianForestNorthGate, VIRIDIAN_FOREST_NORTH_GATE, $0a
	map_attributes Route2TradeHouse, ROUTE_2_TRADE_HOUSE, $00
	map_attributes ViridianSchoolHouse, VIRIDIAN_SCHOOL_HOUSE, $00
	map_attributes DiglettsCaveRoute2, DIGLETTS_CAVE_ROUTE_2, $1d ; Kanto hack (M4 audit): Yellow's $7d, vendor/pokeyellow/data/maps/objects/DiglettsCaveRoute2.asm
	map_attributes ElmsLab, ELMS_LAB, $00
	map_attributes PlayersHouse1F, PLAYERS_HOUSE_1F, $00
	map_attributes PlayersHouse2F, PLAYERS_HOUSE_2F, $00
	map_attributes PlayersNeighborsHouse, PLAYERS_NEIGHBORS_HOUSE, $00
	map_attributes ElmsHouse, ELMS_HOUSE, $00
	map_attributes Route26HealHouse, ROUTE_26_HEAL_HOUSE, $00
	map_attributes DayOfWeekSiblingsHouse, DAY_OF_WEEK_SIBLINGS_HOUSE, $00
	map_attributes Route27SandstormHouse, ROUTE_27_SANDSTORM_HOUSE, $00
	map_attributes Route29Route46Gate, ROUTE_29_ROUTE_46_GATE, $00
	map_attributes FightingDojo, FIGHTING_DOJO, $00
	map_attributes SaffronGym, SAFFRON_GYM, $2e ; Kanto hack (M8 11l): Yellow's border block
	map_attributes SaffronMart, SAFFRON_MART, $00
	map_attributes SaffronPokecenter1F, SAFFRON_POKECENTER_1F, $00
	map_attributes SaffronPokecenter2FBeta, SAFFRON_POKECENTER_2F_BETA, $00
	map_attributes MrPsychicsHouse, MR_PSYCHICS_HOUSE, $00
	map_attributes SaffronPidgeyHouse, SAFFRON_PIDGEY_HOUSE, $0a
	map_attributes SilphCo1F, SILPH_CO_1F, $2e
	map_attributes CopycatsHouse1F, COPYCATS_HOUSE_1F, $00
	map_attributes CopycatsHouse2F, COPYCATS_HOUSE_2F, $00
	map_attributes Route5UndergroundPathEntrance, ROUTE_5_UNDERGROUND_PATH_ENTRANCE, $0a
	map_attributes Route5SaffronGate, ROUTE_5_SAFFRON_GATE, $0a
	map_attributes Route5DayCare, ROUTE_5_DAY_CARE, $00
; Kanto hack (M8 11a): Silph Co. 2F-11F + the elevator.  $2e is Yellow's own
; border block for every Silph floor; the elevator rides TILESET_MART (D83).
	map_attributes SilphCo2F, SILPH_CO_2F, $2e
	map_attributes SilphCo3F, SILPH_CO_3F, $2e
	map_attributes SilphCo4F, SILPH_CO_4F, $2e
	map_attributes SilphCo5F, SILPH_CO_5F, $2e
	map_attributes SilphCo6F, SILPH_CO_6F, $2e
	map_attributes SilphCo7F, SILPH_CO_7F, $2e
	map_attributes SilphCo8F, SILPH_CO_8F, $2e
	map_attributes SilphCo9F, SILPH_CO_9F, $2e
	map_attributes SilphCo10F, SILPH_CO_10F, $2e
	map_attributes SilphCo11F, SILPH_CO_11F, $2e
	map_attributes SilphCoElevator, SILPH_CO_ELEVATOR, $00
	map_attributes CherrygroveMart, CHERRYGROVE_MART, $00
	map_attributes CherrygrovePokecenter1F, CHERRYGROVE_POKECENTER_1F, $00
	map_attributes CherrygroveGymSpeechHouse, CHERRYGROVE_GYM_SPEECH_HOUSE, $00
	map_attributes GuideGentsHouse, GUIDE_GENTS_HOUSE, $00
	map_attributes CherrygroveEvolutionSpeechHouse, CHERRYGROVE_EVOLUTION_SPEECH_HOUSE, $00
	map_attributes Route30BerryHouse, ROUTE_30_BERRY_HOUSE, $00
	map_attributes MrPokemonsHouse, MR_POKEMONS_HOUSE, $00
	map_attributes Route31VioletGate, ROUTE_31_VIOLET_GATE, $00
