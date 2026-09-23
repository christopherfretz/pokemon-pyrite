DEF MAPGROUP_N_A  EQU -1
DEF GROUP_N_A     EQU -1
DEF MAP_N_A       EQU -1
DEF MAPGROUP_NONE EQU 0
DEF GROUP_NONE    EQU 0
DEF MAP_NONE      EQU 0

; map struct members (see data/maps/maps.asm)
rsreset
DEF MAP_MAPATTRIBUTES_BANK rb ; 0
DEF MAP_TILESET            rb ; 1
DEF MAP_ENVIRONMENT        rb ; 2
DEF MAP_MAPATTRIBUTES      rw ; 3
DEF MAP_LOCATION           rb ; 5
DEF MAP_MUSIC              rb ; 6
DEF MAP_PALETTE            rb ; 7
DEF MAP_FISHGROUP          rb ; 8
DEF MAP_LENGTH EQU _RS

; map environments (wEnvironment)
; EnvironmentColorsPointers indexes (see data/maps/environment_colors.asm)
	const_def 1
	const TOWN
	const ROUTE
	const INDOOR
	const CAVE
	const ENVIRONMENT_5
	const GATE
	const DUNGEON
DEF NUM_ENVIRONMENTS EQU const_value - 1

; map palettes (wMapTimeOfDay)
	const_def
	const PALETTE_AUTO
	const PALETTE_DAY
	const PALETTE_NITE
	const PALETTE_MORN
	const PALETTE_DARK
DEF NUM_MAP_PALETTES EQU const_value

; FishGroups indexes (see data/wild/fish.asm)
	const_def
	const FISHGROUP_NONE
	const FISHGROUP_SHORE
	const FISHGROUP_OCEAN
	const FISHGROUP_LAKE
	const FISHGROUP_POND
	const FISHGROUP_DRATINI
	const FISHGROUP_QWILFISH_SWARM
	const FISHGROUP_REMORAID_SWARM
	const FISHGROUP_GYARADOS
	const FISHGROUP_DRATINI_2
	const FISHGROUP_WHIRL_ISLANDS
	const FISHGROUP_QWILFISH
	const FISHGROUP_REMORAID
	const FISHGROUP_QWILFISH_NO_SWARM
; Kanto hack (M5 8m): Yellow-faithful fishing for the Kanto act.  Crystal's
; own groups leak Gen 2 species into Kanto -- .Shore falls through to
; TimeFishGroups 0/1 = CORSOLA by day, .Ocean carries CHINCHOU/LANTURN, and
; .Pond hands out L40 POLIWAG in VIRIDIAN CITY -- so every Kanto map that has
; water gets a group built from Yellow's own rod tables instead.  One group
; per distinct Yellow SuperRodFishingSlots row set
; (vendor/pokeyellow/data/wild/super_rod.asm); the Old and Good Rod lists are
; global in Yellow and are shared by all of them.  Johto's groups above are
; untouched.  See docs/M5-LAVENDER.md "## 8m findings".
	const FISHGROUP_KANTO_PALLET         ; PALLET_TOWN
	const FISHGROUP_KANTO_VIRIDIAN       ; VIRIDIAN_CITY
	const FISHGROUP_KANTO_CERULEAN       ; CERULEAN_CITY
	const FISHGROUP_KANTO_VERMILION      ; VERMILION_CITY, ROUTE_11
	const FISHGROUP_KANTO_VERMILION_DOCK ; VERMILION_DOCK (our VERMILION_PORT)
	const FISHGROUP_KANTO_ROUTE_4        ; ROUTE_4, ROUTE_24
	const FISHGROUP_KANTO_ROUTE_6        ; ROUTE_6 (and CELADON_CITY, in M6)
	const FISHGROUP_KANTO_ROUTE_10       ; ROUTE_10
	const FISHGROUP_KANTO_ROUTE_12       ; ROUTE_12
	const FISHGROUP_KANTO_ROUTE_22       ; ROUTE_22
	const FISHGROUP_KANTO_ROUTE_25       ; ROUTE_25
; Kanto hack (M6 9ab): CYCLING ROAD's channel and ROUTE 18's sea are both
; fishable from land, and Yellow gives each its own SuperRodFishingSlots row
; (vendor/pokeyellow/data/wild/super_rod.asm).  Appended, not inserted, so no
; existing group is renumbered.  ROUTE 16 keeps FISHGROUP_NONE: Yellow has no
; ROUTE_16 row, and the map's only water is a pocket sealed off by Yellow's own
; collision.
	const FISHGROUP_KANTO_ROUTE_17       ; ROUTE_17
	const FISHGROUP_KANTO_ROUTE_18       ; ROUTE_18
; Kanto hack (M7 10a): ROUTE 13's channel and the SAFARI ZONE's ponds.  Yellow
; gives ROUTE_13 one SuperRodFishingSlots row, SAFARI_ZONE_CENTER another, and
; the other three Safari areas share a third
; (vendor/pokeyellow/data/wild/super_rod.asm).  ROUTES 14 and 15 have no Yellow
; row at all, so they take FISHGROUP_NONE -- Crystal had them on FISHGROUP_SHORE,
; which leaked CORSOLA (docs/M7-FUCHSIA.md 0.5).  Appended, never inserted (G7).
	const FISHGROUP_KANTO_ROUTE_13       ; ROUTE_13
	const FISHGROUP_KANTO_SAFARI_CENTER  ; SAFARI_ZONE_CENTER
	const FISHGROUP_KANTO_SAFARI         ; SAFARI_ZONE_EAST/NORTH/WEST
