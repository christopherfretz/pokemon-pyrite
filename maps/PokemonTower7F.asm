; Kanto hack (docs/M6-TOWER.md, 9a): Yellow's POKEMON_TOWER_7F
; (vendor/pokeyellow/data/maps/objects/PokemonTower7F.asm).
;
; 9a ships the map only.  9j/9k add JESSIE at (10,8), JAMES at (11,8) and
; MR FUJI at (10,3) (docs/M6-TOWER.md 2.6, 3.8).  There is no warp to
; MR FUJI'S HOUSE: Yellow's trip home is a scripted warp, written in 9k.
; Environment DUNGEON, wild table in 9b.

PokemonTower7F_MapScripts:
	def_scene_scripts

	def_callbacks

PokemonTower7F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  9, 16, POKEMON_TOWER_6F, 2

	def_coord_events

	def_bg_events

	def_object_events
