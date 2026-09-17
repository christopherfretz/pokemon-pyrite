; 6k: the Cerulean Cave mouth, as a STUB (docs/M3-CERULEAN.md 7 and
; "6k findings").  Yellow's CERULEAN_CAVE_1F/2F/B1F and the Mewtwo encounter
; are their own milestone; this is one 5x4 TILESET_CAVE room so that Cerulean's
; warp 7 at (4,11) has somewhere real to go, and so the champion-gate in front
; of it can be proved end to end.
;
; Geometry (hack/maps/CeruleanCave1F.blk, 20 bytes, no new metatiles): a ring of
; cave wall around tiles x=1..8, y=2..5, with block $37 (WALL,WALL,WALL,CAVE) at
; block (2,0) putting the cave mouth on tile (5,1).  Arriving on a CAVE tile
; forces a step DOWN (docs/PORTING.md 2.3), so the player lands on (5,2).
;
; Yellow has no NPC inside the cave; this one is ours, and it is the stub
; marker.  It goes away when the real Cerulean Cave lands.
	object_const_def
	const CERULEANCAVE1F_HIKER

CeruleanCave1F_MapScripts:
	def_scene_scripts

	def_callbacks

CeruleanCave1FHikerScript:
	jumptextfaceplayer CeruleanCave1FHikerText

CeruleanCave1FHikerText:
	text "Whoa! You got in"
	line "here too?"

	para "It's no use. A"
	line "rock slide has"
	cont "the way ahead"
	cont "blocked solid."

	para "The horribly"
	line "strong #MON"
	cont "deep inside will"
	cont "have to wait!"
	done

CeruleanCave1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  5,  1, CERULEAN_CITY, 7

	def_coord_events

	def_bg_events

	def_object_events
	object_event  5,  4, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, CeruleanCave1FHikerScript, -1
