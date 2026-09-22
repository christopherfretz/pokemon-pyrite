DEF __trainer_class__ = 0

MACRO trainerclass
	DEF \1 EQU __trainer_class__
	DEF __trainer_class__ += 1
	const_def 1
ENDM

; trainer class ids
; `trainerclass` indexes are for:
; - TrainerClassNames (see data/trainers/class_names.asm)
; - TrainerClassAttributes (see data/trainers/attributes.asm)
; - TrainerClassDVs (see data/trainers/dvs.asm)
; - TrainerGroups (see data/trainers/party_pointers.asm)
; - TrainerEncounterMusic (see data/trainers/encounter_music.asm)
; - TrainerPicPointers (see data/trainers/pic_pointers.asm)
; - TrainerPalettes (see data/trainers/palettes.asm)
; - BTTrainerClassSprites (see data/trainers/sprites.asm)
; - BTTrainerClassGenders (see data/trainers/genders.asm)
; trainer constants are Trainers indexes, for the sub-tables of TrainerGroups (see data/trainers/parties.asm)
DEF CHRIS EQU __trainer_class__
	trainerclass TRAINER_NONE ; 0
	const PHONECONTACT_MOM
	const PHONECONTACT_BIKESHOP
	const PHONECONTACT_BILL
	const PHONECONTACT_ELM
	const PHONECONTACT_BUENA
DEF NUM_NONTRAINER_PHONECONTACTS EQU const_value - 1

DEF KRIS EQU __trainer_class__
	trainerclass FALKNER ; 1
	const FALKNER1

	trainerclass WHITNEY ; 2
	const WHITNEY1

	trainerclass BUGSY ; 3
	const BUGSY1

	trainerclass MORTY ; 4
	const MORTY1

	trainerclass PRYCE ; 5
	const PRYCE1

	trainerclass JASMINE ; 6
	const JASMINE1

	trainerclass CHUCK ; 7
	const CHUCK1

	trainerclass CLAIR ; 8
	const CLAIR1

	trainerclass RIVAL1 ; 9
	const RIVAL1_1_CHIKORITA
	const RIVAL1_1_CYNDAQUIL
	const RIVAL1_1_TOTODILE
	const RIVAL1_2_CHIKORITA
	const RIVAL1_2_CYNDAQUIL
	const RIVAL1_2_TOTODILE
	const RIVAL1_3_CHIKORITA
	const RIVAL1_3_CYNDAQUIL
	const RIVAL1_3_TOTODILE
	const RIVAL1_4_CHIKORITA
	const RIVAL1_4_CYNDAQUIL
	const RIVAL1_4_TOTODILE
	const RIVAL1_5_CHIKORITA
	const RIVAL1_5_CYNDAQUIL
	const RIVAL1_5_TOTODILE

	trainerclass POKEMON_PROF ; a

	trainerclass WILL ; b
	const WILL1

	trainerclass CAL ; c
	const CAL1 ; unused
	const CAL2
	const CAL3

	trainerclass BRUNO ; d
	const BRUNO1

	trainerclass KAREN ; e
	const KAREN1

	trainerclass KOGA ; f
	const KOGA1

	trainerclass CHAMPION ; 10
	const LANCE

	trainerclass BROCK ; 11
	const BROCK1

	trainerclass MISTY ; 12
	const MISTY1

	trainerclass LT_SURGE ; 13
	const LT_SURGE1

	trainerclass SCIENTIST ; 14
	const ROSS
	const MITCH
	const JED
	const MARC
	const RICH
; Kanto hack: ROUTE 11's engineers (7l) -- Yellow ENGINEER 2/3
	const MAXWELL
	const THURSTON
; Kanto hack (M8 11f): SILPH CO. 2F-5F's five SCIENTISTs -- Yellow
; ScientistData rows 2-6.  Yellow leaves them nameless, so the party rows carry
; an empty name and PlaceEnemysName prints "SCIENTIST" alone (the M7 10h
; JUGGLER precedent).
	const SCIENTIST_8 ; SILPH CO. 2F (5,12)
	const SCIENTIST_9 ; SILPH CO. 2F (24,13)
	const SCIENTIST_10 ; SILPH CO. 3F (7,9)
	const SCIENTIST_11 ; SILPH CO. 4F (14,6)
	const SCIENTIST_12 ; SILPH CO. 5F (8,3)
; Kanto hack (M8 11g): SILPH CO. 6F-8F's three SCIENTISTs -- Yellow
; ScientistData rows 7-9.  Nameless, same as 8-12 above.
	const SCIENTIST_13 ; SILPH CO. 6F (7,8)
	const SCIENTIST_14 ; SILPH CO. 7F (2,13)
	const SCIENTIST_15 ; SILPH CO. 8F (10,2)
; Kanto hack (M8 11h): SILPH CO. 9F-10F's two SCIENTISTs -- Yellow
; ScientistData rows 10-11.  Nameless, same as 8-15 above.
	const SCIENTIST_16 ; SILPH CO. 9F (21,13)
	const SCIENTIST_17 ; SILPH CO. 10F (10,2)
; Kanto hack (M9 12k): the POKeMON MANSION's two SCIENTISTs -- Yellow
; ScientistData rows 12-13.  Nameless, same as 8-17 above.  The MANSION 1F
; SCIENTIST is NOT here: Yellow's ScientistData row 4 serves both SILPH CO. 3F
; and MANSION 1F, so that map reuses SCIENTIST_10 rather than duplicating it.
	const SCIENTIST_18 ; POKeMON MANSION 3F (20,11)
	const SCIENTIST_19 ; POKeMON MANSION B1F (27,11)

	trainerclass ERIKA ; 15
	const ERIKA1

	trainerclass YOUNGSTER ; 16
	const JOEY1
	const MIKEY
	const ALBERT
	const GORDON
	const SAMUEL
	const IAN
	const JOEY2
	const JOEY3
	const WARREN
	const JIMMY
	const FLOYD ; Kanto hack: renamed in place (7l), was OWEN; ROUTE 11, Yellow's YOUNGSTER 9
	const RUDY ; Kanto hack: renamed in place (7l), was JASON; ROUTE 11, Yellow's YOUNGSTER 10
	const JOEY4
	const JOEY5
	const DUSTIN ; Kanto hack: Mt. Moon 1F (Yellow YOUNGSTER 3)
	const VICTOR ; Kanto hack: Nugget Bridge No. 3 (Yellow YOUNGSTER 4)
; Kanto hack: Route 25 (Yellow YOUNGSTER 5/6/7)
	const GRANT
	const COLE ; Kanto hack (N1e): renamed from ELMER, too close to Prof. ELM
	const OSCAR
	const BENJI ; Kanto hack: S.S. ANNE 1F Rooms (7h, Yellow YOUNGSTER 8)
