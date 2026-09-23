; wEventFlags bit flags

	const_def
; The first eight flags are reset upon reloading the map
	const EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1
	const EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	const EVENT_TEMPORARY_UNTIL_MAP_RELOAD_3
	const EVENT_TEMPORARY_UNTIL_MAP_RELOAD_4
	const EVENT_TEMPORARY_UNTIL_MAP_RELOAD_5
	const EVENT_TEMPORARY_UNTIL_MAP_RELOAD_6
	const EVENT_TEMPORARY_UNTIL_MAP_RELOAD_7
	const EVENT_TEMPORARY_UNTIL_MAP_RELOAD_8
; Johto Gym Leader TM gifts
	const EVENT_GOT_TM31_MUD_SLAP
	const EVENT_GOT_TM49_FURY_CUTTER
	const EVENT_GOT_TM01_DYNAMICPUNCH
	const EVENT_GOT_TM45_ATTRACT
	const EVENT_GOT_TM30_SHADOW_BALL
	const EVENT_GOT_TM23_IRON_TAIL
	const EVENT_GOT_TM16_ICY_WIND
	const EVENT_GOT_TM24_DRAGONBREATH
; HMs (EVENT_GOT_HM07_WATERFALL is with the Johto itemballs)
	const EVENT_GOT_HM01_CUT
	const EVENT_GOT_HM02_FLY
	const EVENT_GOT_HM03_SURF
	const EVENT_GOT_HM04_STRENGTH
	const EVENT_GOT_HM05_FLASH
	const EVENT_GOT_HM06_WHIRLPOOL
	const EVENT_GOT_TM24_THUNDERBOLT ; Kanto hack (M4 7k): renamed in place, was an unused const_skip; LT.SURGE's TM24 THUNDERBOLT
; Rods
	const EVENT_GOT_OLD_ROD
	const EVENT_GOT_GOOD_ROD
	const EVENT_GOT_SUPER_ROD
; Johto story events
	const EVENT_GOT_A_POKEMON_FROM_ELM
	const EVENT_GOT_CYNDAQUIL_FROM_ELM
	const EVENT_GOT_TOTODILE_FROM_ELM
	const EVENT_GOT_CHIKORITA_FROM_ELM
	const EVENT_GOT_MYSTERY_EGG_FROM_MR_POKEMON
	const EVENT_GAVE_MYSTERY_EGG_TO_ELM
	const EVENT_JASMINE_RETURNED_TO_GYM
	const EVENT_CLEARED_RADIO_TOWER
	const EVENT_CLEARED_ROCKET_HIDEOUT
	const EVENT_GOT_SECRETPOTION_FROM_PHARMACY
	const EVENT_GOT_SS_TICKET_FROM_ELM
	const EVENT_USED_THE_CARD_KEY_IN_THE_RADIO_TOWER
	const EVENT_REFUSED_TO_HELP_LANCE_AT_LAKE_OF_RAGE
	const EVENT_GOT_BERRY_FROM_ROUTE_30_HOUSE
	const EVENT_MADE_WHITNEY_CRY
	const EVENT_HERDED_FARFETCHD
	const EVENT_FOUGHT_SUDOWOODO
	const EVENT_CLEARED_SLOWPOKE_WELL
	const EVENT_REFUSED_TO_TAKE_EGG_FROM_ELMS_AIDE
	const EVENT_GOT_TOGEPI_EGG_FROM_ELMS_AIDE
	const EVENT_MADE_UNOWN_APPEAR_IN_RUINS
	const EVENT_FAST_SHIP_DESTINATION_OLIVINE
	const EVENT_FAST_SHIP_FIRST_TIME
	const EVENT_FAST_SHIP_HAS_ARRIVED
	const EVENT_FAST_SHIP_FOUND_GIRL
	const EVENT_FAST_SHIP_LAZY_SAILOR
	const EVENT_FAST_SHIP_INFORMED_ABOUT_LAZY_SAILOR
	const EVENT_KURT_GAVE_YOU_LURE_BALL
	const EVENT_INITIALIZED_EVENTS
	const EVENT_JASMINE_EXPLAINED_AMPHYS_SICKNESS
	const EVENT_LAKE_OF_RAGE_EXPLAINED_WEIRD_MAGIKARP
	const EVENT_LAKE_OF_RAGE_ASKED_FOR_MAGIKARP
	const EVENT_LAKE_OF_RAGE_ELIXIR_ON_STANDBY
	const EVENT_1ST_LOCK_OPENED ; Kanto hack (M4 7k): renamed in place, was an unused const_skip; VERMILION GYM trash cans
	const EVENT_2ND_LOCK_OPENED ; Kanto hack (M4 7k): renamed in place, was an unused const_skip; VERMILION GYM trash cans
	const EVENT_HEALED_MOOMOO
	const EVENT_GOT_TM13_SNORE_FROM_MOOMOO_FARM
	const EVENT_TALKED_TO_FARMER_ABOUT_MOOMOO
	const EVENT_TALKED_TO_MOM_AFTER_MYSTERY_EGG_QUEST
	const EVENT_DUDE_TALKED_TO_YOU
	const EVENT_LEARNED_TO_CATCH_POKEMON
	const EVENT_ELM_CALLED_ABOUT_STOLEN_POKEMON
	const EVENT_BEAT_ELITE_FOUR
	const EVENT_GOT_SHUCKIE
	const EVENT_MANIA_TOOK_SHUCKIE_OR_LET_YOU_KEEP_HIM
	const EVENT_GOT_SUNNY_DAY_FROM_RADIO_TOWER
	const EVENT_GOT_PINK_BOW_FROM_MARY
	const EVENT_USED_BASEMENT_KEY
	const EVENT_RECEIVED_CARD_KEY
	const EVENT_GOT_TM08_ROCK_SMASH
	const EVENT_LANCE_HEALED_YOU_IN_TEAM_ROCKET_BASE
	const EVENT_GOT_MYSTIC_WATER_IN_CHERRYGROVE
	const EVENT_GOT_TM05_ROAR
	const EVENT_GOT_EEVEE
	const EVENT_GOT_KENYA
	const EVENT_GAVE_KENYA
	const EVENT_GOT_HP_UP_FROM_RANDY
	const EVENT_GOT_TM50_NIGHTMARE
	const EVENT_TOGEPI_HATCHED
	const EVENT_SHOWED_TOGEPI_TO_ELM
	const EVENT_GOT_EVERSTONE_FROM_ELM
	const EVENT_GOT_QUICK_CLAW
	const EVENT_GOT_TM10_HIDDEN_POWER
	const EVENT_GOT_TM36_SLUDGE_BOMB
	const EVENT_GOT_ITEMFINDER
	const EVENT_GOT_BICYCLE
	const EVENT_GOT_SQUIRTBOTTLE
	const EVENT_GOT_MIRACLE_SEED_IN_ROUTE_32
	const EVENT_GOT_CHARCOAL_IN_CHARCOAL_KILN
	const EVENT_GOT_TM02_HEADBUTT
	const EVENT_DECIDED_TO_HELP_LANCE
	const EVENT_GOT_TYROGUE_FROM_KIYO
	const EVENT_MET_FRIEDA_OF_FRIDAY
	const EVENT_GOT_POISON_BARB_FROM_FRIEDA
	const EVENT_MET_TUSCANY_OF_TUESDAY
	const EVENT_GOT_PINK_BOW_FROM_TUSCANY
	const EVENT_MET_ARTHUR_OF_THURSDAY
	const EVENT_GOT_HARD_STONE_FROM_ARTHUR
	const EVENT_MET_SUNNY_OF_SUNDAY
	const EVENT_GOT_MAGNET_FROM_SUNNY
	const EVENT_MET_WESLEY_OF_WEDNESDAY
	const EVENT_GOT_BLACKBELT_FROM_WESLEY
	const EVENT_MET_SANTOS_OF_SATURDAY
	const EVENT_GOT_SPELL_TAG_FROM_SANTOS
	const EVENT_MET_MONICA_OF_MONDAY
	const EVENT_GOT_SHARP_BEAK_FROM_MONICA
	const EVENT_GOT_SOFT_SAND_FROM_KATE
	const EVENT_GOT_METAL_COAT_FROM_GRANDPA_ON_SS_AQUA
	const EVENT_GOT_BLACKGLASSES_IN_DARK_CAVE
	const EVENT_GOT_KINGS_ROCK_IN_SLOWPOKE_WELL
	const EVENT_GOT_TM47_STEEL_WING
	const EVENT_GOT_TM37_SANDSTORM
	const EVENT_FIRST_TIME_BANKING_WITH_MOM
	const EVENT_TOLD_ELM_ABOUT_TOGEPI_OVER_THE_PHONE
	const EVENT_GOT_CLEAR_BELL
	const EVENT_GOT_SILVER_WING
	const EVENT_GOT_TM12_SWEET_SCENT
	const EVENT_RELEASED_THE_BEASTS
	const EVENT_GOT_MASTER_BALL_FROM_ELM
