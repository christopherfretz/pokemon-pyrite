CreditsScript:

; Clear the banner.
	db CREDITS_CLEAR

; Pokemon Crystal Version Staff
	db                STAFF, 1

	db CREDITS_WAIT, 8

; Play the credits music.
	db CREDITS_MUSIC

	db CREDITS_WAIT2, 10

	db CREDITS_WAIT, 1

; Update the banner.
	db CREDITS_SCENE, 0 ; Pichu

	db             DIRECTOR, 1
	db       SATOSHI_TAJIRI, 2

	db CREDITS_WAIT, 12

	db           CODIRECTOR, 1
	db       JUNICHI_MASUDA, 2

	db CREDITS_WAIT, 12

	db          PROGRAMMERS, 0
	db       SOUSUKE_TAMADA, 1
	db       HISASHI_SOGABE, 2
	db         KEITA_KAGAYA, 3
	db    YOSHINORI_MATSUDA, 4

	db CREDITS_WAIT, 12

	db          PROGRAMMERS, 0
	db     SHIGEKI_MORIMOTO, 1
	db     TETSUYA_WATANABE, 2
	db        TAKENORI_OOTA, 3

	db CREDITS_WAIT, 12

	db    GRAPHICS_DIRECTOR, 1
	db         KEN_SUGIMORI, 2

	db CREDITS_WAIT, 12

	db       MONSTER_DESIGN, 0
	db         KEN_SUGIMORI, 1
	db    MOTOFUMI_FUJIWARA, 2
	db     SHIGEKI_MORIMOTO, 3
	db     HIRONOBU_YOSHIDA, 4
	db         SATOSHI_OOTA, 5

	db CREDITS_WAIT, 12

	db       MONSTER_DESIGN, 0
	db       ATSUKO_NISHIDA, 1
	db          MUNEO_SAITO, 2
	db       RENA_YOSHIKAWA, 3

	db CREDITS_WAIT, 12

	db    POKEMON_ANIMATION, 1
	db     HIRONOBU_YOSHIDA, 2
	db          JUN_OKUTANI, 3

	db CREDITS_WAIT, 12

; Clear the banner.
	db CREDITS_CLEAR

	db CREDITS_WAIT, 1

; Update the banner.
	db CREDITS_SCENE, 1 ; Smoochum

	db      GRAPHICS_DESIGN, 0
	db     HIRONOBU_YOSHIDA, 1
	db          JUN_OKUTANI, 2
	db       ASUKA_IWASHITA, 3
	db     TETSUYA_WATANABE, 4

	db CREDITS_WAIT, 12

	db         CREDIT_MUSIC, 0
	db       JUNICHI_MASUDA, 1
	db        MORIKAZU_AOKI, 2
	db          GO_ICHINOSE, 3

	db CREDITS_WAIT, 12

	db CREDIT_SOUND_EFFECTS, 0
	db        MORIKAZU_AOKI, 1
	db       JUNICHI_MASUDA, 2
	db     TETSUYA_WATANABE, 3

	db CREDITS_WAIT, 12

	db          GAME_DESIGN, 0
	db       JUNICHI_MASUDA, 1
	db     SHIGEKI_MORIMOTO, 2
	db        KOHJI_NISHINO, 3

	db CREDITS_WAIT, 12

	db          GAME_DESIGN, 0
	db         TETSUJI_OOTA, 1
	db          HITOMI_SATO, 2
	db     KENJI_MATSUSHIMA, 3

	db CREDITS_WAIT, 12

	db        GAME_SCENARIO, 0
	db       JUNICHI_MASUDA, 1
	db        KOHJI_NISHINO, 2
	db  TOSHINOBU_MATSUMIYA, 3
	db     KENJI_MATSUSHIMA, 4

	db CREDITS_WAIT, 12

	db         POKEDEX_TEXT, 1
	db  TOSHINOBU_MATSUMIYA, 2

	db CREDITS_WAIT, 12

	db     TOOL_PROGRAMMING, 1
	db       SOUSUKE_TAMADA, 2
	db        TAKENORI_OOTA, 3

	db CREDITS_WAIT, 12

	db    PARAMETRIC_DESIGN, 1
	db        KOHJI_NISHINO, 2

	db CREDITS_WAIT, 12

; Clear the banner.
	db CREDITS_CLEAR

	db CREDITS_WAIT, 1

; Update the banner.
	db CREDITS_SCENE, 2 ; Ditto

	db        SCRIPT_DESIGN, 1
	db         TETSUJI_OOTA, 2
	db        NOBUHIRO_SEYA, 3

	db CREDITS_WAIT, 12

	db      MAP_DATA_DESIGN, 1
	db         TETSUJI_OOTA, 2
	db      KAZUHITO_SEKINE, 3

	db CREDITS_WAIT, 12

	db           MAP_DESIGN, 0
	db         TETSUJI_OOTA, 1
	db        KOHJI_NISHINO, 2
	db        NOBUHIRO_SEYA, 3

	db CREDITS_WAIT, 12

	db         COORDINATION, 1
	db      HIROYUKI_ZINNAI, 2

	db CREDITS_WAIT, 12

	db            PRODUCERS, 0
	db         SATORU_IWATA, 1
	db       SATOSHI_YAMATO, 2
	db     SHIGERU_MIYAMOTO, 3

	db CREDITS_WAIT, 12

	db            PRODUCERS, 1
	db   TSUNEKAZU_ISHIHARA, 2

	db CREDITS_WAIT, 12

