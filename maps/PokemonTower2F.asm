; Kanto hack (docs/M6-TOWER.md, 9a + 9e): Yellow's POKEMON_TOWER_2F
; (vendor/pokeyellow/data/maps/objects/PokemonTower2F.asm,
;  vendor/pokeyellow/scripts/PokemonTower2F.asm, 178 lines).
;
; 9a shipped the map alone.  9e adds the cast: Yellow's fourth rival battle at
; (14,5) and the CHANNELER talker at (3,7) (3.2, 3.3, 2.1).
;
; Environment INDOOR: Yellow's 2F encounter rate is 0
; (vendor/pokeyellow/data/wild/maps/PokemonTower2F.asm), so this floor has no
; wild table at all and must not roll (3F-7F are DUNGEON, 9b).
;
; The rival stands in the ONE east-west corridor on the floor.  Row 5 (x=5..16)
; is the only link between the stairs side (east) and the 3F stairs side (west);
; rows 6-15 are two disconnected pockets.  So the two trigger tiles below, (15,5)
; coming west along row 5 and (14,6) coming north out of the east pocket, cannot
; be walked around -- which is exactly why Yellow put him here.
	object_const_def
	const POKEMONTOWER2F_RIVAL
	const POKEMONTOWER2F_CHANNELER

PokemonTower2F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_OBJECTS, PokemonTower2FObjectsCallback

; docs/PORTING.md 3.4: an object's hide flag is DERIVED from a stored fact on
; every map load, never toggled once, so a white-out in the middle of the scene
; cannot strand the rival (or, worse here, leave him standing in the only
; corridor with his trigger re-armed behind him).  The stored fact is
; EVENT_BEAT_POKEMON_TOWER_RIVAL -- the same derivation the shipped CERULEAN
; (6d) and ROUTE 22 rivals use.  Yellow does it by hand with HideObject +
; PokemonTower2FResetRivalEncounter.
PokemonTower2FObjectsCallback:
	checkevent EVENT_BEAT_POKEMON_TOWER_RIVAL
	iftrue .RivalGone
	clearevent EVENT_POKEMON_TOWER_2F_RIVAL_HIDDEN
	endcallback

.RivalGone:
	setevent EVENT_POKEMON_TOWER_2F_RIVAL_HIDDEN
	endcallback

; Yellow's PokemonTower2FDefaultScript, entry 1 (wCoordIndex == 1): the player
; walked west along row 5 onto (15,5) and is standing EAST of the rival.
; wPlayerMovingDirection = PLAYER_DIR_LEFT, the rival SPRITE_FACING_RIGHT.
PokemonTower2FRivalSceneEast:
	checkevent EVENT_BEAT_POKEMON_TOWER_RIVAL
	iftrue .Done
	playmusic MUSIC_KANTO_RIVAL + RIVAL_THEME_INTRO
	turnobject PLAYER, LEFT
	turnobject POKEMONTOWER2F_RIVAL, RIGHT
	scall PokemonTower2FRivalBattle
	turnobject PLAYER, LEFT
	turnobject POKEMONTOWER2F_RIVAL, RIGHT
	scall PokemonTower2FRivalHowsYourDex
	applymovement POKEMONTOWER2F_RIVAL, PokemonTower2F_RivalDownThenRight
	sjump PokemonTower2FRivalGone

.Done:
	end

; Entry 2 (any other wCoordIndex): the player came up out of the east pocket
; onto (14,6) and is standing SOUTH of the rival.  PLAYER_DIR_UP, the rival
; SPRITE_FACING_DOWN.
PokemonTower2FRivalSceneSouth:
	checkevent EVENT_BEAT_POKEMON_TOWER_RIVAL
	iftrue .Done
	playmusic MUSIC_KANTO_RIVAL + RIVAL_THEME_INTRO
	turnobject PLAYER, UP
	turnobject POKEMONTOWER2F_RIVAL, DOWN
	scall PokemonTower2FRivalBattle
	turnobject PLAYER, UP
	turnobject POKEMONTOWER2F_RIVAL, DOWN
	scall PokemonTower2FRivalHowsYourDex
	applymovement POKEMONTOWER2F_RIVAL, PokemonTower2F_RivalRightThenDown
	sjump PokemonTower2FRivalGone

.Done:
	end

