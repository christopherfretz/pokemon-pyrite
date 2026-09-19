; Kanto hack: Yellow's SS_ANNE_BOW (docs/M4-VERMILION.md, 7h).  Yellow's five
; SSAnneBow_Object entries, in Yellow's object order, at Yellow's coordinates and
; facings, with Yellow's sight ranges from SSAnne5TrainerHeaders (3/3) and
; Yellow's text verbatim.  Yellow's party data file calls this deck "SS Anne
; Stern"; it is SSAnne5 / SS_ANNE_BOW.
;   Yellow ( 5, 2) SPRITE_SUPER_NERD    -> SPRITE_SUPER_NERD 1:1
;   Yellow ( 4, 9) SPRITE_SAILOR        -> SPRITE_SAILOR 1:1
;   Yellow ( 7,11) SPRITE_COOLTRAINER_M -> SPRITE_COOLTRAINER_M 1:1 (the seasick passenger)
;   Yellow ( 4, 4) SAILOR 1 -> TrainerSailorMurdock, sight 3
;   Yellow (10, 8) SAILOR 2 -> TrainerSailorMurphy,  sight 3
	object_const_def
	const SSANNEBOW_SUPER_NERD
	const SSANNEBOW_SAILOR1
	const SSANNEBOW_COOLTRAINER_M
	const SSANNEBOW_SAILOR2
	const SSANNEBOW_SAILOR3

SSAnneBow_MapScripts:
	def_scene_scripts

	def_callbacks

SSAnneBowSuperNerdScript:
	jumptextfaceplayer SSAnneBowSuperNerdText

SSAnneBowSailor1Script:
	jumptextfaceplayer SSAnneBowSailor1Text

SSAnneBowCooltrainerMScript:
	jumptextfaceplayer SSAnneBowCooltrainerMText

TrainerSailorMurdock:
	trainer SAILOR, MURDOCK, EVENT_BEAT_SAILOR_MURDOCK, SailorMurdockSeenText, SailorMurdockBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SailorMurdockAfterBattleText
	waitbutton
	closetext
	end

TrainerSailorMurphy:
	trainer SAILOR, MURPHY, EVENT_BEAT_SAILOR_MURPHY, SailorMurphySeenText, SailorMurphyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SailorMurphyAfterBattleText
	waitbutton
	closetext
	end

SSAnneBowSuperNerdText:
	text "The party's over."
	line "The ship will be"
	cont "departing soon."
	done

SSAnneBowSailor1Text:
	text "Scrubbing decks"
	line "is hard work!"
	done

SSAnneBowCooltrainerMText:
	text "Urf. I feel ill."

	para "I stepped out to"
	line "get some air."
	done

SailorMurdockSeenText:
	text "Hey matey!"

	para "Let's do a little"
	line "jig!"
	done

SailorMurdockBeatenText:
	text "You're"
	line "impressive!"
	done

SailorMurdockAfterBattleText:
	text "How many kinds of"
	line "#MON do you"
	cont "think there are?"
	done

SailorMurphySeenText:
	text "Ahoy there!"
	line "Are you seasick?"
	done

SailorMurphyBeatenText:
	text "I was"
	line "just careless!"
	done

SailorMurphyAfterBattleText:
	text "My Pa said there"
	line "are 100 kinds of"
	cont "#MON. I think"
	cont "there are more."
	done

SSAnneBow_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 13,  6, SS_ANNE_3F, 1
	warp_event 13,  7, SS_ANNE_3F, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  5,  2, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnneBowSuperNerdScript, -1
	object_event  4,  9, SPRITE_SAILOR, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnneBowSailor1Script, -1
	object_event  7, 11, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SSAnneBowCooltrainerMScript, -1
	object_event  4,  4, SPRITE_SAILOR, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerSailorMurdock, -1
	object_event 10,  8, SPRITE_SAILOR, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerSailorMurphy, -1
