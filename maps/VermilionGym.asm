	object_const_def
	const VERMILIONGYM_SURGE
	const VERMILIONGYM_GENTLEMAN
	const VERMILIONGYM_SUPER_NERD
	const VERMILIONGYM_SAILOR
	const VERMILIONGYM_GYM_GUIDE

VermilionGym_MapScripts:
	def_scene_scripts

	def_callbacks
	; Kanto hack (M4 7k, docs/M4-VERMILION.md 3.9a): Yellow rolls the first
	; switch from VERMILION CITY's BIT_CUR_MAP_LOADED_1.  The gym is only
	; reachable through the city, so rolling it here on entry is the same
	; thing -- and it keeps the whole puzzle inside one map.
	callback MAPCALLBACK_NEWMAP, VermilionGymRollTrashCansCallback
	callback MAPCALLBACK_TILES, VermilionGymDoorCallback

VermilionGymRollTrashCansCallback:
	special InitVermilionGymTrashCans
	endcallback

VermilionGymDoorCallback:
	; The .blk stores the OPEN door (block 2,2 = $01), as Yellow's does, so
	; the closed door is painted in every time the puzzle is unsolved.
	checkevent EVENT_2ND_LOCK_OPENED
	iftrue .DoorOpen
	changeblock 4, 4, $40 ; closed motorized door
.DoorOpen:
	endcallback

VermilionGymSurgeScript:
	faceplayer
	opentext
	checkflag ENGINE_THUNDERBADGE
	iftrue .FightDone
	writetext LtSurgeIntroText
	waitbutton
	closetext
	winlosstext LtSurgeWinLossText, 0
	loadtrainer LT_SURGE, LT_SURGE1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_LTSURGE
	setevent EVENT_BEAT_GENTLEMAN_GREGORY
	setevent EVENT_BEAT_GUITARIST_VINCENT
	setevent EVENT_BEAT_SAILOR_DEWEY
	opentext
	writetext ReceivedThunderBadgeText
	playsound SFX_GET_BADGE
	waitsfx
	setflag ENGINE_THUNDERBADGE
	writetext LtSurgeThunderBadgeText
	waitbutton
.FightDone:
	checkevent EVENT_GOT_TM24_THUNDERBOLT
	iftrue .GotTM24
	writetext LtSurgeTakeThisText
	promptbutton
	verbosegiveitem TM_THUNDERBOLT
	iffalse .NoRoomForTM
	setevent EVENT_GOT_TM24_THUNDERBOLT
	writetext LtSurgeTM24ExplanationText
	waitbutton
	closetext
	end

.GotTM24:
	writetext LtSurgePostBattleAdviceText
	waitbutton
	closetext
	end

.NoRoomForTM:
	writetext LtSurgeTM24NoRoomText
	waitbutton
	closetext
	end

TrainerGentlemanGregory:
	trainer GENTLEMAN, GREGORY, EVENT_BEAT_GENTLEMAN_GREGORY, GentlemanGregorySeenText, GentlemanGregoryBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext GentlemanGregoryAfterBattleText
	waitbutton
	closetext
	end

TrainerGuitaristVincent:
	trainer GUITARIST, VINCENT, EVENT_BEAT_GUITARIST_VINCENT, GuitaristVincentSeenText, GuitaristVincentBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext GuitaristVincentAfterBattleText
	waitbutton
	closetext
	end

TrainerSailorDewey:
	trainer SAILOR, DEWEY, EVENT_BEAT_SAILOR_DEWEY, SailorDeweySeenText, SailorDeweyBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SailorDeweyAfterBattleText
	waitbutton
	closetext
	end

VermilionGymGuideScript:
	faceplayer
	opentext
	; Yellow tests wBeatGymFlags, i.e. the badge, not a "beat Surge" event.
	checkflag ENGINE_THUNDERBADGE
	iftrue .VermilionGymGuideWinScript
	writetext VermilionGymGuideText
	waitbutton
	closetext
	end

.VermilionGymGuideWinScript:
	writetext VermilionGymGuideWinText
	waitbutton
	closetext
	end

; Kanto hack (M4 7k, docs/M4-VERMILION.md 3.9): the fifteen trash cans.
; Yellow numbers them column-major from the top-left can -- index
; (x - 1) / 2 * 3 + (y - 7) / 2 -- and passes the index to the hidden-object
; handler in wHiddenEventFunctionArgument.  Ours goes in wScriptVar, which is
; also where VermilionGymTrashCan hands back a TRASHCAN_* code.
VermilionGymTrashCan0:
	writebyte 0
	sjump VermilionGymTrashCanScript

