	object_const_def
	const ROUTE2GATE_OAKS_AIDE
	const ROUTE2GATE_YOUNGSTER

; Kanto hack: Yellow's Route 2 gate (docs/M2-ROUTE2.md). Crystal's flavour-
; text SCIENTIST becomes Yellow's Oak's Aide, who hands over HM05 FLASH once
; the POKeDEX shows ROUTE2GATE_FLASH_DEX_REQUIREMENT owned species, plus the
; YOUNGSTER who talks FLASH up. Yellow's `predef OaksAideScript` is inlined
; here as a normal GSC script; VAR_DEXCAUGHT is GSC's CountSetBits over
; wPokedexCaught (engine/overworld/variables.asm, .CountCaughtMons) and it
; leaves the count in wStringBuffer2 for text_decimal.
DEF ROUTE2GATE_FLASH_DEX_REQUIREMENT EQU 10

Route2Gate_MapScripts:
	def_scene_scripts

	def_callbacks

Route2GateOaksAideScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_HM05_FLASH
	iftrue .GotFlash
	writetext Route2GateOaksAideHiText
	yesorno
	iffalse .ComeBack
	readvar VAR_DEXCAUGHT
	ifless ROUTE2GATE_FLASH_DEX_REQUIREMENT, .NotEnough
	writetext Route2GateOaksAideHereYouGoText
	promptbutton
	verbosegiveitem HM_FLASH
	iffalse .Done
	setevent EVENT_GOT_HM05_FLASH
.GotFlash:
	writetext Route2GateOaksAideFlashExplanationText
	waitbutton
.Done:
	closetext
	end

.NotEnough:
	writetext Route2GateOaksAideUhOhText
	waitbutton
	closetext
	end

.ComeBack:
	writetext Route2GateOaksAideComeBackText
	waitbutton
	closetext
	end

Route2GateYoungsterScript:
	jumptextfaceplayer Route2GateYoungsterText

Route2GateOaksAideHiText:
	text "Hi! Remember me?"
	line "I'm PROF.OAK's"
	cont "AIDE!"

	para "If you caught 10"
	line "kinds of #MON,"
	cont "I'm supposed to"
	cont "give you an HM05!"

	para "So, <PLAYER>! Have"
	line "you caught at"
	cont "least 10 kinds of"
	cont "#MON?"
	done

Route2GateOaksAideUhOhText:
	text "Let's see…"
	line "Uh-oh! You have"
	cont "caught only @"
	text_decimal wStringBuffer2, 1, 3
	text_start
	cont "kinds of #MON!"

	para "You need 10 kinds"
	line "if you want the"
	cont "HM05."
	done

Route2GateOaksAideComeBackText:
	text "Oh. I see."

	para "When you get 10"
	line "kinds, come back"
	cont "for HM05."
	done

Route2GateOaksAideHereYouGoText:
	text "Great! You have"
	line "caught @"
	text_decimal wStringBuffer2, 1, 3
	text " kinds "
	cont "of #MON!"
	cont "Congratulations!"

	para "Here you go!"
	done

Route2GateOaksAideFlashExplanationText:
	text "The HM FLASH"
	line "lights even the"
	cont "darkest dungeons."
	done

Route2GateYoungsterText:
	text "Once a #MON"
	line "learns FLASH, you"
	cont "can get through"
	cont "ROCK TUNNEL."
	done

Route2Gate_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4,  0, ROUTE_2, 3
	warp_event  5,  0, ROUTE_2, 4
	warp_event  4,  7, ROUTE_2, 2
	warp_event  5,  7, ROUTE_2, 2

	def_coord_events

	def_bg_events

	def_object_events
	object_event  2,  4, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route2GateOaksAideScript, -1
	object_event  7,  4, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, Route2GateYoungsterScript, -1
