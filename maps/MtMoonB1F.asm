; Kanto hack: Mt. Moon B1F, from vendor/pokeyellow/maps/MtMoonB1F.blk and
; vendor/pokeyellow/data/maps/objects/MtMoonB1F.asm (docs/M2-MTMOON.md).
; 5e re-checked Yellow: B1F really is the connective floor and nothing else -
; its object file has eight warps and empty def_bg_events / def_object_events,
; and neither data/events/hidden_item_coords.asm nor hidden_events.asm lists a
; single MT_MOON_B1F entry (Mt. Moon's only two hidden items are on B2F, which
; is 5f's). So this map stays object-free; 5e only gives it a wild table
; (def_grass_wildmons MT_MOON_B1F in data/wild/kanto_grass.asm).

MtMoonB1F_MapScripts:
	def_scene_scripts

	def_callbacks

MtMoonB1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  5,  5, MT_MOON_1F, 3
	warp_event 17, 11, MT_MOON_B2F, 1
	warp_event 25,  9, MT_MOON_1F, 4
	warp_event 25, 15, MT_MOON_1F, 5
	warp_event 21, 17, MT_MOON_B2F, 2
	warp_event 13, 27, MT_MOON_B2F, 3
	warp_event 23,  3, MT_MOON_B2F, 4
	warp_event 27,  3, ROUTE_4, 3

	def_coord_events

	def_bg_events

	def_object_events
