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

; Kanto hack (M7 10a)
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoRoute13_Super
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoSafariCenter_Super
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoSafari_Super
; Kanto hack (M7 10n)
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoFuchsia_Super
; Kanto hack (M9 12o)
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoRoute19_Super
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoRoute20_Super
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoRoute21_Super
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoCinnabar_Super
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoSeafoam_Super
; Kanto hack (M10 13e-1)
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoRoute23_Super
; Kanto hack (M11 14f): SHORE/OCEAN/LAKE/POND split per story stretch; the Base
; constant keeps the lowest cap, each appended _Lnn group caps at Lv nn (G7).
	fishgroup 50 percent + 1, .Shore_L65_Old, .Shore_L65_Good, .Shore_L65_Super
	fishgroup 50 percent + 1, .Shore_L78_Old, .Shore_L78_Good, .Shore_L78_Super
	fishgroup 50 percent + 1, .Ocean_L58_Old, .Ocean_L58_Good, .Ocean_L58_Super
	fishgroup 50 percent + 1, .Ocean_L78_Old, .Ocean_L78_Good, .Ocean_L78_Super
	fishgroup 50 percent + 1, .Lake_L58_Old, .Lake_L58_Good, .Lake_L58_Super
	fishgroup 50 percent + 1, .Lake_L61_Old, .Lake_L61_Good, .Lake_L61_Super
	fishgroup 50 percent + 1, .Lake_L78_Old, .Lake_L78_Good, .Lake_L78_Super
	fishgroup 50 percent + 1, .Lake_L82_Old, .Lake_L82_Good, .Lake_L82_Super
	fishgroup 50 percent + 1, .Lake_L91_Old, .Lake_L91_Good, .Lake_L91_Super
	fishgroup 50 percent + 1, .Lake_L95_Old, .Lake_L95_Good, .Lake_L95_Super
	fishgroup 50 percent + 1, .Pond_L65_Old, .Pond_L65_Good, .Pond_L65_Super
	fishgroup 50 percent + 1, .Pond_L70_Old, .Pond_L70_Good, .Pond_L70_Super
	fishgroup 50 percent + 1, .Pond_L82_Old, .Pond_L82_Good, .Pond_L82_Super
	fishgroup 50 percent + 1, .Pond_L87_Old, .Pond_L87_Good, .Pond_L87_Super
	fishgroup 50 percent + 1, .Pond_L95_Old, .Pond_L95_Good, .Pond_L95_Super
; Kanto hack (M10P)
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoCeruleanCave1F_Super
	fishgroup 50 percent + 1, .Kanto_Old, .Kanto_Good, .KantoCeruleanCaveB1F_Super
	assert_table_length NUM_FISHGROUPS

.Shore_Old:
	db  70 percent + 1, MAGIKARP,   57
	db  85 percent + 1, MAGIKARP,   57
	db 100 percent,     KRABBY,     57
.Shore_Good:
	db  35 percent,     MAGIKARP,   57
	db  70 percent,     KRABBY,     57
	db  90 percent + 1, KRABBY,     57
	db 100 percent,     time_group 0
.Shore_Super:
	db  40 percent,     KRABBY,     57
	db  70 percent,     time_group 1
	db  90 percent + 1, KRABBY,     57
	db 100 percent,     KINGLER,    57

.Ocean_Old:
	db  70 percent + 1, MAGIKARP,   57
	db  85 percent + 1, MAGIKARP,   57
	db 100 percent,     TENTACOOL,  57
.Ocean_Good:
	db  35 percent,     MAGIKARP,   57
	db  70 percent,     TENTACOOL,  57
	db  90 percent + 1, CHINCHOU,   57
	db 100 percent,     time_group 2
.Ocean_Super:
	db  40 percent,     CHINCHOU,   57
	db  70 percent,     time_group 3
	db  90 percent + 1, TENTACRUEL, 57
	db 100 percent,     LANTURN,    57

.Lake_Old:
	db  70 percent + 1, MAGIKARP,   57
	db  85 percent + 1, MAGIKARP,   57
	db 100 percent,     GOLDEEN,    57
