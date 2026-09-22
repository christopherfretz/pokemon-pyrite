; Kanto hack (M8 11f, docs/M8-SAFFRON.md 0.6 row 11f): SILPH CO. 2F, ported
; from Yellow -- four trainers, the SILPH WORKER who hands over Yellow's TM36
; SELFDESTRUCT, and the two card-key doors.
;
; Cast, coordinates and facings are Yellow's
; (vendor/pokeyellow/data/maps/objects/SilphCo2F.asm); sight ranges are the
; second argument of Yellow's `trainer` headers
; (vendor/pokeyellow/scripts/SilphCo2F.asm): 3 / 4 / 3 / 3.  Every line of text
; is Yellow's (vendor/pokeyellow/text/SilphCo2F.asm).
;
; Rocket-takeover visibility: Yellow's data/maps/toggleable_objects.asm hides
; TOGGLE_SILPH_CO_2F_2..2F_5 -- the four trainers -- when GIOVANNI is beaten
; (scripts/SilphCo11F_2.asm), and leaves TOGGLE_SILPH_CO_2F_1 (the SILPH
; WORKER) alone.  A GSC object_event's trailing flag is a HIDE flag, so
; EVENT_BEAT_SILPH_CO_GIOVANNI goes straight on the four trainers and 11k needs
; no line for this floor.
;
; Card-key doors: Yellow's .blk ships both door blocks as $0e (open floor) and
; SilphCo2FGateCallbackScript paints $54 (a shut door: WALL/WALL/FLOOR/FLOOR)
; over them on every map load unless the matching unlock flag is set.  Our .blk
; is a byte-for-byte copy of Yellow's, so that callback is not optional -- it is
; what makes the doors walls.  Yellow's block coordinates (2,2) and (2,5) are
; `changeblock 4, 4` and `changeblock 4, 10`: GSC's changeblock takes MAP TILE
; coordinates (see maps/RocketHideoutB1F.asm).  11j adds the bg_events that set
; the flags; until then the doors never open.
	object_const_def
	const SILPHCO2F_SILPH_WORKER_F
	const SILPHCO2F_SCIENTIST1
	const SILPHCO2F_SCIENTIST2
	const SILPHCO2F_ROCKET1
	const SILPHCO2F_ROCKET2

SilphCo2F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_TILES, SilphCo2FDoorCallback

SilphCo2FDoorCallback:
	checkevent EVENT_SILPH_CO_2F_UNLOCKED_DOOR_1
	iftrue .door2
	changeblock  4,  4, $54 ; shut door, Yellow block (2,2)
.door2
	checkevent EVENT_SILPH_CO_2F_UNLOCKED_DOOR_2
	iftrue .done
	changeblock  4, 10, $54 ; shut door, Yellow block (2,5)
.done
	endcallback

; Yellow's SILPH WORKER F mistakes you for a ROCKET, then hands over TM36
; SELFDESTRUCT -- our TM75 (docs/TM-LEDGER.md row 24).  GSC's verbosegiveitem
; prints Yellow's "<PLAYER> got TM75!" line and handles the full-bag case, so
; only the explanation and the no-room lines are carried over verbatim.
SilphCo2FSilphWorkerFScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_TM75_SELFDESTRUCT
	iftrue .GotTM
	writetext SilphCo2FSilphWorkerFPleaseTakeThisText
	promptbutton
	verbosegiveitem TM_SELFDESTRUCT
	iffalse .NoRoom
	setevent EVENT_GOT_TM75_SELFDESTRUCT
	closetext
	end

.NoRoom:
	writetext SilphCo2FSilphWorkerFNoRoomText
	waitbutton
	closetext
	end

.GotTM:
	writetext SilphCo2FSilphWorkerFTM36ExplanationText
	waitbutton
	closetext
	end

TrainerSilphCo2FScientist1:
	trainer SCIENTIST, SCIENTIST_8, EVENT_BEAT_SILPH_CO_2F_SCIENTIST_1, SilphCo2FScientist1SeenText, SilphCo2FScientist1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo2FScientist1AfterBattleText
	waitbutton
	closetext
	end

