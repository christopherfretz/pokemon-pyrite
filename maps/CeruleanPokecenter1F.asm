; 6b: Yellow's Cerulean Pokemon Center
; (vendor/pokeyellow/data/maps/objects/CeruleanPokecenter.asm), re-placed on
; Crystal's 5x4 room the way M2 5g did Mt. Moon's.  Yellow's LINK_RECEPTIONIST
; is dropped: Crystal's cable club lives on POKECENTER_2F, which the (0,7)
; staircase already reaches.  Crystal's Magnet Train gym guide is gone.
	object_const_def
	const CERULEANPOKECENTER1F_NURSE
	const CERULEANPOKECENTER1F_CHANSEY
	const CERULEANPOKECENTER1F_GENTLEMAN
	const CERULEANPOKECENTER1F_SUPER_NERD

CeruleanPokecenter1F_MapScripts:
	def_scene_scripts

	def_callbacks

CeruleanPokecenter1FNurseScript:
	jumpstd PokecenterNurseScript

; Yellow: PokecenterChanseyText (engine/events/pokecenter_chansey.asm) --
; one line plus the cry.
CeruleanPokecenter1FChanseyScript:
	opentext
	writetext CeruleanPokecenter1FChanseyText
	cry CHANSEY
	waitbutton
	closetext
	end

CeruleanPokecenter1FGentlemanScript:
	jumptextfaceplayer CeruleanPokecenter1FGentlemanText

CeruleanPokecenter1FSuperNerdScript:
	jumptextfaceplayer CeruleanPokecenter1FSuperNerdText

CeruleanPokecenter1FChanseyText:
	text "CHANSEY: Chaaan"
	line "sey!"
	done

CeruleanPokecenter1FGentlemanText:
	text "Have you heard"
	line "about BILL?"

	para "Everyone calls"
	line "him a #MANIAC!"

	para "I think people"
	line "are just jealous"
	cont "of BILL, though."

	para "Who wouldn't want"
	line "to boast about"
	cont "their #MON?"
	done

CeruleanPokecenter1FSuperNerdText:
	text "That BILL!"

	para "I heard that"
	line "he'll do whatever"
	cont "it takes to get"
	cont "rare #MON!"
	done

; BG1: Yellow's bench guy, drawn in the bench art at (0,4) and read only
; from (1,4) facing LEFT (vendor/pokeyellow/data/events/bench_guys.asm,
; _CeruleanPokecenterGuyText in data/text/text_2.asm; docs/BG1-BENCH-AND-SHELVES.md).
CeruleanPokecenter1FBenchGuyScript:
	jumptext CeruleanPokecenter1FBenchGuyText

CeruleanPokecenter1FBenchGuyText:
	text "BILL has lots of"
	line "#MON!"

	para "He collects rare"
	line "ones too!"
	done

CeruleanPokecenter1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, CERULEAN_CITY, 3
	warp_event  4,  7, CERULEAN_CITY, 3
	warp_event  0,  7, POKECENTER_2F, 1

	def_coord_events

	def_bg_events
	bg_event  0,  4, BGEVENT_LEFT, CeruleanPokecenter1FBenchGuyScript ; BG1 Yellow bench guy

	def_object_events
	object_event  3,  1, SPRITE_NURSE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeruleanPokecenter1FNurseScript, -1
	object_event  4,  1, SPRITE_CHANSEY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeruleanPokecenter1FChanseyScript, -1
	object_event  6,  2, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeruleanPokecenter1FGentlemanScript, -1
	object_event  8,  4, SPRITE_SUPER_NERD, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeruleanPokecenter1FSuperNerdScript, -1
