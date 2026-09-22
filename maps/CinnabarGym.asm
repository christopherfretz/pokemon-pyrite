; Kanto hack (M9 12a): placeholder.  Registered so the map has an id, a
; header, attributes and a .blk.  12g links CINNABAR ISLAND's door to it and
; gives it the matching return warp(s) below -- nothing else lives here yet.
; CINNABAR GYM -- 12n builds Yellow's quiz maze, BLAINE and TM38.
CinnabarGym_MapScripts:
	def_scene_scripts

	def_callbacks

CinnabarGym_MapEvents:
	db 0, 0 ; filler

; M9 12g: interim return warps ONLY, so the island's gym door is not a
; one-way trip into a map with no exit.  Yellow's own pair, on the .blk's
; door tiles (vendor/pokeyellow/data/maps/objects/CinnabarGym.asm).  12n
; builds the quiz maze, BLAINE and TM38 around them.
	def_warp_events
	warp_event 16, 17, CINNABAR_ISLAND, 2
	warp_event 17, 17, CINNABAR_ISLAND, 2

	def_coord_events

	def_bg_events

	def_object_events
