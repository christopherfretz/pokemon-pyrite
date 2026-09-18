; Kanto hack: Yellow's VERMILION_PIDGEY_HOUSE
; (vendor/pokeyellow/data/maps/objects/VermilionPidgeyHouse.asm,
; scripts/VermilionPidgeyHouse.asm, text/VermilionPidgeyHouse.asm).  This map is
; Crystal's VERMILION_FISHING_SPEECH_HOUSE slot, renamed in 7e; Crystal's
; FISHING DUDE (a JOHTO / LAKE OF RAGE speech) and his photo are gone.
;
; All three of Yellow's objects sit on Crystal's House1 layout unmoved: the
; YOUNGSTER at (5,3) faces LEFT towards the LETTER at (4,3), which is the right
; half of the table, and the PIDGEY paces left/right from (3,5).
	object_const_def
	const VERMILIONPIDGEYHOUSE_YOUNGSTER
	const VERMILIONPIDGEYHOUSE_PIDGEY
	const VERMILIONPIDGEYHOUSE_LETTER

VermilionPidgeyHouse_MapScripts:
	def_scene_scripts

	def_callbacks

VermilionPidgeyHouseYoungsterScript:
	jumptextfaceplayer VermilionPidgeyHouseYoungsterText

; Yellow: VermilionPidgeyHousePidgeyText -- the line then the cry.
VermilionPidgeyHousePidgeyScript:
	opentext
	writetext VermilionPidgeyHousePidgeyText
	cry PIDGEY
	waitbutton
	closetext
	end

VermilionPidgeyHouseLetterScript:
	jumptext VermilionPidgeyHouseLetterText

VermilionPidgeyHouseYoungsterText:
	text "I'm getting my"
	line "PIDGEY to fly a"
	cont "letter to SAFFRON"
	cont "in the north!"
	done

VermilionPidgeyHousePidgeyText:
	text "PIDGEY: Kurukkoo!"
	done

VermilionPidgeyHouseLetterText:
	text "Dear PIPPI, I hope"
	line "to see you soon."

	para "I heard SAFFRON"
	line "has problems with"
	cont "TEAM ROCKET."

	para "VERMILION appears"
	line "to be safe."
	done

VermilionPidgeyHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, VERMILION_CITY, 5
	warp_event  3,  7, VERMILION_CITY, 5

	def_coord_events

	def_bg_events

	def_object_events
	object_event  5,  3, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, VermilionPidgeyHouseYoungsterScript, -1
	object_event  3,  5, SPRITE_BIRD, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, VermilionPidgeyHousePidgeyScript, -1
	object_event  4,  3, SPRITE_PAPER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VermilionPidgeyHouseLetterScript, -1
