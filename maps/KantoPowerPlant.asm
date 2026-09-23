; POWER PLANT (M10 13l): Yellow's 20x18 POWER_PLANT on TILESET_KANTO_FACILITY.
;
; The .blk is Yellow's verbatim (scripts/celadon_blk.py), except block (0,5):
; Yellow's warp 3 at (0,11) is a live west-edge exit (walking LEFT off (1,11)
; leaves, verified in the Yellow harness), and Crystal only fires an edge warp
; from a WARP_CARPET tile, so (0,5) is $9B, a clone of $70 whose bottom-left
; quadrant is WARP_CARPET_LEFT.  Warps 1-2 are Yellow's south door, $2c's
; WARP_CARPET_DOWN pair.  All three are Yellow's LAST_MAP, 4 = ROUTE 10's door.
;
; Crystal's own POWER_PLANT (the Johto-era plant with the MANAGER) is untouched;
; M11 decides its fate.  It still warps to ROUTE_10, 4 but nothing warps to it.
;
; Objects are Yellow's, in Yellow's order
; (vendor/pokeyellow/data/maps/objects/PowerPlant.asm).  The eight POKe BALLs
; in Yellow's first eight slots are VOLTORB/ELECTRODE: Yellow wires them as
; sight-0 "trainers" whose battle is a wild one, and EndTrainerBattle sets
; their EVENT_BEAT_POWER_PLANT_VOLTORB_n (= hides them) on a win, a catch or a
; run; only a blackout leaves one standing.  Here each is an OBJECTTYPE_SCRIPT
; that runs the same MOLTRES-style wild battle (13g), hidden on anything but
; LOSE.  Yellow's text is "Bzzzt!" with no cry; ZAPDOS says "Gyaoo!" + its cry.

MACRO power_plant_fake_ball
; species, level, event flag, object const
	opentext
	writetext PowerPlantVoltorbText
	waitbutton
	closetext
	loadwildmon \1, \2
	loadvar VAR_BATTLETYPE, BATTLETYPE_NORMAL
	startbattle
	ifequal LOSE, PowerPlantFainted
	setevent \3 ; = the object's hide flag
	disappear \4
	reloadmapafterbattle
	end
ENDM

	object_const_def
	const KANTOPOWERPLANT_VOLTORB1
	const KANTOPOWERPLANT_VOLTORB2
	const KANTOPOWERPLANT_VOLTORB3
	const KANTOPOWERPLANT_ELECTRODE1
	const KANTOPOWERPLANT_VOLTORB4
	const KANTOPOWERPLANT_VOLTORB5
	const KANTOPOWERPLANT_ELECTRODE2
	const KANTOPOWERPLANT_VOLTORB6
	const KANTOPOWERPLANT_ZAPDOS
	const KANTOPOWERPLANT_CARBOS
	const KANTOPOWERPLANT_HP_UP
	const KANTOPOWERPLANT_RARE_CANDY
	const KANTOPOWERPLANT_TM_THUNDER
	const KANTOPOWERPLANT_TM_REFLECT

KantoPowerPlant_MapScripts:
	def_scene_scripts

	def_callbacks

PowerPlantVoltorb1:
	power_plant_fake_ball VOLTORB, 40, EVENT_BEAT_POWER_PLANT_VOLTORB_0, KANTOPOWERPLANT_VOLTORB1

PowerPlantVoltorb2:
	power_plant_fake_ball VOLTORB, 40, EVENT_BEAT_POWER_PLANT_VOLTORB_1, KANTOPOWERPLANT_VOLTORB2

PowerPlantVoltorb3:
	power_plant_fake_ball VOLTORB, 40, EVENT_BEAT_POWER_PLANT_VOLTORB_2, KANTOPOWERPLANT_VOLTORB3

PowerPlantElectrode1:
	power_plant_fake_ball ELECTRODE, 43, EVENT_BEAT_POWER_PLANT_VOLTORB_3, KANTOPOWERPLANT_ELECTRODE1

PowerPlantVoltorb4:
	power_plant_fake_ball VOLTORB, 40, EVENT_BEAT_POWER_PLANT_VOLTORB_4, KANTOPOWERPLANT_VOLTORB4

PowerPlantVoltorb5:
	power_plant_fake_ball VOLTORB, 40, EVENT_BEAT_POWER_PLANT_VOLTORB_5, KANTOPOWERPLANT_VOLTORB5

