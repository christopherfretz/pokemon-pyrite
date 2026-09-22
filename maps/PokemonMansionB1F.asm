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
; *** THE SECRET KEY BALL IS A STAND-IN. ***  D91 retires MACHINE_PART ($80)
; and renames that item slot SECRET_KEY in 12m; until then this ball hands out
; MACHINE_PART, which is already a KEY_ITEM (so it lands in wKeyItems, the same
; pocket the SECRET KEY will) and is otherwise unobtainable, so nothing
; regresses.  The ball's trailing event flag is ALREADY the real one --
; EVENT_GOT_SECRET_KEY, which CinnabarIsland's gym door checks -- so the gate
; is live today and 12m only swaps the item name on one line.
;
; WARP: the single staircase at (23,22) is block (11,11) $6e, whose top-right
; quadrant already reads STAIRCASE.
;
; 12l: the two secret switches at (20,3) and (18,25) and this floor's four
; movable gates hang off a `callback MAPCALLBACK_TILES,
; PokemonMansionB1FSwitchCallback` added below.  Gate blocks (Yellow block
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
	; 12l hangs the switches here:
	; callback MAPCALLBACK_TILES, PokemonMansionB1FSwitchCallback

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
	itemball MACHINE_PART ; D91/12m: becomes SECRET_KEY

PokemonMansionB1FDiary:
	jumptext PokemonMansionB1FDiaryText

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
	cont "tendencies…"
	done

PokemonMansionB1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 23, 22, POKEMON_MANSION_1F, 6

	def_coord_events

	def_bg_events
	bg_event  1,  9, BGEVENT_ITEM, PokemonMansionB1FHiddenRareCandy ; Yellow's hidden RARE CANDY (data/events/hidden_events.asm:135)

	def_object_events
	object_event 16, 23, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 0, TrainerPokemonMansionB1FBurglar, -1
	object_event 27, 11, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerPokemonMansionB1FScientist, -1
	object_event 10,  2, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonMansionB1FRareCandy, EVENT_POKEMON_MANSION_B1F_RARE_CANDY
	object_event  1, 22, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonMansionB1FFullRestore, EVENT_POKEMON_MANSION_B1F_FULL_RESTORE
	object_event 19, 25, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonMansionB1FTMBlizzard, EVENT_POKEMON_MANSION_B1F_TM_BLIZZARD
	object_event  5,  4, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonMansionB1FTMSolarbeam, EVENT_POKEMON_MANSION_B1F_TM_SOLARBEAM
	object_event 16, 20, SPRITE_POKEDEX, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PokemonMansionB1FDiary, -1
	object_event  5, 13, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonMansionB1FSecretKey, EVENT_GOT_SECRET_KEY