; Johto hidden items
	const EVENT_TIN_TOWER_4F_HIDDEN_MAX_POTION
	const EVENT_TIN_TOWER_5F_HIDDEN_FULL_RESTORE
	const EVENT_TIN_TOWER_5F_HIDDEN_CARBOS
	const EVENT_BURNED_TOWER_1F_HIDDEN_ETHER
	const EVENT_GOT_TM13_ICE_BEAM ; Kanto hack: renamed in place (M6 9r), was an unused const_skip; CELADON DEPT. STORE roof girl, FRESH WATER -> TM87 ICE BEAM (Yellow's TM13)
	const EVENT_GOT_TM48_ROCK_SLIDE ; Kanto hack: renamed in place (M6 9r), was an unused const_skip; CELADON DEPT. STORE roof girl, SODA POP -> TM83 ROCK SLIDE (Yellow's TM48)
	const EVENT_GOT_TM49_TRI_ATTACK ; Kanto hack: renamed in place (M6 9r), was an unused const_skip; CELADON DEPT. STORE roof girl, LEMONADE -> TM84 TRI ATTACK (Yellow's TM49)
	const EVENT_NATIONAL_PARK_HIDDEN_FULL_HEAL
	const EVENT_OLIVINE_LIGHTHOUSE_5F_HIDDEN_HYPER_POTION
	const EVENT_TEAM_ROCKET_BASE_B1F_HIDDEN_REVIVE
	const EVENT_TEAM_ROCKET_BASE_B2F_HIDDEN_FULL_HEAL
	const EVENT_ILEX_FOREST_HIDDEN_ETHER
	const EVENT_ILEX_FOREST_HIDDEN_SUPER_POTION
	const EVENT_ILEX_FOREST_HIDDEN_FULL_HEAL
	const EVENT_GOLDENROD_UNDERGROUND_HIDDEN_PARLYZ_HEAL
	const EVENT_GOLDENROD_UNDERGROUND_HIDDEN_SUPER_POTION
	const EVENT_GOLDENROD_UNDERGROUND_HIDDEN_ANTIDOTE
	const EVENT_GOLDENROD_UNDERGROUND_SWITCH_ROOM_ENTRANCES_HIDDEN_MAX_POTION
	const EVENT_GOLDENROD_UNDERGROUND_SWITCH_ROOM_ENTRANCES_HIDDEN_REVIVE
	const EVENT_MOUNT_MORTAR_1F_OUTSIDE_HIDDEN_HYPER_POTION
	const EVENT_MOUNT_MORTAR_1F_INSIDE_HIDDEN_MAX_REPEL
	const EVENT_MOUNT_MORTAR_2F_INSIDE_HIDDEN_FULL_RESTORE
	const EVENT_MOUNT_MORTAR_B1F_HIDDEN_MAX_REVIVE
	const EVENT_ICE_PATH_B1F_HIDDEN_MAX_POTION
	const EVENT_ICE_PATH_B2F_MAHOGANY_SIDE_HIDDEN_CARBOS
	const EVENT_ICE_PATH_B2F_BLACKTHORN_SIDE_HIDDEN_ICE_HEAL
	const EVENT_WHIRL_ISLAND_B1F_HIDDEN_RARE_CANDY
	const EVENT_WHIRL_ISLAND_B1F_HIDDEN_ULTRA_BALL
	const EVENT_WHIRL_ISLAND_B1F_HIDDEN_FULL_RESTORE
	const EVENT_SILVER_CAVE_ROOM_1_HIDDEN_DIRE_HIT
	const EVENT_SILVER_CAVE_ROOM_1_HIDDEN_ULTRA_BALL
	const EVENT_SILVER_CAVE_ROOM_2_HIDDEN_MAX_POTION
	const EVENT_DARK_CAVE_VIOLET_ENTRANCE_HIDDEN_ELIXER
	const EVENT_VICTORY_ROAD_2F_HIDDEN_ULTRA_BALL ; Kanto hack (M10 13g): renamed in place, was EVENT_VICTORY_ROAD_HIDDEN_MAX_POTION (dead); Yellow's VICTORY ROAD 2F hidden ULTRA BALL (5,2)
	const EVENT_VICTORY_ROAD_2F_HIDDEN_FULL_RESTORE ; Kanto hack (M10 13g): renamed in place, was EVENT_VICTORY_ROAD_HIDDEN_FULL_HEAL (dead); Yellow's VICTORY ROAD 2F hidden FULL RESTORE (26,7)
	const EVENT_DRAGONS_DEN_B1F_HIDDEN_REVIVE
	const EVENT_DRAGONS_DEN_B1F_HIDDEN_MAX_POTION
	const EVENT_DRAGONS_DEN_B1F_HIDDEN_MAX_ELIXER
	const EVENT_ROUTE_28_HIDDEN_RARE_CANDY
	const EVENT_ROUTE_30_HIDDEN_POTION
	const EVENT_ROUTE_32_HIDDEN_GREAT_BALL
	const EVENT_ROUTE_32_HIDDEN_SUPER_POTION
	const EVENT_ROUTE_34_HIDDEN_RARE_CANDY
	const EVENT_ROUTE_34_HIDDEN_SUPER_POTION
	const EVENT_ROUTE_37_HIDDEN_ETHER
	const EVENT_ROUTE_39_HIDDEN_NUGGET
	const EVENT_ROUTE_40_HIDDEN_HYPER_POTION
	const EVENT_ROUTE_41_HIDDEN_MAX_ETHER
	const EVENT_ROUTE_42_HIDDEN_MAX_POTION
	const EVENT_ROUTE_44_HIDDEN_ELIXER
	const EVENT_ROUTE_45_HIDDEN_PP_UP
	const EVENT_VIOLET_CITY_HIDDEN_HYPER_POTION
	const EVENT_AZALEA_TOWN_HIDDEN_FULL_HEAL
	const EVENT_CIANWOOD_CITY_HIDDEN_REVIVE
	const EVENT_CIANWOOD_CITY_HIDDEN_MAX_ETHER
	const EVENT_ECRUTEAK_CITY_HIDDEN_HYPER_POTION
	const EVENT_LAKE_OF_RAGE_HIDDEN_FULL_RESTORE
	const EVENT_LAKE_OF_RAGE_HIDDEN_RARE_CANDY
	const EVENT_LAKE_OF_RAGE_HIDDEN_MAX_POTION
	const EVENT_SILVER_CAVE_OUTSIDE_HIDDEN_FULL_RESTORE
; Crystal-exclusive events in Johto
	const EVENT_MET_FLORIA
	const EVENT_TALKED_TO_FLORIA_AT_FLOWER_SHOP
	const EVENT_BUGGING_KURT_TOO_MUCH
	const EVENT_TALKED_TO_RUINS_COWARD
	const EVENT_GOT_DRATINI
	const EVENT_CAN_GIVE_GS_BALL_TO_KURT
	const EVENT_GAVE_GS_BALL_TO_KURT
	const EVENT_FOREST_IS_RESTLESS
	const EVENT_ANSWERED_DRAGON_MASTER_QUIZ_WRONG
; Unused: next 6 events

	const_next 200
; Kanto story events
	const EVENT_GOT_NUGGET_FROM_GUY
	const EVENT_RETURNED_MACHINE_PART
	const EVENT_MET_MANAGER_AT_POWER_PLANT
	const EVENT_BEAT_CERULEAN_ROCKET_THIEF ; Kanto hack: renamed in place (6c,
; docs/M3-CERULEAN.md). Was EVENT_MET_ROCKET_GRUNT_AT_CERULEAN_GYM, whose only
; reference was one dead `setevent` in Crystal's CeruleanGym grunt scene (6e
; deletes that scene outright). Set when Yellow's Cerulean Rocket thief has
; been beaten; gates the (30,7)/(30,9) coord trigger.
	const EVENT_VIRIDIAN_GYM_RIVAL_HIDDEN ; Kanto hack (M10 13k2): was EVENT_MET_REDS_MOM (unreferenced since the N1 audit #73, renamed in place).  The post-E4 rival's object hide flag in VIRIDIAN GYM; the OBJECTS callback derives it on every load, so a stale SET from an old save is harmless
	const EVENT_RESTORED_POWER_TO_KANTO
	const EVENT_GOT_COINS_FROM_GAME_CORNER_GURU_2 ; Kanto hack: renamed in place (M6 9u), was EVENT_GOT_COINS_FROM_GAMBLER_AT_CELADON (Crystal's own CELADON GAME CORNER one-off, this map's only user); CELADON GAME CORNER, Yellow's FISHING GURU 2 (17,13) and his 20 coins
	const EVENT_GOT_TM31_MIMIC ; Kanto hack: renamed in place (M8 11d), was
; EVENT_MET_COPYCAT_FOUND_OUT_ABOUT_LOST_ITEM.  Yellow has no LOST_ITEM quest --
; the COPYCAT trades a POKe DOLL for TM31 MIMIC -- so Crystal's three-step chain
; is dead here.  EVENT_RETURNED_LOST_ITEM_TO_COPYCAT and
; EVENT_GOT_PASS_FROM_COPYCAT are left alone: the second is still read by
; engine/phone/scripts/irwin_gossip.asm, and the PASS itself is wanted for the
; Johto act's MAGNET TRAIN, so only the SAFFRON half of the quest is retired.
	const EVENT_VICTORY_ROAD_2F_GUARD_SPEC ; Kanto hack (M10 13g): renamed in place, was EVENT_RETURNED_LOST_ITEM_TO_COPYCAT (dead); ball (11,0)
	const EVENT_GOT_PASS_FROM_COPYCAT
	const EVENT_GOT_BIKE_VOUCHER ; Kanto hack: renamed in place (7f), was EVENT_GOT_LOST_ITEM_FROM_FAN_CLUB (Crystal's LOST_ITEM quest deleted); Yellow's EVENT_GOT_BIKE_VOUCHER
	const EVENT_PIKACHU_FAN_BOAST ; Kanto hack: renamed in place (7f), was EVENT_LISTENED_TO_FAN_CLUB_PRESIDENT_BUT_BAG_WAS_FULL; Yellow's boast toggle -- SET means the CLEFAIRY fan brags back next
	const EVENT_SEEL_FAN_BOAST ; Kanto hack: renamed in place (7f), was EVENT_LISTENED_TO_FAN_CLUB_PRESIDENT; Yellow's boast toggle -- SET means the SEEL fan brags back next
	const EVENT_TALKED_TO_SEAFOAM_GYM_GUIDE_ONCE
	const EVENT_ENABLE_DIPLOMA_PRINTING
	const EVENT_POWER_PLANT_HIDDEN_MAX_ELIXER ; Kanto hack (M10 13l): renamed in place, was EVENT_CINNABAR_ROCKS_CLEARED (dead); Yellow's POWER PLANT hidden MAX ELIXER (17,16)
	const EVENT_BEAT_HIKER_MORTON ; Kanto hack: renamed in place (6i), was EVENT_CLEARED_NUGGET_BRIDGE; Route 25, Yellow's HIKER 4
	const EVENT_WARDENS_HOME_RARE_CANDY ; Kanto hack (M7 10g): was EVENT_TALKED_TO_WARDENS_GRANDDAUGHTER
	const EVENT_POWER_PLANT_HIDDEN_PP_UP ; Kanto hack (M10 13l): renamed in place, was EVENT_GOT_TM03_CURSE (dead); Yellow's POWER PLANT hidden PP UP (12,1)
	const EVENT_SS_ANNE_1F_ROOMS_TM_BODY_SLAM ; Kanto hack: renamed in place (7h), was EVENT_GOT_CLEANSE_TAG; S.S. ANNE 1F Rooms item ball (12,15)
	const EVENT_GOT_TM21_MEGA_DRAIN ; Kanto hack: renamed in place (M6 9q), was EVENT_GOT_TM19_GIGA_DRAIN; ERIKA's TM is Yellow's TM21 MEGA DRAIN (our TM67)
	const EVENT_GOT_TM06_TOXIC
	const EVENT_VICTORY_ROAD_3F_MAX_REVIVE ; Kanto hack (M10 13g): renamed in place, was EVENT_GOT_UP_GRADE (dead); ball (26,5)
	const EVENT_GOT_TM07_ZAP_CANNON
	const EVENT_GOT_TM42_DREAM_EATER
	const EVENT_TALKED_TO_OAK_IN_KANTO
	const EVENT_GOT_SQUIRTLE_FROM_OFFICER_JENNY ; Kanto hack: renamed in place (7e), was EVENT_GOT_HP_UP_FROM_VERMILION_GUY; Yellow's EVENT_GOT_SQUIRTLE_FROM_OFFICER_JENNY
	const EVENT_GOT_TM29_PSYCHIC
; Kanto hidden items
	const EVENT_ROUTE_9_TM_TELEPORT ; Kanto hack: renamed in place (M5 8c), was the dead EVENT_DIGLETTS_CAVE_HIDDEN_MAX_REVIVE; ROUTE 9's TM30 TELEPORT ball at (10,15).  Itemball flag living in the hidden-item block: moving the const would renumber every flag after it and break existing saves
	const EVENT_UNDERGROUND_PATH_HIDDEN_FULL_RESTORE
	const EVENT_UNDERGROUND_PATH_HIDDEN_X_SPECIAL
	const EVENT_BEAT_HIKER_CONRAD ; Kanto hack: renamed in place (M5 8f), was the dead EVENT_ROCK_TUNNEL_1F_HIDDEN_X_ACCURACY; ROCK TUNNEL B1F, Yellow's HIKER 11
	const EVENT_BEAT_POKEMANIAC_WALDO ; Kanto hack: renamed in place (M5 8f), was the dead EVENT_ROCK_TUNNEL_1F_HIDDEN_X_DEFEND; ROCK TUNNEL B1F, Yellow's POKEMANIAC 5
	const EVENT_BEAT_HIKER_VERNON ; Kanto hack: renamed in place (M5 8f); was Crystal's ROCK TUNNEL B1F hidden MAX_POTION, deleted -- Yellow's B1F has no items.  ROCK TUNNEL B1F, Yellow's HIKER 10
	const EVENT_OLIVINE_PORT_HIDDEN_PROTEIN
	const EVENT_WALKED_PAST_GUARD_AFTER_SS_ANNE_LEFT ; Kanto hack: renamed in place (7g) from EVENT_VERMILION_PORT_HIDDEN_IRON -- Yellow's dock has no hidden IRON and Crystal's was deleted with the FAST SHIP cast.  7j sets/reads this (Yellow: VermilionCityLeftSSAnneCallbackScript, docs/M4-VERMILION.md §3.8); no reader today.
	const EVENT_MT_MOON_1F_TM_WATER_GUN ; Kanto hack: renamed in place (5e); Crystal's Mt. Moon Square is gone.  M3b: Yellow's TM12 WATER GUN (was TM_RAIN_DANCE)
	const EVENT_ROUTE_10_HIDDEN_SUPER_POTION ; Kanto hack: renamed in place (M5 8d), was the dead EVENT_ROUTE_2_HIDDEN_MAX_ETHER; ROUTE 10's hidden SUPER POTION (Yellow (9,17), moved one tile south -- see maps/Route10.asm)
	const EVENT_ROUTE_10_HIDDEN_MAX_ETHER ; Kanto hack: renamed in place (M5 8d), was the dead EVENT_ROUTE_2_HIDDEN_FULL_HEAL; ROUTE 10's hidden MAX ETHER at (16,53)
	const EVENT_UNDERGROUND_PATH_WEST_EAST_HIDDEN_NUGGET ; Kanto hack: renamed in place (M5 8k), was the dead EVENT_ROUTE_2_HIDDEN_FULL_RESTORE (Yellow hides nothing on ROUTE 2); the west-east UNDERGROUND PATH's hidden NUGGET at (12,2)
	const EVENT_UNDERGROUND_PATH_WEST_EAST_HIDDEN_ELIXER ; Kanto hack: renamed in place (M5 8k), was the dead EVENT_ROUTE_2_HIDDEN_REVIVE; the west-east UNDERGROUND PATH's hidden ELIXER at (21,5)
	const EVENT_ROUTE_4_HIDDEN_GREAT_BALL ; Kanto hack: Route 4, Yellow's hidden GREAT_BALL (was EVENT_ROUTE_4_HIDDEN_ULTRA_BALL)
	const EVENT_ROUTE_9_HIDDEN_ETHER
	const EVENT_GOT_TM_SWIFT_FROM_GIRL ; Kanto hack: renamed in place (M5 8l), was EVENT_ROUTE_12_HIDDEN_ELIXER -- Crystal's hidden ELIXER is not Yellow's (Yellow's one ROUTE 12 hidden item is a HYPER POTION at (2,63); see EVENT_ROUTE_12_HIDDEN_HYPER_POTION), so 8l deleted it and this row pays for the ROUTE 12 GATE 2F girl's one-time TM39 SWIFT
	const EVENT_ROUTE_13_HIDDEN_CALCIUM ; Kanto hack (M7 10c): kept; moved to Yellow's tile, ROUTE 13 (16,13), read facing LEFT from (17,13) -- Crystal had it at (30,13)
	const EVENT_ROUTE_11_HIDDEN_ESCAPE_ROPE ; Kanto hack (M4 audit): was EVENT_ROUTE_11_HIDDEN_REVIVE; Yellow's ROUTE 11 hidden item is an ESCAPE_ROPE
	const EVENT_ROUTE_17_HIDDEN_RARE_CANDY ; Kanto hack: renamed in place (M6 9z) -- Yellow's ROUTE 17 hidden items are not Crystal's; ROUTE 17 (15,14)
	const EVENT_ROUTE_17_HIDDEN_MAX_ELIXER
	const EVENT_ROUTE_17_HIDDEN_FULL_RESTORE ; Kanto hack: renamed in place (M6 9z), was the dead EVENT_ROUTE_25_HIDDEN_POTION; ROUTE 17 (8,45)
	const EVENT_GOT_COIN_CASE ; Kanto hack: renamed in place (M6 9t), was EVENT_FOUND_LEFTOVERS_IN_CELADON_CAFE; CELADON DINER gym guide gives the COIN CASE
	const EVENT_SS_ANNE_2F_ROOMS_MAX_ETHER ; Kanto hack: renamed in place (7h), was EVENT_FOUND_BERSERK_GENE_IN_CERULEAN_CITY; S.S. ANNE 2F Rooms item ball (12,1)
	const EVENT_FOUND_MACHINE_PART_IN_CERULEAN_GYM
	const EVENT_VERMILION_CITY_HIDDEN_MAX_ETHER ; Kanto hack: renamed in place (7e), was EVENT_VERMILION_CITY_HIDDEN_FULL_HEAL; Yellow hides a MAX_ETHER at (14,11)
	const EVENT_CELADON_CITY_HIDDEN_PP_UP
	const EVENT_CINNABAR_ISLAND_HIDDEN_RARE_CANDY
	const EVENT_BURNED_TOWER_1F_HIDDEN_ULTRA_BALL
	const EVENT_GINA_GAVE_LEAF_STONE
	const EVENT_ALAN_GAVE_FIRE_STONE
	const EVENT_DANA_GAVE_THUNDERSTONE
	const EVENT_TULLY_GAVE_WATER_STONE
	const EVENT_TIFFANY_GAVE_PINK_BOW
; Unused: next 339 events

	const_next 600
; Kurt Apricorn events
	const EVENT_GAVE_KURT_RED_APRICORN
	const EVENT_GAVE_KURT_BLU_APRICORN
	const EVENT_GAVE_KURT_YLW_APRICORN
	const EVENT_GAVE_KURT_GRN_APRICORN
	const EVENT_GAVE_KURT_WHT_APRICORN
	const EVENT_GAVE_KURT_BLK_APRICORN
	const EVENT_GAVE_KURT_PNK_APRICORN
; Phone events
	const EVENT_JACK_ASKED_FOR_PHONE_NUMBER
	const EVENT_GOT_EEVEE_CELADON ; Kanto hack: renamed in place (M6 9s), was an unused const_skip in Crystal's phone block; CELADON MANSION ROOF HOUSE's free EEVEE ball (4,3).  Yellow has no flag (it uses the toggleable-object hide list); GSC objects need one.  EVENT_GOT_EEVEE is taken by Johto's Bill's-family EEVEE
	const EVENT_BEVERLY_ASKED_FOR_PHONE_NUMBER
	const EVENT_BEAT_KANTO_ELITE_FOUR ; Kanto hack (M10 13d, D109): renamed in place, was an unused const_skip in Crystal's phone block; set ONLY by the Kanto Hall of Fame (13k).  Crystal's EVENT_BEAT_ELITE_FOUR stays clear for the Johto act (C-6).  Read by VICTORY ROAD GATE (south/west seal, D132), the Pewter gramps and the Cerulean Cave guard (13k), and the League rooms' post-E4 state (13j/13k)
	const EVENT_HUEY_ASKED_FOR_PHONE_NUMBER
	const EVENT_ROUTE_23_HIDDEN_FULL_RESTORE ; Kanto hack (M10 13e-1): renamed in place, was an unused const_skip in Crystal's phone block; Yellow's ROUTE 23 hidden item (9,44)
	const EVENT_GOT_PROTEIN_FROM_HUEY
	const EVENT_GOT_HP_UP_FROM_JOEY
	const EVENT_GOT_CARBOS_FROM_VANCE
	const EVENT_GOT_IRON_FROM_PARRY
	const EVENT_GOT_CALCIUM_FROM_ERIN
	const EVENT_KENJI_ON_BREAK
	const EVENT_GAVEN_ASKED_FOR_PHONE_NUMBER
	const EVENT_ROUTE_23_HIDDEN_ULTRA_BALL ; Kanto hack (M10 13e-1): renamed in place, was an unused const_skip in Crystal's phone block; Yellow's ROUTE 23 hidden item (19,70)
	const EVENT_BETH_ASKED_FOR_PHONE_NUMBER
	const EVENT_ROUTE_23_HIDDEN_MAX_ETHER ; Kanto hack (M10 13e-1): renamed in place, was an unused const_skip in Crystal's phone block; Yellow's ROUTE 23 hidden item (8,90)
	const EVENT_JOSE_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused in Crystal
	const EVENT_REENA_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused in Crystal
	const EVENT_JOEY_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused in Crystal
	const EVENT_WADE_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused in Crystal
	const EVENT_RALPH_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused in Crystal
	const EVENT_LIZ_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused in Crystal
	const EVENT_ANTHONY_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused in Crystal
	const EVENT_TODD_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused in Crystal
	const EVENT_GINA_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused in Crystal
	const EVENT_IRWIN_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused in Crystal
	const EVENT_ARNIE_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused in Crystal
	const EVENT_ALAN_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused in Crystal
	const_skip ; unused
	const_skip ; unused
	const EVENT_DANA_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused in Crystal
	const EVENT_CHAD_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused in Crystal
	const EVENT_DEREK_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused in Crystal
	const EVENT_TULLY_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused in Crystal
	const EVENT_BRENT_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused
	const EVENT_TIFFANY_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused in Crystal
	const EVENT_VANCE_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused in Crystal
	const EVENT_WILTON_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused in Crystal
	const EVENT_KENJI_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused in Crystal
	const EVENT_PARRY_ASKED_FOR_PHONE_NUMBER
	const_skip ; unused in Crystal
	const EVENT_ERIN_ASKED_FOR_PHONE_NUMBER
	const EVENT_BUENA_OFFERED_HER_PHONE_NUMBER_NO_BLUE_CARD
	const EVENT_GOT_TM18_COUNTER ; Kanto hack: renamed in place (M6 9r), was an unused const_skip; CELADON DEPT. STORE 3F clerk's TM64 COUNTER (Yellow's TM18)
; Ruins of Alph puzzles
	const EVENT_SOLVED_HO_OH_PUZZLE
	const EVENT_SOLVED_KABUTO_PUZZLE
	const EVENT_SOLVED_OMANYTE_PUZZLE
	const EVENT_SOLVED_AERODACTYL_PUZZLE
; Decorations
	const EVENT_DECO_BED_1
	const EVENT_DECO_BED_2
	const EVENT_DECO_BED_3
	const EVENT_DECO_BED_4
	const EVENT_DECO_CARPET_1
	const EVENT_DECO_CARPET_2
	const EVENT_DECO_CARPET_3
	const EVENT_DECO_CARPET_4
	const EVENT_DECO_PLANT_1
	const EVENT_DECO_PLANT_2
	const EVENT_DECO_PLANT_3
	const EVENT_DECO_POSTER_1
	const EVENT_DECO_POSTER_2
	const EVENT_DECO_POSTER_3
	const EVENT_DECO_POSTER_4
	const EVENT_DECO_FAMICOM
	const EVENT_DECO_SNES
	const EVENT_DECO_N64
	const EVENT_DECO_VIRTUAL_BOY
	const EVENT_DECO_PIKACHU_DOLL
	const EVENT_DECO_SURFING_PIKACHU_DOLL
	const EVENT_DECO_CLEFAIRY_DOLL
	const EVENT_DECO_JIGGLYPUFF_DOLL
	const EVENT_DECO_BULBASAUR_DOLL
	const EVENT_DECO_CHARMANDER_DOLL
	const EVENT_DECO_SQUIRTLE_DOLL
	const EVENT_DECO_POLIWAG_DOLL
	const EVENT_DECO_DIGLETT_DOLL
	const EVENT_DECO_STARYU_DOLL
	const EVENT_DECO_MAGIKARP_DOLL
	const EVENT_DECO_ODDISH_DOLL
	const EVENT_DECO_GENGAR_DOLL
	const EVENT_DECO_SHELLDER_DOLL
	const EVENT_DECO_GRIMER_DOLL
	const EVENT_DECO_VOLTORB_DOLL
	const EVENT_DECO_WEEDLE_DOLL
	const EVENT_DECO_UNOWN_DOLL
	const EVENT_DECO_GEODUDE_DOLL
	const EVENT_DECO_MACHOP_DOLL
	const EVENT_DECO_TENTACOOL_DOLL
	const EVENT_PLAYERS_ROOM_POSTER
	const EVENT_DECO_GOLD_TROPHY
	const EVENT_DECO_SILVER_TROPHY
	const EVENT_DECO_BIG_SNORLAX_DOLL
	const EVENT_DECO_BIG_ONIX_DOLL
	const EVENT_DECO_BIG_LAPRAS_DOLL
; More Johto story events
	const EVENT_WARPED_FROM_ROUTE_35_NATIONAL_PARK_GATE
	const EVENT_SWITCH_1
	const EVENT_SWITCH_2
	const EVENT_SWITCH_3
	const EVENT_EMERGENCY_SWITCH
	const EVENT_DOOR_1_OPEN
	const EVENT_DOOR_2_OPEN
	const EVENT_DOOR_3_OPEN
	const EVENT_DOOR_4_OPEN
	const EVENT_DOOR_5_OPEN
	const EVENT_DOOR_6_OPEN
	const EVENT_DOOR_7_OPEN
	const EVENT_DOOR_8_OPEN
	const EVENT_DOOR_9_OPEN
	const EVENT_DOOR_10_OPEN
	const EVENT_DOOR_11_OPEN
	const EVENT_UNCOVERED_STAIRCASE_IN_MAHOGANY_MART
	const EVENT_TURNED_OFF_SECURITY_CAMERAS
	const EVENT_SECURITY_CAMERA_1
	const EVENT_SECURITY_CAMERA_2
	const EVENT_SECURITY_CAMERA_3
	const EVENT_SECURITY_CAMERA_4
	const EVENT_SECURITY_CAMERA_5
	const EVENT_EXPLODING_TRAP_1
	const EVENT_EXPLODING_TRAP_2
	const EVENT_EXPLODING_TRAP_3
	const EVENT_EXPLODING_TRAP_4
	const EVENT_EXPLODING_TRAP_5
	const EVENT_EXPLODING_TRAP_6
	const EVENT_EXPLODING_TRAP_7
	const EVENT_EXPLODING_TRAP_8
	const EVENT_EXPLODING_TRAP_9
	const EVENT_EXPLODING_TRAP_10
	const EVENT_EXPLODING_TRAP_11
	const EVENT_EXPLODING_TRAP_12
	const EVENT_EXPLODING_TRAP_13
	const EVENT_EXPLODING_TRAP_14
	const EVENT_EXPLODING_TRAP_15
	const EVENT_EXPLODING_TRAP_16
	const EVENT_EXPLODING_TRAP_17
	const EVENT_EXPLODING_TRAP_18
	const EVENT_EXPLODING_TRAP_19
	const EVENT_EXPLODING_TRAP_20
	const EVENT_EXPLODING_TRAP_21
	const EVENT_EXPLODING_TRAP_22
	const EVENT_LEARNED_HAIL_GIOVANNI
	const EVENT_OPENED_DOOR_TO_ROCKET_HIDEOUT_TRANSMITTER
	const EVENT_LEARNED_SLOWPOKETAIL
	const EVENT_LEARNED_RATICATE_TAIL
	const EVENT_OPENED_DOOR_TO_GIOVANNIS_OFFICE
	const EVENT_GOLDENROD_DEPT_STORE_B1F_LAYOUT_1
	const EVENT_GOLDENROD_DEPT_STORE_B1F_LAYOUT_2
	const EVENT_GOLDENROD_DEPT_STORE_B1F_LAYOUT_3
	const EVENT_GOLDENROD_UNDERGROUND_WAREHOUSE_BLOCKED_OFF
	const EVENT_LEFT_MONS_WITH_CONTEST_OFFICER
	const EVENT_LORELEIS_ROOM_ENTRANCE_CLOSED
	const EVENT_LORELEIS_ROOM_EXIT_OPEN
	const EVENT_BRUNOS_ROOM_ENTRANCE_CLOSED
	const EVENT_BRUNOS_ROOM_EXIT_OPEN
	const EVENT_AGATHAS_ROOM_ENTRANCE_CLOSED
	const EVENT_AGATHAS_ROOM_EXIT_OPEN
	const EVENT_LANCES_ROOM_ENTRANCE_CLOSED
	const EVENT_LANCES_ROOM_EXIT_OPEN
	const EVENT_CHAMPIONS_ROOM_ENTRANCE_CLOSED
	const EVENT_CHAMPIONS_ROOM_EXIT_OPEN
	const EVENT_CONTEST_OFFICER_HAS_SUN_STONE
	const EVENT_CONTEST_OFFICER_HAS_EVERSTONE
	const EVENT_CONTEST_OFFICER_HAS_GOLD_BERRY
	const EVENT_CONTEST_OFFICER_HAS_BERRY
	const EVENT_FOUGHT_HO_OH
	const EVENT_FOUGHT_LUGIA
	const EVENT_BEAT_RIVAL_IN_DRAGONS_DEN ; Kanto hack (M11 14c, D142): renamed in place, was Crystal's never-set EVENT_BEAT_RIVAL_IN_MT_MOON
	const EVENT_GOT_SS_TICKET ; Kanto hack: renamed in place (6j, docs/M3-CERULEAN.md), was the now-dead EVENT_MET_BILLS_GRANDPA
	const EVENT_BILL_SAID_USE_CELL_SEPARATOR ; Kanto hack: renamed in place (6j, docs/M3-CERULEAN.md), was the now-dead EVENT_SHOWED_LICKITUNG_TO_BILLS_GRANDPA
	const EVENT_BILLS_HOUSE_BILL_POKEMON_HIDDEN ; Kanto hack: renamed in place (6j, docs/M3-CERULEAN.md), was the now-dead EVENT_SHOWED_ODDISH_TO_BILLS_GRANDPA
	const EVENT_BILLS_HOUSE_BILL_1_HIDDEN ; Kanto hack: renamed in place (6j, docs/M3-CERULEAN.md), was the now-dead EVENT_SHOWED_STARYU_TO_BILLS_GRANDPA
	const EVENT_BILLS_HOUSE_BILL_2_HIDDEN ; Kanto hack: renamed in place (6j, docs/M3-CERULEAN.md), was the now-dead EVENT_SHOWED_GROWLITHE_VULPIX_TO_BILLS_GRANDPA
	const EVENT_USED_CELL_SEPARATOR_ON_BILL ; Kanto hack: renamed in place (N1e), was the now-dead EVENT_SHOWED_PICHU_TO_BILLS_GRANDPA
	const EVENT_SS_ANNE_2F_ROOMS_RARE_CANDY ; Kanto hack: renamed in place (7h), was EVENT_GOT_EVERSTONE_FROM_BILLS_GRANDPA; S.S. ANNE 2F Rooms item ball (0,12)
	const EVENT_SS_ANNE_B1F_ROOMS_ETHER ; Kanto hack: renamed in place (7h), was EVENT_GOT_LEAF_STONE_FROM_BILLS_GRANDPA; S.S. ANNE B1F Rooms item ball (20,2)
	const EVENT_SS_ANNE_B1F_ROOMS_TM_REST ; Kanto hack: renamed in place (7h), was EVENT_GOT_WATER_STONE_FROM_BILLS_GRANDPA; S.S. ANNE B1F Rooms item ball (10,2)
	const EVENT_SS_ANNE_B1F_ROOMS_MAX_POTION ; Kanto hack: renamed in place (7h), was EVENT_GOT_FIRE_STONE_FROM_BILLS_GRANDPA; S.S. ANNE B1F Rooms item ball (12,11)
	const EVENT_SS_ANNE_B1F_ROOMS_HIDDEN_HYPER_POTION ; Kanto hack: renamed in place (7h), was EVENT_GOT_THUNDERSTONE_FROM_BILLS_GRANDPA; S.S. ANNE B1F Rooms hidden HYPER POTION (3,1)
	const EVENT_LISTENED_TO_INITIAL_RADIO
; More Crystal-exclusive events in Johto
	const EVENT_WALL_OPENED_IN_HO_OH_CHAMBER
	const EVENT_WALL_OPENED_IN_KABUTO_CHAMBER
	const EVENT_WALL_OPENED_IN_OMANYTE_CHAMBER
	const EVENT_WALL_OPENED_IN_AERODACTYL_CHAMBER
	const EVENT_ROUTE_17_HIDDEN_PP_UP ; Kanto hack: renamed in place (M6 9z), was a dead Gen 2 POKECOM CENTER flag; ROUTE 17 (17,72)
	const EVENT_WADE_HAS_BERRY
	const EVENT_WADE_HAS_PSNCUREBERRY
	const EVENT_WADE_HAS_PRZCUREBERRY
	const EVENT_WADE_HAS_BITTER_BERRY
	const EVENT_WILTON_HAS_ULTRA_BALL
	const EVENT_WILTON_HAS_GREAT_BALL
	const EVENT_WILTON_HAS_POKE_BALL
	const EVENT_HOLE_IN_BURNED_TOWER
	const EVENT_FOUGHT_EUSINE
	const EVENT_KOJI_ALLOWS_YOU_PASSAGE_TO_TIN_TOWER
	const EVENT_FOUGHT_SUICUNE
	const EVENT_GOT_RAINBOW_WING
	const EVENT_HUEY_PROTEIN
	const EVENT_JOEY_HP_UP
	const EVENT_VANCE_CARBOS
	const EVENT_PARRY_IRON
	const EVENT_ERIN_CALCIUM
	const EVENT_BUENA_OFFERED_HER_PHONE_NUMBER
	const EVENT_MET_BUENA
	const EVENT_GOT_ODD_EGG
	const EVENT_BEAT_ZAPDOS ; Kanto hack (M10 13l): was a const_skip (unused) row; Yellow's flag of the same name; ZAPDOS (4,9)'s hide flag, set on win/catch/run
	const EVENT_GOT_GS_BALL_FROM_GOLDENROD_POKEMON_CENTER
; Unused: next 167 events

	const_next 1000
; Trainer flags
; Swimmer F
	const EVENT_BEAT_SWIMMERF_ELAINE
	const EVENT_BEAT_SWIMMERF_PAULA
	const EVENT_BEAT_SWIMMERF_KAYLEE
	const EVENT_BEAT_SWIMMERF_SUSIE
	const EVENT_BEAT_SWIMMERF_DENISE
	const EVENT_BEAT_SWIMMERF_KARA
	const EVENT_BEAT_SWIMMERF_WENDY
	const EVENT_BEAT_MEDIUM_ALMA ; Kanto hack: renamed in place (M6 9h).  Was
; EVENT_BEAT_SWIMMERF_LISA, dead in a Kanto-first game.  ALMA is the first
; CHANNELER on POKéMON TOWER 6F.  Flag indexes are positional and
; savestate-visible, so a dead flag is renamed, never deleted.
	const EVENT_BEAT_MEDIUM_NORA ; Kanto hack: renamed in place (M6 9h).
; Was EVENT_BEAT_SWIMMERF_JILL.  POKéMON TOWER 6F CHANNELER 2.
	const EVENT_BEAT_MEDIUM_VERA ; Kanto hack: renamed in place (M6 9h).
; Was EVENT_BEAT_SWIMMERF_MARY.  POKéMON TOWER 6F CHANNELER 3.
	const EVENT_POKEMON_TOWER_6F_RARE_CANDY ; Kanto hack: renamed in place
; (M6 9h).  Was EVENT_BEAT_SWIMMERF_KATIE.
	const EVENT_BEAT_ROUTE_19_TRAINER_0 ; Kanto hack (M9 12c): renamed in
; place, was EVENT_BEAT_SWIMMERF_DAWN.  Yellow's own flag name.
	const EVENT_POKEMON_TOWER_6F_X_ACCURACY ; Kanto hack: renamed in place
; (M6 9h).  Was EVENT_BEAT_SWIMMERF_TARA.
	const EVENT_BEAT_ROUTE_19_TRAINER_1 ; Kanto hack (M9 12c): renamed in
; place, was EVENT_BEAT_SWIMMERF_NICOLE.  Yellow's own flag name.
	const EVENT_BEAT_ROUTE_19_TRAINER_2 ; Kanto hack (M9 12c): renamed in
; place, was EVENT_BEAT_SWIMMERF_LORI.  Yellow's own flag name.
	const EVENT_BEAT_GHOST_MAROWAK ; Kanto hack: renamed in place (M6 9h).
; Was EVENT_BEAT_SWIMMERF_JODY.  Yellow's EVENT_BEAT_GHOST_MAROWAK: set when
; the restless soul on POKéMON TOWER 6F is calmed, which unblocks the 7F
; stairs at (9,16).
	const EVENT_BEAT_ROUTE_19_TRAINER_3 ; Kanto hack (M9 12c): renamed in
; place, was EVENT_BEAT_SWIMMERF_NIKKI.  Yellow's own flag name.
	const EVENT_BEAT_PICNICKER_DIANA ; Kanto hack: renamed in place (6e,
; docs/M3-CERULEAN.md).  Was EVENT_BEAT_SWIMMERF_DIANA; Yellow's Cerulean Gym
; JR.TRAINER^F is a PICNICKER named DIANA, so the flag keeps its meaning.
	const EVENT_MR_FUJIS_HOUSE_MR_FUJI_HIDDEN ; Kanto hack: renamed in place
; (M5 8h).  Was EVENT_BEAT_SWIMMERF_BRIANA, dead since 6e (Crystal's third
; Cerulean Gym swimmer is gone); flag indexes are positional and
; savestate-visible, so a dead flag is renamed, never deleted.  MR FUJI is not
; standing at (3,1) in MR_FUJIS_HOUSE (his object's hide flag -- SET means
; hidden, so it is the inverse of EVENT_RESCUED_MR_FUJI and is owned by
; MrFujisHouseObjectsCallback, which derives it on every map load).
; Bird Keeper
	const EVENT_BEAT_BIRD_KEEPER_ROD
	const EVENT_BEAT_BIRD_KEEPER_ABE
	const EVENT_BEAT_BIRD_KEEPER_BRYAN
	const EVENT_BEAT_BIRD_KEEPER_THEO
	const EVENT_BEAT_BIRD_KEEPER_TOBY
	const EVENT_BEAT_BIRD_KEEPER_DENIS
	const EVENT_BEAT_BIRD_KEEPER_VANCE
	const EVENT_BEAT_LASS_TAMARA ; Kanto hack: Route 4, Yellow's LASS 4 (was EVENT_BEAT_BIRD_KEEPER_HANK)
	const EVENT_BEAT_ROUTE_14_BIRD_KEEPER_7 ; Kanto hack (M7 10d): renamed in place, was EVENT_BEAT_BIRD_KEEPER_ROY -- Crystal's own ROUTE 14 bird keeper, deleted by 10d
	const EVENT_BEAT_ROUTE_18_BIRD_KEEPER_1 ; Kanto hack (M6 9aa): renamed in place, was EVENT_BEAT_BIRD_KEEPER_BORIS -- Crystal's ROUTE 18 pair is gone
	const EVENT_BEAT_ROUTE_18_BIRD_KEEPER_2 ; Kanto hack (M6 9aa): renamed in place, was EVENT_BEAT_BIRD_KEEPER_BOB
	const EVENT_BEAT_ROCKET_HIDEOUT_B1F_ROCKET_5 ; Kanto hack: renamed in place (M6 9w), was EVENT_BEAT_BIRD_KEEPER_JOSE -- an unreferenced Gen 2 trainer flag; Yellow's EVENT_BEAT_ROCKET_HIDEOUT_1_TRAINER_4, the B1F Rocket who opens the door to the lift
	const EVENT_BEAT_BIRD_KEEPER_PETER
	const EVENT_BEAT_BIRD_KEEPER_JOSE2
	const EVENT_BEAT_ROUTE_13_BIRD_KEEPER_4 ; Kanto hack (M7 10c): renamed in place, was EVENT_BEAT_BIRD_KEEPER_PERRY -- Crystal's own ROUTE 13 bird keeper, deleted by 10c
	const EVENT_BEAT_ROUTE_13_BIRD_KEEPER_5 ; Kanto hack (M7 10c): renamed in place, was EVENT_BEAT_BIRD_KEEPER_BRET
	const EVENT_CELADON_GAME_CORNER_COIN_1 ; Kanto hack: renamed in place (M6 9u), was EVENT_BEAT_BIRD_KEEPER_JOSE3 -- a dead Gen 2 phone-rematch flag (the Pokegear and the rematch system are cut); CELADON GAME CORNER hidden coins (0,8), 10
	const EVENT_CELADON_GAME_CORNER_COIN_2 ; Kanto hack: renamed in place (M6 9u), was EVENT_BEAT_BIRD_KEEPER_VANCE2 -- a dead Gen 2 phone-rematch flag (the Pokegear and the rematch system are cut); CELADON GAME CORNER hidden coins (1,16), 10
	const EVENT_CELADON_GAME_CORNER_COIN_3 ; Kanto hack: renamed in place (M6 9u), was EVENT_BEAT_BIRD_KEEPER_VANCE3 -- a dead Gen 2 phone-rematch flag (the Pokegear and the rematch system are cut); CELADON GAME CORNER hidden coins (3,11), 20
; Boarder
	const EVENT_BEAT_BOARDER_RONALD
	const EVENT_BEAT_BOARDER_BRAD
	const EVENT_BEAT_BOARDER_DOUGLAS
; Sage
	const EVENT_BEAT_SAGE_CHOW
	const EVENT_BEAT_SAGE_NICO
	const EVENT_BEAT_SAGE_JIN
	const EVENT_BEAT_SAGE_TROY
	const EVENT_BEAT_SAGE_JEFFREY
	const EVENT_BEAT_SAGE_PING
	const EVENT_BEAT_SAGE_EDMOND
	const EVENT_BEAT_SAGE_NEAL
	const EVENT_BEAT_SAGE_LI
; Camper
	const EVENT_BEAT_CAMPER_ROLAND
	const EVENT_BEAT_CAMPER_TODD
	const EVENT_BEAT_CAMPER_IVAN
	const EVENT_BEAT_CAMPER_ELLIOT
	const EVENT_BEAT_FUCHSIA_GYM_TRAINER_0 ; Kanto hack (M7 10h): renamed in place, was EVENT_BEAT_CAMPER_BARRY
	const EVENT_BEAT_CAMPER_WENDELL ; Kanto hack: renamed in place (6i), was EVENT_BEAT_CAMPER_LLOYD; Route 25, Yellow's JR_TRAINER_M 2
	const EVENT_BEAT_CAMPER_DEAN
	const EVENT_BEAT_YOUNGSTER_AJ ; Kanto hack: renamed in place (M5 8c), was EVENT_BEAT_CAMPER_SID (Crystal's Route 9 CAMPER SID, deleted by 8c); ROUTE 9, Yellow's YOUNGSTER 14 "A.J."
	const EVENT_BEAT_CAMPER_LESTER ; Kanto hack: renamed in place (M5 8l), was the dead EVENT_BEAT_CAMPER_HERVEY; ROUTE 12, Yellow's JR_TRAINER_M 9
	const EVENT_BEAT_GUITARIST_SPARKY ; Kanto hack: renamed in place (M5 8l), was the dead EVENT_BEAT_CAMPER_DALE; ROUTE 12, Yellow's ROCKER 2 (no GUITARIST row is dead -- same out-of-class swap 8j made for SUPER_NERD CLARK)
	const EVENT_BEAT_CAMPER_TED
	const EVENT_CELADON_GAME_CORNER_COIN_4 ; Kanto hack: renamed in place (M6 9u), was EVENT_BEAT_CAMPER_TODD2 -- a dead Gen 2 phone-rematch flag (the Pokegear and the rematch system are cut); CELADON GAME CORNER hidden coins (3,14), 10
	const EVENT_CELADON_GAME_CORNER_COIN_5 ; Kanto hack: renamed in place (M6 9u), was EVENT_BEAT_CAMPER_TODD3 -- a dead Gen 2 phone-rematch flag (the Pokegear and the rematch system are cut); CELADON GAME CORNER hidden coins (4,12), 10
	const EVENT_BEAT_ROUTE_16_CUE_BALL_3 ; Kanto hack: renamed in place (M6 9y), was EVENT_BEAT_CAMPER_THOMAS -- dead in vanilla Crystal too (no map ever references it); ROUTE 16 (6,10), Yellow's OPP_CUE_BALL 3
	const EVENT_BEAT_ROUTE_16_SNORLAX ; Kanto hack: renamed in place (M6 9y), was EVENT_BEAT_CAMPER_LEROY -- dead in vanilla Crystal too; ROUTE 16 (26,10), doubles as the SNORLAX object's hide flag
	const EVENT_BEAT_ROUTE_17_BIKER_5 ; Kanto hack: renamed in place (M6 9z), dead in vanilla Crystal too; ROUTE 17 (10,118), Yellow's OPP_BIKER 12
	const EVENT_BEAT_ROUTE_17_CUE_BALL_1 ; Kanto hack: renamed in place (M6 9z), dead in vanilla Crystal too; ROUTE 17 (12,19), Yellow's OPP_CUE_BALL 4
	const EVENT_BEAT_CAMPER_JERRY
	const EVENT_BEAT_CAMPER_SPENCER
; Burglar
	const EVENT_BEAT_BURGLAR_DUNCAN
	const EVENT_BEAT_BURGLAR_EDDIE
	const EVENT_BEAT_BURGLAR_COREY
	const EVENT_POWER_PLANT_TM_THUNDER ; Kanto hack (M10 13l): was a const_skip (unused) row; ball (26,32), TM25
; Biker
; Kanto hack (M6 9y): Yellow's three ROUTE 16 BIKERs (OPP_BIKER 5/6/7).  Rows 1
; and 2 were BIKER_BENNY / KAZU, dead in vanilla Crystal; row 3 was BIKER_DWAYNE,
; Crystal's ROUTE 8 biker, deleted by M5 8j.  D34 gave CUE BALL its own trainer
; class, so the old "reserved for Yellow's CUE_BALLs" note here is superseded.
	const EVENT_BEAT_ROUTE_16_BIKER_1 ; was EVENT_BEAT_BIKER_BENNY; ROUTE 16 (17,12)
	const EVENT_BEAT_ROUTE_16_BIKER_2 ; was EVENT_BEAT_BIKER_KAZU; ROUTE 16 (9,11)
	const EVENT_BEAT_ROUTE_16_BIKER_3 ; was EVENT_BEAT_BIKER_DWAYNE; ROUTE 16 (3,12)
	const EVENT_BEAT_ROUTE_16_CUE_BALL_1 ; was EVENT_BEAT_BIKER_HARRIS (dead, Crystal's ROUTE 8); ROUTE 16 (14,13)
	const EVENT_BEAT_ROUTE_16_CUE_BALL_2 ; was EVENT_BEAT_BIKER_ZEKE (dead, Crystal's ROUTE 8); ROUTE 16 (11,12)
; Kanto hack (M6 9z): Yellow's ROUTE 17 (CYCLING ROAD) -- five OPP_BIKERs and
; five OPP_CUE_BALLs.  The four rows here were Crystal's CHARLES/RILEY/JOEL/
; GLENN, deleted with Crystal's ROUTE 17; the rest are dead rows renamed in
; place elsewhere in this file (CAMPER_DAVID/JOHN, BEAUTY_CARLENE/JESSICA/
; RACHAEL/ANGELICA).
	const EVENT_BEAT_ROUTE_17_BIKER_1 ; was EVENT_BEAT_BIKER_CHARLES (Crystal's ROUTE 17, deleted by 9z); ROUTE 17 (4,18), Yellow's OPP_BIKER 8
	const EVENT_BEAT_ROUTE_17_BIKER_2 ; was EVENT_BEAT_BIKER_RILEY; ROUTE 17 (7,32), Yellow's OPP_BIKER 9
	const EVENT_BEAT_ROUTE_17_BIKER_3 ; was EVENT_BEAT_BIKER_JOEL; ROUTE 17 (14,34), Yellow's OPP_BIKER 10
	const EVENT_BEAT_ROUTE_17_BIKER_4 ; was EVENT_BEAT_BIKER_GLENN; ROUTE 17 (5,98), Yellow's OPP_BIKER 11
; Psychic
	const EVENT_BEAT_PSYCHIC_NATHAN
	const EVENT_VICTORY_ROAD_3F_TM_EXPLOSION ; Kanto hack (M10 13g): renamed in place, was EVENT_BEAT_PSYCHIC_FRANKLIN (dead); ball (7,7), TM82
	const EVENT_BEAT_SCIENTIST_MAXWELL ; Kanto hack: renamed in place (7l), was the dead EVENT_BEAT_PSYCHIC_HERMAN; ROUTE 11, Yellow's ENGINEER 2
	const EVENT_BEAT_SCIENTIST_THURSTON ; Kanto hack: renamed in place (7l), was the dead EVENT_BEAT_PSYCHIC_FIDEL; ROUTE 11, Yellow's ENGINEER 3
	const EVENT_BEAT_PSYCHIC_GREG
	const EVENT_BEAT_PSYCHIC_NORMAN
	const EVENT_BEAT_PSYCHIC_MARK
	const EVENT_BEAT_PSYCHIC_PHIL
	const EVENT_BEAT_PSYCHIC_RICHARD
	const EVENT_BEAT_PSYCHIC_GILBERT
	const EVENT_BEAT_MOLTRES ; Kanto hack (M10 13g): renamed in place, was EVENT_BEAT_PSYCHIC_JARED (dead); Yellow's flag of the same name; MOLTRES (11,5)'s hide flag, set on win/catch/run
	const EVENT_BEAT_PSYCHIC_RODNEY
; Firebreather
	const EVENT_BEAT_BUG_CATCHER_COLTON ; Kanto hack: was EVENT_BEAT_FIREBREATHER_OTIS; Route 3, Yellow's BUG_CATCHER 4
	const EVENT_ROUTE22_RIVAL_2 ; Kanto hack (M10 13c): was EVENT_BEAT_FIREBREATHER_DICK (never referenced, even in vanilla Crystal; renamed in place).  Route 22 rival #2's object hide flag; the OBJECTS callback derives it on every load
	const EVENT_BEAT_ROUTE22_RIVAL_2ND_BATTLE ; Kanto hack (M10 13c): was EVENT_BEAT_FIREBREATHER_NED (never referenced, even in vanilla Crystal; renamed in place).  Yellow's flag of the same name, set on the win
	const EVENT_BEAT_LASS_JANICE ; Kanto hack: was EVENT_BEAT_FIREBREATHER_BURT; Route 3, Yellow's LASS 1
	const EVENT_BEAT_FIREBREATHER_BILL
	const EVENT_BEAT_FIREBREATHER_WALT
	const EVENT_BEAT_FIREBREATHER_RAY
	const EVENT_BEAT_FIREBREATHER_LYLE
; Fisher
	const EVENT_BEAT_FISHER_JUSTIN
	const EVENT_BEAT_FISHER_RALPH
	const EVENT_BEAT_ROUTE_19_TRAINER_4 ; Kanto hack (M9 12c): renamed in
; place, was EVENT_BEAT_FISHER_ARNOLD.  Yellow's own flag name.
	const EVENT_BEAT_FISHER_KYLE ; Kanto hack (M5 8l): ROUTE 12, Yellow's FISHER 3 (kept the name, re-partied to Yellow's)
	const EVENT_BEAT_FISHER_HENRY
	const EVENT_BEAT_FISHER_MARVIN
	const EVENT_BEAT_FISHER_TULLY
	const EVENT_BEAT_FISHER_ANDRE
	const EVENT_BEAT_FISHER_RAYMOND
	const EVENT_BEAT_FISHER_WILTON
	const EVENT_BEAT_FISHER_EDGAR
	const EVENT_BEAT_FISHER_JONAH
	const EVENT_BEAT_FISHER_MARTIN ; Kanto hack (M5 8l): ROUTE 12, Yellow's FISHER 4
	const EVENT_BEAT_FISHER_STEPHEN ; Kanto hack (M5 8l): ROUTE 12, Yellow's FISHER 5
	const EVENT_BEAT_FISHER_BARNEY ; Kanto hack (M5 8l): ROUTE 12, Yellow's FISHER 6
	const EVENT_BEAT_FISHER_DALTON ; Kanto hack: renamed in place (7h), was EVENT_BEAT_FISHER_RALPH2; S.S. ANNE 2F Rooms, Yellow's FISHER 1
	const EVENT_BEAT_FISHER_PERCY ; Kanto hack: renamed in place (7h), was EVENT_BEAT_FISHER_RALPH3; S.S. ANNE B1F Rooms, Yellow's FISHER 2
	const EVENT_BEAT_FISHER_ELWOOD ; Kanto hack: renamed in place (M5 8l), was the dead EVENT_BEAT_FISHER_TULLY2; ROUTE 12, Yellow's FISHER 11
	const EVENT_CELADON_GAME_CORNER_COIN_6 ; Kanto hack: renamed in place (M6 9u), was EVENT_BEAT_FISHER_TULLY3 -- a dead Gen 2 phone-rematch flag (the Pokegear and the rematch system are cut); CELADON GAME CORNER hidden coins (9,12), 20
	const EVENT_CELADON_GAME_CORNER_COIN_7 ; Kanto hack: renamed in place (M6 9u), was EVENT_BEAT_FISHER_WILTON2 -- a dead Gen 2 phone-rematch flag (the Pokegear and the rematch system are cut); CELADON GAME CORNER hidden coins (9,15), 10
	const EVENT_BEAT_FISHER_SCOTT
	const EVENT_CELADON_GAME_CORNER_COIN_8 ; Kanto hack: renamed in place (M6 9u), was EVENT_BEAT_FISHER_WILTON3 -- a dead Gen 2 phone-rematch flag (the Pokegear and the rematch system are cut); CELADON GAME CORNER hidden coins (16,14), 10
; Twins
	const EVENT_BEAT_TWINS_AMY_AND_MAY
	const EVENT_BEAT_TWINS_ANN_AND_ANNE
	const EVENT_ROUTE_12_HIDDEN_HYPER_POTION ; Kanto hack: renamed in place (M5 8n audit), was EVENT_BEAT_TWINS_ANN_AND_ANNE2 -- a Gen 2 phone-rematch flag, permanently dead here because Route37 sets EVENT_BEAT_TWINS_ANN_AND_ANNE for both parties and the Pokegear is cut.  ROUTE 12's hidden HYPER POTION at (2,63) (Yellow data/events/hidden_events.asm:429)
	const EVENT_BEAT_ROCKET_HIDEOUT_B1F_ROCKET_1 ; Kanto hack (M6 9x): ROCKET HIDEOUT B1F (26,8) (was EVENT_BEAT_TWINS_AMY_AND_MAY2, a dead Johto rematch flag)
	const EVENT_BEAT_BEAUTY_POPPY ; Kanto hack: renamed in place (M6 9q), was EVENT_BEAT_TWINS_JO_AND_ZOE -- Yellow's CELADON GYM has no twins; CELADON GYM trainer 5 (Yellow BEAUTY 3)
	const EVENT_BEAT_LASS_HOLLY ; Kanto hack: renamed in place (M6 9q), was EVENT_BEAT_TWINS_JO_AND_ZOE2 (a dead Crystal duplicate -- both twins shared the flag above); CELADON GYM trainer 4 (Yellow LASS 18)
	const EVENT_BEAT_TWINS_MEG_AND_PEG
	const EVENT_BEAT_ROCKET_HIDEOUT_B1F_ROCKET_2 ; Kanto hack (M6 9x): ROCKET HIDEOUT B1F (12,6) (was EVENT_BEAT_TWINS_MEG_AND_PEG2, a dead Johto rematch flag)
; Schoolboy
	const EVENT_BEAT_SCHOOLBOY_JACK
	const EVENT_BEAT_ROUTE_15_PICNICKER_7 ; Kanto hack: renamed in place (M7 10e); was EVENT_BEAT_SCHOOLBOY_KIP (Crystal's dead ROUTE 15 KIPP)
	const EVENT_BEAT_SCHOOLBOY_ALAN
	const EVENT_BEAT_ROUTE_15_BIRD_KEEPER_13 ; Kanto hack: renamed in place (M7 10e); was EVENT_BEAT_SCHOOLBOY_JOHNNY (Crystal's dead ROUTE 15 JOHNNY)
	const EVENT_BEAT_FUCHSIA_GYM_TRAINER_5 ; Kanto hack (M7 10h): renamed in place, was EVENT_BEAT_SCHOOLBOY_DANNY
	const EVENT_BEAT_ROUTE_15_PICNICKER_8 ; Kanto hack: renamed in place (M7 10e); was EVENT_BEAT_SCHOOLBOY_TOMMY (Crystal's dead ROUTE 15 TOMMY)
	const EVENT_BEAT_YOUNGSTER_GRANT ; Kanto hack: renamed in place (6i), was EVENT_BEAT_SCHOOLBOY_DUDLEY; Route 25, Yellow's YOUNGSTER 5
	const EVENT_BEAT_YOUNGSTER_COLE ; Kanto hack: renamed in place (6i/N1e), was EVENT_BEAT_SCHOOLBOY_JOE; Route 25, Yellow's YOUNGSTER 6
	const EVENT_BEAT_ROUTE_15_BIRD_KEEPER_14 ; Kanto hack: renamed in place (M7 10e); was EVENT_BEAT_SCHOOLBOY_BILLY (Crystal's dead ROUTE 15 BILLY)
	const EVENT_BEAT_SCHOOLBOY_CHAD
	const EVENT_BEAT_SCHOOLBOY_NATE
	const EVENT_BEAT_SCHOOLBOY_RICKY
	const EVENT_CELADON_GAME_CORNER_COIN_9 ; Kanto hack: renamed in place (M6 9u), was EVENT_BEAT_SCHOOLBOY_JACK2 -- a dead Gen 2 phone-rematch flag (the Pokegear and the rematch system are cut); CELADON GAME CORNER hidden coins (10,16), 10
	const EVENT_CELADON_GAME_CORNER_COIN_10 ; Kanto hack: renamed in place (M6 9u), was EVENT_BEAT_SCHOOLBOY_JACK3 -- a dead Gen 2 phone-rematch flag (the Pokegear and the rematch system are cut); CELADON GAME CORNER hidden coins (11,7), 40
	const EVENT_CELADON_GAME_CORNER_COIN_11 ; Kanto hack: renamed in place (M6 9u), was EVENT_BEAT_SCHOOLBOY_ALAN2 -- a dead Gen 2 phone-rematch flag (the Pokegear and the rematch system are cut); CELADON GAME CORNER hidden coins (15,8), 100
	const EVENT_CELADON_GAME_CORNER_COIN_12 ; Kanto hack: renamed in place (M6 9u), was EVENT_BEAT_SCHOOLBOY_ALAN3 -- a dead Gen 2 phone-rematch flag (the Pokegear and the rematch system are cut); CELADON GAME CORNER hidden coins (12,15), 10 -- shadowed by the slot machine on the same tile, as in Yellow
	const EVENT_GOT_COINS_FROM_GAME_CORNER_GURU_1 ; Kanto hack: renamed in place (M6 9u), was EVENT_BEAT_SCHOOLBOY_CHAD2 -- a dead Gen 2 phone-rematch flag (the Pokegear and the rematch system are cut); CELADON GAME CORNER, Yellow's FISHING GURU 1 (5,11) and his 10 coins
	const EVENT_GOT_COINS_FROM_GAME_CORNER_MAN ; Kanto hack: renamed in place (M6 9u), was EVENT_BEAT_SCHOOLBOY_CHAD3 -- a dead Gen 2 phone-rematch flag (the Pokegear and the rematch system are cut); CELADON GAME CORNER, Yellow's MIDDLE AGED MAN 2 (14,11) and his 20 coins
; Picnicker
	const EVENT_BEAT_PICNICKER_LIZ
	const EVENT_BEAT_PICNICKER_GINA
	const EVENT_BEAT_PICNICKER_BROOKE
	const EVENT_BEAT_PICNICKER_KIM
	const EVENT_BEAT_FUCHSIA_GYM_TRAINER_1 ; Kanto hack (M7 10h): renamed in place, was EVENT_BEAT_PICNICKER_CINDY
	const EVENT_BEAT_HIKER_MARCOS ; Kanto hack: renamed in place (5e), was EVENT_BEAT_PICNICKER_HOPE
	const EVENT_BEAT_YOUNGSTER_DUSTIN ; Kanto hack: renamed in place (5e), was EVENT_BEAT_PICNICKER_SHARON
	const EVENT_BEAT_PICNICKER_DEBRA
	const EVENT_BEAT_PICNICKER_GRETCHEN ; Kanto hack: renamed in place (M5 8d), was the dead EVENT_BEAT_PICNICKER_GINA2; ROUTE 10, Yellow's JR_TRAINER_F 7
	const EVENT_BEAT_PICNICKER_ERIN
	const EVENT_BEAT_PICNICKER_MABEL ; Kanto hack: renamed in place (M5 8d), was the dead EVENT_BEAT_PICNICKER_LIZ2; ROUTE 10, Yellow's JR_TRAINER_F 8
	const EVENT_BEAT_PICNICKER_THELMA ; Kanto hack: renamed in place (M5 8e), was the dead EVENT_BEAT_PICNICKER_LIZ3; ROCK TUNNEL 1F, Yellow's JR_TRAINER_F 17
	const EVENT_BEAT_PICNICKER_HEIDI
	const EVENT_BEAT_PICNICKER_EDNA
	const EVENT_BEAT_PICNICKER_NELLIE ; Kanto hack: renamed in place (M5 8e), was the dead EVENT_BEAT_PICNICKER_GINA3; ROCK TUNNEL 1F, Yellow's JR_TRAINER_F 18
	const EVENT_BEAT_PICNICKER_MYRNA ; Kanto hack: renamed in place (M5 8e), was the dead EVENT_BEAT_PICNICKER_TIFFANY2; ROCK TUNNEL 1F, Yellow's JR_TRAINER_F 19
	const EVENT_BEAT_PICNICKER_RHODA ; Kanto hack: renamed in place (M5 8f), was the dead EVENT_BEAT_PICNICKER_TIFFANY3; ROCK TUNNEL B1F, Yellow's JR_TRAINER_F 9
	const EVENT_BEAT_PICNICKER_OPAL ; Kanto hack: renamed in place (M5 8f), was the dead EVENT_BEAT_PICNICKER_ERIN2; ROCK TUNNEL B1F, Yellow's JR_TRAINER_F 10
	const EVENT_BEAT_PICNICKER_TANYA
	const EVENT_BEAT_PICNICKER_TIFFANY
	const EVENT_BEAT_ROCKET_HIDEOUT_B1F_ROCKET_3 ; Kanto hack (M6 9x): ROCKET HIDEOUT B1F (18,17) (was EVENT_BEAT_PICNICKER_ERIN3, a dead Johto rematch flag)
; Guitarist
	const EVENT_BEAT_GUITARIST_CLYDE
	const EVENT_BEAT_GUITARIST_VINCENT
; Juggler
	const EVENT_BEAT_JUGGLER_IRWIN
	const EVENT_BEAT_JUGGLER_FRITZ
	const EVENT_BEAT_SAILOR_DEWEY ; Kanto hack: renamed in place (7k), was EVENT_BEAT_JUGGLER_HORTON; VERMILION GYM, Yellow's SAILOR 8
	const EVENT_FOUND_ROCKET_HIDEOUT ; Kanto hack: renamed in place (M6 9u), was EVENT_BEAT_JUGGLER_IRWIN2 -- a dead Gen 2 phone-rematch flag (the Pokegear and the rematch system are cut); Yellow's own flag: the poster switch behind the CELADON GAME CORNER Rocket
	const EVENT_CELADON_GAME_CORNER_ROCKET_HIDDEN ; Kanto hack: renamed in place (M6 9u), was EVENT_BEAT_JUGGLER_IRWIN3 -- a dead Gen 2 phone-rematch flag (the Pokegear and the rematch system are cut); CELADON GAME CORNER, the Rocket guard's object flag (set by disappear)
; Gentleman
	const EVENT_BEAT_GENTLEMAN_PRESTON
	const EVENT_BEAT_GENTLEMAN_EDWARD
	const EVENT_BEAT_GENTLEMAN_GREGORY
	const EVENT_BEAT_GENTLEMAN_THEODORE ; Kanto hack: renamed in place (7h), was EVENT_BEAT_GENTLEMAN_VIRGIL; S.S. ANNE 1F Rooms, Yellow's GENTLEMAN 1
	const EVENT_BEAT_GENTLEMAN_ALFRED
; Scientist
	const EVENT_BEAT_SCIENTIST_ROSS
	const EVENT_BEAT_SCIENTIST_MITCH
	const EVENT_BEAT_SCIENTIST_JED
	const EVENT_BEAT_SCIENTIST_MARC
	const EVENT_BEAT_SCIENTIST_RICH
; Blackbelt
	const EVENT_BEAT_ROCKET_HIDEOUT_B1F_ROCKET_4 ; Kanto hack (M6 9x): ROCKET HIDEOUT B1F (15,25) (was EVENT_BEAT_BLACKBELT_KENJI2, a dead Johto rematch flag)
	const EVENT_BEAT_BLACKBELT_YOSHI
	const EVENT_BEAT_ROCKET_HIDEOUT_B2F_ROCKET ; Kanto hack (M6 9x): ROCKET HIDEOUT B2F (20,12) (was EVENT_BEAT_BLACKBELT_KENJI3, a dead Johto rematch flag)
	const EVENT_BEAT_BLACKBELT_LAO
	const EVENT_BEAT_BLACKBELT_NOB
	const EVENT_BEAT_BLACKBELT_KIYO
	const EVENT_BEAT_BLACKBELT_LUNG
	const EVENT_BEAT_BLACKBELT_KENJI
	const EVENT_BEAT_BLACKBELT_WAI
; Beauty
	const EVENT_BEAT_BEAUTY_VICTORIA
	const EVENT_BEAT_BEAUTY_SAMANTHA
; Kanto hack (M6 9f): the four #MON TOWER 3F/4F item balls.  Renamed in place
; from the dead EVENT_BEAT_BEAUTY_JULIE / _JACLYN / _BRENDA / _CAROLINE (Crystal
; BEAUTY rows no map references); moving the consts instead of renaming them
; would renumber every flag after this point and break existing saves, so the
; itemball flags live in the BEAUTY block -- the same trade the ROUTE 9 TM and
; the ROUTE 12 HYPER POTION rows already make.
	const EVENT_POKEMON_TOWER_3F_ESCAPE_ROPE
	const EVENT_POKEMON_TOWER_4F_ELIXER
	const EVENT_POKEMON_TOWER_4F_AWAKENING
	const EVENT_BEAT_BEAUTY_CASSIE
	const EVENT_POKEMON_TOWER_4F_HP_UP
	const EVENT_BEAT_ROUTE_17_CUE_BALL_2 ; Kanto hack: renamed in place (M6 9z), dead in vanilla Crystal too; ROUTE 17 (11,16), Yellow's OPP_CUE_BALL 5
	const EVENT_BEAT_ROUTE_17_CUE_BALL_3 ; Kanto hack: renamed in place (M6 9z), dead in vanilla Crystal too; ROUTE 17 (17,58), Yellow's OPP_CUE_BALL 6
	const EVENT_BEAT_ROUTE_17_CUE_BALL_4 ; Kanto hack: renamed in place (M6 9z), dead in vanilla Crystal too; ROUTE 17 (2,68), Yellow's OPP_CUE_BALL 7
	const EVENT_BEAT_ROUTE_17_CUE_BALL_5 ; Kanto hack: renamed in place (M6 9z), dead in vanilla Crystal too; ROUTE 17 (14,98), Yellow's OPP_CUE_BALL 8
	const EVENT_BEAT_FUCHSIA_GYM_TRAINER_4 ; Kanto hack (M7 10h): renamed in place, was EVENT_BEAT_BEAUTY_KENDRA
	const EVENT_BEAT_BEAUTY_LILY ; Kanto hack: renamed in place (M6 9q), was the dead EVENT_BEAT_BEAUTY_VERONICA; CELADON GYM trainer 1 (Yellow BEAUTY 1)
	const EVENT_BEAT_BEAUTY_JULIA
	const EVENT_POKEMON_TOWER_5F_IN_PURIFIED_ZONE ; Kanto hack (M6 9g): was the dead EVENT_BEAT_BEAUTY_THERESA.  D23's heal latch -- set by #MON TOWER 5F's purified-zone coord_events, cleared by its MAPCALLBACK_NEWMAP, so the free heal happens once per visit to the floor
	const EVENT_BEAT_BEAUTY_VALERIE
; Johto Gym Leaders
	const EVENT_BEAT_FALKNER
	const EVENT_BEAT_BUGSY
	const EVENT_BEAT_WHITNEY
	const EVENT_BEAT_MORTY
	const EVENT_BEAT_JASMINE
	const EVENT_BEAT_CHUCK
	const EVENT_BEAT_PRYCE
	const EVENT_BEAT_CLAIR
; Kanto Gym Leaders
	const EVENT_BEAT_BROCK
	const EVENT_BEAT_MISTY
	const EVENT_BEAT_LTSURGE
	const EVENT_BEAT_ERIKA
	const EVENT_BEAT_KOGA ; Kanto hack (M7 10h): renamed in place, was EVENT_BEAT_JANINE
	const EVENT_BEAT_SABRINA
	const EVENT_BEAT_BLAINE
	const EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI ; Kanto hack (M10 13b): was EVENT_BEAT_BLUE (dead, renamed in place)
; PokefanM
	const EVENT_BEAT_POKEFANM_WILLIAM
	const EVENT_BEAT_POKEFANM_DEREK
	const EVENT_GOT_TM41_SOFTBOILED ; Kanto hack: renamed in place (M6 9p), was the dead EVENT_BEAT_POKEFANM_ROBERT (Crystal's ROUTE 10 POKEFAN, deleted in M5 8d).  CELADON CITY's gramps, Yellow's EVENT_GOT_TM41
	const EVENT_BEAT_ROUTE_13_PICNICKER_1 ; Kanto hack (M7 10c): renamed in place, was EVENT_BEAT_POKEFANM_JOSHUA -- Crystal's ROUTE 13 PIKACHU-gang POKEFAN, deleted by 10c
	const EVENT_BEAT_ROUTE_14_BIRD_KEEPER_8 ; Kanto hack (M7 10d): renamed in place, was EVENT_BEAT_POKEFANM_CARTER -- Crystal's ROUTE 14 POKEFAN, deleted by 10d (out-of-class swap: the BIRD_KEEPER block has no dead flag left)
	const EVENT_BEAT_ROUTE_14_BIKER_10 ; Kanto hack (M7 10d): renamed in place, was EVENT_BEAT_POKEFANM_TREVOR -- Crystal's other ROUTE 14 POKEFAN, deleted by 10d
	const EVENT_BEAT_POKEFANM_BRANDON
	const EVENT_BEAT_POKEFANM_JEREMY
	const EVENT_BEAT_POKEFANM_COLIN
	const EVENT_BEAT_ROCKET_HIDEOUT_B3F_ROCKET_1 ; Kanto hack (M6 9x): ROCKET HIDEOUT B3F (10,22) (was EVENT_BEAT_POKEFANM_DEREK2, a dead Johto rematch flag)
	const EVENT_BEAT_ROCKET_HIDEOUT_B3F_ROCKET_2 ; Kanto hack (M6 9x): ROCKET HIDEOUT B3F (26,12) (was EVENT_BEAT_POKEFANM_DEREK3, a dead Johto rematch flag)
	const EVENT_BEAT_ROUTE_13_PICNICKER_2 ; Kanto hack (M7 10c): renamed in place, was EVENT_BEAT_POKEFANM_ALEX -- Crystal's other ROUTE 13 POKEFAN, deleted by 10c
; PokefanF
	const EVENT_BEAT_POKEFANF_BEVERLY
	const EVENT_BEAT_POKEFANF_RUTH
	const EVENT_BEAT_ROCKET_HIDEOUT_B4F_ROCKET ; Kanto hack (M6 9x): ROCKET HIDEOUT B4F (11,2), drops the LIFT KEY (was EVENT_BEAT_POKEFANF_BEVERLY2, a dead Johto rematch flag)
	const EVENT_BEAT_ROCKET_HIDEOUT_GIOVANNI ; Kanto hack (M6 9x): ROCKET HIDEOUT B4F GIOVANNI; also his object hide flag (was EVENT_BEAT_POKEFANF_BEVERLY3, a dead Johto rematch flag)
	const EVENT_BEAT_POKEFANF_GEORGIA
; Kimono Girl
	const EVENT_POWER_PLANT_TM_REFLECT ; Kanto hack (M10 13l): was a const_skip (unused) row; ball (20,32), TM72
	const EVENT_BEAT_KIMONO_GIRL_NAOKO
	const EVENT_BEAT_KIMONO_GIRL_SAYO
	const EVENT_BEAT_KIMONO_GIRL_ZUKI
	const EVENT_BEAT_KIMONO_GIRL_KUNI
	const EVENT_BEAT_KIMONO_GIRL_MIKI
; Pokemaniac
	const EVENT_BEAT_POKEMANIAC_LARRY
	const EVENT_BEAT_POKEMANIAC_ANDREW
	const EVENT_BEAT_POKEMANIAC_CALVIN
	const EVENT_BEAT_POKEMANIAC_SHANE
	const EVENT_BEAT_POKEMANIAC_BEN
	const EVENT_BEAT_POKEMANIAC_BRENT
	const EVENT_BEAT_POKEMANIAC_RON
	const EVENT_BEAT_POKEMANIAC_ETHAN
	const EVENT_BEAT_POKEMANIAC_ORVILLE ; Kanto hack: renamed in place (M5 8d), was the dead EVENT_BEAT_POKEMANIAC_BRENT2; ROUTE 10, Yellow's POKEMANIAC 1
	const EVENT_BEAT_POKEMANIAC_MELVIN ; Kanto hack: renamed in place (M5 8d), was the dead EVENT_BEAT_POKEMANIAC_BRENT3; ROUTE 10, Yellow's POKEMANIAC 2
	const EVENT_BEAT_POKEMANIAC_ISSAC
	const EVENT_BEAT_POKEMANIAC_DONALD
	const EVENT_BEAT_POKEMANIAC_ZACH
; GruntM
	const EVENT_BEAT_ROCKET_GRUNTM_1
	const EVENT_BEAT_ROCKET_GRUNTM_2
	const EVENT_BEAT_ROCKET_GRUNTM_3
	const EVENT_BEAT_ROCKET_GRUNTM_4
	const EVENT_BEAT_ROCKET_GRUNTM_5
	const EVENT_BEAT_ROCKET_GRUNTM_6
	const EVENT_BEAT_ROCKET_GRUNTM_7
	const EVENT_BEAT_ROCKET_GRUNTM_8
	const EVENT_BEAT_ROCKET_GRUNTM_9
	const EVENT_BEAT_ROCKET_GRUNTM_10
	const EVENT_BEAT_ROCKET_GRUNTM_11
	const EVENT_BEAT_MT_MOON_B2F_ROCKET_1 ; Kanto hack: renamed in place (5f), was the unused EVENT_BEAT_ROCKET_GRUNTM_12
	const EVENT_BEAT_ROCKET_GRUNTM_13
	const EVENT_BEAT_ROCKET_GRUNTM_14
	const EVENT_BEAT_ROCKET_GRUNTM_15
	const EVENT_BEAT_ROCKET_GRUNTM_16
	const EVENT_BEAT_ROCKET_GRUNTM_17
	const EVENT_BEAT_ROCKET_GRUNTM_18
	const EVENT_BEAT_ROCKET_GRUNTM_19
	const EVENT_MT_MOON_B2F_HIDDEN_MOON_STONE ; Kanto hack: renamed in place (5f), was the unused EVENT_BEAT_ROCKET_GRUNTM_20
	const EVENT_MT_MOON_B2F_HIDDEN_ETHER ; Kanto hack: renamed in place (5f), was the unused EVENT_BEAT_ROCKET_GRUNTM_21
	const EVENT_BEAT_MT_MOON_B2F_ROCKET_2 ; Kanto hack: renamed in place (5f), was the unused EVENT_BEAT_ROCKET_GRUNTM_22
	const EVENT_BEAT_MT_MOON_B2F_ROCKET_3 ; Kanto hack: renamed in place (5f), was the unused EVENT_BEAT_ROCKET_GRUNTM_23
	const EVENT_BEAT_ROCKET_GRUNTM_24
	const EVENT_BEAT_ROCKET_GRUNTM_25
	const EVENT_BEAT_MT_MOON_B2F_JESSIE_JAMES ; Kanto hack: renamed in place (5f), was the unused EVENT_BEAT_ROCKET_GRUNTM_26. 5f uses it for the plain GRUNTM standing in for JESSIE & JAMES; 5h keeps the flag and swaps the scene
	const EVENT_MT_MOON_B2F_DOME_FOSSIL ; Kanto hack: renamed in place (5f), was the unused EVENT_BEAT_ROCKET_GRUNTM_27. Set when the DOME FOSSIL object is gone (taken by the player, or claimed by MIGUEL)
	const EVENT_BEAT_ROCKET_GRUNTM_28
	const EVENT_BEAT_ROCKET_GRUNTM_29
	const EVENT_MT_MOON_B2F_HELIX_FOSSIL ; Kanto hack: renamed in place (5f), was the unused EVENT_BEAT_ROCKET_GRUNTM_30. Ditto for the HELIX FOSSIL object
	const EVENT_MT_MOON_B2F_HP_UP ; Kanto hack: renamed in place (5f), was the unused EVENT_BEAT_ROCKET_GRUNTM_31 (the GRUNTM_31 party slot is still used by Route 24, which battles it from a script and needs no flag)
; GruntF
	const EVENT_BEAT_ROCKET_GRUNTF_1
	const EVENT_BEAT_ROCKET_GRUNTF_2
	const EVENT_BEAT_ROCKET_GRUNTF_3
	const EVENT_BEAT_ROCKET_GRUNTF_4
	const EVENT_BEAT_ROCKET_GRUNTF_5
; Lass
	const EVENT_BEAT_LASS_CARRIE
	const EVENT_BEAT_LASS_BRIDGET
	const EVENT_BEAT_FUCHSIA_GYM_TRAINER_2 ; Kanto hack (M7 10h): renamed in place, was EVENT_BEAT_LASS_ALICE
	const EVENT_BEAT_LASS_KRISE
	const EVENT_BEAT_LASS_CONNIE
	const EVENT_BEAT_FUCHSIA_GYM_TRAINER_3 ; Kanto hack (M7 10h): renamed in place, was EVENT_BEAT_LASS_LINDA
	const EVENT_BEAT_LASS_JODIE ; Kanto hack: renamed in place (6i), was EVENT_BEAT_LASS_LAURA; Route 25, Yellow's LASS 9
	const EVENT_BEAT_YOUNGSTER_OSCAR ; Kanto hack: renamed in place (6i), was EVENT_BEAT_LASS_SHANNON; Route 25, Yellow's YOUNGSTER 7
	const EVENT_BEAT_LASS_MICHELLE
	const EVENT_BEAT_LASS_DANA
	const EVENT_BEAT_LASS_TESSA ; Kanto hack: renamed in place (6i), was EVENT_BEAT_LASS_ELLEN; Route 25, Yellow's LASS 10
	const EVENT_BEAT_LASS_ODETTE ; Kanto hack: renamed in place (7h), was EVENT_BEAT_LASS_CONNIE2; S.S. ANNE 1F Rooms, Yellow's LASS 11
	const EVENT_BEAT_LASS_MARISA ; Kanto hack: renamed in place (7h), was EVENT_BEAT_LASS_CONNIE3; S.S. ANNE 2F Rooms, Yellow's LASS 12
	const EVENT_BEAT_LASS_ESTHER ; Kanto hack: renamed in place (M5 8j), was the dead EVENT_BEAT_LASS_DANA2; ROUTE 8, Yellow's LASS 13
	const EVENT_BEAT_LASS_FLORA ; Kanto hack: renamed in place (M5 8j), was the dead EVENT_BEAT_LASS_DANA3; ROUTE 8, Yellow's LASS 14
; Hiker
	const EVENT_BEAT_HIKER_LAMONT ; Kanto hack: renamed in place (M5 8c), was the dead EVENT_BEAT_HIKER_ANTHONY2; ROUTE 9, Yellow's HIKER 5
	const EVENT_BEAT_HIKER_RUSSELL
	const EVENT_BEAT_HIKER_PHILLIP
	const EVENT_BEAT_HIKER_LEONARD
	const EVENT_BEAT_HIKER_ANTHONY
	const EVENT_BEAT_HIKER_BENJAMIN
	const EVENT_BEAT_HIKER_ERIK
	const EVENT_BEAT_HIKER_MICHAEL
	const EVENT_BEAT_HIKER_PARRY
	const EVENT_BEAT_HIKER_TIMOTHY
	const EVENT_BEAT_HIKER_BAILEY
	const EVENT_BEAT_HIKER_ROSCOE ; Kanto hack: renamed in place (M5 8e), was the dead EVENT_BEAT_HIKER_ANTHONY3; ROCK TUNNEL 1F, Yellow's HIKER 12
	const EVENT_BEAT_HIKER_TIM
	const EVENT_BEAT_HIKER_NOLAND
	const EVENT_BEAT_HIKER_SIDNEY
	const EVENT_BEAT_ROUTE_13_PICNICKER_3 ; Kanto hack (M7 10c): renamed in place, was EVENT_BEAT_HIKER_KENNY -- Crystal's ROUTE 13 HIKER, deleted by 10c
	const EVENT_BEAT_HIKER_JIM ; Kanto hack: kept (M5 8d); ROUTE 10, Yellow's HIKER 7 -- party rewritten in place
	const EVENT_BEAT_HIKER_DANIEL
	const EVENT_BEAT_HIKER_ODELL ; Kanto hack: renamed in place (M5 8d), was the dead EVENT_BEAT_HIKER_PARRY2; ROUTE 10, Yellow's HIKER 8
	const EVENT_BEAT_HIKER_WILBUR ; Kanto hack: renamed in place (M5 8e), was the dead EVENT_BEAT_HIKER_PARRY3; ROCK TUNNEL 1F, Yellow's HIKER 13
; Bug Catcher
	const EVENT_BEAT_BUG_CATCHER_DON
	const EVENT_BEAT_BUG_CATCHER_ELLIS ; Kanto hack: renamed in place (M5 8c), was the dead EVENT_BEAT_BUG_CATCHER_ROB; ROUTE 9, Yellow's BUG_CATCHER 13
	const EVENT_BEAT_BUG_CATCHER_MERV ; Kanto hack: renamed in place (M5 8c), was the dead EVENT_BEAT_BUG_CATCHER_ED; ROUTE 9, Yellow's BUG_CATCHER 14
	const EVENT_BEAT_BUG_CATCHER_WADE
	const EVENT_BEAT_BUG_CATCHER_BENNY
	const EVENT_BEAT_BUG_CATCHER_AL
	const EVENT_BEAT_BUG_CATCHER_JOSH
	const EVENT_BEAT_BUG_CATCHER_ARNIE
	const EVENT_BEAT_BUG_CATCHER_KEN
	const EVENT_BEAT_ROCKET_HIDEOUT_JESSIE_JAMES ; Kanto hack (M6 9x): ROCKET HIDEOUT B4F JESSIE & JAMES (was EVENT_BEAT_BUG_CATCHER_WADE2, a dead Johto rematch flag)
	const EVENT_BEAT_ROUTE_18_BIRD_KEEPER_3 ; Kanto hack (M6 9aa): renamed in place, was EVENT_BEAT_BUG_CATCHER_WADE3 -- a dead Gen 2 phone-rematch flag (the Pokegear and the rematch system are cut)
	const EVENT_BEAT_VIRIDIAN_GYM_TRAINER_3 ; Kanto hack (M10 13b): was EVENT_BEAT_BUG_CATCHER_DOUG (dead, renamed in place)
	const EVENT_BEAT_VIRIDIAN_GYM_TRAINER_4 ; Kanto hack (M10 13b): was EVENT_BEAT_BUG_CATCHER_ARNIE2 (dead, renamed in place)
	const EVENT_BEAT_VIRIDIAN_GYM_TRAINER_5 ; Kanto hack (M10 13b): was EVENT_BEAT_BUG_CATCHER_ARNIE3 (dead, renamed in place)
; Officer
	const EVENT_BEAT_OFFICER_KEITH
	const EVENT_BEAT_OFFICER_DIRK
; CooltrainerM
	const EVENT_BEAT_COOLTRAINERM_NICK
	const EVENT_BEAT_COOLTRAINERM_AARON
	const EVENT_BEAT_COOLTRAINERM_PAUL
	const EVENT_BEAT_COOLTRAINERM_CODY
	const EVENT_BEAT_COOLTRAINERM_MIKE
	const EVENT_BEAT_SUPER_NERD_CLARK ; Kanto hack: renamed in place (M5 8j), was the dead EVENT_BEAT_COOLTRAINERM_GAVEN2; ROUTE 8, Yellow's SUPER_NERD 5.  Out of class: no SUPER_NERD row is dead
	const EVENT_BEAT_GENTLEMAN_ELTON ; Kanto hack: renamed in place (M5 8j), was the dead EVENT_BEAT_COOLTRAINERM_GAVEN3; ROUTE 8, Yellow's GAMBLER 5.  Out of class: no GENTLEMAN row is dead
	const EVENT_BEAT_COOLTRAINERM_RYAN
	const EVENT_BEAT_COOLTRAINERM_JAKE
	const EVENT_BEAT_COOLTRAINERM_GAVEN
	const EVENT_BEAT_COOLTRAINERM_BLAKE
	const EVENT_BEAT_COOLTRAINERM_BRIAN
	const EVENT_BEAT_GENTLEMAN_REUBEN ; Kanto hack: renamed in place (M5 8j), was the dead EVENT_BEAT_COOLTRAINERM_ERICK; ROUTE 8, Yellow's GAMBLER 7
	const EVENT_BEAT_VIRIDIAN_GYM_TRAINER_0 ; Kanto hack (M10 13b): was EVENT_BEAT_COOLTRAINERM_ANDY (dead, renamed in place)
	const EVENT_BEAT_VIRIDIAN_GYM_TRAINER_1 ; Kanto hack (M10 13b): was EVENT_BEAT_COOLTRAINERM_TYLER (dead, renamed in place)
	const EVENT_BEAT_COOLTRAINERM_SEAN
	const EVENT_BEAT_HIKER_ARCHIE ; Kanto hack: renamed in place (6i), was EVENT_BEAT_COOLTRAINERM_KEVIN; Route 25, Yellow's HIKER 3
	const EVENT_BEAT_VIRIDIAN_GYM_TRAINER_2 ; Kanto hack (M10 13b): was EVENT_BEAT_COOLTRAINERM_STEVE (dead, renamed in place)
	const EVENT_BEAT_COOLTRAINERM_ALLEN
; CooltrainerF
	const EVENT_BEAT_COOLTRAINERF_GWEN
	const EVENT_BEAT_COOLTRAINERF_LOIS
	const EVENT_BEAT_COOLTRAINERF_FRAN
	const EVENT_BEAT_COOLTRAINERF_LOLA
	const EVENT_BEAT_COOLTRAINERF_KATE
	const EVENT_BEAT_COOLTRAINERF_IRENE
	const EVENT_BEAT_COOLTRAINERF_KELLY
	const EVENT_BEAT_COOLTRAINERF_JOYCE
	const EVENT_BEAT_COOLTRAINERF_BETH
	const EVENT_BEAT_COOLTRAINERF_REENA
	const EVENT_BEAT_COOLTRAINERF_MEGAN
	const EVENT_BEAT_LASS_WINNIE ; Kanto hack: renamed in place (M5 8j), was the dead EVENT_BEAT_COOLTRAINERF_BETH2; ROUTE 8, Yellow's LASS 15.  Out of class: the LASS block had only two dead rows left and ROUTE 8 needs four, and a rename in place beats an append (HANDOFF flag budget)
	const EVENT_BEAT_COOLTRAINERF_CAROL
	const EVENT_BEAT_LASS_TILDA ; Kanto hack: renamed in place (M5 8j), was the dead EVENT_BEAT_COOLTRAINERF_QUINN; ROUTE 8, Yellow's LASS 16
	const EVENT_BEAT_COOLTRAINERF_EMMA
	const EVENT_BEAT_COOLTRAINERF_CYBIL
	const EVENT_BEAT_COOLTRAINERF_JENN
	const EVENT_BEAT_VIRIDIAN_GYM_TRAINER_6 ; Kanto hack (M10 13b): was EVENT_BEAT_COOLTRAINERF_BETH3 (dead, renamed in place)
	const EVENT_BEAT_VIRIDIAN_GYM_TRAINER_7 ; Kanto hack (M10 13b): was EVENT_BEAT_COOLTRAINERF_REENA2 (dead, renamed in place)
	const EVENT_GOT_TM27_FISSURE ; Kanto hack (M10 13b): was EVENT_BEAT_COOLTRAINERF_REENA3 (dead, renamed in place)
; ExecutiveF
	const EVENT_BEAT_ROCKET_EXECUTIVEF_1
	const EVENT_BEAT_ROCKET_EXECUTIVEF_2
; ExecutiveM
	const EVENT_BEAT_ROCKET_EXECUTIVEM_1
	const EVENT_BEAT_ROCKET_EXECUTIVEM_2
	const EVENT_BEAT_ROCKET_EXECUTIVEM_3
	const EVENT_BEAT_ROCKET_EXECUTIVEM_4
; Sailor
	const EVENT_BEAT_SAILOR_EUGENE
	const EVENT_BEAT_SAILOR_HUEY
	const EVENT_BEAT_SAILOR_TERRELL
	const EVENT_BEAT_SAILOR_KENT
	const EVENT_BEAT_SAILOR_ERNEST
	const EVENT_BEAT_SAILOR_JEFF
	const EVENT_BEAT_SAILOR_GARRETT
	const EVENT_BEAT_SAILOR_KENNETH
	const EVENT_BEAT_SAILOR_STANLY
	const EVENT_BEAT_SAILOR_HARRY
	const EVENT_BEAT_SAILOR_MURDOCK ; Kanto hack: renamed in place (7h), was EVENT_BEAT_SAILOR_HUEY2; S.S. ANNE bow, Yellow's SAILOR 1
	const EVENT_BEAT_SAILOR_MURPHY ; Kanto hack: renamed in place (7h), was EVENT_BEAT_SAILOR_HUEY3; S.S. ANNE bow, Yellow's SAILOR 2
; Super Nerd
	const EVENT_BEAT_SUPER_NERD_STAN
	const EVENT_BEAT_SUPER_NERD_ERIC
	const EVENT_BEAT_SUPER_NERD_GREGG ; Kanto hack: now Mt. Moon 1F (Yellow's SUPER_NERD 1); Crystal never used this slot
	const EVENT_BEAT_SUPER_NERD_MIGUEL ; Kanto hack: renamed in place (5f), was the unused EVENT_BEAT_SUPER_NERD_JAY
	const EVENT_MT_MOON_B2F_TM_MEGA_PUNCH ; Kanto hack: renamed in place (5f), was the unused (and misspelled) EVENT_BEAY_SUPER_NERD_DAVE.  M3b: Yellow's TM01 MEGA PUNCH (was TM_DYNAMICPUNCH)
	const EVENT_BEAT_SUPER_NERD_SAM
	const EVENT_BEAT_SUPER_NERD_TOM
	const EVENT_BEAT_HIKER_GRAHAM ; Kanto hack: renamed in place (6i), was EVENT_BEAT_SUPER_NERD_PAT; Route 25, Yellow's HIKER 2
	const EVENT_BEAT_SUPER_NERD_SHAWN
	const EVENT_BEAT_SUPER_NERD_TERU
; Medium
	const EVENT_BEAT_MEDIUM_MARTHA
	const EVENT_BEAT_MEDIUM_GRACE
	const EVENT_BEAT_MEDIUM_BETHANY ; Kanto hack (M6 9f): #MON TOWER 3F channeler 1
	const EVENT_BEAT_MEDIUM_MARGRET ; Kanto hack (M6 9f): #MON TOWER 3F channeler 2
	const EVENT_BEAT_MEDIUM_ETHEL ; Kanto hack (M6 9f): #MON TOWER 3F channeler 3
	const EVENT_VIRIDIAN_GYM_REVIVE ; Kanto hack (M10 13b): was EVENT_BEAT_MEDIUM_REBECCA (dead, renamed in place)
	const EVENT_VIRIDIAN_GYM_GIOVANNI_GONE ; Kanto hack (M10 13b): was EVENT_BEAT_MEDIUM_DORIS (dead, renamed in place)
; Skier
	const EVENT_BEAT_SKIER_ROXANNE
	const EVENT_BEAT_SKIER_CLARISSA
; SwimmerM
	const EVENT_BEAT_ROUTE_19_TRAINER_5 ; Kanto hack (M9 12c): renamed in
; place, was EVENT_BEAT_SWIMMERM_HAROLD.  Yellow's own flag name.
	const EVENT_BEAT_SWIMMERM_SIMON
	const EVENT_BEAT_SWIMMERM_RANDALL
	const EVENT_BEAT_SWIMMERM_CHARLIE
	const EVENT_BEAT_SWIMMERM_GEORGE
	const EVENT_BEAT_SWIMMERM_BERKE
	const EVENT_BEAT_SWIMMERM_KIRK
	const EVENT_BEAT_SWIMMERM_MATHEW
; Kanto hack (M6 9f): #MON TOWER 4F's three channelers.  Renamed in place from
; the dead EVENT_BEAT_SWIMMERM_HAL / _PATON / _DARYL (no map references); the
; MEDIUM block above is full of live Johto rows, and moving a const would
; renumber every flag after it.  9g/9h take the next dead SWIMMERM rows.
;
; M6 9g took the last five of them -- _WALTER, _TONY, _RICK, _JAMES and _LEWIS --
; for #MON TOWER 5F's four channelers and its NUGGET ball.  There are NO dead
; SwimmerM rows left.  66 dead rows remain in this file (9g re-ran the scan);
; 9h should take plain ones such as EVENT_BEAT_CAMPER_THOMAS / _LEROY / _DAVID /
; _JOHN or the spare BEAUTY rows -- NOT the `*2`/`*3` rows, which belong to
; Crystal's phone-rematch system and are only dead by inspection.
	const EVENT_BEAT_MEDIUM_AGNES
	const EVENT_BEAT_MEDIUM_EDITH
	const EVENT_BEAT_MEDIUM_HAZEL
	const EVENT_BEAT_MEDIUM_OLIVE ; Kanto hack (M6 9g): was EVENT_BEAT_SWIMMERM_WALTER; #MON TOWER 5F channeler 1
	const EVENT_BEAT_MEDIUM_CORA ; Kanto hack (M6 9g): was EVENT_BEAT_SWIMMERM_TONY; #MON TOWER 5F channeler 2
	const EVENT_BEAT_ROUTE_19_TRAINER_6 ; Kanto hack (M9 12c): renamed in
; place, was EVENT_BEAT_SWIMMERM_JEROME.  Yellow's own flag name.
	const EVENT_BEAT_ROUTE_19_TRAINER_7 ; Kanto hack (M9 12c): renamed in
; place, was EVENT_BEAT_SWIMMERM_TUCKER.  Yellow's own flag name.
	const EVENT_BEAT_MEDIUM_RUBY ; Kanto hack (M6 9g): was EVENT_BEAT_SWIMMERM_RICK; #MON TOWER 5F channeler 3
	const EVENT_BEAT_ROUTE_19_TRAINER_8 ; Kanto hack (M9 12c): renamed in
; place, was EVENT_BEAT_SWIMMERM_CAMERON.  Yellow's own flag name.
	const EVENT_BEAT_ROUTE_19_TRAINER_9 ; Kanto hack (M9 12c): renamed in
; place, was EVENT_BEAT_SWIMMERM_SETH.  Yellow's own flag name.
	const EVENT_BEAT_MEDIUM_MYRTLE ; Kanto hack (M6 9g): was EVENT_BEAT_SWIMMERM_JAMES; #MON TOWER 5F channeler 4
	const EVENT_POKEMON_TOWER_5F_NUGGET ; Kanto hack (M6 9g): was EVENT_BEAT_SWIMMERM_LEWIS; the 5F item ball
	const EVENT_BEAT_SWIMMERM_LUIS ; Kanto hack: renamed in place (6e,
; docs/M3-CERULEAN.md).  Was EVENT_BEAT_SWIMMERM_PARKER; same object, now
; Yellow's Cerulean Gym SWIMMER.
; Youngster
	const EVENT_BEAT_YOUNGSTER_JOEY
	const EVENT_BEAT_YOUNGSTER_MIKEY
	const EVENT_BEAT_YOUNGSTER_ALBERT
	const EVENT_BEAT_YOUNGSTER_GORDON
	const EVENT_BEAT_YOUNGSTER_SAMUEL
	const EVENT_BEAT_YOUNGSTER_IAN
	const EVENT_BEAT_YOUNGSTER_BENJI ; Kanto hack: renamed in place (7h), was EVENT_BEAT_YOUNGSTER_JOEY2; S.S. ANNE 1F Rooms, Yellow's YOUNGSTER 8
	const EVENT_BEAT_YOUNGSTER_GORDY ; Kanto hack: renamed in place (7l), was EVENT_BEAT_YOUNGSTER_JOEY3; ROUTE 11, Yellow's YOUNGSTER 11
	const EVENT_BEAT_YOUNGSTER_WARREN ; Kanto hack: Route 3, Yellow's YOUNGSTER 1
	const EVENT_BEAT_YOUNGSTER_JIMMY ; Kanto hack: Route 3, Yellow's YOUNGSTER 2
	const EVENT_BEAT_YOUNGSTER_FLOYD ; Kanto hack: renamed in place (7l), was EVENT_BEAT_YOUNGSTER_OWEN; ROUTE 11, Yellow's YOUNGSTER 9
	const EVENT_BEAT_YOUNGSTER_RUDY ; Kanto hack: renamed in place (7l), was EVENT_BEAT_YOUNGSTER_JASON; ROUTE 11, Yellow's YOUNGSTER 10
; Teacher
	const EVENT_BEAT_ROUTE_15_PICNICKER_5 ; Kanto hack: renamed in place (M7 10e); was EVENT_BEAT_TEACHER_COLETTE, one of Crystal's own dead ROUTE 15 rows
	const EVENT_BEAT_ROUTE_15_PICNICKER_6 ; Kanto hack: renamed in place (M7 10e); was EVENT_BEAT_TEACHER_HILLARY, one of Crystal's own dead ROUTE 15 rows
	const EVENT_BEAT_TEACHER_SHIRLEY
; Elite Four and Champion
	const EVENT_BEAT_ELITE_4_LORELEI
	const EVENT_BEAT_ELITE_4_BRUNO
	const EVENT_BEAT_ELITE_4_AGATHA
	const EVENT_BEAT_ELITE_4_LANCE
	const EVENT_BEAT_CHAMPION_LANCE
; Crystal-exclusive trainer flags
	const EVENT_BEAT_COOLTRAINERM_DARIN
	const EVENT_BEAT_COOLTRAINERF_CARA
	const EVENT_BEAT_TWINS_LEA_AND_PIA
	const EVENT_BEAT_BUG_CATCHER_WAYNE
	const EVENT_BEAT_BEAUTY_OLIVIA
	const EVENT_BEAT_POKEFANF_JAIME
	const EVENT_BEAT_CAMPER_QUENTIN
	const EVENT_BEAT_POKEMANIAC_MILLER
	const EVENT_BEAT_SUPER_NERD_HUGH
	const EVENT_BEAT_SUPER_NERD_MARKUS
	const EVENT_BEAT_CAMPER_NOLAN ; Kanto hack: renamed in place (7d), was EVENT_BEAT_POKEFANM_REX; Route 6, Yellow's JR_TRAINER_M 10
	const EVENT_BEAT_PICNICKER_MARCY ; Kanto hack: renamed in place (7d), was EVENT_BEAT_POKEFANM_ALLAN; Route 6, Yellow's JR_TRAINER_F 25
	const EVENT_BEAT_SAGE_GAKU
	const EVENT_BEAT_SAGE_MASA
	const EVENT_BEAT_SAGE_KOJI
; Unused: next 116 events

	const_next 1600
; Sprite visibility flags
; When these events are cleared, the sprite becomes visible; when set, the sprite is hidden.
; The map script command macros `disappear` and `appear` set/clear these flags and immediately apply the effect on visibility.
; The map script command macros `setevent` and `clearevent` set/clear these flags, and their effects will be seen when the map is reloaded.
; Johto itemballs
	const EVENT_CYNDAQUIL_POKEBALL_IN_ELMS_LAB
	const EVENT_TOTODILE_POKEBALL_IN_ELMS_LAB
	const EVENT_CHIKORITA_POKEBALL_IN_ELMS_LAB
	const EVENT_VIOLET_CITY_PP_UP
	const EVENT_VIOLET_CITY_RARE_CANDY
	const EVENT_LAKE_OF_RAGE_ELIXER
	const EVENT_LAKE_OF_RAGE_TM_DETECT
	const EVENT_SPROUT_TOWER_1F_PARLYZ_HEAL
	const EVENT_SPROUT_TOWER_2F_X_ACCURACY
	const EVENT_SPROUT_TOWER_3F_POTION
	const EVENT_SPROUT_TOWER_3F_ESCAPE_ROPE
	const EVENT_TIN_TOWER_3F_FULL_HEAL
	const EVENT_TIN_TOWER_4F_ULTRA_BALL
	const EVENT_TIN_TOWER_4F_PP_UP
	const EVENT_TIN_TOWER_4F_ESCAPE_ROPE
	const EVENT_TIN_TOWER_5F_RARE_CANDY
	const EVENT_TIN_TOWER_7F_MAX_REVIVE
	const EVENT_TIN_TOWER_8F_NUGGET
	const EVENT_TIN_TOWER_8F_MAX_ELIXER
	const EVENT_TIN_TOWER_8F_FULL_RESTORE
	const EVENT_TEAM_ROCKET_BASE_B3F_ULTRA_BALL
	const EVENT_GOLDENROD_UNDERGROUND_WAREHOUSE_ULTRA_BALL
	const EVENT_BURNED_TOWER_1F_HP_UP
	const EVENT_BURNED_TOWER_B1F_TM_ENDURE
	const EVENT_NATIONAL_PARK_PARLYZ_HEAL
	const EVENT_NATIONAL_PARK_TM_DIG
	const EVENT_UNION_CAVE_1F_GREAT_BALL
	const EVENT_UNION_CAVE_1F_X_ATTACK
	const EVENT_UNION_CAVE_1F_POTION
	const EVENT_UNION_CAVE_1F_AWAKENING
	const EVENT_UNION_CAVE_B1F_TM_SWIFT
	const EVENT_UNION_CAVE_B1F_X_DEFEND
	const EVENT_UNION_CAVE_B2F_ELIXER
	const EVENT_UNION_CAVE_B2F_HYPER_POTION
	const EVENT_SLOWPOKE_WELL_B1F_SUPER_POTION
	const EVENT_SLOWPOKE_WELL_B2F_TM_RAIN_DANCE
	const EVENT_OLIVINE_LIGHTHOUSE_3F_ETHER
	const EVENT_OLIVINE_LIGHTHOUSE_5F_RARE_CANDY
	const EVENT_OLIVINE_LIGHTHOUSE_5F_SUPER_REPEL
	const EVENT_OLIVINE_LIGHTHOUSE_5F_TM_SWAGGER
	const EVENT_OLIVINE_LIGHTHOUSE_6F_SUPER_POTION
	const EVENT_TEAM_ROCKET_BASE_B1F_HYPER_POTION
	const EVENT_TEAM_ROCKET_BASE_B1F_NUGGET
	const EVENT_TEAM_ROCKET_BASE_B1F_GUARD_SPEC
	const EVENT_TEAM_ROCKET_BASE_B2F_TM_THIEF
	const EVENT_TEAM_ROCKET_BASE_B3F_PROTEIN
	const EVENT_TEAM_ROCKET_BASE_B3F_X_SPECIAL
	const EVENT_TEAM_ROCKET_BASE_B3F_FULL_HEAL
	const EVENT_TEAM_ROCKET_BASE_B3F_ICE_HEAL
	const EVENT_ILEX_FOREST_REVIVE
	const EVENT_GOLDENROD_UNDERGROUND_COIN_CASE
	const EVENT_GOLDENROD_UNDERGROUND_SWITCH_ROOM_ENTRANCES_SMOKE_BALL
	const EVENT_GOLDENROD_UNDERGROUND_SWITCH_ROOM_ENTRANCES_FULL_HEAL
	const EVENT_GOLDENROD_DEPT_STORE_B1F_ETHER
	const EVENT_GOLDENROD_DEPT_STORE_B1F_AMULET_COIN
	const EVENT_GOLDENROD_DEPT_STORE_B1F_BURN_HEAL
	const EVENT_GOLDENROD_DEPT_STORE_B1F_ULTRA_BALL
	const EVENT_GOLDENROD_UNDERGROUND_WAREHOUSE_MAX_ETHER
	const EVENT_GOLDENROD_UNDERGROUND_WAREHOUSE_TM_SLEEP_TALK
	const EVENT_MOUNT_MORTAR_1F_OUTSIDE_ETHER
	const EVENT_MOUNT_MORTAR_1F_OUTSIDE_REVIVE
	const EVENT_MOUNT_MORTAR_1F_INSIDE_ESCAPE_ROPE
	const EVENT_MOUNT_MORTAR_1F_INSIDE_MAX_REVIVE
	const EVENT_MOUNT_MORTAR_1F_INSIDE_HYPER_POTION
	const EVENT_MOUNT_MORTAR_2F_INSIDE_MAX_POTION
	const EVENT_MOUNT_MORTAR_2F_INSIDE_RARE_CANDY
	const EVENT_MOUNT_MORTAR_2F_INSIDE_TM_DEFENSE_CURL
	const EVENT_MOUNT_MORTAR_2F_INSIDE_DRAGON_SCALE
	const EVENT_MOUNT_MORTAR_2F_INSIDE_ELIXER
	const EVENT_MOUNT_MORTAR_2F_INSIDE_ESCAPE_ROPE
	const EVENT_MOUNT_MORTAR_B1F_HYPER_POTION
	const EVENT_MOUNT_MORTAR_B1F_CARBOS
	const EVENT_GOT_HM07_WATERFALL
	const EVENT_ICE_PATH_1F_PP_UP
	const EVENT_ICE_PATH_B1F_IRON
	const EVENT_ICE_PATH_B2F_MAHOGANY_SIDE_FULL_HEAL
	const EVENT_ICE_PATH_B2F_MAHOGANY_SIDE_MAX_POTION
	const EVENT_ICE_PATH_B2F_BLACKTHORN_SIDE_TM_REST
	const EVENT_ICE_PATH_B3F_NEVERMELTICE
	const EVENT_WHIRL_ISLAND_NE_ULTRA_BALL
	const EVENT_WHIRL_ISLAND_SW_ULTRA_BALL
	const EVENT_WHIRL_ISLAND_B1F_FULL_RESTORE
	const EVENT_WHIRL_ISLAND_B1F_CARBOS
	const EVENT_WHIRL_ISLAND_B1F_CALCIUM
	const EVENT_WHIRL_ISLAND_B1F_NUGGET
	const EVENT_WHIRL_ISLAND_B1F_ESCAPE_ROPE
	const EVENT_WHIRL_ISLAND_B2F_FULL_RESTORE
	const EVENT_WHIRL_ISLAND_B2F_MAX_REVIVE
	const EVENT_WHIRL_ISLAND_B2F_MAX_ELIXER
	const EVENT_SILVER_CAVE_ROOM_1_MAX_ELIXER
	const EVENT_SILVER_CAVE_ROOM_1_PROTEIN
	const EVENT_SILVER_CAVE_ROOM_1_ESCAPE_ROPE
	const EVENT_SILVER_CAVE_ITEM_ROOMS_MAX_REVIVE
	const EVENT_SILVER_CAVE_ITEM_ROOMS_FULL_RESTORE
	const EVENT_DARK_CAVE_VIOLET_ENTRANCE_POTION
	const EVENT_DARK_CAVE_VIOLET_ENTRANCE_FULL_HEAL
	const EVENT_DARK_CAVE_VIOLET_ENTRANCE_HYPER_POTION
	const EVENT_DARK_CAVE_BLACKTHORN_ENTRANCE_REVIVE
	const EVENT_DARK_CAVE_BLACKTHORN_ENTRANCE_TM_SNORE
	const EVENT_VICTORY_ROAD_1F_TM_SKY_ATTACK ; Kanto hack (M10 13g): renamed in place, was EVENT_VICTORY_ROAD_TM_EARTHQUAKE (dead); ball (11,0), TM79
	const EVENT_VICTORY_ROAD_1F_RARE_CANDY ; Kanto hack (M10 13g): renamed in place, was EVENT_VICTORY_ROAD_MAX_REVIVE (dead); ball (9,2)
	const EVENT_VICTORY_ROAD_2F_TM_SUBMISSION ; Kanto hack (M10 13g): renamed in place, was EVENT_VICTORY_ROAD_FULL_RESTORE (dead); ball (27,5), TM63
	const EVENT_VICTORY_ROAD_2F_FULL_HEAL ; Kanto hack (M10 13g): renamed in place, was EVENT_VICTORY_ROAD_FULL_HEAL (dead); ball (18,9)
	const EVENT_VICTORY_ROAD_2F_TM_MEGA_KICK ; Kanto hack (M10 13g): renamed in place, was EVENT_VICTORY_ROAD_HP_UP (dead); ball (9,11), TM55
	const EVENT_DRAGONS_DEN_B1F_DRAGON_FANG
	const EVENT_TOHJO_FALLS_MOON_STONE
	const EVENT_ROUTE_26_MAX_ELIXER
	const EVENT_ROUTE_27_TM_SOLARBEAM
	const EVENT_ROUTE_27_RARE_CANDY
	const EVENT_ROUTE_29_POTION
	const EVENT_ROUTE_31_POTION
	const EVENT_ROUTE_31_POKE_BALL
	const EVENT_ROUTE_32_GREAT_BALL
	const EVENT_ROUTE_32_REPEL
	const EVENT_ROUTE_35_TM_ROLLOUT
	const EVENT_ROUTE_42_ULTRA_BALL
	const EVENT_ROUTE_42_SUPER_POTION
	const EVENT_ROUTE_43_MAX_ETHER
	const EVENT_ROUTE_44_MAX_REVIVE
	const EVENT_ROUTE_44_ULTRA_BALL
	const EVENT_ROUTE_45_NUGGET
	const EVENT_ROUTE_45_REVIVE
	const EVENT_ROUTE_45_ELIXER
	const EVENT_ROUTE_45_MAX_POTION
	const EVENT_ROUTE_46_X_SPEED
; Johto people
	const EVENT_RIVAL_NEW_BARK_TOWN
	const EVENT_RIVAL_CHERRYGROVE_CITY
	const EVENT_RIVAL_AZALEA_TOWN
	const EVENT_RIVAL_TEAM_ROCKET_BASE
	const EVENT_RIVAL_GOLDENROD_UNDERGROUND
	const EVENT_VICTORY_ROAD_2F_BOULDER_HIDDEN ; Kanto hack (M10 13g): renamed in place, was EVENT_RIVAL_VICTORY_ROAD (dead); hide flag of 2F BOULDER3 (23,16), Yellow's TOGGLE_VICTORY_ROAD_2F_BOULDER inverted.  Still SET by InitializeEventsScript (the old setevent, renamed) and by ROUTE 23's NEWMAP; cleared when a boulder drops through 3F's hole
	const EVENT_RIVAL_OLIVINE_CITY
	const EVENT_RIVAL_SPROUT_TOWER
	const EVENT_RIVAL_BURNED_TOWER
	const EVENT_RIVAL_DRAGONS_DEN
	const EVENT_PLAYERS_HOUSE_MOM_1
	const EVENT_PLAYERS_HOUSE_MOM_2
	const EVENT_MR_POKEMONS_HOUSE_OAK
	const EVENT_VIOLET_CITY_EARL
	const EVENT_EARLS_ACADEMY_EARL
	const EVENT_GOLDENROD_CITY_ROCKET_SCOUT
	const EVENT_GOLDENROD_CITY_ROCKET_TAKEOVER
	const EVENT_RADIO_TOWER_ROCKET_TAKEOVER
	const EVENT_GOLDENROD_CITY_CIVILIANS
	const EVENT_RADIO_TOWER_CIVILIANS_AFTER
	const EVENT_RADIO_TOWER_BLACKBELT_BLOCKS_STAIRS
	const EVENT_OLIVINE_LIGHTHOUSE_JASMINE
	const EVENT_OLIVINE_GYM_JASMINE
	const EVENT_LAKE_OF_RAGE_LANCE
	const EVENT_MAHOGANY_MART_LANCE_AND_DRAGONITE
	const EVENT_TEAM_ROCKET_BASE_B2F_LANCE
	const EVENT_TEAM_ROCKET_BASE_B3F_LANCE_PASSWORDS
	const EVENT_DRAGONS_DEN_CLAIR
	const EVENT_TEAM_ROCKET_BASE_SECURITY_GRUNTS
	const EVENT_TEAM_ROCKET_BASE_POPULATION
	const EVENT_TEAM_ROCKET_BASE_B3F_EXECUTIVE
	const EVENT_ROUTE_43_GATE_ROCKETS
	const EVENT_TEAM_ROCKET_BASE_B2F_EXECUTIVE
	const EVENT_TEAM_ROCKET_BASE_B2F_GRUNT_WITH_EXECUTIVE
	const EVENT_TEAM_ROCKET_BASE_B2F_DRAGONITE
	const EVENT_TEAM_ROCKET_BASE_B2F_ELECTRODE_1
	const EVENT_TEAM_ROCKET_BASE_B2F_ELECTRODE_2
	const EVENT_TEAM_ROCKET_BASE_B2F_ELECTRODE_3
	const EVENT_BLACKTHORN_CITY_SUPER_NERD_BLOCKS_GYM
	const EVENT_BLACKTHORN_CITY_SUPER_NERD_DOES_NOT_BLOCK_GYM
	const EVENT_DAY_CARE_MAN_IN_DAY_CARE
	const EVENT_DAY_CARE_MAN_ON_ROUTE_34
	const EVENT_DAY_CARE_MON_1
	const EVENT_DAY_CARE_MON_2
	const EVENT_ILEX_FOREST_FARFETCHD
	const EVENT_ROUTE_34_ILEX_FOREST_GATE_TEACHER_BEHIND_COUNTER
	const EVENT_ROUTE_34_ILEX_FOREST_GATE_LASS
	const EVENT_ROUTE_34_ILEX_FOREST_GATE_TEACHER_IN_WALKWAY
	const EVENT_ILEX_FOREST_LASS
	const EVENT_VICTORY_ROAD_1F_BOULDER_ON_SWITCH ; Kanto hack (M10 13g): renamed in place, was EVENT_COPYCAT_1 (dead); Yellow's EVENT_VICTORY_ROAD_1_BOULDER_ON_SWITCH; cleared on every 2F entry
	const EVENT_VICTORY_ROAD_2F_BOULDER_ON_SWITCH1 ; Kanto hack (M10 13g): renamed in place, was EVENT_COPYCAT_2 (dead); Yellow's EVENT_VICTORY_ROAD_2_BOULDER_ON_SWITCH1; cleared by ROUTE 23's NEWMAP
	const EVENT_GOLDENROD_SALE_OFF
	const EVENT_GOLDENROD_SALE_ON
	const EVENT_POWER_PLANT_CARBOS ; Kanto hack (M10 13l): was a const_skip (unused) row; ball (7,25)
	const EVENT_ILEX_FOREST_APPRENTICE
	const EVENT_ILEX_FOREST_CHARCOAL_MASTER
	const EVENT_CHARCOAL_KILN_FARFETCH_D
	const EVENT_CHARCOAL_KILN_APPRENTICE
	const EVENT_CHARCOAL_KILN_BOSS
	const EVENT_ROUTE_36_SUDOWOODO
	const EVENT_AZALEA_TOWN_SLOWPOKES
	const EVENT_AZALEA_TOWN_SLOWPOKETAIL_ROCKET
	const EVENT_SLOWPOKE_WELL_SLOWPOKES
	const EVENT_SLOWPOKE_WELL_ROCKETS
	const EVENT_KURTS_HOUSE_SLOWPOKE
	const EVENT_GUIDE_GENT_IN_HIS_HOUSE
	const EVENT_GUIDE_GENT_VISIBLE_IN_CHERRYGROVE
	const EVENT_ELMS_AIDE_IN_VIOLET_POKEMON_CENTER
	const EVENT_ELMS_AIDE_IN_LAB
	const EVENT_COP_IN_ELMS_LAB
	const EVENT_RUINS_OF_ALPH_OUTSIDE_SCIENTIST
	const EVENT_RUINS_OF_ALPH_RESEARCH_CENTER_SCIENTIST
	const EVENT_RUINS_OF_ALPH_INNER_CHAMBER_TOURISTS
	const EVENT_BOULDER_IN_BLACKTHORN_GYM_1
	const EVENT_BOULDER_IN_BLACKTHORN_GYM_2
	const EVENT_BOULDER_IN_BLACKTHORN_GYM_3
	const EVENT_BOULDER_IN_ICE_PATH_1
	const EVENT_BOULDER_IN_ICE_PATH_2
	const EVENT_BOULDER_IN_ICE_PATH_3
	const EVENT_BOULDER_IN_ICE_PATH_4
	const EVENT_BOULDER_IN_ICE_PATH_1A
	const EVENT_BOULDER_IN_ICE_PATH_2A
	const EVENT_BOULDER_IN_ICE_PATH_3A
	const EVENT_BOULDER_IN_ICE_PATH_4A
	const EVENT_MYSTERY_GIFT_DELIVERY_GUY
	const EVENT_MET_BILL
	const EVENT_ECRUTEAK_POKE_CENTER_BILL
	const EVENT_ROUTE_30_BATTLE
	const EVENT_ROUTE_30_YOUNGSTER_JOEY
	const EVENT_BUG_CATCHING_CONTESTANT_1A
	const EVENT_BUG_CATCHING_CONTESTANT_2A
	const EVENT_BUG_CATCHING_CONTESTANT_3A
	const EVENT_BUG_CATCHING_CONTESTANT_4A
	const EVENT_BUG_CATCHING_CONTESTANT_5A
	const EVENT_BUG_CATCHING_CONTESTANT_6A
	const EVENT_BUG_CATCHING_CONTESTANT_7A
	const EVENT_BUG_CATCHING_CONTESTANT_8A
	const EVENT_BUG_CATCHING_CONTESTANT_9A
	const EVENT_BUG_CATCHING_CONTESTANT_10A
	const EVENT_BUG_CATCHING_CONTESTANT_1B
	const EVENT_BUG_CATCHING_CONTESTANT_2B
	const EVENT_BUG_CATCHING_CONTESTANT_3B
	const EVENT_BUG_CATCHING_CONTESTANT_4B
	const EVENT_BUG_CATCHING_CONTESTANT_5B
	const EVENT_BUG_CATCHING_CONTESTANT_6B
	const EVENT_BUG_CATCHING_CONTESTANT_7B
	const EVENT_BUG_CATCHING_CONTESTANT_8B
	const EVENT_BUG_CATCHING_CONTESTANT_9B
	const EVENT_BUG_CATCHING_CONTESTANT_10B
	const EVENT_OLIVINE_PORT_SAILOR_AT_GANGWAY
	const EVENT_VERMILION_PORT_SAILOR_AT_GANGWAY
	const EVENT_FAST_SHIP_1F_GENTLEMAN
	const EVENT_FAST_SHIP_CABINS_NNW_NNE_NE_SAILOR
	const EVENT_FAST_SHIP_B1F_SAILOR_LEFT
	const EVENT_FAST_SHIP_B1F_SAILOR_RIGHT
	const EVENT_FAST_SHIP_CABINS_SE_SSE_GENTLEMAN
	const EVENT_FAST_SHIP_CABINS_SE_SSE_CAPTAINS_CABIN_TWIN_1
	const EVENT_FAST_SHIP_CABINS_SE_SSE_CAPTAINS_CABIN_TWIN_2
	const EVENT_OLIVINE_PORT_PASSAGE_POKEFAN_M
	const EVENT_ROUTE_35_NATIONAL_PARK_GATE_YOUNGSTER
	const EVENT_LAKE_OF_RAGE_CIVILIANS
	const EVENT_MAHOGANY_MART_OWNERS
	const EVENT_OLIVINE_PORT_SPRITES_BEFORE_HALL_OF_FAME
	const EVENT_OLIVINE_PORT_SPRITES_AFTER_HALL_OF_FAME
	const EVENT_FAST_SHIP_PASSENGERS_FIRST_TRIP
	const EVENT_FAST_SHIP_PASSENGERS_EASTBOUND
	const EVENT_FAST_SHIP_PASSENGERS_WESTBOUND
	const EVENT_TIN_TOWER_ROOF_HO_OH
	const EVENT_WHIRL_ISLAND_LUGIA_CHAMBER_LUGIA
	const EVENT_KURTS_HOUSE_KURT_1
	const EVENT_KURTS_HOUSE_KURT_2
	const EVENT_SLOWPOKE_WELL_KURT
	const EVENT_PLAYERS_HOUSE_2F_CONSOLE
	const EVENT_PLAYERS_HOUSE_2F_DOLL_1
	const EVENT_PLAYERS_HOUSE_2F_DOLL_2
	const EVENT_PLAYERS_HOUSE_2F_BIG_DOLL
	const EVENT_ROUTE_35_NATIONAL_PARK_GATE_OFFICER_CONTEST_DAY
	const EVENT_ROUTE_35_NATIONAL_PARK_GATE_OFFICER_NOT_CONTEST_DAY
	const EVENT_ROUTE_36_NATIONAL_PARK_GATE_OFFICER_CONTEST_DAY
	const EVENT_ROUTE_36_NATIONAL_PARK_GATE_OFFICER_NOT_CONTEST_DAY
	const EVENT_GOLDENROD_TRAIN_STATION_GENTLEMAN
	const EVENT_BURNED_TOWER_B1F_BEASTS_1
	const EVENT_BURNED_TOWER_B1F_BEASTS_2
	const EVENT_BLACKTHORN_CITY_GRAMPS_BLOCKS_DRAGONS_DEN
	const EVENT_BLACKTHORN_CITY_GRAMPS_NOT_BLOCKING_DRAGONS_DEN
	const EVENT_RUINS_OF_ALPH_KABUTO_CHAMBER_RECEPTIONIST
	const EVENT_OPENED_MT_SILVER
	const EVENT_FOUGHT_SNORLAX
	const EVENT_LAKE_OF_RAGE_RED_GYARADOS
	const EVENT_GOLDENROD_UNDERGROUND_GRANNY
	const EVENT_GOLDENROD_UNDERGROUND_GRAMPS
	const EVENT_GOLDENROD_UNDERGROUND_OLDER_HAIRCUT_BROTHER
	const EVENT_GOLDENROD_UNDERGROUND_YOUNGER_HAIRCUT_BROTHER
	const EVENT_MAHOGANY_TOWN_POKEFAN_M_BLOCKS_EAST
	const EVENT_MAHOGANY_TOWN_POKEFAN_M_BLOCKS_GYM
	const EVENT_ROUTE_32_FRIEDA_OF_FRIDAY
	const EVENT_ROUTE_29_TUSCANY_OF_TUESDAY
	const EVENT_ROUTE_36_ARTHUR_OF_THURSDAY
	const EVENT_ROUTE_37_SUNNY_OF_SUNDAY
	const EVENT_LAKE_OF_RAGE_WESLEY_OF_WEDNESDAY
	const EVENT_BLACKTHORN_CITY_SANTOS_OF_SATURDAY
	const EVENT_ROUTE_40_MONICA_OF_MONDAY
	const EVENT_CHAMPIONS_ROOM_OAK_AND_MARY
	const EVENT_UNION_CAVE_B2F_LAPRAS
	const EVENT_TEAM_ROCKET_DISBANDED
	const EVENT_RED_IN_MT_SILVER
	const EVENT_GOLDENROD_DEPT_STORE_5F_HAPPINESS_EVENT_LADY
	const EVENT_BURNED_TOWER_MORTY
	const EVENT_BURNED_TOWER_1F_EUSINE
	const EVENT_RANG_CLEAR_BELL_1
	const EVENT_RANG_CLEAR_BELL_2
	const EVENT_FLORIA_AT_FLOWER_SHOP
	const EVENT_FLORIA_AT_SUDOWOODO
	const EVENT_GOLDENROD_CITY_MOVE_TUTOR
	const EVENT_GOLDENROD_GAME_CORNER_MOVE_TUTOR
; Unused: next 0 events
; (In pokegold the previous 4 event flags were not defined,
; but in pokecrystal the 'const_next 1900' is redundant.)

	const_next 1900
; Kanto people
	const EVENT_BEAT_ROUTE_24_ROCKET ; Kanto hack (6h): renamed in place.  Crystal's Route 24 Rocket-executive object flag is dead -- 6h deletes that NPC -- so this slot now records the win over Yellow's Nugget Bridge recruiter.  Its two setters (PowerPlant.asm, InitializeEventsScript) were deleted with it.
	const EVENT_CERULEAN_GYM_ROCKET
	const EVENT_ROUTE_17_HIDDEN_MAX_REVIVE ; Kanto hack: renamed in place (M6 9z), was DEAD since 6i (Crystal's Misty's-date NPC); ROUTE 17 (4,91)
	const EVENT_VICTORY_ROAD_2F_BOULDER_ON_SWITCH2 ; Kanto hack (M10 13g): renamed in place, was EVENT_TRAINERS_IN_CERULEAN_GYM (dead); Yellow's EVENT_VICTORY_ROAD_2_BOULDER_ON_SWITCH2; cleared by ROUTE 23's NEWMAP
	const EVENT_SS_ANNE_LEFT ; Kanto hack: renamed in place (7e), was EVENT_VERMILION_CITY_SNORLAX (Snorlax deleted); Yellow's EVENT_SS_ANNE_LEFT, set in 7g
	const EVENT_GAVE_SAFFRON_GUARDS_DRINK ; Kanto hack: renamed in place (7d), was EVENT_ROUTE_5_6_POKEFAN_M_BLOCKS_UNDERGROUND_PATH; Yellow's BIT_GAVE_SAFFRON_GUARDS_DRINK, shared by every SAFFRON gate guard
	const EVENT_SAFFRON_TRAIN_STATION_POPULATION
	const EVENT_COPYCATS_HOUSE_2F_DOLL
	const EVENT_LEFT_FANCLUB_AFTER_BIKE_VOUCHER ; Kanto hack: renamed in place (7f), was EVENT_VERMILION_FAN_CLUB_DOLL (the CLEFAIRY DOLL prop is deleted); Yellow's flag, set by VermilionCity's NEWMAP callback once the voucher is in the bag
	const EVENT_BLUE_IN_CINNABAR
	const EVENT_VIRIDIAN_GYM_BLUE ; Kanto hack (M10 13b): DEAD -- BLUE left the gym; pre-Blaine saves still have it SET, so never reuse as a hide flag
	const EVENT_SEAFOAM_GYM_GYM_GUIDE
	const EVENT_MT_MOON_1F_RARE_CANDY ; Kanto hack: renamed in place (5e), was EVENT_MT_MOON_SQUARE_ROCK
	const EVENT_MT_MOON_SQUARE_CLEFAIRY
	const EVENT_MT_MOON_1F_MOON_STONE ; Kanto hack: renamed in place (5e), was EVENT_MT_MOON_RIVAL
	const EVENT_INDIGO_PLATEAU_POKECENTER_RIVAL
	const EVENT_TELEPORT_GUY
; Kanto itemballs
	const EVENT_ROUTE22_RIVAL_2_WANTS_BATTLE ; Kanto hack (M10 13b): was EVENT_PICKED_UP_FOCUS_BAND (dead, renamed in place)
	const EVENT_BEAT_HIKER_NORRIS ; Kanto hack: renamed in place (M5 8e); was Crystal's ROCK TUNNEL 1F ELIXER ball, deleted with the rest of 1F's Crystal items.  ROCK TUNNEL 1F, Yellow's HIKER 14
	const EVENT_BEAT_POKEMANIAC_JASPER ; Kanto hack: renamed in place (M5 8e); was Crystal's ROCK TUNNEL 1F TM_STEEL_WING ball.  ROCK TUNNEL 1F, Yellow's POKEMANIAC 7
	const EVENT_BEAT_HIKER_LOWELL ; Kanto hack: renamed in place (M5 8f); was Crystal's ROCK TUNNEL B1F IRON ball, deleted with the rest of B1F's Crystal items.  ROCK TUNNEL B1F, Yellow's HIKER 9
	const EVENT_BEAT_POKEMANIAC_CEDRIC ; Kanto hack: renamed in place (M5 8f); was Crystal's ROCK TUNNEL B1F PP_UP ball.  ROCK TUNNEL B1F, Yellow's POKEMANIAC 3
	const EVENT_BEAT_POKEMANIAC_AMOS ; Kanto hack: renamed in place (M5 8f); was Crystal's ROCK TUNNEL B1F REVIVE ball.  ROCK TUNNEL B1F, Yellow's POKEMANIAC 4
	const EVENT_ROUTE_2_MOON_STONE ; was EVENT_ROUTE_2_DIRE_HIT
	const EVENT_ROUTE_2_HP_UP ; was EVENT_ROUTE_2_MAX_POTION
	const EVENT_VIRIDIAN_FOREST_POTION_1 ; was the unused EVENT_ROUTE_2_CARBOS
	const EVENT_VIRIDIAN_FOREST_POTION_2 ; was the unused EVENT_ROUTE_2_ELIXER
	const EVENT_ROUTE_4_TM_WHIRLWIND ; Kanto hack: Route 4, Yellow's TM04 WHIRLWIND itemball (was EVENT_ROUTE_4_HP_UP); M3b made it the real TM_WHIRLWIND
	const EVENT_ROUTE_12_TM_PAY_DAY ; Kanto hack: renamed in place (M5 8l), was EVENT_ROUTE_12_CALCIUM; ROUTE 12, Yellow's TM16 PAY DAY ball at (14,35) (M3b made it the real TM_PAY_DAY = our TM62)
	const EVENT_ROUTE_12_IRON ; Kanto hack: renamed in place (M5 8l), was EVENT_ROUTE_12_NUGGET; ROUTE 12, Yellow's IRON ball at (5,89)
	const EVENT_ROUTE_15_TM_RAGE ; Kanto hack: renamed in place (M7 10e), was EVENT_ROUTE_15_PP_UP; ROUTE 15, Yellow's TM20 RAGE ball at (18,5) (M3b made it the real TM_RAGE = our TM66)
	const EVENT_ROUTE_25_TM_SEISMIC_TOSS ; Kanto hack: renamed in place (6i), was EVENT_ROUTE_25_PROTEIN; Route 25, Yellow's TM19 SEISMIC TOSS ball (M3b made it the real TM_SEISMIC_TOSS)
; New to Crystal
	const EVENT_KURTS_HOUSE_GRANDDAUGHTER_1
	const EVENT_KURTS_HOUSE_GRANDDAUGHTER_2
	const EVENT_RUINS_OF_ALPH_OUTSIDE_TOURIST_FISHER
	const EVENT_RUINS_OF_ALPH_OUTSIDE_TOURIST_YOUNGSTERS
	const EVENT_DRAGON_SHRINE_CLAIR
	const EVENT_BATTLE_TOWER_BATTLE_ROOM_YOUNGSTER
	const EVENT_PLAYERS_HOUSE_1F_NEIGHBOR
	const EVENT_PLAYERS_NEIGHBORS_HOUSE_NEIGHBOR
	const EVENT_PICKED_UP_GOLD_BERRY_FROM_HO_OH_ITEM_ROOM
	const EVENT_PICKED_UP_MYSTERYBERRY_FROM_HO_OH_ITEM_ROOM
	const EVENT_PICKED_UP_REVIVAL_HERB_FROM_HO_OH_ITEM_ROOM
	const EVENT_PICKED_UP_CHARCOAL_FROM_HO_OH_ITEM_ROOM
	const EVENT_PICKED_UP_BERRY_FROM_KABUTO_ITEM_ROOM
	const EVENT_PICKED_UP_PSNCUREBERRY_FROM_KABUTO_ITEM_ROOM
	const EVENT_PICKED_UP_HEAL_POWDER_FROM_KABUTO_ITEM_ROOM
	const EVENT_PICKED_UP_ENERGYPOWDER_FROM_KABUTO_ITEM_ROOM
	const EVENT_PICKED_UP_MYSTERYBERRY_FROM_OMANYTE_ITEM_ROOM
	const EVENT_PICKED_UP_MYSTIC_WATER_FROM_OMANYTE_ITEM_ROOM
	const EVENT_PICKED_UP_STARDUST_FROM_OMANYTE_ITEM_ROOM
	const EVENT_PICKED_UP_STAR_PIECE_FROM_OMANYTE_ITEM_ROOM
	const EVENT_PICKED_UP_GOLD_BERRY_FROM_AERODACTYL_ITEM_ROOM
	const EVENT_PICKED_UP_MOON_STONE_FROM_AERODACTYL_ITEM_ROOM
	const EVENT_PICKED_UP_HEAL_POWDER_FROM_AERODACTYL_ITEM_ROOM
	const EVENT_PICKED_UP_ENERGY_ROOT_FROM_AERODACTYL_ITEM_ROOM
	const EVENT_AZALEA_TOWN_KURT
	const EVENT_ILEX_FOREST_KURT
	const EVENT_MOUNT_MORTAR_1F_INSIDE_MAX_POTION
	const EVENT_MOUNT_MORTAR_1F_INSIDE_NUGGET
	const EVENT_ECRUTEAK_GYM_GRAMPS
	const EVENT_ECRUTEAK_CITY_GRAMPS
	const EVENT_EUSINE_IN_BURNED_TOWER
	const EVENT_WISE_TRIOS_ROOM_WISE_TRIO_1
	const EVENT_WISE_TRIOS_ROOM_WISE_TRIO_2
	const EVENT_CIANWOOD_CITY_EUSINE
	const EVENT_SAW_SUICUNE_AT_CIANWOOD_CITY
	const EVENT_SAW_SUICUNE_ON_ROUTE_42
	const EVENT_SAW_SUICUNE_ON_ROUTE_36
	const EVENT_ECRUTEAK_TIN_TOWER_ENTRANCE_WANDERING_SAGE
	const EVENT_TIN_TOWER_1F_SUICUNE
	const EVENT_TIN_TOWER_1F_ENTEI
	const EVENT_TIN_TOWER_1F_RAIKOU
	const EVENT_TIN_TOWER_1F_EUSINE
	const EVENT_TIN_TOWER_1F_WISE_TRIO_1
	const EVENT_SET_WHEN_FOUGHT_HO_OH
	const EVENT_ROUTE_30_ANTIDOTE
	const EVENT_ILEX_FOREST_X_ATTACK
	const EVENT_ILEX_FOREST_ANTIDOTE
	const EVENT_ILEX_FOREST_ETHER
	const EVENT_ROUTE_34_NUGGET
	const EVENT_ROUTE_44_MAX_REPEL
	const EVENT_ICE_PATH_1F_PROTEIN
	const EVENT_DRAGONS_DEN_B1F_CALCIUM
	const EVENT_DRAGONS_DEN_B1F_MAX_ELIXER
	const EVENT_SILVER_CAVE_ROOM_1_ULTRA_BALL
	const EVENT_SILVER_CAVE_ROOM_2_CALCIUM
	const EVENT_SILVER_CAVE_ROOM_2_ULTRA_BALL
	const EVENT_SILVER_CAVE_ROOM_2_PP_UP
	const EVENT_TIN_TOWER_1F_WISE_TRIO_2
	const EVENT_TIN_TOWER_6F_MAX_POTION
	const EVENT_TIN_TOWER_9F_HP_UP
	const EVENT_MOUNT_MORTAR_1F_INSIDE_IRON
	const EVENT_MOUNT_MORTAR_1F_INSIDE_ULTRA_BALL
	const EVENT_MOUNT_MORTAR_B1F_FULL_RESTORE
	const EVENT_MOUNT_MORTAR_B1F_MAX_ETHER
	const EVENT_MOUNT_MORTAR_B1F_PP_UP
	const EVENT_RADIO_TOWER_5F_ULTRA_BALL
	const EVENT_DARK_CAVE_VIOLET_ENTRANCE_DIRE_HIT
	const EVENT_BATTLE_TOWER_OPEN_CIVILIANS
; Kanto hack: Yellow intro beat (docs/M2-INTRO.md)
	const EVENT_PALLET_TOWN_OAK ; set at NewGame; Oak only appears via the cutscene
	const EVENT_OAKS_LAB_RIVAL
	const EVENT_OAKS_LAB_EEVEE_BALL
	const EVENT_GOT_STARTER_PIKACHU
	const EVENT_BATTLED_RIVAL_IN_OAKS_LAB
; Kanto hack: Oak's Parcel (docs/M2-PARCEL.md)
	const EVENT_GOT_OAKS_PARCEL
	const EVENT_OAK_GOT_PARCEL
	const EVENT_GOT_POTION_SAMPLE
	const EVENT_GOT_POKEBALLS_FROM_OAK
	const EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE
; Kanto hack: Route 22 rival battle #1 (docs/M2-ROUTE22.md)
	const EVENT_ROUTE22_RIVAL ; object hidden; the Route 22 OBJECTS callback derives it
; Kanto hack: Viridian's old-man catch tutorial (docs/M2-CATCH.md)
	const EVENT_VIRIDIAN_OLD_MAN_CATCH_DEMO ; his first (failed) demo is done; he stands aside
; Kanto hack: Viridian Forest (docs/M2-FOREST.md). Its two POTION itemballs
; reuse the dead EVENT_ROUTE_2_CARBOS/ELIXER flags above, so the forest costs
; 8 new flags, not 10.
	const EVENT_BEAT_BUG_CATCHER_SAMMY ; forest trainer 1 (Yellow BUG_CATCHER 1)
	const EVENT_BEAT_BUG_CATCHER_ELIJAH ; forest trainer 2 (Yellow BUG_CATCHER 2)
	const EVENT_BEAT_BUG_CATCHER_ANTHONY ; forest trainer 3 (Yellow BUG_CATCHER 3)
	const EVENT_BEAT_LASS_SARAH ; forest trainer 4 (Yellow LASS 19)
	const EVENT_BEAT_BUG_CATCHER_WESLEY ; forest trainer 5 (Yellow BUG_CATCHER 15)
	const EVENT_VIRIDIAN_FOREST_POKE_BALL ; the POKe BALL itemball at (1,31)
	const EVENT_VIRIDIAN_FOREST_HIDDEN_POTION ; hidden POTION at (1,18)
	const EVENT_VIRIDIAN_FOREST_HIDDEN_ANTIDOTE ; hidden ANTIDOTE at (16,42)
; Kanto hack: Brock (docs/M2-PEWTER-CITY.md). Crystal's Kanto gym leaders hand
; out no TMs, so there is no flag to reuse for Yellow's Brock TM.
	const EVENT_GOT_TM_FROM_BROCK ; TM_ROLLOUT, standing in for Yellow's TM34 BIDE
; Kanto hack: Route 3 (docs/M2-MTMOON.md). Four of Yellow's eight trainers
; reuse Crystal's dead Route 3 flags (YOUNGSTER WARREN/JIMMY keep their names;
; FIREBREATHER OTIS/BURT were renamed in place above), so Route 3 costs four
; new flags, not eight.
	const EVENT_BEAT_BUG_CATCHER_DION ; Route 3, Yellow's BUG_CATCHER 5
	const EVENT_BEAT_LASS_SALLY ; Route 3, Yellow's LASS 2
	const EVENT_BEAT_BUG_CATCHER_BRETT ; Route 3, Yellow's BUG_CATCHER 6
	const EVENT_BEAT_LASS_ROBIN ; Route 3, Yellow's LASS 3
; Kanto hack: Mt. Moon 1F (docs/M2-MTMOON.md). Five in-scope Crystal flags were
; renamed in place above (PICNICKER HOPE/SHARON from Route 4, MT_MOON_RIVAL and
; MT_MOON_SQUARE_ROCK and MOUNT_MOON_SQUARE_HIDDEN_MOON_STONE from the deleted
; MOUNT_MOON maps) and Crystal's never-used EVENT_BEAT_SUPER_NERD_GREGG was
; taken as-is, so 1F's 7 trainers + 6 itemballs cost seven new flags, not
; thirteen. Mt. Moon B1F has no objects at all. NOTE: EVENT_BEAT_RIVAL_IN_MT_MOON (now
; EVENT_BEAT_RIVAL_IN_DRAGONS_DEN, M11 14c) was NOT free - Johto's Dragon's Den / Dragon Shrine / Indigo Plateau scripts
; still read it - and EVENT_MT_MOON_SQUARE_CLEFAIRY is still set by an (orphaned)
; std script, so neither was reused.
	const EVENT_BEAT_LASS_MELISSA ; Mt. Moon 1F, Yellow's LASS 5
	const EVENT_BEAT_LASS_NADINE ; Mt. Moon 1F, Yellow's LASS 6
	const EVENT_BEAT_BUG_CATCHER_TRAVIS ; Mt. Moon 1F, Yellow's BUG_CATCHER 7
	const EVENT_BEAT_BUG_CATCHER_NEIL ; Mt. Moon 1F, Yellow's BUG_CATCHER 8
	const EVENT_MT_MOON_1F_POTION_1 ; the POTION itemball at (2,20)
	const EVENT_MT_MOON_1F_ESCAPE_ROPE ; the ESCAPE_ROPE itemball at (36,23)
	const EVENT_MT_MOON_1F_POTION_2 ; the POTION itemball at (20,33)
; Kanto hack: Mt. Moon B2F (5f, docs/M2-MTMOON.md) cost ZERO new flags - its
; three Rocket grunts, SUPER NERD MIGUEL, the two fossil objects, the two
; itemballs and the two hidden items all reuse dead Crystal flags renamed in
; place above (EVENT_BEAT_ROCKET_GRUNTM_12/20/21/22/23/26/27/30/31,
; EVENT_BEAT_SUPER_NERD_JAY and the misspelled EVENT_BEAY_SUPER_NERD_DAVE -
; every one of them referenced nowhere but this file).
; Kanto hack: Mt. Moon Pokemon Center (5g, docs/M2-MTMOON.md). Yellow's
; EVENT_BOUGHT_MAGIKARP. The only remaining unreferenced Crystal flags are
; Johto rematch flags (EVENT_BEAT_*2/*3 and a handful of Kanto gym-trainer
; ones) that the Johto milestone will still want, so this one is APPENDED from
; the free pool rather than renamed in place: 16 free -> 15 free.
	const EVENT_BOUGHT_MAGIKARP ; the Mt. Moon Pokecenter MAGIKARP salesman has been paid
; Kanto hack: Mt. Moon B2F Jessie & James (5h, docs/M2-MTMOON.md). One APPENDED
; flag: the pair's object-visibility flag. It is NOT "beaten" (that stays
; EVENT_BEAT_MT_MOON_B2F_JESSIE_JAMES, renamed in place by 5f); it only says
; "the two objects are off the map", which is true both before the cutscene and
; after it. MAPCALLBACK_OBJECTS sets it on every map load, the scene's `appear`
; clears it and its `disappear` sets it again. 15 free -> 14 free.
	const EVENT_MT_MOON_B2F_JESSIE_JAMES_HIDDEN ; JESSIE and JAMES are off the map

; Kanto hack: the Pewter Museum (docs/M2-PEWTER.md, 4d). 14 free -> 12 free.
	const EVENT_BOUGHT_MUSEUM_TICKET
	const EVENT_GOT_OLD_AMBER

; Kanto hack (docs/HOUSEKEEPING.md): the pool was grown from 2048 to 2560 flags.
; That is +64 bytes of wEventFlags, paid for out of the unused `ds 100` padding
; that sits immediately in front of wEventFlags in ram/wram.asm (now `ds 36`),
; so nothing live moved and WRAM bank 1 is no fuller than it was.
; 36 bytes of that padding are left, i.e. one more +256-flag bump is available.

; Kanto hack: the Cerulean Rocket break-in (6c, docs/M3-CERULEAN.md). Four
; APPENDED flags; the first three are object-visibility flags (SET = hidden, the
; object_event convention). The thief's is set by the scene's `disappear` once
; TM_DIG has actually landed in the bag; the two Officer Jennys are re-derived
; from EVENT_CERULEAN_GUARDS_STAND_ASIDE by CeruleanCityObjectsCallback on every
; map load, so a white-out mid-beat can never strand the guard swap half-done.
; Yellow sets that fourth fact in TWO places (BillsHouse_2.asm's S.S. Ticket
; hand-over and CeruleanCity_2.asm's CeruleanHideRocket); 6c wires the second,
; and Bill's scene (6i) only has to `setevent` it. 524 free -> 520 free.
	const EVENT_CERULEAN_ROCKET_THIEF_HIDDEN ; the thief has handed the TM over and run
	const EVENT_CERULEAN_GUARD_1_HIDDEN ; Officer Jenny by the road (28,12)
	const EVENT_CERULEAN_GUARD_2_HIDDEN ; Officer Jenny blocking the door (27,12)
	const EVENT_CERULEAN_GUARDS_STAND_ASIDE ; S.S. Ticket from Bill, or the thief beaten: the trashed house's door is open

; Kanto hack: the Cerulean rival battle, Yellow's third (6d,
; docs/M3-CERULEAN.md).  Three APPENDED flags.  The first two are this beat's
; own state (SET = hidden, the object_event convention); CeruleanCityObjectsCallback
; derives the rival's visibility from EVENT_BEAT_CERULEAN_RIVAL on every map
; load, so a white-out can never strand him half-way through the cutscene.
;
; The third is the Eevee bookkeeping.  Yellow's rival evolves his EEVEE from
; wRivalStarter (vendor/pokeyellow/constants/pokemon_constants.asm:207-209),
; which is written in exactly two places:
;   * OaksLab.asm:230-231 sets JOLTEON when he takes the ball, then
;     OaksLabRivalEndBattleScript (OaksLab.asm:365-381) overwrites it with
;     FLAREON if the player WON the lab battle and VAPOREON if not;
;   * Route22Rival1AfterBattleScript (Route22.asm:150-156) promotes FLAREON ->
;     JOLTEON when the player wins Route 22 (it only fires on a win, and only
;     upgrades FLAREON, so a lab loss stays VAPOREON forever).
; The Cerulean battle does NOT touch it (its party, Rival1Data #3, is fixed).
; So the whole rule is a function of two win/loss facts, and we store them as
; flags instead of a WRAM byte:
;   EVENT_BEAT_OAKS_LAB_RIVAL + EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE -> JOLTEON
;   EVENT_BEAT_OAKS_LAB_RIVAL alone                                 -> FLAREON
;   neither (the lab battle was lost)                               -> VAPOREON
; EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE already exists and is only set on a win
; (losing there is a white-out).  The lab battle is BATTLETYPE_CANLOSE, so it
; needed a flag of its own; OaksLab.asm sets it from wScriptVar right after
; `startbattle`.  Pokemon Tower 2F / Silph Co. 7F / the Champion's room read
; the pair in a later milestone.  520 free -> 517 free.
	const EVENT_CERULEAN_RIVAL_HIDDEN ; the rival is off the map (before he walks in / after he leaves)
	const EVENT_BEAT_CERULEAN_RIVAL ; Yellow's third rival battle, at the south end of Nugget Bridge
	const EVENT_BEAT_OAKS_LAB_RIVAL ; won the Oak's Lab battle (BATTLETYPE_CANLOSE): half of the Eevee rule

; Kanto hack: Cerulean Gym / MISTY (6e, docs/M3-CERULEAN.md).  ONE appended flag.
; Yellow's Misty hands over TM11 BUBBLEBEAM after the CASCADEBADGE; our TM is
; TM18 RAIN_DANCE (§0.8), given by `verbosegiveitem`, so the give needs a flag of
; its own exactly as Brock's TM_ROLLOUT does (EVENT_GOT_TM_FROM_BROCK).
; §3's table proposed renaming EVENT_FOUND_MACHINE_PART_IN_CERULEAN_GYM (index
; 265) for this; that flag is NOT dead -- InitializeEventsScript sets it and
; PowerPlant.asm clears it to arm Johto's machine-part quest -- so it was left
; alone and this flag was appended instead.  517 free -> 516 free.
	const EVENT_GOT_TM_FROM_MISTY ; Misty has handed over TM18 RAIN_DANCE

; Kanto hack: Melanie's house / the BULBASAUR gift (6g, docs/M3-CERULEAN.md).
; ONE appended flag, Yellow's EVENT_GOT_BULBASAUR_IN_CERULEAN.  It doubles as
; the Bulbasaur object's hidden flag in the object_event row, so the separate
; "toggle" visibility flags §6 budgeted for are not needed (same trick as
; EVENT_GOT_OLD_AMBER in Museum1F).  516 free -> 515 free.
	const EVENT_GOT_BULBASAUR_FROM_MELANIE ; Melanie has handed over the L10 BULBASAUR

; Kanto hack: Route 24 / Nugget Bridge (6h, docs/M3-CERULEAN.md).  ONE renamed
; in place -- EVENT_ROUTE_24_ROCKET -> EVENT_BEAT_ROUTE_24_ROCKET, see the
; "Kanto people" block above -- plus NINE appended.  Yellow's six bridge
; trainers each need a beat flag; the NUGGET give needs one of its own so a
; real loss to the recruiter re-arms the battle without re-gifting the prize
; (Yellow sets a single EVENT_GOT_NUGGET before the fight, which permanently
; disarms it on a loss); the TM ball needs the usual itemball hide flag; and
; DAMIAN's CHARMANDER needs Yellow's EVENT_54F.  515 free -> 506 free.
	const EVENT_BEAT_CAMPER_ANSEL ; Nugget Bridge, the Jr.Trainer hiding in the west grass
	const EVENT_BEAT_CAMPER_RUFUS ; Nugget Bridge No. 5
	const EVENT_BEAT_LASS_NORMA ; Nugget Bridge No. 4
	const EVENT_BEAT_YOUNGSTER_VICTOR ; Nugget Bridge No. 3
	const EVENT_BEAT_LASS_PAULINE ; Nugget Bridge No. 2
	const EVENT_BEAT_BUG_CATCHER_MERLE ; Nugget Bridge No. 1
	const EVENT_GOT_NUGGET_ON_ROUTE_24 ; the recruiter has handed over the NUGGET
	const EVENT_ROUTE_24_TM_THUNDER_WAVE ; the TM ball at (10,5) has been picked up (M3b: Yellow's TM45 THUNDER WAVE, was TM_ZAP_CANNON)
	const EVENT_GOT_CHARMANDER_FROM_DAMIAN ; DAMIAN has handed over the L10 CHARMANDER

; Kanto hack: L1 Kanto-leftovers pass (docs/AUDIT-KANTO-LEFTOVERS.md 7).
; SIX appended flags.  Three drive Yellow beats that were missing entirely --
; Daisy's TOWN MAP gift (which doubles as the Blue's House prop's hidden flag),
; the two POKeDEX props on Oak's desk, and the catch-tutorial old man walking
; off to restock at the MART (his object's hidden flag, cleared again by
; ViridianMart's NEWMAP callback) -- and three are Yellow hidden items that had
; never been ported.  506 free -> 500 free.  N1b appends a seventh:
; 500 free -> 499 free.
	const EVENT_GOT_TOWN_MAP ; Daisy has handed over the TOWN MAP (also hides the Blue's House prop)
	const EVENT_OAKS_LAB_POKEDEX ; the two desk POKeDEX props are gone (set when Oak hands the dex over)
	const EVENT_VIRIDIAN_OLD_MAN_GONE_TO_MART ; the catch-tutorial old man is off buying # BALLs (his hidden flag)
	const EVENT_ROUTE_25_HIDDEN_ETHER ; Yellow's hidden ETHER at (38,3)
	const EVENT_ROUTE_25_HIDDEN_ELIXER ; Yellow's hidden ELIXER at (10,1)
	const EVENT_CERULEAN_CITY_HIDDEN_RARE_CANDY ; Yellow's hidden RARE CANDY at (15,8)
	const EVENT_OAKS_LAB_OAK ; OAK is still out looking for #MON (his object's hidden flag, cleared by the lab intro)

; Kanto hack: Route 6's six trainers (7d, docs/M4-VERMILION.md).  TWO renamed
; in place -- EVENT_BEAT_POKEFANM_REX/ALLAN, the two Crystal trainers who stood
; on Yellow's trainer-0/1 tiles and are deleted by 7d -- plus FOUR appended.
; 499 free -> 495 free.
	const EVENT_BEAT_BUG_CATCHER_LOGAN ; Route 6, Yellow's BUG_CATCHER 10
	const EVENT_BEAT_CAMPER_OLIVER ; Route 6, Yellow's JR_TRAINER_M 5
	const EVENT_BEAT_PICNICKER_GRETA ; Route 6, Yellow's JR_TRAINER_F 3
	const EVENT_BEAT_BUG_CATCHER_FELIX ; Route 6, Yellow's BUG_CATCHER 11

; Kanto hack: the POKeMON FAN CLUB (7f, docs/M4-VERMILION.md).  FOUR renamed in
; place (EVENT_GOT_BIKE_VOUCHER, EVENT_PIKACHU_FAN_BOAST, EVENT_SEEL_FAN_BOAST,
; EVENT_LEFT_FANCLUB_AFTER_BIKE_VOUCHER -- all four were Crystal Fan Club flags
; the port deletes) plus ONE appended: Yellow keeps "has the club's Pikachu
; scene ever played" in wPokemonFanClubCurScript, a saved Gen 1 map-script
; variable that GSC's script engine has no equivalent of (a new wMapScenes
; entry would cost saved WRAM, and bank 1 is full).  495 free -> 494 free.
	const EVENT_POKEMON_FAN_CLUB_PIKACHU_SCENE ; the Fan Club Pikachu scene has played once; later entries re-roll Yellow's 25/256

; Kanto hack: Yellow's three VIRIDIAN CITY old-man objects (P1, docs/M2-CATCH.md).
; Yellow toggles a LYING gambler, a standing OLD_MAN_2 on the road and a
; wandering OLD_MAN_1 by the nook; each Crystal object_event can carry only ONE
; hidden flag, and the other two states already have exact flags to reuse
; (EVENT_OAK_GOT_PARCEL hides the sleeper at precisely Yellow's moment,
; EVENT_VIRIDIAN_OLD_MAN_GONE_TO_MART hides the wanderer until the MART visit).
; The standing man needs "visible only between the POKeDEX and his demo", two
; toggles, so he gets one appended flag that the OBJECTS callback owns outright.
; 494 free -> 493 free.
	const EVENT_VIRIDIAN_OLD_MAN_OFF_ROAD ; the awake old man is not standing on (18,9) (his hidden flag; owned by ViridianCityGrampsCallback)

; Kanto hack: S.S. ANNE's trainers, item balls, hidden items and the 2F rival
; (7h, docs/M4-VERMILION.md).  FIFTEEN renamed in place -- eight dead duplicate
; rematch trainer flags (EVENT_BEAT_GENTLEMAN_VIRGIL, EVENT_BEAT_YOUNGSTER_JOEY2,
; EVENT_BEAT_LASS_CONNIE2/CONNIE3, EVENT_BEAT_FISHER_RALPH2/RALPH3,
; EVENT_BEAT_SAILOR_HUEY2/HUEY3) and seven dead Crystal item flags
; (EVENT_GOT_CLEANSE_TAG, EVENT_FOUND_BERSERK_GENE_IN_CERULEAN_CITY and the five
; EVENT_GOT_*_FROM_BILLS_GRANDPA, all left dead and free by M3) -- plus ELEVEN
; appended: the other eight S.S. ANNE trainers, the KITCHEN's hidden GREAT BALL,
; and the two rival flags 7i needs.  The rival's object_event field 13 is a HIDE
; flag, so 3.3's proposed EVENT_SS_ANNE_RIVAL_APPEARED is inverted here to match
; the engine and the CeruleanCity precedent.  493 free -> 482 free.
	const EVENT_BEAT_GENTLEMAN_BARTON ; S.S. ANNE 1F Rooms, Yellow's GENTLEMAN 2
	const EVENT_BEAT_GENTLEMAN_CLIVE ; S.S. ANNE 2F Rooms, Yellow's GENTLEMAN 3
	const EVENT_BEAT_GENTLEMAN_HUBERT ; S.S. ANNE 2F Rooms, Yellow's GENTLEMAN 5
	const EVENT_BEAT_SAILOR_LEO ; S.S. ANNE B1F Rooms, Yellow's SAILOR 3
	const EVENT_BEAT_SAILOR_BRADY ; S.S. ANNE B1F Rooms, Yellow's SAILOR 4
	const EVENT_BEAT_SAILOR_FORREST ; S.S. ANNE B1F Rooms, Yellow's SAILOR 5
	const EVENT_BEAT_SAILOR_SEAMUS ; S.S. ANNE B1F Rooms, Yellow's SAILOR 6
	const EVENT_BEAT_SAILOR_SILAS ; S.S. ANNE B1F Rooms, Yellow's SAILOR 7
	const EVENT_SS_ANNE_KITCHEN_HIDDEN_GREAT_BALL ; S.S. ANNE KITCHEN hidden GREAT BALL (13,9)
	const EVENT_SS_ANNE_2F_RIVAL_HIDDEN ; the 2F rival is not standing at (36,4) (his hidden flag; owned by SSAnne2FObjectsCallback -- 7i clears it for the corridor scene)
	const EVENT_BEAT_RIVAL_SS_ANNE ; 7i: the S.S. ANNE 2F rival battle (rival #3) is over

; Kanto hack: M4 step 7l (ROUTE 11 + ROUTE 11 GATE 2F).  Ten Route 11 trainers:
; three youngster flags and the two dead PSYCHIC_T flags were renamed in place
; above, the remaining six are appended here.  EVENT_BEAT_ROUTE_12_SNORLAX is
; Yellow's EVENT_BEAT_ROUTE12_SNORLAX, read by the gate's left binoculars; it
; could not reuse Crystal's EVENT_FOUGHT_SNORLAX, which was then live in
; VictoryRoadGate and engine/phone/scripts/irwin_gossip.asm (VictoryRoadGate
; stopped reading it in M10 13d; irwin_gossip still does).  482 free -> 476.
	const EVENT_BEAT_YOUNGSTER_CLIFF ; ROUTE 11, Yellow's YOUNGSTER 12
	const EVENT_BEAT_GENTLEMAN_ARTHUR ; ROUTE 11, Yellow's GAMBLER 1
	const EVENT_BEAT_GENTLEMAN_LEOPOLD ; ROUTE 11, Yellow's GAMBLER 2
	const EVENT_BEAT_GENTLEMAN_WINSTON ; ROUTE 11, Yellow's GAMBLER 3
	const EVENT_BEAT_GENTLEMAN_HORACE ; ROUTE 11, Yellow's GAMBLER 4
	const EVENT_BEAT_ROUTE_12_SNORLAX ; the ROUTE 12 SNORLAX has been woken and fought (M5); ROUTE 11 GATE 2F binoculars

; Kanto hack: M5 step 8h (the Lavender interiors).  One append: Yellow's
; EVENT_RESCUED_MR_FUJI, the story flag M6 sets when the player clears the
; #MON TOWER.  Three texts already branch on it (MR FUJI'S HOUSE's SUPER NERD
; and TWIN, LAVENDER MART's COOLTRAINER_M) and MrFujisHouseObjectsCallback
; derives MR FUJI's hide flag from it.  The object row's own hide flag reuses
; the dead EVENT_BEAT_SWIMMERF_BRIANA slot, renamed in place above.
; 476 free -> 475.
	const EVENT_RESCUED_MR_FUJI ; MR FUJI is back home from the #MON TOWER (Yellow's EVENT_RESCUED_MR_FUJI); set by M6's tower rescue

; Kanto hack: M6 step 9e (POKEMON TOWER 2F, the rival's fourth battle).  TWO
; appends, not the three docs/M6-TOWER.md 3.12 budgeted.
;
; Yellow's EVENT_POKEMON_TOWER_RIVAL_ON_LEFT is deliberately NOT ported.  It
; exists only because Gen 1 splits the scene across three script-pointer states
; (PokemonTower2FDefaultScript sets the flag, PokemonTower2FDefeatedRivalScript
; reads it back after the battle to pick the exit path); it is reset at the top
; of every trigger and can never survive a battle boundary, so it carries no
; cross-session meaning.  GSC runs the whole beat as one linear script per
; coord_event, so each entry tile already knows its own exit walk -- exactly how
; the shipped S.S. ANNE (7i) and CERULEAN (6d) rival scenes are built.  475 free
; -> 473.
	const EVENT_BEAT_POKEMON_TOWER_RIVAL ; 9e: Yellow's fourth rival battle, POKEMON TOWER 2F, is over
	const EVENT_POKEMON_TOWER_2F_RIVAL_HIDDEN ; the 2F rival is off the map (derived from the flag above by PokemonTower2FObjectsCallback)

; Kanto hack: M6 step 9j (POKEMON TOWER 7F, JESSIE & JAMES).  TWO appends, and
; 9k adds none.
;
; Yellow's EVENT_POKEMONTOWER_7_JESSIE_JAMES_ON_LEFT is deliberately NOT ported,
; for the reason given for the 2F rival above: it only exists so that Gen 1's
; split script states can read back which trigger tile was stepped on, and GSC
; gives each coord_event its own linear script.  Yellow's EVENT_RESCUED_MR_FUJI_2
; has no analogue either (it only drove Gen 1's second ShowObject; our
; MrFujisHouse derives MR FUJI's visibility from EVENT_RESCUED_MR_FUJI, which
; already exists, and 9k only sets it).  MR FUJI's 7F object row hides on
; EVENT_RESCUED_MR_FUJI itself -- there the hide polarity already matches the
; story flag, so it needs no dedicated row.  473 free -> 471.
	const EVENT_BEAT_POKEMON_TOWER_JESSIE_JAMES ; 9j: Yellow's third JESSIE & JAMES battle, POKEMON TOWER 7F, is over
	const EVENT_POKEMON_TOWER_7F_JESSIE_JAMES_HIDDEN ; JESSIE and JAMES are off the map (set unconditionally by PokemonTower7FObjectsCallback)

; Kanto hack: M6 step 9l (MR FUJI'S HOUSE, the POKe FLUTE give).  ONE append
; (docs/M6-TOWER.md D19), Yellow's own EVENT_GOT_POKE_FLUTE
; (vendor/pokeyellow/constants/event_constants.asm).  It is the give's
; once-only guard in MrFujisHouseMrFujiScript and nothing else reads it:
; ROUTE 12's wake branch tests the item with `checkitem POKE_FLUTE`, not this
; flag (D20), exactly as Yellow's ItemUsePokeFlute tested the bag.
; 471 free -> 470.
	const EVENT_GOT_POKE_FLUTE ; MR FUJI has handed over the POKe FLUTE

; Kanto hack: M6 step 9q (CELADON GYM).  ONE append.  Yellow's seven gym
; trainers need seven flags; six came from renames in place (MICHELLE, TANYA
; and JULIA keep theirs, the dead BEAUTY VERONICA and the two TWINS JO & ZOE
; flags became BEAUTY LILY / BEAUTY POPPY / LASS HOLLY), and only the
; COOLTRAINERF needed a new one.  470 free -> 469.
	const EVENT_BEAT_COOLTRAINERF_IVY ; CELADON GYM trainer 7 (Yellow COOLTRAINER_F 1)

; Kanto hack: M6 step 9x (ROCKET HIDEOUT population).  28 flags needed; TEN
; came from renames in place of dead Johto phone-rematch rows (the ten
; EVENT_BEAT_ROCKET_HIDEOUT_* trainer flags above) and EIGHTEEN are appended
; here: thirteen item-ball hide flags, the three hidden items, the LIFT KEY
; drop gate and the JESSIE & JAMES hide flag.  469 free -> 451.
;
; The two "revealed" balls need TWO pieces of state each, because a GSC
; object_event has only one hide flag: the flag below is the ball's own
; (set by FindItemInBallScript's `disappear LAST_TALKED` once taken), and the
; B4F MAPCALLBACK_OBJECTS re-hides it while its GATE flag
; (EVENT_ROCKET_DROPPED_LIFT_KEY / EVENT_BEAT_ROCKET_HIDEOUT_GIOVANNI) is
; still clear.  The grunt's / GIOVANNI's script `appear`s it.
	const EVENT_ROCKET_HIDEOUT_B1F_ESCAPE_ROPE ; B1F (11,14)
	const EVENT_ROCKET_HIDEOUT_B1F_HYPER_POTION ; B1F (9,17)
	const EVENT_ROCKET_HIDEOUT_B1F_HIDDEN_PP_UP ; B1F (21,15)
	const EVENT_ROCKET_HIDEOUT_B2F_MOON_STONE ; B2F (1,11)
	const EVENT_ROCKET_HIDEOUT_B2F_NUGGET ; B2F (16,8)
	const EVENT_ROCKET_HIDEOUT_B2F_TM_HORN_DRILL ; B2F (6,12), Yellow's TM07
	const EVENT_ROCKET_HIDEOUT_B2F_SUPER_POTION ; B2F (3,21)
	const EVENT_ROCKET_HIDEOUT_B3F_TM_DOUBLE_EDGE ; B3F (26,17), Yellow's TM10
	const EVENT_ROCKET_HIDEOUT_B3F_RARE_CANDY ; B3F (20,14)
	const EVENT_ROCKET_HIDEOUT_B3F_HIDDEN_NUGGET ; B3F (27,17)
	const EVENT_ROCKET_HIDEOUT_B4F_HP_UP ; B4F (10,12)
	const EVENT_ROCKET_HIDEOUT_B4F_TM_RAZOR_WIND ; B4F (9,4), Yellow's TM02
	const EVENT_ROCKET_HIDEOUT_B4F_IRON ; B4F (12,20)
	const EVENT_ROCKET_HIDEOUT_B4F_HIDDEN_SUPER_POTION ; B4F (25,1)
	const EVENT_ROCKET_HIDEOUT_B4F_LIFT_KEY ; B4F (10,2), the dropped ball itself
	const EVENT_ROCKET_DROPPED_LIFT_KEY ; the B4F Rocket has been beaten and the LIFT KEY ball is on the floor
	const EVENT_GOT_SILPH_SCOPE ; B4F (25,2), the ball GIOVANNI leaves behind
	const EVENT_ROCKET_HIDEOUT_B4F_JESSIE_JAMES_HIDDEN ; JESSIE and JAMES are off the map (set unconditionally by RocketHideoutB4FObjectsCallback)

; Kanto hack (M7 10c, docs/M7-FUCHSIA.md): ROUTE 13.  Five of its eleven flags
; are renames of Crystal's own dead ROUTE 13 rows further up this file; these six
; had no dead row of the right shape left, so they are appended.  Flag names
; match the trainer const they gate (BIRD_KEEPER_6, PICNICKER_4, BEAUTY_1/2,
; BIKER_9), not Yellow's opponent number.
	const EVENT_BEAT_ROUTE_13_PICNICKER_4
	const EVENT_BEAT_ROUTE_13_BIRD_KEEPER_6
	const EVENT_BEAT_ROUTE_13_BEAUTY_1
	const EVENT_BEAT_ROUTE_13_BEAUTY_2
	const EVENT_BEAT_ROUTE_13_BIKER_9
	const EVENT_ROUTE_13_HIDDEN_PP_UP ; ROUTE 13 (1,14), read facing DOWN from (1,13)

; Kanto hack (M7 10d, docs/M7-FUCHSIA.md): ROUTE 14.  Three of its ten flags are
; renames of Crystal's own dead ROUTE 14 rows further up this file
; (BIRD_KEEPER_ROY, POKEFANM_CARTER, POKEFANM_TREVOR); the other seven are
; appended.  Flag names match the trainer const they gate, not Yellow's
; opponent number.
	const EVENT_BEAT_ROUTE_14_BIRD_KEEPER_9
	const EVENT_BEAT_ROUTE_14_BIRD_KEEPER_10
	const EVENT_BEAT_ROUTE_14_BIRD_KEEPER_11
	const EVENT_BEAT_ROUTE_14_BIRD_KEEPER_12
	const EVENT_BEAT_ROUTE_14_BIKER_11
	const EVENT_BEAT_ROUTE_14_BIKER_12
	const EVENT_BEAT_ROUTE_14_BIKER_13

; Kanto hack (M7 10e, docs/M7-FUCHSIA.md): ROUTE 15 and its gate.  Six of the ten
; trainer flags are renames of Crystal's own dead ROUTE 15 rows further up this
; file (TEACHER COLETTE/HILLARY, SCHOOLBOY KIPP/TOMMY/JOHNNY/BILLY); the four
; BEAUTY/BIKER ones are appended, because the rows those two classes took over
; (BRENDA/CAROLINE, and the BIKER class generally) have no dead flags left.
; EVENT_GOT_EXP_ALL gates ROUTE 15 GATE 2F's Oak's aide, Yellow's
; EVENT_GOT_EXP_ALL.  438 free -> 433.
	const EVENT_BEAT_ROUTE_15_BEAUTY_3
	const EVENT_BEAT_ROUTE_15_BEAUTY_4
	const EVENT_BEAT_ROUTE_15_BIKER_14
	const EVENT_BEAT_ROUTE_15_BIKER_15
	const EVENT_GOT_EXP_ALL

; Kanto hack (M7 10l, docs/M7-FUCHSIA.md): the SAFARI ZONE's four areas.  All
; twelve are appended, not renamed: Crystal's own Safari Zone maps are empty
; stubs with no events of any kind, so there is no dead row of the right shape
; anywhere in this file, and the only strictly-unreferenced rows left are Johto
; trainer-beat flags whose names would have to lie.  433 free -> 421.
	const EVENT_SAFARI_ZONE_CENTER_NUGGET
	const EVENT_SAFARI_ZONE_EAST_FULL_RESTORE
	const EVENT_SAFARI_ZONE_EAST_MAX_POTION
	const EVENT_SAFARI_ZONE_EAST_CARBOS
	const EVENT_SAFARI_ZONE_EAST_TM_EGG_BOMB
	const EVENT_SAFARI_ZONE_NORTH_PROTEIN
	const EVENT_SAFARI_ZONE_NORTH_TM_SKULL_BASH
	const EVENT_SAFARI_ZONE_WEST_MAX_POTION
	const EVENT_SAFARI_ZONE_WEST_TM_DOUBLE_TEAM
	const EVENT_SAFARI_ZONE_WEST_MAX_REVIVE
	const EVENT_SAFARI_ZONE_WEST_GOLD_TEETH
	const EVENT_SAFARI_ZONE_WEST_HIDDEN_REVIVE ; SAFARI ZONE WEST (6,5), read facing RIGHT from (5,5)

; Kanto hack (M8 11a, docs/M8-SAFFRON.md): SAFFRON CITY, SILPH CO., SABRINA's
; gym and the FIGHTING DOJO.  All 86 are appended, not renamed: every dead row
; this file still had of the right shape went to M6 and M7, and the only
; strictly-unreferenced rows left are Johto trainer-beat flags whose names
; would have to lie.  The survey budgeted ~60; Yellow's SILPH CO. alone wants
; 30 trainer flags, 14 item balls and 20 card-key doors.  421 free -> 335.
;
; Names follow Yellow's own constants where Yellow has one
; (vendor/pokeyellow/constants/event_constants.asm) and the floor + class
; otherwise; the trainer flags are ordered exactly as the object_events are in
; vendor/pokeyellow/data/maps/objects/SilphCo*.asm, so 11f can walk both lists
; side by side.
	const EVENT_BEAT_SILPH_CO_2F_SCIENTIST_1
	const EVENT_BEAT_SILPH_CO_2F_SCIENTIST_2
	const EVENT_BEAT_SILPH_CO_2F_ROCKET_1
	const EVENT_BEAT_SILPH_CO_2F_ROCKET_2
	const EVENT_BEAT_SILPH_CO_3F_ROCKET
	const EVENT_BEAT_SILPH_CO_3F_SCIENTIST
	const EVENT_BEAT_SILPH_CO_4F_ROCKET_1
	const EVENT_BEAT_SILPH_CO_4F_SCIENTIST
	const EVENT_BEAT_SILPH_CO_4F_ROCKET_2
	const EVENT_BEAT_SILPH_CO_5F_ROCKET_1
	const EVENT_BEAT_SILPH_CO_5F_SCIENTIST
	const EVENT_BEAT_SILPH_CO_5F_JUGGLER ; Yellow's SPRITE_ROCKER / OPP_JUGGLER 1
	const EVENT_BEAT_SILPH_CO_5F_ROCKET_2
	const EVENT_BEAT_SILPH_CO_6F_ROCKET_1
	const EVENT_BEAT_SILPH_CO_6F_SCIENTIST
	const EVENT_BEAT_SILPH_CO_6F_ROCKET_2
	const EVENT_BEAT_SILPH_CO_7F_ROCKET_1
	const EVENT_BEAT_SILPH_CO_7F_SCIENTIST
	const EVENT_BEAT_SILPH_CO_7F_ROCKET_2
	const EVENT_BEAT_SILPH_CO_7F_ROCKET_3
	const EVENT_BEAT_SILPH_CO_8F_ROCKET_1
	const EVENT_BEAT_SILPH_CO_8F_SCIENTIST
	const EVENT_BEAT_SILPH_CO_8F_ROCKET_2
	const EVENT_BEAT_SILPH_CO_9F_ROCKET_1
	const EVENT_BEAT_SILPH_CO_9F_SCIENTIST
	const EVENT_BEAT_SILPH_CO_9F_ROCKET_2
	const EVENT_BEAT_SILPH_CO_10F_ROCKET
	const EVENT_BEAT_SILPH_CO_10F_SCIENTIST
	const EVENT_BEAT_SILPH_CO_11F_ROCKET
	const EVENT_BEAT_SILPH_CO_GIOVANNI ; 11F (6,9), Yellow's OPP_GIOVANNI 2
; The 7F rival and the 11F duo.  JESSIE_JAMES_HIDDEN follows ROCKET HIDEOUT
; B4F's pattern: the callback takes the pair off the map once they are beaten.
	const EVENT_BEAT_SILPH_CO_RIVAL ; 7F, the third KANTO_RIVAL battle (11g)
	const EVENT_BEAT_SILPH_CO_11F_JESSIE_JAMES
	const EVENT_SILPH_CO_11F_JESSIE_JAMES_HIDDEN
; 1F's receptionist is not at her desk while SILPH is occupied; she comes back
; when GIOVANNI falls (Yellow's EVENT_SILPH_CO_RECEPTIONIST_AT_DESK).  A GSC
; object_event flag is a HIDE flag, so the polarity is inverted from Yellow's
; and the name says so; maps/SilphCo1F.asm's MAPCALLBACK_OBJECTS derives it
; from EVENT_BEAT_SILPH_CO_GIOVANNI on every map load (11e).
	const EVENT_SILPH_CO_1F_RECEPTIONIST_HIDDEN
	const EVENT_GOT_MASTER_BALL ; 11F, the president's thank-you
; SILPH CO. item balls, in Yellow's own object order.
	const EVENT_SILPH_CO_3F_HYPER_POTION ; 3F (8,5)
	const EVENT_SILPH_CO_4F_FULL_HEAL ; 4F (3,9)
	const EVENT_SILPH_CO_4F_MAX_REVIVE ; 4F (4,7)
	const EVENT_SILPH_CO_4F_ESCAPE_ROPE ; 4F (5,8)
	const EVENT_SILPH_CO_5F_TM_TAKE_DOWN ; 5F (2,13), Yellow's TM09
	const EVENT_SILPH_CO_5F_PROTEIN ; 5F (4,6)
	const EVENT_SILPH_CO_5F_CARD_KEY ; 5F (21,16), the ball that opens the tower
	const EVENT_SILPH_CO_6F_HP_UP ; 6F (3,12)
	const EVENT_SILPH_CO_6F_X_ACCURACY ; 6F (2,15)
	const EVENT_SILPH_CO_7F_CALCIUM ; 7F (1,9)
	const EVENT_SILPH_CO_7F_TM_SWORDS_DANCE ; 7F (24,11), Yellow's TM03
	const EVENT_SILPH_CO_10F_TM_EARTHQUAKE ; 10F (2,12), Yellow's TM26
	const EVENT_SILPH_CO_10F_RARE_CANDY ; 10F (4,14)
	const EVENT_SILPH_CO_10F_CARBOS ; 10F (5,11)
; Itemfinder finds (vendor/pokeyellow/data/events/hidden_events.asm:117,121,302).
	const EVENT_SILPH_CO_5F_HIDDEN_ELIXER ; 5F (12,3)
	const EVENT_SILPH_CO_9F_HIDDEN_MAX_POTION ; 9F (2,15)
	const EVENT_COPYCATS_HOUSE_2F_HIDDEN_NUGGET ; COPYCAT's room (1,1)
; The card-key doors, one flag per door pair, exactly Yellow's twenty
; EVENT_SILPH_CO_n_UNLOCKED_DOORm.  11j re-applies them with changeblock from
; MAPCALLBACK_TILES, the RADIO TOWER 3F pattern.
	const EVENT_SILPH_CO_2F_UNLOCKED_DOOR_1
	const EVENT_SILPH_CO_2F_UNLOCKED_DOOR_2
	const EVENT_SILPH_CO_3F_UNLOCKED_DOOR_1
	const EVENT_SILPH_CO_3F_UNLOCKED_DOOR_2
	const EVENT_SILPH_CO_4F_UNLOCKED_DOOR_1
	const EVENT_SILPH_CO_4F_UNLOCKED_DOOR_2
	const EVENT_SILPH_CO_5F_UNLOCKED_DOOR_1
	const EVENT_SILPH_CO_5F_UNLOCKED_DOOR_2
	const EVENT_SILPH_CO_5F_UNLOCKED_DOOR_3
	const EVENT_SILPH_CO_6F_UNLOCKED_DOOR
	const EVENT_SILPH_CO_7F_UNLOCKED_DOOR_1
	const EVENT_SILPH_CO_7F_UNLOCKED_DOOR_2
	const EVENT_SILPH_CO_7F_UNLOCKED_DOOR_3
	const EVENT_SILPH_CO_8F_UNLOCKED_DOOR
	const EVENT_SILPH_CO_9F_UNLOCKED_DOOR_1
	const EVENT_SILPH_CO_9F_UNLOCKED_DOOR_2
	const EVENT_SILPH_CO_9F_UNLOCKED_DOOR_3
	const EVENT_SILPH_CO_9F_UNLOCKED_DOOR_4
	const EVENT_SILPH_CO_10F_UNLOCKED_DOOR
	const EVENT_SILPH_CO_11F_UNLOCKED_DOOR
; SAFFRON GYM's seven, named after the trainer const they gate, the way every
; other Crystal gym flag is (11h).
	const EVENT_BEAT_MEDIUM_TASHA
	const EVENT_BEAT_MEDIUM_MARLENA
	const EVENT_BEAT_MEDIUM_BEULAH
	const EVENT_BEAT_PSYCHIC_TYRON
	const EVENT_BEAT_PSYCHIC_HOLLIS
	const EVENT_BEAT_PSYCHIC_EZRA
	const EVENT_BEAT_PSYCHIC_DARIUS
; The FIGHTING DOJO (11d).  Its four BLACKBELTs get numbered flags rather than
; name-keyed ones because Yellow leaves them nameless; KARATE MASTER's loss
; opens the two choice balls, and taking one locks the other out.
	const EVENT_BEAT_FIGHTING_DOJO_TRAINER_1
	const EVENT_BEAT_FIGHTING_DOJO_TRAINER_2
	const EVENT_BEAT_FIGHTING_DOJO_TRAINER_3
	const EVENT_BEAT_FIGHTING_DOJO_TRAINER_4
	const EVENT_DEFEATED_FIGHTING_DOJO ; the KARATE MASTER is beaten
	const EVENT_GOT_HITMONLEE
	const EVENT_GOT_HITMONCHAN
; 11d/11n: EVENT_GOT_HITMONLEE / _HITMONCHAN are each ball's own HIDE flag, so
; only the ball you take disappears -- Yellow hides exactly one
; (vendor/pokeyellow/scripts/FightingDojo.asm:249,284).  This flag is no longer
; a HIDE flag: it is the "you already chose" marker the surviving ball reads to
; print "Better not get greedy..." (11d shipped both balls sharing it, which
; deleted the one you did not pick -- corrected by the 11n audit).
	const EVENT_GOT_FIGHTING_DOJO_GIFT
; SAFFRON CITY's six civilians (11c).  Yellow keeps them off the map with its
; global data/maps/toggleable_objects.asm table, which GSC has no analogue for,
; so they get one shared HIDE flag: InitializeEventsScript sets it at new game
; and 11k's takeover script clears it.  Same shape as RADIO TOWER's
; EVENT_RADIO_TOWER_CIVILIANS_AFTER.
	const EVENT_SAFFRON_CITY_CIVILIANS_AFTER
; SILPH CO. 2F's SILPH WORKER F hands over TM75 SELFDESTRUCT (Yellow's TM36)
; exactly once (11f).
	const EVENT_GOT_TM75_SELFDESTRUCT
; SILPH CO. 7F (11g).  Appended at the END of the used list, like the flag
; above, so no existing flag index moves.
; The SILPH WORKER at (1,5) hands over the LAPRAS exactly once (Yellow's
; BIT_GOT_LAPRAS in wStatusFlags4).
	const EVENT_GOT_LAPRAS
; The 7F rival is off the map once he has been beaten -- derived from
; EVENT_BEAT_SILPH_CO_RIVAL by SilphCo7FObjectsCallback on every map load, the
; same shape as the CERULEAN / S.S. ANNE / POKEMON TOWER rivals.
	const EVENT_SILPH_CO_7F_RIVAL_HIDDEN
; SAFFRON GYM (11l).  SABRINA hands over TM81 PSYWAVE (Yellow's TM46) exactly
; once; Yellow's EVENT_GOT_TM46.  Appended at the END of the used list so no
; existing flag index moves.
	const EVENT_GOT_TM81_PSYWAVE
; Kanto hack (M9 12c): ROUTES 20 and 21, Yellow's own flag names.  ROUTE 19's
; ten were renamed in place above; these nineteen are appended at the END of
; the used list so no existing flag index moves.
	const EVENT_BEAT_ROUTE_20_TRAINER_0
	const EVENT_BEAT_ROUTE_20_TRAINER_1
	const EVENT_BEAT_ROUTE_20_TRAINER_2
	const EVENT_BEAT_ROUTE_20_TRAINER_3
	const EVENT_BEAT_ROUTE_20_TRAINER_4
	const EVENT_BEAT_ROUTE_20_TRAINER_5
	const EVENT_BEAT_ROUTE_20_TRAINER_6
	const EVENT_BEAT_ROUTE_20_TRAINER_7
	const EVENT_BEAT_ROUTE_20_TRAINER_8
	const EVENT_BEAT_ROUTE_20_TRAINER_9
	const EVENT_BEAT_ROUTE_21_TRAINER_0
	const EVENT_BEAT_ROUTE_21_TRAINER_1
	const EVENT_BEAT_ROUTE_21_TRAINER_2
	const EVENT_BEAT_ROUTE_21_TRAINER_3
	const EVENT_BEAT_ROUTE_21_TRAINER_4
	const EVENT_BEAT_ROUTE_21_TRAINER_5
	const EVENT_BEAT_ROUTE_21_TRAINER_6
	const EVENT_BEAT_ROUTE_21_TRAINER_7
	const EVENT_BEAT_ROUTE_21_TRAINER_8

; M9 12e -- SEAFOAM ISLANDS.  Twelve boulder HIDE flags (set = the object is
; hidden) reproducing Yellow's `toggleable_objects.asm` initial states, and
; eight "this boulder went down that hole" flags reproducing Yellow's
; EVENT_SEAFOAM{1,2,3,4}_BOULDER{1,2}_DOWN_HOLE.  The ones that start hidden
; are set at new game in InitializeEventsScript (engine/events/std_scripts.asm).
	const EVENT_BOULDER_IN_SEAFOAM_ISLANDS_1F_1  ; (18,10), visible
	const EVENT_BOULDER_IN_SEAFOAM_ISLANDS_1F_2  ; (26, 7), visible
	const EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B1F_1 ; (17, 6), starts hidden
	const EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B1F_2 ; (22, 6), starts hidden
	const EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B2F_1 ; (18, 6), starts hidden
	const EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B2F_2 ; (23, 6), starts hidden
	const EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B3F_1 ; ( 3,15), visible
	const EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B3F_2 ; ( 8,14), visible
	const EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B3F_3 ; (18, 6), starts hidden
	const EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B3F_4 ; (19, 6), starts hidden
	const EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B4F_1 ; ( 4,15), starts hidden
	const EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B4F_2 ; ( 5,15), starts hidden
	const EVENT_SEAFOAM_ISLANDS_1F_BOULDER_1_DOWN_HOLE
	const EVENT_SEAFOAM_ISLANDS_1F_BOULDER_2_DOWN_HOLE
	const EVENT_SEAFOAM_ISLANDS_B1F_BOULDER_1_DOWN_HOLE
	const EVENT_SEAFOAM_ISLANDS_B1F_BOULDER_2_DOWN_HOLE
	const EVENT_SEAFOAM_ISLANDS_B2F_BOULDER_1_DOWN_HOLE
	const EVENT_SEAFOAM_ISLANDS_B2F_BOULDER_2_DOWN_HOLE
	const EVENT_SEAFOAM_ISLANDS_B3F_BOULDER_1_DOWN_HOLE
	const EVENT_SEAFOAM_ISLANDS_B3F_BOULDER_2_DOWN_HOLE
	const EVENT_SEAFOAM_ISLANDS_B2F_HIDDEN_NUGGET
	const EVENT_SEAFOAM_ISLANDS_B3F_HIDDEN_MAX_ELIXER
	const EVENT_SEAFOAM_ISLANDS_B4F_HIDDEN_ULTRA_BALL
; M9 12f: ARTICUNO's hide flag, Yellow's EVENT_BEAT_ARTICUNO.  Set by a win, a
; catch OR a successful run, exactly as Yellow's EndTrainerBattle does; only a
; blackout leaves the bird in place.
	const EVENT_BEAT_ARTICUNO ; (6, 1) SEAFOAM ISLANDS B4F

; M9 12g: three flags Yellow has and Crystal does not.
; EVENT_MANSION_SWITCH_ON and EVENT_LAB_STILL_REVIVING_FOSSIL are Yellow's own
; (vendor/pokeyellow/constants/event_constants.asm); CinnabarIsland's
; MAPCALLBACK_NEWMAP clears both on every arrival, exactly as
; vendor/pokeyellow/scripts/CinnabarIsland.asm:5-6 does.  12l sets the mansion
; switch, 12j the fossil machine.
	const EVENT_MANSION_SWITCH_ON
	const EVENT_LAB_STILL_REVIVING_FOSSIL
; D91/12m stand-in: SECRET_KEY has no item id yet, so the CINNABAR GYM door
; checks this flag instead of the bag.  12m claims an item id and swaps
; CinnabarIslandGymDoor's `checkevent` for `checkitem SECRET_KEY`, after which
; this row is dead (kept, never renumbered -- D49).
	const EVENT_GOT_SECRET_KEY
; M9 12i: the R-and-D room scientist's one-off TM35 METRONOME gift, Yellow's
; EVENT_GOT_TM35 (vendor/pokeyellow/scripts/CinnabarLabMetronomeRoom.asm).
; Crystal has no free TM-gift flag that is not already spoken for, so this is a
; new one appended at the end -- never renumber (D49).
	const EVENT_GOT_TM35_METRONOME
; M9 12j: the CINNABAR LAB fossil revival.
;
; EVENT_GAVE_FOSSIL_TO_LAB is Yellow's own flag
; (vendor/pokeyellow/constants/event_constants.asm); together with
; EVENT_LAB_STILL_REVIVING_FOSSIL (12g, cleared by CINNABAR ISLAND's
; MAPCALLBACK_NEWMAP) it is the whole state machine: GAVE+STILL = "come back
; later", GAVE alone = "your fossil is back to life".
;
; The two _IS_ rows replace Yellow's wFossilItem/wFossilMon pair, which say
; WHICH fossil is in the machine.  Yellow keeps them in unsaved scratch WRAM
; ($d1xx, outside the Gen 1 save range), so saving and resetting mid-revival
; loses the answer; our WRAM1 is full besides (HANDOFF "Budgets"), so the two
; bits live in the saved event array instead:
;     neither set  -> DOME FOSSIL  -> KABUTO
;     _IS_HELIX    -> HELIX FOSSIL -> OMANYTE
;     _IS_AMBER    -> OLD AMBER    -> AERODACTYL
; Both are cleared again when the mon is handed over, so all three fossils can
; be revived in one save, one at a time.
;
; Yellow's third flag, EVENT_LAB_HANDING_OVER_FOSSIL_MON, is deliberately NOT
; ported: it is set at scripts/CinnabarLabFossilRoom.asm:76 and reset at :82
; and is read NOWHERE in the whole game, so porting it would only hand the M9
; audit a dead row.
	const EVENT_GAVE_FOSSIL_TO_LAB
	const EVENT_LAB_FOSSIL_IS_HELIX
	const EVENT_LAB_FOSSIL_IS_AMBER

; M9 12k: the POKeMON MANSION.  Yellow keeps its six trainers in
; EVENT_BEAT_MANSION_{1,2,3,4}_TRAINER_{0,1} and its ten item balls in the
; per-map "missable object" hide list, neither of which GSC has, so every one
; of them needs a flag of its own here.  Appended after 12j's rows, never
; renumbered (D49).  The SECRET KEY ball is the exception: it reuses 12g's
; EVENT_GOT_SECRET_KEY above, which the CINNABAR GYM door already checks.
	const EVENT_BEAT_POKEMON_MANSION_1F_SCIENTIST  ; Yellow EVENT_BEAT_MANSION_1_TRAINER_0
	const EVENT_BEAT_POKEMON_MANSION_2F_BURGLAR    ; Yellow EVENT_BEAT_MANSION_2_TRAINER_0
	const EVENT_BEAT_POKEMON_MANSION_3F_BURGLAR    ; Yellow EVENT_BEAT_MANSION_3_TRAINER_0
	const EVENT_BEAT_POKEMON_MANSION_3F_SCIENTIST  ; Yellow EVENT_BEAT_MANSION_3_TRAINER_1
	const EVENT_BEAT_POKEMON_MANSION_B1F_BURGLAR   ; Yellow EVENT_BEAT_MANSION_4_TRAINER_0
	const EVENT_BEAT_POKEMON_MANSION_B1F_SCIENTIST ; Yellow EVENT_BEAT_MANSION_4_TRAINER_1
	const EVENT_POKEMON_MANSION_1F_ESCAPE_ROPE     ; ball (14,3)
	const EVENT_POKEMON_MANSION_1F_CARBOS          ; ball (18,21)
	const EVENT_POKEMON_MANSION_2F_CALCIUM         ; ball (28,7)
	const EVENT_POKEMON_MANSION_3F_MAX_POTION      ; ball (1,16)
	const EVENT_POKEMON_MANSION_3F_IRON            ; ball (25,5)
	const EVENT_POKEMON_MANSION_B1F_RARE_CANDY     ; ball (10,2)
	const EVENT_POKEMON_MANSION_B1F_FULL_RESTORE   ; ball (1,22)
	const EVENT_POKEMON_MANSION_B1F_TM_BLIZZARD    ; ball (19,25), Yellow TM14
	const EVENT_POKEMON_MANSION_B1F_TM_SOLARBEAM   ; ball (5,4), Yellow TM22
	const EVENT_POKEMON_MANSION_1F_HIDDEN_MOON_STONE   ; (8,16)
	const EVENT_POKEMON_MANSION_3F_HIDDEN_MAX_REVIVE   ; (1,9)
	const EVENT_POKEMON_MANSION_B1F_HIDDEN_RARE_CANDY  ; (1,9)
; Kanto hack (M9 12n): CINNABAR GYM, Yellow's quiz gym.  Yellow keeps the seven
; gym trainers' flags in EVENT_BEAT_CINNABAR_GYM_TRAINER_0..6 (TRAINER_0 is the
; gate-less SUPER NERD at (17,2); TRAINER_g guards gate g) and the six quiz
; gates in EVENT_CINNABAR_GYM_GATE1..6_UNLOCKED, persistent for the rest of the
; game; EVENT_GOT_TM38 is BLAINE's one-shot TM38 FIRE BLAST.  Appended, never
; renumbered (D49).  Yellow's EVENT_CINNABAR_GYM_GATE0_UNLOCKED is set by
; beating TRAINER_0 and read by nothing, so it has no row here.
	const EVENT_BEAT_CINNABAR_GYM_TRAINER_0 ; SUPER NERD (17,2), no gate
	const EVENT_BEAT_CINNABAR_GYM_TRAINER_1 ; BURGLAR (17,8), gate 1
	const EVENT_BEAT_CINNABAR_GYM_TRAINER_2 ; SUPER NERD (11,4), gate 2
	const EVENT_BEAT_CINNABAR_GYM_TRAINER_3 ; BURGLAR (11,8), gate 3
	const EVENT_BEAT_CINNABAR_GYM_TRAINER_4 ; SUPER NERD (11,14), gate 4
	const EVENT_BEAT_CINNABAR_GYM_TRAINER_5 ; BURGLAR (3,14), gate 5
	const EVENT_BEAT_CINNABAR_GYM_TRAINER_6 ; SUPER NERD (3,8), gate 6
	const EVENT_CINNABAR_GYM_GATE1_UNLOCKED ; Yellow block (9,3)
	const EVENT_CINNABAR_GYM_GATE2_UNLOCKED ; Yellow block (6,3)
	const EVENT_CINNABAR_GYM_GATE3_UNLOCKED ; Yellow block (6,6)
	const EVENT_CINNABAR_GYM_GATE4_UNLOCKED ; Yellow block (3,8)
	const EVENT_CINNABAR_GYM_GATE5_UNLOCKED ; Yellow block (2,6)
	const EVENT_CINNABAR_GYM_GATE6_UNLOCKED ; Yellow block (2,3)
	const EVENT_GOT_TM38_FIRE_BLAST
; Kanto hack (M10 13g): VICTORY ROAD's eleven trainers and 3F's two boulder
; flags, appended (D49) -- the 15 renamed rows above ran out.  Yellow's names,
; with the floor spelled 1F/2F/3F.
	const EVENT_VICTORY_ROAD_3F_BOULDER_ON_SWITCH1 ; switch (3,5); cleared by ROUTE 23's NEWMAP
	const EVENT_VICTORY_ROAD_3F_BOULDER_ON_SWITCH2 ; = "a boulder went down the hole (23,15)"; hide flag of 3F BOULDER4 (22,15); cleared by ROUTE 23's NEWMAP
	const EVENT_BEAT_VICTORY_ROAD_1F_TRAINER_0 ; COOLTRAINER F (7,5)
	const EVENT_BEAT_VICTORY_ROAD_1F_TRAINER_1 ; COOLTRAINER M (3,2)
	const EVENT_BEAT_VICTORY_ROAD_2F_TRAINER_0 ; BLACKBELT (12,9)
	const EVENT_BEAT_VICTORY_ROAD_2F_TRAINER_1 ; JUGGLER (21,13)
	const EVENT_BEAT_VICTORY_ROAD_2F_TRAINER_2 ; TAMER (19,8)
	const EVENT_BEAT_VICTORY_ROAD_2F_TRAINER_3 ; POKEMANIAC (4,2)
	const EVENT_BEAT_VICTORY_ROAD_2F_TRAINER_4 ; JUGGLER (26,3)
	const EVENT_BEAT_VICTORY_ROAD_3F_TRAINER_0 ; COOLTRAINER M (28,5)
	const EVENT_BEAT_VICTORY_ROAD_3F_TRAINER_1 ; COOLTRAINER F (7,13)
	const EVENT_BEAT_VICTORY_ROAD_3F_TRAINER_2 ; COOLTRAINER M (6,14)
	const EVENT_BEAT_VICTORY_ROAD_3F_TRAINER_3 ; COOLTRAINER F (13,3)
; Kanto hack (M10 13l): POWER PLANT, appended -- the dead rows ran out after six
; (see the 13l renames above).  Yellow's EVENT_BEAT_POWER_PLANT_VOLTORB_0..7 are
; the eight fake POKe BALLs' hide flags, in Yellow's object order (VOLTORB x6 +
; ELECTRODE x2 share one run, as in Yellow).
	const EVENT_POWER_PLANT_HP_UP ; ball (28,3)
	const EVENT_POWER_PLANT_RARE_CANDY ; ball (34,3)
	const EVENT_BEAT_POWER_PLANT_VOLTORB_0 ; VOLTORB (9,20)
	const EVENT_BEAT_POWER_PLANT_VOLTORB_1 ; VOLTORB (32,18)
	const EVENT_BEAT_POWER_PLANT_VOLTORB_2 ; VOLTORB (21,25)
	const EVENT_BEAT_POWER_PLANT_VOLTORB_3 ; ELECTRODE (25,18)
	const EVENT_BEAT_POWER_PLANT_VOLTORB_4 ; VOLTORB (23,34)
	const EVENT_BEAT_POWER_PLANT_VOLTORB_5 ; VOLTORB (26,28)
	const EVENT_BEAT_POWER_PLANT_VOLTORB_6 ; ELECTRODE (21,14)
	const EVENT_BEAT_POWER_PLANT_VOLTORB_7 ; VOLTORB (37,32)
	const EVENT_OAK_SENT_PLAYER_TO_ELM ; Kanto hack (M11 14a, D135): OAK's post-E4 hand-off in OAK's LAB (HM07 + "go see ELM"); opens VICTORY ROAD GATE's south door
	const EVENT_ICE_PATH_1F_TM_EARTHQUAKE ; Kanto hack (M11 14a, D135): ICE PATH 1F ball (31,7), was Crystal's HM07 (OAK gives HM07 now)
	const EVENT_BEAT_RIVAL_MT_SILVER ; Kanto hack (M11 14c, D142): SILVER's final fight at the foot of MT.SILVER; also his hide flag there
	const EVENT_RADIO_TOWER_4F_JESSIE_JAMES_HIDDEN ; Kanto hack (M11 14g, D149): JESSIE & JAMES at the RADIO TOWER 4F stairs; re-derived by the map's OBJECTS callback (takeover on, EXECUTIVEM_2 fight not won)

; Unused: next 222 events

	const_next 2560
DEF NUM_EVENTS EQU const_value ; a00
