; Kanto hack (docs/M6-CELADON.md, 9s): Yellow's CELADON MANSION 3F -- the GAME
; FREAK development room.  Four devs, three PCs and the sign, all at Yellow's
; coordinates and with Yellow's text (vendor/pokeyellow/scripts/CeladonMansion3F
; .asm + text/CeladonMansion3F.asm).
;
; All four devs share one gate, Yellow's CeladonMansion3_PokedexCount:
;   ld hl, wPokedexOwned / ld b, wPokedexOwnedEnd - wPokedexOwned
;   call CountSetBits / cp NUM_POKEMON - 1 ; discount Mew
; i.e. "at least 150 of the 151 Kanto species owned" -- MEW is not required, but
; it does count if you have it.  Crystal's VAR_DEXCAUGHT counts all 251 flags,
; so `special KantoDexCaught` (engine/events/specials.asm) counts just the first
; 151 and `ifgreater MEW - 2` is Yellow's `cp NUM_POKEMON - 1`.  Crystal's
; EVENT_ENABLE_DIPLOMA_PRINTING two-step (designer unlocks, artist prints) is
; gone: in Yellow both NPCs test the dex directly, so the flag has no users.
	object_const_def
	const CELADONMANSION3F_PROGRAMMER
	const CELADONMANSION3F_GRAPHIC_ARTIST
	const CELADONMANSION3F_WRITER
	const CELADONMANSION3F_GAME_DESIGNER

CeladonMansion3F_MapScripts:
	def_scene_scripts

	def_callbacks

GameFreakProgrammerScript:
	faceplayer
	opentext
	special KantoDexCaught
	ifgreater MEW - 2, .CompletedDex
	writetext GameFreakProgrammerText
	waitbutton
	closetext
	end

.CompletedDex
	writetext GameFreakProgrammerCompletedDexText
	waitbutton
	closetext
	end

; Yellow: Text2 -> YesNoChoice -> PrintDiploma -> Text4 ("All done!"), or Text5
; if the printer was cancelled, or Text3 if the player declined.  Crystal's
; `special PrintDiploma` owns the whole printer UI and reports nothing back, so
; Text5 has no trigger here and is not ported.
GameFreakGraphicArtistScript:
	faceplayer
	opentext
	special KantoDexCaught
	ifgreater MEW - 2, .CompletedDex
	writetext GameFreakGraphicArtistText
	waitbutton
	closetext
	end

.CompletedDex
	writetext GameFreakGraphicArtistPrintDiplomaText
	yesorno
	iffalse .Declined
	special PrintDiploma
	writetext GameFreakGraphicArtistAllDoneText
	waitbutton
	closetext
	end

.Declined
	writetext GameFreakGraphicArtistDeclinedText
	waitbutton
	closetext
	end

GameFreakWriterScript:
	faceplayer
	opentext
	special KantoDexCaught
	ifgreater MEW - 2, .CompletedDex
	writetext GameFreakWriterText
	waitbutton
	closetext
	end

.CompletedDex
	writetext GameFreakWriterCompletedDexText
	waitbutton
	closetext
	end

; Yellow's GAME DESIGNER is `STAY NONE` -- he does not turn to face the player,
; so there is no `faceplayer` here.
GameFreakGameDesignerScript:
	opentext
	special KantoDexCaught
	ifgreater MEW - 2, .CompletedDex
	writetext GameFreakGameDesignerText
	waitbutton
	closetext
	end

.CompletedDex
	writetext GameFreakGameDesignerCompletedDexText
	promptbutton
	special Diploma
	writetext GameFreakGameDesignerShowItOffText
	waitbutton
	closetext
	end

CeladonMansion3FGameProgramPC:
	jumptext CeladonMansion3FGameProgramPCText

CeladonMansion3FPlayingGamePC:
	jumptext CeladonMansion3FPlayingGamePCText

CeladonMansion3FGameScriptPC:
	jumptext CeladonMansion3FGameScriptPCText

CeladonMansion3FDevRoomSign:
	jumptext CeladonMansion3FDevRoomSignText

GameFreakProgrammerText:
	text "Me? I'm the"
	line "programmer!"
	done

GameFreakProgrammerCompletedDexText:
	text "Me? I'm the"
	line "programmer!"

	para "What a surprise!"
	line "I never expected"
	cont "anyone to fill a"
	cont "#DEX."
	done

GameFreakGraphicArtistText:
	text "I'm the graphic"
	line "artist!"
	cont "I drew you!"
	done

GameFreakGraphicArtistPrintDiplomaText:
	text "I'm the graphic"
	line "artist!"

	para "Wow, you finished"
	line "your #DEX!"
	cont "Want me to PRINT"
	cont "out a DIPLOMA"
	cont "as proof?"
	done

GameFreakGraphicArtistDeclinedText:
	text "Just tell me if"
	line "you want to PRINT"
	cont "out a DIPLOMA."
	done

GameFreakGraphicArtistAllDoneText:
	text "All done!"
	done

GameFreakWriterText:
	text "I wrote the story!"
	line "Isn't ERIKA cute?"

	para "I like MISTY a"
	line "lot too!"

	para "Oh, and SABRINA,"
	line "I like her!"
	done

GameFreakWriterCompletedDexText:
	text "I wrote the story!"

	para "It's great you"
	line "caught all the"
	cont "#MON! Thanks!"
	done

GameFreakGameDesignerText:
	text "Is that right?"

	para "I'm the game"
	line "designer!"

	para "Filling up your"
	line "#DEX is tough,"
	cont "but don't quit!"

	para "When you finish,"
	line "come tell me!"
	done

GameFreakGameDesignerCompletedDexText:
	text "Wow! Excellent!"
	line "You completed"
	cont "your #DEX!"
	cont "Congratulations!"
	cont "…"
	done

GameFreakGameDesignerShowItOffText:
	text "Go show off your"
	line "DIPLOMA to"
	cont "the development"
	cont "crew."
	done

CeladonMansion3FGameProgramPCText:
	text "It's the game"
	line "program! Messing"
	cont "with it could bug"
	cont "out the game!"
	done

CeladonMansion3FPlayingGamePCText:
	text "Someone's playing"
	line "a game instead of"
	cont "working!"
	done

CeladonMansion3FGameScriptPCText:
	text "It's the script!"
	line "Better not look"
	cont "at the ending!"
	done

CeladonMansion3FDevRoomSignText:
	text "GAME FREAK"
	line "Development Room"
	done

CeladonMansion3F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  0,  0, CELADON_MANSION_ROOF, 1
	warp_event  1,  0, CELADON_MANSION_2F, 2
	warp_event  6,  0, CELADON_MANSION_2F, 3
	warp_event  7,  0, CELADON_MANSION_ROOF, 2

	def_coord_events

	def_bg_events
	bg_event  1,  3, BGEVENT_UP, CeladonMansion3FGameProgramPC
	bg_event  4,  3, BGEVENT_UP, CeladonMansion3FPlayingGamePC
	bg_event  1,  6, BGEVENT_UP, CeladonMansion3FGameScriptPC
	bg_event  5,  8, BGEVENT_UP, CeladonMansion3FDevRoomSign

	def_object_events
	object_event  0,  4, SPRITE_GYM_GUIDE, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, GameFreakProgrammerScript, -1
	object_event  3,  4, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, GameFreakGraphicArtistScript, -1
	object_event  0,  7, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, GameFreakWriterScript, -1
	object_event  2,  3, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, GameFreakGameDesignerScript, -1