; Kanto hack: ROUTE 11 (7l) -- Yellow YOUNGSTER 11/12
	const GORDY
	const CLIFF
	const AJ ; Kanto hack: ROUTE 9 (M5 8c, Yellow YOUNGSTER 14 -- Yellow's own name)

	trainerclass SCHOOLBOY ; 17
	const JACK1
	const KIPP ; unused (Kanto hack, M7 10e: was ROUTE 15, deleted by the Yellow re-cut)
	const ALAN1
	const JOHNNY ; unused (Kanto hack, M7 10e: was ROUTE 15, deleted by the Yellow re-cut)
	const DANNY
	const TOMMY ; unused (Kanto hack, M7 10e: was ROUTE 15, deleted by the Yellow re-cut)
	const DUDLEY
	const JOE
	const BILLY ; unused (Kanto hack, M7 10e: was ROUTE 15, deleted by the Yellow re-cut)
	const CHAD1
	const NATE
	const RICKY
	const JACK2
	const JACK3
	const ALAN2
	const ALAN3
	const CHAD2
	const CHAD3
	const JACK4
	const JACK5
	const ALAN4
	const ALAN5
	const CHAD4
	const CHAD5

	trainerclass BIRD_KEEPER ; 18
	const ROD
	const ABE
	const BRYAN
	const THEO
	const TOBY
	const DENIS
	const VANCE1
; Kanto hack (M6 9aa): Yellow's three ROUTE 18 BIRD KEEPERs (OPP_BIRD_KEEPER
; 8-10) take over three dead rows in place -- HANK was never referenced by any
; Crystal map, and BORIS/BOB were Crystal's own ROUTE 18 pair, deleted by 9aa.
; No renumbering, no new const cost; the rows are nameless so the battle intro
; reads "BIRD KEEPER" alone, as Gen 1 does.
	const BIRD_KEEPER_1 ; ROUTE 18 (was HANK)
	const BIRD_KEEPER_7 ; ROUTE 14 (Kanto hack, M7 10d, Yellow's OPP_BIRD_KEEPER 14); was ROY, Crystal's own ROUTE 14 bird keeper, deleted by 10d
	const BIRD_KEEPER_2 ; ROUTE 18 (was BORIS)
	const BIRD_KEEPER_3 ; ROUTE 18 (was BOB)
	const JOSE1
	const PETER
	const JOSE2
; Kanto hack (M7 10c): Yellow's three ROUTE 13 BIRD KEEPERs (OPP_BIRD_KEEPER
; 1-3).  PERRY and BRET were Crystal's own ROUTE 13 pair, deleted by 10c, so two
; of the three take their rows over in place; the third is appended below.  The
; _4/_5/_6 numbering continues the per-class hack sequence BIRD_KEEPER_1-3
; (ROUTE 18, M6 9aa) started -- it is NOT Yellow's opponent number.
	const BIRD_KEEPER_4 ; ROUTE 13 (was PERRY)
	const BIRD_KEEPER_5 ; ROUTE 13 (was BRET)
	const JOSE3
	const VANCE2
	const VANCE3
	const BIRD_KEEPER_6 ; ROUTE 13 (Kanto hack, M7 10c), appended
; Kanto hack (M7 10d): Yellow's six ROUTE 14 BIRD KEEPERs (OPP_BIRD_KEEPER
; 14/15/16/17/4/5, in Yellow's object order).  Only ROY's row above was dead,
; so the other five are appended -- the class has no dead rows left.
	const BIRD_KEEPER_8 ; ROUTE 14 (Kanto hack, M7 10d), appended
	const BIRD_KEEPER_9 ; ROUTE 14 (Kanto hack, M7 10d), appended
	const BIRD_KEEPER_10 ; ROUTE 14 (Kanto hack, M7 10d), appended
	const BIRD_KEEPER_11 ; ROUTE 14 (Kanto hack, M7 10d), appended
	const BIRD_KEEPER_12 ; ROUTE 14 (Kanto hack, M7 10d), appended
; Kanto hack (M7 10e): Yellow's two ROUTE 15 COOLTRAINER_Ms (OPP_BIRD_KEEPER
; 6/7).  The class still has no dead rows, so both are appended.
	const BIRD_KEEPER_13 ; ROUTE 15 (Kanto hack, M7 10e), appended
	const BIRD_KEEPER_14 ; ROUTE 15 (Kanto hack, M7 10e), appended
; Kanto hack (M9 12c): ROUTE 20's lone COOLTRAINER_M (Yellow OPP_BIRD_KEEPER
; 11).  The class still has no dead rows, so it is appended.
	const BIRD_KEEPER_15 ; ROUTE 20 (Kanto hack, M9 12c), appended

	trainerclass LASS ; 19
	const CARRIE
	const BRIDGET
	const ALICE
	const KRISE
	const CONNIE1
	const LINDA
	const LAURA
	const SHANNON
	const MICHELLE ; Kanto hack: CELADON GYM (Yellow LASS 17); kept in place (M6 9q)
	const DANA1
	const WINNIE ; Kanto hack: ROUTE 8 (Yellow LASS 15); renamed in place (M5 8j), was the dead ELLEN
	const ESTHER ; Kanto hack: ROUTE 8 (Yellow LASS 13); renamed in place (M5 8j), was the unused CONNIE2
	const FLORA ; Kanto hack: ROUTE 8 (Yellow LASS 14); renamed in place (M5 8j), was the unused CONNIE3
	const DANA2
	const DANA3
	const DANA4
	const DANA5
	const SARAH ; Kanto hack: Viridian Forest (Yellow LASS 19)
; Kanto hack: Route 3's three lasses (Yellow LASS 1/2/3)
	const JANICE
	const SALLY
	const ROBIN
	const TAMARA ; Kanto hack: Route 4 (Yellow LASS 4)
; Kanto hack: Mt. Moon 1F's two lasses (Yellow LASS 5/6)
	const MELISSA
	const NADINE
; Kanto hack: Nugget Bridge No. 4 and No. 2 (Yellow LASS 7/8)
	const NORMA
	const PAULINE
; Kanto hack: Route 25 (Yellow LASS 9/10)
	const JODIE
	const TESSA
; Kanto hack: S.S. ANNE's lasses (7h) -- Yellow LASS 11 (1F Rooms) and 12 (2F Rooms)
	const ODETTE
	const MARISA
	const TILDA ; Kanto hack: ROUTE 8 (Yellow LASS 16), appended (M5 8j)
	const HOLLY ; Kanto hack: CELADON GYM (Yellow LASS 18), appended (M6 9q)

