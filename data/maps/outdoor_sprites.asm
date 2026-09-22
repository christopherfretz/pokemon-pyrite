; Valid sprite IDs for each map group.
; Maps with environment ROUTE or TOWN can only use these sprites.

OutdoorSprites:
; entries correspond to MAPGROUP_* constants
	table_width 2
	dw OlivineGroupSprites
	dw MahoganyGroupSprites
	dw DungeonsGroupSprites
	dw EcruteakGroupSprites
	dw BlackthornGroupSprites
	dw CinnabarGroupSprites
	dw CeruleanGroupSprites
	dw AzaleaGroupSprites
	dw LakeOfRageGroupSprites
	dw VioletGroupSprites
	dw GoldenrodGroupSprites
	dw VermilionGroupSprites
	dw PalletGroupSprites
	dw PewterGroupSprites
	dw FastShipGroupSprites
	dw IndigoGroupSprites
	dw FuchsiaGroupSprites
	dw LavenderGroupSprites
	dw SilverGroupSprites
	dw CableClubGroupSprites
	dw CeladonGroupSprites
	dw CianwoodGroupSprites
	dw ViridianGroupSprites
	dw NewBarkGroupSprites
	dw SaffronGroupSprites
	dw CherrygroveGroupSprites
	assert_table_length NUM_MAP_GROUPS

PalletGroupSprites:
	db SPRITE_OAK
	db SPRITE_TWIN
	db SPRITE_YOUNGSTER
	db SPRITE_FISHER
; Kanto hack (M9 12c): ROUTE 21's swimmers, one connection south of PALLET.
; Yellow uses one swimmer sheet for every swimmer on ROUTES 19/20/21, and it is
; SWIMMER_GUY.  A walking sheet, so it goes ahead of the still ones.
	db SPRITE_SWIMMER_GUY
; Kanto hack (L2): VIRIDIAN CITY's own sprites, so walking Route 1 -> VIRIDIAN
; CITY finds them already loaded and RefreshConnectionSprites' ~27-frame reload
; never fires on the line the player crosses most.  A group's list must cover
; its own outdoor maps plus every map one connection away; trim_outdoor_sprites
; --report checks both.
	db SPRITE_FRUIT_TREE
	db SPRITE_OLD_MAN
	db SPRITE_OLD_MAN_ASLEEP_OW
rept MAX_OUTDOOR_SPRITES - 8
	db 0 ; AddOutdoorSprites always reads MAX_OUTDOOR_SPRITES entries
endr

ViridianGroupSprites:
	db SPRITE_COOLTRAINER_F
	db SPRITE_BUG_CATCHER
	db SPRITE_TWIN
	db SPRITE_YOUNGSTER
	db SPRITE_FISHER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
	db SPRITE_KANTO_RIVAL
	db SPRITE_OLD_MAN
	db SPRITE_OLD_MAN_ASLEEP_OW
rept MAX_OUTDOOR_SPRITES - 10
	db 0 ; AddOutdoorSprites always reads MAX_OUTDOOR_SPRITES entries
endr

PewterGroupSprites:
	db SPRITE_COOLTRAINER_M
	db SPRITE_COOLTRAINER_F
	db SPRITE_BUG_CATCHER
	db SPRITE_YOUNGSTER
	db SPRITE_SUPER_NERD
	db SPRITE_GRAMPS
	db SPRITE_FRUIT_TREE
rept MAX_OUTDOOR_SPRITES - 7
	db 0 ; AddOutdoorSprites always reads MAX_OUTDOOR_SPRITES entries
endr

