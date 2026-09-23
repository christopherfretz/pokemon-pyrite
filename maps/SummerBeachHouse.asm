; Kanto hack (M12a, docs/M12-STRETCH.md "## M12a findings"): Yellow's SUMMER
; BEACH HOUSE on ROUTE 19 (vendor/pokeyellow/{data/maps/objects,scripts,text}/
; SummerBeachHouse.asm), cut wholesale onto Yellow's own 7x4 .blk and the new
; TILESET_KANTO_BEACH_HOUSE (scripts/kanto_beach_house_blk.py).  ROUTE 19's
; door at (5,9) is its warp 1 (this closes D107); warps 1 and 2 here are the
; exit mat on the bottom row, whose collision the generator overrides to
; WARP_CARPET_DOWN (block $0b).
;
; M12a is the SHELL: the house exactly as an *unqualified* Yellow player sees
; it -- one whose Pikachu cannot SURF.  Every script below is Yellow's
; unqualified branch.  Where Yellow branches on the player being qualified
; (the SURFIN' DUDE's minigame offer, the posters' SURFING TIPs, the PRINTER's
; hi-score card), a `; M12b:` hook comment marks the spot and the script falls
; through to the unqualified text.  What "qualified" means here is the open Q5
; gate (docs/survey-m12-stretch.md section 4); M12a deliberately does not
; decide it.
;
; Yellow's gates, for M12b: the dude and the PRINTER test
; BIT_PIKACHU_SPAWN_SURFING (patched to BIT_PIKACHU_SPAWN_STARTER on the
; Virtual Console), the three posters test BIT_PIKACHU_SPAWN_SURFING only.
	object_const_def
	const SUMMERBEACHHOUSE_SURFIN_DUDE
	const SUMMERBEACHHOUSE_PIKACHU

SummerBeachHouse_MapScripts:
	def_scene_scripts

	def_callbacks

SummerBeachHouseSurfinDudeScript:
	faceplayer
	opentext
	; M12b: minigame offer goes here.  Yellow: if qualified, "Whoa! Your
	; PIKACHU knows how to SURF!..." (first time) or "Wanna go SURF?" (later),
	; YES -> SurfingPikachuMinigame, NO -> "Come SURF anytime, my friend!".
	; Unqualified falls through to Yellow's SurfinDudeText4:
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
	; M12b: if qualified, Yellow shows "SURFIN' DUDE's scribbles..." instead.
	jumptext SummerBeachHousePoster1Text

SummerBeachHousePoster2Script:
	; M12b: if qualified, Yellow shows "SURFING TIP 1!" instead.
	jumptext SummerBeachHousePoster2Text

SummerBeachHousePoster3Script:
	; M12b: if qualified, Yellow shows "SURFING TIP 2!" instead.
	jumptext SummerBeachHousePoster3Text

SummerBeachHousePrinterScript:
	; M12b: if qualified, Yellow shows "SUMMER BEACH HOUSE PRINTER, it says."
	; and, once the minigame has been played, offers to PRINT the Hi-Score.
	; Unqualified falls through to Yellow's PrinterText1 (a stub here):
	jumptext SummerBeachHousePrinterText

SummerBeachHouseSurfinDudeText:
	text "Dogs and burgers"
	line "on special today!"
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