; Kanto hack (M7 10h): JANINE is gone -- FUCHSIA GYM is Yellow's, and KOGA leads
; it.  The leader takes JANINE's class slot, renamed in place, rather than
; Crystal's ELITE FOUR KOGA class: that class's TrainerClassNames entry is
; "ELITE FOUR", so a gym battle would announce "ELITE FOUR KOGA wants to
; battle!".  JANINE is Crystal's own FUCHSIA gym-leader class, so its name entry
; is already "LEADER" -- matching BROCK/MISTY/LT_SURGE/ERIKA/SABRINA/BLAINE.
; Every other per-class row (pic, palette, DVs, attributes, encounter music,
; Battle Tower sprite/gender) is retuned to Crystal's KOGA values, so the swap
; changes only the displayed class name.  ELITE FOUR KOGA is left untouched.
	trainerclass KOGA_LEADER ; 1a
	const KOGA_LEADER1

	trainerclass COOLTRAINERM ; 1b
	const NICK
	const AARON
	const PAUL
	const CODY
	const MIKE
	const GAVEN1
	const GAVEN2
	const RYAN
	const JAKE
	const GAVEN3
	const BLAKE
	const BRIAN
	const ERICK ; unused
	const COOLTRAINERM_VIRIDIAN_1 ; Kanto hack (M10 13b): was ANDY (unused) -- VIRIDIAN GYM, Yellow CoolTrainerMData 9
	const COOLTRAINERM_VIRIDIAN_2 ; Kanto hack (M10 13b): was TYLER (unused) -- VIRIDIAN GYM, Yellow CoolTrainerMData 10
	const SEAN
	const KEVIN
	const COOLTRAINERM_VIRIDIAN_3 ; Kanto hack (M10 13b): was STEVE (unused) -- VIRIDIAN GYM, Yellow CoolTrainerMData 1
	const ALLEN
	const DARIN

	trainerclass COOLTRAINERF ; 1c
	const GWEN
	const LOIS
	const FRAN
	const LOLA
	const KATE
	const IRENE
	const KELLY
	const JOYCE
	const BETH1
	const REENA1
	const MEGAN
	const BETH2
	const CAROL
	const QUINN
	const EMMA
	const CYBIL
	const JENN
	const BETH3
	const REENA2
	const REENA3
	const CARA
	const IVY ; Kanto hack: CELADON GYM (Yellow COOLTRAINER_F 1), appended (M6 9q)

	trainerclass BEAUTY ; 1d
	const VICTORIA
	const SAMANTHA
; Kanto hack (M7 10c): ROUTE 13's two BEAUTYs (Yellow's OPP_BEAUTY 4 and 5) take
; over two of Crystal's "; unused" placeholder rows in place -- no renumbering,
; no new const cost.
	const BEAUTY_1 ; ROUTE 13 (was the unused JULIE)
	const BEAUTY_2 ; ROUTE 13 (was the unused JACLYN)
; Kanto hack (M7 10e): Yellow's two ROUTE 15 BEAUTYs (OPP_BEAUTY 9/10) take over
; two more of Crystal's "; unused" placeholder rows in place -- no renumbering,
; no new const cost.  (Their old event flags were already reclaimed by M6 9f, so
; ROUTE 15's two BEAUTY flags are appended in event_flags.asm.)
	const BEAUTY_3 ; ROUTE 15 (Kanto hack, M7 10e; was the unused BRENDA)
	const CASSIE
	const BEAUTY_4 ; ROUTE 15 (Kanto hack, M7 10e; was the unused CAROLINE)
; Kanto hack (M9 12c): Yellow's ROUTE 19/20 BEAUTY-class swimmers (OPP_BEAUTY
; 6/7/8/12/13/14/15).  Five of Crystal's "; unused" rows are renamed in place;
; the last two are appended at the end of the class.
	const BEAUTY_5 ; ROUTES 19/20 (M9 12c; was the unused CARLENE)
	const BEAUTY_6 ; ROUTES 19/20 (M9 12c; was the unused JESSICA)
	const BEAUTY_7 ; ROUTES 19/20 (M9 12c; was the unused RACHAEL)
	const BEAUTY_8 ; ROUTES 19/20 (M9 12c; was the unused ANGELICA)
	const BEAUTY_9 ; ROUTES 19/20 (M9 12c; was the unused KENDRA)
	const LILY ; Kanto hack: CELADON GYM (Yellow BEAUTY 1); renamed in place (M6 9q), was the unused VERONICA
	const JULIA ; Kanto hack: CELADON GYM (Yellow BEAUTY 2); kept in place (M6 9q)
	const POPPY ; Kanto hack: CELADON GYM (Yellow BEAUTY 3); renamed in place (M6 9q), was the unused THERESA
	const VALERIE
	const OLIVIA
	const BEAUTY_10 ; ROUTE 20 (M9 12c), appended
	const BEAUTY_11 ; ROUTE 20 (M9 12c), appended

	trainerclass POKEMANIAC ; 1e
	const LARRY
	const ANDREW
	const CALVIN
	const SHANE
	const BEN
	const BRENT1
	const RON
	const ETHAN
	const BRENT2
	const BRENT3
	const ISSAC
	const DONALD
	const ZACH
	const BRENT4
	const MILLER
; Kanto hack: ROUTE 10's two POKEMANIACs (M5 8d, Yellow POKEMANIAC 1/2)
	const ORVILLE
	const MELVIN
	const JASPER ; Kanto hack: ROCK TUNNEL 1F (M5 8e, Yellow POKEMANIAC 7)
; Kanto hack: ROCK TUNNEL B1F's three POKEMANIACs (M5 8f, Yellow POKEMANIAC 3/4/5)
	const CEDRIC
	const AMOS
	const WALDO

	trainerclass GRUNTM ; 1f
	const GRUNTM_1
	const GRUNTM_2
	const GRUNTM_3
	const GRUNTM_4
	const GRUNTM_5
	const GRUNTM_6
	const GRUNTM_7
	const GRUNTM_8
	const GRUNTM_9
	const GRUNTM_10
	const GRUNTM_11
	const GRUNTM_12 ; Kanto hack: Mt. Moon B2F ROCKET 1 (was unused)
	const GRUNTM_13
	const GRUNTM_14
	const GRUNTM_15
	const GRUNTM_16
	const GRUNTM_17
	const GRUNTM_18
	const GRUNTM_19
	const GRUNTM_20
	const GRUNTM_21
	const GRUNTM_22 ; Kanto hack: Mt. Moon B2F ROCKET 2 (was unused)
	const GRUNTM_23 ; Kanto hack: Mt. Moon B2F ROCKET 3 (was unused)
	const GRUNTM_24
	const GRUNTM_25
	const GRUNTM_26 ; Kanto hack: Cerulean City Rocket thief (was unused)
	const GRUNTM_27 ; Kanto hack: Nugget Bridge recruiter (was unused)
	const GRUNTM_28
	const GRUNTM_29
	const GRUNTM_30 ; Kanto hack (M6 9u): CELADON GAME CORNER's poster guard
	const GRUNTM_31 ; Kanto hack (M6 9x): ROCKET HIDEOUT B1F ROCKET 1 (was unused)
; Kanto hack (M6 9x): the other eight ROCKET HIDEOUT grunts.  Appending inside
; an existing class costs only party data -- no class-keyed table grows.
	const GRUNTM_32 ; ROCKET HIDEOUT B1F ROCKET 2
	const GRUNTM_33 ; ROCKET HIDEOUT B1F ROCKET 3
	const GRUNTM_34 ; ROCKET HIDEOUT B1F ROCKET 4
	const GRUNTM_35 ; ROCKET HIDEOUT B1F ROCKET 5 (drops the door)
	const GRUNTM_36 ; ROCKET HIDEOUT B2F ROCKET
	const GRUNTM_37 ; ROCKET HIDEOUT B3F ROCKET 1
	const GRUNTM_38 ; ROCKET HIDEOUT B3F ROCKET 2
	const GRUNTM_39 ; ROCKET HIDEOUT B4F ROCKET (drops the LIFT KEY)