CinnabarGroupSprites:
; Kanto hack (M9 12c, re-derived 12g; gotcha G15): written by
; scripts/trim_outdoor_sprites.py --write Cinnabar.  The group's own outdoor
; maps (ROUTEs 19/20/21 and CINNABAR ISLAND) use five sheets -- SWIMMER_GUY,
; COOLTRAINER_M, FISHER and, from 12g, LASS and OLD_MAN (CINNABAR ISLAND's GIRL
; and GAMBLER) -- and the rest are the maps one connection away: PALLET TOWN
; (north of ROUTE 21) and FUCHSIA CITY (north of ROUTE 19), so neither crossing
; pays RefreshConnectionSprites' ~27-frame reload.  Walking sheets first
; (SortUsedSprites), still ones last; 13 entries, 152 tiles, nothing dropped.
; SPRITE_BLUE left with 12g's deletion of CINNABAR ISLAND's BLUE; no map in or
; beside this group uses that sheet any more.  SPRITE_SWIMMER_GIRL left with
; 12b's invented SWIMMERFs: Yellow's routes use one swimmer sheet for every
; swimmer.
	db SPRITE_OAK
	db SPRITE_TWIN
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_FISHER
	db SPRITE_MONSTER
	db SPRITE_OLD_MAN
	db SPRITE_SEEL_OW
	db SPRITE_COOLTRAINER_M
	db SPRITE_SWIMMER_GUY
	db SPRITE_POKE_BALL
	db SPRITE_FOSSIL
	db SPRITE_CHANSEY
rept MAX_OUTDOOR_SPRITES - 13
	db 0 ; AddOutdoorSprites always reads MAX_OUTDOOR_SPRITES entries
endr

CeruleanGroupSprites:
; walks: keep inside table 1 (the first eight entries)
	db SPRITE_KANTO_RIVAL   ; CERULEAN CITY 6d cutscene applymovement
	db SPRITE_SUPER_NERD    ; CERULEAN CITY, WALK_UP_DOWN + WALK_LEFT_RIGHT
	db SPRITE_COOLTRAINER_F ; CERULEAN CITY WALK_LEFT_RIGHT, ROUTE 4 WANDER
	db SPRITE_TWIN          ; Kanto hack (M5 8n): ROUTE 10 -> LAVENDER TOWN,
	                        ; whose TWIN WANDERs, and whose sprites would
	                        ; otherwise cost a RefreshConnectionSprites reload
; stands still everywhere in this group: safe in either table
	db SPRITE_COOLTRAINER_M
	db SPRITE_BUG_CATCHER
	db SPRITE_YOUNGSTER
	db SPRITE_POKEFAN_M
	db SPRITE_ROCKET
	db SPRITE_OFFICER
	db SPRITE_POKE_BALL
rept MAX_OUTDOOR_SPRITES - 11
	db 0 ; AddOutdoorSprites always reads MAX_OUTDOOR_SPRITES entries
endr

; Kanto hack (M8 11c): rebuilt by scripts/trim_outdoor_sprites.py --write
; Saffron for SAFFRON CITY's 14 objects -- seven ROCKET grunts plus the six
; civilians who appear once the takeover lifts.  Walkers first (G1): ROCKET,
; SCIENTIST and SILPH_WORKER_F all step, and COOLTRAINER_F walks on the
; connected routes.  The two COOLTRAINERs are cross-connection entries kept
; from the old Crystal list so ROUTE 5/6/7/8 need no sprite reload at the seam.
SaffronGroupSprites:
; walks: keep inside table 1 (the first eight entries)
	db SPRITE_COOLTRAINER_F
	db SPRITE_ROCKET
	db SPRITE_SCIENTIST
	db SPRITE_SILPH_WORKER_F
; stands still everywhere in this group: safe in either table
	db SPRITE_COOLTRAINER_M
	db SPRITE_ROCKER
	db SPRITE_GENTLEMAN
	db SPRITE_BIRD
	db SPRITE_SILPH_WORKER_M
rept MAX_OUTDOOR_SPRITES - 9
	db 0 ; AddOutdoorSprites always reads MAX_OUTDOOR_SPRITES entries
endr

