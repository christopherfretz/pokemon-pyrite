; Kanto hack (docs/M6-TOWER.md, 9a): Yellow's POKEMON_TOWER_3F
; (vendor/pokeyellow/data/maps/objects/PokemonTower3F.asm).
;
; 9a ships the map only.  9f adds Yellow's three CHANNELERs (12,3)/(9,8)/(10,13)
; and the ESCAPE ROPE ball at (12,1) (docs/M6-TOWER.md 2.2, 4.4).
; Environment DUNGEON, wild table in 9b.

PokemonTower3F_MapScripts:
	def_scene_scripts

	def_callbacks

PokemonTower3F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  9, POKEMON_TOWER_2F, 1
	warp_event 18,  9, POKEMON_TOWER_4F, 2

	def_coord_events

	def_bg_events

	def_object_events
