	object_const_def
	const SILVERCAVEOUTSIDE_RIVAL

SilverCaveOutside_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_NEWMAP, SilverCaveOutsideFlypointCallback

SilverCaveOutsideFlypointCallback:
	setflag ENGINE_FLYPOINT_SILVER_CAVE
	endcallback

MtSilverPokecenterSign:
	jumpstd PokecenterSignScript

MtSilverSign:
	jumptext MtSilverSignText

SilverCaveOutsideHiddenFullRestore:
	hiddenitem FULL_RESTORE, EVENT_SILVER_CAVE_OUTSIDE_HIDDEN_FULL_RESTORE

MtSilverSignText:
	text "MT.SILVER"
	done

; Kanto hack (M11 14c, D142): SILVER's last fight, at the mouth of MT.SILVER.
; He blocks the cave until beaten.  The party is Crystal's unused RIVAL2_2 rows
; (its Indigo Plateau rematch); the texts are that rematch's, re-aimed from the
; LEAGUE at the mountain.
SilverCaveOutsideRivalScript:
	faceplayer
	playmusic MUSIC_RIVAL_ENCOUNTER
	opentext
	writetext SilverCaveOutsideRivalTextBefore
	waitbutton
	closetext
	checkevent EVENT_GOT_TOTODILE_FROM_ELM
	iftrue .Totodile
	checkevent EVENT_GOT_CHIKORITA_FROM_ELM
	iftrue .Chikorita
	winlosstext SilverCaveOutsideRivalTextWin, SilverCaveOutsideRivalTextLoss
	setlasttalked SILVERCAVEOUTSIDE_RIVAL
	loadtrainer RIVAL2, RIVAL2_2_TOTODILE
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	sjump .FinishBattle

.Totodile:
	winlosstext SilverCaveOutsideRivalTextWin, SilverCaveOutsideRivalTextLoss
	setlasttalked SILVERCAVEOUTSIDE_RIVAL
	loadtrainer RIVAL2, RIVAL2_2_CHIKORITA
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	sjump .FinishBattle

.Chikorita:
	winlosstext SilverCaveOutsideRivalTextWin, SilverCaveOutsideRivalTextLoss
	setlasttalked SILVERCAVEOUTSIDE_RIVAL
	loadtrainer RIVAL2, RIVAL2_2_CYNDAQUIL
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	sjump .FinishBattle

.FinishBattle:
	playmusic MUSIC_RIVAL_AFTER
	opentext
	writetext SilverCaveOutsideRivalTextAfter
	waitbutton
	closetext
	; he walks off south, around the player
	readvar VAR_XCOORD
	ifequal 19, .LeaveStraight
	applymovement SILVERCAVEOUTSIDE_RIVAL, SilverCaveOutsideRivalLeavesMovement
	sjump .Left

.LeaveStraight:
	applymovement SILVERCAVEOUTSIDE_RIVAL, SilverCaveOutsideRivalLeavesStraightMovement
.Left:
	disappear SILVERCAVEOUTSIDE_RIVAL
	setevent EVENT_BEAT_RIVAL_MT_SILVER
	playmapmusic
	end

SilverCaveOutsideRivalLeavesMovement:
	step RIGHT
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step_end

SilverCaveOutsideRivalLeavesStraightMovement:
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step_end

SilverCaveOutsideRivalTextBefore:
	text "Hold it."

	para "You're going to"
	line "climb MT.SILVER"
	cont "now?"

	para "That's not going"
	line "to happen."

	para "My super-well-"
	line "trained #MON"

	para "are going to pound"
	line "you."

	para "<PLAYER>!"
	line "I challenge you!"
	done

SilverCaveOutsideRivalTextWin:
	text "…"

	para "OK--I lost…"
	done

SilverCaveOutsideRivalTextAfter:
	text "…Darn… I still"
	line "can't win…"

	para "I… I have to think"
	line "more about my"
	cont "#MON…"

	para "Humph! Try not to"
	line "lose!"
	done

SilverCaveOutsideRivalTextLoss:
	text "…"

	para "Whew…"
	line "With my partners,"

	para "I'm going to be"
	line "the CHAMPION!"
	done

SilverCaveOutside_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 23, 19, SILVER_CAVE_POKECENTER_1F, 1
	warp_event 18, 11, SILVER_CAVE_ROOM_1, 1

	def_coord_events

	def_bg_events
	bg_event 24, 19, BGEVENT_READ, MtSilverPokecenterSign
	bg_event 17, 13, BGEVENT_READ, MtSilverSign
	bg_event  9, 25, BGEVENT_ITEM, SilverCaveOutsideHiddenFullRestore

	def_object_events
	object_event 18, 12, SPRITE_RIVAL, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SilverCaveOutsideRivalScript, EVENT_BEAT_RIVAL_MT_SILVER ; Kanto hack (M11 14c, D142)
