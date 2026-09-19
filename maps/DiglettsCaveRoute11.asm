	object_const_def
	const DIGLETTSCAVEROUTE11_GENTLEMAN

; Kanto hack: Yellow's DIGLETT'S CAVE south entrance room (docs/M4-VERMILION.md,
; 7c decision (d), populated in 7l).  Yellow's single object is a GAMBLER at
; (2,3); Crystal has no GAMBLER sprite, so this is SPRITE_GENTLEMAN, the M2
; Museum/Pewter precedent (docs/M2-PEWTER.md:477-478).

DiglettsCaveRoute11_MapScripts:
	def_scene_scripts

	def_callbacks

DiglettsCaveRoute11GentlemanScript:
	jumptextfaceplayer DiglettsCaveRoute11GentlemanText

DiglettsCaveRoute11GentlemanText:
	text "What a surprise!"
	line "DIGLETTs dug this"
	cont "long tunnel!"

	para "It goes right to"
	line "VIRIDIAN CITY!"
	done

DiglettsCaveRoute11_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, ROUTE_11, 5
	warp_event  3,  7, ROUTE_11, 5
	warp_event  4,  4, DIGLETTS_CAVE, 2

	def_coord_events

	def_bg_events

	def_object_events
	object_event  2,  3, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, DiglettsCaveRoute11GentlemanScript, -1
