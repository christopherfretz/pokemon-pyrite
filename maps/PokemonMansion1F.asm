; Kanto hack (M9 12k, docs/M9-CINNABAR.md 0.6 row 12k): POKeMON MANSION 1F,
; ported from Yellow -- the burnt-out lab where MEWTWO was made, and where the
; SECRET KEY to CINNABAR's GYM is hidden (on B1F).
;
; Cast, coordinates and facings are Yellow's
; (vendor/pokeyellow/data/maps/objects/PokemonMansion1F.asm); the SCIENTIST's
; sight range is the second argument of Yellow's trainer header
; (vendor/pokeyellow/scripts/PokemonMansion1F.asm: 3).  Text is Yellow's
; (vendor/pokeyellow/text/PokemonMansion1F.asm).
;
; TRAINER REUSE: Yellow's ScientistData row 4 backs BOTH SILPH CO. 3F and this
; map (L29 ELECTRODE / L29 WEEZING), so this map points at the existing
; SCIENTIST_10 rather than duplicating the party.
;
; WARPS.  Yellow warps on a COORDINATE match; Crystal only from a tile whose
; ATTRIBUTE is a warp (engine/overworld/tile_events.asm, CheckWarpCollision).
; Yellow's eight warps here land on six ordinary floor/carpet tiles and two
; staircases, so 12k gave the tileset what it needed:
;   - the four front-door tiles (4..7,27) and the two back-door tiles
;     (26..27,27) sit on blocks (2,13) $3f, (3,13) $3b and (13,13) $0e.  All
;     three block ids are used elsewhere for plain floor/carpet, so they could
;     not be re-attributed globally; instead kanto_facility grew three clones
;     -- $96/$97/$98 -- with Yellow's ART and WARP_CARPET_DOWN on the bottom
;     row, and this map's .blk uses them at those three block coordinates.
;     (This REPLACES 12g's interim $2c patch, which was lift-door art.)
;   - the 2F staircase at (5,10) is block (2,5) $3a and the B1F staircase at
;     (21,23) is block (10,11) $4e; each id occurs exactly ONCE across all 20
;     kanto_facility maps, so both got a plain global STAIRCASE override in
;     data/tilesets/kanto_facility_collision.asm.
; WARP_CARPET_DOWN is directional (CheckDirectionalWarp), so leaving by a door
; costs one extra press of DOWN versus Yellow.  That is SILPH CO. 1F's shipped
; front-door idiom and it is deliberate.
;
; 12l: the secret switch at (2,5) and this floor's four movable gates hang off
; a `callback MAPCALLBACK_TILES, PokemonMansion1FSwitchCallback` added below.
; Gate blocks (Yellow block coords, changeblock coords are 2x these):
;   (12,6) off $0e / on $2d | (8,3) off $2d / on $0e | (10,8) off $2d / on $0e
;   (13,13) off $2d / on $98  <-- NOT $0e: (13,13) is the back-door warp clone,
;   so painting Yellow's $0e there would silently kill warps 7 and 8.
	object_const_def
	const POKEMONMANSION1F_SCIENTIST
	const POKEMONMANSION1F_ESCAPE_ROPE
	const POKEMONMANSION1F_CARBOS

PokemonMansion1F_MapScripts:
	def_scene_scripts

	def_callbacks
	; 12l hangs the switch here:
	; callback MAPCALLBACK_TILES, PokemonMansion1FSwitchCallback

TrainerPokemonMansion1FScientist:
	trainer SCIENTIST, SCIENTIST_10, EVENT_BEAT_POKEMON_MANSION_1F_SCIENTIST, PokemonMansion1FScientistSeenText, PokemonMansion1FScientistBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PokemonMansion1FScientistAfterBattleText
	waitbutton
	closetext
	end

PokemonMansion1FEscapeRope:
	itemball ESCAPE_ROPE

PokemonMansion1FCarbos:
	itemball CARBOS

PokemonMansion1FHiddenMoonStone:
	hiddenitem MOON_STONE, EVENT_POKEMON_MANSION_1F_HIDDEN_MOON_STONE

PokemonMansion1FScientistSeenText:
	text "Who are you? There"
	line "shouldn't be"
	cont "anyone here."
	done

PokemonMansion1FScientistBeatenText:
	text "Ouch!"
	prompt

PokemonMansion1FScientistAfterBattleText:
	text "A key? I don't"
	line "know what you're"
	cont "talking about."
	done

PokemonMansion1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 27, CINNABAR_ISLAND, 1
	warp_event  5, 27, CINNABAR_ISLAND, 1
	warp_event  6, 27, CINNABAR_ISLAND, 1
	warp_event  7, 27, CINNABAR_ISLAND, 1
	warp_event  5, 10, POKEMON_MANSION_2F, 1
	warp_event 21, 23, POKEMON_MANSION_B1F, 1
	warp_event 26, 27, CINNABAR_ISLAND, 1
	warp_event 27, 27, CINNABAR_ISLAND, 1
	warp_event 16, 14, POKEMON_MANSION_3F, 4 ; landing from 3F's holes (16,14)/(17,14)

	def_coord_events

	def_bg_events
	bg_event  8, 16, BGEVENT_ITEM, PokemonMansion1FHiddenMoonStone ; Yellow's hidden MOON STONE (data/events/hidden_events.asm:547)

	def_object_events
	object_event 17, 17, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerPokemonMansion1FScientist, -1
	object_event 14,  3, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonMansion1FEscapeRope, EVENT_POKEMON_MANSION_1F_ESCAPE_ROPE
	object_event 18, 21, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonMansion1FCarbos, EVENT_POKEMON_MANSION_1F_CARBOS
