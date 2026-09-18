	object_const_def
	const VIRIDIANNICKNAMESPEECHHOUSE_POKEFAN_M
	const VIRIDIANNICKNAMESPEECHHOUSE_LASS
	const VIRIDIANNICKNAMESPEECHHOUSE_SPEARY

ViridianNicknameSpeechHouse_MapScripts:
	def_scene_scripts

	def_callbacks

ViridianNicknameSpeechHousePokefanMScript:
	jumptextfaceplayer ViridianNicknameSpeechHousePokefanMText

ViridianNicknameSpeechHouseLassScript:
	jumptextfaceplayer ViridianNicknameSpeechHouseLassText

Speary:
	opentext
	writetext SpearyText
	cry SPEAROW
	waitbutton
	closetext
	end

ViridianNicknameSpeechHouseSpearySign:
	jumptext ViridianNicknameSpeechHouseSpearySignText

; Kanto hack (N1c): Yellow's _ViridianNicknameHouseBaldingGuyText, verbatim.
ViridianNicknameSpeechHousePokefanMText:
	text "Coming up with"
	line "nicknames is fun,"
	cont "but hard."

	para "Simple names are"
	line "the easiest to"
	cont "remember."
	done

; Kanto hack (N1c): Yellow's _ViridianNicknameHouseLittleGirlText, verbatim.
ViridianNicknameSpeechHouseLassText:
	text "My Daddy loves"
	line "#MON too."
	done

SpearyText:
	text "SPEARY: Tetweet!"
	done

; Kanto hack (N1c): Yellow's SPRITE_CLIPBOARD nameplate
; (_ViridianNicknameHouseSpearySignText) as a bg_event.
ViridianNicknameSpeechHouseSpearySignText:
	text "SPEAROW"
	line "Name: SPEARY"
	done

ViridianNicknameSpeechHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, VIRIDIAN_CITY, 2
	warp_event  3,  7, VIRIDIAN_CITY, 2

	def_coord_events

	def_bg_events
	bg_event  4,  0, BGEVENT_READ, ViridianNicknameSpeechHouseSpearySign

	def_object_events
	object_event  5,  3, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ViridianNicknameSpeechHousePokefanMScript, -1
	object_event  1,  4, SPRITE_LASS, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, ViridianNicknameSpeechHouseLassScript, -1
	object_event  5,  5, SPRITE_BIRD, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, Speary, -1
