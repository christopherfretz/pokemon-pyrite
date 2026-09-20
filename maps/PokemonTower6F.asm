; Kanto hack (docs/M6-TOWER.md, 9a + 9h): Yellow's POKEMON_TOWER_6F
; (vendor/pokeyellow/data/maps/objects/PokemonTower6F.asm,
;  vendor/pokeyellow/scripts/PokemonTower6F.asm,
;  vendor/pokeyellow/text/PokemonTower6F.asm).
;
; 9a shipped the map, 9b its wild table, 9d the ghost battle engine.  9h adds
; the cast: Yellow's three CHANNELERs at (12,10)/(9,5)/(16,5), the RARE CANDY
; ball at (6,8), the X ACCURACY ball at (14,14), and THE MAROWAK BLOCK -- a
; coord_event at (10,16) (docs/M6-TOWER.md 2.5, 3.5).
;
; CLASS SUBSTITUTION (D12, operator-confirmed 2026-09-19): Crystal has no
; CHANNELER trainer class, so these fight as MEDIUM.  The overworld sprite IS
; Yellow's (SPRITE_CHANNELER); only the battle portrait and the class name
; differ.  Names are invented (D13) -- Yellow's channelers are nameless.
;
; SHAPE (scripts/mapgrid.py PokemonTower6F).  Two lobes joined only across
; row 3, plus a long southern tail:
;     01234567890123456789
;   2 ##########....######
;   3 #######.........####
;   4 ######.###..##..####
;   5 #####.......##...###
;   6 ####........##..####
;   7 ###.........##.....#
;   8 ######.#....##.....#
;   9 ######.#####......D#   <- (18,9) is the 5F stairs
;  10 ###.....####.......#
;  11 ######......###.####
;  12 #####.........#..###
;  13 ######..##..###.####
;  14 ######......##..####
;  15 ##########..########
;  16 #########D...#######   <- (9,16) is the 7F stairs, (10,16) the block
; ⚠ (10,16) IS THE ONLY WALKABLE NEIGHBOUR OF THE 7F STAIRS.  That is what
; makes Yellow's block work: with EVENT_BEAT_GHOST_MAROWAK clear you cannot
; stand next to the stairs without tripping the coord_event, and the no-Scope
; path ends by pushing you one step RIGHT to (11,16), away from them.
; ⚠ THE RARE CANDY AT (6,8) SITS ON THE ONLY WESTERN NORTH-SOUTH CORRIDOR
; (column 6, rows 7-10), so any route to the south half walks over it.
; ⚠ Crossing between the lobes forces (14,5)/(15,5), inside VERA's LEFT sight
; cone, and reaching the west of the north lobe forces (9,6)/(9,7), inside
; NORA's DOWN cone.  Both are unavoidable -- scripts/gen_states.sh pre-sets
; those two beat flags on the floor below rather than pretending otherwise.
	object_const_def
	const POKEMONTOWER6F_CHANNELER1
	const POKEMONTOWER6F_CHANNELER2
	const POKEMONTOWER6F_CHANNELER3
	const POKEMONTOWER6F_RARE_CANDY
	const POKEMONTOWER6F_X_ACCURACY

PokemonTower6F_MapScripts:
	def_scene_scripts

	def_callbacks

; Yellow CHANNELER 19 (vendor/pokeyellow/data/trainers/parties.asm:741), sight 3
; (vendor/pokeyellow/scripts/PokemonTower6F.asm PokemonTower6TrainerHeader0)
TrainerMediumAlma:
	trainer MEDIUM, ALMA, EVENT_BEAT_MEDIUM_ALMA, MediumAlmaSeenText, MediumAlmaBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext MediumAlmaAfterBattleText
	waitbutton
	closetext
	end

; Yellow CHANNELER 20 (:742), sight 3 (PokemonTower6TrainerHeader1)
TrainerMediumNora:
	trainer MEDIUM, NORA, EVENT_BEAT_MEDIUM_NORA, MediumNoraSeenText, MediumNoraBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext MediumNoraAfterBattleText
	waitbutton
	closetext
	end

; Yellow CHANNELER 21 (:743), sight 2 (PokemonTower6TrainerHeader2)
TrainerMediumVera:
	trainer MEDIUM, VERA, EVENT_BEAT_MEDIUM_VERA, MediumVeraSeenText, MediumVeraBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext MediumVeraAfterBattleText
	waitbutton
	closetext
	end

