; Kanto hack (M6 9r, docs/M6-CELADON.md §3.5): Yellow's CELADON MART 1F.
; 1F is the SERVICE COUNTER -- an information desk, no mart -- and it is the only
; floor with its own .blk (maps/CeladonDeptStore1F.blk), because Yellow's 1F has
; TWO doors onto the city (west and east) where Goldenrod's has one.
; Warp order is Yellow's: west pair, east pair, up-stairs, elevator.

	object_const_def
	const CELADONDEPTSTORE1F_RECEPTIONIST

CeladonDeptStore1F_MapScripts:
	def_scene_scripts

	def_callbacks

CeladonDeptStore1FReceptionistScript:
	jumptextfaceplayer CeladonDeptStore1FReceptionistText

CeladonDeptStore1FDirectory:
	jumptext CeladonDeptStore1FDirectoryText

CeladonDeptStore1FFloorSign:
	jumptext CeladonDeptStore1FFloorSignText

CeladonDeptStore1FElevatorButton:
	jumpstd ElevatorButtonScript

CeladonDeptStore1FReceptionistText:
	text "Hello! Welcome to"
	line "CELADON DEPT."
	cont "STORE."

	para "The board on the"
	line "right describes"
	cont "the store layout."
	done

CeladonDeptStore1FDirectoryText:
	text "1F: SERVICE"
	line "    COUNTER"

	para "2F: TRAINER'S"
	line "    MARKET"

	para "3F: TV GAME SHOP"

	para "4F: WISEMAN GIFTS"

	para "5F: DRUG STORE"

	para "ROOFTOP SQUARE:"
	line "VENDING MACHINES"
	done

CeladonDeptStore1FFloorSignText:
	text "1F: SERVICE"
	line "    COUNTER"
	done

CeladonDeptStore1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, CELADON_CITY, 1
	warp_event  4,  7, CELADON_CITY, 1
	warp_event 11,  7, CELADON_CITY, 2
	warp_event 12,  7, CELADON_CITY, 2
	warp_event 15,  0, CELADON_DEPT_STORE_2F, 2
	warp_event  2,  0, CELADON_DEPT_STORE_ELEVATOR, 1

	def_coord_events

	def_bg_events
	bg_event 13,  0, BGEVENT_READ, CeladonDeptStore1FDirectory
	bg_event 14,  0, BGEVENT_READ, CeladonDeptStore1FFloorSign
	bg_event  3,  0, BGEVENT_READ, CeladonDeptStore1FElevatorButton

	def_object_events
	object_event 10,  1, SPRITE_RECEPTIONIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonDeptStore1FReceptionistScript, -1
