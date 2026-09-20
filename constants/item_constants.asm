; item ids
; indexes for:
; - ItemNames (see data/items/names.asm)
; - ItemDescriptions (see data/items/descriptions.asm)
; - ItemAttributes (see data/items/attributes.asm)
; - ItemEffects (see engine/items/item_effects.asm)
;
; Kanto hack: free ITEM_xx slots are claimed by renaming them in place (see
; docs/PORTING.md 6.3).  Claimed so far: $19 OAKS_PARCEL, $2d DOME_FOSSIL,
; $32 HELIX_FOSSIL, $5a OLD_AMBER, $64 BIKE_VOUCHER.
;
; M3b TM union (docs/M3B-TM-UNION.md) then claimed EVERY remaining free slot
; for TM51-TM85: $78, $87-$89, $8d, $8e, $91, $93-$95, $99-$9b, $a2, $ab, $b0,
; $b3, $be, $c3, $dc plus BRICK_PIECE ($b4), the nine unused Gen 2 mails
; ($b5-$bd) and the four unnamed table rows $fb-$fe.  **There are no free item
; ids left.**  The next feature that needs one must reclaim a dead Gen 2 item;
; the best remaining candidates (unobtainable in Crystal, referenced only by
; the item tables) are, in order:
;   GOLD_LEAF ($4b), NORMAL_BOX ($a7), GORGEOUS_BOX ($a8).
; M4 7a (docs/M4-VERMILION.md 3.10) reclaimed the first of those, SILVER_LEAF
; ($3c), for TM_THUNDERBOLT = TM86 (Lt. Surge's TM24), and dropped the
; THUNDERBOLT move tutor in exchange so NUM_TM_HM_TUTOR stayed 95.
; M6 9c (docs/M6-TOWER.md D11) reclaimed GOLD_LEAF ($4b) for SILPH_SCOPE.
; M6 9o (docs/M6-CELADON.md D29) reclaimed NORMAL_BOX ($a7) for LIFT_KEY.
; M6 9r (docs/M6-CELADON.md 9r findings) reclaimed POLKADOT_BOW ($aa) for
; TM_ICE_BEAM = TM87 (Celadon rooftop FRESH WATER), and dropped the ICE_BEAM
; move tutor in exchange so NUM_TM_HM_TUTOR again stayed 95.  POLKADOT_BOW was
; a byte-identical duplicate of PINK_BOW ($68) -- same item_attribute row, same
; HELD_NORMAL_BOOST -- and is unobtainable in vanilla Crystal (no mart, no
; giveitem/itemball, no held item, no script); PINK_BOW keeps the
; HELD_NORMAL_BOOST / TypeBoostItems row alive.
; Remaining reclaim candidate: GORGEOUS_BOX ($a8) -- the LAST one.  It is
; RESERVED for Silph Co.'s CARD KEY; do not spend it on anything else.
; $ff is reserved (ITEM_FROM_MEM / item-list terminator) and can never be used.
	const_def
	const NO_ITEM      ; 00
	const MASTER_BALL  ; 01
	const ULTRA_BALL   ; 02
	const BRIGHTPOWDER ; 03
	const GREAT_BALL   ; 04
	const POKE_BALL    ; 05
	const TOWN_MAP     ; 06
	const BICYCLE      ; 07
	const MOON_STONE   ; 08
	const ANTIDOTE     ; 09
	const BURN_HEAL    ; 0a
	const ICE_HEAL     ; 0b
	const AWAKENING    ; 0c
	const PARLYZ_HEAL  ; 0d
	const FULL_RESTORE ; 0e
	const MAX_POTION   ; 0f
	const HYPER_POTION ; 10
	const SUPER_POTION ; 11
	const POTION       ; 12
	const ESCAPE_ROPE  ; 13
	const REPEL        ; 14
	const MAX_ELIXER   ; 15
	const FIRE_STONE   ; 16
	const THUNDERSTONE ; 17
	const WATER_STONE  ; 18
	const OAKS_PARCEL  ; 19 (was ITEM_19; Kanto hack)
	const HP_UP        ; 1a
	const PROTEIN      ; 1b
	const IRON         ; 1c
	const CARBOS       ; 1d
	const LUCKY_PUNCH  ; 1e
	const CALCIUM      ; 1f
	const RARE_CANDY   ; 20
	const X_ACCURACY   ; 21
	const LEAF_STONE   ; 22
	const METAL_POWDER ; 23
	const NUGGET       ; 24
	const POKE_DOLL    ; 25
	const FULL_HEAL    ; 26
	const REVIVE       ; 27
	const MAX_REVIVE   ; 28
	const GUARD_SPEC   ; 29
	const SUPER_REPEL  ; 2a
	const MAX_REPEL    ; 2b
	const DIRE_HIT     ; 2c
	const DOME_FOSSIL  ; 2d (was ITEM_2D; Kanto hack)
	const FRESH_WATER  ; 2e
	const SODA_POP     ; 2f
	const LEMONADE     ; 30
	const X_ATTACK     ; 31
	const HELIX_FOSSIL ; 32 (was ITEM_32; Kanto hack)
	const X_DEFEND     ; 33
	const X_SPEED      ; 34
	const X_SPECIAL    ; 35
	const COIN_CASE    ; 36
	const ITEMFINDER   ; 37
	const POKE_FLUTE   ; 38
	const EXP_SHARE    ; 39
	const OLD_ROD      ; 3a
	const GOOD_ROD     ; 3b
	const TM_THUNDERBOLT  ; 3c (was SILVER_LEAF; Kanto hack M4 7a)
	const SUPER_ROD    ; 3d
	const PP_UP        ; 3e
	const ETHER        ; 3f
	const MAX_ETHER    ; 40
	const ELIXER       ; 41
	const RED_SCALE    ; 42
	const SECRETPOTION ; 43
	const S_S_TICKET   ; 44
	const MYSTERY_EGG  ; 45
	const CLEAR_BELL   ; 46
	const SILVER_WING  ; 47
	const MOOMOO_MILK  ; 48
	const QUICK_CLAW   ; 49
	const PSNCUREBERRY ; 4a
	const SILPH_SCOPE  ; 4b (was GOLD_LEAF; Kanto hack M6 9c)
	const SOFT_SAND    ; 4c
	const SHARP_BEAK   ; 4d
	const PRZCUREBERRY ; 4e
	const BURNT_BERRY  ; 4f
	const ICE_BERRY    ; 50
	const POISON_BARB  ; 51
	const KINGS_ROCK   ; 52
	const BITTER_BERRY ; 53
	const MINT_BERRY   ; 54
	const RED_APRICORN ; 55
	const TINYMUSHROOM ; 56
	const BIG_MUSHROOM ; 57
	const SILVERPOWDER ; 58
	const BLU_APRICORN ; 59
	const OLD_AMBER    ; 5a
	const AMULET_COIN  ; 5b
	const YLW_APRICORN ; 5c
	const GRN_APRICORN ; 5d
	const CLEANSE_TAG  ; 5e
	const MYSTIC_WATER ; 5f
	const TWISTEDSPOON ; 60
	const WHT_APRICORN ; 61
	const BLACKBELT_I  ; 62
	const BLK_APRICORN ; 63
	const BIKE_VOUCHER ; 64 (was ITEM_64; Kanto hack)
	const PNK_APRICORN ; 65
	const BLACKGLASSES ; 66
	const SLOWPOKETAIL ; 67
	const PINK_BOW     ; 68
	const STICK        ; 69
	const SMOKE_BALL   ; 6a
	const NEVERMELTICE ; 6b
	const MAGNET       ; 6c
	const MIRACLEBERRY ; 6d
	const PEARL        ; 6e
	const BIG_PEARL    ; 6f
	const EVERSTONE    ; 70
	const SPELL_TAG    ; 71
	const RAGECANDYBAR ; 72
	const GS_BALL      ; 73
	const BLUE_CARD    ; 74
	const MIRACLE_SEED ; 75
	const THICK_CLUB   ; 76
	const FOCUS_BAND   ; 77
	const TM_MEGA_PUNCH   ; 78 (was ITEM_78; Kanto hack TM union)
	const ENERGYPOWDER ; 79
	const ENERGY_ROOT  ; 7a
	const HEAL_POWDER  ; 7b
	const REVIVAL_HERB ; 7c
	const HARD_STONE   ; 7d
	const LUCKY_EGG    ; 7e
	const CARD_KEY     ; 7f
	const MACHINE_PART ; 80
	const EGG_TICKET   ; 81
	const LOST_ITEM    ; 82
	const STARDUST     ; 83
	const STAR_PIECE   ; 84
	const BASEMENT_KEY ; 85
	const PASS         ; 86
	const TM_RAZOR_WIND   ; 87 (was ITEM_87; Kanto hack TM union)
	const TM_SWORDS_DANCE ; 88 (was ITEM_88; Kanto hack TM union)
	const TM_WHIRLWIND    ; 89 (was ITEM_89; Kanto hack TM union)
	const CHARCOAL     ; 8a
	const BERRY_JUICE  ; 8b
	const SCOPE_LENS   ; 8c
	const TM_MEGA_KICK    ; 8d (was ITEM_8D; Kanto hack TM union)
	const TM_HORN_DRILL   ; 8e (was ITEM_8E; Kanto hack TM union)
	const METAL_COAT   ; 8f
	const DRAGON_FANG  ; 90
	const TM_BODY_SLAM    ; 91 (was ITEM_91; Kanto hack TM union)
	const LEFTOVERS    ; 92
	const TM_TAKE_DOWN    ; 93 (was ITEM_93; Kanto hack TM union)
	const TM_DOUBLE_EDGE  ; 94 (was ITEM_94; Kanto hack TM union)
	const TM_BUBBLEBEAM   ; 95 (was ITEM_95; Kanto hack TM union)
	const MYSTERYBERRY ; 96
	const DRAGON_SCALE ; 97
	const BERSERK_GENE ; 98
	const TM_WATER_GUN    ; 99 (was ITEM_99; Kanto hack TM union)
	const TM_PAY_DAY      ; 9a (was ITEM_9A; Kanto hack TM union)
	const TM_SUBMISSION   ; 9b (was ITEM_9B; Kanto hack TM union)
	const SACRED_ASH   ; 9c
	const HEAVY_BALL   ; 9d
	const FLOWER_MAIL  ; 9e
	const LEVEL_BALL   ; 9f
	const LURE_BALL    ; a0
	const FAST_BALL    ; a1
	const TM_COUNTER      ; a2 (was ITEM_A2; Kanto hack TM union)
	const LIGHT_BALL   ; a3
	const FRIEND_BALL  ; a4
	const MOON_BALL    ; a5
	const LOVE_BALL    ; a6
	const LIFT_KEY     ; a7 (was NORMAL_BOX; Kanto hack M6 9o)
	const GORGEOUS_BOX ; a8
	const SUN_STONE    ; a9
	const TM_ICE_BEAM  ; aa (was POLKADOT_BOW; Kanto hack M6 9r)
	const TM_SEISMIC_TOSS ; ab (was ITEM_AB; Kanto hack TM union)
	const UP_GRADE     ; ac
	const BERRY        ; ad
	const GOLD_BERRY   ; ae
	const SQUIRTBOTTLE ; af
	const TM_RAGE         ; b0 (was ITEM_B0; Kanto hack TM union)
	const PARK_BALL    ; b1
	const RAINBOW_WING ; b2
	const TM_MEGA_DRAIN   ; b3 (was ITEM_B3; Kanto hack TM union)
	const TM_DRAGON_RAGE  ; b4 (was BRICK_PIECE; Kanto hack TM union)
	const TM_FISSURE      ; b5 (was SURF_MAIL; Kanto hack TM union)
	const TM_TELEPORT     ; b6 (was LITEBLUEMAIL; Kanto hack TM union)
	const TM_MIMIC        ; b7 (was PORTRAITMAIL; Kanto hack TM union)
	const TM_REFLECT      ; b8 (was LOVELY_MAIL; Kanto hack TM union)
	const TM_BIDE         ; b9 (was EON_MAIL; Kanto hack TM union)
	const TM_METRONOME    ; ba (was MORPH_MAIL; Kanto hack TM union)
	const TM_SELFDESTRUCT ; bb (was BLUESKY_MAIL; Kanto hack TM union)
	const TM_EGG_BOMB     ; bc (was MUSIC_MAIL; Kanto hack TM union)
	const TM_SKULL_BASH   ; bd (was MIRAGE_MAIL; Kanto hack TM union)
	const TM_SOFTBOILED   ; be (was ITEM_BE; Kanto hack TM union)
DEF NUM_ITEMS EQU const_value - 1

DEF __tmhm_value__ = 1

MACRO add_tmnum
	DEF \1_TMNUM EQU __tmhm_value__
	DEF __tmhm_value__ += 1
ENDM

MACRO add_tm
; Defines four constants:
; - TM_\1: the item id, starting at $bf
; - \1_TMNUM: the learnable TM/HM flag, starting at 1
; - TM##_MOVE: alias for the move id, equal to the value of \1
; - TM##_ITEM: alias for the item id (see data/items/tmhm_items.asm)
	const TM_\1
	DEF TM{02d:__tmhm_value__}_MOVE = \1
	DEF TM{02d:__tmhm_value__}_ITEM = TM_\1
	add_tmnum \1
ENDM

MACRO add_tm_id
; Kanto hack (M3b TM union): like add_tm, but for a TM whose item id is a
; reclaimed slot somewhere else in the item list instead of the next const.
; TM_\1 must already be defined by a renamed const (or a DEF) above.
; Emits no const, so it does not disturb the item id sequence.
; - \1_TMNUM: the learnable TM/HM flag
; - TM##_MOVE: alias for the move id, equal to the value of \1
; - TM##_ITEM: alias for the item id (see data/items/tmhm_items.asm)
	assert DEF(TM_\1), "TM_\1 has no item id"
	DEF TM{02d:__tmhm_value__}_MOVE = \1
	DEF TM{02d:__tmhm_value__}_ITEM = TM_\1
	add_tmnum \1
ENDM

; see data/moves/tmhm_moves.asm for moves
DEF TM01 EQU const_value
	add_tm DYNAMICPUNCH ; bf
	add_tm HEADBUTT     ; c0
	add_tm CURSE        ; c1
	add_tm ROLLOUT      ; c2
	const TM_SKY_ATTACK   ; c3 (was ITEM_C3; Kanto hack TM union)
	add_tm ROAR         ; c4
	add_tm TOXIC        ; c5
	add_tm ZAP_CANNON   ; c6
	add_tm ROCK_SMASH   ; c7
	add_tm PSYCH_UP     ; c8
	add_tm HIDDEN_POWER ; c9
	add_tm SUNNY_DAY    ; ca
	add_tm SWEET_SCENT  ; cb
	add_tm SNORE        ; cc
	add_tm BLIZZARD     ; cd
	add_tm HYPER_BEAM   ; ce
	add_tm ICY_WIND     ; cf
	add_tm PROTECT      ; d0
	add_tm RAIN_DANCE   ; d1
	add_tm GIGA_DRAIN   ; d2
	add_tm ENDURE       ; d3
	add_tm FRUSTRATION  ; d4
	add_tm SOLARBEAM    ; d5
	add_tm IRON_TAIL    ; d6
	add_tm DRAGONBREATH ; d7
	add_tm THUNDER      ; d8
	add_tm EARTHQUAKE   ; d9
	add_tm RETURN       ; da
	add_tm DIG          ; db
	const TM_THUNDER_WAVE ; dc (was ITEM_DC; Kanto hack TM union)
	add_tm PSYCHIC_M    ; dd
	add_tm SHADOW_BALL  ; de
	add_tm MUD_SLAP     ; df
	add_tm DOUBLE_TEAM  ; e0
	add_tm ICE_PUNCH    ; e1
	add_tm SWAGGER      ; e2
	add_tm SLEEP_TALK   ; e3
	add_tm SLUDGE_BOMB  ; e4
	add_tm SANDSTORM    ; e5
	add_tm FIRE_BLAST   ; e6
	add_tm SWIFT        ; e7
	add_tm DEFENSE_CURL ; e8
	add_tm THUNDERPUNCH ; e9
	add_tm DREAM_EATER  ; ea
	add_tm DETECT       ; eb
	add_tm REST         ; ec
	add_tm ATTRACT      ; ed
	add_tm THIEF        ; ee
	add_tm STEEL_WING   ; ef
	add_tm FIRE_PUNCH   ; f0
	add_tm FURY_CUTTER  ; f1
	add_tm NIGHTMARE    ; f2

; Kanto hack (M3b TM union, docs/M3B-TM-UNION.md): TM51-TM85 are the Gen 1 TM
; moves that Crystal has no TM item for, numbered in Yellow's TM order.  Their
; item ids are reclaimed slots scattered through the list above, so the TM item
; ids are NOT contiguous: GetTMHMNumber / GetNumberedTMHM are table-driven
; against TMHMItems (data/items/tmhm_items.asm).  These lines must stay between
; the last add_tm and NUM_TMS so the HM and tutor flag numbers follow them.
;
; $fa-$fe sit past the end of the const sequence (the item tables have rows for
; them but no names), so their item ids are DEFed here instead of renamed.
DEF TM_PSYWAVE     EQU $fa ; was ITEM_FA
DEF TM_EXPLOSION   EQU $fb
DEF TM_ROCK_SLIDE  EQU $fc
DEF TM_TRI_ATTACK  EQU $fd
DEF TM_SUBSTITUTE  EQU $fe

	add_tm_id MEGA_PUNCH   ; 78 = TM51
	add_tm_id RAZOR_WIND   ; 87 = TM52
	add_tm_id SWORDS_DANCE ; 88 = TM53
	add_tm_id WHIRLWIND    ; 89 = TM54
	add_tm_id MEGA_KICK    ; 8d = TM55
	add_tm_id HORN_DRILL   ; 8e = TM56
	add_tm_id BODY_SLAM    ; 91 = TM57
	add_tm_id TAKE_DOWN    ; 93 = TM58
	add_tm_id DOUBLE_EDGE  ; 94 = TM59
	add_tm_id BUBBLEBEAM   ; 95 = TM60
	add_tm_id WATER_GUN    ; 99 = TM61
	add_tm_id PAY_DAY      ; 9a = TM62
	add_tm_id SUBMISSION   ; 9b = TM63
	add_tm_id COUNTER      ; a2 = TM64
	add_tm_id SEISMIC_TOSS ; ab = TM65
	add_tm_id RAGE         ; b0 = TM66
	add_tm_id MEGA_DRAIN   ; b3 = TM67
	add_tm_id DRAGON_RAGE  ; b4 = TM68
	add_tm_id FISSURE      ; b5 = TM69
	add_tm_id TELEPORT     ; b6 = TM70
	add_tm_id MIMIC        ; b7 = TM71
	add_tm_id REFLECT      ; b8 = TM72
	add_tm_id BIDE         ; b9 = TM73
	add_tm_id METRONOME    ; ba = TM74
	add_tm_id SELFDESTRUCT ; bb = TM75
	add_tm_id EGG_BOMB     ; bc = TM76
	add_tm_id SKULL_BASH   ; bd = TM77
	add_tm_id SOFTBOILED   ; be = TM78
	add_tm_id SKY_ATTACK   ; c3 = TM79
	add_tm_id THUNDER_WAVE ; dc = TM80
	add_tm_id PSYWAVE      ; fa = TM81
	add_tm_id EXPLOSION    ; fb = TM82
	add_tm_id ROCK_SLIDE   ; fc = TM83
	add_tm_id TRI_ATTACK   ; fd = TM84
	add_tm_id SUBSTITUTE   ; fe = TM85
; M4 7a (docs/M4-VERMILION.md 3.10): Lt. Surge's TM24.  Was Crystal's MT02 move
; tutor; promoting it here and deleting the tutor below keeps NUM_TM_HM_TUTOR at
; 95, so the tmhm bitfield stays 12 bytes and no base stats had to be regenerated.
	add_tm_id THUNDERBOLT  ; 3c = TM86
; M6 9r (docs/M6-CELADON.md): the Celadon rooftop girl's FRESH WATER reward,
; Yellow's TM13.  Was Crystal's other move tutor (MT02 ICE_BEAM); same trade as
; 7a -- promoting it here and deleting the tutor below keeps NUM_TM_HM_TUTOR at
; 95, so the tmhm bitfield stays 12 bytes and no base stats had to be regrown.
	add_tm_id ICE_BEAM     ; aa = TM87
DEF NUM_TMS EQU __tmhm_value__ - 1

MACRO add_hm
; Defines four constants:
; - HM_\1: the item id, starting at $f3
; - \1_TMNUM: the learnable TM/HM flag, starting at NUM_TMS + 1 (86)
; - HM##_MOVE: alias for the move id, equal to the value of \1
; - HM##_ITEM: alias for the item id (see data/items/tmhm_items.asm)
	const HM_\1
	DEF HM_VALUE = __tmhm_value__ - NUM_TMS
	DEF HM{02d:HM_VALUE}_MOVE = \1
	DEF HM{02d:HM_VALUE}_ITEM = HM_\1
	add_tmnum \1
ENDM

DEF HM01 EQU const_value
	add_hm CUT          ; f3
	add_hm FLY          ; f4
	add_hm SURF         ; f5
	add_hm STRENGTH     ; f6
	add_hm FLASH        ; f7
	add_hm WHIRLPOOL    ; f8
	add_hm WATERFALL    ; f9
DEF NUM_HMS EQU __tmhm_value__ - NUM_TMS - 1

MACRO add_mt
; Defines two constants:
; - \1_TMNUM: the learnable TM/HM flag, starting at NUM_TMS + NUM_HMS + 1 (93)
; - MT##_MOVE: alias for the move id, equal to the value of \1
	DEF MT_VALUE = __tmhm_value__ - NUM_TMS - NUM_HMS
	DEF MT{02d:MT_VALUE}_MOVE = \1
	add_tmnum \1
ENDM

DEF MT01 EQU const_value
	add_mt FLAMETHROWER
; M4 7a: THUNDERBOLT is TM86 now (see the add_tm_id block), not a tutor move.
; M6 9r: ICE_BEAM is TM87 now, likewise.  FLAMETHROWER is the only tutor left.
DEF NUM_TUTORS = __tmhm_value__ - NUM_TMS - NUM_HMS - 1

DEF NUM_TM_HM_TUTOR EQU NUM_TMS + NUM_HMS + NUM_TUTORS

; $fa is TM_PSYWAVE (TM81) and $fb-$fe are TM82-TM85; see the add_tm_id block.

DEF USE_SCRIPT_VAR EQU $00
DEF ITEM_FROM_MEM  EQU $ff

; leftovers from red
DEF SAFARI_BALL    EQU $08 ; MOON_STONE
DEF MOON_STONE_RED EQU $0a ; BURN_HEAL
DEF FULL_HEAL_RED  EQU $34 ; X_SPEED
