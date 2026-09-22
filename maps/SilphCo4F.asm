; Kanto hack (M8 11f, docs/M8-SAFFRON.md 0.6 row 11f): SILPH CO. 4F, ported
; from Yellow -- three trainers, three item balls, a SILPH WORKER hiding in the
; corner and the two card-key doors.
;
; Cast, coordinates and facings are Yellow's
; (vendor/pokeyellow/data/maps/objects/SilphCo4F.asm); sight ranges are the
; second argument of Yellow's `trainer` headers
; (vendor/pokeyellow/scripts/SilphCo4F.asm): 4 / 3 / 4.  Text is Yellow's
; (vendor/pokeyellow/text/SilphCo4F.asm).
;
; Rocket-takeover visibility (D73): Yellow hides TOGGLE_SILPH_CO_4F_1..4F_3 --
; the three trainers -- when GIOVANNI is beaten.  The trailing object_event flag
; is a HIDE flag, so EVENT_BEAT_SILPH_CO_GIOVANNI goes straight on them.
;
; Card-key doors: Yellow block coordinates (2,6) and (6,4), both HORIZONTAL, so
; the shut block is $54 (WALL/WALL/FLOOR/FLOOR).  See maps/SilphCo2F.asm.
	object_const_def
	const SILPHCO4F_SILPH_WORKER_M
	const SILPHCO4F_ROCKET1
	const SILPHCO4F_SCIENTIST
	const SILPHCO4F_ROCKET2
	const SILPHCO4F_FULL_HEAL
	const SILPHCO4F_MAX_REVIVE
	const SILPHCO4F_ESCAPE_ROPE

SilphCo4F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_TILES, SilphCo4FDoorCallback

SilphCo4FDoorCallback:
	checkevent EVENT_SILPH_CO_4F_UNLOCKED_DOOR_1
	iftrue .door2
	changeblock  4, 12, $54 ; shut door, Yellow block (2,6)
.door2
	checkevent EVENT_SILPH_CO_4F_UNLOCKED_DOOR_2
	iftrue .done
	changeblock 12,  8, $54 ; shut door, Yellow block (6,4)
.done
	endcallback

; 11j -- the card-key doors.  One BGEVENT_READ per walled tile (Yellow's engine
; is tile-driven, so either tile of a door works, from either side); the macro
; is macros/scripts/card_key.asm and the shared text/sound tail is
; maps/SilphCoCardKeyDoors.asm.  The changeblock here is what opens the door
; NOW -- the callback above only runs on a map LOAD.

SilphCo4FDoor1Script:
	silph_card_key_door EVENT_SILPH_CO_4F_UNLOCKED_DOOR_1, 4, 12, $0e ; Yellow block (2,6)

SilphCo4FDoor2Script:
	silph_card_key_door EVENT_SILPH_CO_4F_UNLOCKED_DOOR_2, 12, 8, $0e ; Yellow block (6,4)

SilphCo4FSilphWorkerMScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_SILPH_CO_GIOVANNI
	iftrue .RocketsGone
	writetext SilphCo4FSilphWorkerMImHidingText
	waitbutton
	closetext
	end

.RocketsGone:
	writetext SilphCo4FSilphWorkerMTeamRocketIsGoneText
	waitbutton
	closetext
	end

TrainerSilphCo4FRocket1:
	trainer GRUNTM, GRUNTM_43, EVENT_BEAT_SILPH_CO_4F_ROCKET_1, SilphCo4FRocket1SeenText, SilphCo4FRocket1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo4FRocket1AfterBattleText
	waitbutton
	closetext
	end

TrainerSilphCo4FScientist:
	trainer SCIENTIST, SCIENTIST_11, EVENT_BEAT_SILPH_CO_4F_SCIENTIST, SilphCo4FScientistSeenText, SilphCo4FScientistBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo4FScientistAfterBattleText
	waitbutton
	closetext
	end

TrainerSilphCo4FRocket2:
	trainer GRUNTM, GRUNTM_44, EVENT_BEAT_SILPH_CO_4F_ROCKET_2, SilphCo4FRocket2SeenText, SilphCo4FRocket2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo4FRocket2AfterBattleText
	waitbutton
	closetext
	end

SilphCo4FFullHeal:
	itemball FULL_HEAL

SilphCo4FMaxRevive:
	itemball MAX_REVIVE

SilphCo4FEscapeRope:
	itemball ESCAPE_ROPE

SilphCo4FSilphWorkerMImHidingText:
	text "Sssh! Can't you"
	line "see I'm hiding?"
	done

SilphCo4FSilphWorkerMTeamRocketIsGoneText:
	text "Huh? TEAM ROCKET"
	line "is gone?"
	done

SilphCo4FRocket1SeenText:
	text "TEAM ROCKET has"
	line "taken command of"
	cont "SILPH CO.!"
	done

SilphCo4FRocket1BeatenText:
	text "Arrgh!"
	prompt

SilphCo4FRocket1AfterBattleText:
	text "Fwahahaha!"
	line "My BOSS has been"
	cont "after this place!"
	done

SilphCo4FScientistSeenText:
	text "My #MON are my"
	line "loyal soldiers!"
	done

SilphCo4FScientistBeatenText:
	text "Darn!"
	line "You weak #MON!"
	prompt

SilphCo4FScientistAfterBattleText:
	text "The doors are"
	line "electronically"
	cont "locked! A CARD"
	cont "KEY opens them!"
	done

SilphCo4FRocket2SeenText:
	text "Intruder spotted!"
	done

SilphCo4FRocket2BeatenText:
	text "Who"
	line "are you?"
	prompt

SilphCo4FRocket2AfterBattleText:
	text "I better tell the"
	line "BOSS on 11F!"
	done

SilphCo4F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 24,  0, SILPH_CO_3F, 2
	warp_event 26,  0, SILPH_CO_5F, 2
	warp_event 20,  0, SILPH_CO_ELEVATOR, 1
	warp_event 11,  7, SILPH_CO_10F, 4
	warp_event 17,  3, SILPH_CO_6F, 4
	warp_event  3, 15, SILPH_CO_10F, 5
	warp_event 17, 11, SILPH_CO_10F, 6

	def_coord_events

	def_bg_events
	; card-key door 1, Yellow block (2,6): walled top row -- faced from the north (or from inside, to the south)
	bg_event  4, 12, BGEVENT_READ, SilphCo4FDoor1Script
	bg_event  5, 12, BGEVENT_READ, SilphCo4FDoor1Script
	; card-key door 2, Yellow block (6,4): walled top row -- faced from the north (or from inside, to the south)
	bg_event 12,  8, BGEVENT_READ, SilphCo4FDoor2Script
	bg_event 13,  8, BGEVENT_READ, SilphCo4FDoor2Script

	def_object_events
	object_event  6,  2, SPRITE_SILPH_WORKER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SilphCo4FSilphWorkerMScript, -1
	object_event  9, 14, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerSilphCo4FRocket1, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event 14,  6, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerSilphCo4FScientist, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event 26, 10, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerSilphCo4FRocket2, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event  3,  9, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SilphCo4FFullHeal, EVENT_SILPH_CO_4F_FULL_HEAL
	object_event  4,  7, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SilphCo4FMaxRevive, EVENT_SILPH_CO_4F_MAX_REVIVE
	object_event  5,  8, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SilphCo4FEscapeRope, EVENT_SILPH_CO_4F_ESCAPE_ROPE
