; Kanto hack (M8 11h, docs/M8-SAFFRON.md 0.6 row 11h): SILPH CO. 10F, ported
; from Yellow -- the last two guards before the boardroom, a terrified SILPH
; worker, the building's three remaining item balls and one card-key door.
;
; Cast, coordinates and facings are Yellow's
; (vendor/pokeyellow/data/maps/objects/SilphCo10F.asm); sight ranges are the
; second argument of Yellow's `trainer` headers
; (vendor/pokeyellow/scripts/SilphCo10F.asm): 3 / 4.  Text is Yellow's
; (vendor/pokeyellow/text/SilphCo10F.asm).
;
; The three balls are Yellow's exact items at Yellow's exact spots.  TM_EARTHQUAKE
; is our TM26 and Yellow's TM26 (docs/TM-LEDGER.md row 27), so both the number
; and the move ship faithful.
;
; Rocket-takeover visibility (D73): Yellow's toggleable_objects.asm hides
; TOGGLE_SILPH_CO_10F_1/_2 -- the two trainers -- when GIOVANNI is beaten, so
; EVENT_BEAT_SILPH_CO_GIOVANNI is their HIDE flag.  The SILPH worker and the
; three balls have toggle constants in Yellow but are never toggled, so they
; stay; she just switches to her "keep quiet about my crying" line.
;
; Card-key door: Yellow block coordinate (5,4) $54 (SilphCo10FGateCallbackScript's
; `lb bc, 4, 5`).  Our .blk is Yellow's and ships the gate as open floor ($0e),
; so this per-floor MAPCALLBACK_TILES shuts it on every map load until the flag
; is set.  `changeblock` takes MAP TILE coordinates (see maps/SilphCo2F.asm).
; The bg_events that open it are 11j's and are now shipped.
	object_const_def
	const SILPHCO10F_ROCKET
	const SILPHCO10F_SCIENTIST
	const SILPHCO10F_SILPH_WORKER_F
	const SILPHCO10F_TM_EARTHQUAKE
	const SILPHCO10F_RARE_CANDY
	const SILPHCO10F_CARBOS

SilphCo10F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_TILES, SilphCo10FDoorCallback

SilphCo10FDoorCallback:
	checkevent EVENT_SILPH_CO_10F_UNLOCKED_DOOR
	iftrue .done
	changeblock 10,  8, $54 ; shut door, Yellow block (5,4)
.done
	endcallback

; 11j -- the card-key doors.  One BGEVENT_READ per walled tile (Yellow's engine
; is tile-driven, so either tile of a door works, from either side); the macro
; is macros/scripts/card_key.asm and the shared text/sound tail is
; maps/SilphCoCardKeyDoors.asm.  The changeblock here is what opens the door
; NOW -- the callback above only runs on a map LOAD.

SilphCo10FDoorScript:
	silph_card_key_door EVENT_SILPH_CO_10F_UNLOCKED_DOOR, 10, 8, $0e ; Yellow block (5,4)

TrainerSilphCo10FRocket:
	trainer GRUNTM, GRUNTM_56, EVENT_BEAT_SILPH_CO_10F_ROCKET, SilphCo10FRocketSeenText, SilphCo10FRocketBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo10FRocketAfterBattleText
	waitbutton
	closetext
	end

TrainerSilphCo10FScientist:
	trainer SCIENTIST, SCIENTIST_17, EVENT_BEAT_SILPH_CO_10F_SCIENTIST, SilphCo10FScientistSeenText, SilphCo10FScientistBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo10FScientistAfterBattleText
	waitbutton
	closetext
	end

SilphCo10FSilphWorkerFScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_SILPH_CO_GIOVANNI
	iftrue .Saved
	writetext SilphCo10FSilphWorkerFImScaredText
	waitbutton
	closetext
	end

.Saved:
	writetext SilphCo10FSilphWorkerFQuietAboutMyCryingText
	waitbutton
	closetext
	end

SilphCo10FTMEarthquake:
	itemball TM_EARTHQUAKE

SilphCo10FRareCandy:
	itemball RARE_CANDY

SilphCo10FCarbos:
	itemball CARBOS

SilphCo10FRocketSeenText:
	text "Welcome to the"
	line "10F! So good of"
	cont "you to join me!"
	done

SilphCo10FRocketBeatenText:
	text "I'm"
	line "stunned!"
	prompt

SilphCo10FRocketAfterBattleText:
	text "Nice try, but the"
	line "boardroom is up"
	cont "one more floor!"
	done

SilphCo10FScientistSeenText:
	text "Enough of your"
	line "silly games!"
	done

SilphCo10FScientistBeatenText:
	text "No"
	line "continues left!"
	prompt

SilphCo10FScientistAfterBattleText:
	text "Are you satisfied"
	line "with beating me?"
	cont "Then go on home!"
	done

SilphCo10FSilphWorkerFImScaredText:
	text "Waaaaa!"
	line "I'm scared!"
	done

SilphCo10FSilphWorkerFQuietAboutMyCryingText:
	text "Please keep quiet"
	line "about my crying!"
	done

SilphCo10F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  8,  0, SILPH_CO_9F, 1
	warp_event 10,  0, SILPH_CO_11F, 1
	warp_event 12,  0, SILPH_CO_ELEVATOR, 1
	warp_event  9, 11, SILPH_CO_4F, 4
	warp_event 13, 15, SILPH_CO_4F, 6
	warp_event 13,  7, SILPH_CO_4F, 7

	def_coord_events

	def_bg_events
	; the card-key door, Yellow block (5,4): walled top row -- faced from the north (or from inside, to the south)
	bg_event 10,  8, BGEVENT_READ, SilphCo10FDoorScript
	bg_event 11,  8, BGEVENT_READ, SilphCo10FDoorScript

	def_object_events
	object_event  1,  9, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerSilphCo10FRocket, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event 10,  2, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 4, TrainerSilphCo10FScientist, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event  9, 15, SPRITE_SILPH_WORKER_F, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SilphCo10FSilphWorkerFScript, -1
	object_event  2, 12, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SilphCo10FTMEarthquake, EVENT_SILPH_CO_10F_TM_EARTHQUAKE
	object_event  4, 14, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SilphCo10FRareCandy, EVENT_SILPH_CO_10F_RARE_CANDY
	object_event  5, 11, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SilphCo10FCarbos, EVENT_SILPH_CO_10F_CARBOS