; Clear the banner.
	db CREDITS_CLEAR

	db CREDITS_WAIT, 1

; Update the banner.
	db CREDITS_SCENE, 3 ; Igglybuff

	db     US_VERSION_STAFF, 2

	db CREDITS_WAIT, 9

	db      US_COORDINATION, 1
	db          GAIL_TILDEN, 2
	db        HIRO_NAKAMURA, 3

	db CREDITS_WAIT, 12

	db      US_COORDINATION, 1
	db       JUNICHI_MASUDA, 2
	db        SETH_MCMAHILL, 3

	db CREDITS_WAIT, 12

	db      US_COORDINATION, 1
	db     HIROTO_ALEXANDER, 2
	db     TERESA_LILLYGREN, 3

	db CREDITS_WAIT, 12

	db     TEXT_TRANSLATION, 1
	db        NOB_OGASAWARA, 2

	db CREDITS_WAIT, 12

	db          PROGRAMMERS, 1
	db      TERUKI_MURAKAWA, 2
	db      KAZUYOSHI_OSAWA, 3

	db CREDITS_WAIT, 12

	db         PAAD_TESTING, 1
	db       THOMAS_HERTZOG, 2
	db         ERIK_JOHNSON, 3

	db CREDITS_WAIT, 12

	db      PRODUCT_TESTING, 0
	db             PLANNING, 1

	db CREDITS_WAIT, 12

	db      PRODUCT_TESTING, 0
	db       KEITA_NAKAMURA, 1
	db      HIROTAKA_UEMURA, 2
	db       HIROAKI_TAMURA, 3
	db    NORIAKI_SAKAGUCHI, 4

	db CREDITS_WAIT, 12

	db      PRODUCT_TESTING, 0
	db NCL_SUPER_MARIO_CLUB, 1
	db          KENJI_SAIKI, 2
	db         ATSUSHI_TADA, 3
	db          MIYUKI_SATO, 4

	db CREDITS_WAIT, 12

	db       SPECIAL_THANKS, 0
	db     KIMIKO_NAKAMICHI, 1
	db           AKITO_MORI, 2

	db CREDITS_WAIT, 12

	db       SPECIAL_THANKS, 0
	db        GAKUZI_NOMOTO, 1
	db           AI_MASHIMA, 2
	db      KUNIMI_KAWAMURA, 3

	db CREDITS_WAIT, 12

	db       SPECIAL_THANKS, 0
	db    MIKIHIRO_ISHIKAWA, 1
	db   HIDEYUKI_HASHIMOTO, 2

	db CREDITS_WAIT, 12

	db   EXECUTIVE_PRODUCER, 1
	db     HIROSHI_YAMAUCHI, 2

	db CREDITS_WAIT, 12

	db            COPYRIGHT, 1

	db CREDITS_WAIT, 9

; Display "The End" graphic.
	db CREDITS_THEEND

	db CREDITS_WAIT, 20

	db CREDITS_END

; Kanto hack (M10 13k, D111): the credits after the Kanto HALL OF FAME.
; Yellow's staff (vendor/pokeyellow/data/credits/credits_order.asm, 30 pages
; between "#MON YELLOW VERSION" and the copyright) in Crystal's engine, with
; Crystal's four banner scenes, music and pacing.  Crystal's script spends
; ~441 ticks on its 36 staff pages (12 each + one 9); Yellow's 30 pages get 15
; ticks each (the first 24) or 14 (the last six), 444, so the page flips still
; end with the music.
; Credits:: starts here when wSpawnAfterChampion is SPAWN_KANTO_CHAMPION.
KantoCreditsScript:

	db CREDITS_CLEAR

