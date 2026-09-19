MACRO spawn
; map, x, y
	map_id \1
	db \2, \3
ENDM

SpawnPoints:
; entries correspond to SPAWN_* constants
	table_width 4

	spawn REDS_HOUSE_2F,               3,  6 ; yellowcrystal: SPAWN_HOME is Red's room in Pallet
	spawn VIRIDIAN_POKECENTER_1F,      5,  3

	spawn PALLET_TOWN,                 5,  6
	spawn VIRIDIAN_CITY,              23, 26
	spawn PEWTER_CITY,                13, 26
	spawn CERULEAN_CITY,              19, 22
; Kanto hack (M5 8d): was 11, 2 -- the front door of the Pokemon Center on the
; old 10x9 ROUTE_10_NORTH.  8b merged Route 10 back to Yellow's single 10x36
; map, where y=2 is open water; the Center's door is at (11,19), so the
; whiteout spawn is the tile in front of it.
	spawn ROUTE_10,                   11, 20
	spawn VERMILION_CITY,              9,  6
; Kanto hack (M5 8g): was 5, 6 -- in front of Crystal's Pokemon Center door.
; 8g moves the door to Yellow's (3,5), and Yellow's own fly/blackout tile is
; LAVENDER_TOWN 3, 6 (data/maps/special_warps.asm .LavenderTown).
	spawn LAVENDER_TOWN,               3,  6
	spawn SAFFRON_CITY,                9, 30
	spawn CELADON_CITY,               29, 10
	spawn FUCHSIA_CITY,               19, 28
	spawn CINNABAR_ISLAND,            11, 12
	spawn ROUTE_23,                    9,  6

	spawn NEW_BARK_TOWN,              13,  6
	spawn CHERRYGROVE_CITY,           29,  4
	spawn VIOLET_CITY,                31, 26
	spawn ROUTE_32,                   11, 74
	spawn AZALEA_TOWN,                15, 10
	spawn CIANWOOD_CITY,              23, 44
	spawn GOLDENROD_CITY,             15, 28
	spawn OLIVINE_CITY,               13, 22
	spawn ECRUTEAK_CITY,              23, 28
	spawn MAHOGANY_TOWN,              15, 14
	spawn LAKE_OF_RAGE,               21, 29
	spawn BLACKTHORN_CITY,            21, 30
	spawn SILVER_CAVE_OUTSIDE,        23, 20
	spawn FAST_SHIP_CABINS_SW_SSW_NW,  6,  2

	spawn N_A,                        -1, -1

	assert_table_length NUM_SPAWNS + 1
