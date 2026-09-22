; Kanto hack (M8 11f, docs/M8-SAFFRON.md 0.6 row 11f): SILPH CO. 5F, ported
; from Yellow -- four trainers, three item balls INCLUDING THE CARD KEY, the
; hidden ELIXER, the three #MON REPORT notices and the three card-key doors.
;
; Cast, coordinates and facings are Yellow's
; (vendor/pokeyellow/data/maps/objects/SilphCo5F.asm); sight ranges are the
; second argument of Yellow's `trainer` headers
; (vendor/pokeyellow/scripts/SilphCo5F.asm): 1 / 2 / 4 / 3.  Text is Yellow's
; (vendor/pokeyellow/text/SilphCo5F.asm).
;
; The CARD KEY sits in a plain item ball at (21,16), exactly where Yellow puts
; it, behind the third locked door.  11j turns it into a working key.
;
; D81: Yellow's three #MON REPORTs are SPRITE_CLIPBOARD objects; here they are
; bg_events, which costs no sprite id and no object slot.  All three tiles are
; WALL blocks (the office scenery Yellow stands the clipboards in front of), so
; they read exactly like signs.
;
; Rocket-takeover visibility (D73): Yellow hides TOGGLE_SILPH_CO_5F_1..5F_4 --
; the four trainers -- when GIOVANNI is beaten.  The trailing object_event flag
; is a HIDE flag, so EVENT_BEAT_SILPH_CO_GIOVANNI goes straight on them.
;
; Card-key doors: Yellow block coordinates (3,2), (3,6) and (7,5), all three
; VERTICAL, so the shut block is $5f (FLOOR/WALL/FLOOR/WALL).  See
; maps/SilphCo2F.asm for why this callback is load-bearing.
	object_const_def
	const SILPHCO5F_SILPH_WORKER_M
	const SILPHCO5F_ROCKET1
	const SILPHCO5F_SCIENTIST
	const SILPHCO5F_ROCKER
	const SILPHCO5F_ROCKET2
	const SILPHCO5F_TM_TAKE_DOWN
	const SILPHCO5F_PROTEIN
	const SILPHCO5F_CARD_KEY

SilphCo5F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_TILES, SilphCo5FDoorCallback

SilphCo5FDoorCallback:
	checkevent EVENT_SILPH_CO_5F_UNLOCKED_DOOR_1
	iftrue .door2
	changeblock  6,  4, $5f ; shut door, Yellow block (3,2)
.door2
	checkevent EVENT_SILPH_CO_5F_UNLOCKED_DOOR_2
	iftrue .door3
	changeblock  6, 12, $5f ; shut door, Yellow block (3,6)
.door3
	checkevent EVENT_SILPH_CO_5F_UNLOCKED_DOOR_3
	iftrue .done
	changeblock 14, 10, $5f ; shut door, Yellow block (7,5)
.done
	endcallback

SilphCo5FSilphWorkerMScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_SILPH_CO_GIOVANNI
	iftrue .Hero
	writetext SilphCo5FSilphWorkerMThatsYouRightText
	waitbutton
	closetext
	end

.Hero:
	writetext SilphCo5FSilphWorkerMYoureOurHeroText
	waitbutton
	closetext
	end

TrainerSilphCo5FRocket1:
	trainer GRUNTM, GRUNTM_45, EVENT_BEAT_SILPH_CO_5F_ROCKET_1, SilphCo5FRocket1SeenText, SilphCo5FRocket1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo5FRocket1AfterBattleText
	waitbutton
	closetext
	end

TrainerSilphCo5FScientist:
	trainer SCIENTIST, SCIENTIST_12, EVENT_BEAT_SILPH_CO_5F_SCIENTIST, SilphCo5FScientistSeenText, SilphCo5FScientistBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo5FScientistAfterBattleText
	waitbutton
	closetext
	end

; Yellow's "ROCKER" -- SPRITE_ROCKER standing in the ball lab, battling as
; OPP_JUGGLER 1.  Same substitution as FUCHSIA GYM (M7 10h).
TrainerSilphCo5FJuggler:
	trainer JUGGLER, JUGGLER_9, EVENT_BEAT_SILPH_CO_5F_JUGGLER, SilphCo5FRockerSeenText, SilphCo5FRockerBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo5FRockerAfterBattleText
	waitbutton
	closetext
	end

TrainerSilphCo5FRocket2:
	trainer GRUNTM, GRUNTM_46, EVENT_BEAT_SILPH_CO_5F_ROCKET_2, SilphCo5FRocket2SeenText, SilphCo5FRocket2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo5FRocket2AfterBattleText
	waitbutton
	closetext
	end

SilphCo5FTMTakeDown:
	itemball TM_TAKE_DOWN

SilphCo5FProtein:
	itemball PROTEIN

