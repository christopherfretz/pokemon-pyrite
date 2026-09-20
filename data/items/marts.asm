Marts:
; entries correspond to MART_* constants (see constants/mart_constants.asm)
	table_width 2
	dw MartCherrygrove
	dw MartCherrygroveDex
	dw MartViolet
	dw MartAzalea
	dw MartCianwood
	dw MartGoldenrod2F1
	dw MartGoldenrod2F2
	dw MartGoldenrod3F
	dw MartGoldenrod4F
	dw MartGoldenrod5F1
	dw MartGoldenrod5F2
	dw MartGoldenrod5F3
	dw MartGoldenrod5F4
	dw MartOlivine
	dw MartEcruteak
	dw MartMahogany1
	dw MartMahogany2
	dw MartBlackthorn
	dw MartViridian
	dw MartPewter
	dw MartCerulean
	dw MartLavender
	dw MartVermilion
	dw MartCeladon2F1
	dw MartCeladon2F2
	dw MartCeladon4F
	dw MartCeladon5F1
	dw MartCeladon5F2
	dw MartFuchsia
	dw MartSaffron
	dw MartMtMoon
	dw MartIndigoPlateau
	dw MartUnderground
	assert_table_length NUM_MARTS

MartCherrygrove:
	db 4 ; # items
	db POTION
	db ANTIDOTE
	db PARLYZ_HEAL
	db AWAKENING
	db -1 ; end

MartCherrygroveDex:
	db 5 ; # items
	db POKE_BALL
	db POTION
	db ANTIDOTE
	db PARLYZ_HEAL
	db AWAKENING
	db -1 ; end

MartViolet:
	db 10 ; # items
	db POKE_BALL
	db POTION
	db ESCAPE_ROPE
	db ANTIDOTE
	db PARLYZ_HEAL
	db AWAKENING
	db X_DEFEND
	db X_ATTACK
	db X_SPEED
	db FLOWER_MAIL
	db -1 ; end

MartAzalea:
	db 9 ; # items
	db CHARCOAL
	db POKE_BALL
	db POTION
	db SUPER_POTION
	db ESCAPE_ROPE
	db REPEL
	db ANTIDOTE
	db PARLYZ_HEAL
	db FLOWER_MAIL
	db -1 ; end

MartCianwood:
	db 5 ; # items
	db POTION
	db SUPER_POTION
	db HYPER_POTION
	db FULL_HEAL
	db REVIVE
	db -1 ; end

MartGoldenrod2F1:
	db 7 ; # items
	db POTION
	db SUPER_POTION
	db ANTIDOTE
	db PARLYZ_HEAL
	db AWAKENING
	db BURN_HEAL
	db ICE_HEAL
	db -1 ; end

MartGoldenrod2F2:
	db 8 ; # items
	db POKE_BALL
	db GREAT_BALL
	db ESCAPE_ROPE
	db REPEL
	db REVIVE
	db FULL_HEAL
	db POKE_DOLL
	db FLOWER_MAIL
	db -1 ; end

MartGoldenrod3F:
	db 7 ; # items
	db X_SPEED
	db X_SPECIAL
	db X_DEFEND
	db X_ATTACK
	db DIRE_HIT
	db GUARD_SPEC
	db X_ACCURACY
	db -1 ; end

MartGoldenrod4F:
	db 5 ; # items
	db PROTEIN
	db IRON
	db CARBOS
	db CALCIUM
	db HP_UP
	db -1 ; end

MartGoldenrod5F1:
	db 3 ; # items
	db TM_THUNDERPUNCH
	db TM_FIRE_PUNCH
	db TM_ICE_PUNCH
	db -1 ; end

MartGoldenrod5F2:
	db 4 ; # items
	db TM_THUNDERPUNCH
	db TM_FIRE_PUNCH
	db TM_ICE_PUNCH
	db TM_HEADBUTT
	db -1 ; end

