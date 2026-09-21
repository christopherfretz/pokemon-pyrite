; Kanto hack (docs/M6-TOWER.md, 9a/9j/9k): Yellow's POKEMON_TOWER_7F
; (vendor/pokeyellow/data/maps/objects/PokemonTower7F.asm,
; scripts/PokemonTower7F.asm, text/PokemonTower7F.asm).
;
; The floor holds exactly three objects and nothing else - no CHANNELERs, no
; item balls, no bg_events, one warp down to 6F.  Environment DUNGEON, wild
; table from 9b.
;
; 9j - JESSIE & JAMES.  Yellow's trigger is wYCoord == $c AND wXCoord == $a or
; $b (PokemonTower7FScript_60d2a), i.e. the two tiles (10,12) and (11,12), the
; full width of the corridor one row below the pair's approach lane.  Gen 1
; remembers which tile was tripped in EVENT_POKEMONTOWER_7_JESSIE_JAMES_ON_LEFT
; because its scene is split over twelve script-pointer states and has to read
; the answer back after the battle; GSC runs each coord_event as one linear
; script, so each entry tile carries its own choreography and the flag has no
; analogue - the same call 9e made for the 2F rival (constants/event_flags.asm).
;
; Yellow's choreography, beat for beat: MUSIC_MEET_JESSIE_JAMES, both objects
; shown, "Stop right there!", the player turned UP with an exclamation bubble
; over him, JESSIE walks down the lane and turns to face the player, then JAMES
; does, then the threat text, the battle, the blast-off line, a fade to black
; with both objects removed, and the map song back.
;
; The two approach walks are Yellow's PokemonTower7FMovementData_60d7a (4 steps)
; and _60d7b (3 steps), swapped between the pair by the ON_LEFT flag.  As at
; Mt. Moon B2F (5h) the per-step byte is overridden by the objects' declared
; STAY/DOWN facing, so they are DOWN steps, and the arithmetic is the only
; reading that fits the corridor:
;
;   player (10,12): JESSIE (10,8) +3 -> (10,11), above him, facing DOWN
;                   JAMES  (11,8) +4 -> (11,12), right of him, facing LEFT
;   player (11,12): JESSIE (10,8) +4 -> (10,12), left of him, facing RIGHT
;                   JAMES  (11,8) +3 -> (11,11), above him, facing DOWN
;
; Losing is a plain GSC white-out: `reloadmapafterbattle` jumps to it, the beat
; flag stays clear and the OBJECTS callback below re-hides the pair on the way
; back in, which is exactly what Yellow's PokemonTower7FScript8 does by hand
; (`cp LOST_BATTLE / jp z, PokemonTower7FSetDefaultScript`).
;
; No `dontrestartmapmusic` (the S.S. ANNE 2F / TOWER 2F precedent): Yellow's
; PokemonTower7FScript8 speaks the blast-off line over the restored map song and
; only then restarts MUSIC_MEET_JESSIE_JAMES for the exit, so the battle putting
; the map song back by itself is the faithful path.  The tail therefore ends in
; `special RestartMapMusic`, not `playmapmusic` (a no-op while wMapMusic already
; holds the map's song).
;
; 9k - MR FUJI.  Talking to him prints the rescue speech and warps the player
; straight to MR FUJI'S HOUSE (Yellow does it from a deferred script state,
; PokemonTower7FWarpToMrFujiHouseScript: hide MR FUJI, face the player UP,
; warp to MR_FUJIS_HOUSE warp id 1 - which is our (2,7)).  GSC spells the
; facing half of that as `warpfacing UP, ...`.
;
; His 7F object row hides on EVENT_RESCUED_MR_FUJI itself.  A GSC object flag is
; a HIDE flag, and here the polarity already matches the story flag - he is on
; the tower iff he has not been rescued - so no dedicated hide flag and no
; callback are needed.  (MR FUJI'S HOUSE needs both because there the polarity is
; inverted; hack/maps/MrFujisHouse.asm:36-44.)  `disappear` sets the row's flag,
; so it sets EVENT_RESCUED_MR_FUJI a second time, harmlessly.
;
; Flags: two appends, EVENT_BEAT_POKEMON_TOWER_JESSIE_JAMES and
; EVENT_POKEMON_TOWER_7F_JESSIE_JAMES_HIDDEN; EVENT_RESCUED_MR_FUJI already
; exists (M5 8h) and is only set here.
	object_const_def
	const POKEMONTOWER7F_JESSIE
	const POKEMONTOWER7F_JAMES
	const POKEMONTOWER7F_MR_FUJI