.Lake_Good:
	db  35 percent,     MAGIKARP,   57
	db  70 percent,     GOLDEEN,    57
	db  90 percent + 1, GOLDEEN,    57
	db 100 percent,     time_group 4
.Lake_Super:
	db  40 percent,     GOLDEEN,    57
	db  70 percent,     time_group 5
	db  90 percent + 1, MAGIKARP,   57
	db 100 percent,     SEAKING,    57

.Pond_Old:
	db  70 percent + 1, MAGIKARP,   57
	db  85 percent + 1, MAGIKARP,   57
	db 100 percent,     POLIWAG,    57
.Pond_Good:
	db  35 percent,     MAGIKARP,   57
	db  70 percent,     POLIWAG,    57
	db  90 percent + 1, POLIWAG,    57
	db 100 percent,     time_group 6
.Pond_Super:
	db  40 percent,     POLIWAG,    57
	db  70 percent,     time_group 7
	db  90 percent + 1, MAGIKARP,   57
	db 100 percent,     POLIWAG,    57

.Dratini_Old:
	db  70 percent + 1, MAGIKARP,   60
	db  85 percent + 1, MAGIKARP,   60
	db 100 percent,     MAGIKARP,   60
.Dratini_Good:
	db  35 percent,     MAGIKARP,   70
	db  70 percent,     MAGIKARP,   70
	db  90 percent + 1, MAGIKARP,   70
	db 100 percent,     time_group 8
.Dratini_Super:
	db  40 percent,     MAGIKARP,   87
	db  70 percent,     time_group 9
	db  90 percent + 1, MAGIKARP,   87
	db 100 percent,     DRAGONAIR,  87

.Qwilfish_Swarm_Old:
	db  70 percent + 1, MAGIKARP,   55
	db  85 percent + 1, MAGIKARP,   55
	db 100 percent,     QWILFISH,   55
.Qwilfish_Swarm_Good:
	db  35 percent,     MAGIKARP,   61
	db  70 percent,     QWILFISH,   61
	db  90 percent + 1, QWILFISH,   61
	db 100 percent,     time_group 10
.Qwilfish_Swarm_Super:
	db  40 percent,     QWILFISH,   61
	db  70 percent,     time_group 11
	db  90 percent + 1, QWILFISH,   61
	db 100 percent,     QWILFISH,   61

.Remoraid_Swarm_Old:
	db  70 percent + 1, MAGIKARP,   60
	db  85 percent + 1, MAGIKARP,   60
	db 100 percent,     REMORAID,   60
.Remoraid_Swarm_Good:
	db  35 percent,     MAGIKARP,   70
	db  70 percent,     REMORAID,   70
	db  90 percent + 1, REMORAID,   70
	db 100 percent,     time_group 12
.Remoraid_Swarm_Super:
	db  40 percent,     REMORAID,   87
	db  70 percent,     time_group 13
	db  90 percent + 1, REMORAID,   87
	db 100 percent,     REMORAID,   87

.Gyarados_Old:
	db  70 percent + 1, MAGIKARP,   60
	db  85 percent + 1, MAGIKARP,   60
	db 100 percent,     MAGIKARP,   60
.Gyarados_Good:
	db  35 percent,     MAGIKARP,   70
	db  70 percent,     MAGIKARP,   70
	db  90 percent + 1, MAGIKARP,   70
	db 100 percent,     time_group 14
.Gyarados_Super:
	db  40 percent,     MAGIKARP,   82
	db  70 percent,     time_group 15
	db  90 percent + 1, MAGIKARP,   82
	db 100 percent,     MAGIKARP,   82

.Dratini_2_Old:
	db  70 percent + 1, MAGIKARP,   60
	db  85 percent + 1, MAGIKARP,   60
	db 100 percent,     MAGIKARP,   60
.Dratini_2_Good:
	db  35 percent,     MAGIKARP,   60
	db  70 percent,     MAGIKARP,   60
	db  90 percent + 1, MAGIKARP,   60
	db 100 percent,     time_group 16
