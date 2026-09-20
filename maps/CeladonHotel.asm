CeladonHotel_MapScripts:
	def_scene_scripts

	def_callbacks

CeladonHotel_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	; Kanto hack (M6 9p): placeholder exit so CELADON CITY's warp 13 is
	; two-way.  The room itself (and its .blk door art) is M6 9t's job.
	warp_event  2,  7, CELADON_CITY, 13
	warp_event  3,  7, CELADON_CITY, 13

	def_coord_events

	def_bg_events

	def_object_events
