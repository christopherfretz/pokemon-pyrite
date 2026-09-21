; Kanto hack: Yellow's ROUTE_16_GATE_2F (docs/M6-CELADON.md, 9y).  9o cut the
; map and its header; this fills in Yellow's two NPCs and two binoculars.
;   (4,2) LITTLE_BOY  -> SPRITE_YOUNGSTER, STAY  (2.3 substitution table)
;   (2,5) LITTLE_GIRL -> SPRITE_TWIN, WALK LEFT_RIGHT
;   (1,2)/(6,2) binoculars, printed only when facing UP.
; Yellow's Route16Gate2F.blk is byte-identical to its Route11Gate2F.blk, so
; data/maps/blocks.asm INCBINs that file twice (the ROUTE 12 GATE 2F precedent).
	object_const_def
	const ROUTE16GATE2F_YOUNGSTER
	const ROUTE16GATE2F_TWIN

Route16Gate2F_MapScripts:
	def_scene_scripts

	def_callbacks

Route16Gate2FYoungsterScript:
	jumptextfaceplayer Route16Gate2FYoungsterText

Route16Gate2FTwinScript:
	jumptextfaceplayer Route16Gate2FTwinText

; GateUpstairsScript_PrintIfFacingUp (vendor/pokeyellow/scripts/Route12Gate2F.asm)
; prints nothing at all when the player reads a binocular tile from the side.
Route16Gate2FLeftBinocularsScript:
	readvar VAR_FACING
	ifnotequal UP, .NotFacingUp
	jumptext Route16Gate2FLeftBinocularsText

.NotFacingUp:
	end

Route16Gate2FRightBinocularsScript:
	readvar VAR_FACING
	ifnotequal UP, .NotFacingUp
	jumptext Route16Gate2FRightBinocularsText

.NotFacingUp:
	end

Route16Gate2FYoungsterText:
	text "I'm going for a"
	line "ride with my girl"
	cont "friend!"
	done

Route16Gate2FTwinText:
	text "We're going"
	line "riding together!"
	done

Route16Gate2FLeftBinocularsText:
	text "Looked into the"
	line "binoculars."

	para "It's CELADON DEPT."
	line "STORE!"
	done

Route16Gate2FRightBinocularsText:
	text "Looked into the"
	line "binoculars."

	para "There's a long"
	line "path over water!"
	done

Route16Gate2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  7,  7, ROUTE_16_GATE, 9

	def_coord_events

	def_bg_events
	bg_event  1,  2, BGEVENT_READ, Route16Gate2FLeftBinocularsScript
	bg_event  6,  2, BGEVENT_READ, Route16Gate2FRightBinocularsScript

	def_object_events
	object_event  4,  2, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route16Gate2FYoungsterScript, -1
	object_event  2,  5, SPRITE_TWIN, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route16Gate2FTwinScript, -1
