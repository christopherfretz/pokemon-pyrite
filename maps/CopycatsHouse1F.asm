; Kanto hack (M8 11d): Yellow's COPYCAT's house, ground floor
; (vendor/pokeyellow/{data/maps/objects,text}/CopycatsHouse1F.asm).  Crystal's
; LOST_ITEM branch on the mother goes with the rest of that quest (D75), and the
; BLISSEY becomes Yellow's CHANSEY.  Sprite substitutions are the standing ones:
; MIDDLE_AGED_MAN -> SPRITE_POKEFAN_M (docs/M2-MTMOON.md:1465),
; MIDDLE_AGED_WOMAN -> SPRITE_POKEFAN_F (docs/M5-LAVENDER.md:1941).  The stairs
; move to Yellow's top-right corner; the warp tile is (7,0) rather than Yellow's
; (7,1) because the players_house art carries STAIRCASE collision on a block's
; top row only.
	object_const_def
	const COPYCATSHOUSE1F_MIDDLE_AGED_WOMAN
	const COPYCATSHOUSE1F_MIDDLE_AGED_MAN
	const COPYCATSHOUSE1F_CHANSEY

CopycatsHouse1F_MapScripts:
	def_scene_scripts

	def_callbacks

CopycatsHouse1FMiddleAgedWomanScript:
	jumptextfaceplayer CopycatsHouse1FMiddleAgedWomanText

CopycatsHouse1FMiddleAgedManScript:
	jumptextfaceplayer CopycatsHouse1FMiddleAgedManText

CopycatsHouse1FChanseyScript:
	opentext
	writetext CopycatsHouse1FChanseyText
	cry CHANSEY
	waitbutton
	closetext
	end

CopycatsHouse1FMiddleAgedWomanText:
	text "My daughter is so"
	line "self-centered."
	cont "She only has a"
	cont "few friends."
	done

CopycatsHouse1FMiddleAgedManText:
	text "My daughter likes"
	line "to mimic people."

	para "Her mimicry has"
	line "earned her the"
	cont "nickname COPYCAT"
	cont "around here!"
	done

CopycatsHouse1FChanseyText:
	text "CHANSEY: Chaaan"
	line "sey!"
	done

CopycatsHouse1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, SAFFRON_CITY, 1
	warp_event  3,  7, SAFFRON_CITY, 1
	warp_event  7,  0, COPYCATS_HOUSE_2F, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  2,  2, SPRITE_POKEFAN_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CopycatsHouse1FMiddleAgedWomanScript, -1
	object_event  5,  4, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CopycatsHouse1FMiddleAgedManScript, -1
	object_event  1,  4, SPRITE_CHANSEY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CopycatsHouse1FChanseyScript, -1
