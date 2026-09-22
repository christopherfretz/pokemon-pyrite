; Kanto hack (M9 12i): Yellow's CINNABAR LAB Meeting Room
; (vendor/pokeyellow/{data/maps/objects,scripts,text}/CinnabarLabTradeRoom.asm),
; cut wholesale onto Yellow's own 4x4 .blk and the new TILESET_KANTO_LAB (D95).
; The hall's west door (its warp 3) leads here; warps 1 and 2 are the exit mat
; on the bottom row, whose collision scripts/kanto_lab_blk.py overrides to
; WARP_CARPET_DOWN (block $0c) -- see hack/maps/CinnabarLab.asm.
;
; Two of Yellow's three in-game trades live here:
;   (1,4) GRAMPS  -> TRADE_FOR_BUFFY   GOLDUCK for RHYDON, NPC_TRADE_BUFFY
;   (5,5) BEAUTY  -> TRADE_FOR_CEZANNE GROWLITHE for DEWGONG, NPC_TRADE_CEZANNE
; The third, TRADE_FOR_STICKY, is in the Testing Room in Yellow, not here
; (vendor/pokeyellow/scripts/CinnabarLabFossilRoom.asm, Scientist2).
;
; BUFFY's Yellow dialog set is TRADE_DIALOGSET_EVOLUTION, which Crystal has no
; equivalent of, so 12i adds TRADE_DIALOGSET_YELLOW_EVOLUTION (D108) with
; Yellow's _WannaTrade2Text family ported verbatim into data/text/common_1.asm.
; CEZANNE's is Yellow's HAPPY voice, already ported as
; TRADE_DIALOGSET_YELLOW_HAPPY by 7d.  Both OT names follow the M4-audit Q5
; ruling: GSC requires an OT, so the OT is the Yellow nickname.
	object_const_def
	const CINNABARLABTRADEROOM_SUPER_NERD
	const CINNABARLABTRADEROOM_GRAMPS
	const CINNABARLABTRADEROOM_BEAUTY

CinnabarLabTradeRoom_MapScripts:
	def_scene_scripts

	def_callbacks

CinnabarLabTradeRoomSuperNerdScript:
	jumptextfaceplayer CinnabarLabTradeRoomSuperNerdText

CinnabarLabTradeRoomGrampsScript:
	faceplayer
	opentext
	trade NPC_TRADE_BUFFY
	waitbutton
	closetext
	end

CinnabarLabTradeRoomBeautyScript:
	faceplayer
	opentext
	trade NPC_TRADE_CEZANNE
	waitbutton
	closetext
	end

CinnabarLabTradeRoomSuperNerdText:
	text "I found this very"
	line "strange fossil in"
	cont "MT.MOON!"

	para "I think it's a"
	line "rare, prehistoric"
	cont "#MON!"
	done

CinnabarLabTradeRoom_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, CINNABAR_LAB, 3
	warp_event  3,  7, CINNABAR_LAB, 3

	def_coord_events

	def_bg_events

	def_object_events
	object_event  3,  2, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CinnabarLabTradeRoomSuperNerdScript, -1
	object_event  1,  4, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, CinnabarLabTradeRoomGrampsScript, -1
	object_event  5,  5, SPRITE_BEAUTY, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CinnabarLabTradeRoomBeautyScript, -1
