; Kanto hack (M5 8e): Yellow's ROCK TUNNEL 1F
; (vendor/pokeyellow/data/maps/objects/RockTunnel1F.asm,
; vendor/pokeyellow/scripts/RockTunnel1F.asm, vendor/pokeyellow/text/RockTunnel1F.asm).
; The .blk is re-cut from Yellow's by scripts/rock_tunnel_blk.py; every warp,
; sign and trainer below is on Yellow's own tile, with Yellow's facing, sight
; range, party and text.  Crystal's two item balls (ELIXER, TM_STEEL_WING) and
; two hidden items (X_ACCURACY, X_DEFEND) are gone -- Yellow's 1F has none.
;
; SHAPE.  1F is not a corridor, it is THREE disjoint lobes (measured with
; scripts/cave_reach.py; 782 reachable cells, identical to Yellow's):
;   north mouth (15,3) .. ladder (37,3)      192 cells  -> B1F warp 1
;   ladder (5,3) .. ladder (17,11)           248 cells  -> B1F warps 2, 3
;   ladder (37,17) .. south mouth (15,33)    339 cells  -> B1F warp 4
; You CANNOT cross Rock Tunnel on 1F; Yellow makes you drop to B1F and climb
; back twice.  That is why 8f (B1F's blocks) has to land before the tunnel is
; walkable end to end.
;
; WARP TILES.  Yellow's cave mouths are NOT door tiles: CAVERN does not appear
; in vendor/pokeyellow/data/tilesets/door_tile_ids.asm at all, so Yellow never
; walks the player a step inward on arrival.  Both mouths therefore ship as
; COLL_LADDER (Crystal metatile $1b, the art of Yellow's own block $3e), not
; COLL_CAVE: COLL_CAVE is in CheckWarpFacingDown's list
; (engine/overworld/tile_events.asm) and would force a step south, and the tile
; south of the south mouth -- (15,34), Yellow block $52 -- is solid rock.  The
; four ladders down are COLL_LADDER too ($1f, the art of Yellow's block $28).
; LADDER is non-directional, so all six fire the instant you step on, which is
; Yellow's behaviour; a WARP_CARPET would need a second button press.
;
; Warps 2 (15,0) and 4 (15,35) are Yellow's own dead duplicates -- ROUTE 10
; only ever targets 1 and 3 -- and are kept so warps 5-8 keep Yellow's indices.
; (15,35) is solid rock on both sides, exactly as Yellow draws it.
	object_const_def
	const ROCKTUNNEL1F_HIKER1
	const ROCKTUNNEL1F_HIKER2
	const ROCKTUNNEL1F_HIKER3
	const ROCKTUNNEL1F_POKEMANIAC
	const ROCKTUNNEL1F_PICNICKER1
	const ROCKTUNNEL1F_PICNICKER2
	const ROCKTUNNEL1F_PICNICKER3

RockTunnel1F_MapScripts:
	def_scene_scripts

	def_callbacks

; Yellow HIKER 12 (vendor/pokeyellow/data/trainers/parties.asm)
TrainerHikerRoscoe:
	trainer HIKER, ROSCOE, EVENT_BEAT_HIKER_ROSCOE, HikerRoscoeSeenText, HikerRoscoeBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext HikerRoscoeAfterBattleText
	waitbutton
	closetext
	end

; Yellow HIKER 13
TrainerHikerWilbur:
	trainer HIKER, WILBUR, EVENT_BEAT_HIKER_WILBUR, HikerWilburSeenText, HikerWilburBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext HikerWilburAfterBattleText
	waitbutton
	closetext
	end

; Yellow HIKER 14
TrainerHikerNorris:
	trainer HIKER, NORRIS, EVENT_BEAT_HIKER_NORRIS, HikerNorrisSeenText, HikerNorrisBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext HikerNorrisAfterBattleText
	waitbutton
	closetext
	end

; Yellow POKEMANIAC 7
TrainerPokemaniacJasper:
	trainer POKEMANIAC, JASPER, EVENT_BEAT_POKEMANIAC_JASPER, PokemaniacJasperSeenText, PokemaniacJasperBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PokemaniacJasperAfterBattleText
	waitbutton
	closetext
	end

; Yellow JR_TRAINER_F 17
TrainerPicnickerThelma:
	trainer PICNICKER, THELMA, EVENT_BEAT_PICNICKER_THELMA, PicnickerThelmaSeenText, PicnickerThelmaBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PicnickerThelmaAfterBattleText
	waitbutton
	closetext
	end

; Yellow JR_TRAINER_F 18
TrainerPicnickerNellie:
	trainer PICNICKER, NELLIE, EVENT_BEAT_PICNICKER_NELLIE, PicnickerNellieSeenText, PicnickerNellieBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PicnickerNellieAfterBattleText
	waitbutton
	closetext
	end

; Yellow JR_TRAINER_F 19
TrainerPicnickerMyrna:
	trainer PICNICKER, MYRNA, EVENT_BEAT_PICNICKER_MYRNA, PicnickerMyrnaSeenText, PicnickerMyrnaBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PicnickerMyrnaAfterBattleText
	waitbutton
	closetext
	end

RockTunnel1FSign:
	jumptext RockTunnel1FSignText

HikerRoscoeSeenText:
	text "This tunnel goes"
	line "a long way, kid!"
	done

HikerRoscoeBeatenText:
	text "Doh!"
	line "You win!"
	done

HikerRoscoeAfterBattleText:
	text "Watch for ONIX!"
	line "It can put the"
	cont "squeeze on you!"
	done

HikerWilburSeenText:
	text "Hmm. Maybe I'm"
	line "lost in here..."
	done

HikerWilburBeatenText:
	text "Ease up!"
	line "What am I doing?"
	cont "Which way is out?"
	done

HikerWilburAfterBattleText:
	text "That sleeping"
	line "#MON on ROUTE"
	cont "12 forced me to"
	cont "take this detour."
	done

HikerNorrisSeenText:
	text "Outsiders like"
	line "you need to show"
	cont "me some respect!"
	done

HikerNorrisBeatenText:
	text "I give!"
	done

HikerNorrisAfterBattleText:
	text "You're talented"
	line "enough to hike!"
	done

PokemaniacJasperSeenText:
	text "#MON fight!"
	line "Ready, go!"
	done

PokemaniacJasperBeatenText:
	text "Game"
	line "over!"
	done

PokemaniacJasperAfterBattleText:
	text "Oh well, I'll get"
	line "a ZUBAT as I go!"
	done

PicnickerThelmaSeenText:
	text "Eek! Don't try"
	line "anything funny in"
	cont "the dark!"
	done

PicnickerThelmaBeatenText:
	text "It"
	line "was too dark!"
	done

PicnickerThelmaAfterBattleText:
	text "I saw a MACHOP"
	line "in this tunnel!"
	done

PicnickerNellieSeenText:
	text "I came this far"
	line "for #MON!"
	done

PicnickerNellieBeatenText:
	text "I'm"
	line "out of #MON!"
	done

PicnickerNellieAfterBattleText:
	text "You looked cute"
	line "and harmless!"
	done

PicnickerMyrnaSeenText:
	text "You have #MON!"
	line "Let's start!"
	done

PicnickerMyrnaBeatenText:
	text "You"
	line "play hard!"
	done

PicnickerMyrnaAfterBattleText:
	text "Whew! I'm all"
	line "sweaty now!"
	done

RockTunnel1FSignText:
	text "ROCK TUNNEL"
	line "CERULEAN CITY -"
	cont "LAVENDER TOWN"
	done

RockTunnel1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 15,  3, ROUTE_10, 2
	warp_event 15,  0, ROUTE_10, 2
	warp_event 15, 33, ROUTE_10, 3
	warp_event 15, 35, ROUTE_10, 3
	warp_event 37,  3, ROCK_TUNNEL_B1F, 1
	warp_event  5,  3, ROCK_TUNNEL_B1F, 2
	warp_event 17, 11, ROCK_TUNNEL_B1F, 3
	warp_event 37, 17, ROCK_TUNNEL_B1F, 4

	def_coord_events

	def_bg_events
	bg_event 11, 29, BGEVENT_READ, RockTunnel1FSign

	def_object_events
	object_event  7,  5, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerHikerRoscoe, -1
	object_event  5, 16, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerHikerWilbur, -1
	object_event 17, 15, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerHikerNorris, -1
	object_event 23,  8, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerPokemaniacJasper, -1
	object_event 37, 21, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerPicnickerThelma, -1
	object_event 22, 24, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerPicnickerNellie, -1
	object_event 32, 24, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerPicnickerMyrna, -1
