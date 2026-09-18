	object_const_def
	const VIRIDIANGYM_BLUE
	const VIRIDIANGYM_GYM_GUIDE

ViridianGym_MapScripts:
	def_scene_scripts

	def_callbacks

ViridianGymBlueScript:
	faceplayer
	opentext
	checkflag ENGINE_EARTHBADGE
	iftrue .FightDone
	writetext LeaderBlueBeforeText
	waitbutton
	closetext
	winlosstext LeaderBlueWinText, 0
	loadtrainer BLUE, BLUE1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_BLUE
	opentext
	writetext Text_ReceivedEarthBadge
	playsound SFX_GET_BADGE
	waitsfx
	setflag ENGINE_EARTHBADGE
	writetext LeaderBlueAfterText
	waitbutton
	closetext
	end

.FightDone:
	writetext LeaderBlueEpilogueText
	waitbutton
	closetext
	end

ViridianGymGuideScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_BLUE
	iftrue .ViridianGymGuideWinScript
	writetext ViridianGymGuideText
	waitbutton
	closetext
	end

.ViridianGymGuideWinScript:
	writetext ViridianGymGuideWinText
	waitbutton
	closetext
	end

ViridianGymStatue:
	; Kanto hack (N1a): Yellow's pre-badge statue names the LEADER too
	; (_GymStatueText1), so wStringBuffer4 must be filled for BOTH statues.
	gettrainername STRING_BUFFER_4, BLUE, BLUE1
	checkflag ENGINE_EARTHBADGE
	iftrue .Beaten
	jumpstd GymStatue1Script

.Beaten:
	jumpstd GymStatue2Script

; Kanto hack (N1c): de-Johto'd.  Crystal's Blue opens by referring to CINNABAR
; (a rematch that never happened in this act) and to conquering "the GYMS in
; JOHTO" / being the "JOHTO CHAMP" -- in a Kanto-first run the player arrives
; here with seven KANTO badges and no league win.  Blue's voice and beats are
; unchanged; only the region references are.  (Porting Yellow's GIOVANNI over
; this gym wholesale is out of scope for N1c -- see docs/AUDIT-NPC-TEXT.md.)
LeaderBlueBeforeText:
	text "BLUE: Yo! Finally"
	line "got here, huh?"

	para "I've been waiting"
	line "for you to show"
	cont "up at my GYM."

	para "…"

	para "You're telling me"
	line "you conquered all"
	cont "the other GYMS?"

	para "Heh! Then they"
	line "must be pretty"
	cont "pathetic."

	para "Hey, don't worry"
	line "about it."

	para "I'll know if you"
	line "are good or not by"

	para "battling you right"
	line "now."

	para "Ready, CHAMP in"
	line "making?"
	done

LeaderBlueWinText:
	text "BLUE: What?"

	para "How the heck did I"
	line "lose to you?"

	para "…"

	para "Tch, all right…"
	line "Here, take this--"
	cont "it's EARTHBADGE."
	done

Text_ReceivedEarthBadge:
	text "<PLAYER> received"
	line "EARTHBADGE."
	done

LeaderBlueAfterText:
	text "BLUE: …"

	para "All right, I was"
	line "wrong. You're the"

	para "real deal. You are"
	line "a good trainer."

	para "But I'm going to"
	line "beat you someday."

	para "Don't you forget"
	line "it!"
	done

LeaderBlueEpilogueText:
	text "BLUE: Listen, you."

	para "You'd better not"
	line "lose until I beat"
	cont "you. Got it?"
	done

; Kanto hack (N1c): "battled the CHAMPION three years ago" is Crystal's Johto
; backstory for Blue.  Replaced with Yellow's own line for this GYM's guide
; (_ViridianGymGuidePreBattleText: "This will be the toughest of all the GYM
; LEADERs!").
ViridianGymGuideText:
	text "Yo, CHAMP in"
	line "making!"

	para "How's it going?"
	line "Looks like you're"
	cont "on a roll."

	para "This will be the"
	line "toughest of all"
	cont "the GYM LEADERs!"

	para "He's no pushover."

	para "Give it everything"
	line "you've got!"
	done

ViridianGymGuideWinText:
	text "Man, you are truly"
	line "tough…"

	para "That was a heck of"
	line "an inspirational"

	para "battle. It brought"
	line "tears to my eyes."
	done

ViridianGym_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 17, VIRIDIAN_CITY, 1
	warp_event  5, 17, VIRIDIAN_CITY, 1

	def_coord_events

	def_bg_events
	bg_event  3, 13, BGEVENT_READ, ViridianGymStatue
	bg_event  6, 13, BGEVENT_READ, ViridianGymStatue

	def_object_events
	object_event  5,  3, SPRITE_BLUE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ViridianGymBlueScript, EVENT_VIRIDIAN_GYM_BLUE
	object_event  7, 13, SPRITE_GYM_GUIDE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ViridianGymGuideScript, EVENT_VIRIDIAN_GYM_BLUE
