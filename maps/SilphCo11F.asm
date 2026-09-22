; Kanto hack (M8 11i, docs/M8-SAFFRON.md 0.6 row 11i): SILPH CO. 11F, the top
; floor -- the president's office, JESSIE & JAMES #4, GIOVANNI #2 and the
; MASTER BALL, ported from Yellow
; (vendor/pokeyellow/data/maps/objects/SilphCo11F.asm,
; scripts/SilphCo11F.asm, scripts/SilphCo11F_2.asm,
; text/SilphCo11F.asm and text/SilphCo10F.asm for the four shared J&J lines).
;
; --- the floor's shape -----------------------------------------------------
; 11F is TWO DISCONNECTED REGIONS (docs/M8-SAFFRON.md 11b):
;   A  the top corridor + the right-hand column: the 10F stairs (9,0), the
;      elevator (13,0) and the last ROCKET (15,9).  A dead end.
;   B  the left strip + the president's office: the 7F teleport pad (3,2),
;      JESSIE & JAMES, the card-key door, GIOVANNI, the PRESIDENT, the
;      SECRETARY and the PC.
; There is no tile joining them, so the office is reachable ONLY from the 7F
; pad (D85) -- that is Yellow's design, not an omission, and it is why the way
; out after GIOVANNI is the same pad back to 7F.
;
; --- the card-key door -----------------------------------------------------
; Yellow block coordinate (3,6) $20 (SilphCo11FGateCallbackScript's
; `lb bc, 6, 3`), the LAST of Silph's 20 doors.  Our .blk is Yellow's and ships
; the gate as open floor ($03), so this MAPCALLBACK_TILES shuts it on every map
; load until the flag is set.  `changeblock` takes MAP TILE coordinates.
; Block $20 is FLOOR/FLOOR/WALL/WALL, i.e. it walls tiles (6,13) and (7,13);
; the player stands at (6,14)/(7,14) and faces UP.  The bg_event that opens it
; is 11j's and now shipped (bg_events below).
;
; --- JESSIE & JAMES #4 -----------------------------------------------------
; Yellow's trigger is wYCoord == 3 AND wXCoord < 4, i.e. (1,3), (2,3), (3,3) --
; the three tiles of the row just south of the 7F pad, so the scene is
; unavoidable on the way in.  EVENT_780/EVENT_781 only remember WHICH tile was
; stepped on so Gen 1's split script states can read it back; GSC gives each
; coord_event its own linear script, so they have no analogue (the call 9e, 9j
; and 9x already made).  Unlike the HIDEOUT, the pair are on the map from the
; start here -- Yellow never ShowObjects them -- and they walk UP to the
; player, so the player turns DOWN.  Yellow's per-tile data:
;
;   player (3,3): JAMES  (2,8) +5 -> (2,3), left of him,  facing RIGHT
;                 JESSIE (3,8) +4 -> (3,4), below him,    facing UP
;   player (2,3): JAMES  (2,8) +4 -> (2,4), below him,    facing UP
;                 JESSIE (3,8) +5 -> (3,3), right of him, facing LEFT
;   player (1,3): JAMES  (2,8) +5 -> (2,3), right of him, facing UP
;                 JESSIE (3,8) +6 -> (3,2)                facing LEFT
;
; ⚠ DEVIATION (docs/M8-SAFFRON.md "11i findings"): Yellow's dispatch is buggy.
; SilphCo11FScript5/8 read CheckEitherEventSet EVENT_780, EVENT_781, which
; returns $00/$10/$20, then branch on `cp $1` -- a value it can never hold.  So
; the (2,3) branch above is dead code in Yellow and the (1,3) data runs for
; BOTH x==2 and x==1, which walks JAMES straight into the player standing on
; (2,3).  Gen 1 shrugs that off; a GSC `applymovement` into an occupied tile
; never completes and soft-locks the game.  We ship the three branches Yellow's
; DATA intends, one per tile, exactly as listed above.
;
; --- GIOVANNI #2 -----------------------------------------------------------
; Yellow's trigger array is (6,13) and (7,12) -- the two tiles you can first
; stand on inside the office, i.e. the card-key door tile and the one above its
; neighbour, so he too is unavoidable.  wCoordIndex is 1-based, so entry 1 is
; (6,13) (player faces UP, GIOVANNI DOWN) and entry 2 is (7,12) (player LEFT,
; GIOVANNI RIGHT); Yellow's inline comment on `cp 1` has them the wrong way
; round.  He speaks FIRST, from (6,9), then walks DOWN 3 to (6,12) and fights.
; He has no Gen 1 trainer header (no sight range) -- the coord_event is his
; only trigger -- so his object is OBJECTTYPE_SCRIPT and the battle is inline,
; the RocketHideoutB4F JESSIE & JAMES shape.
;
; EVENT_BEAT_SILPH_CO_GIOVANNI is the master flag: every Silph floor, SAFFRON
; CITY and 11k hang the Rocket takeover off it, so it is set here on the pass
; that follows the win, and it doubles as GIOVANNI's and the 11F ROCKET's
; object hide flag.  Yellow's SilphCo11FTeamRocketLeavesScript (SilphCo11F_2)
; hides 41 toggleable objects and shows 6 -- all of that is flag-driven in GSC
; and belongs to 11k; here we only need the flag and the local `disappear`.
;
; Battle music: GIOVANNI is a Kanto-hack class, so start_battle.asm falls
; through to MUSIC_KANTO_TRAINER_BATTLE -- what Yellow's PlayBattleMusic gives
; the Silph GIOVANNI too (wGymLeaderNo is 0 here).
;
; --- the PRESIDENT and the MASTER BALL -------------------------------------
; Yellow's president gives MASTER_BALL once on EVENT_GOT_MASTER_BALL, prints
; "You have no room for this." when the bag is full, and thereafter describes
; the ball instead.  GSC's `verbosegiveitem` prints Yellow's
; "<PLAYER> got a MASTER BALL!" line itself, so only the three flavour texts
; are ported (the CopycatsHouse2F gift convention).
;
; --- the PC ----------------------------------------------------------------
; Yellow's `hidden_event 10, 12, OpenPokemonCenterPC, SPRITE_FACING_UP`
; (data/events/hidden_events.asm) -- a full #MON Center PC on the office's
; north wall, matched against the tile in front of the player, i.e. exactly a
; GSC bg_event.  The CeladonMansion2F precedent: `jumpstd PCScript`.
;
; --- warp 3 ----------------------------------------------------------------
; Yellow sends warp 3 (5,5) to LAST_MAP, warp 10 -- a dead destination it
; labels "inaccessible".  11a self-loops it so warp 4, the 7F pad's return leg
; (SilphCo7F's `warp_event 5, 7, SILPH_CO_11F, 4`), keeps its index.  Kept.
	object_const_def
	const SILPHCO11F_SILPH_PRESIDENT
	const SILPHCO11F_BEAUTY
	const SILPHCO11F_GIOVANNI
	const SILPHCO11F_JAMES
	const SILPHCO11F_ROCKET
	const SILPHCO11F_JESSIE

SilphCo11F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_TILES, SilphCo11FDoorCallback
	callback MAPCALLBACK_OBJECTS, SilphCo11FObjectsCallback

SilphCo11FDoorCallback:
	checkevent EVENT_SILPH_CO_11F_UNLOCKED_DOOR
	iftrue .done
	changeblock  6, 12, $20 ; shut door, Yellow block (3,6)
.done
	endcallback

; 11j -- the card-key doors.  One BGEVENT_READ per walled tile (Yellow's engine
; is tile-driven, so either tile of a door works, from either side); the macro
; is macros/scripts/card_key.asm and the shared text/sound tail is
; maps/SilphCoCardKeyDoors.asm.  The changeblock here is what opens the door
; NOW -- the callback above only runs on a map LOAD.

SilphCo11FDoorScript:
	silph_card_key_door EVENT_SILPH_CO_11F_UNLOCKED_DOOR, 6, 12, $03 ; Yellow block (3,6)

SilphCo11FObjectsCallback:
; JESSIE and JAMES stand here from the first visit (Yellow never ShowObjects
; them) and are gone for good once beaten, so -- unlike the HIDEOUT, where they
; are hidden at load time either way -- the hide flag is DERIVED from the beat
; flag.  It has to be cleared as well as set: `disappear` at the end of the
; scene sets it, and a white-out mid-scene must not leave them missing.
	checkevent EVENT_BEAT_SILPH_CO_11F_JESSIE_JAMES
	iftrue .blasted_off
	clearevent EVENT_SILPH_CO_11F_JESSIE_JAMES_HIDDEN
	endcallback

.blasted_off
	setevent EVENT_SILPH_CO_11F_JESSIE_JAMES_HIDDEN
	endcallback

; --- JESSIE & JAMES #4 -----------------------------------------------------
; (3,3): the pair end up to the left of and below the player.
SilphCo11FJessieJamesSceneFromTile3:
	checkevent EVENT_BEAT_SILPH_CO_11F_JESSIE_JAMES
	iftrue .Done
	playmusic MUSIC_MEET_JESSIE_JAMES
	opentext
	writetext SilphCo11FJessieJamesStopText
	waitbutton
	closetext
	turnobject PLAYER, DOWN
	showemote EMOTE_SHOCK, PLAYER, 15
	applymovement SILPHCO11F_JAMES, SilphCo11FWalkUp5
	turnobject SILPHCO11F_JAMES, RIGHT
	applymovement SILPHCO11F_JESSIE, SilphCo11FWalkUp4
	turnobject SILPHCO11F_JESSIE, UP
	sjump SilphCo11FJessieJamesBattle

.Done:
	end

; (2,3): the pair end up below and to the right of the player.
SilphCo11FJessieJamesSceneFromTile2:
	checkevent EVENT_BEAT_SILPH_CO_11F_JESSIE_JAMES
	iftrue .Done
	playmusic MUSIC_MEET_JESSIE_JAMES
	opentext
	writetext SilphCo11FJessieJamesStopText
	waitbutton
	closetext
	turnobject PLAYER, DOWN
	showemote EMOTE_SHOCK, PLAYER, 15
	applymovement SILPHCO11F_JAMES, SilphCo11FWalkUp4
	turnobject SILPHCO11F_JAMES, UP
	applymovement SILPHCO11F_JESSIE, SilphCo11FWalkUp5
	turnobject SILPHCO11F_JESSIE, LEFT
	sjump SilphCo11FJessieJamesBattle

.Done:
	end

; (1,3): both walk past the player and turn back towards the office.
SilphCo11FJessieJamesSceneFromTile1:
	checkevent EVENT_BEAT_SILPH_CO_11F_JESSIE_JAMES
	iftrue .Done
	playmusic MUSIC_MEET_JESSIE_JAMES
	opentext
	writetext SilphCo11FJessieJamesStopText
	waitbutton
	closetext
	turnobject PLAYER, DOWN
	showemote EMOTE_SHOCK, PLAYER, 15
	applymovement SILPHCO11F_JAMES, SilphCo11FWalkUp5
	turnobject SILPHCO11F_JAMES, UP
	applymovement SILPHCO11F_JESSIE, SilphCo11FWalkUp6
	turnobject SILPHCO11F_JESSIE, LEFT
	sjump SilphCo11FJessieJamesBattle

.Done:
	end

; Shared tail: the threat, the battle and the exit.  Yellow's Script10 -> 14.
SilphCo11FJessieJamesBattle:
	opentext
	writetext SilphCo11FJessieJamesSeenText
	waitbutton
	closetext
	winlosstext SilphCo11FJessieJamesBeatenText, 0
	setlasttalked SILPHCO11F_JESSIE
	loadtrainer JESSIE_JAMES, JESSIE_JAMES_4
	startbattle
	ifequal WIN, .Won
	reloadmapafterbattle ; LOSE jumps to the whiteout here; nothing below runs
	end

.Won:
	reloadmapafterbattle
	turnobject SILPHCO11F_JAMES, DOWN
	turnobject SILPHCO11F_JESSIE, DOWN
	opentext
	writetext SilphCo11FJessieJamesAfterBattleText
	waitbutton
	closetext
	playmusic MUSIC_MEET_JESSIE_JAMES
	pause 30
	special FadeOutToBlack
	special ReloadSpritesNoPalettes
	disappear SILPHCO11F_JAMES
	disappear SILPHCO11F_JESSIE
	pause 15
	special FadeInFromBlack
	setevent EVENT_BEAT_SILPH_CO_11F_JESSIE_JAMES
	special RestartMapMusic
	end

; Talking to either of them before the scene is impossible -- the scene fires
; on the only row you can reach them from -- but both objects need a script
; pointer, exactly as Yellow's TEXT_SILPHCO11F_JAMES/_JESSIE both point at the
; scene's own text.
SilphCo11FJamesScript:
	jumptextfaceplayer SilphCo11FJessieJamesSeenText

SilphCo11FJessieScript:
	jumptextfaceplayer SilphCo11FJessieJamesSeenText

; --- GIOVANNI #2 -----------------------------------------------------------
; (6,13), the card-key door tile: GIOVANNI comes down to (6,12), right above.
SilphCo11FGiovanniSceneFromDoor:
	checkevent EVENT_BEAT_SILPH_CO_GIOVANNI
	iftrue .Done
	opentext
	writetext SilphCo11FGiovanniSeenText
	waitbutton
	closetext
	turnobject PLAYER, UP
	applymovement SILPHCO11F_GIOVANNI, SilphCo11FWalkDown3
	turnobject SILPHCO11F_GIOVANNI, DOWN
	sjump SilphCo11FGiovanniBattle

.Done:
	end

; (7,12): GIOVANNI comes down to (6,12), to the player's left.
SilphCo11FGiovanniSceneFromRight:
	checkevent EVENT_BEAT_SILPH_CO_GIOVANNI
	iftrue .Done
	opentext
	writetext SilphCo11FGiovanniSeenText
	waitbutton
	closetext
	turnobject PLAYER, LEFT
	applymovement SILPHCO11F_GIOVANNI, SilphCo11FWalkDown3
	turnobject SILPHCO11F_GIOVANNI, RIGHT
	sjump SilphCo11FGiovanniBattle

.Done:
	end

SilphCo11FGiovanniBattle:
	winlosstext SilphCo11FGiovanniBeatenText, 0
	setlasttalked SILPHCO11F_GIOVANNI
	loadtrainer GIOVANNI, GIOVANNI_2
	startbattle
	ifequal WIN, .Won
	reloadmapafterbattle ; LOSE jumps to the whiteout here; nothing below runs
	end

.Won:
	reloadmapafterbattle
	opentext
	writetext SilphCo11FGiovanniYouRuinedOurPlansText
	waitbutton
	closetext
	special FadeOutToBlack
	special ReloadSpritesNoPalettes
	disappear SILPHCO11F_GIOVANNI
	pause 15
	special FadeInFromBlack
; The master flag.  `disappear` above already set it (it IS GIOVANNI's hide
; flag); set it by name too, because everything outside this map reads it.
	setevent EVENT_BEAT_SILPH_CO_GIOVANNI
	end

; Unreachable for the same reason as JESSIE and JAMES above -- the coord_events
; cover both tiles the office can be entered from -- but the object needs a
; script pointer, and Yellow's TEXT_SILPHCO11F_GIOVANNI is this same speech.
SilphCo11FGiovanniScript:
	jumptextfaceplayer SilphCo11FGiovanniSeenText

; --- the last ROCKET (region A) --------------------------------------------
TrainerSilphCo11FRocket:
	trainer GRUNTM, GRUNTM_57, EVENT_BEAT_SILPH_CO_11F_ROCKET, SilphCo11FRocketSeenText, SilphCo11FRocketBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo11FRocketAfterBattleText
	waitbutton
	closetext
	end

; --- the PRESIDENT, the SECRETARY and the PC -------------------------------
SilphCo11FSilphPresidentScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_MASTER_BALL
	iftrue .GotMasterBall
	writetext SilphCo11FSilphPresidentText
	promptbutton
	verbosegiveitem MASTER_BALL
	iffalse .NoRoom
	setevent EVENT_GOT_MASTER_BALL
	closetext
	end

.GotMasterBall:
	writetext SilphCo11FSilphPresidentMasterBallDescriptionText
	waitbutton
	closetext
	end

.NoRoom:
	writetext SilphCo11FSilphPresidentNoRoomText
	waitbutton
	closetext
	end

SilphCo11FBeautyScript:
	jumptextfaceplayer SilphCo11FBeautyText

SilphCo11FPC:
	jumpstd PCScript

; --- movement data ---------------------------------------------------------
SilphCo11FWalkUp4:
	step UP
	step UP
	step UP
	step UP
	step_end

SilphCo11FWalkUp5:
	step UP
	step UP
	step UP
	step UP
	step UP
	step_end

SilphCo11FWalkUp6:
	step UP
	step UP
	step UP
	step UP
	step UP
	step UP
	step_end

SilphCo11FWalkDown3:
	step DOWN
	step DOWN
	step DOWN
	step_end

; --- text ------------------------------------------------------------------
SilphCo11FSilphPresidentText:
	text "PRESIDENT: Thank"
	line "you for saving"
	cont "SILPH!"

	para "I will never"
	line "forget you saved"
	cont "us in our moment"
	cont "of peril!"

	para "I have to thank"
	line "you in some way!"

	para "Because I am rich,"
	line "I can give you"
	cont "anything!"

	para "Here, maybe this"
	line "will do!"
	prompt

SilphCo11FSilphPresidentMasterBallDescriptionText:
	text "PRESIDENT: You"
	line "can't buy that"
	cont "anywhere!"

	para "It's our secret"
	line "prototype MASTER"
	cont "BALL!"

	para "It will catch any"
	line "#MON without"
	cont "fail!"

	para "You should be"
	line "quiet about using"
	cont "it, though."
	done

SilphCo11FSilphPresidentNoRoomText:
	text "You have no"
	line "room for this."
	done

SilphCo11FBeautyText:
	text "SECRETARY: Thank"
	line "you for rescuing"
	cont "all of us!"

	para "We admire your"
	line "courage."
	done

SilphCo11FGiovanniSeenText:
	text "Ah, <PLAYER>!"
	line "So we meet again!"

	para "The PRESIDENT and"
	line "I are discussing"
	cont "a vital business"
	cont "proposition."

	para "Keep your nose"
	line "out of grown-up"
	cont "matters…"

	para "or, experience a"
	line "world of pain!"
	done

SilphCo11FGiovanniBeatenText:
	text "Arrgh!!"
	line "I lost again!?"
	prompt

SilphCo11FGiovanniYouRuinedOurPlansText:
	text "Blast it all!"
	line "You ruined our"
	cont "plans for SILPH!"

	para "But, TEAM ROCKET"
	line "will never fall!"

	para "<PLAYER>! Never"
	line "forget that all"
	cont "#MON exist"
	cont "for TEAM ROCKET!"

	para "I must go, but I"
	line "shall return!"
	done

SilphCo11FJessieJamesStopText:
	text "Hold it right"
	line "there, brat!"
	done

SilphCo11FJessieJamesSeenText:
	text "Our BOSS is in a"
	line "meeting!"

	para "You better not"
	line "disturb him!"
	done

SilphCo11FJessieJamesBeatenText:
	text "Like"
	line "always…"
	prompt

SilphCo11FJessieJamesAfterBattleText:
	text "TEAM ROCKET, blast"
	line "off at the speed"
	cont "of light!"

	para "Again…"
	done

SilphCo11FRocketSeenText:
	text "Halt! Do you have"
	line "an appointment"
	cont "with my BOSS?"
	done

SilphCo11FRocketBeatenText:
	text "Gaah!"
	line "Demolished!"
	prompt

SilphCo11FRocketAfterBattleText:
	text "Watch your step,"
	line "my BOSS likes his"
	cont "#MON tough!"
	done

SilphCo11F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  9,  0, SILPH_CO_10F, 2
	warp_event 13,  0, SILPH_CO_ELEVATOR, 1
	; Yellow sends warp 3 to LAST_MAP -- it is unreachable behind the
	; president's desk.  Self-loop here so the index stays valid.
	warp_event  5,  5, SILPH_CO_11F, 1
	warp_event  3,  2, SILPH_CO_7F, 4

	def_coord_events
	coord_event  3,  3, -1, SilphCo11FJessieJamesSceneFromTile3
	coord_event  2,  3, -1, SilphCo11FJessieJamesSceneFromTile2
	coord_event  1,  3, -1, SilphCo11FJessieJamesSceneFromTile1
	coord_event  6, 13, -1, SilphCo11FGiovanniSceneFromDoor
	coord_event  7, 12, -1, SilphCo11FGiovanniSceneFromRight

	def_bg_events
	bg_event 10, 12, BGEVENT_UP, SilphCo11FPC ; Yellow's OpenPokemonCenterPC hidden event
	; the card-key door, Yellow block (3,6): walled bottom row -- faced from the south (or from inside, to the north)
	bg_event  6, 13, BGEVENT_READ, SilphCo11FDoorScript
	bg_event  7, 13, BGEVENT_READ, SilphCo11FDoorScript

	def_object_events
	object_event  7,  5, SPRITE_SILPH_PRESIDENT, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SilphCo11FSilphPresidentScript, -1
	object_event 10,  5, SPRITE_BEAUTY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, SilphCo11FBeautyScript, -1
	object_event  6,  9, SPRITE_GIOVANNI, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SilphCo11FGiovanniScript, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event  2,  8, SPRITE_JAMES, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SilphCo11FJamesScript, EVENT_SILPH_CO_11F_JESSIE_JAMES_HIDDEN
	object_event 15,  9, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerSilphCo11FRocket, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event  3,  8, SPRITE_JESSIE, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SilphCo11FJessieScript, EVENT_SILPH_CO_11F_JESSIE_JAMES_HIDDEN
