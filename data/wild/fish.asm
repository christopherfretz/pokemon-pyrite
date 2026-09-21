DEF time_group EQUS "0," ; use the nth TimeFishGroups entry

MACRO fishgroup
; chance, old rod, good rod, super rod
	db \1
	dw \2, \3, \4
ENDM

FishGroups:
; entries correspond to FISHGROUP_* constants
	table_width FISHGROUP_DATA_LENGTH
	fishgroup 50 percent + 1, .Shore_Old,            .Shore_Good,            .Shore_Super
	fishgroup 50 percent + 1, .Ocean_Old,            .Ocean_Good,            .Ocean_Super
	fishgroup 50 percent + 1, .Lake_Old,             .Lake_Good,             .Lake_Super
	fishgroup 50 percent + 1, .Pond_Old,             .Pond_Good,             .Pond_Super
	fishgroup 50 percent + 1, .Dratini_Old,          .Dratini_Good,          .Dratini_Super
	fishgroup 50 percent + 1, .Qwilfish_Swarm_Old,   .Qwilfish_Swarm_Good,   .Qwilfish_Swarm_Super
	fishgroup 50 percent + 1, .Remoraid_Swarm_Old,   .Remoraid_Swarm_Good,   .Remoraid_Swarm_Super
	fishgroup 50 percent + 1, .Gyarados_Old,         .Gyarados_Good,         .Gyarados_Super
	fishgroup 50 percent + 1, .Dratini_2_Old,        .Dratini_2_Good,        .Dratini_2_Super
	fishgroup 50 percent + 1, .WhirlIslands_Old,     .WhirlIslands_Good,     .WhirlIslands_Super
	fishgroup 50 percent + 1, .Qwilfish_Old,         .Qwilfish_Good,         .Qwilfish_Super
	fishgroup 50 percent + 1, .Remoraid_Old,         .Remoraid_Good,         .Remoraid_Super
	fishgroup 50 percent + 1, .Qwilfish_NoSwarm_Old, .Qwilfish_NoSwarm_Good, .Qwilfish_NoSwarm_Super
; Kanto hack (M5 8m): the Kanto act's groups, from Yellow's own rod tables.
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoPallet_Super
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoViridian_Super
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoCerulean_Super
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoVermilion_Super
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoVermilionDock_Super
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoRoute4_Super
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoRoute6_Super
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoRoute10_Super
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoRoute12_Super
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoRoute22_Super
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoRoute25_Super
; Kanto hack (M6 9ab): CYCLING ROAD and ROUTE 18 (D43 corrected).
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoRoute17_Super
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoRoute18_Super
	assert_table_length NUM_FISHGROUPS

.Shore_Old:
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     KRABBY,     10
.Shore_Good:
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     KRABBY,     20
	db  90 percent + 1, KRABBY,     20
	db 100 percent,     time_group 0
.Shore_Super:
	db  40 percent,     KRABBY,     40
	db  70 percent,     time_group 1
	db  90 percent + 1, KRABBY,     40
	db 100 percent,     KINGLER,    40

.Ocean_Old:
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     TENTACOOL,  10
.Ocean_Good:
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     TENTACOOL,  20
	db  90 percent + 1, CHINCHOU,   20
	db 100 percent,     time_group 2
.Ocean_Super:
	db  40 percent,     CHINCHOU,   40
	db  70 percent,     time_group 3
	db  90 percent + 1, TENTACRUEL, 40
	db 100 percent,     LANTURN,    40

.Lake_Old:
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     GOLDEEN,    10
.Lake_Good:
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     GOLDEEN,    20
	db  90 percent + 1, GOLDEEN,    20
	db 100 percent,     time_group 4
.Lake_Super:
	db  40 percent,     GOLDEEN,    40
	db  70 percent,     time_group 5
	db  90 percent + 1, MAGIKARP,   40
	db 100 percent,     SEAKING,    40

.Pond_Old:
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     POLIWAG,    10
.Pond_Good:
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     POLIWAG,    20
	db  90 percent + 1, POLIWAG,    20
	db 100 percent,     time_group 6
.Pond_Super:
	db  40 percent,     POLIWAG,    40
	db  70 percent,     time_group 7
	db  90 percent + 1, MAGIKARP,   40
	db 100 percent,     POLIWAG,    40

