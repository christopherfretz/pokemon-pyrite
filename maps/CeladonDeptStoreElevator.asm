CeladonDeptStoreElevator_MapScripts:
	def_scene_scripts

	def_callbacks

CeladonDeptStoreElevatorScript:
	opentext
	elevator CeladonDeptStoreElevatorData
	closetext
	iffalse .Done
	pause 5
	playsound SFX_ELEVATOR
	earthquake 60
	waitsfx
.Done:
	end

CeladonDeptStoreElevatorData:
; Kanto hack (M6 9r, docs/M6-CELADON.md §3.5): Yellow's CELADON MART elevator
; serves 1F-5F only -- the ROOFTOP SQUARE is reached by the 5F staircase, so
; FLOOR_6F is not on the panel.  1F's elevator warp is #6 now, because Yellow's
; 1F has two doors onto the city and therefore four door warps before the stairs.
	db 5 ; floors
	elevfloor FLOOR_1F, 6, CELADON_DEPT_STORE_1F
	elevfloor FLOOR_2F, 3, CELADON_DEPT_STORE_2F
	elevfloor FLOOR_3F, 3, CELADON_DEPT_STORE_3F
	elevfloor FLOOR_4F, 3, CELADON_DEPT_STORE_4F
	elevfloor FLOOR_5F, 3, CELADON_DEPT_STORE_5F
	db -1 ; end

CeladonDeptStoreElevator_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  1,  3, CELADON_DEPT_STORE_1F, -1
	warp_event  2,  3, CELADON_DEPT_STORE_1F, -1

	def_coord_events

	def_bg_events
	bg_event  3,  0, BGEVENT_READ, CeladonDeptStoreElevatorScript

	def_object_events