; Kanto hack (M8 11f): SILPH CO. 2F-5F's seven ROCKETs -- Yellow OPP_ROCKET
; 23-29.  Same convention as the hideout grunts above: "GRUNT" over the ROCKET
; class name.
	const GRUNTM_40 ; SILPH CO. 2F (16,11), Yellow ROCKET 23
	const GRUNTM_41 ; SILPH CO. 2F (24,7), Yellow ROCKET 24
	const GRUNTM_42 ; SILPH CO. 3F (20,7), Yellow ROCKET 25
	const GRUNTM_43 ; SILPH CO. 4F (9,14), Yellow ROCKET 26
	const GRUNTM_44 ; SILPH CO. 4F (26,10), Yellow ROCKET 27
	const GRUNTM_45 ; SILPH CO. 5F (8,16), Yellow ROCKET 28
	const GRUNTM_46 ; SILPH CO. 5F (28,4), Yellow ROCKET 29
; Kanto hack (M8 11g): SILPH CO. 6F-8F's seven ROCKETs -- Yellow OPP_ROCKET
; 30-36.  Same convention: "GRUNT" over the ROCKET class name.
	const GRUNTM_47 ; SILPH CO. 6F (17,3), Yellow ROCKET 30
	const GRUNTM_48 ; SILPH CO. 6F (14,15), Yellow ROCKET 31
	const GRUNTM_49 ; SILPH CO. 7F (13,1), Yellow ROCKET 32
	const GRUNTM_50 ; SILPH CO. 7F (20,2), Yellow ROCKET 33
	const GRUNTM_51 ; SILPH CO. 7F (19,14), Yellow ROCKET 34
	const GRUNTM_52 ; SILPH CO. 8F (19,2), Yellow ROCKET 35
	const GRUNTM_53 ; SILPH CO. 8F (12,15), Yellow ROCKET 36
; Kanto hack (M8 11h): SILPH CO. 9F-10F's three ROCKETs -- Yellow RocketData
; rows 37-39.  Same convention: "GRUNT" over the ROCKET class name.
	const GRUNTM_54 ; SILPH CO. 9F (2,4), Yellow ROCKET 37
	const GRUNTM_55 ; SILPH CO. 9F (13,16), Yellow ROCKET 38
	const GRUNTM_56 ; SILPH CO. 10F (1,9), Yellow ROCKET 39
; Kanto hack (M8 11i): SILPH CO. 11F's last ROCKET -- Yellow RocketData row 40.
; Same convention: "GRUNT" over the ROCKET class name.
	const GRUNTM_57 ; SILPH CO. 11F (15,9), Yellow ROCKET 40

	trainerclass GENTLEMAN ; 20
	const PRESTON
	const EDWARD
	const GREGORY
	const ARTHUR ; Kanto hack: renamed in place (7l), was the unused VIRGIL; ROUTE 11, Yellow's GAMBLER 1
	const ALFRED
; Kanto hack: S.S. ANNE's gentlemen (7h) -- Yellow GENTLEMAN 1/2 (1F Rooms) and 3/5 (2F Rooms)
	const THEODORE
	const BARTON
	const CLIVE
	const HUBERT
; Kanto hack: ROUTE 11's gamblers (7l) -- Yellow GAMBLER 2/3/4 (GAMBLER 1 is ARTHUR above)
	const LEOPOLD
	const WINSTON
	const HORACE
; Kanto hack: ROUTE 8's gamblers (M5 8j) -- Yellow GAMBLER 5 and 7
	const ELTON
	const REUBEN

	trainerclass SKIER ; 21
	const ROXANNE
	const CLARISSA

	trainerclass TEACHER ; 22
; Kanto hack (M7 10e): COLETTE and HILLARY were Crystal's own ROUTE 15 TEACHERs,
; deleted by the Yellow re-cut.  Their rows stay in place -- deleting them would
; renumber SHIRLEY, and "Enemy Trainers" has ~1.9 KB free, so D49's byte-saving
; deletion is not needed.  A later Kanto map can reclaim them in place.
	const COLETTE ; unused (Kanto hack, M7 10e)
	const HILLARY ; unused (Kanto hack, M7 10e)
	const SHIRLEY

	trainerclass SABRINA ; 23
	const SABRINA1

	trainerclass BUG_CATCHER ; 24
	const DON
	const ROB
	const ED
	const WADE1
	const BUG_CATCHER_BENNY
	const AL
	const JOSH
	const ARNIE1
	const KEN
	const WADE2
	const WADE3
	const DOUG
	const ARNIE2
	const ARNIE3
	const WADE4
	const WADE5
	const ARNIE4
	const ARNIE5
	const WAYNE
; Kanto hack: Viridian Forest's four bug catchers (Yellow BUG_CATCHER 1/2/3/15)
	const SAMMY
	const ELIJAH
	const ANTHONY
	const WESLEY
; Kanto hack: Route 3's three bug catchers (Yellow BUG_CATCHER 4/5/6)
	const COLTON
	const DION
	const BRETT
; Kanto hack: Mt. Moon 1F's two bug catchers (Yellow BUG_CATCHER 7/8)
	const TRAVIS
	const NEIL
	const MERLE ; Kanto hack: Nugget Bridge No. 1 (Yellow BUG_CATCHER 9)
; Kanto hack: Route 6's two bug catchers (Yellow BUG_CATCHER 10 / 11)
	const LOGAN
	const FELIX
; Kanto hack: ROUTE 9 (M5 8c) -- Yellow BUG_CATCHER 13 / 14
	const ELLIS
	const MERV

	trainerclass FISHER ; 25
	const JUSTIN
	const RALPH1
; Kanto hack (M9 12c): Yellow's four ROUTE 21 FISHERs (OPP_FISHER 7/8/9/10).
; ARNOLD was 12a's ROUTE 21 placeholder and is renamed in place; the other
; three are appended at the end of the class.
	const FISHER_1 ; ROUTE 21 (M9 12c; was ARNOLD)
	const KYLE
	const HENRY
	const MARVIN
	const TULLY1
	const ANDRE
	const RAYMOND
	const WILTON1
	const EDGAR
	const JONAH
	const MARTIN
	const STEPHEN
	const BARNEY
	const RALPH2
	const RALPH3
	const TULLY2
	const TULLY3
	const WILTON2
	const SCOTT
	const WILTON3
	const RALPH4
	const RALPH5
	const TULLY4
; Kanto hack: S.S. ANNE's fishers (7h) -- Yellow FISHER 1 (2F Rooms) and 2 (B1F Rooms)
	const DALTON
	const PERCY
; Kanto hack: ROUTE 12's fifth fisher (Yellow FISHER 11), M5 8l
	const ELWOOD
	const FISHER_2 ; ROUTE 21 (M9 12c), appended
	const FISHER_3 ; ROUTE 21 (M9 12c), appended
	const FISHER_4 ; ROUTE 21 (M9 12c), appended

	trainerclass SWIMMERM ; 26
