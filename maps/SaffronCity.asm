; Kanto hack (M8 11c, docs/M8-SAFFRON.md): SAFFRON CITY re-cut to Yellow's
; 20x18 map.  Warps, signs and NPCs are Yellow's, at Yellow's coordinates and
; in Yellow's order (vendor/pokeyellow/data/maps/objects/SaffronCity.asm);
; every Crystal-only object and text is gone -- the MAGNET TRAIN STATION and
; its sign, the JOHTO/radio/TRAINER HOUSE/POWER PLANT chatter and the seven
; EVENT_RETURNED_MACHINE_PART branches.
;
; Yellow's Saffron has no gate warps: the four SAFFRON gates live wholly on
; the ROUTE maps and the city <-> route transition is a plain `connection`
; (data/maps/attributes.asm already matches Yellow byte for byte).  Crystal's
; seven ROUTE_n_SAFFRON_GATE warp_events are therefore deleted, not
; re-pointed, and hack/maps/Route{5,6,7,8}SaffronGate.asm are untouched.
;
; TEAM ROCKET occupies the city until GIOVANNI falls on SILPH CO. 11F.  Yellow
; does that with its global data/maps/toggleable_objects.asm table, which GSC
; has no analogue for (D73/G1), so each object carries the hide flag instead:
;   ROCKET1-7          EVENT_BEAT_SILPH_CO_GIOVANNI  -- gone once SILPH is free
;   ROCKET8            EVENT_RESCUED_MR_FUJI         -- Yellow's two-stage
;                      unblock of SILPH's door (TOGGLE_SAFFRON_CITY_E, cleared
;                      by vendor/pokeyellow/scripts/PokemonTower7F.asm)
;   the six civilians  EVENT_SAFFRON_CITY_CIVILIANS_AFTER -- set at new game by
;                      InitializeEventsScript, cleared by 11k's takeover script,
;                      the same shape as RADIO TOWER's EVENT_..._CIVILIANS_AFTER
; Yellow's dangling ROCKET9 const (removed from its object list but still named
; in toggleable_objects.asm) is dropped entirely -- D88.

	object_const_def
	const SAFFRONCITY_ROCKET1
	const SAFFRONCITY_ROCKET2
	const SAFFRONCITY_ROCKET3
	const SAFFRONCITY_ROCKET4
	const SAFFRONCITY_ROCKET5
	const SAFFRONCITY_ROCKET6
	const SAFFRONCITY_ROCKET7
	const SAFFRONCITY_SCIENTIST
	const SAFFRONCITY_SILPH_WORKER_M
	const SAFFRONCITY_SILPH_WORKER_F
	const SAFFRONCITY_GENTLEMAN
	const SAFFRONCITY_PIDGEOT
	const SAFFRONCITY_ROCKER
	const SAFFRONCITY_ROCKET8

SaffronCity_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_NEWMAP, SaffronCityFlypointCallback
	callback MAPCALLBACK_TILES, SaffronCityStationCallback ; Kanto hack (M11 14h)

SaffronCityFlypointCallback:
	setflag ENGINE_FLYPOINT_SAFFRON
	endcallback

; Kanto hack (M11 14h, docs/M11-JOHTO.md D146): the MAGNET TRAIN STATION is
; built once the story turns to JOHTO (ENGINE_POKEGEAR, set by ELM).  It takes
; the two doorless office blocks WEST of the PIDGEY house (block columns 2-5,
; rows 4-5) and uses Crystal's station roof/wall blocks from
; vendor/pokecrystal/maps/SaffronCity.blk; the PIDGEY house and every Yellow
; warp stay put.  The door is step (8,11) = warp 9, a wall tile in the Kanto
; act, so that warp can only be stepped on once the station stands.
SaffronCityStationCallback:
	checkflag ENGINE_POKEGEAR
	iffalse .done
	changeblock  4,  8, $20
	changeblock  6,  8, $54
	changeblock  8,  8, $54
	changeblock 10,  8, $21
	changeblock  4, 10, $37
	changeblock  6, 10, $7d
	changeblock  8, 10, $3a
	changeblock 10, 10, $7e
.done
	endcallback

SaffronCityRocket1Script:
	jumptextfaceplayer SaffronCityRocket1Text

SaffronCityRocket2Script:
	jumptextfaceplayer SaffronCityRocket2Text

