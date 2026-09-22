; Kanto hack (M9 12k, docs/M9-CINNABAR.md 0.6 row 12k): POKeMON MANSION 3F,
; ported from Yellow -- two trainers, two item balls and the third page of the
; MEWTWO diary.
;
; Cast, coordinates and facings are Yellow's
; (vendor/pokeyellow/data/maps/objects/PokemonMansion3F.asm); sight ranges are
; the second argument of Yellow's trainer headers
; (vendor/pokeyellow/scripts/PokemonMansion3F.asm): 0 / 2.  Text is Yellow's
; (vendor/pokeyellow/text/PokemonMansion3F.asm).
;
; TRAINERS: Yellow's BurglarData row 8 (L38 NINETALES) and ScientistData row 12
; (L33 MAGNEMITE / MAGNETON / VOLTORB) are new here as BURGLAR_5 and
; SCIENTIST_18.  The BURGLAR uses the SUPER NERD overworld sprite, as Yellow
; does.
;
; WARPS: (7,10) and (25,14) are $6f/$6e staircases that already read STAIRCASE;
; (6,1) sits on block (3,0) $73, an id used exactly once across the 20
; kanto_facility maps, so it got a plain global override in
; data/tilesets/kanto_facility_collision.asm.
;
; HOLES: Yellow's three DungeonWarps (scripts/PokemonMansion3F.asm) -- the
; floor gives way at (16,14)/(17,14) onto 1F (16,14) and at (19,14) onto 2F
; (18,14).  Gen 1 drops you on a coordinate match on plain floor; here the
; three tiles are COLL_PIT (blocks $99/$9a, clones of $01, see
; scripts/celadon_blk.py MANSION_BLOCKS) under warp rows 4-6, landing on
; destination-only anchor rows 1F #9 and 2F #5 (Seafoam 12e's idiom).  The
; region below the holes (x12-21, y14-17) is reachable only by falling, as in
; Yellow.
;
; 12l: the secret switch at (10,5) and this floor's two movable gates hang off
; a `callback MAPCALLBACK_TILES, PokemonMansion3FSwitchCallback` added below.
; Gate blocks (Yellow block coords, changeblock coords are 2x these):
;   (7,2) off $0e / on $5f | (7,5) off $5f / on $0e
	object_const_def
	const POKEMONMANSION3F_SUPER_NERD
	const POKEMONMANSION3F_SCIENTIST
	const POKEMONMANSION3F_MAX_POTION
	const POKEMONMANSION3F_IRON
	const POKEMONMANSION3F_DIARY

PokemonMansion3F_MapScripts:
	def_scene_scripts

	def_callbacks
	; 12l hangs the switch here:
	; callback MAPCALLBACK_TILES, PokemonMansion3FSwitchCallback

TrainerPokemonMansion3FBurglar:
	trainer BURGLAR, BURGLAR_5, EVENT_BEAT_POKEMON_MANSION_3F_BURGLAR, PokemonMansion3FBurglarSeenText, PokemonMansion3FBurglarBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PokemonMansion3FBurglarAfterBattleText
	waitbutton
	closetext
	end

TrainerPokemonMansion3FScientist:
	trainer SCIENTIST, SCIENTIST_18, EVENT_BEAT_POKEMON_MANSION_3F_SCIENTIST, PokemonMansion3FScientistSeenText, PokemonMansion3FScientistBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PokemonMansion3FScientistAfterBattleText
	waitbutton
	closetext
	end

PokemonMansion3FMaxPotion:
	itemball MAX_POTION

PokemonMansion3FIron:
	itemball IRON

PokemonMansion3FDiary:
	jumptext PokemonMansion3FDiaryText

PokemonMansion3FHiddenMaxRevive:
	hiddenitem MAX_REVIVE, EVENT_POKEMON_MANSION_3F_HIDDEN_MAX_REVIVE

PokemonMansion3FBurglarSeenText:
	text "This place is"
	line "like, huge!"
	done

PokemonMansion3FBurglarBeatenText:
	text "Ayah!"
	prompt

PokemonMansion3FBurglarAfterBattleText:
	text "I wonder where"
	line "my partner went."
	done

PokemonMansion3FScientistSeenText:
	text "My mentor once"
	line "lived here."
	done

PokemonMansion3FScientistBeatenText:
	text "Whew!"
	line "Overwhelming!"
	prompt

PokemonMansion3FScientistAfterBattleText:
	text "So, you're stuck?"
	line "Try jumping off"
	cont "over there!"
	done

PokemonMansion3FDiaryText:
	text "Diary: Feb. 6"
	line "MEW gave birth."

	para "We named the"
	line "newborn MEWTWO."
	done

PokemonMansion3F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  7, 10, POKEMON_MANSION_2F, 2
	warp_event  6,  1, POKEMON_MANSION_2F, 4
	warp_event 25, 14, POKEMON_MANSION_2F, 3
	warp_event 16, 14, POKEMON_MANSION_1F, 9 ; hole (Yellow DungeonWarp 0)
	warp_event 17, 14, POKEMON_MANSION_1F, 9 ; hole (Yellow DungeonWarp 1)
	warp_event 19, 14, POKEMON_MANSION_2F, 5 ; hole (Yellow DungeonWarp 2)

	def_coord_events

	def_bg_events
	bg_event  1,  9, BGEVENT_ITEM, PokemonMansion3FHiddenMaxRevive ; Yellow's hidden MAX REVIVE (data/events/hidden_events.asm:130)

	def_object_events
	object_event  5, 11, SPRITE_SUPER_NERD, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 0, TrainerPokemonMansion3FBurglar, -1
	object_event 20, 11, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, TrainerPokemonMansion3FScientist, -1
	object_event  1, 16, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonMansion3FMaxPotion, EVENT_POKEMON_MANSION_3F_MAX_POTION
	object_event 25,  5, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonMansion3FIron, EVENT_POKEMON_MANSION_3F_IRON
	object_event  6, 12, SPRITE_POKEDEX, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PokemonMansion3FDiary, -1
