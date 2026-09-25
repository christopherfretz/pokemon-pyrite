; Kanto hack (MEW1, docs/MEW1-SEALED-LAB.md): the POKeMON MANSION's SEALED LAB,
; a post-E4 room below B1F that is not in Yellow.  Its stair is revealed by the
; MEWTWO statue on B1F once the four MEWTWO diaries have been read in date
; order (maps/PokemonMansion2F.asm, 3F, B1F) with MEWTWO in the party.
;
; 5x5 blocks of TILESET_KANTO_LAB, existing metatiles only:
;   12 16 20 16 13   machines and tubes along the back wall
;   07 07 07 07 07
;   25 07 07 07 27   tube racks; $27 is the one with an EMPTY slot
;   28 07 07 07 06   the console desk (0..1,6) and a bookshelf
;   07 07 0c 07 07   the exit mat, WARP_CARPET_DOWN at (4,9)/(5,9)
;
; MEW uses SPRITE_FAIRY (the CLEFAIRY-shaped walking sprite, PAL_NPC_RED):
; the closest existing small pink POKeMON overworld sprite, so no new sprite.
; It wanders a 3x3 box around (6,3).  Reading the console prints the lab log,
; MEW flits over beside the player, and the battle is MEWTWO's M10P idiom
; (maps/CeruleanCaveB1F.asm): EVENT_BEAT_MEW is set on a catch, a KO or a run
; and is also the object's hide flag; a loss leaves MEW here.
	object_const_def
	const POKEMONMANSIONSEALEDLAB_MEW

PokemonMansionSealedLab_MapScripts:
	def_scene_scripts

	def_callbacks

; The console's two halves: the player stands at (0,7) or (1,7) facing UP.
PokemonMansionSealedLabConsoleLeft:
	checkevent EVENT_BEAT_MEW
	iftrue PokemonMansionSealedLabConsoleLog
	scall PokemonMansionSealedLabConsoleText
	moveobject POKEMONMANSIONSEALEDLAB_MEW, 2, 5
	sjump PokemonMansionSealedLabMewFlits

PokemonMansionSealedLabConsoleRight:
	checkevent EVENT_BEAT_MEW
	iftrue PokemonMansionSealedLabConsoleLog
	scall PokemonMansionSealedLabConsoleText
	moveobject POKEMONMANSIONSEALEDLAB_MEW, 3, 5
PokemonMansionSealedLabMewFlits:
	disappear POKEMONMANSIONSEALEDLAB_MEW
	appear POKEMONMANSIONSEALEDLAB_MEW
	playsound SFX_WARP_FROM
	applymovement POKEMONMANSIONSEALEDLAB_MEW, PokemonMansionSealedLabMewFlitMovement
	turnobject PLAYER, RIGHT
	showemote EMOTE_SHOCK, PLAYER, 15
PokemonMansionSealedLabMew:
	faceplayer
	opentext
	writetext PokemonMansionSealedLabMewText
	cry MEW
	waitbutton
	closetext
	loadwildmon MEW, 70
	loadvar VAR_BATTLETYPE, BATTLETYPE_NORMAL
	startbattle
	ifequal LOSE, .Fainted
	setevent EVENT_BEAT_MEW ; = the object's hide flag
	disappear POKEMONMANSIONSEALEDLAB_MEW
	reloadmapafterbattle
	end

.Fainted:
	reloadmapafterbattle
	end

PokemonMansionSealedLabConsoleText:
	opentext
	writetext PokemonMansionSealedLabLogText
	waitbutton
	closetext
	end

PokemonMansionSealedLabConsoleLog:
	jumptext PokemonMansionSealedLabLogText

PokemonMansionSealedLabMewFlitMovement:
	big_step DOWN
	big_step DOWN
	big_step LEFT
	step_end

PokemonMansionSealedLabLogText:
	text "A log is still on"
	line "the screen…"

	para "…The specimen"
	line "escaped its tube."

	para "It hides, but it"
	line "is very curious…"
	done

PokemonMansionSealedLabMewText:
	text "Mew!"
	done

PokemonMansionSealedLab_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4,  9, POKEMON_MANSION_B1F, 2
	warp_event  5,  9, POKEMON_MANSION_B1F, 2

	def_coord_events

	def_bg_events
	bg_event  0,  6, BGEVENT_UP, PokemonMansionSealedLabConsoleLeft
	bg_event  1,  6, BGEVENT_UP, PokemonMansionSealedLabConsoleRight

	def_object_events
	object_event  6,  3, SPRITE_FAIRY, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, PokemonMansionSealedLabMew, EVENT_BEAT_MEW
