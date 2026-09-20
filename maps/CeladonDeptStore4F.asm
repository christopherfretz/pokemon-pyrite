; Kanto hack (M6 9r, docs/M6-CELADON.md §3.5): Yellow's CELADON MART 4F,
; WISEMAN GIFTS -- the # DOLL and the four evolution stones.

	object_const_def
	const CELADONDEPTSTORE4F_CLERK
	const CELADONDEPTSTORE4F_SUPER_NERD
	const CELADONDEPTSTORE4F_YOUNGSTER

CeladonDeptStore4F_MapScripts:
	def_scene_scripts

	def_callbacks

CeladonDeptStore4FClerkScript:
	faceplayer
	opentext
	pokemart MARTTYPE_STANDARD, MART_CELADON_4F
	closetext
	end

CeladonDeptStore4FSuperNerdScript:
	jumptextfaceplayer CeladonDeptStore4FSuperNerdText

CeladonDeptStore4FYoungsterScript:
	jumptextfaceplayer CeladonDeptStore4FYoungsterText

CeladonDeptStore4FFloorSign:
	jumptext CeladonDeptStore4FFloorSignText

CeladonDeptStore4FElevatorButton:
	jumpstd ElevatorButtonScript

CeladonDeptStore4FSuperNerdText:
	text "I'm getting a"
	line "gift for COPYCAT"
	cont "in CERULEAN CITY."

	para "It's got to be a"
	line "# DOLL. They"
	cont "are trendy!"
	done

CeladonDeptStore4FYoungsterText:
	text "I heard something"
	line "useful."

	para "You can run from"
	line "wild #MON by"
	cont "distracting them"
	cont "with a # DOLL!"
	done

CeladonDeptStore4FFloorSignText:
	text "Express yourself"
	line "with gifts!"

	para "4F: WISEMAN GIFTS"

	para "Evolution Special!"
	line "Element STONEs on"
	cont "sale now!"
	done

CeladonDeptStore4F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 12,  0, CELADON_DEPT_STORE_5F, 1
	warp_event 15,  0, CELADON_DEPT_STORE_3F, 2
	warp_event  2,  0, CELADON_DEPT_STORE_ELEVATOR, 1

	def_coord_events

	def_bg_events
	bg_event 14,  0, BGEVENT_READ, CeladonDeptStore4FFloorSign
	bg_event  3,  0, BGEVENT_READ, CeladonDeptStore4FElevatorButton

	def_object_events
	object_event 13,  5, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore4FClerkScript, -1
	object_event  7,  6, SPRITE_SUPER_NERD, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore4FSuperNerdScript, -1
	object_event  5,  2, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore4FYoungsterScript, -1
