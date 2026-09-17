	object_const_def
	const VIRIDIANFORESTNORTHGATE_SUPER_NERD
	const VIRIDIANFORESTNORTHGATE_GRAMPS

; Kanto hack: the gate between Viridian Forest's north end and Route 2's
; Pewter half (docs/M2-FOREST.md). Ported from Yellow: its two NPCs, their
; text and their tiles are Yellow's. It shares Crystal's NorthSouthGate.blk,
; so both doors are on the map's north and south edges. The forest is south of
; this gate and Route 2's Pewter half is north of it, so warps 1/2 (the north
; door) lead out onto Route 2 and warps 3/4 (the south door) back into the
; forest -- walking north through the building really does walk north.
ViridianForestNorthGate_MapScripts:
	def_scene_scripts

	def_callbacks

ViridianForestNorthGateSuperNerdScript:
	jumptextfaceplayer ViridianForestNorthGateSuperNerdText

ViridianForestNorthGateGrampsScript:
	jumptextfaceplayer ViridianForestNorthGateGrampsText

ViridianForestNorthGateSuperNerdText:
	text "Many #MON live"
	line "only in forests"
	cont "and caves."

	para "You need to look"
	line "everywhere to get"
	cont "different kinds!"
	done

ViridianForestNorthGateGrampsText:
	text "Have you noticed"
	line "the bushes on the"
	cont "roadside?"

	para "They can be cut"
	line "down by a special"
	cont "#MON move."
	done

ViridianForestNorthGate_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4,  0, ROUTE_2, 6
	warp_event  5,  0, ROUTE_2, 6
	warp_event  4,  7, VIRIDIAN_FOREST, 1
	warp_event  5,  7, VIRIDIAN_FOREST, 1 ; (2,0) in the forest is walled off; both doors land on (1,0)

	def_coord_events

	def_bg_events

	def_object_events
	object_event  3,  2, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, ViridianForestNorthGateSuperNerdScript, -1
	object_event  2,  5, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, ViridianForestNorthGateGrampsScript, -1
