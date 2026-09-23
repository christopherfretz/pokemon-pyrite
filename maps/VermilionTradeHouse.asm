; Kanto hack: Yellow's VERMILION_TRADE_HOUSE
; (vendor/pokeyellow/data/maps/objects/VermilionTradeHouse.asm,
; scripts/VermilionTradeHouse.asm).  This map is Crystal's
; VERMILION_MAGNET_TRAIN_SPEECH_HOUSE slot, renamed in 7e; Crystal's two MAGNET
; TRAIN / JOHTO speakers and the bookshelf are gone.
;
; Despite the name Yellow inherited from Red/Blue, Yellow's house holds NO
; in-game trade: TradeMons has no VERMILION entry and
; VermilionTradeHouseGentlemanText just prints the shared TeachingHMsText
; (vendor/pokeyellow/data/text/text_6.asm).  So this is one GENTLEMAN on
; Yellow's own tile (3,5), facing UP, and no NPC_TRADE.
	object_const_def
	const VERMILIONTRADEHOUSE_GENTLEMAN

VermilionTradeHouse_MapScripts:
	def_scene_scripts

	def_callbacks

VermilionTradeHouseGentlemanScript:
	jumptextfaceplayer VermilionTradeHouseGentlemanText

VermilionTradeHouseGentlemanText:
	text "Once a #MON"
	line "learns an HM, the"
	cont "technique can't"
	cont "be replaced."

	para "Better think care-"
	line "fully before you"
	cont "teach HM moves."
	done

; BG1Q1 (docs/BG1-BENCH-AND-SHELVES.md): Yellow prints BookOrSculptureText
; ("Crammed full of / #MON books!") facing UP on (0,1), (1,1), (7,1)
; (engine/events/hidden_events/bookshelves.asm).  Every other bookshelf/TV/
; radio square here is silent, as in Yellow (engine/events/std_collision.asm).
VermilionTradeHouseBG1Q1Bookshelf:
	jumpstd PictureBookshelfScript

VermilionTradeHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, VERMILION_CITY, 8
	warp_event  3,  7, VERMILION_CITY, 8

	def_coord_events

	def_bg_events
	bg_event  0,  1, BGEVENT_UP, VermilionTradeHouseBG1Q1Bookshelf ; BG1Q1
	bg_event  1,  1, BGEVENT_UP, VermilionTradeHouseBG1Q1Bookshelf ; BG1Q1
	bg_event  7,  1, BGEVENT_UP, VermilionTradeHouseBG1Q1Bookshelf ; BG1Q1

	def_object_events
	object_event  3,  5, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, VermilionTradeHouseGentlemanScript, -1
