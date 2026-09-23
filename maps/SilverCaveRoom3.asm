; Kanto hack (M11 14j, D154/D155): the finale.  LANCE, who gave up his title
; at the INDIGO PLATEAU, waits here in RED's old spot with his maxed team.
; Beating him sets EVENT_BEAT_LANCE_MT_SILVER (also his hide flag) and rolls
; Crystal's credits with no Hall of Fame entry; Continue lands at NEW BARK.
	object_const_def
	const SILVERCAVEROOM3_LANCE

SilverCaveRoom3_MapScripts:
	def_scene_scripts

	def_callbacks

SilverCaveRoom3LanceScript:
	special FadeOutMusic
	faceplayer
	opentext
	writetext SilverCaveRoom3LanceSeenText
	waitbutton
	closetext
	winlosstext SilverCaveRoom3LanceBeatenText, SilverCaveRoom3LanceWinText
	loadtrainer CHAMPION, LANCE
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	setevent EVENT_BEAT_LANCE_MT_SILVER
; Kanto hack (M11 14k, D151): the post-game opens here -- SUICUNE waits in
; CIANWOOD (the chase BURNED TOWER used to arm), and ELM calls about the
; MASTER BALL (the call the RISINGBADGE used to place).
	setmapscene CIANWOOD_CITY, SCENE_CIANWOODCITY_SUICUNE_AND_EUSINE
	clearevent EVENT_SAW_SUICUNE_AT_CIANWOOD_CITY
	specialphonecall SPECIALCALL_MASTERBALL
	special FadeOutMusic
	opentext
	writetext SilverCaveRoom3LanceLeavesText
	waitbutton
	closetext
	special FadeOutToBlack
	special ReloadSpritesNoPalettes
	disappear SILVERCAVEROOM3_LANCE
	pause 15
	special FadeInFromBlack
	pause 30
	special HealParty
	reanchormap
	credits
	end

SilverCaveRoom3LanceSeenText:
	text "LANCE: …<PLAYER>."
	line "I've been waiting."

	para "Since I left the"
	line "LEAGUE, my dragons"

	para "and I have trained"
	line "on this mountain."

	para "They are stronger"
	line "than the team you"
	cont "beat at INDIGO."

	para "I said that next"
	line "time, I would be"
	cont "the challenger."

	para "<PLAYER>!"
	line "I challenge you!"
	done

SilverCaveRoom3LanceBeatenText:
	text "…Magnificent."

	para "Even at my best,"
	line "I couldn't reach"
	cont "you."
	done

SilverCaveRoom3LanceWinText:
	text "My dragons were"
	line "ready this time."
	done

SilverCaveRoom3LanceLeavesText:
	text "A title isn't"
	line "what makes a"
	cont "trainer strong."

	para "I understand that"
	line "now. Thank you."

	para "I'll return to the"
	line "DRAGON'S DEN and"
	cont "start again."

	para "Keep going,"
	line "CHAMPION."
	done

SilverCaveRoom3_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  9, 33, SILVER_CAVE_ROOM_2, 2

	def_coord_events

	def_bg_events

	def_object_events
	object_event  9, 10, SPRITE_LANCE, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SilverCaveRoom3LanceScript, EVENT_BEAT_LANCE_MT_SILVER