; Kanto hack (M7 10n): FUCHSIA CITY's own pond.  Yellow's row
; (`db FUCHSIA_CITY, MAGIKARP, 5, MAGIKARP, 10, MAGIKARP, 15, GYARADOS, 15`)
; matches no existing group -- it is FISHGROUP_KANTO_SAFARI's row with GYARADOS
; in place of DRATINI, and it is the only GYARADOS row in Yellow's whole Super
; Rod table -- so it needs a group of its own.  Appended, never inserted (G7).
	const FISHGROUP_KANTO_FUCHSIA        ; FUCHSIA_CITY
; Kanto hack (M9 12o, D102): the Cinnabar act's five Super Rod rows
; (vendor/pokeyellow/data/wild/super_rod.asm).  ROUTE_21's row is identical to
; ROUTE_19's but D102 gives it its own group anyway, so the two routes stay
; independently tunable; SEAFOAM B3F and B4F share one row and one group.
; Appended, never inserted (G7) -- ids 31-35.
	const FISHGROUP_KANTO_ROUTE_19       ; ROUTE_19
	const FISHGROUP_KANTO_ROUTE_20       ; ROUTE_20
	const FISHGROUP_KANTO_ROUTE_21       ; ROUTE_21
	const FISHGROUP_KANTO_CINNABAR       ; CINNABAR_ISLAND
	const FISHGROUP_KANTO_SEAFOAM        ; SEAFOAM_ISLANDS_B3F/B4F
; Kanto hack (M10 13e-1): Yellow's ROUTE_23 Super Rod row -- id 36, appended.
	const FISHGROUP_KANTO_ROUTE_23       ; ROUTE_23
DEF NUM_FISHGROUPS EQU const_value - 1

; wMapConnections
; connection directions (see data/maps/data.asm)
	const_def
	shift_const EAST
	shift_const WEST
	shift_const SOUTH
	shift_const NORTH

; SpawnPoints indexes (see data/maps/spawn_points.asm)
	const_def
	const SPAWN_HOME
	const SPAWN_DEBUG
; kanto
	const SPAWN_PALLET
	const SPAWN_VIRIDIAN
	const SPAWN_PEWTER
	const SPAWN_CERULEAN
	const SPAWN_ROCK_TUNNEL
	const SPAWN_VERMILION
	const SPAWN_LAVENDER
	const SPAWN_SAFFRON
	const SPAWN_CELADON
	const SPAWN_FUCHSIA
	const SPAWN_CINNABAR
	const SPAWN_INDIGO
; johto
	const SPAWN_NEW_BARK
	const SPAWN_CHERRYGROVE
	const SPAWN_VIOLET
	const SPAWN_UNION_CAVE
	const SPAWN_AZALEA
	const SPAWN_CIANWOOD
	const SPAWN_GOLDENROD
	const SPAWN_OLIVINE
	const SPAWN_ECRUTEAK
	const SPAWN_MAHOGANY
	const SPAWN_LAKE_OF_RAGE
	const SPAWN_BLACKTHORN
	const SPAWN_MT_SILVER
	const SPAWN_FAST_SHIP
DEF NUM_SPAWNS EQU const_value

DEF SPAWN_N_A EQU -1

; wSpawnAfterChampion values.  Kanto hack (M10 13k): an after-HoF marker IS
; the spawn point Continue lands on (intro_menu's .SpawnAfterE4 copies it to
; wDefaultSpawnpoint), so the Kanto HoF can spawn at PALLET without growing
; bank 1.  Crystal had LANCE = 1, RED = 2 and a hard-coded SPAWN_NEW_BARK.
DEF SPAWN_LANCE          EQU SPAWN_NEW_BARK ; Crystal's (Johto) HoF
DEF SPAWN_KANTO_CHAMPION EQU SPAWN_PALLET   ; Yellow: fly_warp PALLET_TOWN, 5, 6
DEF SPAWN_RED            EQU $ff            ; after RED's credits; never saved

; Flypoints indexes (see data/maps/flypoints.asm)
	const_def
; johto
DEF JOHTO_FLYPOINT EQU const_value
	const FLY_NEW_BARK
	const FLY_CHERRYGROVE
	const FLY_VIOLET
	const FLY_AZALEA
	const FLY_GOLDENROD
	const FLY_ECRUTEAK
	const FLY_OLIVINE
	const FLY_CIANWOOD
	const FLY_MAHOGANY
	const FLY_LAKE_OF_RAGE
	const FLY_BLACKTHORN
	const FLY_MT_SILVER
; kanto
DEF KANTO_FLYPOINT EQU const_value
	const FLY_PALLET
	const FLY_VIRIDIAN
	const FLY_PEWTER
	const FLY_CERULEAN
	const FLY_VERMILION
	const FLY_ROCK_TUNNEL
	const FLY_LAVENDER
	const FLY_CELADON
	const FLY_SAFFRON
	const FLY_FUCHSIA
	const FLY_CINNABAR
	const FLY_INDIGO
DEF NUM_FLYPOINTS EQU const_value

DEF MAX_OUTDOOR_SPRITES EQU 23 ; see engine/overworld/overworld.asm
