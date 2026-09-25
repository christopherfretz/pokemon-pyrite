; Kanto hack (M9 12k, docs/M9-CINNABAR.md 0.6 row 12k): POKeMON MANSION B1F,
; ported from Yellow -- two trainers, five item balls (including TM14 BLIZZARD,
; TM22 SOLARBEAM and the SECRET KEY) and the last page of the MEWTWO diary.
;
; Cast, coordinates and facings are Yellow's
; (vendor/pokeyellow/data/maps/objects/PokemonMansionB1F.asm); sight ranges are
; the second argument of Yellow's trainer headers
; (vendor/pokeyellow/scripts/PokemonMansionB1F.asm): 0 / 3.  Text is Yellow's
; (vendor/pokeyellow/text/PokemonMansionB1F.asm).
;
; TRAINERS: Yellow's BurglarData row 9 (L34 GROWLITHE / PONYTA) and
; ScientistData row 13 (L34 MAGNEMITE / ELECTRODE) are new here as BURGLAR_6
; and SCIENTIST_19.  The BURGLAR uses the SUPER NERD overworld sprite, as
; Yellow does.
;
; SECRET KEY: Yellow's (5,13) ball.  12k shipped it as a MACHINE_PART stand-in;
; 12m (D91) renamed item $80 to SECRET_KEY, so it is the real key now.  Its
; trailing flag EVENT_GOT_SECRET_KEY only hides the ball -- CINNABAR ISLAND's
; gym door checks the item itself (`checkitem SECRET_KEY`), as Yellow does.
;
; WARP: the single staircase at (23,22) is block (11,11) $6e, whose top-right
; quadrant already reads STAIRCASE.
;
; 12l: the two secret switches at (20,3) and (18,25) and this floor's four
; movable gates hang off a `callback MAPCALLBACK_TILES,
; PokemonMansionB1FSwitchCallback` (below).  Gate blocks (Yellow block
; coords, changeblock coords are 2x these):
;   (13,8) off $0e / on $2d | (6,11) off $0e / on $5f
;   (4,3)  off $5f / on $0e | (8,8)  off $54 / on $0e
	object_const_def
	const POKEMONMANSIONB1F_BURGLAR
	const POKEMONMANSIONB1F_SCIENTIST
	const POKEMONMANSIONB1F_RARE_CANDY
	const POKEMONMANSIONB1F_FULL_RESTORE
	const POKEMONMANSIONB1F_TM_BLIZZARD
	const POKEMONMANSIONB1F_TM_SOLARBEAM
	const POKEMONMANSIONB1F_DIARY
	const POKEMONMANSIONB1F_SECRET_KEY

PokemonMansionB1F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_TILES, PokemonMansionB1FSwitchCallback

; 12l: Yellow's MansionB1FCheckReplaceSwitchDoorBlocks, run on every
; load of this floor (Yellow: BIT_CUR_MAP_LOADED_1).  The gates live in a
; subroutine so the switch statue can redraw them in place, as Yellow does.
PokemonMansionB1FSwitchCallback:
	scall PokemonMansionB1FGates
	scall PokemonMansionB1FSealedLabBlocks ; MEW1
	endcallback

