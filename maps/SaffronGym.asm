	object_const_def
	const SAFFRONGYM_SABRINA
	const SAFFRONGYM_CHANNELER1
	const SAFFRONGYM_YOUNGSTER1
	const SAFFRONGYM_CHANNELER2
	const SAFFRONGYM_YOUNGSTER2
	const SAFFRONGYM_CHANNELER3
	const SAFFRONGYM_YOUNGSTER3
	const SAFFRONGYM_YOUNGSTER4
	const SAFFRONGYM_GYM_GUIDE

SaffronGym_MapScripts:
	def_scene_scripts

	def_callbacks

; Kanto hack (M8 11l, docs/M8-SAFFRON.md 11l): SAFFRON GYM is Yellow's, not
; Crystal's.  Crystal's four-trainer room (REBECCA / DORIS / FRANKLIN / JARED)
; is gone; the roster is Yellow's seven -- three CHANNELERs (our MEDIUM class,
; the same stand-in POKEMON TOWER uses) and four PSYCHICs -- at Yellow's
; coordinates and facings (vendor/pokeyellow/data/maps/objects/SaffronGym.asm),
; all with Yellow's own view_range 3 as the GSC sight range.
;
; THE WARP-PAD MAZE.  Yellow's 30 teleport pads are pure map data: maps/
; SaffronGym.blk is now Yellow's byte-for-byte, and the map moved from
; TILESET_UNDERGROUND to TILESET_KANTO_FACILITY (data/maps/maps.asm), whose
; block $2f already carries COLL_WARP_PANEL in its bottom-left quadrant (11b).
; The 32 warp_events below are Yellow's, verbatim, ids included: 1-2 are the
; door, and 3-32 pair into 15 two-way pad links.
;
; SABRINA fights as Crystal's own SABRINA class (already in KantoGymLeaders, so
; the leader music is right) with Yellow's party -- L50 ABRA / KADABRA /
; ALAKAZAM, no custom moves (D79).
SaffronGymSabrinaScript:
	faceplayer
	opentext
	checkflag ENGINE_MARSHBADGE
	iftrue .FightDone
	writetext SabrinaBeforeBattleText
	waitbutton
	closetext
	winlosstext SabrinaWinLossText, 0
	loadtrainer SABRINA, SABRINA1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_SABRINA
	; Yellow's SetEventRange EVENT_BEAT_SAFFRON_GYM_TRAINER_0 ..
	; EVENT_BEAT_SAFFRON_GYM_TRAINER_6 -- beating SABRINA retires all seven
	; gym trainers, as in CELADON and FUCHSIA.
	setevent EVENT_BEAT_MEDIUM_TASHA
	setevent EVENT_BEAT_PSYCHIC_TYRON
	setevent EVENT_BEAT_MEDIUM_MARLENA
	setevent EVENT_BEAT_PSYCHIC_HOLLIS
	setevent EVENT_BEAT_MEDIUM_BEULAH
	setevent EVENT_BEAT_PSYCHIC_EZRA
	setevent EVENT_BEAT_PSYCHIC_DARIUS
	opentext
	writetext ReceivedMarshBadgeText
	playsound SFX_GET_BADGE
	waitsfx
	setflag ENGINE_MARSHBADGE
.FightDone:
	; Yellow re-runs SaffronGymSabrinaReceiveTM46Script -- badge blurb and all
	; -- every time you talk to SABRINA until EVENT_GOT_TM46 is set, so the
	; MARSHBADGE info text (which ends "Wait, please take this TM with you!")
	; is the TM's own lead-in.  Same shape as KOGA in M7.
	;
	; Yellow's badge jingle here plays the wrong SFX channel (a documented
	; Yellow bug); D90 says do NOT reproduce it, so the badge gets Crystal's
	; normal SFX_GET_BADGE and the TM Crystal's normal verbosegiveitem jingle.
	checkevent EVENT_GOT_TM81_PSYWAVE
	iftrue .GotTM81
	writetext SabrinaMarshBadgeInfoText
	promptbutton
	; Yellow hands over TM46 PSYWAVE.  In our TM union PSYWAVE is TM81
	; (constants/item_constants.asm), and the in-game text uses OUR number --
	; the same call ERIKA's TM21->TM67 and COPYCAT's TM31->TM71 made.
	verbosegiveitem TM_PSYWAVE
	iffalse .NoRoomForTM
	setevent EVENT_GOT_TM81_PSYWAVE
	writetext SabrinaTM81ExplanationText
	waitbutton
	closetext
	end

.GotTM81:
	writetext SabrinaPostBattleAdviceText
	waitbutton
	closetext
	end

.NoRoomForTM:
	writetext SabrinaTM81NoRoomText
	waitbutton
	closetext
	end

TrainerMediumTasha:
	trainer MEDIUM, TASHA, EVENT_BEAT_MEDIUM_TASHA, SaffronGymChanneler1SeenText, SaffronGymChanneler1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SaffronGymChanneler1AfterBattleText
	waitbutton
	closetext
	end

TrainerPsychicTyron:
	trainer PSYCHIC_T, TYRON, EVENT_BEAT_PSYCHIC_TYRON, SaffronGymYoungster1SeenText, SaffronGymYoungster1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SaffronGymYoungster1AfterBattleText
	waitbutton
	closetext
	end

TrainerMediumMarlena:
	trainer MEDIUM, MARLENA, EVENT_BEAT_MEDIUM_MARLENA, SaffronGymChanneler2SeenText, SaffronGymChanneler2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SaffronGymChanneler2AfterBattleText
	waitbutton
	closetext
	end

TrainerPsychicHollis:
	trainer PSYCHIC_T, HOLLIS, EVENT_BEAT_PSYCHIC_HOLLIS, SaffronGymYoungster2SeenText, SaffronGymYoungster2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SaffronGymYoungster2AfterBattleText
	waitbutton
	closetext
	end

TrainerMediumBeulah:
	trainer MEDIUM, BEULAH, EVENT_BEAT_MEDIUM_BEULAH, SaffronGymChanneler3SeenText, SaffronGymChanneler3BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SaffronGymChanneler3AfterBattleText
	waitbutton
	closetext
	end

TrainerPsychicEzra:
	trainer PSYCHIC_T, EZRA, EVENT_BEAT_PSYCHIC_EZRA, SaffronGymYoungster3SeenText, SaffronGymYoungster3BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SaffronGymYoungster3AfterBattleText
	waitbutton
	closetext
	end

TrainerPsychicDarius:
	trainer PSYCHIC_T, DARIUS, EVENT_BEAT_PSYCHIC_DARIUS, SaffronGymYoungster4SeenText, SaffronGymYoungster4BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SaffronGymYoungster4AfterBattleText
	waitbutton
	closetext
	end

SaffronGymGuideScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_SABRINA
	iftrue .BeatSabrina
	writetext SaffronGymGuideChampInMakingText
	waitbutton
	closetext
	end

.BeatSabrina:
	writetext SaffronGymGuideBeatSabrinaText
	waitbutton
	closetext
	end

SaffronGymStatue:
	; Kanto hack (N1a): Yellow's pre-badge statue names the LEADER too
	; (_GymStatueText1), so wStringBuffer4 must be filled for BOTH statues.
	gettrainername STRING_BUFFER_4, SABRINA, SABRINA1
	checkflag ENGINE_MARSHBADGE
	iftrue .Beaten
	jumpstd GymStatue1Script
.Beaten:
	jumpstd GymStatue2Script

SabrinaBeforeBattleText:
	text "SABRINA: I had a"
	line "vision of your"
	cont "arrival!"

	para "I have had psychic"
	line "powers since I"
	cont "was a child."

	para "I first learned"
	line "to bend spoons"
	cont "with my mind."

	para "I dislike fight-"
	line "ing, but if you"
	cont "wish, I will show"
	cont "you my powers!"
	done

SabrinaWinLossText:
	text "SABRINA: I'm"
	line "shocked!"
	cont "But, a loss is a"
	cont "loss."

	para "I admit I didn't"
	line "work hard enough"
	cont "to win!"

	para "You earned the"
	line "MARSHBADGE!"
	done

ReceivedMarshBadgeText:
	text "<PLAYER> received"
	line "MARSHBADGE."
	done