CeladonGroupSprites:
	db SPRITE_TWIN
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_GRAMPS
	db SPRITE_ROCKET
	db SPRITE_FISHER
	db SPRITE_BIKER
	db SPRITE_COOLTRAINER_M ; Kanto hack (M6 9aa): cross-connection -- ROUTE 17's south edge opens onto ROUTE 18's three BIRD KEEPERs
	db SPRITE_POLIWAG
	db SPRITE_BIG_SNORLAX ; Kanto hack (M6 9y): the ROUTE 16 SNORLAX
rept MAX_OUTDOOR_SPRITES - 10
	db 0 ; AddOutdoorSprites always reads MAX_OUTDOOR_SPRITES entries
endr

LavenderGroupSprites:
	db SPRITE_COOLTRAINER_M
	db SPRITE_COOLTRAINER_F
	db SPRITE_TWIN
	db SPRITE_YOUNGSTER
	db SPRITE_SUPER_NERD
	db SPRITE_POKEFAN_M
	; Kanto hack (M7 10c): cross-connection -- ROUTE 12's south edge opens onto
	; ROUTE 13, whose 10 trainers add BEAUTY and BIKER to the COOLTRAINER_M/F
	; this group already lists.
	db SPRITE_BEAUTY
	db SPRITE_BIKER
	db SPRITE_BIG_SNORLAX ; Kanto hack (M5 8l): the ROUTE 12 SNORLAX
	db SPRITE_FISHER
	db SPRITE_GENTLEMAN
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE
rept MAX_OUTDOOR_SPRITES - 13
	db 0 ; AddOutdoorSprites always reads MAX_OUTDOOR_SPRITES entries
endr

VermilionGroupSprites:
	db SPRITE_COOLTRAINER_M
	db SPRITE_COOLTRAINER_F
	db SPRITE_BUG_CATCHER
	db SPRITE_YOUNGSTER
	db SPRITE_OFFICER
	db SPRITE_SAILOR
	db SPRITE_MONSTER
	db SPRITE_FRUIT_TREE
	db SPRITE_OLD_MAN
	db SPRITE_GENTLEMAN ; Kanto hack: ROUTE 11's four GAMBLERs (7l)
	db SPRITE_SUPER_NERD ; Kanto hack: ROUTE 11's two ENGINEERs (7l)
	; Kanto hack (M5 8n): ROUTE 11 -> ROUTE 12.  Without these three the
	; crossing pays a RefreshConnectionSprites reload (~30 frames) for the
	; SNORLAX, ROUTE 12's FISHERs and its two item balls.
	db SPRITE_FISHER
	db SPRITE_BIG_SNORLAX
	db SPRITE_POKE_BALL
rept MAX_OUTDOOR_SPRITES - 15
	db 0 ; AddOutdoorSprites always reads MAX_OUTDOOR_SPRITES entries
endr

