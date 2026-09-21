	object_const_def
	const FUCHSIAGYM_KOGA
	const FUCHSIAGYM_ROCKER1
	const FUCHSIAGYM_ROCKER2
	const FUCHSIAGYM_ROCKER3
	const FUCHSIAGYM_ROCKER4
	const FUCHSIAGYM_ROCKER5
	const FUCHSIAGYM_ROCKER6
	const FUCHSIAGYM_GYM_GUIDE

FuchsiaGym_MapScripts:
	def_scene_scripts

	def_callbacks

; Kanto hack (M7 10h, docs/M7-FUCHSIA.md 10h): FUCHSIA GYM is Yellow's, not
; Crystal's.  JANINE and her four disguised look-alikes are gone; the leader is
; KOGA, with Yellow's four JUGGLERs and two TAMERs at Yellow's coordinates and
; facings (vendor/pokeyellow/data/maps/objects/FuchsiaGym.asm) and Yellow's own
; per-header view_range values as GSC sight ranges (2, 2, 4, 2, 2, 2 --
; FuchsiaGymTrainerHeaders; the same correction CeladonGym records).
;
; KOGA fights as the KOGA_LEADER class -- JANINE's class slot, renamed in place
; (constants/trainer_constants.asm).  Crystal's ELITE FOUR KOGA class is named
; "ELITE FOUR" in TrainerClassNames, so reusing it would announce "ELITE FOUR
; KOGA wants to battle!" in a gym; JANINE's slot is already named "LEADER",
; matching every other Kanto leader here, and is already in KantoGymLeaders, so
; the battle music is right with no change to the Johto side.
;
; THE INVISIBLE WALLS.  Yellow's gimmick is two visually identical floor tiles
; in the GYM tileset: $11 is in Gym_Coll (vendor/pokeyellow/data/tilesets/
; collision_tile_ids.asm) and $1f is NOT, so half of the blocks in
; gfx/blocksets/gym.bst look like open floor and cannot be walked through.
; Nothing new was needed to reproduce it: FuchsiaGym is on TILESET_LAB, whose
; data/tilesets/lab_collision.asm already carries all four half-wall quadrant
; patterns Yellow uses -- $1c (top half), $1f (bottom half), $1d (left half),
; $1e (right half) -- so the maze is pure .blk data.  maps/FuchsiaGym.blk was
; off by three bytes (row 6 had $1d where Yellow has $2d); with those fixed the
; walkability grid is byte-identical to Yellow's, all 90 cells (see
; "## 10h findings").  No metatile clone, no Tileset Data bytes.
FuchsiaGymKogaScript:
	faceplayer
	opentext
	checkflag ENGINE_SOULBADGE
	iftrue .FightDone
	writetext KogaBeforeBattleText
	waitbutton
	closetext
	winlosstext KogaWinLossText, 0
	loadtrainer KOGA_LEADER, KOGA_LEADER1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_KOGA
	; Yellow's SetEventRange EVENT_BEAT_FUCHSIA_GYM_TRAINER_0 ..
	; EVENT_BEAT_FUCHSIA_GYM_TRAINER_5 -- beating KOGA retires all six gym
	; trainers, as in CELADON GYM.
	setevent EVENT_BEAT_FUCHSIA_GYM_TRAINER_0
	setevent EVENT_BEAT_FUCHSIA_GYM_TRAINER_1
	setevent EVENT_BEAT_FUCHSIA_GYM_TRAINER_2
	setevent EVENT_BEAT_FUCHSIA_GYM_TRAINER_3
	setevent EVENT_BEAT_FUCHSIA_GYM_TRAINER_4
	setevent EVENT_BEAT_FUCHSIA_GYM_TRAINER_5
	opentext
	writetext ReceivedSoulBadgeText
	playsound SFX_GET_BADGE
	waitsfx
	setflag ENGINE_SOULBADGE
.FightDone:
	; Yellow re-runs FuchsiaGymReceiveTM06 -- badge blurb and all -- every time
	; you talk to KOGA until EVENT_GOT_TM06 is set, so the SOULBADGE info text
	; (which ends "Ah! Take this too!") is the TM's own lead-in, not a separate
	; ErikaTakeThisText-style line.
	checkevent EVENT_GOT_TM06_TOXIC
	iftrue .GotTM06
	writetext KogaSoulBadgeInfoText
	promptbutton
	verbosegiveitem TM_TOXIC
	iffalse .NoRoomForTM
	setevent EVENT_GOT_TM06_TOXIC
	writetext KogaTM06ExplanationText
	waitbutton
	closetext
	end

