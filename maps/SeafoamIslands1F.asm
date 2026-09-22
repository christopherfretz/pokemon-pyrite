; SEAFOAM ISLANDS 1F.  Geometry cut from Yellow by scripts/seafoam_blk.py
; (M9 12d); warps 1-4 are Yellow's two ROUTE 20 mouths, at Yellow's own
; coordinates and in Yellow's own order, so ROUTE_20 can go back to warping
; at `, 1` and `, 3` as it does there.  12e adds warps 5-7 (to B1F), the two
; boulders and the hidden items.
SeafoamIslands1F_MapScripts:
	def_scene_scripts

	def_callbacks

SeafoamIslands1F_MapEvents:
	db 0, 0 ; filler

	; Yellow's warps 1-4: each mouth is two tiles wide, both halves of the
	; WARP_CARPET_DOWN pair on cave metatile $40 (cavern block $24).
	def_warp_events
	warp_event  4, 17, ROUTE_20, 1
	warp_event  5, 17, ROUTE_20, 1
	warp_event 26, 17, ROUTE_20, 2
	warp_event 27, 17, ROUTE_20, 2

	def_coord_events

	def_bg_events

	def_object_events
