; Kanto hack (M8 11g, docs/M8-SAFFRON.md 0.6 row 11g): SILPH CO. 7F, ported
; from Yellow -- four trainers, two item balls, four civilian SILPH workers
; (one of whom hands over the LAPRAS), the rival's third KANTO_RIVAL battle,
; three card-key doors and the 7F->11F shortcut pad.
;
; Cast, coordinates and facings are Yellow's
; (vendor/pokeyellow/data/maps/objects/SilphCo7F.asm); sight ranges are the
; second argument of Yellow's `trainer` headers
; (vendor/pokeyellow/scripts/SilphCo7F.asm): 2 / 3 / 3 / 4.  Text is Yellow's
; (vendor/pokeyellow/text/SilphCo7F.asm).
;
; NOTE Yellow's SILPHCO7F_SILPH_WORKER_M4 at (10,8) is a SPRITE_SILPH_WORKER_F
; despite the const's name; the sprite is what ships, as in Yellow.
; SILPHCO7F_UNUSED is a dangling const with no object_event behind it (it only
; appears in data/maps/toggleable_objects.asm), so nothing is invented for it.
;
; D85: warp 4 at (5,7) is Yellow's one-way shortcut straight to SILPH CO. 11F,
; landing on 11F's warp 4 at (3,2) -- which points back here, so the round trip
; closes.  It is the single biggest skip in the building and it is reproduced
; verbatim; it was already wired in 11a.  Warps 5 and 6 keep their indices
; because SILPH CO. 3F and 5F point at them.
;
; Rocket-takeover visibility (D73): Yellow hides TOGGLE_SILPH_CO_7F_1..7F_4 --
; the four trainers -- when GIOVANNI is beaten, so EVENT_BEAT_SILPH_CO_GIOVANNI
; is their HIDE flag.  The rival has his own, derived below.
;
; Card-key doors: Yellow block coordinates (5,3), (10,2) and (10,6), all three
; HORIZONTAL, so the shut block is $54.  `changeblock` takes MAP TILE
; coordinates (see maps/SilphCo2F.asm).  The bg_events that open them are 11j's
; and are now shipped.
	object_const_def
	const SILPHCO7F_SILPH_WORKER_M1
	const SILPHCO7F_SILPH_WORKER_M2
	const SILPHCO7F_SILPH_WORKER_M3
	const SILPHCO7F_SILPH_WORKER_M4
	const SILPHCO7F_ROCKET1
	const SILPHCO7F_SCIENTIST
	const SILPHCO7F_ROCKET2
	const SILPHCO7F_ROCKET3
	const SILPHCO7F_RIVAL
	const SILPHCO7F_CALCIUM
	const SILPHCO7F_TM_SWORDS_DANCE

SilphCo7F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_TILES, SilphCo7FDoorCallback
	callback MAPCALLBACK_OBJECTS, SilphCo7FObjectsCallback

SilphCo7FDoorCallback:
	checkevent EVENT_SILPH_CO_7F_UNLOCKED_DOOR_1
	iftrue .door2
	changeblock 10,  6, $54 ; shut door, Yellow block (5,3)
.door2
	checkevent EVENT_SILPH_CO_7F_UNLOCKED_DOOR_2
	iftrue .door3
	changeblock 20,  4, $54 ; shut door, Yellow block (10,2)
.door3
	checkevent EVENT_SILPH_CO_7F_UNLOCKED_DOOR_3
	iftrue .done
	changeblock 20, 12, $54 ; shut door, Yellow block (10,6)
.done
	endcallback

; 11j -- the card-key doors.  One BGEVENT_READ per walled tile (Yellow's engine
; is tile-driven, so either tile of a door works, from either side); the macro
; is macros/scripts/card_key.asm and the shared text/sound tail is
; maps/SilphCoCardKeyDoors.asm.  The changeblock here is what opens the door
; NOW -- the callback above only runs on a map LOAD.

SilphCo7FDoor1Script:
	silph_card_key_door EVENT_SILPH_CO_7F_UNLOCKED_DOOR_1, 10, 6, $0e ; Yellow block (5,3)

SilphCo7FDoor2Script:
	silph_card_key_door EVENT_SILPH_CO_7F_UNLOCKED_DOOR_2, 20, 4, $0e ; Yellow block (10,2)