MartGoldenrod5F3:
	db 4 ; # items
	db TM_THUNDERPUNCH
	db TM_FIRE_PUNCH
	db TM_ICE_PUNCH
	db TM_ROCK_SMASH
	db -1 ; end

MartGoldenrod5F4:
	db 5 ; # items
	db TM_THUNDERPUNCH
	db TM_FIRE_PUNCH
	db TM_ICE_PUNCH
	db TM_HEADBUTT
	db TM_ROCK_SMASH
	db -1 ; end

MartOlivine:
	db 9 ; # items
	db GREAT_BALL
	db SUPER_POTION
	db HYPER_POTION
	db ANTIDOTE
	db PARLYZ_HEAL
	db AWAKENING
	db ICE_HEAL
	db SUPER_REPEL
	db FLOWER_MAIL ; Kanto hack: was SURF_MAIL
	db -1 ; end

MartEcruteak:
	db 10 ; # items
	db POKE_BALL
	db GREAT_BALL
	db POTION
	db SUPER_POTION
	db ANTIDOTE
	db PARLYZ_HEAL
	db AWAKENING
	db BURN_HEAL
	db ICE_HEAL
	db REVIVE
	db -1 ; end

MartMahogany1:
	db 4 ; # items
	db TINYMUSHROOM
	db SLOWPOKETAIL
	db POKE_BALL
	db POTION
	db -1 ; end

MartMahogany2:
	db 9 ; # items
	db RAGECANDYBAR
	db GREAT_BALL
	db SUPER_POTION
	db HYPER_POTION
	db ANTIDOTE
	db PARLYZ_HEAL
	db SUPER_REPEL
	db REVIVE
	db FLOWER_MAIL
	db -1 ; end

MartBlackthorn:
	db 9 ; # items
	db GREAT_BALL
	db ULTRA_BALL
	db HYPER_POTION
	db MAX_POTION
	db FULL_HEAL
	db REVIVE
	db MAX_REPEL
	db X_DEFEND
	db X_ATTACK
	db -1 ; end

MartViridian: ; Yellow's Kanto-act stock (docs/M2-PARCEL.md); the Johto act wants the late list back
	db 5 ; # items
	db POKE_BALL
	db POTION
	db ANTIDOTE
	db PARLYZ_HEAL
	db BURN_HEAL
	db -1 ; end

; Kanto hack: Yellow's PEWTER MART stock (docs/M2-PEWTER-CITY.md).
MartPewter:
	db 7 ; # items
	db POKE_BALL
	db POTION
	db ESCAPE_ROPE
	db ANTIDOTE
	db BURN_HEAL
	db AWAKENING
	db PARLYZ_HEAL
	db -1 ; end

; Kanto hack: Yellow's CERULEAN MART stock (docs/M3-CERULEAN.md 6b).
MartCerulean:
	db 8 ; # items
	db POKE_BALL
	db POTION
	db ESCAPE_ROPE
	db REPEL
	db ANTIDOTE
	db BURN_HEAL
	db AWAKENING
	db PARLYZ_HEAL
	db -1 ; end

MartLavender:
; Kanto hack (M5 8h): Yellow's LAVENDER_MART stock
; (vendor/pokeyellow/data/items/marts.asm:20), replacing Crystal's eight-item
; Johto list under the same MART_LAVENDER id.
	db 9 ; # items
	db GREAT_BALL
	db SUPER_POTION
	db REVIVE
	db ESCAPE_ROPE
	db SUPER_REPEL
	db ANTIDOTE
	db BURN_HEAL
	db ICE_HEAL
	db PARLYZ_HEAL
	db -1 ; end

MartVermilion:
; Kanto hack (7e): Yellow's VERMILION_MART stock
; (vendor/pokeyellow/data/items/marts.asm VermilionMartClerkText).
	db 6 ; # items
	db POKE_BALL
	db SUPER_POTION
	db ICE_HEAL
	db AWAKENING
	db PARLYZ_HEAL
	db REPEL
	db -1 ; end

