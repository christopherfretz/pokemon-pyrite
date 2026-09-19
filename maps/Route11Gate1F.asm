; Kanto hack: Yellow's ROUTE_11_GATE_1F (docs/M4-VERMILION.md, 7l).
; Yellow's gate has exactly one object, the guard at (4,1), who talks about the
; LAVENDER TOWN name rater.  SPRITE_GUARD becomes SPRITE_OFFICER, the M4 7d
; precedent (hack/maps/Route5SaffronGate.asm).
	object_const_def
	const ROUTE11GATE1F_OFFICER

Route11Gate1F_MapScripts:
	def_scene_scripts

	def_callbacks

Route11Gate1FGuardScript:
	jumptextfaceplayer Route11Gate1FGuardText

Route11Gate1FGuardText:
	text "When you catch"
	line "lots of #MON,"
	cont "isn't it hard to"
	cont "think up names?"

	para "In LAVENDER TOWN,"
	line "there's a man who"
	cont "rates #MON"
	cont "nicknames."

	para "He'll help you"
	line "rename them too!"
	done

Route11Gate1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  0,  4, ROUTE_11, 1
	warp_event  0,  5, ROUTE_11, 2
	warp_event  7,  4, ROUTE_11, 3
	warp_event  7,  5, ROUTE_11, 4
	warp_event  6,  8, ROUTE_11_GATE_2F, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  4,  1, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route11Gate1FGuardScript, -1
