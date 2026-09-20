; Kanto hack (M6 9x, docs/M6-CELADON.md 3.4): Yellow's ROCKET_HIDEOUT_B3F
; population -- two Rockets, two item balls and one hidden item, at Yellow's
; own coordinates (vendor/pokeyellow/data/maps/objects/RocketHideoutB3F.asm).
;
; Sight ranges 2 and 4 are Yellow's `trainer` second arguments.
	object_const_def
	const ROCKETHIDEOUTB3F_ROCKET1
	const ROCKETHIDEOUTB3F_ROCKET2
	const ROCKETHIDEOUTB3F_TM_DOUBLE_EDGE
	const ROCKETHIDEOUTB3F_RARE_CANDY

RocketHideoutB3F_MapScripts:
	def_scene_scripts

	def_callbacks

TrainerRocketHideoutB3FRocket1:
	trainer GRUNTM, GRUNTM_37, EVENT_BEAT_ROCKET_HIDEOUT_B3F_ROCKET_1, RocketHideoutB3FRocket1SeenText, RocketHideoutB3FRocket1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext RocketHideoutB3FRocket1AfterBattleText
	waitbutton
	closetext
	end

TrainerRocketHideoutB3FRocket2:
	trainer GRUNTM, GRUNTM_38, EVENT_BEAT_ROCKET_HIDEOUT_B3F_ROCKET_2, RocketHideoutB3FRocket2SeenText, RocketHideoutB3FRocket2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext RocketHideoutB3FRocket2AfterBattleText
	waitbutton
	closetext
	end

; Yellow's TM10 DOUBLE-EDGE.  Our TM union (M3b, docs/TM-LEDGER.md) parks the
; Yellow-only TM moves on spare item ids: TM_DOUBLE_EDGE is TM59.
RocketHideoutB3FTMDoubleEdge:
	itemball TM_DOUBLE_EDGE

RocketHideoutB3FRareCandy:
	itemball RARE_CANDY

RocketHideoutB3FHiddenNugget:
	hiddenitem NUGGET, EVENT_ROCKET_HIDEOUT_B3F_HIDDEN_NUGGET

RocketHideoutB3FRocket1SeenText:
	text "Stop meddling in"
	line "TEAM ROCKET's"
	cont "affairs!"
	done

RocketHideoutB3FRocket1BeatenText:
	text "Oof!"
	line "Taken down!"
	prompt

RocketHideoutB3FRocket1AfterBattleText:
	text "SILPH SCOPE?"
	line "The machine the"
	cont "BOSS stole. It's"
	cont "here somewhere."
	done

RocketHideoutB3FRocket2SeenText:
	text "We got word from"
	line "upstairs that you"
	cont "were coming!"
	done

RocketHideoutB3FRocket2BeatenText:
	text "What?"
	line "I lost? No!"
	prompt

RocketHideoutB3FRocket2AfterBattleText:
	text "Go ahead and go!"
	line "But, you need the"
	cont "LIFT KEY to run"
	cont "the elevator!"
	done

RocketHideoutB3F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; Kanto hack (M6 9w): Yellow's warp table, tile for tile.  B3F has no lift
; door -- the panel deliberately skips it, so the only way in is the B2F
; staircase and the only way on is the one down to B4F.
	warp_event 25,  6, ROCKET_HIDEOUT_B2F, 2
	warp_event 19, 18, ROCKET_HIDEOUT_B4F, 1

	def_coord_events

	def_bg_events
	bg_event 27, 17, BGEVENT_ITEM, RocketHideoutB3FHiddenNugget ; Yellow's hidden NUGGET (data/events/hidden_events.asm:203)

	def_object_events
	object_event 10, 22, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerRocketHideoutB3FRocket1, -1
	object_event 26, 12, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerRocketHideoutB3FRocket2, -1
	object_event 26, 17, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, RocketHideoutB3FTMDoubleEdge, EVENT_ROCKET_HIDEOUT_B3F_TM_DOUBLE_EDGE
	object_event 20, 14, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, RocketHideoutB3FRareCandy, EVENT_ROCKET_HIDEOUT_B3F_RARE_CANDY