SaffronCityRocket3Script:
	jumptextfaceplayer SaffronCityRocket3Text

SaffronCityRocket4Script:
	jumptextfaceplayer SaffronCityRocket4Text

SaffronCityRocket5Script:
	jumptextfaceplayer SaffronCityRocket5Text

SaffronCityRocket6Script:
	jumptextfaceplayer SaffronCityRocket6Text

SaffronCityRocket7Script:
	jumptextfaceplayer SaffronCityRocket7Text

SaffronCityScientistScript:
	jumptextfaceplayer SaffronCityScientistText

SaffronCitySilphWorkerMScript:
	jumptextfaceplayer SaffronCitySilphWorkerMText

SaffronCitySilphWorkerFScript:
	jumptextfaceplayer SaffronCitySilphWorkerFText

SaffronCityGentlemanScript:
	jumptextfaceplayer SaffronCityGentlemanText

; Yellow's PIDGEOT text ends in sound_cry_pidgeot.
SaffronCityPidgeotScript:
	opentext
	writetext SaffronCityPidgeotText
	cry PIDGEOT
	waitbutton
	closetext
	end

SaffronCityRockerScript:
	jumptextfaceplayer SaffronCityRockerText

SaffronCityRocket8Script:
	jumptextfaceplayer SaffronCityRocket8Text

SaffronCitySign:
	jumptext SaffronCitySignText

FightingDojoSign:
	jumptext FightingDojoSignText

SaffronGymSign:
	jumptext SaffronGymSignText

SaffronCityMartSign:
	jumpstd MartSignScript

SaffronCityTrainerTips1Sign:
	jumptext SaffronCityTrainerTips1Text

SaffronCityTrainerTips2Sign:
	jumptext SaffronCityTrainerTips2Text

SilphCoSign:
	jumptext SilphCoSignText

SaffronCityPokecenterSign:
	jumpstd PokecenterSignScript

MrPsychicsHouseSign:
	jumptext MrPsychicsHouseSignText

SilphCoLatestProductSign:
	jumptext SilphCoLatestProductSignText

SaffronCityRocket1Text:
	text "What do you want?"
	line "Get lost!"
	done

SaffronCityRocket2Text:
	text "BOSS said he'll"
	line "take this town!"
	done

SaffronCityRocket3Text:
	text "Get out of the"
	line "way!"
	done

SaffronCityRocket4Text:
	text "SAFFRON belongs"
	line "to TEAM ROCKET!"
	done

SaffronCityRocket5Text:
	text "Being evil makes"
	line "me feel so alive!"
	done

SaffronCityRocket6Text:
	text "Ow! Watch where"
	line "you're walking!"
	done

SaffronCityRocket7Text:
	text "With SILPH under"
	line "control, we can"
	cont "exploit #MON"
	cont "around the world!"
	done

SaffronCityScientistText:
	text "You beat TEAM"
	line "ROCKET all alone?"
	cont "That's amazing!"
	done

SaffronCitySilphWorkerMText:
	text "Yeah! TEAM ROCKET"
	line "is gone!"
	cont "It's safe to go"
	cont "out again!"
	done

SaffronCitySilphWorkerFText:
	text "People should be"
	line "flocking back to"
	cont "SAFFRON now."
	done

SaffronCityGentlemanText:
	text "I flew here on my"
	line "PIDGEOT when I"
	cont "read about SILPH."

	para "It's already over?"
	line "I missed the"
	cont "media action."
	done

SaffronCityPidgeotText:
	text "PIDGEOT: Bi bibii!"
	done

SaffronCityRockerText:
	text "I saw ROCKET"
	line "BOSS escaping"
	cont "SILPH's building."
	done

SaffronCityRocket8Text:
	text "I'm a security"
	line "guard."

	para "Suspicious kids I"
	line "don't allow in!"
	done

SaffronCitySignText:
	text "SAFFRON CITY"
	line "Shining, Golden"
	cont "Land of Commerce"
	done

FightingDojoSignText:
	text "FIGHTING DOJO"
	done

SaffronGymSignText:
	text "SAFFRON CITY"
	line "#MON GYM"
	cont "LEADER: SABRINA"

	para "The Master of"
	line "Psychic #MON!"
	done