; Yellow: `ld a, OPP_RIVAL2 / ld a, [wRivalStarter] / add $1 / ld [wTrainerNo], a`
; (vendor/pokeyellow/scripts/PokemonTower2F.asm:148-152).  This is the project's
; FIRST consumer of the Eevee rule, and it is a ROW choice, not a species patch:
; `loadtrainer` only records the class/id, and ReadTrainerParty builds the party
; from ROM at battle start.  See engine/events/kanto_rival.asm for the full
; interface note; wScriptVar comes back holding Yellow's wRivalStarter value.
;
; ⚠ The three rows do NOT differ in slot 5 -- at the Tower the rival's ace is
; still an unevolved L25 EEVEE in all three, and only appears as
; JOLTEON/FLAREON/VAPOREON from SILPH CO. 7F on.  What varies is slots 2 and 3,
; the coverage against the evolution he did not pick.
;
; Losing is a plain GSC white-out, so nothing past `startbattle` runs, the beat
; flag stays clear, and the OBJECTS callback above re-arms the whole scene on the
; way back in -- what Yellow does by hand in PokemonTower2FDefeatedRivalScript's
; `cp LOST_BATTLE / jp z, PokemonTower2FResetRivalEncounter`.
;
; No `dontrestartmapmusic` (the S.S. ANNE 2F precedent, 7i): the battle puts the
; map song back by itself, exactly as Yellow's return path does, and the
; after-battle line is spoken over it before the rival's exit music starts.
PokemonTower2FRivalBattle:
	opentext
	writetext PokemonTower2FRivalWhatBringsYouHereText
	waitbutton
	closetext
	winlosstext PokemonTower2FRivalDefeatedText, PokemonTower2FRivalVictoryText
	setlasttalked POKEMONTOWER2F_RIVAL
	special GetKantoRivalStarter
	ifequal RIVAL_STARTER_JOLTEON, .Jolteon
	ifequal RIVAL_STARTER_FLAREON, .Flareon
	loadtrainer KANTO_RIVAL, KANTO_RIVAL_7 ; RIVAL_STARTER_VAPOREON
	sjump .Fight

.Jolteon:
	loadtrainer KANTO_RIVAL, KANTO_RIVAL_5
	sjump .Fight

.Flareon:
	loadtrainer KANTO_RIVAL, KANTO_RIVAL_6

.Fight:
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_POKEMON_TOWER_RIVAL
	return

; Yellow re-displays TEXT_POKEMONTOWER2F_RIVAL once the beat flag is set, which
; takes the text_asm's other branch (.HowsYourDexText), and only then stops the
; music and restarts MUSIC_MEET_RIVAL at Music_RivalAlternateStart as he walks
; off -- ported as RIVAL_THEME_ALT_START (K6a).
PokemonTower2FRivalHowsYourDex:
	opentext
	writetext PokemonTower2FRivalHowsYourDexText
	waitbutton
	closetext
	playmusic MUSIC_KANTO_RIVAL + RIVAL_THEME_ALT_START
	return

; `special RestartMapMusic`, not `playmapmusic`: PlayMapMusic is a no-op when
; wMapMusic already holds the map's song (home/audio.asm), and it does here,
; because this scene does not use `dontrestartmapmusic`.  Same reasoning as
; SSAnne2FRivalGone.
PokemonTower2FRivalGone:
	disappear POKEMONTOWER2F_RIVAL
	setevent EVENT_POKEMON_TOWER_2F_RIVAL_HIDDEN
	special RestartMapMusic
	end

; Yellow's PokemonTower2FRivalText is a text_asm branching on
; EVENT_BEAT_POKEMON_TOWER_RIVAL.  Neither branch is reachable on foot -- the two
; trigger tiles are the only tiles adjacent to him, so stepping next to him
; always starts the scene instead, and he is off the map afterwards -- but the
; object needs a script pointer and Yellow carries both halves, so keep both.
PokemonTower2FRivalScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_POKEMON_TOWER_RIVAL
	iftrue .AfterBattle
	writetext PokemonTower2FRivalWhatBringsYouHereText
	waitbutton
	closetext
	end

.AfterBattle:
	writetext PokemonTower2FRivalHowsYourDexText
	waitbutton
	closetext
	end

PokemonTower2FChannelerScript:
	jumptextfaceplayer PokemonTower2FChannelerText

