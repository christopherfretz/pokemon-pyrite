	object_const_def
	const CELADONGYM_ERIKA
	const CELADONGYM_COOLTRAINER_F1
	const CELADONGYM_BEAUTY1
	const CELADONGYM_COOLTRAINER_F2
	const CELADONGYM_BEAUTY2
	const CELADONGYM_COOLTRAINER_F3
	const CELADONGYM_BEAUTY3
	const CELADONGYM_COOLTRAINER_F4

CeladonGym_MapScripts:
	def_scene_scripts

	def_callbacks

; Kanto hack (M6 9q, docs/M6-CELADON.md 3.2): Yellow's CELADON GYM has no gym
; guide and no switches.  The gimmick is the planter maze: ERIKA and three of
; her seven trainers sit inside a sealed 4x4 courtyard whose only three
; openings are cuttable gym plants at (2,4), (7,5) and (5,7).  Yellow allows
; CUT on tile $50 in the GYM tileset (vendor/pokeyellow/engine/overworld/cut.asm);
; ours are COLL_CUT_TREE quadrants in blocks $48/$49/$4a of
; TILESET_TRAIN_STATION, wired up in data/collision/field_move_blocks.asm.
CeladonGymErikaScript:
	faceplayer
	opentext
	checkflag ENGINE_RAINBOWBADGE
	iftrue .FightDone
	writetext ErikaIntroText
	waitbutton
	closetext
	winlosstext ErikaWinLossText, 0
	loadtrainer ERIKA, ERIKA1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_ERIKA
	; Yellow's SetEventRange EVENT_BEAT_CELADON_GYM_TRAINER_0 ..
	; EVENT_BEAT_CELADON_GYM_TRAINER_6 -- beating ERIKA retires all seven gym
	; trainers, so a player who cut straight through to her is not walled in.
	setevent EVENT_BEAT_LASS_MICHELLE
	setevent EVENT_BEAT_BEAUTY_LILY
	setevent EVENT_BEAT_PICNICKER_TANYA
	setevent EVENT_BEAT_BEAUTY_JULIA
	setevent EVENT_BEAT_LASS_HOLLY
	setevent EVENT_BEAT_BEAUTY_POPPY
	setevent EVENT_BEAT_COOLTRAINERF_IVY
	opentext
	writetext ReceivedRainbowBadgeText
	playsound SFX_GET_BADGE
	waitsfx
	setflag ENGINE_RAINBOWBADGE
	writetext ErikaRainbowBadgeText
	waitbutton
.FightDone:
	checkevent EVENT_GOT_TM21_MEGA_DRAIN
	iftrue .GotTM21
	writetext ErikaTakeThisText
	promptbutton
	verbosegiveitem TM_MEGA_DRAIN
	iffalse .NoRoomForTM
	setevent EVENT_GOT_TM21_MEGA_DRAIN
	writetext ErikaTM21ExplanationText
	waitbutton
	closetext
	end

.GotTM21:
	writetext ErikaPostBattleAdviceText
	waitbutton
	closetext
	end

.NoRoomForTM:
	writetext ErikaTM21NoRoomText
	waitbutton
	closetext
	end

TrainerLassMichelle:
	trainer LASS, MICHELLE, EVENT_BEAT_LASS_MICHELLE, LassMichelleSeenText, LassMichelleBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassMichelleAfterBattleText
	waitbutton
	closetext
	end

TrainerBeautyLily:
	trainer BEAUTY, LILY, EVENT_BEAT_BEAUTY_LILY, BeautyLilySeenText, BeautyLilyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BeautyLilyAfterBattleText
	waitbutton
	closetext
	end

TrainerPicnickerTanya:
	trainer PICNICKER, TANYA, EVENT_BEAT_PICNICKER_TANYA, PicnickerTanyaSeenText, PicnickerTanyaBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext PicnickerTanyaAfterBattleText
	waitbutton
	closetext
	end

