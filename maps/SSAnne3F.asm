; Kanto hack: Yellow's SS_ANNE_3F (docs/M4-VERMILION.md, 7h).  2.8 calls this map
; objectless; it is not -- Yellow's SSAnne3F_Object carries one SAILOR (see
; "## 7h findings", correction 1).
;   Yellow ( 9, 3) SPRITE_SAILOR, WALK LEFT_RIGHT -> SPRITE_SAILOR 1:1
	object_const_def
	const SSANNE3F_SAILOR

SSAnne3F_MapScripts:
	def_scene_scripts

	def_callbacks

SSAnne3FSailorScript:
	jumptextfaceplayer SSAnne3FSailorText

SSAnne3FSailorText:
	text "Our CAPTAIN is a"
	line "sword master!"

	para "He even teaches"
	line "CUT to #MON!"
	done

SSAnne3F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  0,  3, SS_ANNE_BOW, 1
	warp_event 19,  3, SS_ANNE_2F, 8

	def_coord_events

	def_bg_events

	def_object_events
	object_event  9,  3, SPRITE_SAILOR, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnne3FSailorScript, -1
