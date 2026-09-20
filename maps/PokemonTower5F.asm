; Kanto hack (docs/M6-TOWER.md, 9a + 9g): Yellow's POKEMON_TOWER_5F
; (vendor/pokeyellow/data/maps/objects/PokemonTower5F.asm,
;  vendor/pokeyellow/scripts/PokemonTower5F.asm,
;  vendor/pokeyellow/text/PokemonTower5F.asm).
;
; 9a shipped the map, 9b its wild table.  9g adds the cast: the purified-zone
; CHANNELER at (12,8), Yellow's four battling CHANNELERs at (17,7)/(14,3)/
; (6,10)/(9,16), the NUGGET ball at (6,14) and the four-tile purified zone
; (10,8)/(11,8)/(10,9)/(11,9) (docs/M6-TOWER.md 2.4, 3.7, 4.4, 5.1).
;
; CLASS SUBSTITUTION (D12, operator-confirmed 2026-09-19): Crystal has no
; CHANNELER trainer class, so these fight as MEDIUM.  The overworld sprite IS
; Yellow's (SPRITE_CHANNELER); only the battle portrait and the class name
; differ.  Names are invented (D13) -- Yellow's channelers are nameless.
;
; SHAPE.  The floor is a ring with a plug in the middle:
;   west lobe      x=3..4,  rows 8..11   -> the 4F stairs at (3,9)
;   row-7 corridor x=3..7   and x=12..18
;   row-6 gallery  x=4..17                (the only link between the two halves
;                                          of row 7)
;   middle block   x=8..13, rows 8..9     -- entered from the north ONLY at
;                                          (13,7)->(13,8); (12,8) is the
;                                          purified-zone CHANNELER's own tile
;   south ring     row 10 x=6..11, row 11 x=6..9, row 12 x=7..14,
;                  row 11 x=12..17, row 10 x=14..18
;   east lobe      x=17..18, rows 8..9   -> the 6F stairs at (18,9)
;   south alcove   rows 13..16           -> the NUGGET and MYRTLE
; ⚠ THE PURIFIED ZONE IS ON THE ONLY NORTH-SOUTH CORRIDOR.  Row 8 west of the
; middle block is walled and (12,8) is an NPC, so every route from the row-6
; gallery to the south ring runs (13,9) -> (12,9) -> (11,9), and (11,9) is a
; zone tile.  That is Yellow's design -- you are meant to be healed on the way
; through.  scripts/gen_states.sh therefore TAKES the heal on its 5F crossing
; (TALK to dismiss the text) instead of routing around it.
; The east lobe is reached from the south ring at (17,10)/(18,10), NOT down
; column 17 from row 6: (17,7) is OLIVE's own tile and (18,7) hangs off it, so
; the north half cannot reach the 6F stairs without going all the way round.
; None of the four sight cones sits on that route, so every 5F trainer stays
; ARMED in tower5f.state and in the tower6f leg that crosses the floor.
	object_const_def
	const POKEMONTOWER5F_CHANNELER1
	const POKEMONTOWER5F_CHANNELER2
	const POKEMONTOWER5F_CHANNELER3
	const POKEMONTOWER5F_CHANNELER4
	const POKEMONTOWER5F_CHANNELER5
	const POKEMONTOWER5F_NUGGET

PokemonTower5F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_NEWMAP, PokemonTower5FNewMapCallback

; D23.  Yellow re-arms the purified zone by clearing EVENT_IN_PURIFIED_ZONE on
; every frame the player is NOT standing in it (PokemonTower5FDefaultScript),
; and clears BIT_NO_BATTLES in the same breath.  GSC has no per-step map script,
; so the port re-arms on a map load instead: one heal per visit to 5F, which is
; D23's ruled default.  wildon here is not just tidiness -- wStatusFlags is
; SAVED, so an ESCAPE ROPE (there is one on 3F!) or a blackout taken while
; standing in the zone would otherwise leave the whole game encounter-free.
PokemonTower5FNewMapCallback:
	clearevent EVENT_POKEMON_TOWER_5F_IN_PURIFIED_ZONE
	wildon
	endcallback

; Yellow CHANNELER 14 (vendor/pokeyellow/data/trainers/parties.asm:734), sight 2
; (vendor/pokeyellow/scripts/PokemonTower5F.asm PokemonTower5TrainerHeader0)
TrainerMediumOlive:
	trainer MEDIUM, OLIVE, EVENT_BEAT_MEDIUM_OLIVE, MediumOliveSeenText, MediumOliveBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext MediumOliveAfterBattleText
	waitbutton
	closetext
	end

; Yellow CHANNELER 16 (:738), sight 3 (PokemonTower5TrainerHeader1)
TrainerMediumCora:
	trainer MEDIUM, CORA, EVENT_BEAT_MEDIUM_CORA, MediumCoraSeenText, MediumCoraBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext MediumCoraAfterBattleText
	waitbutton
	closetext
	end

; Yellow CHANNELER 17 (:739), sight 2 (PokemonTower5TrainerHeader2)
TrainerMediumRuby:
	trainer MEDIUM, RUBY, EVENT_BEAT_MEDIUM_RUBY, MediumRubySeenText, MediumRubyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext MediumRubyAfterBattleText
	waitbutton
	closetext
	end

