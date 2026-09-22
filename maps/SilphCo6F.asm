; Kanto hack (M8 11g, docs/M8-SAFFRON.md 0.6 row 11g): SILPH CO. 6F, ported
; from Yellow -- three trainers, two item balls, five civilian SILPH workers and
; the one card-key door.
;
; Cast, coordinates and facings are Yellow's
; (vendor/pokeyellow/data/maps/objects/SilphCo6F.asm); sight ranges are the
; second argument of Yellow's `trainer` headers
; (vendor/pokeyellow/scripts/SilphCo6F.asm): 2 / 3 / 2.  Text is Yellow's
; (vendor/pokeyellow/text/SilphCo6F.asm).
;
; All five workers are two-branch on EVENT_BEAT_SILPH_CO_GIOVANNI -- Yellow's
; SilphCo6FBeatGiovanniPrintDEOrPrintHLScript prints `hl` before the takeover
; ends and `de` after it, and every worker on this floor uses it.
;
; Rocket-takeover visibility (D73): Yellow hides TOGGLE_SILPH_CO_6F_1..6F_3 --
; the three trainers -- when GIOVANNI is beaten.  The trailing object_event flag
; is a HIDE flag, so EVENT_BEAT_SILPH_CO_GIOVANNI goes straight on them.  The
; two item balls are in the same Yellow toggle list only because that is how Gen
; 1 makes a picked-up ball vanish; here their own EVENT_SILPH_CO_6F_* flags do
; that job.
;
; Card-key door: Yellow block coordinate (2,6), VERTICAL, so the shut block is
; $5f (FLOOR/WALL/FLOOR/WALL).  `changeblock` takes MAP TILE coordinates, so the
; Yellow block (bx,by) becomes `changeblock 2*bx, 2*by` -- see
; maps/SilphCo2F.asm for the full note.  The bg_events that open it are 11j's.
	object_const_def
	const SILPHCO6F_SILPH_WORKER_M1
	const SILPHCO6F_SILPH_WORKER_M2
	const SILPHCO6F_SILPH_WORKER_F1
	const SILPHCO6F_SILPH_WORKER_F2
	const SILPHCO6F_SILPH_WORKER_M3
	const SILPHCO6F_ROCKET1
	const SILPHCO6F_SCIENTIST
	const SILPHCO6F_ROCKET2
	const SILPHCO6F_HP_UP
	const SILPHCO6F_X_ACCURACY

SilphCo6F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_TILES, SilphCo6FDoorCallback

SilphCo6FDoorCallback:
	checkevent EVENT_SILPH_CO_6F_UNLOCKED_DOOR
	iftrue .done
	changeblock  4, 12, $5f ; shut door, Yellow block (2,6)
.done
	endcallback

; 11j -- the card-key doors.  One BGEVENT_READ per walled tile (Yellow's engine
; is tile-driven, so either tile of a door works, from either side); the macro
; is macros/scripts/card_key.asm and the shared text/sound tail is
; maps/SilphCoCardKeyDoors.asm.  The changeblock here is what opens the door
; NOW -- the callback above only runs on a map LOAD.

SilphCo6FDoorScript:
	silph_card_key_door EVENT_SILPH_CO_6F_UNLOCKED_DOOR, 4, 12, $0e ; Yellow block (2,6)

SilphCo6FSilphWorkerM1Script:
	faceplayer
	opentext
	checkevent EVENT_BEAT_SILPH_CO_GIOVANNI
	iftrue .Saved
	writetext SilphCo6FSilphWorkerM1TookOverTheBuildingText
	waitbutton
	closetext
	end

.Saved:
	writetext SilphCo6FSilphWorkerM1BackToWorkText
	waitbutton
	closetext
	end

SilphCo6FSilphWorkerM2Script:
	faceplayer
	opentext
	checkevent EVENT_BEAT_SILPH_CO_GIOVANNI
	iftrue .Saved
	writetext SilphCo6FSilphWorkerM2HelpMePleaseText
	waitbutton
	closetext
	end

.Saved:
	writetext SilphCo6FSilphWorkerM2WeGotEngagedText
	waitbutton
	closetext
	end

SilphCo6FSilphWorkerF1Script:
	faceplayer
	opentext
	checkevent EVENT_BEAT_SILPH_CO_GIOVANNI
	iftrue .Saved
	writetext SilphCo6FSilphWorkerF1SuchACowardText
	waitbutton
	closetext
	end

.Saved:
	writetext SilphCo6FSilphWorkerF1HaveToMarryHimText
	waitbutton
	closetext
	end

SilphCo6FSilphWorkerF2Script:
	faceplayer
	opentext
	checkevent EVENT_BEAT_SILPH_CO_GIOVANNI
	iftrue .Saved
	writetext SilphCo6FSilphWorkerF2TeamRocketConquerWorldText
	waitbutton
	closetext
	end

.Saved:
	writetext SilphCo6FSilphWorkerF2TeamRocketRanText
	waitbutton
	closetext
	end

SilphCo6FSilphWorkerM3Script:
	faceplayer
	opentext
	checkevent EVENT_BEAT_SILPH_CO_GIOVANNI
	iftrue .Saved
	writetext SilphCo6FSilphWorkerM3TargetedSilphText
	waitbutton
	closetext
	end

.Saved:
	writetext SilphCo6FSilphWorkerM3WorkForSilphText
	waitbutton
	closetext
	end