SilphCo5FCardKey:
	itemball CARD_KEY

SilphCo5FHiddenElixer:
	hiddenitem ELIXER, EVENT_SILPH_CO_5F_HIDDEN_ELIXER

SilphCo5FPokemonReport1:
	jumptext SilphCo5FPokemonReport1Text

SilphCo5FPokemonReport2:
	jumptext SilphCo5FPokemonReport2Text

SilphCo5FPokemonReport3:
	jumptext SilphCo5FPokemonReport3Text

SilphCo5FSilphWorkerMThatsYouRightText:
	text "TEAM ROCKET is"
	line "in an uproar over"
	cont "some intruder."
	cont "That's you right?"
	done

SilphCo5FSilphWorkerMYoureOurHeroText:
	text "TEAM ROCKET took"
	line "off! You're our"
	cont "hero! Thank you!"
	done

SilphCo5FRocket1SeenText:
	text "I heard a kid was"
	line "wandering around."
	done

SilphCo5FRocket1BeatenText:
	text "Boom!"
	prompt

SilphCo5FRocket1AfterBattleText:
	text "It's not smart"
	line "to pick a fight"
	cont "with TEAM ROCKET!"
	done

SilphCo5FScientistSeenText:
	text "We study #"
	line "BALL technology"
	cont "on this floor!"
	done

SilphCo5FScientistBeatenText:
	text "Dang!"
	line "Blast it!"
	prompt

SilphCo5FScientistAfterBattleText:
	text "We worked on the"
	line "ultimate #"
	cont "BALL which would"
	cont "catch anything!"
	done

SilphCo5FRockerSeenText:
	text "Whaaat? There"
	line "shouldn't be any"
	cont "children here!"
	done

SilphCo5FRockerBeatenText:
	text "Oh"
	line "goodness!"
	prompt

SilphCo5FRockerAfterBattleText:
	text "You're only on 5F."
	line "It's a long way"
	cont "to my BOSS!"
	done

SilphCo5FRocket2SeenText:
	text "Show TEAM ROCKET"
	line "a little respect!"
	done

SilphCo5FRocket2BeatenText:
	text "Cough…"
	line "Cough…"
	prompt

SilphCo5FRocket2AfterBattleText:
	text "Which reminds me."

	para "KOFFING evolves"
	line "into WEEZING!"
	done

SilphCo5FPokemonReport1Text:
	text "It's a #MON"
	line "REPORT!"

	para "#MON LAB"
	line "created PORYGON,"
	cont "the first virtual"
	cont "reality #MON."
	done

SilphCo5FPokemonReport2Text:
	text "It's a #MON"
	line "REPORT!"

	para "Over 160 #MON"
	line "techniques have"
	cont "been confirmed."
	done

SilphCo5FPokemonReport3Text:
	text "It's a #MON"
	line "REPORT!"

	para "4 #MON evolve"
	line "only when traded"
	cont "by link-cable."
	done

SilphCo5F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 24,  0, SILPH_CO_6F, 2
	warp_event 26,  0, SILPH_CO_4F, 2
	warp_event 20,  0, SILPH_CO_ELEVATOR, 1
	warp_event 27,  3, SILPH_CO_7F, 6
	warp_event  9, 15, SILPH_CO_9F, 5
	warp_event 11,  5, SILPH_CO_3F, 5
	warp_event  3, 15, SILPH_CO_3F, 6

	def_coord_events

	def_bg_events
	bg_event 22, 12, BGEVENT_READ, SilphCo5FPokemonReport1 ; Yellow's CLIPBOARD 1 (D81)
	bg_event 25, 10, BGEVENT_READ, SilphCo5FPokemonReport2 ; Yellow's CLIPBOARD 2 (D81)
	bg_event 24,  6, BGEVENT_READ, SilphCo5FPokemonReport3 ; Yellow's CLIPBOARD 3 (D81)
	bg_event 12,  3, BGEVENT_ITEM, SilphCo5FHiddenElixer ; Yellow's hidden ELIXER (data/events/hidden_events.asm:117)

	def_object_events
	object_event 13,  9, SPRITE_SILPH_WORKER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SilphCo5FSilphWorkerMScript, -1
	object_event  8, 16, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 1, TrainerSilphCo5FRocket1, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event  8,  3, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, TrainerSilphCo5FScientist, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event 18, 10, SPRITE_ROCKER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerSilphCo5FJuggler, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event 28,  4, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerSilphCo5FRocket2, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event  2, 13, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SilphCo5FTMTakeDown, EVENT_SILPH_CO_5F_TM_TAKE_DOWN
	object_event  4,  6, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SilphCo5FProtein, EVENT_SILPH_CO_5F_PROTEIN
	object_event 21, 16, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SilphCo5FCardKey, EVENT_SILPH_CO_5F_CARD_KEY
