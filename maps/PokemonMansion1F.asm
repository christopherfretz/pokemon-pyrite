; Kanto hack (M9 12a): placeholder.  Registered so the map has an id, a
; header, attributes and a .blk.  12g links CINNABAR ISLAND's door to it and
; gives it the matching return warp(s) below -- nothing else lives here yet.
; POKeMON MANSION 1F -- 12k populates it, 12l wires the switch.
PokemonMansion1F_MapScripts:
	def_scene_scripts

	def_callbacks

PokemonMansion1F_MapEvents:
	db 0, 0 ; filler

; M9 12g: interim return warps ONLY.  The island's front door is this map's
; warp 2, so Yellow's four south-wall doors have to exist (in Yellow's order)
; before CinnabarIsland can link here at all -- otherwise the warp lands on
; garbage coordinates and the player is stranded with no way out (soft-lock).
; Yellow: vendor/pokeyellow/data/maps/objects/PokemonMansion1F.asm warps 1-4.
; 12k adds the rest (2F at (5,10), B1F at (21,23), the two back doors) and
; populates the map; these four rows stay exactly as they are.
; Yellow warps on a COORDINATE match; Crystal only from a tile whose
; ATTRIBUTE is a warp (engine/overworld/tile_events.asm, CheckWarpCollision),
; and Gen 1 painted no door art on an exit tile -- so blocks (2,13)/(3,13) of
; the .blk are now kanto_facility $2c (FLOOR, FLOOR, WARP_CARPET_DOWN,
; WARP_CARPET_DOWN), the same exit block CinnabarGym.blk already uses, which
; makes tiles (4..7,27) warp carpets exactly under Yellow's four warps.
	def_warp_events
	warp_event  4, 27, CINNABAR_ISLAND, 1
	warp_event  5, 27, CINNABAR_ISLAND, 1
	warp_event  6, 27, CINNABAR_ISLAND, 1
	warp_event  7, 27, CINNABAR_ISLAND, 1

	def_coord_events

	def_bg_events

	def_object_events
