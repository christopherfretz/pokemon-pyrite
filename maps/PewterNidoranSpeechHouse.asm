; Kanto hack: Yellow's PEWTER NIDORAN HOUSE (docs/M2-PEWTER.md).  All three
; NPCs and their text are Yellow's (vendor/pokeyellow/text/PewterNidoranHouse.asm,
; objects/PewterNidoranHouse.asm).  The middle-aged man is Yellow's ONLY in-game
; explanation of traded-#MON obedience, so he is not optional flavour.
; Sprite substitutions (Crystal's sprite set has neither): Yellow's LITTLE_BOY
; -> SPRITE_YOUNGSTER, MIDDLE_AGED_MAN -> SPRITE_POKEFAN_M (the same stand-in
; docs/M2-PEWTER.md:477 already uses for Yellow's HIKER).
	object_const_def
	const PEWTERNIDORANSPEECHHOUSE_LITTLE_BOY
	const PEWTERNIDORANSPEECHHOUSE_NIDORAN_M
	const PEWTERNIDORANSPEECHHOUSE_MIDDLE_AGED_MAN

PewterNidoranSpeechHouse_MapScripts:
	def_scene_scripts

	def_callbacks

PewterNidoranSpeechHouseLittleBoyScript:
	jumptextfaceplayer PewterNidoranSpeechHouseLittleBoyText

PewterNidoran:
	opentext
	writetext PewterNidoranText
	cry NIDORAN_M
	waitbutton
	closetext
	end

PewterNidoranSpeechHouseMiddleAgedManScript:
	jumptextfaceplayer PewterNidoranSpeechHouseMiddleAgedManText

PewterNidoranSpeechHouseLittleBoyText:
	text "NIDORAN sit!"
	done

PewterNidoranText:
	text "NIDORAN: Bowbow!"
	done

PewterNidoranSpeechHouseMiddleAgedManText:
	text "Our #MON's an"
	line "outsider, so it's"
	cont "hard to handle."

	para "An outsider is a"
	line "#MON that you"
	cont "get in a trade."

	para "It grows fast, but"
	line "it may ignore an"
	cont "unskilled trainer"
	cont "in battle!"

	para "If only we had"
	line "some BADGEs…"
	done

PewterNidoranSpeechHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, PEWTER_CITY, 1
	warp_event  3,  7, PEWTER_CITY, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  3,  5, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, PewterNidoranSpeechHouseLittleBoyScript, -1
	object_event  4,  5, SPRITE_GROWLITHE, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, PewterNidoran, -1
	object_event  1,  2, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, PewterNidoranSpeechHouseMiddleAgedManScript, -1