; Kanto hack (M6 9r, docs/M6-CELADON.md): Yellow's five CELADON DEPT. STORE
; rosters, verbatim from vendor/pokeyellow/data/items/marts.asm (CeladonMart2F
; Clerk1/Clerk2, CeladonMart4FClerk, CeladonMart5F Clerk1/Clerk2), in Yellow's
; order.  Yellow's 3F is the TV GAME SHOP and sells nothing, so MartCeladon3F
; and MART_CELADON_3F are gone.  Note Yellow's 5F order: Clerk1 is the X-item
; counter and Clerk2 the vitamin counter -- the opposite of Crystal's Goldenrod.
MartCeladon2F1:
	db 9 ; # items
	db GREAT_BALL
	db SUPER_POTION
	db REVIVE
	db SUPER_REPEL
	db ANTIDOTE
	db BURN_HEAL
	db ICE_HEAL
	db AWAKENING
	db PARLYZ_HEAL
	db -1 ; end

MartCeladon2F2:
; Yellow's TM numbers, mapped through docs/TM-LEDGER.md: TM32 DOUBLE TEAM (ours
; TM32), TM33 REFLECT (TM72), TM02 RAZOR WIND (TM52), TM07 HORN DRILL (TM56),
; TM37 EGG BOMB (TM76), TM01 MEGA PUNCH (TM51), TM05 MEGA KICK (TM55),
; TM09 TAKE DOWN (TM58), TM17 SUBMISSION (TM63).
	db 9 ; # items
	db TM_DOUBLE_TEAM
	db TM_REFLECT
	db TM_RAZOR_WIND
	db TM_HORN_DRILL
	db TM_EGG_BOMB
	db TM_MEGA_PUNCH
	db TM_MEGA_KICK
	db TM_TAKE_DOWN
	db TM_SUBMISSION
	db -1 ; end

MartCeladon4F:
	db 5 ; # items
	db POKE_DOLL
	db FIRE_STONE
	db THUNDERSTONE
	db WATER_STONE
	db LEAF_STONE
	db -1 ; end

MartCeladon5F1:
	db 7 ; # items
	db X_ACCURACY
	db GUARD_SPEC
	db DIRE_HIT
	db X_ATTACK
	db X_DEFEND
	db X_SPEED
	db X_SPECIAL
	db -1 ; end

MartCeladon5F2:
	db 5 ; # items
	db HP_UP
	db PROTEIN
	db IRON
	db CARBOS
	db CALCIUM
	db -1 ; end

MartFuchsia:
	db 7 ; # items
	db GREAT_BALL
	db ULTRA_BALL
	db SUPER_POTION
	db HYPER_POTION
	db FULL_HEAL
	db MAX_REPEL
	db FLOWER_MAIL
	db -1 ; end

MartSaffron:
	db 8 ; # items
	db GREAT_BALL
	db ULTRA_BALL
	db HYPER_POTION
	db MAX_POTION
	db FULL_HEAL
	db X_ATTACK
	db X_DEFEND
	db FLOWER_MAIL
	db -1 ; end

MartMtMoon:
; Kanto hack (N1a): FLOWER_MAIL dropped -- Mail is a Gen-2 item class and this
; table sits one `pokemart` away from a Kanto counter (Yellow's Mt. Moon
; Pokecenter has no clerk, so nothing references MART_MT_MOON today).
	db 5 ; # items
	db POKE_DOLL
	db FRESH_WATER
	db SODA_POP
	db LEMONADE
	db REPEL
	db -1 ; end

MartIndigoPlateau:
	db 7 ; # items
	db ULTRA_BALL
	db MAX_REPEL
	db HYPER_POTION
	db MAX_POTION
	db FULL_RESTORE
	db REVIVE
	db FULL_HEAL
	db -1 ; end

MartUnderground:
	db 4 ; # items
	db ENERGYPOWDER
	db ENERGY_ROOT
	db HEAL_POWDER
	db REVIVAL_HERB
	db -1 ; end

DefaultMart:
	db 2 ; # items
	db POKE_BALL
	db POTION
	db -1 ; end