TrainerSilphCo2FScientist2:
	trainer SCIENTIST, SCIENTIST_9, EVENT_BEAT_SILPH_CO_2F_SCIENTIST_2, SilphCo2FScientist2SeenText, SilphCo2FScientist2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo2FScientist2AfterBattleText
	waitbutton
	closetext
	end

TrainerSilphCo2FRocket1:
	trainer GRUNTM, GRUNTM_40, EVENT_BEAT_SILPH_CO_2F_ROCKET_1, SilphCo2FRocket1SeenText, SilphCo2FRocket1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo2FRocket1AfterBattleText
	waitbutton
	closetext
	end

TrainerSilphCo2FRocket2:
	trainer GRUNTM, GRUNTM_41, EVENT_BEAT_SILPH_CO_2F_ROCKET_2, SilphCo2FRocket2SeenText, SilphCo2FRocket2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo2FRocket2AfterBattleText
	waitbutton
	closetext
	end

SilphCo2FSilphWorkerFPleaseTakeThisText:
	text "Eeek!"
	line "No! Stop! Help!"

	para "Oh, you're not"
	line "with TEAM ROCKET."
	cont "I thought…"
	cont "I'm sorry. Here,"
	cont "please take this!"
	prompt

SilphCo2FSilphWorkerFTM36ExplanationText:
	text "TM75 is"
	line "SELFDESTRUCT!"

	para "It's powerful, but"
	line "the #MON that"
	cont "uses it faints!"
	cont "Be careful."
	done

SilphCo2FSilphWorkerFNoRoomText:
	text "You don't have any"
	line "room for this."
	done

SilphCo2FScientist1SeenText:
	text "Help! I'm a SILPH"
	line "employee."
	done

SilphCo2FScientist1BeatenText:
	text "How"
	line "did you know I"
	cont "was a ROCKET?"
	prompt

SilphCo2FScientist1AfterBattleText:
	text "I work for both"
	line "SILPH and TEAM"
	cont "ROCKET!"
	done

SilphCo2FScientist2SeenText:
	text "It's off limits"
	line "here! Go home!"
	done

SilphCo2FScientist2BeatenText:
	text "You're"
	line "good."
	prompt

SilphCo2FScientist2AfterBattleText:
	text "Can you solve the"
	line "maze in here?"
	done

SilphCo2FRocket1SeenText:
	text "No kids are"
	line "allowed in here!"
	done

SilphCo2FRocket1BeatenText:
	text "Tough!"
	prompt

SilphCo2FRocket1AfterBattleText:
	text "Diamond-shaped"
	line "tiles are"
	cont "teleport blocks!"

	para "They're hi-tech"
	line "transporters!"
	done

SilphCo2FRocket2SeenText:
	text "Hey kid! What are"
	line "you doing here?"
	done

SilphCo2FRocket2BeatenText:
	text "I goofed!"
	prompt

SilphCo2FRocket2AfterBattleText:
	text "SILPH CO. will"
	line "be merged with"
	cont "TEAM ROCKET!"
	done

SilphCo2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; Yellow's warp table, tile for tile.  Warps 4-7 are teleport pads; warp 4 is
; the one that drops you back on 3F's own pad maze.  Do not renumber warp 3 --
; the elevator's floor table indexes it (11e findings).
	warp_event 24,  0, SILPH_CO_1F, 3
	warp_event 26,  0, SILPH_CO_3F, 1
	warp_event 20,  0, SILPH_CO_ELEVATOR, 1
	warp_event  3,  3, SILPH_CO_3F, 7
	warp_event 13,  3, SILPH_CO_8F, 5
	warp_event 27, 15, SILPH_CO_8F, 6
	warp_event  9, 15, SILPH_CO_6F, 5

	def_coord_events

	def_bg_events

	def_object_events
	object_event 10,  1, SPRITE_SILPH_WORKER_F, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SilphCo2FSilphWorkerFScript, -1
	object_event  5, 12, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerSilphCo2FScientist1, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event 24, 13, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 4, TrainerSilphCo2FScientist2, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event 16, 11, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerSilphCo2FRocket1, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event 24,  7, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerSilphCo2FRocket2, EVENT_BEAT_SILPH_CO_GIOVANNI