SilphCo7FDoor3Script:
	silph_card_key_door EVENT_SILPH_CO_7F_UNLOCKED_DOOR_3, 20, 12, $0e ; Yellow block (10,6)

; docs/PORTING.md 3.4: the rival's hide flag is DERIVED from the stored fact
; EVENT_BEAT_SILPH_CO_RIVAL on every map load, never toggled once, so a
; white-out mid-scene cannot strand him.  Yellow does it by hand with
; HideObject + the SCRIPT_SILPHCO7F_* state machine.  Same shape as
; maps/PokemonTower2F.asm and maps/CeruleanCity.asm.
SilphCo7FObjectsCallback:
	checkevent EVENT_BEAT_SILPH_CO_RIVAL
	iftrue .RivalGone
	clearevent EVENT_SILPH_CO_7F_RIVAL_HIDDEN
	endcallback

.RivalGone:
	setevent EVENT_SILPH_CO_7F_RIVAL_HIDDEN
	endcallback

; Yellow SilphCo7FDefaultScript: two trigger tiles, `dbmapcoord 3, 2` and
; `dbmapcoord 3, 3`, at the mouth of the dead-end corridor the rival is waiting
; in.  He is at (3,7) and walks UP until he is directly below the player, so the
; number of steps depends on which tile was tripped: wCoordIndex is 1-BASED
; (CheckCoords increments it before the match), so Yellow's `cp 1` selects the
; FIRST entry -- (3,2), four steps -- and everything else the second -- (3,3),
; three steps.  The same saved index picks the exit walk afterwards.
;
; Yellow force-sets wPlayerMovingDirection to PLAYER_DIR_DOWN before the scene,
; which is `turnobject PLAYER, DOWN` here, and prints TEXT_SILPHCO7F_RIVAL
; ("What kept you?") from across the room BEFORE he starts walking.
SilphCo7FRivalSceneNorth:
	checkevent EVENT_BEAT_SILPH_CO_RIVAL
	iftrue .Done
	playmusic MUSIC_RIVAL_ENCOUNTER
	turnobject PLAYER, DOWN
	scall SilphCo7FRivalWhatKeptYou
	applymovement SILPHCO7F_RIVAL, SilphCo7F_RivalApproachFour
	turnobject PLAYER, DOWN
	scall SilphCo7FRivalBattle
	turnobject PLAYER, DOWN
	turnobject SILPHCO7F_RIVAL, UP
	scall SilphCo7FRivalGoodLuckToYou
	applymovement SILPHCO7F_RIVAL, SilphCo7F_RivalExitRight
	sjump SilphCo7FRivalGone

.Done:
	end

SilphCo7FRivalSceneSouth:
	checkevent EVENT_BEAT_SILPH_CO_RIVAL
	iftrue .Done
	playmusic MUSIC_RIVAL_ENCOUNTER
	turnobject PLAYER, DOWN
	scall SilphCo7FRivalWhatKeptYou
	applymovement SILPHCO7F_RIVAL, SilphCo7F_RivalApproachThree
	turnobject PLAYER, DOWN
	scall SilphCo7FRivalBattle
	turnobject PLAYER, DOWN
	turnobject SILPHCO7F_RIVAL, UP
	scall SilphCo7FRivalGoodLuckToYou
	applymovement SILPHCO7F_RIVAL, SilphCo7F_RivalWalkAroundPlayer
	sjump SilphCo7FRivalGone

.Done:
	end

SilphCo7FRivalWhatKeptYou:
	opentext
	writetext SilphCo7FRivalWhatKeptYouText
	waitbutton
	closetext
	return

