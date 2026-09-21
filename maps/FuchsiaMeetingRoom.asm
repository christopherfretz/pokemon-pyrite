; Kanto hack: Yellow's SAFARI ZONE office (docs/M7-FUCHSIA.md 10g).  10a
; repurposed Crystal's SAFARI_ZONE_MAIN_OFFICE shell into FUCHSIA_MEETING_ROOM;
; 10g gives it Yellow's 7x4 footprint on the LAB tileset and Yellow's three
; SAFARI ZONE workers with their lines verbatim
; (vendor/pokeyellow/{data/maps/objects,text}/FuchsiaMeetingRoom.asm).  The
; SAFARI ZONE is open in this hack, so nothing here says otherwise (D65).
; Yellow's LAB block ids do not map onto Crystal's LAB blockset one for one, so
; the room is re-cut from Crystal's LAB vocabulary; every one of Yellow's three
; worker tiles is floor in it and the door sits at Yellow's (4,7)/(5,7).
	object_const_def
	const FUCHSIAMEETINGROOM_WORKER1
	const FUCHSIAMEETINGROOM_WORKER2
	const FUCHSIAMEETINGROOM_WORKER3

FuchsiaMeetingRoom_MapScripts:
	def_scene_scripts

	def_callbacks

FuchsiaMeetingRoomWorker1Script:
	jumptextfaceplayer FuchsiaMeetingRoomWorker1Text

FuchsiaMeetingRoomWorker2Script:
	jumptextfaceplayer FuchsiaMeetingRoomWorker2Text

FuchsiaMeetingRoomWorker3Script:
	jumptextfaceplayer FuchsiaMeetingRoomWorker3Text

FuchsiaMeetingRoomWorker1Text:
	text "We nicknamed the"
	line "WARDEN SLOWPOKE."

	para "He and SLOWPOKE"
	line "both look vacant!"
	done

FuchsiaMeetingRoomWorker2Text:
	text "SLOWPOKE is very"
	line "knowledgeable"
	cont "about #MON!"

	para "He even has some"
	line "fossils of rare,"
	cont "extinct #MON!"
	done

FuchsiaMeetingRoomWorker3Text:
	text "SLOWPOKE came in,"
	line "but I couldn't"
	cont "understand him."

	para "I think he's got"
	line "a speech problem!"
	done

FuchsiaMeetingRoom_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4,  7, FUCHSIA_CITY, 7
	warp_event  5,  7, FUCHSIA_CITY, 7

	def_coord_events

	def_bg_events

	def_object_events
	object_event  4,  1, SPRITE_SAFARI_ZONE_WORKER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, FuchsiaMeetingRoomWorker1Script, -1
	object_event  0,  2, SPRITE_SAFARI_ZONE_WORKER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, FuchsiaMeetingRoomWorker2Script, -1
	object_event 10,  1, SPRITE_SAFARI_ZONE_WORKER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, FuchsiaMeetingRoomWorker3Script, -1
