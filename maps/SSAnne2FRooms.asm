; Kanto hack: Yellow's SS_ANNE_2F_ROOMS (docs/M4-VERMILION.md, 7h).  Yellow's
; thirteen SSAnne2FRooms_Object entries, in Yellow's object order, at Yellow's
; coordinates and facings, with Yellow's sight ranges from SSAnne9TrainerHeaders
; (2/3/3/2) and Yellow's text verbatim.
;   Yellow (10, 2) GENTLEMAN 3 -> TrainerGentlemanClive,  sight 2
;   Yellow (13, 4) FISHER 1    -> TrainerFisherDalton,    sight 3
;   Yellow ( 0,14) GENTLEMAN 5 -> TrainerGentlemanHubert, sight 3
;   Yellow ( 2,11) LASS 12     -> TrainerLassMarisa,      sight 2
;   Yellow ( 1, 2) SPRITE_GENTLEMAN     -> the SNORLAX storyteller (see below)
;   Yellow (12, 1) SPRITE_POKE_BALL     -> MAX_ETHER item ball
;   Yellow (21, 2) SPRITE_GENTLEMAN     -> SPRITE_GENTLEMAN 1:1
;   Yellow (22, 1) SPRITE_GRAMPS        -> SPRITE_GRAMPS 1:1 (the CUT hint)
;   Yellow ( 0,12) SPRITE_POKE_BALL     -> RARE_CANDY item ball
;   Yellow (12,12) SPRITE_GENTLEMAN     -> SPRITE_GENTLEMAN 1:1
;   Yellow (11,14) SPRITE_LITTLE_BOY    -> SPRITE_YOUNGSTER
;   Yellow (22,12) SPRITE_BRUNETTE_GIRL -> SPRITE_LASS
;   Yellow (20,12) SPRITE_BEAUTY        -> SPRITE_BEAUTY 1:1
; Eight distinct NPC sheets: 12 (player) + 7 x 12 + 4 (POKE_BALL) = 100 of the
; 108 sprite-VRAM tiles below FOLLOWER_VTILE.  No overflow.
	object_const_def
	const SSANNE2FROOMS_GENTLEMAN1
	const SSANNE2FROOMS_FISHER
	const SSANNE2FROOMS_GENTLEMAN2
	const SSANNE2FROOMS_COOLTRAINER_F
	const SSANNE2FROOMS_GENTLEMAN3
	const SSANNE2FROOMS_POKE_BALL1
	const SSANNE2FROOMS_GENTLEMAN4
	const SSANNE2FROOMS_GRAMPS
	const SSANNE2FROOMS_POKE_BALL2
	const SSANNE2FROOMS_GENTLEMAN5
	const SSANNE2FROOMS_LITTLE_BOY
	const SSANNE2FROOMS_BRUNETTE_GIRL
	const SSANNE2FROOMS_BEAUTY

SSAnne2FRooms_MapScripts:
	def_scene_scripts

	def_callbacks

TrainerGentlemanClive:
	trainer GENTLEMAN, CLIVE, EVENT_BEAT_GENTLEMAN_CLIVE, GentlemanCliveSeenText, GentlemanCliveBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext GentlemanCliveAfterBattleText
	waitbutton
	closetext
	end

TrainerFisherDalton:
	trainer FISHER, DALTON, EVENT_BEAT_FISHER_DALTON, FisherDaltonSeenText, FisherDaltonBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext FisherDaltonAfterBattleText
	waitbutton
	closetext
	end

TrainerGentlemanHubert:
	trainer GENTLEMAN, HUBERT, EVENT_BEAT_GENTLEMAN_HUBERT, GentlemanHubertSeenText, GentlemanHubertBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext GentlemanHubertAfterBattleText
	waitbutton
	closetext
	end

TrainerLassMarisa:
	trainer LASS, MARISA, EVENT_BEAT_LASS_MARISA, LassMarisaSeenText, LassMarisaBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassMarisaAfterBattleText
	waitbutton
	closetext
	end

; Yellow's SSAnne2FRoomsGentleman3Text prints its line (ending in `prompt`) and
; then calls DisplayPokedex SNORLAX -- "It was something like this!" is followed
; by the dex entry for the sleeper.  GSC has no "open the POKeDEX at species N"
; script command (the M3 ruling, docs/M3-CERULEAN.md 6j.7), so the closest
; in-engine substitute is `pokepic`, the ElmsLab.asm starter-portrait idiom.
; Deviation recorded in "## 7h findings".
SSAnne2FRoomsGentleman3Script:
	faceplayer
	opentext
	writetext SSAnne2FRoomsGentleman3Text
	promptbutton
	closetext
	pokepic SNORLAX
	waitbutton
	closepokepic
	end

SSAnne2FRoomsMaxEther:
	itemball MAX_ETHER

SSAnne2FRoomsGentleman4Script:
	jumptextfaceplayer SSAnne2FRoomsGentleman4Text

SSAnne2FRoomsGrampsScript:
	jumptextfaceplayer SSAnne2FRoomsGrampsText

