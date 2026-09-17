; 6a: geometry stub.  Yellow's CERULEAN_BADGE_HOUSE, the pass-through corridor
; that reaches Cerulean Cave: warp 1 is the hole in the back wall, warps 2/3 the
; front door.  6k gives it the badge-counting man and wires warp 1's other side
; to Cerulean Cave.
	object_const_def

CeruleanBadgeHouse_MapScripts:
	def_scene_scripts

	def_callbacks

CeruleanBadgeHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  0, CERULEAN_CITY, 10 ; hole in the back wall
	warp_event  2,  7, CERULEAN_CITY, 9
	warp_event  3,  7, CERULEAN_CITY, 9

	def_coord_events

	def_bg_events

	def_object_events
