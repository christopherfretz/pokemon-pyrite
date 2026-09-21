; Kanto hack: Yellow's ROUTE_18_GATE_2F (docs/M6-CELADON.md, 9aa).  9o cut the
; map and its header; this fills in Yellow's one NPC and its two binoculars:
;   (4,2) COOK, WALK LEFT_RIGHT -- the in-game trade TRADE_FOR_SPIKE
;         (TANGELA for PARASECT, nicknamed SPIKE), ported as NPC_TRADE_SPIKE.
;         SPRITE_COOK does not exist in Crystal; SPRITE_CLERK is the standing
;         substitution (docs/M4-VERMILION.md 5.4, and 9t's diner COOK).
;   (1,2)/(6,2) binoculars, printed only when facing UP.
; Yellow's Route18Gate2F.blk is byte-identical to its Route11Gate2F.blk, so
; data/maps/blocks.asm INCBINs that file again (the ROUTE 12/16 GATE 2F
; precedent) and the 9o placeholder .blk is deleted.
	object_const_def
	const ROUTE18GATE2F_COOK

Route18Gate2F_MapScripts:
	def_scene_scripts

	def_callbacks

Route18Gate2FCookScript:
	faceplayer
	opentext
	trade NPC_TRADE_SPIKE
	waitbutton
	closetext
	end

; GateUpstairsScript_PrintIfFacingUp (vendor/pokeyellow/scripts/Route12Gate2F.asm)
; prints nothing at all when the player reads a binocular tile from the side.
Route18Gate2FLeftBinocularsScript:
	readvar VAR_FACING
	ifnotequal UP, .NotFacingUp
	jumptext Route18Gate2FLeftBinocularsText

.NotFacingUp:
	end

Route18Gate2FRightBinocularsScript:
	readvar VAR_FACING
	ifnotequal UP, .NotFacingUp
	jumptext Route18Gate2FRightBinocularsText

.NotFacingUp:
	end

Route18Gate2FLeftBinocularsText:
	text "Looked into the"
	line "binoculars."

	para "PALLET TOWN is in"
	line "the west!"
	done

Route18Gate2FRightBinocularsText:
	text "Looked into the"
	line "binoculars."

	para "There are people"
	line "swimming!"
	done

Route18Gate2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  7,  7, ROUTE_17_ROUTE_18_GATE, 5

	def_coord_events

	def_bg_events
	bg_event  1,  2, BGEVENT_READ, Route18Gate2FLeftBinocularsScript
	bg_event  6,  2, BGEVENT_READ, Route18Gate2FRightBinocularsScript

	def_object_events
	object_event  4,  2, SPRITE_CLERK, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route18Gate2FCookScript, -1
