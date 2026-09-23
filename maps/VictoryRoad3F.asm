; VICTORY ROAD 3F (M10 13f geometry; 13g adds boulders, switch, trainers, items).
;
; Yellow's 15x9 VICTORY_ROAD_3F on TILESET_CAVE (scripts/vr_blk.py).  Warps 1-4
; are Yellow's, in Yellow's order
; (vendor/pokeyellow/data/maps/objects/VictoryRoad3F.asm).  Warp 5 is the
; boulder HOLE at (23,15) (cave $5f, COLL_PIT): Yellow drops the player to
; 2F (22,16) (IsPlayerOnDungeonWarp + special_warps.asm fly_warp), so here it
; is an ordinary warp_event onto 2F's anchor warp 8.  Yellow drops the player
; whether or not a boulder has gone down first (VictoryRoad3FDefaultScript
; .check_switch_hole runs unconditionally), so the warp needs no gate.
;
; 13g: the switch TILE (3,5) opens BLOCK (3,5) $60 -> stock $0d (Yellow $1d).

VictoryRoad3F_MapScripts:
	def_scene_scripts

	def_callbacks

VictoryRoad3F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 23,  7, VICTORY_ROAD_2F, 4
	warp_event 26,  8, VICTORY_ROAD_2F, 6
	warp_event 27, 15, VICTORY_ROAD_2F, 5
	warp_event  2,  0, VICTORY_ROAD_2F, 7
	warp_event 23, 15, VICTORY_ROAD_2F, 8 ; the hole

	def_coord_events

	def_bg_events

	def_object_events
