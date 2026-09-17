	object_const_def
	const ROUTE24_ROCKET
	const ROUTE24_CAMPER1
	const ROUTE24_CAMPER2
	const ROUTE24_LASS1
	const ROUTE24_YOUNGSTER
	const ROUTE24_LASS2
	const ROUTE24_BUG_CATCHER
	const ROUTE24_TM_ZAP_CANNON
	const ROUTE24_DAMIAN

; Kanto hack: Yellow's Route 24, Nugget Bridge (docs/M3-CERULEAN.md 6h). The
; map was re-cut from Yellow in 6a; hack/maps/Route24.blk is a byte-for-byte
; block-id translation of vendor/pokeyellow/maps/Route24.blk, so every Yellow
; object coordinate transfers 1:1 with no offset (each tile re-checked on
; `scripts/mapgrid.py Route24`). Objects, facings, sight ranges and text are
; Yellow's (vendor/pokeyellow/data/maps/objects/Route24.asm,
; scripts/Route24.asm's Route24TrainerHeaders, text/Route24.asm).
;
; Yellow's anonymous trainers get GSC names and Crystal classes
; (docs/M3-CERULEAN.md 5): JR_TRAINER_M -> CAMPER, LASS -> LASS,
; YOUNGSTER -> YOUNGSTER, BUG_CATCHER -> BUG_CATCHER, ROCKET -> GRUNTM.
; Yellow draws its OPP_BUG_CATCHER with the youngster overworld sprite; we use
; SPRITE_BUG_CATCHER so the overworld sprite matches the battle class, as
; Route 3 and Viridian Forest do (docs/M2-MTMOON.md 5c, docs/M2-FOREST.md).
;
; The bridge runs north from Cerulean on columns x=10 and x=11 (rows 16-35).
; The five bridge trainers alternate sides and watch the opposite column at
; sight range 1, exactly as Yellow's headers 1-5 do; header 0 - the Jr.Trainer
; hiding in the west grass at (5,20) - keeps Yellow's range 4, facing up the
; grass strip. Encounter order walking north is BUG_CATCHER MERLE (No. 1),
; LASS PAULINE (2), YOUNGSTER VICTOR (3), LASS NORMA (4), CAMPER RUFUS (5).
;
; Item substitution (docs/M3-CERULEAN.md 0.8): Yellow's TM45 THUNDER WAVE is
; GSC TM07 ZAP_CANNON's slot in our table; the ball at (10,5) gives
; TM_ZAP_CANNON.
;
; DEVIATION from Yellow, deliberate: Yellow's Rocket recruiter can be fought
; exactly once and never disappears. His trigger array is gated on
; EVENT_GOT_NUGGET, and Yellow sets that flag *before* the battle, so losing
; to him permanently disarms the fight - afterwards he only ever prints the
; "top leader" line. We split Yellow's single flag in two:
; EVENT_GOT_NUGGET_ON_ROUTE_24 records the prize (so the NUGGET is never given
; twice) and EVENT_BEAT_ROUTE_24_ROCKET records the win. A real loss leaves
; the beat flag clear, so stepping on (10,15) or talking to him re-arms the
; battle, matching the Cerulean Rocket thief (6c/6d). He is NOT disappeared
; on the win: Yellow keeps him standing at the bridge head and gives him the
; "you could become a top leader in TEAM ROCKET" line, which would otherwise
; be dead text.
Route24_MapScripts:
	def_scene_scripts

	def_callbacks

; Walking onto the head of the bridge. Yellow's trigger tile is (10,15), the
; only walkable tile the player can reach coming north up the bridge - the
; recruiter's own body blocks (11,15).
Route24RocketTrigger:
	checkevent EVENT_BEAT_ROUTE_24_ROCKET
	iftrue .Done
	jump Route24RocketConfrontation

.Done:
	end

Route24RocketScript:
	faceplayer
	checkevent EVENT_BEAT_ROUTE_24_ROCKET
	iftrue .TopLeader
	jump Route24RocketConfrontation

.TopLeader:
	opentext
	writetext Route24RocketTopLeaderText
	waitbutton
	closetext
	end

