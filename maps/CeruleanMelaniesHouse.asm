; 6a: geometry stub.  Yellow's CERULEAN_MELANIES_HOUSE (the Bulbasaur gift).
; 6g adds Melanie, Bulbasaur and the happiness gate.
	object_const_def

CeruleanMelaniesHouse_MapScripts:
	def_scene_scripts

	def_callbacks

CeruleanMelaniesHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, CERULEAN_CITY, 2
	warp_event  3,  7, CERULEAN_CITY, 2

	def_coord_events

	def_bg_events

	def_object_events
