; Kanto hack (M6 9x, docs/M6-CELADON.md 3.4): Yellow's ROCKET_HIDEOUT_B4F --
; GIOVANNI, JESSIE & JAMES #2, the Rocket who drops the LIFT KEY, five item
; balls and one hidden item, at Yellow's own coordinates
; (vendor/pokeyellow/data/maps/objects/RocketHideoutB4F.asm,
; scripts/RocketHideoutB4F.asm, text/RocketHideoutB4F.asm).
;
; --- the two "revealed" balls ---------------------------------------------
; Yellow keeps the LIFT KEY (10,2) and the SILPH SCOPE (25,2) hidden and calls
; ShowObject on them from a script.  A GSC object_event has exactly ONE flag,
; and it is a HIDE flag that FindItemInBallScript sets for us on pickup, so
; each of these two needs a second piece of state:
;
;   EVENT_ROCKET_DROPPED_LIFT_KEY       gate  - the B4F Rocket has been beaten
;   EVENT_ROCKET_HIDEOUT_B4F_LIFT_KEY   hide  - the ball itself
;   EVENT_BEAT_ROCKET_HIDEOUT_GIOVANNI  gate  - GIOVANNI has been beaten
;   EVENT_GOT_SILPH_SCOPE               hide  - the ball itself
;
; RocketHideoutB4FObjectsCallback re-asserts the hide flag on every map load
; while the gate is still clear, and does nothing once it is set; the grunt's
; and GIOVANNI's scripts `appear` the ball (which clears the hide flag), and
; picking it up sets it again for good.  So while the gate is clear the hide
; flag says nothing about the player's bag -- nothing outside this file reads
; EVENT_GOT_SILPH_SCOPE, and the POKEMON TOWER gate (9i) tests the bag with
; HasSilphScope / `checkitem SILPH_SCOPE`, never a flag.
;
; --- GIOVANNI --------------------------------------------------------------
; Yellow's object row is `OPP_GIOVANNI, 1` with no trainer header, i.e. he is a
; pure talk-to (docs/M6-CELADON.md 5.7 -> GSC sight range 0).  On defeat he
; prints "I hope we meet again...", fades out, is hidden, and the SILPH SCOPE
; ball is shown one tile north of where he stood.  He DISAPPEARS; he does not
; walk or warp away.  EVENT_BEAT_ROCKET_HIDEOUT_GIOVANNI is both his `trainer`
; flag and his object's hide flag -- the polarity already matches (he is on B4F
; iff he is unbeaten), the MR FUJI precedent from maps/PokemonTower7F.asm.
;
; Battle music: a brand-new class falls through engine/battle/start_battle.asm
; to .kantotrainer -> MUSIC_KANTO_TRAINER_BATTLE, which is Crystal's
; arrangement of Gen 1's Music_TrainerBattle -- exactly what Yellow's
; PlayBattleMusic gives hideout GIOVANNI (wGymLeaderNo is 0 here; only the
; VIRIDIAN GYM battle sets it).  No engine change needed.
;
; --- JESSIE & JAMES #2 -----------------------------------------------------
; Yellow's trigger is wYCoord == $e AND wXCoord == $18 or $19, i.e. (24,14) and
; (25,14); EVENT_ROCKET_HIDEOUT_4_JESSIE_JAMES_ON_LEFT only remembers which of
; the two was stepped on so Gen 1's split script states can read it back, and
; GSC gives each coord_event its own linear script, so it has no analogue (the
; call 9e and 9j already made).  Unlike POKEMON TOWER 7F, JAMES walks first.
;
;   player (24,14): JAMES  (25,10) +4 -> (25,14), right of him, facing LEFT
;                   JESSIE (24,10) +3 -> (24,13), above him,    facing DOWN
;   player (25,14): JAMES  (25,10) +3 -> (25,13), above him,    facing DOWN
;                   JESSIE (24,10) +4 -> (24,14), left of him,  facing RIGHT
;
; Yellow shows the pair AFTER "Not another step, brat!" here (POKEMON TOWER 7F
; shows them first); we keep each map's own order.
	object_const_def
	const ROCKETHIDEOUTB4F_GIOVANNI
	const ROCKETHIDEOUTB4F_JAMES
	const ROCKETHIDEOUTB4F_JESSIE
	const ROCKETHIDEOUTB4F_ROCKET
	const ROCKETHIDEOUTB4F_HP_UP
	const ROCKETHIDEOUTB4F_TM_RAZOR_WIND
	const ROCKETHIDEOUTB4F_IRON
	const ROCKETHIDEOUTB4F_SILPH_SCOPE
	const ROCKETHIDEOUTB4F_LIFT_KEY

