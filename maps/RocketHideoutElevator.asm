RocketHideoutElevator_MapScripts:
	def_scene_scripts

	def_callbacks

; Kanto hack (M6 9w, docs/M6-CELADON.md 3.4): Yellow's ROCKET HIDEOUT lift.
;
; Yellow's RocketHideoutElevatorText checks LIFT_KEY with IsItemInBag and, if
; it is missing, prints "It appears to need a key." and never opens the floor
; menu at all -- there is no "the lift is locked" shake, no panel, nothing.
; Same here: checkitem gates the whole elevator command.
;
; RocketHideoutElevatorFloors lists B1F, B2F, B4F -- Yellow leaves B3F off the
; panel on purpose, so the only way onto B3F is the B2F staircase.
;
; The warp numbers below are the lift-door warp on each floor.  Yellow's
; RocketHideoutElevatorWarpMaps holds RAW warp ids (`db 4, B1F` / `db 4, B2F` /
; `db 2, B4F`), which are 0-based -- its `warp_event` macro is the thing that
; subtracts 1 -- so Yellow puts you out on the RIGHT-hand door of each pair:
; B1F warp 5 (25,19), B2F warp 5 (25,19), B4F warp 3 (25,15).  elevfloor counts
; from 1, so those are the numbers here.
RocketHideoutElevatorScript:
	opentext
	checkitem LIFT_KEY
	iffalse .NoKey
	elevator RocketHideoutElevatorData
	closetext
	iffalse .Done
	pause 5
	playsound SFX_ELEVATOR
	earthquake 60
	waitsfx
.Done:
	end

.NoKey:
	writetext RocketHideoutElevatorNeedKeyText
	waitbutton
	closetext
	end

RocketHideoutElevatorData:
	db 3 ; floors
	elevfloor FLOOR_B1F, 5, ROCKET_HIDEOUT_B1F
	elevfloor FLOOR_B2F, 5, ROCKET_HIDEOUT_B2F
	elevfloor FLOOR_B4F, 3, ROCKET_HIDEOUT_B4F
	db -1 ; end

RocketHideoutElevatorNeedKeyText:
	text "It appears to"
	line "need a key."
	done

RocketHideoutElevator_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; Both doors are -1: the destination is whatever the panel last chose, or --
; if the player walks straight back out -- the floor they came in from.
	warp_event  1,  3, ROCKET_HIDEOUT_B1F, -1
	warp_event  2,  3, ROCKET_HIDEOUT_B1F, -1

	def_coord_events

	def_bg_events
	bg_event  3,  0, BGEVENT_READ, RocketHideoutElevatorScript

	def_object_events
