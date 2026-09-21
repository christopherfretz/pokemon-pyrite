; sprite ids
; OverworldSprites indexes (see data/sprites/sprites.asm)
	const_def
	const SPRITE_NONE ; 00
	const SPRITE_CHRIS ; 01
	const SPRITE_CHRIS_BIKE ; 02
	const SPRITE_GAMEBOY_KID ; 03
	const SPRITE_RIVAL ; 04
	const SPRITE_OAK ; 05
	const SPRITE_RED ; 06
	const SPRITE_BLUE ; 07
	const SPRITE_BILL ; 08
	const SPRITE_ELDER ; 09
	const SPRITE_JANINE ; 0a
	const SPRITE_KURT ; 0b
	const SPRITE_MOM ; 0c
	const SPRITE_BLAINE ; 0d
	const SPRITE_REDS_MOM ; 0e
	const SPRITE_DAISY ; 0f
	const SPRITE_ELM ; 10
	const SPRITE_WILL ; 11
	const SPRITE_FALKNER ; 12
	const SPRITE_WHITNEY ; 13
	const SPRITE_BUGSY ; 14
	const SPRITE_MORTY ; 15
	const SPRITE_CHUCK ; 16
	const SPRITE_JASMINE ; 17
	const SPRITE_PRYCE ; 18
	const SPRITE_CLAIR ; 19
	const SPRITE_BROCK ; 1a
	const SPRITE_KAREN ; 1b
	const SPRITE_BRUNO ; 1c
	const SPRITE_MISTY ; 1d
	const SPRITE_LANCE ; 1e
	const SPRITE_SURGE ; 1f
	const SPRITE_ERIKA ; 20
	const SPRITE_KOGA ; 21
	const SPRITE_SABRINA ; 22
	const SPRITE_COOLTRAINER_M ; 23
	const SPRITE_COOLTRAINER_F ; 24
	const SPRITE_BUG_CATCHER ; 25
	const SPRITE_TWIN ; 26
	const SPRITE_YOUNGSTER ; 27
	const SPRITE_LASS ; 28
	const SPRITE_TEACHER ; 29
	const SPRITE_BEAUTY ; 2a
	const SPRITE_SUPER_NERD ; 2b
	const SPRITE_ROCKER ; 2c
	const SPRITE_POKEFAN_M ; 2d
	const SPRITE_POKEFAN_F ; 2e
	const SPRITE_GRAMPS ; 2f
	const SPRITE_GRANNY ; 30
	const SPRITE_SWIMMER_GUY ; 31
	const SPRITE_SWIMMER_GIRL ; 32
	const SPRITE_BIG_SNORLAX ; 33
	const SPRITE_SURFING_PIKACHU ; 34
	const SPRITE_ROCKET ; 35
	const SPRITE_ROCKET_GIRL ; 36
	const SPRITE_NURSE ; 37
	const SPRITE_LINK_RECEPTIONIST ; 38
	const SPRITE_CLERK ; 39
	const SPRITE_FISHER ; 3a
	const SPRITE_FISHING_GURU ; 3b
	const SPRITE_SCIENTIST ; 3c
	const SPRITE_KIMONO_GIRL ; 3d
	const SPRITE_SAGE ; 3e
	const SPRITE_UNUSED_GUY ; 3f
	const SPRITE_GENTLEMAN ; 40
	const SPRITE_BLACK_BELT ; 41
	const SPRITE_RECEPTIONIST ; 42
	const SPRITE_OFFICER ; 43
	const SPRITE_CAL ; 44
	const SPRITE_SLOWPOKE ; 45
	const SPRITE_CAPTAIN ; 46
	const SPRITE_BIG_LAPRAS ; 47
	const SPRITE_GYM_GUIDE ; 48
	const SPRITE_SAILOR ; 49
	const SPRITE_BIKER ; 4a
	const SPRITE_PHARMACIST ; 4b
	const SPRITE_MONSTER ; 4c
	const SPRITE_FAIRY ; 4d
	const SPRITE_BIRD ; 4e
	const SPRITE_DRAGON ; 4f
	const SPRITE_BIG_ONIX ; 50
	const SPRITE_N64 ; 51
	const SPRITE_SUDOWOODO ; 52
	const SPRITE_SURF ; 53
	const SPRITE_POKE_BALL ; 54
	const SPRITE_POKEDEX ; 55
	const SPRITE_PAPER ; 56
	const SPRITE_VIRTUAL_BOY ; 57
	const SPRITE_OLD_LINK_RECEPTIONIST ; 58
	const SPRITE_ROCK ; 59
	const SPRITE_BOULDER ; 5a
	const SPRITE_SNES ; 5b
	const SPRITE_FAMICOM ; 5c
	const SPRITE_FRUIT_TREE ; 5d
	const SPRITE_GOLD_TROPHY ; 5e
	const SPRITE_SILVER_TROPHY ; 5f
	const SPRITE_KRIS ; 60
	const SPRITE_KRIS_BIKE ; 61
	const SPRITE_KURT_OUTSIDE ; 62
	const SPRITE_SUICUNE ; 63
	const SPRITE_ENTEI ; 64
	const SPRITE_RAIKOU ; 65
	const SPRITE_STANDING_YOUNGSTER ; 66
	const SPRITE_PIKACHU_FOLLOWER   ; 67
	const SPRITE_KANTO_RIVAL        ; 68 (Yellow's young Blue)
	const SPRITE_OLD_MAN            ; 69 (Yellow's Viridian old man)
	const SPRITE_JESSIE             ; 6a (Yellow's Jessie)
	const SPRITE_JAMES              ; 6b (Yellow's James)
	const SPRITE_FOSSIL             ; 6c (Yellow's fossil prop, still)
	const SPRITE_OLD_AMBER          ; 6d (Yellow's old amber prop, still)
	const SPRITE_CHANSEY            ; 6e (Yellow's Pokemon Center Chansey)
; Melanie's house (docs/M3-CERULEAN.md 6g).  Crystal already has SPRITE_ODDISH
; ($85) and SPRITE_BULBASAUR ($93), but those are SpriteMons indexes drawn from
; the party-menu icons; these three are Yellow's dedicated 16x48 overworld
; sheets, hence the _OW suffix on the two that collide.
	const SPRITE_SANDSHREW          ; 6f (Yellow's overworld SANDSHREW)
	const SPRITE_ODDISH_OW          ; 70 (Yellow's overworld ODDISH)
	const SPRITE_BULBASAUR_OW       ; 71 (Yellow's overworld BULBASAUR)
; Pewter #MON Center (docs/JIGGLYPUFF.md J1).  Same story as ODDISH/BULBASAUR:
; Crystal's SPRITE_JIGGLYPUFF ($94) is a SpriteMons party-icon index with only a
; down facing, and the Jigglypuff song spins the sprite through all four.
	const SPRITE_JIGGLYPUFF_OW      ; 72 (Yellow's overworld JIGGLYPUFF)
; POKeMON FAN CLUB (docs/M4-VERMILION.md 7f).  Yellow's SEEL has no Crystal
; counterpart at all; Crystal's SPRITE_CLEFAIRY ($8f) is a SpriteMons party-icon
; index and its SPRITE_FAIRY ($4d) is a different (CLEFAIRY DOLL) sheet, so both
; of these are Yellow's own 16x48 overworld art.
	const SPRITE_SEEL_OW            ; 73 (Yellow's overworld SEEL)
	const SPRITE_CLEFAIRY_OW        ; 74 (Yellow's overworld CLEFAIRY)
	const SPRITE_OLD_MAN_ASLEEP_OW  ; 75 (Yellow's lying-asleep gambler)
; POKeMON TOWER / Lavender (docs/M5-LAVENDER.md 8a).  Neither sheet exists in
; Crystal: the CHANNELER is Yellow's mourner/Rocket-possessed woman and MR FUJI
; is the tower's old man.  Both are Yellow's own 16x96 walking sheets, copied
; byte for byte (Gen 1 and Gen 2 use the same 6-frame overworld layout -- 14 of
; the two games' sprite PNGs are already bit-identical, e.g. biker and oak).
	const SPRITE_CHANNELER          ; 76 (Yellow's CHANNELER)
	const SPRITE_MR_FUJI            ; 77 (Yellow's MR FUJI)
	const SPRITE_GIOVANNI           ; 78 (Yellow's GIOVANNI)
; Kanto hack (M7 10a, docs/M7-FUCHSIA.md D57/D58): the SAFARI ZONE's and
; FUCHSIA's Yellow faces.  Every id must stay below SPRITE_POKEMON ($80).
	const SPRITE_WARDEN             ; 79 (Yellow's WARDEN)
	const SPRITE_SAFARI_ZONE_WORKER ; 7a (Yellow's SAFARI ZONE WORKER)
	const SPRITE_SILPH_WORKER_M     ; 7b (Yellow's SILPH WORKER M)
	const SPRITE_SILPH_WORKER_F     ; 7c (Yellow's SILPH WORKER F)
; Kanto hack (M8 11a, docs/M8-SAFFRON.md D80): SILPH CO.'s president, the man
; Giovanni is interrogating on 11F.  Yellow's own 16x48 static, and the last
; face M8 buys -- $7e and $7f are all that is left below SPRITE_POKEMON ($80).
	const SPRITE_SILPH_PRESIDENT    ; 7d (Yellow's SILPH CO. PRESIDENT)
; D58 asked for a fifth id, SPRITE_KOGA -- but Crystal already has one at $21
; (ELITE FOUR KOGA, maps/KogasRoom.asm), and FUCHSIA's gym leader is the same
; man.  FUCHSIA GYM reuses it in 10h; no new id is spent.
DEF NUM_OVERWORLD_SPRITES EQU const_value - 1

; Pikachu follower: fixed VRAM tile (bank 1) reserved outside the shared
; sprite-GFX budget, so it can never be dropped on crowded maps. Its walking
; frames land at $ec-$f7, just below the emote tiles at $f8.
DEF FOLLOWER_VTILE EQU $6c

; SpriteMons indexes (see data/sprites/sprite_mons.asm)
	const_next $80
DEF SPRITE_POKEMON EQU const_value
	const SPRITE_UNOWN ; 80
	const SPRITE_GEODUDE ; 81
	const SPRITE_GROWLITHE ; 82
	const SPRITE_WEEDLE ; 83
	const SPRITE_SHELLDER ; 84
	const SPRITE_ODDISH ; 85
	const SPRITE_GENGAR ; 86
	const SPRITE_ZUBAT ; 87
	const SPRITE_MAGIKARP ; 88
	const SPRITE_SQUIRTLE ; 89
	const SPRITE_TOGEPI ; 8a
	const SPRITE_BUTTERFREE ; 8b
	const SPRITE_DIGLETT ; 8c
	const SPRITE_POLIWAG ; 8d
	const SPRITE_PIKACHU ; 8e
	const SPRITE_CLEFAIRY ; 8f
	const SPRITE_CHARMANDER ; 90
	const SPRITE_JYNX ; 91
	const SPRITE_STARMIE ; 92
	const SPRITE_BULBASAUR ; 93
	const SPRITE_JIGGLYPUFF ; 94
	const SPRITE_GRIMER ; 95
	const SPRITE_EKANS ; 96
	const SPRITE_PARAS ; 97
	const SPRITE_TENTACOOL ; 98
	const SPRITE_TAUROS ; 99
	const SPRITE_MACHOP ; 9a
	const SPRITE_VOLTORB ; 9b
	const SPRITE_LAPRAS ; 9c
	const SPRITE_RHYDON ; 9d
	const SPRITE_MOLTRES ; 9e
	const SPRITE_SNORLAX ; 9f
	const SPRITE_GYARADOS ; a0
	const SPRITE_LUGIA ; a1
	const SPRITE_HO_OH ; a2
DEF NUM_POKEMON_SPRITES EQU const_value - SPRITE_POKEMON

; special GetMonSprite values (see engine/overworld/overworld.asm)
	const_next $e0
	const SPRITE_DAY_CARE_MON_1 ; e0
	const SPRITE_DAY_CARE_MON_2 ; e1

; wVariableSprites indexes (see wram.asm)
	const_next $f0
DEF SPRITE_VARS EQU const_value
	const SPRITE_CONSOLE ; f0
	const SPRITE_DOLL_1 ; f1
	const SPRITE_DOLL_2 ; f2
	const SPRITE_BIG_DOLL ; f3
	const SPRITE_WEIRD_TREE ; f4
	const SPRITE_OLIVINE_RIVAL ; f5
	const SPRITE_AZALEA_ROCKET ; f6
	const SPRITE_FUCHSIA_GYM_1 ; f7
	const SPRITE_FUCHSIA_GYM_2 ; f8
	const SPRITE_FUCHSIA_GYM_3 ; f9
	const SPRITE_FUCHSIA_GYM_4 ; fa
	const SPRITE_COPYCAT ; fb
	const SPRITE_JANINE_IMPERSONATOR ; fc
