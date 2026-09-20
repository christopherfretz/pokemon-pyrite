; Kanto hack (docs/M6-TOWER.md, 9a): Yellow's POKEMON_TOWER_5F
; (vendor/pokeyellow/data/maps/objects/PokemonTower5F.asm).
;
; 9a ships the map only.  9g adds the purified-zone CHANNELER at (12,8), the
; four battling CHANNELERs, the NUGGET ball at (6,14) and the four-tile
; purified zone (10,8)/(11,8)/(10,9)/(11,9) (docs/M6-TOWER.md 2.4, 3.7, 4.4).
; Environment DUNGEON, wild table in 9b -- 5F is the first floor with CUBONE.

PokemonTower5F_MapScripts:
	def_scene_scripts

	def_callbacks

PokemonTower5F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  9, POKEMON_TOWER_4F, 1
	warp_event 18,  9, POKEMON_TOWER_6F, 1

	def_coord_events

	def_bg_events

	def_object_events