RocketHideoutB4F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_OBJECTS, RocketHideoutB4FObjectsCallback

RocketHideoutB4FObjectsCallback:
; JESSIE and JAMES are never on the map at load time: before the scene they
; have not shown up, after it they have blasted off, and a white-out in
; between must not leave them standing there (`appear` cleared the flag).
	setevent EVENT_ROCKET_HIDEOUT_B4F_JESSIE_JAMES_HIDDEN
; The two revealed balls: keep them hidden until their gate opens.
	checkevent EVENT_ROCKET_DROPPED_LIFT_KEY
	iftrue .lift_key_dropped
	setevent EVENT_ROCKET_HIDEOUT_B4F_LIFT_KEY
.lift_key_dropped
	checkevent EVENT_BEAT_ROCKET_HIDEOUT_GIOVANNI
	iftrue .giovanni_beaten
	setevent EVENT_GOT_SILPH_SCOPE
.giovanni_beaten
	endcallback

; --- GIOVANNI --------------------------------------------------------------
TrainerRocketHideoutB4FGiovanni:
	trainer GIOVANNI, GIOVANNI_1, EVENT_BEAT_ROCKET_HIDEOUT_GIOVANNI, RocketHideoutB4FGiovanniSeenText, RocketHideoutB4FGiovanniBeatenText, 0, .Script

; Yellow's RocketHideoutB4FBeatGiovanniScript, run straight after the battle:
; the farewell speech, a fade to black, GIOVANNI hidden, the SILPH SCOPE ball
; shown, a fade back in.  There is no "later talk" branch to guard with
; `endifjustbattled` -- by the time this script could run again its own beat
; flag has hidden the object.  A LOSS never gets here either: the engine whites
; the player out, exactly as Yellow's `cp LOST_BATTLE` branch bails to
; RocketHideoutB4FResetScripts.  The `trainer` macro has already set
; EVENT_BEAT_ROCKET_HIDEOUT_GIOVANNI; `disappear` sets it again, harmlessly.
.Script:
	opentext
	writetext RocketHideoutB4FGiovanniHopeWeMeetAgainText
	waitbutton
	closetext
	special FadeOutToBlack
	special ReloadSpritesNoPalettes
	disappear ROCKETHIDEOUTB4F_GIOVANNI
	appear ROCKETHIDEOUTB4F_SILPH_SCOPE
	pause 15
	special FadeInFromBlack
	end

; --- JESSIE & JAMES #2 -----------------------------------------------------
; (24,14): the pair end up to the right of and above the player.
RocketHideoutB4FJessieJamesSceneFromLeftTile:
	checkevent EVENT_BEAT_ROCKET_HIDEOUT_JESSIE_JAMES
	iftrue .Done
	playmusic MUSIC_MEET_JESSIE_JAMES
	opentext
	writetext RocketHideoutB4FJessieJamesStopText
	waitbutton
	closetext
	turnobject PLAYER, UP
	showemote EMOTE_SHOCK, PLAYER, 15
	appear ROCKETHIDEOUTB4F_JAMES
	appear ROCKETHIDEOUTB4F_JESSIE
	applymovement ROCKETHIDEOUTB4F_JAMES, RocketHideoutB4FWalkDown4
	turnobject ROCKETHIDEOUTB4F_JAMES, LEFT
	applymovement ROCKETHIDEOUTB4F_JESSIE, RocketHideoutB4FWalkDown3
	turnobject ROCKETHIDEOUTB4F_JESSIE, DOWN
	sjump RocketHideoutB4FJessieJamesBattle

.Done:
	end

