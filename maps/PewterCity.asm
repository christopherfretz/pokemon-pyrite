	object_const_def
	const PEWTERCITY_COOLTRAINER_F
	const PEWTERCITY_COOLTRAINER_M
	const PEWTERCITY_GRAMPS
	const PEWTERCITY_FRUIT_TREE1
	const PEWTERCITY_FRUIT_TREE2
	const PEWTERCITY_SUPER_NERD1 ; museum barker
	const PEWTERCITY_SUPER_NERD2 ; repel gardener
	const PEWTERCITY_YOUNGSTER ; gym dragger

PewterCity_MapScripts:
	def_scene_scripts
	scene_script PewterCityNoopScene, SCENE_PEWTERCITY_NOOP
	scene_script PewterCityNoopScene, SCENE_PEWTERCITY_DRAGGER

	def_callbacks
	callback MAPCALLBACK_NEWMAP, PewterCityFlypointCallback
	callback MAPCALLBACK_OBJECTS, PewterCityDraggerCallback

PewterCityNoopScene:
	end

PewterCityFlypointCallback:
	setflag ENGINE_FLYPOINT_PEWTER
	endcallback

; Kanto hack (docs/M2-PEWTER-CITY.md): Yellow's youngster won't let you leave
; for ROUTE 3 before BROCK. Derive the scene on every map load so a white-out
; or a save/reload lands in the same state.
PewterCityDraggerCallback:
	checkevent EVENT_BEAT_BROCK
	iftrue .Done
	setscene SCENE_PEWTERCITY_DRAGGER
	endcallback

.Done:
	setscene SCENE_PEWTERCITY_NOOP
	endcallback

; Yellow's east-exit trigger tiles. Each one walks the player back under the
; youngster at (35,16) first, then they all share the escort.
PewterCityDraggerFrom3517:
	applymovement PLAYER, PewterCity_PlayerToDragger3517
	sjump PewterCityDraggerEscort

PewterCityDraggerFrom3617:
	applymovement PLAYER, PewterCity_PlayerToDragger3617
	sjump PewterCityDraggerEscort

PewterCityDraggerFrom3718:
	applymovement PLAYER, PewterCity_PlayerToDragger3718
	sjump PewterCityDraggerEscort

PewterCityDraggerFrom3719:
	applymovement PLAYER, PewterCity_PlayerToDragger3719
	sjump PewterCityDraggerEscort

