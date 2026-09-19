; Kanto hack: Yellow's UNDERGROUND_PATH_WEST_EAST (docs/M5-LAVENDER.md, 8b/8k).
; No objects.  8b's header claimed "no hidden items" -- that was wrong: Yellow
; hides two here (data/events/hidden_events.asm:193-196, a NUGGET at (12,2) and
; an ELIXER at (21,5)), and 8k restores them.  GSC's BGEVENT_ITEM is
; facing-triggered, not step-on, which is Gen 1's behaviour too.
UndergroundPathWestEast_MapScripts:
	def_scene_scripts

	def_callbacks

UndergroundPathWestEastHiddenNugget:
	hiddenitem NUGGET, EVENT_UNDERGROUND_PATH_WEST_EAST_HIDDEN_NUGGET

UndergroundPathWestEastHiddenElixer:
	hiddenitem ELIXER, EVENT_UNDERGROUND_PATH_WEST_EAST_HIDDEN_ELIXER

UndergroundPathWestEast_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  5, ROUTE_7_UNDERGROUND_PATH_ENTRANCE, 3
	warp_event 47,  2, ROUTE_8_UNDERGROUND_PATH_ENTRANCE, 3

	def_coord_events

	def_bg_events
	bg_event 12,  2, BGEVENT_ITEM, UndergroundPathWestEastHiddenNugget
	bg_event 21,  5, BGEVENT_ITEM, UndergroundPathWestEastHiddenElixer

	def_object_events