SSAnne2FRoomsRareCandy:
	itemball RARE_CANDY

SSAnne2FRoomsGentleman5Script:
	jumptextfaceplayer SSAnne2FRoomsGentleman5Text

SSAnne2FRoomsLittleBoyScript:
	jumptextfaceplayer SSAnne2FRoomsLittleBoyText

SSAnne2FRoomsBrunetteGirlScript:
	jumptextfaceplayer SSAnne2FRoomsBrunetteGirlText

SSAnne2FRoomsBeautyScript:
	jumptextfaceplayer SSAnne2FRoomsBeautyText

GentlemanCliveSeenText:
	text "Competing against"
	line "the young keeps"
	cont "me youthful."
	done

GentlemanCliveBeatenText:
	text "Good"
	line "fight! Ah, I feel"
	cont "young again!"
	done

GentlemanCliveAfterBattleText:
	text "15 years ago, I"
	line "would have won!"
	done

FisherDaltonSeenText:
	text "Check out what I"
	line "fished up!"
	done

FisherDaltonBeatenText:
	text "I'm"
	line "all out!"
	done

FisherDaltonAfterBattleText:
	text "Party?"

	para "The cruise ship's"
	line "party should be"
	cont "over by now."
	done

GentlemanHubertSeenText:
	text "Which do you like,"
	line "a strong or a"
	cont "rare #MON?"
	done

GentlemanHubertBeatenText:
	text "I must"
	line "salute you!"
	done

GentlemanHubertAfterBattleText:
	text "I prefer strong"
	line "and rare #MON."
	done

LassMarisaSeenText:
	text "I never saw you"
	line "at the party."
	done

LassMarisaBeatenText:
	text "Take"
	line "it easy!"
	done

LassMarisaAfterBattleText:
	text "Oh, I adore your"
	line "strong #MON!"
	done

SSAnne2FRoomsGentleman3Text:
	text "In all my travels,"
	line "I've never seen"
	cont "any #MON sleep"
	cont "like this one!"

	para "It was something"
	line "like this!"
	done

SSAnne2FRoomsGentleman4Text:
	text "Ah yes, I have"
	line "seen some #MON"
	cont "ferry people"
	cont "across the water!"
	done

SSAnne2FRoomsGrampsText:
	text "#MON can CUT"
	line "down small bushes."
	done

SSAnne2FRoomsGentleman5Text:
	text "Have you gone to"
	line "the SAFARI ZONE"
	cont "in FUCHSIA CITY?"

	para "It had many rare"
	line "kinds of #MON!!"
	done

SSAnne2FRoomsLittleBoyText:
	text "Me and my Daddy"
	line "think the SAFARI"
	cont "ZONE is awesome!"
	done

SSAnne2FRoomsBrunetteGirlText:
	text "The CAPTAIN looked"
	line "really sick and"
	cont "pale!"
	done

SSAnne2FRoomsBeautyText:
	text "I hear many people"
	line "get seasick!"
	done

SSAnne2FRooms_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  5, SS_ANNE_2F, 1
	warp_event  3,  5, SS_ANNE_2F, 1
	warp_event 12,  5, SS_ANNE_2F, 2
	warp_event 13,  5, SS_ANNE_2F, 2
	warp_event 22,  5, SS_ANNE_2F, 3
	warp_event 23,  5, SS_ANNE_2F, 3
	warp_event  2, 15, SS_ANNE_2F, 4
	warp_event  3, 15, SS_ANNE_2F, 4
	warp_event 12, 15, SS_ANNE_2F, 5
	warp_event 13, 15, SS_ANNE_2F, 5
	warp_event 22, 15, SS_ANNE_2F, 6
	warp_event 23, 15, SS_ANNE_2F, 6

	def_coord_events

	def_bg_events

	def_object_events
	object_event 10,  2, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, TrainerGentlemanClive, -1
	object_event 13,  4, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 3, TrainerFisherDalton, -1
	object_event  0, 14, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerGentlemanHubert, -1
	object_event  2, 11, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerLassMarisa, -1
	object_event  1,  2, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnne2FRoomsGentleman3Script, -1
	object_event 12,  1, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SSAnne2FRoomsMaxEther, EVENT_SS_ANNE_2F_ROOMS_MAX_ETHER
	object_event 21,  2, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnne2FRoomsGentleman4Script, -1
	object_event 22,  1, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, SSAnne2FRoomsGrampsScript, -1
	object_event  0, 12, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SSAnne2FRoomsRareCandy, EVENT_SS_ANNE_2F_ROOMS_RARE_CANDY
	object_event 12, 12, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnne2FRoomsGentleman5Script, -1
	object_event 11, 14, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnne2FRoomsLittleBoyScript, -1
	object_event 22, 12, SPRITE_LASS, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, SSAnne2FRoomsBrunetteGirlScript, -1
	object_event 20, 12, SPRITE_BEAUTY, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnne2FRoomsBeautyScript, -1
