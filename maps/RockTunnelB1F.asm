; Kanto hack (M5 8f): Yellow's ROCK TUNNEL B1F
; (vendor/pokeyellow/data/maps/objects/RockTunnelB1F.asm,
; vendor/pokeyellow/scripts/RockTunnelB1F.asm, vendor/pokeyellow/text/RockTunnelB1F.asm).
; The .blk is re-cut from Yellow's by scripts/rock_tunnel_blk.py; every warp and
; trainer below is on Yellow's own tile, with Yellow's facing, sight range,
; party and text.  Crystal's three item balls (IRON, PP_UP, REVIVE) and its one
; hidden item (MAX_POTION) are gone -- Yellow's B1F has none; their four event
; flags were renamed in place for four of these trainers
; (constants/event_flags.asm).
;
; SHAPE.  B1F is TWO disjoint lobes (measured with scripts/cave_reach.py; 876
; reachable cells, identical to Yellow's):
;   ladder (33,25) .. ladder (27,3)   516 cells  -> 1F warps 5, 6
;   ladder (23,11) .. ladder (3,3)    360 cells  -> 1F warps 7, 8
; Together with 1F's three lobes this is what forces Yellow's zig-zag:
; Route 10 north -> 1F -> B1F -> 1F -> B1F -> 1F -> Route 10 south.  There is
; no path between the two lobes on B1F either; you must climb back up.
;
; WARP TILES.  All four ladders are Yellow's block $3e -> Crystal metatile $1b
; (FLOOR, FLOOR, FLOOR, LADDER) and all four coordinates are odd/odd, i.e. the
; bottom-right quadrant, so each warp tile really is COLL_LADDER.  LADDER is
; non-directional and absent from CheckWarpFacingDown, so the warp fires the
; instant you step on, exactly as Yellow does; a COLL_CAVE would force a step
; south into rock.
;
; SEALING.  Gen 1's CAVERN tile-pair collisions ($20/$41/$2a/$05 and $05/$21)
; fence off the light shelves that B1F draws with block ids $02 $17 $1f $20
; $22.  GSC has no tile pairs, so those five ids are re-cut as the sealed WALL
; clones the Mt. Moon fix added ($42-$47).  Every cell of all five is
; unreachable in Yellow, so the seal is per block id with no per-coordinate
; exceptions and no new metatiles.
	object_const_def
	const ROCKTUNNELB1F_PICNICKER1
	const ROCKTUNNELB1F_HIKER1
	const ROCKTUNNELB1F_POKEMANIAC1
	const ROCKTUNNELB1F_POKEMANIAC2
	const ROCKTUNNELB1F_HIKER2
	const ROCKTUNNELB1F_PICNICKER2
	const ROCKTUNNELB1F_HIKER3
	const ROCKTUNNELB1F_POKEMANIAC3

RockTunnelB1F_MapScripts:
	def_scene_scripts

	def_callbacks

; Yellow JR_TRAINER_F 9 (vendor/pokeyellow/data/trainers/parties.asm)
TrainerPicnickerRhoda:
	trainer PICNICKER, RHODA, EVENT_BEAT_PICNICKER_RHODA, PicnickerRhodaSeenText, PicnickerRhodaBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PicnickerRhodaAfterBattleText
	waitbutton
	closetext
	end

; Yellow HIKER 9
TrainerHikerLowell:
	trainer HIKER, LOWELL, EVENT_BEAT_HIKER_LOWELL, HikerLowellSeenText, HikerLowellBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext HikerLowellAfterBattleText
	waitbutton
	closetext
	end

; Yellow POKEMANIAC 3
TrainerPokemaniacCedric:
	trainer POKEMANIAC, CEDRIC, EVENT_BEAT_POKEMANIAC_CEDRIC, PokemaniacCedricSeenText, PokemaniacCedricBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PokemaniacCedricAfterBattleText
	waitbutton
	closetext
	end

; Yellow POKEMANIAC 4
TrainerPokemaniacAmos:
	trainer POKEMANIAC, AMOS, EVENT_BEAT_POKEMANIAC_AMOS, PokemaniacAmosSeenText, PokemaniacAmosBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PokemaniacAmosAfterBattleText
	waitbutton
	closetext
	end

; Yellow HIKER 10
TrainerHikerVernon:
	trainer HIKER, VERNON, EVENT_BEAT_HIKER_VERNON, HikerVernonSeenText, HikerVernonBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext HikerVernonAfterBattleText
	waitbutton
	closetext
	end

; Yellow JR_TRAINER_F 10
TrainerPicnickerOpal:
	trainer PICNICKER, OPAL, EVENT_BEAT_PICNICKER_OPAL, PicnickerOpalSeenText, PicnickerOpalBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PicnickerOpalAfterBattleText
	waitbutton
	closetext
	end

; Yellow HIKER 11 (the same party ROUTE 9's TIM uses -- Yellow shares it)
TrainerHikerConrad:
	trainer HIKER, CONRAD, EVENT_BEAT_HIKER_CONRAD, HikerConradSeenText, HikerConradBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext HikerConradAfterBattleText
	waitbutton
	closetext
	end

; Yellow POKEMANIAC 5
TrainerPokemaniacWaldo:
	trainer POKEMANIAC, WALDO, EVENT_BEAT_POKEMANIAC_WALDO, PokemaniacWaldoSeenText, PokemaniacWaldoBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PokemaniacWaldoAfterBattleText
	waitbutton
	closetext
	end

PicnickerRhodaSeenText:
	text "Hikers leave twigs"
	line "as trail markers."
	done

PicnickerRhodaBeatenText:
	text "Ohhh!"
	line "I did my best!"
	done

PicnickerRhodaAfterBattleText:
	text "I want to go "
	line "home!"
	done

HikerLowellSeenText:
	text "Hahaha! Can you"
	line "beat my power?"
	done

HikerLowellBeatenText:
	text "Oops!"
	line "Out-muscled!"
	done

HikerLowellAfterBattleText:
	text "I go for power"
	line "because I hate"
	cont "thinking!"
	done

PokemaniacCedricSeenText:
	text "You have a"
	line "#DEX?"
	cont "I want one too!"
	done

PokemaniacCedricBeatenText:
	text "Shoot!"
	line "I'm so jealous!"
	done

PokemaniacCedricAfterBattleText:
	text "When you finish"
	line "your #DEX, can"
	cont "I have it?"
	done

PokemaniacAmosSeenText:
	text "Do you know about"
	line "costume players?"
	done

PokemaniacAmosBeatenText:
	text "Well,"
	line "that's that."
	done

PokemaniacAmosAfterBattleText:
	text "Costume players"
	line "dress up as"
	cont "#MON for fun."
	done

HikerVernonSeenText:
	text "My #MON"
	line "techniques will"
	cont "leave you crying!"
	done

HikerVernonBeatenText:
	text "I give!"
	line "You're a better"
	cont "technician!"
	done

HikerVernonAfterBattleText:
	text "In mountains,"
	line "you'll often find"
	cont "rock-type #MON."
	done

PicnickerOpalSeenText:
	text "I don't often"
	line "come here, but I"
	cont "will fight you."
	done

PicnickerOpalBeatenText:
	text "Oh!"
	line "I lost!"
	done

PicnickerOpalAfterBattleText:
	text "I like tiny"
	line "#MON, big ones"
	cont "are too scary!"
	done

HikerConradSeenText:
	text "Hit me with your"
	line "best shot!"
	done

HikerConradBeatenText:
	text "Fired"
	line "away!"
	done

HikerConradAfterBattleText:
	text "I'll raise my"
	line "#MON to beat"
	cont "yours, kid!"
	done

PokemaniacWaldoSeenText:
	text "I draw #MON"
	line "when I'm home."
	done

PokemaniacWaldoBeatenText:
	text "Whew!"
	line "I'm exhausted!"
	done

PokemaniacWaldoAfterBattleText:
	text "I'm an artist,"
	line "not a fighter."
	done

RockTunnelB1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	; Yellow's own B1F ladder coordinates, paired with ROCK_TUNNEL_1F warps 5-8
	; in order (1F 5 <-> B1F 1, ... 1F 8 <-> B1F 4).
	warp_event 33, 25, ROCK_TUNNEL_1F, 5
	warp_event 27,  3, ROCK_TUNNEL_1F, 6
	warp_event 23, 11, ROCK_TUNNEL_1F, 7
	warp_event  3,  3, ROCK_TUNNEL_1F, 8

	def_coord_events

	def_bg_events

	def_object_events
	object_event 11, 13, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerPicnickerRhoda, -1
	object_event  6, 10, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerHikerLowell, -1
	object_event  3,  5, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerPokemaniacCedric, -1
	object_event 20, 21, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 4, TrainerPokemaniacAmos, -1
	object_event 30, 10, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerHikerVernon, -1
	object_event 14, 28, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerPicnickerOpal, -1
	object_event 33,  5, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerHikerConrad, -1
	object_event 26, 30, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerPokemaniacWaldo, -1
