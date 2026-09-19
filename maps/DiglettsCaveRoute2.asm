	object_const_def
	const DIGLETTSCAVEROUTE2_FISHING_GURU

; Kanto hack: Yellow's DIGLETT'S CAVE north entrance room (docs/M4-VERMILION.md,
; 7c decision (d), populated in 7l).  Yellow's single object is the FISHING GURU
; at (3,3) who wishes for FLASH in ROCK TUNNEL.

DiglettsCaveRoute2_MapScripts:
	def_scene_scripts

	def_callbacks

DiglettsCaveRoute2FishingGuruScript:
	jumptextfaceplayer DiglettsCaveRoute2FishingGuruText

DiglettsCaveRoute2FishingGuruText:
	text "I went to ROCK"
	line "TUNNEL, but it's"
	cont "dark and scary."

	para "If a #MON's"
	line "FLASH could light"
	cont "it up…"
	done

DiglettsCaveRoute2_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, ROUTE_2, 5
	warp_event  3,  7, ROUTE_2, 5
	warp_event  4,  4, DIGLETTS_CAVE, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  3,  3, SPRITE_FISHING_GURU, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, DiglettsCaveRoute2FishingGuruScript, -1