PowerPlantElectrode2:
	power_plant_fake_ball ELECTRODE, 43, EVENT_BEAT_POWER_PLANT_VOLTORB_6, KANTOPOWERPLANT_ELECTRODE2

PowerPlantVoltorb6:
	power_plant_fake_ball VOLTORB, 40, EVENT_BEAT_POWER_PLANT_VOLTORB_7, KANTOPOWERPLANT_VOLTORB6

PowerPlantZapdos:
; M10 13g's MOLTRES pattern.  A KO or a catch is WIN, a run is DRAW: all
; three hide it (Yellow's EndTrainerBattle); a blackout leaves it standing.
	faceplayer
	opentext
	writetext PowerPlantZapdosText
	cry ZAPDOS
	waitbutton
	closetext
	loadwildmon ZAPDOS, 50
	loadvar VAR_BATTLETYPE, BATTLETYPE_NORMAL
	startbattle
	ifequal LOSE, PowerPlantFainted
	setevent EVENT_BEAT_ZAPDOS ; = the object's hide flag
	disappear KANTOPOWERPLANT_ZAPDOS
	reloadmapafterbattle
	end

PowerPlantFainted:
	reloadmapafterbattle ; jp's straight to the whiteout
	end

PowerPlantCarbos:
	itemball CARBOS

PowerPlantHPUp:
	itemball HP_UP

PowerPlantRareCandy:
	itemball RARE_CANDY

PowerPlantTMThunder:
	itemball TM_THUNDER

PowerPlantTMReflect:
	itemball TM_REFLECT

PowerPlantHiddenMaxElixer:
	hiddenitem MAX_ELIXER, EVENT_POWER_PLANT_HIDDEN_MAX_ELIXER

PowerPlantHiddenPPUp:
	hiddenitem PP_UP, EVENT_POWER_PLANT_HIDDEN_PP_UP

PowerPlantVoltorbText:
	text "Bzzzt!"
	done

PowerPlantZapdosText:
	text "Gyaoo!"
	done

KantoPowerPlant_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 35, ROUTE_10, 4
	warp_event  5, 35, ROUTE_10, 4
	warp_event  0, 11, ROUTE_10, 4 ; west edge, WARP_CARPET_LEFT ($9B)

	def_coord_events

	def_bg_events
	bg_event 17, 16, BGEVENT_ITEM, PowerPlantHiddenMaxElixer ; Yellow data/events/hidden_events.asm
	bg_event 12,  1, BGEVENT_ITEM, PowerPlantHiddenPPUp

	def_object_events
	object_event  9, 20, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PowerPlantVoltorb1, EVENT_BEAT_POWER_PLANT_VOLTORB_0
	object_event 32, 18, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PowerPlantVoltorb2, EVENT_BEAT_POWER_PLANT_VOLTORB_1
	object_event 21, 25, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PowerPlantVoltorb3, EVENT_BEAT_POWER_PLANT_VOLTORB_2
	object_event 25, 18, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PowerPlantElectrode1, EVENT_BEAT_POWER_PLANT_VOLTORB_3
	object_event 23, 34, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PowerPlantVoltorb4, EVENT_BEAT_POWER_PLANT_VOLTORB_4
	object_event 26, 28, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PowerPlantVoltorb5, EVENT_BEAT_POWER_PLANT_VOLTORB_5
	object_event 21, 14, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PowerPlantElectrode2, EVENT_BEAT_POWER_PLANT_VOLTORB_6
	object_event 37, 32, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PowerPlantVoltorb6, EVENT_BEAT_POWER_PLANT_VOLTORB_7
	object_event  4,  9, SPRITE_MOLTRES, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_YELLOW, OBJECTTYPE_SCRIPT, 0, PowerPlantZapdos, EVENT_BEAT_ZAPDOS ; SPRITE_MOLTRES in the follower's yellow, as ARTICUNO wears it in blue
	object_event  7, 25, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PowerPlantCarbos, EVENT_POWER_PLANT_CARBOS
	object_event 28,  3, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PowerPlantHPUp, EVENT_POWER_PLANT_HP_UP
	object_event 34,  3, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PowerPlantRareCandy, EVENT_POWER_PLANT_RARE_CANDY
	object_event 26, 32, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PowerPlantTMThunder, EVENT_POWER_PLANT_TM_THUNDER
	object_event 20, 32, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, PowerPlantTMReflect, EVENT_POWER_PLANT_TM_REFLECT
