; Kanto hack (M9 12a): placeholder.  Registered so the map has an id, a
; header, attributes and a .blk; no warps, so nothing can reach it yet.
; POKeMON MANSION 2F -- 12k/12l.
PokemonMansion2F_MapScripts:
	def_scene_scripts

	def_callbacks

PokemonMansion2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events

	def_coord_events

	def_bg_events

	def_object_events
