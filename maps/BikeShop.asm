; 6a: geometry stub.  Yellow's BIKE_SHOP.
; 6f adds the clerk, the BIKE_VOUCHER item and the refusal/redemption menus.
	object_const_def

BikeShop_MapScripts:
	def_scene_scripts

	def_callbacks

BikeShop_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, CERULEAN_CITY, 5
	warp_event  3,  7, CERULEAN_CITY, 5

	def_coord_events

	def_bg_events

	def_object_events
