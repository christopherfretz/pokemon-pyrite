	object_const_def
	const ROUTE2_POKE_BALL1
	const ROUTE2_POKE_BALL2
	const ROUTE2_FRUIT_TREE

; Kanto hack: Yellow's Route 2 (docs/M2-ROUTE2.md, docs/M2-FOREST.md). Yellow
; has NO trainers here - the bug catchers all live in Viridian Forest - so
; Crystal's three
; Bug Catchers (ROB/ED/DOUG) are gone, and the four GSC itemballs collapse to
; Yellow's two: HP_UP and MOON_STONE, both south of the Route 2 gate.
; The hidden items are Crystal's and stay.
; 4b carved the two Viridian Forest gate doorways into Route2.blk - warps 6
; (3,27, Pewter half) and 7 (5,33, Viridian half) - and opened the cut trees
; at (5,8) and (15,18) so the Route 2 gate, Diglett's Cave and the Nugget
; House are reachable without CUT. The cut trees at (10,40)/(12,46)/(12,50)
; stay: opening them would let the player skip the forest entirely.
Route2_MapScripts:
	def_scene_scripts

	def_callbacks

Route2Sign:
	jumptext Route2SignText

Route2DiglettsCaveSign:
	jumptext Route2DiglettsCaveSignText

Route2HPUp:
	itemball HP_UP

Route2MoonStone:
	itemball MOON_STONE

Route2FruitTree:
	fruittree FRUITTREE_ROUTE_2

Route2HiddenMaxEther:
	hiddenitem MAX_ETHER, EVENT_ROUTE_2_HIDDEN_MAX_ETHER

Route2HiddenFullHeal:
	hiddenitem FULL_HEAL, EVENT_ROUTE_2_HIDDEN_FULL_HEAL

Route2HiddenFullRestore:
	hiddenitem FULL_RESTORE, EVENT_ROUTE_2_HIDDEN_FULL_RESTORE

Route2HiddenRevive:
	hiddenitem REVIVE, EVENT_ROUTE_2_HIDDEN_REVIVE

Route2SignText:
	text "ROUTE 2"

	para "VIRIDIAN CITY -"
	line "PEWTER CITY"
	done

Route2DiglettsCaveSignText:
	text "DIGLETT'S CAVE"
	done

Route2_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 15, 15, ROUTE_2_NUGGET_HOUSE, 1
	warp_event 15, 31, ROUTE_2_GATE, 3
	warp_event 16, 27, ROUTE_2_GATE, 1
	warp_event 17, 27, ROUTE_2_GATE, 2
	warp_event 12,  7, DIGLETTS_CAVE, 3
	warp_event  3, 27, VIRIDIAN_FOREST_NORTH_GATE, 1 ; Kanto hack (docs/M2-FOREST.md)
	warp_event  5, 33, VIRIDIAN_FOREST_SOUTH_GATE, 3 ; Kanto hack (docs/M2-FOREST.md)

	def_coord_events

	def_bg_events
	bg_event  7, 51, BGEVENT_READ, Route2Sign
	bg_event 11,  9, BGEVENT_READ, Route2DiglettsCaveSign
	bg_event  7, 23, BGEVENT_ITEM, Route2HiddenMaxEther
	bg_event  4, 14, BGEVENT_ITEM, Route2HiddenFullHeal
	bg_event  4, 27, BGEVENT_ITEM, Route2HiddenFullRestore
	bg_event 11, 30, BGEVENT_ITEM, Route2HiddenRevive

	def_object_events
	object_event 10, 45, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route2HPUp, EVENT_ROUTE_2_HP_UP
	object_event 14, 50, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route2MoonStone, EVENT_ROUTE_2_MOON_STONE
	object_event 10, 14, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route2FruitTree, -1
