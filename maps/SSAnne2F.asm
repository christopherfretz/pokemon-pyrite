; Kanto hack: Yellow's SS_ANNE_2F (docs/M4-VERMILION.md, 7h).
;   Yellow ( 3, 7) SPRITE_WAITER, WALK UP_DOWN -> SPRITE_CLERK (5.4)
;   Yellow (36, 4) SPRITE_BLUE, STAY DOWN      -> SPRITE_KANTO_RIVAL
; The rival is 7i's (3.3): Yellow only ShowObject's him for the corridor scene
; that blocks the CAPTAIN's door, so 7h places the object with its HIDE flag set
; and a script that does nothing.  Per docs/PORTING.md 3.4 the flag is DERIVED on
; every map load instead of being toggled once, so a white-out in 7i's battle
; cannot leave a stray rival standing on the stairs; 7h's derivation is the
; degenerate "always hidden", and 7i replaces the body of the callback below with
; the real EVENT_BEAT_RIVAL_SS_ANNE test (CeruleanCityObjectsCallback is the
; precedent).  An appended flag starts CLEAR = visible, so the setevent is what
; keeps him off the map at all.
	object_const_def
	const SSANNE2F_WAITER
	const SSANNE2F_RIVAL

SSAnne2F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_OBJECTS, SSAnne2FObjectsCallback

SSAnne2FObjectsCallback:
	setevent EVENT_SS_ANNE_2F_RIVAL_HIDDEN ; 7i
	endcallback

SSAnne2FWaiterScript:
	jumptextfaceplayer SSAnne2FWaiterText

SSAnne2FRivalScript:
	end ; 7i

SSAnne2FWaiterText:
	text "This ship, she is"
	line "a luxury liner"
	cont "for trainers!"

	para "At every port, we"
	line "hold parties with"
	cont "invited trainers!"
	done

SSAnne2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  9, 11, SS_ANNE_2F_ROOMS, 1
	warp_event 13, 11, SS_ANNE_2F_ROOMS, 3
	warp_event 17, 11, SS_ANNE_2F_ROOMS, 5
	warp_event 21, 11, SS_ANNE_2F_ROOMS, 7
	warp_event 25, 11, SS_ANNE_2F_ROOMS, 9
	warp_event 29, 11, SS_ANNE_2F_ROOMS, 11
	warp_event  2,  4, SS_ANNE_1F, 9
	warp_event  2, 12, SS_ANNE_3F, 2
	warp_event 36,  4, SS_ANNE_CAPTAINS_ROOM, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  3,  7, SPRITE_CLERK, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnne2FWaiterScript, -1
	object_event 36,  4, SPRITE_KANTO_RIVAL, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SSAnne2FRivalScript, EVENT_SS_ANNE_2F_RIVAL_HIDDEN
