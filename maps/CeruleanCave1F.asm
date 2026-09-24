; CERULEAN CAVE 1F (M10P, docs/M10P-CERULEAN-CAVE.md): Yellow's 15x9
; CERULEAN_CAVE_1F on TILESET_KANTO_CAVE.  The .blk is Yellow's, cut by
; scripts/ct1_kanto_cave.py (YELLOW_MAPS): Yellow block N == our metatile N,
; plus collision clones for the ladders (LADDER), the two-wide south exit
; ($24's WARP_CARPET_DOWN pair, clone $94) and Gen 1's tile-pair barriers,
; which become GSC edge walls ($bx family).  Replaces M3 6k's 5x4 stub.
;
; Objects are Yellow's four item balls, in Yellow's order
; (vendor/pokeyellow/data/maps/objects/CeruleanCave1F.asm); the hidden PP UP is
; Yellow's data/events/hidden_events.asm row.
	object_const_def
	const CERULEANCAVE1F_RARE_CANDY
	const CERULEANCAVE1F_MAX_ELIXER
	const CERULEANCAVE1F_MAX_REVIVE
	const CERULEANCAVE1F_ULTRA_BALL

CeruleanCave1F_MapScripts:
	def_scene_scripts

	def_callbacks

CeruleanCave1FRareCandy:
	itemball RARE_CANDY

CeruleanCave1FMaxElixer:
	itemball MAX_ELIXER

CeruleanCave1FMaxRevive:
	itemball MAX_REVIVE

CeruleanCave1FUltraBall:
	itemball ULTRA_BALL

CeruleanCave1FHiddenPPUp:
	hiddenitem PP_UP, EVENT_CERULEAN_CAVE_1F_HIDDEN_PP_UP

CeruleanCave1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 24, 17, CERULEAN_CITY, 7 ; Yellow LAST_MAP; WARP_CARPET_DOWN
	warp_event 25, 17, CERULEAN_CITY, 7
	warp_event 27,  1, CERULEAN_CAVE_2F, 1
	warp_event 23,  7, CERULEAN_CAVE_2F, 2
	warp_event 18,  9, CERULEAN_CAVE_2F, 3
	warp_event  7,  1, CERULEAN_CAVE_2F, 4
	warp_event  1,  3, CERULEAN_CAVE_2F, 5
	warp_event  3, 11, CERULEAN_CAVE_2F, 6
	warp_event  0,  6, CERULEAN_CAVE_B1F, 1

	def_coord_events

	def_bg_events
	bg_event 18,  7, BGEVENT_ITEM, CeruleanCave1FHiddenPPUp

	def_object_events
	object_event 29, 16, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCave1FRareCandy, EVENT_CERULEAN_CAVE_1F_RARE_CANDY
	object_event  7, 11, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCave1FMaxElixer, EVENT_CERULEAN_CAVE_1F_MAX_ELIXER
	object_event 29,  9, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCave1FMaxRevive, EVENT_CERULEAN_CAVE_1F_MAX_REVIVE
	object_event 18,  3, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCave1FUltraBall, EVENT_CERULEAN_CAVE_1F_ULTRA_BALL
