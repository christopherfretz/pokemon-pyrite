; Kanto hack (M8 11h, docs/M8-SAFFRON.md 0.6 row 11h): SILPH CO. 9F, ported
; from Yellow -- three trainers, the free-heal NURSE, the building's last
; hidden item and the floor's four card-key doors.
;
; Cast, coordinates and facings are Yellow's
; (vendor/pokeyellow/data/maps/objects/SilphCo9F.asm); sight ranges are the
; second argument of Yellow's `trainer` headers
; (vendor/pokeyellow/scripts/SilphCo9F.asm): 4 / 2 / 4.  Text is Yellow's
; (vendor/pokeyellow/text/SilphCo9F.asm).
;
; The NURSE is the only free full heal inside the building.  Yellow's script is
; PrintText -> `predef HealParty` -> GBFadeOutToWhite -> Delay3 ->
; GBFadeInFromWhite -> PrintText, with NO jingle: the white flash is the whole
; presentation.  That is the POKeMON TOWER 5F purified-zone shape (M6 9j), so
; it is reproduced with the same three specials.  Yellow does nothing at all
; about the Pikachu follower here, so neither do we.  After GIOVANNI falls she
; stops offering and just thanks the player, like Yellow.
;
; Rocket-takeover visibility (D73): Yellow's toggleable_objects.asm hides
; TOGGLE_SILPH_CO_9F_1..9F_3 -- the three trainers, and ONLY them -- when
; GIOVANNI is beaten, so EVENT_BEAT_SILPH_CO_GIOVANNI is their HIDE flag.  The
; NURSE is not a toggleable object in Yellow and stays put.
;
; Card-key doors: Yellow block coordinates (1,4) $5f, (9,2) $54, (9,5) $54 and
; (5,6) $5f (SilphCo9FGateCallbackScript's four `lb bc, Y, X` pairs).  Our
; .blk is Yellow's and Yellow ships every gate as open floor ($0e), closing it
; from this per-floor callback on each map load -- so the callback is ours too.
; `changeblock` takes MAP TILE coordinates (see maps/SilphCo2F.asm).  The
; bg_events that open them are 11j's.
	object_const_def
	const SILPHCO9F_NURSE
	const SILPHCO9F_ROCKET1
	const SILPHCO9F_SCIENTIST
	const SILPHCO9F_ROCKET2

SilphCo9F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_TILES, SilphCo9FDoorCallback

SilphCo9FDoorCallback:
	checkevent EVENT_SILPH_CO_9F_UNLOCKED_DOOR_1
	iftrue .door2
	changeblock  2,  8, $5f ; shut door, Yellow block (1,4)
.door2
	checkevent EVENT_SILPH_CO_9F_UNLOCKED_DOOR_2
	iftrue .door3
	changeblock 18,  4, $54 ; shut door, Yellow block (9,2)
.door3
	checkevent EVENT_SILPH_CO_9F_UNLOCKED_DOOR_3
	iftrue .door4
	changeblock 18, 10, $54 ; shut door, Yellow block (9,5)
.door4
	checkevent EVENT_SILPH_CO_9F_UNLOCKED_DOOR_4
	iftrue .done
	changeblock 10, 12, $5f ; shut door, Yellow block (5,6)
.done
	endcallback

SilphCo9FNurseScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_SILPH_CO_GIOVANNI
	iftrue .Saved
	writetext SilphCo9FNurseYouLookTiredText
	waitbutton
	closetext
	special HealParty
	special FadeOutToWhite
	pause 10
	special FadeInFromWhite
	opentext
	writetext SilphCo9FNurseDontGiveUpText
	waitbutton
	closetext
	end

.Saved:
	writetext SilphCo9FNurseThankYouText
	waitbutton
	closetext
	end

TrainerSilphCo9FRocket1:
	trainer GRUNTM, GRUNTM_54, EVENT_BEAT_SILPH_CO_9F_ROCKET_1, SilphCo9FRocket1SeenText, SilphCo9FRocket1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo9FRocket1AfterBattleText
	waitbutton
	closetext
	end

TrainerSilphCo9FScientist:
	trainer SCIENTIST, SCIENTIST_16, EVENT_BEAT_SILPH_CO_9F_SCIENTIST, SilphCo9FScientistSeenText, SilphCo9FScientistBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo9FScientistAfterBattleText
	waitbutton
	closetext
	end

TrainerSilphCo9FRocket2:
	trainer GRUNTM, GRUNTM_55, EVENT_BEAT_SILPH_CO_9F_ROCKET_2, SilphCo9FRocket2SeenText, SilphCo9FRocket2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SilphCo9FRocket2AfterBattleText
	waitbutton
	closetext
	end

SilphCo9FHiddenMaxPotion:
	hiddenitem MAX_POTION, EVENT_SILPH_CO_9F_HIDDEN_MAX_POTION

SilphCo9FNurseYouLookTiredText:
	text "You look tired!"
	line "You should take a"
	cont "quick nap!"
	done

SilphCo9FNurseDontGiveUpText:
	text "Don't give up!"
	done

SilphCo9FNurseThankYouText:
	text "Thank you so"
	line "much!"
	done

SilphCo9FRocket1SeenText:
	text "Your #MON seem"
	line "to adore you, kid!"
	done

SilphCo9FRocket1BeatenText:
	text "Ghaaah!"
	prompt

SilphCo9FRocket1AfterBattleText:
	text "If I had started"
	line "as a trainer at"
	cont "your age…"
	done

SilphCo9FScientistSeenText:
	text "Your #MON have"
	line "weak points! I"
	cont "can nail them!"
	done

SilphCo9FScientistBeatenText:
	text "You"
	line "hammered me!"
	prompt

SilphCo9FScientistAfterBattleText:
	text "Exploiting weak"
	line "spots does work!"
	cont "Think about"
	cont "element types!"
	done

SilphCo9FRocket2SeenText:
	text "I am one of the 4"
	line "ROCKET BROTHERS!"
	done

SilphCo9FRocket2BeatenText:
	text "Warg!"
	line "Brothers, I lost!"
	prompt

SilphCo9FRocket2AfterBattleText:
	text "My brothers will"
	line "avenge me!"
	done

SilphCo9F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 14,  0, SILPH_CO_10F, 1
	warp_event 16,  0, SILPH_CO_8F, 1
	warp_event 18,  0, SILPH_CO_ELEVATOR, 1
	warp_event  9,  3, SILPH_CO_3F, 8
	warp_event 17, 15, SILPH_CO_5F, 5

	def_coord_events

	def_bg_events
	bg_event  2, 15, BGEVENT_ITEM, SilphCo9FHiddenMaxPotion ; Yellow's hidden MAX POTION (data/events/hidden_item_coords.asm:9)

	def_object_events
	object_event  3, 14, SPRITE_NURSE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SilphCo9FNurseScript, -1
	object_event  2,  4, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerSilphCo9FRocket1, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event 21, 13, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, TrainerSilphCo9FScientist, EVENT_BEAT_SILPH_CO_GIOVANNI
	object_event 13, 16, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerSilphCo9FRocket2, EVENT_BEAT_SILPH_CO_GIOVANNI
