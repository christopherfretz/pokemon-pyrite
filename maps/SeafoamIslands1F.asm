; Kanto hack (M9 12a): placeholder.  Registered so the map has an id, a
; header, attributes and a .blk.
; SEAFOAM ISLANDS 1F -- 12d cuts the geometry, 12e the boulders.  12b gave
; it the two ROUTE 20 mouths so the route's warps have a real destination.
SeafoamIslands1F_MapScripts:
	def_scene_scripts

	def_callbacks

SeafoamIslands1F_MapEvents:
	db 0, 0 ; filler

	; Kanto hack (M9 12b): the two mouths ROUTE 20 warps into, on the BR CAVE
	; quadrant of cave block $37 (scripts/route19_21_blk.py puts the blocks
	; there).  12d replaces the whole stub with Yellow's geometry.
	def_warp_events
	warp_event  3,  3, ROUTE_20, 1
	warp_event 11,  3, ROUTE_20, 2

	def_coord_events

	def_bg_events

	def_object_events
