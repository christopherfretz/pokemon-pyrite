; Kanto hack: Yellow's PEWTER SPEECH HOUSE (docs/M2-PEWTER.md).  Crystal's
; snoozing GRAMPS talked about Johto's RADIO TOWER; Yellow's two NPCs teach the
; TM-vs-level-up-move and the catch-rate lessons instead
; (vendor/pokeyellow/text/PewterSpeechHouse.asm).  The file name is kept so the
; map constant, map list and header do not have to move.
; Sprite substitution: Yellow's GAMBLER -> SPRITE_GENTLEMAN (docs/M2-PEWTER.md:477).
; The two bookshelf bg_events are a deliberate keep: Yellow's HOUSE tileset does
; print for bookshelf tile $1E (data/tilesets/bookshelf_tile_ids.asm ->
; BookOrSculptureText), and N1a already made PictureBookshelfText that exact
; string, so reading them here is Yellow behaviour, not a Crystal leftover.
	object_const_def
	const PEWTERSNOOZESPEECHHOUSE_GAMBLER
	const PEWTERSNOOZESPEECHHOUSE_YOUNGSTER

PewterSnoozeSpeechHouse_MapScripts:
	def_scene_scripts

	def_callbacks

PewterSnoozeSpeechHouseGamblerScript:
	jumptextfaceplayer PewterSnoozeSpeechHouseGamblerText

PewterSnoozeSpeechHouseYoungsterScript:
	jumptextfaceplayer PewterSnoozeSpeechHouseYoungsterText

PewterSnoozeSpeechHouseBookshelf:
	jumpstd PictureBookshelfScript

PewterSnoozeSpeechHouseGamblerText:
	text "#MON learn new"
	line "techniques as"
	cont "they grow!"

	para "But, some moves"
	line "must be taught by"
	cont "the trainer!"
	done

PewterSnoozeSpeechHouseYoungsterText:
	text "#MON become"
	line "easier to catch"
	cont "when they are"
	cont "hurt or asleep!"

	para "But, it's not a"
	line "sure thing!"
	done

; BG1Q1 (docs/BG1-BENCH-AND-SHELVES.md): Yellow prints BookOrSculptureText
; ("Crammed full of / #MON books!") facing UP on (7,1)
; (engine/events/hidden_events/bookshelves.asm).  Every other bookshelf/TV/
; radio square here is silent, as in Yellow (engine/events/std_collision.asm).
PewterSnoozeSpeechHouseBG1Q1Bookshelf:
	jumpstd PictureBookshelfScript

PewterSnoozeSpeechHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, PEWTER_CITY, 5
	warp_event  3,  7, PEWTER_CITY, 5

	def_coord_events

	def_bg_events
	bg_event  7,  1, BGEVENT_UP, PewterSnoozeSpeechHouseBG1Q1Bookshelf ; BG1Q1
	bg_event  0,  1, BGEVENT_READ, PewterSnoozeSpeechHouseBookshelf
	bg_event  1,  1, BGEVENT_READ, PewterSnoozeSpeechHouseBookshelf

	def_object_events
	object_event  2,  3, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, PewterSnoozeSpeechHouseGamblerScript, -1
	object_event  4,  5, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, PewterSnoozeSpeechHouseYoungsterScript, -1
