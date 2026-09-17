; Kanto hack: the Mt. Moon Pokemon Center on Route 4 (docs/M2-MTMOON.md).
; It uses Crystal's shared maps/Pokecenter1F.blk, so the two door tiles and the
; 2F staircase are Crystal's, not Yellow's.  The nurse and the NPCs (including
; the Magikarp salesman) come in a later step.

MtMoonPokecenter_MapScripts:
	def_scene_scripts

	def_callbacks

MtMoonPokecenter_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, ROUTE_4, 1
	warp_event  4,  7, ROUTE_4, 1
	warp_event  0,  7, POKECENTER_2F, 1

	def_coord_events

	def_bg_events

	def_object_events
