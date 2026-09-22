; Kanto hack (M9 12a): placeholder.  Registered so the map has an id, a
; header, attributes and a .blk.  12g links CINNABAR ISLAND's door to it and
; gives it the matching return warp(s) below -- nothing else lives here yet.
; CINNABAR LAB -- 12i.
CinnabarLab_MapScripts:
	def_scene_scripts

	def_callbacks

CinnabarLab_MapEvents:
	db 0, 0 ; filler

; M9 12g: an interim return warp ONLY, so the island's LAB door leads
; somewhere the player can leave again.  Yellow warps on a COORDINATE match,
; Crystal only from a tile whose ATTRIBUTE is a warp
; (engine/overworld/tile_events.asm, CheckWarpCollision), so Yellow's own exit
; tiles (2,7)/(3,7) -- plain floor in this placeholder .blk -- could not work:
; the block at (1,3) is now kanto_interior $39 (FLOOR, WARP_PANEL, FLOOR,
; FLOOR), which puts a warp panel on tile (3,6), and the warp sits there.
; 12i cuts the real .blk from Yellow's layout and moves this exit onto the
; converted doorway, then adds the three side-room doors after it.
	def_warp_events
	warp_event  3,  6, CINNABAR_ISLAND, 3

	def_coord_events

	def_bg_events

	def_object_events
