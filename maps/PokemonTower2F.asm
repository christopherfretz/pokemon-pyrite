; Kanto hack (docs/M6-TOWER.md, 9a): Yellow's POKEMON_TOWER_2F
; (vendor/pokeyellow/data/maps/objects/PokemonTower2F.asm).
;
; 9a ships the map only: Yellow's .blk byte for byte, Yellow's two warps, the
; correct border block ($01) and nothing else.  The cast arrives in 9e -- the
; rival's fourth battle at (14,5) and the CHANNELER talker at (3,7)
; (docs/M6-TOWER.md 2.1, 3.2).
;
; Environment INDOOR: Yellow's 2F encounter rate is 0
; (vendor/pokeyellow/data/wild/maps/PokemonTower2F.asm), so this floor has no
; wild table at all and must not roll (3F-7F are DUNGEON, 9b).

PokemonTower2F_MapScripts:
	def_scene_scripts

	def_callbacks

PokemonTower2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  9, POKEMON_TOWER_3F, 1
	warp_event 18,  9, POKEMON_TOWER_1F, 3

	def_coord_events

	def_bg_events

	def_object_events
