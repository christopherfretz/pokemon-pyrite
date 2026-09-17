; 6a: geometry stub.  Yellow's CERULEAN_TRASHED_HOUSE (the robbed house, whose
; back wall the Rocket thief smashes through).  Warp 3 is that hole.
; 6c replaces this with the Fishing Guru, the girl and the TM_DIG branch.
	object_const_def

CeruleanTrashedHouse_MapScripts:
	def_scene_scripts

	def_callbacks

CeruleanTrashedHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, CERULEAN_CITY, 1
	warp_event  3,  7, CERULEAN_CITY, 1
	warp_event  2,  0, CERULEAN_CITY, 8 ; hole in the back wall (Yellow: 3, 0)

	def_coord_events

	def_bg_events

	def_object_events
