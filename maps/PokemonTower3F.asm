; Kanto hack (docs/M6-TOWER.md, 9a + 9f): Yellow's POKEMON_TOWER_3F
; (vendor/pokeyellow/data/maps/objects/PokemonTower3F.asm,
;  vendor/pokeyellow/scripts/PokemonTower3F.asm,
;  vendor/pokeyellow/text/PokemonTower3F.asm).
;
; 9a shipped the map, 9b its wild table.  9f adds the cast: Yellow's three
; CHANNELERs at (12,3)/(9,8)/(10,13) and the ESCAPE ROPE ball at (12,1), each on
; Yellow's own tile with Yellow's facing, sight range, party and text
; (docs/M6-TOWER.md 2.2, 4.4, 5.1).
;
; CLASS SUBSTITUTION (D12, operator-confirmed 2026-09-19): Crystal has no
; CHANNELER trainer class, so these fight as MEDIUM.  The overworld sprite IS
; Yellow's (SPRITE_CHANNELER, byte-identical to pokeyellow's); only the battle
; portrait and the class name differ.  Names are Crystal's three dead MEDIUM rows
; rewritten in place (D13); Yellow gives its channelers no names at all.
;
; SHAPE.  The floor is four pockets joined by row 13 (x=5..17) and the row-6
; gallery (x=8..17):
;   west lobe      x=3..6,  rows 6..13   -> the 2F stairs at (3,9)
;   top corridor   rows 1..4             -> the ESCAPE ROPE, via (5,5)/(6,5)
;   middle block   x=8..13, rows 6..12
;   east lobe      x=15..18, rows 7..12  -> the 4F stairs at (18,9)
; None of the three sight cones blocks a crossing: (9,8) looks DOWN the x=9
; column (x=8 is parallel and clear), (10,13) looks DOWN off the corridor into
; the row-14/15 alcove, and (12,3) looks LEFT along row 3, which only the
; ESCAPE ROPE detour uses.  So scripts/gen_states.sh crosses 3F with every
; trainer still ARMED -- but it must route x=8, not x=9, and must NOT walk row 13
; past x=9, because the third channeler physically stands on (10,13).
	object_const_def
	const POKEMONTOWER3F_CHANNELER1
	const POKEMONTOWER3F_CHANNELER2
	const POKEMONTOWER3F_CHANNELER3
	const POKEMONTOWER3F_ESCAPE_ROPE

PokemonTower3F_MapScripts:
	def_scene_scripts

	def_callbacks

; Yellow CHANNELER 5 (vendor/pokeyellow/data/trainers/parties.asm:718), sight 2
TrainerMediumBethany:
	trainer MEDIUM, BETHANY, EVENT_BEAT_MEDIUM_BETHANY, MediumBethanySeenText, MediumBethanyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext MediumBethanyAfterBattleText
	waitbutton
	closetext
	end

; Yellow CHANNELER 6 (:719), sight 3
TrainerMediumMargret:
	trainer MEDIUM, MARGRET, EVENT_BEAT_MEDIUM_MARGRET, MediumMargretSeenText, MediumMargretBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext MediumMargretAfterBattleText
	waitbutton
	closetext
	end

; Yellow CHANNELER 8 (:723), sight 2
TrainerMediumEthel:
	trainer MEDIUM, ETHEL, EVENT_BEAT_MEDIUM_ETHEL, MediumEthelSeenText, MediumEthelBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext MediumEthelAfterBattleText
	waitbutton
	closetext
	end

PokemonTower3FEscapeRope:
	itemball ESCAPE_ROPE

MediumBethanySeenText:
	text "Urrg...Awaa..."
	line "Huhu...graa.."
	done

MediumBethanyBeatenText:
	text "Hwa!"
	line "I'm saved!"
	prompt

MediumBethanyAfterBattleText:
	text "The GHOSTs can be"
	line "identified by the"
	cont "SILPH SCOPE."
	done

MediumMargretSeenText:
	text "Kekeke...."
	line "Kwaaah!"
	done

MediumMargretBeatenText:
	text "Hmm?"
	line "What am I doing?"
	prompt

MediumMargretAfterBattleText:
	text "Sorry! I was"
	line "possessed!"
	done

MediumEthelSeenText:
	text "Be gone!"
	line "Evil spirit!"
	done

MediumEthelBeatenText:
	text "Whew!"
	line "The spirit left!"
	prompt

MediumEthelAfterBattleText:
	text "My friends were"
	line "possessed too!"
	done

PokemonTower3F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  9, POKEMON_TOWER_2F, 1
	warp_event 18,  9, POKEMON_TOWER_4F, 2

	def_coord_events

	def_bg_events

	def_object_events
	object_event 12,  3, SPRITE_CHANNELER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerMediumBethany, -1
	object_event  9,  8, SPRITE_CHANNELER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerMediumMargret, -1
	object_event 10, 13, SPRITE_CHANNELER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerMediumEthel, -1
	object_event 12,  1, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonTower3FEscapeRope, EVENT_POKEMON_TOWER_3F_ESCAPE_ROPE
