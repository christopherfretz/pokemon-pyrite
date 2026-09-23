INCLUDE "data/trainers/party_pointers.asm"

Trainers:
; Trainer data structure:
; - db "NAME@", TRAINERTYPE_* constant
; - 1 to 6 Pokémon:
;    * for TRAINERTYPE_NORMAL:     db level, species
;    * for TRAINERTYPE_MOVES:      db level, species, 4 moves
;    * for TRAINERTYPE_ITEM:       db level, species, item
;    * for TRAINERTYPE_ITEM_MOVES: db level, species, item, 4 moves
; - db -1 ; end

FalknerGroup:
	; FALKNER (1)
	db "FALKNER@", TRAINERTYPE_MOVES
	db  7, PIDGEY,     TACKLE, MUD_SLAP, NO_MOVE, NO_MOVE
	db  9, PIDGEOTTO,  TACKLE, MUD_SLAP, GUST, NO_MOVE
	db -1 ; end

WhitneyGroup:
	; WHITNEY (1)
	db "WHITNEY@", TRAINERTYPE_MOVES
	db 18, CLEFAIRY,   DOUBLESLAP, MIMIC, ENCORE, METRONOME
	db 20, MILTANK,    ROLLOUT, ATTRACT, STOMP, MILK_DRINK
	db -1 ; end

BugsyGroup:
	; BUGSY (1)
	db "BUGSY@", TRAINERTYPE_MOVES
	db 14, METAPOD,    TACKLE, STRING_SHOT, HARDEN, NO_MOVE
	db 14, KAKUNA,     POISON_STING, STRING_SHOT, HARDEN, NO_MOVE
	db 16, SCYTHER,    QUICK_ATTACK, LEER, FURY_CUTTER, NO_MOVE
	db -1 ; end

MortyGroup:
	; MORTY (1)
	db "MORTY@", TRAINERTYPE_MOVES
	db 21, GASTLY,     LICK, SPITE, MEAN_LOOK, CURSE
	db 21, HAUNTER,    HYPNOSIS, MIMIC, CURSE, NIGHT_SHADE
	db 25, GENGAR,     HYPNOSIS, SHADOW_BALL, MEAN_LOOK, DREAM_EATER
	db 23, HAUNTER,    SPITE, MEAN_LOOK, MIMIC, NIGHT_SHADE
	db -1 ; end

PryceGroup:
	; PRYCE (1)
	db "PRYCE@", TRAINERTYPE_MOVES
	db 27, SEEL,       HEADBUTT, ICY_WIND, AURORA_BEAM, REST
	db 29, DEWGONG,    HEADBUTT, ICY_WIND, AURORA_BEAM, REST
	db 31, PILOSWINE,  ICY_WIND, FURY_ATTACK, MIST, BLIZZARD
	db -1 ; end

JasmineGroup:
	; JASMINE (1)
	db "JASMINE@", TRAINERTYPE_MOVES
	db 30, MAGNEMITE,  THUNDERBOLT, SUPERSONIC, SONICBOOM, THUNDER_WAVE
	db 30, MAGNEMITE,  THUNDERBOLT, SUPERSONIC, SONICBOOM, THUNDER_WAVE
	db 35, STEELIX,    SCREECH, SUNNY_DAY, ROCK_THROW, IRON_TAIL
	db -1 ; end

ChuckGroup:
	; CHUCK (1)
	db "CHUCK@", TRAINERTYPE_MOVES
	db 27, PRIMEAPE,   LEER, RAGE, KARATE_CHOP, FURY_SWIPES
	db 30, POLIWRATH,  HYPNOSIS, MIND_READER, SURF, DYNAMICPUNCH
	db -1 ; end

ClairGroup:
	; CLAIR (1)
	db "CLAIR@", TRAINERTYPE_MOVES
	db 37, DRAGONAIR,  THUNDER_WAVE, SURF, SLAM, DRAGONBREATH
	db 37, DRAGONAIR,  THUNDER_WAVE, THUNDERBOLT, SLAM, DRAGONBREATH
	db 37, DRAGONAIR,  THUNDER_WAVE, ICE_BEAM, SLAM, DRAGONBREATH
	db 40, KINGDRA,    SMOKESCREEN, SURF, HYPER_BEAM, DRAGONBREATH
	db -1 ; end

Rival1Group:
	; RIVAL1 (1)
	db "?@", TRAINERTYPE_NORMAL
	db  5, CHIKORITA
	db -1 ; end

	; RIVAL1 (2)
	db "?@", TRAINERTYPE_NORMAL
	db  5, CYNDAQUIL
	db -1 ; end

	; RIVAL1 (3)
	db "?@", TRAINERTYPE_NORMAL
	db  5, TOTODILE
	db -1 ; end

	; RIVAL1 (4)
	db "?@", TRAINERTYPE_NORMAL
	db 12, GASTLY
	db 14, ZUBAT
	db 16, BAYLEEF
	db -1 ; end

	; RIVAL1 (5)
	db "?@", TRAINERTYPE_NORMAL
	db 12, GASTLY
	db 14, ZUBAT
	db 16, QUILAVA
	db -1 ; end

	; RIVAL1 (6)
	db "?@", TRAINERTYPE_NORMAL
	db 12, GASTLY
	db 14, ZUBAT
	db 16, CROCONAW
	db -1 ; end

	; RIVAL1 (7)
	db "?@", TRAINERTYPE_MOVES
	db 20, HAUNTER,    LICK, SPITE, MEAN_LOOK, CURSE
	db 18, MAGNEMITE,  TACKLE, THUNDERSHOCK, SUPERSONIC, SONICBOOM
	db 20, ZUBAT,      LEECH_LIFE, SUPERSONIC, BITE, CONFUSE_RAY
	db 22, BAYLEEF,    GROWL, REFLECT, RAZOR_LEAF, POISONPOWDER
	db -1 ; end

	; RIVAL1 (8)
	db "?@", TRAINERTYPE_MOVES
	db 20, HAUNTER,    LICK, SPITE, MEAN_LOOK, CURSE
	db 18, MAGNEMITE,  TACKLE, THUNDERSHOCK, SUPERSONIC, SONICBOOM
	db 20, ZUBAT,      LEECH_LIFE, SUPERSONIC, BITE, CONFUSE_RAY
	db 22, QUILAVA,    LEER, SMOKESCREEN, EMBER, QUICK_ATTACK
	db -1 ; end

	; RIVAL1 (9)
	db "?@", TRAINERTYPE_MOVES
	db 20, HAUNTER,    LICK, SPITE, MEAN_LOOK, CURSE
	db 18, MAGNEMITE,  TACKLE, THUNDERSHOCK, SUPERSONIC, SONICBOOM
	db 20, ZUBAT,      LEECH_LIFE, SUPERSONIC, BITE, CONFUSE_RAY
	db 22, CROCONAW,   LEER, RAGE, WATER_GUN, BITE
	db -1 ; end

	; RIVAL1 (10)
	db "?@", TRAINERTYPE_MOVES
	db 30, GOLBAT,     LEECH_LIFE, BITE, CONFUSE_RAY, WING_ATTACK
	db 28, MAGNEMITE,  TACKLE, THUNDERSHOCK, SONICBOOM, THUNDER_WAVE
	db 30, HAUNTER,    LICK, MEAN_LOOK, CURSE, SHADOW_BALL
	db 32, SNEASEL,    LEER, QUICK_ATTACK, SCREECH, FAINT_ATTACK
	db 32, MEGANIUM,   REFLECT, RAZOR_LEAF, POISONPOWDER, BODY_SLAM
	db -1 ; end

	; RIVAL1 (11)
	db "?@", TRAINERTYPE_MOVES
	db 30, GOLBAT,     LEECH_LIFE, BITE, CONFUSE_RAY, WING_ATTACK
	db 28, MAGNEMITE,  TACKLE, THUNDERSHOCK, SONICBOOM, THUNDER_WAVE
	db 30, HAUNTER,    LICK, MEAN_LOOK, CURSE, SHADOW_BALL
	db 32, SNEASEL,    LEER, QUICK_ATTACK, SCREECH, FAINT_ATTACK
	db 32, QUILAVA,    SMOKESCREEN, EMBER, QUICK_ATTACK, FLAME_WHEEL
	db -1 ; end

	; RIVAL1 (12)
	db "?@", TRAINERTYPE_MOVES
	db 30, GOLBAT,     LEECH_LIFE, BITE, CONFUSE_RAY, WING_ATTACK
	db 28, MAGNEMITE,  TACKLE, THUNDERSHOCK, SONICBOOM, THUNDER_WAVE
	db 30, HAUNTER,    LICK, MEAN_LOOK, CURSE, SHADOW_BALL
	db 32, SNEASEL,    LEER, QUICK_ATTACK, SCREECH, FAINT_ATTACK
	db 32, FERALIGATR, RAGE, WATER_GUN, BITE, SCARY_FACE
	db -1 ; end

	; RIVAL1 (13)
	db "?@", TRAINERTYPE_MOVES
	db 34, SNEASEL,    QUICK_ATTACK, SCREECH, FAINT_ATTACK, FURY_CUTTER
	db 36, GOLBAT,     LEECH_LIFE, BITE, CONFUSE_RAY, WING_ATTACK
	db 35, MAGNETON,   THUNDERSHOCK, SONICBOOM, THUNDER_WAVE, SWIFT
	db 35, HAUNTER,    MEAN_LOOK, CURSE, SHADOW_BALL, CONFUSE_RAY
	db 35, KADABRA,    DISABLE, PSYBEAM, RECOVER, FUTURE_SIGHT
	db 38, MEGANIUM,   REFLECT, RAZOR_LEAF, POISONPOWDER, BODY_SLAM
	db -1 ; end

	; RIVAL1 (14)
	db "?@", TRAINERTYPE_MOVES
	db 34, SNEASEL,    QUICK_ATTACK, SCREECH, FAINT_ATTACK, FURY_CUTTER
	db 36, GOLBAT,     LEECH_LIFE, BITE, CONFUSE_RAY, WING_ATTACK
	db 35, MAGNETON,   THUNDERSHOCK, SONICBOOM, THUNDER_WAVE, SWIFT
	db 35, HAUNTER,    MEAN_LOOK, CURSE, SHADOW_BALL, CONFUSE_RAY
	db 35, KADABRA,    DISABLE, PSYBEAM, RECOVER, FUTURE_SIGHT
	db 38, TYPHLOSION, SMOKESCREEN, EMBER, QUICK_ATTACK, FLAME_WHEEL
	db -1 ; end

	; RIVAL1 (15)
	db "?@", TRAINERTYPE_MOVES
	db 34, SNEASEL,    QUICK_ATTACK, SCREECH, FAINT_ATTACK, FURY_CUTTER
	db 36, GOLBAT,     LEECH_LIFE, BITE, CONFUSE_RAY, WING_ATTACK
	db 34, MAGNETON,   THUNDERSHOCK, SONICBOOM, THUNDER_WAVE, SWIFT
	db 35, HAUNTER,    MEAN_LOOK, CURSE, SHADOW_BALL, CONFUSE_RAY
	db 35, KADABRA,    DISABLE, PSYBEAM, RECOVER, FUTURE_SIGHT
	db 38, FERALIGATR, RAGE, WATER_GUN, SCARY_FACE, SLASH
	db -1 ; end

PokemonProfGroup:

LoreleiGroup:
	; Kanto hack (M10 13i, D127): Yellow's party, TRAINERTYPE_MOVES = Yellow's level-up
	; fill (WriteMonMoves) + SpecialTrainerMoves (data/trainers/special_moves.asm).
	; LORELEI (1)
	; Yellow data/trainers/parties.asm:708-709 LoreleiData, special_moves.asm LORELEI 1
	db "LORELEI@", TRAINERTYPE_MOVES
	db 54, DEWGONG,    BUBBLEBEAM, AURORA_BEAM, REST, TAKE_DOWN
	db 53, CLOYSTER,   SUPERSONIC, CLAMP, ICE_BEAM, SPIKE_CANNON
	db 54, SLOWBRO,    PSYCHIC_M, SURF, WITHDRAW, AMNESIA
	db 56, JYNX,       DOUBLESLAP, ICE_PUNCH, LOVELY_KISS, THRASH
	db 56, LAPRAS,     BODY_SLAM, CONFUSE_RAY, BLIZZARD, HYDRO_PUMP
	db -1 ; end

PKMNTrainerGroup:
	; CAL (1)
	db "CAL@", TRAINERTYPE_NORMAL
	db 10, CHIKORITA
	db 10, CYNDAQUIL
	db 10, TOTODILE
	db -1 ; end

	; CAL (2)
	db "CAL@", TRAINERTYPE_NORMAL
	db 30, BAYLEEF
	db 30, QUILAVA
	db 30, CROCONAW
	db -1 ; end

	; CAL (3)
	db "CAL@", TRAINERTYPE_NORMAL
	db 50, MEGANIUM
	db 50, TYPHLOSION
	db 50, FERALIGATR
	db -1 ; end

BrunoGroup:
	; Kanto hack (M10 13i, D127): Yellow's party, TRAINERTYPE_MOVES = Yellow's level-up
	; fill (WriteMonMoves) + SpecialTrainerMoves (data/trainers/special_moves.asm).
	; BRUNO (1)
	; Yellow data/trainers/parties.asm:651-652 BrunoData, special_moves.asm BRUNO 1
	db "BRUNO@", TRAINERTYPE_MOVES
	db 53, ONIX,       ROCK_SLIDE, SCREECH, SLAM, DIG
	db 55, HITMONCHAN, ICE_PUNCH, THUNDERPUNCH, FIRE_PUNCH, DOUBLE_TEAM
	db 55, HITMONLEE,  DOUBLE_KICK, MEGA_KICK, HI_JUMP_KICK, DOUBLE_TEAM
	db 56, ONIX,       ROCK_SLIDE, SCREECH, SLAM, EARTHQUAKE
	db 58, MACHAMP,    LEER, KARATE_CHOP, STRENGTH, SUBMISSION
	db -1 ; end

AgathaGroup:
	; Kanto hack (M10 13i, D127): Yellow's party, TRAINERTYPE_MOVES = Yellow's level-up
	; fill (WriteMonMoves) + SpecialTrainerMoves (data/trainers/special_moves.asm).
	; AGATHA (1)
	; Yellow data/trainers/parties.asm:750-751 AgathaData, special_moves.asm AGATHA 1
	db "AGATHA@", TRAINERTYPE_MOVES
	db 56, GENGAR,     CONFUSE_RAY, SUBSTITUTE, LICK, MEGA_DRAIN
	db 56, GOLBAT,     SUPERSONIC, TOXIC, WING_ATTACK, LEECH_LIFE
	db 55, HAUNTER,    CONFUSE_RAY, LICK, HYPNOSIS, DREAM_EATER
	db 58, ARBOK,      WRAP, GLARE, SCREECH, ACID
	db 60, GENGAR,     CONFUSE_RAY, PSYCHIC_M, HYPNOSIS, DREAM_EATER
	db -1 ; end

LanceE4Group:
	; Kanto hack (M10 13i, D127): Yellow's party, TRAINERTYPE_MOVES = Yellow's level-up
	; fill (WriteMonMoves) + SpecialTrainerMoves (data/trainers/special_moves.asm).
	; LANCE_E4 (1)
	; Yellow data/trainers/parties.asm:753-754 LanceData, special_moves.asm LANCE 1
	db "LANCE@", TRAINERTYPE_MOVES
	db 58, GYARADOS,   DRAGON_RAGE, LEER, HYDRO_PUMP, HYPER_BEAM
	db 56, DRAGONAIR,  THUNDER_WAVE, SLAM, THUNDERBOLT, HYPER_BEAM
	db 56, DRAGONAIR,  BUBBLEBEAM, WRAP, ICE_BEAM, HYPER_BEAM
	db 60, AERODACTYL, WING_ATTACK, SWIFT, FLY, HYPER_BEAM
	db 62, DRAGONITE,  BLIZZARD, FIRE_BLAST, THUNDER, HYPER_BEAM
	db -1 ; end


ChampionGroup:
	; CHAMPION (1)
	db "LANCE@", TRAINERTYPE_MOVES
	db 44, GYARADOS,   FLAIL, RAIN_DANCE, SURF, HYPER_BEAM
	db 47, DRAGONITE,  THUNDER_WAVE, TWISTER, THUNDER, HYPER_BEAM
	db 47, DRAGONITE,  THUNDER_WAVE, TWISTER, BLIZZARD, HYPER_BEAM
	db 46, AERODACTYL, WING_ATTACK, ANCIENTPOWER, ROCK_SLIDE, HYPER_BEAM
	db 46, CHARIZARD,  FLAMETHROWER, WING_ATTACK, SLASH, HYPER_BEAM
	db 50, DRAGONITE,  FIRE_BLAST, SAFEGUARD, OUTRAGE, HYPER_BEAM
	db -1 ; end

BrockGroup:
	; BROCK (1)
	; Kanto hack: Yellow's BROCK (docs/M2-PEWTER-CITY.md), moves as in Yellow.
	db "BROCK@", TRAINERTYPE_MOVES
	db 10, GEODUDE,    TACKLE, NO_MOVE, NO_MOVE, NO_MOVE
	db 12, ONIX,       TACKLE, SCREECH, BIDE, NO_MOVE
	db -1 ; end

