; CERULEAN CAVE 2F (M10P, docs/M10P-CERULEAN-CAVE.md): Yellow's 15x9
; CERULEAN_CAVE_2F on TILESET_KANTO_CAVE, cut by scripts/ct1_kanto_cave.py
; (YELLOW_MAPS).  Six ladders, all back down to 1F; no water, no tile pairs.
; Objects: Yellow's four item balls in Yellow's order; hidden PP UP from
; Yellow's hidden_events.asm.
	object_const_def
	const CERULEANCAVE2F_RARE_CANDY
	const CERULEANCAVE2F_ULTRA_BALL
	const CERULEANCAVE2F_MAX_REVIVE
	const CERULEANCAVE2F_FULL_RESTORE

CeruleanCave2F_MapScripts:
	def_scene_scripts

	def_callbacks

CeruleanCave2FRareCandy:
	itemball RARE_CANDY

CeruleanCave2FUltraBall:
	itemball ULTRA_BALL

CeruleanCave2FMaxRevive:
	itemball MAX_REVIVE

CeruleanCave2FFullRestore:
	itemball FULL_RESTORE

CeruleanCave2FHiddenPPUp:
	hiddenitem PP_UP, EVENT_CERULEAN_CAVE_2F_HIDDEN_PP_UP

CeruleanCave2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 29,  1, CERULEAN_CAVE_1F, 3
	warp_event 22,  6, CERULEAN_CAVE_1F, 4
	warp_event 19,  7, CERULEAN_CAVE_1F, 5
	warp_event  9,  1, CERULEAN_CAVE_1F, 6
	warp_event  1,  3, CERULEAN_CAVE_1F, 7
	warp_event  3, 11, CERULEAN_CAVE_1F, 8

	def_coord_events

	def_bg_events
	bg_event 16, 13, BGEVENT_ITEM, CeruleanCave2FHiddenPPUp

	def_object_events
	object_event  0, 11, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCave2FRareCandy, EVENT_CERULEAN_CAVE_2F_RARE_CANDY
	object_event 16,  7, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCave2FUltraBall, EVENT_CERULEAN_CAVE_2F_ULTRA_BALL
	object_event 19, 11, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCave2FMaxRevive, EVENT_CERULEAN_CAVE_2F_MAX_REVIVE
	object_event 27,  9, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCave2FFullRestore, EVENT_CERULEAN_CAVE_2F_FULL_RESTORE
