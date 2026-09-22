; Kanto hack (M9 12i): Yellow's CINNABAR LAB hall
; (vendor/pokeyellow/{data/maps/objects,scripts,text}/CinnabarLab.asm), cut
; wholesale.  12a registered the map and 12g gave it an interim return warp on
; a patched kanto_interior block; both are gone now -- the .blk is Yellow's own
; 9x4 layout byte for byte (scripts/kanto_lab_blk.py) on the new
; TILESET_KANTO_LAB (D95), so every one of Yellow's coordinates lands on the
; tile Yellow meant it to.
;
; Warps.  Yellow fires a warp on a COORDINATE match and painted no door art on
; the hall's own south exit, so its (2,7)/(3,7) tiles are plain floor; Crystal
; only ever warps from a $7x tile ATTRIBUTE (engine/overworld/tile_events.asm,
; CheckWarpCollision).  scripts/kanto_lab_blk.py resolves that in the collision
; table rather than in the art: block $0c's bottom half -- the light-grey exit
; mat, which occurs exactly once in each of the four LAB maps and always as the
; south exit -- becomes WARP_CARPET_DOWN, and block $18's top-left quadrant,
; Yellow's door tile $34, becomes COLL_DOOR.  That is the same "deviation 2"
; 12g recorded, now applied to the real layout.
;
; CINNABAR ISLAND's LAB door is its warp 3, and it points at this map's warp 1,
; so warp 1 must stay the island exit (12g).
;
; DR. FUJI's photo at (3,2) is read facing UP from (3,3); the three room signs
; sit one tile east of each door, exactly as Yellow places them.
	object_const_def
	const CINNABARLAB_FISHING_GURU

CinnabarLab_MapScripts:
	def_scene_scripts

	def_callbacks

CinnabarLabFishingGuruScript:
	jumptextfaceplayer CinnabarLabFishingGuruText

CinnabarLabPhoto:
	jumptext CinnabarLabPhotoText

CinnabarLabMeetingRoomSign:
	jumptext CinnabarLabMeetingRoomSignText

CinnabarLabRAndDSign:
	jumptext CinnabarLabRAndDSignText

CinnabarLabTestingRoomSign:
	jumptext CinnabarLabTestingRoomSignText

CinnabarLabFishingGuruText:
	text "We study #MON"
	line "extensively here."

	para "People often bring"
	line "us rare #MON"
	cont "for examination."
	done

CinnabarLabPhotoText:
	text "A photo of the"
	line "LAB's founder,"
	cont "DR.FUJI!"
	done

CinnabarLabMeetingRoomSignText:
	text "#MON LAB"
	line "Meeting Room"
	done

CinnabarLabRAndDSignText:
	text "#MON LAB"
	line "R-and-D Room"
	done

CinnabarLabTestingRoomSignText:
	text "#MON LAB"
	line "Testing Room"
	done

CinnabarLab_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, CINNABAR_ISLAND, 3
	warp_event  3,  7, CINNABAR_ISLAND, 3
	warp_event  8,  4, CINNABAR_LAB_TRADE_ROOM, 1
	warp_event 12,  4, CINNABAR_LAB_METRONOME_ROOM, 1
	warp_event 16,  4, CINNABAR_LAB_FOSSIL_ROOM, 1

	def_coord_events

	def_bg_events
	bg_event  3,  2, BGEVENT_READ, CinnabarLabPhoto
	bg_event  9,  4, BGEVENT_READ, CinnabarLabMeetingRoomSign
	bg_event 13,  4, BGEVENT_READ, CinnabarLabRAndDSign
	bg_event 17,  4, BGEVENT_READ, CinnabarLabTestingRoomSign

	def_object_events
	object_event  1,  3, SPRITE_FISHING_GURU, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CinnabarLabFishingGuruScript, -1