SabrinaMarshBadgeInfoText:
	text "SABRINA: The"
	line "MARSHBADGE makes"
	cont "#MON up to L70"
	cont "obey you!"

	para "Stronger #MON"
	line "will become wild,"
	cont "ignoring your"
	cont "orders in battle!"

	para "Just don't raise"
	line "your #MON too"
	cont "much!"

	para "Wait, please take"
	line "this TM with you!"
	done

SabrinaTM81ExplanationText:
	text "TM81 is PSYWAVE!"
	line "It uses powerful"
	cont "psychic waves to"
	cont "inflict damage!"
	done

SabrinaTM81NoRoomText:
	text "SABRINA: Your pack"
	line "is full of other"
	cont "items!"
	done

SabrinaPostBattleAdviceText:
	text "SABRINA: Everyone"
	line "has psychic power!"
	cont "People just don't"
	cont "realize it!"
	done

SaffronGymChanneler1SeenText:
	text "SABRINA is younger"
	line "than I, but I"
	cont "respect her!"
	done

SaffronGymChanneler1BeatenText:
	text "Not"
	line "good enough!"
	done

SaffronGymChanneler1AfterBattleText:
	text "In a battle of"
	line "equals, the one"
	cont "with the stronger"
	cont "will wins!"

	para "If you wish"
	line "to beat SABRINA,"
	cont "focus on winning!"
	done

SaffronGymYoungster1SeenText:
	text "Does our unseen"
	line "power scare you?"
	done

SaffronGymYoungster1BeatenText:
	text "I never"
	line "foresaw this!"
	done

SaffronGymYoungster1AfterBattleText:
	text "Psychic #MON"
	line "fear only bugs!"
	done

SaffronGymChanneler2SeenText:
	text "#MON take on"
	line "the appearance of"
	cont "their trainers."

	para "Your #MON must"
	line "be tough, then!"
	done

SaffronGymChanneler2BeatenText:
	text "I knew"
	line "it!"
	done

SaffronGymChanneler2AfterBattleText:
	text "I must teach"
	line "better techniques"
	cont "to my #MON!"
	done

SaffronGymYoungster2SeenText:
	text "You know that"
	line "power alone isn't"
	cont "enough!"
	done

SaffronGymYoungster2BeatenText:
	text "I don't"
	line "believe this!"
	done

SaffronGymYoungster2AfterBattleText:
	text "SABRINA just wiped"
	line "out the KARATE"
	cont "MASTER next door!"
	done

SaffronGymChanneler3SeenText:
	text "You and I, our"
	line "#MON shall"
	cont "fight!"
	done

SaffronGymChanneler3BeatenText:
	text "I lost"
	line "after all!"
	done

SaffronGymChanneler3AfterBattleText:
	text "I knew that this"
	line "was going to take"
	cont "place."
	done

SaffronGymYoungster3SeenText:
	text "SABRINA is young,"
	line "but she's also"
	cont "our LEADER!"

	para "You won't reach"
	line "her easily!"
	done

SaffronGymYoungster3BeatenText:
	text "I lost"
	line "my concentration!"
	done

SaffronGymYoungster3AfterBattleText:
	text "There used to be"
	line "2 #MON GYMs in"
	cont "SAFFRON."

	para "The FIGHTING DOJO"
	line "next door lost"
	cont "its GYM status"
	cont "when we went and"
	cont "creamed them!"
	done

SaffronGymYoungster4SeenText:
	text "SAFFRON #MON"
	line "GYM is famous for"
	cont "its psychics!"

	para "You want to see"
	line "SABRINA!"
	cont "I can tell!"
	done

SaffronGymYoungster4BeatenText:
	text "Arrrgh!"
	done

SaffronGymYoungster4AfterBattleText:
	text "That's right! I"
	line "used telepathy to"
	cont "read your mind!"
	done

SaffronGymGuideChampInMakingText:
	text "Yo! Champ in"
	line "making!"

	para "SABRINA's #MON"
	line "use psychic power"
	cont "instead of force!"

	para "Fighting #MON"
	line "are weak against"
	cont "psychic #MON!"

	para "They get creamed"
	line "before they can"
	cont "even aim a punch!"
	done

SaffronGymGuideBeatSabrinaText:
	text "Psychic power,"
	line "huh?"

	para "If I had that,"
	line "I'd make a bundle"
	cont "at the slots!"
	done

SaffronGym_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; Kanto hack (M8 11l): Yellow's 32 warps, verbatim.  1-2 are the gym door;
; 3-32 are the 30 teleport pads, paired exactly as Yellow pairs them, so every
; pad is a two-way link (3<->23, 4<->16, 5<->19, 6<->9, 7<->28, 8<->17,
; 10<->14, 11<->24, 12<->31, 13<->18, 15<->27, 20<->32, 21<->25, 22<->29,
; 26<->30).
	warp_event  8, 17, SAFFRON_CITY, 3
	warp_event  9, 17, SAFFRON_CITY, 3
	warp_event  1,  3, SAFFRON_GYM, 23
	warp_event  5,  3, SAFFRON_GYM, 16
	warp_event  1,  5, SAFFRON_GYM, 19
	warp_event  5,  5, SAFFRON_GYM, 9
	warp_event  1,  9, SAFFRON_GYM, 28
	warp_event  5,  9, SAFFRON_GYM, 17
	warp_event  1, 11, SAFFRON_GYM, 6
	warp_event  5, 11, SAFFRON_GYM, 14
	warp_event  1, 15, SAFFRON_GYM, 24
	warp_event  5, 15, SAFFRON_GYM, 31
	warp_event  1, 17, SAFFRON_GYM, 18
	warp_event  5, 17, SAFFRON_GYM, 10
	warp_event  9,  3, SAFFRON_GYM, 27
	warp_event 11,  3, SAFFRON_GYM, 4
	warp_event  9,  5, SAFFRON_GYM, 8
	warp_event 11,  5, SAFFRON_GYM, 13
	warp_event 11, 11, SAFFRON_GYM, 5
	warp_event 11, 15, SAFFRON_GYM, 32
	warp_event 15,  3, SAFFRON_GYM, 25
	warp_event 19,  3, SAFFRON_GYM, 29
	warp_event 15,  5, SAFFRON_GYM, 3
	warp_event 19,  5, SAFFRON_GYM, 11
	warp_event 15,  9, SAFFRON_GYM, 21
	warp_event 19,  9, SAFFRON_GYM, 30
	warp_event 15, 11, SAFFRON_GYM, 15
	warp_event 19, 11, SAFFRON_GYM, 7
	warp_event 15, 15, SAFFRON_GYM, 22
	warp_event 19, 15, SAFFRON_GYM, 26
	warp_event 15, 17, SAFFRON_GYM, 12
	warp_event 19, 17, SAFFRON_GYM, 20

	def_coord_events

	def_bg_events
; Kanto hack (M8 11l): Yellow's SaffronGym has an empty def_bg_events, but the
; N1a convention (CELADON, FUCHSIA, VERMILION) keeps the badge statue.  The
; entrance chamber's only wall furniture is block $45's one-tile-wide pillar at
; (9,14)-(9,15), which is genuine art on genuine WALL tiles, so both statue
; reads live there.
	bg_event  9, 14, BGEVENT_READ, SaffronGymStatue
	bg_event  9, 15, BGEVENT_READ, SaffronGymStatue

	def_object_events
; Kanto hack (M8 11l): Yellow's nine objects at Yellow's coordinates.  Yellow's
; SABRINA is SPRITE_COOLTRAINER_F; she gets Crystal's own SPRITE_SABRINA, as
; ERIKA, LT.SURGE and KOGA got theirs.  The CHANNELERs use the Yellow CHANNELER
; art ported in M6 (SPRITE_CHANNELER), the same sprite POKEMON TOWER uses.
	object_event  9,  8, SPRITE_SABRINA, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SaffronGymSabrinaScript, -1
	object_event 10,  1, SPRITE_CHANNELER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerMediumTasha, -1
	object_event 17,  1, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerPsychicTyron, -1
	object_event  3,  7, SPRITE_CHANNELER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerMediumMarlena, -1
	object_event 17,  7, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerPsychicHollis, -1
	object_event  3, 13, SPRITE_CHANNELER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerMediumBeulah, -1
	object_event 17, 13, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerPsychicEzra, -1
	object_event  3,  1, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerPsychicDarius, -1
	object_event 10, 15, SPRITE_GYM_GUIDE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SaffronGymGuideScript, -1