PokemonTower7F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_OBJECTS, PokemonTower7FObjectsCallback

; JESSIE and JAMES are never on the map at load time: before the scene they have
; not shown up yet, after it they have blasted off, and a white-out in between
; must not leave them standing there (`appear` cleared the flag).
PokemonTower7FObjectsCallback:
	setevent EVENT_POKEMON_TOWER_7F_JESSIE_JAMES_HIDDEN
	endcallback

; (10,12): the pair end up above and to the right of the player.
PokemonTower7FJessieJamesSceneFromLeftTile:
	checkevent EVENT_BEAT_POKEMON_TOWER_JESSIE_JAMES
	iftrue .Done
	playmusic MUSIC_MEET_JESSIE_JAMES
	appear POKEMONTOWER7F_JESSIE
	appear POKEMONTOWER7F_JAMES
	opentext
	writetext PokemonTower7FJessieJamesStopText
	waitbutton
	closetext
	turnobject PLAYER, UP
	showemote EMOTE_SHOCK, PLAYER, 15
	applymovement POKEMONTOWER7F_JESSIE, PokemonTower7FWalkDown3
	turnobject POKEMONTOWER7F_JESSIE, DOWN
	applymovement POKEMONTOWER7F_JAMES, PokemonTower7FWalkDown4
	turnobject POKEMONTOWER7F_JAMES, LEFT
	sjump PokemonTower7FJessieJamesBattle

.Done:
	end

; (11,12): the pair end up to the left of and above the player.
PokemonTower7FJessieJamesSceneFromRightTile:
	checkevent EVENT_BEAT_POKEMON_TOWER_JESSIE_JAMES
	iftrue .Done
	playmusic MUSIC_MEET_JESSIE_JAMES
	appear POKEMONTOWER7F_JESSIE
	appear POKEMONTOWER7F_JAMES
	opentext
	writetext PokemonTower7FJessieJamesStopText
	waitbutton
	closetext
	turnobject PLAYER, UP
	showemote EMOTE_SHOCK, PLAYER, 15
	applymovement POKEMONTOWER7F_JESSIE, PokemonTower7FWalkDown4
	turnobject POKEMONTOWER7F_JESSIE, RIGHT
	applymovement POKEMONTOWER7F_JAMES, PokemonTower7FWalkDown3
	turnobject POKEMONTOWER7F_JAMES, DOWN
	sjump PokemonTower7FJessieJamesBattle

.Done:
	end

; Shared tail: the threat, the battle and the exit.  Yellow's Script6 -> Script10.
PokemonTower7FJessieJamesBattle:
	opentext
	writetext PokemonTower7FJessieJamesSeenText
	waitbutton
	closetext
	winlosstext PokemonTower7FJessieJamesBeatenText, 0
	setlasttalked POKEMONTOWER7F_JESSIE
	loadtrainer JESSIE_JAMES, JESSIE_JAMES_2
	startbattle
	ifequal WIN, .Won
	reloadmapafterbattle ; LOSE jumps to the whiteout here; nothing below runs
	end

.Won:
	reloadmapafterbattle
	turnobject POKEMONTOWER7F_JESSIE, DOWN
	turnobject POKEMONTOWER7F_JAMES, DOWN
	opentext
	writetext PokemonTower7FJessieJamesAfterBattleText
	waitbutton
	closetext
	playmusic MUSIC_MEET_JESSIE_JAMES
	pause 30
	special FadeOutToBlack
	special ReloadSpritesNoPalettes
	disappear POKEMONTOWER7F_JESSIE
	disappear POKEMONTOWER7F_JAMES
	pause 15
	special FadeInFromBlack
	setevent EVENT_BEAT_POKEMON_TOWER_JESSIE_JAMES
	special RestartMapMusic
	end

; Talking to either of them mid-scene is impossible (the scene never yields),
; but both objects need a script pointer.  Yellow's TEXT_POKEMONTOWER7F_JESSIE
; and _JAMES are a bare `text_end` for the same reason.
PokemonTower7FJessieScript:
	jumptextfaceplayer PokemonTower7FJessieJamesSeenText

