	object_const_def
	const VIRIDIANGYM_GIOVANNI
	const VIRIDIANGYM_COOLTRAINER1
	const VIRIDIANGYM_BLACKBELT1
	const VIRIDIANGYM_TAMER1
	const VIRIDIANGYM_BLACKBELT2
	const VIRIDIANGYM_COOLTRAINER2
	const VIRIDIANGYM_BLACKBELT3
	const VIRIDIANGYM_TAMER2
	const VIRIDIANGYM_COOLTRAINER3
	const VIRIDIANGYM_GYM_GUIDE
	const VIRIDIANGYM_REVIVE

ViridianGym_MapScripts:
	def_scene_scripts

	def_callbacks

; Kanto hack (M10 13b): Yellow's VIRIDIAN GYM people (vendor/pokeyellow/
; scripts/ViridianGym.asm, data/maps/objects/ViridianGym.asm).  GIOVANNI #3
; replaces Crystal's BLUE (D116): GIOVANNI_3 party with Yellow's special moves
; (D127), gym-leader battle/victory music via IsGymLeaderCommon's row test
; (D117), EARTHBADGE, TM69 FISSURE (Yellow's TM27; EVENT_GOT_TM27_FISSURE
; keeps Yellow's number like EVENT_GOT_TM38_FIRE_BLAST).  Beating him retires
; all eight trainers (Yellow's SetEventRange) and arms the Route 22 rival #2
; (Yellow's EVENT_ROUTE22_RIVAL_WANTS_BATTLE; 13c builds the battle).  A talk
; after the TM: his farewell, a fade, and he is gone for good.
ViridianGymGiovanniScript:
	faceplayer
	opentext
	checkflag ENGINE_EARTHBADGE
	iftrue .FightDone
	writetext ViridianGymGiovanniBeforeBattleText
	waitbutton
	closetext
	winlosstext ViridianGymGiovanniWinLossText, 0
	loadtrainer GIOVANNI, GIOVANNI_3
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
	setevent EVENT_BEAT_VIRIDIAN_GYM_TRAINER_0
	setevent EVENT_BEAT_VIRIDIAN_GYM_TRAINER_1
	setevent EVENT_BEAT_VIRIDIAN_GYM_TRAINER_2
	setevent EVENT_BEAT_VIRIDIAN_GYM_TRAINER_3
	setevent EVENT_BEAT_VIRIDIAN_GYM_TRAINER_4
	setevent EVENT_BEAT_VIRIDIAN_GYM_TRAINER_5
	setevent EVENT_BEAT_VIRIDIAN_GYM_TRAINER_6
	setevent EVENT_BEAT_VIRIDIAN_GYM_TRAINER_7
	setevent EVENT_ROUTE22_RIVAL_2_WANTS_BATTLE
	opentext
	writetext ViridianGymReceivedEarthBadgeText
	playsound SFX_GET_BADGE
	waitsfx
	setflag ENGINE_EARTHBADGE
.FightDone:
	; Yellow re-runs ViridianGymReceiveTM27 -- badge blurb and all -- on every
	; talk until EVENT_GOT_TM27 is set (bag-full retry), as BLAINE does.
	checkevent EVENT_GOT_TM27_FISSURE
	iftrue .GotTM27
	writetext ViridianGymGiovanniEarthBadgeInfoText
	promptbutton
	verbosegiveitem TM_FISSURE
	iffalse .NoRoomForTM
	setevent EVENT_GOT_TM27_FISSURE
	writetext ViridianGymGiovanniTM69ExplanationText
	waitbutton
	closetext
	end

.NoRoomForTM:
	writetext ViridianGymGiovanniTM69NoRoomText
	waitbutton
	closetext
	end

.GotTM27:
	; Yellow: PostBattleAdvice, GBFadeOutToBlack, HideObject, GBFadeInFromBlack.
	writetext ViridianGymGiovanniPostBattleAdviceText
	waitbutton
	closetext
	special FadeOutToBlack
	special ReloadSpritesNoPalettes
	disappear VIRIDIANGYM_GIOVANNI
	pause 15
	special FadeInFromBlack
	end

TrainerViridianGymCooltrainer1:
	trainer COOLTRAINERM, COOLTRAINERM_VIRIDIAN_1, EVENT_BEAT_VIRIDIAN_GYM_TRAINER_0, ViridianGymCooltrainerM1BattleText, ViridianGymCooltrainerM1EndBattleText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext ViridianGymCooltrainerM1AfterBattleText
	waitbutton
	closetext
	end

TrainerViridianGymBlackbelt1:
	trainer BLACKBELT_T, BLACKBELT_VIRIDIAN_1, EVENT_BEAT_VIRIDIAN_GYM_TRAINER_1, ViridianGymHiker1BattleText, ViridianGymHiker1EndBattleText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext ViridianGymHiker1AfterBattleText
	waitbutton
	closetext
	end

TrainerViridianGymTamer1:
	trainer TAMER, TAMER_3, EVENT_BEAT_VIRIDIAN_GYM_TRAINER_2, ViridianGymRocker1BattleText, ViridianGymRocker1EndBattleText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext ViridianGymRocker1AfterBattleText
	waitbutton
	closetext
	end

TrainerViridianGymBlackbelt2:
	trainer BLACKBELT_T, BLACKBELT_VIRIDIAN_2, EVENT_BEAT_VIRIDIAN_GYM_TRAINER_3, ViridianGymHiker2BattleText, ViridianGymHiker2EndBattleText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext ViridianGymHiker2AfterBattleText
	waitbutton
	closetext
	end

TrainerViridianGymCooltrainer2:
	trainer COOLTRAINERM, COOLTRAINERM_VIRIDIAN_2, EVENT_BEAT_VIRIDIAN_GYM_TRAINER_4, ViridianGymCooltrainerM2BattleText, ViridianGymCooltrainerM2EndBattleText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext ViridianGymCooltrainerM2AfterBattleText
	waitbutton
	closetext
	end

TrainerViridianGymBlackbelt3:
	trainer BLACKBELT_T, BLACKBELT_VIRIDIAN_3, EVENT_BEAT_VIRIDIAN_GYM_TRAINER_5, ViridianGymHiker3BattleText, ViridianGymHiker3EndBattleText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext ViridianGymHiker3AfterBattleText
	waitbutton
	closetext
	end

TrainerViridianGymTamer2:
	trainer TAMER, TAMER_4, EVENT_BEAT_VIRIDIAN_GYM_TRAINER_6, ViridianGymRocker2BattleText, ViridianGymRocker2EndBattleText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext ViridianGymRocker2AfterBattleText
	waitbutton
	closetext
	end

TrainerViridianGymCooltrainer3:
	trainer COOLTRAINERM, COOLTRAINERM_VIRIDIAN_3, EVENT_BEAT_VIRIDIAN_GYM_TRAINER_7, ViridianGymCooltrainerM3BattleText, ViridianGymCooltrainerM3EndBattleText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext ViridianGymCooltrainerM3AfterBattleText
	waitbutton
	closetext
	end

ViridianGymGuideScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
	iftrue .BeatGiovanni
	writetext ViridianGymGuidePreBattleText
	waitbutton
	closetext
	end

.BeatGiovanni:
	writetext ViridianGymGuidePostBattleText
	waitbutton
	closetext
	end

ViridianGymRevive:
	itemball REVIVE

ViridianGymStatue:
	; N1a: Yellow's pre-badge statue names the LEADER too.  GIOVANNI's party
	; rows are nameless, so the class name is the leader's name.
	gettrainerclassname STRING_BUFFER_4, GIOVANNI
	checkflag ENGINE_EARTHBADGE
	iftrue .Beaten
	jumpstd GymStatue1Script

.Beaten:
	jumpstd GymStatue2Script

; --- Text: Yellow's (text/ViridianGym.asm), verbatim.  GIOVANNI's boxes carry
; the "GIOVANNI: " prefix (N1), re-wrapped only where the prefix pushed a line
; past 18 characters.  Yellow's TM27 is our TM69 (docs/TM-LEDGER.md).

ViridianGymGiovanniBeforeBattleText:
	text "GIOVANNI:"
	line "Fwahahaha! This is"
	cont "my hideout!"

	para "I planned to"
	line "resurrect TEAM"
	cont "ROCKET here!"

	para "But, you have"
	line "caught me again!"
	cont "So be it! This"
	cont "time, I'm not"
	cont "holding back!"

	para "Once more, you"
	line "shall face"
	cont "GIOVANNI, the"
	cont "greatest trainer!"
	done

ViridianGymGiovanniWinLossText:
	text "GIOVANNI: Ha!"
	line "That was a truly"
	cont "intense fight!"
	cont "You have won!"
	cont "As proof, here is"
	cont "the EARTHBADGE!"
	done

ViridianGymReceivedEarthBadgeText:
	text "<PLAYER> received"
	line "EARTHBADGE."
	done

ViridianGymGiovanniEarthBadgeInfoText:
	text "GIOVANNI: The"
	line "EARTHBADGE makes"
	cont "#MON of any"
	cont "level obey!"

	para "It is evidence of"
	line "your mastery as a"
	cont "#MON trainer!"

	para "With it, you can"
	line "enter the #MON"
	cont "LEAGUE!"

	para "It is my gift for"
	line "your #MON"
	cont "LEAGUE challenge!"
	done

ViridianGymGiovanniTM69ExplanationText:
	text "TM69 is FISSURE!"
	line "It will take out"
	cont "#MON with just"
	cont "one hit!"

	para "I made it when I"
	line "ran the GYM here,"
	cont "too long ago..."
	done

ViridianGymGiovanniTM69NoRoomText:
	text "GIOVANNI: You do"
	line "not have space"
	cont "for this!"
	done

ViridianGymGiovanniPostBattleAdviceText:
	text "GIOVANNI: Having"
	line "lost, I cannot"
	cont "face my"
	cont "underlings!"
	cont "TEAM ROCKET is"
	cont "finished forever!"

	para "I will dedicate my"
	line "life to the study"
	cont "of #MON!"

	para "Let us meet again"
	line "someday!"
	cont "Farewell!"
	done

ViridianGymCooltrainerM1BattleText:
	text "Heh! You must be"
	line "running out of"
	cont "steam by now!"
	done

ViridianGymCooltrainerM1EndBattleText:
	text "I"
	line "ran out of gas!"
	done

ViridianGymCooltrainerM1AfterBattleText:
	text "You need power to"
	line "keep up with our"
	cont "GYM LEADER!"
	done

ViridianGymHiker1BattleText:
	text "Rrrroar! I'm"
	line "working myself"
	cont "into a rage!"
	done

ViridianGymHiker1EndBattleText:
	text "Wargh!"
	done

ViridianGymHiker1AfterBattleText:
	text "I'm still not"
	line "worthy!"
	done

ViridianGymRocker1BattleText:
	text "#MON and I, we"
	line "make wonderful"
	cont "music together!"
	done

ViridianGymRocker1EndBattleText:
	text "You are in"
	line "perfect harmony!"
	done

ViridianGymRocker1AfterBattleText:
	text "Do you know the"
	line "identity of our"
	cont "GYM LEADER?"
	done

ViridianGymHiker2BattleText:
	text "Karate is the"
	line "ultimate form of"
	cont "martial arts!"
	done

ViridianGymHiker2EndBattleText:
	text "Atcho!"
	done

ViridianGymHiker2AfterBattleText:
	text "If my #MON"
	line "were as good at"
	cont "Karate as I..."
	done

ViridianGymCooltrainerM2BattleText:
	text "The truly talented"
	line "win with style!"
	done

ViridianGymCooltrainerM2EndBattleText:
	text "I"
	line "lost my grip!"
	done

ViridianGymCooltrainerM2AfterBattleText:
	text "The LEADER will"
	line "scold me!"
	done

ViridianGymHiker3BattleText:
	text "I'm the KARATE"
	line "KING! Your fate"
	cont "rests with me!"
	done

ViridianGymHiker3EndBattleText:
	text "Ayah!"
	done

ViridianGymHiker3AfterBattleText:
	text "#MON LEAGUE?"
	line "You? Don't get"
	cont "cocky!"
	done

ViridianGymRocker2BattleText:
	text "Your #MON will"
	line "cower at the"
	cont "crack of my whip!"
	done

ViridianGymRocker2EndBattleText:
	text "Yowch!"
	line "Whiplash!"
	done

ViridianGymRocker2AfterBattleText:
	text "Wait! I was just"
	line "careless!"
	done

ViridianGymCooltrainerM3BattleText:
	text "VIRIDIAN GYM was"
	line "closed for a long"
	cont "time, but now our"
	cont "LEADER is back!"
	done

ViridianGymCooltrainerM3EndBattleText:
	text "I"
	line "was beaten?"
	done

ViridianGymCooltrainerM3AfterBattleText:
	text "You can go on to"
	line "#MON LEAGUE"
	cont "only by defeating"
	cont "our GYM LEADER!"
	done

ViridianGymGuidePreBattleText:
	text "Yo! Champ in"
	line "making!"

	para "Even I don't know"
	line "VIRIDIAN LEADER's"
	cont "identity!"

	para "This will be the"
	line "toughest of all"
	cont "the GYM LEADERs!"

	para "I heard that the"
	line "trainers here"
	cont "like ground-type"
	cont "#MON!"
	done

ViridianGymGuidePostBattleText:
	text "Blow me away!"
	line "GIOVANNI was the"
	cont "GYM LEADER here?"
	done

ViridianGym_MapEvents:
	db 0, 0 ; filler

; Kanto hack (M10 13a): Yellow's 10x9 room on TILESET_KANTO_GYM.  Warps are
; Yellow's (16,17)/(17,17) on the exit mat; the statues are Yellow's
; hidden_events (15,15)/(18,15), SPRITE_FACING_UP.  The twelve arrow runs are
; collision (D115, scripts/kanto_gym_blk.py), not coord_events.
; M10 13b: Yellow's eleven objects, in Yellow's order, on Yellow's tiles --
; GIOVANNI (2,1), eight trainers (sight = Yellow's trainer-header range), the
; GYM GUIDE (16,15) and the REVIVE ball (16,9).  None stands on an arrow run.
	def_warp_events
	warp_event 16, 17, VIRIDIAN_CITY, 1
	warp_event 17, 17, VIRIDIAN_CITY, 1

	def_coord_events

	def_bg_events
	bg_event 15, 15, BGEVENT_UP, ViridianGymStatue
	bg_event 18, 15, BGEVENT_UP, ViridianGymStatue

	def_object_events
	object_event  2,  1, SPRITE_GIOVANNI, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ViridianGymGiovanniScript, EVENT_VIRIDIAN_GYM_GIOVANNI_GONE
	object_event 12,  7, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerViridianGymCooltrainer1, -1
	object_event 11, 11, SPRITE_BLACK_BELT, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerViridianGymBlackbelt1, -1
	object_event 10,  7, SPRITE_ROCKER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerViridianGymTamer1, -1
	object_event  3,  7, SPRITE_BLACK_BELT, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 2, TrainerViridianGymBlackbelt2, -1
	object_event 13,  5, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerViridianGymCooltrainer2, -1
	object_event 10,  1, SPRITE_BLACK_BELT, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerViridianGymBlackbelt3, -1
	object_event  2, 16, SPRITE_ROCKER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerViridianGymTamer2, -1
	object_event  6,  5, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerViridianGymCooltrainer3, -1
	object_event 16, 15, SPRITE_GYM_GUIDE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ViridianGymGuideScript, -1
	object_event 16,  9, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, ViridianGymRevive, EVENT_VIRIDIAN_GYM_REVIVE