.Dratini_2_Super:
	db  40 percent,     MAGIKARP,   60
	db  70 percent,     time_group 17
	db  90 percent + 1, MAGIKARP,   60
	db 100 percent,     DRAGONAIR,  60

.WhirlIslands_Old:
	db  70 percent + 1, MAGIKARP,   60
	db  85 percent + 1, MAGIKARP,   60
	db 100 percent,     KRABBY,     60
.WhirlIslands_Good:
	db  35 percent,     MAGIKARP,   70
	db  70 percent,     KRABBY,     70
	db  90 percent + 1, KRABBY,     70
	db 100 percent,     time_group 18
.WhirlIslands_Super:
	db  40 percent,     KRABBY,     78
	db  70 percent,     time_group 19
	db  90 percent + 1, KINGLER,    78
	db 100 percent,     SEADRA,     78

.Qwilfish_NoSwarm_Old:
.Qwilfish_Old:
	db  70 percent + 1, MAGIKARP,   60
	db  85 percent + 1, MAGIKARP,   60
	db 100 percent,     TENTACOOL,  60
.Qwilfish_NoSwarm_Good:
.Qwilfish_Good:
	db  35 percent,     MAGIKARP,   61
	db  70 percent,     TENTACOOL,  61
	db  90 percent + 1, TENTACOOL,  61
	db 100 percent,     time_group 20
.Qwilfish_NoSwarm_Super:
.Qwilfish_Super:
	db  40 percent,     TENTACOOL,  61
	db  70 percent,     time_group 21
	db  90 percent + 1, MAGIKARP,   61
	db 100 percent,     QWILFISH,   61

.Remoraid_Old:
	db  70 percent + 1, MAGIKARP,   60
	db  85 percent + 1, MAGIKARP,   60
	db 100 percent,     POLIWAG,    60
.Remoraid_Good:
	db  35 percent,     MAGIKARP,   70
	db  70 percent,     POLIWAG,    70
	db  90 percent + 1, POLIWAG,    70
	db 100 percent,     time_group 6
.Remoraid_Super:
	db  40 percent,     POLIWAG,    87
	db  70 percent,     time_group 7
	db  90 percent + 1, MAGIKARP,   87
	db 100 percent,     REMORAID,   87

; Kanto hack (M11 14f): the per-stretch variants (scripts/m11_wild.py).
.Shore_L65_Old:
	db  70 percent + 1, MAGIKARP,   60
	db  85 percent + 1, MAGIKARP,   60
	db 100 percent,     KRABBY,     60
.Shore_L65_Good:
	db  35 percent,     MAGIKARP,   65
	db  70 percent,     KRABBY,     65
	db  90 percent + 1, KRABBY,     65
	db 100 percent,     time_group 22
.Shore_L65_Super:
	db  40 percent,     KRABBY,     65
	db  70 percent,     time_group 23
	db  90 percent + 1, KRABBY,     65
	db 100 percent,     KINGLER,    65

.Shore_L78_Old:
	db  70 percent + 1, MAGIKARP,   60
	db  85 percent + 1, MAGIKARP,   60
	db 100 percent,     KRABBY,     60
.Shore_L78_Good:
	db  35 percent,     MAGIKARP,   70
	db  70 percent,     KRABBY,     70
	db  90 percent + 1, KRABBY,     70
	db 100 percent,     time_group 24
.Shore_L78_Super:
	db  40 percent,     KRABBY,     78
	db  70 percent,     time_group 25
	db  90 percent + 1, KRABBY,     78
	db 100 percent,     KINGLER,    78

.Ocean_L58_Old:
	db  70 percent + 1, MAGIKARP,   58
	db  85 percent + 1, MAGIKARP,   58
	db 100 percent,     TENTACOOL,  58
.Ocean_L58_Good:
	db  35 percent,     MAGIKARP,   58
	db  70 percent,     TENTACOOL,  58
	db  90 percent + 1, CHINCHOU,   58
	db 100 percent,     time_group 26
.Ocean_L58_Super:
	db  40 percent,     CHINCHOU,   58
	db  70 percent,     time_group 27
	db  90 percent + 1, TENTACRUEL, 58
	db 100 percent,     LANTURN,    58

