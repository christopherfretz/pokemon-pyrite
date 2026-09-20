; Kanto hack (M6 9r, docs/M6-CELADON.md §3.5): Yellow's CELADON MART 5F, the
; DRUG STORE.  Note Yellow's clerk order -- Clerk1 (the left one) sells the
; X-items and Clerk2 the vitamins, the opposite way round from Goldenrod's 5F.

	object_const_def
	const CELADONDEPTSTORE5F_CLERK1
	const CELADONDEPTSTORE5F_CLERK2
	const CELADONDEPTSTORE5F_GENTLEMAN
	const CELADONDEPTSTORE5F_SAILOR

CeladonDeptStore5F_MapScripts:
	def_scene_scripts

	def_callbacks

CeladonDeptStore5FClerk1Script:
	faceplayer
	opentext
	pokemart MARTTYPE_STANDARD, MART_CELADON_5F_1
	closetext
	end

CeladonDeptStore5FClerk2Script:
	faceplayer
	opentext
	pokemart MARTTYPE_STANDARD, MART_CELADON_5F_2
	closetext
	end

CeladonDeptStore5FGentlemanScript:
	jumptextfaceplayer CeladonDeptStore5FGentlemanText

CeladonDeptStore5FSailorScript:
	jumptextfaceplayer CeladonDeptStore5FSailorText

CeladonDeptStore5FFloorSign:
	jumptext CeladonDeptStore5FFloorSignText

CeladonDeptStore5FElevatorButton:
	jumpstd ElevatorButtonScript

CeladonDeptStore5FGentlemanText:
	text "#MON ability"
	line "enhancers can be"
	cont "bought only here."

	para "Use CALCIUM to"
	line "increase SPECIAL"
	cont "abilities."

	para "Use CARBOS to"
	line "increase SPEED."
	done

CeladonDeptStore5FSailorText:
	text "I'm here for"
	line "#MON ability"
	cont "enhancers."

	para "PROTEIN increases"
	line "ATTACK power."

	para "IRON increases"
	line "DEFENSE!"
	done

CeladonDeptStore5FFloorSignText:
	text "5F: DRUG STORE"
	done

CeladonDeptStore5F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 12,  0, CELADON_DEPT_STORE_4F, 1
	warp_event 15,  0, CELADON_DEPT_STORE_6F, 1
	warp_event  2,  0, CELADON_DEPT_STORE_ELEVATOR, 1

	def_coord_events

	def_bg_events
	bg_event 14,  0, BGEVENT_READ, CeladonDeptStore5FFloorSign
	bg_event  3,  0, BGEVENT_READ, CeladonDeptStore5FElevatorButton

	def_object_events
	object_event  7,  5, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore5FClerk1Script, -1
	object_event  8,  5, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore5FClerk2Script, -1
	object_event 14,  5, SPRITE_GENTLEMAN, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore5FGentlemanScript, -1
	object_event  2,  6, SPRITE_SAILOR, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore5FSailorScript, -1
