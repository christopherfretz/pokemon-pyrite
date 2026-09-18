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
; at (5,8) and (15,18) so the Route 2 gate, Diglett's Cave and the Route 2
; trade house are reachable without CUT. The cut trees at
; (10,40)/(12,46)/(12,50) stay: opening them would let the player skip the
; forest entirely.
; N1d: Crystal's NUGGET HOUSE is gone - Yellow's Route 2 has exactly one
; building, the trade house. Its front blocks (Route2.blk offsets 77/78) are
; now trees, so the door tile (15,15) is a WALL. Warp 1 below is left in the
; list on purpose: CheckWarpTile (hack/engine/overworld/events.asm:330) fires
; on coordinates alone, so the tile had to become unstandable, and deleting
; the entry would renumber warps 2-8, which Route2Gate, both Viridian Forest
; gates, Diglett's Cave and Route2TradeHouse all reference by index.
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

; Kanto hack (N1e, operator ruling "remove Crystal's extra Kanto items",
; AUDIT-NPC-TEXT 3.1 K2): Crystal's four hidden items on this route are gone.
; Yellow's hidden_item_coords.asm lists none for ROUTE_2, and MAX_ETHER /
; FULL_HEAL / FULL_RESTORE / REVIVE before the first badge is Gen-2 loot in a
; Gen-1 route.  Yellow's own two itemballs (MOON_STONE, HP_UP) stay, and so
; does the fruit tree (berries ruling).  The four EVENT_ROUTE_2_HIDDEN_* flags
; are left defined but dead -- the const list is positional.

Route2SignText:
	text "ROUTE 2"
	line "VIRIDIAN CITY -"
	cont "PEWTER CITY"
	done

Route2DiglettsCaveSignText:
	text "DIGLETT'S CAVE"
	done

Route2_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 15, 15, ROUTE_2_NUGGET_HOUSE, 1 ; Kanto hack: unreachable, see above
	warp_event 15, 31, ROUTE_2_GATE, 3
	warp_event 16, 27, ROUTE_2_GATE, 1
	warp_event 17, 27, ROUTE_2_GATE, 2
	warp_event 12,  7, DIGLETTS_CAVE, 1
	warp_event  3, 27, VIRIDIAN_FOREST_NORTH_GATE, 1 ; Kanto hack (docs/M2-FOREST.md)
	warp_event  5, 33, VIRIDIAN_FOREST_SOUTH_GATE, 3 ; Kanto hack (docs/M2-FOREST.md)
	warp_event 15, 11, ROUTE_2_TRADE_HOUSE, 1 ; Kanto hack (docs/M2-PEWTER.md, 4f)

	def_coord_events

	def_bg_events
	bg_event  7, 51, BGEVENT_READ, Route2Sign
	bg_event 11,  9, BGEVENT_READ, Route2DiglettsCaveSign

	def_object_events
	object_event 10, 45, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route2HPUp, EVENT_ROUTE_2_HP_UP
	object_event 14, 50, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route2MoonStone, EVENT_ROUTE_2_MOON_STONE
	object_event 10, 14, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route2FruitTree, -1
