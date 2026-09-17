	object_const_def
	const VIRIDIANCITY_GRAMPS1
	const VIRIDIANCITY_GRAMPS2
	const VIRIDIANCITY_FISHER
	const VIRIDIANCITY_YOUNGSTER

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
	moveobject VIRIDIANCITY_GRAMPS1, 16, 5
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
	; Walk to (16,5) around whichever side the player is standing on.
	readvar VAR_XCOORD
	ifequal 17, .AsideViaRight
	applymovement VIRIDIANCITY_GRAMPS1, ViridianCity_GrampsAsideViaLeftMovement
	sjump .Aside
.AsideViaRight:
	applymovement VIRIDIANCITY_GRAMPS1, ViridianCity_GrampsAsideViaRightMovement
.Aside:
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

ViridianCity_GrampsAsideViaLeftMovement:
	step LEFT
	step DOWN
	step DOWN
	step LEFT
	turn_head DOWN
	step_end

ViridianCity_GrampsAsideViaRightMovement:
	step RIGHT
	step DOWN
	step DOWN
	step LEFT
	step LEFT
	step LEFT
	turn_head DOWN
	step_end

ViridianCityGrampsNearGym:
	faceplayer
	opentext
	checkevent EVENT_BLUE_IN_CINNABAR
	iftrue .BlueReturned
	writetext ViridianCityGrampsNearGymText
	waitbutton
	closetext
	end

.BlueReturned:
	writetext ViridianCityGrampsNearGymBlueReturnedText
	waitbutton
	closetext
	end

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

ViridianCityWelcomeSign:
	jumptext ViridianCityWelcomeSignText

TrainerHouseSign:
	jumptext TrainerHouseSignText

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

ViridianCityGrampsNearGymText:
	text "This GYM didn't"
	line "have a LEADER"
	cont "until recently."

	para "A young man from"
	line "PALLET became the"

	para "LEADER, but he's"
	line "often away."
	done

ViridianCityGrampsNearGymBlueReturnedText:
	text "Are you going to"
	line "battle the LEADER?"

	para "Good luck to you."
	line "You'll need it."
	done

ViridianCityDreamEaterFisherText:
	text "Yawn!"

	para "I must have dozed"
	line "off in the sun."

	para "…I had this dream"
	line "about a DROWZEE"

	para "eating my dream."
	line "Weird, huh?"

	para "Huh?"
	line "What's this?"

	para "Where did this TM"
	line "come from?"

	para "This is spooky!"
	line "Here, you can have"
	cont "this TM."
	done

ViridianCityDreamEaterFisherGotDreamEaterText:
	text "TM42 contains"
	line "DREAM EATER…"

	para "…Zzzzz…"
	done

ViridianCityYoungsterText:
	text "I heard that there"
	line "are many items on"

	para "the ground in"
	line "VIRIDIAN FOREST."
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

ViridianCityWelcomeSignText:
	text "WELCOME TO"
	line "VIRIDIAN CITY,"

	para "THE GATEWAY TO"
	line "INDIGO PLATEAU"
	done

TrainerHouseSignText:
	text "TRAINER HOUSE"

	para "The Club for Top"
	line "Trainer Battles"
	done

ViridianCity_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 32,  7, VIRIDIAN_GYM, 1
	warp_event 21,  9, VIRIDIAN_NICKNAME_SPEECH_HOUSE, 1
	warp_event 23, 15, TRAINER_HOUSE_1F, 1
	warp_event 29, 19, VIRIDIAN_MART, 2
	warp_event 23, 25, VIRIDIAN_POKECENTER_1F, 1

	def_coord_events
	coord_event 17,  3, SCENE_VIRIDIANCITY_GRAMPS_BLOCK, ViridianCityGrampsBlockRight
	coord_event 19,  3, SCENE_VIRIDIANCITY_GRAMPS_BLOCK, ViridianCityGrampsBlockLeft

	def_bg_events
	bg_event 17, 17, BGEVENT_READ, ViridianCitySign
	bg_event 27,  7, BGEVENT_READ, ViridianGymSign
	bg_event 19,  1, BGEVENT_READ, ViridianCityWelcomeSign
	bg_event 21, 15, BGEVENT_READ, TrainerHouseSign
	bg_event 24, 25, BGEVENT_READ, ViridianCityPokecenterSign
	bg_event 30, 19, BGEVENT_READ, ViridianCityMartSign

	def_object_events
	object_event 18,  3, SPRITE_OLD_MAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ViridianCityCoffeeGramps, -1
	object_event 30,  8, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ViridianCityGrampsNearGym, -1
	object_event  6, 23, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ViridianCityDreamEaterFisher, -1
	object_event 17, 21, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WANDER, 3, 3, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, ViridianCityYoungsterScript, -1
