; Kanto hack (M6 9r, docs/M6-CELADON.md §3.5): Yellow's CELADON MART 2F, the
; TRAINER'S MARKET.  Clerk1 sells Yellow's general goods, Clerk2 the nine TMs
; (see data/items/marts.asm for the Yellow-TM-number mapping).

	object_const_def
	const CELADONDEPTSTORE2F_CLERK1
	const CELADONDEPTSTORE2F_CLERK2
	const CELADONDEPTSTORE2F_MIDDLE_AGED_MAN
	const CELADONDEPTSTORE2F_GIRL

CeladonDeptStore2F_MapScripts:
	def_scene_scripts

	def_callbacks

CeladonDeptStore2FClerk1Script:
	faceplayer
	opentext
	pokemart MARTTYPE_STANDARD, MART_CELADON_2F_1
	closetext
	end

CeladonDeptStore2FClerk2Script:
	faceplayer
	opentext
	pokemart MARTTYPE_STANDARD, MART_CELADON_2F_2
	closetext
	end

CeladonDeptStore2FMiddleAgedManScript:
	jumptextfaceplayer CeladonDeptStore2FMiddleAgedManText

CeladonDeptStore2FGirlScript:
	jumptextfaceplayer CeladonDeptStore2FGirlText

CeladonDeptStore2FFloorSign:
	jumptext CeladonDeptStore2FFloorSignText

CeladonDeptStore2FElevatorButton:
	jumpstd ElevatorButtonScript

CeladonDeptStore2FMiddleAgedManText:
	text "SUPER REPEL keeps"
	line "weak #MON at"
	cont "bay…"

	para "Hmm, it's a more"
	line "powerful REPEL!"
	done

CeladonDeptStore2FGirlText:
	text "For long outings,"
	line "you should buy"
	cont "REVIVE."
	done

CeladonDeptStore2FFloorSignText:
	text "Top Grade Items"
	line "for Trainers!"

	para "2F: TRAINER'S"
	line "    MARKET"
	done

CeladonDeptStore2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 12,  0, CELADON_DEPT_STORE_3F, 1
	warp_event 15,  0, CELADON_DEPT_STORE_1F, 5
	warp_event  2,  0, CELADON_DEPT_STORE_ELEVATOR, 1

	def_coord_events

	def_bg_events
	bg_event 14,  0, BGEVENT_READ, CeladonDeptStore2FFloorSign
	bg_event  3,  0, BGEVENT_READ, CeladonDeptStore2FElevatorButton

	def_object_events
	object_event 13,  5, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore2FClerk1Script, -1
	object_event 14,  5, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore2FClerk2Script, -1
	object_event  5,  2, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore2FMiddleAgedManScript, -1
	object_event  9,  3, SPRITE_LASS, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore2FGirlScript, -1
