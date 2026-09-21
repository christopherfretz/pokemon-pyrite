; Kanto hack: Yellow's ROUTE 17 (CYCLING ROAD), re-cut wholesale
; (docs/M6-CELADON.md, 9z).  Crystal's ROUTE 17 was a 10x45 road with four
; invented BIKERs and two hidden items; this is Yellow's own 10x72 -- ten
; trainers, six signs, five hidden items, no item balls and NO WARPS (Yellow
; puts the ROUTE 18 gate wholly on ROUTE 18; M6 9aa builds it).
;
; Object order below is Yellow's own (data/maps/objects/Route17.asm) and the
; sight ranges are Yellow's trainer headers (scripts/Route17.asm:36-55):
; 3, 4, 4, 4, 3, 2, 4, 2, 3, 4.
;
; Class substitutions (as 9y on ROUTE 16, decision D34):
;   OPP_BIKER 8-12     -> BIKER 4-8      (BikerGroup rows 3-7, taken over from
;                                         Crystal's dead DWAYNE/HARRIS/ZEKE and
;                                         its now-deleted CHARLES/RILEY)
;   OPP_CUE_BALL 4-8   -> CUE_BALL 4-8   (reserved by 9y, parties already match)
; Both draw with SPRITE_BIKER, exactly as Yellow does.
;
; The downhill (decision D42): Yellow forces a DOWN press on ROUTE_17 from
; ForceBikeDown (home/overworld.asm), masked off by PAD_CTRL_PAD | PAD_A |
; PAD_B, and suppresses the bike speed-up while UP/LEFT/RIGHT is held
; (DoBikeSpeedup).  Crystal's ENGINE_DOWNHILL is the same mechanic; 9z added
; the A/B half of Yellow's mask to engine/overworld/player_movement.asm so the
; ported TRAINER TIPS sign ("Press the A or B Button to stay in place while on
; a slope") is true.
	object_const_def
	const ROUTE17_BIKER1
	const ROUTE17_BIKER2
	const ROUTE17_BIKER3
	const ROUTE17_BIKER4
	const ROUTE17_BIKER5
	const ROUTE17_BIKER6
	const ROUTE17_BIKER7
	const ROUTE17_BIKER8
	const ROUTE17_BIKER9
	const ROUTE17_BIKER10

Route17_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_NEWMAP, Route17AlwaysOnBikeCallback

; Whole-map, unlike ROUTE 16's coordinate-gated version: every tile of ROUTE 17
; is CYCLING ROAD, and Yellow's force_bike_surf table has no ROUTE_17 rows
; precisely because in Gen 1 the bike bit simply persists from ROUTE 16.  GSC's
; HandleNewMap calls ResetBikeFlags before every MAPCALLBACK_NEWMAP (including
; on a connection crossing), so the destination map has to re-assert it; that
; is what this does, and it is also why neither flag leaks back onto ROUTE 16.
Route17AlwaysOnBikeCallback:
	setflag ENGINE_ALWAYS_ON_BIKE
	setflag ENGINE_DOWNHILL
	endcallback

TrainerCueBall4:
	trainer CUE_BALL, CUE_BALL_4, EVENT_BEAT_ROUTE_17_CUE_BALL_1, Route17Biker1SeenText, Route17Biker1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route17Biker1AfterBattleText
	waitbutton
	closetext
	end

TrainerCueBall5:
	trainer CUE_BALL, CUE_BALL_5, EVENT_BEAT_ROUTE_17_CUE_BALL_2, Route17Biker2SeenText, Route17Biker2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route17Biker2AfterBattleText
	waitbutton
	closetext
	end

TrainerBiker4:
	trainer BIKER, BIKER_4, EVENT_BEAT_ROUTE_17_BIKER_1, Route17Biker3SeenText, Route17Biker3BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route17Biker3AfterBattleText
	waitbutton
	closetext
	end

TrainerBiker5:
	trainer BIKER, BIKER_5, EVENT_BEAT_ROUTE_17_BIKER_2, Route17Biker4SeenText, Route17Biker4BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route17Biker4AfterBattleText
	waitbutton
	closetext
	end

TrainerBiker6:
	trainer BIKER, BIKER_6, EVENT_BEAT_ROUTE_17_BIKER_3, Route17Biker5SeenText, Route17Biker5BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route17Biker5AfterBattleText
	waitbutton
	closetext
	end

TrainerCueBall6:
	trainer CUE_BALL, CUE_BALL_6, EVENT_BEAT_ROUTE_17_CUE_BALL_3, Route17Biker6SeenText, Route17Biker6BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route17Biker6AfterBattleText
	waitbutton
	closetext
	end

TrainerCueBall7:
	trainer CUE_BALL, CUE_BALL_7, EVENT_BEAT_ROUTE_17_CUE_BALL_4, Route17Biker7SeenText, Route17Biker7BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route17Biker7AfterBattleText
	waitbutton
	closetext
	end

TrainerCueBall8:
	trainer CUE_BALL, CUE_BALL_8, EVENT_BEAT_ROUTE_17_CUE_BALL_5, Route17Biker8SeenText, Route17Biker8BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route17Biker8AfterBattleText
	waitbutton
	closetext
	end

TrainerBiker7:
	trainer BIKER, BIKER_7, EVENT_BEAT_ROUTE_17_BIKER_4, Route17Biker9SeenText, Route17Biker9BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route17Biker9AfterBattleText
	waitbutton
	closetext
	end

TrainerBiker8:
	trainer BIKER, BIKER_8, EVENT_BEAT_ROUTE_17_BIKER_5, Route17Biker10SeenText, Route17Biker10BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route17Biker10AfterBattleText
	waitbutton
	closetext
	end

Route17NoticeSign1:
	jumptext Route17NoticeSign1Text

Route17TrainerTips1:
	jumptext Route17TrainerTips1Text

Route17TrainerTips2:
	jumptext Route17TrainerTips2Text

Route17Sign:
	jumptext Route17SignText

Route17NoticeSign2:
	jumptext Route17NoticeSign2Text

Route17CyclingRoadEndsSign:
	jumptext Route17CyclingRoadEndsSignText

Route17HiddenRareCandy:
	hiddenitem RARE_CANDY, EVENT_ROUTE_17_HIDDEN_RARE_CANDY

Route17HiddenFullRestore:
	hiddenitem FULL_RESTORE, EVENT_ROUTE_17_HIDDEN_FULL_RESTORE

Route17HiddenPPUp:
	hiddenitem PP_UP, EVENT_ROUTE_17_HIDDEN_PP_UP

Route17HiddenMaxRevive:
	hiddenitem MAX_REVIVE, EVENT_ROUTE_17_HIDDEN_MAX_REVIVE

Route17HiddenMaxElixer:
	hiddenitem MAX_ELIXER, EVENT_ROUTE_17_HIDDEN_MAX_ELIXER

Route17Biker1SeenText:
	text "There's no money"
	line "in fighting kids!"
	done

Route17Biker1BeatenText:
	text "Burned"
	line "out!"
	done

Route17Biker1AfterBattleText:
	text "Good stuff is"
	line "lying around on"
	cont "CYCLING ROAD!"
	done

Route17Biker2SeenText:
	text "What do you want,"
	line "kiddo?"
	done

Route17Biker2BeatenText:
	text "Whoo!"
	done

Route17Biker2AfterBattleText:
	text "I could belly-"
	line "bump you outta"
	cont "here!"
	done

Route17Biker3SeenText:
	text "You heading to"
	line "FUCHSIA?"
	done

Route17Biker3BeatenText:
	text "Crash and"
	line "burn!"
	done

Route17Biker3AfterBattleText:
	text "I love racing"
	line "downhill!"
	done

Route17Biker4SeenText:
	text "We're BIKERs!"
	line "Highway stars!"
	done

Route17Biker4BeatenText:
	text "Smoked!"
	done

Route17Biker4AfterBattleText:
	text "Are you looking"
	line "for adventure?"
	done

Route17Biker5SeenText:
	text "Let VOLTORB"
	line "electrify you!"
	done

Route17Biker5BeatenText:
	text "Grounded"
	line "out!"
	done

Route17Biker5AfterBattleText:
	text "I got my VOLTORB"
	line "at the abandoned"
	cont "POWER PLANT."
	done

Route17Biker6SeenText:
	text "My #MON won't"
	line "evolve! Why?"
	done

Route17Biker6BeatenText:
	text "Why,"
	line "you!"
	done

Route17Biker6AfterBattleText:
	text "Maybe some #MON"
	line "need element"
	cont "STONEs to evolve."
	done

Route17Biker7SeenText:
	text "I need a little"
	line "exercise!"
	done

Route17Biker7BeatenText:
	text "Whew!"
	line "Good workout!"
	done

Route17Biker7AfterBattleText:
	text "I'm sure I lost"
	line "weight there!"
	done

Route17Biker8SeenText:
	text "Be a rebel!"
	done

Route17Biker8BeatenText:
	text "Aaaargh!"
	done

Route17Biker8AfterBattleText:
	text "Be ready to fight"
	line "for your beliefs!"
	done

Route17Biker9SeenText:
	text "Nice BIKE!"
	line "How's it handle?"
	done

Route17Biker9BeatenText:
	text "Shoot!"
	done

Route17Biker9AfterBattleText:
	text "The slope makes"
	line "it hard to steer!"
	done

Route17Biker10SeenText:
	text "Get lost, kid!"
	line "I'm bushed!"
	done

Route17Biker10BeatenText:
	text "Are you"
	line "satisfied?"
	done

Route17Biker10AfterBattleText:
	text "I need to catch"
	line "a few Zs!"
	done

Route17NoticeSign1Text:
	text "It's a notice!"

	para "Watch out for"
	line "discarded items!"
	done

Route17TrainerTips1Text:
	text "TRAINER TIPS"

	para "All #MON are"
	line "unique."

	para "Even #MON of"
	line "the same type and"
	cont "level grow at"
	cont "different rates."
	done

Route17TrainerTips2Text:
	text "TRAINER TIPS"

	para "Press the A or B"
	line "Button to stay in"
	cont "place while on a"
	cont "slope."
	done

Route17SignText:
	text "ROUTE 17"
	line "CELADON CITY -"
	cont "FUCHSIA CITY"
	done

Route17NoticeSign2Text:
	text "It's a notice!"

	para "Don't throw the"
	line "game, throw #"
	cont "BALLs instead!"
	done

Route17CyclingRoadEndsSignText:
	text "CYCLING ROAD"
	line "Slope ends here!"
	done

Route17_MapEvents:
	db 0, 0 ; filler

	def_warp_events

	def_coord_events

	def_bg_events
	bg_event  9,  51, BGEVENT_READ, Route17NoticeSign1
	bg_event  9,  63, BGEVENT_READ, Route17TrainerTips1
	bg_event  9,  75, BGEVENT_READ, Route17TrainerTips2
	bg_event  9,  87, BGEVENT_READ, Route17Sign
	bg_event  9, 111, BGEVENT_READ, Route17NoticeSign2
	bg_event  9, 141, BGEVENT_READ, Route17CyclingRoadEndsSign
	bg_event 15,  14, BGEVENT_ITEM, Route17HiddenRareCandy
	bg_event  8,  45, BGEVENT_ITEM, Route17HiddenFullRestore
	bg_event 17,  72, BGEVENT_ITEM, Route17HiddenPPUp
	bg_event  4,  91, BGEVENT_ITEM, Route17HiddenMaxRevive
	bg_event  8, 121, BGEVENT_ITEM, Route17HiddenMaxElixer

	def_object_events
	object_event 12,  19, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerCueBall4, -1
	object_event 11,  16, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerCueBall5, -1
	object_event  4,  18, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerBiker4, -1
	object_event  7,  32, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerBiker5, -1
	object_event 14,  34, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerBiker6, -1
	object_event 17,  58, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 2, TrainerCueBall6, -1
	object_event  2,  68, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerCueBall7, -1
	object_event 14,  98, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 2, TrainerCueBall8, -1
	object_event  5,  98, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerBiker7, -1
	object_event 10, 118, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerBiker8, -1
