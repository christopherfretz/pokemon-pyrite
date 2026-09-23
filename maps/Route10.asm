; Kanto hack (M5 8d): Yellow's ROUTE 10, merged back into one 10x36 map
; (vendor/pokeyellow/data/maps/objects/Route10.asm,
; vendor/pokeyellow/scripts/Route10.asm, vendor/pokeyellow/text/Route10.asm).
; Every warp, sign, hidden item and trainer below is on Yellow's own tile.
;
; The map is two lobes joined only through ROCK TUNNEL: the north lobe (tile
; rows 4-45) holds the Pokemon Center, the tunnel's north mouth and -- across
; water, so Surf-only, exactly as in Yellow -- the POWER PLANT door; the south
; lobe (rows 52-71) holds the tunnel's south mouth and the path down to
; LAVENDER TOWN.  Rows 46-51 are water and cliff: there is no land route.
	object_const_def
	const ROUTE10_POKEMANIAC1
	const ROUTE10_HIKER1
	const ROUTE10_POKEMANIAC2
	const ROUTE10_PICNICKER1
	const ROUTE10_HIKER2
	const ROUTE10_PICNICKER2

Route10_MapScripts:
	def_scene_scripts

	def_callbacks

; Yellow POKEMANIAC 1 (vendor/pokeyellow/data/trainers/parties.asm, POKEMANIAC 1)
TrainerPokemaniacOrville:
	trainer POKEMANIAC, ORVILLE, EVENT_BEAT_POKEMANIAC_ORVILLE, PokemaniacOrvilleSeenText, PokemaniacOrvilleBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PokemaniacOrvilleAfterBattleText
	waitbutton
	closetext
	end

; Yellow HIKER 7
TrainerHikerJim:
	trainer HIKER, JIM, EVENT_BEAT_HIKER_JIM, HikerJimSeenText, HikerJimBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext HikerJimAfterBattleText
	waitbutton
	closetext
	end

; Yellow POKEMANIAC 2
TrainerPokemaniacMelvin:
	trainer POKEMANIAC, MELVIN, EVENT_BEAT_POKEMANIAC_MELVIN, PokemaniacMelvinSeenText, PokemaniacMelvinBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PokemaniacMelvinAfterBattleText
	waitbutton
	closetext
	end

; Yellow JR_TRAINER_F 7
TrainerPicnickerGretchen:
	trainer PICNICKER, GRETCHEN, EVENT_BEAT_PICNICKER_GRETCHEN, PicnickerGretchenSeenText, PicnickerGretchenBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PicnickerGretchenAfterBattleText
	waitbutton
	closetext
	end

; Yellow HIKER 8
TrainerHikerOdell:
	trainer HIKER, ODELL, EVENT_BEAT_HIKER_ODELL, HikerOdellSeenText, HikerOdellBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext HikerOdellAfterBattleText
	waitbutton
	closetext
	end

; Yellow JR_TRAINER_F 8
TrainerPicnickerMabel:
	trainer PICNICKER, MABEL, EVENT_BEAT_PICNICKER_MABEL, PicnickerMabelSeenText, PicnickerMabelBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PicnickerMabelAfterBattleText
	waitbutton
	closetext
	end

Route10RockTunnelSign:
	jumptext Route10RockTunnelSignText

Route10PokecenterSign:
	jumpstd PokecenterSignScript

Route10PowerPlantSign:
	jumptext Route10PowerPlantSignText

Route10HiddenSuperPotion:
	hiddenitem SUPER_POTION, EVENT_ROUTE_10_HIDDEN_SUPER_POTION

Route10HiddenMaxEther:
	hiddenitem MAX_ETHER, EVENT_ROUTE_10_HIDDEN_MAX_ETHER

PokemaniacOrvilleSeenText:
	text "Wow, are you a"
	line "#MANIAC too?"
	cont "Want to see my"
	cont "collection?"
	done

PokemaniacOrvilleBeatenText:
	text "Humph."
	line "I'm not angry!"
	done

PokemaniacOrvilleAfterBattleText:
	text "I have more rare"
	line "#MON at home!"
	done

HikerJimSeenText:
	text "Ha-hahah-ah-ha!"
	done

HikerJimBeatenText:
	text "Ha-haha!"
	line "Not laughing!"
	cont "Ha-hay fever!"
	cont "Haha-ha-choo!"
	done

HikerJimAfterBattleText:
	text "Haha-ha-choo!"
	line "Ha-choo!"
	cont "Snort! Snivel!"
	done

