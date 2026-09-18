	object_const_def
	const VIRIDIANCITY_GRAMPS1
	const VIRIDIANCITY_GRAMPS2
	const VIRIDIANCITY_FISHER
	const VIRIDIANCITY_YOUNGSTER
; Kanto hack (L1, docs/AUDIT-KANTO-LEFTOVERS.md 4.7): Yellow's two missing
; VIRIDIAN CITY NPCs -- the girl who explains the blocked road north and the
; second youngster with the CATERPIE/WEEDLE speech.
	const VIRIDIANCITY_GIRL
	const VIRIDIANCITY_YOUNGSTER2
; Kanto hack (P1, docs/M2-CATCH.md): Yellow's other two old-man objects.  Yellow
; keeps THREE gamblers on this map -- the one lying across (18,9), the awake
; OLD_MAN_2 who stands on the same tile after the POKeDEX, and OLD_MAN_1 who
; paces by the nook at (17,5) once he is back from the MART -- and toggles them
; with HideObject/ShowObject.  APPENDED so the six existing indices don't move.
	const VIRIDIANCITY_OLD_MAN_ASLEEP
	const VIRIDIANCITY_OLD_MAN_WANDER

ViridianCity_MapScripts:
	def_scene_scripts
	scene_script ViridianCityGrampsBlockScene, SCENE_VIRIDIANCITY_GRAMPS_BLOCK
	scene_script ViridianCityNoopScene,        SCENE_VIRIDIANCITY_NOOP
; V1: Yellow's third VIRIDIAN CITY script state, SCRIPT_VIRIDIANCITY_AFTER_POKEDEX
; (vendor/pokeyellow/scripts/ViridianCity.asm): the old man is awake and waiting
; on the same tile, and stepping in front of him starts the catch demo.
; APPENDED so SCENE_VIRIDIANCITY_NOOP keeps id 1 for the existing savestates.
	scene_script ViridianCityOldManWaitingScene, SCENE_VIRIDIANCITY_OLD_MAN_WAITING

	def_callbacks
	callback MAPCALLBACK_NEWMAP, ViridianCityFlypointCallback
	callback MAPCALLBACK_OBJECTS, ViridianCityGrampsCallback

ViridianCityGrampsBlockScene:
ViridianCityNoopScene:
ViridianCityOldManWaitingScene:
	end

; Yellow's sleepy old man (docs/M2-PARCEL.md, V1): until OAK'S PARCEL is
; delivered he lies across (18,9) -- the middle of the three-tile road north,
; with the girl who apologises for him beside him at (17,9).  (19,9) is the only
; gap in that row, and stepping onto it is Yellow's trigger
; (ViridianCityCheckSleepingOldMan: y == 9 && x == 19): his text, then the player
; is forced one step back DOWN.  The x=18 and x=17 approaches are plain body
; collisions with no text, in Yellow and here.  He never turns -- he is asleep.
ViridianCityGrampsBlock:
	opentext
	writetext ViridianCityGrampsPrivatePropertyText
	waitbutton
	closetext
	applymovement PLAYER, ViridianCity_PlayerStepBackMovement
	end

ViridianCity_PlayerStepBackMovement:
	step DOWN
	step_end

; P1: talking to the sleeper himself (from (18,10) below, or (19,9) with A after
; the trigger has already fired).  He is asleep, so no faceplayer -- his sheet is
; a single 16x16 frame anyway -- and he says the same sleepy line.
ViridianCityAsleepGramps:
	opentext
	writetext ViridianCityGrampsPrivatePropertyText
	waitbutton
	closetext
	end

ViridianCityFlypointCallback:
	setflag ENGINE_FLYPOINT_VIRIDIAN
	endcallback