; Kanto hack (M9 12c): Yellow's ROUTES 19/20/21 swimmers (OPP_SWIMMER 2-15).
; Thirteen of Crystal's dead SWIMMERM rows are renamed in place -- HAROLD was
; 12a's placeholder and the rest were "; unused" -- so nothing renumbers; the
; fourteenth is appended at the end of the class.  Rows are nameless, so
; PlaceEnemysName prints "SWIMMER" alone, as Gen 1 does.
	const SWIMMERM_1 ; ROUTES 19/20/21 (M9 12c; was HAROLD)
	const SIMON
	const RANDALL
	const CHARLIE
	const GEORGE
	const BERKE
	const KIRK
	const MATHEW
	const SWIMMERM_2 ; ROUTES 19/20/21 (M9 12c; was HAL)
	const SWIMMERM_3 ; ROUTES 19/20/21 (M9 12c; was PATON)
	const SWIMMERM_4 ; ROUTES 19/20/21 (M9 12c; was DARYL)
	const SWIMMERM_5 ; ROUTES 19/20/21 (M9 12c; was WALTER)
	const SWIMMERM_6 ; ROUTES 19/20/21 (M9 12c; was TONY)
	const SWIMMERM_7 ; ROUTES 19/20/21 (M9 12c; was JEROME)
	const SWIMMERM_8 ; ROUTES 19/20/21 (M9 12c; was TUCKER)
	const SWIMMERM_9 ; ROUTES 19/20/21 (M9 12c; was RICK)
	const SWIMMERM_10 ; ROUTES 19/20/21 (M9 12c; was CAMERON)
	const SWIMMERM_11 ; ROUTES 19/20/21 (M9 12c; was SETH)
	const SWIMMERM_12 ; ROUTES 19/20/21 (M9 12c; was JAMES)
	const SWIMMERM_13 ; ROUTES 19/20/21 (M9 12c; was LEWIS)
	const LUIS ; Kanto hack: Cerulean Gym, Yellow's SWIMMER 1 (was PARKER,
	           ; Crystal's own gym swimmer; renamed in place, 6e)
	const SWIMMERM_14 ; ROUTE 21 (M9 12c), appended -- the class had only 13 dead rows

	trainerclass SWIMMERF ; 27
	const ELAINE
	const PAULA
	const KAYLEE
	const SUSIE
	const DENISE
	const KARA
	const WENDY
	const LISA ; unused
	const JILL ; unused
	const MARY ; unused
	const KATIE ; unused
	const DAWN
	const TARA ; unused
	const NICOLE
	const LORI
	const JODY ; unused
	const NIKKI
; Kanto hack (6e): Crystal's two Cerulean Gym SWIMMERF trainers, DIANA and
; BRIANA, are gone -- the gym now holds Yellow's two.  They were the LAST two
; consts of the class, so removing them shifts no other trainer id.  The name
; DIANA is re-used by the PICNICKER below.

	trainerclass SAILOR ; 28
	const EUGENE
	const HUEY1
	const TERRELL
	const KENT
	const ERNEST
	const JEFF
	const GARRETT
	const KENNETH
	const STANLY
	const HARRY
	const HUEY2
	const HUEY3
	const HUEY4
; Kanto hack: S.S. ANNE's sailors (7h) -- Yellow SAILOR 1/2 (bow) and 3/4/5/6/7 (B1F Rooms)
	const MURDOCK
	const MURPHY
	const LEO
	const BRADY
	const FORREST
	const SEAMUS
	const SILAS
; Kanto hack: VERMILION GYM's sailor (7k) -- Yellow SAILOR 8
	const DEWEY

	trainerclass SUPER_NERD ; 29
	const STAN
	const ERIC
	const GREGG ; Kanto hack: Mt. Moon 1F (Yellow SUPER_NERD 1); was an unused Crystal slot
	const MIGUEL ; Kanto hack: Mt. Moon B2F fossil rival (was the unused JAY)
	const CLARK ; Kanto hack: ROUTE 8 (Yellow SUPER_NERD 5); renamed in place (M5 8j), was the unused DAVE
	const SAM
	const TOM
	const PAT
	const SHAWN
	const TERU
	const RUSS ; unused
	const NORTON ; unused
	const HUGH
	const MARKUS
; Kanto hack (M9 12n): CINNABAR GYM's four SUPER NERDs, Yellow SuperNerdData
; rows 9-12, appended and nameless.
	const SUPER_NERD_15 ; CINNABAR GYM (17,2), no gate
	const SUPER_NERD_16 ; CINNABAR GYM (11,4), gate 2
	const SUPER_NERD_17 ; CINNABAR GYM (11,14), gate 4
	const SUPER_NERD_18 ; CINNABAR GYM (3,8), gate 6

	trainerclass RIVAL2 ; 2a
	const RIVAL2_1_CHIKORITA
	const RIVAL2_1_CYNDAQUIL
	const RIVAL2_1_TOTODILE
	const RIVAL2_2_CHIKORITA
	const RIVAL2_2_CYNDAQUIL
	const RIVAL2_2_TOTODILE

	trainerclass GUITARIST ; 2b
	const CLYDE
	const VINCENT
; Kanto hack: ROUTE 12's rocker (Yellow ROCKER 2), M5 8l
	const SPARKY

	trainerclass HIKER ; 2c
	const ANTHONY1
	const RUSSELL
	const PHILLIP
	const LEONARD
	const ANTHONY2
	const BENJAMIN
	const ERIK
	const MICHAEL
	const PARRY1
	const TIMOTHY
	const BAILEY
	const ANTHONY3
	const TIM
	const NOLAND
	const SIDNEY
	const KENNY
	const JIM
	const DANIEL
	const PARRY2
	const PARRY3
	const ANTHONY4
	const ANTHONY5
	const MARCOS ; Kanto hack: Mt. Moon 1F (Yellow HIKER 1)
; Kanto hack: Route 25 (Yellow HIKER 2/3/4)
	const GRAHAM
	const ARCHIE
	const MORTON
	const LAMONT ; Kanto hack: ROUTE 9 (M5 8c, Yellow HIKER 5)
	const ODELL ; Kanto hack: ROUTE 10 (M5 8d, Yellow HIKER 8)
; Kanto hack: ROCK TUNNEL 1F's three HIKERs (M5 8e, Yellow HIKER 12/13/14)
	const ROSCOE
	const WILBUR
	const NORRIS
