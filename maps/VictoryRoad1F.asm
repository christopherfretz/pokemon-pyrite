; VICTORY ROAD 1F (M10 13f geometry; 13g adds boulders, switch, trainers, items).
;
; Yellow's 10x9 VICTORY_ROAD_1F re-cut on TILESET_CAVE by scripts/vr_blk.py.
; This map is Crystal's old VICTORY_ROAD (id 90) renamed; Crystal's 10x36
; layout, its Silver fight and its five items are gone (docs/M10-INDIGO.md
; "## 13f findings", C-12).
;
; Warps are Yellow's (vendor/pokeyellow/data/maps/objects/VictoryRoad1F.asm):
; the mouth (8,17)/(9,17) returns to ROUTE_23 warp 3 (Yellow: LAST_MAP, 3),
; the ladder (1,1) climbs to 2F.
;
; 13g: boulder switch TILE (17,13); the barrier is BLOCK (4,6) -- $60 closed,
; changeblock to stock $0d when open (Yellow's ReplaceTileBlock $1d).

VictoryRoad1F_MapScripts:
	def_scene_scripts

	def_callbacks

VictoryRoad1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  8, 17, ROUTE_23, 3
	warp_event  9, 17, ROUTE_23, 3
	warp_event  1,  1, VICTORY_ROAD_2F, 1

	def_coord_events

	def_bg_events

	def_object_events
