; Kanto hack (M8 11a/11d, docs/M8-SAFFRON.md D74): Yellow has no MAGNET TRAIN,
; and the house Crystal bulldozed for the station is the PIDGEY house -- the one
; whose TEACHER in the old station script says "before the MAGNET TRAIN STATION
; was built, there was a house there".  The map const, the map file and the
; SAFFRON CITY warp were repurposed in place by 11a; 11d fills in Yellow's cast
; and text (vendor/pokeyellow/{data/maps/objects,scripts,text}/
; SaffronPidgeyHouse.asm).  The Magnet Train itself is still parked for the
; Johto act (the engine, the PASS and GOLDENROD's station all still compile).
; BRUNETTE_GIRL is SPRITE_LASS by the standing substitution
; (docs/M5-LAVENDER.md:1941); the letter she is writing is Yellow's SPRITE_PAPER
; on the table at (3,3), which she faces.
	object_const_def
	const SAFFRONPIDGEYHOUSE_BRUNETTE_GIRL
	const SAFFRONPIDGEYHOUSE_PIDGEY
	const SAFFRONPIDGEYHOUSE_YOUNGSTER
	const SAFFRONPIDGEYHOUSE_PAPER

SaffronPidgeyHouse_MapScripts:
	def_scene_scripts

	def_callbacks

SaffronPidgeyHouseBrunetteGirlScript:
	jumptextfaceplayer SaffronPidgeyHouseBrunetteGirlText

SaffronPidgeyHousePidgeyScript:
	opentext
	writetext SaffronPidgeyHousePidgeyText
	cry PIDGEY
	waitbutton
	closetext
	end

SaffronPidgeyHouseYoungsterScript:
	jumptextfaceplayer SaffronPidgeyHouseYoungsterText

SaffronPidgeyHousePaperScript:
	jumptext SaffronPidgeyHousePaperText

SaffronPidgeyHouseBrunetteGirlText:
	text "Thank you for"
	line "writing. I hope"
	cont "to see you soon!"

	para "Hey! Don't look"
	line "at my letter!"
	done

SaffronPidgeyHousePidgeyText:
	text "PIDGEY: Kurukkoo!"
	done

SaffronPidgeyHouseYoungsterText:
	text "The COPYCAT is"
	line "cute! I'm getting"
	cont "her a # DOLL!"
	done

SaffronPidgeyHousePaperText:
	text "I was given a PP"
	line "UP as a gift."

	para "It's used for"
	line "increasing the PP"
	cont "of techniques!"
	done

SaffronPidgeyHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, SAFFRON_CITY, 4
	warp_event  3,  7, SAFFRON_CITY, 4

	def_coord_events

	def_bg_events

	def_object_events
	object_event  2,  3, SPRITE_LASS, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SaffronPidgeyHouseBrunetteGirlScript, -1
	object_event  0,  4, SPRITE_BIRD, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, SaffronPidgeyHousePidgeyScript, -1
	object_event  4,  1, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SaffronPidgeyHouseYoungsterScript, -1
	object_event  3,  3, SPRITE_PAPER, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SaffronPidgeyHousePaperScript, -1
