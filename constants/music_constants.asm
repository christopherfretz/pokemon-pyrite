; song ids
; Music indexes (see audio/music_pointers.asm)
	const_def
	const MUSIC_NONE                         ; 00
	const MUSIC_TITLE                        ; 01
	const MUSIC_ROUTE_1                      ; 02
	const MUSIC_ROUTE_3                      ; 03
	const MUSIC_ROUTE_12                     ; 04
	const MUSIC_MAGNET_TRAIN                 ; 05
	const MUSIC_KANTO_GYM_LEADER_BATTLE      ; 06
	const MUSIC_KANTO_TRAINER_BATTLE         ; 07
	const MUSIC_KANTO_WILD_BATTLE            ; 08
	const MUSIC_POKEMON_CENTER               ; 09
	const MUSIC_HIKER_ENCOUNTER              ; 0a
	const MUSIC_LASS_ENCOUNTER               ; 0b
	const MUSIC_OFFICER_ENCOUNTER            ; 0c
	const MUSIC_HEAL                         ; 0d
	const MUSIC_LAVENDER_TOWN                ; 0e
	const MUSIC_ROUTE_2                      ; 0f
	const MUSIC_MT_MOON                      ; 10
	const MUSIC_SHOW_ME_AROUND               ; 11
	const MUSIC_GAME_CORNER                  ; 12
	const MUSIC_BICYCLE                      ; 13
	const MUSIC_HALL_OF_FAME                 ; 14
	const MUSIC_VIRIDIAN_CITY                ; 15
	const MUSIC_CELADON_CITY                 ; 16
	const MUSIC_TRAINER_VICTORY              ; 17
	const MUSIC_WILD_VICTORY                 ; 18
	const MUSIC_GYM_VICTORY                  ; 19
	const MUSIC_MT_MOON_SQUARE               ; 1a
	const MUSIC_GYM                          ; 1b
	const MUSIC_PALLET_TOWN                  ; 1c
	const MUSIC_POKEMON_TALK                 ; 1d
	const MUSIC_PROF_OAK                     ; 1e
	const MUSIC_RIVAL_ENCOUNTER              ; 1f
	const MUSIC_RIVAL_AFTER                  ; 20
	const MUSIC_SURF                         ; 21
	const MUSIC_EVOLUTION                    ; 22
	const MUSIC_NATIONAL_PARK                ; 23
	const MUSIC_CREDITS                      ; 24
	const MUSIC_AZALEA_TOWN                  ; 25
	const MUSIC_CHERRYGROVE_CITY             ; 26
	const MUSIC_KIMONO_ENCOUNTER             ; 27
	const MUSIC_UNION_CAVE                   ; 28
	const MUSIC_JOHTO_WILD_BATTLE            ; 29
	const MUSIC_JOHTO_TRAINER_BATTLE         ; 2a
	const MUSIC_ROUTE_30                     ; 2b
	const MUSIC_ECRUTEAK_CITY                ; 2c
	const MUSIC_VIOLET_CITY                  ; 2d
	const MUSIC_JOHTO_GYM_LEADER_BATTLE      ; 2e
	const MUSIC_CHAMPION_BATTLE              ; 2f
	const MUSIC_RIVAL_BATTLE                 ; 30
	const MUSIC_ROCKET_BATTLE                ; 31
	const MUSIC_PROF_ELM                     ; 32
	const MUSIC_DARK_CAVE                    ; 33
	const MUSIC_ROUTE_29                     ; 34
	const MUSIC_ROUTE_36                     ; 35
	const MUSIC_SS_AQUA                      ; 36
	const MUSIC_YOUNGSTER_ENCOUNTER          ; 37
	const MUSIC_BEAUTY_ENCOUNTER             ; 38
	const MUSIC_ROCKET_ENCOUNTER             ; 39
	const MUSIC_POKEMANIAC_ENCOUNTER         ; 3a
	const MUSIC_SAGE_ENCOUNTER               ; 3b
	const MUSIC_NEW_BARK_TOWN                ; 3c
	const MUSIC_GOLDENROD_CITY               ; 3d
	const MUSIC_VERMILION_CITY               ; 3e
	const MUSIC_POKEMON_CHANNEL              ; 3f
	const MUSIC_POKE_FLUTE_CHANNEL           ; 40
	const MUSIC_TIN_TOWER                    ; 41
	const MUSIC_SPROUT_TOWER                 ; 42
	const MUSIC_BURNED_TOWER                 ; 43
	const MUSIC_LIGHTHOUSE                   ; 44
	const MUSIC_LAKE_OF_RAGE                 ; 45
	const MUSIC_INDIGO_PLATEAU               ; 46
	const MUSIC_ROUTE_37                     ; 47
	const MUSIC_ROCKET_HIDEOUT               ; 48
	const MUSIC_DRAGONS_DEN                  ; 49
	const MUSIC_JOHTO_WILD_BATTLE_NIGHT      ; 4a
	const MUSIC_RUINS_OF_ALPH_RADIO          ; 4b
	const MUSIC_CAPTURE                      ; 4c
	const MUSIC_ROUTE_26                     ; 4d
	const MUSIC_MOM                          ; 4e
	const MUSIC_VICTORY_ROAD                 ; 4f
	const MUSIC_POKEMON_LULLABY              ; 50
	const MUSIC_POKEMON_MARCH                ; 51
	const MUSIC_GS_OPENING                   ; 52
	const MUSIC_GS_OPENING_2                 ; 53
	const MUSIC_MAIN_MENU                    ; 54
	const MUSIC_RUINS_OF_ALPH_INTERIOR       ; 55
	const MUSIC_ROCKET_OVERTURE              ; 56
	const MUSIC_DANCING_HALL                 ; 57
	const MUSIC_BUG_CATCHING_CONTEST_RANKING ; 58
	const MUSIC_BUG_CATCHING_CONTEST         ; 59
	const MUSIC_LAKE_OF_RAGE_ROCKET_RADIO    ; 5a
	const MUSIC_PRINTER                      ; 5b
	const MUSIC_POST_CREDITS                 ; 5c