; Kanto hack: ROCK TUNNEL B1F's three HIKERs (M5 8f, Yellow HIKER 9/10/11)
	const LOWELL
	const VERNON
	const CONRAD

	trainerclass BIKER ; 2d
	; Kanto hack (M6 9y): Crystal never uses rows 1 and 2 (BIKER_BENNY and KAZU
	; are dead slots with placeholder parties), so Yellow's first two ROUTE 16
	; bikers take them over in place -- no renumbering, no new const cost.
	const BIKER_1 ; ROUTE 16 (was BIKER_BENNY)
	const BIKER_2 ; ROUTE 16 (was KAZU)
	; Kanto hack (M6 9z): Yellow's five ROUTE 17 BIKERs (OPP_BIKER 8-12) take
	; over five more dead rows -- DWAYNE/HARRIS/ZEKE were Crystal ROUTE 8's,
	; deleted by M5 8j; CHARLES/RILEY were Crystal ROUTE 17's, deleted by 9z.
	const BIKER_4 ; ROUTE 17 (was DWAYNE)
	const BIKER_5 ; ROUTE 17 (was HARRIS)
	const BIKER_6 ; ROUTE 17 (was ZEKE)
	const BIKER_7 ; ROUTE 17 (was CHARLES)
	const BIKER_8 ; ROUTE 17 (was RILEY)
	const BIKER_9 ; ROUTE 13 (Kanto hack, M7 10c, Yellow's OPP_BIKER 1); was the dead JOEL
	const BIKER_10 ; ROUTE 14 (Kanto hack, M7 10d, Yellow's OPP_BIKER 13); was the dead GLENN
	const BIKER_3 ; ROUTE 16 (Kanto hack, M6 9y)
; Kanto hack (M7 10d): Yellow's four ROUTE 14 BIKERs (OPP_BIKER 13/14/15/2).
; GLENN's row above was the class's last dead one, so three are appended.
	const BIKER_11 ; ROUTE 14 (Kanto hack, M7 10d), appended
	const BIKER_12 ; ROUTE 14 (Kanto hack, M7 10d), appended
	const BIKER_13 ; ROUTE 14 (Kanto hack, M7 10d), appended
; Kanto hack (M7 10e): Yellow's two ROUTE 15 BIKERs (OPP_BIKER 3/4).  The class
; has had no dead rows since 10d, so both are appended.
	const BIKER_14 ; ROUTE 15 (Kanto hack, M7 10e), appended
	const BIKER_15 ; ROUTE 15 (Kanto hack, M7 10e), appended

	trainerclass BLAINE ; 2e
	const BLAINE1

	trainerclass BURGLAR ; 2f
	const DUNCAN
	const EDDIE
	const COREY
; Kanto hack (M9 12k): the POKeMON MANSION's three BURGLARs -- Yellow
; BurglarData rows 7-9.  DUNCAN/EDDIE/COREY above are live JOHTO trainers
; (FastShipCabins_NNW_NNE_NE, GoldenrodUndergroundSwitchRoomEntrances), so
; none of them can be re-pointed; these three are new and nameless, the same
; way the SILPH CO. SCIENTISTs are.  Yellow draws them with the SUPER NERD
; overworld sprite, not Crystal's PHARMACIST.
	const BURGLAR_4 ; POKeMON MANSION 2F (3,17)
	const BURGLAR_5 ; POKeMON MANSION 3F (5,11)
	const BURGLAR_6 ; POKeMON MANSION B1F (16,23)
; Kanto hack (M9 12n): CINNABAR GYM's three BURGLARs, Yellow BurglarData 4-6.
	const BURGLAR_7 ; CINNABAR GYM (17,8), gate 1
	const BURGLAR_8 ; CINNABAR GYM (11,8), gate 3
	const BURGLAR_9 ; CINNABAR GYM (3,14), gate 5

	trainerclass FIREBREATHER ; 30
	const OTIS
	const DICK ; unused
	const NED ; unused
	const BURT
	const BILL
	const WALT
	const RAY
	const LYLE

; Kanto hack (M7 10h): the three dead IRWIN duplicates are renamed in place for
; FUCHSIA GYM; the suffixes are Yellow's own OPP_JUGGLER party numbers, as with
; CUE_BALL_1..9 and BIRD_KEEPER_*.
	trainerclass JUGGLER ; 31
	const IRWIN1
	const FRITZ
	const HORTON
	const JUGGLER_3 ; FUCHSIA GYM (was IRWIN2, unused)
	const JUGGLER_4 ; FUCHSIA GYM (was IRWIN3, unused)
	const JUGGLER_7 ; FUCHSIA GYM (was IRWIN4, unused)
	const JUGGLER_8 ; FUCHSIA GYM, appended
	const JUGGLER_9 ; Kanto hack (M8 11f): SILPH CO. 5F (18,10), Yellow JugglerData 1

	trainerclass BLACKBELT_T ; 32
	const KENJI1 ; unused
	const YOSHI
	const KENJI2 ; unused
	const LAO
	const NOB
	const KIYO
	const LUNG
	const KENJI3
	const WAI
; Kanto hack (M8 11d): Yellow's FIGHTING DOJO.  Yellow has no KARATE MASTER
; class -- every dojo fighter, the master included, is OPP_BLACKBELT -- so the
; five rows are appended here and left nameless in parties.asm, which makes
; PlaceEnemysName print "BLACKBELT" alone, as Yellow does.
	const KARATE_MASTER ; FIGHTING DOJO, appended
	const BLACKBELT_DOJO_1
	const BLACKBELT_DOJO_2
	const BLACKBELT_DOJO_3
	const BLACKBELT_DOJO_4
; Kanto hack (M10 13b): VIRIDIAN GYM, Yellow BlackbeltData 6-8, appended nameless.
	const BLACKBELT_VIRIDIAN_1
	const BLACKBELT_VIRIDIAN_2
	const BLACKBELT_VIRIDIAN_3

	trainerclass EXECUTIVEM ; 33
	const EXECUTIVEM_1
	const EXECUTIVEM_2
	const EXECUTIVEM_3
	const EXECUTIVEM_4

	trainerclass PSYCHIC_T ; 34
	const NATHAN
	const HERMAN
	const FIDEL
	const GREG
	const NORMAN
	const MARK
	const PHIL
	const RICHARD
	const GILBERT
	const RODNEY
; Kanto hack (M8 11a, docs/M8-SAFFRON.md 0.6): SAFFRON GYM's four psychics,
; Yellow's PSYCHIC_TR 1-4.  Yellow gives them no names, so these are invented
; the way M6 invented the #MON TOWER channelers' (D13).  Parties in 11h.
	const TYRON ; Kanto hack (M8 11h): SAFFRON GYM, Yellow's PSYCHIC_TR 1
	const HOLLIS ; Kanto hack (M8 11h): SAFFRON GYM, Yellow's PSYCHIC_TR 2
	const EZRA ; Kanto hack (M8 11h): SAFFRON GYM, Yellow's PSYCHIC_TR 3
	const DARIUS ; Kanto hack (M8 11h): SAFFRON GYM, Yellow's PSYCHIC_TR 4

	trainerclass PICNICKER ; 35
	const LIZ1
	const GINA1
	const BROOKE
	const KIM
	const CINDY
; Kanto hack (M9 12c): ROUTE 20's two JR.TRAINERs^F (Yellow OPP_JR_TRAINER_F
; 16/24) take over two rows that fell dead when M4 replaced Crystal's ROUTE 4
; picnickers, so nothing renumbers and no const is added.
	const PICNICKER_9 ; ROUTE 20 (M9 12c; was HOPE, dead since M4)
	const PICNICKER_10 ; ROUTE 20 (M9 12c; was SHARON, dead since M4)
	const DEBRA
	const GINA2
	const ERIN1
	const LIZ2
	const LIZ3
	const HEIDI
	const EDNA
	const GINA3
	const TIFFANY1
	const TIFFANY2
	const ERIN2
	const TANYA
	const TIFFANY3
	const ERIN3
	const LIZ4
	const LIZ5
	const GINA4
	const GINA5
	const TIFFANY4
	const DIANA ; Kanto hack: Cerulean Gym, Yellow's JR.TRAINER^F 1 (6e)
; Kanto hack: Route 6's two Jr.Trainers^F (Yellow JR_TRAINER_F 25 / 3)
	const MARCY
	const GRETA
; Kanto hack: ROUTE 10's two Jr.Trainers^F (M5 8d, Yellow JR_TRAINER_F 7/8)
	const GRETCHEN
	const MABEL
; Kanto hack: ROCK TUNNEL 1F's three Jr.Trainers^F (M5 8e, Yellow JR_TRAINER_F 17/18/19)
	const THELMA
	const NELLIE
	const MYRNA
; Kanto hack: ROCK TUNNEL B1F's two Jr.Trainers^F (M5 8f, Yellow JR_TRAINER_F 9/10)
	const RHODA
	const OPAL
; Kanto hack (M7 10c): ROUTE 13's four JR.TRAINERs^F (Yellow OPP_JR_TRAINER_F
; 12/13/14/15).  The class has no dead rows left, so these four are appended.
	const PICNICKER_1
	const PICNICKER_2
	const PICNICKER_3
	const PICNICKER_4