.GotTM06:
	writetext KogaPostBattleAdviceText
	waitbutton
	closetext
	end

.NoRoomForTM:
	writetext KogaTM06NoRoomText
	waitbutton
	closetext
	end

TrainerJuggler7:
	trainer JUGGLER, JUGGLER_7, EVENT_BEAT_FUCHSIA_GYM_TRAINER_0, FuchsiaGymRocker1SeenText, FuchsiaGymRocker1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext FuchsiaGymRocker1AfterBattleText
	waitbutton
	closetext
	end

TrainerJuggler3:
	trainer JUGGLER, JUGGLER_3, EVENT_BEAT_FUCHSIA_GYM_TRAINER_1, FuchsiaGymRocker2SeenText, FuchsiaGymRocker2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext FuchsiaGymRocker2AfterBattleText
	waitbutton
	closetext
	end

TrainerJuggler8:
	trainer JUGGLER, JUGGLER_8, EVENT_BEAT_FUCHSIA_GYM_TRAINER_2, FuchsiaGymRocker3SeenText, FuchsiaGymRocker3BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext FuchsiaGymRocker3AfterBattleText
	waitbutton
	closetext
	end

TrainerTamer1:
	trainer TAMER, TAMER_1, EVENT_BEAT_FUCHSIA_GYM_TRAINER_3, FuchsiaGymRocker4SeenText, FuchsiaGymRocker4BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext FuchsiaGymRocker4AfterBattleText
	waitbutton
	closetext
	end

TrainerTamer2:
	trainer TAMER, TAMER_2, EVENT_BEAT_FUCHSIA_GYM_TRAINER_4, FuchsiaGymRocker5SeenText, FuchsiaGymRocker5BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext FuchsiaGymRocker5AfterBattleText
	waitbutton
	closetext
	end

TrainerJuggler4:
	trainer JUGGLER, JUGGLER_4, EVENT_BEAT_FUCHSIA_GYM_TRAINER_5, FuchsiaGymRocker6SeenText, FuchsiaGymRocker6BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext FuchsiaGymRocker6AfterBattleText
	waitbutton
	closetext
	end

FuchsiaGymGuideScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_KOGA
	iftrue .BeatKoga
	writetext FuchsiaGymGuideChampInMakingText
	waitbutton
	closetext
	end

.BeatKoga:
	writetext FuchsiaGymGuideBeatKogaText
	waitbutton
	closetext
	end

FuchsiaGymStatue:
	; Kanto hack (N1a): Yellow's pre-badge statue names the LEADER too
	; (_GymStatueText1), so wStringBuffer4 must be filled for BOTH statues.
	gettrainername STRING_BUFFER_4, KOGA_LEADER, KOGA_LEADER1
	checkflag ENGINE_SOULBADGE
	iftrue .Beaten
	jumpstd GymStatue1Script
.Beaten:
	jumpstd GymStatue2Script

KogaBeforeBattleText:
	text "KOGA: Fwahahaha!"

	para "A mere child like"
	line "you dares to"
	cont "challenge me?"

	para "Very well, I"
	line "shall show you"
	cont "true terror as a"
	cont "ninja master!"

	para "You shall feel"
	line "the despair of"
	cont "poison and sleep"
	cont "techniques!"
	done

KogaWinLossText:
	text "KOGA: Humph!"
	line "You have proven"
	cont "your worth!"

	para "Here! Take the"
	line "SOULBADGE!"
	done

ReceivedSoulBadgeText:
	text "<PLAYER> received"
	line "SOULBADGE."
	done

KogaSoulBadgeInfoText:
	text "KOGA: Now that"
	line "you have the"
	cont "SOULBADGE, the"
	cont "DEFENSE of your"
	cont "#MON increases!"

	para "It also lets you"
	line "SURF outside of"
	cont "battle!"

	para "Ah! Take this"
	line "too!"
	done

KogaTM06ExplanationText:
	text "TM06 contains"
	line "TOXIC!"

	para "It is a secret"
	line "technique over"
	cont "400 years old!"
	done

KogaTM06NoRoomText:
	text "KOGA: Make space"
	line "for this, child!"
	done

KogaPostBattleAdviceText:
	text "KOGA: When"
	line "afflicted by"
	cont "TOXIC, #MON"
	cont "suffer more and"
	cont "more as battle"
	cont "progresses!"

	para "It will surely"
	line "terrorize foes!"
	done

FuchsiaGymRocker1SeenText:
	text "Strength isn't"
	line "the key for"
	cont "#MON!"

	para "It's strategy!"

	para "I'll show you how"
	line "strategy can beat"
	cont "brute strength!"
	done

