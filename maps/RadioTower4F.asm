	object_const_def
	const RADIOTOWER4F_FISHER
	const RADIOTOWER4F_TEACHER
	const RADIOTOWER4F_GROWLITHE
	const RADIOTOWER4F_ROCKET1
	const RADIOTOWER4F_JESSIE
	const RADIOTOWER4F_ROCKET_GIRL
	const RADIOTOWER4F_SCIENTIST
	const RADIOTOWER4F_JAMES

; Kanto hack (M11 14g, D149): JESSIE & JAMES take the fight that was Crystal's
; EXECUTIVEM_2 -- the takeover's first executive, who stood on (14,1) facing
; LEFT with a sight range of 2, guarding the right-hand stairs to 5F.  JESSIE
; keeps his tile and facing, JAMES stands behind her on (15,1).  His sight
; line is two coord_events, (13,1) and (12,1): from the far tile both step
; one LEFT to meet the player, as a sight trainer would.  The battle is
; Yellow-style (MUSIC_MEET_JESSIE_JAMES, JESSIE_JAMES_6) and they leave with
; Yellow's fade to black.  EVENT_BEAT_ROCKET_EXECUTIVEM_2 is still set by the
; win (nothing else reads it).
;
; The executive hid on EVENT_RADIO_TOWER_ROCKET_TAKEOVER, which every takeover
; Rocket shares -- a `disappear` would set it and clear the whole tower -- so
; the pair have their own hide flag, re-derived on every load: shown only
; while the takeover is on and the fight is not won.  The coord_events read
; the same flag, so they are dead before and after the takeover.

RadioTower4F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_OBJECTS, RadioTower4FJessieJamesCallback

RadioTower4FJessieJamesCallback:
	checkevent EVENT_RADIO_TOWER_ROCKET_TAKEOVER
	iftrue .Hide
	checkevent EVENT_BEAT_ROCKET_EXECUTIVEM_2
	iftrue .Hide
	clearevent EVENT_RADIO_TOWER_4F_JESSIE_JAMES_HIDDEN
	endcallback

.Hide:
	setevent EVENT_RADIO_TOWER_4F_JESSIE_JAMES_HIDDEN
	endcallback

; the far end of the old sight line: they step LEFT to meet the player
RadioTower4FJessieJamesSceneFar:
	checkevent EVENT_RADIO_TOWER_4F_JESSIE_JAMES_HIDDEN
	iftrue .Done
	scall RadioTower4FJessieJamesStop
	applymovement RADIOTOWER4F_JESSIE, RadioTower4FJessieJamesStepLeftMovement
	applymovement RADIOTOWER4F_JAMES, RadioTower4FJessieJamesStepLeftMovement
	sjump RadioTower4FJessieJamesBattle

.Done:
	end

; right in front of JESSIE
RadioTower4FJessieJamesSceneNear:
	checkevent EVENT_RADIO_TOWER_4F_JESSIE_JAMES_HIDDEN
	iftrue .Done
	scall RadioTower4FJessieJamesStop
	sjump RadioTower4FJessieJamesBattle

.Done:
	end

RadioTower4FJessieJamesStop:
	turnobject PLAYER, RIGHT
	playmusic MUSIC_MEET_JESSIE_JAMES
	showemote EMOTE_SHOCK, RADIOTOWER4F_JESSIE, 15
	opentext
	writetext RadioTower4FJessieJamesStopText
	waitbutton
	closetext
	end

RadioTower4FJessieJamesBattle:
	opentext
	writetext RadioTower4FJessieJamesSeenText
	waitbutton
	closetext
	winlosstext RadioTower4FJessieJamesBeatenText, 0
	setlasttalked RADIOTOWER4F_JESSIE
	loadtrainer JESSIE_JAMES, JESSIE_JAMES_6
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	setevent EVENT_BEAT_ROCKET_EXECUTIVEM_2
	turnobject RADIOTOWER4F_JESSIE, DOWN
	turnobject RADIOTOWER4F_JAMES, DOWN
	playmusic MUSIC_MEET_JESSIE_JAMES
	opentext
	writetext RadioTower4FJessieJamesAfterBattleText
	waitbutton
	closetext
	pause 30
	special FadeOutToBlack
	special ReloadSpritesNoPalettes
	disappear RADIOTOWER4F_JESSIE
	disappear RADIOTOWER4F_JAMES
	pause 15
	special FadeInFromBlack
	playmapmusic
	end

RadioTower4FJessieJamesStepLeftMovement:
	step LEFT
	step_end

RadioTower4FFisherScript:
	jumptextfaceplayer RadioTower4FFisherText

RadioTower4FDJMaryScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_PINK_BOW_FROM_MARY
	iftrue .GotPinkBow
	checkevent EVENT_CLEARED_RADIO_TOWER
	iftrue .ClearedRockets
	writetext RadioTower4FDJMaryText
	waitbutton
	closetext
	end

.ClearedRockets:
	writetext RadioTower4FDJMaryText_ClearedRockets
	promptbutton
	verbosegiveitem PINK_BOW
	iffalse .NoRoom
	writetext RadioTower4FDJMaryText_GivePinkBow
	waitbutton
	closetext
	setevent EVENT_GOT_PINK_BOW_FROM_MARY
	end

.GotPinkBow:
	writetext RadioTower4FDJMaryText_After
	waitbutton
.NoRoom:
	closetext
	end

RadioTowerMeowth:
	opentext
	writetext RadioTowerMeowthText
	cry MEOWTH
	waitbutton
	closetext
	end

