	object_const_def
	const ROUTE2_POKE_BALL1
	const ROUTE2_POKE_BALL2
	const ROUTE2_FRUIT_TREE

; Kanto hack: Yellow's Route 2 (docs/M2-ROUTE2.md, docs/M2-FOREST.md). Yellow
; has NO trainers here - the bug catchers all live in Viridian Forest - so
; Crystal's three
; Bug Catchers (ROB/ED/DOUG) are gone, and the four GSC itemballs collapse to
; Yellow's two: HP_UP and MOON_STONE, both south of the Route 2 gate.
; Crystal's four hidden items are gone (N1e, below).
; 4b carved the two Viridian Forest gate doorways into Route2.blk - warps 6
; (3,27, Pewter half) and 7 (5,33, Viridian half).
; VF4 (docs/M2-FOREST.md "## VF4 findings"): the north gate's warp moved to
; its entry carpet ABOVE the roof, (4,23) = warp 6 and (5,23) = warp 9, as
; Yellow's (3,11); the drawn front door at (3,27) no longer warps.
; P5 (docs/M2-PEWTER-CITY.md "## P5 findings"): 4b had also opened the cut
; trees at (5,8) and (15,18), which let a no-CUT player walk from Pewter into
; Diglett's Cave and out at Vermilion before Brock.  Both are back (block $32
; at .blk offsets 42/97), matching Yellow's (5,10)/(15,22): the cave mouth
; and trade house sit behind the first tree, the gate's north door behind the
; second, so the whole east side needs HM01 CUT as in Yellow.  The cut trees
; at (10,40)/(12,46)/(12,50) stay too.
; P5b: HP_UP moved from Crystal-side (10,45), open west road, to Yellow's own
; (13,45), which here too is the east strip below the gate's south door -
; CUT-gated as in Yellow.
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
	warp_event 16, 27, ROUTE_2_GATE, 2 ; M1: Yellow's gate has only ONE north door tile (the west half is wall); warp 1 is Yellow's dead duplicate
	warp_event 17, 27, ROUTE_2_GATE, 2
	warp_event 12,  7, DIGLETTS_CAVE_ROUTE_2, 1 ; Kanto hack (docs/M4-VERMILION.md, 7c)
	warp_event  4, 23, VIRIDIAN_FOREST_NORTH_GATE, 2 ; Kanto hack (docs/M2-FOREST.md): VF4, the gate's north entry carpet above its roof, as Yellow's (3,11); the front door at (3,27) is art only. Both carpet tiles -> gate warp 2: the gate's (4,0) is wall (M1, as ROUTE_2_GATE)
	warp_event  5, 33, VIRIDIAN_FOREST_SOUTH_GATE, 3 ; Kanto hack (docs/M2-FOREST.md)
	warp_event 15, 11, ROUTE_2_TRADE_HOUSE, 1 ; Kanto hack (docs/M2-PEWTER.md, 4f)
	warp_event  5, 23, VIRIDIAN_FOREST_NORTH_GATE, 2 ; Kanto hack: VF4, appended so warps 7/8 keep their ids

	def_coord_events

	def_bg_events
	bg_event  7, 51, BGEVENT_READ, Route2Sign
	bg_event 11,  9, BGEVENT_READ, Route2DiglettsCaveSign

	def_object_events
	object_event 13, 45, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route2HPUp, EVENT_ROUTE_2_HP_UP
	object_event 14, 50, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route2MoonStone, EVENT_ROUTE_2_MOON_STONE
	object_event 10, 14, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route2FruitTree, -1
