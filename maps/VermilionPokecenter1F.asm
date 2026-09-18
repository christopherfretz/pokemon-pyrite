; Kanto hack: Yellow's VERMILION_POKECENTER
; (vendor/pokeyellow/data/maps/objects/VermilionPokecenter.asm,
; scripts/VermilionPokecenter.asm, text/VermilionPokecenter.asm), re-placed on
; Crystal's 5x4 room the way 6b did Cerulean's.  Yellow's LINK_RECEPTIONIST is
; dropped: Crystal's cable club lives on POKECENTER_2F, which the (0,7)
; staircase already reaches.  Crystal's SNORLAX fisher and JOHTO-badges bug
; catcher are gone with the Snorlax (7e).
;
; Yellow's NURSE (3,1), CHANSEY (4,1) and SAILOR (5,4) are on Yellow's own
; tiles.  Yellow's FISHING_GURU stands at (10,5), past the right-hand end of
; Crystal's narrower room, so he takes the equivalent tile on this side of the
; tables, (9,5).
	object_const_def
	const VERMILIONPOKECENTER1F_NURSE
	const VERMILIONPOKECENTER1F_CHANSEY
	const VERMILIONPOKECENTER1F_FISHING_GURU
	const VERMILIONPOKECENTER1F_SAILOR

VermilionPokecenter1F_MapScripts:
	def_scene_scripts

	def_callbacks

VermilionPokecenter1FNurseScript:
	jumpstd PokecenterNurseScript

; Yellow: PokecenterChanseyText (engine/events/pokecenter_chansey.asm).
VermilionPokecenter1FChanseyScript:
	opentext
	writetext VermilionPokecenter1FChanseyText
	cry CHANSEY
	waitbutton
	closetext
	end

VermilionPokecenter1FFishingGuruScript:
	jumptextfaceplayer VermilionPokecenter1FFishingGuruText

VermilionPokecenter1FSailorScript:
	jumptextfaceplayer VermilionPokecenter1FSailorText

VermilionPokecenter1FChanseyText:
	text "CHANSEY: Chaaan"
	line "sey!"
	done

VermilionPokecenter1FFishingGuruText:
	text "Even if they are"
	line "the same level,"
	cont "#MON can have"
	cont "very different"
	cont "abilities."

	para "A #MON raised"
	line "by a trainer is"
	cont "stronger than one"
	cont "in the wild."
	done

VermilionPokecenter1FSailorText:
	text "My #MON was"
	line "poisoned! It"
	cont "fainted while we"
	cont "were walking!"
	done

VermilionPokecenter1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, VERMILION_CITY, 1
	warp_event  4,  7, VERMILION_CITY, 1
	warp_event  0,  7, POKECENTER_2F, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  3,  1, SPRITE_NURSE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VermilionPokecenter1FNurseScript, -1
	object_event  4,  1, SPRITE_CHANSEY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VermilionPokecenter1FChanseyScript, -1
	object_event  9,  5, SPRITE_FISHING_GURU, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, VermilionPokecenter1FFishingGuruScript, -1
	object_event  5,  4, SPRITE_SAILOR, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, VermilionPokecenter1FSailorScript, -1
