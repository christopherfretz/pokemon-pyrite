	object_const_def
	const ROUTE22_RIVAL

; Kanto hack: Yellow's first Route 22 rival battle (docs/M2-ROUTE22.md).
; Crystal's Route 22 is a one-way loop, so the top corridor (rows 4-5,
; x 18..35) is only ever entered from the east at x=31. The rival waits at
; (21,5); stepping onto x=25 in either row brings him over, like Yellow's
; (29,4)/(29,5) pair. He exists only while the POKeDEX is in hand and the
; battle is unfought; the OBJECTS callback derives that on every map load.
Route22_MapScripts:
	def_scene_scripts
	scene_script Route22NoopScene,  SCENE_ROUTE22_NOOP
	scene_script Route22NoopScene,  SCENE_ROUTE22_RIVAL

	def_callbacks
	callback MAPCALLBACK_OBJECTS, Route22RivalCallback

Route22NoopScene:
	end

Route22RivalCallback:
	checkflag ENGINE_POKEDEX
	iffalse .Hide
	checkevent EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE
	iftrue .Hide
	clearevent EVENT_ROUTE22_RIVAL
	setscene SCENE_ROUTE22_RIVAL
	endcallback

.Hide:
	setevent EVENT_ROUTE22_RIVAL
	setscene SCENE_ROUTE22_NOOP
	endcallback

; Player on (25,4): the rival walks to (25,5), below the player.
Route22RivalSceneNorth:
	showemote EMOTE_SHOCK, ROUTE22_RIVAL, 15
	playmusic MUSIC_RIVAL_ENCOUNTER
	applymovement ROUTE22_RIVAL, Route22_RivalApproachNorth
	turnobject PLAYER, DOWN
	turnobject ROUTE22_RIVAL, UP
	scall Route22RivalBattle
	applymovement ROUTE22_RIVAL, Route22_RivalExitNorth
	sjump Route22RivalGone

; Player on (25,5): the rival walks to (24,5), left of the player.
Route22RivalSceneSouth:
	showemote EMOTE_SHOCK, ROUTE22_RIVAL, 15
	playmusic MUSIC_RIVAL_ENCOUNTER
	applymovement ROUTE22_RIVAL, Route22_RivalApproachSouth
	turnobject PLAYER, LEFT
	turnobject ROUTE22_RIVAL, RIGHT
	scall Route22RivalBattle
	applymovement ROUTE22_RIVAL, Route22_RivalExitSouth
	sjump Route22RivalGone

; Losing is a normal white-out (Yellow: the rival stays and re-triggers).
Route22RivalBattle:
	opentext
	writetext Route22RivalBeforeBattleText
	waitbutton
	closetext
	winlosstext Route22RivalWinText, Route22RivalLossText
	setlasttalked ROUTE22_RIVAL
	loadtrainer KANTO_RIVAL, KANTO_RIVAL_2
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	setevent EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE
	playmusic MUSIC_RIVAL_AFTER
	opentext
	writetext Route22RivalAfterBattleText
	waitbutton
	closetext
	return

Route22RivalGone:
	disappear ROUTE22_RIVAL
	setevent EVENT_ROUTE22_RIVAL
	setscene SCENE_ROUTE22_NOOP
	playmapmusic
	end

; Talking to him first (he faces the corridor, the player can reach him
; only via the triggers, but keep it safe).
Route22RivalScript:
	faceplayer
	opentext
	writetext Route22RivalBeforeBattleText
	waitbutton
	closetext
	end

Route22_RivalApproachNorth:
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step_end

Route22_RivalApproachSouth:
	step RIGHT
	step RIGHT
	step RIGHT
	step_end

; (25,5) -> (31,5) -> (31,11): down the only way out of the corridor.
Route22_RivalExitNorth:
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step_end

; (24,5) -> around the player via row 4 -> (31,4) -> (31,11).
Route22_RivalExitSouth:
	step UP
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step_end

VictoryRoadEntranceSign:
	jumptext VictoryRoadEntranceSignText

Route22RivalBeforeBattleText:
	text "<RIVAL>: Hey!"
	line "<PLAYER>!"

	para "You're going to"
	line "#MON LEAGUE?"

	para "Forget it! You"
	line "probably don't"
	cont "have any BADGEs!"

	para "The guard won't"
	line "let you through!"

	para "By the way, did"
	line "your #MON"
	cont "get any stronger?"
	done

Route22RivalWinText:
	text "Awww!"
	line "You just lucked"
	cont "out!"
	prompt

Route22RivalLossText:
	text "<RIVAL>: What?"
	line "Why do I have 2"
	cont "#MON?"

	para "You should catch"
	cont "some more too!"
	prompt

Route22RivalAfterBattleText:
	text "I heard #MON"
	line "LEAGUE has many"
	cont "tough trainers!"

	para "I have to figure"
	line "out how to get"
	cont "past them!"

	para "You should quit"
	line "dawdling and get"
	cont "a move on!"
	done

VictoryRoadEntranceSignText:
	text "#MON LEAGUE"

	para "VICTORY ROAD"
	line "ENTRANCE"
	done

Route22_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 13,  5, VICTORY_ROAD_GATE, 1

	def_coord_events
	coord_event 25,  4, SCENE_ROUTE22_RIVAL, Route22RivalSceneNorth
	coord_event 25,  5, SCENE_ROUTE22_RIVAL, Route22RivalSceneSouth

	def_bg_events
	bg_event 15,  7, BGEVENT_READ, VictoryRoadEntranceSign

	def_object_events
	object_event 21,  5, SPRITE_BLUE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route22RivalScript, EVENT_ROUTE22_RIVAL