PokemaniacMelvinSeenText:
	text "Hi, kid, want to"
	line "see my #MON?"
	done

PokemaniacMelvinBeatenText:
	text "Oh no!"
	line "My #MON!"
	done

PokemaniacMelvinAfterBattleText:
	text "I don't like you"
	line "for beating me!"
	done

PicnickerGretchenSeenText:
	text "I've been to a"
	line "#MON GYM a few"
	cont "times. But, I"
	cont "lost each time."
	done

PicnickerGretchenBeatenText:
	text "Ohh!"
	line "Blew it again!"
	done

PicnickerGretchenAfterBattleText:
	text "I noticed some"
	line "#MANIACs"
	cont "prowling around."
	done

HikerOdellSeenText:
	text "Ah! This mountain"
	line "air is delicious!"
	done

HikerOdellBeatenText:
	text "That"
	line "cleared my head!"
	done

HikerOdellAfterBattleText:
	text "I feel bloated on"
	line "mountain air!"
	done

PicnickerMabelSeenText:
	text "I'm feeling a bit"
	line "faint from this"
	cont "tough hike."
	done

PicnickerMabelBeatenText:
	text "I'm"
	line "not up to it!"
	done

PicnickerMabelAfterBattleText:
	text "The #MON here"
	line "are so chunky!"
	cont "There should be a"
	cont "pink one with a"
	cont "floral pattern!"
	done

Route10RockTunnelSignText:
	text "ROCK TUNNEL"
	done

Route10PowerPlantSignText:
	text "POWER PLANT"
	done

Route10_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 11, 19, ROUTE_10_POKECENTER_1F, 1
	warp_event  8, 17, ROCK_TUNNEL_1F, 1
	; M5 8e re-cut the tunnel on Yellow's geometry, which gave it Yellow's
	; EIGHT warps: the south mouth pairs with ROCK_TUNNEL_1F warp 3 now
	; (warps 2 and 4 are Yellow's dead duplicates of 1 and 3).
	warp_event  8, 53, ROCK_TUNNEL_1F, 3
	; Surf-only in Yellow -- the door sits on a shelf across the water channel.
	warp_event  6, 39, KANTO_POWER_PLANT, 1 ; M10 13l: Yellow's POWER PLANT (was Crystal's POWER_PLANT)

	def_coord_events

	def_bg_events
	bg_event  7, 19, BGEVENT_READ, Route10RockTunnelSign
	bg_event 12, 19, BGEVENT_READ, Route10PokecenterSign
	bg_event  9, 55, BGEVENT_READ, Route10RockTunnelSign
	bg_event  5, 41, BGEVENT_READ, Route10PowerPlantSign
	; Yellow hides the SUPER POTION at (9, 17) -- the rock face immediately EAST
	; of ROCK TUNNEL's north mouth (data/events/hidden_events.asm:211, the macro
	; writes y then x, so those really are x=9 y=17).  Gen 1 checks the tile in
	; FRONT of the player (CheckIfCoordsInFrontOfPlayerMatch), exactly like
	; BGEVENT_ITEM, and (9,17)'s only non-wall neighbour is the mouth tile (8,17)
	; itself: in Yellow you step out of the tunnel ONTO (8,17) and face right.
	; GSC cannot do that.  Arriving on a tile in CheckWarpFacingDown's list
	; (COLL_DOOR / COLL_CAVE / COLL_STAIRCASE / COLL_WARP_PANEL --
	; engine/overworld/tile_events.asm) walks the player one tile DOWN out of the
	; doorway, measured both here (tunnel -> (8,17) leaves you at (8,18)) and at
	; the Pokecenter door ((11,19) -> (11,20)); and stepping back onto (8,17)
	; re-fires the warp, so the player can never stand there.  The item therefore
	; moves one tile south, onto the rock/tree at (9, 18): same "face east of the
	; tunnel mouth" gesture, from the tile GSC actually leaves you on.
	bg_event  9, 18, BGEVENT_ITEM, Route10HiddenSuperPotion
	bg_event 16, 53, BGEVENT_ITEM, Route10HiddenMaxEther

	def_object_events
	object_event 10, 44, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 4, TrainerPokemaniacOrville, -1
	object_event  3, 57, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerHikerJim, -1
	object_event 14, 64, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 4, TrainerPokemaniacMelvin, -1
	object_event  7, 25, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerPicnickerGretchen, -1
	object_event  3, 61, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 2, TrainerHikerOdell, -1
	object_event  7, 54, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerPicnickerMabel, -1
