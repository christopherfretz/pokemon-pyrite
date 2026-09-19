; Kanto hack: Yellow's SS_ANNE_1F_ROOMS (docs/M4-VERMILION.md, 7h).  Yellow's
; eleven SSAnne1FRooms_Object entries, in Yellow's object order, at Yellow's
; coordinates and facings, with Yellow's sight ranges from SSAnne8TrainerHeaders
; (2/3/2/2) and Yellow's before/win/after text verbatim.  Class substitutions
; are 5.4 (0 new classes); sprite substitutions follow the M2/M3 precedent.
;   Yellow ( 2, 3) GENTLEMAN 1     -> TrainerGentlemanTheodore, sight 2
;   Yellow (11, 4) GENTLEMAN 2     -> TrainerGentlemanBarton,   sight 3
;   Yellow (11,14) YOUNGSTER 8     -> TrainerYoungsterBenji,    sight 2
;   Yellow (13,11) LASS 11         -> TrainerLassOdette,        sight 2
;   Yellow (22, 3) SPRITE_GIRL           -> SPRITE_LASS
;   Yellow ( 0,14) SPRITE_MIDDLE_AGED_MAN-> SPRITE_POKEFAN_M
;   Yellow ( 2,11) SPRITE_LITTLE_GIRL    -> SPRITE_TWIN
;   Yellow ( 3,11) SPRITE_JIGGLYPUFF     -> SPRITE_JIGGLYPUFF_OW (ported in M3 6g)
;   Yellow (10,13) SPRITE_GIRL           -> SPRITE_LASS
;   Yellow (12,15) SPRITE_POKE_BALL      -> TM_BODY_SLAM item ball
;   Yellow (21,13) SPRITE_GENTLEMAN      -> SPRITE_GENTLEMAN (the GLOBAL POLICE agent)
; Eight distinct NPC sheets: 12 (player) + 7 x 12 (walking) + 4 (POKE_BALL,
; still) = 100 of the 108 sprite-VRAM tiles below FOLLOWER_VTILE.  No overflow.
	object_const_def
	const SSANNE1FROOMS_GENTLEMAN1
	const SSANNE1FROOMS_GENTLEMAN2
	const SSANNE1FROOMS_YOUNGSTER
	const SSANNE1FROOMS_COOLTRAINER_F
	const SSANNE1FROOMS_GIRL1
	const SSANNE1FROOMS_MIDDLE_AGED_MAN
	const SSANNE1FROOMS_LITTLE_GIRL
	const SSANNE1FROOMS_WIGGLYTUFF
	const SSANNE1FROOMS_GIRL2
	const SSANNE1FROOMS_POKE_BALL
	const SSANNE1FROOMS_GENTLEMAN3

SSAnne1FRooms_MapScripts:
	def_scene_scripts

	def_callbacks

TrainerGentlemanTheodore:
	trainer GENTLEMAN, THEODORE, EVENT_BEAT_GENTLEMAN_THEODORE, GentlemanTheodoreSeenText, GentlemanTheodoreBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext GentlemanTheodoreAfterBattleText
	waitbutton
	closetext
	end

TrainerGentlemanBarton:
	trainer GENTLEMAN, BARTON, EVENT_BEAT_GENTLEMAN_BARTON, GentlemanBartonSeenText, GentlemanBartonBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext GentlemanBartonAfterBattleText
	waitbutton
	closetext
	end

TrainerYoungsterBenji:
	trainer YOUNGSTER, BENJI, EVENT_BEAT_YOUNGSTER_BENJI, YoungsterBenjiSeenText, YoungsterBenjiBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext YoungsterBenjiAfterBattleText
	waitbutton
	closetext
	end

TrainerLassOdette:
	trainer LASS, ODETTE, EVENT_BEAT_LASS_ODETTE, LassOdetteSeenText, LassOdetteBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassOdetteAfterBattleText
	waitbutton
	closetext
	end

SSAnne1FRoomsGirl1Script:
	jumptextfaceplayer SSAnne1FRoomsGirl1Text

SSAnne1FRoomsMiddleAgedManScript:
	jumptextfaceplayer SSAnne1FRoomsMiddleAgedManText

SSAnne1FRoomsLittleGirlScript:
	jumptextfaceplayer SSAnne1FRoomsLittleGirlText