Route24RocketConfrontation:
	checkevent EVENT_GOT_NUGGET_ON_ROUTE_24
	iftrue .Fight
	opentext
	writetext Route24RocketYouBeatOurContestText
	promptbutton
	verbosegiveitem NUGGET
	iffalse .NoRoom
	setevent EVENT_GOT_NUGGET_ON_ROUTE_24
	jump .Pitch

.Fight:
	opentext
.Pitch:
	writetext Route24RocketJoinTeamRocketText
	waitbutton
	closetext
	winlosstext Route24RocketDefeatedText, 0
	setlasttalked ROUTE24_ROCKET
	loadtrainer GRUNTM, GRUNTM_27
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_ROUTE_24_ROCKET
	opentext
	writetext Route24RocketTopLeaderText
	waitbutton
	closetext
	end

.NoRoom:
	writetext Route24RocketNoRoomText
	waitbutton
	closetext
	end

TrainerCamperAnsel:
	trainer CAMPER, ANSEL, EVENT_BEAT_CAMPER_ANSEL, CamperAnselSeenText, CamperAnselBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext CamperAnselAfterBattleText
	waitbutton
	closetext
	end

TrainerCamperRufus:
	trainer CAMPER, RUFUS, EVENT_BEAT_CAMPER_RUFUS, CamperRufusSeenText, CamperRufusBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext CamperRufusAfterBattleText
	waitbutton
	closetext
	end

TrainerLassNorma:
	trainer LASS, NORMA, EVENT_BEAT_LASS_NORMA, LassNormaSeenText, LassNormaBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassNormaAfterBattleText
	waitbutton
	closetext
	end

TrainerYoungsterVictor:
	trainer YOUNGSTER, VICTOR, EVENT_BEAT_YOUNGSTER_VICTOR, YoungsterVictorSeenText, YoungsterVictorBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext YoungsterVictorAfterBattleText
	waitbutton
	closetext
	end

TrainerLassPauline:
	trainer LASS, PAULINE, EVENT_BEAT_LASS_PAULINE, LassPaulineSeenText, LassPaulineBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassPaulineAfterBattleText
	waitbutton
	closetext
	end

TrainerBugCatcherMerle:
	trainer BUG_CATCHER, MERLE, EVENT_BEAT_BUG_CATCHER_MERLE, BugCatcherMerleSeenText, BugCatcherMerleBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BugCatcherMerleAfterBattleText
	waitbutton
	closetext
	end

Route24TMZapCannon:
	itemball TM_ZAP_CANNON

; Yellow's GivePokemon would have boxed the CHARMANDER; like Melanie's
; BULBASAUR (docs/M3-CERULEAN.md 6g) and the Mt. Moon MAGIKARP salesman
; (docs/M2-MTMOON.md 5g) we check the party first and DAMIAN keeps it.
Route24DamianScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_CHARMANDER_FROM_DAMIAN
	iftrue .AlreadyGave
	writetext Route24DamianOfferText
	yesorno
	iffalse .Refused
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .PartyFull
	writetext Route24DamianReceivedCharmanderText
	playsound SFX_CAUGHT_MON
	waitsfx
	givepoke CHARMANDER, 10
	setevent EVENT_GOT_CHARMANDER_FROM_DAMIAN
	writetext Route24DamianTakeCareText
	waitbutton
	closetext
	end

.Refused:
	writetext Route24DamianReleaseItText
	waitbutton
	closetext
	end

.PartyFull:
	writetext Route24DamianPartyFullText
	waitbutton
	closetext
	end

.AlreadyGave:
	writetext Route24DamianAfterText
	waitbutton
	closetext
	end

Route24RocketYouBeatOurContestText:
	text "Congratulations!"
	line "You beat our 5"
	cont "contest trainers!"

	para "You just earned a"
	line "fabulous prize!"
	done

Route24RocketNoRoomText:
	text "You don't have"
	line "any room!"
	done

Route24RocketJoinTeamRocketText:
	text "By the way, would"
	line "you like to join"
	cont "TEAM ROCKET?"

	para "We're a group"
	line "dedicated to evil"
	cont "using #MON!"

	para "Want to join?"

	para "Are you sure?"

	para "Come on, join us!"

	para "I'm telling you"
	line "to join!"

	para "OK, you need"
	line "convincing!"

	para "I'll make you an"
	line "offer you can't"
	cont "refuse!"
	done

