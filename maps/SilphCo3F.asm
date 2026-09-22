; Kanto hack (M8 11f, docs/M8-SAFFRON.md 0.6 row 11f): SILPH CO. 3F, ported
; from Yellow -- two trainers, one item ball, a hiding SILPH WORKER and the two
; card-key doors.
;
; Cast, coordinates and facings are Yellow's
; (vendor/pokeyellow/data/maps/objects/SilphCo3F.asm); sight ranges are the
; second argument of Yellow's `trainer` headers
; (vendor/pokeyellow/scripts/SilphCo3F.asm): 2 / 3.  Text is Yellow's
; (vendor/pokeyellow/text/SilphCo3F.asm).
;
; Rocket-takeover visibility (D73): Yellow hides TOGGLE_SILPH_CO_3F_1/_2 -- the
; ROCKET and the SCIENTIST -- when GIOVANNI is beaten, and leaves the SILPH
; WORKER and the item ball alone.  A GSC object_event's trailing flag is a HIDE
; flag, so EVENT_BEAT_SILPH_CO_GIOVANNI goes straight on the two trainers.
;
; Card-key doors: Yellow block coordinates (4,4) and (8,4) -- these two are
; VERTICAL doors, so the shut block is $5f (FLOOR/WALL/FLOOR/WALL), not 2F's
; $54.  See maps/SilphCo2F.asm for why the callback exists at all.
;
; Warps 4 and 10 are Yellow's two same-floor troll pads: each teleports you to
; the other, so the pair is a closed loop that wastes your time (D84 -- quirks
; reproduced verbatim).
	object_const_def
	const SILPHCO3F_SILPH_WORKER_M
	const SILPHCO3F_ROCKET
	const SILPHCO3F_SCIENTIST
	const SILPHCO3F_HYPER_POTION

SilphCo3F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_TILES, SilphCo3FDoorCallback

SilphCo3FDoorCallback:
	checkevent EVENT_SILPH_CO_3F_UNLOCKED_DOOR_1
	iftrue .door2
	changeblock  8,  8, $5f ; shut door, Yellow block (4,4)
.door2
	checkevent EVENT_SILPH_CO_3F_UNLOCKED_DOOR_2
	iftrue .done
	changeblock 16,  8, $5f ; shut door, Yellow block (8,4)
.done
	endcallback

SilphCo3FSilphWorkerMScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_SILPH_CO_GIOVANNI
	iftrue .Saved
	writetext SilphCo3FSilphWorkerMWhatShouldIDoText
	waitbutton
	closetext
	end

.Saved:
	writetext SilphCo3FSilphWorkerMYouSavedUsText
	waitbutton
	closetext
	end

TrainerSilphCo3FRocket:
	trainer GRUNTM, GRUNTM_42, EVENT_BEAT_SILPH_CO_3F_ROCKET, SilphCo3FRocketSeenText, SilphCo3FRocketBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo3FRocketAfterBattleText
	waitbutton
	closetext
	end

TrainerSilphCo3FScientist:
	trainer SCIENTIST, SCIENTIST_10, EVENT_BEAT_SILPH_CO_3F_SCIENTIST, SilphCo3FScientistSeenText, SilphCo3FScientistBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo3FScientistAfterBattleText
	waitbutton
	closetext
	end

SilphCo3FHyperPotion:
	itemball HYPER_POTION

SilphCo3FSilphWorkerMWhatShouldIDoText:
	text "I work for SILPH."
	line "What should I do?"
	done

SilphCo3FSilphWorkerMYouSavedUsText:
	text "<PLAYER>! You and"
	line "your #MON"
	cont "saved us!"
	done

SilphCo3FRocketSeenText:
	text "Quit messing with"
	line "us, kid!"
	done

SilphCo3FRocketBeatenText:
	text "I give"
	line "up!"
	prompt

SilphCo3FRocketAfterBattleText:
	text "A hint? You can"
	line "open doors with a"
	cont "CARD KEY!"
	done

SilphCo3FScientistSeenText:
	text "I support TEAM"
	line "ROCKET more than"
	cont "I support SILPH!"
	done

SilphCo3FScientistBeatenText:
	text "You"
	line "really got me!"
	prompt

SilphCo3FScientistAfterBattleText:
	text "Humph…"

	para "TEAM ROCKET said"
	line "that if I helped"
	cont "them, they'd let"
	cont "me study #MON!"
	done

SilphCo3F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 26,  0, SILPH_CO_2F, 2
	warp_event 24,  0, SILPH_CO_4F, 1
	warp_event 20,  0, SILPH_CO_ELEVATOR, 1
	warp_event 23, 11, SILPH_CO_3F, 10 ; troll pad: loops to warp 10
	warp_event  3,  3, SILPH_CO_5F, 6
	warp_event  3, 15, SILPH_CO_5F, 7
	warp_event 27,  3, SILPH_CO_2F, 4
	warp_event  3, 11, SILPH_CO_9F, 4
	warp_event 11, 11, SILPH_CO_7F, 5
	warp_event 27, 15, SILPH_CO_3F, 4 ; troll pad: loops back to warp 4

	def_coord_events

	def_bg_events

	def_object_events
	object_event 24,  8, SPRITE_SILPH_WORKER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SilphCo3FSilphWorkerMScript, -1
	object_event 20,  7, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerSilphCo3FRocket, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event  7,  9, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerSilphCo3FScientist, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event  8,  5, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SilphCo3FHyperPotion, EVENT_SILPH_CO_3F_HYPER_POTION