; Kanto hack (M7 10e): ROUTE 15's four JR.TRAINERs^F (Yellow OPP_JR_TRAINER_F
; 20/21/22/23).  Still no dead rows in this class, so all four are appended.
	const PICNICKER_5
	const PICNICKER_6
	const PICNICKER_7
	const PICNICKER_8

	trainerclass CAMPER ; 36
	const ROLAND
	const TODD1
	const IVAN
	const ELLIOT
	const BARRY
	const LLOYD
	const DEAN
	const HARVEY ; unused
	const DALE ; unused
	const TED
	const TODD2
	const TODD3
	const THOMAS ; unused
	const LEROY ; unused
	const DAVID ; unused
	const JOHN ; unused
	const JERRY
	const SPENCER
	const TODD4
	const TODD5
	const QUENTIN
; Kanto hack: Nugget Bridge's two Jr.Trainers (Yellow JR_TRAINER_M 2/3)
	const ANSEL
	const RUFUS
	const WENDELL ; Kanto hack: Route 25 (Yellow JR_TRAINER_M 2, 2nd use)
; Kanto hack: Route 6's two Jr.Trainers^M (Yellow JR_TRAINER_M 10 / 5)
	const NOLAN
	const OLIVER
; Kanto hack: ROUTE 12's Jr.Trainer^M (Yellow JR_TRAINER_M 9), M5 8l
	const LESTER

	trainerclass EXECUTIVEF ; 37
	const EXECUTIVEF_1
	const EXECUTIVEF_2

	trainerclass SAGE ; 38
	const CHOW
	const NICO
	const JIN
	const TROY
	const JEFFREY
	const PING
	const EDMOND
	const NEAL
	const LI
	const GAKU
	const MASA
	const KOJI

