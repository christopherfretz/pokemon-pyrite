; VICTORY ROAD 2F (M10 13f geometry; 13g adds boulders, switches, trainers,
; items and MOLTRES).
;
; Yellow's 15x9 VICTORY_ROAD_2F on TILESET_CAVE (scripts/vr_blk.py).  Warps 1-7
; are Yellow's, in Yellow's order
; (vendor/pokeyellow/data/maps/objects/VictoryRoad2F.asm).  Warps 2-3 are the
; east exit onto ROUTE_23 (14,31) (Yellow: LAST_MAP, 4): Yellow walks off the
; map edge there, so the tiles are WARP_CARPET_RIGHT.
; Warp 8 is the inert landing anchor for 3F's hole at (23,15): Yellow's
; fly_warp VICTORY_ROAD_2F, 22, 16 (vendor/pokeyellow/data/maps/special_warps.asm).
; It sits on plain floor, so stepping on it does nothing.
;
; 13g: switch 1 TILE (1,16) opens BLOCK (3,4) $61 -> stock $05 (Yellow $15);
; switch 2 TILE (9,16) opens BLOCK (11,7) $60 -> stock $0d (Yellow $1d).

VictoryRoad2F_MapScripts:
	def_scene_scripts

	def_callbacks

VictoryRoad2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  0,  8, VICTORY_ROAD_1F, 3
	warp_event 29,  7, ROUTE_23, 4
	warp_event 29,  8, ROUTE_23, 4
	warp_event 23,  7, VICTORY_ROAD_3F, 1
	warp_event 25, 14, VICTORY_ROAD_3F, 3
	warp_event 27,  7, VICTORY_ROAD_3F, 2
	warp_event  1,  1, VICTORY_ROAD_3F, 4
	warp_event 22, 16, VICTORY_ROAD_3F, 5 ; hole landing (anchor)

	def_coord_events

	def_bg_events

	def_object_events