TrainerGruntM10:
	trainer GRUNTM, GRUNTM_10, EVENT_BEAT_ROCKET_GRUNTM_10, GruntM10SeenText, GruntM10BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext GruntM10AfterBattleText
	waitbutton
	closetext
	end

TrainerGruntF4:
	trainer GRUNTF, GRUNTF_4, EVENT_BEAT_ROCKET_GRUNTF_4, GruntF4SeenText, GruntF4BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext GruntF4AfterBattleText
	waitbutton
	closetext
	end

TrainerScientistRich:
	trainer SCIENTIST, RICH, EVENT_BEAT_SCIENTIST_RICH, ScientistRichSeenText, ScientistRichBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext ScientistRichAfterBattleText
	waitbutton
	closetext
	end

RadioTower4FProductionSign:
	jumptext RadioTower4FProductionSignText

RadioTower4FStudio2Sign:
	jumptext RadioTower4FStudio2SignText

RadioTower4FFisherText:
	text "I listened to the"
	line "radio while I was"
	cont "at the RUINS."

	para "I heard a strange"
	line "broadcast there."
	done

RadioTower4FDJMaryText:
	text "MARY: Why? Why do"
	line "I have to suffer"
	cont "through this?"

	para "MEOWTH, help me!"
	done

RadioTower4FDJMaryText_ClearedRockets:
	text "MARY: Oh! You're"
	line "my little savior!"

	para "Will you take this"
	line "as my thanks?"
	done

RadioTower4FDJMaryText_GivePinkBow:
	text "MARY: It's just"
	line "right for #MON"

	para "that know normal-"
	line "type moves."
	done

RadioTower4FDJMaryText_After:
	text "MARY: Please tune"
	line "into me on PROF."

	para "OAK'S #MON TALK"
	line "show."
	done

RadioTowerMeowthText:
	text "MEOWTH: Meowth…"
	done

GruntM10SeenText:
	text "You plan to rescue"
	line "the DIRECTOR?"

	para "That won't be pos-"
	line "sible because I'm"
	cont "going to beat you!"
	done

GruntM10BeatenText:
	text "No! Unbelievable!"
	done

GruntM10AfterBattleText:
	text "I don't believe"
	line "it! I was beaten!"
	done

RadioTower4FJessieJamesStopText:
	text "Stop right there!"
	done

RadioTower4FJessieJamesSeenText:
	text "You?! Here too?"

	para "We're taking over"
	line "the airwaves to"
	cont "call our BOSS"
	cont "home!"

	para "Surrender now, or"
	line "prepare to fight!"
	done

RadioTower4FJessieJamesBeatenText:
	text "Like"
	line "always…"
	done

RadioTower4FJessieJamesAfterBattleText:
	text "TEAM ROCKET, blast"
	line "off at the speed"
	cont "of light!"

	para "Again…"
	done

GruntF4SeenText:
	text "Don't I think"
	line "#MON are cute?"

	para "I'll think my"
	line "#MON are cute--"

	para "after they beat"
	line "yours!"
	done

GruntF4BeatenText:
	text "Oh, no! They're so"
	line "useless!"
	done

GruntF4AfterBattleText:
	text "I love my"
	line "beautiful self!"

	para "Who cares about"
	line "#MON?"
	done

ScientistRichSeenText:
	text "Most excellent."

	para "This RADIO TOWER"
	line "will fulfill our"
	cont "grand design."
	done

ScientistRichBeatenText:
	text "Hmmm…"

	para "All grand plans"
	line "come with snags."
	done

ScientistRichAfterBattleText:
	text "Do you honestly"
	line "believe you can"
	cont "stop TEAM ROCKET?"
	done

RadioTower4FProductionSignText:
	text "4F PRODUCTION"
	done

RadioTower4FStudio2SignText:
	text "4F STUDIO 2"
	done

RadioTower4F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  0,  0, RADIO_TOWER_5F, 1
	warp_event  9,  0, RADIO_TOWER_3F, 2
	warp_event 12,  0, RADIO_TOWER_5F, 2
	warp_event 17,  0, RADIO_TOWER_3F, 3

	def_coord_events
	coord_event 13,  1, -1, RadioTower4FJessieJamesSceneNear
	coord_event 12,  1, -1, RadioTower4FJessieJamesSceneFar

	def_bg_events
	bg_event  7,  0, BGEVENT_READ, RadioTower4FProductionSign
	bg_event 15,  0, BGEVENT_READ, RadioTower4FStudio2Sign

	def_object_events
	object_event  6,  4, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, RadioTower4FFisherScript, EVENT_RADIO_TOWER_CIVILIANS_AFTER
	object_event 14,  6, SPRITE_TEACHER, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, RadioTower4FDJMaryScript, -1
	object_event 12,  7, SPRITE_GROWLITHE, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, RadioTowerMeowth, -1
	object_event  5,  6, SPRITE_ROCKET, SPRITEMOVEDATA_SPINCLOCKWISE, 0, 0, -1, -1, 0, OBJECTTYPE_TRAINER, 3, TrainerGruntM10, EVENT_RADIO_TOWER_ROCKET_TAKEOVER
	object_event 14,  1, SPRITE_JESSIE, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_RADIO_TOWER_4F_JESSIE_JAMES_HIDDEN
	object_event 12,  4, SPRITE_ROCKET_GIRL, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 1, TrainerGruntF4, EVENT_RADIO_TOWER_ROCKET_TAKEOVER
	object_event  4,  2, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 4, TrainerScientistRich, EVENT_RADIO_TOWER_ROCKET_TAKEOVER
	object_event 15,  1, SPRITE_JAMES, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_RADIO_TOWER_4F_JESSIE_JAMES_HIDDEN
