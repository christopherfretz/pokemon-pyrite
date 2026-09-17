; Kanto hack: Mt. Moon B2F, from vendor/pokeyellow/maps/MtMoonB2F.blk and
; vendor/pokeyellow/data/maps/objects/MtMoonB2F.asm (docs/M2-MTMOON.md).
; The fossils, Super Nerd and Team Rocket come in a later step.

MtMoonB2F_MapScripts:
	def_scene_scripts

	def_callbacks

MtMoonB2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 25,  9, MT_MOON_B1F, 2
	warp_event 21, 17, MT_MOON_B1F, 5
	warp_event 15, 27, MT_MOON_B1F, 6
	warp_event  5,  7, MT_MOON_B1F, 7

	def_coord_events

	def_bg_events

	def_object_events
