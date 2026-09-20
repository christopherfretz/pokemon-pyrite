RocketHideoutB3F_MapScripts:
	def_scene_scripts

	def_callbacks

RocketHideoutB3F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; Kanto hack (M6 9w): Yellow's warp table, tile for tile.  B3F has no lift
; door -- the panel deliberately skips it, so the only way in is the B2F
; staircase and the only way on is the one down to B4F.
	warp_event 25,  6, ROCKET_HIDEOUT_B2F, 2
	warp_event 19, 18, ROCKET_HIDEOUT_B4F, 1

	def_coord_events

	def_bg_events

	def_object_events
