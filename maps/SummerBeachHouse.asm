; Kanto hack (M12a, docs/M12-STRETCH.md "## M12a findings"): Yellow's SUMMER
; BEACH HOUSE on ROUTE 19 (vendor/pokeyellow/{data/maps/objects,scripts,text}/
; SummerBeachHouse.asm), cut wholesale onto Yellow's own 7x4 .blk and the new
; TILESET_KANTO_BEACH_HOUSE (scripts/kanto_beach_house_blk.py).  ROUTE 19's
; door at (5,9) is its warp 1 (this closes D107); warps 1 and 2 here are the
; exit mat on the bottom row, whose collision the generator overrides to
; WARP_CARPET_DOWN (block $0b).
;
; M12a built the shell as an *unqualified* Yellow player sees it; M12b-4 wires
; Yellow's qualified branches (the SURFIN' DUDE's minigame offer, the posters'
; SURFING TIPs, the PRINTER's Hi-Score card) under the Q5 gate the operator
; chose: Yellow's Virtual Console rule, "the starter PIKACHU is in the party"
; (Yellow's BIT_PIKACHU_SPAWN_STARTER = IsStarterPikachuAliveInOurParty), no
; SURF needed -- our PIKACHU can never learn SURF.  The unqualified branches
; are M12a's, unchanged.  Yellow's own gates: the dude and the PRINTER test
; BIT_PIKACHU_SPAWN_SURFING, patched to BIT_PIKACHU_SPAWN_STARTER on the
; Virtual Console; the three posters test BIT_PIKACHU_SPAWN_SURFING only (the
; VC patch leaves them alone).  Here all five use the one gate, so the TIPs
; are readable too (docs/M12-STRETCH.md "## M12b-4 findings", deviations).
; Yellow's saved wPikachuMapScriptFlags bits 0 and 1 are the event flags
; EVENT_SURFIN_DUDE_OFFERED and EVENT_SURFING_MINIGAME_SURF_SELECT.

	object_const_def
	const SUMMERBEACHHOUSE_SURFIN_DUDE
	const SUMMERBEACHHOUSE_PIKACHU

SummerBeachHouse_MapScripts:
	def_scene_scripts

	def_callbacks

SummerBeachHouseSurfinDudeScript:
; Yellow's SummerBeachHouseSurfinDudeText (scripts/SummerBeachHouse.asm).
	faceplayer
	opentext
	callasm SummerBeachHouseCheckStarterPikachu
	iffalse .Unqualified
	checkevent EVENT_SURFIN_DUDE_OFFERED
	setevent EVENT_SURFIN_DUDE_OFFERED
	iftrue .WannaGoSurf
	writetext SummerBeachHouseSurfinDudeOfferText
	sjump .YesNo

.WannaGoSurf:
	writetext SummerBeachHouseSurfinDudeWannaGoText
.YesNo:
	yesorno
	iffalse .Declined
	; Yellow: wDoNotWaitForButtonPressAfterDisplayingText, the minigame, then
	; set BIT_PIKACHU_MAP_SURF_SELECT; no more text.
	special SurfingPikachuMinigame
	setevent EVENT_SURFING_MINIGAME_SURF_SELECT
	closetext
	end

.Declined:
	writetext SummerBeachHouseSurfinDudeDeclineText
	waitbutton
	closetext
	end

.Unqualified:
	; Yellow's SurfinDudeText4 (M12a):
	writetext SummerBeachHouseSurfinDudeText
	waitbutton
	closetext
	end

SummerBeachHousePikachuScript:
; Yellow: PrintText, then PlayCry PIKACHU + WaitForSoundToFinish, box still up.
	faceplayer
	opentext
	writetext SummerBeachHousePikachuText
	cry PIKACHU
	waitsfx
	waitbutton
	closetext
	end

SummerBeachHousePoster1Script:
	callasm SummerBeachHouseCheckStarterPikachu
	iftrue .Qualified
	jumptext SummerBeachHousePoster1Text
.Qualified:
	jumptext SummerBeachHousePoster1QualifiedText

SummerBeachHousePoster2Script:
	callasm SummerBeachHouseCheckStarterPikachu
	iftrue .Qualified
	jumptext SummerBeachHousePoster2Text
.Qualified:
	jumptext SummerBeachHousePoster2QualifiedText

SummerBeachHousePoster3Script:
	callasm SummerBeachHouseCheckStarterPikachu
	iftrue .Qualified
	jumptext SummerBeachHousePoster3Text
.Qualified:
	jumptext SummerBeachHousePoster3QualifiedText

SummerBeachHousePrinterScript:
; Yellow's SummerBeachHousePrinterText (scripts/SummerBeachHouse_2.asm).
	callasm SummerBeachHouseCheckStarterPikachu
	iffalse .Unqualified
	opentext
	writetext SummerBeachHousePrinterSaysText
	waitbutton
	checkevent EVENT_SURFING_MINIGAME_SURF_SELECT
	iffalse .done
	writetext SummerBeachHousePrinterHiScoreText
	yesorno
	iftrue .Print
	; NO: the card on screen until A or B
	special SurfingHiScoreCard
.done
	closetext
	end

.Print:
	special PrintSurfingHiScore
	iftrue .PrintError
	writetext SummerBeachHousePrintCompletedText
	waitbutton
	closetext
	end

.PrintError:
	writetext SummerBeachHousePrintErrorText
	waitbutton
	closetext
	end

.Unqualified:
	; Yellow's PrinterText1 (M12a):
	jumptext SummerBeachHousePrinterText

SummerBeachHouseCheckStarterPikachu:
; The Q5 gate: wScriptVar = TRUE if the starter PIKACHU is in the party and
; not fainted -- IsStarterPikachuAliveInParty (engine/overworld/follower.asm),
; Yellow's IsStarterPikachuAliveInOurParty, which is what sets
; BIT_PIKACHU_SPAWN_STARTER.
	farcall IsStarterPikachuAliveInParty
	ld a, FALSE
	jr nc, .done
	ld a, TRUE
.done
	ld [wScriptVar], a
	ret

SummerBeachHouseSurfinDudeText:
	text "Dogs and burgers"
	line "on special today!"
	done

SummerBeachHouseSurfinDudeOfferText:
	text "Whoa!"

	para "Your PIKACHU knows"
	line "how to SURF! So,"
	cont "I'm not alone…"

	para "Great! You earned"
	line "the right to SURF"
	cont "with the DUDE!"

	para "Give it a go?"
	done

SummerBeachHouseSurfinDudeDeclineText:
	text "Come SURF anytime,"
	line "my friend!"
	done

SummerBeachHouseSurfinDudeWannaGoText:
	text "Wanna go SURF?"
	done

SummerBeachHousePikachuText:
	text "PIKACHU: Pikaa"
	done

SummerBeachHousePoster1Text:
	text "30 years of waves!"
	line "SURFIN' DUDE"
	done

SummerBeachHousePoster2Text:
	text "SUMMER BEACH HOUSE"
	line "#MON welcome!"
	done

SummerBeachHousePoster3Text:
	text "The sea unites"
	line "all in surfdom!"
	done

SummerBeachHousePrinterText:
	text "It's some sort of"
	line "a machine…"
	done

SummerBeachHousePoster1QualifiedText:
	text "SURFIN' DUDE's"
	line "scribbles…"

	para "When I shoot the"
	line "tube, the tunes"
	cont "hit the groove!"
	done

SummerBeachHousePoster2QualifiedText:
	text "SURFING TIP 1!"

	para "After flips, line"
	line "the board up with"
	cont "a wave for a cool"
	cont "effect!"
	done

SummerBeachHousePoster3QualifiedText:
	text "SURFING TIP 2!"

	para "Pulling flips in"
	line "a jump is totally"
	cont "rad!"
	done

SummerBeachHousePrinterSaysText:
	text "SUMMER BEACH HOUSE"
	line "PRINTER, it says."
	done

SummerBeachHousePrinterHiScoreText:
	text "The Hi-Score is"
	line "shown."

	para "PRINT it out?"
	done

SummerBeachHousePrintCompletedText:
	text "PRINT completed."
	done

SummerBeachHousePrintErrorText:
	text "PRINT error!"
	done

SummerBeachHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, ROUTE_19, 1
	warp_event  3,  7, ROUTE_19, 1

	def_coord_events

	def_bg_events
	bg_event  3,  0, BGEVENT_READ, SummerBeachHousePoster1Script
	bg_event  7,  0, BGEVENT_READ, SummerBeachHousePoster2Script
	bg_event 11,  0, BGEVENT_READ, SummerBeachHousePoster3Script
	bg_event 13,  1, BGEVENT_READ, SummerBeachHousePrinterScript

	def_object_events
; Yellow: `object_event 5, 3, SPRITE_PIKACHU, WALK, UP_DOWN` -- Gen 1 bounds a
; walker by the screen, and in the harness it paces x=5 from y=1 to y=7.  From
; home (5,3), radius 4 gives exactly that span once the wall row (y=0) clamps.
	object_event  2,  3, SPRITE_FISHING_GURU, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, SummerBeachHouseSurfinDudeScript, -1
	object_event  5,  3, SPRITE_PIKACHU_FOLLOWER, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 4, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SummerBeachHousePikachuScript, -1
