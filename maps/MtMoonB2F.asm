	object_const_def
	const MTMOONB2F_MIGUEL
	const MTMOONB2F_ROCKET1
	const MTMOONB2F_ROCKET2
	const MTMOONB2F_ROCKET3
	const MTMOONB2F_JESSIE
	const MTMOONB2F_JAMES
	const MTMOONB2F_DOME_FOSSIL
	const MTMOONB2F_HELIX_FOSSIL
	const MTMOONB2F_HP_UP
	const MTMOONB2F_TM_DYNAMICPUNCH

; Kanto hack: Mt. Moon B2F, from vendor/pokeyellow/maps/MtMoonB2F.blk (converted
; in 5a) and vendor/pokeyellow/data/maps/objects/MtMoonB2F.asm. 5b registered the
; map and its four warps; 5f adds the fossil beat, SUPER NERD MIGUEL, Yellow's
; three Rocket grunts, the two itemballs and the two hidden items
; (docs/M2-MTMOON.md, "5f findings"). Coordinates, facings and sight ranges are
; Yellow's; text is Yellow's verbatim (vendor/pokeyellow/text/MtMoonB2F.asm),
; with Gen 1 `prompt` -> GSC `done`.
;
; Parties: docs/M2-MTMOON.md section 5's Rocket table mislabels which grunt gets
; which party. The truth is the object list plus vendor/pokeyellow/data/trainers/
; parties.asm `RocketData`: (15,22) is OPP_ROCKET 2 = SANDSHREW/RATTATA/ZUBAT
; L11, (29,11) is OPP_ROCKET 3 = ZUBAT/EKANS L12, (29,17) is OPP_ROCKET 1 =
; RATTATA/ZUBAT L13. All three battle texts follow the same mapping (Yellow's
; MtMoon3TrainerHeader0..2 -> its Rocket2/3/4 text blocks).
;
; MIGUEL is Yellow's SUPER_NERD 2, the fossil rival. Yellow force-runs his text
; when the player stands on (13,8) with neither fossil taken and MIGUEL unbeaten
; (MtMoonB2FScript_49d28). He stands at (12,8) facing RIGHT, so (13,8) is
; exactly the tile in front of him: a GSC sight range of 1 reproduces the
; trigger with no coord_event, and the trainer flag retires it after the battle.
;
; The fossils are SPRITE_FOSSIL objects (Yellow's still prop, ported 2026-09-17;
; they were SPRITE_ROCK before that). Taking one makes MIGUEL step into the
; *other* fossil's column, say his line and claim it,
; exactly as Yellow's MtMoonB2FMoveSuperNerdScript does: DOME taken -> he steps
; RIGHT from (12,8) to (13,8) (the HELIX column), HELIX taken -> he steps UP to
; (12,7) (the DOME column). Yellow picks the direction from the player's tile;
; those coordinate sets are exactly "the tiles you can take the DOME from" and
; "the tiles you can take the HELIX from", so keying off the fossil is the same
; behaviour and never walks him into the player.
;
; Both fossil objects are hidden as soon as *either* fossil is taken, so both
; flags are set together and the OBJECTS callback re-derives that on every map
; load. The flags say "this fossil object is gone", not "the player owns it" -
; a future Cinnabar lab must ask the bag (checkitem DOME_FOSSIL), which is what
; Yellow does too.
;
; JESSIE and JAMES (5h) are Yellow's scripted pair: objects at (9,3) and (9,4),
; both off the map until the player steps on (3,5), which is Yellow's trigger
; (MtMoonB2FScript_49e15). Yellow's choreography, reproduced beat for beat:
; play MUSIC_MEET_JESSIE_JAMES, show both, "Stop right there!", exclamation
; bubble over the player, force the player one step UP to (3,4), JESSIE walks
; six steps LEFT to (3,3) and faces DOWN, JAMES walks five steps LEFT to (4,4)
; and faces LEFT, the threat text, the battle, then the blast-off line, a fade
; to black, both objects gone, and the map music back.
;
; Yellow's movement bytes look like six/five DOWN steps ($06), but Gen 1's
; wCurSpriteMovement2 (LEFT, from the objects' STAY/LEFT declaration) overrides
; the per-step direction, so they really are LEFT steps - which is the only
; reading that fits the map: JESSIE ends directly above the player and JAMES
; directly to his right.
;
; Losing is a plain GSC white-out: the script never reaches the setevent, so
; re-entering the map re-arms the whole scene, exactly as Yellow's
; MtMoonB2FResetScripts does.
;
; MAPSETUP_RELOADMAP (what `reloadmapafterbattle` runs) does NOT re-run
; MAPCALLBACK_OBJECTS, so the pair stays on screen for the post-battle beat
; even though the callback would otherwise hide them.
;
; Flags: 5f added NO new events; 5h adds exactly one
; (EVENT_MT_MOON_B2F_JESSIE_JAMES_HIDDEN, the pair's visibility flag). Eleven dead Crystal flags were renamed in place
; (the list is positional, so renaming keeps every later index - and every
; savestate - valid): EVENT_BEAT_ROCKET_GRUNTM_12/20/21/22/23/26/27/30/31,
; EVENT_BEAT_SUPER_NERD_JAY and the misspelled EVENT_BEAY_SUPER_NERD_DAVE.
; Trainer slots are Crystal's unused GRUNTM_12/22/23/26 and SUPER_NERD 4 (JAY,
; renamed MIGUEL), all rewritten in place - no constants appended.
;
; Item substitution (operator decision, 2026-09-17): Yellow's TM01 MEGA PUNCH
; has no GSC equivalent, so (29,5) gives TM_DYNAMICPUNCH (GSC TM01).
; DOME_FOSSIL and HELIX_FOSSIL are new key items in Crystal's free ITEM_2D /
; ITEM_32 slots; they are inert until a Cinnabar lab exists.

MtMoonB2F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_OBJECTS, MtMoonB2FObjectsCallback

MtMoonB2FObjectsCallback:
; JESSIE and JAMES are never on the map at load time: before the cutscene they
; have not shown up yet, after it they have blasted off.
	setevent EVENT_MT_MOON_B2F_JESSIE_JAMES_HIDDEN

; Once either fossil is taken the other is MIGUEL's, so both objects go.
	checkevent EVENT_MT_MOON_B2F_DOME_FOSSIL
	iftrue .HideBoth
	checkevent EVENT_MT_MOON_B2F_HELIX_FOSSIL
	iftrue .HideBoth
	endcallback

.HideBoth:
	setevent EVENT_MT_MOON_B2F_DOME_FOSSIL
	setevent EVENT_MT_MOON_B2F_HELIX_FOSSIL
	endcallback

TrainerSuperNerdMiguel:
	trainer SUPER_NERD, MIGUEL, EVENT_BEAT_SUPER_NERD_MIGUEL, SuperNerdMiguelSeenText, SuperNerdMiguelBeatenText, 1, .Script

.Script:
	endifjustbattled
	opentext
	checkevent EVENT_MT_MOON_B2F_DOME_FOSSIL
	iftrue .TookAFossil
	writetext SuperNerdMiguelEachTakeOneText
	waitbutton
	closetext
	end

.TookAFossil:
	writetext SuperNerdMiguelPokemonLabText
	waitbutton
	closetext
	end

TrainerGruntM12:
	trainer GRUNTM, GRUNTM_12, EVENT_BEAT_MT_MOON_B2F_ROCKET_1, MtMoonB2FRocket1SeenText, MtMoonB2FRocket1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext MtMoonB2FRocket1AfterBattleText
	waitbutton
	closetext
	end

TrainerGruntM22:
	trainer GRUNTM, GRUNTM_22, EVENT_BEAT_MT_MOON_B2F_ROCKET_2, MtMoonB2FRocket2SeenText, MtMoonB2FRocket2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext MtMoonB2FRocket2AfterBattleText
	waitbutton
	closetext
	end

TrainerGruntM23:
	trainer GRUNTM, GRUNTM_23, EVENT_BEAT_MT_MOON_B2F_ROCKET_3, MtMoonB2FRocket3SeenText, MtMoonB2FRocket3BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext MtMoonB2FRocket3AfterBattleText
	waitbutton
	closetext
	end

; The (3,5) trigger. The coord_event's scene id is -1 so it matches whatever
; CheckScenes returns (this map has no scene scripts); the checkevent is what
; retires it.
MtMoonB2FJessieJamesScene:
	checkevent EVENT_BEAT_MT_MOON_B2F_JESSIE_JAMES
	iftrue .Done
	turnobject PLAYER, UP
	playmusic MUSIC_MEET_JESSIE_JAMES
	showemote EMOTE_SHOCK, PLAYER, 15
	opentext
	writetext MtMoonB2FJessieJamesStopText
	waitbutton
	closetext
	applymovement PLAYER, MtMoonB2FPlayerStepUp
	appear MTMOONB2F_JESSIE
	appear MTMOONB2F_JAMES
	applymovement MTMOONB2F_JESSIE, MtMoonB2FJessieApproach
	turnobject MTMOONB2F_JESSIE, DOWN
	applymovement MTMOONB2F_JAMES, MtMoonB2FJamesApproach
	turnobject MTMOONB2F_JAMES, LEFT
	opentext
	writetext MtMoonB2FJessieJamesSeenText
	waitbutton
	closetext
	winlosstext MtMoonB2FJessieJamesBeatenText, 0
	setlasttalked MTMOONB2F_JESSIE
	loadtrainer JESSIE_JAMES, JESSIE_JAMES_1
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	turnobject MTMOONB2F_JESSIE, DOWN
	turnobject MTMOONB2F_JAMES, DOWN
	playmusic MUSIC_MEET_JESSIE_JAMES
	opentext
	writetext MtMoonB2FJessieJamesAfterBattleText
	waitbutton
	closetext
	pause 30
	special FadeOutToBlack
	special ReloadSpritesNoPalettes
	disappear MTMOONB2F_JESSIE
	disappear MTMOONB2F_JAMES
	pause 15
	special FadeInFromBlack
	setevent EVENT_BEAT_MT_MOON_B2F_JESSIE_JAMES
	playmapmusic
	end

.Done:
	end

; Talking to either of them mid-scene is impossible (the scene never yields),
; but both objects need a script pointer.
MtMoonB2FJessieScript:
	jumptextfaceplayer MtMoonB2FJessieJamesSeenText

MtMoonB2FJamesScript:
	jumptextfaceplayer MtMoonB2FJessieJamesSeenText

; (3,5) -> (3,4). Yellow simulates a PAD_UP press here.
MtMoonB2FPlayerStepUp:
	step UP
	step_end

; JESSIE (9,3) -> (3,3), directly above the player.
MtMoonB2FJessieApproach:
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step_end

; JAMES (9,4) -> (4,4), directly right of the player.
MtMoonB2FJamesApproach:
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step_end

MtMoonB2FDomeFossil:
	opentext
	writetext MtMoonB2FDomeFossilText
	yesorno
	iffalse .Declined
	verbosegiveitem DOME_FOSSIL
	iffalse .Declined
	closetext
	setevent EVENT_MT_MOON_B2F_DOME_FOSSIL
	disappear MTMOONB2F_DOME_FOSSIL
	applymovement MTMOONB2F_MIGUEL, MtMoonB2FMiguelStepRight
	opentext
	writetext MtMoonB2FSuperNerdThenThisIsMineText
	waitbutton
	closetext
	setevent EVENT_MT_MOON_B2F_HELIX_FOSSIL
	disappear MTMOONB2F_HELIX_FOSSIL
	end

.Declined:
	closetext
	end

MtMoonB2FHelixFossil:
	opentext
	writetext MtMoonB2FHelixFossilText
	yesorno
	iffalse .Declined
	verbosegiveitem HELIX_FOSSIL
	iffalse .Declined
	closetext
	setevent EVENT_MT_MOON_B2F_HELIX_FOSSIL
	disappear MTMOONB2F_HELIX_FOSSIL
	applymovement MTMOONB2F_MIGUEL, MtMoonB2FMiguelStepUp
	opentext
	writetext MtMoonB2FSuperNerdThenThisIsMineText
	waitbutton
	closetext
	setevent EVENT_MT_MOON_B2F_DOME_FOSSIL
	disappear MTMOONB2F_DOME_FOSSIL
	end

.Declined:
	closetext
	end

MtMoonB2FMiguelStepRight:
	step RIGHT
	step_end

MtMoonB2FMiguelStepUp:
	step UP
	step_end

MtMoonB2FHPUp:
	itemball HP_UP

MtMoonB2FTMDynamicPunch:
	itemball TM_DYNAMICPUNCH

MtMoonB2FHiddenMoonStone:
	hiddenitem MOON_STONE, EVENT_MT_MOON_B2F_HIDDEN_MOON_STONE

MtMoonB2FHiddenEther:
	hiddenitem ETHER, EVENT_MT_MOON_B2F_HIDDEN_ETHER

SuperNerdMiguelSeenText:
	text "Hey, stop!"

	para "I found these"
	line "fossils! They're"
	cont "both mine!"
	done

SuperNerdMiguelBeatenText:
	text "OK!"
	line "I'll share!"
	done

SuperNerdMiguelEachTakeOneText:
	text "We'll each take"
	line "one!"
	cont "No being greedy!"
	done

SuperNerdMiguelPokemonLabText:
	text "Far away, on"
	line "CINNABAR ISLAND,"
	cont "there's a #MON"
	cont "LAB."

	para "They do research"
	line "on regenerating"
	cont "fossils."
	done

MtMoonB2FSuperNerdThenThisIsMineText:
	text "All right. Then"
	line "this is mine!"
	done

MtMoonB2FDomeFossilText:
	text "You want the"
	line "DOME FOSSIL?"
	done

MtMoonB2FHelixFossilText:
	text "You want the"
	line "HELIX FOSSIL?"
	done

MtMoonB2FRocket1SeenText:
	text "We, TEAM ROCKET,"
	line "are #MON"
	cont "gangsters!"
	done

MtMoonB2FRocket1BeatenText:
	text "I blew"
	line "it!"
	done

MtMoonB2FRocket1AfterBattleText:
	text "Darn it all! My"
	line "associates won't"
	cont "stand for this!"
	done

MtMoonB2FRocket2SeenText:
	text "We're pulling a"
	line "big job here!"
	cont "Get lost, kid!"
	done

MtMoonB2FRocket2BeatenText:
	text "So, you"
	line "are good."
	done

MtMoonB2FRocket2AfterBattleText:
	text "If you find a"
	line "fossil, give it"
	cont "to me and scram!"
	done

MtMoonB2FRocket3SeenText:
	text "Little kids"
	line "should leave"
	cont "grown-ups alone!"
	done

MtMoonB2FRocket3BeatenText:
	text "I'm"
	line "steamed!"
	done

MtMoonB2FRocket3AfterBattleText:
	text "#MON lived"
	line "here long before"
	cont "people came."
	done

MtMoonB2FJessieJamesStopText:
	text "Stop right there!"
	done

MtMoonB2FJessieJamesSeenText:
	text "That fossil is"
	line "TEAM ROCKET's!"

	para "Surrender now, or"
	line "prepare to fight!"
	done

MtMoonB2FJessieJamesBeatenText:
	text "A"
	line "brat beat us?"
	done

MtMoonB2FJessieJamesAfterBattleText:
	text "TEAM ROCKET, blast"
	line "off at the speed"
	cont "of light!"
	done

MtMoonB2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 25,  9, MT_MOON_B1F, 2
	warp_event 21, 17, MT_MOON_B1F, 5
	warp_event 15, 27, MT_MOON_B1F, 6
	warp_event  5,  7, MT_MOON_B1F, 7

	def_coord_events
	coord_event  3,  5, -1, MtMoonB2FJessieJamesScene

	def_bg_events
	bg_event 18, 12, BGEVENT_ITEM, MtMoonB2FHiddenMoonStone
	bg_event 33,  9, BGEVENT_ITEM, MtMoonB2FHiddenEther

	def_object_events
	object_event 12,  8, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 1, TrainerSuperNerdMiguel, -1
	object_event 15, 22, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_TRAINER, 4, TrainerGruntM12, -1
	object_event 29, 11, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_TRAINER, 4, TrainerGruntM22, -1
	object_event 29, 17, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, OBJECTTYPE_TRAINER, 4, TrainerGruntM23, -1
	object_event  9,  3, SPRITE_JESSIE, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, MtMoonB2FJessieScript, EVENT_MT_MOON_B2F_JESSIE_JAMES_HIDDEN
	object_event  9,  4, SPRITE_JAMES, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, MtMoonB2FJamesScript, EVENT_MT_MOON_B2F_JESSIE_JAMES_HIDDEN
	object_event 12,  6, SPRITE_FOSSIL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, MtMoonB2FDomeFossil, EVENT_MT_MOON_B2F_DOME_FOSSIL
	object_event 13,  6, SPRITE_FOSSIL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, MtMoonB2FHelixFossil, EVENT_MT_MOON_B2F_HELIX_FOSSIL
	object_event 25, 21, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, MtMoonB2FHPUp, EVENT_MT_MOON_B2F_HP_UP
	object_event 29,  5, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, MtMoonB2FTMDynamicPunch, EVENT_MT_MOON_B2F_TM_DYNAMICPUNCH