FuchsiaGroupSprites:
; Kanto hack (M7 10f): the FUCHSIA group's list, re-derived with
; scripts/trim_outdoor_sprites.py --report.  Every entry is loaded on EVERY
; outdoor map of the group -- ROUTEs 13/14/15/18, FUCHSIA CITY and the four
; SAFARI ZONE maps -- so the list is the union of what they use, plus the
; cross-connection entries that spare RefreshConnectionSprites' ~27-frame
; reload on a seam.  ArrangeUsedSprites fills table 1 with the player first and
; stops at FOLLOWER_VTILE $6c (player + 8 twelve-tile sheets), then table 2
; $80-$ff; SortUsedSprites sorts by TYPE, so the four sheets that ever ANIMATE
; here -- YOUNGSTER, FISHER (ROUTE 19's, one connection away), and the two
; WALK_LEFT_RIGHT pen mons on MONSTER and OLD_MAN -- are all WALKING_SPRITEs
; and land in table 1 ahead of the still ones.  14 entries, 164 tiles, nothing
; dropped.  CHANSEY and SEEL_OW are STANDING_SPRITEs: 12 tiles with no walking
; half in ROM at all, so table 2 is correct for them and they slide exactly as
; Yellow's own SEEL does.  (M9 12c added SWIMMER_GUY: 15 entries, 176 tiles.)
	db SPRITE_YOUNGSTER
	db SPRITE_FISHER
	; M7 10f: FUCHSIA's zoo -- KANGASKHAN and SLOWPOKE share SPRITE_MONSTER and
	; Yellow's GAMBLER is SPRITE_OLD_MAN.  Both walk, so both go in table 1.
	db SPRITE_MONSTER
	db SPRITE_OLD_MAN
	db SPRITE_COOLTRAINER_M
	; Kanto hack (M7 10c): ROUTE 13's own trainers -- 4 PICNICKERs (COOLTRAINER_F),
	; 2 BEAUTYs and a BIKER.  Walking sheets, so they go ahead of the still ones.
	db SPRITE_COOLTRAINER_F
	db SPRITE_BEAUTY
	db SPRITE_BIKER
	; Kanto hack (M9 12c): ROUTE 19's swimmers, one connection south.  Yellow
	; uses one swimmer sheet for every swimmer on ROUTES 19/20/21, male or
	; female, and it is SWIMMER_GUY.  A walking sheet, so it goes in table 1.
	db SPRITE_SWIMMER_GUY
	; Kanto hack (M7 10c/10f): cross-connection entries -- ROUTE 12's SNORLAX and
	; the SUPER_NERD one connection off the group, carried so walking back out of
	; the group pays no sprite reload.  Neither is used inside the group.
	db SPRITE_SUPER_NERD
	db SPRITE_BIG_SNORLAX
	; M7 10f: the rest of the zoo -- LAPRAS on SPRITE_SEEL_OW, CHANSEY, the
	; OMANYTE/KABUTO fossil on SPRITE_FOSSIL and VOLTORB as Yellow's item ball.
	db SPRITE_SEEL_OW
	db SPRITE_CHANSEY
	db SPRITE_FOSSIL
	db SPRITE_POKE_BALL
rept MAX_OUTDOOR_SPRITES - 14
	db 0 ; AddOutdoorSprites always reads MAX_OUTDOOR_SPRITES entries
endr

IndigoGroupSprites:
; Kanto hack (M10 13e-1): ROUTE 23's badge guards -- Yellow's GUARD sheet is
; our OFFICER; its two lake guards are SWIMMER_GUY (Yellow's SWIMMER).
	db SPRITE_OFFICER
	db SPRITE_SWIMMER_GUY
rept MAX_OUTDOOR_SPRITES - 2
	db 0 ; AddOutdoorSprites always reads MAX_OUTDOOR_SPRITES entries
endr

NewBarkGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_RIVAL
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_COOLTRAINER_M
	db SPRITE_YOUNGSTER
	db SPRITE_MONSTER
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE

CherrygroveGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_RIVAL
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_COOLTRAINER_M
	db SPRITE_YOUNGSTER
	db SPRITE_MONSTER
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE

SilverGroupSprites:
rept MAX_OUTDOOR_SPRITES - 0
	db 0 ; AddOutdoorSprites always reads MAX_OUTDOOR_SPRITES entries
endr

VioletGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_FISHER
	db SPRITE_LASS
	db SPRITE_OFFICER
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_COOLTRAINER_M
	db SPRITE_BUG_CATCHER
	db SPRITE_SUPER_NERD
	db SPRITE_WEIRD_TREE
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE

EcruteakGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_FISHER
	db SPRITE_LASS
	db SPRITE_OFFICER
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_COOLTRAINER_M
	db SPRITE_BUG_CATCHER
	db SPRITE_SUPER_NERD
	db SPRITE_WEIRD_TREE
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE

AzaleaGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_KURT_OUTSIDE
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_OFFICER
	db SPRITE_POKEFAN_M
	db SPRITE_BLACK_BELT
	db SPRITE_TEACHER
	db SPRITE_AZALEA_ROCKET
	db SPRITE_LASS
	db SPRITE_RIVAL
	db SPRITE_FRUIT_TREE
	db SPRITE_SLOWPOKE

GoldenrodGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_POKE_BALL
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_OFFICER
	db SPRITE_POKEFAN_M
	db SPRITE_DAY_CARE_MON_1
	db SPRITE_COOLTRAINER_F
	db SPRITE_ROCKET
	db SPRITE_LASS
	db SPRITE_DAY_CARE_MON_2
	db SPRITE_FRUIT_TREE
	db SPRITE_SLOWPOKE

CianwoodGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_STANDING_YOUNGSTER
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_OLIVINE_RIVAL
	db SPRITE_POKEFAN_M
	db SPRITE_LASS
	db SPRITE_BEAUTY
	db SPRITE_SWIMMER_GIRL
	db SPRITE_SAILOR
	db SPRITE_POKEFAN_F
	db SPRITE_SUPER_NERD
	db SPRITE_TAUROS
	db SPRITE_FRUIT_TREE
	db SPRITE_ROCK

OlivineGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_STANDING_YOUNGSTER
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_OLIVINE_RIVAL
	db SPRITE_POKEFAN_M
	db SPRITE_LASS
	db SPRITE_BEAUTY
	db SPRITE_SWIMMER_GIRL
	db SPRITE_SAILOR
	db SPRITE_POKEFAN_F
	db SPRITE_SUPER_NERD
	db SPRITE_TAUROS
	db SPRITE_FRUIT_TREE
	db SPRITE_ROCK

LakeOfRageGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_LANCE
	db SPRITE_GRAMPS
	db SPRITE_SUPER_NERD
	db SPRITE_COOLTRAINER_F
	db SPRITE_FISHER
	db SPRITE_COOLTRAINER_M
	db SPRITE_LASS
	db SPRITE_YOUNGSTER
	db SPRITE_GYARADOS
	db SPRITE_FRUIT_TREE
	db SPRITE_POKE_BALL

MahoganyGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_SUPER_NERD
	db SPRITE_COOLTRAINER_M
	db SPRITE_POKEFAN_M
	db SPRITE_BLACK_BELT
	db SPRITE_COOLTRAINER_F
	db SPRITE_FISHER
	db SPRITE_FRUIT_TREE
	db SPRITE_POKE_BALL

BlackthornGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_SUPER_NERD
	db SPRITE_COOLTRAINER_M
	db SPRITE_POKEFAN_M
	db SPRITE_BLACK_BELT
	db SPRITE_COOLTRAINER_F
	db SPRITE_FISHER
	db SPRITE_FRUIT_TREE
	db SPRITE_POKE_BALL

DungeonsGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_GAMEBOY_KID
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_LASS
	db SPRITE_POKEFAN_F
	db SPRITE_TEACHER
	db SPRITE_YOUNGSTER
	db SPRITE_GROWLITHE
	db SPRITE_POKEFAN_M
	db SPRITE_ROCKER
	db SPRITE_FISHER
	db SPRITE_SCIENTIST
	db SPRITE_POKE_BALL
	db SPRITE_BOULDER

FastShipGroupSprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_SAILOR
	db SPRITE_FISHING_GURU
	db SPRITE_GENTLEMAN
	db SPRITE_SUPER_NERD
	db SPRITE_HO_OH
	db SPRITE_TEACHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_YOUNGSTER
	db SPRITE_FAIRY
	db SPRITE_POKE_BALL
	db SPRITE_ROCK

CableClubGroupSprites:
	db SPRITE_OAK
	db SPRITE_FISHER
	db SPRITE_TEACHER
	db SPRITE_TWIN
	db SPRITE_POKEFAN_M
	db SPRITE_GRAMPS
	db SPRITE_FAIRY
	db SPRITE_RIVAL
	db SPRITE_FISHING_GURU
	db SPRITE_POKE_BALL
	db SPRITE_POKEDEX
