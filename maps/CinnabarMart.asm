; Kanto hack (M9 12a): placeholder.  Registered so the map has an id, a
; header, attributes and a .blk; no warps, so nothing can reach it yet.
; CINNABAR MART -- 12h stocks it.
CinnabarMart_MapScripts:
	def_scene_scripts

	def_callbacks

CinnabarMart_MapEvents:
	db 0, 0 ; filler

	def_warp_events

	def_coord_events

	def_bg_events

	def_object_events
