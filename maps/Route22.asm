	object_const_def
	const ROUTE22_RIVAL
	const ROUTE22_RIVAL_2

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
	scene_script Route22NoopScene,  SCENE_ROUTE22_RIVAL_2

	def_callbacks
	callback MAPCALLBACK_OBJECTS, Route22RivalCallback

Route22NoopScene:
	end

; M10 13c: the same callback also owns rival #2 (Yellow's second ROUTE 22
; fight).  At most one rival is ever shown and at most one scene is armed:
; rival #1 is tested first and, while he is due, rival #2 stays hidden.  Only
; a player who never walked the corridor before GIOVANNI can have both due;
; Yellow then fires rival #1 (its DefaultScript tests EVENT_1ST_ROUTE22_RIVAL_
; BATTLE first) and its exit clears EVENT_ROUTE22_RIVAL_WANTS_BATTLE, which
; strands rival #2 for good.  Here rival #2 simply waits for the next visit.
Route22RivalCallback:
	setevent EVENT_ROUTE22_RIVAL_2
	checkflag ENGINE_POKEDEX
	iffalse .Hide
	checkevent EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE
	iftrue .Hide
	clearevent EVENT_ROUTE22_RIVAL
	setscene SCENE_ROUTE22_RIVAL
	endcallback

.Hide:
	setevent EVENT_ROUTE22_RIVAL
	; Yellow: ViridianGym.asm:164-167 shows TOGGLE_ROUTE_22_RIVAL_2 and sets
	; EVENT_ROUTE22_RIVAL_WANTS_BATTLE on the GIOVANNI win; the win on ROUTE 22
	; sets EVENT_BEAT_ROUTE22_RIVAL_2ND_BATTLE and hides him for good.
	checkevent EVENT_ROUTE22_RIVAL_2_WANTS_BATTLE
	iffalse .Noop
	checkevent EVENT_BEAT_ROUTE22_RIVAL_2ND_BATTLE
	iftrue .Noop
	clearevent EVENT_ROUTE22_RIVAL_2
	setscene SCENE_ROUTE22_RIVAL_2
	endcallback

.Noop:
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

; --- Rival #2 (M10 13c): Yellow scripts/Route22.asm:249-373 -------------------
; Same trigger tiles and the same walk up as rival #1 (Yellow's rival objects
; share one tile, (25,5), and one Route22RivalMovementData), but Yellow's
; Rival2ExitMovementData walks him back LEFT the way he came -- four steps
; from the north trigger, three from the south -- before HideObject.
; Music: Yellow replays MUSIC_MEET_RIVAL at Music_RivalAlternateTempo on the
; approach and at Music_RivalAlternateStartAndTempo after the fight; rival #1's
; MUSIC_RIVAL_ENCOUNTER / MUSIC_RIVAL_AFTER pair stands in (K6 placeholder).

; Player on (25,4): the rival walks to (25,5), below the player.
Route22Rival2SceneNorth:
	showemote EMOTE_SHOCK, ROUTE22_RIVAL_2, 15
	playmusic MUSIC_RIVAL_ENCOUNTER
	applymovement ROUTE22_RIVAL_2, Route22_RivalApproachNorth
	turnobject PLAYER, DOWN
	turnobject ROUTE22_RIVAL_2, UP
	scall Route22Rival2Battle
	applymovement ROUTE22_RIVAL_2, Route22_Rival2ExitNorth
	sjump Route22Rival2Gone

; Player on (25,5): the rival walks to (24,5), left of the player.
Route22Rival2SceneSouth:
	showemote EMOTE_SHOCK, ROUTE22_RIVAL_2, 15
	playmusic MUSIC_RIVAL_ENCOUNTER
	applymovement ROUTE22_RIVAL_2, Route22_RivalApproachSouth
	turnobject PLAYER, LEFT
	turnobject ROUTE22_RIVAL_2, RIGHT
	scall Route22Rival2Battle
	applymovement ROUTE22_RIVAL_2, Route22_Rival2ExitSouth
	sjump Route22Rival2Gone

; Yellow: OPP_RIVAL2, wTrainerNo = wRivalStarter + 7 (Rival2Data rows 8-10) --
; a ROW choice via GetKantoRivalStarter, never a species patch (HANDOFF
; "Rival battles #5-#7", engine/events/kanto_rival.asm).  Losing is a normal
; white-out: nothing past `startbattle` runs, the beat flag stays clear and the
; OBJECTS callback re-arms him, which is Yellow's `jp z, Route22SetDefaultScript`.
Route22Rival2Battle:
	opentext
	writetext Route22Rival2BeforeBattleText
	waitbutton
	closetext
	winlosstext Route22Rival2WinText, Route22Rival2LossText
	setlasttalked ROUTE22_RIVAL_2
	special GetKantoRivalStarter
	ifequal RIVAL_STARTER_JOLTEON, .Jolteon
	ifequal RIVAL_STARTER_FLAREON, .Flareon
	loadtrainer KANTO_RIVAL, KANTO_RIVAL_13 ; RIVAL_STARTER_VAPOREON
	sjump .Fight

