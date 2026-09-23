; Kanto hack (M11 14a, D138/Q3): Crystal's "player's house" is a neighbour's
; house in the Johto act -- the player is the Kanto Champion, Yellow's MOM is in
; PALLET TOWN, and ELM hands over the #GEAR at his LAB.  MOM's four objects,
; her #GEAR/phone/day-of-week scene and the BANK OF MOM are gone (no PHONE_MOM,
; no banking: Yellow's MOM never banked).  The map id, warps and scene vars
; are kept; the stairs up are closed off by a coord event.
	object_const_def
	const PLAYERSHOUSE1F_GRANNY

PlayersHouse1F_MapScripts:
	def_scene_scripts
	scene_script PlayersHouse1FNoop1Scene, SCENE_PLAYERSHOUSE1F_MEET_MOM
	scene_script PlayersHouse1FNoop2Scene, SCENE_PLAYERSHOUSE1F_NOOP

	def_callbacks

PlayersHouse1FNoop1Scene:
	end

PlayersHouse1FNoop2Scene:
	end

PlayersHouse1FGrannyScript:
	jumptextfaceplayer PlayersHouse1FGrannyText

; The grandson's room upstairs is not ours to visit (PLAYERS_HOUSE_2F mirrors
; the player's own decorations and PC, so it stays shut).
PlayersHouse1FStairsScript:
	opentext
	writetext PlayersHouse1FStairsText
	waitbutton
	closetext
	applymovement PLAYER, PlayersHouse1FStepDownMovement
	end

PlayersHouse1FStepDownMovement:
	step DOWN
	step_end

PlayersHouse1FTVScript:
	jumptext PlayersHouse1FTVText

PlayersHouse1FStoveScript:
	jumptext PlayersHouse1FStoveText

PlayersHouse1FSinkScript:
	jumptext PlayersHouse1FSinkText

PlayersHouse1FFridgeScript:
	jumptext PlayersHouse1FFridgeText

; Kanto hack (M11 14a): our text.
PlayersHouse1FGrannyText:
	text "Oh my! A visitor"
	line "from KANTO?"

	para "PROF.ELM told the"
	line "whole town you'd"
	cont "be coming."

	para "My grandson left"
	line "on his own #MON"
	cont "journey, you know."

	para "Do drop by again,"
	line "dear."
	done

; Kanto hack (M11 14a): our text.
PlayersHouse1FStairsText:
	text "That's the grand-"
	line "son's room. Better"
	cont "not go up there."
	done

; Kanto hack (M11 14a): our text (Crystal's said "Mom's specialty!").
PlayersHouse1FStoveText:
	text "Something tasty is"
	line "simmering…"

	para "CINNABAR VOLCANO"
	line "BURGER!"
	done

; Kanto hack (M11 14a): Crystal's, minus "Mom likes it clean".
PlayersHouse1FSinkText:
	text "The sink is spot-"
	line "less."
	done

PlayersHouse1FFridgeText:
	text "Let's see what's"
	line "in the fridge…"

	para "FRESH WATER and"
	line "tasty LEMONADE!"
	done

PlayersHouse1FTVText:
	text "There's a movie on"
	line "TV: Stars dot the"

	para "sky as two boys"
	line "ride on a train…"

	para "I'd better get"
	line "rolling too!"
	done

PlayersHouse1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  6,  7, NEW_BARK_TOWN, 2
	warp_event  7,  7, NEW_BARK_TOWN, 2
	warp_event  9,  0, PLAYERS_HOUSE_2F, 1 ; kept for the warp numbering; closed by the (9,1) coord events

	def_coord_events
	coord_event  9,  1, SCENE_PLAYERSHOUSE1F_MEET_MOM, PlayersHouse1FStairsScript
	coord_event  9,  1, SCENE_PLAYERSHOUSE1F_NOOP, PlayersHouse1FStairsScript

	def_bg_events
	bg_event  0,  1, BGEVENT_READ, PlayersHouse1FStoveScript
	bg_event  1,  1, BGEVENT_READ, PlayersHouse1FSinkScript
	bg_event  2,  1, BGEVENT_READ, PlayersHouse1FFridgeScript
	bg_event  4,  1, BGEVENT_READ, PlayersHouse1FTVScript

	def_object_events
	object_event  7,  4, SPRITE_GRANNY, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PlayersHouse1FGrannyScript, -1
