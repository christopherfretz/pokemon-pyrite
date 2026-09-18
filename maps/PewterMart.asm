; Kanto hack: Yellow's PEWTER MART (docs/M2-PEWTER.md). Both shoppers speak
; Yellow's lines verbatim (vendor/pokeyellow/text/PewterMart.asm) and copy
; Yellow's movement (youngster paces UP/DOWN, super nerd STAY/NONE); the floor
; tiles differ from Yellow's so the positions stay Crystal's.
	object_const_def
	const PEWTERMART_CLERK
	const PEWTERMART_YOUNGSTER
	const PEWTERMART_SUPER_NERD

PewterMart_MapScripts:
	def_scene_scripts

	def_callbacks

PewterMartClerkScript:
	opentext
	pokemart MARTTYPE_STANDARD, MART_PEWTER
	closetext
	end

PewterMartYoungsterScript:
	jumptextfaceplayer PewterMartYoungsterText

PewterMartSuperNerdScript:
	jumptextfaceplayer PewterMartSuperNerdText

PewterMartYoungsterText:
	text "A shady old man"
	line "got me to buy"
	cont "this really weird"
	cont "fish #MON!"

	para "It's totally weak"
	line "and it cost ¥500!"
	done

PewterMartSuperNerdText:
	text "Good things can"
	line "happen if you"
	cont "raise #MON"
	cont "diligently, even"
	cont "the weak ones!"
	done

PewterMart_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, PEWTER_CITY, 3
	warp_event  3,  7, PEWTER_CITY, 3

	def_coord_events

	def_bg_events

	def_object_events
	object_event  1,  3, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PewterMartClerkScript, -1
	object_event  9,  2, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PewterMartYoungsterScript, -1
	object_event  6,  6, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, PewterMartSuperNerdScript, -1
