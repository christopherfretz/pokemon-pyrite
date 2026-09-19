; Kanto hack: Yellow's ROUTE_12_GATE_2F (docs/M5-LAVENDER.md, 8l).  A new map.
; Its .blk is byte-for-byte Yellow's Route11Gate2F.blk -- Yellow shares one 2F
; layout across every east-west gate -- so data/maps/blocks.asm INCBINs that
; file for both maps rather than shipping a duplicate.
;
; Yellow has one NPC and the two binoculars:
;   (3,4) BRUNETTE_GIRL, WALK UP_DOWN -- gives TM39 SWIFT once.  Crystal has no
;         BRUNETTE_GIRL sprite; SPRITE_LASS is the standing substitution
;         (docs/AUDIT-NPC-TEXT.md:1577).
;   (1,2)/(6,2) binoculars.  Yellow's GateUpstairsScript_PrintIfFacingUp
;         (vendor/pokeyellow/scripts/Route12Gate2F.asm:68-79) prints nothing at
;         all unless the player is facing UP, and both tiles are reachable from
;         the side, so the readvar VAR_FACING guard below is required to match.
;
; Two deviations from Yellow, both the 7l ROUTE 11 GATE 2F precedent:
;   * the one-time flag is a GSC event (EVENT_GOT_TM_SWIFT_FROM_GIRL, renamed
;     in place from the dead EVENT_ROUTE_12_HIDDEN_ELIXER) rather than Yellow's
;     EVENT_GOT_TM39;
;   * `verbosegiveitem` prints GSC's own "no room" line, so Yellow's
;     _Route12Gate2FBrunetteGirlTM39NoRoomText has no port.
	object_const_def
	const ROUTE12GATE2F_LASS

Route12Gate2F_MapScripts:
	def_scene_scripts

	def_callbacks

Route12Gate2FGirlScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_TM_SWIFT_FROM_GIRL
	iftrue .GotItem
	writetext Route12Gate2FGirlYouCanHaveThisText
	promptbutton
	verbosegiveitem TM_SWIFT
	iffalse .Done
	setevent EVENT_GOT_TM_SWIFT_FROM_GIRL
	closetext
	end

.GotItem:
	writetext Route12Gate2FGirlTMSwiftExplanationText
	waitbutton
.Done:
	closetext
	end

Route12Gate2FLeftBinocularsScript:
	readvar VAR_FACING
	ifnotequal UP, .NotFacingUp
	jumptext Route12Gate2FLeftBinocularsText

.NotFacingUp:
	end

Route12Gate2FRightBinocularsScript:
	readvar VAR_FACING
	ifnotequal UP, .NotFacingUp
	jumptext Route12Gate2FRightBinocularsText

.NotFacingUp:
	end

Route12Gate2FGirlYouCanHaveThisText:
	text "My #MON's"
	line "ashes are stored"
	cont "in #MON TOWER."

	para "You can have this"
	line "TM. I don't need"
	cont "it anymore…"
	done

Route12Gate2FGirlTMSwiftExplanationText:
	text "TM39 is a move"
	line "called SWIFT."

	para "It's very accurate,"
	line "so use it during"
	cont "battles you can't"
	cont "afford to lose."
	done

Route12Gate2FLeftBinocularsText:
	text "Looked into the"
	line "binoculars."

	para "A man fishing!"
	done

Route12Gate2FRightBinocularsText:
	text "Looked into the"
	line "binoculars."

	para "It's #MON TOWER!"
	done

Route12Gate2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  7,  7, ROUTE_12_GATE_1F, 5

	def_coord_events

	def_bg_events
	bg_event  1,  2, BGEVENT_READ, Route12Gate2FLeftBinocularsScript
	bg_event  6,  2, BGEVENT_READ, Route12Gate2FRightBinocularsScript

	def_object_events
	object_event  3,  4, SPRITE_LASS, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route12Gate2FGirlScript, -1
