; Kanto hack (docs/M6-TOWER.md, 9a): Yellow's POKEMON_TOWER_4F
; (vendor/pokeyellow/data/maps/objects/PokemonTower4F.asm).
;
; 9a ships the map only.  9f adds Yellow's three CHANNELERs (5,10)/(15,7)/(14,12)
; and the ELIXER / AWAKENING / HP UP balls (docs/M6-TOWER.md 2.3, 4.4).
; Environment DUNGEON, wild table in 9b.
;
; Note Yellow's stairs are crossed here: (3,9) goes UP to 5F and (18,9) goes
; DOWN to 3F, the opposite sense to 3F and 5F.

PokemonTower4F_MapScripts:
	def_scene_scripts

	def_callbacks

PokemonTower4F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  9, POKEMON_TOWER_5F, 1
	warp_event 18,  9, POKEMON_TOWER_3F, 2

	def_coord_events

	def_bg_events

	def_object_events