; new to Crystal
	const MUSIC_CLAIR                        ; 5d
	const MUSIC_MOBILE_ADAPTER_MENU          ; 5e
	const MUSIC_MOBILE_ADAPTER               ; 5f
	const MUSIC_BUENAS_PASSWORD              ; 60
	const MUSIC_MYSTICALMAN_ENCOUNTER        ; 61
	const MUSIC_CRYSTAL_OPENING              ; 62
	const MUSIC_BATTLE_TOWER_THEME           ; 63
	const MUSIC_SUICUNE_BATTLE               ; 64
	const MUSIC_BATTLE_TOWER_LOBBY           ; 65
	const MUSIC_MOBILE_CENTER                ; 66
; Kanto hack
	const MUSIC_MEET_JESSIE_JAMES            ; 67 (Yellow's Jessie & James theme)
	const MUSIC_JIGGLYPUFF_SONG              ; 68 (Yellow's JIGGLYPUFF SONG)
	; Kanto hack (M7 10a, docs/M7-FUCHSIA.md D59): the SAFARI ZONE's own id.  It
	; pointed at the BUG CATCHING CONTEST track until K6c ported Yellow's
	; Music_SafariZone (docs/K6-MUSIC.md).
	const MUSIC_SAFARI_ZONE                  ; 69
	; Kanto hack (K6a, docs/K6-MUSIC.md): Yellow's "rival appears" theme, twice
	; -- a straight port (_YELLOW) and a Crystal-style re-voicing (_GSC) -- each
	; with Yellow's three alternate entries (audio/alternate_tempo.asm): ALT_START
	; skips the intro (after-battle walk-offs), ALT_TEMPO is ch1 `tempo 100` for
	; ROUTE 22's second meeting, ALT_START_TEMPO is both.  Keep each block of
	; four in this order: the RIVAL_THEME_* offsets below depend on it.
	const MUSIC_MEET_RIVAL_YELLOW                 ; 6a
	const MUSIC_MEET_RIVAL_YELLOW_ALT_START       ; 6b
	const MUSIC_MEET_RIVAL_YELLOW_ALT_TEMPO       ; 6c
	const MUSIC_MEET_RIVAL_YELLOW_ALT_START_TEMPO ; 6d
	const MUSIC_MEET_RIVAL_GSC                    ; 6e
	const MUSIC_MEET_RIVAL_GSC_ALT_START          ; 6f
	const MUSIC_MEET_RIVAL_GSC_ALT_TEMPO          ; 70
	const MUSIC_MEET_RIVAL_GSC_ALT_START_TEMPO    ; 71
	const MUSIC_POKEMON_TOWER                ; 72 (Yellow's POKEMON TOWER, K6a)
	const MUSIC_SS_ANNE                      ; 73 (Yellow's S.S. ANNE, K6a)
	; Kanto hack (K6c, docs/K6-MUSIC.md): six more ids.  _YELLOW where Crystal
	; already has a song of that name (its Lavender / Game Corner stay for Johto).
	const MUSIC_LAVENDER_YELLOW              ; 74 (Yellow's MUSIC_LAVENDER)
	const MUSIC_DUNGEON1                     ; 75 (Hideout, Power Plant, Bruno, Cerulean Cave)
	const MUSIC_DUNGEON2                     ; 76 (Viridian Forest, Diglett's Cave, Seafoam)
	const MUSIC_DUNGEON3                     ; 77 (Mt. Moon, Rock Tunnel, Victory Road)
	const MUSIC_GAME_CORNER_YELLOW           ; 78 (Yellow's MUSIC_GAME_CORNER)
	const MUSIC_SURFING                      ; 79 (Yellow's surf theme; Kanto act only)
	; Kanto hack (K6d, docs/K6-MUSIC.md): Yellow's last three tracks ($7d-$7f stay free).
	const MUSIC_SILPH_CO_YELLOW              ; 7a (Yellow's MUSIC_SILPH_CO; see the MUSIC_SILPH_CO alias below)
	const MUSIC_POKEMON_MANSION_YELLOW       ; 7b (Yellow's MUSIC_CINNABAR_MANSION)
	const MUSIC_BIKE_RIDING_YELLOW           ; 7c (Yellow's MUSIC_BIKE_RIDING; Kanto act only, GetBikeMusic)
	; M12b-3 (docs/M12-STRETCH.md): the Surfing Pikachu minigame ($7e-$7f stay free).
	const MUSIC_SURFING_PIKACHU              ; 7d
DEF NUM_MUSIC_SONGS EQU const_value

; Kanto hack (K6a): the rival-theme A/B switch.  Every Kanto rival scene plays
; MUSIC_KANTO_RIVAL + RIVAL_THEME_*; ROUTE 22's FIRST meeting (the 2nd time you
; meet him) plays MUSIC_KANTO_RIVAL_AB + RIVAL_THEME_* so one normal playthrough
; hears both arrangements.  Flip either line between MUSIC_MEET_RIVAL_YELLOW and
; MUSIC_MEET_RIVAL_GSC to move the whole game (or just that encounter) over.
DEF MUSIC_KANTO_RIVAL    EQU MUSIC_MEET_RIVAL_YELLOW
DEF MUSIC_KANTO_RIVAL_AB EQU MUSIC_MEET_RIVAL_GSC
DEF RIVAL_THEME_INTRO           EQU 0 ; Yellow: PlayMusic MUSIC_MEET_RIVAL
DEF RIVAL_THEME_ALT_START       EQU 1 ; Yellow: Music_RivalAlternateStart
DEF RIVAL_THEME_ALT_TEMPO       EQU 2 ; Yellow: Music_RivalAlternateTempo
DEF RIVAL_THEME_ALT_START_TEMPO EQU 3 ; Yellow: Music_RivalAlternateStartAndTempo

; Kanto hack (M8 11a, docs/M8-SAFFRON.md D82): SILPH CO. has a name of its own
; so the twelve Silph maps are repointed in one line.  It was an alias of the
; ROCKET HIDEOUT theme until K6d ported Yellow's Music_SilphCo.
DEF MUSIC_SILPH_CO EQU MUSIC_SILPH_CO_YELLOW

; GetMapMusic picks music for this value (see home/map.asm)
; this overlaps with a Crystal song ID, but not one that is used for map music
DEF MUSIC_MAHOGANY_MART EQU MUSIC_SUICUNE_BATTLE

; ExitPokegearRadio_HandleMusic uses these values
DEF RESTART_MAP_MUSIC EQU $fe
DEF ENTER_MAP_MUSIC   EQU $ff

; GetMapMusic picks music for this bit flag
	const_def 7
	shift_const RADIO_TOWER_MUSIC
assert NUM_MUSIC_SONGS <= RADIO_TOWER_MUSIC, "song IDs overlap RADIO_TOWER_MUSIC"