PokemonTower7FJamesScript:
	jumptextfaceplayer PokemonTower7FJessieJamesSeenText

; 9k.  Yellow: PokemonTower7FMrFujiText prints the rescue speech, sets
; EVENT_RESCUED_MR_FUJI (+ its _2 twin), shows MR FUJI in his house, and queues
; PokemonTower7FWarpToMrFujiHouseScript, which hides him here, faces the player
; UP and warps to MR_FUJIS_HOUSE warp id 1.
;
; M7: Yellow also sets EVENT_RESCUED_MR_FUJI_2 and swaps two SAFFRON CITY
; objects (HideObject SAFFRON_CITY_E / ShowObject SAFFRON_CITY_F).  Our MR
; FUJI'S HOUSE derives his visibility from EVENT_RESCUED_MR_FUJI in its own
; MAPCALLBACK_OBJECTS, so the _2 twin has no analogue at all.
;
; M8 11c: SAFFRON CITY is ported now, and the HideObject half needs no script
; here either -- SAFFRONCITY_ROCKET8 (the grunt in front of SILPH CO.'s door,
; Yellow's SAFFRON_CITY_E) carries EVENT_RESCUED_MR_FUJI as its own HIDE flag,
; so the setevent above makes him vanish by itself.  ShowObject SAFFRON_CITY_F
; has no analogue: that is Yellow's ROCKET9, dropped per D88 because Yellow
; itself deleted the object and left only a dangling const behind.
PokemonTower7FMrFujiScript:
	faceplayer
	opentext
	writetext PokemonTower7FMrFujiRescueText
	waitbutton
	closetext
	setevent EVENT_RESCUED_MR_FUJI
	disappear POKEMONTOWER7F_MR_FUJI
; Yellow forces SPRITE_FACING_UP before the warp so the player walks out of the
; doorway into the room; a plain `warp` spawns him facing DOWN, on the mat and
; looking back out of the door.  `warpfacing` is GSC's own way to say it.
	warpfacing UP, MR_FUJIS_HOUSE, 2, 7
	end

; Yellow's PokemonTower7FMovementData_60d7b (3 bytes) and _60d7a (4 bytes; it
; falls through into _60d7b).
PokemonTower7FWalkDown3:
	step DOWN
	step DOWN
	step DOWN
	step_end

PokemonTower7FWalkDown4:
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step_end

PokemonTower7FJessieJamesStopText:
	text "Stop right there!"
	done

PokemonTower7FJessieJamesSeenText:
	text "Grampa here wanted"
	line "to complain, so"
	cont "we're setting him"
	cont "straight."

	para "So render yourself"
	line "invisible, or"
	cont "prepare to fight!"
	done

PokemonTower7FJessieJamesBeatenText:
	text "You"
	line "will regret this!"
	done

PokemonTower7FJessieJamesAfterBattleText:
	text "Looks like TEAM"
	line "ROCKET's blasting"
	cont "off again!"
	done

PokemonTower7FMrFujiRescueText:
	text "MR.FUJI: Heh? You"
	line "came to save me?"

	para "Thank you. But, I"
	line "came here of my"
	cont "own free will."

	para "I came to calm"
	line "the soul of"
	cont "CUBONE's mother."

	para "I think MAROWAK's"
	line "spirit has gone"
	cont "to the afterlife."

	para "I must thank you"
	line "for your kind"
	cont "concern!"

	para "Follow me to my"
	line "home, #MON"
	cont "HOUSE at the foot"
	cont "of this tower."
	done

PokemonTower7F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  9, 16, POKEMON_TOWER_6F, 2

	def_coord_events
	coord_event 10, 12, -1, PokemonTower7FJessieJamesSceneFromLeftTile
	coord_event 11, 12, -1, PokemonTower7FJessieJamesSceneFromRightTile

	def_bg_events

	def_object_events
	object_event 10,  8, SPRITE_JESSIE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PokemonTower7FJessieScript, EVENT_POKEMON_TOWER_7F_JESSIE_JAMES_HIDDEN
	object_event 11,  8, SPRITE_JAMES, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PokemonTower7FJamesScript, EVENT_POKEMON_TOWER_7F_JESSIE_JAMES_HIDDEN
	object_event 10,  3, SPRITE_MR_FUJI, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, PokemonTower7FMrFujiScript, EVENT_RESCUED_MR_FUJI