; Yellow: `ld a, OPP_RIVAL2 / ld a, [wRivalStarter] / add 4 / ld [wTrainerNo], a`
; -- Rival2Data rows 5/6/7, the first three parties in which the EEVEE has
; actually evolved.  As at POKEMON TOWER 2F (9e) this is a ROW choice, never a
; species patch: `loadtrainer` only records the class/id and ReadTrainerParty
; rebuilds the party from ROM at `startbattle`.  See
; engine/events/kanto_rival.asm; `special GetKantoRivalStarter` hands back
; Yellow's wRivalStarter value in wScriptVar.
;
; Losing is a plain GSC white-out, so nothing past `startbattle` runs, the beat
; flag stays clear, and the OBJECTS callback above re-arms the whole scene --
; what Yellow's `cp LOST_BATTLE / jp z, SilphCo7FSetDefaultScript` does.
;
; No `dontrestartmapmusic` (the S.S. ANNE 2F / POKEMON TOWER 2F precedent): the
; battle puts the map song back by itself, exactly as Yellow's return path does.
SilphCo7FRivalBattle:
	opentext
	writetext SilphCo7FRivalWaitedHereText
	waitbutton
	closetext
	winlosstext SilphCo7FRivalDefeatedText, SilphCo7FRivalVictoryText
	setlasttalked SILPHCO7F_RIVAL
	special GetKantoRivalStarter
	ifequal RIVAL_STARTER_JOLTEON, .Jolteon
	ifequal RIVAL_STARTER_FLAREON, .Flareon
	loadtrainer KANTO_RIVAL, KANTO_RIVAL_10 ; RIVAL_STARTER_VAPOREON
	sjump .Fight

.Jolteon:
	loadtrainer KANTO_RIVAL, KANTO_RIVAL_8
	sjump .Fight

.Flareon:
	loadtrainer KANTO_RIVAL, KANTO_RIVAL_9

.Fight:
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_SILPH_CO_RIVAL
	return

; Yellow stops the music and restarts MUSIC_MEET_RIVAL at
; Music_RivalAlternateStart as the goodbye speech ends; MUSIC_RIVAL_AFTER is
; Crystal's equivalent piece (the CERULEAN, S.S. ANNE and TOWER scenes use it
; the same way).
SilphCo7FRivalGoodLuckToYou:
	opentext
	writetext SilphCo7FRivalGoodLuckToYouText
	waitbutton
	closetext
	playmusic MUSIC_RIVAL_AFTER
	return

; `special RestartMapMusic`, not `playmapmusic`: PlayMapMusic is a no-op when
; wMapMusic already holds the map's song, and it does here because this scene
; does not use `dontrestartmapmusic`.  Same reasoning as PokemonTower2FRivalGone.
SilphCo7FRivalGone:
	disappear SILPHCO7F_RIVAL
	setevent EVENT_SILPH_CO_7F_RIVAL_HIDDEN
	special RestartMapMusic
	end

; Yellow's SilphCo7FRivalText is the plain object script -- the same "What kept
; you?" line the scene opens with.  He is unreachable on foot before the trigger
; fires and gone afterwards, but the object still needs a script pointer.
SilphCo7FRivalScript:
	faceplayer
	opentext
	writetext SilphCo7FRivalWhatKeptYouText
	waitbutton
	closetext
	end

; Yellow SilphCo7FSilphWorkerM1Text, the LAPRAS giver (`lb bc, LAPRAS, 15`).
; Crystal's `givepoke` with no trainer argument takes the wild-catch path
; (SetCaughtData -> GiveANickname_YesNo), so the ordinary DV roll, the player as
; OT and the nickname prompt all come free, exactly as Yellow's AddPartyMon
; does.  `givepoke` returns 0 = party, 1 = box, 2 = both full, so the
; "<PLAYER> got LAPRAS!" line and its jingle are printed here on the party path
; only -- Crystal's GivePoke prints its own "sent to BILL's PC" message on the
; box path -- and the both-full text is printed locally because GivePoke
; returns 2 silently.  Same shape as the VERMILION SQUIRTLE (7e) and the
; CELADON MANSION EEVEE (9s).
;
; DEVIATION (cosmetic): Yellow's GivePokemon prints "got LAPRAS!" on the box
; path too, before its own SentToBoxText.  The tree convention drops the
; duplicate; it is the shipped behaviour of every other gift in the hack.
;
; The flag is only set on a path that actually handed the mon over, so a
; both-full player can come back for it.
SilphCo7FSilphWorkerM1Script:
	faceplayer
	opentext
	checkevent EVENT_GOT_LAPRAS
	iftrue .AlreadyGave
	writetext SilphCo7FSilphWorkerM1HaveThisPokemonText
	promptbutton
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .ToBox
	writetext SilphCo7FSilphWorkerM1GotLaprasText
	playsound SFX_CAUGHT_MON
	waitsfx
.ToBox:
	givepoke LAPRAS, 15
	ifequal 2, .BoxIsFull
	setevent EVENT_GOT_LAPRAS
	writetext SilphCo7FSilphWorkerM1LaprasDescriptionText
	waitbutton
	closetext
	end