MistyGroup:
	; MISTY (1)
	; Kanto hack: Yellow's MISTY (docs/M3-CERULEAN.md, 6e).  Yellow's MistyData
	; is `db $FF, 18, STARYU, 21, STARMIE, 0` -- no explicit moves, so Gen 1
	; derives each mon's moveset from its level-1 moves plus every level-up move
	; at or below its level (vendor/pokeyellow/data/pokemon/base_stats/*.asm,
	; evos_moves.asm): STARYU L18 = TACKLE + WATER_GUN (L17); STARMIE L21 =
	; TACKLE/WATER_GUN/HARDEN (its level-1 set -- Starmie is a stone evolution
	; and learns nothing by level).  Same convention as BrockGroup above.
	db "MISTY@", TRAINERTYPE_MOVES
	db 18, STARYU,     TACKLE, WATER_GUN, NO_MOVE, NO_MOVE
	db 21, STARMIE,    TACKLE, WATER_GUN, HARDEN, NO_MOVE
	db -1 ; end

LtSurgeGroup:
	; LT_SURGE (1) - Kanto hack: Yellow's LT.SURGE (docs/M4-VERMILION.md 5.1),
	; one L28 RAICHU.  Yellow gives it no explicit moveset, so the game builds
	; one from RAICHU's base moves -- and RaichuEvosMoves has an empty learnset,
	; so a L28 RAICHU knows exactly its level-1 four:
	; THUNDERSHOCK/GROWL/THUNDER_WAVE and an empty slot.  Spelled out with
	; TRAINERTYPE_MOVES because Gen 2 would otherwise hand it Gen 2's RAICHU
	; learnset (as with BROCK/MISTY in M2/M3).
	db "LT.SURGE@", TRAINERTYPE_MOVES
	db 28, RAICHU,     THUNDERSHOCK, GROWL, THUNDER_WAVE, NO_MOVE
	db -1 ; end

ScientistGroup:
	; SCIENTIST (1)
	db "ROSS@", TRAINERTYPE_NORMAL
	db 22, KOFFING
	db 22, KOFFING
	db -1 ; end

	; SCIENTIST (2)
	db "MITCH@", TRAINERTYPE_NORMAL
	db 24, DITTO
	db -1 ; end

	; SCIENTIST (3)
	db "JED@", TRAINERTYPE_NORMAL
	db 20, MAGNEMITE
	db 20, MAGNEMITE
	db 20, MAGNEMITE
	db -1 ; end

	; SCIENTIST (4)
	db "MARC@", TRAINERTYPE_NORMAL
	db 27, MAGNEMITE
	db 27, MAGNEMITE
	db 27, MAGNEMITE
	db -1 ; end

	; SCIENTIST (5)
	db "RICH@", TRAINERTYPE_MOVES
	db 30, PORYGON,    CONVERSION, CONVERSION2, RECOVER, TRI_ATTACK
	db -1 ; end

	; SCIENTIST (6) - Kanto hack: ROUTE 11, Yellow's ENGINEER 2 (docs/M4-VERMILION.md 7l)
	db "MAXWELL@", TRAINERTYPE_NORMAL
	db 21, MAGNEMITE
	db -1 ; end

	; SCIENTIST (7) - Kanto hack: ROUTE 11, Yellow's ENGINEER 3 (docs/M4-VERMILION.md 7l)
	db "THURSTON@", TRAINERTYPE_NORMAL
	db 18, MAGNEMITE
	db 18, MAGNEMITE
	db 18, MAGNETON
	db -1 ; end

	; SCIENTIST (8) - Kanto hack (M8 11f): SILPH CO. 2F, (5,12).  Yellow
	; ScientistData 2.  Nameless, so PlaceEnemysName prints "SCIENTIST"
	; alone, as Yellow does.
	db "@", TRAINERTYPE_NORMAL
	db 26, GRIMER
	db 26, WEEZING
	db 26, KOFFING
	db 26, WEEZING
	db -1 ; end

	; SCIENTIST (9) - SILPH CO. 2F, (24,13).  Yellow ScientistData 3.
	db "@", TRAINERTYPE_NORMAL
	db 28, MAGNEMITE
	db 28, VOLTORB
	db 28, MAGNETON
	db -1 ; end

	; SCIENTIST (10) - SILPH CO. 3F, (7,9).  Yellow ScientistData 4.
	db "@", TRAINERTYPE_NORMAL
	db 29, ELECTRODE
	db 29, WEEZING
	db -1 ; end

	; SCIENTIST (11) - SILPH CO. 4F, (14,6).  Yellow ScientistData 5.
	db "@", TRAINERTYPE_NORMAL
	db 33, ELECTRODE
	db -1 ; end

	; SCIENTIST (12) - SILPH CO. 5F, (8,3).  Yellow ScientistData 6.
	db "@", TRAINERTYPE_NORMAL
	db 26, MAGNETON
	db 26, KOFFING
	db 26, WEEZING
	db 26, MAGNEMITE
	db -1 ; end

	; SCIENTIST (13) - Kanto hack (M8 11g): SILPH CO. 6F, (7,8).  Yellow
	; ScientistData 7.
	db "@", TRAINERTYPE_NORMAL
	db 25, VOLTORB
	db 25, KOFFING
	db 25, MAGNETON
	db 25, MAGNEMITE
	db 25, KOFFING
	db -1 ; end

	; SCIENTIST (14) - SILPH CO. 7F, (2,13).  Yellow ScientistData 8.
	db "@", TRAINERTYPE_NORMAL
	db 29, ELECTRODE
	db 29, MUK
	db -1 ; end

	; SCIENTIST (15) - SILPH CO. 8F, (10,2).  Yellow ScientistData 9.
	db "@", TRAINERTYPE_NORMAL
	db 29, GRIMER
	db 29, ELECTRODE
	db -1 ; end

	; SCIENTIST (16) - SILPH CO. 9F, (21,13).  Yellow ScientistData 10.
	db "@", TRAINERTYPE_NORMAL
	db 28, VOLTORB
	db 28, KOFFING
	db 28, MAGNETON
	db -1 ; end

	; SCIENTIST (17) - SILPH CO. 10F, (10,2).  Yellow ScientistData 11.
	db "@", TRAINERTYPE_NORMAL
	db 29, MAGNEMITE
	db 29, KOFFING
	db -1 ; end

	; SCIENTIST (18) - Kanto hack (M9 12k): POKeMON MANSION 3F, (20,11).
	; Yellow ScientistData 12.  Nameless, same as 8-17 above.
	db "@", TRAINERTYPE_NORMAL
	db 33, MAGNEMITE
	db 33, MAGNETON
	db 33, VOLTORB
	db -1 ; end

	; SCIENTIST (19) - POKeMON MANSION B1F, (27,11).  Yellow ScientistData 13.
	db "@", TRAINERTYPE_NORMAL
	db 34, MAGNEMITE
	db 34, ELECTRODE
	db -1 ; end

ErikaGroup:
	; ERIKA (1)
	; Kanto hack: Yellow's ERIKA (docs/M6-CELADON.md 5.1, M6 9q).  ErikaData is
	; `db $FF, 30, TANGELA, 32, WEEPINBELL, 32, GLOOM, 0` -- no explicit moves,
	; so Gen 1's WriteMonMoves (vendor/pokeyellow/engine/pokemon/evos_moves.asm)
	; seeds each mon with its base_stats level-1 four and then appends every
	; learnset move at or below its level, shifting slot 1 out when full:
	;   TANGELA    L30 base CONSTRICT + L24 BIND, L27 ABSORB, L29 VINE_WHIP
	;   WEEPINBELL L32 base VINE_WHIP/GROWTH/WRAP + L15 POISONPOWDER,
	;              L18 SLEEP_POWDER, L23 STUN_SPORE, L29 ACID (WRAP is already
	;              known at L13, and the first three base moves shift out)
	;   GLOOM      L32 base ABSORB/POISONPOWDER/STUN_SPORE + L19 SLEEP_POWDER,
	;              L28 ACID (ABSORB shifts out)
	; Spelled out with TRAINERTYPE_MOVES for the same reason as BROCK/MISTY/
	; LT.SURGE above: Gen 2 would otherwise use Gen 2's learnsets.
	db "ERIKA@", TRAINERTYPE_MOVES
	db 30, TANGELA,    CONSTRICT, BIND, ABSORB, VINE_WHIP
	db 32, WEEPINBELL, POISONPOWDER, SLEEP_POWDER, STUN_SPORE, ACID
	db 32, GLOOM,      POISONPOWDER, STUN_SPORE, SLEEP_POWDER, ACID
	db -1 ; end

YoungsterGroup:
	; YOUNGSTER (1)
	db "JOEY@", TRAINERTYPE_NORMAL
	db  4, RATTATA
	db -1 ; end

	; YOUNGSTER (2)
	db "MIKEY@", TRAINERTYPE_NORMAL
	db  2, PIDGEY
	db  4, RATTATA
	db -1 ; end

	; YOUNGSTER (3)
	db "ALBERT@", TRAINERTYPE_NORMAL
	db  6, RATTATA
	db  8, ZUBAT
	db -1 ; end

	; YOUNGSTER (4)
	db "GORDON@", TRAINERTYPE_NORMAL
	db 10, WOOPER
	db -1 ; end

	; YOUNGSTER (5)
	db "SAMUEL@", TRAINERTYPE_NORMAL
	db  7, RATTATA
	db 10, SANDSHREW
	db  8, SPEAROW
	db  8, SPEAROW
	db -1 ; end

	; YOUNGSTER (6)
	db "IAN@", TRAINERTYPE_NORMAL
	db 10, MANKEY
	db 12, DIGLETT
	db -1 ; end

	; YOUNGSTER (7)
	db "JOEY@", TRAINERTYPE_NORMAL
	db 15, RATTATA
	db -1 ; end

	; YOUNGSTER (8)
	db "JOEY@", TRAINERTYPE_MOVES
	db 21, RATICATE,   TAIL_WHIP, QUICK_ATTACK, HYPER_FANG, SCARY_FACE
	db -1 ; end

	; YOUNGSTER (9) - Kanto hack: Route 3, Yellow's YOUNGSTER 1
	db "WARREN@", TRAINERTYPE_NORMAL
	db 11, RATTATA
	db 11, EKANS
	db -1 ; end

	; YOUNGSTER (10) - Kanto hack: Route 3, Yellow's YOUNGSTER 2
	db "JIMMY@", TRAINERTYPE_NORMAL
	db 14, SPEAROW
	db -1 ; end

	; YOUNGSTER (11) - Kanto hack: ROUTE 11, Yellow's YOUNGSTER 9 (docs/M4-VERMILION.md 7l; was the unused OWEN)
	db "FLOYD@", TRAINERTYPE_NORMAL
	db 21, EKANS
	db -1 ; end

	; YOUNGSTER (12) - Kanto hack: ROUTE 11, Yellow's YOUNGSTER 10 (docs/M4-VERMILION.md 7l; was the unused JASON)
	db "RUDY@", TRAINERTYPE_NORMAL
	db 19, SANDSHREW
	db 19, ZUBAT
	db -1 ; end

	; YOUNGSTER (13)
	db "JOEY@", TRAINERTYPE_MOVES
	db 30, RATICATE,   TAIL_WHIP, QUICK_ATTACK, HYPER_FANG, PURSUIT
	db -1 ; end

	; YOUNGSTER (14)
	db "JOEY@", TRAINERTYPE_MOVES
	db 37, RATICATE,   HYPER_BEAM, QUICK_ATTACK, HYPER_FANG, PURSUIT
	db -1 ; end

	; YOUNGSTER (15) - Kanto hack: Mt. Moon 1F, Yellow's YOUNGSTER 3
	db "DUSTIN@", TRAINERTYPE_NORMAL
	db 10, RATTATA
	db 10, RATTATA
	db 10, ZUBAT
	db -1 ; end

	; YOUNGSTER (16) - Kanto hack: Nugget Bridge No. 3, Yellow's YOUNGSTER 4
	db "VICTOR@", TRAINERTYPE_NORMAL
	db 14, RATTATA
	db 14, EKANS
	db 14, ZUBAT
	db -1 ; end

	; YOUNGSTER (17) - Kanto hack: Route 25, Yellow's YOUNGSTER 5
	db "GRANT@", TRAINERTYPE_NORMAL
	db 15, RATTATA
	db 15, SPEAROW
	db -1 ; end

	; YOUNGSTER (18) - Kanto hack: Route 25, Yellow's YOUNGSTER 6
	db "COLE@", TRAINERTYPE_NORMAL
	db 17, SLOWPOKE
	db -1 ; end

	; YOUNGSTER (19) - Kanto hack: Route 25, Yellow's YOUNGSTER 7
	db "OSCAR@", TRAINERTYPE_NORMAL
	db 14, EKANS
	db 14, SANDSHREW
	db -1 ; end

	; YOUNGSTER (20) - Kanto hack: S.S. ANNE 1F Rooms, Yellow's YOUNGSTER 8 (docs/M4-VERMILION.md 5.1)
	db "BENJI@", TRAINERTYPE_NORMAL
	db 21, NIDORAN_M
	db -1 ; end

	; YOUNGSTER (21) - Kanto hack: ROUTE 11, Yellow's YOUNGSTER 11 (docs/M4-VERMILION.md 7l)
	db "GORDY@", TRAINERTYPE_NORMAL
	db 17, RATTATA
	db 17, RATTATA
	db 17, RATICATE
	db -1 ; end

	; YOUNGSTER (22) - Kanto hack: ROUTE 11, Yellow's YOUNGSTER 12 (docs/M4-VERMILION.md 7l)
	db "CLIFF@", TRAINERTYPE_NORMAL
	db 18, NIDORAN_M
	db 18, NIDORINO
	db -1 ; end

	; YOUNGSTER (23) - Kanto hack: ROUTE 9, Yellow's YOUNGSTER 14 "A.J." (docs/M5-LAVENDER.md 5.1)
	db "A.J.@", TRAINERTYPE_NORMAL
	db 24, SANDSHREW
	db -1 ; end

SchoolboyGroup:
	; SCHOOLBOY (1)
	db "JACK@", TRAINERTYPE_NORMAL
	db 12, ODDISH
	db 15, VOLTORB
	db -1 ; end

	; SCHOOLBOY (2) -- unused (Kanto hack, M7 10e): KIPP was one of Crystal's own
	; ROUTE 15 trainers, deleted by the Yellow re-cut.  The row is kept so the
	; class is not renumbered; it can be reclaimed in place by a later map.
	db "KIPP@", TRAINERTYPE_NORMAL
	db 27, VOLTORB
	db 27, MAGNEMITE
	db 31, VOLTORB
	db 31, MAGNETON
	db -1 ; end

	; SCHOOLBOY (3)
	db "ALAN@", TRAINERTYPE_NORMAL
	db 16, TANGELA
	db -1 ; end

	; SCHOOLBOY (4) -- unused (Kanto hack, M7 10e): JOHNNY was one of Crystal's own
	; ROUTE 15 trainers, deleted by the Yellow re-cut.  The row is kept so the
	; class is not renumbered; it can be reclaimed in place by a later map.
	db "JOHNNY@", TRAINERTYPE_NORMAL
	db 29, BELLSPROUT
	db 31, WEEPINBELL
	db 33, VICTREEBEL
	db -1 ; end

	; SCHOOLBOY (5)
	db "DANNY@", TRAINERTYPE_NORMAL
	db 31, JYNX
	db 31, ELECTABUZZ
	db 31, MAGMAR
	db -1 ; end

	; SCHOOLBOY (6) -- unused (Kanto hack, M7 10e): TOMMY was one of Crystal's own
	; ROUTE 15 trainers, deleted by the Yellow re-cut.  The row is kept so the
	; class is not renumbered; it can be reclaimed in place by a later map.
	db "TOMMY@", TRAINERTYPE_NORMAL
	db 32, XATU
	db 34, ALAKAZAM
	db -1 ; end

	; SCHOOLBOY (7)
	db "DUDLEY@", TRAINERTYPE_NORMAL
	db 35, ODDISH
	db -1 ; end

	; SCHOOLBOY (8)
	db "JOE@", TRAINERTYPE_NORMAL
	db 33, TANGELA
	db 33, VAPOREON
	db -1 ; end

	; SCHOOLBOY (9) -- unused (Kanto hack, M7 10e): BILLY was one of Crystal's own
	; ROUTE 15 trainers, deleted by the Yellow re-cut.  The row is kept so the
	; class is not renumbered; it can be reclaimed in place by a later map.
	db "BILLY@", TRAINERTYPE_NORMAL
	db 27, PARAS
	db 27, PARAS
	db 27, POLIWHIRL
	db 35, DITTO
	db -1 ; end

	; SCHOOLBOY (10)
	db "CHAD@", TRAINERTYPE_NORMAL
	db 19, MR__MIME
	db -1 ; end

	; SCHOOLBOY (11)
	db "NATE@", TRAINERTYPE_NORMAL
	db 32, LEDIAN
	db 32, EXEGGUTOR
	db -1 ; end

	; SCHOOLBOY (12)
	db "RICKY@", TRAINERTYPE_NORMAL
	db 32, AIPOM
	db 32, DITTO
	db -1 ; end

	; SCHOOLBOY (13)
	db "JACK@", TRAINERTYPE_NORMAL
	db 14, ODDISH
	db 17, VOLTORB
	db -1 ; end

	; SCHOOLBOY (14)
	db "JACK@", TRAINERTYPE_NORMAL
	db 28, GLOOM
	db 31, ELECTRODE
	db -1 ; end

	; SCHOOLBOY (15)
	db "ALAN@", TRAINERTYPE_NORMAL
	db 17, TANGELA
	db 17, YANMA
	db -1 ; end

	; SCHOOLBOY (16)
	db "ALAN@", TRAINERTYPE_NORMAL
	db 20, NATU
	db 22, TANGELA
	db 20, QUAGSIRE
	db 25, YANMA
	db -1 ; end

	; SCHOOLBOY (17)
	db "CHAD@", TRAINERTYPE_NORMAL
	db 19, MR__MIME
	db 19, MAGNEMITE
	db -1 ; end

	; SCHOOLBOY (18)
	db "CHAD@", TRAINERTYPE_NORMAL
	db 27, MR__MIME
	db 31, MAGNETON
	db -1 ; end

	; SCHOOLBOY (19)
	db "JACK@", TRAINERTYPE_NORMAL
	db 30, GLOOM
	db 33, GROWLITHE
	db 33, ELECTRODE
	db -1 ; end

	; SCHOOLBOY (20)
	db "JACK@", TRAINERTYPE_MOVES
	db 35, ELECTRODE,  SCREECH, SONICBOOM, ROLLOUT, LIGHT_SCREEN
	db 35, GROWLITHE,  SUNNY_DAY, LEER, TAKE_DOWN, FLAME_WHEEL
	db 37, VILEPLUME,  SOLARBEAM, SLEEP_POWDER, ACID, MOONLIGHT
	db -1 ; end

	; SCHOOLBOY (21)
	db "ALAN@", TRAINERTYPE_NORMAL
	db 27, NATU
	db 27, TANGELA
	db 30, QUAGSIRE
	db 30, YANMA
	db -1 ; end

	; SCHOOLBOY (22)
	db "ALAN@", TRAINERTYPE_MOVES
	db 35, XATU,       PECK, NIGHT_SHADE, SWIFT, FUTURE_SIGHT
	db 32, TANGELA,    POISONPOWDER, VINE_WHIP, BIND, MEGA_DRAIN
	db 32, YANMA,      QUICK_ATTACK, DOUBLE_TEAM, SONICBOOM, SUPERSONIC
	db 35, QUAGSIRE,   TAIL_WHIP, SLAM, AMNESIA, EARTHQUAKE
	db -1 ; end

	; SCHOOLBOY (23)
	db "CHAD@", TRAINERTYPE_NORMAL
	db 30, MR__MIME
	db 34, MAGNETON
	db -1 ; end

	; SCHOOLBOY (24)
	db "CHAD@", TRAINERTYPE_MOVES
	db 34, MR__MIME,   PSYCHIC_M, LIGHT_SCREEN, REFLECT, ENCORE
	db 38, MAGNETON,   ZAP_CANNON, THUNDER_WAVE, LOCK_ON, SWIFT
	db -1 ; end

BirdKeeperGroup:
	; BIRD_KEEPER (1)
	db "ROD@", TRAINERTYPE_NORMAL
	db  7, PIDGEY
	db  7, PIDGEY
	db -1 ; end

	; BIRD_KEEPER (2)
	db "ABE@", TRAINERTYPE_NORMAL
	db  9, SPEAROW
	db -1 ; end

	; BIRD_KEEPER (3)
	db "BRYAN@", TRAINERTYPE_NORMAL
	db 12, PIDGEY
	db 14, PIDGEOTTO
	db -1 ; end

	; BIRD_KEEPER (4)
	db "THEO@", TRAINERTYPE_NORMAL
	db 17, PIDGEY
	db 15, PIDGEY
	db 19, PIDGEY
	db 15, PIDGEY
	db 15, PIDGEY
	db -1 ; end

	; BIRD_KEEPER (5)
	db "TOBY@", TRAINERTYPE_NORMAL
	db 15, DODUO
	db 16, DODUO
	db 17, DODUO
	db -1 ; end

	; BIRD_KEEPER (6)
	db "DENIS@", TRAINERTYPE_NORMAL
	db 18, SPEAROW
	db 20, FEAROW
	db 18, SPEAROW
	db -1 ; end

	; BIRD_KEEPER (7)
	db "VANCE@", TRAINERTYPE_NORMAL
	db 25, PIDGEOTTO
	db 25, PIDGEOTTO
	db -1 ; end

	; BIRD_KEEPER (8) -- Kanto hack (M6 9aa): Yellow's ROUTE 18 BIRD KEEPER 1,
	; OPP_BIRD_KEEPER 8 (db 29, SPEAROW, FEAROW, 0).  Was Crystal's HANK, a row
	; no map referenced.  Nameless, so PlaceEnemysName prints "BIRD KEEPER".
	db "@", TRAINERTYPE_NORMAL
	db 29, SPEAROW
	db 29, FEAROW
	db -1 ; end

	; BIRD_KEEPER (9) = BIRD_KEEPER_7 -- Kanto hack (M7 10d): Yellow's ROUTE 14 COOLTRAINER_M1,
	; OPP_BIRD_KEEPER 14 (db 28, PIDGEY, DODUO, PIDGEOTTO, 0).  Was Crystal's ROY,
	; its own ROUTE 14 bird keeper, deleted by 10d.  Nameless, so PlaceEnemysName
	; prints "BIRD KEEPER".
	db "@", TRAINERTYPE_NORMAL
	db 28, PIDGEY
	db 28, DODUO
	db 28, PIDGEOTTO
	db -1 ; end

	; BIRD_KEEPER (10) -- Kanto hack (M6 9aa): Yellow's ROUTE 18 BIRD KEEPER 2,
	; OPP_BIRD_KEEPER 9 (db 34, DODRIO, 0).  Was Crystal's BORIS.
	db "@", TRAINERTYPE_NORMAL
	db 34, DODRIO
	db -1 ; end

	; BIRD_KEEPER (11) -- Kanto hack (M6 9aa): Yellow's ROUTE 18 BIRD KEEPER 3,
	; OPP_BIRD_KEEPER 10 (db 26, SPEAROW, SPEAROW, FEAROW, SPEAROW, 0).  Was
	; Crystal's BOB.
	db "@", TRAINERTYPE_NORMAL
	db 26, SPEAROW
	db 26, SPEAROW
	db 26, FEAROW
	db 26, SPEAROW
	db -1 ; end

	; BIRD_KEEPER (12)
	db "JOSE@", TRAINERTYPE_NORMAL
	db 36, FARFETCH_D
	db -1 ; end

	; BIRD_KEEPER (13)
	db "PETER@", TRAINERTYPE_NORMAL
	db  6, PIDGEY
	db  6, PIDGEY
	db  8, SPEAROW
	db -1 ; end

	; BIRD_KEEPER (14)
	db "JOSE@", TRAINERTYPE_NORMAL
	db 34, FARFETCH_D
	db -1 ; end

	; BIRD_KEEPER (15) -- Kanto hack (M7 10c): Yellow's ROUTE 13 BIRD KEEPER 1,
	; OPP_BIRD_KEEPER 1 (db 29, PIDGEY, PIDGEOTTO, 0).  Was Crystal's PERRY, one
	; of its own ROUTE 13 pair, deleted by 10c.  Nameless, so PlaceEnemysName
	; prints "BIRD KEEPER".
	db "@", TRAINERTYPE_NORMAL
	db 29, PIDGEY
	db 29, PIDGEOTTO
	db -1 ; end

	; BIRD_KEEPER (16) -- Kanto hack (M7 10c): Yellow's ROUTE 13 BIRD KEEPER 2,
	; OPP_BIRD_KEEPER 2 (db 25, SPEAROW, PIDGEY, PIDGEY, SPEAROW, SPEAROW, 0).
	; Was Crystal's BRET.
	db "@", TRAINERTYPE_NORMAL
	db 25, SPEAROW
	db 25, PIDGEY
	db 25, PIDGEY
	db 25, SPEAROW
	db 25, SPEAROW
	db -1 ; end

	; BIRD_KEEPER (17)
	db "JOSE@", TRAINERTYPE_MOVES
	db 40, FARFETCH_D, FURY_ATTACK, DETECT, FLY, SLASH
	db -1 ; end

	; BIRD_KEEPER (18)
	db "VANCE@", TRAINERTYPE_NORMAL
	db 32, PIDGEOTTO
	db 32, PIDGEOTTO
	db -1 ; end

	; BIRD_KEEPER (19)
	db "VANCE@", TRAINERTYPE_MOVES
	db 38, PIDGEOT,    TOXIC, QUICK_ATTACK, WHIRLWIND, FLY
	db 38, PIDGEOT,    SWIFT, DETECT, STEEL_WING, FLY
	db -1 ; end

	; BIRD_KEEPER (20) -- Kanto hack (M7 10c): Yellow's ROUTE 13 BIRD KEEPER 3,
	; OPP_BIRD_KEEPER 3 (db 26, PIDGEY, PIDGEOTTO, SPEAROW, FEAROW, 0).  The
	; class had only two dead rows left, so this one is appended.
	db "@", TRAINERTYPE_NORMAL
	db 26, PIDGEY
	db 26, PIDGEOTTO
	db 26, SPEAROW
	db 26, FEAROW
	db -1 ; end

	; BIRD_KEEPER (21) = BIRD_KEEPER_8 -- Kanto hack (M7 10d): Yellow's ROUTE 14 COOLTRAINER_M2,
	; OPP_BIRD_KEEPER 15 (db 26, PIDGEY, SPEAROW, PIDGEY, FEAROW, 0).  The class had
	; only ROY's dead row left, so this one and the four below are appended.
	db "@", TRAINERTYPE_NORMAL
	db 26, PIDGEY
	db 26, SPEAROW
	db 26, PIDGEY
	db 26, FEAROW
	db -1 ; end

	; BIRD_KEEPER (22) = BIRD_KEEPER_9 -- Kanto hack (M7 10d): Yellow's ROUTE 14 COOLTRAINER_M3,
	; OPP_BIRD_KEEPER 16 (db 29, PIDGEOTTO, FEAROW, 0).
	db "@", TRAINERTYPE_NORMAL
	db 29, PIDGEOTTO
	db 29, FEAROW
	db -1 ; end

	; BIRD_KEEPER (23) = BIRD_KEEPER_10 -- Kanto hack (M7 10d): Yellow's ROUTE 14 COOLTRAINER_M4,
	; OPP_BIRD_KEEPER 17 (db 28, SPEAROW, DODUO, FEAROW, 0).
	db "@", TRAINERTYPE_NORMAL
	db 28, SPEAROW
	db 28, DODUO
	db 28, FEAROW
	db -1 ; end

	; BIRD_KEEPER (24) = BIRD_KEEPER_11 -- Kanto hack (M7 10d): Yellow's ROUTE 14 COOLTRAINER_M5,
	; OPP_BIRD_KEEPER 4 (db 33, FARFETCHD, 0).
	db "@", TRAINERTYPE_NORMAL
	db 33, FARFETCH_D
	db -1 ; end

	; BIRD_KEEPER (25) = BIRD_KEEPER_12 -- Kanto hack (M7 10d): Yellow's ROUTE 14 COOLTRAINER_M6,
	; OPP_BIRD_KEEPER 5 (db 29, SPEAROW, FEAROW, 0).
	db "@", TRAINERTYPE_NORMAL
	db 29, SPEAROW
	db 29, FEAROW
	db -1 ; end

	; BIRD_KEEPER (26) = BIRD_KEEPER_13 -- Kanto hack (M7 10e): Yellow's ROUTE 15
	; COOLTRAINER_M1, OPP_BIRD_KEEPER 6
	; (db 26, PIDGEOTTO, FARFETCHD, DODUO, PIDGEY, 0).  Appended: the class has
	; had no dead rows since 10d.
	db "@", TRAINERTYPE_NORMAL
	db 26, PIDGEOTTO
	db 26, FARFETCH_D
	db 26, DODUO
	db 26, PIDGEY
	db -1 ; end

	; BIRD_KEEPER (27) = BIRD_KEEPER_14 -- Kanto hack (M7 10e): Yellow's ROUTE 15
	; COOLTRAINER_M2, OPP_BIRD_KEEPER 7 (db 28, DODRIO, DODUO, DODUO, 0).
	db "@", TRAINERTYPE_NORMAL
	db 28, DODRIO
	db 28, DODUO
	db 28, DODUO
	db -1 ; end


	; BIRD_KEEPER (28) = BIRD_KEEPER_15 -- Kanto hack (M9 12c): Yellow's ROUTE 20
	; COOLTRAINER_M, OPP_BIRD_KEEPER 11.  Appended: the class has had no dead
	; rows since 10d.
	db "@", TRAINERTYPE_NORMAL
	db 30, FEAROW
	db 30, FEAROW
	db 30, PIDGEOTTO
	db -1 ; end
LassGroup:
	; LASS (1)
	db "CARRIE@", TRAINERTYPE_MOVES
	db 18, SNUBBULL,   SCARY_FACE, CHARM, BITE, LICK
	db -1 ; end

	; LASS (2)
	db "BRIDGET@", TRAINERTYPE_NORMAL
	db 15, JIGGLYPUFF
	db 15, JIGGLYPUFF
	db 15, JIGGLYPUFF
	db -1 ; end

	; LASS (3)
	db "ALICE@", TRAINERTYPE_NORMAL
	db 30, GLOOM
	db 34, ARBOK
	db 30, GLOOM
	db -1 ; end

	; LASS (4)
	db "KRISE@", TRAINERTYPE_NORMAL
	db 12, ODDISH
	db 15, CUBONE
	db -1 ; end

	; LASS (5)
	db "CONNIE@", TRAINERTYPE_NORMAL
	db 21, MARILL
	db -1 ; end

	; LASS (6)
	db "LINDA@", TRAINERTYPE_NORMAL
	db 30, BULBASAUR
	db 32, IVYSAUR
	db 34, VENUSAUR
	db -1 ; end

	; LASS (7)
	db "LAURA@", TRAINERTYPE_NORMAL
	db 28, GLOOM
	db 31, PIDGEOTTO
	db 31, BELLOSSOM
	db -1 ; end

	; LASS (8)
	db "SHANNON@", TRAINERTYPE_NORMAL
	db 29, PARAS
	db 29, PARAS
	db 32, PARASECT
	db -1 ; end

	; LASS (9) - Kanto hack: CELADON GYM, Yellow's LASS 17 (M6 9q).  Kept in
	; place; MICHELLE was already Crystal's Celadon Gym lass.
	db "MICHELLE@", TRAINERTYPE_NORMAL
	db 23, BELLSPROUT
	db 23, WEEPINBELL
	db -1 ; end

	; LASS (10)
	db "DANA@", TRAINERTYPE_MOVES
	db 18, FLAAFFY,    TACKLE, GROWL, THUNDERSHOCK, THUNDER_WAVE
	db 18, PSYDUCK,    SCRATCH, TAIL_WHIP, DISABLE, CONFUSION
	db -1 ; end

	; LASS (11) - Kanto hack: ROUTE 8, Yellow's LASS 15.  Renamed in place
	; (M5 8j); ELLEN was dead (6i gave her flag to TESSA).
	db "WINNIE@", TRAINERTYPE_NORMAL
	db 19, PIDGEY
	db 19, RATTATA
	db 19, NIDORAN_F
	db 19, MEOWTH
	db 19, NIDORAN_M
	db -1 ; end

	; LASS (12) - Kanto hack: ROUTE 8, Yellow's LASS 13.  Renamed in place
	; (M5 8j); CONNIE2 was an unused Crystal rematch slot.
	db "ESTHER@", TRAINERTYPE_NORMAL
	db 23, NIDORAN_F
	db 23, NIDORINA
	db -1 ; end

	; LASS (13) - Kanto hack: ROUTE 8, Yellow's LASS 14.  Renamed in place
	; (M5 8j); CONNIE3 was an unused Crystal rematch slot.
	db "FLORA@", TRAINERTYPE_NORMAL
	db 24, MEOWTH
	db 24, MEOWTH
	db 24, MEOWTH
	db -1 ; end

	; LASS (14)
	db "DANA@", TRAINERTYPE_MOVES
	db 21, FLAAFFY,    TACKLE, GROWL, THUNDERSHOCK, THUNDER_WAVE
	db 21, PSYDUCK,    SCRATCH, TAIL_WHIP, DISABLE, CONFUSION
	db -1 ; end

	; LASS (15)
	db "DANA@", TRAINERTYPE_MOVES
	db 29, PSYDUCK,    SCRATCH, DISABLE, CONFUSION, SCREECH
	db 29, AMPHAROS,   TACKLE, THUNDERSHOCK, THUNDER_WAVE, COTTON_SPORE
	db -1 ; end

	; LASS (16)
	db "DANA@", TRAINERTYPE_MOVES
	db 32, PSYDUCK,    SCRATCH, DISABLE, CONFUSION, SCREECH
	db 32, AMPHAROS,   TACKLE, THUNDERPUNCH, THUNDER_WAVE, COTTON_SPORE
	db -1 ; end

	; LASS (17)
	db "DANA@", TRAINERTYPE_MOVES
	db 36, AMPHAROS,   SWIFT, THUNDERPUNCH, THUNDER_WAVE, COTTON_SPORE
	db 36, GOLDUCK,    DISABLE, SURF, PSYCHIC_M, SCREECH
	db -1 ; end

	; LASS (18) - Kanto hack: Viridian Forest, Yellow's LASS 19
	db "SARAH@", TRAINERTYPE_NORMAL
	db  6, NIDORAN_F
	db  6, NIDORAN_M
	db -1 ; end

	; LASS (19) - Kanto hack: Route 3, Yellow's LASS 1
	db "JANICE@", TRAINERTYPE_NORMAL
	db  9, PIDGEY
	db  9, PIDGEY
	db -1 ; end

	; LASS (20) - Kanto hack: Route 3, Yellow's LASS 2
	db "SALLY@", TRAINERTYPE_NORMAL
	db 10, RATTATA
	db 10, NIDORAN_M
	db -1 ; end

	; LASS (21) - Kanto hack: Route 3, Yellow's LASS 3
	db "ROBIN@", TRAINERTYPE_NORMAL
	db 14, JIGGLYPUFF
	db -1 ; end

	; LASS (22) - Kanto hack: Route 4, Yellow's LASS 4
	db "TAMARA@", TRAINERTYPE_NORMAL
	db 31, PARAS
	db 31, PARAS
	db 31, PARASECT
	db -1 ; end

	; LASS (23) - Kanto hack: Mt. Moon 1F, Yellow's LASS 5
	db "MELISSA@", TRAINERTYPE_NORMAL
	db 11, ODDISH
	db 11, BELLSPROUT
	db -1 ; end

	; LASS (24) - Kanto hack: Mt. Moon 1F, Yellow's LASS 6
	db "NADINE@", TRAINERTYPE_NORMAL
	db 14, CLEFAIRY
	db -1 ; end

	; LASS (25) - Kanto hack: Nugget Bridge No. 4, Yellow's LASS 7
	db "NORMA@", TRAINERTYPE_NORMAL
	db 16, PIDGEY
	db 16, NIDORAN_F
	db -1 ; end

	; LASS (26) - Kanto hack: Nugget Bridge No. 2, Yellow's LASS 8
	db "PAULINE@", TRAINERTYPE_NORMAL
	db 14, PIDGEY
	db 14, NIDORAN_F
	db -1 ; end

	; LASS (27) - Kanto hack: Route 25, Yellow's LASS 9
	db "JODIE@", TRAINERTYPE_NORMAL
	db 15, NIDORAN_M
	db 15, NIDORAN_F
	db -1 ; end

	; LASS (28) - Kanto hack: Route 25, Yellow's LASS 10
	db "TESSA@", TRAINERTYPE_NORMAL
	db 13, ODDISH
	db 13, PIDGEY
	db 13, ODDISH
	db -1 ; end

	; LASS (29) - Kanto hack: S.S. ANNE 1F Rooms, Yellow's LASS 11 (docs/M4-VERMILION.md 5.1)
	db "ODETTE@", TRAINERTYPE_NORMAL
	db 18, PIDGEY
	db 18, NIDORAN_F
	db -1 ; end

	; LASS (30) - Kanto hack: S.S. ANNE 2F Rooms, Yellow's LASS 12 (docs/M4-VERMILION.md 5.1)
	db "MARISA@", TRAINERTYPE_NORMAL
	db 20, JIGGLYPUFF
	db -1 ; end

	; LASS (31) - Kanto hack: ROUTE 8, Yellow's LASS 16 (M5 8j).  Appended --
	; the LASS group had only three dead slots and ROUTE 8 needs four.
	db "TILDA@", TRAINERTYPE_NORMAL
	db 22, CLEFAIRY
	db 22, CLEFAIRY
	db -1 ; end

	; LASS (32) - Kanto hack: CELADON GYM, Yellow's LASS 18 (M6 9q).  Appended
	; -- MICHELLE (9) was the group's only free slot and the gym needs two
	; lasses; LASS 10/14-17 are Crystal's DANA phone-rematch rows.
	db "HOLLY@", TRAINERTYPE_NORMAL
	db 23, ODDISH
	db 23, GLOOM
	db -1 ; end

KogaLeaderGroup:
	; KOGA_LEADER (1)
	; Kanto hack (M7 10h): Yellow's FUCHSIA GYM KOGA, over the dead JANINE row.
	; KOGA (1) in KogaGroup is Crystal's ELITE FOUR KOGA, untouched.  Yellow's KogaData
	; is `db $FF, 44, VENONAT, 46, VENONAT, 48, VENONAT, 50, VENOMOTH, 0` -- no
	; explicit moves, so Gen 1 derives each moveset from the mon's level-1 moves
	; plus every level-up move at or below its level (WriteMonMoves), newest
	; four kept.  VENONAT L1 = TACKLE/DISABLE, learnset 11 SUPERSONIC,
	; 19 CONFUSION, 22 POISONPOWDER, 27 LEECH_LIFE, 30 STUN_SPORE, 35 PSYBEAM,
	; 38 SLEEP_POWDER, 43 PSYCHIC_M; VENOMOTH L1 adds SUPERSONIC/CONFUSION,
	; learnset 22/27/30/38/43/50.  At L44/46/48/50 all four land on the same
	; last four moves.  Same convention as BrockGroup/MistyGroup/ErikaGroup.
	db "KOGA@", TRAINERTYPE_MOVES
	db 44, VENONAT,    STUN_SPORE, PSYBEAM, SLEEP_POWDER, PSYCHIC_M
	db 46, VENONAT,    STUN_SPORE, PSYBEAM, SLEEP_POWDER, PSYCHIC_M
	db 48, VENONAT,    STUN_SPORE, PSYBEAM, SLEEP_POWDER, PSYCHIC_M
	db 50, VENOMOTH,   STUN_SPORE, PSYBEAM, SLEEP_POWDER, PSYCHIC_M
	db -1 ; end

CooltrainerMGroup:
	; COOLTRAINERM (1)
	db "NICK@", TRAINERTYPE_MOVES
	db 26, CHARMANDER, EMBER, SMOKESCREEN, RAGE, SCARY_FACE
	db 26, SQUIRTLE,   WITHDRAW, WATER_GUN, BITE, CURSE
	db 26, BULBASAUR,  LEECH_SEED, POISONPOWDER, SLEEP_POWDER, RAZOR_LEAF
	db -1 ; end

	; COOLTRAINERM (2)
	db "AARON@", TRAINERTYPE_NORMAL
	db 24, IVYSAUR
	db 24, CHARMELEON
	db 24, WARTORTLE
	db -1 ; end

	; COOLTRAINERM (3)
	db "PAUL@", TRAINERTYPE_NORMAL
	db 34, DRATINI
	db 34, DRATINI
	db 34, DRATINI
	db -1 ; end

	; COOLTRAINERM (4)
	db "CODY@", TRAINERTYPE_NORMAL
	db 34, HORSEA
	db 36, SEADRA
	db -1 ; end

	; COOLTRAINERM (5)
	db "MIKE@", TRAINERTYPE_NORMAL
	db 37, DRAGONAIR
	db -1 ; end

	; COOLTRAINERM (6)
	db "GAVEN@", TRAINERTYPE_MOVES
	db 35, VICTREEBEL, WRAP, TOXIC, ACID, RAZOR_LEAF
	db 35, KINGLER,    BUBBLEBEAM, STOMP, GUILLOTINE, PROTECT
	db 35, FLAREON,    SAND_ATTACK, QUICK_ATTACK, BITE, FIRE_SPIN
	db -1 ; end

	; COOLTRAINERM (7)
	db "GAVEN@", TRAINERTYPE_ITEM_MOVES
	db 39, VICTREEBEL, NO_ITEM,      GIGA_DRAIN, TOXIC, SLUDGE_BOMB, RAZOR_LEAF
	db 39, KINGLER,    KINGS_ROCK,   SURF, STOMP, GUILLOTINE, BLIZZARD
	db 39, FLAREON,    NO_ITEM,      FLAMETHROWER, QUICK_ATTACK, BITE, FIRE_SPIN
	db -1 ; end

	; COOLTRAINERM (8)
	db "RYAN@", TRAINERTYPE_MOVES
	db 25, PIDGEOT,    SAND_ATTACK, QUICK_ATTACK, WHIRLWIND, WING_ATTACK
	db 27, ELECTABUZZ, THUNDERPUNCH, LIGHT_SCREEN, SWIFT, SCREECH
	db -1 ; end

	; COOLTRAINERM (9)
	db "JAKE@", TRAINERTYPE_MOVES
	db 33, PARASECT,   LEECH_LIFE, SPORE, SLASH, SWORDS_DANCE
	db 35, GOLDUCK,    CONFUSION, SCREECH, PSYCH_UP, FURY_SWIPES
	db -1 ; end

	; COOLTRAINERM (10)
	db "GAVEN@", TRAINERTYPE_MOVES
	db 32, VICTREEBEL, WRAP, TOXIC, ACID, RAZOR_LEAF
	db 32, KINGLER,    BUBBLEBEAM, STOMP, GUILLOTINE, PROTECT
	db 32, FLAREON,    SAND_ATTACK, QUICK_ATTACK, BITE, FIRE_SPIN
	db -1 ; end

	; COOLTRAINERM (11)
	db "BLAKE@", TRAINERTYPE_MOVES
	db 33, MAGNETON,   THUNDERBOLT, SUPERSONIC, SWIFT, SCREECH
	db 31, QUAGSIRE,   WATER_GUN, SLAM, AMNESIA, EARTHQUAKE
	db 31, EXEGGCUTE,  LEECH_SEED, CONFUSION, SLEEP_POWDER, SOLARBEAM
	db -1 ; end

	; COOLTRAINERM (12)
	db "BRIAN@", TRAINERTYPE_MOVES
	db 35, SANDSLASH,  SAND_ATTACK, POISON_STING, SLASH, SWIFT
	db -1 ; end

	; COOLTRAINERM (13)
	db "ERICK@", TRAINERTYPE_NORMAL
	db 10, BULBASAUR
	db 10, CHARMANDER
	db 10, SQUIRTLE
	db -1 ; end

	; COOLTRAINERM (14) = COOLTRAINERM_VIRIDIAN_1 (Yellow CoolTrainerMData 9)
	; Kanto hack (M10 13b): Crystal's unused ANDY row, taken over nameless.
	db "@", TRAINERTYPE_NORMAL
	db 39, SANDSLASH
	db 39, DUGTRIO
	db -1 ; end

	; COOLTRAINERM (15) = COOLTRAINERM_VIRIDIAN_2 (Yellow CoolTrainerMData 10)
	; Kanto hack (M10 13b): Crystal's unused TYLER row, taken over nameless.
	db "@", TRAINERTYPE_NORMAL
	db 43, RHYHORN
	db -1 ; end

	; COOLTRAINERM (16)
	db "SEAN@", TRAINERTYPE_NORMAL
	db 35, FLAREON
	db 35, TANGELA
	db 35, TAUROS
	db -1 ; end

	; COOLTRAINERM (17)
	db "KEVIN@", TRAINERTYPE_NORMAL
	db 38, RHYHORN
	db 35, CHARMELEON
	db 35, WARTORTLE
	db -1 ; end

	; COOLTRAINERM (18) = COOLTRAINERM_VIRIDIAN_3 (Yellow CoolTrainerMData 1)
	; Kanto hack (M10 13b): Crystal's unused STEVE row, taken over nameless.
	db "@", TRAINERTYPE_NORMAL
	db 39, NIDORINO
	db 39, NIDOKING
	db -1 ; end

	; COOLTRAINERM (19)
	db "ALLEN@", TRAINERTYPE_MOVES
	db 27, CHARMELEON, EMBER, SMOKESCREEN, RAGE, SCARY_FACE
	db -1 ; end

	; COOLTRAINERM (20)
	db "DARIN@", TRAINERTYPE_MOVES
	db 37, DRAGONAIR,  WRAP, SURF, DRAGON_RAGE, SLAM
	db -1 ; end

	; COOLTRAINERM (21) = COOLTRAINERM_VICTORY_ROAD_1: Kanto hack (M10 13g) VICTORY ROAD, 1F (3,2), Yellow CoolTrainerMData 5.
	; Appended nameless, as the 13b rows.
	db "@", TRAINERTYPE_NORMAL
	db 42, IVYSAUR
	db 42, WARTORTLE
	db 42, CHARMELEON
	db 42, CHARIZARD
	db -1 ; end

	; COOLTRAINERM (22) = COOLTRAINERM_VICTORY_ROAD_2: Kanto hack (M10 13g) VICTORY ROAD, 3F (28,5), Yellow CoolTrainerMData 2.
	; Appended nameless, as the 13b rows.
	db "@", TRAINERTYPE_NORMAL
	db 43, EXEGGUTOR
	db 43, CLOYSTER
	db 43, ARCANINE
	db -1 ; end

	; COOLTRAINERM (23) = COOLTRAINERM_VICTORY_ROAD_3: Kanto hack (M10 13g) VICTORY ROAD, 3F (6,14), Yellow CoolTrainerMData 3.
	; Appended nameless, as the 13b rows.
	db "@", TRAINERTYPE_NORMAL
	db 43, KINGLER
	db 43, TENTACRUEL
	db 43, BLASTOISE
	db -1 ; end

CooltrainerFGroup:
	; COOLTRAINERF (1)
	db "GWEN@", TRAINERTYPE_NORMAL
	db 26, EEVEE
	db 22, FLAREON
	db 22, VAPOREON
	db 22, JOLTEON
	db -1 ; end

	; COOLTRAINERF (2)
	db "LOIS@", TRAINERTYPE_MOVES
	db 25, SKIPLOOM,   SYNTHESIS, POISONPOWDER, MEGA_DRAIN, LEECH_SEED
	db 25, NINETALES,  EMBER, QUICK_ATTACK, CONFUSE_RAY, SAFEGUARD
	db -1 ; end

	; COOLTRAINERF (3)
	db "FRAN@", TRAINERTYPE_NORMAL
	db 37, SEADRA
	db -1 ; end

	; COOLTRAINERF (4)
	db "LOLA@", TRAINERTYPE_NORMAL
	db 34, DRATINI
	db 36, DRAGONAIR
	db -1 ; end

	; COOLTRAINERF (5)
	db "KATE@", TRAINERTYPE_NORMAL
	db 26, SHELLDER
	db 28, CLOYSTER
	db -1 ; end

	; COOLTRAINERF (6)
	db "IRENE@", TRAINERTYPE_NORMAL
	db 22, GOLDEEN
	db 24, SEAKING
	db -1 ; end

	; COOLTRAINERF (7)
	db "KELLY@", TRAINERTYPE_NORMAL
	db 27, MARILL
	db 24, WARTORTLE
	db 24, WARTORTLE
	db -1 ; end

	; COOLTRAINERF (8)
	db "JOYCE@", TRAINERTYPE_MOVES
	db 36, PIKACHU,    QUICK_ATTACK, DOUBLE_TEAM, THUNDERBOLT, THUNDER
	db 32, BLASTOISE,  BITE, CURSE, SURF, RAIN_DANCE
	db -1 ; end

	; COOLTRAINERF (9)
	db "BETH@", TRAINERTYPE_MOVES
	db 36, RAPIDASH,   STOMP, FIRE_SPIN, FURY_ATTACK, AGILITY
	db -1 ; end

	; COOLTRAINERF (10)
	db "REENA@", TRAINERTYPE_NORMAL
	db 31, STARMIE
	db 33, NIDOQUEEN
	db 31, STARMIE
	db -1 ; end

	; COOLTRAINERF (11)
	db "MEGAN@", TRAINERTYPE_MOVES
	db 32, BULBASAUR,  GROWL, LEECH_SEED, POISONPOWDER, RAZOR_LEAF
	db 32, IVYSAUR,    GROWL, LEECH_SEED, POISONPOWDER, RAZOR_LEAF
	db 32, VENUSAUR,   BODY_SLAM, SLEEP_POWDER, RAZOR_LEAF, SWEET_SCENT
	db -1 ; end

	; COOLTRAINERF (12)
	db "BETH@", TRAINERTYPE_MOVES
	db 39, RAPIDASH,   STOMP, FIRE_SPIN, FURY_ATTACK, AGILITY
	db -1 ; end

	; COOLTRAINERF (13)
	db "CAROL@", TRAINERTYPE_NORMAL
	db 35, ELECTRODE
	db 35, STARMIE
	db 35, NINETALES
	db -1 ; end

	; COOLTRAINERF (14)
	db "QUINN@", TRAINERTYPE_NORMAL
	db 38, IVYSAUR
	db 38, STARMIE
	db -1 ; end

	; COOLTRAINERF (15)
	db "EMMA@", TRAINERTYPE_NORMAL
	db 28, POLIWHIRL
	db -1 ; end

	; COOLTRAINERF (16)
	db "CYBIL@", TRAINERTYPE_MOVES
	db 25, BUTTERFREE, CONFUSION, SLEEP_POWDER, WHIRLWIND, GUST
	db 25, BELLOSSOM,  ABSORB, STUN_SPORE, ACID, SOLARBEAM
	db -1 ; end

	; COOLTRAINERF (17)
	db "JENN@", TRAINERTYPE_NORMAL
	db 24, STARYU
	db 26, STARMIE
	db -1 ; end

	; COOLTRAINERF (18)
	db "BETH@", TRAINERTYPE_ITEM_MOVES
	db 43, RAPIDASH,   FOCUS_BAND,   STOMP, FIRE_SPIN, FURY_ATTACK, FIRE_BLAST
	db -1 ; end

	; COOLTRAINERF (19)
	db "REENA@", TRAINERTYPE_NORMAL
	db 34, STARMIE
	db 36, NIDOQUEEN
	db 34, STARMIE
	db -1 ; end

	; COOLTRAINERF (20)
	db "REENA@", TRAINERTYPE_ITEM_MOVES
	db 38, STARMIE,    NO_ITEM,      DOUBLE_TEAM, PSYCHIC_M, WATERFALL, CONFUSE_RAY
	db 40, NIDOQUEEN,  PINK_BOW,     EARTHQUAKE, DOUBLE_KICK, TOXIC, BODY_SLAM
	db 38, STARMIE,    NO_ITEM,      BLIZZARD, PSYCHIC_M, WATERFALL, RECOVER
	db -1 ; end

	; COOLTRAINERF (21)
	db "CARA@", TRAINERTYPE_MOVES
	db 33, HORSEA,     SMOKESCREEN, LEER, WHIRLPOOL, TWISTER
	db 33, HORSEA,     SMOKESCREEN, LEER, WHIRLPOOL, TWISTER
	db 35, SEADRA,     SWIFT, LEER, WATERFALL, TWISTER
	db -1 ; end

	; COOLTRAINERF (22) - Kanto hack: CELADON GYM, Yellow's COOLTRAINER_F 1
	; (M6 9q).  Appended -- all 21 Crystal rows are live.
	db "IVY@", TRAINERTYPE_NORMAL
	db 24, WEEPINBELL
	db 24, GLOOM
	db 24, IVYSAUR
	db -1 ; end

	; COOLTRAINERF (23) = COOLTRAINERF_VICTORY_ROAD_1: Kanto hack (M10 13g) VICTORY ROAD, 1F (7,5), Yellow CoolTrainerFData 5.
	; Appended nameless, as the 13b rows.
	db "@", TRAINERTYPE_NORMAL
	db 44, PERSIAN
	db 44, NINETALES
	db -1 ; end

	; COOLTRAINERF (24) = COOLTRAINERF_VICTORY_ROAD_2: Kanto hack (M10 13g) VICTORY ROAD, 3F (7,13), Yellow CoolTrainerFData 2.
	; Appended nameless, as the 13b rows.
	db "@", TRAINERTYPE_NORMAL
	db 43, BELLSPROUT
	db 43, WEEPINBELL
	db 43, VICTREEBEL
	db -1 ; end

	; COOLTRAINERF (25) = COOLTRAINERF_VICTORY_ROAD_3: Kanto hack (M10 13g) VICTORY ROAD, 3F (13,3), Yellow CoolTrainerFData 3.
	; Appended nameless, as the 13b rows.
	db "@", TRAINERTYPE_NORMAL
	db 43, PARASECT
	db 43, DEWGONG
	db 43, CHANSEY
	db -1 ; end

BeautyGroup:
	; BEAUTY (1)
	db "VICTORIA@", TRAINERTYPE_NORMAL
	db  9, SENTRET
	db 13, SENTRET
	db 17, SENTRET
	db -1 ; end

	; BEAUTY (2)
	db "SAMANTHA@", TRAINERTYPE_MOVES
	db 16, MEOWTH,     SCRATCH, GROWL, BITE, PAY_DAY
	db 16, MEOWTH,     SCRATCH, GROWL, BITE, SLASH
	db -1 ; end

	; BEAUTY (3) -- Kanto hack (M7 10c): Yellow's ROUTE 13 BEAUTY 4
	; (db 27, RATTATA, VULPIX, RATTATA, 0).  Was JULIE, one of Crystal's own
	; "; unused" placeholder rows.  Nameless, so PlaceEnemysName prints "BEAUTY".
	db "@", TRAINERTYPE_NORMAL
	db 27, RATTATA
	db 27, VULPIX
	db 27, RATTATA
	db -1 ; end

	; BEAUTY (4) -- Kanto hack (M7 10c): Yellow's ROUTE 13 BEAUTY 5
	; (db 29, CLEFAIRY, MEOWTH, 0).  Was the unused JACLYN.
	db "@", TRAINERTYPE_NORMAL
	db 29, CLEFAIRY
	db 29, MEOWTH
	db -1 ; end

	; BEAUTY (5) = BEAUTY_3 -- Kanto hack (M7 10e): Yellow's ROUTE 15 BEAUTY 1,
	; OPP_BEAUTY 9 (db 29, PIDGEOTTO, WIGGLYTUFF, 0).  Was the unused BRENDA.
	db "@", TRAINERTYPE_NORMAL
	db 29, PIDGEOTTO
	db 29, WIGGLYTUFF
	db -1 ; end

	; BEAUTY (6)
	db "CASSIE@", TRAINERTYPE_NORMAL
	db 28, VILEPLUME
	db 34, BUTTERFREE
	db -1 ; end

	; BEAUTY (7) = BEAUTY_4 -- Kanto hack (M7 10e): Yellow's ROUTE 15 BEAUTY 2,
	; OPP_BEAUTY 10 (db 29, BULBASAUR, IVYSAUR, 0).  Was the unused CAROLINE.
	db "@", TRAINERTYPE_NORMAL
	db 29, BULBASAUR
	db 29, IVYSAUR
	db -1 ; end

	; BEAUTY (8)
	; = BEAUTY_5 -- Kanto hack (M9 12c): Yellow's ROUTE 19 SWIMMER5,
	; OPP_BEAUTY 12 (vendor/pokeyellow/data/trainers/parties.asm).
	db "@", TRAINERTYPE_NORMAL
	db 27, POLIWAG
	db 27, GOLDEEN
	db 27, SEAKING
	db 27, GOLDEEN
	db 27, POLIWAG
	db -1 ; end

	; BEAUTY (9)
	; = BEAUTY_6 -- Kanto hack (M9 12c): Yellow's ROUTE 19 SWIMMER6,
	; OPP_BEAUTY 13 (vendor/pokeyellow/data/trainers/parties.asm).
	db "@", TRAINERTYPE_NORMAL
	db 30, GOLDEEN
	db 30, SEAKING
	db -1 ; end

	; BEAUTY (10)
	; = BEAUTY_7 -- Kanto hack (M9 12c): Yellow's ROUTE 19 SWIMMER8,
	; OPP_BEAUTY 14 (vendor/pokeyellow/data/trainers/parties.asm).
	db "@", TRAINERTYPE_NORMAL
	db 29, STARYU
	db 29, STARYU
	db 29, STARYU
	db -1 ; end

	; BEAUTY (11)
	; = BEAUTY_8 -- Kanto hack (M9 12c): Yellow's ROUTE 20 SWIMMER2,
	; OPP_BEAUTY 15 (vendor/pokeyellow/data/trainers/parties.asm).
	db "@", TRAINERTYPE_NORMAL
	db 30, SEADRA
	db 30, HORSEA
	db 30, SEADRA
	db -1 ; end

	; BEAUTY (12)
	; = BEAUTY_9 -- Kanto hack (M9 12c): Yellow's ROUTE 20 SWIMMER3,
	; OPP_BEAUTY 6 (vendor/pokeyellow/data/trainers/parties.asm).
	db "@", TRAINERTYPE_NORMAL
	db 35, SEAKING
	db -1 ; end

	; BEAUTY (13) - Kanto hack: CELADON GYM, Yellow's BEAUTY 1 (M6 9q).
	; Renamed in place; VERONICA was one of Crystal's dead `db 15, SENTRET`
	; placeholder rows.
	db "LILY@", TRAINERTYPE_NORMAL
	db 21, ODDISH
	db 21, BELLSPROUT
	db 21, ODDISH
	db 21, BELLSPROUT
	db -1 ; end

	; BEAUTY (14) - Kanto hack: CELADON GYM, Yellow's BEAUTY 2 (M6 9q).  Kept
	; in place; JULIA was already Crystal's Celadon Gym beauty.
	db "JULIA@", TRAINERTYPE_NORMAL
	db 24, BELLSPROUT
	db 24, BELLSPROUT
	db -1 ; end

	; BEAUTY (15) - Kanto hack: CELADON GYM, Yellow's BEAUTY 3 (M6 9q).
	; Renamed in place; THERESA was another dead `db 15, SENTRET` row (9g had
	; already taken her event flag).
	db "POPPY@", TRAINERTYPE_NORMAL
	db 26, EXEGGCUTE
	db -1 ; end

	; BEAUTY (16)
	db "VALERIE@", TRAINERTYPE_MOVES
	db 17, HOPPIP,     SYNTHESIS, TAIL_WHIP, TACKLE, POISONPOWDER
	db 17, SKIPLOOM,   SYNTHESIS, TAIL_WHIP, TACKLE, STUN_SPORE
	db -1 ; end

	; BEAUTY (17)
	db "OLIVIA@", TRAINERTYPE_NORMAL
	db 19, CORSOLA
	db -1 ; end

	; BEAUTY (18) = BEAUTY_10 -- Kanto hack (M9 12c): Yellow's ROUTE 20 SWIMMER7,
	; OPP_BEAUTY 7.  Appended: the class had no dead rows left.
	db "@", TRAINERTYPE_NORMAL
	db 30, SHELLDER
	db 30, SHELLDER
	db 30, CLOYSTER
	db -1 ; end

	; BEAUTY (19) = BEAUTY_11 -- Kanto hack (M9 12c): Yellow's ROUTE 20 SWIMMER9,
	; OPP_BEAUTY 8.  Appended: the class had no dead rows left.
	db "@", TRAINERTYPE_NORMAL
	db 31, POLIWAG
	db 31, SEAKING
	db -1 ; end

PokemaniacGroup:
	; POKEMANIAC (1)
	db "LARRY@", TRAINERTYPE_NORMAL
	db 10, SLOWPOKE
	db -1 ; end

	; POKEMANIAC (2)
	db "ANDREW@", TRAINERTYPE_NORMAL
	db 24, MAROWAK
	db 24, MAROWAK
	db -1 ; end

	; POKEMANIAC (3)
	db "CALVIN@", TRAINERTYPE_NORMAL
	db 26, KANGASKHAN
	db -1 ; end

	; POKEMANIAC (4)
	db "SHANE@", TRAINERTYPE_NORMAL
	db 16, NIDORINA
	db 16, NIDORINO
	db -1 ; end

	; POKEMANIAC (5)
	db "BEN@", TRAINERTYPE_NORMAL
	db 19, SLOWBRO
	db -1 ; end

	; POKEMANIAC (6)
	db "BRENT@", TRAINERTYPE_NORMAL
	db 19, LICKITUNG
	db -1 ; end

	; POKEMANIAC (7)
	db "RON@", TRAINERTYPE_NORMAL
	db 19, NIDOKING
	db -1 ; end

	; POKEMANIAC (8)
	db "ETHAN@", TRAINERTYPE_NORMAL
	db 31, RHYHORN
	db 31, RHYDON
	db -1 ; end

	; POKEMANIAC (9)
	db "BRENT@", TRAINERTYPE_NORMAL
	db 25, KANGASKHAN
	db -1 ; end

	; POKEMANIAC (10)
	db "BRENT@", TRAINERTYPE_MOVES
	db 36, PORYGON,    RECOVER, PSYCHIC_M, CONVERSION2, TRI_ATTACK
	db -1 ; end

	; POKEMANIAC (11)
	db "ISSAC@", TRAINERTYPE_MOVES
	db 12, LICKITUNG,  LICK, SUPERSONIC, CUT, NO_MOVE
	db -1 ; end

	; POKEMANIAC (12)
	db "DONALD@", TRAINERTYPE_NORMAL
	db 10, SLOWPOKE
	db 10, SLOWPOKE
	db -1 ; end

	; POKEMANIAC (13)
	db "ZACH@", TRAINERTYPE_NORMAL
	db 27, RHYHORN
	db -1 ; end

	; POKEMANIAC (14)
	db "BRENT@", TRAINERTYPE_MOVES
	db 41, CHANSEY,    ROLLOUT, ATTRACT, EGG_BOMB, SOFTBOILED
	db -1 ; end

	; POKEMANIAC (15)
	db "MILLER@", TRAINERTYPE_NORMAL
	db 17, NIDOKING
	db 17, NIDOQUEEN
	db -1 ; end

	; POKEMANIAC (16) - Kanto hack: ROUTE 10, Yellow's POKEMANIAC 1 (docs/M5-LAVENDER.md 5.1)
	db "ORVILLE@", TRAINERTYPE_NORMAL
	db 30, RHYHORN
	db 30, LICKITUNG
	db -1 ; end

	; POKEMANIAC (17) - Kanto hack: ROUTE 10, Yellow's POKEMANIAC 2
	db "MELVIN@", TRAINERTYPE_NORMAL
	db 20, CUBONE
	db 20, SLOWPOKE
	db -1 ; end

	; POKEMANIAC (18) - Kanto hack: ROCK TUNNEL 1F, Yellow's POKEMANIAC 7 (M5 8e)
	db "JASPER@", TRAINERTYPE_NORMAL
	db 23, CUBONE
	db 23, SLOWPOKE
	db -1 ; end

	; POKEMANIAC (19) - Kanto hack: ROCK TUNNEL B1F, Yellow's POKEMANIAC 3 (M5 8f)
	db "CEDRIC@", TRAINERTYPE_NORMAL
	db 20, SLOWPOKE
	db 20, SLOWPOKE
	db 20, SLOWPOKE
	db -1 ; end

	; POKEMANIAC (20) - Kanto hack: ROCK TUNNEL B1F, Yellow's POKEMANIAC 4
	db "AMOS@", TRAINERTYPE_NORMAL
	db 22, CHARMANDER
	db 22, CUBONE
	db -1 ; end

	; POKEMANIAC (21) - Kanto hack: ROCK TUNNEL B1F, Yellow's POKEMANIAC 5
	db "WALDO@", TRAINERTYPE_NORMAL
	db 25, SLOWPOKE
	db -1 ; end

	; POKEMANIAC (22) = POKEMANIAC_VICTORY_ROAD: Kanto hack (M10 13g) VICTORY ROAD, 2F (4,2), Yellow PokemaniacData 6.
	; Appended nameless, as the 13b rows.
	db "@", TRAINERTYPE_NORMAL
	db 40, CHARMELEON
	db 40, LAPRAS
	db 40, LICKITUNG
	db -1 ; end

GruntMGroup:
	; GRUNTM (1)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 14, KOFFING
	db -1 ; end

	; GRUNTM (2)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db  7, RATTATA
	db  9, ZUBAT
	db  9, ZUBAT
	db -1 ; end

	; GRUNTM (3)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 24, RATICATE
	db 24, RATICATE
	db -1 ; end

	; GRUNTM (4)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 23, GRIMER
	db 23, GRIMER
	db 25, MUK
	db -1 ; end

	; GRUNTM (5)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 21, RATTATA
	db 21, RATTATA
	db 23, RATTATA
	db 23, RATTATA
	db 23, RATTATA
	db -1 ; end

	; GRUNTM (6)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 26, ZUBAT
	db 26, ZUBAT
	db -1 ; end

	; GRUNTM (7)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 23, KOFFING
	db 23, GRIMER
	db 23, ZUBAT
	db 23, RATTATA
	db -1 ; end

	; GRUNTM (8)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 26, WEEZING
	db -1 ; end

	; GRUNTM (9)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 24, RATICATE
	db 26, KOFFING
	db -1 ; end

	; GRUNTM (10)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 22, ZUBAT
	db 24, GOLBAT
	db 22, GRIMER
	db -1 ; end

	; GRUNTM (11)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 23, MUK
	db 23, KOFFING
	db 25, RATTATA
	db -1 ; end

	; GRUNTM (12) - Kanto hack: Mt. Moon B2F, Yellow's ROCKET 1 at (15,22)
	; (OPP_ROCKET party 2). Crystal never used this slot; rewritten in place.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 11, SANDSHREW
	db 11, RATTATA
	db 11, ZUBAT
	db -1 ; end

	; GRUNTM (13)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 27, RATTATA
	db -1 ; end

	; GRUNTM (14)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 24, RATICATE
	db 24, GOLBAT
	db -1 ; end

	; GRUNTM (15)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 26, GRIMER
	db 23, WEEZING
	db -1 ; end

	; GRUNTM (16)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 16, RATTATA
	db 16, RATTATA
	db 16, RATTATA
	db 16, RATTATA
	db -1 ; end

	; GRUNTM (17)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 18, GOLBAT
	db -1 ; end

	; GRUNTM (18)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 17, RATTATA
	db 17, ZUBAT
	db 17, RATTATA
	db -1 ; end

	; GRUNTM (19)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 18, VENONAT
	db 18, VENONAT
	db -1 ; end

	; GRUNTM (20)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 17, DROWZEE
	db 19, ZUBAT
	db -1 ; end

	; GRUNTM (21)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 16, ZUBAT
	db 17, GRIMER
	db 18, RATTATA
	db -1 ; end

	; GRUNTM (22) - Kanto hack: Mt. Moon B2F, Yellow's ROCKET 2 at (29,11)
	; (OPP_ROCKET party 3). Crystal never used this slot; rewritten in place.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 12, ZUBAT
	db 12, EKANS
	db -1 ; end

	; GRUNTM (23) - Kanto hack: Mt. Moon B2F, Yellow's ROCKET 3 at (29,17)
	; (OPP_ROCKET party 1). Crystal never used this slot; rewritten in place.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 13, RATTATA
	db 13, ZUBAT
	db -1 ; end

	; GRUNTM (24)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 25, KOFFING
	db 25, KOFFING
	db -1 ; end

	; GRUNTM (25)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 24, KOFFING
	db 24, MUK
	db -1 ; end

	; GRUNTM (26) - Kanto hack: Cerulean City, the Rocket thief who smashes his
	; way out of the trashed house (6c). Yellow's RocketData #5 (OPP_ROCKET, 5).
	; The slot was free again after 5h moved the Mt. Moon B2F stand-in to the
	; JESSIE_JAMES class; vanilla Crystal never used it.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 17, MACHOP
	db 17, DROWZEE
	db -1 ; end

	; GRUNTM (27) - Kanto hack: Nugget Bridge recruiter, Yellow's ROCKET 6
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 15, EKANS
	db 15, ZUBAT
	db -1 ; end

	; GRUNTM (28)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 19, RATICATE
	db -1 ; end

	; GRUNTM (29)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db  9, RATTATA
	db  9, RATTATA
	db -1 ; end

	; GRUNTM (30) - Kanto hack: CELADON GAME CORNER's poster guard, Yellow's
	; OPP_ROCKET party 7 (docs/M6-CELADON.md 5.2).  Was an unused Crystal row.
	; The name is "GRUNT", not "ROCKET": GSC always prints "<class> <name> wants
	; to battle!", so a "ROCKET" name on the ROCKET class stutters ("ROCKET
	; ROCKET wants to battle!").  Yellow just says "ROCKET wants to fight!" and
	; GSC cannot; "ROCKET GRUNT" is what the four shipped Kanto Rockets already
	; print (GRUNTM 12/22/23/26, docs/M3-CERULEAN.md 6c step 3).
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 20, RATICATE
	db 20, ZUBAT
	db -1 ; end

	; Kanto hack (M6 9x): the nine ROCKET HIDEOUT grunts, Yellow's RocketData
	; rows 8-15 and 18 (vendor/pokeyellow/data/trainers/parties.asm).  Row 31
	; was an unused Crystal row (db 30, GOLBAT); 32-39 are appends.

	; GRUNTM (31) - ROCKET HIDEOUT B1F, (26,8).  Yellow OPP_ROCKET 8.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 21, DROWZEE
	db 21, MACHOP
	db -1 ; end

	; GRUNTM (32) - ROCKET HIDEOUT B1F, (12,6).  Yellow OPP_ROCKET 9.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 21, RATICATE
	db 21, RATICATE
	db -1 ; end

	; GRUNTM (33) - ROCKET HIDEOUT B1F, (18,17).  Yellow OPP_ROCKET 10.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 20, GRIMER
	db 20, KOFFING
	db 20, KOFFING
	db -1 ; end

	; GRUNTM (34) - ROCKET HIDEOUT B1F, (15,25).  Yellow OPP_ROCKET 11.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 19, RATTATA
	db 19, RATICATE
	db 19, RATICATE
	db 19, RATTATA
	db -1 ; end

	; GRUNTM (35) - ROCKET HIDEOUT B1F, (28,18).  Yellow OPP_ROCKET 12.
	; Beating him opens the locked door at map tile (24,16).
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 22, GRIMER
	db 22, KOFFING
	db -1 ; end

	; GRUNTM (36) - ROCKET HIDEOUT B2F, (20,12).  Yellow OPP_ROCKET 13.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 17, ZUBAT
	db 17, KOFFING
	db 17, GRIMER
	db 17, ZUBAT
	db 17, RATICATE
	db -1 ; end

	; GRUNTM (37) - ROCKET HIDEOUT B3F, (10,22).  Yellow OPP_ROCKET 14.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 20, RATTATA
	db 20, RATICATE
	db 20, DROWZEE
	db -1 ; end

	; GRUNTM (38) - ROCKET HIDEOUT B3F, (26,12).  Yellow OPP_ROCKET 15.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 21, MACHOP
	db 21, MACHOP
	db -1 ; end

	; GRUNTM (39) - ROCKET HIDEOUT B4F, (11,2).  Yellow OPP_ROCKET 18.
	; Beating him drops the LIFT KEY.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 21, KOFFING
	db 21, ZUBAT
	db -1 ; end

	; GRUNTM (40) - Kanto hack (M8 11f): SILPH CO. 2F, (16,11).  Yellow
	; OPP_ROCKET 23.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 29, CUBONE
	db 29, ZUBAT
	db -1 ; end

	; GRUNTM (41) - SILPH CO. 2F, (24,7).  Yellow OPP_ROCKET 24.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 25, GOLBAT
	db 25, ZUBAT
	db 25, ZUBAT
	db 25, RATICATE
	db 25, ZUBAT
	db -1 ; end

	; GRUNTM (42) - SILPH CO. 3F, (20,7).  Yellow OPP_ROCKET 25.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 28, RATICATE
	db 28, HYPNO
	db 28, RATICATE
	db -1 ; end

	; GRUNTM (43) - SILPH CO. 4F, (9,14).  Yellow OPP_ROCKET 26.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 29, MACHOP
	db 29, DROWZEE
	db -1 ; end

	; GRUNTM (44) - SILPH CO. 4F, (26,10).  Yellow OPP_ROCKET 27.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 28, EKANS
	db 28, ZUBAT
	db 28, CUBONE
	db -1 ; end

	; GRUNTM (45) - SILPH CO. 5F, (8,16).  Yellow OPP_ROCKET 28.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 33, ARBOK
	db -1 ; end

	; GRUNTM (46) - SILPH CO. 5F, (28,4).  Yellow OPP_ROCKET 29.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 33, HYPNO
	db -1 ; end

	; GRUNTM (47) - Kanto hack (M8 11g): SILPH CO. 6F, (17,3).  Yellow
	; OPP_ROCKET 30.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 29, MACHOP
	db 29, MACHOKE
	db -1 ; end

	; GRUNTM (48) - SILPH CO. 6F, (14,15).  Yellow OPP_ROCKET 31.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 28, ZUBAT
	db 28, ZUBAT
	db 28, GOLBAT
	db -1 ; end

	; GRUNTM (49) - SILPH CO. 7F, (13,1).  Yellow OPP_ROCKET 32.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 26, RATICATE
	db 26, ARBOK
	db 26, KOFFING
	db 26, GOLBAT
	db -1 ; end

	; GRUNTM (50) - SILPH CO. 7F, (20,2).  Yellow OPP_ROCKET 33.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 29, CUBONE
	db 29, CUBONE
	db -1 ; end

	; GRUNTM (51) - SILPH CO. 7F, (19,14).  Yellow OPP_ROCKET 34.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 29, SANDSHREW
	db 29, SANDSLASH
	db -1 ; end

	; GRUNTM (52) - SILPH CO. 8F, (19,2).  Yellow OPP_ROCKET 35.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 26, RATICATE
	db 26, ZUBAT
	db 26, GOLBAT
	db 26, RATTATA
	db -1 ; end

	; GRUNTM (53) - SILPH CO. 8F, (12,15).  Yellow OPP_ROCKET 36.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 28, WEEZING
	db 28, GOLBAT
	db 28, KOFFING
	db -1 ; end

	; GRUNTM (54) - SILPH CO. 9F, (2,4).  Yellow OPP_ROCKET 37.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 28, DROWZEE
	db 28, GRIMER
	db 28, MACHOP
	db -1 ; end

	; GRUNTM (55) - SILPH CO. 9F, (13,16).  Yellow OPP_ROCKET 38.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 28, GOLBAT
	db 28, DROWZEE
	db 28, HYPNO
	db -1 ; end

	; GRUNTM (56) - SILPH CO. 10F, (1,9).  Yellow OPP_ROCKET 39.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 33, MACHOKE
	db -1 ; end

	; GRUNTM (57) - SILPH CO. 11F, (15,9).  Yellow OPP_ROCKET 40.
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 25, RATTATA
	db 25, RATTATA
	db 25, ZUBAT
	db 25, RATTATA
	db 25, EKANS
	db -1 ; end

GentlemanGroup:
	; GENTLEMAN (1)
	db "PRESTON@", TRAINERTYPE_NORMAL
	db 18, GROWLITHE
	db 18, GROWLITHE
	db -1 ; end

	; GENTLEMAN (2)
	db "EDWARD@", TRAINERTYPE_NORMAL
	db 33, PERSIAN
	db -1 ; end

	; GENTLEMAN (3) - Kanto hack: VERMILION GYM, Yellow's GENTLEMAN 3 (docs/M4-VERMILION.md 5.1)
	db "GREGORY@", TRAINERTYPE_NORMAL
	db 22, VOLTORB
	db 22, MAGNEMITE
	db -1 ; end

	; GENTLEMAN (4) - Kanto hack: ROUTE 11, Yellow's GAMBLER 1 (docs/M4-VERMILION.md 7l; was the unused VIRGIL)
	db "ARTHUR@", TRAINERTYPE_NORMAL
	db 18, POLIWAG
	db 18, HORSEA
	db -1 ; end

	; GENTLEMAN (5)
	db "ALFRED@", TRAINERTYPE_NORMAL
	db 20, NOCTOWL
	db -1 ; end

	; GENTLEMAN (6) - Kanto hack: S.S. ANNE 1F Rooms, Yellow's GENTLEMAN 1 (docs/M4-VERMILION.md 5.1)
	db "THEODORE@", TRAINERTYPE_NORMAL
	db 18, GROWLITHE
	db 18, GROWLITHE
	db -1 ; end

	; GENTLEMAN (7) - Kanto hack: S.S. ANNE 1F Rooms, Yellow's GENTLEMAN 2 (docs/M4-VERMILION.md 5.1)
	db "BARTON@", TRAINERTYPE_NORMAL
	db 19, NIDORAN_M
	db 19, NIDORAN_F
	db -1 ; end

	; GENTLEMAN (8) - Kanto hack: S.S. ANNE 2F Rooms, Yellow's GENTLEMAN 3 (docs/M4-VERMILION.md 5.1)
	db "CLIVE@", TRAINERTYPE_NORMAL
	db 22, VOLTORB
	db 22, MAGNEMITE
	db -1 ; end

	; GENTLEMAN (9) - Kanto hack: S.S. ANNE 2F Rooms, Yellow's GENTLEMAN 5 (docs/M4-VERMILION.md 5.1)
	db "HUBERT@", TRAINERTYPE_NORMAL
	db 17, GROWLITHE
	db 17, PONYTA
	db -1 ; end

	; GENTLEMAN (10) - Kanto hack: ROUTE 11, Yellow's GAMBLER 2 (docs/M4-VERMILION.md 7l)
	db "LEOPOLD@", TRAINERTYPE_NORMAL
	db 18, BELLSPROUT
	db 18, ODDISH
	db -1 ; end

	; GENTLEMAN (11) - Kanto hack: ROUTE 11, Yellow's GAMBLER 3 (docs/M4-VERMILION.md 7l)
	db "WINSTON@", TRAINERTYPE_NORMAL
	db 18, VOLTORB
	db 18, MAGNEMITE
	db -1 ; end

	; GENTLEMAN (12) - Kanto hack: ROUTE 11, Yellow's GAMBLER 4 (docs/M4-VERMILION.md 7l)
	db "HORACE@", TRAINERTYPE_NORMAL
	db 18, GROWLITHE
	db 18, VULPIX
	db -1 ; end

	; GENTLEMAN (13) - Kanto hack: ROUTE 8, Yellow's GAMBLER 5 (M5 8j).
	; Appended: the GENTLEMAN group has no dead slots left.
	db "ELTON@", TRAINERTYPE_NORMAL
	db 22, POLIWAG
	db 22, POLIWAG
	db 22, POLIWHIRL
	db -1 ; end

	; GENTLEMAN (14) - Kanto hack: ROUTE 8, Yellow's GAMBLER 7 (M5 8j).
	db "REUBEN@", TRAINERTYPE_NORMAL
	db 24, GROWLITHE
	db 24, VULPIX
	db -1 ; end

SkierGroup:
	; SKIER (1)
	db "ROXANNE@", TRAINERTYPE_NORMAL
	db 28, JYNX
	db -1 ; end

	; SKIER (2)
	db "CLARISSA@", TRAINERTYPE_NORMAL
	db 28, DEWGONG
	db -1 ; end

TeacherGroup:
	; TEACHER (1) -- unused (Kanto hack, M7 10e): COLETTE was one of Crystal's own
	; ROUTE 15 trainers, deleted by the Yellow re-cut.  The row is kept so the
	; class is not renumbered; it can be reclaimed in place by a later map.
	db "COLETTE@", TRAINERTYPE_NORMAL
	db 36, CLEFAIRY
	db -1 ; end

	; TEACHER (2) -- unused (Kanto hack, M7 10e): HILLARY was one of Crystal's own
	; ROUTE 15 trainers, deleted by the Yellow re-cut.  The row is kept so the
	; class is not renumbered; it can be reclaimed in place by a later map.
	db "HILLARY@", TRAINERTYPE_NORMAL
	db 32, AIPOM
	db 36, CUBONE
	db -1 ; end

	; TEACHER (3)
	db "SHIRLEY@", TRAINERTYPE_NORMAL
	db 35, JIGGLYPUFF
	db -1 ; end

SabrinaGroup:
	; SABRINA (1)
; Kanto hack (M8 11l, D79): Yellow's SABRINA -- SabrinaData in
; vendor/pokeyellow/data/trainers/parties.asm.  Yellow's $FF-prefixed row is a
; per-#MON level list with no custom moves, so it becomes a plain
; TRAINERTYPE_NORMAL row here (G9); ESPEON and the Gen 2 movesets are gone.
	db "SABRINA@", TRAINERTYPE_NORMAL
	db 50, ABRA
	db 50, KADABRA
	db 50, ALAKAZAM
	db -1 ; end

BugCatcherGroup:
	; BUG_CATCHER (1)
	db "DON@", TRAINERTYPE_NORMAL
	db  3, CATERPIE
	db  3, CATERPIE
	db -1 ; end

	; BUG_CATCHER (2)
	db "ROB@", TRAINERTYPE_NORMAL
	db 32, BEEDRILL
	db 32, BUTTERFREE
	db -1 ; end

	; BUG_CATCHER (3)
	db "ED@", TRAINERTYPE_NORMAL
	db 30, BEEDRILL
	db 30, BEEDRILL
	db 30, BEEDRILL
	db -1 ; end

	; BUG_CATCHER (4)
	db "WADE@", TRAINERTYPE_NORMAL
	db  2, CATERPIE
	db  2, CATERPIE
	db  3, WEEDLE
	db  2, CATERPIE
	db -1 ; end

	; BUG_CATCHER (5)
	db "BENNY@", TRAINERTYPE_NORMAL
	db  7, WEEDLE
	db  9, KAKUNA
	db 12, BEEDRILL
	db -1 ; end

	; BUG_CATCHER (6)
	db "AL@", TRAINERTYPE_NORMAL
	db 12, CATERPIE
	db 12, WEEDLE
	db -1 ; end

	; BUG_CATCHER (7)
	db "JOSH@", TRAINERTYPE_NORMAL
	db 13, PARAS
	db -1 ; end

	; BUG_CATCHER (8)
	db "ARNIE@", TRAINERTYPE_NORMAL
	db 15, VENONAT
	db -1 ; end

	; BUG_CATCHER (9)
	db "KEN@", TRAINERTYPE_NORMAL
	db 30, ARIADOS
	db 32, PINSIR
	db -1 ; end

	; BUG_CATCHER (10)
	db "WADE@", TRAINERTYPE_NORMAL
	db  9, METAPOD
	db  9, METAPOD
	db 10, KAKUNA
	db  9, METAPOD
	db -1 ; end

	; BUG_CATCHER (11)
	db "WADE@", TRAINERTYPE_NORMAL
	db 14, BUTTERFREE
	db 14, BUTTERFREE
	db 15, BEEDRILL
	db 14, BUTTERFREE
	db -1 ; end

	; BUG_CATCHER (12)
	db "DOUG@", TRAINERTYPE_NORMAL
	db 34, ARIADOS
	db -1 ; end

	; BUG_CATCHER (13)
	db "ARNIE@", TRAINERTYPE_NORMAL
	db 19, VENONAT
	db -1 ; end

	; BUG_CATCHER (14)
	db "ARNIE@", TRAINERTYPE_MOVES
	db 28, VENOMOTH,   DISABLE, SUPERSONIC, CONFUSION, LEECH_LIFE
	db -1 ; end

	; BUG_CATCHER (15)
	db "WADE@", TRAINERTYPE_MOVES
	db 24, BUTTERFREE, CONFUSION, POISONPOWDER, SUPERSONIC, WHIRLWIND
	db 24, BUTTERFREE, CONFUSION, STUN_SPORE, SUPERSONIC, WHIRLWIND
	db 25, BEEDRILL,   FURY_ATTACK, FOCUS_ENERGY, TWINEEDLE, RAGE
	db 24, BUTTERFREE, CONFUSION, SLEEP_POWDER, SUPERSONIC, WHIRLWIND
	db -1 ; end

	; BUG_CATCHER (16)
	db "WADE@", TRAINERTYPE_MOVES
	db 30, BUTTERFREE, CONFUSION, POISONPOWDER, SUPERSONIC, GUST
	db 30, BUTTERFREE, CONFUSION, STUN_SPORE, SUPERSONIC, GUST
	db 32, BEEDRILL,   FURY_ATTACK, PURSUIT, TWINEEDLE, DOUBLE_TEAM
	db 34, BUTTERFREE, PSYBEAM, SLEEP_POWDER, GUST, WHIRLWIND
	db -1 ; end

	; BUG_CATCHER (17)
	db "ARNIE@", TRAINERTYPE_MOVES
	db 36, VENOMOTH,   GUST, SUPERSONIC, PSYBEAM, LEECH_LIFE
	db -1 ; end

	; BUG_CATCHER (18)
	db "ARNIE@", TRAINERTYPE_MOVES
	db 40, VENOMOTH,   GUST, SUPERSONIC, PSYCHIC_M, TOXIC
	db -1 ; end

	; BUG_CATCHER (19)
	db "WAYNE@", TRAINERTYPE_NORMAL
	db  8, LEDYBA
	db 10, PARAS
	db -1 ; end

	; BUG_CATCHER (20) - Kanto hack: Viridian Forest, Yellow's BUG_CATCHER 1
	db "SAMMY@", TRAINERTYPE_NORMAL
	db  7, CATERPIE
	db  7, CATERPIE
	db -1 ; end

	; BUG_CATCHER (21) - Kanto hack: Viridian Forest, Yellow's BUG_CATCHER 2
	db "ELIJAH@", TRAINERTYPE_NORMAL
	db  6, METAPOD
	db  6, CATERPIE
	db  6, METAPOD
	db -1 ; end

	; BUG_CATCHER (22) - Kanto hack: Viridian Forest, Yellow's BUG_CATCHER 3
	db "ANTHONY@", TRAINERTYPE_NORMAL
	db 10, CATERPIE
	db -1 ; end

	; BUG_CATCHER (23) - Kanto hack: Viridian Forest, Yellow's BUG_CATCHER 15
	db "WESLEY@", TRAINERTYPE_NORMAL
	db  8, CATERPIE
	db  8, METAPOD
	db -1 ; end

	; BUG_CATCHER (24) - Kanto hack: Route 3, Yellow's BUG_CATCHER 4
	db "COLTON@", TRAINERTYPE_NORMAL
	db 10, CATERPIE
	db 10, WEEDLE
	db 10, CATERPIE
	db -1 ; end

	; BUG_CATCHER (25) - Kanto hack: Route 3, Yellow's BUG_CATCHER 5
	db "DION@", TRAINERTYPE_NORMAL
	db  9, WEEDLE
	db  9, KAKUNA
	db  9, CATERPIE
	db  9, METAPOD
	db -1 ; end

	; BUG_CATCHER (26) - Kanto hack: Route 3, Yellow's BUG_CATCHER 6
	db "BRETT@", TRAINERTYPE_NORMAL
	db 11, CATERPIE
	db 11, METAPOD
	db -1 ; end

	; BUG_CATCHER (27) - Kanto hack: Mt. Moon 1F, Yellow's BUG_CATCHER 7
	db "TRAVIS@", TRAINERTYPE_NORMAL
	db 11, WEEDLE
	db 11, KAKUNA
	db -1 ; end

	; BUG_CATCHER (28) - Kanto hack: Mt. Moon 1F, Yellow's BUG_CATCHER 8
	db "NEIL@", TRAINERTYPE_NORMAL
	db 10, CATERPIE
	db 10, METAPOD
	db 10, CATERPIE
	db -1 ; end

	; BUG_CATCHER (29) - Kanto hack: Nugget Bridge No. 1, Yellow's BUG_CATCHER 9
	db "MERLE@", TRAINERTYPE_NORMAL
	db 14, CATERPIE
	db 14, WEEDLE
	db -1 ; end

	; BUG_CATCHER (30) - Kanto hack: Route 6, Yellow's BUG_CATCHER 10 (docs/M4-VERMILION.md 5.1)
	db "LOGAN@", TRAINERTYPE_NORMAL
	db 16, WEEDLE
	db 16, CATERPIE
	db 16, WEEDLE
	db -1 ; end

	; BUG_CATCHER (31) - Kanto hack: Route 6, Yellow's BUG_CATCHER 11
	db "FELIX@", TRAINERTYPE_NORMAL
	db 20, BUTTERFREE
	db -1 ; end

	; BUG_CATCHER (32) - Kanto hack: ROUTE 9, Yellow's BUG_CATCHER 13 (docs/M5-LAVENDER.md 5.1)
	db "ELLIS@", TRAINERTYPE_NORMAL
	db 19, BEEDRILL
	db 19, BEEDRILL
	db -1 ; end

	; BUG_CATCHER (33) - Kanto hack: ROUTE 9, Yellow's BUG_CATCHER 14 (docs/M5-LAVENDER.md 5.1)
	db "MERV@", TRAINERTYPE_NORMAL
	db 20, CATERPIE
	db 20, WEEDLE
	db 20, VENONAT
	db -1 ; end

FisherGroup:
	; FISHER (1)
	db "JUSTIN@", TRAINERTYPE_NORMAL
	db  5, MAGIKARP
	db  5, MAGIKARP
	db 15, MAGIKARP
	db  5, MAGIKARP
	db -1 ; end

	; FISHER (2)
	db "RALPH@", TRAINERTYPE_NORMAL
	db 10, GOLDEEN
	db -1 ; end

	; FISHER (3)
	; = FISHER_1 -- Kanto hack (M9 12c): Yellow's ROUTE 21 FISHER1,
	; OPP_FISHER 7 (vendor/pokeyellow/data/trainers/parties.asm).
	db "@", TRAINERTYPE_NORMAL
	db 28, SEAKING
	db 28, GOLDEEN
	db 28, SEAKING
	db 28, SEAKING
	db -1 ; end

	; FISHER (4) - Kanto hack: ROUTE 12, Yellow's FISHER 3 (M5 8l).  Crystal's
	; own KYLE (L28 SEAKING / L31 POLIWHIRL / L31 SEAKING) was one of the four
	; Route 12 fishers 8l replaced; the name and flag are kept, the party is
	; Yellow's.
	db "KYLE@", TRAINERTYPE_NORMAL
	db 22, GOLDEEN
	db 22, POLIWAG
	db 22, GOLDEEN
	db -1 ; end

	; FISHER (5)
	db "HENRY@", TRAINERTYPE_NORMAL
	db  8, POLIWAG
	db  8, POLIWAG
	db -1 ; end

	; FISHER (6)
	db "MARVIN@", TRAINERTYPE_NORMAL
	db 10, MAGIKARP
	db 10, GYARADOS
	db 15, MAGIKARP
	db 15, GYARADOS
	db -1 ; end

	; FISHER (7)
	db "TULLY@", TRAINERTYPE_NORMAL
	db 18, QWILFISH
	db -1 ; end

	; FISHER (8)
	db "ANDRE@", TRAINERTYPE_NORMAL
	db 27, GYARADOS
	db -1 ; end

	; FISHER (9)
	db "RAYMOND@", TRAINERTYPE_NORMAL
	db 22, MAGIKARP
	db 22, MAGIKARP
	db 22, MAGIKARP
	db 22, MAGIKARP
	db -1 ; end

	; FISHER (10)
	db "WILTON@", TRAINERTYPE_NORMAL
	db 23, GOLDEEN
	db 23, GOLDEEN
	db 25, SEAKING
	db -1 ; end

	; FISHER (11)
	db "EDGAR@", TRAINERTYPE_MOVES
	db 25, REMORAID,   LOCK_ON, PSYBEAM, AURORA_BEAM, BUBBLEBEAM
	db 25, REMORAID,   LOCK_ON, PSYBEAM, AURORA_BEAM, BUBBLEBEAM
	db -1 ; end

	; FISHER (12)
	db "JONAH@", TRAINERTYPE_NORMAL
	db 25, SHELLDER
	db 29, OCTILLERY
	db 25, REMORAID
	db 29, CLOYSTER
	db -1 ; end

	; FISHER (13) - Kanto hack: ROUTE 12, Yellow's FISHER 4 (M5 8l)
	db "MARTIN@", TRAINERTYPE_NORMAL
	db 24, TENTACOOL
	db 24, GOLDEEN
	db -1 ; end

	; FISHER (14) - Kanto hack: ROUTE 12, Yellow's FISHER 5 (M5 8l)
	db "STEPHEN@", TRAINERTYPE_NORMAL
	db 27, GOLDEEN
	db -1 ; end

	; FISHER (15) - Kanto hack: ROUTE 12, Yellow's FISHER 6 (M5 8l)
	db "BARNEY@", TRAINERTYPE_NORMAL
	db 21, POLIWAG
	db 21, SHELLDER
	db 21, GOLDEEN
	db 21, HORSEA
	db -1 ; end

	; FISHER (16)
	db "RALPH@", TRAINERTYPE_NORMAL
	db 17, GOLDEEN
	db -1 ; end

	; FISHER (17)
	db "RALPH@", TRAINERTYPE_NORMAL
	db 17, QWILFISH
	db 19, GOLDEEN
	db -1 ; end

	; FISHER (18)
	db "TULLY@", TRAINERTYPE_NORMAL
	db 23, QWILFISH
	db -1 ; end

	; FISHER (19)
	db "TULLY@", TRAINERTYPE_NORMAL
	db 32, GOLDEEN
	db 32, GOLDEEN
	db 32, QWILFISH
	db -1 ; end

	; FISHER (20)
	db "WILTON@", TRAINERTYPE_NORMAL
	db 29, GOLDEEN
	db 29, GOLDEEN
	db 32, SEAKING
	db -1 ; end

	; FISHER (21)
	db "SCOTT@", TRAINERTYPE_NORMAL
	db 30, QWILFISH
	db 30, QWILFISH
	db 34, SEAKING
	db -1 ; end

	; FISHER (22)
	db "WILTON@", TRAINERTYPE_MOVES
	db 34, SEAKING,    SUPERSONIC, WATERFALL, FLAIL, FURY_ATTACK
	db 34, SEAKING,    SUPERSONIC, WATERFALL, FLAIL, FURY_ATTACK
	db 38, REMORAID,   PSYBEAM, AURORA_BEAM, BUBBLEBEAM, HYPER_BEAM
	db -1 ; end

	; FISHER (23)
	db "RALPH@", TRAINERTYPE_NORMAL
	db 30, QWILFISH
	db 32, GOLDEEN
	db -1 ; end

	; FISHER (24)
	db "RALPH@", TRAINERTYPE_MOVES
	db 35, QWILFISH,   TOXIC, MINIMIZE, SURF, PIN_MISSILE
	db 39, SEAKING,    ENDURE, FLAIL, FURY_ATTACK, WATERFALL
	db -1 ; end

	; FISHER (25)
	db "TULLY@", TRAINERTYPE_MOVES
	db 34, SEAKING,    SUPERSONIC, RAIN_DANCE, WATERFALL, FURY_ATTACK
	db 34, SEAKING,    SUPERSONIC, RAIN_DANCE, WATERFALL, FURY_ATTACK
	db 37, QWILFISH,   ROLLOUT, SURF, PIN_MISSILE, TAKE_DOWN
	db -1 ; end

	; FISHER (26) - Kanto hack: S.S. ANNE 2F Rooms, Yellow's FISHER 1 (docs/M4-VERMILION.md 5.1)
	db "DALTON@", TRAINERTYPE_NORMAL
	db 17, GOLDEEN
	db 17, TENTACOOL
	db 17, GOLDEEN
	db -1 ; end

	; FISHER (27) - Kanto hack: S.S. ANNE B1F Rooms, Yellow's FISHER 2 (docs/M4-VERMILION.md 5.1)
	db "PERCY@", TRAINERTYPE_NORMAL
	db 17, TENTACOOL
	db 17, STARYU
	db 17, SHELLDER
	db -1 ; end

	; FISHER (28) - Kanto hack: ROUTE 12, Yellow's FISHER 11 (M5 8l)
	db "ELWOOD@", TRAINERTYPE_NORMAL
	db 24, MAGIKARP
	db 24, MAGIKARP
	db -1 ; end

	; FISHER (28) = FISHER_2 -- Kanto hack (M9 12c): Yellow's ROUTE 21 FISHER2,
	; OPP_FISHER 9.  Appended: the class had no dead rows left.
	db "@", TRAINERTYPE_NORMAL
	db 27, MAGIKARP
	db 27, MAGIKARP
	db 27, MAGIKARP
	db 27, MAGIKARP
	db 27, MAGIKARP
	db 27, MAGIKARP
	db -1 ; end

	; FISHER (29) = FISHER_3 -- Kanto hack (M9 12c): Yellow's ROUTE 21 FISHER3,
	; OPP_FISHER 8.  Appended: the class had no dead rows left.
	db "@", TRAINERTYPE_NORMAL
	db 31, SHELLDER
	db 31, CLOYSTER
	db -1 ; end

	; FISHER (30) = FISHER_4 -- Kanto hack (M9 12c): Yellow's ROUTE 21 FISHER4,
	; OPP_FISHER 10.  Appended: the class had no dead rows left.
	db "@", TRAINERTYPE_NORMAL
	db 33, SEAKING
	db 33, GOLDEEN
	db -1 ; end

SwimmerMGroup:
	; SWIMMERM (1)
	; = SWIMMERM_1 -- Kanto hack (M9 12c): Yellow's ROUTE 19 COOLTRAINER_M1,
	; OPP_SWIMMER 2 (vendor/pokeyellow/data/trainers/parties.asm).
	db "@", TRAINERTYPE_NORMAL
	db 30, TENTACOOL
	db 30, SHELLDER
	db -1 ; end

	; SWIMMERM (2)
	db "SIMON@", TRAINERTYPE_NORMAL
	db 20, TENTACOOL
	db 20, TENTACOOL
	db -1 ; end

	; SWIMMERM (3)
	db "RANDALL@", TRAINERTYPE_NORMAL
	db 18, SHELLDER
	db 20, WARTORTLE
	db 18, SHELLDER
	db -1 ; end

	; SWIMMERM (4)
	db "CHARLIE@", TRAINERTYPE_NORMAL
	db 21, SHELLDER
	db 19, TENTACOOL
	db 19, TENTACRUEL
	db -1 ; end

	; SWIMMERM (5)
	db "GEORGE@", TRAINERTYPE_NORMAL
	db 16, TENTACOOL
	db 17, TENTACOOL
	db 16, TENTACOOL
	db 19, STARYU
	db 17, TENTACOOL
	db 19, REMORAID
	db -1 ; end

	; SWIMMERM (6)
	db "BERKE@", TRAINERTYPE_NORMAL
	db 23, QWILFISH
	db -1 ; end

	; SWIMMERM (7)
	db "KIRK@", TRAINERTYPE_NORMAL
	db 20, GYARADOS
	db 20, GYARADOS
	db -1 ; end

	; SWIMMERM (8)
	db "MATHEW@", TRAINERTYPE_NORMAL
	db 23, KRABBY
	db -1 ; end

	; SWIMMERM (9)
	; = SWIMMERM_2 -- Kanto hack (M9 12c): Yellow's ROUTE 19 COOLTRAINER_M2,
	; OPP_SWIMMER 3 (vendor/pokeyellow/data/trainers/parties.asm).
	db "@", TRAINERTYPE_NORMAL
	db 29, GOLDEEN
	db 29, HORSEA
	db 29, STARYU
	db -1 ; end

	; SWIMMERM (10)
	; = SWIMMERM_3 -- Kanto hack (M9 12c): Yellow's ROUTE 19 SWIMMER1,
	; OPP_SWIMMER 4 (vendor/pokeyellow/data/trainers/parties.asm).
	db "@", TRAINERTYPE_NORMAL
	db 30, POLIWAG
	db 30, POLIWHIRL
	db -1 ; end

	; SWIMMERM (11)
	; = SWIMMERM_4 -- Kanto hack (M9 12c): Yellow's ROUTE 19 SWIMMER2,
	; OPP_SWIMMER 5 (vendor/pokeyellow/data/trainers/parties.asm).
	db "@", TRAINERTYPE_NORMAL
	db 27, HORSEA
	db 27, TENTACOOL
	db 27, TENTACOOL
	db 27, GOLDEEN
	db -1 ; end

	; SWIMMERM (12)
	; = SWIMMERM_5 -- Kanto hack (M9 12c): Yellow's ROUTE 19 SWIMMER3,
	; OPP_SWIMMER 6 (vendor/pokeyellow/data/trainers/parties.asm).
	db "@", TRAINERTYPE_NORMAL
	db 29, GOLDEEN
	db 29, SHELLDER
	db 29, SEAKING
	db -1 ; end

	; SWIMMERM (13)
	; = SWIMMERM_6 -- Kanto hack (M9 12c): Yellow's ROUTE 19 SWIMMER4,
	; OPP_SWIMMER 7 (vendor/pokeyellow/data/trainers/parties.asm).
	db "@", TRAINERTYPE_NORMAL
	db 30, HORSEA
	db 30, HORSEA
	db -1 ; end

	; SWIMMERM (14)
	; = SWIMMERM_7 -- Kanto hack (M9 12c): Yellow's ROUTE 19 SWIMMER7,
	; OPP_SWIMMER 8 (vendor/pokeyellow/data/trainers/parties.asm).
	db "@", TRAINERTYPE_NORMAL
	db 27, TENTACOOL
	db 27, TENTACOOL
	db 27, STARYU
	db 27, HORSEA
	db 27, TENTACRUEL
	db -1 ; end

	; SWIMMERM (15)
	; = SWIMMERM_8 -- Kanto hack (M9 12c): Yellow's ROUTE 20 SWIMMER1,
	; OPP_SWIMMER 9 (vendor/pokeyellow/data/trainers/parties.asm).
	db "@", TRAINERTYPE_NORMAL
	db 31, SHELLDER
	db 31, CLOYSTER
	db -1 ; end

	; SWIMMERM (16)
	; = SWIMMERM_9 -- Kanto hack (M9 12c): Yellow's ROUTE 20 SWIMMER5,
	; OPP_SWIMMER 10 (vendor/pokeyellow/data/trainers/parties.asm).
	db "@", TRAINERTYPE_NORMAL
	db 35, STARYU
	db -1 ; end

	; SWIMMERM (17)
	; = SWIMMERM_10 -- Kanto hack (M9 12c): Yellow's ROUTE 20 SWIMMER6,
	; OPP_SWIMMER 11 (vendor/pokeyellow/data/trainers/parties.asm).
	db "@", TRAINERTYPE_NORMAL
	db 28, HORSEA
	db 28, HORSEA
	db 28, SEADRA
	db 28, HORSEA
	db -1 ; end

	; SWIMMERM (18)
	; = SWIMMERM_11 -- Kanto hack (M9 12c): Yellow's ROUTE 21 SWIMMER1,
	; OPP_SWIMMER 12 (vendor/pokeyellow/data/trainers/parties.asm).
	db "@", TRAINERTYPE_NORMAL
	db 33, SEADRA
	db 33, TENTACRUEL
	db -1 ; end

	; SWIMMERM (19)
	; = SWIMMERM_12 -- Kanto hack (M9 12c): Yellow's ROUTE 21 SWIMMER3,
	; OPP_SWIMMER 13 (vendor/pokeyellow/data/trainers/parties.asm).
	db "@", TRAINERTYPE_NORMAL
	db 37, STARMIE
	db -1 ; end

	; SWIMMERM (20)
	; = SWIMMERM_13 -- Kanto hack (M9 12c): Yellow's ROUTE 21 SWIMMER4,
	; OPP_SWIMMER 14 (vendor/pokeyellow/data/trainers/parties.asm).
	db "@", TRAINERTYPE_NORMAL
	db 33, STARYU
	db 33, WARTORTLE
	db -1 ; end

	; SWIMMERM (21)
	; Kanto hack: Yellow's CERULEAN GYM SWIMMER 1 (docs/M3-CERULEAN.md, 6e).
	; Re-uses Crystal's own gym swimmer slot, renamed PARKER -> LUIS.
	db "LUIS@", TRAINERTYPE_NORMAL
	db 16, HORSEA
	db 16, SHELLDER
	db -1 ; end

	; SWIMMERM (22) = SWIMMERM_14 -- Kanto hack (M9 12c): Yellow's ROUTE 21 SWIMMER5,
	; OPP_SWIMMER 15.  Appended: the class had no dead rows left.
	db "@", TRAINERTYPE_NORMAL
	db 32, POLIWHIRL
	db 32, TENTACOOL
	db 32, SEADRA
	db -1 ; end

SwimmerFGroup:
	; SWIMMERF (1)
	db "ELAINE@", TRAINERTYPE_NORMAL
	db 21, STARYU
	db -1 ; end

	; SWIMMERF (2)
	db "PAULA@", TRAINERTYPE_NORMAL
	db 19, STARYU
	db 19, SHELLDER
	db -1 ; end

	; SWIMMERF (3)
	db "KAYLEE@", TRAINERTYPE_NORMAL
	db 18, GOLDEEN
	db 20, GOLDEEN
	db 20, SEAKING
	db -1 ; end

	; SWIMMERF (4)
	db "SUSIE@", TRAINERTYPE_MOVES
	db 20, PSYDUCK,    SCRATCH, TAIL_WHIP, DISABLE, CONFUSION
	db 22, GOLDEEN,    PECK, TAIL_WHIP, SUPERSONIC, HORN_ATTACK
	db -1 ; end

	; SWIMMERF (5)
	db "DENISE@", TRAINERTYPE_NORMAL
	db 22, SEEL
	db -1 ; end

	; SWIMMERF (6)
	db "KARA@", TRAINERTYPE_NORMAL
	db 20, STARYU
	db 20, STARMIE
	db -1 ; end

	; SWIMMERF (7)
	db "WENDY@", TRAINERTYPE_MOVES
	db 21, HORSEA,     BUBBLE, SMOKESCREEN, LEER, WATER_GUN
	db 21, HORSEA,     DRAGON_RAGE, SMOKESCREEN, LEER, WATER_GUN
	db -1 ; end

	; SWIMMERF (8)
	db "LISA@", TRAINERTYPE_NORMAL
	db 28, JYNX
	db -1 ; end

	; SWIMMERF (9)
	db "JILL@", TRAINERTYPE_NORMAL
	db 28, DEWGONG
	db -1 ; end

	; SWIMMERF (10)
	db "MARY@", TRAINERTYPE_NORMAL
	db 20, SEAKING
	db -1 ; end

	; SWIMMERF (11)
	db "KATIE@", TRAINERTYPE_NORMAL
	db 33, DEWGONG
	db -1 ; end

	; SWIMMERF (12)
	db "DAWN@", TRAINERTYPE_NORMAL
	db 34, SEAKING
	db -1 ; end

	; SWIMMERF (13)
	db "TARA@", TRAINERTYPE_NORMAL
	db 20, SEAKING
	db -1 ; end

	; SWIMMERF (14)
	db "NICOLE@", TRAINERTYPE_NORMAL
	db 29, MARILL
	db 29, MARILL
	db 32, LAPRAS
	db -1 ; end

	; SWIMMERF (15)
	db "LORI@", TRAINERTYPE_NORMAL
	db 32, STARMIE
	db 32, STARMIE
	db -1 ; end

	; SWIMMERF (16)
	db "JODY@", TRAINERTYPE_NORMAL
	db 20, SEAKING
	db -1 ; end

	; SWIMMERF (17)
	db "NIKKI@", TRAINERTYPE_NORMAL
	db 28, SEEL
	db 28, SEEL
	db 28, SEEL
	db 28, DEWGONG
	db -1 ; end

; Kanto hack (6e): SWIMMERF (18) DIANA and (19) BRIANA -- Crystal's Cerulean Gym
; swimmers -- are gone with the rest of Crystal's gym.  They were the last two
; entries of the class, so no other SWIMMERF id moves.

SailorGroup:
	; SAILOR (1)
	db "EUGENE@", TRAINERTYPE_NORMAL
	db 17, POLIWHIRL
	db 17, RATICATE
	db 19, KRABBY
	db -1 ; end

	; SAILOR (2)
	db "HUEY@", TRAINERTYPE_NORMAL
	db 18, POLIWAG
	db 18, POLIWHIRL
	db -1 ; end

	; SAILOR (3)
	db "TERRELL@", TRAINERTYPE_NORMAL
	db 20, POLIWHIRL
	db -1 ; end

	; SAILOR (4)
	db "KENT@", TRAINERTYPE_MOVES
	db 18, KRABBY,     BUBBLE, LEER, VICEGRIP, HARDEN
	db 20, KRABBY,     BUBBLEBEAM, LEER, VICEGRIP, HARDEN
	db -1 ; end

	; SAILOR (5)
	db "ERNEST@", TRAINERTYPE_NORMAL
	db 18, MACHOP
	db 18, MACHOP
	db 18, POLIWHIRL
	db -1 ; end

	; SAILOR (6)
	db "JEFF@", TRAINERTYPE_NORMAL
	db 32, RATICATE
	db 32, RATICATE
	db -1 ; end

	; SAILOR (7)
	db "GARRETT@", TRAINERTYPE_NORMAL
	db 34, KINGLER
	db -1 ; end

	; SAILOR (8)
	db "KENNETH@", TRAINERTYPE_NORMAL
	db 28, MACHOP
	db 28, MACHOP
	db 28, POLIWRATH
	db 28, MACHOP
	db -1 ; end

	; SAILOR (9)
	db "STANLY@", TRAINERTYPE_NORMAL
	db 31, MACHOP
	db 33, MACHOKE
	db 26, PSYDUCK
	db -1 ; end

	; SAILOR (10)
	db "HARRY@", TRAINERTYPE_NORMAL
	db 19, WOOPER
	db -1 ; end

	; SAILOR (11)
	db "HUEY@", TRAINERTYPE_NORMAL
	db 28, POLIWHIRL
	db 28, POLIWHIRL
	db -1 ; end

	; SAILOR (12)
	db "HUEY@", TRAINERTYPE_NORMAL
	db 34, POLIWHIRL
	db 34, POLIWRATH
	db -1 ; end

	; SAILOR (13)
	db "HUEY@", TRAINERTYPE_MOVES
	db 38, POLITOED,   WHIRLPOOL, RAIN_DANCE, BODY_SLAM, PERISH_SONG
	db 38, POLIWRATH,  SURF, STRENGTH, ICE_PUNCH, SUBMISSION
	db -1 ; end

	; SAILOR (14) - Kanto hack: S.S. ANNE bow, Yellow's SAILOR 1 (docs/M4-VERMILION.md 5.1)
	db "MURDOCK@", TRAINERTYPE_NORMAL
	db 18, MACHOP
	db 18, SHELLDER
	db -1 ; end

	; SAILOR (15) - Kanto hack: S.S. ANNE bow, Yellow's SAILOR 2 (docs/M4-VERMILION.md 5.1)
	db "MURPHY@", TRAINERTYPE_NORMAL
	db 17, MACHOP
	db 17, TENTACOOL
	db -1 ; end

	; SAILOR (16) - Kanto hack: S.S. ANNE B1F Rooms, Yellow's SAILOR 3 (docs/M4-VERMILION.md 5.1)
	db "LEO@", TRAINERTYPE_NORMAL
	db 21, SHELLDER
	db -1 ; end

	; SAILOR (17) - Kanto hack: S.S. ANNE B1F Rooms, Yellow's SAILOR 4 (docs/M4-VERMILION.md 5.1)
	db "BRADY@", TRAINERTYPE_NORMAL
	db 17, HORSEA
	db 17, SHELLDER
	db 17, TENTACOOL
	db -1 ; end

	; SAILOR (18) - Kanto hack: S.S. ANNE B1F Rooms, Yellow's SAILOR 5 (docs/M4-VERMILION.md 5.1)
	db "FORREST@", TRAINERTYPE_NORMAL
	db 18, TENTACOOL
	db 18, STARYU
	db -1 ; end

	; SAILOR (19) - Kanto hack: S.S. ANNE B1F Rooms, Yellow's SAILOR 6 (docs/M4-VERMILION.md 5.1)
	db "SEAMUS@", TRAINERTYPE_NORMAL
	db 17, HORSEA
	db 17, HORSEA
	db 17, HORSEA
	db -1 ; end

	; SAILOR (20) - Kanto hack: S.S. ANNE B1F Rooms, Yellow's SAILOR 7 (docs/M4-VERMILION.md 5.1)
	db "SILAS@", TRAINERTYPE_NORMAL
	db 20, MACHOP
	db -1 ; end

	; SAILOR (21) - Kanto hack: VERMILION GYM, Yellow's SAILOR 8 (docs/M4-VERMILION.md 5.1)
	db "DEWEY@", TRAINERTYPE_NORMAL
	db 24, MAGNEMITE
	db -1 ; end

SuperNerdGroup:
	; SUPER_NERD (1)
	db "STAN@", TRAINERTYPE_NORMAL
	db 20, GRIMER
	db -1 ; end

	; SUPER_NERD (2)
	db "ERIC@", TRAINERTYPE_NORMAL
	db 11, GRIMER
	db 11, GRIMER
	db -1 ; end

	; SUPER_NERD (3) - Kanto hack: Mt. Moon 1F, Yellow's SUPER_NERD 1.
	; Crystal never used this slot; rewritten in place with Yellow's party.
	db "GREGG@", TRAINERTYPE_NORMAL
	db 11, MAGNEMITE
	db 11, VOLTORB
	db -1 ; end

	; SUPER_NERD (4) - Kanto hack: Mt. Moon B2F, Yellow's SUPER_NERD 2, the
	; fossil rival. Crystal never used this slot; rewritten in place.
	db "MIGUEL@", TRAINERTYPE_NORMAL
	db 12, GRIMER
	db 12, VOLTORB
	db 12, KOFFING
	db -1 ; end

	; SUPER_NERD (5) - Kanto hack: ROUTE 8, Yellow's SUPER_NERD 5.  Renamed in
	; place (M5 8j); DAVE was an unused Crystal slot.
	db "CLARK@", TRAINERTYPE_NORMAL
	db 26, KOFFING
	db -1 ; end

	; SUPER_NERD (6) - Kanto hack: ROUTE 8, Yellow's SUPER_NERD 3.  Crystal's
	; own SAM stood on ROUTE 8 too; party rewritten in place (M5 8j).
	db "SAM@", TRAINERTYPE_NORMAL
	db 20, VOLTORB
	db 20, KOFFING
	db 20, VOLTORB
	db 20, MAGNEMITE
	db -1 ; end

	; SUPER_NERD (7) - Kanto hack: ROUTE 8, Yellow's SUPER_NERD 4.  Crystal's
	; own TOM stood on ROUTE 8 too; party rewritten in place (M5 8j).
	db "TOM@", TRAINERTYPE_NORMAL
	db 22, GRIMER
	db 22, MUK
	db 22, GRIMER
	db -1 ; end

	; SUPER_NERD (8)
	db "PAT@", TRAINERTYPE_NORMAL
	db 36, PORYGON
	db -1 ; end

	; SUPER_NERD (9)
	db "SHAWN@", TRAINERTYPE_NORMAL
	db 31, MAGNEMITE
	db 33, MUK
	db 31, MAGNEMITE
	db -1 ; end

	; SUPER_NERD (10)
	db "TERU@", TRAINERTYPE_NORMAL
	db  7, MAGNEMITE
	db 11, VOLTORB
	db  7, MAGNEMITE
	db  9, MAGNEMITE
	db -1 ; end

	; SUPER_NERD (11)
	db "RUSS@", TRAINERTYPE_NORMAL
	db 27, MAGNEMITE
	db 27, MAGNEMITE
	db 27, MAGNEMITE
	db -1 ; end

	; SUPER_NERD (12)
	db "NORTON@", TRAINERTYPE_MOVES
	db 30, PORYGON,    CONVERSION, CONVERSION2, RECOVER, TRI_ATTACK
	db -1 ; end

	; SUPER_NERD (13)
	db "HUGH@", TRAINERTYPE_MOVES
	db 39, SEADRA,     SMOKESCREEN, TWISTER, SURF, WATERFALL
	db -1 ; end

	; SUPER_NERD (14)
	db "MARKUS@", TRAINERTYPE_MOVES
	db 19, SLOWPOKE,   CURSE, WATER_GUN, GROWL, STRENGTH
	db -1 ; end

	; SUPER_NERD (15) - Kanto hack (M9 12n): CINNABAR GYM (17,2), the one gym
	; trainer with no quiz gate.  Yellow SuperNerdData 9.  The four CINNABAR GYM
	; SUPER NERDs are appended and nameless (RUSS/NORTON are unused Crystal rows
	; but carry names Yellow's gym trainers never had).
	db "@", TRAINERTYPE_NORMAL
	db 36, VULPIX
	db 36, VULPIX
	db 36, NINETALES
	db -1 ; end

	; SUPER_NERD (16) - CINNABAR GYM (11,4), gate 2.  Yellow SuperNerdData 10.
	db "@", TRAINERTYPE_NORMAL
	db 34, PONYTA
	db 34, CHARMANDER
	db 34, VULPIX
	db 34, GROWLITHE
	db -1 ; end

	; SUPER_NERD (17) - CINNABAR GYM (11,14), gate 4.  Yellow SuperNerdData 11.
	db "@", TRAINERTYPE_NORMAL
	db 41, RAPIDASH
	db -1 ; end

	; SUPER_NERD (18) - CINNABAR GYM (3,8), gate 6.  Yellow SuperNerdData 12.
	db "@", TRAINERTYPE_NORMAL
	db 37, GROWLITHE
	db 37, VULPIX
	db -1 ; end

Rival2Group:
	; RIVAL2 (1)
	db "?@", TRAINERTYPE_MOVES
	db 41, SNEASEL,    QUICK_ATTACK, SCREECH, FAINT_ATTACK, FURY_CUTTER
	db 42, GOLBAT,     LEECH_LIFE, BITE, CONFUSE_RAY, WING_ATTACK
	db 41, MAGNETON,   THUNDERSHOCK, SONICBOOM, THUNDER_WAVE, SWIFT
	db 43, GENGAR,     MEAN_LOOK, CURSE, SHADOW_BALL, CONFUSE_RAY
	db 43, ALAKAZAM,   DISABLE, RECOVER, FUTURE_SIGHT, PSYCHIC_M
	db 45, MEGANIUM,   RAZOR_LEAF, POISONPOWDER, BODY_SLAM, LIGHT_SCREEN
	db -1 ; end

	; RIVAL2 (2)
	db "?@", TRAINERTYPE_MOVES
	db 41, SNEASEL,    QUICK_ATTACK, SCREECH, FAINT_ATTACK, FURY_CUTTER
	db 42, GOLBAT,     LEECH_LIFE, BITE, CONFUSE_RAY, WING_ATTACK
	db 41, MAGNETON,   THUNDERSHOCK, SONICBOOM, THUNDER_WAVE, SWIFT
	db 43, GENGAR,     MEAN_LOOK, CURSE, SHADOW_BALL, CONFUSE_RAY
	db 43, ALAKAZAM,   DISABLE, RECOVER, FUTURE_SIGHT, PSYCHIC_M
	db 45, TYPHLOSION, SMOKESCREEN, QUICK_ATTACK, FLAME_WHEEL, SWIFT
	db -1 ; end

	; RIVAL2 (3)
	db "?@", TRAINERTYPE_MOVES
	db 41, SNEASEL,    QUICK_ATTACK, SCREECH, FAINT_ATTACK, FURY_CUTTER
	db 42, GOLBAT,     LEECH_LIFE, BITE, CONFUSE_RAY, WING_ATTACK
	db 41, MAGNETON,   THUNDERSHOCK, SONICBOOM, THUNDER_WAVE, SWIFT
	db 43, GENGAR,     MEAN_LOOK, CURSE, SHADOW_BALL, CONFUSE_RAY
	db 43, ALAKAZAM,   DISABLE, RECOVER, FUTURE_SIGHT, PSYCHIC_M
	db 45, FERALIGATR, RAGE, WATER_GUN, SCARY_FACE, SLASH
	db -1 ; end

	; RIVAL2 (4)
	db "?@", TRAINERTYPE_MOVES
	db 45, SNEASEL,    QUICK_ATTACK, SCREECH, FAINT_ATTACK, FURY_CUTTER
	db 48, CROBAT,     TOXIC, BITE, CONFUSE_RAY, WING_ATTACK
	db 45, MAGNETON,   THUNDER, SONICBOOM, THUNDER_WAVE, SWIFT
	db 46, GENGAR,     MEAN_LOOK, CURSE, SHADOW_BALL, CONFUSE_RAY
	db 46, ALAKAZAM,   RECOVER, FUTURE_SIGHT, PSYCHIC_M, REFLECT
	db 50, MEGANIUM,   GIGA_DRAIN, BODY_SLAM, LIGHT_SCREEN, SAFEGUARD
	db -1 ; end

	; RIVAL2 (5)
	db "?@", TRAINERTYPE_MOVES
	db 45, SNEASEL,    QUICK_ATTACK, SCREECH, FAINT_ATTACK, FURY_CUTTER
	db 48, CROBAT,     TOXIC, BITE, CONFUSE_RAY, WING_ATTACK
	db 45, MAGNETON,   THUNDER, SONICBOOM, THUNDER_WAVE, SWIFT
	db 46, GENGAR,     MEAN_LOOK, CURSE, SHADOW_BALL, CONFUSE_RAY
	db 46, ALAKAZAM,   RECOVER, FUTURE_SIGHT, PSYCHIC_M, REFLECT
	db 50, TYPHLOSION, SMOKESCREEN, QUICK_ATTACK, FIRE_BLAST, SWIFT
	db -1 ; end

	; RIVAL2 (6)
	db "?@", TRAINERTYPE_MOVES
	db 45, SNEASEL,    QUICK_ATTACK, SCREECH, FAINT_ATTACK, FURY_CUTTER
	db 48, CROBAT,     TOXIC, BITE, CONFUSE_RAY, WING_ATTACK
	db 45, MAGNETON,   THUNDER, SONICBOOM, THUNDER_WAVE, SWIFT
	db 46, GENGAR,     MEAN_LOOK, CURSE, SHADOW_BALL, CONFUSE_RAY
	db 46, ALAKAZAM,   RECOVER, FUTURE_SIGHT, PSYCHIC_M, REFLECT
	db 50, FERALIGATR, SURF, RAIN_DANCE, SLASH, SCREECH
	db -1 ; end

GuitaristGroup:
	; GUITARIST (1)
	db "CLYDE@", TRAINERTYPE_NORMAL
	db 34, ELECTABUZZ
	db -1 ; end

	; GUITARIST (2) - Kanto hack: VERMILION GYM, Yellow's ROCKER 1 (docs/M4-VERMILION.md 5.1).
	; Crystal has no ROCKER class; GUITARIST is its descendant.
	db "VINCENT@", TRAINERTYPE_NORMAL
	db 20, VOLTORB
	db 20, VOLTORB
	db 20, VOLTORB
	db -1 ; end

	; GUITARIST (3) - Kanto hack: ROUTE 12, Yellow's ROCKER 2 (M5 8l).
	; Same class substitution as VINCENT above: Crystal has no ROCKER.
	db "SPARKY@", TRAINERTYPE_NORMAL
	db 29, VOLTORB
	db 29, ELECTRODE
	db -1 ; end

HikerGroup:
	; HIKER (1)
	db "ANTHONY@", TRAINERTYPE_NORMAL
	db 16, GEODUDE
	db 18, MACHAMP
	db -1 ; end

	; HIKER (2)
	db "RUSSELL@", TRAINERTYPE_NORMAL
	db  4, GEODUDE
	db  6, GEODUDE
	db  8, GEODUDE
	db -1 ; end

	; HIKER (3)
	db "PHILLIP@", TRAINERTYPE_NORMAL
	db 23, GEODUDE
	db 23, GEODUDE
	db 23, GRAVELER
	db -1 ; end

	; HIKER (4)
	db "LEONARD@", TRAINERTYPE_NORMAL
	db 23, GEODUDE
	db 25, MACHOP
	db -1 ; end

	; HIKER (5)
	db "ANTHONY@", TRAINERTYPE_NORMAL
	db 11, GEODUDE
	db 11, MACHOP
	db -1 ; end

	; HIKER (6)
	db "BENJAMIN@", TRAINERTYPE_NORMAL
	db 14, DIGLETT
	db 14, GEODUDE
	db 16, DUGTRIO
	db -1 ; end

	; HIKER (7)
	db "ERIK@", TRAINERTYPE_NORMAL
	db 24, MACHOP
	db 27, GRAVELER
	db 27, MACHOP
	db -1 ; end

	; HIKER (8)
	db "MICHAEL@", TRAINERTYPE_NORMAL
	db 25, GEODUDE
	db 25, GRAVELER
	db 25, GOLEM
	db -1 ; end

	; HIKER (9)
	db "PARRY@", TRAINERTYPE_NORMAL
	db 35, ONIX
	db 33, SWINUB
	db -1 ; end

	; HIKER (10)
	db "TIMOTHY@", TRAINERTYPE_MOVES
	db 27, DIGLETT,    MAGNITUDE, DIG, SAND_ATTACK, SLASH
	db 27, DUGTRIO,    MAGNITUDE, DIG, SAND_ATTACK, SLASH
	db -1 ; end

	; HIKER (11)
	db "BAILEY@", TRAINERTYPE_NORMAL
	db 13, GEODUDE
	db 13, GEODUDE
	db 13, GEODUDE
	db 13, GEODUDE
	db 13, GEODUDE
	db -1 ; end

	; HIKER (12)
	db "ANTHONY@", TRAINERTYPE_NORMAL
	db 25, GRAVELER
	db 27, GRAVELER
	db 29, MACHOKE
	db -1 ; end

	; HIKER (13) - Kanto hack: ROUTE 9, Yellow's HIKER 11 (docs/M5-LAVENDER.md 5.1)
	db "TIM@", TRAINERTYPE_NORMAL
	db 20, MACHOP
	db 20, ONIX
	db -1 ; end

	; HIKER (14)
	db "NOLAND@", TRAINERTYPE_NORMAL
	db 31, SANDSLASH
	db 33, GOLEM
	db -1 ; end

	; HIKER (15) - Kanto hack: ROUTE 9, Yellow's HIKER 6 (docs/M5-LAVENDER.md 5.1)
	db "SIDNEY@", TRAINERTYPE_NORMAL
	db 20, GEODUDE
	db 20, MACHOP
	db 20, GEODUDE
	db -1 ; end

	; HIKER (16) -- unused (Kanto hack, M7 10c): KENNY was Crystal's ROUTE 13
	; HIKER, deleted by 10c (Yellow has no HIKER on ROUTE 13).  The row has to
	; stay so HIKER (17) JIM and everything after it keep their ids, but its
	; party is cut to a one-#MON placeholder, the shape Crystal's own dead rows
	; have (D49).
	db "KENNY@", TRAINERTYPE_NORMAL
	db 27, SANDSLASH
	db -1 ; end

	; HIKER (17) - Kanto hack: ROUTE 10, Yellow's HIKER 7 (docs/M5-LAVENDER.md 5.1, 5.3)
	db "JIM@", TRAINERTYPE_NORMAL
	db 21, GEODUDE
	db 21, ONIX
	db -1 ; end

	; HIKER (18)
	db "DANIEL@", TRAINERTYPE_NORMAL
	db 11, ONIX
	db -1 ; end

	; HIKER (19)
	db "PARRY@", TRAINERTYPE_MOVES
	db 35, PILOSWINE,  EARTHQUAKE, BLIZZARD, REST, TAKE_DOWN
	db 35, DUGTRIO,    MAGNITUDE, DIG, MUD_SLAP, SLASH
	db 38, STEELIX,    DIG, IRON_TAIL, SANDSTORM, SLAM
	db -1 ; end

	; HIKER (20)
	db "PARRY@", TRAINERTYPE_NORMAL
	db 29, ONIX
	db -1 ; end

	; HIKER (21)
	db "ANTHONY@", TRAINERTYPE_NORMAL
	db 30, GRAVELER
	db 30, GRAVELER
	db 32, MACHOKE
	db -1 ; end

	; HIKER (22)
	db "ANTHONY@", TRAINERTYPE_MOVES
	db 34, GRAVELER,   MAGNITUDE, SELFDESTRUCT, DEFENSE_CURL, ROLLOUT
	db 36, GOLEM,      MAGNITUDE, SELFDESTRUCT, DEFENSE_CURL, ROLLOUT
	db 34, MACHOKE,    KARATE_CHOP, VITAL_THROW, HEADBUTT, DIG
	db -1 ; end

	; HIKER (23) - Kanto hack: Mt. Moon 1F, Yellow's HIKER 1
	db "MARCOS@", TRAINERTYPE_NORMAL
	db 10, GEODUDE
	db 10, GEODUDE
	db 10, ONIX
	db -1 ; end

	; HIKER (24) - Kanto hack: Route 25, Yellow's HIKER 2
	db "GRAHAM@", TRAINERTYPE_NORMAL
	db 15, MACHOP
	db 15, GEODUDE
	db -1 ; end

	; HIKER (25) - Kanto hack: Route 25, Yellow's HIKER 3
	db "ARCHIE@", TRAINERTYPE_NORMAL
	db 13, GEODUDE
	db 13, GEODUDE
	db 13, MACHOP
	db 13, GEODUDE
	db -1 ; end

	; HIKER (26) - Kanto hack: Route 25, Yellow's HIKER 4
	db "MORTON@", TRAINERTYPE_NORMAL
	db 17, ONIX
	db -1 ; end

	; HIKER (27) - Kanto hack: ROUTE 9, Yellow's HIKER 5 (docs/M5-LAVENDER.md 5.1)
	db "LAMONT@", TRAINERTYPE_NORMAL
	db 21, GEODUDE
	db 21, ONIX
	db -1 ; end

	; HIKER (28) - Kanto hack: ROUTE 10, Yellow's HIKER 8 (docs/M5-LAVENDER.md 5.1)
	db "ODELL@", TRAINERTYPE_NORMAL
	db 19, ONIX
	db 19, GRAVELER
	db -1 ; end

	; HIKER (29) - Kanto hack: ROCK TUNNEL 1F, Yellow's HIKER 12 (M5 8e)
	db "ROSCOE@", TRAINERTYPE_NORMAL
	db 19, GEODUDE
	db 19, MACHOP
	db 19, GEODUDE
	db 19, GEODUDE
	db -1 ; end

	; HIKER (30) - Kanto hack: ROCK TUNNEL 1F, Yellow's HIKER 13
	db "WILBUR@", TRAINERTYPE_NORMAL
	db 20, ONIX
	db 20, ONIX
	db 20, GEODUDE
	db -1 ; end

	; HIKER (31) - Kanto hack: ROCK TUNNEL 1F, Yellow's HIKER 14
	db "NORRIS@", TRAINERTYPE_NORMAL
	db 21, GEODUDE
	db 21, GRAVELER
	db -1 ; end

	; HIKER (32) - Kanto hack: ROCK TUNNEL B1F, Yellow's HIKER 9 (M5 8f)
	db "LOWELL@", TRAINERTYPE_NORMAL
	db 21, GEODUDE
	db 21, GEODUDE
	db 21, GRAVELER
	db -1 ; end

	; HIKER (33) - Kanto hack: ROCK TUNNEL B1F, Yellow's HIKER 10
	db "VERNON@", TRAINERTYPE_NORMAL
	db 25, GEODUDE
	db -1 ; end

	; HIKER (34) - Kanto hack: ROCK TUNNEL B1F, Yellow's HIKER 11.  Yellow reuses
	; this one party for both ROUTE 9's hiker (our TIM) and B1F's; the duplicate
	; is deliberate.
	db "CONRAD@", TRAINERTYPE_NORMAL
	db 20, MACHOP
	db 20, ONIX
	db -1 ; end

BikerGroup:
	; BIKER (1) -- Kanto hack (M6 9y): Yellow's ROUTE 16 BIKER 5
	; (db 29, GRIMER, KOFFING, 0).  Nameless, so PlaceEnemysName prints "BIKER".
	db "@", TRAINERTYPE_NORMAL
	db 29, GRIMER
	db 29, KOFFING
	db -1 ; end

	; BIKER (2) -- Kanto hack (M6 9y): Yellow's ROUTE 16 BIKER 6
	db "@", TRAINERTYPE_NORMAL
	db 33, WEEZING
	db -1 ; end

	; BIKER (4) -- Kanto hack (M6 9z): Yellow's ROUTE 17 BIKER 3, OPP_BIKER 8
	; (db 28, WEEZING, KOFFING, WEEZING, 0).  Was Crystal's DWAYNE.
	db "@", TRAINERTYPE_NORMAL
	db 28, WEEZING
	db 28, KOFFING
	db 28, WEEZING
	db -1 ; end

	; BIKER (5) -- Kanto hack (M6 9z): Yellow's ROUTE 17 BIKER 4, OPP_BIKER 9
	db "@", TRAINERTYPE_NORMAL
	db 33, MUK
	db -1 ; end

	; BIKER (6) -- Kanto hack (M6 9z): Yellow's ROUTE 17 BIKER 5, OPP_BIKER 10
	db "@", TRAINERTYPE_NORMAL
	db 29, VOLTORB
	db 29, VOLTORB
	db -1 ; end

	; BIKER (7) -- Kanto hack (M6 9z): Yellow's ROUTE 17 BIKER 9, OPP_BIKER 11
	db "@", TRAINERTYPE_NORMAL
	db 29, WEEZING
	db 29, MUK
	db -1 ; end

	; BIKER (8) -- Kanto hack (M6 9z): Yellow's ROUTE 17 BIKER 10, OPP_BIKER 12
	db "@", TRAINERTYPE_NORMAL
	db 25, KOFFING
	db 25, WEEZING
	db 25, KOFFING
	db 25, KOFFING
	db 25, WEEZING
	db -1 ; end

	; BIKER (BIKER_9) -- Kanto hack (M7 10c): Yellow's ROUTE 13 BIKER 1, OPP_BIKER 1
	; (db 28, KOFFING, KOFFING, KOFFING, 0).  Was JOEL, dead since M6 9z.
	db "@", TRAINERTYPE_NORMAL
	db 28, KOFFING
	db 28, KOFFING
	db 28, KOFFING
	db -1 ; end

	; BIKER (BIKER_10) -- Kanto hack (M7 10d): Yellow's ROUTE 14 BIKER 1, OPP_BIKER 13
	; (db 26, KOFFING, KOFFING, GRIMER, KOFFING, 0).  Was GLENN, dead since M6 9z.
	db "@", TRAINERTYPE_NORMAL
	db 26, KOFFING
	db 26, KOFFING
	db 26, GRIMER
	db 26, KOFFING
	db -1 ; end

	; BIKER (10) -- Kanto hack (M6 9y): Yellow's ROUTE 16 BIKER 7
	db "@", TRAINERTYPE_NORMAL
	db 26, GRIMER
	db 26, GRIMER
	db 26, GRIMER
	db 26, GRIMER
	db -1 ; end

	; BIKER (BIKER_11) -- Kanto hack (M7 10d): Yellow's ROUTE 14 BIKER 2, OPP_BIKER 14
	; (db 28, GRIMER, GRIMER, KOFFING, 0).  GLENN's row was the class's last dead
	; one, so this row and the two below are appended.
	db "@", TRAINERTYPE_NORMAL
	db 28, GRIMER
	db 28, GRIMER
	db 28, KOFFING
	db -1 ; end

	; BIKER (BIKER_12) -- Kanto hack (M7 10d): Yellow's ROUTE 14 BIKER 3, OPP_BIKER 15
	; (db 29, KOFFING, MUK, 0).
	db "@", TRAINERTYPE_NORMAL
	db 29, KOFFING
	db 29, MUK
	db -1 ; end

	; BIKER (BIKER_13) -- Kanto hack (M7 10d): Yellow's ROUTE 14 BIKER 4, OPP_BIKER 2
	; (db 29, KOFFING, GRIMER, 0).
	db "@", TRAINERTYPE_NORMAL
	db 29, KOFFING
	db 29, GRIMER
	db -1 ; end

	; BIKER (BIKER_14) -- Kanto hack (M7 10e): Yellow's ROUTE 15 BIKER 1, OPP_BIKER 3
	; (db 25, KOFFING, KOFFING, WEEZING, KOFFING, GRIMER, 0).  Appended.
	db "@", TRAINERTYPE_NORMAL
	db 25, KOFFING
	db 25, KOFFING
	db 25, WEEZING
	db 25, KOFFING
	db 25, GRIMER
	db -1 ; end

	; BIKER (BIKER_15) -- Kanto hack (M7 10e): Yellow's ROUTE 15 BIKER 2, OPP_BIKER 4
	; (db 28, KOFFING, GRIMER, WEEZING, 0).
	db "@", TRAINERTYPE_NORMAL
	db 28, KOFFING
	db 28, GRIMER
	db 28, WEEZING
	db -1 ; end

BlaineGroup:
	; BLAINE (1) - Kanto hack (M9 12n): Yellow's BlaineData, L48 NINETALES /
	; L50 RAPIDASH / L54 ARCANINE (was Crystal's MAGCARGO / MAGMAR / RAPIDASH).
	; The moves are what Yellow's ReadTrainer actually hands him: the Gen 1
	; level-up moveset at that level (WriteMonMoves), then Yellow's
	; SpecialTrainerMoves overrides for BLAINE 1
	; (vendor/pokeyellow/data/trainers/special_moves.asm): NINETALES slot 1
	; FLAMETHROWER + slot 4 CONFUSE_RAY, ARCANINE slots 1-3 FLAMETHROWER /
	; FIRE_BLAST / REFLECT.  RAPIDASH has no override.
	db "BLAINE@", TRAINERTYPE_MOVES
	db 48, NINETALES,  FLAMETHROWER, TAIL_WHIP, QUICK_ATTACK, CONFUSE_RAY
	db 50, RAPIDASH,   STOMP, GROWL, FIRE_SPIN, TAKE_DOWN
	db 54, ARCANINE,   FLAMETHROWER, FIRE_BLAST, REFLECT, TAKE_DOWN
	db -1 ; end

BurglarGroup:
	; BURGLAR (1)
	db "DUNCAN@", TRAINERTYPE_NORMAL
	db 23, KOFFING
	db 25, MAGMAR
	db 23, KOFFING
	db -1 ; end

	; BURGLAR (2)
	db "EDDIE@", TRAINERTYPE_MOVES
	db 26, GROWLITHE,  ROAR, EMBER, LEER, TAKE_DOWN
	db 24, KOFFING,    TACKLE, SMOG, SLUDGE, SMOKESCREEN
	db -1 ; end

	; BURGLAR (3)
	db "COREY@", TRAINERTYPE_NORMAL
	db 25, KOFFING
	db 28, MAGMAR
	db 25, KOFFING
	db 30, KOFFING
	db -1 ; end

	; BURGLAR (4) - Kanto hack (M9 12k): POKeMON MANSION 2F, (3,17).
	; Yellow BurglarData 7.  Nameless: PlaceEnemysName prints "BURGLAR" alone.
	db "@", TRAINERTYPE_NORMAL
	db 34, CHARMANDER
	db 34, CHARMELEON
	db -1 ; end

	; BURGLAR (5) - POKeMON MANSION 3F, (5,11).  Yellow BurglarData 8.
	db "@", TRAINERTYPE_NORMAL
	db 38, NINETALES
	db -1 ; end

	; BURGLAR (6) - POKeMON MANSION B1F, (16,23).  Yellow BurglarData 9.
	db "@", TRAINERTYPE_NORMAL
	db 34, GROWLITHE
	db 34, PONYTA
	db -1 ; end

	; BURGLAR (7) - Kanto hack (M9 12n): CINNABAR GYM (17,8), quiz gate 1.
	; Yellow BurglarData 4.  Nameless, like the MANSION's three above.
	db "@", TRAINERTYPE_NORMAL
	db 36, GROWLITHE
	db 36, VULPIX
	db 36, NINETALES
	db -1 ; end

	; BURGLAR (8) - CINNABAR GYM (11,8), gate 3.  Yellow BurglarData 5.
	db "@", TRAINERTYPE_NORMAL
	db 41, PONYTA
	db -1 ; end

	; BURGLAR (9) - CINNABAR GYM (3,14), gate 5.  Yellow BurglarData 6.
	db "@", TRAINERTYPE_NORMAL
	db 37, VULPIX
	db 37, GROWLITHE
	db -1 ; end

FirebreatherGroup:
	; FIREBREATHER (1) - Kanto hack: unused (Crystal's Route 3 is gone)
	db "OTIS@", TRAINERTYPE_NORMAL
	db 29, MAGMAR
	db 32, WEEZING
	db 29, MAGMAR
	db -1 ; end

	; FIREBREATHER (2)
	db "DICK@", TRAINERTYPE_NORMAL
	db 17, CHARMELEON
	db -1 ; end

	; FIREBREATHER (3)
	db "NED@", TRAINERTYPE_NORMAL
	db 15, KOFFING
	db 16, GROWLITHE
	db 15, KOFFING
	db -1 ; end

	; FIREBREATHER (4) - Kanto hack: unused (Crystal's Route 3 is gone)
	db "BURT@", TRAINERTYPE_NORMAL
	db 32, KOFFING
	db 32, SLUGMA
	db -1 ; end

	; FIREBREATHER (5)
	db "BILL@", TRAINERTYPE_NORMAL
	db  6, KOFFING
	db  6, KOFFING
	db -1 ; end

	; FIREBREATHER (6)
	db "WALT@", TRAINERTYPE_NORMAL
	db 11, MAGMAR
	db 13, MAGMAR
	db -1 ; end

	; FIREBREATHER (7)
	db "RAY@", TRAINERTYPE_NORMAL
	db  9, VULPIX
	db -1 ; end

	; FIREBREATHER (8)
	db "LYLE@", TRAINERTYPE_NORMAL
	db 28, KOFFING
	db 31, FLAREON
	db 28, KOFFING
	db -1 ; end

JugglerGroup:
	; JUGGLER (1)
	db "IRWIN@", TRAINERTYPE_NORMAL
	db  2, VOLTORB
	db  6, VOLTORB
	db 10, VOLTORB
	db 14, VOLTORB
	db -1 ; end

	; JUGGLER (2)
	db "FRITZ@", TRAINERTYPE_NORMAL
	db 29, MR__MIME
	db 29, MAGMAR
	db 29, MACHOKE
	db -1 ; end

	; JUGGLER (3)
	db "HORTON@", TRAINERTYPE_NORMAL
	db 33, ELECTRODE
	db 33, ELECTRODE
	db 33, ELECTRODE
	db 33, ELECTRODE
	db -1 ; end

	; JUGGLER (4) = JUGGLER_3: FUCHSIA GYM
	; Kanto hack (M7 10h): rows 4-6 were dead IRWIN duplicates; they now carry
	; Yellow's FUCHSIA GYM JugglerData rows 3, 4 and 7, and row 7 (Yellow's
	; row 8) is appended.  Nameless, so PlaceEnemysName prints "JUGGLER" alone,
	; as Yellow does -- same convention as TamerGroup and CueBallGroup.
	db "@", TRAINERTYPE_NORMAL
	db 31, DROWZEE
	db 31, DROWZEE
	db 31, KADABRA
	db 31, DROWZEE
	db -1 ; end

	; JUGGLER (5) = JUGGLER_4: FUCHSIA GYM
	db "@", TRAINERTYPE_NORMAL
	db 34, DROWZEE
	db 34, HYPNO
	db -1 ; end

	; JUGGLER (6) = JUGGLER_7: FUCHSIA GYM
	db "@", TRAINERTYPE_NORMAL
	db 38, HYPNO
	db -1 ; end

	; JUGGLER (7) = JUGGLER_8: FUCHSIA GYM
	db "@", TRAINERTYPE_NORMAL
	db 34, DROWZEE
	db 34, KADABRA
	db -1 ; end

	; JUGGLER (8) = JUGGLER_9: Kanto hack (M8 11f) SILPH CO. 5F, (18,10).
	; Yellow JugglerData 1, on SPRITE_ROCKER.  Nameless, as above.
	db "@", TRAINERTYPE_NORMAL
	db 29, KADABRA
	db 29, MR__MIME
	db -1 ; end

	; JUGGLER (9) = JUGGLER_10: Kanto hack (M10 13g) VICTORY ROAD, 2F (21,13), Yellow JugglerData 2.
	; Appended nameless, as the 13b rows.
	db "@", TRAINERTYPE_NORMAL
	db 41, DROWZEE
	db 41, HYPNO
	db 41, KADABRA
	db 41, KADABRA
	db -1 ; end

	; JUGGLER (10) = JUGGLER_11: Kanto hack (M10 13g) VICTORY ROAD, 2F (26,3), Yellow JugglerData 5.
	; Appended nameless, as the 13b rows.
	db "@", TRAINERTYPE_NORMAL
	db 48, MR__MIME
	db -1 ; end

BlackbeltGroup:
	; BLACKBELT_T (1)
	db "KENJI@", TRAINERTYPE_NORMAL
	db 27, ONIX
	db 30, HITMONLEE
	db 27, ONIX
	db 32, MACHOKE
	db -1 ; end

	; BLACKBELT_T (2)
	db "YOSHI@", TRAINERTYPE_MOVES
	db 27, HITMONLEE,  DOUBLE_KICK, MEDITATE, JUMP_KICK, FOCUS_ENERGY
	db -1 ; end

	; BLACKBELT_T (3)
	db "KENJI@", TRAINERTYPE_MOVES
	db 33, ONIX,       BIND, ROCK_THROW, TOXIC, DIG
	db 38, MACHAMP,    HEADBUTT, SWAGGER, THUNDERPUNCH, VITAL_THROW
	db 33, STEELIX,    EARTHQUAKE, ROCK_THROW, IRON_TAIL, SANDSTORM
	db 36, HITMONLEE,  DOUBLE_TEAM, HI_JUMP_KICK, MUD_SLAP, SWIFT
	db -1 ; end

	; BLACKBELT_T (4)
	db "LAO@", TRAINERTYPE_MOVES
	db 27, HITMONCHAN, COMET_PUNCH, THUNDERPUNCH, ICE_PUNCH, FIRE_PUNCH
	db -1 ; end

	; BLACKBELT_T (5)
	db "NOB@", TRAINERTYPE_MOVES
	db 25, MACHOP,     LEER, FOCUS_ENERGY, KARATE_CHOP, SEISMIC_TOSS
	db 25, MACHOKE,    LEER, KARATE_CHOP, SEISMIC_TOSS, ROCK_SLIDE
	db -1 ; end

	; BLACKBELT_T (6)
	db "KIYO@", TRAINERTYPE_NORMAL
	db 34, HITMONLEE
	db 34, HITMONCHAN
	db -1 ; end

	; BLACKBELT_T (7)
	db "LUNG@", TRAINERTYPE_NORMAL
	db 23, MANKEY
	db 23, MANKEY
	db 25, PRIMEAPE
	db -1 ; end

	; BLACKBELT_T (8)
	db "KENJI@", TRAINERTYPE_NORMAL
	db 28, MACHOKE
	db -1 ; end

	; BLACKBELT_T (9)
	db "WAI@", TRAINERTYPE_NORMAL
	db 30, MACHOKE
	db 32, MACHOKE
	db 34, MACHOKE
	db -1 ; end

	; BLACKBELT_T (10) = KARATE_MASTER: FIGHTING DOJO (Yellow BlackbeltData 1)
	db "@", TRAINERTYPE_NORMAL
	db 37, HITMONLEE
	db 37, HITMONCHAN
	db -1 ; end

	; BLACKBELT_T (11) = BLACKBELT_DOJO_1 (Yellow BlackbeltData 2)
	db "@", TRAINERTYPE_NORMAL
	db 31, MANKEY
	db 31, MANKEY
	db 31, PRIMEAPE
	db -1 ; end

	; BLACKBELT_T (12) = BLACKBELT_DOJO_2 (Yellow BlackbeltData 3)
	db "@", TRAINERTYPE_NORMAL
	db 32, MACHOP
	db 32, MACHOKE
	db -1 ; end

	; BLACKBELT_T (13) = BLACKBELT_DOJO_3 (Yellow BlackbeltData 4)
	db "@", TRAINERTYPE_NORMAL
	db 36, PRIMEAPE
	db -1 ; end

	; BLACKBELT_T (14) = BLACKBELT_DOJO_4 (Yellow BlackbeltData 5)
	db "@", TRAINERTYPE_NORMAL
	db 31, MACHOP
	db 31, MANKEY
	db 31, PRIMEAPE
	db -1 ; end

	; Kanto hack (M10 13b): VIRIDIAN GYM, Yellow BlackbeltData 6-8.
	; BLACKBELT_T (15) = BLACKBELT_VIRIDIAN_1 (Yellow BlackbeltData 6)
	db "@", TRAINERTYPE_NORMAL
	db 40, MACHOP
	db 40, MACHOKE
	db -1 ; end

	; BLACKBELT_T (16) = BLACKBELT_VIRIDIAN_2 (Yellow BlackbeltData 7)
	db "@", TRAINERTYPE_NORMAL
	db 43, MACHOKE
	db -1 ; end

	; BLACKBELT_T (17) = BLACKBELT_VIRIDIAN_3 (Yellow BlackbeltData 8)
	db "@", TRAINERTYPE_NORMAL
	db 38, MACHOKE
	db 38, MACHOP
	db 38, MACHOKE
	db -1 ; end

	; BLACKBELT_T (18) = BLACKBELT_VICTORY_ROAD: Kanto hack (M10 13g) VICTORY ROAD, 2F (12,9), Yellow BlackbeltData 9.
	; Appended nameless, as the 13b rows.
	db "@", TRAINERTYPE_NORMAL
	db 43, MACHOKE
	db 43, MACHOP
	db 43, MACHOKE
	db -1 ; end

ExecutiveMGroup:
	; EXECUTIVEM (1)
	db "EXECUTIVE@", TRAINERTYPE_MOVES
	db 33, HOUNDOUR,   EMBER, ROAR, BITE, FAINT_ATTACK
	db 33, KOFFING,    TACKLE, SLUDGE, SMOKESCREEN, HAZE
	db 35, HOUNDOOM,   EMBER, SMOG, BITE, FAINT_ATTACK
	db -1 ; end

	; EXECUTIVEM (2)
	db "EXECUTIVE@", TRAINERTYPE_MOVES
	db 36, GOLBAT,     LEECH_LIFE, BITE, CONFUSE_RAY, WING_ATTACK
	db -1 ; end

	; EXECUTIVEM (3)
	db "EXECUTIVE@", TRAINERTYPE_MOVES
	db 30, KOFFING,    TACKLE, SELFDESTRUCT, SLUDGE, SMOKESCREEN
	db 30, KOFFING,    TACKLE, SELFDESTRUCT, SLUDGE, SMOKESCREEN
	db 30, KOFFING,    TACKLE, SELFDESTRUCT, SLUDGE, SMOKESCREEN
	db 32, WEEZING,    TACKLE, EXPLOSION, SLUDGE, SMOKESCREEN
	db 30, KOFFING,    TACKLE, SELFDESTRUCT, SLUDGE, SMOKESCREEN
	db 30, KOFFING,    TACKLE, SMOG, SLUDGE, SMOKESCREEN
	db -1 ; end

	; EXECUTIVEM (4)
	db "EXECUTIVE@", TRAINERTYPE_NORMAL
	db 22, ZUBAT
	db 24, RATICATE
	db 22, KOFFING
	db -1 ; end

PsychicGroup:
	; PSYCHIC_T (1)
	db "NATHAN@", TRAINERTYPE_NORMAL
	db 26, GIRAFARIG
	db -1 ; end

	; PSYCHIC_T (2)
	db "HERMAN@", TRAINERTYPE_NORMAL
	db 30, EXEGGCUTE
	db 30, EXEGGCUTE
	db 30, EXEGGUTOR
	db -1 ; end

	; PSYCHIC_T (3)
	db "FIDEL@", TRAINERTYPE_NORMAL
	db 34, XATU
	db -1 ; end

	; PSYCHIC_T (4)
	db "GREG@", TRAINERTYPE_MOVES
	db 17, DROWZEE,    HYPNOSIS, DISABLE, DREAM_EATER, NO_MOVE
	db -1 ; end

	; PSYCHIC_T (5)
	db "NORMAN@", TRAINERTYPE_MOVES
	db 17, SLOWPOKE,   TACKLE, GROWL, WATER_GUN, NO_MOVE
	db 20, SLOWPOKE,   CURSE, BODY_SLAM, WATER_GUN, CONFUSION
	db -1 ; end

	; PSYCHIC_T (6)
	db "MARK@", TRAINERTYPE_MOVES
	db 13, ABRA,       TELEPORT, FLASH, NO_MOVE, NO_MOVE
	db 13, ABRA,       TELEPORT, FLASH, NO_MOVE, NO_MOVE
	db 15, KADABRA,    TELEPORT, KINESIS, CONFUSION, NO_MOVE
	db -1 ; end

	; PSYCHIC_T (7)
	db "PHIL@", TRAINERTYPE_MOVES
	db 24, NATU,       LEER, NIGHT_SHADE, FUTURE_SIGHT, CONFUSE_RAY
	db 26, KADABRA,    DISABLE, PSYBEAM, RECOVER, FUTURE_SIGHT
	db -1 ; end

	; PSYCHIC_T (8)
	db "RICHARD@", TRAINERTYPE_NORMAL
	db 36, ESPEON
	db -1 ; end

	; PSYCHIC_T (9)
	db "GILBERT@", TRAINERTYPE_NORMAL
	db 30, STARMIE
	db 30, EXEGGCUTE
	db 34, GIRAFARIG
	db -1 ; end

	; PSYCHIC_T (10)
	db "RODNEY@", TRAINERTYPE_NORMAL
	db 29, DROWZEE
	db 33, HYPNO
	db -1 ; end

	; PSYCHIC_T (11)
	; Kanto hack (M8 11a): SAFFRON GYM, Yellow's PsychicData row 1.
	db "TYRON@", TRAINERTYPE_NORMAL
	db 31, KADABRA
	db 31, SLOWPOKE
	db 31, MR__MIME
	db 31, KADABRA
	db -1 ; end

	; PSYCHIC_T (12)
	; Kanto hack (M8 11a): SAFFRON GYM, Yellow's PsychicData row 2.
	db "HOLLIS@", TRAINERTYPE_NORMAL
	db 34, MR__MIME
	db 34, KADABRA
	db -1 ; end

	; PSYCHIC_T (13)
	; Kanto hack (M8 11a): SAFFRON GYM, Yellow's PsychicData row 3.
	db "EZRA@", TRAINERTYPE_NORMAL
	db 33, SLOWPOKE
	db 33, SLOWPOKE
	db 33, SLOWBRO
	db -1 ; end

	; PSYCHIC_T (14)
	; Kanto hack (M8 11a): SAFFRON GYM, Yellow's PsychicData row 4.
	db "DARIUS@", TRAINERTYPE_NORMAL
	db 38, SLOWBRO
	db -1 ; end

PicnickerGroup:
	; PICNICKER (1)
	db "LIZ@", TRAINERTYPE_NORMAL
	db  9, NIDORAN_F
	db -1 ; end

	; PICNICKER (2)
	db "GINA@", TRAINERTYPE_NORMAL
	db  9, HOPPIP
	db  9, HOPPIP
	db 12, BULBASAUR
	db -1 ; end

	; PICNICKER (3)
	db "BROOKE@", TRAINERTYPE_MOVES
	db 16, PIKACHU,    THUNDERSHOCK, GROWL, QUICK_ATTACK, DOUBLE_TEAM
	db -1 ; end

	; PICNICKER (4)
	db "KIM@", TRAINERTYPE_NORMAL
	db 15, VULPIX
	db -1 ; end

	; PICNICKER (5)
	db "CINDY@", TRAINERTYPE_NORMAL
	db 36, NIDOQUEEN
	db -1 ; end

	; PICNICKER (6)
	; = PICNICKER_9 -- Kanto hack (M9 12c): Yellow's ROUTE 20 SWIMMER4,
	; OPP_JR_TRAINER_F 24 (vendor/pokeyellow/data/trainers/parties.asm).
	db "@", TRAINERTYPE_NORMAL
	db 30, TENTACOOL
	db 30, HORSEA
	db 30, SEEL
	db -1 ; end

	; PICNICKER (7)
	; = PICNICKER_10 -- Kanto hack (M9 12c): Yellow's ROUTE 20 SWIMMER8,
	; OPP_JR_TRAINER_F 16 (vendor/pokeyellow/data/trainers/parties.asm).
	db "@", TRAINERTYPE_NORMAL
	db 31, GOLDEEN
	db 31, SEAKING
	db -1 ; end

	; PICNICKER (8)
	db "DEBRA@", TRAINERTYPE_NORMAL
	db 33, SEAKING
	db -1 ; end

	; PICNICKER (9)
	db "GINA@", TRAINERTYPE_NORMAL
	db 14, HOPPIP
	db 14, HOPPIP
	db 17, IVYSAUR
	db -1 ; end

	; PICNICKER (10)
	db "ERIN@", TRAINERTYPE_NORMAL
	db 16, PONYTA
	db 16, PONYTA
	db -1 ; end

	; PICNICKER (11)
	db "LIZ@", TRAINERTYPE_NORMAL
	db 15, WEEPINBELL
	db 15, NIDORINA
	db -1 ; end

	; PICNICKER (12)
	db "LIZ@", TRAINERTYPE_NORMAL
	db 19, WEEPINBELL
	db 19, NIDORINO
	db 21, NIDOQUEEN
	db -1 ; end

	; PICNICKER (13) - Kanto hack: ROUTE 9, Yellow's JR_TRAINER_F 5 (docs/M5-LAVENDER.md 5.1)
	db "HEIDI@", TRAINERTYPE_NORMAL
	db 18, ODDISH
	db 18, BELLSPROUT
	db 18, ODDISH
	db 18, BELLSPROUT
	db -1 ; end

	; PICNICKER (14) - Kanto hack: ROUTE 9, Yellow's JR_TRAINER_F 6 (docs/M5-LAVENDER.md 5.1)
	db "EDNA@", TRAINERTYPE_NORMAL
	db 23, MEOWTH
	db -1 ; end

	; PICNICKER (15)
	db "GINA@", TRAINERTYPE_NORMAL
	db 26, SKIPLOOM
	db 26, SKIPLOOM
	db 29, IVYSAUR
	db -1 ; end

	; PICNICKER (16)
	db "TIFFANY@", TRAINERTYPE_MOVES
	db 31, CLEFAIRY,   ENCORE, SING, DOUBLESLAP, MINIMIZE
	db -1 ; end

	; PICNICKER (17)
	db "TIFFANY@", TRAINERTYPE_MOVES
	db 37, CLEFAIRY,   ENCORE, DOUBLESLAP, MINIMIZE, METRONOME
	db -1 ; end

	; PICNICKER (18)
	db "ERIN@", TRAINERTYPE_NORMAL
	db 32, PONYTA
	db 32, PONYTA
	db -1 ; end

	; PICNICKER (19) - Kanto hack: CELADON GYM, Yellow's JR_TRAINER_F 11
	; (M6 9q).  Kept in place; TANYA was already Crystal's Celadon Gym
	; picnicker, and PICNICKER is this hack's standing stand-in for Yellow's
	; JR.TRAINER-f (7d precedent, docs/M5-LAVENDER.md 5.1).
	db "TANYA@", TRAINERTYPE_NORMAL
	db 24, BULBASAUR
	db 24, IVYSAUR
	db -1 ; end

	; PICNICKER (20)
	db "TIFFANY@", TRAINERTYPE_MOVES
	db 20, CLEFAIRY,   ENCORE, SING, DOUBLESLAP, MINIMIZE
	db -1 ; end

	; PICNICKER (21)
	db "ERIN@", TRAINERTYPE_MOVES
	db 36, PONYTA,     DOUBLE_TEAM, STOMP, FIRE_SPIN, SUNNY_DAY
	db 34, RAICHU,     SWIFT, MUD_SLAP, QUICK_ATTACK, THUNDERBOLT
	db 36, PONYTA,     DOUBLE_TEAM, STOMP, FIRE_SPIN, SUNNY_DAY
	db -1 ; end

	; PICNICKER (22)
	db "LIZ@", TRAINERTYPE_NORMAL
	db 24, WEEPINBELL
	db 26, NIDORINO
	db 26, NIDOQUEEN
	db -1 ; end

	; PICNICKER (23)
	db "LIZ@", TRAINERTYPE_MOVES
	db 30, WEEPINBELL, SLEEP_POWDER, POISONPOWDER, STUN_SPORE, SLUDGE_BOMB
	db 32, NIDOKING,   EARTHQUAKE, DOUBLE_KICK, POISON_STING, IRON_TAIL
	db 32, NIDOQUEEN,  EARTHQUAKE, DOUBLE_KICK, TAIL_WHIP, BODY_SLAM
	db -1 ; end

	; PICNICKER (24)
	db "GINA@", TRAINERTYPE_NORMAL
	db 30, SKIPLOOM
	db 30, SKIPLOOM
	db 32, IVYSAUR
	db -1 ; end

	; PICNICKER (25)
	db "GINA@", TRAINERTYPE_MOVES
	db 33, JUMPLUFF,   STUN_SPORE, SUNNY_DAY, LEECH_SEED, COTTON_SPORE
	db 33, JUMPLUFF,   SUNNY_DAY, SLEEP_POWDER, LEECH_SEED, COTTON_SPORE
	db 38, VENUSAUR,   SOLARBEAM, RAZOR_LEAF, HEADBUTT, MUD_SLAP
	db -1 ; end

	; PICNICKER (26)
	db "TIFFANY@", TRAINERTYPE_MOVES
	db 43, CLEFAIRY,   METRONOME, ENCORE, MOONLIGHT, MINIMIZE
	db -1 ; end

	; PICNICKER (27)
	; Kanto hack: Yellow's CERULEAN GYM JR.TRAINER^F 1 (docs/M3-CERULEAN.md, 6e).
	; Crystal has no JR.TRAINER class, so she is a PICNICKER -- the same
	; substitution M2 made for Pewter's JR.TRAINER^M (CAMPER JERRY).
	db "DIANA@", TRAINERTYPE_NORMAL
	db 19, GOLDEEN
	db -1 ; end

	; PICNICKER (28) - Kanto hack: Route 6, Yellow's JR_TRAINER_F 25 (docs/M4-VERMILION.md 5.1)
	db "MARCY@", TRAINERTYPE_NORMAL
	db 20, CUBONE
	db -1 ; end

	; PICNICKER (29) - Kanto hack: Route 6, Yellow's JR_TRAINER_F 3
	db "GRETA@", TRAINERTYPE_NORMAL
	db 16, PIDGEY
	db 16, PIDGEY
	db 16, PIDGEY
	db -1 ; end

	; PICNICKER (30) - Kanto hack: ROUTE 10, Yellow's JR_TRAINER_F 7 (docs/M5-LAVENDER.md 5.1)
	db "GRETCHEN@", TRAINERTYPE_NORMAL
	db 20, JIGGLYPUFF
	db 20, CLEFAIRY
	db -1 ; end

	; PICNICKER (31) - Kanto hack: ROUTE 10, Yellow's JR_TRAINER_F 8
	db "MABEL@", TRAINERTYPE_NORMAL
	db 21, PIDGEY
	db 21, PIDGEOTTO
	db -1 ; end

	; PICNICKER (32) - Kanto hack: ROCK TUNNEL 1F, Yellow's JR_TRAINER_F 17 (M5 8e)
	db "THELMA@", TRAINERTYPE_NORMAL
	db 22, BELLSPROUT
	db 22, CLEFAIRY
	db -1 ; end

	; PICNICKER (33) - Kanto hack: ROCK TUNNEL 1F, Yellow's JR_TRAINER_F 18
	db "NELLIE@", TRAINERTYPE_NORMAL
	db 20, MEOWTH
	db 20, ODDISH
	db 20, PIDGEY
	db -1 ; end

	; PICNICKER (34) - Kanto hack: ROCK TUNNEL 1F, Yellow's JR_TRAINER_F 19
	db "MYRNA@", TRAINERTYPE_NORMAL
	db 19, PIDGEY
	db 19, RATTATA
	db 19, RATTATA
	db 19, BELLSPROUT
	db -1 ; end

	; PICNICKER (35) - Kanto hack: ROCK TUNNEL B1F, Yellow's JR_TRAINER_F 9 (M5 8f)
	db "RHODA@", TRAINERTYPE_NORMAL
	db 21, JIGGLYPUFF
	db 21, PIDGEY
	db 21, MEOWTH
	db -1 ; end

	; PICNICKER (36) - Kanto hack: ROCK TUNNEL B1F, Yellow's JR_TRAINER_F 10
	db "OPAL@", TRAINERTYPE_NORMAL
	db 22, ODDISH
	db 22, BULBASAUR
	db -1 ; end

	; Kanto hack (M7 10c): ROUTE 13's four JR.TRAINER^F (OPP_JR_TRAINER_F
	; 12-15).  PICNICKER has no dead rows left, so these four are appended.
	; Nameless (the M6 9y convention), so PlaceEnemysName prints "PICNICKER".
	; PICNICKER (37) -- Yellow's JR_TRAINER_F 12
	; (db 24, PIDGEY, MEOWTH, RATTATA, PIDGEY, MEOWTH, 0)
	db "@", TRAINERTYPE_NORMAL
	db 24, PIDGEY
	db 24, MEOWTH
	db 24, RATTATA
	db 24, PIDGEY
	db 24, MEOWTH
	db -1 ; end

	; PICNICKER (38) -- Yellow's JR_TRAINER_F 13 (db 30, POLIWAG, POLIWAG, 0)
	db "@", TRAINERTYPE_NORMAL
	db 30, POLIWAG
	db 30, POLIWAG
	db -1 ; end

	; PICNICKER (39) -- Yellow's JR_TRAINER_F 14
	; (db 27, PIDGEY, MEOWTH, PIDGEY, PIDGEOTTO, 0)
	db "@", TRAINERTYPE_NORMAL
	db 27, PIDGEY
	db 27, MEOWTH
	db 27, PIDGEY
	db 27, PIDGEOTTO
	db -1 ; end

	; PICNICKER (40) -- Yellow's JR_TRAINER_F 15
	; (db 28, GOLDEEN, POLIWAG, HORSEA, 0)
	db "@", TRAINERTYPE_NORMAL
	db 28, GOLDEEN
	db 28, POLIWAG
	db 28, HORSEA
	db -1 ; end

	; Kanto hack (M7 10e): ROUTE 15's four JR.TRAINERs^F, appended.  Nameless, so
	; PlaceEnemysName prints "PICNICKER".
	; PICNICKER (41) = PICNICKER_5 -- Yellow's JR_TRAINER_F 20
	; (db 28, GLOOM, ODDISH, ODDISH, 0)
	db "@", TRAINERTYPE_NORMAL
	db 28, GLOOM
	db 28, ODDISH
	db 28, ODDISH
	db -1 ; end

	; PICNICKER (42) = PICNICKER_6 -- Yellow's JR_TRAINER_F 21
	; (db 29, PIDGEY, PIDGEOTTO, 0)
	db "@", TRAINERTYPE_NORMAL
	db 29, PIDGEY
	db 29, PIDGEOTTO
	db -1 ; end

	; PICNICKER (43) = PICNICKER_7 -- Yellow's JR_TRAINER_F 22 (db 33, CLEFAIRY, 0)
	db "@", TRAINERTYPE_NORMAL
	db 33, CLEFAIRY
	db -1 ; end

	; PICNICKER (44) = PICNICKER_8 -- Yellow's JR_TRAINER_F 23
	; (db 29, BELLSPROUT, ODDISH, TANGELA, 0)
	db "@", TRAINERTYPE_NORMAL
	db 29, BELLSPROUT
	db 29, ODDISH
	db 29, TANGELA
	db -1 ; end

CamperGroup:
	; CAMPER (1)
	db "ROLAND@", TRAINERTYPE_NORMAL
	db  9, NIDORAN_M
	db -1 ; end

	; CAMPER (2)
	db "TODD@", TRAINERTYPE_NORMAL
	db 14, PSYDUCK
	db -1 ; end

	; CAMPER (3)
	db "IVAN@", TRAINERTYPE_NORMAL
	db 10, DIGLETT
	db 10, ZUBAT
	db 14, DIGLETT
	db -1 ; end

	; CAMPER (4)
	db "ELLIOT@", TRAINERTYPE_NORMAL
	db 13, SANDSHREW
	db 15, MARILL
	db -1 ; end

	; CAMPER (5)
	db "BARRY@", TRAINERTYPE_NORMAL
	db 36, NIDOKING
	db -1 ; end

	; CAMPER (6)
	db "LLOYD@", TRAINERTYPE_NORMAL
	db 34, NIDOKING
	db -1 ; end

	; CAMPER (7) - Kanto hack: ROUTE 9, Yellow's JR_TRAINER_M 8 (docs/M5-LAVENDER.md 5.1)
	db "DEAN@", TRAINERTYPE_NORMAL
	db 19, RATTATA
	db 19, DIGLETT
	db 19, EKANS
	db 19, SANDSHREW
	db -1 ; end

	; CAMPER (8)
	db "HARVEY@", TRAINERTYPE_NORMAL
	db 15, NIDORINO
	db -1 ; end

	; CAMPER (9)
	db "DALE@", TRAINERTYPE_NORMAL
	db 15, NIDORINO
	db -1 ; end

	; CAMPER (10)
	db "TED@", TRAINERTYPE_NORMAL
	db 17, MANKEY
	db -1 ; end

	; CAMPER (11)
	db "TODD@", TRAINERTYPE_NORMAL
	db 17, GEODUDE
	db 17, GEODUDE
	db 23, PSYDUCK
	db -1 ; end

	; CAMPER (12)
	db "TODD@", TRAINERTYPE_NORMAL
	db 23, GEODUDE
	db 23, GEODUDE
	db 26, PSYDUCK
	db -1 ; end

	; CAMPER (13)
	db "THOMAS@", TRAINERTYPE_NORMAL
	db 33, GRAVELER
	db 36, GRAVELER
	db 40, GOLBAT
	db 42, GOLDUCK
	db -1 ; end

	; CAMPER (14)
	db "LEROY@", TRAINERTYPE_NORMAL
	db 33, GRAVELER
	db 36, GRAVELER
	db 40, GOLBAT
	db 42, GOLDUCK
	db -1 ; end

	; CAMPER (15)
	db "DAVID@", TRAINERTYPE_NORMAL
	db 33, GRAVELER
	db 36, GRAVELER
	db 40, GOLBAT
	db 42, GOLDUCK
	db -1 ; end

	; CAMPER (16)
	db "JOHN@", TRAINERTYPE_NORMAL
	db 33, GRAVELER
	db 36, GRAVELER
	db 40, GOLBAT
	db 42, GOLDUCK
	db -1 ; end

	; CAMPER (17)
	; Kanto hack: Yellow's PEWTER GYM JR.TRAINER^M (docs/M2-PEWTER-CITY.md).
	; Crystal has no JR.TRAINER class, so he stays a CAMPER.
	db "JERRY@", TRAINERTYPE_NORMAL
	db  9, DIGLETT
	db  9, SANDSHREW
	db -1 ; end

	; CAMPER (18)
	db "SPENCER@", TRAINERTYPE_NORMAL
	db 17, SANDSHREW
	db 17, SANDSLASH
	db 19, ZUBAT
	db -1 ; end

	; CAMPER (19)
	db "TODD@", TRAINERTYPE_NORMAL
	db 30, GRAVELER
	db 30, GRAVELER
	db 30, SLUGMA
	db 32, PSYDUCK
	db -1 ; end

	; CAMPER (20)
	db "TODD@", TRAINERTYPE_MOVES
	db 33, GRAVELER,   SELFDESTRUCT, ROCK_THROW, HARDEN, MAGNITUDE
	db 33, GRAVELER,   SELFDESTRUCT, ROCK_THROW, HARDEN, MAGNITUDE
	db 36, MAGCARGO,   ROCK_THROW, HARDEN, AMNESIA, FLAMETHROWER
	db 34, GOLDUCK,    DISABLE, PSYCHIC_M, SURF, PSYCH_UP
	db -1 ; end

	; CAMPER (21)
	db "QUENTIN@", TRAINERTYPE_NORMAL
	db 30, FEAROW
	db 30, PRIMEAPE
	db 30, TAUROS
	db -1 ; end

	; CAMPER (22) - Kanto hack: Nugget Bridge grass hider, Yellow's JR_TRAINER_M 2
	db "ANSEL@", TRAINERTYPE_NORMAL
	db 14, RATTATA
	db 14, EKANS
	db -1 ; end

	; CAMPER (23) - Kanto hack: Nugget Bridge No. 5, Yellow's JR_TRAINER_M 3
	db "RUFUS@", TRAINERTYPE_NORMAL
	db 18, MANKEY
	db -1 ; end

	; CAMPER (24) - Kanto hack: Route 25, Yellow's JR_TRAINER_M 2 (2nd use;
	; Nugget Bridge's ANSEL has the same party, so this one needs its own name)
	db "WENDELL@", TRAINERTYPE_NORMAL
	db 14, RATTATA
	db 14, EKANS
	db -1 ; end

	; CAMPER (25) - Kanto hack: Route 6, Yellow's JR_TRAINER_M 10 (docs/M4-VERMILION.md 5.1)
	db "NOLAN@", TRAINERTYPE_NORMAL
	db 16, WEEPINBELL
	db -1 ; end

	; CAMPER (26) - Kanto hack: Route 6, Yellow's JR_TRAINER_M 5
	db "OLIVER@", TRAINERTYPE_NORMAL
	db 16, SPEAROW
	db 16, RATICATE
	db -1 ; end

	; CAMPER (27) - Kanto hack: ROUTE 12, Yellow's JR_TRAINER_M 9 (M5 8l)
	db "LESTER@", TRAINERTYPE_NORMAL
	db 29, NIDORAN_M
	db 29, NIDORINO
	db -1 ; end

ExecutiveFGroup:
	; EXECUTIVEF (1)
	db "EXECUTIVE@", TRAINERTYPE_MOVES
	db 32, ARBOK,      WRAP, POISON_STING, BITE, GLARE
	db 32, VILEPLUME,  ABSORB, SWEET_SCENT, SLEEP_POWDER, ACID
	db 32, MURKROW,    PECK, PURSUIT, HAZE, NIGHT_SHADE
	db -1 ; end

	; EXECUTIVEF (2)
	db "EXECUTIVE@", TRAINERTYPE_MOVES
	db 23, ARBOK,      WRAP, LEER, POISON_STING, BITE
	db 23, GLOOM,      ABSORB, SWEET_SCENT, SLEEP_POWDER, ACID
	db 25, MURKROW,    PECK, PURSUIT, HAZE, NO_MOVE
	db -1 ; end

SageGroup:
	; SAGE (1)
	db "CHOW@", TRAINERTYPE_NORMAL
	db  3, BELLSPROUT
	db  3, BELLSPROUT
	db  3, BELLSPROUT
	db -1 ; end

	; SAGE (2)
	db "NICO@", TRAINERTYPE_NORMAL
	db  3, BELLSPROUT
	db  3, BELLSPROUT
	db  3, BELLSPROUT
	db -1 ; end

	; SAGE (3)
	db "JIN@", TRAINERTYPE_NORMAL
	db  6, BELLSPROUT
	db -1 ; end

	; SAGE (4)
	db "TROY@", TRAINERTYPE_NORMAL
	db  7, BELLSPROUT
	db  7, HOOTHOOT
	db -1 ; end

	; SAGE (5)
	db "JEFFREY@", TRAINERTYPE_NORMAL
	db 22, HAUNTER
	db -1 ; end

	; SAGE (6)
	db "PING@", TRAINERTYPE_NORMAL
	db 16, GASTLY
	db 16, GASTLY
	db 16, GASTLY
	db 16, GASTLY
	db 16, GASTLY
	db -1 ; end

	; SAGE (7)
	db "EDMOND@", TRAINERTYPE_NORMAL
	db  3, BELLSPROUT
	db  3, BELLSPROUT
	db  3, BELLSPROUT
	db -1 ; end

	; SAGE (8)
	db "NEAL@", TRAINERTYPE_NORMAL
	db  6, BELLSPROUT
	db -1 ; end

	; SAGE (9)
	db "LI@", TRAINERTYPE_NORMAL
	db  7, BELLSPROUT
	db  7, BELLSPROUT
	db 10, HOOTHOOT
	db -1 ; end

	; SAGE (10)
	db "GAKU@", TRAINERTYPE_NORMAL
	db 32, NOCTOWL
	db 32, FLAREON
	db -1 ; end

	; SAGE (11)
	db "MASA@", TRAINERTYPE_NORMAL
	db 32, NOCTOWL
	db 32, JOLTEON
	db -1 ; end

	; SAGE (12)
	db "KOJI@", TRAINERTYPE_NORMAL
	db 32, NOCTOWL
	db 32, VAPOREON
	db -1 ; end

MediumGroup:
	; MEDIUM (1)
	db "MARTHA@", TRAINERTYPE_NORMAL
	db 18, GASTLY
	db 20, HAUNTER
	db 20, GASTLY
	db -1 ; end

	; MEDIUM (2)
	db "GRACE@", TRAINERTYPE_NORMAL
	db 20, HAUNTER
	db 20, HAUNTER
	db -1 ; end

; Kanto hack (M6 9f, docs/M6-TOWER.md 5.1/5.3): MEDIUM stands in for Yellow's
; CHANNELER (D12).  These three were dead Crystal rows (`db 25, HAUNTER` each,
; referenced by no map) and are rewritten in place as #MON TOWER 3F's three
; channelers -- Yellow ChannelerData rows 5, 6 and 8
; (vendor/pokeyellow/data/trainers/parties.asm:718,719,723).
	; MEDIUM (3)
	db "BETHANY@", TRAINERTYPE_NORMAL
	db 23, GASTLY
	db -1 ; end

	; MEDIUM (4)
	db "MARGRET@", TRAINERTYPE_NORMAL
	db 24, GASTLY
	db -1 ; end

	; MEDIUM (5)
	db "ETHEL@", TRAINERTYPE_NORMAL
	db 22, GASTLY
	db -1 ; end

; Kanto hack (M6 9f): #MON TOWER 4F's three channelers -- Yellow ChannelerData
; rows 9, 10 and 12 (vendor/pokeyellow/data/trainers/parties.asm:725,726,730).
; Names are invented (D13); 9g appends 5F's four and 9h 6F's three after these.
	; MEDIUM (6)
	db "AGNES@", TRAINERTYPE_NORMAL
	db 24, GASTLY
	db -1 ; end

	; MEDIUM (7)
	db "EDITH@", TRAINERTYPE_NORMAL
	db 23, GASTLY
	db 23, GASTLY
	db -1 ; end

	; MEDIUM (8)
	db "HAZEL@", TRAINERTYPE_NORMAL
	db 22, GASTLY
	db -1 ; end

; Kanto hack (M6 9g): #MON TOWER 5F's four channelers -- Yellow ChannelerData
; rows 14, 16, 17 and 18 (vendor/pokeyellow/data/trainers/parties.asm:734,
; 738, 739, 740).  Names are invented (D13); 9h appends 6F's three after these.
	; MEDIUM (9)
	db "OLIVE@", TRAINERTYPE_NORMAL
	db 23, HAUNTER
	db -1 ; end

	; MEDIUM (10)
	db "CORA@", TRAINERTYPE_NORMAL
	db 22, GASTLY
	db -1 ; end

	; MEDIUM (11)
	db "RUBY@", TRAINERTYPE_NORMAL
	db 24, GASTLY
	db -1 ; end

	; MEDIUM (12)
	db "MYRTLE@", TRAINERTYPE_NORMAL
	db 22, HAUNTER
	db -1 ; end

	; MEDIUM (13)
	; Kanto hack (M6 9h): POKéMON TOWER 6F, Yellow's ChannelerData row 19.
	db "ALMA@", TRAINERTYPE_NORMAL
	db 22, GASTLY
	db 22, GASTLY
	db 22, GASTLY
	db -1 ; end

	; MEDIUM (14)
	; Kanto hack (M6 9h): POKéMON TOWER 6F, Yellow's ChannelerData row 20.
	db "NORA@", TRAINERTYPE_NORMAL
	db 24, GASTLY
	db -1 ; end

	; MEDIUM (15)
	; Kanto hack (M6 9h): POKéMON TOWER 6F, Yellow's ChannelerData row 21.
	db "VERA@", TRAINERTYPE_NORMAL
	db 24, GASTLY
	db -1 ; end

	; MEDIUM (16)
	; Kanto hack (M8 11a): SAFFRON GYM, Yellow's ChannelerData row 22.
	db "TASHA@", TRAINERTYPE_NORMAL
	db 34, GASTLY
	db 34, HAUNTER
	db -1 ; end

	; MEDIUM (17)
	; Kanto hack (M8 11a): SAFFRON GYM, Yellow's ChannelerData row 23.
	db "MARLENA@", TRAINERTYPE_NORMAL
	db 38, HAUNTER
	db -1 ; end

	; MEDIUM (18)
	; Kanto hack (M8 11a): SAFFRON GYM, Yellow's ChannelerData row 24.
	db "BEULAH@", TRAINERTYPE_NORMAL
	db 33, GASTLY
	db 33, GASTLY
	db 33, HAUNTER
	db -1 ; end

BoarderGroup:
	; BOARDER (1)
	db "RONALD@", TRAINERTYPE_NORMAL
	db 24, SEEL
	db 25, DEWGONG
	db 24, SEEL
	db -1 ; end

	; BOARDER (2)
	db "BRAD@", TRAINERTYPE_NORMAL
	db 26, SWINUB
	db 26, SWINUB
	db -1 ; end

	; BOARDER (3)
	db "DOUGLAS@", TRAINERTYPE_NORMAL
	db 24, SHELLDER
	db 25, CLOYSTER
	db 24, SHELLDER
	db -1 ; end

PokefanMGroup:
	; POKEFANM (1)
	db "WILLIAM@", TRAINERTYPE_ITEM
	db 14, RAICHU,     BERRY
	db -1 ; end

	; POKEFANM (2)
	db "DEREK@", TRAINERTYPE_ITEM
	db 17, PIKACHU,    BERRY
	db -1 ; end

	; POKEFANM (3) -- unused (Kanto hack, M7 10c): JOSHUA was Crystal's ROUTE 13
	; PIKACHU-gang POKEFAN, deleted by 10c.  The row has to stay so POKEFANM (4)
	; CARTER and everything after it keep their ids, but its six-PIKACHU party
	; is cut to a one-#MON placeholder (D49).
	db "JOSHUA@", TRAINERTYPE_ITEM
	db 23, PIKACHU,    BERRY
	db -1 ; end

	; POKEFANM (4) -- unused (Kanto hack, M7 10d): CARTER was Crystal's ROUTE 14
	; POKEFAN, deleted by 10d.  The row has to stay so POKEFANM (5) and everything
	; after it keep their ids, but its three-#MON party is cut to a one-#MON
	; placeholder (D49).
	db "CARTER@", TRAINERTYPE_ITEM
	db 29, BULBASAUR,  BERRY
	db -1 ; end

	; POKEFANM (5) -- unused (Kanto hack, M7 10d): TREVOR was Crystal's other
	; ROUTE 14 POKEFAN, deleted by 10d.  Already a one-#MON row, so nothing to cut.
	db "TREVOR@", TRAINERTYPE_ITEM
	db 33, PSYDUCK,    BERRY
	db -1 ; end

	; POKEFANM (6)
	db "BRANDON@", TRAINERTYPE_ITEM
	db 13, SNUBBULL,   BERRY
	db -1 ; end

	; POKEFANM (7)
	db "JEREMY@", TRAINERTYPE_ITEM
	db 28, MEOWTH,     BERRY
	db 28, MEOWTH,     BERRY
	db 28, MEOWTH,     BERRY
	db -1 ; end

	; POKEFANM (8)
	db "COLIN@", TRAINERTYPE_ITEM
	db 32, DELIBIRD,   BERRY
	db -1 ; end

	; POKEFANM (9)
	db "DEREK@", TRAINERTYPE_ITEM
	db 19, PIKACHU,    BERRY
	db -1 ; end

	; POKEFANM (10)
	db "DEREK@", TRAINERTYPE_ITEM
	db 36, PIKACHU,    BERRY
	db -1 ; end

; Kanto hack (M7 10c): POKEFANM (11) ALEX -- Crystal's other ROUTE 13 POKEFAN --
; is gone with the rest of Crystal's ROUTE 13.  He was the LAST entry of the
; class, so no other POKEFANM id moves and the row is deleted outright (D49).

KimonoGirlGroup:
	; KIMONO_GIRL (1)
	db "NAOKO@", TRAINERTYPE_NORMAL
	db 20, SKIPLOOM
	db 20, VULPIX
	db 18, SKIPLOOM
	db -1 ; end

	; KIMONO_GIRL (2)
	db "NAOKO@", TRAINERTYPE_NORMAL
	db 17, FLAREON
	db -1 ; end

	; KIMONO_GIRL (3)
	db "SAYO@", TRAINERTYPE_NORMAL
	db 17, ESPEON
	db -1 ; end

	; KIMONO_GIRL (4)
	db "ZUKI@", TRAINERTYPE_NORMAL
	db 17, UMBREON
	db -1 ; end

	; KIMONO_GIRL (5)
	db "KUNI@", TRAINERTYPE_NORMAL
	db 17, VAPOREON
	db -1 ; end

	; KIMONO_GIRL (6)
	db "MIKI@", TRAINERTYPE_NORMAL
	db 17, JOLTEON
	db -1 ; end

TwinsGroup:
	; TWINS (1)
	db "AMY & MAY@", TRAINERTYPE_NORMAL
	db 10, SPINARAK
	db 10, LEDYBA
	db -1 ; end

	; TWINS (2)
	db "ANN & ANNE@", TRAINERTYPE_MOVES
	db 16, CLEFAIRY,   GROWL, ENCORE, DOUBLESLAP, METRONOME
	db 16, JIGGLYPUFF, SING, DEFENSE_CURL, POUND, DISABLE
	db -1 ; end

	; TWINS (3)
	db "ANN & ANNE@", TRAINERTYPE_MOVES
	db 16, JIGGLYPUFF, SING, DEFENSE_CURL, POUND, DISABLE
	db 16, CLEFAIRY,   GROWL, ENCORE, DOUBLESLAP, METRONOME
	db -1 ; end

	; TWINS (4)
	db "AMY & MAY@", TRAINERTYPE_NORMAL
	db 10, LEDYBA
	db 10, SPINARAK
	db -1 ; end

	; TWINS (5) and (6) - Kanto hack (M6 9q): dead.  JO & ZOE were Crystal's
	; Celadon Gym twins and Yellow's CELADON GYM has none, so nothing loads
	; these two rows any more.  Left in place because TWINS (7)-(10) are live
	; Johto rows and deleting these would renumber them; their two event flags
	; were re-used for the gym's BEAUTY POPPY and LASS HOLLY.
	; TWINS (5)
	db "JO & ZOE@", TRAINERTYPE_NORMAL
	db 35, VICTREEBEL
	db 35, VILEPLUME
	db -1 ; end

	; TWINS (6)
	db "JO & ZOE@", TRAINERTYPE_NORMAL
	db 35, VILEPLUME
	db 35, VICTREEBEL
	db -1 ; end

	; TWINS (7)
	db "MEG & PEG@", TRAINERTYPE_NORMAL
	db 31, TEDDIURSA
	db 31, PHANPY
	db -1 ; end

	; TWINS (8)
	db "MEG & PEG@", TRAINERTYPE_NORMAL
	db 31, PHANPY
	db 31, TEDDIURSA
	db -1 ; end

	; TWINS (9)
	db "LEA & PIA@", TRAINERTYPE_MOVES
	db 35, DRATINI,    THUNDER_WAVE, TWISTER, FLAMETHROWER, HEADBUTT
	db 35, DRATINI,    THUNDER_WAVE, TWISTER, ICE_BEAM, HEADBUTT
	db -1 ; end

	; TWINS (10)
	db "LEA & PIA@", TRAINERTYPE_MOVES
	db 38, DRATINI,    THUNDER_WAVE, TWISTER, ICE_BEAM, HEADBUTT
	db 38, DRATINI,    THUNDER_WAVE, TWISTER, FLAMETHROWER, HEADBUTT
	db -1 ; end

PokefanFGroup:
	; POKEFANF (1)
	db "BEVERLY@", TRAINERTYPE_ITEM
	db 14, SNUBBULL,   BERRY
	db -1 ; end

	; POKEFANF (2)
	db "RUTH@", TRAINERTYPE_ITEM
	db 17, PIKACHU,    BERRY
	db -1 ; end

	; POKEFANF (3)
	db "BEVERLY@", TRAINERTYPE_ITEM
	db 18, SNUBBULL,   BERRY
	db -1 ; end

	; POKEFANF (4)
	db "BEVERLY@", TRAINERTYPE_ITEM
	db 30, GRANBULL,   BERRY
	db -1 ; end

	; POKEFANF (5)
	db "GEORGIA@", TRAINERTYPE_ITEM
	db 23, SENTRET,    BERRY
	db 23, SENTRET,    BERRY
	db 23, SENTRET,    BERRY
	db 28, FURRET,     BERRY
	db 23, SENTRET,    BERRY
	db -1 ; end

	; POKEFANF (6)
	db "JAIME@", TRAINERTYPE_ITEM
	db 16, MEOWTH,     BERRY
	db -1 ; end

RedGroup:
	; RED (1)
	db "RED@", TRAINERTYPE_MOVES
	db 81, PIKACHU,    CHARM, QUICK_ATTACK, THUNDERBOLT, THUNDER
	db 73, ESPEON,     MUD_SLAP, REFLECT, SWIFT, PSYCHIC_M
	db 75, SNORLAX,    AMNESIA, SNORE, REST, BODY_SLAM
	db 77, VENUSAUR,   SUNNY_DAY, GIGA_DRAIN, SYNTHESIS, SOLARBEAM
	db 77, CHARIZARD,  FLAMETHROWER, WING_ATTACK, SLASH, FIRE_SPIN
	db 77, BLASTOISE,  RAIN_DANCE, SURF, BLIZZARD, WHIRLPOOL
	db -1 ; end

BlueGroup:
	; BLUE (1)
	db "BLUE@", TRAINERTYPE_MOVES
	db 56, PIDGEOT,    QUICK_ATTACK, WHIRLWIND, WING_ATTACK, MIRROR_MOVE
	db 54, ALAKAZAM,   DISABLE, RECOVER, PSYCHIC_M, REFLECT
	db 56, RHYDON,     FURY_ATTACK, SANDSTORM, ROCK_SLIDE, EARTHQUAKE
	db 58, GYARADOS,   TWISTER, HYDRO_PUMP, RAIN_DANCE, HYPER_BEAM
	db 58, EXEGGUTOR,  SUNNY_DAY, LEECH_SEED, EGG_BOMB, SOLARBEAM
	db 58, ARCANINE,   ROAR, SWIFT, FLAMETHROWER, EXTREMESPEED
	db -1 ; end

OfficerGroup:
	; OFFICER (1)
	db "KEITH@", TRAINERTYPE_NORMAL
	db 17, GROWLITHE
	db -1 ; end

	; OFFICER (2)
	db "DIRK@", TRAINERTYPE_NORMAL
	db 14, GROWLITHE
	db 14, GROWLITHE
	db -1 ; end

GruntFGroup:
	; GRUNTF (1)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db  9, ZUBAT
	db 11, EKANS
	db -1 ; end

	; GRUNTF (2)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 26, ARBOK
	db -1 ; end

	; GRUNTF (3)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 25, GLOOM
	db 25, GLOOM
	db -1 ; end

	; GRUNTF (4)
	db "GRUNT@", TRAINERTYPE_NORMAL
	db 21, EKANS
	db 23, ODDISH
	db 21, EKANS
	db 24, GLOOM
	db -1 ; end

	; GRUNTF (5)
	db "GRUNT@", TRAINERTYPE_MOVES
	db 18, EKANS,      WRAP, LEER, POISON_STING, BITE
	db 18, GLOOM,      ABSORB, SWEET_SCENT, STUN_SPORE, SLEEP_POWDER
	db -1 ; end

KantoRivalGroup:
	; KANTO_RIVAL (1): Oak's Lab, Pallet Town
	db "?@", TRAINERTYPE_NORMAL
	db  5, EEVEE
	db -1 ; end

	; KANTO_RIVAL (2): Route 22, first battle (Yellow's Rival1Data #2)
	db "?@", TRAINERTYPE_NORMAL
	db  9, SPEAROW
	db  8, EEVEE
	db -1 ; end

	; KANTO_RIVAL (3): Cerulean City, the south end of Nugget Bridge
	; (Yellow's Rival1Data #3, docs/M3-CERULEAN.md 5).  A fixed party: Yellow
	; never branches this one on wRivalStarter, only the Pokemon Tower / Silph
	; / Champion parties.  The L18 SPEAROW is fair against Yellow's Pikachu.
	db "?@", TRAINERTYPE_NORMAL
	db 18, SPEAROW
	db 15, SANDSHREW
	db 15, RATTATA
	db 17, EEVEE
	db -1 ; end

	; KANTO_RIVAL (4): S.S. ANNE 2F, outside the CAPTAIN's room -- Yellow's
	; fourth rival fight (OPP_RIVAL2 / wTrainerNo = 1, Rival2Data #1 at
	; vendor/pokeyellow/data/trainers/parties.asm:688).  Fixed, like #1-#3:
	; Yellow only branches the Pokemon Tower / Silph Co. / Champion parties on
	; wRivalStarter, and the EEVEE here is still an unevolved EEVEE -- the
	; JOLTEON/FLAREON/VAPOREON rule (docs/M3-CERULEAN.md 6d.5) first matters at
	; Pokemon Tower 2F.
	db "?@", TRAINERTYPE_NORMAL
	db 19, SPEAROW
	db 16, RATTATA
	db 18, SANDSHREW
	db 20, EEVEE
	db -1 ; end

	; KANTO_RIVAL (5)-(7): POKEMON TOWER 2F -- Yellow's fifth rival fight
	; (OPP_RIVAL2 / wTrainerNo = wRivalStarter + 1, Rival2Data rows 2-4 at
	; vendor/pokeyellow/data/trainers/parties.asm:690-692).
	;
	; ⚠ These three rows are NOT one-per-player-starter.  The player's starter
	; in Yellow is always PIKACHU; wRivalStarter is the RIVAL's EEVEE outcome
	; (RIVAL_STARTER_JOLTEON/FLAREON/VAPOREON = 1/2/3,
	; vendor/pokeyellow/constants/pokemon_constants.asm:207-209), and it selects
	; the row.  Note what changes and what does not: slots 1, 4 and 5 are the
	; same in all three rows, and slot 5 is still an unevolved L25 EEVEE --
	; Yellow's rival does not show JOLTEON/FLAREON/VAPOREON until SILPH CO. 7F.
	; What the rule buys him here is type coverage against the evolution he
	; DIDN'T pick: the JOLTEON rival carries water + fire, the FLAREON rival
	; electric + water, the VAPOREON rival fire + electric.
	; Selected by `special GetKantoRivalStarter` -- see maps/PokemonTower2F.asm.

	; KANTO_RIVAL (5): POKEMON TOWER 2F, RIVAL_STARTER_JOLTEON
	db "?@", TRAINERTYPE_NORMAL
	db 25, FEAROW
	db 23, SHELLDER
	db 22, VULPIX
	db 20, SANDSHREW
	db 25, EEVEE
	db -1 ; end

	; KANTO_RIVAL (6): POKEMON TOWER 2F, RIVAL_STARTER_FLAREON
	db "?@", TRAINERTYPE_NORMAL
	db 25, FEAROW
	db 23, MAGNEMITE
	db 22, SHELLDER
	db 20, SANDSHREW
	db 25, EEVEE
	db -1 ; end

	; KANTO_RIVAL (7): POKEMON TOWER 2F, RIVAL_STARTER_VAPOREON
	db "?@", TRAINERTYPE_NORMAL
	db 25, FEAROW
	db 23, VULPIX
	db 22, MAGNEMITE
	db 20, SANDSHREW
	db 25, EEVEE
	db -1 ; end

	; KANTO_RIVAL (8)-(10): SILPH CO. 7F -- Yellow's sixth rival fight
	; (OPP_RIVAL2 / wTrainerNo = wRivalStarter + 4, Rival2Data rows 5-7 at
	; vendor/pokeyellow/data/trainers/parties.asm:694-696).  Selected by
	; `special GetKantoRivalStarter` -- see maps/SilphCo7F.asm.
	;
	; This is the first fight in which the EEVEE has actually evolved: slot 5 is
	; the L40 JOLTEON/FLAREON/VAPOREON itself, and slots 2 and 3 again cover the
	; two evolutions he did not take.  Slots 1 and 4 (SANDSLASH, KADABRA) are
	; the same in all three rows.

	; KANTO_RIVAL (8): SILPH CO. 7F, RIVAL_STARTER_JOLTEON
	db "?@", TRAINERTYPE_NORMAL
	db 38, SANDSLASH
	db 35, NINETALES
	db 37, CLOYSTER
	db 35, KADABRA
	db 40, JOLTEON
	db -1 ; end

	; KANTO_RIVAL (9): SILPH CO. 7F, RIVAL_STARTER_FLAREON
	db "?@", TRAINERTYPE_NORMAL
	db 38, SANDSLASH
	db 35, CLOYSTER
	db 37, MAGNETON
	db 35, KADABRA
	db 40, FLAREON
	db -1 ; end

	; KANTO_RIVAL (10): SILPH CO. 7F, RIVAL_STARTER_VAPOREON
	db "?@", TRAINERTYPE_NORMAL
	db 38, SANDSLASH
	db 35, MAGNETON
	db 37, NINETALES
	db 35, KADABRA
	db 40, VAPOREON
	db -1 ; end

	; KANTO_RIVAL (11)-(13): ROUTE 22 after the eighth badge -- Yellow's
	; seventh rival fight (OPP_RIVAL2 / wTrainerNo = wRivalStarter + 7,
	; Rival2Data rows 8-10 at vendor/pokeyellow/data/trainers/parties.asm:
	; 698-700).  Selected by `special GetKantoRivalStarter` -- see
	; maps/Route22.asm (M10 13c).  TRAINERTYPE_NORMAL like rows 1-10: Yellow's
	; special_moves.asm lists no RIVAL2 rows, so every mon has its level-up
	; moves, exactly as in Yellow.  Slots 1, 2 and 5 are the same in all three
	; rows; slots 3 and 4 cover the two evolutions he did not take.

	; KANTO_RIVAL (11): ROUTE 22 #2, RIVAL_STARTER_JOLTEON
	db "?@", TRAINERTYPE_NORMAL
	db 47, SANDSLASH
	db 45, EXEGGCUTE
	db 45, NINETALES
	db 47, CLOYSTER
	db 50, KADABRA
	db 53, JOLTEON
	db -1 ; end

	; KANTO_RIVAL (12): ROUTE 22 #2, RIVAL_STARTER_FLAREON
	db "?@", TRAINERTYPE_NORMAL
	db 47, SANDSLASH
	db 45, EXEGGCUTE
	db 45, CLOYSTER
	db 47, MAGNETON
	db 50, KADABRA
	db 53, FLAREON
	db -1 ; end

	; KANTO_RIVAL (13): ROUTE 22 #2, RIVAL_STARTER_VAPOREON
	db "?@", TRAINERTYPE_NORMAL
	db 47, SANDSLASH
	db 45, EXEGGCUTE
	db 45, MAGNETON
	db 47, NINETALES
	db 50, KADABRA
	db 53, VAPOREON
	db -1 ; end

JessieJamesGroup:
	; JESSIE_JAMES (1): Mt. Moon B2F (Yellow's OPP_ROCKET $2a)
	; Name is empty: PlaceEnemysName prints the class name "JESSIE&JAMES" alone.
	db "@", TRAINERTYPE_NORMAL
	db 14, EKANS
	db 14, MEOWTH
	db 14, KOFFING
	db -1 ; end

	; JESSIE_JAMES (2): POKEMON TOWER 7F (Yellow's OPP_ROCKET $2c, RocketData
	; row 44: db 27, MEOWTH, ARBOK, WEEZING).
	db "@", TRAINERTYPE_NORMAL
	db 27, MEOWTH
	db 27, ARBOK
	db 27, WEEZING
	db -1 ; end

	; JESSIE_JAMES (3): ROCKET HIDEOUT B4F (Yellow's OPP_ROCKET $2b, RocketData
	; row 43: db 25, KOFFING, MEOWTH, EKANS).
	db "@", TRAINERTYPE_NORMAL
	db 25, KOFFING
	db 25, MEOWTH
	db 25, EKANS
	db -1 ; end

	; JESSIE_JAMES (4): SILPH CO. 11F (Yellow's OPP_ROCKET $2d, RocketData
	; row 45: db 31, WEEZING, ARBOK, MEOWTH).
	db "@", TRAINERTYPE_NORMAL
	db 31, WEEZING
	db 31, ARBOK
	db 31, MEOWTH
	db -1 ; end

; Kanto hack (M6 9x): GIOVANNI, Yellow's GiovanniData rows 1-3 verbatim
; (vendor/pokeyellow/data/trainers/parties.asm:535-541).  Yellow's leading $FF
; means "per-mon levels", which is TRAINERTYPE_NORMAL's default shape here.
; The name is empty so PlaceEnemysName prints the class name "GIOVANNI" alone.
GiovanniGroup:
	; GIOVANNI (1): ROCKET HIDEOUT B4F
	db "@", TRAINERTYPE_NORMAL
	db 25, ONIX
	db 24, RHYHORN
	db 29, PERSIAN
	db -1 ; end

	; GIOVANNI (2): SILPH CO. 11F (M8 11i)
	db "@", TRAINERTYPE_NORMAL
	db 37, NIDORINO
	db 35, PERSIAN
	db 37, RHYHORN
	db 41, NIDOQUEEN
	db -1 ; end

	; GIOVANNI (3): VIRIDIAN GYM (M10 13b)
	; Yellow's moves: WriteMonMoves' level-up fill at each level, then
	; vendor/pokeyellow/data/trainers/special_moves.asm's GIOVANNI 3 overrides
	; (DUGTRIO 3:FISSURE; PERSIAN 2:DOUBLE_TEAM; NIDOQUEEN 1:EARTHQUAKE
	; 3:THUNDER; NIDOKING 1:EARTHQUAKE 2:LEER 3:THUNDER; RHYDON 1:ROCK_SLIDE
	; 4:EARTHQUAKE).
	db "@", TRAINERTYPE_MOVES
	db 50, DUGTRIO,   DIG, SAND_ATTACK, FISSURE, EARTHQUAKE
	db 53, PERSIAN,   SCREECH, DOUBLE_TEAM, FURY_SWIPES, SLASH
	db 53, NIDOQUEEN, EARTHQUAKE, TAIL_WHIP, THUNDER, DOUBLE_KICK
	db 55, NIDOKING,  EARTHQUAKE, LEER, THUNDER, DOUBLE_KICK
	db 55, RHYDON,    ROCK_SLIDE, FURY_ATTACK, HORN_DRILL, EARTHQUAKE
	db -1 ; end

; Kanto hack (M6 9y): CUE BALL, Yellow's CueBallData rows 1-9 verbatim
; (vendor/pokeyellow/data/trainers/parties.asm).  Nameless, so PlaceEnemysName
; prints the class name "CUE BALL" alone -- exactly what Yellow shows.
CueBallGroup:
	; CUE BALL (1): ROUTE 16
	db "@", TRAINERTYPE_NORMAL
	db 28, MACHOP
	db 28, MANKEY
	db 28, MACHOP
	db -1 ; end

	; CUE BALL (2): ROUTE 16
	db "@", TRAINERTYPE_NORMAL
	db 29, MANKEY
	db 29, MACHOP
	db -1 ; end

	; CUE BALL (3): ROUTE 16
	db "@", TRAINERTYPE_NORMAL
	db 33, MACHOP
	db -1 ; end

	; CUE BALL (4): ROUTE 17 (M6 9z)
	db "@", TRAINERTYPE_NORMAL
	db 29, MANKEY
	db 29, PRIMEAPE
	db -1 ; end

	; CUE BALL (5): ROUTE 17 (M6 9z)
	db "@", TRAINERTYPE_NORMAL
	db 29, MACHOP
	db 29, MACHOKE
	db -1 ; end

	; CUE BALL (6): ROUTE 17 (M6 9z)
	db "@", TRAINERTYPE_NORMAL
	db 33, MACHOKE
	db -1 ; end

	; CUE BALL (7): ROUTE 17 (M6 9z)
	db "@", TRAINERTYPE_NORMAL
	db 26, MANKEY
	db 26, MANKEY
	db 26, MACHOKE
	db 26, MACHOP
	db -1 ; end

	; CUE BALL (8): ROUTE 17 (M6 9z)
	db "@", TRAINERTYPE_NORMAL
	db 29, PRIMEAPE
	db 29, MACHOKE
	db -1 ; end

	; CUE BALL (9) = CUE_BALL_9 -- Kanto hack (M9 12c): Yellow's ROUTE 21 SWIMMER2,
	; OPP_CUE_BALL 9.  The row was reserved by M6 9z and is wired up here.
	db "@", TRAINERTYPE_NORMAL
	db 31, TENTACOOL
	db 31, TENTACOOL
	db 31, TENTACRUEL
	db -1 ; end

; Kanto hack (M7 10a): TAMER, Yellow's TamerData rows 1-5 verbatim
; (vendor/pokeyellow/data/trainers/parties.asm).  Nameless, so PlaceEnemysName
; prints the class name "TAMER" alone -- exactly what Yellow shows.  Rows 3-5
; are wired up by M8 (VIRIDIAN GYM, VICTORY ROAD 2F).
TamerGroup:
	; TAMER (1): FUCHSIA GYM
	db "@", TRAINERTYPE_NORMAL
	db 34, SANDSLASH
	db 34, ARBOK
	db -1 ; end

	; TAMER (2): FUCHSIA GYM
	db "@", TRAINERTYPE_NORMAL
	db 33, ARBOK
	db 33, SANDSLASH
	db 33, ARBOK
	db -1 ; end

	; TAMER (3): VIRIDIAN GYM
	db "@", TRAINERTYPE_NORMAL
	db 43, RHYHORN
	db -1 ; end

	; TAMER (4): VIRIDIAN GYM
	db "@", TRAINERTYPE_NORMAL
	db 39, ARBOK
	db 39, TAUROS
	db -1 ; end

	; TAMER (5): VICTORY ROAD 2F
	db "@", TRAINERTYPE_NORMAL
	db 44, PERSIAN
	db 44, GOLDUCK
	db -1 ; end

KantoChampionGroup:
	; Kanto hack (M10 13i): Yellow's RIVAL3 (the INDIGO PLATEAU CHAMPION), rows 1-3 =
	; RIVAL_STARTER_JOLTEON/FLAREON/VAPOREON (wScriptVar 1/2/3), picked by the Eevee rule in 13k.
	; The name is "?" -- PlaceEnemysName prints wRivalName, as for KANTO_RIVAL.
	; Kanto hack (M10 13i, D127): Yellow's party, TRAINERTYPE_MOVES = Yellow's level-up
	; fill (WriteMonMoves) + SpecialTrainerMoves (data/trainers/special_moves.asm).
	; KANTO_CHAMPION_1 (JOLTEON)
	; Yellow data/trainers/parties.asm:702-706 Rival3Data row 1, special_moves.asm RIVAL3 1
	db "?@", TRAINERTYPE_MOVES
	db 61, SANDSLASH,  SLASH, POISON_STING, EARTHQUAKE, FURY_SWIPES
	db 59, ALAKAZAM,   PSYBEAM, RECOVER, PSYCHIC_M, KINESIS
	db 61, EXEGGUTOR,  BARRAGE, HYPNOSIS, STOMP, LEECH_SEED
	db 61, CLOYSTER,   ICE_BEAM, CLAMP, AURORA_BEAM, SPIKE_CANNON
	db 63, NINETALES,  CONFUSE_RAY, TAIL_WHIP, QUICK_ATTACK, FIRE_SPIN
	db 65, JOLTEON,    PIN_MISSILE, THUNDER_WAVE, QUICK_ATTACK, THUNDER
	db -1 ; end

	; KANTO_CHAMPION_2 (FLAREON)
	; Yellow data/trainers/parties.asm:702-706 Rival3Data row 2, special_moves.asm RIVAL3 2
	db "?@", TRAINERTYPE_MOVES
	db 61, SANDSLASH,  SLASH, POISON_STING, EARTHQUAKE, FURY_SWIPES
	db 59, ALAKAZAM,   PSYBEAM, RECOVER, PSYCHIC_M, KINESIS
	db 61, EXEGGUTOR,  BARRAGE, HYPNOSIS, STOMP, LEECH_SEED
	db 61, MAGNETON,   THUNDERBOLT, THUNDER_WAVE, SWIFT, SCREECH
	db 63, CLOYSTER,   ICE_BEAM, CLAMP, AURORA_BEAM, SPIKE_CANNON
	db 65, FLAREON,    FIRE_SPIN, REFLECT, QUICK_ATTACK, FLAMETHROWER
	db -1 ; end

	; KANTO_CHAMPION_3 (VAPOREON)
	; Yellow data/trainers/parties.asm:702-706 Rival3Data row 3, special_moves.asm RIVAL3 3
	db "?@", TRAINERTYPE_MOVES
	db 61, SANDSLASH,  SLASH, POISON_STING, EARTHQUAKE, FURY_SWIPES
	db 59, ALAKAZAM,   PSYBEAM, RECOVER, PSYCHIC_M, KINESIS
	db 61, EXEGGUTOR,  BARRAGE, HYPNOSIS, STOMP, LEECH_SEED
	db 61, NINETALES,  CONFUSE_RAY, TAIL_WHIP, QUICK_ATTACK, FIRE_SPIN
	db 63, MAGNETON,   THUNDERBOLT, THUNDER_WAVE, SWIFT, SCREECH
	db 65, VAPOREON,   AURORA_BEAM, MIST, QUICK_ATTACK, HYDRO_PUMP
	db -1 ; end

MysticalmanGroup:
	; MYSTICALMAN (1)
	db "EUSINE@", TRAINERTYPE_MOVES
	db 23, DROWZEE,    DREAM_EATER, HYPNOSIS, DISABLE, CONFUSION
	db 23, HAUNTER,    LICK, HYPNOSIS, MEAN_LOOK, CURSE
	db 25, ELECTRODE,  SCREECH, SONICBOOM, THUNDER, ROLLOUT
	db -1 ; end

