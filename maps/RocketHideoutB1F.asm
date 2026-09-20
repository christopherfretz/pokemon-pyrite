; Kanto hack (M6 9x, docs/M6-CELADON.md 3.4): Yellow's ROCKET_HIDEOUT_B1F
; population -- five Rockets, two item balls and one hidden item, at Yellow's
; own coordinates (vendor/pokeyellow/data/maps/objects/RocketHideoutB1F.asm).
;
; Sight ranges are Yellow's `trainer` second argument, which is how far that
; Gen 1 trainer actually sees: 3 / 2 / 2 / 3 / 3.
	object_const_def
	const ROCKETHIDEOUTB1F_ROCKET1
	const ROCKETHIDEOUTB1F_ROCKET2
	const ROCKETHIDEOUTB1F_ROCKET3
	const ROCKETHIDEOUTB1F_ROCKET4
	const ROCKETHIDEOUTB1F_ROCKET5
	const ROCKETHIDEOUTB1F_ESCAPE_ROPE
	const ROCKETHIDEOUTB1F_HYPER_POTION

RocketHideoutB1F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_TILES, RocketHideoutB1FDoorCallback

; Kanto hack (M6 9w, docs/M6-CELADON.md 3.4): Yellow's B1F door.
; RocketHideoutB1FDoorCallbackScript flips block (12, 8) -- Yellow writes
; `lb bc, 8, 12`, which is (y, x) -- between $54 (a shut door, WALL) and $0e
; (plain floor), sealing the corridor down to the lift until the fifth B1F
; Rocket is beaten.
;
; GSC's `changeblock` does NOT take block coordinates: Script_changeblock adds
; the 4-tile border to each argument and GetBlockLocation halves them, so the
; arguments are MAP TILE coordinates, the same space as warp_event, and Yellow
; block (12, 8) is `changeblock 24, 16` -- the two-tile gap in the wall along
; tile row 16, directly above the lift doors at (24,19)/(25,19).
;
; Yellow re-runs that on EVERY map load and replays SFX_GO_INSIDE each time --
; its own source flags that as a bug ("should be SetEvent to avoid the SFX
; playing every time you enter the map").  We keep the geometry and drop the
; bug: this callback only paints the block from the flag, so it is silent and
; idempotent, and the one-off "the door slid open" sound belongs on the actual
; transition, in the trainer's after-battle script (9x: TrainerRocketHideoutB1FRocket5).
RocketHideoutB1FDoorCallback:
	checkevent EVENT_BEAT_ROCKET_HIDEOUT_B1F_ROCKET_5
	iftrue .open
	changeblock 24, 16, $54 ; shut door
	endcallback

.open
	changeblock 24, 16, $0e ; floor
	endcallback

TrainerRocketHideoutB1FRocket1:
	trainer GRUNTM, GRUNTM_31, EVENT_BEAT_ROCKET_HIDEOUT_B1F_ROCKET_1, RocketHideoutB1FRocket1SeenText, RocketHideoutB1FRocket1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext RocketHideoutB1FRocket1AfterBattleText
	waitbutton
	closetext
	end

TrainerRocketHideoutB1FRocket2:
	trainer GRUNTM, GRUNTM_32, EVENT_BEAT_ROCKET_HIDEOUT_B1F_ROCKET_2, RocketHideoutB1FRocket2SeenText, RocketHideoutB1FRocket2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext RocketHideoutB1FRocket2AfterBattleText
	waitbutton
	closetext
	end

TrainerRocketHideoutB1FRocket3:
	trainer GRUNTM, GRUNTM_33, EVENT_BEAT_ROCKET_HIDEOUT_B1F_ROCKET_3, RocketHideoutB1FRocket3SeenText, RocketHideoutB1FRocket3BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext RocketHideoutB1FRocket3AfterBattleText
	waitbutton
	closetext
	end

TrainerRocketHideoutB1FRocket4:
	trainer GRUNTM, GRUNTM_34, EVENT_BEAT_ROCKET_HIDEOUT_B1F_ROCKET_4, RocketHideoutB1FRocket4SeenText, RocketHideoutB1FRocket4BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext RocketHideoutB1FRocket4AfterBattleText
	waitbutton
	closetext
	end

; The door Rocket.  Yellow sets EVENT_BEAT_ROCKET_HIDEOUT_1_TRAINER_4 from his
; end-battle text and lets the next map-load callback repaint the block (and
; replay the SFX, the bug above); the GSC `trainer` macro sets the flag for us,
; so the only thing left to do on the just-battled pass is the one-off
; repaint + sound.  `checkjustbattled` is the inverse of `endifjustbattled`:
; wScriptVar is TRUE only on the pass that follows the battle, so the sound
; plays exactly once and later talks fall through to the after-battle line.
TrainerRocketHideoutB1FRocket5:
	trainer GRUNTM, GRUNTM_35, EVENT_BEAT_ROCKET_HIDEOUT_B1F_ROCKET_5, RocketHideoutB1FRocket5SeenText, RocketHideoutB1FRocket5BeatenText, 0, .Script

.Script:
	checkjustbattled
	iffalse .AfterBattle
	changeblock 24, 16, $0e ; floor -- the door slides open
	refreshmap
	playsound SFX_ENTER_DOOR ; GSC has no SFX_GO_INSIDE (9u finding)
	waitsfx
	end

; Yellow only speaks "Uh-oh, that fight opened the door!" when you talk to him
; AGAIN -- the door itself opens silently-but-for-the-SFX on the reload.
.AfterBattle:
	opentext
	writetext RocketHideoutB1FRocket5AfterBattleText
	waitbutton
	closetext
	end

RocketHideoutB1FEscapeRope:
	itemball ESCAPE_ROPE

RocketHideoutB1FHyperPotion:
	itemball HYPER_POTION

RocketHideoutB1FHiddenPpUp:
	hiddenitem PP_UP, EVENT_ROCKET_HIDEOUT_B1F_HIDDEN_PP_UP

RocketHideoutB1FRocket1SeenText:
	text "Who are you? How"
	line "did you get here?"
	done

RocketHideoutB1FRocket1BeatenText:
	text "Oww!"
	line "Beaten!"
	prompt

RocketHideoutB1FRocket1AfterBattleText:
	text "Are you dissing"
	line "TEAM ROCKET?"
	done

RocketHideoutB1FRocket2SeenText:
	text "You broke into"
	line "our operation?"
	done

RocketHideoutB1FRocket2BeatenText:
	text "Burnt!"
	prompt

RocketHideoutB1FRocket2AfterBattleText:
	text "You're not going"
	line "to get away with"
	cont "this, brat!"
	done

RocketHideoutB1FRocket3SeenText:
	text "Intruder alert!"
	done

RocketHideoutB1FRocket3BeatenText:
	text "I"
	line "can't do it!"
	prompt

RocketHideoutB1FRocket3AfterBattleText:
	text "SILPH SCOPE?"
	line "I don't know"
	cont "where it is!"
	done

RocketHideoutB1FRocket4SeenText:
	text "Why did you come"
	line "here?"
	done

RocketHideoutB1FRocket4BeatenText:
	text "This"
	line "won't do!"
	prompt

RocketHideoutB1FRocket4AfterBattleText:
	text "OK, I'll talk!"
	line "Take the elevator"
	cont "to see my BOSS!"
	done

RocketHideoutB1FRocket5SeenText:
	text "Are you lost, you"
	line "little rat?"
	done

RocketHideoutB1FRocket5BeatenText:
	text "Why…?"
	prompt

RocketHideoutB1FRocket5AfterBattleText:
	text "Uh-oh, that fight"
	line "opened the door!"
	done

RocketHideoutB1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; Kanto hack (M6 9w): Yellow's warp table, tile for tile.  Warps 1 and 4 are
; the two staircases down to B2F, 2 is the staircase back up to the GAME
; CORNER (9u), 3 and 5 are the lift doors.  The elevator's own warps are -1,
; so which floor they land on is whatever the lift panel last chose.
	warp_event 23,  2, ROCKET_HIDEOUT_B2F, 1
	warp_event 21,  2, CELADON_GAME_CORNER, 3
	warp_event 24, 19, ROCKET_HIDEOUT_ELEVATOR, 1
	warp_event 21, 24, ROCKET_HIDEOUT_B2F, 4
	warp_event 25, 19, ROCKET_HIDEOUT_ELEVATOR, 2

	def_coord_events

	def_bg_events
	bg_event 21, 15, BGEVENT_ITEM, RocketHideoutB1FHiddenPpUp ; Yellow's hidden PP UP (data/events/hidden_events.asm:199)

	def_object_events
	object_event 26,  8, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerRocketHideoutB1FRocket1, -1
	object_event 12,  6, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerRocketHideoutB1FRocket2, -1
	object_event 18, 17, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerRocketHideoutB1FRocket3, -1
	object_event 15, 25, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerRocketHideoutB1FRocket4, -1
	object_event 28, 18, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerRocketHideoutB1FRocket5, -1
	object_event 11, 14, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, RocketHideoutB1FEscapeRope, EVENT_ROCKET_HIDEOUT_B1F_ESCAPE_ROPE
	object_event  9, 17, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, RocketHideoutB1FHyperPotion, EVENT_ROCKET_HIDEOUT_B1F_HYPER_POTION