.BoxIsFull:
	writetext SilphCo7FSilphWorkerM1BoxIsFullText
	waitbutton
	closetext
	end

.AlreadyGave:
	checkevent EVENT_BEAT_SILPH_CO_GIOVANNI
	iftrue .Saved
	writetext SilphCo7FSilphWorkerM1IsOurPresidentOkText
	waitbutton
	closetext
	end

.Saved:
	writetext SilphCo7FSilphWorkerM1SavedText
	waitbutton
	closetext
	end

SilphCo7FSilphWorkerM2Script:
	faceplayer
	opentext
	checkevent EVENT_BEAT_SILPH_CO_GIOVANNI
	iftrue .Saved
	writetext SilphCo7FSilphWorkerM2AfterTheMasterBallText
	waitbutton
	closetext
	end

.Saved:
	writetext SilphCo7FSilphWorkerM2CancelledMasterBallText
	waitbutton
	closetext
	end

SilphCo7FSilphWorkerM3Script:
	faceplayer
	opentext
	checkevent EVENT_BEAT_SILPH_CO_GIOVANNI
	iftrue .Saved
	writetext SilphCo7FSilphWorkerM3ItWouldBeBadText
	waitbutton
	closetext
	end

.Saved:
	writetext SilphCo7FSilphWorkerM3YouChasedOffTeamRocketText
	waitbutton
	closetext
	end

SilphCo7FSilphWorkerM4Script:
	faceplayer
	opentext
	checkevent EVENT_BEAT_SILPH_CO_GIOVANNI
	iftrue .Saved
	writetext SilphCo7FSilphWorkerM4ItsReallyDangerousHereText
	waitbutton
	closetext
	end

.Saved:
	writetext SilphCo7FSilphWorkerM4SafeAtLastText
	waitbutton
	closetext
	end

TrainerSilphCo7FRocket1:
	trainer GRUNTM, GRUNTM_49, EVENT_BEAT_SILPH_CO_7F_ROCKET_1, SilphCo7FRocket1SeenText, SilphCo7FRocket1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo7FRocket1AfterBattleText
	waitbutton
	closetext
	end

TrainerSilphCo7FScientist:
	trainer SCIENTIST, SCIENTIST_14, EVENT_BEAT_SILPH_CO_7F_SCIENTIST, SilphCo7FScientistSeenText, SilphCo7FScientistBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo7FScientistAfterBattleText
	waitbutton
	closetext
	end

TrainerSilphCo7FRocket2:
	trainer GRUNTM, GRUNTM_50, EVENT_BEAT_SILPH_CO_7F_ROCKET_2, SilphCo7FRocket2SeenText, SilphCo7FRocket2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo7FRocket2AfterBattleText
	waitbutton
	closetext
	end

TrainerSilphCo7FRocket3:
	trainer GRUNTM, GRUNTM_51, EVENT_BEAT_SILPH_CO_7F_ROCKET_3, SilphCo7FRocket3SeenText, SilphCo7FRocket3BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo7FRocket3AfterBattleText
	waitbutton
	closetext
	end

SilphCo7FCalcium:
	itemball CALCIUM

SilphCo7FTMSwordsDance:
	itemball TM_SWORDS_DANCE

; Yellow .RivalMovementUp, four NPC_MOVEMENT_UPs: (3,7) -> (3,3), directly below
; the player standing on (3,2).
SilphCo7F_RivalApproachFour:
	step UP
	step UP
	step UP
	step UP
	step_end