FuchsiaGymRocker1BeatenText:
	text "What?"
	line "Extraordinary!"
	done

FuchsiaGymRocker1AfterBattleText:
	text "So, you mix brawn"
	line "with brains?"
	cont "Good strategy!"
	done

FuchsiaGymRocker2SeenText:
	text "I wanted to become"
	line "a ninja, so I"
	cont "joined this GYM!"
	done

FuchsiaGymRocker2BeatenText:
	text "I'm done"
	line "for!"
	done

FuchsiaGymRocker2AfterBattleText:
	text "I will keep on"
	line "training under"
	cont "KOGA, my ninja"
	cont "master!"
	done

FuchsiaGymRocker3SeenText:
	text "Let's see you"
	line "beat my special"
	cont "techniques!"
	done

FuchsiaGymRocker3BeatenText:
	text "You"
	line "had me fooled!"
	done

FuchsiaGymRocker3AfterBattleText:
	text "I like poison and"
	line "sleep techniques,"
	cont "as they linger"
	cont "after battle!"
	done

FuchsiaGymRocker4SeenText:
	text "Stop right there!"

	para "Our invisible"
	line "walls have you"
	cont "frustrated?"
	done

FuchsiaGymRocker4BeatenText:
	text "Whoa!"
	line "He's got it!"
	done

FuchsiaGymRocker4AfterBattleText:
	text "You impressed me!"
	line "Here's a hint!"

	para "Look very closely"
	line "for gaps in the"
	cont "invisible walls!"
	done

FuchsiaGymRocker5SeenText:
	text "I also study the"
	line "way of the ninja"
	cont "with master KOGA!"

	para "Ninja have a long"
	line "history of using"
	cont "animals!"
	done

FuchsiaGymRocker5BeatenText:
	text "Awoo!"
	done

FuchsiaGymRocker5AfterBattleText:
	text "I still have much"
	line "to learn!"
	done

FuchsiaGymRocker6SeenText:
	text "Master KOGA comes"
	line "from a long line"
	cont "of ninjas!"

	para "What did you"
	line "descend from?"
	done

FuchsiaGymRocker6BeatenText:
	text "Dropped"
	line "my balls!"
	done

FuchsiaGymRocker6AfterBattleText:
	text "Where there is"
	line "light, there is"
	cont "shadow!"

	para "Light and shadow!"
	line "Which do you"
	cont "choose?"
	done

FuchsiaGymGuideChampInMakingText:
	text "Yo! Champ in"
	line "making!"

	para "FUCHSIA GYM is"
	line "riddled with"
	cont "invisible walls!"

	para "KOGA might appear"
	line "close, but he's"
	cont "blocked off!"

	para "You have to find"
	line "gaps in the walls"
	cont "to reach him!"
	done

FuchsiaGymGuideBeatKogaText:
	text "It's amazing how"
	line "ninja can terrify"
	cont "even now!"
	done

FuchsiaGym_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 17, FUCHSIA_CITY, 6
	warp_event  5, 17, FUCHSIA_CITY, 6

	def_coord_events

	def_bg_events
	bg_event  3, 15, BGEVENT_READ, FuchsiaGymStatue
	bg_event  6, 15, BGEVENT_READ, FuchsiaGymStatue

	def_object_events
; Kanto hack (M7 10h): Yellow's eight objects, at Yellow's coordinates and
; facings.  Yellow deliberately mismatches sprite and class -- every trainer in
; the room is SPRITE_ROCKER, and they battle as JUGGLER (Yellow's OPP_JUGGLER
; 3/4/7/8) or TAMER (1/2).  KOGA is SPRITE_SILPH_WORKER_M in Yellow, which has
; no Crystal counterpart; he gets Crystal's own SPRITE_KOGA, as ERIKA and
; LT.SURGE got theirs.
	object_event  4, 10, SPRITE_KOGA, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, FuchsiaGymKogaScript, -1
	object_event  8, 13, SPRITE_ROCKER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerJuggler7, -1
	object_event  7,  8, SPRITE_ROCKER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerJuggler3, -1
	object_event  1, 12, SPRITE_ROCKER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerJuggler8, -1
	object_event  3,  5, SPRITE_ROCKER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerTamer1, -1
	object_event  8,  2, SPRITE_ROCKER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerTamer2, -1
	object_event  2,  7, SPRITE_ROCKER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerJuggler4, -1
	object_event  7, 15, SPRITE_GYM_GUIDE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, FuchsiaGymGuideScript, -1
