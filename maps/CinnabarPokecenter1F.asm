; Kanto hack (M9 12h): Yellow's CINNABAR #MON CENTER
; (vendor/pokeyellow/{data/maps/objects,scripts,text}/CinnabarPokecenter.asm)
; minus the cable-club receptionist at (11,2): Crystal keeps the cable club
; upstairs on POKECENTER_2F, which warp 3 already leads to (docs/PORTING.md
; §15) -- the same call Pewter, Viridian, Fuchsia and Saffron made.  CHANSEY
; keeps the Kanto-Pokecentre (4,1) convention (N1c/N1d).  Crystal's two
; Gen 2 gossips -- the COOLTRAINER_F pointing at "BLAINE lives alone in the
; SEAFOAM ISLANDS cave" and the FISHER's "a year since the volcano erupted" --
; are gone with the rest of the relocation story (D96/12g).  12a had already
; widened the room to Yellow's 7x4 and pointed it at Yellow's own Pokecentre
; .blk (data/maps/blocks.asm), so every one of Yellow's coordinates lands on
; the tile Yellow meant it to.
;
; Yellow's bench guy (data/events/bench_guys.asm, CINNABAR_POKECENTER,
; SPRITE_FACING_LEFT) is NOT here: no Kanto Centre has one yet, and the whole
; set lands together in BG1 (M4-audit Q10, HANDOFF "Next" item 2).
	object_const_def
	const CINNABARPOKECENTER1F_NURSE
	const CINNABARPOKECENTER1F_COOLTRAINER_F
	const CINNABARPOKECENTER1F_GENTLEMAN
	const CINNABARPOKECENTER1F_CHANSEY

CinnabarPokecenter1F_MapScripts:
	def_scene_scripts

	def_callbacks

CinnabarPokecenter1FNurseScript:
	jumpstd PokecenterNurseScript

CinnabarPokecenter1FCooltrainerFScript:
	jumptextfaceplayer CinnabarPokecenter1FCooltrainerFText

CinnabarPokecenter1FGentlemanScript:
	jumptextfaceplayer CinnabarPokecenter1FGentlemanText

; Yellow's PokecenterChanseyText -- one line plus the cry (N1c/N1d).
CinnabarPokecenter1FChanseyScript:
	opentext
	writetext CinnabarPokecenter1FChanseyText
	cry CHANSEY
	waitbutton
	closetext
	end

CinnabarPokecenter1FCooltrainerFText:
	text "You can cancel"
	line "evolution."

	para "When a #MON is"
	line "evolving, you can"
	cont "stop it and leave"
	cont "it the way it is."
	done

CinnabarPokecenter1FGentlemanText:
	text "Do you have any"
	line "friends?"

	para "#MON you get"
	line "in trades grow"
	cont "very quickly."

	para "I think it's"
	line "worth a try!"
	done

CinnabarPokecenter1FChanseyText:
	text "CHANSEY: Chaaan"
	line "sey!"
	done

CinnabarPokecenter1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; CINNABAR ISLAND carries Yellow's five warps and the POKeCENTRE is its FOURTH
; (Yellow returns to LAST_MAP, 4 from here) -- 12g.
	warp_event  3,  7, CINNABAR_ISLAND, 4
	warp_event  4,  7, CINNABAR_ISLAND, 4
	warp_event  0,  7, POKECENTER_2F, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  3,  1, SPRITE_NURSE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CinnabarPokecenter1FNurseScript, -1
	object_event  9,  4, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CinnabarPokecenter1FCooltrainerFScript, -1
	object_event  2,  6, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CinnabarPokecenter1FGentlemanScript, -1
	object_event  4,  1, SPRITE_CHANSEY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CinnabarPokecenter1FChanseyScript, -1
