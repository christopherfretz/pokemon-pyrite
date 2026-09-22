; Kanto hack (M9 12o, D96): DISSOLVED.  Crystal put BLAINE in a gym on the
; SEAFOAM ISLANDS; Yellow's SEAFOAM ISLANDS are a five-floor cave (12d/12e) and
; BLAINE's gym is on CINNABAR ISLAND again (12n, maps/CinnabarGym.asm).  12o
; lifted everything out: BLAINE's script, the GYM GUIDE, their texts
; (BlaineWinLossText, ReceivedVolcanoBadgeText, ...), the two object_consts,
; the object_events and the ROUTE_20 warp.  maps/SeafoamGym.blk is deleted too;
; SeafoamGym_Blocks now shares the 5x4 KantoGateNorthSouth.blk label in
; data/maps/blocks.asm (never drawn -- nothing warps here).
;
; What stays, and why: SEAFOAM_GYM in constants/map_constants.asm is a dead
; positional id (D49: never renumber -- the Cinnabar group's ids 5-23 would
; move), so its `map` row in data/maps/maps.asm and its `map_attributes` in
; data/maps/attributes.asm must still name these two labels.  EVENT_TALKED_TO_SEAFOAM_GYM_GUIDE_ONCE and
; EVENT_SEAFOAM_GYM_GYM_GUIDE stay in constants/event_flags.asm as dead flags
; (never renumber).  Same shape as the retired ROUTE_19_FUCHSIA_GATE (12c).
SeafoamGym_MapScripts:
	def_scene_scripts

	def_callbacks

SeafoamGym_MapEvents:
	db 0, 0 ; filler

	def_warp_events

	def_coord_events

	def_bg_events

	def_object_events
