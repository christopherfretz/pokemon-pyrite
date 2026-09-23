; Kanto hack (M11 14h, docs/M11-JOHTO.md D146/D147/D148): Crystal's SAFFRON
; MAGNET TRAIN station, back as its own map (SAFFRON group #27) for the Johto
; act.  M8 11a had repurposed the old map slot as SAFFRON_PIDGEY_HOUSE; that
; house stays, and the station's door on SAFFRON CITY only exists once
; ENGINE_POKEGEAR is set (SaffronCity.asm's tiles callback).  Crystal's scripts
; and movements are verbatim; the changes are the return warps (SAFFRON CITY's
; warp 9), the GYM GUIDE keyed on EVENT_RESTORED_POWER_TO_KANTO (Crystal's
; EVENT_RETURNED_MACHINE_PART belongs to the retired Machine Part errand) and
; the TEACHER's and LASS's lines (ours: COPYCAT still lives up the street, and
; the LASS points at her for the PASS).  The TEACHER and LASS appear with the
; power (EVENT_SAFFRON_TRAIN_STATION_POPULATION, cleared by the 4th JOHTO badge).
	object_const_def
	const SAFFRONMAGNETTRAINSTATION_OFFICER
	const SAFFRONMAGNETTRAINSTATION_GYM_GUIDE
	const SAFFRONMAGNETTRAINSTATION_TEACHER
	const SAFFRONMAGNETTRAINSTATION_LASS

SaffronMagnetTrainStation_MapScripts:
	def_scene_scripts
	scene_script SaffronMagnetTrainStationNoopScene, SCENE_SAFFRONMAGNETTRAINSTATION_ARRIVE_FROM_GOLDENROD

	def_callbacks

SaffronMagnetTrainStationNoopScene:
	end

SaffronMagnetTrainStationOfficerScript:
	faceplayer
	opentext
	checkevent EVENT_RESTORED_POWER_TO_KANTO
	iftrue .MagnetTrainToGoldenrod
	writetext SaffronMagnetTrainStationOfficerTrainIsntOperatingText
	waitbutton
	closetext
	end

.MagnetTrainToGoldenrod:
	writetext SaffronMagnetTrainStationOfficerAreYouComingOnBoardText
	yesorno
	iffalse .DecidedNotToRide
	checkitem PASS
	iffalse .PassNotInBag
	writetext SaffronMagnetTrainStationOfficerRightThisWayText
	waitbutton
	closetext
	applymovement SAFFRONMAGNETTRAINSTATION_OFFICER, SaffronMagnetTrainStationOfficerApproachTrainDoorMovement
	applymovement PLAYER, SaffronMagnetTrainStationPlayerApproachAndEnterTrainMovement
	setval TRUE
	special MagnetTrain
	warpcheck
	newloadmap MAPSETUP_TRAIN
	applymovement PLAYER, .MovementBoardTheTrain
	wait 20
	end

.MovementBoardTheTrain:
	turn_head DOWN
	step_end

.PassNotInBag:
	writetext SaffronMagnetTrainStationOfficerYouDontHaveAPassText
	waitbutton
	closetext
	end

.DecidedNotToRide:
	writetext SaffronMagnetTrainStationOfficerHopeToSeeYouAgainText
	waitbutton
	closetext
	end

Script_ArriveFromGoldenrod:
	applymovement SAFFRONMAGNETTRAINSTATION_OFFICER, SaffronMagnetTrainStationOfficerApproachTrainDoorMovement
	applymovement PLAYER, SaffronMagnetTrainStationPlayerLeaveTrainAndEnterStationMovement
	applymovement SAFFRONMAGNETTRAINSTATION_OFFICER, SaffronMagnetTrainStationOfficerReturnToBoardingGateMovement
	opentext
	writetext SaffronMagnetTrainStationOfficerArrivedInSaffronText
	waitbutton
	closetext
	end

SaffronMagnetTrainStationGymGuideScript:
	faceplayer
	opentext
	checkevent EVENT_RESTORED_POWER_TO_KANTO ; Kanto hack (M11 14h): was EVENT_RETURNED_MACHINE_PART
	iftrue .ReturnedMachinePart
	writetext SaffronMagnetTrainStationGymGuideText
	waitbutton
	closetext
	end

.ReturnedMachinePart:
	writetext SaffronMagnetTrainStationGymGuideText_ReturnedMachinePart
	waitbutton
	closetext
	end

SaffronMagnetTrainStationTeacherScript:
	jumptextfaceplayer SaffronMagnetTrainStationTeacherText

SaffronMagnetTrainStationLassScript:
	jumptextfaceplayer SaffronMagnetTrainStationLassText

SaffronMagnetTrainStationOfficerApproachTrainDoorMovement:
	step UP
	step UP
	step RIGHT
	turn_head LEFT
	step_end

SaffronMagnetTrainStationOfficerReturnToBoardingGateMovement:
	step LEFT
	step DOWN
	step DOWN
	step_end

SaffronMagnetTrainStationPlayerApproachAndEnterTrainMovement:
	step UP
	step UP
	step UP
	step LEFT
	step LEFT
	step LEFT
	step UP
	step UP
	step_end

SaffronMagnetTrainStationPlayerLeaveTrainAndEnterStationMovement:
	step LEFT
	step LEFT
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	turn_head UP
	step_end

SaffronMagnetTrainStationOfficerTrainIsntOperatingText:
	text "I'm sorry, but the"
	line "MAGNET TRAIN isn't"
	cont "operating now."
	done

SaffronMagnetTrainStationOfficerAreYouComingOnBoardText:
	text "We'll soon depart"
	line "for GOLDENROD."

	para "Are you coming on"
	line "board?"
	done

SaffronMagnetTrainStationOfficerRightThisWayText:
	text "May I see your"
	line "rail PASS, please?"

	para "OK. Right this"
	line "way, please."
	done

SaffronMagnetTrainStationOfficerYouDontHaveAPassText:
	text "Sorry, but you"
	line "don't have a PASS."
	done

SaffronMagnetTrainStationOfficerHopeToSeeYouAgainText:
	text "We hope to see you"
	line "again."
	done

SaffronMagnetTrainStationOfficerArrivedInSaffronText:
	text "We have arrived in"
	line "SAFFRON."

	para "We hope to see you"
	line "again."
	done

SaffronMagnetTrainStationGymGuideText:
	text "The MAGNET TRAIN"
	line "is a super-modern"

	para "rail liner that"
	line "uses electricity"

	para "and magnets to"
	line "attain incredible"
	cont "speed."

	para "However, if there"
	line "isn't any elec-"
	cont "tricity…"
	done

SaffronMagnetTrainStationGymGuideText_ReturnedMachinePart:
	text "Whew…"

	para "How many times"
	line "have I gone back"

	para "and forth between"
	line "KANTO and JOHTO?"
	done

SaffronMagnetTrainStationTeacherText:
; Kanto hack (M11 14h): our text.  Crystal's "there was a house here, COPYCAT
; used to live there" -- our COPYCAT still lives up the street.
	text "Before the MAGNET"
	line "TRAIN STATION was"

	para "built, there were"
	line "offices here."

	para "SAFFRON never"
	line "stops growing!"
	done

SaffronMagnetTrainStationLassText:
	text "Hi. Do you have a"
	line "rail PASS? I have"

	para "one. All the peo-"
	line "ple in SAFFRON who"

	para "ride the MAGNET"
	line "TRAIN have PASSES."

; Kanto hack (M11 14h, D148): our line -- where the PASS comes from.
	para "COPYCAT up the"
	line "street has a spare"
	cont "one, I heard."
	done

SaffronMagnetTrainStation_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  8, 17, SAFFRON_CITY, 9 ; Kanto hack (M11 14h): SAFFRON CITY's station door (8,11), appended as its 9th warp
	warp_event  9, 17, SAFFRON_CITY, 9
	warp_event  6,  5, GOLDENROD_MAGNET_TRAIN_STATION, 4
	warp_event 11,  5, GOLDENROD_MAGNET_TRAIN_STATION, 3

	def_coord_events
	coord_event 11,  6, SCENE_SAFFRONMAGNETTRAINSTATION_ARRIVE_FROM_GOLDENROD, Script_ArriveFromGoldenrod

	def_bg_events

	def_object_events
	object_event  9,  9, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SaffronMagnetTrainStationOfficerScript, -1
	object_event 10, 14, SPRITE_GYM_GUIDE, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SaffronMagnetTrainStationGymGuideScript, -1
	object_event  6, 11, SPRITE_TEACHER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SaffronMagnetTrainStationTeacherScript, EVENT_SAFFRON_TRAIN_STATION_POPULATION
	object_event  6, 10, SPRITE_LASS, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, SaffronMagnetTrainStationLassScript, EVENT_SAFFRON_TRAIN_STATION_POPULATION