; P1: Yellow's three-object old man, driven the way KurtsHouse drives Kurt.
; Three states, one visible object each:
;   before the POKeDEX   VIRIDIANCITY_OLD_MAN_ASLEEP lies across (18,9)
;                        (hidden by EVENT_OAK_GOT_PARCEL, which OaksLab sets at
;                        exactly Yellow's TOGGLE_LYING_OLD_MAN moment);
;   after the POKeDEX    VIRIDIANCITY_GRAMPS1 stands awake on (18,9) and does
;                        the coffee/catch demo (hidden by
;                        EVENT_VIRIDIAN_OLD_MAN_OFF_ROAD, owned here);
;   after the MART trip  VIRIDIANCITY_OLD_MAN_WANDER paces at (17,5) with the
;                        repeat offer (hidden by
;                        EVENT_VIRIDIAN_OLD_MAN_GONE_TO_MART, which the demo
;                        leaves set and ViridianMart's NEWMAP callback clears).
; The sleeper needs no handling here -- his flag is set by OaksLab and never
; cleared.  Before the demo we keep the wanderer's flag set; from the demo on we
; never touch it again, so the MART visit alone brings him back.
ViridianCityGrampsCallback:
	checkevent EVENT_VIRIDIAN_OLD_MAN_CATCH_DEMO
	iftrue .AfterDemo
	disappear VIRIDIANCITY_OLD_MAN_WANDER ; sets EVENT_VIRIDIAN_OLD_MAN_GONE_TO_MART
	checkevent EVENT_OAK_GOT_PARCEL
	iffalse .StillAsleep
	appear VIRIDIANCITY_GRAMPS1
	endcallback

.StillAsleep:
	disappear VIRIDIANCITY_GRAMPS1
	endcallback

.AfterDemo:
	disappear VIRIDIANCITY_GRAMPS1
	endcallback

; Yellow's old man: grumpy until OAK'S PARCEL is delivered, then he shows
; the player how to catch #MON as an apology (and fumbles it), then offers
; repeat demonstrations from beside the road.
ViridianCityCoffeeGramps:
	faceplayer
	opentext
	checkevent EVENT_VIRIDIAN_OLD_MAN_CATCH_DEMO
	iftrue .ShowYouAgain
	checkevent EVENT_OAK_GOT_PARCEL
	iftrue ViridianCityGrampsCatchDemo
	writetext ViridianCityGrampsPrivatePropertyText
	waitbutton
	closetext
	end

.ShowYouAgain:
	writetext ViridianCityGrampsShowYouAgainText
	yesorno
	iffalse .NotGoodEnough
	readvar VAR_BOXSPACE
	ifequal 0, .BoxFull
	writetext ViridianCityGrampsWatchCloselyText
	waitbutton
	closetext
	loadwildmon RATTATA, 5
	setval FALSE ; he catches it
	special OldManCatchTutorial
	reloadmap
	faceplayer
	opentext
	writetext ViridianCityGrampsWeakenTheTargetText
	waitbutton
	closetext
	end

.NotGoodEnough:
	writetext ViridianCityGrampsNotGoodEnoughText
	waitbutton
	closetext
	end

.BoxFull:
	writetext ViridianCityGrampsBoxFullText
	waitbutton
	closetext
	end

; V1: Yellow's ViridianCityCheckWaitingOldMan.  Once OAK'S PARCEL is delivered
; (OaksLab setmapscene) the old man is awake on the same tile and the demo starts
; by itself when the player steps onto (19,9) -- no A press: he turns to face the
; player, the player turns to face him, and he offers the demonstration.
ViridianCityOldManWaitingTrigger:
	turnobject VIRIDIANCITY_GRAMPS1, RIGHT
	turnobject PLAYER, LEFT
	opentext
	sjump ViridianCityGrampsCatchDemo

; The catch demo itself, shared by the (19,9) trigger above and by talking to him
; from below.  Entered with text open.
ViridianCityGrampsCatchDemo:
	writetext ViridianCityGrampsHadMyCoffeeText
	waitbutton
	closetext
	loadwildmon RATTATA, 5
	setval TRUE ; the ball breaks free
	special OldManCatchTutorial
	reloadmap
	readvar VAR_XCOORD
	ifequal 19, .FacePlayerEast
	turnobject VIRIDIANCITY_GRAMPS1, DOWN
	sjump .LosingMyTouch
.FacePlayerEast:
	turnobject VIRIDIANCITY_GRAMPS1, RIGHT
.LosingMyTouch:
	opentext
	writetext ViridianCityGrampsLosingMyTouchText
	waitbutton
	closetext
	; L1 (docs/AUDIT-KANTO-LEFTOVERS.md 4.3) / V1: Yellow's post-demo beat.  He
	; walks six tiles DOWN the road towards the MART and is gone until he has
	; restocked (ViridianMart's NEWMAP callback clears the flag again); the OBJECTS
	; callback above then stands him beside the road at (17,5), Yellow's own tile.
	; Yellow picks between two movements on the player's X
	; (vendor/pokeyellow/scripts/ViridianCity.asm:219-243) and we now test the same
	; `cp 19`: straight down the road when the player is east of him on (19,9),
	; one step RIGHT first when they are below him in his own column.
	readvar VAR_XCOORD
	ifequal 19, .OffToMart
	applymovement VIRIDIANCITY_GRAMPS1, ViridianCity_GrampsStepAsideMovement
	sjump .GoneToMart
.OffToMart:
	applymovement VIRIDIANCITY_GRAMPS1, ViridianCity_GrampsOffToMartMovement
.GoneToMart:
	disappear VIRIDIANCITY_GRAMPS1 ; sets EVENT_VIRIDIAN_OLD_MAN_OFF_ROAD; GONE_TO_MART is already set by the callback
	setevent EVENT_VIRIDIAN_OLD_MAN_CATCH_DEMO
	setscene SCENE_VIRIDIANCITY_NOOP
	end

; Yellow's ViridianCityOldManMovementData2, verbatim: six steps DOWN.  Column 18
; is walkable on rows 10-15 (scripts/mapgrid.py ViridianCity), so his walk-off
; runs (18,9) -> (18,15), the same six tiles Yellow's does.
ViridianCity_GrampsOffToMartMovement:
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step_end

; Yellow's ViridianCityOldManMovementData1, for when the player is below him in
; his own column.  Data1 is a single NPC_MOVEMENT_RIGHT with NO $ff terminator,
; so it falls through into Data2's six DOWN: verified in the Yellow harness
; (V1 phase C), (18,9) -> (19,9) -> (19,15).
ViridianCity_GrampsStepAsideMovement:
	step RIGHT
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step_end

; L1 (4.6): Yellow's gambler by the gym.  He is the hint that the GYM is shut,
; so he is gated on the same seven badges as the door, not on Crystal's
; EVENT_BLUE_IN_CINNABAR (which nothing in Kanto sets).
ViridianCityGrampsNearGym:
	faceplayer
	opentext
	readvar VAR_BADGES
	ifless 7, .AlwaysClosed
	writetext ViridianCityGrampsNearGymLeaderReturnedText
	waitbutton
	closetext
	end

.AlwaysClosed:
	writetext ViridianCityGrampsNearGymAlwaysClosedText
	waitbutton
	closetext
	end

; L1 (4.5, R1): Yellow locks VIRIDIAN GYM until the seventh badge
; (vendor/pokeyellow/scripts/ViridianCity.asm:31-60).  Kanto is played first, so
; wJohtoBadges is still 0 and VAR_BADGES is the Kanto count.
ViridianGymLockedDoor:
	readvar VAR_BADGES
	ifless 7, .Locked
	end

.Locked:
	opentext
	writetext ViridianGymLockedText
	waitbutton
	closetext
	applymovement PLAYER, ViridianCity_PlayerStepWestMovement
	end

; Yellow pushes the player one tile DOWN (a simulated joypad press).  Our door
; tile (32,8) is the lip of a ledge -- (32,9) is the cliff face and a scripted
; `step` cannot hop a ledge -- so the nudge is one tile west along the same lip.
; Same visible result: the player is off the door tile.
ViridianCity_PlayerStepWestMovement:
	step LEFT
	step_end

ViridianCityDreamEaterFisher:
	faceplayer
	opentext
	checkevent EVENT_GOT_TM42_DREAM_EATER
	iftrue .GotDreamEater
	writetext ViridianCityDreamEaterFisherText
	promptbutton
	verbosegiveitem TM_DREAM_EATER
	iffalse .NoRoomForDreamEater
	setevent EVENT_GOT_TM42_DREAM_EATER
.GotDreamEater:
	writetext ViridianCityDreamEaterFisherGotDreamEaterText
	waitbutton
.NoRoomForDreamEater:
	closetext
	end

ViridianCityYoungsterScript:
	jumptextfaceplayer ViridianCityYoungsterText

ViridianCitySign:
	jumptext ViridianCitySignText

ViridianGymSign:
	jumptext ViridianGymSignText

ViridianCityTrainerTips1:
	jumptext ViridianCityTrainerTips1Text

ViridianCityTrainerTips2:
	jumptext ViridianCityTrainerTips2Text

; L1 (4.7): Yellow's GIRL beside the blocked road.  Crystal has no SPRITE_GIRL;
; SPRITE_TWIN is its little-girl overworld sprite, so she uses that.
ViridianCityGirlScript:
	faceplayer
	opentext
	checkflag ENGINE_POKEDEX
	iftrue .WhenIGoShop
	writetext ViridianCityGirlCoffeeText
	waitbutton
	closetext
	end

.WhenIGoShop:
	writetext ViridianCityGirlWhenIGoShopText
	waitbutton
	closetext
	end

; L1 (4.7): Yellow's second youngster and his yes/no caterpillar speech
; (vendor/pokeyellow/scripts/ViridianCity_2.asm:30-41).
ViridianCityYoungster2Script:
	faceplayer
	opentext
	writetext ViridianCityYoungster2AskText
	yesorno
	iffalse .OkThen
	writetext ViridianCityYoungster2CaterpieText
	waitbutton
	closetext
	end

.OkThen:
	writetext ViridianCityYoungster2OkThenText
	waitbutton
	closetext
	end

ViridianCityPokecenterSign:
	jumpstd PokecenterSignScript

ViridianCityMartSign:
	jumpstd MartSignScript

ViridianCityGrampsPrivatePropertyText:
	text "You can't go"
	line "through here!"

	para "This is private"
	line "property!"
	done

ViridianCityGrampsHadMyCoffeeText:
	text "Ahh, I've had my"
	line "coffee now and I"
	cont "feel great!"

	para "Sure, you can go"
	line "through!"

	para "I'm sorry I was"
	line "so rude to you!"

	para "I see you're using"
	line "a #DEX."

	para "I'll show you how"
	line "to catch #MON"
	cont "as my apology."
	done

ViridianCityGrampsLosingMyTouchText:
	text "That didn't work!"
	line "I must be losing"
	cont "my touch."

	para "I've run out of"
	line "# BALLs too."

	para "I have to get some"
	line "at #MON MART."
	done

ViridianCityGrampsShowYouAgainText:
	text "Hmm? You want me"
	line "to show you how"
	cont "to catch #MON"
	cont "again?"
	done

ViridianCityGrampsWatchCloselyText:
	text "Dandy! Watch what"
	line "I do closely now!"
	done

ViridianCityGrampsWeakenTheTargetText:
	text "First, you need"
	line "to weaken the"
	cont "target #MON."
	done

ViridianCityGrampsNotGoodEnoughText:
	text "Oh... I'm not good"
	line "enough for you."
	done

ViridianCityGrampsBoxFullText:
	text "Hmm? Your #MON"
	line "BOX is full."

	para "Make some room"
	line "first!"
	done

ViridianCityGrampsNearGymAlwaysClosedText:
	text "This #MON GYM"
	line "is always closed."

	para "I wonder who the"
	line "LEADER is?"
	done

ViridianCityGrampsNearGymLeaderReturnedText:
	text "VIRIDIAN GYM's"
	line "LEADER returned!"
	done

; Kanto hack (N1c): Yellow's ViridianCityFisherYouCanHaveThisText, verbatim
; (text/ViridianCity.asm).  Crystal's extra box breaks, "Weird, huh?" and the
; standalone "Huh?" are gone.
ViridianCityDreamEaterFisherText:
	text "Yawn!"
	line "I must have dozed"
	cont "off in the sun."

	para "I had this dream"
	line "about a DROWZEE"
	cont "eating my dream."
	cont "What's this?"
	cont "Where did this TM"
	cont "come from?"

	para "This is spooky!"
	line "Here, you can"
	cont "have this TM."
	done

; Kanto hack (N1c): Yellow's _ViridianCityFisherTM42ExplanationText, verbatim
; (one box, "...Snore..." not Crystal's "…Zzzzz…").
ViridianCityDreamEaterFisherGotDreamEaterText:
	text "TM42 contains"
	line "DREAM EATER..."
	cont "...Snore..."
	done

ViridianCityYoungsterText:
	text "Those # BALLs"
	line "at your waist!"
	cont "You have #MON!"

	para "It's great that"
	line "you can carry and"
	cont "use #MON any-"
	cont "time, anywhere!"
	done

ViridianCityYoungster2AskText:
	text "You want to know"
	line "about the 2 kinds"
	cont "of caterpillar"
	cont "#MON?"
	done

ViridianCityYoungster2OkThenText:
	text "Oh, OK then!"
	done

ViridianCityYoungster2CaterpieText:
	text "CATERPIE has no"
	line "poison, but"
	cont "WEEDLE does."

	para "Watch out for its"
	line "POISON STING!"
	done

ViridianCityGirlCoffeeText:
	text "Oh Grandpa! Don't"
	line "be so mean!"
	cont "He hasn't had his"
	cont "coffee yet."
	done

ViridianCityGirlWhenIGoShopText:
	text "When I go shop in"
	line "PEWTER CITY, I"
	cont "have to take the"
	cont "winding trail in"
	cont "VIRIDIAN FOREST."
	done

ViridianGymLockedText:
	text "The GYM's doors"
	line "are locked…"
	done

ViridianCitySignText:
	text "VIRIDIAN CITY"

	para "The Eternally"
	line "Green Paradise"
	done

ViridianGymSignText:
; N1 ruling 1 (operator, 2026-09-18): Yellow's sign verbatim, not Crystal's
; "LEADER: ... / the rest of the text is illegible" gag.  Yellow never names
; the Viridian leader on the sign -- vendor/pokeyellow/text/ViridianCity.asm
; _ViridianCityGymSignText.
	text "VIRIDIAN CITY"
	line "#MON GYM"
	done

ViridianCityTrainerTips1Text:
	text "TRAINER TIPS"

	para "Catch #MON"
	line "and expand your"
	cont "collection!"

	para "The more you have,"
	line "the easier it is"
	cont "to fight!"
	done

ViridianCityTrainerTips2Text:
	text "TRAINER TIPS"

	para "The battle moves"
	line "of #MON are"
	cont "limited by their"
	cont "POWER POINTs, PP."

	para "To replenish PP,"
	line "rest your tired"
	cont "#MON at a"
	cont "#MON CENTER!"
	done

ViridianCity_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 32,  7, VIRIDIAN_GYM, 1
	warp_event 21,  9, VIRIDIAN_NICKNAME_SPEECH_HOUSE, 1
	warp_event 29, 19, VIRIDIAN_MART, 2
	warp_event 23, 25, VIRIDIAN_POKECENTER_1F, 1
	; Kanto hack (N1c): Yellow's SCHOOL HOUSE on the door L1 emptied when it
	; deleted the TRAINER HOUSE.  APPENDED as warp 5 so warps 1-4 keep the
	; indices ViridianMart.asm and ViridianPokecenter1F.asm already point at.
	warp_event 23, 15, VIRIDIAN_SCHOOL_HOUSE, 1

	def_coord_events
	coord_event 19,  9, SCENE_VIRIDIANCITY_GRAMPS_BLOCK, ViridianCityGrampsBlock
	coord_event 19,  9, SCENE_VIRIDIANCITY_OLD_MAN_WAITING, ViridianCityOldManWaitingTrigger
	coord_event 32,  8, -1, ViridianGymLockedDoor ; L1 (R1): the locked GYM door

	def_bg_events
	bg_event 17, 17, BGEVENT_READ, ViridianCitySign
	bg_event 27,  7, BGEVENT_READ, ViridianGymSign
	bg_event 19,  1, BGEVENT_READ, ViridianCityTrainerTips1
	bg_event 21, 29, BGEVENT_READ, ViridianCityTrainerTips2
	bg_event 24, 25, BGEVENT_READ, ViridianCityPokecenterSign
	bg_event 30, 19, BGEVENT_READ, ViridianCityMartSign

	def_object_events
	object_event 18,  9, SPRITE_OLD_MAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ViridianCityCoffeeGramps, EVENT_VIRIDIAN_OLD_MAN_OFF_ROAD
	object_event 30,  8, SPRITE_OLD_MAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ViridianCityGrampsNearGym, -1
	object_event  6, 23, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ViridianCityDreamEaterFisher, -1
	object_event 13, 20, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, ViridianCityYoungsterScript, -1
	object_event 17,  9, SPRITE_TWIN, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ViridianCityGirlScript, -1
	object_event 30, 25, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, ViridianCityYoungster2Script, -1
; P1: Yellow's lying-asleep gambler on the same tile as the awake one, and his
; OLD_MAN_1 pacing LEFT_RIGHT by the nook.  Palette 0 on both, so each takes its
; sprite's own PAL_OW_BROWN -- the palette Crystal gives its own SPRITE_GRAMPS.
	object_event 18,  9, SPRITE_OLD_MAN_ASLEEP_OW, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ViridianCityAsleepGramps, EVENT_OAK_GOT_PARCEL
	object_event 17,  5, SPRITE_OLD_MAN, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ViridianCityCoffeeGramps, EVENT_VIRIDIAN_OLD_MAN_GONE_TO_MART
