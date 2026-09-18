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

ViridianCity_MapScripts:
	def_scene_scripts
	scene_script ViridianCityGrampsBlockScene, SCENE_VIRIDIANCITY_GRAMPS_BLOCK
	scene_script ViridianCityNoopScene,        SCENE_VIRIDIANCITY_NOOP

	def_callbacks
	callback MAPCALLBACK_NEWMAP, ViridianCityFlypointCallback
	callback MAPCALLBACK_OBJECTS, ViridianCityGrampsCallback

ViridianCityGrampsBlockScene:
ViridianCityNoopScene:
	end

; Yellow's grumpy old man (docs/M2-PARCEL.md): until OAK'S PARCEL is
; delivered he stands in the road to ROUTE 2 and turns the player back.
ViridianCityGrampsBlockLeft:
	turnobject VIRIDIANCITY_GRAMPS1, LEFT
	sjump ViridianCityGrampsBlock

ViridianCityGrampsBlockRight:
	turnobject VIRIDIANCITY_GRAMPS1, RIGHT
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

ViridianCityFlypointCallback:
	setflag ENGINE_FLYPOINT_VIRIDIAN
	endcallback

; After his catch demo the old man stands beside the road (docs/M2-CATCH.md).
ViridianCityGrampsCallback:
	checkevent EVENT_VIRIDIAN_OLD_MAN_CATCH_DEMO
	iffalse .Done
	moveobject VIRIDIANCITY_GRAMPS1, 17, 5 ; L1: Yellow's OLD_MAN_1 tile (was 16, 5)
.Done:
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
	iftrue .HadMyCoffee
	writetext ViridianCityGrampsPrivatePropertyText
	waitbutton
	closetext
	end

.HadMyCoffee:
	writetext ViridianCityGrampsHadMyCoffeeText
	waitbutton
	closetext
	loadwildmon RATTATA, 5
	setval TRUE ; the ball breaks free
	special OldManCatchTutorial
	reloadmap
	faceplayer
	opentext
	writetext ViridianCityGrampsLosingMyTouchText
	waitbutton
	closetext
	; L1 (docs/AUDIT-KANTO-LEFTOVERS.md 4.3): Yellow's post-demo beat.  He walks
	; six tiles DOWN the road towards the MART and is gone until he has restocked
	; (ViridianMart's NEWMAP callback clears the flag again); the OBJECTS callback
	; above then stands him beside the road at (17,5), Yellow's own tile.
	; Yellow picks between two movements on the player's X
	; (vendor/pokeyellow/scripts/ViridianCity.asm:219-243): the six-DOWN when the
	; column below him is clear, one step aside when the player is standing in it.
	; Yellow tests `cp 19` because its old man can only be spoken to from the east;
	; ours is approachable from (17,3) and (19,3) as well, so the test is "is the
	; player in MY column".
	readvar VAR_XCOORD
	ifequal 18, .StepAside
	applymovement VIRIDIANCITY_GRAMPS1, ViridianCity_GrampsOffToMartMovement
	sjump .GoneToMart
.StepAside:
	applymovement VIRIDIANCITY_GRAMPS1, ViridianCity_GrampsStepAsideMovement
.GoneToMart:
	disappear VIRIDIANCITY_GRAMPS1 ; sets EVENT_VIRIDIAN_OLD_MAN_GONE_TO_MART
	setevent EVENT_VIRIDIAN_OLD_MAN_CATCH_DEMO
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

; Yellow's ViridianCityOldManMovementData2, verbatim: six steps DOWN.  Column 18
; is walkable on rows 4-9 (scripts/mapgrid.py ViridianCity), so (18,3) -> (18,9).
ViridianCity_GrampsOffToMartMovement:
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step_end

; Yellow's ViridianCityOldManMovementData1, for when the player (or the follower
; behind them) is standing in that column.
ViridianCity_GrampsStepAsideMovement:
	step RIGHT
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
	text "VIRIDIAN CITY"
	line "#MON GYM"
	cont "LEADER: …"

	para "The rest of the"
	line "text is illegible…"
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
	coord_event 17,  3, SCENE_VIRIDIANCITY_GRAMPS_BLOCK, ViridianCityGrampsBlockRight
	coord_event 19,  3, SCENE_VIRIDIANCITY_GRAMPS_BLOCK, ViridianCityGrampsBlockLeft
	coord_event 32,  8, -1, ViridianGymLockedDoor ; L1 (R1): the locked GYM door

	def_bg_events
	bg_event 17, 17, BGEVENT_READ, ViridianCitySign
	bg_event 27,  7, BGEVENT_READ, ViridianGymSign
	bg_event 19,  1, BGEVENT_READ, ViridianCityTrainerTips1
	bg_event 21, 29, BGEVENT_READ, ViridianCityTrainerTips2
	bg_event 24, 25, BGEVENT_READ, ViridianCityPokecenterSign
	bg_event 30, 19, BGEVENT_READ, ViridianCityMartSign

	def_object_events
	object_event 18,  3, SPRITE_OLD_MAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ViridianCityCoffeeGramps, EVENT_VIRIDIAN_OLD_MAN_GONE_TO_MART
	object_event 30,  8, SPRITE_OLD_MAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ViridianCityGrampsNearGym, -1
	object_event  6, 23, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ViridianCityDreamEaterFisher, -1
	object_event 13, 20, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, ViridianCityYoungsterScript, -1
	object_event 17,  9, SPRITE_TWIN, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ViridianCityGirlScript, -1
	object_event 30, 25, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, ViridianCityYoungster2Script, -1
