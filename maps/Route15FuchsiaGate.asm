	object_const_def
	const ROUTE15FUCHSIAGATE_GUARD

; Kanto hack: Yellow's ROUTE_15_GATE_1F (docs/M7-FUCHSIA.md, 10e).  Yellow's
; gate is a pass-through INSIDE ROUTE 15 -- both door pairs land back on ROUTE
; 15, exactly as ROUTE 11's gate does -- so all four ground-floor warps go to
; ROUTE_15 and the map's only other exit is the stairs to ROUTE_15_GATE_2F.
; Crystal had the west pair going to FUCHSIA_CITY 8/9; those two Fuchsia warps
; at (37,22)/(37,23) are now a one-way Fuchsia -> gate -> ROUTE 15 leftover and
; 10f drops them when it re-cuts FUCHSIA CITY onto Yellow's layout.
;
; The guard is Yellow's SPRITE_GUARD; SPRITE_OFFICER is the stand-in the earlier
; Kanto gates already use, and his Crystal-invented #DEX line is replaced by
; Yellow's own (_Route15Gate1FGuardText), which is what points the player
; upstairs at PROF.OAK's AIDE.
Route15FuchsiaGate_MapScripts:
	def_scene_scripts

	def_callbacks

Route15FuchsiaGateGuardScript:
	jumptextfaceplayer Route15FuchsiaGateGuardText

Route15FuchsiaGateGuardText:
	text "Are you working"
	line "on a #DEX?"

	para "PROF.OAK's AIDE"
	line "came by here."
	done

Route15FuchsiaGate_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  0,  4, ROUTE_15, 1
	warp_event  0,  5, ROUTE_15, 2
	warp_event  7,  4, ROUTE_15, 3
	warp_event  7,  5, ROUTE_15, 4
	warp_event  6,  8, ROUTE_15_GATE_2F, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  4,  1, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route15FuchsiaGateGuardScript, -1
