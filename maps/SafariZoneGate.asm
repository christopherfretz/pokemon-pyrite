; Kanto hack (docs/M7-FUCHSIA.md): the admission machine is 10k's and the room
; is still 10a's flat stub.  10f gives it the ONE thing the city needs now --
; a way back out, so FUCHSIA CITY's warp 5 round-trips instead of stranding the
; player: Yellow's own south door tiles (3,5)/(4,5), on two $0b blocks
; (FLOOR, FLOOR, WARP_CARPET_DOWN, WARP_CARPET_DOWN) in the .blk.  Yellow's
; north pair (3,0)/(4,0) -> SAFARI_ZONE_CENTER and the two workers come with
; 10k/10l.

SafariZoneGate_MapScripts:
	def_scene_scripts

	def_callbacks

SafariZoneGate_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  5, FUCHSIA_CITY, 5
	warp_event  4,  5, FUCHSIA_CITY, 5

	def_coord_events

	def_bg_events

	def_object_events