; Kanto hack (docs/M6-TOWER.md D12): Crystal has no CHANNELER class, and MEDIUM
; is the stand-in for Yellow's #MON TOWER channelers -- female, psychic-themed,
; already fights GASTLY/HAUNTER, and its overworld sprite is SPRITE_CHANNELER
; (byte-identical to pokeyellow's).  Only the battle portrait and the class name
; differ from Yellow.  BETHANY/MARGRET/ETHEL were dead Crystal rows and are
; rewritten in place as TOWER 3F's three; AGNES/EDITH/HAZEL are appended for 4F
; (D13 -- Yellow gives the channelers no names, so these are invented).
; 9g (5F) appends four and 9h (6F) three more.
	trainerclass MEDIUM ; 39
	const MARTHA
	const GRACE
	const BETHANY ; Kanto hack (M6 9f): #MON TOWER 3F, Yellow's CHANNELER 5
	const MARGRET ; Kanto hack (M6 9f): #MON TOWER 3F, Yellow's CHANNELER 6
	const ETHEL ; Kanto hack (M6 9f): #MON TOWER 3F, Yellow's CHANNELER 8
	const AGNES ; Kanto hack (M6 9f): #MON TOWER 4F, Yellow's CHANNELER 9
	const EDITH ; Kanto hack (M6 9f): #MON TOWER 4F, Yellow's CHANNELER 10
	const HAZEL ; Kanto hack (M6 9f): #MON TOWER 4F, Yellow's CHANNELER 12
	const OLIVE ; Kanto hack (M6 9g): #MON TOWER 5F, Yellow's CHANNELER 14
	const CORA ; Kanto hack (M6 9g): #MON TOWER 5F, Yellow's CHANNELER 16
	const RUBY ; Kanto hack (M6 9g): #MON TOWER 5F, Yellow's CHANNELER 17
	const MYRTLE ; Kanto hack (M6 9g): #MON TOWER 5F, Yellow's CHANNELER 18
	const ALMA ; Kanto hack (M6 9h): #MON TOWER 6F, Yellow's CHANNELER 19
	const NORA ; Kanto hack (M6 9h): #MON TOWER 6F, Yellow's CHANNELER 20
	const VERA ; Kanto hack (M6 9h): #MON TOWER 6F, Yellow's CHANNELER 21
	const TASHA ; Kanto hack (M8 11h): SAFFRON GYM, Yellow's CHANNELER 22
	const MARLENA ; Kanto hack (M8 11h): SAFFRON GYM, Yellow's CHANNELER 23
	const BEULAH ; Kanto hack (M8 11h): SAFFRON GYM, Yellow's CHANNELER 24

	trainerclass BOARDER ; 3a
	const RONALD
	const BRAD
	const DOUGLAS

	trainerclass POKEFANM ; 3b
	const WILLIAM
	const DEREK1
; Kanto hack (M5 8d): ROBERT deleted -- he was Crystal's ROUTE 10 POKEFAN, and
; Yellow has no POKEFAN anywhere on Route 10 (docs/M5-LAVENDER.md 5.3).
	const JOSHUA
; Kanto hack (M7 10d): CARTER and TREVOR were Crystal's own ROUTE 14 POKEFANs,
; deleted by 10d -- Yellow has no POKEFAN on ROUTE 14.  Both rows are mid-class,
; so they stay (BRANDON and everything after them keep their ids) and are marked
; unused; their event flags are renamed in place for ROUTE 14's own trainers.
	const CARTER ; unused (Kanto hack, M7 10d)
	const TREVOR ; unused (Kanto hack, M7 10d)
	const BRANDON
	const JEREMY
	const COLIN
	const DEREK2 ; unused
	const DEREK3 ; unused
; Kanto hack (M7 10c): ALEX deleted -- he was Crystal's ROUTE 13 POKEFAN, and
; Yellow has no POKEFAN on ROUTE 13.  He was the class's last row, so nothing
; renumbers.

	trainerclass KIMONO_GIRL ; 3c
	const NAOKO_UNUSED ; unused
	const NAOKO
	const SAYO
	const ZUKI
	const KUNI
	const MIKI

	trainerclass TWINS ; 3d
	const AMYANDMAY1
	const ANNANDANNE1
	const ANNANDANNE2
	const AMYANDMAY2
	const JOANDZOE1
	const JOANDZOE2
	const MEGANDPEG1
	const MEGANDPEG2
	const LEAANDPIA1
	const LEAANDPIA2 ; unused

	trainerclass POKEFANF ; 3e
	const BEVERLY1
	const RUTH
	const BEVERLY2 ; unused
	const BEVERLY3 ; unused
	const GEORGIA
	const JAIME

	trainerclass RED ; 3f
	const RED1

	trainerclass BLUE ; 40
	const BLUE1

	trainerclass OFFICER ; 41
	const KEITH
	const DIRK

	trainerclass GRUNTF ; 42
	const GRUNTF_1
	const GRUNTF_2
	const GRUNTF_3
	const GRUNTF_4
	const GRUNTF_5

; Kanto hack: Blue, the Kanto rival (docs/M2-INTRO.md). Named from wRivalName.
	trainerclass KANTO_RIVAL ; 43
	const KANTO_RIVAL_1 ; Oak's Lab
	const KANTO_RIVAL_2 ; Route 22
	const KANTO_RIVAL_3 ; Cerulean City, the south end of Nugget Bridge (6d)
	const KANTO_RIVAL_4 ; S.S. ANNE 2F, the corridor outside the CAPTAIN's room (7i)
	const KANTO_RIVAL_5 ; POKEMON TOWER 2F, the JOLTEON branch of the Eevee rule (9e)
	const KANTO_RIVAL_6 ; POKEMON TOWER 2F, the FLAREON branch (9e)
	const KANTO_RIVAL_7 ; POKEMON TOWER 2F, the VAPOREON branch (9e)
	const KANTO_RIVAL_8 ; SILPH CO. 7F, the JOLTEON branch (11g)
	const KANTO_RIVAL_9 ; SILPH CO. 7F, the FLAREON branch (11g)
	const KANTO_RIVAL_10 ; SILPH CO. 7F, the VAPOREON branch (11g)
	const KANTO_RIVAL_11 ; ROUTE 22 after 8 badges, the JOLTEON branch (M10 13c)
	const KANTO_RIVAL_12 ; ROUTE 22 after 8 badges, the FLAREON branch (M10 13c)
	const KANTO_RIVAL_13 ; ROUTE 22 after 8 badges, the VAPOREON branch (M10 13c)

; Kanto hack: Yellow's rival-starter selector, ported value for value from
; vendor/pokeyellow/constants/pokemon_constants.asm:207-209.  Yellow keeps it in
; the saved byte wRivalStarter; we derive it instead from the EVENT_ pair
; EVENT_BEAT_OAKS_LAB_RIVAL + EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE (the rule
; block at constants/event_flags.asm, "Cerulean rival battle"), which is what
; `special GetKantoRivalStarter` (engine/events/kanto_rival.asm) returns in
; wScriptVar.  It picks the rival's PARTY ROW from POKEMON TOWER 2F onward --
; in Yellow the EEVEE itself is still an EEVEE at the Tower and only appears
; evolved from SILPH CO. 7F on (docs/M6-TOWER.md "## 9e findings").
DEF RIVAL_STARTER_JOLTEON  EQU 1
DEF RIVAL_STARTER_FLAREON  EQU 2
DEF RIVAL_STARTER_VAPOREON EQU 3

; Kanto hack: Jessie & James, the recurring Rocket duo (docs/M2-MTMOON.md 5h).
; One class, one party id per Yellow encounter: Mt. Moon B2F now, then Rocket
; Hideout B4F, Pokemon Tower 7F and Silph Co. 11F in later milestones.
	trainerclass JESSIE_JAMES ; 44
	const JESSIE_JAMES_1 ; Mt. Moon B2F
	const JESSIE_JAMES_2 ; Pokemon Tower 7F
	const JESSIE_JAMES_3 ; Rocket Hideout B4F
	const JESSIE_JAMES_4 ; Silph Co. 11F (Kanto hack, M8 11h)

; Kanto hack: GIOVANNI, the Rocket boss (docs/M6-CELADON.md D33).  Crystal has
; no such class -- Yellow's `trainer_const GIOVANNI ; $1D`.  Inserted BEFORE
; MYSTICALMAN because several class-keyed tables end in
; `assert_table_length NUM_TRAINER_CLASSES - 1 ; exclude MYSTICALMAN`.
; All three of his Yellow battles get a row now so Saffron and Viridian need
; no further class work.
	trainerclass GIOVANNI ; 45
	const GIOVANNI_1 ; Rocket Hideout B4F
	const GIOVANNI_2 ; Silph Co. 11F
	const GIOVANNI_3 ; Viridian Gym

; Kanto hack: CUE BALL (docs/M6-CELADON.md D34).  Crystal has no such class --
; Yellow's `trainer_const CUE_BALL ; $2E`, used on ROUTE 16 (1-3), ROUTE 17
; (4-8) and ROUTE 21 (9).  Folding them into BIKER was the alternative, but
; that is 2 reserved slots for 9 trainers and the class word on screen would
; read "BIKER".  Inserted BEFORE MYSTICALMAN, like GIOVANNI above.
; Every party row leaves the name empty, so PlaceEnemysName prints
; "CUE BALL" alone, which is exactly what Yellow shows.
	trainerclass CUE_BALL ; 46
	const CUE_BALL_1 ; ROUTE 16
	const CUE_BALL_2 ; ROUTE 16
	const CUE_BALL_3 ; ROUTE 16
	const CUE_BALL_4 ; ROUTE 17 (M6 9z)
	const CUE_BALL_5 ; ROUTE 17 (M6 9z)
	const CUE_BALL_6 ; ROUTE 17 (M6 9z)
	const CUE_BALL_7 ; ROUTE 17 (M6 9z)
	const CUE_BALL_8 ; ROUTE 17 (M6 9z)
	const CUE_BALL_9 ; ROUTE 21 (reserved for M9 -- D62 moved ROUTES 19-21 out of M7)

; Kanto hack: TAMER (docs/M7-FUCHSIA.md D55).  Crystal has no such class --
; Yellow's `trainer_const TAMER ; $2D`, used in FUCHSIA GYM (1-2), VIRIDIAN GYM
; (3-4) and VICTORY ROAD 2F (5).  Inserted BEFORE MYSTICALMAN, like GIOVANNI and
; CUE BALL above, because several class-keyed tables end in
; `assert_table_length NUM_TRAINER_CLASSES - 1 ; exclude MYSTICALMAN`.
; Every party row leaves the name empty, so PlaceEnemysName prints "TAMER"
; alone, which is what Yellow shows.  The pic is Crystal's BIKER for now --
; M7 10h ported pokeyellow gfx/trainers/tamer.png, so the pic is Yellow's own.
	trainerclass TAMER ; 47
	const TAMER_1 ; FUCHSIA GYM
	const TAMER_2 ; FUCHSIA GYM
	const TAMER_3 ; VIRIDIAN GYM (M10 13b)
	const TAMER_4 ; VIRIDIAN GYM (M10 13b)
	const TAMER_5 ; VICTORY ROAD 2F (reserved for M8)

	trainerclass MYSTICALMAN ; 48
	const EUSINE

DEF NUM_TRAINER_CLASSES EQU __trainer_class__ - 1
