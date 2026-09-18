; Kanto hack: Yellow's ROUTE_2_TRADE_HOUSE (docs/M2-PEWTER.md, 4f).
; Yellow objects: SCIENTIST (2,4) with the "a fainted #MON can still use CUT"
; tip, and a GAMEBOY_KID (4,1) running TRADE_FOR_MILES (CLEFAIRY -> MR.MIME
; "MILES"). The room shares maps/House1.blk, whose layout is Yellow's
; Route2TradeHouse.blk with two different wall decorations.
	object_const_def
	const ROUTE2TRADEHOUSE_SCIENTIST
	const ROUTE2TRADEHOUSE_GAMEBOY_KID

Route2TradeHouse_MapScripts:
	def_scene_scripts

	def_callbacks

Route2TradeHouseScientistScript:
	jumptextfaceplayer Route2TradeHouseScientistText

Route2TradeHouseGameboyKidScript:
	faceplayer
	opentext
	trade NPC_TRADE_MILES
	waitbutton
	closetext
	end

Route2TradeHouseBookshelf:
	jumpstd DifficultBookshelfScript

Route2TradeHouseScientistText:
	text "A fainted #MON"
	line "can't fight. But, "
	cont "it can still use "
	cont "moves like CUT!"
	done

Route2TradeHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, ROUTE_2, 8
	warp_event  3,  7, ROUTE_2, 8

	def_coord_events

	def_bg_events
	bg_event  0,  1, BGEVENT_READ, Route2TradeHouseBookshelf
	bg_event  1,  1, BGEVENT_READ, Route2TradeHouseBookshelf

	def_object_events
	object_event  2,  4, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route2TradeHouseScientistScript, -1
	object_event  4,  1, SPRITE_GAMEBOY_KID, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, Route2TradeHouseGameboyKidScript, -1
