; Kanto hack: Yellow's ROUTE 15, re-cut wholesale (docs/M7-FUCHSIA.md, 10e).
; Crystal's ROUTE 15 was the same 30x9 block map but with an invented layout and
; six invented trainers; 10e replaces the layout (scripts/vermilion_blk.py, M7
; 10e), the objects and the connections with Yellow's -- ten trainers, one sign
; and the TM20 RAGE ball.  Yellow's ROUTE 15 has no coord events and no hidden
; items, and its only warps are the four gate doors.
;
; Deleted with Crystal's version: TEACHER COLETTE (30,12), TEACHER HILLARY
; (20,10), SCHOOLBOY KIPP (10,10), SCHOOLBOY TOMMY (15,13), SCHOOLBOY JOHNNY
; (33,10) and SCHOOLBOY BILLY (27,10) -- Johto schoolkids on a field trip to the
; LAVENDER RADIO TOWER, with phone-calling text (docs/M7-FUCHSIA.md 0.5).  Their
; six party rows in data/trainers/parties.asm are left in place, marked unused:
; deleting them would renumber their classes and "Enemy Trainers" is not tight
; (D49), so a later map can reclaim the rows where they stand.
;
; Crystal's PP_UP ball at (12,5) is retired for Yellow's TM_RAGE at (18,5); the
; flag EVENT_ROUTE_15_PP_UP was renamed in place to EVENT_ROUTE_15_TM_RAGE, so
; no saved bit moves.  TM_RAGE is our TM66 (Yellow's TM20; see docs/TM-LEDGER.md).
;
; Object order below is Yellow's own (data/maps/objects/Route15.asm), and the
; sight ranges are Yellow's trainer headers (scripts/Route15.asm:34-53):
; 2, 3, 3, 3, 2, 3, 3, 3, 3, 3.
;
; Class substitutions: Crystal has no JR.TRAINER, so Yellow's OPP_JR_TRAINER_F
; becomes PICNICKER (the M6/M7 standing substitution).  OPP_BIRD_KEEPER,
; OPP_BEAUTY and OPP_BIKER map straight across.
;
; The party rows are nameless (`db "@", TRAINERTYPE_NORMAL`), so
; PlaceEnemysName prints the class alone, as Gen 1 does.  Const/flag pairs:
;   PICNICKER_5..8       EVENT_BEAT_ROUTE_15_PICNICKER_5..8
;   BIRD_KEEPER_13/14    EVENT_BEAT_ROUTE_15_BIRD_KEEPER_13/14
;   BEAUTY_3/4           EVENT_BEAT_ROUTE_15_BEAUTY_3/4
;   BIKER_14/15          EVENT_BEAT_ROUTE_15_BIKER_14/15
; (The numbers continue the per-class hack sequence; they are not Yellow's
; opponent ids -- Yellow's are OPP_JR_TRAINER_F 20/21/22/23, OPP_BIRD_KEEPER
; 6/7, OPP_BEAUTY 9/10 and OPP_BIKER 3/4.)
	object_const_def
	const ROUTE15_PICNICKER1
	const ROUTE15_PICNICKER2
	const ROUTE15_BIRD_KEEPER1
	const ROUTE15_BIRD_KEEPER2
	const ROUTE15_BEAUTY1
	const ROUTE15_BEAUTY2
	const ROUTE15_BIKER1
	const ROUTE15_BIKER2
	const ROUTE15_PICNICKER3
	const ROUTE15_PICNICKER4
	const ROUTE15_POKE_BALL

Route15_MapScripts:
	def_scene_scripts

	def_callbacks

TrainerPicnicker5:
	trainer PICNICKER, PICNICKER_5, EVENT_BEAT_ROUTE_15_PICNICKER_5, Route15Picnicker5SeenText, Route15Picnicker5BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route15Picnicker5AfterBattleText
	waitbutton
	closetext
	end

TrainerPicnicker6:
	trainer PICNICKER, PICNICKER_6, EVENT_BEAT_ROUTE_15_PICNICKER_6, Route15Picnicker6SeenText, Route15Picnicker6BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route15Picnicker6AfterBattleText
	waitbutton
	closetext
	end

TrainerBirdKeeper13:
	trainer BIRD_KEEPER, BIRD_KEEPER_13, EVENT_BEAT_ROUTE_15_BIRD_KEEPER_13, Route15BirdKeeper13SeenText, Route15BirdKeeper13BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route15BirdKeeper13AfterBattleText
	waitbutton
	closetext
	end

TrainerBirdKeeper14:
	trainer BIRD_KEEPER, BIRD_KEEPER_14, EVENT_BEAT_ROUTE_15_BIRD_KEEPER_14, Route15BirdKeeper14SeenText, Route15BirdKeeper14BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route15BirdKeeper14AfterBattleText
	waitbutton
	closetext
	end

TrainerBeauty3:
	trainer BEAUTY, BEAUTY_3, EVENT_BEAT_ROUTE_15_BEAUTY_3, Route15Beauty3SeenText, Route15Beauty3BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route15Beauty3AfterBattleText
	waitbutton
	closetext
	end

TrainerBeauty4:
	trainer BEAUTY, BEAUTY_4, EVENT_BEAT_ROUTE_15_BEAUTY_4, Route15Beauty4SeenText, Route15Beauty4BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route15Beauty4AfterBattleText
	waitbutton
	closetext
	end

TrainerBiker14:
	trainer BIKER, BIKER_14, EVENT_BEAT_ROUTE_15_BIKER_14, Route15Biker14SeenText, Route15Biker14BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route15Biker14AfterBattleText
	waitbutton
	closetext
	end

TrainerBiker15:
	trainer BIKER, BIKER_15, EVENT_BEAT_ROUTE_15_BIKER_15, Route15Biker15SeenText, Route15Biker15BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route15Biker15AfterBattleText
	waitbutton
	closetext
	end

TrainerPicnicker7:
	trainer PICNICKER, PICNICKER_7, EVENT_BEAT_ROUTE_15_PICNICKER_7, Route15Picnicker7SeenText, Route15Picnicker7BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route15Picnicker7AfterBattleText
	waitbutton
	closetext
	end

TrainerPicnicker8:
	trainer PICNICKER, PICNICKER_8, EVENT_BEAT_ROUTE_15_PICNICKER_8, Route15Picnicker8SeenText, Route15Picnicker8BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route15Picnicker8AfterBattleText
	waitbutton
	closetext
	end

Route15Sign:
	jumptext Route15SignText

Route15TMRage:
	itemball TM_RAGE

; Yellow's _Route15CooltrainerF1{Battle,EndBattle,AfterBattle}Text.
Route15Picnicker5SeenText:
	text "Let me try out the"
	line "#MON I just"
	cont "got in a trade!"
	done

Route15Picnicker5BeatenText:
	text "Not"
	line "good enough!"
	done

Route15Picnicker5AfterBattleText:
	text "You can't change"
	line "the nickname of"
	cont "any #MON you"
	cont "get in a trade."

	para "Only the Original"
	line "Trainer can."
	done

; Yellow's _Route15CooltrainerF2*Text.
Route15Picnicker6SeenText:
	text "You look gentle,"
	line "so I think I can"
	cont "beat you!"
	done

Route15Picnicker6BeatenText:
	text "No,"
	line "wrong!"
	done

Route15Picnicker6AfterBattleText:
	text "I'm afraid of"
	line "BIKERs, they look"
	cont "so ugly and mean!"
	done

; Yellow's _Route15CooltrainerM1*Text.
Route15BirdKeeper13SeenText:
	text "When I whistle, I"
	line "can summon bird"
	cont "#MON!"
	done

Route15BirdKeeper13BeatenText:
	text "Ow!"
	line "That's tragic!"
	done

Route15BirdKeeper13AfterBattleText:
	text "Maybe I'm not cut"
	line "out for battles."
	done

; Yellow's _Route15CooltrainerM2*Text.
Route15BirdKeeper14SeenText:
	text "Hmm? My birds are"
	line "shivering! You're"
	cont "good, aren't you?"
	done

Route15BirdKeeper14BeatenText:
	text "Just"
	line "as I thought!"
	done

Route15BirdKeeper14AfterBattleText:
	text "Did you know moves"
	line "like EARTHQUAKE"
	cont "don't have any"
	cont "effect on birds?"
	done

; Yellow's _Route15Beauty1*Text.
Route15Beauty3SeenText:
	text "Oh, you're a"
	line "little cutie!"
	done

Route15Beauty3BeatenText:
	text "You looked"
	line "so cute too!"
	done

Route15Beauty3AfterBattleText:
	text "I forgive you!"
	line "I can take it!"
	done

; Yellow's _Route15Beauty2*Text.
Route15Beauty4SeenText:
	text "I raise #MON"
	line "because I live"
	cont "alone!"
	done

Route15Beauty4BeatenText:
	text "I didn't"
	line "ask for this!"
	done

Route15Beauty4AfterBattleText:
	text "I just like going"
	line "home to be with"
	cont "my #MON!"
	done

; Yellow's _Route15Biker1*Text.
Route15Biker14SeenText:
	text "Hey kid! C'mon!"
	line "I just got these!"
	done

Route15Biker14BeatenText:
	text "Why"
	line "not?"
	done

Route15Biker14AfterBattleText:
	text "You only live"
	line "once, so I live"
	cont "as an outlaw!"
	cont "TEAM ROCKET RULES!"
	done

; Yellow's _Route15Biker2*Text.
Route15Biker15SeenText:
	text "Fork over all your"
	line "cash when you"
	cont "lose to me, kid!"
	done

Route15Biker15BeatenText:
	text "That"
	line "can't be true!"
	done

Route15Biker15AfterBattleText:
	text "I was just joking"
	line "about the money!"
	done

; Yellow's _Route15CooltrainerF3*Text.
Route15Picnicker7SeenText:
	text "What's cool?"
	line "Trading #MON!"
	done

Route15Picnicker7BeatenText:
	text "I"
	line "said trade!"
	done

Route15Picnicker7AfterBattleText:
	text "I trade #MON"
	line "with my friends!"
	done

; Yellow's _Route15CooltrainerF4*Text.
Route15Picnicker8SeenText:
	text "Want to play with"
	line "my #MON?"
	done

Route15Picnicker8BeatenText:
	text "I was"
	line "too impatient!"
	done

Route15Picnicker8AfterBattleText:
	text "I'll go train with"
	line "weaker people."
	done

Route15SignText:
	text "ROUTE 15"
	line "West to FUCHSIA"
	cont "CITY"
	done

Route15_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; Yellow's own four gate doors (data/maps/objects/Route15.asm).  The pairing is
; asymmetric on purpose: Yellow sends BOTH west tiles to gate warp 1 and BOTH
; east tiles to gate warp 3, so you always come back out through the upper door.
	warp_event  7,  8, ROUTE_15_FUCHSIA_GATE, 1
	warp_event  7,  9, ROUTE_15_FUCHSIA_GATE, 1
	warp_event 14,  8, ROUTE_15_FUCHSIA_GATE, 3
	warp_event 14,  9, ROUTE_15_FUCHSIA_GATE, 3

	def_coord_events

	def_bg_events
	bg_event 39,  9, BGEVENT_READ, Route15Sign

	def_object_events
	object_event 41, 11, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerPicnicker5, -1
	object_event 53, 10, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerPicnicker6, -1
	object_event 31, 13, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerBirdKeeper13, -1
	object_event 35, 13, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerBirdKeeper14, -1
	object_event 53, 11, SPRITE_BEAUTY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, TrainerBeauty3, -1
	object_event 41, 10, SPRITE_BEAUTY, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerBeauty4, -1
	object_event 48, 10, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerBiker14, -1
	object_event 46, 10, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerBiker15, -1
	object_event 37,  5, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerPicnicker7, -1
	object_event 18, 13, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerPicnicker8, -1
	object_event 18,  5, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route15TMRage, EVENT_ROUTE_15_TM_RAGE