Route24RocketDefeatedText:
	text "Arrgh!"
	line "You are good!"
	done

Route24RocketTopLeaderText:
	text "With your ability,"
	line "you could become"
	cont "a top leader in"
	cont "TEAM ROCKET!"
	done

CamperAnselSeenText:
	text "I saw your feat"
	line "from the grass!"
	done

CamperAnselBeatenText:
	text "I"
	line "thought not!"
	done

CamperAnselAfterBattleText:
	text "I hid because the"
	line "people on the"
	cont "bridge scared me!"
	done

CamperRufusSeenText:
	text "OK! I'm No. 5!"
	line "I'll stomp you!"
	done

CamperRufusBeatenText:
	text "Whoa!"
	line "Too much!"
	done

CamperRufusAfterBattleText:
	text "I did my best, I"
	line "have no regrets!"
	done

LassNormaSeenText:
	text "I'm No. 4!"
	line "Getting tired?"
	done

LassNormaBeatenText:
	text "I lost"
	line "too!"
	done

LassNormaAfterBattleText:
	text "I did my best, so"
	line "I've no regrets!"
	done

YoungsterVictorSeenText:
	text "Here's No. 3!"
	line "I won't be easy!"
	done

YoungsterVictorBeatenText:
	text "Ow!"
	line "Stomped flat!"
	done

YoungsterVictorAfterBattleText:
	text "I did my best, I"
	line "have no regrets!"
	done

LassPaulineSeenText:
	text "I'm second!"
	line "Now it's serious!"
	done

LassPaulineBeatenText:
	text "How could I"
	line "lose?"
	done

LassPaulineAfterBattleText:
	text "I did my best, I"
	line "have no regrets!"
	done

BugCatcherMerleSeenText:
	text "This is NUGGET"
	line "BRIDGE! Beat us 5"
	cont "trainers and win"
	cont "a fabulous prize!"

	para "Think you got"
	line "what it takes?"
	done

BugCatcherMerleBeatenText:
	text "Whoo!"
	line "Good stuff!"
	done

BugCatcherMerleAfterBattleText:
	text "I did my best, I"
	line "have no regrets!"
	done

Route24DamianOfferText:
	text "I'm not good at"
	line "raising #MON."

	para "I should release"
	line "my CHARMANDER"
	cont "because I haven't"
	cont "raised it well…"

	para "If you promise me"
	line "you'll care for"
	cont "it, it's yours."
	done

; Yellow's GivePokemon prints this line itself; GSC's givepoke does not.
Route24DamianReceivedCharmanderText:
	text "<PLAYER> received"
	line "CHARMANDER!"
	done

Route24DamianTakeCareText:
	text "Take good care of"
	line "my CHARMANDER!"
	done

Route24DamianReleaseItText:
	text "Oh… I'd better"
	line "release it then."
	done

Route24DamianAfterText:
	text "How's CHARMANDER"
	line "doing?"
	done

; Yellow has no line for this: its GivePokemon would have boxed the CHARMANDER.
Route24DamianPartyFullText:
	text "Oh! You're already"
	line "carrying six"
	cont "#MON."

	para "Come back when you"
	line "have room for"
	cont "CHARMANDER."
	done

Route24_MapEvents:
	db 0, 0 ; filler

	def_warp_events

	def_coord_events
	coord_event 10, 15, -1, Route24RocketTrigger

	def_bg_events

	def_object_events
	object_event 11, 15, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route24RocketScript, -1
	object_event  5, 20, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 4, TrainerCamperAnsel, -1
	object_event 11, 19, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 1, TrainerCamperRufus, -1
	object_event 10, 22, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 1, TrainerLassNorma, -1
	object_event 11, 25, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 1, TrainerYoungsterVictor, -1
	object_event 10, 28, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 1, TrainerLassPauline, -1
	object_event 11, 31, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 1, TrainerBugCatcherMerle, -1
	object_event 10,  5, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route24TMZapCannon, EVENT_ROUTE_24_TM_ZAP_CANNON
	object_event  6,  5, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route24DamianScript, -1
