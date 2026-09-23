; Kanto hack: Yellow's ROUTE 16, re-cut wholesale (docs/M6-CELADON.md, 9y).
; Crystal's ROUTE 16 was a 10x9 stub with one invented CYCLING ROAD sign and no
; objects at all; this is Yellow's own 20x9 map -- six trainers, two signs, the
; SNORLAX, the two-storey gate hut and the FLY HOUSE.
;
; Object order below is Yellow's own (data/maps/objects/Route16.asm) and the
; sight ranges are Yellow's trainer headers (scripts/Route16.asm:83-95):
; 3, 2, 2, 2, 2, 4.  Yellow gives ROUTE 16 no item balls and no hidden items.
;
; Class substitutions:
;   OPP_BIKER    -> BIKER     (Crystal has the class; rows 1-3 of BikerGroup are
;                              Yellow's ROUTE 16 parties, nameless so the battle
;                              intro reads "BIKER" alone)
;   OPP_CUE_BALL -> CUE_BALL  (new trainer class, docs/M6-CELADON.md D34)
; Both draw with SPRITE_BIKER, exactly as Yellow does.
	object_const_def
	const ROUTE16_BIKER1
	const ROUTE16_BIKER2
	const ROUTE16_BIKER3
	const ROUTE16_BIKER4
	const ROUTE16_BIKER5
	const ROUTE16_BIKER6
	const ROUTE16_SNORLAX

Route16_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_NEWMAP, Route16AlwaysOnBikeCallback

; The BICYCLE gate mechanic (docs/M6-CELADON.md 3.8, decision D38).
;
; Yellow re-arms the forced bike on the ROUTE 16 side, from a coordinate table:
;   force_bike_surf ROUTE_16, 17, 10
;   force_bike_surf ROUTE_16, 17, 11
; (vendor/pokeyellow/data/maps/force_bike_surf.asm) -- the two tiles you land on
; when you step out of the gate hut's WEST doors, i.e. the top of CYCLING ROAD.
; From there BIT_ALWAYS_ON_BIKE stays set until you walk into a gate, which
; clears it (Route16Gate's own NEWMAP callback below does the same).
;
; GSC has no per-step hook, so this is the NEWMAP-callback version Crystal
; itself used on this map: set the flag inside a box, clear it outside.  The
; box is "x <= 17 and y >= 9" -- the whole CYCLING ROAD half of the map, which
; is reachable only through the gate or from ROUTE 17 below.  That covers
; Yellow's two force tiles exactly and, unlike Yellow, also keeps the flag set
; when you walk back up from ROUTE 17, which is what Yellow's persistent flag
; does anyway.  Outside the box (the CELADON corridor at y=10 east of the hut,
; the north path, the FLY HOUSE door) the flag is cleared, which is both
; Crystal's safety net against a stuck bike and what Yellow's player state
; would be there.
Route16AlwaysOnBikeCallback:
	readvar VAR_XCOORD
	ifgreater 17, .CanWalk
	readvar VAR_YCOORD
	ifless 9, .CanWalk
	setflag ENGINE_ALWAYS_ON_BIKE
	endcallback

.CanWalk:
	clearflag ENGINE_ALWAYS_ON_BIKE
	endcallback

; SNORLAX #2.  The script is M6 9m's ROUTE 12 SNORLAX verbatim (decision D20 and
; the long rationale at hack/maps/Route12.asm:29-70): the POKe FLUTE is tested
; with `checkitem` from the object script instead of Yellow's
; ItemUsePokeFlute + Route16SnorlaxFluteCoords (dbmapcoord 27,10 / 25,10, the
; two tiles either side of it), the tune is playmusic MUSIC_NONE + playsound
; SFX_POKEFLUTE + RestartMapMusic, and the battle-result branch has to precede
; `reloadmapafterbattle` because that command jp's to the whiteout on LOSE.
; Only the two wake texts differ from ROUTE 12's: Yellow gives ROUTE 16 its own
; _Route16SnorlaxReturnedToMountainsText.
Route16Snorlax:: ; PE1: also queued by PokeFluteEffect (field use)
	opentext
	checkitem POKE_FLUTE
	iffalse .Asleep
	writetext Route16PlayedPokeFluteText
	promptbutton
	playmusic MUSIC_NONE
	playsound SFX_POKEFLUTE
	waitsfx
	special RestartMapMusic
	writetext Route16SnorlaxWokeUpText
	waitbutton
	closetext
	loadwildmon SNORLAX, 30
	loadvar VAR_BATTLETYPE, BATTLETYPE_NORMAL
	startbattle
	ifequal LOSE, .Fainted
	setevent EVENT_BEAT_ROUTE_16_SNORLAX ; = the object's hide flag
	disappear ROUTE16_SNORLAX
	reloadmapafterbattle
	opentext
	writetext Route16SnorlaxReturnedText
	waitbutton
	closetext
	end

.Fainted:
	setevent EVENT_BEAT_ROUTE_16_SNORLAX
	reloadmapafterbattle ; jp's straight to the whiteout
	end

.Asleep:
	writetext Route16SnorlaxText
	waitbutton
	closetext
	end

TrainerBiker1:
	trainer BIKER, BIKER_1, EVENT_BEAT_ROUTE_16_BIKER_1, Route16Biker1SeenText, Route16Biker1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route16Biker1AfterBattleText
	waitbutton
	closetext
	end

TrainerCueBall1:
	trainer CUE_BALL, CUE_BALL_1, EVENT_BEAT_ROUTE_16_CUE_BALL_1, Route16CueBall1SeenText, Route16CueBall1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route16CueBall1AfterBattleText
	waitbutton
	closetext
	end