.Jolteon:
	loadtrainer KANTO_RIVAL, KANTO_RIVAL_11
	sjump .Fight

.Flareon:
	loadtrainer KANTO_RIVAL, KANTO_RIVAL_12

.Fight:
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	setevent EVENT_BEAT_ROUTE22_RIVAL_2ND_BATTLE
	playmusic MUSIC_RIVAL_AFTER
	opentext
	writetext Route22Rival2AfterBattleText
	waitbutton
	closetext
	return

Route22Rival2Gone:
	disappear ROUTE22_RIVAL_2
	setevent EVENT_ROUTE22_RIVAL_2
	setscene SCENE_ROUTE22_NOOP
	playmapmusic
	end

; Yellow Route22PrintRival2Text: the before- or after-battle line by the beat
; flag.  He is only reachable through the triggers, but keep it safe.
Route22Rival2Script:
	faceplayer
	opentext
	checkevent EVENT_BEAT_ROUTE22_RIVAL_2ND_BATTLE
	iftrue .After
	writetext Route22Rival2BeforeBattleText
	waitbutton
	closetext
	end

.After:
	writetext Route22Rival2AfterBattleText
	waitbutton
	closetext
	end

; (25,5) -> (21,5): Yellow's Rival2ExitMovementData1, four steps left.
Route22_Rival2ExitNorth:
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step_end

; (24,5) -> (21,5): Yellow's Rival2ExitMovementData2, three steps left.
Route22_Rival2ExitSouth:
	step LEFT
	step LEFT
	step LEFT
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

; Yellow text/Route22.asm, rival #2, verbatim.
Route22Rival2BeforeBattleText:
	text "<RIVAL>: What?"
	line "<PLAYER>! What a"
	cont "surprise to see"
	cont "you here!"

	para "So you're going to"
	line "#MON LEAGUE?"

	para "You collected all"
	line "the BADGEs too?"
	cont "That's cool!"

	para "Then I'll whip"
	line "you, <PLAYER>, as"
	cont "a warmup for"
	cont "#MON LEAGUE!"

	para "Come on!"
	done

Route22Rival2WinText:
	text "What!?"

	para "I was just"
	line "careless!"
	prompt

Route22Rival2LossText:
	text "<RIVAL>: Hahaha!"
	line "<PLAYER>! That's"
	cont "your best? You're"
	cont "nowhere near as"
	cont "good as me, pal!"

	para "Go train some"
	line "more! You loser!"
	prompt

Route22Rival2AfterBattleText:
	text "That loosened me"
	line "up! I'm ready for"
	cont "#MON LEAGUE!"

	para "<PLAYER>, you need"
	line "more practice!"

	para "But hey, you know"
	line "that! I'm out of"
	cont "here. Smell ya!"
	done

; Kanto hack (N1c): Yellow's own sign for this building,
; _Route23VictoryRoadGateSignText, verbatim (text/Route23.asm).  Yellow's Route
; 22 sign ("#MON LEAGUE / Front Gate") labels the Route 22 gate house, which
; Crystal's geometry does not have -- this door opens on the VICTORY ROAD GATE.
VictoryRoadEntranceSignText:
	text "VICTORY ROAD GATE"
	line "- #MON LEAGUE"
	done

Route22_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 13,  5, VICTORY_ROAD_GATE, 1

	def_coord_events
	coord_event 25,  4, SCENE_ROUTE22_RIVAL, Route22RivalSceneNorth
	coord_event 25,  5, SCENE_ROUTE22_RIVAL, Route22RivalSceneSouth
	coord_event 25,  4, SCENE_ROUTE22_RIVAL_2, Route22Rival2SceneNorth
	coord_event 25,  5, SCENE_ROUTE22_RIVAL_2, Route22Rival2SceneSouth

	def_bg_events
	bg_event 15,  7, BGEVENT_READ, VictoryRoadEntranceSign

	def_object_events
	object_event 21,  5, SPRITE_KANTO_RIVAL, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route22RivalScript, EVENT_ROUTE22_RIVAL
	object_event 21,  5, SPRITE_KANTO_RIVAL, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route22Rival2Script, EVENT_ROUTE22_RIVAL_2
