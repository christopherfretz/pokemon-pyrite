RocketHideoutB2F_MapScripts:
	def_scene_scripts

	def_callbacks

RocketHideoutB2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; Kanto hack (M6 9w): Yellow's warp table, tile for tile.  1 and 4 are the two
; staircases back up to B1F, 2 is the staircase down to B3F, 3 and 5 the lift.
	warp_event 27,  8, ROCKET_HIDEOUT_B1F, 1
	warp_event 21,  8, ROCKET_HIDEOUT_B3F, 1
	warp_event 24, 19, ROCKET_HIDEOUT_ELEVATOR, 1
	warp_event 21, 22, ROCKET_HIDEOUT_B1F, 4
	warp_event 25, 19, ROCKET_HIDEOUT_ELEVATOR, 2

	def_coord_events

	def_bg_events

	def_object_events