.Dratini_Old:
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     MAGIKARP,   10
.Dratini_Good:
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     MAGIKARP,   20
	db  90 percent + 1, MAGIKARP,   20
	db 100 percent,     time_group 8
.Dratini_Super:
	db  40 percent,     MAGIKARP,   40
	db  70 percent,     time_group 9
	db  90 percent + 1, MAGIKARP,   40
	db 100 percent,     DRAGONAIR,  40

.Qwilfish_Swarm_Old:
	db  70 percent + 1, MAGIKARP,   5
	db  85 percent + 1, MAGIKARP,   5
	db 100 percent,     QWILFISH,   5
.Qwilfish_Swarm_Good:
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     QWILFISH,   20
	db  90 percent + 1, QWILFISH,   20
	db 100 percent,     time_group 10
.Qwilfish_Swarm_Super:
	db  40 percent,     QWILFISH,   40
	db  70 percent,     time_group 11
	db  90 percent + 1, QWILFISH,   40
	db 100 percent,     QWILFISH,   40

.Remoraid_Swarm_Old:
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     REMORAID,   10
.Remoraid_Swarm_Good:
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     REMORAID,   20
	db  90 percent + 1, REMORAID,   20
	db 100 percent,     time_group 12
.Remoraid_Swarm_Super:
	db  40 percent,     REMORAID,   40
	db  70 percent,     time_group 13
	db  90 percent + 1, REMORAID,   40
	db 100 percent,     REMORAID,   40

.Gyarados_Old:
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     MAGIKARP,   10
.Gyarados_Good:
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     MAGIKARP,   20
	db  90 percent + 1, MAGIKARP,   20
	db 100 percent,     time_group 14
.Gyarados_Super:
	db  40 percent,     MAGIKARP,   40
	db  70 percent,     time_group 15
	db  90 percent + 1, MAGIKARP,   40
	db 100 percent,     MAGIKARP,   40

.Dratini_2_Old:
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     MAGIKARP,   10
.Dratini_2_Good:
	db  35 percent,     MAGIKARP,   10
	db  70 percent,     MAGIKARP,   10
	db  90 percent + 1, MAGIKARP,   10
	db 100 percent,     time_group 16
.Dratini_2_Super:
	db  40 percent,     MAGIKARP,   10
	db  70 percent,     time_group 17
	db  90 percent + 1, MAGIKARP,   10
	db 100 percent,     DRAGONAIR,  10

.WhirlIslands_Old:
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     KRABBY,     10
.WhirlIslands_Good:
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     KRABBY,     20
	db  90 percent + 1, KRABBY,     20
	db 100 percent,     time_group 18
.WhirlIslands_Super:
	db  40 percent,     KRABBY,     40
	db  70 percent,     time_group 19
	db  90 percent + 1, KINGLER,    40
	db 100 percent,     SEADRA,     40

.Qwilfish_NoSwarm_Old:
.Qwilfish_Old:
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     TENTACOOL,  10
.Qwilfish_NoSwarm_Good:
.Qwilfish_Good:
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     TENTACOOL,  20
	db  90 percent + 1, TENTACOOL,  20
	db 100 percent,     time_group 20
.Qwilfish_NoSwarm_Super:
.Qwilfish_Super:
	db  40 percent,     TENTACOOL,  40
	db  70 percent,     time_group 21
	db  90 percent + 1, MAGIKARP,   40
	db 100 percent,     QWILFISH,   40

.Remoraid_Old:
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     POLIWAG,    10
.Remoraid_Good:
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     POLIWAG,    20
	db  90 percent + 1, POLIWAG,    20
	db 100 percent,     time_group 6
.Remoraid_Super:
	db  40 percent,     POLIWAG,    40
	db  70 percent,     time_group 7
	db  90 percent + 1, MAGIKARP,   40
	db 100 percent,     REMORAID,   40