; The same table entered one byte in (Yellow's `inc de`): (3,7) -> (3,4),
; directly below the player standing on (3,3).
SilphCo7F_RivalApproachThree:
	step UP
	step UP
	step UP
	step_end

; Yellow .RivalExitRightMovement, taken when the player tripped (3,2): the rival
; is on (3,3) with the player above him, so two steps RIGHT put him on the (5,3)
; staircase to SILPH CO. 3F and he is gone.
SilphCo7F_RivalExitRight:
	step RIGHT
	step RIGHT
	step_end

; Yellow .RivalWalkAroundPlayerMovement, taken when the player tripped (3,3):
; the rival is on (3,4) and the player is standing on the tile he wants, so he
; goes round the west side -- (2,4), (2,3), (2,2), (3,2), (4,2), (5,2) -- and
; drops onto the same (5,3) staircase.
SilphCo7F_RivalWalkAroundPlayer:
	step LEFT
	step UP
	step UP
	step RIGHT
	step RIGHT
	step RIGHT
	step DOWN
	step_end

SilphCo7FSilphWorkerM1HaveThisPokemonText:
	text "Oh! Hi! You're"
	line "not a ROCKET! You"
	cont "came to save us?"
	cont "Why, thank you!"

	para "I want you to"
	line "have this #MON"
	cont "for saving us."
	prompt

SilphCo7FSilphWorkerM1GotLaprasText:
	text "<PLAYER> got"
	line "LAPRAS!"
	done

SilphCo7FSilphWorkerM1LaprasDescriptionText:
	text "It's LAPRAS. It's"
	line "very intelligent."

	para "We kept it in our"
	line "lab, but it will"
	cont "be much better"
	cont "off with you!"

	para "I think you will"
	line "be a good trainer"
	cont "for LAPRAS!"

	para "It's a good"
	line "swimmer. It'll"
	cont "give you a lift!"
	done

; Yellow: _BoxIsFullText, printed by GivePokemon when party and box are both
; full.  Crystal's GivePoke returns 2 and prints nothing, so we print it here.
SilphCo7FSilphWorkerM1BoxIsFullText:
	text "There's no more"
	line "room for #MON!"

	para "The #MON BOX"
	line "is full and can't"
	cont "accept any more!"
	done

SilphCo7FSilphWorkerM1IsOurPresidentOkText:
	text "TEAM ROCKET's"
	line "BOSS went to the"
	cont "boardroom! Is our"
	cont "PRESIDENT OK?"
	done

SilphCo7FSilphWorkerM1SavedText:
	text "Saved at last!"
	line "Thank you!"
	done

SilphCo7FSilphWorkerM2AfterTheMasterBallText:
	text "TEAM ROCKET was"
	line "after the MASTER"
	cont "BALL which will"
	cont "catch any #MON!"
	done

SilphCo7FSilphWorkerM2CancelledMasterBallText:
	text "We canceled the"
	line "MASTER BALL"
	cont "project because"
	cont "of TEAM ROCKET."
	done

SilphCo7FSilphWorkerM3ItWouldBeBadText:
	text "It would be bad"
	line "if TEAM ROCKET"
	cont "took over SILPH"
	cont "or our #MON!"
	done

SilphCo7FSilphWorkerM3YouChasedOffTeamRocketText:
	text "Wow! You chased"
	line "off TEAM ROCKET"
	cont "all by yourself?"
	done

SilphCo7FSilphWorkerM4ItsReallyDangerousHereText:
	text "You! It's really"
	line "dangerous here!"
	cont "You came to save"
	cont "me? You can't!"
	done

SilphCo7FSilphWorkerM4SafeAtLastText:
	text "Safe at last!"
	line "Oh thank you!"
	done

SilphCo7FRocket1SeenText:
	text "Aha! I smell a"
	line "little rat!"
	done

SilphCo7FRocket1BeatenText:
	text "Lights"
	line "out!"
	prompt

SilphCo7FRocket1AfterBattleText:
	text "You won't find my"
	line "BOSS by just"
	cont "scurrying around!"
	done

SilphCo7FScientistSeenText:
	text "Heheh!"

	para "You mistook me for"
	line "a SILPH worker?"
	done

SilphCo7FScientistBeatenText:
	text "I'm"
	line "done!"
	prompt

SilphCo7FScientistAfterBattleText:
	text "Despite your age,"
	line "you are a skilled"
	cont "trainer!"
	done

SilphCo7FRocket2SeenText:
	text "I am one of the 4"
	line "ROCKET BROTHERS!"
	done

SilphCo7FRocket2BeatenText:
	text "Aack!"
	line "Brothers, I lost!"
	prompt

SilphCo7FRocket2AfterBattleText:
	text "Doesn't matter."
	line "My brothers will"
	cont "repay the favor!"
	done

SilphCo7FRocket3SeenText:
	text "A child intruder?"
	line "That must be you!"
	done

SilphCo7FRocket3BeatenText:
	text "Fine!"
	line "I lost!"
	prompt

SilphCo7FRocket3AfterBattleText:
	text "Go on home"
	line "before my BOSS"
	cont "gets ticked off!"
	done

SilphCo7FRivalWhatKeptYouText:
	text "<RIVAL>: What"
	line "kept you <PLAYER>?"
	done

SilphCo7FRivalWaitedHereText:
	text "<RIVAL>: Hahaha!"
	line "I thought you'd"
	cont "turn up if I"
	cont "waited here!"

	para "I guess TEAM"
	line "ROCKET slowed you"
	cont "down! Not that I"
	cont "care!"

	para "I saw you in"
	line "SAFFRON, so I"
	cont "decided to see if"
	cont "you got better!"
	done

SilphCo7FRivalDefeatedText:
	text "Oh-oh!"
	line "So, you are ready"
	cont "for BOSS ROCKET!"
	prompt

SilphCo7FRivalVictoryText:
	text "<RIVAL>: How can"
	line "I put this?"

	para "You're not good"
	line "enough to play"
	cont "with us big boys!"
	prompt

SilphCo7FRivalGoodLuckToYouText:
	text "Well, <PLAYER>!"

	para "I'm moving on up"
	line "and ahead!"

	para "By checking my"
	line "#DEX, I'm"
	cont "starting to see"
	cont "what's strong and"
	cont "how they evolve!"

	para "I'm going to the"
	line "#MON LEAGUE"
	cont "to boot out the"
	cont "ELITE FOUR!"

	para "I'll become the"
	line "world's most"
	cont "powerful trainer!"

	para "<PLAYER>, well"
	line "good luck to you!"
	cont "Don't sweat it!"
	cont "Smell ya!"
	done

SilphCo7F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 16,  0, SILPH_CO_8F, 2
	warp_event 22,  0, SILPH_CO_6F, 1
	warp_event 18,  0, SILPH_CO_ELEVATOR, 1
	warp_event  5,  7, SILPH_CO_11F, 4 ; D85: the shortcut pad straight to 11F
	warp_event  5,  3, SILPH_CO_3F, 9
	warp_event 21, 15, SILPH_CO_5F, 4

	def_coord_events
; Yellow SilphCo7FDefaultScript.RivalEncounterCoordinates: `dbmapcoord 3, 2`
; (wCoordIndex 1, the four-step approach and the two-step exit) then
; `dbmapcoord 3, 3` (anything else: three steps in, the walk-around on the way
; out).
	coord_event  3,  2, -1, SilphCo7FRivalSceneNorth
	coord_event  3,  3, -1, SilphCo7FRivalSceneSouth

	def_bg_events
	; card-key door 1, Yellow block (5,3): walled top row -- faced from the north (or from inside, to the south)
	bg_event 10,  6, BGEVENT_READ, SilphCo7FDoor1Script
	bg_event 11,  6, BGEVENT_READ, SilphCo7FDoor1Script
	; card-key door 2, Yellow block (10,2): walled top row -- faced from the north (or from inside, to the south)
	bg_event 20,  4, BGEVENT_READ, SilphCo7FDoor2Script
	bg_event 21,  4, BGEVENT_READ, SilphCo7FDoor2Script
	; card-key door 3, Yellow block (10,6): walled top row -- faced from the north (or from inside, to the south)
	bg_event 20, 12, BGEVENT_READ, SilphCo7FDoor3Script
	bg_event 21, 12, BGEVENT_READ, SilphCo7FDoor3Script

	def_object_events
	object_event  1,  5, SPRITE_SILPH_WORKER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SilphCo7FSilphWorkerM1Script, -1
	object_event 13, 13, SPRITE_SILPH_WORKER_M, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SilphCo7FSilphWorkerM2Script, -1
	object_event  7, 10, SPRITE_SILPH_WORKER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SilphCo7FSilphWorkerM3Script, -1
	object_event 10,  8, SPRITE_SILPH_WORKER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SilphCo7FSilphWorkerM4Script, -1
	object_event 13,  1, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerSilphCo7FRocket1, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event  2, 13, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerSilphCo7FScientist, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event 20,  2, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerSilphCo7FRocket2, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event 19, 14, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerSilphCo7FRocket3, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event  3,  7, SPRITE_KANTO_RIVAL, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SilphCo7FRivalScript, EVENT_SILPH_CO_7F_RIVAL_HIDDEN
	object_event  1,  9, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SilphCo7FCalcium, EVENT_SILPH_CO_7F_CALCIUM
	object_event 24, 11, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SilphCo7FTMSwordsDance, EVENT_SILPH_CO_7F_TM_SWORDS_DANCE
