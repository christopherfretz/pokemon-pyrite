; Kanto hack: Yellow's SS_ANNE_CAPTAINS_ROOM (docs/M4-VERMILION.md, 7h).
;   Yellow ( 4, 2) SPRITE_CAPTAIN, STAY UP -> SPRITE_CAPTAIN 1:1
;   Yellow bg_event ( 4, 1) TEXT_SSANNECAPTAINSROOM_TRASH
;   Yellow bg_event ( 1, 2) TEXT_SSANNECAPTAINSROOM_SEASICK_BOOK
; The CAPTAIN's scene -- the back rub, HM01 CUT, BIT_NO_NPC_FACE_PLAYER until
; EVENT_GOT_HM01, the "not sick anymore" line -- is 7i's (3.4).  7h only puts him
; on the map at Yellow's tile and facing, with a script that does nothing; 7i
; replaces SSAnneCaptainsRoomCaptainScript's body.
	object_const_def
	const SSANNECAPTAINSROOM_CAPTAIN

SSAnneCaptainsRoom_MapScripts:
	def_scene_scripts

	def_callbacks

SSAnneCaptainsRoomCaptainScript:
	end ; 7i

SSAnneCaptainsRoomTrash:
	jumptext SSAnneCaptainsRoomTrashText

SSAnneCaptainsRoomSeasickBook:
	jumptext SSAnneCaptainsRoomSeasickBookText

SSAnneCaptainsRoomTrashText:
	text "Yuck! Shouldn't"
	line "have looked!"
	done

SSAnneCaptainsRoomSeasickBookText:
	text "How to Conquer"
	line "Seasickness…"
	cont "The CAPTAIN's"
	cont "reading this!"
	done

SSAnneCaptainsRoom_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  0,  7, SS_ANNE_2F, 9

	def_coord_events

	def_bg_events
	bg_event  4,  1, BGEVENT_READ, SSAnneCaptainsRoomTrash
	bg_event  1,  2, BGEVENT_READ, SSAnneCaptainsRoomSeasickBook

	def_object_events
	object_event  4,  2, SPRITE_CAPTAIN, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnneCaptainsRoomCaptainScript, -1
