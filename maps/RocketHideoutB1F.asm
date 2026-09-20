RocketHideoutB1F_MapScripts:
	def_scene_scripts

	def_callbacks

RocketHideoutB1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; Kanto hack (M6 9u): Yellow's warp table, so the GAME CORNER staircase has
; somewhere to land and a way back.  Only warp 2 is live -- the rest sit on the
; skeleton map's plain floor and can never fire until M6 9w builds the hideout.
	warp_event 23,  2, ROCKET_HIDEOUT_B2F, 1
	warp_event 21,  2, CELADON_GAME_CORNER, 3
	warp_event 24, 19, ROCKET_HIDEOUT_ELEVATOR, 1
	warp_event 21, 24, ROCKET_HIDEOUT_B2F, 4
	warp_event 25, 19, ROCKET_HIDEOUT_ELEVATOR, 2

	def_coord_events

	def_bg_events

	def_object_events
