; Kanto hack (M8 11g, docs/M8-SAFFRON.md 0.6 row 11g): SILPH CO. 8F, ported
; from Yellow -- three trainers, one civilian SILPH worker, one card-key door
; and the floor's two same-floor teleport-pad loops (D84).
;
; Cast, coordinates and facings are Yellow's
; (vendor/pokeyellow/data/maps/objects/SilphCo8F.asm); sight ranges are the
; second argument of Yellow's `trainer` headers
; (vendor/pokeyellow/scripts/SilphCo8F.asm): 4 / 4 / 4.  Text is Yellow's
; (vendor/pokeyellow/text/SilphCo8F.asm).
;
; D84: warps 4 and 7 are the troll pads.  Yellow sends (3,11) to warp 7 -- the
; pad at (11,9) on THIS floor -- and (11,9) back to warp 4 at (3,11), so the two
; pads just bounce the player between the two halves of 8F forever while looking
; exactly like the pads that do go somewhere.  Both are reproduced verbatim;
; they were already in place from 11a, and warps 5 and 6 keep their indices
; because SILPH CO. 2F's pads point at them.
;
; Rocket-takeover visibility (D73): Yellow hides TOGGLE_SILPH_CO_8F_1..8F_3 --
; the three trainers -- when GIOVANNI is beaten, so EVENT_BEAT_SILPH_CO_GIOVANNI
; is their HIDE flag.
;
; Card-key door: Yellow block coordinate (3,4), VERTICAL, shut block $5f.
; `changeblock` takes MAP TILE coordinates (see maps/SilphCo2F.asm).  The
; bg_event that opens it is 11j's.
	object_const_def
	const SILPHCO8F_SILPH_WORKER_M
	const SILPHCO8F_ROCKET1
	const SILPHCO8F_SCIENTIST
	const SILPHCO8F_ROCKET2

SilphCo8F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_TILES, SilphCo8FDoorCallback

SilphCo8FDoorCallback:
	checkevent EVENT_SILPH_CO_8F_UNLOCKED_DOOR
	iftrue .done
	changeblock  6,  8, $5f ; shut door, Yellow block (3,4)
.done
	endcallback

SilphCo8FSilphWorkerMScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_SILPH_CO_GIOVANNI
	iftrue .Saved
	writetext SilphCo8FSilphWorkerMSilphIsFinishedText
	waitbutton
	closetext
	end

.Saved:
	writetext SilphCo8FSilphWorkerMThanksForSavingUsText
	waitbutton
	closetext
	end

TrainerSilphCo8FRocket1:
	trainer GRUNTM, GRUNTM_52, EVENT_BEAT_SILPH_CO_8F_ROCKET_1, SilphCo8FRocket1SeenText, SilphCo8FRocket1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo8FRocket1AfterBattleText
	waitbutton
	closetext
	end

TrainerSilphCo8FScientist:
	trainer SCIENTIST, SCIENTIST_15, EVENT_BEAT_SILPH_CO_8F_SCIENTIST, SilphCo8FScientistSeenText, SilphCo8FScientistBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo8FScientistAfterBattleText
	waitbutton
	closetext
	end

TrainerSilphCo8FRocket2:
	trainer GRUNTM, GRUNTM_53, EVENT_BEAT_SILPH_CO_8F_ROCKET_2, SilphCo8FRocket2SeenText, SilphCo8FRocket2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo8FRocket2AfterBattleText
	waitbutton
	closetext
	end

SilphCo8FSilphWorkerMSilphIsFinishedText:
	text "I wonder if SILPH"
	line "is finished…"
	done

SilphCo8FSilphWorkerMThanksForSavingUsText:
	text "Thanks for saving"
	line "us!"
	done

SilphCo8FRocket1SeenText:
	text "That's as far as"
	line "you'll go!"
	done

SilphCo8FRocket1BeatenText:
	text "Not"
	line "enough grit!"
	prompt

SilphCo8FRocket1AfterBattleText:
	text "If you don't turn"
	line "back, I'll call"
	cont "for backup!"
	done

SilphCo8FScientistSeenText:
	text "You're causing us"
	line "problems!"
	done

SilphCo8FScientistBeatenText:
	text "Huh?"
	line "I lost?"
	prompt

SilphCo8FScientistAfterBattleText:
	text "So, what do you"
	line "think of SILPH"
	cont "BUILDING's maze?"
	done

SilphCo8FRocket2SeenText:
	text "I am one of the 4"
	line "ROCKET BROTHERS!"
	done

SilphCo8FRocket2BeatenText:
	text "Whoo!"
	line "Oh brothers!"
	prompt

SilphCo8FRocket2AfterBattleText:
	text "I'll leave you up"
	line "to my brothers!"
	done

SilphCo8F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 16,  0, SILPH_CO_9F, 2
	warp_event 14,  0, SILPH_CO_7F, 1
	warp_event 18,  0, SILPH_CO_ELEVATOR, 1
	warp_event  3, 11, SILPH_CO_8F, 7 ; troll pad (D84): lands on the pad at (11,9)
	warp_event  3, 15, SILPH_CO_2F, 5
	warp_event 11,  5, SILPH_CO_2F, 6
	warp_event 11,  9, SILPH_CO_8F, 4 ; troll pad (D84): lands back on (3,11)

	def_coord_events

	def_bg_events

	def_object_events
	object_event  4,  2, SPRITE_SILPH_WORKER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SilphCo8FSilphWorkerMScript, -1
	object_event 19,  2, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerSilphCo8FRocket1, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event 10,  2, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 4, TrainerSilphCo8FScientist, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event 12, 15, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerSilphCo8FRocket2, EVENT_BEAT_SILPH_CO_GIOVANNI
