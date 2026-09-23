; Kanto hack (M5 8h): Yellow's LAVENDER_POKECENTER
; (vendor/pokeyellow/data/maps/objects/LavenderPokecenter.asm,
; vendor/pokeyellow/text/LavenderPokecenter.asm), re-placed on Crystal's 5x4
; room the way 6b/7b/8d did Cerulean's, Vermilion's and Rock Tunnel's.
;
; Yellow's NURSE (3,1), CHANSEY (4,1) and GENTLEMAN (5,3) are on Yellow's own
; tiles.  Yellow's LITTLE_GIRL walks left-right at (10,5), past the right-hand
; end of this narrower room and (at x=9) hemmed in by the tables, so she takes
; the equivalent open tile one row up, (8,4), exactly as 6b re-placed
; Cerulean's (10,5) walker.  She is SPRITE_TWIN per the sprite substitution
; table (docs/M5-LAVENDER.md 2.17).
;
; Yellow's 11,2 LINK_RECEPTIONIST is dropped: Crystal's cable club lives on
; POKECENTER_2F, which the (0,7) staircase already reaches (and x=11 does not
; exist in this 10-tile-wide room).  Crystal's own TEACHER and YOUNGSTER are
; gone -- they are not on Yellow's list -- and with the YOUNGSTER went the
; EVENT_RETURNED_MACHINE_PART / MAGNET TRAIN / RADIO STATION branch, which
; belongs to the deferred Johto Power Plant story (docs/M5-LAVENDER.md 3.9).
; The flag itself stays live for Johto.
	object_const_def
	const LAVENDERPOKECENTER1F_NURSE
	const LAVENDERPOKECENTER1F_CHANSEY
	const LAVENDERPOKECENTER1F_GENTLEMAN
	const LAVENDERPOKECENTER1F_TWIN

LavenderPokecenter1F_MapScripts:
	def_scene_scripts

	def_callbacks

LavenderPokecenter1FNurseScript:
	jumpstd PokecenterNurseScript

; Yellow: PokecenterChanseyText (engine/events/pokecenter_chansey.asm).
LavenderPokecenter1FChanseyScript:
	opentext
	writetext LavenderPokecenter1FChanseyText
	cry CHANSEY
	waitbutton
	closetext
	end

LavenderPokecenter1FGentlemanScript:
	jumptextfaceplayer LavenderPokecenter1FGentlemanText

LavenderPokecenter1FTwinScript:
	jumptextfaceplayer LavenderPokecenter1FTwinText

LavenderPokecenter1FChanseyText:
	text "CHANSEY: Chaaan"
	line "sey!"
	done

LavenderPokecenter1FGentlemanText:
	text "TEAM ROCKET will"
	line "do anything for"
	cont "the sake of gold!"
	done

LavenderPokecenter1FTwinText:
	text "I saw CUBONE's"
	line "mother die trying"
	cont "to escape from"
	cont "TEAM ROCKET!"
	done

; BG1: Yellow's bench guy, drawn in the bench art at (0,4) and read only
; from (1,4) facing LEFT (vendor/pokeyellow/data/events/bench_guys.asm,
; _LavenderPokecenterGuyText in data/text/text_2.asm; docs/BG1-BENCH-AND-SHELVES.md).
LavenderPokecenter1FBenchGuyScript:
	jumptext LavenderPokecenter1FBenchGuyText

LavenderPokecenter1FBenchGuyText:
	text "CUBONEs wear"
	line "skulls, right?"

	para "People will pay a"
	line "lot for one!"
	done

LavenderPokecenter1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, LAVENDER_TOWN, 1
	warp_event  4,  7, LAVENDER_TOWN, 1
	warp_event  0,  7, POKECENTER_2F, 1

	def_coord_events

	def_bg_events
	bg_event  0,  4, BGEVENT_LEFT, LavenderPokecenter1FBenchGuyScript ; BG1 Yellow bench guy

	def_object_events
	object_event  3,  1, SPRITE_NURSE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, LavenderPokecenter1FNurseScript, -1
	object_event  4,  1, SPRITE_CHANSEY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, LavenderPokecenter1FChanseyScript, -1
	object_event  5,  3, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, LavenderPokecenter1FGentlemanScript, -1
	object_event  8,  4, SPRITE_TWIN, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, LavenderPokecenter1FTwinScript, -1
