; Kanto hack: Yellow's FUCHSIA MART (docs/M7-FUCHSIA.md 10g).  Both shoppers
; speak Yellow's lines verbatim (vendor/pokeyellow/text/FuchsiaMart.asm), the
; cast is Yellow's (objects/FuchsiaMart.asm) and the stock is Yellow's
; FuchsiaMartClerkText list (data/items/marts.asm).  Crystal's two
; "SAFARI ZONE is closed" shoppers are gone (D65) -- the SAFARI ZONE is open in
; this hack.  10a already re-cut the room to Yellow's 4x4; as in every other
; Kanto mart the clerk keeps Crystal's counter tile (1,3) rather than Yellow's
; (0,5), and the COOLTRAINER_F drops one row, (6,5) -> (6,6), because Yellow's
; (6,5) is a shelf in Crystal's MART art.
; Sprites follow the standing substitutions: SPRITE_POKEFAN_M for Yellow's
; MIDDLE_AGED_MAN (docs/M2-MTMOON.md:1465).
	object_const_def
	const FUCHSIAMART_CLERK
	const FUCHSIAMART_MIDDLE_AGED_MAN
	const FUCHSIAMART_COOLTRAINER_F

FuchsiaMart_MapScripts:
	def_scene_scripts

	def_callbacks

FuchsiaMartClerkScript:
	opentext
	pokemart MARTTYPE_STANDARD, MART_FUCHSIA
	closetext
	end

FuchsiaMartMiddleAgedManScript:
	jumptextfaceplayer FuchsiaMartMiddleAgedManText

FuchsiaMartCooltrainerFScript:
	jumptextfaceplayer FuchsiaMartCooltrainerFText

FuchsiaMartMiddleAgedManText:
	text "Do you have a"
	line "SAFARI ZONE flag?"

	para "What about cards"
	line "or calendars?"
	done

FuchsiaMartCooltrainerFText:
	text "Did you try X"
	line "SPEED? It speeds"
	cont "up a #MON in"
	cont "battle!"
	done

FuchsiaMart_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, FUCHSIA_CITY, 1
	warp_event  3,  7, FUCHSIA_CITY, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  1,  3, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, FuchsiaMartClerkScript, -1
	object_event  4,  2, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, FuchsiaMartMiddleAgedManScript, -1
	object_event  6,  6, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, FuchsiaMartCooltrainerFScript, -1
