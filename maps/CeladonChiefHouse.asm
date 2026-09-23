; Kanto hack (M6 9t): Yellow's CELADON_CHIEF_HOUSE -- the ROCKET BOSS's house
; (vendor/pokeyellow/data/maps/objects/CeladonChiefHouse.asm,
; vendor/pokeyellow/text/CeladonChiefHouse.asm).
;
; Yellow's room is 4x4 on the MANSION tileset; docs/M6-CELADON.md 1.1 puts it
; on TILESET_HOUSE here, and Crystal's House1.blk turns out to be Yellow's
; layout tile for tile -- the two-tile door at (2,7)/(3,7), the central table
; block at (3,3)-(4,4), the plants in the bottom corners, and all three of
; Yellow's NPC tiles open -- so it aliases House1.blk (data/maps/blocks.asm)
; the way 8h aliased it for MrFujisHouse and SoulHouse.  Border block moves
; from $00 to $0a to match the other House1 rooms.
;
; All three NPCs keep Yellow's own tiles.  GRAMPS is the chief (Yellow's
; BALDING_GUY, docs/M6-CELADON.md 2.3).
;
; Yellow has no hidden events here, so the map has no bg_events of its own --
; except that House1's (7,1) is a COLL_RADIO tile, which would otherwise drop
; the player into Crystal's Pokegear radio.  It is shadowed with the same
; magazines text MrFujisHouse uses for exactly this tile; the bookshelves at
; (0,1)/(1,1) and the TV at (2,1) keep their Gen 1-neutral std scripts.
	object_const_def
	const CELADONCHIEFHOUSE_CHIEF
	const CELADONCHIEFHOUSE_ROCKET
	const CELADONCHIEFHOUSE_SAILOR

CeladonChiefHouse_MapScripts:
	def_scene_scripts

	def_callbacks

CeladonChiefHouseChiefScript:
	jumptextfaceplayer CeladonChiefHouseChiefText

CeladonChiefHouseRocketScript:
	jumptextfaceplayer CeladonChiefHouseRocketText

CeladonChiefHouseSailorScript:
	jumptextfaceplayer CeladonChiefHouseSailorText

CeladonChiefHouseMagazines:
	jumptext CeladonChiefHouseMagazinesText

CeladonChiefHouseChiefText:
	text "Hehehe! The slots"
	line "just reel in the"
	cont "dough, big time!"
	done

CeladonChiefHouseRocketText:
	text "CHIEF!"

	para "We just shipped"
	line "2000 #MON as"
	cont "slot prizes!"
	done

CeladonChiefHouseSailorText:
	text "Don't touch the"
	line "poster at the"
	cont "GAME CORNER!"

	para "There's no secret"
	line "switch behind it!"
	done

CeladonChiefHouseMagazinesText:
	text "#MON magazines!"

	para "#MON notebooks!"

	para "#MON graphs!"
	done

; BG1Q1 (docs/BG1-BENCH-AND-SHELVES.md): Yellow prints BookOrSculptureText
; ("Crammed full of / #MON books!") facing UP on (2,1)
; (engine/events/hidden_events/bookshelves.asm).  Every other bookshelf/TV/
; radio square here is silent, as in Yellow (engine/events/std_collision.asm).
CeladonChiefHouseBG1Q1Bookshelf:
	jumpstd PictureBookshelfScript

CeladonChiefHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, CELADON_CITY, 12 ; Kanto hack (M6 9p): Yellow's city warp 12
	warp_event  3,  7, CELADON_CITY, 12

	def_coord_events

	def_bg_events
	bg_event  2,  1, BGEVENT_UP, CeladonChiefHouseBG1Q1Bookshelf ; BG1Q1
	bg_event  7,  1, BGEVENT_READ, CeladonChiefHouseMagazines

	def_object_events
	object_event  4,  2, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonChiefHouseChiefScript, -1
	object_event  1,  4, SPRITE_ROCKET, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeladonChiefHouseRocketScript, -1
	object_event  5,  6, SPRITE_SAILOR, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonChiefHouseSailorScript, -1