; THE MAROWAK BLOCK (docs/M6-TOWER.md 3.5).  Yellow's PokemonTower6FDefaultScript
; + PokemonTower6FMarowakBattleScript, collapsed into one GSC coord script.
;
; ⚠ NOTE FOR 9i: Yellow's 6F MAP script contains NO SILPH SCOPE CHECK AT ALL.
; The entire Scope difference lives in the battle engine -- IsGhostBattle (our
; CheckGhostBattle, engine/battle/ghost.asm) simply declines to set the ghost
; battle type when the Scope is in the bag, and the beginning-of-battle text
; branches on the same thing.  So the faithful port is ONE battle with a result
; branch, not two script paths:
;   * NO SCOPE  -> BATTLETYPE_GHOST; the ghost cannot be damaged (GhostTurn) or
;                  caught (GhostCantBeCaught), so the only exits are RUN (DRAW)
;                  and fainting (LOSE).  DRAW falls through to the push-right;
;                  LOSE white-outs inside reloadmapafterbattle.
;   * WITH SCOPE -> the battle still OPENS as the ghost and is unveiled on
;                  screen (9i: CheckGhostBattle keeps BATTLETYPE_GHOST for the
;                  MAROWAK, GhostBattleStartMessage prints Yellow's unveil text
;                  and calls RevealGhost), after which it is a plain wild L30
;                  MAROWAK: winnable -> `.defeated`, runnable -> the push-right,
;                  still uncatchable.  `loadwildmon MAROWAK, 30` already puts
;                  the real species in wTempWildMonSpecies/wEnemyMonSpecies,
;                  which is what RevealGhost:: needs, so 9i changed NOTHING in
;                  this file but these comments.
; GhostCantBeCaught already blocks the catch on 6F+MAROWAK regardless of the
; Scope, so the ball route to EVENT_BEAT_GHOST_MAROWAK stays closed after 9i too.
PokemonTower6FMarowakScript:
	checkevent EVENT_BEAT_GHOST_MAROWAK
	iftrue .calmed
	opentext
	writetext PokemonTower6FBeGoneText
	waitbutton
	closetext
	loadwildmon MAROWAK, 30
	startbattle
	ifequal WIN, .defeated ; reachable once the SILPH SCOPE is in the bag (9i)
	reloadmapafterbattle ; LOSE jumps to the whiteout here; nothing below runs
	applymovement PLAYER, PokemonTower6FPushedBackMovement
	end

.defeated
	reloadmapafterbattle
	setevent EVENT_BEAT_GHOST_MAROWAK
	opentext
	writetext PokemonTower6FGhostWasCubonesMotherText
	waitbutton
	cry MAROWAK
	pause 30
	writetext PokemonTower6FSoulWasCalmedText
	waitbutton
	closetext
	end

.calmed
	end

; Yellow pushes the player one tile RIGHT, off the stairs' only approach tile,
; by feeding PAD_RIGHT to the simulated joypad.  (10,16) -> (11,16).
PokemonTower6FPushedBackMovement:
	step RIGHT
	step_end

PokemonTower6FRareCandy:
	itemball RARE_CANDY

PokemonTower6FXAccuracy:
	itemball X_ACCURACY

PokemonTower6FBeGoneText:
	text "Be gone..."
	line "Intruders..."
	done

PokemonTower6FGhostWasCubonesMotherText:
	text "The GHOST was the"
	line "restless soul of"
	cont "CUBONE's mother!"
	done

PokemonTower6FSoulWasCalmedText:
	text "The mother's soul"
	line "was calmed."

	para "It departed to"
	line "the afterlife!"
	done

MediumAlmaSeenText:
	text "Give...me..."
	line "blood..."
	done

MediumAlmaBeatenText:
	text "Groan!"
	prompt

MediumAlmaAfterBattleText:
	text "I feel anemic and"
	line "weak..."
	done

MediumNoraSeenText:
	text "Urff... Kwaah!"
	done

MediumNoraBeatenText:
	text "Some-"
	line "thing fell out!"
	prompt

MediumNoraAfterBattleText:
	text "Hair didn't fall"
	line "out! It was an"
	cont "evil spirit!"
	done

MediumVeraSeenText:
	text "Ke..ke...ke..."
	line "ke..ke...ke!!"
	done

MediumVeraBeatenText:
	text "Keee!"
	prompt

MediumVeraAfterBattleText:
	text "What's going on"
	line "here?"
	done

PokemonTower6F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 18,  9, POKEMON_TOWER_5F, 2
	warp_event  9, 16, POKEMON_TOWER_7F, 1

	def_coord_events
	coord_event 10, 16, -1, PokemonTower6FMarowakScript

	def_bg_events

	def_object_events
	object_event 12, 10, SPRITE_CHANNELER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerMediumAlma, -1
	object_event  9,  5, SPRITE_CHANNELER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerMediumNora, -1
	object_event 16,  5, SPRITE_CHANNELER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerMediumVera, -1
	object_event  6,  8, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonTower6FRareCandy, EVENT_POKEMON_TOWER_6F_RARE_CANDY
	object_event 14, 14, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonTower6FXAccuracy, EVENT_POKEMON_TOWER_6F_X_ACCURACY