TrainerCueBall2:
	trainer CUE_BALL, CUE_BALL_2, EVENT_BEAT_ROUTE_16_CUE_BALL_2, Route16CueBall2SeenText, Route16CueBall2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route16CueBall2AfterBattleText
	waitbutton
	closetext
	end

TrainerBiker2:
	trainer BIKER, BIKER_2, EVENT_BEAT_ROUTE_16_BIKER_2, Route16Biker2SeenText, Route16Biker2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route16Biker2AfterBattleText
	waitbutton
	closetext
	end

TrainerCueBall3:
	trainer CUE_BALL, CUE_BALL_3, EVENT_BEAT_ROUTE_16_CUE_BALL_3, Route16CueBall3SeenText, Route16CueBall3BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route16CueBall3AfterBattleText
	waitbutton
	closetext
	end

TrainerBiker3:
	trainer BIKER, BIKER_3, EVENT_BEAT_ROUTE_16_BIKER_3, Route16Biker3SeenText, Route16Biker3BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route16Biker3AfterBattleText
	waitbutton
	closetext
	end

Route16CyclingRoadSign:
	jumptext Route16CyclingRoadSignText

Route16Sign:
	jumptext Route16SignText

Route16SnorlaxText:
	text "A sleeping #MON"
	line "blocks the way!"
	done

; Yellow's _PlayedFluteHadEffectText (data/text/text_9.asm:113).
Route16PlayedPokeFluteText:
	text "<PLAYER> played the"
	line "# FLUTE."
	prompt

Route16SnorlaxWokeUpText:
	text "SNORLAX woke up!"

	para "It attacked in a"
	line "grumpy rage!"
	done

Route16SnorlaxReturnedText:
	text "With a big yawn,"
	line "SNORLAX returned"
	cont "to the mountains!"
	done

Route16Biker1SeenText:
	text "What do you want?"
	done

Route16Biker1BeatenText:
	text "Don't you"
	line "dare laugh!"
	done

Route16Biker1AfterBattleText:
	text "We like just"
	line "hanging here,"
	cont "what's it to you?"
	done

Route16CueBall1SeenText:
	text "Nice BIKE!"
	line "Hand it over!"
	done

Route16CueBall1BeatenText:
	text "Knock-"
	line "out!"
	done

Route16CueBall1AfterBattleText:
	text "Forget it, who"
	line "needs your BIKE!"
	done

Route16CueBall2SeenText:
	text "Come out and play,"
	line "little mouse!"
	done

Route16CueBall2BeatenText:
	text "You"
	line "little rat!"
	done

Route16CueBall2AfterBattleText:
	text "I hate losing!"
	line "Get away from me!"
	done

Route16Biker2SeenText:
	text "Hey, you just"
	line "bumped me!"
	done

Route16Biker2BeatenText:
	text "Kaboom!"
	done

Route16Biker2AfterBattleText:
	text "You can also get"
	line "to FUCHSIA from"
	cont "VERMILION using a"
	cont "coastal road."
	done

Route16CueBall3SeenText:
	text "I'm feeling"
	line "hungry and mean!"
	done

Route16CueBall3BeatenText:
	text "Bad,"
	line "bad, bad!"
	done

Route16CueBall3AfterBattleText:
	text "I like my #MON"
	line "ferocious! They"
	cont "tear up enemies!"
	done

Route16Biker3SeenText:
	text "Sure, I'll go!"
	done

Route16Biker3BeatenText:
	text "Don't make"
	line "me mad!"
	done

Route16Biker3AfterBattleText:
	text "I like harassing"
	line "people with my"
	cont "vicious #MON!"
	done

Route16CyclingRoadSignText:
	text "Enjoy the slope!"
	line "CYCLING ROAD"
	done

Route16SignText:
	text "ROUTE 16"
	line "CELADON CITY -"
	cont "FUCHSIA CITY"
	done

Route16_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; Yellow's nine warps in Yellow's order -- ROUTE_16_GATE's own warp list points
; back at these indices, so the order is load-bearing.  Warps 2 and 4 are the
; second tile of each doorway; Yellow points warp 4 at gate warp 3, not 4, and
; tile (24,11) is a wall block in both games, so that pair is dead in Yellow too.
	warp_event 17, 10, ROUTE_16_GATE, 1
	warp_event 17, 11, ROUTE_16_GATE, 1
	warp_event 24, 10, ROUTE_16_GATE, 3
	warp_event 24, 11, ROUTE_16_GATE, 3
	warp_event 17,  4, ROUTE_16_GATE, 5
	warp_event 17,  5, ROUTE_16_GATE, 5
	warp_event 24,  4, ROUTE_16_GATE, 7
	warp_event 24,  5, ROUTE_16_GATE, 7
	warp_event  7,  5, ROUTE_16_FUCHSIA_SPEECH_HOUSE, 1

	def_coord_events

	def_bg_events
	bg_event 27, 11, BGEVENT_READ, Route16CyclingRoadSign
	bg_event  5, 17, BGEVENT_READ, Route16Sign

	def_object_events
	object_event 17, 12, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerBiker1, -1
	object_event 14, 13, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 2, TrainerCueBall1, -1
	object_event 11, 12, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 2, TrainerCueBall2, -1
	object_event  9, 11, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 2, TrainerBiker2, -1
	object_event  6, 10, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 2, TrainerCueBall3, -1
	object_event  3, 12, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerBiker3, -1
	object_event 26, 10, SPRITE_BIG_SNORLAX, SPRITEMOVEDATA_BIGDOLLSYM, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route16Snorlax, EVENT_BEAT_ROUTE_16_SNORLAX ; palette 0 = the sprite's own, as ROUTE 12's SNORLAX has it