.Ocean_L78_Old:
	db  70 percent + 1, MAGIKARP,   60
	db  85 percent + 1, MAGIKARP,   60
	db 100 percent,     TENTACOOL,  60
.Ocean_L78_Good:
	db  35 percent,     MAGIKARP,   70
	db  70 percent,     TENTACOOL,  70
	db  90 percent + 1, CHINCHOU,   70
	db 100 percent,     time_group 28
.Ocean_L78_Super:
	db  40 percent,     CHINCHOU,   78
	db  70 percent,     time_group 29
	db  90 percent + 1, TENTACRUEL, 78
	db 100 percent,     LANTURN,    78

.Lake_L58_Old:
	db  70 percent + 1, MAGIKARP,   58
	db  85 percent + 1, MAGIKARP,   58
	db 100 percent,     GOLDEEN,    58
.Lake_L58_Good:
	db  35 percent,     MAGIKARP,   58
	db  70 percent,     GOLDEEN,    58
	db  90 percent + 1, GOLDEEN,    58
	db 100 percent,     time_group 30
.Lake_L58_Super:
	db  40 percent,     GOLDEEN,    58
	db  70 percent,     time_group 31
	db  90 percent + 1, MAGIKARP,   58
	db 100 percent,     SEAKING,    58

.Lake_L61_Old:
	db  70 percent + 1, MAGIKARP,   60
	db  85 percent + 1, MAGIKARP,   60
	db 100 percent,     GOLDEEN,    60
.Lake_L61_Good:
	db  35 percent,     MAGIKARP,   61
	db  70 percent,     GOLDEEN,    61
	db  90 percent + 1, GOLDEEN,    61
	db 100 percent,     time_group 32
.Lake_L61_Super:
	db  40 percent,     GOLDEEN,    61
	db  70 percent,     time_group 33
	db  90 percent + 1, MAGIKARP,   61
	db 100 percent,     SEAKING,    61

.Lake_L78_Old:
	db  70 percent + 1, MAGIKARP,   60
	db  85 percent + 1, MAGIKARP,   60
	db 100 percent,     GOLDEEN,    60
.Lake_L78_Good:
	db  35 percent,     MAGIKARP,   70
	db  70 percent,     GOLDEEN,    70
	db  90 percent + 1, GOLDEEN,    70
	db 100 percent,     time_group 34
.Lake_L78_Super:
	db  40 percent,     GOLDEEN,    78
	db  70 percent,     time_group 35
	db  90 percent + 1, MAGIKARP,   78
	db 100 percent,     SEAKING,    78

.Lake_L82_Old:
	db  70 percent + 1, MAGIKARP,   60
	db  85 percent + 1, MAGIKARP,   60
	db 100 percent,     GOLDEEN,    60
.Lake_L82_Good:
	db  35 percent,     MAGIKARP,   70
	db  70 percent,     GOLDEEN,    70
	db  90 percent + 1, GOLDEEN,    70
	db 100 percent,     time_group 36
.Lake_L82_Super:
	db  40 percent,     GOLDEEN,    82
	db  70 percent,     time_group 37
	db  90 percent + 1, MAGIKARP,   82
	db 100 percent,     SEAKING,    82

.Lake_L91_Old:
	db  70 percent + 1, MAGIKARP,   60
	db  85 percent + 1, MAGIKARP,   60
	db 100 percent,     GOLDEEN,    60
.Lake_L91_Good:
	db  35 percent,     MAGIKARP,   70
	db  70 percent,     GOLDEEN,    70
	db  90 percent + 1, GOLDEEN,    70
	db 100 percent,     time_group 38
.Lake_L91_Super:
	db  40 percent,     GOLDEEN,    90
	db  70 percent,     time_group 39
	db  90 percent + 1, MAGIKARP,   90
	db 100 percent,     SEAKING,    90

.Lake_L95_Old:
	db  70 percent + 1, MAGIKARP,   60
	db  85 percent + 1, MAGIKARP,   60
	db 100 percent,     GOLDEEN,    60