VermilionGymTrashCan1:
	writebyte 1
	sjump VermilionGymTrashCanScript

VermilionGymTrashCan2:
	writebyte 2
	sjump VermilionGymTrashCanScript

VermilionGymTrashCan3:
	writebyte 3
	sjump VermilionGymTrashCanScript

VermilionGymTrashCan4:
	writebyte 4
	sjump VermilionGymTrashCanScript

VermilionGymTrashCan5:
	writebyte 5
	sjump VermilionGymTrashCanScript

VermilionGymTrashCan6:
	writebyte 6
	sjump VermilionGymTrashCanScript

VermilionGymTrashCan7:
	writebyte 7
	sjump VermilionGymTrashCanScript

VermilionGymTrashCan8:
	writebyte 8
	sjump VermilionGymTrashCanScript

VermilionGymTrashCan9:
	writebyte 9
	sjump VermilionGymTrashCanScript

VermilionGymTrashCan10:
	writebyte 10
	sjump VermilionGymTrashCanScript

VermilionGymTrashCan11:
	writebyte 11
	sjump VermilionGymTrashCanScript

VermilionGymTrashCan12:
	writebyte 12
	sjump VermilionGymTrashCanScript

VermilionGymTrashCan13:
	writebyte 13
	sjump VermilionGymTrashCanScript

VermilionGymTrashCan14:
	writebyte 14
	sjump VermilionGymTrashCanScript

VermilionGymTrashCanScript:
	opentext
	special VermilionGymTrashCan
	ifequal TRASHCAN_1ST_LOCK, .FirstLock
	ifequal TRASHCAN_2ND_LOCK, .SecondLock
	ifequal TRASHCAN_RESET, .Reset
	writetext VermilionGymTrashText
	waitbutton
	closetext
	end

.FirstLock:
	writetext VermilionGymTrashSuccessText1
	playsound SFX_PUSH_BUTTON
	waitsfx
	waitbutton
	closetext
	end

.SecondLock:
	writetext VermilionGymTrashSuccessText3
	waitbutton
	closetext
	; Yellow opens the door there and then (ReplaceTileBlock from the text's
	; own script), so do the same rather than waiting for the next map load.
	playsound SFX_ENTER_DOOR
	changeblock 4, 4, $01 ; open doorway
	refreshmap
	waitsfx
	end

.Reset:
	writetext VermilionGymTrashFailText
	playsound SFX_WRONG
	waitsfx
	waitbutton
	closetext
	end

VermilionGymStatue:
	; Kanto hack (N1a): Yellow's pre-badge statue names the LEADER too
	; (_GymStatueText1), so wStringBuffer4 must be filled for BOTH statues.
	gettrainername STRING_BUFFER_4, LT_SURGE, LT_SURGE1
	checkflag ENGINE_THUNDERBADGE
	iftrue .Beaten
	jumpstd GymStatue1Script
.Beaten:
	jumpstd GymStatue2Script

LtSurgeIntroText:
	text "SURGE: Ten-hut!"
	line "Welcome to"
	cont "VERMILION GYM!"

	para "Will you look at"
	line "that, a pint-size"
	cont "challenger!"

	para "Hahaha! You've got"
	line "big and brassy"
	cont "nerves to take me"
	cont "on with your puny"
	cont "power!"

	para "A #MON battle"
	line "is war! I'll show"
	cont "you, civilian!"

	para "I'll shock you"
	line "into surrender!"
	done

LtSurgeWinLossText:
	text "SURGE: Whoa!"

	para "You're the real"
	line "deal, kid!"

	para "Fine then, take"
	line "the THUNDERBADGE!"
	done

ReceivedThunderBadgeText:
	text "<PLAYER> received"
	line "THUNDERBADGE."
	done

LtSurgeThunderBadgeText:
	text "SURGE: The"
	line "THUNDERBADGE"

	para "cranks up your"
	line "#MON's SPEED!"

	para "It also lets your"
	line "#MON FLY any-"
	cont "time, kid!"
	done

LtSurgeTakeThisText:
	text "SURGE: You're"
	line "special, kid!"
	cont "Take this!"
	done

LtSurgeTM24ExplanationText:
; Yellow says "TM24"; our TM union numbers THUNDERBOLT as TM86
; (docs/TM-LEDGER.md, docs/M3B-TM-UNION.md) — same treatment as Misty's TM60.
	text "TM86 contains"
	line "THUNDERBOLT!"

	para "Teach it to an"
	line "electric #MON!"
	done

LtSurgeTM24NoRoomText:
	text "SURGE: Yo kid,"
	line "make room in your"
	cont "pack!"
	done