; Yellow PokemonTower2FRivalDownThenRightMovement, taken when the player tripped
; (15,5) (Yellow: EVENT_POKEMON_TOWER_RIVAL_ON_LEFT set).  (14,5) -> (14,7) ->
; (18,7) -> (18,9), the 1F staircase; the two DOWNs first step him clear of the
; player standing on (15,5).
;
; ⚠ Yellow's EVENT_POKEMON_TOWER_RIVAL_ON_LEFT is deliberately NOT ported.  It
; exists only because Gen 1 splits this beat across three script-pointer states
; and has to remember, across the battle boundary, which tile was tripped.  GSC
; runs each coord_event as one linear script, so each entry tile already knows
; its own exit walk (the shipped S.S. ANNE and CERULEAN scenes are built the same
; way).  See constants/event_flags.asm.
PokemonTower2F_RivalDownThenRight:
	step DOWN
	step DOWN
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step DOWN
	step DOWN
	step_end

; Yellow PokemonTower2FRivalRightThenDownMovement, taken when the player tripped
; (14,6).  (14,5) -> (15,5) -> (15,7) -> (16,7) -> (16,9) -> (18,9), the same
; staircase; the first RIGHT steps him clear of the player standing on (14,6).
; DEVIATION: on this branch Yellow also runs PokemonTower2FPikachuMovementScript,
; which walks the follower out of the rival's way first.  We do not.  The follower
; IS on this map (mapsetup SpawnFollower runs on every warp), but GSC's scripted
; applymovement ignores NPC collision, so the rival simply walks through him and
; the beat completes -- verified in the harness by entering (14,6) from (15,6),
; the one approach that parks the follower on (15,6), a tile this walk crosses.
; The cost is a one-frame sprite overlap, not a stall; porting Yellow's Pikachu
; shuffle would need a second applymovement and a bank-local movement table for
; a case the player can only reach from one tile.  Revisit if it looks bad.
PokemonTower2F_RivalRightThenDown:
	step RIGHT
	step DOWN
	step DOWN
	step RIGHT
	step DOWN
	step DOWN
	step RIGHT
	step RIGHT
	step_end

PokemonTower2FRivalWhatBringsYouHereText:
	text "<RIVAL>: Hey,"
	line "<PLAYER>! What"
	cont "brings you here?"
	cont "Your #MON"
	cont "don't look dead!"

	para "I can at least"
	line "make them faint!"
	cont "Let's go, pal!"
	done

PokemonTower2FRivalDefeatedText:
	text "What?"
	line "You stinker!"

	para "I took it easy on"
	line "you too!"
	prompt

PokemonTower2FRivalVictoryText:
	text "<RIVAL>: Well,"
	line "look at all your"
	cont "wimpy #MON!"

	para "Toughen them up a"
	line "bit more!"
	prompt

PokemonTower2FRivalHowsYourDexText:
	text "How's your #DEX"
	line "coming, pal?"
	cont "I just caught a"
	cont "CUBONE!"

	para "I can't find the"
	line "grown-up MAROWAK"
	cont "yet!"

	para "I doubt there are"
	line "any left! Well, I"
	cont "better get going!"
	cont "I've got a lot to"
	cont "accomplish, pal!"

	para "Smell ya later!"
	done

PokemonTower2FChannelerText:
	text "Even we could not"
	line "identify the"
	cont "wayward GHOSTs!"

	para "A SILPH SCOPE"
	line "might be able to"
	cont "unmask them."
	done

PokemonTower2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  9, POKEMON_TOWER_3F, 1
	warp_event 18,  9, POKEMON_TOWER_1F, 3

	def_coord_events
; Yellow PokemonTower2FRivalEncounterEventCoords: `dbmapcoord 15, 5`,
; `dbmapcoord 14, 6`, then `db $0F ; end? (should be $ff?)`.
;
; ; BUG (Yellow, not ported): ArePlayerCoordsInArray wants a -1 terminator.
; $0F is eaten as a third entry's y, and the byte after it -- the first opcode
; of PokemonTower2FDefeatedRivalScript -- as its x, producing a phantom trigger
; at an unreachable coordinate.  It can never fire, so GSC's two coord_events
; are behaviourally identical and there is nothing observable to reproduce
; (docs/M6-TOWER.md 3.2).
	coord_event 15,  5, -1, PokemonTower2FRivalSceneEast
	coord_event 14,  6, -1, PokemonTower2FRivalSceneSouth

	def_bg_events

	def_object_events
	object_event 14,  5, SPRITE_KANTO_RIVAL, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PokemonTower2FRivalScript, EVENT_POKEMON_TOWER_2F_RIVAL_HIDDEN
	object_event  3,  7, SPRITE_CHANNELER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, PokemonTower2FChannelerScript, -1