; Kanto hack (M5 8m): the Kanto act's fishing, ported from Yellow.
;
; Yellow keys fishing off the rod plus a per-map row, not off a group crossed
; with the rod, so the port is: one shared Old Rod list, one shared Good Rod
; list, and one Super Rod list per distinct row of Yellow's
; SuperRodFishingSlots (vendor/pokeyellow/data/wild/super_rod.asm).
;
; * Old Rod -- ItemUseOldRod (vendor/pokeyellow/engine/items/item_effects.asm)
;   hardcodes `lb bc, 5, MAGIKARP` on every map, so one 100% entry covers it.
; * Good Rod -- ItemUseGoodRod picks one of the two GoodRodMons
;   (vendor/pokeyellow/data/wild/good_rod.asm) with `and %11 / cp 2`, i.e. a
;   flat 50/50 between GOLDEEN L10 and POLIWAG L10, on every map.
; * Super Rod -- GenerateRandomFishingEncounter
;   (vendor/pokeyellow/engine/items/super_rod.asm) rolls the four slots at
;   $66 / $b2 / $e5, i.e. 39.8 / 29.7 / 19.9 / 10.5 percent.  Crystal's own
;   bracket convention (40 / 70 / 90+1 / 100) is the same split to within
;   1/256, so the four slots transfer in order with no re-weighting.
;
; Levels are Yellow's exactly: `Fish` returns d = species, e = level straight
; from these rows, and only ChooseWildEncounter's water path adds the +0..+4
; buff, so nothing inflates a fishing level the way it does a surf level.
;
; Known deviation: the "bite" chance byte is per GROUP, not per rod, so the
; Old Rod is 50/50 here where Yellow's never fails.  Making it faithful means
; special-casing rod 0 in `Fish` (engine/events/fish.asm), which would change
; Johto too -- left alone, recorded as an open question in
; docs/M5-LAVENDER.md "## 8m findings".
.Kanto_Old:
	db 100 percent,     MAGIKARP,    5
.Kanto_Good:
	db  50 percent,     GOLDEEN,    10
	db 100 percent,     POLIWAG,    10

; db PALLET_TOWN, STARYU, 10, TENTACOOL, 10, STARYU, 5, TENTACOOL, 20
.KantoPallet_Super:
	db  40 percent,     STARYU,     10
	db  70 percent,     TENTACOOL,  10
	db  90 percent + 1, STARYU,      5
	db 100 percent,     TENTACOOL,  20

; db VIRIDIAN_CITY, POLIWAG, 5, POLIWAG, 10, POLIWAG, 15, POLIWAG, 10
.KantoViridian_Super:
	db  40 percent,     POLIWAG,     5
	db  70 percent,     POLIWAG,    10
	db  90 percent + 1, POLIWAG,    15
	db 100 percent,     POLIWAG,    10

; db CERULEAN_CITY, GOLDEEN, 25, GOLDEEN, 30, SEAKING, 30, SEAKING, 40
.KantoCerulean_Super:
	db  40 percent,     GOLDEEN,    25
	db  70 percent,     GOLDEEN,    30
	db  90 percent + 1, SEAKING,    30
	db 100 percent,     SEAKING,    40

; db VERMILION_CITY, TENTACOOL, 15, TENTACOOL, 20, TENTACOOL, 10, HORSEA, 5
; db ROUTE_11,       TENTACOOL, 15, TENTACOOL, 20, TENTACOOL, 10, HORSEA, 5
.KantoVermilion_Super:
	db  40 percent,     TENTACOOL,  15
	db  70 percent,     TENTACOOL,  20
	db  90 percent + 1, TENTACOOL,  10
	db 100 percent,     HORSEA,      5

; db VERMILION_DOCK, TENTACOOL, 10, TENTACOOL, 15, STARYU, 15, SHELLDER, 10
.KantoVermilionDock_Super:
	db  40 percent,     TENTACOOL,  10
	db  70 percent,     TENTACOOL,  15
	db  90 percent + 1, STARYU,     15
	db 100 percent,     SHELLDER,   10

; db ROUTE_4,  GOLDEEN, 20, GOLDEEN, 25, GOLDEEN, 30, SEAKING, 30
; db ROUTE_24, GOLDEEN, 20, GOLDEEN, 25, GOLDEEN, 30, SEAKING, 30
.KantoRoute4_Super:
	db  40 percent,     GOLDEEN,    20
	db  70 percent,     GOLDEEN,    25
	db  90 percent + 1, GOLDEEN,    30
	db 100 percent,     SEAKING,    30

