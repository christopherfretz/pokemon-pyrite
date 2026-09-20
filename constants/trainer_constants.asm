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
	const KIPP
	const ALAN1
	const JOHNNY
	const DANNY
	const TOMMY
	const DUDLEY
	const JOE
	const BILLY
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
	const HANK
	const ROY
	const BORIS
	const BOB
	const JOSE1
	const PETER
	const JOSE2
	const PERRY
	const BRET
	const JOSE3
	const VANCE2
	const VANCE3

	trainerclass LASS ; 19
	const CARRIE
	const BRIDGET
	const ALICE
	const KRISE
	const CONNIE1
	const LINDA
	const LAURA
	const SHANNON
	const MICHELLE
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

	trainerclass JANINE ; 1a
	const JANINE1

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
	const ANDY ; unused
	const TYLER ; unused
	const SEAN
	const KEVIN
	const STEVE ; unused
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

	trainerclass BEAUTY ; 1d
	const VICTORIA
	const SAMANTHA
	const JULIE ; unused
	const JACLYN ; unused
	const BRENDA ; unused
	const CASSIE
	const CAROLINE ; unused
	const CARLENE ; unused
	const JESSICA ; unused
	const RACHAEL ; unused
	const ANGELICA ; unused
	const KENDRA ; unused
	const VERONICA ; unused
	const JULIA
	const THERESA ; unused
	const VALERIE
	const OLIVIA

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
	const GRUNTM_30 ; unused
	const GRUNTM_31

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
	const COLETTE
	const HILLARY
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
	const ARNOLD
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

	trainerclass SWIMMERM ; 26
	const HAROLD
	const SIMON
	const RANDALL
	const CHARLIE
	const GEORGE
	const BERKE
	const KIRK
	const MATHEW
	const HAL ; unused
	const PATON ; unused
	const DARYL ; unused
	const WALTER ; unused
	const TONY ; unused
	const JEROME
	const TUCKER
	const RICK ; unused
	const CAMERON
	const SETH
	const JAMES ; unused
	const LEWIS ; unused
	const LUIS ; Kanto hack: Cerulean Gym, Yellow's SWIMMER 1 (was PARKER,
	           ; Crystal's own gym swimmer; renamed in place, 6e)

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
	const BIKER_BENNY ; unused
	const KAZU ; unused
	const DWAYNE
	const HARRIS
	const ZEKE
	const CHARLES
	const RILEY
	const JOEL
	const GLENN

	trainerclass BLAINE ; 2e
	const BLAINE1

	trainerclass BURGLAR ; 2f
	const DUNCAN
	const EDDIE
	const COREY

	trainerclass FIREBREATHER ; 30
	const OTIS
	const DICK ; unused
	const NED ; unused
	const BURT
	const BILL
	const WALT
	const RAY
	const LYLE

	trainerclass JUGGLER ; 31
	const IRWIN1
	const FRITZ
	const HORTON
	const IRWIN2 ; unused
	const IRWIN3 ; unused
	const IRWIN4 ; unused

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

	trainerclass EXECUTIVEM ; 33
	const EXECUTIVEM_1
	const EXECUTIVEM_2
	const EXECUTIVEM_3
	const EXECUTIVEM_4

	trainerclass PSYCHIC_T ; 34
	const NATHAN
	const FRANKLIN
	const HERMAN
	const FIDEL
	const GREG
	const NORMAN
	const MARK
	const PHIL
	const RICHARD
	const GILBERT
	const JARED
	const RODNEY

	trainerclass PICNICKER ; 35
	const LIZ1
	const GINA1
	const BROOKE
	const KIM
	const CINDY
	const HOPE
	const SHARON
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
; 9g (5F) and 9h (6F) append seven more here.
	trainerclass MEDIUM ; 39
	const MARTHA
	const GRACE
	const BETHANY ; Kanto hack (M6 9f): #MON TOWER 3F, Yellow's CHANNELER 5
	const MARGRET ; Kanto hack (M6 9f): #MON TOWER 3F, Yellow's CHANNELER 6
	const ETHEL ; Kanto hack (M6 9f): #MON TOWER 3F, Yellow's CHANNELER 8
	const REBECCA
	const DORIS
	const AGNES ; Kanto hack (M6 9f): #MON TOWER 4F, Yellow's CHANNELER 9
	const EDITH ; Kanto hack (M6 9f): #MON TOWER 4F, Yellow's CHANNELER 10
	const HAZEL ; Kanto hack (M6 9f): #MON TOWER 4F, Yellow's CHANNELER 12

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
	const CARTER
	const TREVOR
	const BRANDON
	const JEREMY
	const COLIN
	const DEREK2 ; unused
	const DEREK3 ; unused
	const ALEX

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

	trainerclass MYSTICALMAN ; 45
	const EUSINE

DEF NUM_TRAINER_CLASSES EQU __trainer_class__ - 1
