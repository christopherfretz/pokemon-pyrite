; Kanto hack: the PEWTER MUSEUM OF SCIENCE, upper floor (docs/M2-PEWTER.md, 4d).
; TILESET_GATE, like 1F.  Yellow's NPC positions are kept 1:1; Crystal has no
; SPRITE_HIKER or SPRITE_BRUNETTE_GIRL, so the pair by the meteorite are a
; POKEFAN_M and a LASS.

	object_const_def
	const MUSEUM2F_YOUNGSTER
	const MUSEUM2F_GRAMPS
	const MUSEUM2F_SCIENTIST
	const MUSEUM2F_GIRL
	const MUSEUM2F_FATHER

Museum2F_MapScripts:
	def_scene_scripts

	def_callbacks

Museum2FYoungsterScript:
	jumptextfaceplayer Museum2FYoungsterText

Museum2FGrampsScript:
	jumptextfaceplayer Museum2FGrampsText

Museum2FScientistScript:
	jumptextfaceplayer Museum2FScientistText

Museum2FGirlScript:
	jumptextfaceplayer Museum2FGirlText

; Yellow branches on wPikachuHappiness, which GSC has no equivalent of; the
; nearest thing is "is the starter Pikachu still with you", so the father asks
; for it only when it is not, and gives Yellow's "too attached to you" line
; when it is.  FindPartyMonThatSpeciesYourTrainerID is the same OT-ID test
; IsStarterPikachuInSlot does, but reachable from a script.
Museum2FFatherScript:
	faceplayer
	opentext
	setval PIKACHU
	special FindPartyMonThatSpeciesYourTrainerID
	iftrue .HasPikachu
	writetext Museum2FFatherText
	waitbutton
	closetext
	end

.HasPikachu:
	writetext Museum2FFatherPikachuText
	waitbutton
	closetext
	end

Museum2FSpaceShuttleSign:
	jumptext Museum2FSpaceShuttleSignText

Museum2FMoonStoneSign:
	jumptext Museum2FMoonStoneSignText

Museum2FYoungsterText:
	text "MOON STONE?"

	para "What's so special"
	line "about it?"
	done

Museum2FGrampsText:
	text "July 20, 1969!"

	para "The 1st lunar"
	line "landing!"

	para "I bought a color"
	line "TV to watch it!"
	done

Museum2FScientistText:
	text "We have a space"
	line "exhibit now."
	done

Museum2FGirlText:
	text "I want a PIKACHU!"
	line "It's so cute!"

	para "I asked my Daddy"
	line "to catch me one!"
	done

Museum2FFatherText:
	text "Yeah, a PIKACHU"
	line "soon, I promise!"
	done

Museum2FFatherPikachuText:
	text "I'd like to get"
	line "that PIKACHU off"
	cont "you, but it's too"
	cont "attached to you."
	done

Museum2FSpaceShuttleSignText:
	text "SPACE SHUTTLE"
	line "COLUMBIA"
	done

Museum2FMoonStoneSignText:
	text "Meteorite that"
	line "fell on MT.MOON."
	cont "(MOON STONE?)"
	done

Museum2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  7,  7, MUSEUM_1F, 5

	def_coord_events

	def_bg_events
	bg_event 11,  2, BGEVENT_READ, Museum2FSpaceShuttleSign
	bg_event  2,  5, BGEVENT_READ, Museum2FMoonStoneSign

	def_object_events
	object_event  1,  7, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Museum2FYoungsterScript, -1
	object_event  0,  5, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Museum2FGrampsScript, -1
	object_event  7,  5, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Museum2FScientistScript, -1
	object_event 11,  5, SPRITE_LASS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Museum2FGirlScript, -1
	object_event 12,  5, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, Museum2FFatherScript, -1