; Yellow CHANNELER 18 (:740), sight 2 (PokemonTower5TrainerHeader3)
TrainerMediumMyrtle:
	trainer MEDIUM, MYRTLE, EVENT_BEAT_MEDIUM_MYRTLE, MediumMyrtleSeenText, MediumMyrtleBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext MediumMyrtleAfterBattleText
	waitbutton
	closetext
	end

; The purified-zone CHANNELER.  Yellow gives her no trainer header -- she is a
; pure talker standing beside the zone she sealed.
PokemonTower5FChannelerScript:
	jumptextfaceplayer PokemonTower5FChannelerText

; The four zone tiles, in Yellow's own array order
; (PokemonTower5FPurifiedZoneCoords: dbmapcoord 10,8 / 11,8 / 10,9 / 11,9).
; Yellow's script, in order: set BIT_NO_BATTLES, predef HealParty,
; GBFadeOutToWhite, Delay3 x2, GBFadeInFromWhite, then the text.  There is NO
; jingle -- the white flash is the whole presentation, so none is added here.
PokemonTower5FPurifiedZoneEnter:
	wildoff
	checkevent EVENT_POKEMON_TOWER_5F_IN_PURIFIED_ZONE
	iftrue .already_healed
	setevent EVENT_POKEMON_TOWER_5F_IN_PURIFIED_ZONE
	special HealParty
	special FadeOutToWhite
	pause 10
	special FadeInFromWhite
	opentext
	writetext PokemonTower5FPurifiedZoneText
	waitbutton
	closetext
.already_healed
	end

; The five walkable tiles that touch the zone: (9,8), (9,9), (12,9), (10,10),
; (11,10).  ((12,8) is the CHANNELER's body and the north side is solid wall.)
; Yellow clears BIT_NO_BATTLES the moment you are outside the array; this is
; the GSC equivalent.  ⚠ DEVIATION (D23): Yellow ALSO clears its heal latch
; here, so stepping out and back in re-heals.  One `clearevent
; EVENT_POKEMON_TOWER_5F_IN_PURIFIED_ZONE` in this script restores that exactly
; if the operator ever prefers it; D23's ruled default is one heal per visit.
PokemonTower5FPurifiedZoneLeave:
	wildon
	end

PokemonTower5FNugget:
	itemball NUGGET

PokemonTower5FChannelerText:
	text "Come, child! I"
	line "sealed this space"
	cont "with white magic!"

	para "You can rest here!"
	done

PokemonTower5FPurifiedZoneText:
	text "Entered purified,"
	line "protected zone!"

	para "<PLAYER>'s #MON"
	line "are fully healed!"
	done

MediumOliveSeenText:
	text "Give...me..."
	line "your...soul..."
	done

MediumOliveBeatenText:
	text "Gasp!"
	prompt

MediumOliveAfterBattleText:
	text "I was under"
	line "possession!"
	done

MediumCoraSeenText:
	text "You...shall..."
	line "join...us..."
	done

MediumCoraBeatenText:
	text "What"
	line "a nightmare!"
	prompt

MediumCoraAfterBattleText:
	text "I was possessed!"
	done

MediumRubySeenText:
	text "Zombies!"
	done

MediumRubyBeatenText:
	text "Ha?"
	prompt

MediumRubyAfterBattleText:
	text "I regained my"
	line "senses!"
	done

MediumMyrtleSeenText:
	text "Urgah..."
	line "Urff...."
	done

MediumMyrtleBeatenText:
	text "Whoo!"
	prompt

MediumMyrtleAfterBattleText:
	text "I fell to evil"
	line "spirits despite"
	cont "my training!"
	done

PokemonTower5F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  9, POKEMON_TOWER_4F, 1
	warp_event 18,  9, POKEMON_TOWER_6F, 1

	def_coord_events
	coord_event 10,  8, -1, PokemonTower5FPurifiedZoneEnter
	coord_event 11,  8, -1, PokemonTower5FPurifiedZoneEnter
	coord_event 10,  9, -1, PokemonTower5FPurifiedZoneEnter
	coord_event 11,  9, -1, PokemonTower5FPurifiedZoneEnter
	coord_event  9,  8, -1, PokemonTower5FPurifiedZoneLeave
	coord_event  9,  9, -1, PokemonTower5FPurifiedZoneLeave
	coord_event 12,  9, -1, PokemonTower5FPurifiedZoneLeave
	coord_event 10, 10, -1, PokemonTower5FPurifiedZoneLeave
	coord_event 11, 10, -1, PokemonTower5FPurifiedZoneLeave

	def_bg_events

	def_object_events
	object_event 12,  8, SPRITE_CHANNELER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, PokemonTower5FChannelerScript, -1
	object_event 17,  7, SPRITE_CHANNELER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerMediumOlive, -1
	object_event 14,  3, SPRITE_CHANNELER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerMediumCora, -1
	object_event  6, 10, SPRITE_CHANNELER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerMediumRuby, -1
	object_event  9, 16, SPRITE_CHANNELER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerMediumMyrtle, -1
	object_event  6, 14, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PokemonTower5FNugget, EVENT_POKEMON_TOWER_5F_NUGGET
