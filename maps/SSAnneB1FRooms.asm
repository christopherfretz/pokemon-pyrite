; Kanto hack: Yellow's SS_ANNE_B1F_ROOMS (docs/M4-VERMILION.md, 7h).  Yellow's
; eleven SSAnneB1FRooms_Object entries plus the hidden HYPER POTION, in Yellow's
; object order, at Yellow's coordinates and facings, with Yellow's sight ranges
; from SSAnne10TrainerHeaders (2/3/2/2/2/3) and Yellow's text verbatim.
;   Yellow ( 0,13) SAILOR 3 -> TrainerSailorLeo,     sight 2
;   Yellow ( 2,11) SAILOR 4 -> TrainerSailorBrady,   sight 3
;   Yellow (12, 3) SAILOR 5 -> TrainerSailorForrest, sight 2
;   Yellow (22, 2) SAILOR 6 -> TrainerSailorSeamus,  sight 2
;   Yellow ( 0, 2) SAILOR 7 -> TrainerSailorSilas,   sight 2
;   Yellow ( 0, 4) FISHER 2 -> TrainerFisherPercy,   sight 3
;   Yellow (10,13) SPRITE_SUPER_NERD -> SPRITE_SUPER_NERD 1:1
;   Yellow (11,12) SPRITE_MONSTER    -> SPRITE_MONSTER (the MACHOKE; same sheet
;                                      Vermilion City's MACHOP already uses)
;   Yellow (20, 2) SPRITE_POKE_BALL  -> ETHER item ball
;   Yellow (10, 2) SPRITE_POKE_BALL  -> TM_REST item ball
;   Yellow (12,11) SPRITE_POKE_BALL  -> MAX_POTION item ball
;   Yellow ( 3, 1) hidden_event HiddenItems, HYPER_POTION -> BGEVENT_ITEM
; 2.8/5.1 omit the hidden HYPER POTION; see "## 7h findings", correction 2.
; Five distinct NPC sheets: 12 (player) + 4 x 12 + 4 (POKE_BALL) = 64 tiles.
	object_const_def
	const SSANNEB1FROOMS_SAILOR1
	const SSANNEB1FROOMS_SAILOR2
	const SSANNEB1FROOMS_SAILOR3
	const SSANNEB1FROOMS_SAILOR4
	const SSANNEB1FROOMS_SAILOR5
	const SSANNEB1FROOMS_FISHER
	const SSANNEB1FROOMS_SUPER_NERD
	const SSANNEB1FROOMS_MACHOKE
	const SSANNEB1FROOMS_POKE_BALL1
	const SSANNEB1FROOMS_POKE_BALL2
	const SSANNEB1FROOMS_POKE_BALL3

SSAnneB1FRooms_MapScripts:
	def_scene_scripts

	def_callbacks

TrainerSailorLeo:
	trainer SAILOR, LEO, EVENT_BEAT_SAILOR_LEO, SailorLeoSeenText, SailorLeoBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SailorLeoAfterBattleText
	waitbutton
	closetext
	end

TrainerSailorBrady:
	trainer SAILOR, BRADY, EVENT_BEAT_SAILOR_BRADY, SailorBradySeenText, SailorBradyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SailorBradyAfterBattleText
	waitbutton
	closetext
	end

TrainerSailorForrest:
	trainer SAILOR, FORREST, EVENT_BEAT_SAILOR_FORREST, SailorForrestSeenText, SailorForrestBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SailorForrestAfterBattleText
	waitbutton
	closetext
	end

TrainerSailorSeamus:
	trainer SAILOR, SEAMUS, EVENT_BEAT_SAILOR_SEAMUS, SailorSeamusSeenText, SailorSeamusBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SailorSeamusAfterBattleText
	waitbutton
	closetext
	end

TrainerSailorSilas:
	trainer SAILOR, SILAS, EVENT_BEAT_SAILOR_SILAS, SailorSilasSeenText, SailorSilasBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SailorSilasAfterBattleText
	waitbutton
	closetext
	end

TrainerFisherPercy:
	trainer FISHER, PERCY, EVENT_BEAT_FISHER_PERCY, FisherPercySeenText, FisherPercyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext FisherPercyAfterBattleText
	waitbutton
	closetext
	end

SSAnneB1FRoomsSuperNerdScript:
	jumptextfaceplayer SSAnneB1FRoomsSuperNerdText

; Yellow plays MACHOKE's cry after printing the line, the same shape as the 1F
; Rooms WIGGLYTUFF and Vermilion City's MACHOP.
SSAnneB1FRoomsMachokeScript:
	opentext
	writetext SSAnneB1FRoomsMachokeText
	cry MACHOKE
	waitbutton
	closetext
	end

SSAnneB1FRoomsEther:
	itemball ETHER

SSAnneB1FRoomsTMRest:
	itemball TM_REST

SSAnneB1FRoomsMaxPotion:
	itemball MAX_POTION

SSAnneB1FRoomsHiddenHyperPotion:
	hiddenitem HYPER_POTION, EVENT_SS_ANNE_B1F_ROOMS_HIDDEN_HYPER_POTION

SailorLeoSeenText:
	text "You know what they"
	line "say about sailors"
	cont "and fighting!"
	done

SailorLeoBeatenText:
	text "Right!"
	line "Good fight, mate!"
	done

SailorLeoAfterBattleText:
	text "Haha! Want to be"
	line "a sailor, mate?"
	done

SailorBradySeenText:
	text "My sailor's pride"
	line "is at stake!"
	done

SailorBradyBeatenText:
	text "Your"
	line "spirit sank me!"
	done

SailorBradyAfterBattleText:
	text "Did you see the"
	line "FISHING GURU in"
	cont "VERMILION CITY?"
	done

SailorForrestSeenText:
	text "Us sailors have"
	line "#MON too!"
	done

SailorForrestBeatenText:
	text "OK, "
	line "you're not bad."
	done

SailorForrestAfterBattleText:
	text "We caught all our"
	line "#MON while"
	cont "out at sea!"
	done

SailorSeamusSeenText:
	text "I like feisty"
	line "kids like you!"
	done

SailorSeamusBeatenText:
	text "Argh!"
	line "Lost it!"
	done

SailorSeamusAfterBattleText:
	text "Sea #MON live"
	line "in deep water."
	cont "You'll need a ROD!"
	done

SailorSilasSeenText:
	text "Matey, you're"
	line "walking the plank"
	cont "if you lose!"
	done

SailorSilasBeatenText:
	text "Argh!"
	line "Beaten by a kid!"
	done

SailorSilasAfterBattleText:
	text "Jellyfish some-"
	line "times drift into"
	cont "the ship."
	done

FisherPercySeenText:
	text "Hello stranger!"
	line "Stop and chat!"

	para "All my #MON"
	line "are from the sea!"
	done

FisherPercyBeatenText:
	text "Darn!"
	line "I let that one"
	cont "get away!"
	done

FisherPercyAfterBattleText:
	text "I was going to"
	line "make you my"
	cont "assistant too!"
	done

SSAnneB1FRoomsSuperNerdText:
	text "My buddy, MACHOKE,"
	line "is super strong!"

	para "He has enough"
	line "STRENGTH to move"
	cont "big rocks!"
	done

SSAnneB1FRoomsMachokeText:
	text "MACHOKE: Gwoh!"
	line "Goggoh!"
	done

SSAnneB1FRooms_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  5, SS_ANNE_B1F, 5
	warp_event  3,  5, SS_ANNE_B1F, 5
	warp_event 12,  5, SS_ANNE_B1F, 4
	warp_event 13,  5, SS_ANNE_B1F, 4
	warp_event 22,  5, SS_ANNE_B1F, 3
	warp_event 23,  5, SS_ANNE_B1F, 3
	warp_event  2, 15, SS_ANNE_B1F, 2
	warp_event  3, 15, SS_ANNE_B1F, 2
	warp_event 12, 15, SS_ANNE_B1F, 1
	warp_event 13, 15, SS_ANNE_B1F, 1

	def_coord_events

	def_bg_events
	bg_event  3,  1, BGEVENT_ITEM, SSAnneB1FRoomsHiddenHyperPotion

	def_object_events
	object_event  0, 13, SPRITE_SAILOR, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, TrainerSailorLeo, -1
	object_event  2, 11, SPRITE_SAILOR, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerSailorBrady, -1
	object_event 12,  3, SPRITE_SAILOR, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, TrainerSailorForrest, -1
	object_event 22,  2, SPRITE_SAILOR, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, TrainerSailorSeamus, -1
	object_event  0,  2, SPRITE_SAILOR, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, TrainerSailorSilas, -1
	object_event  0,  4, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 3, TrainerFisherPercy, -1
	object_event 10, 13, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnneB1FRoomsSuperNerdScript, -1
	object_event 11, 12, SPRITE_MONSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnneB1FRoomsMachokeScript, -1
	object_event 20,  2, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SSAnneB1FRoomsEther, EVENT_SS_ANNE_B1F_ROOMS_ETHER
	object_event 10,  2, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SSAnneB1FRoomsTMRest, EVENT_SS_ANNE_B1F_ROOMS_TM_REST
	object_event 12, 11, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SSAnneB1FRoomsMaxPotion, EVENT_SS_ANNE_B1F_ROOMS_MAX_POTION
