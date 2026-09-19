; Kanto hack: Yellow's ROUTE_12_GATE_1F (docs/M5-LAVENDER.md, 8l).  A new map --
; Crystal has no gate on ROUTE 12 at all, because Crystal's ROUTE 12 was only
; the northern half of Yellow's.  The gate is load-bearing geometry: Yellow's
; building severs the bridge at tile rows 16-20, so all LAVENDER -> south
; traffic has to walk through here.
;
; Yellow's gate has exactly one object, the guard at (1,3).  SPRITE_GUARD
; becomes SPRITE_OFFICER, the M4 7d precedent (hack/maps/Route5SaffronGate.asm,
; hack/maps/Route11Gate1F.asm).
	object_const_def
	const ROUTE12GATE1F_OFFICER

Route12Gate1F_MapScripts:
	def_scene_scripts

	def_callbacks

Route12Gate1FGuardScript:
	jumptextfaceplayer Route12Gate1FGuardText

Route12Gate1FGuardText:
	text "There's a lookout"
	line "spot upstairs."
	done

Route12Gate1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4,  0, ROUTE_12, 1
	warp_event  5,  0, ROUTE_12, 2
	warp_event  4,  7, ROUTE_12, 3
	warp_event  5,  7, ROUTE_12, 3 ; Yellow points both south tiles at the same route warp
	warp_event  8,  6, ROUTE_12_GATE_2F, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  1,  3, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route12Gate1FGuardScript, -1