TrainerSilphCo6FRocket1:
	trainer GRUNTM, GRUNTM_47, EVENT_BEAT_SILPH_CO_6F_ROCKET_1, SilphCo6FRocket1SeenText, SilphCo6FRocket1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo6FRocket1AfterBattleText
	waitbutton
	closetext
	end

TrainerSilphCo6FScientist:
	trainer SCIENTIST, SCIENTIST_13, EVENT_BEAT_SILPH_CO_6F_SCIENTIST, SilphCo6FScientistSeenText, SilphCo6FScientistBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo6FScientistAfterBattleText
	waitbutton
	closetext
	end

TrainerSilphCo6FRocket2:
	trainer GRUNTM, GRUNTM_48, EVENT_BEAT_SILPH_CO_6F_ROCKET_2, SilphCo6FRocket2SeenText, SilphCo6FRocket2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo6FRocket2AfterBattleText
	waitbutton
	closetext
	end

SilphCo6FHPUp:
	itemball HP_UP

SilphCo6FXAccuracy:
	itemball X_ACCURACY

SilphCo6FSilphWorkerM1TookOverTheBuildingText:
	text "The ROCKETs came"
	line "and took over the"
	cont "building!"
	done

SilphCo6FSilphWorkerM1BackToWorkText:
	text "Well, better get"
	line "back to work!"
	done

SilphCo6FSilphWorkerM2HelpMePleaseText:
	text "Oh dear, oh dear."
	line "Help me please!"
	done

SilphCo6FSilphWorkerM2WeGotEngagedText:
	text "We got engaged!"
	line "Heheh!"
	done

SilphCo6FSilphWorkerF1SuchACowardText:
	text "Look at him! He's"
	line "such a coward!"
	done

SilphCo6FSilphWorkerF1HaveToMarryHimText:
	text "I feel so sorry"
	line "for him, I have"
	cont "to marry him!"
	done

SilphCo6FSilphWorkerF2TeamRocketConquerWorldText:
	text "TEAM ROCKET is"
	line "trying to conquer"
	cont "the world with"
	cont "#MON!"
	done

SilphCo6FSilphWorkerF2TeamRocketRanText:
	text "TEAM ROCKET ran"
	line "because of you!"
	done

SilphCo6FSilphWorkerM3TargetedSilphText:
	text "They must have"
	line "targeted SILPH"
	cont "for our #MON"
	cont "products."
	done

SilphCo6FSilphWorkerM3WorkForSilphText:
	text "Come work for"
	line "SILPH when you"
	cont "get older!"
	done

SilphCo6FRocket1SeenText:
	text "I am one of the 4"
	line "ROCKET BROTHERS!"
	done

SilphCo6FRocket1BeatenText:
	text "Flame"
	line "out!"
	prompt

SilphCo6FRocket1AfterBattleText:
	text "No matter!"
	line "My brothers will"
	cont "avenge me!"
	done

SilphCo6FScientistSeenText:
	text "That rotten"
	line "PRESIDENT!"

	para "He shouldn't have"
	line "sent me to the"
	cont "TIKSI BRANCH!"
	done

SilphCo6FScientistBeatenText:
	text "Shoot!"
	prompt

SilphCo6FScientistAfterBattleText:
	text "TIKSI BRANCH?"
	line "It's in Russian"
	cont "no man's land!"
	done

SilphCo6FRocket2SeenText:
	text "You dare betray"
	line "TEAM ROCKET?"
	done

SilphCo6FRocket2BeatenText:
	text "You"
	line "traitor!"
	prompt

SilphCo6FRocket2AfterBattleText:
	text "If you stand for"
	line "justice, you"
	cont "betray evil!"
	done

SilphCo6F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 16,  0, SILPH_CO_7F, 2
	warp_event 14,  0, SILPH_CO_5F, 1
	warp_event 18,  0, SILPH_CO_ELEVATOR, 1
	warp_event  3,  3, SILPH_CO_4F, 5
	warp_event 23,  3, SILPH_CO_2F, 7

	def_coord_events

	def_bg_events
	; the card-key door, Yellow block (2,6): walled right column -- faced from the east (or from inside, to the west)
	bg_event  5, 12, BGEVENT_READ, SilphCo6FDoorScript
	bg_event  5, 13, BGEVENT_READ, SilphCo6FDoorScript

	def_object_events
	object_event 10,  6, SPRITE_SILPH_WORKER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SilphCo6FSilphWorkerM1Script, -1
	object_event 20,  6, SPRITE_SILPH_WORKER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SilphCo6FSilphWorkerM2Script, -1
	object_event 21,  6, SPRITE_SILPH_WORKER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SilphCo6FSilphWorkerF1Script, -1
	object_event 11, 10, SPRITE_SILPH_WORKER_F, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SilphCo6FSilphWorkerF2Script, -1
	object_event 18, 13, SPRITE_SILPH_WORKER_M, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SilphCo6FSilphWorkerM3Script, -1
	object_event 17,  3, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerSilphCo6FRocket1, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event  7,  8, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerSilphCo6FScientist, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event 14, 15, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerSilphCo6FRocket2, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event  3, 12, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SilphCo6FHPUp, EVENT_SILPH_CO_6F_HP_UP
	object_event  2, 15, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SilphCo6FXAccuracy, EVENT_SILPH_CO_6F_X_ACCURACY
