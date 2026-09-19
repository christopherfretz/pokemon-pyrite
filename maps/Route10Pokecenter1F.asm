; Kanto hack (M5 8d): Yellow's ROCK TUNNEL #MON CENTER
; (vendor/pokeyellow/data/maps/objects/RockTunnelPokecenter.asm,
; vendor/pokeyellow/text/RockTunnelPokecenter.asm), re-placed on Crystal's 5x4
; room the way 6b/7b did Cerulean's and Vermilion's.  Yellow's 11,2
; LINK_RECEPTIONIST is dropped: Crystal's cable club lives on POKECENTER_2F,
; which the (0,7) staircase already reaches (and x=11 does not exist in this
; 10-tile-wide room).  Crystal's own COOLTRAINER_F is gone -- she is not on
; Yellow's list -- and the GYM_GUIDE's POWER PLANT / TEAM ROCKET-in-JOHTO
; script went with the deferred Power Plant story (docs/M5-LAVENDER.md 3.9).
;
; Yellow's NURSE (3,1), CHANSEY (4,1), GENTLEMAN (7,3) and FISHER (2,5) are all
; on Yellow's own tiles.
	object_const_def
	const ROUTE10POKECENTER1F_NURSE
	const ROUTE10POKECENTER1F_CHANSEY
	const ROUTE10POKECENTER1F_GENTLEMAN
	const ROUTE10POKECENTER1F_FISHER

Route10Pokecenter1F_MapScripts:
	def_scene_scripts

	def_callbacks

Route10Pokecenter1FNurseScript:
	jumpstd PokecenterNurseScript

; Yellow: PokecenterChanseyText (engine/events/pokecenter_chansey.asm).
Route10Pokecenter1FChanseyScript:
	opentext
	writetext Route10Pokecenter1FChanseyText
	cry CHANSEY
	waitbutton
	closetext
	end

Route10Pokecenter1FGentlemanScript:
	jumptextfaceplayer Route10Pokecenter1FGentlemanText

Route10Pokecenter1FFisherScript:
	jumptextfaceplayer Route10Pokecenter1FFisherText

Route10Pokecenter1FChanseyText:
	text "CHANSEY: Chaaan"
	line "sey!"
	done

Route10Pokecenter1FGentlemanText:
	text "The element types"
	line "of #MON make"
	cont "them stronger"
	cont "than some types"
	cont "and weaker than"
	cont "others!"
	done

Route10Pokecenter1FFisherText:
	text "I sold a useless"
	line "NUGGET for ¥5000!"
	done

Route10Pokecenter1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, ROUTE_10, 1
	warp_event  4,  7, ROUTE_10, 1
	warp_event  0,  7, POKECENTER_2F, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  3,  1, SPRITE_NURSE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route10Pokecenter1FNurseScript, -1
	object_event  4,  1, SPRITE_CHANSEY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route10Pokecenter1FChanseyScript, -1
	object_event  7,  3, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route10Pokecenter1FGentlemanScript, -1
	object_event  2,  5, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, Route10Pokecenter1FFisherScript, -1