TrainerBeautyJulia:
	trainer BEAUTY, JULIA, EVENT_BEAT_BEAUTY_JULIA, BeautyJuliaSeenText, BeautyJuliaBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BeautyJuliaAfterBattleText
	waitbutton
	closetext
	end

TrainerLassHolly:
	trainer LASS, HOLLY, EVENT_BEAT_LASS_HOLLY, LassHollySeenText, LassHollyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassHollyAfterBattleText
	waitbutton
	closetext
	end

TrainerBeautyPoppy:
	trainer BEAUTY, POPPY, EVENT_BEAT_BEAUTY_POPPY, BeautyPoppySeenText, BeautyPoppyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BeautyPoppyAfterBattleText
	waitbutton
	closetext
	end

TrainerCooltrainerfIvy:
	trainer COOLTRAINERF, IVY, EVENT_BEAT_COOLTRAINERF_IVY, CooltrainerfIvySeenText, CooltrainerfIvyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext CooltrainerfIvyAfterBattleText
	waitbutton
	closetext
	end

CeladonGymStatue:
	; Kanto hack (N1a): Yellow's pre-badge statue names the LEADER too
	; (_GymStatueText1), so wStringBuffer4 must be filled for BOTH statues.
	gettrainername STRING_BUFFER_4, ERIKA, ERIKA1
	checkflag ENGINE_RAINBOWBADGE
	iftrue .Beaten
	jumpstd GymStatue1Script
.Beaten:
	jumpstd GymStatue2Script

ErikaIntroText:
	text "ERIKA: Hello."
	line "Lovely weather"
	cont "isn't it? It's so"
	cont "pleasant."

	para "…Oh dear…"
	line "I must have dozed"
	cont "off. Welcome."

	para "My name is ERIKA."
	line "I am the LEADER"
	cont "of CELADON GYM."

	para "I teach the art of"
	line "flower arranging."
	cont "My #MON are of"
	cont "the grass-type."

	para "Oh, I'm sorry, I"
	line "had no idea that"
	cont "you wished to"
	cont "challenge me."

	para "Very well, but I"
	line "shall not lose."
	done

ErikaWinLossText:
	text "ERIKA: Oh!"
	line "I concede defeat."

	para "You are remarkably"
	line "strong."

	para "I must confer you"
	line "the RAINBOWBADGE."
	done

ReceivedRainbowBadgeText:
	text "<PLAYER> received"
	line "RAINBOWBADGE."
	done

ErikaRainbowBadgeText:
	text "ERIKA: The"
	line "RAINBOWBADGE"

	para "will make #MON"
	line "up to L50 obey."

	para "It also allows"
	line "#MON to use"
	cont "STRENGTH in and"
	cont "out of battle."
	done

ErikaTakeThisText:
	text "ERIKA: Please also"
	line "take this with"
	cont "you."
	done

ErikaTM21ExplanationText:
; Yellow says "TM21"; our TM union numbers MEGA DRAIN as TM67
; (docs/TM-LEDGER.md, docs/M3B-TM-UNION.md) — same treatment as Misty's TM60
; and Surge's TM86.
	text "TM67 contains"
	line "MEGA DRAIN."

	para "Half the damage"
	line "it inflicts is"
	cont "drained to heal"
	cont "your #MON!"
	done

ErikaTM21NoRoomText:
	text "ERIKA: You should"
	line "make room for"
	cont "this."
	done

ErikaPostBattleAdviceText:
	text "ERIKA: You are"
	line "cataloging"
	cont "#MON? I must"
	cont "say I'm impressed."

	para "I would never"
	line "collect #MON"
	cont "if they were"
	cont "unattractive."
	done

LassMichelleSeenText:
	text "Hey!"

	para "You are not"
	line "allowed in here!"
	done

LassMichelleBeatenText:
	text "You're"
	line "too rough!"
	done

LassMichelleAfterBattleText:
	text "Bleaah!"
	line "I hope ERIKA"
	cont "wipes you out!"
	done

BeautyLilySeenText:
	text "I was getting"
	line "bored."
	done

