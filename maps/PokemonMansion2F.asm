; Kanto hack (M9 12k, docs/M9-CINNABAR.md 0.6 row 12k): POKeMON MANSION 2F,
; ported from Yellow -- one BURGLAR, one item ball and the first two pages of
; the MEWTWO diary.
;
; Cast, coordinates and facings are Yellow's
; (vendor/pokeyellow/data/maps/objects/PokemonMansion2F.asm); the BURGLAR's
; sight range is the second argument of Yellow's trainer header
; (vendor/pokeyellow/scripts/PokemonMansion2F.asm: 0 -- talk-only).  Text is
; Yellow's (vendor/pokeyellow/text/PokemonMansion2F.asm).
;
; TRAINER: Yellow's BurglarData row 7 (L34 CHARMANDER / L34 CHARMELEON) is new
; here as BURGLAR_4 -- Crystal's three existing BURGLARs (DUNCAN, EDDIE, COREY)
; are live JOHTO trainers and cannot be re-pointed.  Yellow draws a BURGLAR
; with the SUPER NERD overworld sprite, so that is the sprite used, not
; Crystal's PHARMACIST.
;
; WARPS: all four are staircases on blocks whose bottom-left tile already reads
; STAIRCASE ($6e/$6f top-right) except (6,1), which sits on block (3,0) $6a --
; an id used exactly once across all 20 kanto_facility maps, so it got a plain
; global override in data/tilesets/kanto_facility_collision.asm.
;
; 12l: the secret switch at (2,11) and this floor's three movable gates hang
; off a `callback MAPCALLBACK_TILES, PokemonMansion2FSwitchCallback`
; (below).  Gate blocks (Yellow block coords, changeblock coords are 2x these):
;   (4,2) off $0e / on $5f | (9,4) off $54 / on $0e | (3,11) off $5f / on $0e
	object_const_def
	const POKEMONMANSION2F_SUPER_NERD
	const POKEMONMANSION2F_CALCIUM
	const POKEMONMANSION2F_DIARY1
	const POKEMONMANSION2F_DIARY2

PokemonMansion2F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_TILES, PokemonMansion2FSwitchCallback

; 12l: Yellow's Mansion2CheckReplaceSwitchDoorBlocks, run on every
; load of this floor (Yellow: BIT_CUR_MAP_LOADED_1).  The gates live in a
; subroutine so the switch statue can redraw them in place, as Yellow does.
PokemonMansion2FSwitchCallback:
	scall PokemonMansion2FGates
	endcallback

PokemonMansion2FGates:
	checkevent EVENT_MANSION_SWITCH_ON
	iftrue .On
	changeblock  8,  4, $0e ; Yellow block (4,2)
	changeblock 18,  8, $54 ; Yellow block (9,4)
	changeblock  6, 22, $5f ; Yellow block (3,11)
	end

.On:
	changeblock  8,  4, $5f ; Yellow block (4,2)
	changeblock 18,  8, $0e ; Yellow block (9,4)
	changeblock  6, 22, $0e ; Yellow block (3,11)
	end

; The statue (BGEVENT_UP, Yellow's SPRITE_FACING_UP hidden_event).
PokemonMansion2FSwitch:
	scall PokemonMansionSwitchScript
	iffalse .NotPressed
	scall PokemonMansion2FGates
	sjump PokemonMansionSwitchRedrawScript

.NotPressed:
	end

TrainerPokemonMansion2FBurglar:
	trainer BURGLAR, BURGLAR_4, EVENT_BEAT_POKEMON_MANSION_2F_BURGLAR, PokemonMansion2FBurglarSeenText, PokemonMansion2FBurglarBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PokemonMansion2FBurglarAfterBattleText
	waitbutton
	closetext
	end

PokemonMansion2FCalcium:
	itemball CALCIUM

; MEW1: after the Kanto E4 the diaries also count the reading order
; (PokemonMansionJournalTrack*, maps/PokemonMansionB1F.asm).  Silent flag
; work only; the text box is Yellow's jumptext, unchanged.
PokemonMansion2FDiary1:
	scall PokemonMansionJournalTrackJuly5
	jumptext PokemonMansion2FDiary1Text

PokemonMansion2FDiary2:
	scall PokemonMansionJournalTrackJuly10
	jumptext PokemonMansion2FDiary2Text

PokemonMansion2FBurglarSeenText:
	text "I can't get out!"
	line "This old place is"
	cont "one big puzzle!"
	done

PokemonMansion2FBurglarBeatenText:
	text "Oh no!"
	line "My bag of loot!"
	prompt

PokemonMansion2FBurglarAfterBattleText:
	text "Switches open and"
	line "close alternating"
	cont "sets of doors!"
	done

PokemonMansion2FDiary1Text:
	text "Diary: July 5"
	line "Guyana,"
	cont "South America"

	para "A new #MON was"
	line "discovered deep"
	cont "in the jungle."
	done

PokemonMansion2FDiary2Text:
	text "Diary: July 10"
	line "We christened the"
	cont "newly discovered"
	cont "#MON, MEW."
	done

PokemonMansion2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  5, 10, POKEMON_MANSION_1F, 5
	warp_event  7, 10, POKEMON_MANSION_3F, 1
	warp_event 25, 14, POKEMON_MANSION_3F, 3
	warp_event  6,  1, POKEMON_MANSION_3F, 2
	warp_event 18, 14, POKEMON_MANSION_3F, 6 ; landing from 3F's hole (19,14)

	def_coord_events

	def_bg_events
	bg_event  2, 11, BGEVENT_UP, PokemonMansion2FSwitch ; Yellow's secret switch (data/events/hidden_events.asm)

	def_object_events
	object_event  3, 17, SPRITE_SUPER_NERD, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 0, TrainerPokemonMansion2FBurglar, -1
	object_event 28,  7, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonMansion2FCalcium, EVENT_POKEMON_MANSION_2F_CALCIUM
	object_event 18,  2, SPRITE_POKEDEX, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PokemonMansion2FDiary1, -1
	object_event  3, 22, SPRITE_POKEDEX, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PokemonMansion2FDiary2, -1