LtSurgePostBattleAdviceText:
	text "SURGE: A little"
	line "word of advice,"
	cont "kid!"

	para "Electricity is"
	line "sure powerful!"

	para "But, it's useless"
	line "against ground-"
	cont "type #MON!"
	done

GentlemanGregorySeenText:
	text "When I was in the"
	line "Army, LT.SURGE"
	cont "was my strict CO!"
	done

GentlemanGregoryBeatenText:
	text "Stop!"
	line "You're very good!"
	done

GentlemanGregoryAfterBattleText:
	text "The door won't"
	line "open?"

	para "LT.SURGE always"
	line "was cautious!"
	done

GuitaristVincentSeenText:
	text "I'm a lightweight,"
	line "but I'm good with"
	cont "electricity!"
	done

GuitaristVincentBeatenText:
	text "Fried!"
	done

GuitaristVincentAfterBattleText:
	text "OK, I'll talk!"

	para "LT.SURGE said he"
	line "hid door switches"
	cont "inside something!"
	done

SailorDeweySeenText:
	text "This is no place"
	line "for kids!"
	done

SailorDeweyBeatenText:
	text "Wow!"
	line "Surprised me!"
	done

SailorDeweyAfterBattleText:
	text "LT.SURGE set up"
	line "double locks!"
	cont "Here's a hint!"

	para "When you open the"
	line "1st lock, the 2nd"
	cont "lock is right"
	cont "next to it!"
	done

VermilionGymGuideText:
	text "Yo! Champ in"
	line "making!"

	para "LT.SURGE has a"
	line "nickname. People"
	cont "refer to him as"
	cont "the Lightning"
	cont "American!"

	para "He's an expert on"
	line "electric #MON!"

	para "Birds and water"
	line "#MON are at"
	cont "risk! Beware of"
	cont "paralysis too!"

	para "LT.SURGE is very"
	line "cautious!"

	para "You'll have to"
	line "break a code to"
	cont "get to him!"
	done

VermilionGymGuideWinText:
	text "Whew! That match"
	line "was electric!"
	done

VermilionGymTrashText:
	text "Nope, there's"
	line "only trash here."
	done

VermilionGymTrashSuccessText1:
	text "Hey! There's a"
	line "switch under the"
	cont "trash!"
	cont "Turn it on!"

	para "The 1st electric"
	line "lock opened!"
	done

VermilionGymTrashSuccessText3:
	text "The 2nd electric"
	line "lock opened!"

	para "The motorized door"
	line "opened!"
	done

VermilionGymTrashFailText:
	text "Nope! There's"
	line "only trash here."
	cont "Hey! The electric"
	cont "locks were reset!"
	done

VermilionGym_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 17, VERMILION_CITY, 4
	warp_event  5, 17, VERMILION_CITY, 4

	def_coord_events

	def_bg_events
	bg_event  1,  7, BGEVENT_READ, VermilionGymTrashCan0
	bg_event  1,  9, BGEVENT_READ, VermilionGymTrashCan1
	bg_event  1, 11, BGEVENT_READ, VermilionGymTrashCan2
	bg_event  3,  7, BGEVENT_READ, VermilionGymTrashCan3
	bg_event  3,  9, BGEVENT_READ, VermilionGymTrashCan4
	bg_event  3, 11, BGEVENT_READ, VermilionGymTrashCan5
	bg_event  5,  7, BGEVENT_READ, VermilionGymTrashCan6
	bg_event  5,  9, BGEVENT_READ, VermilionGymTrashCan7
	bg_event  5, 11, BGEVENT_READ, VermilionGymTrashCan8
	bg_event  7,  7, BGEVENT_READ, VermilionGymTrashCan9
	bg_event  7,  9, BGEVENT_READ, VermilionGymTrashCan10
	bg_event  7, 11, BGEVENT_READ, VermilionGymTrashCan11
	bg_event  9,  7, BGEVENT_READ, VermilionGymTrashCan12
	bg_event  9,  9, BGEVENT_READ, VermilionGymTrashCan13
	bg_event  9, 11, BGEVENT_READ, VermilionGymTrashCan14
	bg_event  3, 15, BGEVENT_READ, VermilionGymStatue
	bg_event  6, 15, BGEVENT_READ, VermilionGymStatue

	def_object_events
	object_event  5,  1, SPRITE_SURGE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, VermilionGymSurgeScript, -1
	object_event  9,  6, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerGentlemanGregory, -1
	object_event  3,  8, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, TrainerGuitaristVincent, -1
	object_event  0, 10, SPRITE_SAILOR, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerSailorDewey, -1
	object_event  4, 14, SPRITE_GYM_GUIDE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 1, VermilionGymGuideScript, -1