; (25,14): the pair end up above and to the left of the player.
RocketHideoutB4FJessieJamesSceneFromRightTile:
	checkevent EVENT_BEAT_ROCKET_HIDEOUT_JESSIE_JAMES
	iftrue .Done
	playmusic MUSIC_MEET_JESSIE_JAMES
	opentext
	writetext RocketHideoutB4FJessieJamesStopText
	waitbutton
	closetext
	turnobject PLAYER, UP
	showemote EMOTE_SHOCK, PLAYER, 15
	appear ROCKETHIDEOUTB4F_JAMES
	appear ROCKETHIDEOUTB4F_JESSIE
	applymovement ROCKETHIDEOUTB4F_JAMES, RocketHideoutB4FWalkDown3
	turnobject ROCKETHIDEOUTB4F_JAMES, DOWN
	applymovement ROCKETHIDEOUTB4F_JESSIE, RocketHideoutB4FWalkDown4
	turnobject ROCKETHIDEOUTB4F_JESSIE, RIGHT
	sjump RocketHideoutB4FJessieJamesBattle

.Done:
	end

; Shared tail: the threat, the battle and the exit.  Yellow's Script9 -> 13.
RocketHideoutB4FJessieJamesBattle:
	opentext
	writetext RocketHideoutB4FJessieJamesSeenText
	waitbutton
	closetext
	winlosstext RocketHideoutB4FJessieJamesBeatenText, 0
	setlasttalked ROCKETHIDEOUTB4F_JESSIE
	loadtrainer JESSIE_JAMES, JESSIE_JAMES_3
	startbattle
	ifequal WIN, .Won
	reloadmapafterbattle ; LOSE jumps to the whiteout here; nothing below runs
	end

.Won:
	reloadmapafterbattle
	turnobject ROCKETHIDEOUTB4F_JAMES, DOWN
	turnobject ROCKETHIDEOUTB4F_JESSIE, DOWN
	opentext
	writetext RocketHideoutB4FJessieJamesAfterBattleText
	waitbutton
	closetext
	playmusic MUSIC_MEET_JESSIE_JAMES
	pause 30
	special FadeOutToBlack
	special ReloadSpritesNoPalettes
	disappear ROCKETHIDEOUTB4F_JAMES
	disappear ROCKETHIDEOUTB4F_JESSIE
	pause 15
	special FadeInFromBlack
	setevent EVENT_BEAT_ROCKET_HIDEOUT_JESSIE_JAMES
	special RestartMapMusic
	end

; Talking to either of them mid-scene is impossible (the scene never yields),
; but both objects need a script pointer -- Yellow's TEXT_ROCKETHIDEOUTB4F_JAMES
; and _JESSIE are a bare `text_end` for the same reason.
RocketHideoutB4FJamesScript:
	jumptextfaceplayer RocketHideoutB4FJessieJamesSeenText

RocketHideoutB4FJessieScript:
	jumptextfaceplayer RocketHideoutB4FJessieJamesSeenText

; --- the LIFT KEY grunt ----------------------------------------------------
; Yellow sets EVENT_ROCKET_DROPPED_LIFT_KEY and ShowObjects the ball from the
; end-battle text, i.e. the instant the battle is over; `checkjustbattled` is
; how GSC says "only on the pass that follows the battle".
TrainerRocketHideoutB4FRocket:
	trainer GRUNTM, GRUNTM_39, EVENT_BEAT_ROCKET_HIDEOUT_B4F_ROCKET, RocketHideoutB4FRocketSeenText, RocketHideoutB4FRocketBeatenText, 0, .Script

.Script:
	checkjustbattled
	iffalse .AfterBattle
	setevent EVENT_ROCKET_DROPPED_LIFT_KEY
	appear ROCKETHIDEOUTB4F_LIFT_KEY
	end

.AfterBattle:
	opentext
	writetext RocketHideoutB4FRocketAfterBattleText
	waitbutton
	closetext
	end

; --- items -----------------------------------------------------------------
RocketHideoutB4FHPUp:
	itemball HP_UP

; Yellow's TM02 RAZOR WIND.  Our TM union (M3b, docs/TM-LEDGER.md) parks the
; Yellow-only TM moves on spare item ids: TM_RAZOR_WIND is TM52.
RocketHideoutB4FTMRazorWind:
	itemball TM_RAZOR_WIND

RocketHideoutB4FIron:
	itemball IRON

RocketHideoutB4FSilphScope:
	itemball SILPH_SCOPE

RocketHideoutB4FLiftKey:
	itemball LIFT_KEY