SaffronCityTrainerTips1Text:
	text "TRAINER TIPS"

	para "FULL HEAL cures"
	line "all ailments like"
	cont "sleep and burns."

	para "It costs a bit"
	line "more, but it's"
	cont "more convenient."
	done

SaffronCityTrainerTips2Text:
	text "TRAINER TIPS"

	para "New GREAT BALL"
	line "offers improved"
	cont "capture rates."

	para "Try it on those"
	line "hard-to-catch"
	cont "#MON."
	done

SilphCoSignText:
	text "SILPH CO."
	line "OFFICE BUILDING"
	done

MrPsychicsHouseSignText:
	text "MR.PSYCHIC's"
	line "HOUSE"
	done

SilphCoLatestProductSignText:
	text "SILPH's latest"
	line "product!"

	para "Release to be"
	line "determined…"
	done

SaffronCity_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  7,  5, COPYCATS_HOUSE_1F, 1
	warp_event 26,  3, FIGHTING_DOJO, 1
	warp_event 34,  3, SAFFRON_GYM, 1
	warp_event 13, 11, SAFFRON_PIDGEY_HOUSE, 1
	warp_event 25, 11, SAFFRON_MART, 1
	warp_event 18, 21, SILPH_CO_1F, 1
	warp_event  9, 29, SAFFRON_POKECENTER_1F, 1
	warp_event 29, 29, MR_PSYCHICS_HOUSE, 1
	warp_event  8, 11, SAFFRON_MAGNET_TRAIN_STATION, 1 ; Kanto hack (M11 14h): station door, Johto act only (a wall in the Kanto act)

	def_coord_events

	def_bg_events
	bg_event 17,  5, BGEVENT_READ, SaffronCitySign
	bg_event 27,  5, BGEVENT_READ, FightingDojoSign
	bg_event 35,  5, BGEVENT_READ, SaffronGymSign
	bg_event 26, 11, BGEVENT_READ, SaffronCityMartSign
	bg_event 39, 19, BGEVENT_READ, SaffronCityTrainerTips1Sign
	bg_event  5, 21, BGEVENT_READ, SaffronCityTrainerTips2Sign
	bg_event 15, 21, BGEVENT_READ, SilphCoSign
	bg_event 10, 29, BGEVENT_READ, SaffronCityPokecenterSign
	bg_event 27, 29, BGEVENT_READ, MrPsychicsHouseSign
	bg_event  1, 19, BGEVENT_READ, SilphCoLatestProductSign

	def_object_events
	object_event  7,  6, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SaffronCityRocket1Script, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event 20,  8, SPRITE_ROCKET, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SaffronCityRocket2Script, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event 34,  4, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SaffronCityRocket3Script, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event 13, 12, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SaffronCityRocket4Script, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event 11, 25, SPRITE_ROCKET, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SaffronCityRocket5Script, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event 32, 13, SPRITE_ROCKET, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SaffronCityRocket6Script, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event 18, 30, SPRITE_ROCKET, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SaffronCityRocket7Script, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event  8, 14, SPRITE_SCIENTIST, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SaffronCityScientistScript, EVENT_SAFFRON_CITY_CIVILIANS_AFTER
	object_event 23, 23, SPRITE_SILPH_WORKER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SaffronCitySilphWorkerMScript, EVENT_SAFFRON_CITY_CIVILIANS_AFTER
	object_event 17, 30, SPRITE_SILPH_WORKER_F, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SaffronCitySilphWorkerFScript, EVENT_SAFFRON_CITY_CIVILIANS_AFTER
	object_event 30, 12, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SaffronCityGentlemanScript, EVENT_SAFFRON_CITY_CIVILIANS_AFTER
	object_event 31, 12, SPRITE_BIRD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, SaffronCityPidgeotScript, EVENT_SAFFRON_CITY_CIVILIANS_AFTER ; Kanto hack (M8 11n): Yellow has this PIDGEOT STAY/DOWN, not bouncing (vendor/pokeyellow/data/maps/objects/SaffronCity.asm:55); SPRITEMOVEDATA_POKEMON bobs
	object_event 18,  8, SPRITE_ROCKER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SaffronCityRockerScript, EVENT_SAFFRON_CITY_CIVILIANS_AFTER
	object_event 18, 22, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SaffronCityRocket8Script, EVENT_RESCUED_MR_FUJI