.Lake_L95_Good:
	db  35 percent,     MAGIKARP,   70
	db  70 percent,     GOLDEEN,    70
	db  90 percent + 1, GOLDEEN,    70
	db 100 percent,     time_group 40
.Lake_L95_Super:
	db  40 percent,     GOLDEEN,    90
	db  70 percent,     time_group 41
	db  90 percent + 1, MAGIKARP,   90
	db 100 percent,     SEAKING,    90

.Pond_L65_Old:
	db  70 percent + 1, MAGIKARP,   60
	db  85 percent + 1, MAGIKARP,   60
	db 100 percent,     POLIWAG,    60
.Pond_L65_Good:
	db  35 percent,     MAGIKARP,   65
	db  70 percent,     POLIWAG,    65
	db  90 percent + 1, POLIWAG,    65
	db 100 percent,     time_group 42
.Pond_L65_Super:
	db  40 percent,     POLIWAG,    65
	db  70 percent,     time_group 43
	db  90 percent + 1, MAGIKARP,   65
	db 100 percent,     POLIWAG,    65

.Pond_L70_Old:
	db  70 percent + 1, MAGIKARP,   60
	db  85 percent + 1, MAGIKARP,   60
	db 100 percent,     POLIWAG,    60
.Pond_L70_Good:
	db  35 percent,     MAGIKARP,   70
	db  70 percent,     POLIWAG,    70
	db  90 percent + 1, POLIWAG,    70
	db 100 percent,     time_group 44
.Pond_L70_Super:
	db  40 percent,     POLIWAG,    70
	db  70 percent,     time_group 45
	db  90 percent + 1, MAGIKARP,   70
	db 100 percent,     POLIWAG,    70

.Pond_L82_Old:
	db  70 percent + 1, MAGIKARP,   60
	db  85 percent + 1, MAGIKARP,   60
	db 100 percent,     POLIWAG,    60
.Pond_L82_Good:
	db  35 percent,     MAGIKARP,   70
	db  70 percent,     POLIWAG,    70
	db  90 percent + 1, POLIWAG,    70
	db 100 percent,     time_group 46
.Pond_L82_Super:
	db  40 percent,     POLIWAG,    82
	db  70 percent,     time_group 47
	db  90 percent + 1, MAGIKARP,   82
	db 100 percent,     POLIWAG,    82

.Pond_L87_Old:
	db  70 percent + 1, MAGIKARP,   60
	db  85 percent + 1, MAGIKARP,   60
	db 100 percent,     POLIWAG,    60
.Pond_L87_Good:
	db  35 percent,     MAGIKARP,   70
	db  70 percent,     POLIWAG,    70
	db  90 percent + 1, POLIWAG,    70
	db 100 percent,     time_group 48
.Pond_L87_Super:
	db  40 percent,     POLIWAG,    87
	db  70 percent,     time_group 49
	db  90 percent + 1, MAGIKARP,   87
	db 100 percent,     POLIWAG,    87

.Pond_L95_Old:
	db  70 percent + 1, MAGIKARP,   60
	db  85 percent + 1, MAGIKARP,   60
	db 100 percent,     POLIWAG,    60
.Pond_L95_Good:
	db  35 percent,     MAGIKARP,   70
	db  70 percent,     POLIWAG,    70
	db  90 percent + 1, POLIWAG,    70
	db 100 percent,     time_group 50
.Pond_L95_Super:
	db  40 percent,     POLIWAG,    90
	db  70 percent,     time_group 51
	db  90 percent + 1, MAGIKARP,   90
	db 100 percent,     POLIWAG,    90

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

; db ROUTE_13, HORSEA, 15, HORSEA, 20, TENTACOOL, 10, SEADRA, 20
.KantoRoute13_Super:
	db  40 percent,     HORSEA,     15
	db  70 percent,     HORSEA,     20
	db  90 percent + 1, TENTACOOL,  10
	db 100 percent,     SEADRA,     20

; db SAFARI_ZONE_CENTER, MAGIKARP, 5, MAGIKARP, 10, DRATINI, 10, DRAGONAIR, 15
.KantoSafariCenter_Super:
	db  40 percent,     MAGIKARP,    5
	db  70 percent,     MAGIKARP,   10
	db  90 percent + 1, DRATINI,    10
	db 100 percent,     DRAGONAIR,  15