RocketHideoutB4FHiddenSuperPotion:
	hiddenitem SUPER_POTION, EVENT_ROCKET_HIDEOUT_B4F_HIDDEN_SUPER_POTION

; Yellow's PokemonTower7F-style approach walks: 4 steps and 3 steps.
RocketHideoutB4FWalkDown3:
	step DOWN
	step DOWN
	step DOWN
	step_end

RocketHideoutB4FWalkDown4:
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step_end

RocketHideoutB4FGiovanniSeenText:
	text "So! I must say, I"
	line "am impressed you"
	cont "got here!"
	done

RocketHideoutB4FGiovanniBeatenText:
	text "WHAT!"
	line "This cannot be!"
	prompt

RocketHideoutB4FGiovanniHopeWeMeetAgainText:
	text "I see that you"
	line "raise #MON"
	cont "with utmost care."

	para "A child like you"
	line "would never"
	cont "understand what I"
	cont "hope to achieve."

	para "I shall step"
	line "aside this time!"

	para "I hope we meet"
	line "again…"
	done

RocketHideoutB4FJessieJamesStopText:
	text "Not another step,"
	line "brat!"
	done

RocketHideoutB4FJessieJamesSeenText:
	text "How dare you"
	line "humiliate us at"
	cont "MT.MOON!"

	para "It's payback time,"
	line "you brat!"
	done

RocketHideoutB4FJessieJamesBeatenText:
	text "Such"
	line "a dreadful twerp!"
	prompt

RocketHideoutB4FJessieJamesAfterBattleText:
	text "Looks like TEAM"
	line "ROCKET's blasting"
	cont "off again!"
	done

RocketHideoutB4FRocketSeenText:
	text "The elevator"
	line "doesn't work? Who"
	cont "has the LIFT KEY?"
	done

RocketHideoutB4FRocketBeatenText:
	text "No!"
	prompt

RocketHideoutB4FRocketAfterBattleText:
	text "Oh no! I dropped"
	line "the LIFT KEY!"
	done

RocketHideoutB4F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; Kanto hack (M6 9w): Yellow's warp table, tile for tile.
	warp_event 19, 10, ROCKET_HIDEOUT_B3F, 2
	warp_event 24, 15, ROCKET_HIDEOUT_ELEVATOR, 1
	warp_event 25, 15, ROCKET_HIDEOUT_ELEVATOR, 2

	def_coord_events
	coord_event 24, 14, -1, RocketHideoutB4FJessieJamesSceneFromLeftTile
	coord_event 25, 14, -1, RocketHideoutB4FJessieJamesSceneFromRightTile

	def_bg_events
	bg_event 25,  1, BGEVENT_ITEM, RocketHideoutB4FHiddenSuperPotion ; Yellow's hidden SUPER POTION (data/events/hidden_events.asm:207)

	def_object_events
	object_event 25,  3, SPRITE_GIOVANNI, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_TRAINER, 0, TrainerRocketHideoutB4FGiovanni, EVENT_BEAT_ROCKET_HIDEOUT_GIOVANNI
	object_event 25, 10, SPRITE_JAMES, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, RocketHideoutB4FJamesScript, EVENT_ROCKET_HIDEOUT_B4F_JESSIE_JAMES_HIDDEN
	object_event 24, 10, SPRITE_JESSIE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, RocketHideoutB4FJessieScript, EVENT_ROCKET_HIDEOUT_B4F_JESSIE_JAMES_HIDDEN
	object_event 11,  2, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 1, TrainerRocketHideoutB4FRocket, -1
	object_event 10, 12, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, RocketHideoutB4FHPUp, EVENT_ROCKET_HIDEOUT_B4F_HP_UP
	object_event  9,  4, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, RocketHideoutB4FTMRazorWind, EVENT_ROCKET_HIDEOUT_B4F_TM_RAZOR_WIND
	object_event 12, 20, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, RocketHideoutB4FIron, EVENT_ROCKET_HIDEOUT_B4F_IRON
	object_event 25,  2, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, RocketHideoutB4FSilphScope, EVENT_GOT_SILPH_SCOPE
	object_event 10,  2, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, RocketHideoutB4FLiftKey, EVENT_ROCKET_HIDEOUT_B4F_LIFT_KEY