; MEW1: after the Kanto E4 a MEWTWO statue stands in the middle room at block
; (7,5) ($0e -> kanto_facility's switch statue $77, tiles (14,10)/(14,11));
; once opened, the room's north wall at block (8,4) becomes $6a, the same wall
; with a STAIRCASE at (16,9) -- warp 2, down to the SEALED LAB.  Before the E4
; nothing is drawn, so the Kanto act's B1F is Yellow's.
PokemonMansionB1FSealedLabBlocks:
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iffalse .Done
	changeblock 14, 10, $77
	checkevent EVENT_MANSION_SEALED_LAB_OPEN
	iffalse .Done
	changeblock 16, 8, $6a
.Done:
	end

PokemonMansionB1FGates:
	checkevent EVENT_MANSION_SWITCH_ON
	iftrue .On
	changeblock 26, 16, $0e ; Yellow block (13,8)
	changeblock 12, 22, $0e ; Yellow block (6,11)
	changeblock  8,  6, $5f ; Yellow block (4,3)
	changeblock 16, 16, $54 ; Yellow block (8,8)
	end

.On:
	changeblock 26, 16, $2d ; Yellow block (13,8)
	changeblock 12, 22, $5f ; Yellow block (6,11)
	changeblock  8,  6, $0e ; Yellow block (4,3)
	changeblock 16, 16, $0e ; Yellow block (8,8)
	end

; The statues (BGEVENT_UP, Yellow's SPRITE_FACING_UP hidden_events).
PokemonMansionB1FSwitch:
	scall PokemonMansionSwitchScript
	iffalse .NotPressed
	scall PokemonMansionB1FGates
	sjump PokemonMansionSwitchRedrawScript

.NotPressed:
	end

TrainerPokemonMansionB1FBurglar:
	trainer BURGLAR, BURGLAR_6, EVENT_BEAT_POKEMON_MANSION_B1F_BURGLAR, PokemonMansionB1FBurglarSeenText, PokemonMansionB1FBurglarBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PokemonMansionB1FBurglarAfterBattleText
	waitbutton
	closetext
	end

TrainerPokemonMansionB1FScientist:
	trainer SCIENTIST, SCIENTIST_19, EVENT_BEAT_POKEMON_MANSION_B1F_SCIENTIST, PokemonMansionB1FScientistSeenText, PokemonMansionB1FScientistBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PokemonMansionB1FScientistAfterBattleText
	waitbutton
	closetext
	end

PokemonMansionB1FRareCandy:
	itemball RARE_CANDY

PokemonMansionB1FFullRestore:
	itemball FULL_RESTORE

PokemonMansionB1FTMBlizzard:
	itemball TM_BLIZZARD

PokemonMansionB1FTMSolarbeam:
	itemball TM_SOLARBEAM

PokemonMansionB1FSecretKey:
	itemball SECRET_KEY

; MEW1: the Sept. 1 page.  Read fourth, after July 5 -> July 10 -> Feb. 6 (and
; for good once that has happened) it gains an appended page after Yellow's
; text and sets EVENT_MANSION_JOURNALS_IN_ORDER, which arms the statue.
PokemonMansionB1FDiary:
	scall PokemonMansionJournalTrackSept1
	iftrue .Appended
	jumptext PokemonMansionB1FDiaryText

.Appended:
	opentext
	writetext PokemonMansionB1FDiaryText
	promptbutton
	writetext PokemonMansionB1FDiaryAppendedText
	waitbutton
	closetext
	end

; MEW1: journal order tracking, shared by 2F/3F/B1F (all in "Map Scripts 30").
; Order state = how many of STEP_1..STEP_3 are set (0-3).  Reading page k:
; k = 1 restarts at 1; state k-1 advances to k; state k (a re-read) changes
; nothing; anything else is out of order and resets to 0.  Inert before the
; Kanto E4 and once the sequence is complete.
PokemonMansionJournalTrackJuly5:
	scall PokemonMansionJournalTrackActive
	iffalse .Done
	setevent EVENT_MANSION_JOURNAL_STEP_1
	clearevent EVENT_MANSION_JOURNAL_STEP_2
	clearevent EVENT_MANSION_JOURNAL_STEP_3
.Done:
	end

PokemonMansionJournalTrackJuly10:
	scall PokemonMansionJournalTrackActive
	iffalse .Done
	checkevent EVENT_MANSION_JOURNAL_STEP_3
	iftrue PokemonMansionJournalReset
	checkevent EVENT_MANSION_JOURNAL_STEP_2
	iftrue .Done
	checkevent EVENT_MANSION_JOURNAL_STEP_1
	iffalse PokemonMansionJournalReset
	setevent EVENT_MANSION_JOURNAL_STEP_2
.Done:
	end

PokemonMansionJournalTrackFeb6:
	scall PokemonMansionJournalTrackActive
	iffalse .Done
	checkevent EVENT_MANSION_JOURNAL_STEP_3
	iftrue .Done
	checkevent EVENT_MANSION_JOURNAL_STEP_2
	iffalse PokemonMansionJournalReset
	setevent EVENT_MANSION_JOURNAL_STEP_3
.Done:
	end

; Returns wScriptVar TRUE if the appended page should show.
PokemonMansionJournalTrackSept1:
	checkevent EVENT_MANSION_JOURNALS_IN_ORDER
	iftrue .Yes
	scall PokemonMansionJournalTrackActive
	iffalse .No
	checkevent EVENT_MANSION_JOURNAL_STEP_3
	iffalse .Reset
	setevent EVENT_MANSION_JOURNALS_IN_ORDER
.Yes:
	setval TRUE
	end

.Reset:
	scall PokemonMansionJournalReset
.No:
	setval FALSE
	end

PokemonMansionJournalReset:
	clearevent EVENT_MANSION_JOURNAL_STEP_1
	clearevent EVENT_MANSION_JOURNAL_STEP_2
	clearevent EVENT_MANSION_JOURNAL_STEP_3
	end

; TRUE iff post-Kanto-E4 and the sequence is not yet complete.
PokemonMansionJournalTrackActive:
	checkevent EVENT_MANSION_JOURNALS_IN_ORDER
	iftrue .No
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	end ; wScriptVar = the flag

.No:
	setval FALSE
	end

; MEW1: the MEWTWO statue (post-E4 only; BGEVENT_IFSET on the E4 flag, so it
; is inert -- and not drawn, see the callback -- in the Kanto act).
PokemonMansionB1FMewtwoStatue:
	checkevent EVENT_MANSION_SEALED_LAB_OPEN
	iftrue .AlreadyOpen
	checkevent EVENT_MANSION_JOURNALS_IN_ORDER
	iffalse .Plain
	checkpoke MEWTWO
	iffalse .Searching
	opentext
	writetext PokemonMansionB1FStatueSearchingText
	waitbutton
	writetext PokemonMansionB1FStatueReactsText
	waitbutton
	closetext
	earthquake 30
	playsound SFX_STRENGTH
	showemote EMOTE_SHOCK, PLAYER, 15
	changeblock 16, 8, $6a ; wall -> wall with a staircase down at (16,9)
	refreshmap
	earthquake 50
	waitsfx
	setevent EVENT_MANSION_SEALED_LAB_OPEN
	end

.Plain:
	jumptext PokemonMansionB1FStatueText

.Searching:
	opentext
	writetext PokemonMansionB1FStatueText
	promptbutton
	writetext PokemonMansionB1FStatueSearchingText
	waitbutton
	closetext
	end

.AlreadyOpen:
	jumptext PokemonMansionB1FStatueOpenText

PokemonMansionB1FMewtwoStatueEvent:
	conditional_event EVENT_BEAT_KANTO_ELITE_FOUR, PokemonMansionB1FMewtwoStatue

PokemonMansionB1FStatueText:
	text "It's a statue of"
	line "MEWTWO."
	done

PokemonMansionB1FStatueSearchingText:
	text "The statue's eyes"
	line "seem to be looking"
	cont "for something…"
	done

PokemonMansionB1FStatueReactsText:
	text "Your MEWTWO stares"
	line "back at it…"
	done

PokemonMansionB1FStatueOpenText:
	text "It's a statue of"
	line "MEWTWO."

	para "A cold draft comes"
	line "up the stairs."
	done

PokemonMansionB1FDiaryAppendedText:
	text "A later page is"
	line "pinned to it…"

	para "P.S. I sealed the"
	line "lab below the"
	cont "basement."

	para "Only MEWTWO can"
	line "open it again…"
	done

PokemonMansionB1FHiddenRareCandy:
	hiddenitem RARE_CANDY, EVENT_POKEMON_MANSION_B1F_HIDDEN_RARE_CANDY

PokemonMansionB1FBurglarSeenText:
	text "Uh-oh. Where am"
	line "I now?"
	done

PokemonMansionB1FBurglarBeatenText:
	text "Awooh!"
	prompt

PokemonMansionB1FBurglarAfterBattleText:
	text "You can find stuff"
	line "lying around."
	done

PokemonMansionB1FScientistSeenText:
	text "This place is"
	line "ideal for a lab."
	done

PokemonMansionB1FScientistBeatenText:
	text "What"
	line "was that for?"
	prompt

PokemonMansionB1FScientistAfterBattleText:
	text "I like it here!"
	line "It's conducive to"
	cont "my studies!"
	done

PokemonMansionB1FDiaryText:
	text "Diary; Sept. 1"
	line "MEWTWO is far too"
	cont "powerful."

	para "We have failed to"
	line "curb its vicious"
	cont "tendencies..."
	done

PokemonMansionB1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 23, 22, POKEMON_MANSION_1F, 6
	warp_event 16,  9, POKEMON_MANSION_SEALED_LAB, 1 ; MEW1: live only once block (8,4) is $6a

	def_coord_events

	def_bg_events
	bg_event 20,  3, BGEVENT_UP, PokemonMansionB1FSwitch ; Yellow's secret switch (data/events/hidden_events.asm)
	bg_event 18, 25, BGEVENT_UP, PokemonMansionB1FSwitch ; Yellow's secret switch (data/events/hidden_events.asm)
	bg_event  1,  9, BGEVENT_ITEM, PokemonMansionB1FHiddenRareCandy ; Yellow's hidden RARE CANDY (data/events/hidden_events.asm:135)
	bg_event 14, 10, BGEVENT_IFSET, PokemonMansionB1FMewtwoStatueEvent ; MEW1
	bg_event 14, 11, BGEVENT_IFSET, PokemonMansionB1FMewtwoStatueEvent ; MEW1

	def_object_events
	object_event 16, 23, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 0, TrainerPokemonMansionB1FBurglar, -1
	object_event 27, 11, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerPokemonMansionB1FScientist, -1
	object_event 10,  2, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonMansionB1FRareCandy, EVENT_POKEMON_MANSION_B1F_RARE_CANDY
	object_event  1, 22, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonMansionB1FFullRestore, EVENT_POKEMON_MANSION_B1F_FULL_RESTORE
	object_event 19, 25, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonMansionB1FTMBlizzard, EVENT_POKEMON_MANSION_B1F_TM_BLIZZARD
	object_event  5,  4, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonMansionB1FTMSolarbeam, EVENT_POKEMON_MANSION_B1F_TM_SOLARBEAM
	object_event 16, 20, SPRITE_POKEDEX, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PokemonMansionB1FDiary, -1
	object_event  5, 13, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonMansionB1FSecretKey, EVENT_GOT_SECRET_KEY
