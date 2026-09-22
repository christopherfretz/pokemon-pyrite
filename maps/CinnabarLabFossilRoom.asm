; Kanto hack (M9 12i): Yellow's CINNABAR LAB Testing Room
; (vendor/pokeyellow/{data/maps/objects,scripts,text}/CinnabarLabFossilRoom.asm),
; cut wholesale onto Yellow's own 4x4 .blk and the new TILESET_KANTO_LAB (D95).
; The hall's east door (its warp 5) leads here; warps 1 and 2 are the exit mat
; on the bottom row -- see hack/maps/CinnabarLab.asm for the collision override.
; The big grey machine along the north wall (block $0f) is the Resurrection
; Machine.
;
; 12j: THE FOSSIL REVIVAL IS NOT IMPLEMENTED HERE.  Scientist1 prints Yellow's
; opening line and then its no-fossil answer, which is exactly what Yellow does
; for a player carrying no fossil.  12j replaces .NoFossils below with Yellow's
; real branch (vendor/pokeyellow/scripts/CinnabarLabFossilRoom.asm):
;   * Lab4Script_GetFossilsInBag scans DOME_FOSSIL / HELIX_FOSSIL / OLD_AMBER;
;   * GiveFossilToCinnabarLab takes one, sets EVENT_GAVE_FOSSIL_TO_LAB and
;     EVENT_LAB_STILL_REVIVING_FOSSIL, prints SeesFossil/TakesFossil/
;     GoForAWalk and sends the player away;
;   * on return, EVENT_LAB_STILL_REVIVING_FOSSIL (12g appended it; CINNABAR
;     ISLAND's MAPCALLBACK_NEWMAP clears it on every arrival, as Yellow does)
;     decides between GoForAWalk and FossilIsBackToLife + GivePokemon at L30.
; Everything 12j needs already exists except EVENT_GAVE_FOSSIL_TO_LAB,
; EVENT_LAB_HANDING_OVER_FOSSIL_MON and the wFossilMon/wFossilItem plumbing.
;
; Scientist2 (7,6) is Yellow's third in-game trade, TRADE_FOR_STICKY
; (KANGASKHAN for MUK) -- note it is in THIS room, not the Meeting Room.
	object_const_def
	const CINNABARLABFOSSILROOM_SCIENTIST1
	const CINNABARLABFOSSILROOM_SCIENTIST2

CinnabarLabFossilRoom_MapScripts:
	def_scene_scripts

	def_callbacks

CinnabarLabFossilRoomScientist1Script:
	faceplayer
	opentext
	writetext CinnabarLabFossilRoomScientist1Text
	promptbutton
; 12j: the fossil-revival branch hangs here.  Until then every answer is
; Yellow's no-fossil one.
	writetext CinnabarLabFossilRoomScientist1NoFossilsText
	waitbutton
	closetext
	end

CinnabarLabFossilRoomScientist2Script:
	faceplayer
	opentext
	trade NPC_TRADE_STICKY
	waitbutton
	closetext
	end

CinnabarLabFossilRoomScientist1Text:
	text "Hiya!"

	para "I am important"
	line "doctor!"

	para "I study here rare"
	line "#MON fossils!"

	para "You! Have you a"
	line "fossil for me?"
	done

CinnabarLabFossilRoomScientist1NoFossilsText:
	text "No! Is too bad!"
	done

CinnabarLabFossilRoom_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, CINNABAR_LAB, 5
	warp_event  3,  7, CINNABAR_LAB, 5

	def_coord_events

	def_bg_events

	def_object_events
	object_event  5,  2, SPRITE_SCIENTIST, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CinnabarLabFossilRoomScientist1Script, -1
	object_event  7,  6, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CinnabarLabFossilRoomScientist2Script, -1
