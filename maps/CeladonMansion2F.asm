; Kanto hack (docs/M6-CELADON.md, 9s): Yellow's CELADON MANSION 2F -- the GAME
; FREAK meeting room.  Yellow has no objects here at all, one sign and one
; hidden event: `hidden_event 0, 5, OpenPokemonCenterPC, SPRITE_FACING_UP`
; (vendor/pokeyellow/data/events/hidden_events.asm) -- a full #MON Center PC on
; the west wall.  Yellow's hidden events are matched against the tile IN FRONT
; of the player (engine/overworld/hidden_events.asm:
; CheckIfCoordsInFrontOfPlayerMatch), so that is exactly a GSC bg_event; the
; SPRITE_FACING_UP argument is the function's argument, not a facing gate.  It
; lands on the computer Crystal already had at (0,3) -- our floor is 4x5 blocks
; against Yellow's 4x6.  Crystal's Johto e-mail text and its bookshelf are gone.
CeladonMansion2F_MapScripts:
	def_scene_scripts

	def_callbacks

CeladonMansion2FPC:
	jumpstd PCScript

CeladonMansion2FMeetingRoomSign:
	jumptext CeladonMansion2FMeetingRoomSignText

CeladonMansion2FMeetingRoomSignText:
	text "GAME FREAK"
	line "Meeting Room"
	done

; BG1Q1 (docs/BG1-BENCH-AND-SHELVES.md): Yellow prints BookOrSculptureText
; ("Crammed full of / #MON books!") facing UP on (2,3)
; (engine/events/hidden_events/bookshelves.asm).  Every other bookshelf/TV/
; radio square here is silent, as in Yellow (engine/events/std_collision.asm).
CeladonMansion2FBG1Q1Bookshelf:
	jumpstd PictureBookshelfScript

CeladonMansion2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  0,  0, CELADON_MANSION_1F, 4
	warp_event  1,  0, CELADON_MANSION_3F, 2
	warp_event  6,  0, CELADON_MANSION_3F, 3
	warp_event  7,  0, CELADON_MANSION_1F, 5

	def_coord_events

	def_bg_events
	bg_event  2,  3, BGEVENT_UP, CeladonMansion2FBG1Q1Bookshelf ; BG1Q1
	bg_event  0,  3, BGEVENT_UP, CeladonMansion2FPC
	bg_event  5,  8, BGEVENT_UP, CeladonMansion2FMeetingRoomSign

	def_object_events
