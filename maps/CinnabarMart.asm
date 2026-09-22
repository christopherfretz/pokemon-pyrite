; Kanto hack (M9 12a): placeholder.  Registered so the map has an id, a
; header, attributes and a .blk.  12g links CINNABAR ISLAND's door to it and
; gives it the matching return warp(s) below -- nothing else lives here yet.
; CINNABAR MART -- 12h stocks it.
CinnabarMart_MapScripts:
	def_scene_scripts

	def_callbacks

CinnabarMart_MapEvents:
	db 0, 0 ; filler

; M9 12g: interim return warps ONLY, so the island's MART door is not a
; one-way trip.  The placeholder shares FuchsiaMart.blk (data/maps/blocks.asm),
; whose door tiles are (2,7)/(3,7) -- Yellow's mart doors are (3,7)/(4,7), and
; 12h moves these two rows when it cuts CinnabarMart.blk and stocks the shelf.
	def_warp_events
	warp_event  2,  7, CINNABAR_ISLAND, 5
	warp_event  3,  7, CINNABAR_ISLAND, 5

	def_coord_events

	def_bg_events

	def_object_events
