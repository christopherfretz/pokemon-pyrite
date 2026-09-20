; Kanto hack (M6 9t): Yellow's CELADON_POKECENTER
; (vendor/pokeyellow/data/maps/objects/CeladonPokecenter.asm,
; vendor/pokeyellow/text/CeladonPokecenter.asm), re-placed on Crystal's 5x4
; room the way 8h did Lavender's.
;
; Yellow's NURSE (3,1), CHANSEY (4,1) and GENTLEMAN (7,3) keep Yellow's own
; tiles.  Yellow's BEAUTY wanders at (10,5), past the right-hand end of this
; narrower 10-tile room, so she takes the equivalent open tile, (8,4),
; left-right -- exactly the re-placement 6b/8h used for Cerulean's and
; Lavender's (10,5) walkers.
;
; Yellow's 11,2 LINK_RECEPTIONIST is dropped: Crystal's cable club lives on
; POKECENTER_2F, which the (0,7) staircase already reaches (and x=11 does not
; exist here).  Crystal's own PHARMACIST ("that was three years ago"),
; COOLTRAINER_F (ERIKA tip), HappinessCheck gentleman and EUSINE (Suicune /
; Ho-Oh / TIN TOWER / ECRUTEAK) are all gone -- none are on Yellow's list and
; all four are Johto-era content.
;
; Yellow also hides a bench guy at (0,4) (PrintBenchGuyText) and the PC hidden
; event at (13,3); Crystal's room has a real PC tile at (9,1) and no bench art
; at (0,4), so the bench guy is left for BG1's bench pass.
	object_const_def
	const CELADONPOKECENTER1F_NURSE
	const CELADONPOKECENTER1F_CHANSEY
	const CELADONPOKECENTER1F_GENTLEMAN
	const CELADONPOKECENTER1F_BEAUTY

CeladonPokecenter1F_MapScripts:
	def_scene_scripts

	def_callbacks

CeladonPokecenter1FNurseScript:
	jumpstd PokecenterNurseScript

; Yellow: PokecenterChanseyText (engine/events/pokecenter_chansey.asm).
CeladonPokecenter1FChanseyScript:
	opentext
	writetext CeladonPokecenter1FChanseyText
	cry CHANSEY
	waitbutton
	closetext
	end

CeladonPokecenter1FGentlemanScript:
	jumptextfaceplayer CeladonPokecenter1FGentlemanText

CeladonPokecenter1FBeautyScript:
	jumptextfaceplayer CeladonPokecenter1FBeautyText

CeladonPokecenter1FChanseyText:
	text "CHANSEY: Chaaan"
	line "sey!"
	done

CeladonPokecenter1FGentlemanText:
	text "# FLUTE awakens"
	line "#MON with a"

	para "sound that only"
	line "they can hear!"
	done

CeladonPokecenter1FBeautyText:
	text "I rode uphill on"
	line "CYCLING ROAD from"
	cont "FUCHSIA!"
	done

CeladonPokecenter1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, CELADON_CITY, 6 ; Kanto hack (M6 9p): Yellow's city warp 6
	warp_event  4,  7, CELADON_CITY, 6
	warp_event  0,  7, POKECENTER_2F, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  3,  1, SPRITE_NURSE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeladonPokecenter1FNurseScript, -1
	object_event  4,  1, SPRITE_CHANSEY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeladonPokecenter1FChanseyScript, -1
	object_event  7,  3, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonPokecenter1FGentlemanScript, -1
	object_event  8,  4, SPRITE_BEAUTY, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonPokecenter1FBeautyScript, -1