; Yellow plays WIGGLYTUFF's cry after printing the line (the text ends in "@",
; then PlayCry), the same shape as Vermilion City's MACHOP.
SSAnne1FRoomsWigglytuffScript:
	opentext
	writetext SSAnne1FRoomsWigglytuffText
	cry WIGGLYTUFF
	waitbutton
	closetext
	end

SSAnne1FRoomsGirl2Script:
	jumptextfaceplayer SSAnne1FRoomsGirl2Text

SSAnne1FRoomsTMBodySlam:
	itemball TM_BODY_SLAM

SSAnne1FRoomsGentleman3Script:
	jumptextfaceplayer SSAnne1FRoomsGentleman3Text

GentlemanTheodoreSeenText:
	text "I travel alone"
	line "on my journeys!"

	para "My #MON are my"
	line "only friends!"
	done

GentlemanTheodoreBeatenText:
	text "My, my"
	line "friends…"
	done

GentlemanTheodoreAfterBattleText:
	text "You should be"
	line "nice to friends!"
	done

GentlemanBartonSeenText:
	text "You pup! How dare"
	line "you barge in!"
	done

GentlemanBartonBeatenText:
	text "Humph!"
	line "You rude child!"
	done

GentlemanBartonAfterBattleText:
	text "I wish to be left"
	line "alone! Get out!"
	done

YoungsterBenjiSeenText:
	text "I love #MON!"
	line "Do you?"
	done

YoungsterBenjiBeatenText:
	text "Wow! "
	line "You're great!"
	done

YoungsterBenjiAfterBattleText:
	text "Let me be your"
	line "friend, OK?"

	para "Then we can trade"
	line "#MON!"
	done

LassOdetteSeenText:
	text "I collected these"
	line "#MON from all"
	cont "around the world!"
	done

LassOdetteBeatenText:
	text "Oh no!"
	line "I went around the"
	cont "world for these!"
	done

LassOdetteAfterBattleText:
	text "You hurt my poor"
	line "worldly #MON!"

	para "I demand that you"
	line "heal them at a"
	cont "#MON CENTER!"
	done

SSAnne1FRoomsGirl1Text:
	text "Waiter, I would"
	line "like a cherry pie"
	cont "please!"
	done

SSAnne1FRoomsMiddleAgedManText:
	text "A cruise is so"
	line "elegant yet cozy!"
	done

SSAnne1FRoomsLittleGirlText:
	text "I always travel"
	line "with WIGGLYTUFF!"
	done

SSAnne1FRoomsWigglytuffText:
	text "WIGGLYTUFF: Puup"
	line "pupuu!"
	done

SSAnne1FRoomsGirl2Text:
	text "We are cruising"
	line "around the world."
	done

SSAnne1FRoomsGentleman3Text:
	text "Ssh! I'm a GLOBAL"
	line "POLICE agent!"

	para "I'm on the trail"
	line "of TEAM ROCKET!"
	done

SSAnne1FRooms_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  0,  0, SS_ANNE_1F, 3
	warp_event 10,  0, SS_ANNE_1F, 4
	warp_event 20,  0, SS_ANNE_1F, 5
	warp_event  0, 10, SS_ANNE_1F, 6
	warp_event 10, 10, SS_ANNE_1F, 7
	warp_event 20, 10, SS_ANNE_1F, 8

	def_coord_events

	def_bg_events

	def_object_events
	object_event  2,  3, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, TrainerGentlemanTheodore, -1
	object_event 11,  4, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerGentlemanBarton, -1
	object_event 11, 14, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, TrainerYoungsterBenji, -1
	object_event 13, 11, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerLassOdette, -1
	object_event 22,  3, SPRITE_LASS, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, SSAnne1FRoomsGirl1Script, -1
	object_event  0, 14, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, SSAnne1FRoomsMiddleAgedManScript, -1
	object_event  2, 11, SPRITE_TWIN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SSAnne1FRoomsLittleGirlScript, -1
	object_event  3, 11, SPRITE_JIGGLYPUFF_OW, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SSAnne1FRoomsWigglytuffScript, -1
	object_event 10, 13, SPRITE_LASS, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, SSAnne1FRoomsGirl2Script, -1
	object_event 12, 15, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SSAnne1FRoomsTMBodySlam, EVENT_SS_ANNE_1F_ROOMS_TM_BODY_SLAM
	object_event 21, 13, SPRITE_GENTLEMAN, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnne1FRoomsGentleman3Script, -1