; db SAFARI_ZONE_EAST/NORTH/WEST, MAGIKARP, 5, MAGIKARP, 10, MAGIKARP, 15, DRATINI, 15
.KantoSafari_Super:
	db  40 percent,     MAGIKARP,    5
	db  70 percent,     MAGIKARP,   10
	db  90 percent + 1, MAGIKARP,   15
	db 100 percent,     DRATINI,    15

; db FUCHSIA_CITY, MAGIKARP, 5, MAGIKARP, 10, MAGIKARP, 15, GYARADOS, 15
; The only GYARADOS row in Yellow's Super Rod table: a ~10% chance of a L15
; GYARADOS off the city pond, which is also Yellow's cheapest legitimate
; GYARADOS.  Nothing else in the Kanto act shares this row (M7 10n).
.KantoFuchsia_Super:
	db  40 percent,     MAGIKARP,    5
	db  70 percent,     MAGIKARP,   10
	db  90 percent + 1, MAGIKARP,   15
	db 100 percent,     GYARADOS,   15

; Kanto hack (M9 12o): the Cinnabar act's rows, Yellow's four slots in order.
; db ROUTE_19, TENTACOOL, 15, STARYU, 20, TENTACOOL, 30, TENTACRUEL, 30
.KantoRoute19_Super:
	db  40 percent,     TENTACOOL,  15
	db  70 percent,     STARYU,     20
	db  90 percent + 1, TENTACOOL,  30
	db 100 percent,     TENTACRUEL, 30

; db ROUTE_20, TENTACOOL, 20, TENTACRUEL, 20, STARYU, 30, TENTACRUEL, 40
.KantoRoute20_Super:
	db  40 percent,     TENTACOOL,  20
	db  70 percent,     TENTACRUEL, 20
	db  90 percent + 1, STARYU,     30
	db 100 percent,     TENTACRUEL, 40

; db ROUTE_21, TENTACOOL, 15, STARYU, 20, TENTACOOL, 30, TENTACRUEL, 30
.KantoRoute21_Super:
	db  40 percent,     TENTACOOL,  15
	db  70 percent,     STARYU,     20
	db  90 percent + 1, TENTACOOL,  30
	db 100 percent,     TENTACRUEL, 30

; db CINNABAR_ISLAND, STARYU, 15, TENTACOOL, 15, STARYU, 10, TENTACOOL, 30
.KantoCinnabar_Super:
	db  40 percent,     STARYU,     15
	db  70 percent,     TENTACOOL,  15
	db  90 percent + 1, STARYU,     10
	db 100 percent,     TENTACOOL,  30

; (SEAFOAM_ISLANDS_B4F has the identical row.)
; db SEAFOAM_ISLANDS_B3F, KRABBY, 25, STARYU, 20, KINGLER, 35, STARYU, 40
.KantoSeafoam_Super:
	db  40 percent,     KRABBY,     25
	db  70 percent,     STARYU,     20
	db  90 percent + 1, KINGLER,    35
	db 100 percent,     STARYU,     40

; Kanto hack (M10 13e-1): Yellow's ROUTE_23 super_rod.asm row.
.KantoRoute23_Super:
	db  40 percent,     POLIWAG,    25
	db  70 percent,     POLIWAG,    30
	db  90 percent + 1, POLIWHIRL,  30
	db 100 percent,     POLIWHIRL,  40

; Kanto hack (M10P): Yellow's CERULEAN CAVE super_rod.asm rows.
; db CERULEAN_CAVE_1F, GOLDEEN, 25, SEAKING, 35, SEAKING, 45, SEAKING, 55
.KantoCeruleanCave1F_Super:
	db  40 percent,     GOLDEEN,    25
	db  70 percent,     SEAKING,    35
	db  90 percent + 1, SEAKING,    45
	db 100 percent,     SEAKING,    55

