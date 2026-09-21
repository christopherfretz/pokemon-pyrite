; Kanto hack: Yellow's ROUTE 13, re-cut wholesale (docs/M7-FUCHSIA.md, 10c).
; Crystal's ROUTE 13 was already 30x9, Yellow's own size, but with Yellow's
; layout nowhere in it, five invented trainers, an invented directions sign and
; the hidden CALCIUM in the wrong place; 10c replaces the whole thing with
; Yellow's -- layout (scripts/vermilion_blk.py, M7 10c), ten trainers, three
; signs and two hidden items.  Yellow's ROUTE 13 has no warps and no coord
; events.
;
; Object order below is Yellow's own (data/maps/objects/Route13.asm), and the
; sight ranges are Yellow's trainer headers (scripts/Route13.asm:36-54): 2 for
; every trainer except headers 4, 6 and 9 (PICNICKER_4, BEAUTY_1 and
; BIRD_KEEPER_6 here), which are 4.
;
; Class substitutions, both already established:
;   OPP_JR_TRAINER_F -> PICNICKER  (Crystal has no JR.TRAINER^F; PICNICKER is
;                                   the stand-in used since CERULEAN GYM)
;   OPP_BEAUTY/OPP_BIKER/OPP_BIRD_KEEPER map straight onto BEAUTY/BIKER/
;   BIRD_KEEPER, which Crystal has.
;
; The party rows are nameless (`db "@", TRAINERTYPE_NORMAL`), so
; PlaceEnemysName prints the class alone, as Gen 1 does.  Const/flag pairs:
;   BIRD_KEEPER_4/5/6  EVENT_BEAT_ROUTE_13_BIRD_KEEPER_4/5/6
;   PICNICKER_1..4     EVENT_BEAT_ROUTE_13_PICNICKER_1..4
;   BEAUTY_1/2         EVENT_BEAT_ROUTE_13_BEAUTY_1/2
;   BIKER_9            EVENT_BEAT_ROUTE_13_BIKER_9
; (BIRD_KEEPER_1-3 and BIKER_1-8 are M6's ROUTE 16/17/18 trainers; the numbers
; continue that per-class hack sequence, they are not Yellow's opponent ids.)
	object_const_def
	const ROUTE13_BIRD_KEEPER1
	const ROUTE13_PICNICKER1
	const ROUTE13_PICNICKER2
	const ROUTE13_PICNICKER3
	const ROUTE13_PICNICKER4
	const ROUTE13_BIRD_KEEPER2
	const ROUTE13_BEAUTY1
	const ROUTE13_BEAUTY2
	const ROUTE13_BIKER
	const ROUTE13_BIRD_KEEPER3

Route13_MapScripts:
	def_scene_scripts

	def_callbacks

TrainerBirdKeeper4:
	trainer BIRD_KEEPER, BIRD_KEEPER_4, EVENT_BEAT_ROUTE_13_BIRD_KEEPER_4, Route13BirdKeeper4SeenText, Route13BirdKeeper4BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route13BirdKeeper4AfterBattleText
	waitbutton
	closetext
	end

TrainerPicnicker1:
	trainer PICNICKER, PICNICKER_1, EVENT_BEAT_ROUTE_13_PICNICKER_1, Route13Picnicker1SeenText, Route13Picnicker1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route13Picnicker1AfterBattleText
	waitbutton
	closetext
	end

TrainerPicnicker2:
	trainer PICNICKER, PICNICKER_2, EVENT_BEAT_ROUTE_13_PICNICKER_2, Route13Picnicker2SeenText, Route13Picnicker2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route13Picnicker2AfterBattleText
	waitbutton
	closetext
	end

TrainerPicnicker3:
	trainer PICNICKER, PICNICKER_3, EVENT_BEAT_ROUTE_13_PICNICKER_3, Route13Picnicker3SeenText, Route13Picnicker3BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route13Picnicker3AfterBattleText
	waitbutton
	closetext
	end

TrainerPicnicker4:
	trainer PICNICKER, PICNICKER_4, EVENT_BEAT_ROUTE_13_PICNICKER_4, Route13Picnicker4SeenText, Route13Picnicker4BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route13Picnicker4AfterBattleText
	waitbutton
	closetext
	end

TrainerBirdKeeper5:
	trainer BIRD_KEEPER, BIRD_KEEPER_5, EVENT_BEAT_ROUTE_13_BIRD_KEEPER_5, Route13BirdKeeper5SeenText, Route13BirdKeeper5BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route13BirdKeeper5AfterBattleText
	waitbutton
	closetext
	end

TrainerBeauty1:
	trainer BEAUTY, BEAUTY_1, EVENT_BEAT_ROUTE_13_BEAUTY_1, Route13Beauty1SeenText, Route13Beauty1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route13Beauty1AfterBattleText
	waitbutton
	closetext
	end

TrainerBeauty2:
	trainer BEAUTY, BEAUTY_2, EVENT_BEAT_ROUTE_13_BEAUTY_2, Route13Beauty2SeenText, Route13Beauty2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route13Beauty2AfterBattleText
	waitbutton
	closetext
	end

TrainerBiker9:
	trainer BIKER, BIKER_9, EVENT_BEAT_ROUTE_13_BIKER_9, Route13Biker9SeenText, Route13Biker9BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route13Biker9AfterBattleText
	waitbutton
	closetext
	end

TrainerBirdKeeper6:
	trainer BIRD_KEEPER, BIRD_KEEPER_6, EVENT_BEAT_ROUTE_13_BIRD_KEEPER_6, Route13BirdKeeper6SeenText, Route13BirdKeeper6BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route13BirdKeeper6AfterBattleText
	waitbutton
	closetext
	end

Route13TrainerTips1:
	jumptext Route13TrainerTips1Text

Route13TrainerTips2:
	jumptext Route13TrainerTips2Text

Route13Sign:
	jumptext Route13SignText

; Kanto hack (M7 10c): Yellow's two ROUTE 13 hidden items,
; data/events/hidden_events.asm -- a PP UP at (1,14) and a CALCIUM at (16,13).
; Crystal put its own hidden CALCIUM at (30,13), which is not Yellow's tile.
Route13HiddenPPUp:
	hiddenitem PP_UP, EVENT_ROUTE_13_HIDDEN_PP_UP

Route13HiddenCalcium:
	hiddenitem CALCIUM, EVENT_ROUTE_13_HIDDEN_CALCIUM

Route13BirdKeeper4SeenText:
	text "My bird #MON"
	line "want to scrap!"
	done

Route13BirdKeeper4BeatenText:
	text "My"
	line "bird combo lost?"
	done

Route13BirdKeeper4AfterBattleText:
	text "My #MON look"
	line "happy even though"
	cont "they lost."
	done

Route13Picnicker1SeenText:
	text "I'm told I'm good"
	line "for a kid!"
	done

Route13Picnicker1BeatenText:
	text "Ohh!"
	line "I lost!"
	done

Route13Picnicker1AfterBattleText:
	text "I want to become"
	line "a good trainer."
	cont "I'll train hard."
	done

Route13Picnicker2SeenText:
	text "Wow! Your BADGEs"
	line "are too cool!"
	done

Route13Picnicker2BeatenText:
	text "Not"
	line "enough!"
	done

Route13Picnicker2AfterBattleText:
	text "You got those"
	line "BADGEs from GYM"
	cont "LEADERs. I know!"
	done

Route13Picnicker3SeenText:
	text "My cute #MON"
	line "wish to make your"
	cont "acquaintance."
	done

Route13Picnicker3BeatenText:
	text "Wow!"
	line "You totally won!"
	done

Route13Picnicker3AfterBattleText:
	text "You have to make"
	line "#MON fight to"
	cont "toughen them up!"
	done

Route13Picnicker4SeenText:
	text "I found CARBOS in"
	line "a cave once."
	done

Route13Picnicker4BeatenText:
	text "Just"
	line "messed up!"
	done

Route13Picnicker4AfterBattleText:
	text "CARBOS boosted"
	line "the SPEED of my"
	cont "#MON."
	done

Route13BirdKeeper5SeenText:
	text "The wind's blowing"
	line "my way!"
	done

Route13BirdKeeper5BeatenText:
	text "The"
	line "wind turned!"
	done

Route13BirdKeeper5AfterBattleText:
	text "I'm beat. I guess"
	line "I'll FLY home."
	done

Route13Beauty1SeenText:
	text "Sure, I'll play"
	line "with you!"
	done

Route13Beauty1BeatenText:
	text "Oh!"
	line "You little brute!"
	done

Route13Beauty1AfterBattleText:
	text "I wonder which is"
	line "stronger, male or"
	cont "female #MON?"
	done

Route13Beauty2SeenText:
	text "Do you want to"
	line "#MON with me?"
	done

Route13Beauty2BeatenText:
	text "It's over"
	line "already?"
	done

Route13Beauty2AfterBattleText:
	text "I don't know"
	line "anything about"
	cont "#MON. I just"
	cont "like cool ones!"
	done

Route13Biker9SeenText:
	text "What're you"
	line "lookin' at?"
	done

Route13Biker9BeatenText:
	text "Dang!"
	line "Stripped gears!"
	done

Route13Biker9AfterBattleText:
	text "Get lost!"
	done

Route13BirdKeeper6SeenText:
	text "I always go with"
	line "bird #MON!"
	done

Route13BirdKeeper6BeatenText:
	text "Out"
	line "of power!"
	done

Route13BirdKeeper6AfterBattleText:
	text "I wish I could"
	line "fly like PIDGEY"
	cont "and PIDGEOTTO..."
	done

Route13TrainerTips1Text:
	text "TRAINER TIPS"

	para "Look to the left"
	line "of that post!"
	done

Route13TrainerTips2Text:
	text "TRAINER TIPS"

	para "Use SELECT to"
	line "switch items in"
	cont "the ITEM window!"
	done

Route13SignText:
	text "ROUTE 13"
	line "North to SILENCE"
	cont "BRIDGE"
	done

Route13_MapEvents:
	db 0, 0 ; filler

	def_warp_events

	def_coord_events

	def_bg_events
	bg_event 15, 13, BGEVENT_READ, Route13TrainerTips1
	bg_event 33,  5, BGEVENT_READ, Route13TrainerTips2
	bg_event 31, 11, BGEVENT_READ, Route13Sign
	bg_event  1, 14, BGEVENT_ITEM, Route13HiddenPPUp
	bg_event 16, 13, BGEVENT_ITEM, Route13HiddenCalcium

	def_object_events
	object_event 49, 10, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerBirdKeeper4, -1
	object_event 48, 10, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerPicnicker1, -1
	object_event 27,  9, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerPicnicker2, -1
	object_event 23, 10, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerPicnicker3, -1
	object_event 50,  5, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerPicnicker4, -1
	object_event 12,  4, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerBirdKeeper5, -1
	object_event 33,  6, SPRITE_BEAUTY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 4, TrainerBeauty1, -1
	object_event 32,  6, SPRITE_BEAUTY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, TrainerBeauty2, -1
	object_event 10,  7, SPRITE_BIKER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 2, TrainerBiker9, -1
	object_event  7, 13, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerBirdKeeper6, -1
