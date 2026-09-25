; Kanto hack (M8 11e, docs/M8-SAFFRON.md 0.6 row 11e): SILPH CO.'s lobby,
; ported from Yellow.
;
; Yellow's 1F is almost empty: five warps, no bg_events and exactly ONE object,
; the LINK RECEPTIONIST behind the front desk at (4,2)
; (vendor/pokeyellow/data/maps/objects/SilphCo1F.asm).  There are no Rockets on
; 1F -- TEAM ROCKET's grunts stand outside in the city (11c) and upstairs from
; 2F -- so nothing here blocks the stairs or the lift.  Crystal's own lobby
; (a receptionist plus an OFFICER handing out the UP-GRADE) is gone; see the
; 11e findings for the UP-GRADE note.
;
; The receptionist is NOT at her desk while the building is occupied.  Yellow
; runs SilphCo1F_Script on every map load, checks EVENT_BEAT_SILPH_CO_GIOVANNI
; and ShowObject's her once it is set (vendor/pokeyellow/scripts/SilphCo1F.asm
; lines 3-9).  A GSC object_event carries one flag and it is a HIDE flag, so
; the polarity is inverted: SilphCo1FReceptionistCallback derives
; EVENT_SILPH_CO_1F_RECEPTIONIST_HIDDEN from EVENT_BEAT_SILPH_CO_GIOVANNI on
; every map load, the RocketHideoutB4F pattern (maps/RocketHideoutB4F.asm).
; Because it is derived, 11k's takeover script needs no line for her.

	object_const_def
	const SILPHCO1F_RECEPTIONIST

SilphCo1F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_OBJECTS, SilphCo1FReceptionistCallback

SilphCo1FReceptionistCallback:
	checkevent EVENT_BEAT_SILPH_CO_GIOVANNI
	iftrue .AtDesk
	setevent EVENT_SILPH_CO_1F_RECEPTIONIST_HIDDEN
	endcallback

.AtDesk:
	clearevent EVENT_SILPH_CO_1F_RECEPTIONIST_HIDDEN
	endcallback

; Kanto hack (A251): in the Johto act (ENGINE_POKEGEAR) the receptionist hands
; out Crystal's SILPH CO. UP-GRADE souvenir once (Crystal's 1F OFFICER, whose
; object is not on Yellow's lobby; his lines are kept verbatim).  The Kanto act
; is untouched: she only ever says Yellow's welcome line there.
SilphCo1FReceptionistScript:
	checkflag ENGINE_POKEGEAR
	iffalse .KantoAct
	faceplayer
	opentext
	checkevent EVENT_GOT_UP_GRADE_SILPH_CO
	iftrue .GotUpGrade
	writetext SilphCo1FUpGradeText
	promptbutton
	verbosegiveitem UP_GRADE
	iffalse .NoRoom
	setevent EVENT_GOT_UP_GRADE_SILPH_CO
.GotUpGrade:
	writetext SilphCo1FGotUpGradeText
	waitbutton
.NoRoom:
	closetext
	end

.KantoAct:
	jumptextfaceplayer SilphCo1FReceptionistText

SilphCo1FUpGradeText:
	text "Welcome back to"
	line "SILPH CO.!"

	para "Since you came"
	line "such a long way,"

	para "have this neat"
	line "little souvenir."
	done

SilphCo1FGotUpGradeText:
	text "It's SILPH CO.'s"
	line "latest product."

	para "It's not for sale"
	line "anywhere yet."
	done

SilphCo1FReceptionistText:
	text "Welcome!"

	para "The PRESIDENT is"
	line "in the boardroom"
	cont "on 11F!"
	done

SilphCo1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; Yellow's five warps verbatim (LAST_MAP -> SAFFRON_CITY warp 6, the front
; door 11c numbered).  Warp 5 is behind the west wall and unreachable in
; Yellow too (D84); it is kept so 3F's warp 7 has something to come back to.
	warp_event 10, 17, SAFFRON_CITY, 6
	warp_event 11, 17, SAFFRON_CITY, 6
	warp_event 26,  0, SILPH_CO_2F, 1
	warp_event 20,  0, SILPH_CO_ELEVATOR, 1
	warp_event 16, 10, SILPH_CO_3F, 7 ; inaccessible, as in Yellow

	def_coord_events

	def_bg_events

	def_object_events
	object_event  4,  2, SPRITE_LINK_RECEPTIONIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SilphCo1FReceptionistScript, EVENT_SILPH_CO_1F_RECEPTIONIST_HIDDEN