; The youngster leads, the player trails one tile behind (GSC's `follow`, the
; idiomatic stand-in for Yellow's simulated-joypad drag). He stops one tile
; east of the gym door, which leaves the player standing on it at (16,18).
PewterCityDraggerEscort:
	turnobject PLAYER, UP
	turnobject PEWTERCITY_YOUNGSTER, DOWN
	opentext
	writetext PewterCityYoungsterFollowMeText
	waitbutton
	closetext
	playmusic MUSIC_SHOW_ME_AROUND
	follow PEWTERCITY_YOUNGSTER, PLAYER
	applymovement PEWTERCITY_YOUNGSTER, PewterCity_YoungsterToGym
	stopfollow
	turnobject PLAYER, UP
	turnobject PEWTERCITY_YOUNGSTER, LEFT
	opentext
	writetext PewterCityYoungsterGoTakeOnBrockText
	waitbutton
	closetext
	special RestartMapMusic
	applymovement PEWTERCITY_YOUNGSTER, PewterCity_YoungsterLeaves
	disappear PEWTERCITY_YOUNGSTER
	moveobject PEWTERCITY_YOUNGSTER, 35, 16
	appear PEWTERCITY_YOUNGSTER
	end

PewterCity_PlayerToDragger3517:
	step_end

PewterCity_PlayerToDragger3617:
	step LEFT
	step_end

PewterCity_PlayerToDragger3718:
	step LEFT
	step LEFT
	step UP
	step_end

PewterCity_PlayerToDragger3719:
	step UP
	step LEFT
	step LEFT
	step UP
	step_end

; (35,16) -> row 16 west -> up x=27 -> row 13 west -> down x=10 -> (17,18).
PewterCity_YoungsterToGym:
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step UP
	step UP
	step UP
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step_end

PewterCity_YoungsterLeaves:
	step RIGHT
	step_end

PewterCityYoungsterScript:
	jumptextfaceplayer PewterCityYoungsterGoTakeOnBrockText

PewterCityCooltrainerFScript:
	jumptextfaceplayer PewterCityCooltrainerFText

PewterCityCooltrainerMScript:
	jumptextfaceplayer PewterCityCooltrainerMText

; Yellow's museum barker. The MUSEUM itself is step 4d, so he only talks.
PewterCityMuseumBarkerScript:
	faceplayer
	opentext
	writetext PewterCityMuseumBarkerAskText
	yesorno
	iffalse .No
	writetext PewterCityMuseumBarkerYesText
	waitbutton
	closetext
	end

.No:
	writetext PewterCityMuseumBarkerNoText
	waitbutton
	closetext
	end

PewterCityRepelGardenerScript:
	faceplayer
	opentext
	writetext PewterCityRepelGardenerAskText
	yesorno
	iffalse .No
	writetext PewterCityRepelGardenerYesText
	waitbutton
	closetext
	end

.No:
	writetext PewterCityRepelGardenerNoText
	waitbutton
	closetext
	end

; Kanto hack: the SILVER WING belongs to the Johto act, so it is held back
; until the KANTO LEAGUE is done (docs/M2-PEWTER-CITY.md).
PewterCityGrampsScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_SILVER_WING
	iftrue .GotSilverWing
	checkevent EVENT_BEAT_ELITE_FOUR
	iffalse .NotYet
	writetext PewterCityGrampsText
	promptbutton
	verbosegiveitem SILVER_WING
	setevent EVENT_GOT_SILVER_WING
	closetext
	end

.NotYet:
	writetext PewterCityGrampsTravelText
	waitbutton
	closetext
	end

.GotSilverWing:
	writetext PewterCityGrampsText_GotSilverWing
	waitbutton
	closetext
	end

PewterCitySign:
	jumptext PewterCitySignText

PewterGymSign:
	jumptext PewterGymSignText

PewterMuseumSign:
	jumptext PewterMuseumSignText

PewterCityPoliceNoticeSign:
	jumptext PewterCityPoliceNoticeSignText

PewterCityTrainerTipsSign:
	jumptext PewterCityTrainerTipsSignText

PewterCityPokecenterSign:
	jumpstd PokecenterSignScript

PewterCityMartSign:
	jumpstd MartSignScript

PewterCityFruitTree1:
	fruittree FRUITTREE_PEWTER_CITY_1

PewterCityFruitTree2:
	fruittree FRUITTREE_PEWTER_CITY_2

PewterCityCooltrainerFText:
	text "It's rumored that"
	line "CLEFAIRY came"
	cont "from the moon!"

	para "They appeared"
	line "after MOON STONE"
	cont "fell on MT.MOON."
	done

PewterCityCooltrainerMText:
	text "There aren't many"
	line "serious #MON"
	cont "trainers here!"

	para "They're all like"
	line "BUG CATCHERs, but"

	para "PEWTER GYM's"
	line "BROCK is totally"
	cont "into it!"
	done

PewterCityMuseumBarkerAskText:
	text "Did you check out"
	line "the MUSEUM?"
	done

PewterCityMuseumBarkerYesText:
	text "Weren't those"
	line "fossils from MT."
	cont "MOON amazing?"
	done

PewterCityMuseumBarkerNoText:
	text "Really?"
	line "You absolutely"
	cont "have to go!"

	para "It's right here!"
	line "You have to pay"
	cont "to get in, but"
	cont "it's worth it!"
	done

PewterCityRepelGardenerAskText:
	text "Psssst!"
	line "Do you know what"
	cont "I'm doing?"
	done

PewterCityRepelGardenerYesText:
	text "That's right!"
	line "It's hard work!"
	done

PewterCityRepelGardenerNoText:
	text "I'm spraying REPEL"
	line "to keep #MON"
	cont "out of my garden!"
	done

PewterCityYoungsterFollowMeText:
	text "You're a trainer"
	line "right? BROCK's"
	cont "looking for new"
	cont "challengers!"

	para "Follow me!"
	done

PewterCityYoungsterGoTakeOnBrockText:
	text "If you have the"
	line "right stuff, go"
	cont "take on BROCK!"
	done

PewterCityGrampsTravelText:
	text "When I was young,"
	line "I walked all over"
	cont "KANTO."

	para "Going to new, un-"
	line "known places and"
	cont "seeing new people…"

	para "Those are the joys"
	line "of travel."
	done

PewterCityGrampsText:
	text "You've conquered"
	line "the #MON LEAGUE?"

	para "That brings back"
	line "memories. When I"

	para "was young, I went"
	line "to JOHTO to train."

	para "You remind me so"
	line "much of what I was"

	para "like as a young"
	line "man."

	para "Here. I want you"
	line "to have this item"
	cont "I found in JOHTO."
	done

PewterCityGrampsText_GotSilverWing:
	text "Going to new, un-"
	line "known places and"
	cont "seeing new people…"

	para "Those are the joys"
	line "of travel."
	done

PewterCitySignText:
	text "PEWTER CITY"
	line "A Stone Gray City"
	done

PewterGymSignText:
	text "PEWTER CITY"
	line "#MON GYM"
	cont "LEADER: BROCK"

	para "The Rock Solid"
	line "#MON Trainer"
	done

PewterMuseumSignText:
	text "PEWTER MUSEUM"
	line "OF SCIENCE"
	done

PewterCityPoliceNoticeSignText:
	text "NOTICE!"

	para "Thieves have been"
	line "stealing #MON"
	cont "fossils at MT."
	cont "MOON!"

	para "Please call PEWTER"
	line "POLICE with any"
	cont "info!"
	done

PewterCityTrainerTipsSignText:
	text "TRAINER TIPS"

	para "Any #MON that"
	line "takes part in"
	cont "battle, however"
	cont "short, earns EXP!"
	done

PewterCity_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 29, 13, PEWTER_NIDORAN_SPEECH_HOUSE, 1
	warp_event 16, 17, PEWTER_GYM, 1
	warp_event 23, 17, PEWTER_MART, 2
	warp_event 13, 25, PEWTER_POKECENTER_1F, 1
	warp_event  7, 29, PEWTER_SNOOZE_SPEECH_HOUSE, 1
	warp_event 14,  7, MUSEUM_1F, 1
	warp_event 19,  5, MUSEUM_1F, 3

	def_coord_events
	coord_event 35, 17, SCENE_PEWTERCITY_DRAGGER, PewterCityDraggerFrom3517
	coord_event 36, 17, SCENE_PEWTERCITY_DRAGGER, PewterCityDraggerFrom3617
	coord_event 37, 18, SCENE_PEWTERCITY_DRAGGER, PewterCityDraggerFrom3718
	coord_event 37, 19, SCENE_PEWTERCITY_DRAGGER, PewterCityDraggerFrom3719

	def_bg_events
	bg_event 25, 23, BGEVENT_READ, PewterCitySign
	bg_event 11, 17, BGEVENT_READ, PewterGymSign
	bg_event 15,  9, BGEVENT_READ, PewterMuseumSign
	bg_event 33, 19, BGEVENT_READ, PewterCityPoliceNoticeSign
	bg_event 19, 29, BGEVENT_READ, PewterCityTrainerTipsSign
	bg_event 14, 25, BGEVENT_READ, PewterCityPokecenterSign
	bg_event 24, 17, BGEVENT_READ, PewterCityMartSign

	def_object_events
	object_event  8, 15, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, PewterCityCooltrainerFScript, -1
	object_event 17, 25, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, PewterCityCooltrainerMScript, -1
	object_event 29, 17, SPRITE_GRAMPS, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 2, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, PewterCityGrampsScript, -1
	object_event 32,  3, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PewterCityFruitTree1, -1
	object_event 30,  3, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PewterCityFruitTree2, -1
	object_event 27, 17, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, PewterCityMuseumBarkerScript, -1
	object_event 26, 25, SPRITE_SUPER_NERD, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 2, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, PewterCityRepelGardenerScript, -1
	object_event 35, 16, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, PewterCityYoungsterScript, -1
