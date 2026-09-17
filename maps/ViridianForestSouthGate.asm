	object_const_def
	const VIRIDIANFORESTSOUTHGATE_LASS
	const VIRIDIANFORESTSOUTHGATE_TWIN

; Kanto hack: the gate between Route 2's Viridian half and Viridian Forest's
; south end (docs/M2-FOREST.md). Ported from Yellow; SPRITE_GIRL becomes
; SPRITE_LASS and SPRITE_LITTLE_GIRL becomes SPRITE_TWIN. Yellow puts the
; LASS at (8,4), which is a counter tile in Crystal's NorthSouthGate.blk, so
; she stands at (7,4) instead. Warps 1/2 lead into the forest, 3/4 back out
; onto Route 2.
ViridianForestSouthGate_MapScripts:
	def_scene_scripts

	def_callbacks

ViridianForestSouthGateLassScript:
	jumptextfaceplayer ViridianForestSouthGateLassText

ViridianForestSouthGateTwinScript:
	jumptextfaceplayer ViridianForestSouthGateTwinText

ViridianForestSouthGateLassText:
	text "Are you going to"
	line "VIRIDIAN FOREST?"
	cont "Be careful, it's"
	cont "a natural maze!"
	done

ViridianForestSouthGateTwinText:
	text "You have to roam"
	line "far to get new"
	cont "kinds of #MON."

	para "Look for other"
	line "types outside of"
	cont "VIRIDIAN FOREST."
	done

ViridianForestSouthGate_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4,  0, VIRIDIAN_FOREST, 3
	warp_event  5,  0, VIRIDIAN_FOREST, 4
	warp_event  4,  7, ROUTE_2, 7
	warp_event  5,  7, ROUTE_2, 7

	def_coord_events

	def_bg_events

	def_object_events
	object_event  7,  4, SPRITE_LASS, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ViridianForestSouthGateLassScript, -1
	object_event  2,  4, SPRITE_TWIN, SPRITEMOVEDATA_WALK_UP_DOWN, 1, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, ViridianForestSouthGateTwinScript, -1