; db CERULEAN_CAVE_B1F, GOLDEEN, 30, SEAKING, 40, SEAKING, 50, SEAKING, 60
.KantoCeruleanCaveB1F_Super:
	db  40 percent,     GOLDEEN,    30
	db  70 percent,     SEAKING,    40
	db  90 percent + 1, SEAKING,    50
	db 100 percent,     SEAKING,    60

TimeFishGroups:
	;  day              nite
	db CORSOLA,    57,  STARYU,     57 ; 0
	db CORSOLA,    57,  STARYU,     57 ; 1
	db SHELLDER,   57,  SHELLDER,   57 ; 2
	db SHELLDER,   57,  SHELLDER,   57 ; 3
	db GOLDEEN,    57,  GOLDEEN,    57 ; 4
	db GOLDEEN,    57,  GOLDEEN,    57 ; 5
	db POLIWAG,    57,  POLIWAG,    57 ; 6
	db POLIWAG,    57,  POLIWAG,    57 ; 7
	db DRATINI,    70,  DRATINI,    70 ; 8
	db DRATINI,    87,  DRATINI,    87 ; 9
	db QWILFISH,   61,  QWILFISH,   61 ; 10
	db QWILFISH,   61,  QWILFISH,   61 ; 11
	db REMORAID,   70,  REMORAID,   70 ; 12
	db REMORAID,   87,  REMORAID,   87 ; 13
	db GYARADOS,   70,  GYARADOS,   70 ; 14
	db GYARADOS,   82,  GYARADOS,   82 ; 15
	db DRATINI,    60,  DRATINI,    60 ; 16
	db DRATINI,    60,  DRATINI,    60 ; 17
	db HORSEA,     70,  HORSEA,     70 ; 18
	db HORSEA,     78,  HORSEA,     78 ; 19
	db TENTACOOL,  61,  TENTACOOL,  61 ; 20
	db TENTACOOL,  61,  TENTACOOL,  61 ; 21
; Kanto hack (M11 14f): the split variants' time groups.
	db CORSOLA,   65,  STARYU,    65 ; 22
	db CORSOLA,   65,  STARYU,    65 ; 23
	db CORSOLA,   70,  STARYU,    70 ; 24
	db CORSOLA,   78,  STARYU,    78 ; 25
	db SHELLDER,  58,  SHELLDER,  58 ; 26
	db SHELLDER,  58,  SHELLDER,  58 ; 27
	db SHELLDER,  70,  SHELLDER,  70 ; 28
	db SHELLDER,  78,  SHELLDER,  78 ; 29
	db GOLDEEN,   58,  GOLDEEN,   58 ; 30
	db GOLDEEN,   58,  GOLDEEN,   58 ; 31
	db GOLDEEN,   61,  GOLDEEN,   61 ; 32
	db GOLDEEN,   61,  GOLDEEN,   61 ; 33
	db GOLDEEN,   70,  GOLDEEN,   70 ; 34
	db GOLDEEN,   78,  GOLDEEN,   78 ; 35
	db GOLDEEN,   70,  GOLDEEN,   70 ; 36
	db GOLDEEN,   82,  GOLDEEN,   82 ; 37
	db GOLDEEN,   70,  GOLDEEN,   70 ; 38
	db GOLDEEN,   90,  GOLDEEN,   90 ; 39
	db GOLDEEN,   70,  GOLDEEN,   70 ; 40
	db GOLDEEN,   90,  GOLDEEN,   90 ; 41
	db POLIWAG,   65,  POLIWAG,   65 ; 42
	db POLIWAG,   65,  POLIWAG,   65 ; 43
	db POLIWAG,   70,  POLIWAG,   70 ; 44
	db POLIWAG,   70,  POLIWAG,   70 ; 45
	db POLIWAG,   70,  POLIWAG,   70 ; 46
	db POLIWAG,   82,  POLIWAG,   82 ; 47
	db POLIWAG,   70,  POLIWAG,   70 ; 48
	db POLIWAG,   87,  POLIWAG,   87 ; 49
	db POLIWAG,   70,  POLIWAG,   70 ; 50
	db POLIWAG,   90,  POLIWAG,   90 ; 51