; Pokemon Yellow Version Staff
	db          KANTO_STAFF, 1

	db CREDITS_WAIT, 8

	db CREDITS_MUSIC

	db CREDITS_WAIT2, 10

	db CREDITS_WAIT, 1

	db CREDITS_SCENE, 0 ; Pichu

	db             DIRECTOR, 1
	db       SATOSHI_TAJIRI, 2

	db CREDITS_WAIT, 15

	db          PROGRAMMERS, 0
	db        TAKENORI_OOTA, 1
	db     SHIGEKI_MORIMOTO, 2
	db     TETSUYA_WATANABE, 3

	db CREDITS_WAIT, 15

	db          PROGRAMMERS, 0
	db       JUNICHI_MASUDA, 1
	db       SOUSUKE_TAMADA, 2

	db CREDITS_WAIT, 15

	db     CHARACTER_DESIGN, 0
	db         KEN_SUGIMORI, 1
	db       ATSUKO_NISHIDA, 2

	db CREDITS_WAIT, 15

	db         CREDIT_MUSIC, 1
	db       JUNICHI_MASUDA, 2

	db CREDITS_WAIT, 15

	db CREDIT_SOUND_EFFECTS, 0
	db       JUNICHI_MASUDA, 1
	db     TETSUYA_WATANABE, 2

	db CREDITS_WAIT, 15

	db          GAME_DESIGN, 0
	db       SATOSHI_TAJIRI, 1
	db        KOHJI_NISHINO, 2

	db CREDITS_WAIT, 15

	db       MONSTER_DESIGN, 0
	db         KEN_SUGIMORI, 1
	db       ATSUKO_NISHIDA, 2
	db     HIRONOBU_YOSHIDA, 3

	db CREDITS_WAIT, 15

	db CREDITS_CLEAR

	db CREDITS_WAIT, 1

	db CREDITS_SCENE, 1 ; Smoochum

	db        GAME_SCENARIO, 1
	db       SATOSHI_TAJIRI, 2

	db CREDITS_WAIT, 15

	db        GAME_SCENARIO, 1
	db  TOSHINOBU_MATSUMIYA, 2

	db CREDITS_WAIT, 15

	db    PARAMETRIC_DESIGN, 1
	db        KOHJI_NISHINO, 2

	db CREDITS_WAIT, 15

	db           MAP_DESIGN, 0
	db       SATOSHI_TAJIRI, 1
	db        KOHJI_NISHINO, 2
	db        NOBUHIRO_SEYA, 3

	db CREDITS_WAIT, 15

	db      PRODUCT_TESTING, 0
	db      KAZUHITO_SEKINE, 1
	db        NOBUHIRO_SEYA, 2

	db CREDITS_WAIT, 15

	db      PRODUCT_TESTING, 0
	db    KAZUSHI_SHIMAMURA, 1
	db TERUYUKI_SHIMOYAMADA, 2

	db CREDITS_WAIT, 15

	db       SPECIAL_THANKS, 1
	db           SHOGAKUKAN, 2

	db CREDITS_WAIT, 15

	db        PIKACHU_VOICE, 1
	db          IKUE_OOTANI, 2

	db CREDITS_WAIT, 15

	db CREDITS_CLEAR

	db CREDITS_WAIT, 1

	db CREDITS_SCENE, 2 ; Ditto

	db             PRODUCER, 1
	db      TAKEHIRO_IZUSHI, 2

	db CREDITS_WAIT, 15

	db             PRODUCER, 1
	db    TAKASHI_KAWAGUCHI, 2

	db CREDITS_WAIT, 15

	db             PRODUCER, 1
	db   TSUNEKAZU_ISHIHARA, 2

	db CREDITS_WAIT, 15

	db     US_VERSION_STAFF, 2

	db CREDITS_WAIT, 15

	db      US_COORDINATION, 1
	db          GAIL_TILDEN, 2

	db CREDITS_WAIT, 15

	db      US_COORDINATION, 0
	db       NAOKO_KAWAKAMI, 1
	db        HIRO_NAKAMURA, 2

	db CREDITS_WAIT, 15

	db      US_COORDINATION, 0
	db       RANDY_SHOEMAKE, 1
	db         SARA_OSBORNE, 2

	db CREDITS_WAIT, 15

	db CREDITS_CLEAR

	db CREDITS_WAIT, 1

	db CREDITS_SCENE, 3 ; Igglybuff

	db     TEXT_TRANSLATION, 1
	db        NOB_OGASAWARA, 2

	db CREDITS_WAIT, 15

	db          PROGRAMMERS, 0
	db      TERUKI_MURAKAWA, 1
	db          KOHTA_FUKUI, 2

	db CREDITS_WAIT, 14

	db     CHARACTER_DESIGN, 1
	db    TAKEHIKO_HOSOKAWA, 2

	db CREDITS_WAIT, 14

	db       SPECIAL_THANKS, 0
	db          KENJI_OKUBO, 1
	db      TAKAHIRO_HARADA, 2

	db CREDITS_WAIT, 14

	db       SPECIAL_THANKS, 0
	db     KIMIKO_NAKAMICHI, 1
	db      KAMON_YOSHIMURA, 2
	db       SAKAE_YAMAZAKI, 3

	db CREDITS_WAIT, 14

	db      PRODUCT_TESTING, 0
	db         PAAD_TESTING, 1
	db NCL_SUPER_MARIO_CLUB, 2

	db CREDITS_WAIT, 14

	db   EXECUTIVE_PRODUCER, 1
	db     HIROSHI_YAMAUCHI, 2

	db CREDITS_WAIT, 14

	db            COPYRIGHT, 1

	db CREDITS_WAIT, 9

	db CREDITS_THEEND

	db CREDITS_WAIT, 20

	db CREDITS_END
