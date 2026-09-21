	object_const_def
	const ROUTE15GATE2F_OAKS_AIDE

; Kanto hack: Yellow's ROUTE_15_GATE_2F (docs/M7-FUCHSIA.md, 10e).  10a
; registered the map on the Route11Gate2F INCBIN (the two gate upper floors are
; the same 8x8 room); 10e fills it in.  Yellow has one NPC and the two
; binoculars:
;   (4,2) SCIENTIST, STAY DOWN -- PROF.OAK's AIDE, hands over EXP.ALL once the
;         POKeDEX shows 50 owned species.  Yellow's `predef OaksAideScript` is
;         inlined as a normal GSC script, the same way 7l did it for ROUTE 11
;         GATE 2F's ITEMFINDER aide: VAR_DEXCAUGHT is GSC's CountSetBits over
;         wPokedexCaught and it leaves the count in wStringBuffer2 for
;         text_decimal.
;   (1,2) the LEFT binoculars.  Yellow makes these a hidden event rather than a
;         sign (vendor/pokeyellow/data/events/hidden_events.asm:239,
;         engine/events/hidden_events/route_15_binoculars.asm): it prints the
;         text, then plays ARTICUNO's cry and draws its front sprite in a box.
;         GSC's pokepic window and its textbox cannot share the screen, so the
;         picture follows the text instead of sitting beside it.
;   (6,2) the RIGHT binoculars, Yellow's plain "small island" text.
DEF ROUTE15GATE2F_EXP_ALL_DEX_REQUIREMENT EQU 50

Route15Gate2F_MapScripts:
	def_scene_scripts

	def_callbacks

Route15Gate2FOaksAideScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_EXP_ALL
	iftrue .GotExpAll
	writetext Route15Gate2FOaksAideHiText
	yesorno
	iffalse .ComeBack
	readvar VAR_DEXCAUGHT
	ifless ROUTE15GATE2F_EXP_ALL_DEX_REQUIREMENT, .NotEnough
	writetext Route15Gate2FOaksAideHereYouGoText
	promptbutton
	verbosegiveitem EXP_ALL
	iffalse .Done
	setevent EVENT_GOT_EXP_ALL
.GotExpAll:
	writetext Route15Gate2FOaksAideExpAllText
	waitbutton
.Done:
	closetext
	end

.NotEnough:
	writetext Route15Gate2FOaksAideUhOhText
	waitbutton
	closetext
	end

.ComeBack:
	writetext Route15Gate2FOaksAideComeBackText
	waitbutton
	closetext
	end

; Kanto hack (M4 audit ruling, kept here): Yellow prints the binoculars only
; when the player is facing UP -- the hidden event above bails on
; `cp SPRITE_FACING_UP / ret nz`, and the right-hand sign runs through
; GateUpstairsScript_PrintIfFacingUp.  Both binocular tiles are WALL, but the
; tiles left and right of them are floor in both games, so the side approach is
; reachable and must stay silent.
Route15Gate2FLeftBinocularsScript:
	readvar VAR_FACING
	ifnotequal UP, .NotFacingUp
	opentext
	writetext Route15Gate2FLeftBinocularsText
	waitbutton
	closetext
	pokepic ARTICUNO
	cry ARTICUNO
	waitbutton
	closepokepic
	end

.NotFacingUp:
	end

Route15Gate2FRightBinocularsScript:
	readvar VAR_FACING
	ifnotequal UP, .NotFacingUp
	jumptext Route15Gate2FRightBinocularsText

.NotFacingUp:
	end

; Yellow's shared _OaksAideHiText, with hOaksAideRequirement resolved to 50 and
; wOaksAideRewardItemName to EXP.ALL.
Route15Gate2FOaksAideHiText:
	text "Hi! Remember me?"
	line "I'm PROF.OAK's"
	cont "AIDE!"

	para "If you caught 50"
	line "kinds of #MON,"
	cont "I'm supposed to"
	cont "give you an"
	cont "EXP.ALL!"

	para "So, <PLAYER>! Have"
	line "you caught at"
	cont "least 50 kinds of"
	cont "#MON?"
	done

Route15Gate2FOaksAideUhOhText:
	text "Let's see…"
	line "Uh-oh! You have"
	cont "caught only @"
	text_decimal wStringBuffer2, 1, 3
	text_start
	cont "kinds of #MON!"

	para "You need 50 kinds"
	line "if you want the"
	cont "EXP.ALL."
	done

Route15Gate2FOaksAideComeBackText:
	text "Oh. I see."

	para "When you get 50"
	line "kinds, come back"
	cont "for EXP.ALL."
	done

Route15Gate2FOaksAideHereYouGoText:
	text "Great! You have"
	line "caught @"
	text_decimal wStringBuffer2, 1, 3
	text " kinds "
	cont "of #MON!"
	cont "Congratulations!"

	para "Here you go!"
	done

; Yellow's _Route15Gate2FOaksAideExpAllText.
Route15Gate2FOaksAideExpAllText:
	text "EXP.ALL gives"
	line "EXP points to all"
	cont "the #MON with"
	cont "you, even if they"
	cont "don't fight."

	para "It does, however,"
	line "reduce the amount"
	cont "of EXP for each"
	cont "#MON."

	para "If you don't need"
	line "it, you should "
	cont "store it via PC."
	done

; Yellow's _Route15UpstairsBinocularsText.
Route15Gate2FLeftBinocularsText:
	text "Looked into the"
	line "binoculars…"

	para "A large, shining"
	line "bird is flying"
	cont "toward the sea."
	done

; Yellow's _Route15Gate2FBinocularsText.
Route15Gate2FRightBinocularsText:
	text "Looked into the"
	line "binoculars."

	para "It looks like a"
	line "small island!"
	done

Route15Gate2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  7,  7, ROUTE_15_FUCHSIA_GATE, 5

	def_coord_events

	def_bg_events
	bg_event  1,  2, BGEVENT_READ, Route15Gate2FLeftBinocularsScript
	bg_event  6,  2, BGEVENT_READ, Route15Gate2FRightBinocularsScript

	def_object_events
	object_event  4,  2, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route15Gate2FOaksAideScript, -1
