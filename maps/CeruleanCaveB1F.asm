; CERULEAN CAVE B1F (M10P, docs/M10P-CERULEAN-CAVE.md): Yellow's 15x9
; CERULEAN_CAVE_B1F on TILESET_KANTO_CAVE, cut by scripts/ct1_kanto_cave.py
; (YELLOW_MAPS).  One ladder up to 1F.
;
; MEWTWO: Yellow wires it as a sight-0 "trainer" (EVENT_BEAT_MEWTWO) whose
; battle is a wild Lv70 MEWTWO; its text is "Mew!" + MEWTWO's cry, and
; EndTrainerBattle sets the flag (= hides it) on a KO, a catch or a run -- only
; a blackout leaves it standing.  Here it is the M10 13g/13l legendary pattern
; (KantoPowerPlant.asm's ZAPDOS): a KO or a catch is WIN, a run is DRAW, all
; three hide it; LOSE leaves it for the next visit.
	object_const_def
	const CERULEANCAVEB1F_MEWTWO
	const CERULEANCAVEB1F_ULTRA_BALL1
	const CERULEANCAVEB1F_ULTRA_BALL2
	const CERULEANCAVEB1F_MAX_REVIVE
	const CERULEANCAVEB1F_MAX_ELIXER

CeruleanCaveB1F_MapScripts:
	def_scene_scripts

	def_callbacks

CeruleanCaveB1FMewtwo:
	faceplayer
	opentext
	writetext CeruleanCaveB1FMewtwoText
	cry MEWTWO
	waitbutton
	closetext
	loadwildmon MEWTWO, 70
	loadvar VAR_BATTLETYPE, BATTLETYPE_NORMAL
	startbattle
	ifequal LOSE, .Fainted
	setevent EVENT_BEAT_MEWTWO ; = the object's hide flag
	disappear CERULEANCAVEB1F_MEWTWO
	reloadmapafterbattle
	end

.Fainted:
	reloadmapafterbattle ; jp's straight to the whiteout
	end

CeruleanCaveB1FUltraBall1:
	itemball ULTRA_BALL

CeruleanCaveB1FUltraBall2:
	itemball ULTRA_BALL

CeruleanCaveB1FMaxRevive:
	itemball MAX_REVIVE

CeruleanCaveB1FMaxElixer:
	itemball MAX_ELIXER

CeruleanCaveB1FHiddenPPUp:
	hiddenitem PP_UP, EVENT_CERULEAN_CAVE_B1F_HIDDEN_PP_UP

CeruleanCaveB1FMewtwoText:
	text "Mew!"
	done

CeruleanCaveB1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  6, CERULEAN_CAVE_1F, 9

	def_coord_events

	def_bg_events
	bg_event  8, 14, BGEVENT_ITEM, CeruleanCaveB1FHiddenPPUp

	def_object_events
	object_event 27, 13, SPRITE_MONSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeruleanCaveB1FMewtwo, EVENT_BEAT_MEWTWO
	object_event 26,  1, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCaveB1FUltraBall1, EVENT_CERULEAN_CAVE_B1F_ULTRA_BALL_1
	object_event  2, 13, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCaveB1FUltraBall2, EVENT_CERULEAN_CAVE_B1F_ULTRA_BALL_2
	object_event  3, 13, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCaveB1FMaxRevive, EVENT_CERULEAN_CAVE_B1F_MAX_REVIVE
	object_event 15,  3, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, CeruleanCaveB1FMaxElixer, EVENT_CERULEAN_CAVE_B1F_MAX_ELIXER