; db ROUTE_6, GOLDEEN, 5, GOLDEEN, 10, GOLDEEN, 15, GOLDEEN, 20
; (CELADON_CITY is the same row; M6 points it here.)
.KantoRoute6_Super:
	db  40 percent,     GOLDEEN,     5
	db  70 percent,     GOLDEEN,    10
	db  90 percent + 1, GOLDEEN,    15
	db 100 percent,     GOLDEEN,    20

; db ROUTE_10, KRABBY, 15, KRABBY, 20, HORSEA, 10, KINGLER, 25
.KantoRoute10_Super:
	db  40 percent,     KRABBY,     15
	db  70 percent,     KRABBY,     20
	db  90 percent + 1, HORSEA,     10
	db 100 percent,     KINGLER,    25

; db ROUTE_12, HORSEA, 20, HORSEA, 25, SEADRA, 25, SEADRA, 35
.KantoRoute12_Super:
	db  40 percent,     HORSEA,     20
	db  70 percent,     HORSEA,     25
	db  90 percent + 1, SEADRA,     25
	db 100 percent,     SEADRA,     35

; db ROUTE_22, POLIWAG, 5, POLIWAG, 10, POLIWAG, 15, POLIWHIRL, 15
.KantoRoute22_Super:
	db  40 percent,     POLIWAG,     5
	db  70 percent,     POLIWAG,    10
	db  90 percent + 1, POLIWAG,    15
	db 100 percent,     POLIWHIRL,  15

; db ROUTE_25, KRABBY, 10, KRABBY, 15, KINGLER, 15, KINGLER, 25
.KantoRoute25_Super:
	db  40 percent,     KRABBY,     10
	db  70 percent,     KRABBY,     15
	db  90 percent + 1, KINGLER,    15
	db 100 percent,     KINGLER,    25

; db ROUTE_17, TENTACOOL, 5, TENTACOOL, 15, SHELLDER, 25, SHELLDER, 35
.KantoRoute17_Super:
	db  40 percent,     TENTACOOL,   5
	db  70 percent,     TENTACOOL,  15
	db  90 percent + 1, SHELLDER,   25
	db 100 percent,     SHELLDER,   35

; db ROUTE_18, TENTACOOL, 15, SHELLDER, 20, SHELLDER, 30, SHELLDER, 40
.KantoRoute18_Super:
	db  40 percent,     TENTACOOL,  15
	db  70 percent,     SHELLDER,   20
	db  90 percent + 1, SHELLDER,   30
	db 100 percent,     SHELLDER,   40

TimeFishGroups:
	;  day              nite
	db CORSOLA,    20,  STARYU,     20 ; 0
	db CORSOLA,    40,  STARYU,     40 ; 1
	db SHELLDER,   20,  SHELLDER,   20 ; 2
	db SHELLDER,   40,  SHELLDER,   40 ; 3
	db GOLDEEN,    20,  GOLDEEN,    20 ; 4
	db GOLDEEN,    40,  GOLDEEN,    40 ; 5
	db POLIWAG,    20,  POLIWAG,    20 ; 6
	db POLIWAG,    40,  POLIWAG,    40 ; 7
	db DRATINI,    20,  DRATINI,    20 ; 8
	db DRATINI,    40,  DRATINI,    40 ; 9
	db QWILFISH,   20,  QWILFISH,   20 ; 10
	db QWILFISH,   40,  QWILFISH,   40 ; 11
	db REMORAID,   20,  REMORAID,   20 ; 12
	db REMORAID,   40,  REMORAID,   40 ; 13
	db GYARADOS,   20,  GYARADOS,   20 ; 14
	db GYARADOS,   40,  GYARADOS,   40 ; 15
	db DRATINI,    10,  DRATINI,    10 ; 16
	db DRATINI,    10,  DRATINI,    10 ; 17
	db HORSEA,     20,  HORSEA,     20 ; 18
	db HORSEA,     40,  HORSEA,     40 ; 19
	db TENTACOOL,  20,  TENTACOOL,  20 ; 20
	db TENTACOOL,  40,  TENTACOOL,  40 ; 21
