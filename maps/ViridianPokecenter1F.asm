	object_const_def
	const VIRIDIANPOKECENTER1F_NURSE
	const VIRIDIANPOKECENTER1F_COOLTRAINER_M
	const VIRIDIANPOKECENTER1F_COOLTRAINER_F
	const VIRIDIANPOKECENTER1F_CHANSEY

ViridianPokecenter1F_MapScripts:
	def_scene_scripts

	def_callbacks

ViridianPokecenter1FNurseScript:
	jumpstd PokecenterNurseScript

ViridianPokecenter1FCooltrainerMScript:
	jumptextfaceplayer ViridianPokecenter1FCooltrainerMText

ViridianPokecenter1FCooltrainerFScript:
	jumptextfaceplayer ViridianPokecenter1FCooltrainerFText

; Kanto hack (N1c): Yellow's PokecenterChanseyText
; (engine/events/pokecenter_chansey.asm) -- one line plus the cry.
; Same pattern as CeruleanPokecenter1FChanseyScript.
ViridianPokecenter1FChanseyScript:
	opentext
	writetext ViridianPokecenter1FChanseyText
	cry CHANSEY
	waitbutton
	closetext
	end

; Kanto hack (N1c): Yellow's _ViridianPokecenterCooltrainerMText, verbatim.
; Crystal's "where is VIRIDIAN's GYM LEADER" line and its EVENT_BLUE_IN_CINNABAR
; branch are gone -- both were Blue-as-leader Johto-act flavour.
ViridianPokecenter1FCooltrainerMText:
	text "There's a #MON"
	line "CENTER in every"
	cont "town ahead."

	para "They don't charge"
	line "any money either!"
	done

; Kanto hack (N1c): Yellow's _ViridianPokecenterGentlemanText, verbatim.
ViridianPokecenter1FCooltrainerFText:
	text "You can use that"
	line "PC in the corner."

	para "The receptionist"
	line "told me. So kind!"
	done

ViridianPokecenter1FChanseyText:
	text "CHANSEY: Chaaan"
	line "sey!"
	done

ViridianPokecenter1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, VIRIDIAN_CITY, 4 ; L1: warp 5 -> 4 (TRAINER HOUSE warp deleted)
	warp_event  4,  7, VIRIDIAN_CITY, 4
	warp_event  0,  7, POKECENTER_2F, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  3,  1, SPRITE_NURSE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ViridianPokecenter1FNurseScript, -1
	object_event  8,  4, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ViridianPokecenter1FCooltrainerMScript, -1
	object_event  5,  3, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ViridianPokecenter1FCooltrainerFScript, -1
	object_event  4,  1, SPRITE_CHANSEY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ViridianPokecenter1FChanseyScript, -1
