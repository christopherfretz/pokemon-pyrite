; Kanto hack (M6 9x, docs/M6-CELADON.md 3.4): Yellow's ROCKET_HIDEOUT_B2F
; population -- one Rocket and four item balls, at Yellow's own coordinates
; (vendor/pokeyellow/data/maps/objects/RocketHideoutB2F.asm).  No hidden items
; and no bg_events on this floor.
;
; Sight range 4 is Yellow's `trainer` second argument: he watches the whole
; length of the spin-maze lane he is standing in.
	object_const_def
	const ROCKETHIDEOUTB2F_ROCKET
	const ROCKETHIDEOUTB2F_MOON_STONE
	const ROCKETHIDEOUTB2F_NUGGET
	const ROCKETHIDEOUTB2F_TM_HORN_DRILL
	const ROCKETHIDEOUTB2F_SUPER_POTION

RocketHideoutB2F_MapScripts:
	def_scene_scripts

	def_callbacks

TrainerRocketHideoutB2FRocket:
	trainer GRUNTM, GRUNTM_36, EVENT_BEAT_ROCKET_HIDEOUT_B2F_ROCKET, RocketHideoutB2FRocketSeenText, RocketHideoutB2FRocketBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext RocketHideoutB2FRocketAfterBattleText
	waitbutton
	closetext
	end

RocketHideoutB2FMoonStone:
	itemball MOON_STONE

RocketHideoutB2FNugget:
	itemball NUGGET

; Yellow's TM07 HORN DRILL.  Our TM union (M3b, docs/TM-LEDGER.md) parks the
; Yellow-only TM moves on spare item ids: TM_HORN_DRILL is TM56.
RocketHideoutB2FTMHornDrill:
	itemball TM_HORN_DRILL

RocketHideoutB2FSuperPotion:
	itemball SUPER_POTION

RocketHideoutB2FRocketSeenText:
	text "BOSS said you can"
	line "see GHOSTs with"
	cont "the SILPH SCOPE!"
	done

RocketHideoutB2FRocketBeatenText:
	text "I"
	line "surrender!"
	prompt

RocketHideoutB2FRocketAfterBattleText:
	text "The TEAM ROCKET"
	line "HQ has 4 basement"
	cont "floors. Can you"
	cont "reach the BOSS?"
	done

RocketHideoutB2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; Kanto hack (M6 9w): Yellow's warp table, tile for tile.  1 and 4 are the two
; staircases back up to B1F, 2 is the staircase down to B3F, 3 and 5 the lift.
	warp_event 27,  8, ROCKET_HIDEOUT_B1F, 1
	warp_event 21,  8, ROCKET_HIDEOUT_B3F, 1
	warp_event 24, 19, ROCKET_HIDEOUT_ELEVATOR, 1
	warp_event 21, 22, ROCKET_HIDEOUT_B1F, 4
	warp_event 25, 19, ROCKET_HIDEOUT_ELEVATOR, 2

	def_coord_events

	def_bg_events

	def_object_events
	object_event 20, 12, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerRocketHideoutB2FRocket, -1
	object_event  1, 11, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, RocketHideoutB2FMoonStone, EVENT_ROCKET_HIDEOUT_B2F_MOON_STONE
	object_event 16,  8, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, RocketHideoutB2FNugget, EVENT_ROCKET_HIDEOUT_B2F_NUGGET
	object_event  6, 12, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, RocketHideoutB2FTMHornDrill, EVENT_ROCKET_HIDEOUT_B2F_TM_HORN_DRILL
	object_event  3, 21, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, RocketHideoutB2FSuperPotion, EVENT_ROCKET_HIDEOUT_B2F_SUPER_POTION