BeautyLilyBeatenText:
	text "My"
	line "makeup!"
	done

BeautyLilyAfterBattleText:
	text "Grass-type #MON"
	line "are tough against"
	cont "the water-type!"

	para "They also have an"
	line "edge on rock and"
	cont "ground #MON!"
	done

PicnickerTanyaSeenText:
	text "Aren't you the"
	line "peeping Tom?"
	done

PicnickerTanyaBeatenText:
	text "I'm"
	line "in shock!"
	done

PicnickerTanyaAfterBattleText:
	text "Oh, you weren't"
	line "peeping? We get a"
	cont "lot of gawkers!"
	done

BeautyJuliaSeenText:
	text "Look at my grass"
	line "#MON!"

	para "They're so easy"
	line "to raise!"
	done

BeautyJuliaBeatenText:
	text "No!"
	done

BeautyJuliaAfterBattleText:
	text "We only use grass-"
	line "type #MON at"
	cont "our GYM!"

	para "We also use them"
	line "for making flower"
	cont "arrangements!"
	done

LassHollySeenText:
	text "Don't bring any"
	line "bugs or fire"
	cont "#MON in here!"
	done

LassHollyBeatenText:
	text "Oh!"
	line "You!"
	done

LassHollyAfterBattleText:
	text "Our LEADER, ERIKA,"
	line "might be quiet,"
	cont "but she's also"
	cont "very skilled!"
	done

BeautyPoppySeenText:
	text "Pleased to meet"
	line "you. My hobby is"
	cont "#MON training."
	done

BeautyPoppyBeatenText:
	text "Oh!"
	line "Splendid!"
	done

BeautyPoppyAfterBattleText:
	text "I have a blind"
	line "date coming up."
	cont "I have to learn"
	cont "to be polite."
	done

CooltrainerfIvySeenText:
	text "Welcome to"
	line "CELADON GYM!"

	para "You better not"
	line "underestimate"
	cont "girl power!"
	done

CooltrainerfIvyBeatenText:
	text "Oh!"
	line "Beaten!"
	done

CooltrainerfIvyAfterBattleText:
	text "I didn't bring my"
	line "best #MON!"

	para "Wait 'til next"
	line "time!"
	done

CeladonGym_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 17, CELADON_CITY, 7 ; Kanto hack (M6 9p): Yellow's city warp 7
	warp_event  5, 17, CELADON_CITY, 7

	def_coord_events

	def_bg_events
	bg_event  3, 15, BGEVENT_READ, CeladonGymStatue
	bg_event  6, 15, BGEVENT_READ, CeladonGymStatue

	def_object_events
; Kanto hack (M6 9q): Yellow's eight objects, at Yellow's coordinates and
; facings (vendor/pokeyellow/data/maps/objects/CeladonGym.asm).  Sight ranges
; are Yellow's own per-trainer view_range values from CeladonGymTrainerHeaders
; (2, 2, 4, 4, 2, 2, 3) -- docs/M6-CELADON.md 5.7 claims Gen 1 has no
; sight-range field and that gym trainers should get 0; the `trainer` macro
; carries one per header, so the survey is wrong there (see "## 9q findings").
; Yellow deliberately mismatches sprite and class -- SPRITE_COOLTRAINER_F NPCs
; battle as LASS / PICNICKER (Yellow's JR.TRAINER-f) / COOLTRAINERF.  Kept.
	object_event  4,  3, SPRITE_ERIKA, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonGymErikaScript, -1
	object_event  2, 11, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerLassMichelle, -1
	object_event  7, 10, SPRITE_BEAUTY, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, TrainerBeautyLily, -1
	object_event  9,  5, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerPicnickerTanya, -1
	object_event  1,  5, SPRITE_BEAUTY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 4, TrainerBeautyJulia, -1
	object_event  6,  3, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerLassHolly, -1
	object_event  3,  3, SPRITE_BEAUTY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, TrainerBeautyPoppy, -1
	object_event  5,  3, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerCooltrainerfIvy, -1
