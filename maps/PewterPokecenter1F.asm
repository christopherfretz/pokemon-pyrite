; Kanto hack: Yellow's PEWTER #MON CENTER (docs/M2-PEWTER.md).  Every line is
; Yellow's (vendor/pokeyellow/text/PewterPokecenter.asm) and the cast is
; Yellow's (objects/PewterPokecenter.asm) minus the cable-club receptionist:
; Crystal keeps the cable club upstairs on POKECENTER_2F, which this map's
; third warp already leads to, so a 1F link receptionist would be a second
; door into the same room (same call N1c made at Viridian).  Crystal's
; Johto-act NPCs -- the CINNABAR-GYM-gossip TEACHER and the CHRIS trade -- are
; gone.  Yellow's (11,7)/(11,2) slots are off our 10-wide floor, so the
; GENTLEMAN moves to (8,6).  The COOLTRAINER_F moves one tile right, (4,3)
; -> (5,3): Yellow parks her directly in front of the CHANSEY at (4,1),
; which makes CHANSEY's line unreachable -- the same Yellow quirk N1c
; already fixed the same way at Viridian.  Every other position is
; Yellow's.
	object_const_def
	const PEWTERPOKECENTER1F_NURSE
	const PEWTERPOKECENTER1F_GENTLEMAN
	const PEWTERPOKECENTER1F_JIGGLYPUFF
	const PEWTERPOKECENTER1F_COOLTRAINER_F
	const PEWTERPOKECENTER1F_CHANSEY

PewterPokecenter1F_MapScripts:
	def_scene_scripts

	def_callbacks

; J6 (docs/JIGGLYPUFF.md): Yellow's DisplayPokemonCenterDialogue_ opens with a
; PEWTER_POKECENTER special case (vendor/pokeyellow/engine/events/pokecenter.asm:1)
; -- while the JIGGLYPUFF SONG has Pikachu asleep NURSE JOY does not heal at all,
; she only says it looks content, and the whole dialogue returns.  Yellow's
; predicate there is CheckPikachuFollowingPlayer, i.e. the sleep bit itself,
; which is our wPikaAsleep.  Anywhere else -- and here once Pikachu is awake --
; this is the ordinary shared nurse script.
PewterPokecenter1FNurseScript:
	special CheckPikachuAsleep
	iftrue .pikachu_asleep
	jumpstd PokecenterNurseScript

.pikachu_asleep
	opentext
	writetext PewterPokecenter1FLooksContentText
	waitbutton
	closetext
	end

PewterPokecenter1FGentlemanScript:
	jumptextfaceplayer PewterPokecenter1FGentlemanText

; Yellow's set-piece (vendor/pokeyellow/scripts/PewterPokecenter_2.asm:10),
; ported in full -- song, sprite spin and the Pikachu sleep (docs/JIGGLYPUFF.md).
; The whole beat is the PewterJigglypuffSong special, because Crystal's script
; engine cannot wait on the sound driver: the map music stops, JIGGLYPUFF sings
; MUSIC_JIGGLYPUFF_SONG while the sprite turns down/left/up/right every 24
; frames, and the map music comes back 48 frames after the song ends.  No
; waitbutton: Yellow sets wDoNotWaitForButtonPressAfterDisplayingText, so the
; box is up for the whole song and closes on its own.  No cry either -- the song
; IS the cry in Yellow.
PewterJigglypuff:
	opentext
	writetext PewterJigglypuffText
	special PewterJigglypuffSong
	closetext
	end

PewterPokecenter1FCooltrainerFScript:
	jumptextfaceplayer PewterPokecenter1FCooltrainerFText

; Kanto hack (N1c/N1d): Yellow's PokecenterChanseyText -- one line plus the cry.
PewterPokecenter1FChanseyScript:
	opentext
	writetext PewterPokecenter1FChanseyText
	cry CHANSEY
	waitbutton
	closetext
	end

PewterPokecenter1FGentlemanText:
	text "What!?"

	para "TEAM ROCKET is"
	line "at MT.MOON? Huh?"
	cont "I'm on the phone!"

	para "Scram!"
	done

PewterJigglypuffText:
	text "JIGGLYPUFF: Puu"
	line "pupuu!"
	done

PewterPokecenter1FCooltrainerFText:
	text "#MON CENTERS"
	line "are wonderful!"

	para "They heal #MON"
	line "completely."

	para "Even conditions"
	line "like sleep, burn,"
	cont "poison and others"
	cont "are cured."
	done

; Yellow's _LooksContentText (vendor/pokeyellow/data/text/text_7.asm:193).
PewterPokecenter1FLooksContentText:
	text "It looks very"
	line "content asleep."
	done

PewterPokecenter1FChanseyText:
	text "CHANSEY: Chaaan"
	line "sey!"
	done

; BG1: Yellow's bench guy, drawn in the bench art at (0,4) and read only
; from (1,4) facing LEFT (vendor/pokeyellow/data/events/bench_guys.asm,
; _PewterCityPokecenterGuyText in data/text/text_2.asm; docs/BG1-BENCH-AND-SHELVES.md).
PewterPokecenter1FBenchGuyScript:
	jumptext PewterPokecenter1FBenchGuyText

PewterPokecenter1FBenchGuyText:
	text "Yawn!"

	para "When JIGGLYPUFF"
	line "sings, #MON"
	cont "get drowsy..."

	para "...Me too..."
	line "Snore..."
	done

PewterPokecenter1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, PEWTER_CITY, 4
	warp_event  4,  7, PEWTER_CITY, 4
	warp_event  0,  7, POKECENTER_2F, 1

	def_coord_events

	def_bg_events
	bg_event  0,  4, BGEVENT_LEFT, PewterPokecenter1FBenchGuyScript ; BG1 Yellow bench guy

	def_object_events
	object_event  3,  1, SPRITE_NURSE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PewterPokecenter1FNurseScript, -1
	object_event  8,  6, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, PewterPokecenter1FGentlemanScript, -1
	object_event  1,  3, SPRITE_JIGGLYPUFF_OW, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PewterJigglypuff, -1
	object_event  5,  3, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, PewterPokecenter1FCooltrainerFScript, -1
	object_event  4,  1, SPRITE_CHANSEY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PewterPokecenter1FChanseyScript, -1
