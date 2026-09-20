; Kanto hack (docs/M6-TOWER.md, 9a + 9f): Yellow's POKEMON_TOWER_4F
; (vendor/pokeyellow/data/maps/objects/PokemonTower4F.asm,
;  vendor/pokeyellow/scripts/PokemonTower4F.asm,
;  vendor/pokeyellow/text/PokemonTower4F.asm).
;
; 9a shipped the map, 9b its wild table.  9f adds the cast: Yellow's three
; CHANNELERs at (5,10)/(15,7)/(14,12) and the ELIXER / AWAKENING / HP UP balls at
; (12,10)/(9,10)/(12,16), each on Yellow's own tile with Yellow's facing, sight
; range, party and text (docs/M6-TOWER.md 2.3, 4.4, 5.1).
;
; Note Yellow's stairs are crossed here: (3,9) goes UP to 5F and (18,9) goes
; DOWN to 3F, the opposite sense to 3F and 5F.
;
; CLASS SUBSTITUTION (D12): see the header of maps/PokemonTower3F.asm.  These
; three are appended MEDIUM rows (8)-(10) with invented names (D13).
;
; ⚠ SIGHT CONE ON THE ONLY PATH.  The second channeler stands at (15,7) facing
; DOWN with sight 2; (15,8) and (15,9) are the ONLY two tiles that join the 3F
; staircase pocket (x=14..18) to the rest of the floor -- row 7 west of him is
; his own tile, (16,6)/(15,6) are wall, and (16,10) is wall.  So he cannot be
; walked around, which is exactly why Yellow put him there, and every
; scripts/gen_states.sh leg that crosses 4F westward must pre-set
; EVENT_BEAT_MEDIUM_EDITH.  The first channeler at (5,10) is avoidable (row 11
; runs parallel) but gen_states pre-flags him too, to keep the tower5f walk the
; same one 9a derived.  tower4f.state itself keeps all three ARMED.
	object_const_def
	const POKEMONTOWER4F_CHANNELER1
	const POKEMONTOWER4F_CHANNELER2
	const POKEMONTOWER4F_CHANNELER3
	const POKEMONTOWER4F_ELIXER
	const POKEMONTOWER4F_AWAKENING
	const POKEMONTOWER4F_HP_UP

PokemonTower4F_MapScripts:
	def_scene_scripts

	def_callbacks

; Yellow CHANNELER 9 (vendor/pokeyellow/data/trainers/parties.asm:725), sight 2
TrainerMediumAgnes:
	trainer MEDIUM, AGNES, EVENT_BEAT_MEDIUM_AGNES, MediumAgnesSeenText, MediumAgnesBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext MediumAgnesAfterBattleText
	waitbutton
	closetext
	end

; Yellow CHANNELER 10 (:726), sight 2 -- the only two-Pokémon channeler on 3F/4F
TrainerMediumEdith:
	trainer MEDIUM, EDITH, EVENT_BEAT_MEDIUM_EDITH, MediumEdithSeenText, MediumEdithBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext MediumEdithAfterBattleText
	waitbutton
	closetext
	end

; Yellow CHANNELER 12 (:730), sight 2
TrainerMediumHazel:
	trainer MEDIUM, HAZEL, EVENT_BEAT_MEDIUM_HAZEL, MediumHazelSeenText, MediumHazelBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext MediumHazelAfterBattleText
	waitbutton
	closetext
	end

PokemonTower4FElixer:
	itemball ELIXER

PokemonTower4FAwakening:
	itemball AWAKENING

PokemonTower4FHPUp:
	itemball HP_UP

MediumAgnesSeenText:
	text "GHOST! No!"
	line "Kwaaah!"
	done

MediumAgnesBeatenText:
	text "Where"
	line "is the GHOST?"
	prompt

MediumAgnesAfterBattleText:
	text "I must have been"
	line "dreaming..."
	done

MediumEdithSeenText:
	text "Be cursed with"
	line "me! Kwaaah!"
	done

MediumEdithBeatenText:
	text "What!"
	prompt

MediumEdithAfterBattleText:
	text "We can't crack"
	line "the identity of"
	cont "the GHOSTs."
	done

MediumHazelSeenText:
	text "Huhuhu..."
	line "Beat me not!"
	done

MediumHazelBeatenText:
	text "Huh?"
	line "Who? What?"
	prompt

MediumHazelAfterBattleText:
	text "May the departed"
	line "souls of #MON"
	cont "rest in peace..."
	done

PokemonTower4F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  9, POKEMON_TOWER_5F, 1
	warp_event 18,  9, POKEMON_TOWER_3F, 2

	def_coord_events

	def_bg_events

	def_object_events
	object_event  5, 10, SPRITE_CHANNELER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerMediumAgnes, -1
	object_event 15,  7, SPRITE_CHANNELER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerMediumEdith, -1
	object_event 14, 12, SPRITE_CHANNELER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerMediumHazel, -1
	object_event 12, 10, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonTower4FElixer, EVENT_POKEMON_TOWER_4F_ELIXER
	object_event  9, 10, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonTower4FAwakening, EVENT_POKEMON_TOWER_4F_AWAKENING
	object_event 12, 16, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonTower4FHPUp, EVENT_POKEMON_TOWER_4F_HP_UP
