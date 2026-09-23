; Kanto hack (M8 11d): Yellow's SAFFRON #MON CENTER
; (vendor/pokeyellow/{data/maps/objects,scripts,text}/SaffronPokecenter.asm)
; minus the cable-club receptionist: Crystal keeps the cable club upstairs on
; POKECENTER_2F, which warp 3 already leads to (docs/PORTING.md §15), the same
; call Pewter, Viridian and Fuchsia made.  Crystal's mobile-adapter TEACHER, its
; JOHTO gossip, its POWER PLANT HIKER and its MAGNET TRAIN STATION YOUNGSTER are
; all gone -- the Kanto-act predicate is ENGINE_POKEGEAR clear, and the MAGNET
; TRAIN does not exist yet (D74).  CHANSEY keeps the Kanto-Pokecentre (4,1)
; convention (N1c/N1d).  11a widened the room to Yellow's 7x4.
	object_const_def
	const SAFFRONPOKECENTER1F_NURSE
	const SAFFRONPOKECENTER1F_BEAUTY
	const SAFFRONPOKECENTER1F_GENTLEMAN
	const SAFFRONPOKECENTER1F_CHANSEY

SaffronPokecenter1F_MapScripts:
	def_scene_scripts

	def_callbacks

SaffronPokecenter1FNurseScript:
	jumpstd PokecenterNurseScript

SaffronPokecenter1FBeautyScript:
	jumptextfaceplayer SaffronPokecenter1FBeautyText

SaffronPokecenter1FGentlemanScript:
	jumptextfaceplayer SaffronPokecenter1FGentlemanText

; Yellow's PokecenterChanseyText -- one line plus the cry (N1c/N1d).
SaffronPokecenter1FChanseyScript:
	opentext
	writetext SaffronPokecenter1FChanseyText
	cry CHANSEY
	waitbutton
	closetext
	end

SaffronPokecenter1FBeautyText:
	text "#MON growth"
	line "rates differ from"
	cont "specie to specie."
	done

SaffronPokecenter1FGentlemanText:
	text "SILPH CO. is very"
	line "famous. That's"
	cont "why it attracted"
	cont "TEAM ROCKET!"
	done

SaffronPokecenter1FChanseyText:
	text "CHANSEY: Chaaan"
	line "sey!"
	done

; BG1: Yellow's bench guy, drawn in the bench art at (0,4) and read only
; from (1,4) facing LEFT (vendor/pokeyellow/data/events/bench_guys.asm,
; _SaffronCityPokecenterGuyText1 in data/text/text_2.asm; docs/BG1-BENCH-AND-SHELVES.md).
SaffronPokecenter1FBenchGuyScript:
; Yellow switches on EVENT_BEAT_SILPH_CO_GIOVANNI (_SaffronCityPokecenterGuyText2).
	checkevent EVENT_BEAT_SILPH_CO_GIOVANNI
	iftrue .RocketGone
	jumptext SaffronPokecenter1FBenchGuyText

.RocketGone:
	jumptext SaffronPokecenter1FBenchGuyAfterText

SaffronPokecenter1FBenchGuyText:
	text "It would be great"
	line "if the ELITE FOUR"
	cont "came and stomped"
	cont "TEAM ROCKET!"
	done

SaffronPokecenter1FBenchGuyAfterText:
	text "TEAM ROCKET took"
	line "off! We can go"
	cont "out safely again!"
	cont "That's great!"
	done

SaffronPokecenter1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, SAFFRON_CITY, 7
	warp_event  4,  7, SAFFRON_CITY, 7
	warp_event  0,  7, POKECENTER_2F, 1

	def_coord_events

	def_bg_events
	bg_event  0,  4, BGEVENT_LEFT, SaffronPokecenter1FBenchGuyScript ; BG1 Yellow bench guy

	def_object_events
	object_event  3,  1, SPRITE_NURSE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SaffronPokecenter1FNurseScript, -1
	object_event  5,  5, SPRITE_BEAUTY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SaffronPokecenter1FBeautyScript, -1
	object_event  8,  3, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SaffronPokecenter1FGentlemanScript, -1
	object_event  4,  1, SPRITE_CHANSEY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SaffronPokecenter1FChanseyScript, -1
