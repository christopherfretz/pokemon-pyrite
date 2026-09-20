; Kanto hack (docs/M6-TOWER.md, 9a): Yellow's POKEMON_TOWER_6F
; (vendor/pokeyellow/data/maps/objects/PokemonTower6F.asm).
;
; 9a ships the map only.  9h adds Yellow's three CHANNELERs, the RARE CANDY and
; X ACCURACY balls, and the MAROWAK ghost block -- a coord_event at (10,16),
; the only approach tile to the 7F stairs at (9,16) (docs/M6-TOWER.md 2.5, 3.5).
; Until 9h lands, 7F is reachable with no fight; that is deliberate, so the
; warp pairs can be walked in both directions now.
; Environment DUNGEON, wild table in 9b.

PokemonTower6F_MapScripts:
	def_scene_scripts

	def_callbacks

PokemonTower6F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 18,  9, POKEMON_TOWER_5F, 2
	warp_event  9, 16, POKEMON_TOWER_7F, 1

	def_coord_events

	def_bg_events

	def_object_events
