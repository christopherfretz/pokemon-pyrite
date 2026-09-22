; Kanto hack (M9 12n, docs/M9-CINNABAR.md 12n): CINNABAR GYM is Yellow's QUIZ
; GYM (vendor/pokeyellow/scripts/CinnabarGym{,_2,_3}.asm,
; engine/events/hidden_events/cinnabar_gym_quiz.asm, text/CinnabarGym.asm,
; data/text/text_2.asm).  maps/CinnabarGym.blk is already Yellow's byte for
; byte (12a) on TILESET_KANTO_FACILITY, whose blocks $54 / $5f are Yellow's
; horizontal / vertical gate and $0e the open floor.
;
; THE QUIZ.  Six BGEVENT_UP machines (Yellow's SPRITE_FACING_UP hidden events,
; same coordinates).  Gate 1 opens with the long "#MON Quiz!" intro, gates 2-6
; with the short one; then the question and YES/NO.  Yellow stores each answer
; as a menu index compared against wCurrentMenuItem (0 = YES), so its
; `(FALSE << 4) | 1` means YES is right: the answers are YES, NO, NO, NO, YES,
; NO -- the real Gen 1 facts (CATERPIE does end up a BUTTERFREE; there are 8
; badges; POLIWAG evolves twice; ground is immune to electric; DVs differ;
; TM28 is DIG).
;   * Right: item jingle + "You're absolutely correct!", SFX_GO_INSIDE (our
;     SFX_ENTER_DOOR) only if the gate was still shut, and the gate opens.
;   * Wrong: SFX_DENIED (our SFX_WRONG) + "Sorry! Bad call!".  If that gate's
;     trainer is already beaten nothing else happens (the gate stays as it
;     is); otherwise the trainer walks over -- the gate-2 SUPER NERD left and
;     up, from below, the others one step left, from the right -- the player
;     turns to face them, Pikachu steps out of the way as in Yellow
;     (special CinnabarGymPikachuStepAside), and the battle starts.
;   * Beating a gate trainer, by either route, sets its trainer flag AND
;     opens its gate (30 frames, the block, then SFX_GO_INSIDE if it was
;     shut).  Losing leaves both alone.
; Gates are persistent event flags re-applied by MAPCALLBACK_TILES on every
; load, exactly as Yellow's UpdateCinnabarGymGateTileBlocks re-applies them.
;
; THE TRAINERS have no sight in Yellow (no trainer headers): you fight them by
; a wrong answer or by talking.  Talking: beaten -> after-battle line; gate
; already open -> battle; otherwise a refusal (_CinnabarGymText_1-6) and no
; battle.  The gate-less SUPER NERD at (17,2) always battles.  Yellow's
; wd474 bit 7 ("a wrong answer is pending") only ever lives between a wrong
; answer and the battle it starts, which here is one uninterrupted script, so
; it needs no flag of its own.
;
; BLAINE: Yellow's party with its SpecialTrainerMoves (data/trainers/
; parties.asm), SPRITE_SILPH_PRESIDENT as in Yellow (docs/M9-CINNABAR.md §0.4
; #7), VOLCANOBADGE, and TM38 FIRE BLAST once; beating him retires all seven
; trainers (Yellow's SetEventRange).  Gates are NOT opened by beating him --
; Yellow doesn't either.  (D97's clearevent EVENT_VIRIDIAN_GYM_BLUE lived here
; until M10 13b retired that flag with BLUE -- D116.)

DEF CINNABAR_GYM_H_GATE EQU $54 ; Yellow HORIZONTAL_GATE_BLOCK
DEF CINNABAR_GYM_V_GATE EQU $5f ; Yellow VERTICAL_GATE_BLOCK
DEF CINNABAR_GYM_FLOOR  EQU $0e ; Yellow's "unlocked" block

	object_const_def
	const CINNABARGYM_BLAINE
	const CINNABARGYM_SUPER_NERD1
	const CINNABARGYM_SUPER_NERD2
	const CINNABARGYM_SUPER_NERD3
	const CINNABARGYM_SUPER_NERD4
	const CINNABARGYM_SUPER_NERD5
	const CINNABARGYM_SUPER_NERD6
	const CINNABARGYM_SUPER_NERD7
	const CINNABARGYM_GYM_GUIDE

CinnabarGym_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_TILES, CinnabarGymGatesCallback

; Yellow's CinnabarGymGateCoords, block (x,y) -> changeblock (2x,2y).  The
; .blk has open floor at all six, so only the shut gates need drawing.
CinnabarGymGatesCallback:
	checkevent EVENT_CINNABAR_GYM_GATE1_UNLOCKED
	iftrue .Gate2
	changeblock 18,  6, CINNABAR_GYM_H_GATE ; Yellow block (9,3)
.Gate2:
	checkevent EVENT_CINNABAR_GYM_GATE2_UNLOCKED
	iftrue .Gate3
	changeblock 12,  6, CINNABAR_GYM_H_GATE ; Yellow block (6,3)
.Gate3:
	checkevent EVENT_CINNABAR_GYM_GATE3_UNLOCKED
	iftrue .Gate4
	changeblock 12, 12, CINNABAR_GYM_H_GATE ; Yellow block (6,6)
.Gate4:
	checkevent EVENT_CINNABAR_GYM_GATE4_UNLOCKED
	iftrue .Gate5
	changeblock  6, 16, CINNABAR_GYM_V_GATE ; Yellow block (3,8)
.Gate5:
	checkevent EVENT_CINNABAR_GYM_GATE5_UNLOCKED
	iftrue .Gate6
	changeblock  4, 12, CINNABAR_GYM_H_GATE ; Yellow block (2,6)
.Gate6:
	checkevent EVENT_CINNABAR_GYM_GATE6_UNLOCKED
	iftrue .Done
	changeblock  4,  6, CINNABAR_GYM_H_GATE ; Yellow block (2,3)
.Done:
	endcallback

; \1 gate, \2 TRUE if YES is the right answer, \3/\4 the gate's changeblock
; coords, \5 the gate trainer's object, \6 TRUE if that trainer arrives from
; below (gate 2) rather than from the right.
MACRO cinnabar_gym_quiz
CinnabarGymQuiz\1:
	opentext
	if \1 == 1
		writetext CinnabarGymQuizIntroText
	else
		writetext CinnabarGymQuizShortIntroText
	endc
	writetext CinnabarGymQuizQuestion\1Text
	yesorno
	if \2
		iffalse .Wrong
	else
		iftrue .Wrong
	endc
	writetext CinnabarGymQuizCorrectText
	checkevent EVENT_CINNABAR_GYM_GATE\1_UNLOCKED
	iftrue .AlreadyOpen
	playsound SFX_ENTER_DOOR
	waitsfx
	setevent EVENT_CINNABAR_GYM_GATE\1_UNLOCKED
	changeblock \3, \4, CINNABAR_GYM_FLOOR
	refreshmap
.AlreadyOpen:
	closetext
	end

.Wrong:
	playsound SFX_WRONG
	waitsfx
	writetext CinnabarGymQuizIncorrectText
	closetext
	checkevent EVENT_BEAT_CINNABAR_GYM_TRAINER_\1
	iftrue .Done
	if \6
		turnobject PLAYER, DOWN
		setval 0
		special CinnabarGymPikachuStepAside
		applymovement \5, CinnabarGymTrainerFromBelowMovement
	else
		turnobject PLAYER, RIGHT
		setval 1
		special CinnabarGymPikachuStepAside
		applymovement \5, CinnabarGymTrainerFromRightMovement
	endc
	opentext
	sjump CinnabarGymGate\1Battle

.Done:
	end
ENDM

	cinnabar_gym_quiz 1, TRUE,  18,  6, CINNABARGYM_SUPER_NERD2, FALSE
	cinnabar_gym_quiz 2, FALSE, 12,  6, CINNABARGYM_SUPER_NERD3, TRUE
	cinnabar_gym_quiz 3, FALSE, 12, 12, CINNABARGYM_SUPER_NERD4, FALSE
	cinnabar_gym_quiz 4, FALSE,  6, 16, CINNABARGYM_SUPER_NERD5, FALSE
	cinnabar_gym_quiz 5, TRUE,   4, 12, CINNABARGYM_SUPER_NERD6, FALSE
	cinnabar_gym_quiz 6, FALSE,  4,  6, CINNABARGYM_SUPER_NERD7, FALSE

; Yellow's MovementNpcToLeft / MovementNpcToLeftAndUp.
CinnabarGymTrainerFromRightMovement:
	step LEFT
	step_end

CinnabarGymTrainerFromBelowMovement:
	step LEFT
	step UP
	step_end

; \1 gate (0 = the gate-less SUPER NERD), \2 trainer class, \3 trainer id,
; \4/\5 the gate's changeblock coords (gates 1-6 only).  Entered with the text
; box open, from a talk or from a wrong answer.
MACRO cinnabar_gym_battle
CinnabarGymGate\1Battle:
	writetext CinnabarGymTrainer\1BattleText
	waitbutton
	closetext
	winlosstext CinnabarGymTrainer\1EndBattleText, 0
	loadtrainer \2, \3
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_CINNABAR_GYM_TRAINER_\1
	if \1 > 0
		; Yellow's CinnabarGymOpenGateScript: a gate that was still shut
		; opens after 30 frames with SFX_GO_INSIDE.
		checkevent EVENT_CINNABAR_GYM_GATE\1_UNLOCKED
		iftrue .Done
		pause 30
		setevent EVENT_CINNABAR_GYM_GATE\1_UNLOCKED
		changeblock \4, \5, CINNABAR_GYM_FLOOR
		refreshmap
		playsound SFX_ENTER_DOOR
		waitsfx
	endc
.Done:
	end
ENDM

	cinnabar_gym_battle 0, SUPER_NERD, SUPER_NERD_15
	cinnabar_gym_battle 1, BURGLAR, BURGLAR_7, 18,  6
	cinnabar_gym_battle 2, SUPER_NERD, SUPER_NERD_16, 12,  6
	cinnabar_gym_battle 3, BURGLAR, BURGLAR_8, 12, 12
	cinnabar_gym_battle 4, SUPER_NERD, SUPER_NERD_17,  6, 16
	cinnabar_gym_battle 5, BURGLAR, BURGLAR_9,  4, 12
	cinnabar_gym_battle 6, SUPER_NERD, SUPER_NERD_18,  4,  6

; \1 gate (1-6).  Yellow's CinnabarGymSuperNerd2-7 text_asm.
MACRO cinnabar_gym_trainer
CinnabarGymTrainer\1Script:
	faceplayer
	opentext
	checkevent EVENT_BEAT_CINNABAR_GYM_TRAINER_\1
	iftrue .AfterBattle
	checkevent EVENT_CINNABAR_GYM_GATE\1_UNLOCKED
	iftrue CinnabarGymGate\1Battle
	writetext CinnabarGymTrainer\1RefusalText
	waitbutton
	closetext
	end

.AfterBattle:
	writetext CinnabarGymTrainer\1AfterBattleText
	waitbutton
	closetext
	end
ENDM

CinnabarGymTrainer0Script:
	faceplayer
	opentext
	checkevent EVENT_BEAT_CINNABAR_GYM_TRAINER_0
	iftrue .AfterBattle
	sjump CinnabarGymGate0Battle

.AfterBattle:
	writetext CinnabarGymTrainer0AfterBattleText
	waitbutton
	closetext
	end

	cinnabar_gym_trainer 1
	cinnabar_gym_trainer 2
	cinnabar_gym_trainer 3
	cinnabar_gym_trainer 4
	cinnabar_gym_trainer 5
	cinnabar_gym_trainer 6

CinnabarGymBlaineScript:
	faceplayer
	opentext
	checkflag ENGINE_VOLCANOBADGE
	iftrue .FightDone
	writetext BlaineBeforeBattleText
	waitbutton
	closetext
	winlosstext CinnabarBlaineWinLossText, 0
	loadtrainer BLAINE, BLAINE1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_BLAINE
	; Yellow's SetEventRange EVENT_BEAT_CINNABAR_GYM_TRAINER_0 .. _6.
	setevent EVENT_BEAT_CINNABAR_GYM_TRAINER_0
	setevent EVENT_BEAT_CINNABAR_GYM_TRAINER_1
	setevent EVENT_BEAT_CINNABAR_GYM_TRAINER_2
	setevent EVENT_BEAT_CINNABAR_GYM_TRAINER_3
	setevent EVENT_BEAT_CINNABAR_GYM_TRAINER_4
	setevent EVENT_BEAT_CINNABAR_GYM_TRAINER_5
	setevent EVENT_BEAT_CINNABAR_GYM_TRAINER_6
	opentext
	writetext CinnabarReceivedVolcanoBadgeText
	playsound SFX_GET_BADGE
	waitsfx
	setflag ENGINE_VOLCANOBADGE
.FightDone:
	; Yellow re-runs CinnabarGymReceiveTM38 -- badge blurb and all -- every
	; time you talk to BLAINE until EVENT_GOT_TM38 is set (bag-full retry),
	; the same shape as SABRINA and KOGA.  D90: Crystal's normal badge SFX.
	checkevent EVENT_GOT_TM38_FIRE_BLAST
	iftrue .GotTM38
	writetext BlaineVolcanoBadgeInfoText
	promptbutton
	verbosegiveitem TM_FIRE_BLAST
	iffalse .NoRoomForTM
	setevent EVENT_GOT_TM38_FIRE_BLAST
	writetext BlaineTM38ExplanationText
	waitbutton
	closetext
	end

.GotTM38:
	writetext BlainePostBattleAdviceText
	waitbutton
	closetext
	end

.NoRoomForTM:
	writetext BlaineTM38NoRoomText
	waitbutton
	closetext
	end

CinnabarGymGuideScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_BLAINE
	iftrue .BeatBlaine
	writetext CinnabarGymGuideChampInMakingText
	waitbutton
	closetext
	end

.BeatBlaine:
	writetext CinnabarGymGuideBeatBlaineText
	waitbutton
	closetext
	end

CinnabarGymStatue:
	; N1a: Yellow's pre-badge statue names the LEADER too.
	gettrainername STRING_BUFFER_4, BLAINE, BLAINE1
	checkflag ENGINE_VOLCANOBADGE
	iftrue .Beaten
	jumpstd GymStatue1Script
.Beaten:
	jumpstd GymStatue2Script

; --- Text: Yellow's, verbatim.  BLAINE's lines carry the "BLAINE: " prefix
; (N1), re-wrapped only where the prefix pushed a line past 18 characters.

BlaineBeforeBattleText:
	text "BLAINE: Hah!"

	para "I am BLAINE! I"
	line "am the LEADER of"
	cont "CINNABAR GYM!"

	para "My fiery #MON"
	line "will incinerate"
	cont "all challengers!"

	para "Hah! You better"
	line "have BURN HEAL!"
	done

CinnabarBlaineWinLossText:
	text "BLAINE: I have"
	line "burnt out!"

	para "You have earned"
	line "the VOLCANOBADGE!"
	done

CinnabarReceivedVolcanoBadgeText:
	text "<PLAYER> received"
	line "VOLCANOBADGE."
	done

BlaineVolcanoBadgeInfoText:
	text "BLAINE: Hah!"

	para "The VOLCANOBADGE"
	line "heightens the"
	cont "SPECIAL abilities"
	cont "of your #MON!"

	para "Here, you can"
	line "have this too!"
	done

BlaineTM38ExplanationText:
	text "TM38 contains"
	line "FIRE BLAST!"

	para "Teach it to fire-"
	line "type #MON!"

	para "CHARMELEON or"
	line "PONYTA would be"
	cont "good bets!"
	done

BlaineTM38NoRoomText:
	text "BLAINE: Make room"
	line "for my gift!"
	done

BlainePostBattleAdviceText:
	text "BLAINE: FIRE BLAST"
	line "is the ultimate"
	cont "fire technique!"

	para "Don't waste it on"
	line "water #MON!"
	done

CinnabarGymTrainer0BattleText:
	text "Do you know how"
	line "hot #MON fire"
	cont "breath can get?"
	done

CinnabarGymTrainer0EndBattleText:
	text "Yow!"
	line "Hot, hot, hot!"
	done

CinnabarGymTrainer0AfterBattleText:
	text "Fire, or to be"
	line "more precise,"
	cont "combustion..."

	para "Blah, blah, blah,"
	line "blah..."
	done

CinnabarGymTrainer1BattleText:
	text "I was a thief, but"
	line "I became straight"
	cont "as a trainer!"
	done

CinnabarGymTrainer1EndBattleText:
	text "I"
	line "surrender!"
	done

CinnabarGymTrainer1AfterBattleText:
	text "I can't help"
	line "stealing other"
	cont "people's #MON!"
	done

CinnabarGymTrainer2BattleText:
	text "You can't win!"
	line "I have studied"
	cont "#MON totally!"
	done

CinnabarGymTrainer2EndBattleText:
	text "Waah!"
	line "My studies!"
	done

CinnabarGymTrainer2AfterBattleText:
	text "My theories are"
	line "too complicated"
	cont "for you!"
	done

CinnabarGymTrainer3BattleText:
	text "I just like using"
	line "fire #MON!"
	done

CinnabarGymTrainer3EndBattleText:
	text "Too hot"
	line "to handle!"
	done

CinnabarGymTrainer3AfterBattleText:
	text "I wish there was"
	line "a thief #MON!"
	cont "I'd use that!"
	done

CinnabarGymTrainer4BattleText:
	text "I know why BLAINE"
	line "became a trainer!"
	done

CinnabarGymTrainer4EndBattleText:
	text "Ow!"
	done

CinnabarGymTrainer4AfterBattleText:
	text "BLAINE was lost"
	line "in the mountains"
	cont "when a fiery bird"
	cont "#MON appeared."

	para "Its light enabled"
	line "BLAINE to find"
	cont "his way down!"
	done

CinnabarGymTrainer5BattleText:
	text "I've been to many"
	line "GYMs, but this is"
	cont "my favorite!"
	done

CinnabarGymTrainer5EndBattleText:
	text "Yowza!"
	line "Too hot!"
	done

CinnabarGymTrainer5AfterBattleText:
	text "Us fire #MON"
	line "fans like PONYTA"
	cont "and NINETALES!"
	done

CinnabarGymTrainer6BattleText:
	text "Fire is weak"
	line "against H2O!"
	done

CinnabarGymTrainer6EndBattleText:
	text "Oh!"
	line "Snuffed out!"
	done

CinnabarGymTrainer6AfterBattleText:
	text "Water beats fire!"
	line "But, fire melts"
	cont "ice #MON!"
	done

; Yellow's _CinnabarGymText_1-6 (Func_f2150): what a gate trainer says when
; talked to before its gate is open.  _CinnabarGymText_7 is unused in Yellow
; and is not ported.
CinnabarGymTrainer1RefusalText:
	text "This GYM is also"
	line "known as the QUIZ"
	cont "GYM."

	para "You have to take a"
	line "quiz if you want"
	cont "to see BLAINE."

	para "You don't have to"
	line "fight us if you"
	cont "get it right."
	done

CinnabarGymTrainer2RefusalText:
	text "Think you can do"
	line "it?"
	done

CinnabarGymTrainer3RefusalText:
	text "This one's tricky!"
	done

CinnabarGymTrainer4RefusalText:
	text "#MON enjoy"
	line "quizzes too!"
	done

CinnabarGymTrainer5RefusalText:
	text "I like it here at"
	line "QUIZ GYM."
	done

CinnabarGymTrainer6RefusalText:
	text "This is the last"
	line "question."
	done

CinnabarGymGuideChampInMakingText:
	text "Yo! Champ in"
	line "making!"

	para "The hot-headed"
	line "BLAINE is a fire"
	cont "#MON pro!"

	para "Douse his spirits"
	line "with water!"

	para "You better take"
	line "some BURN HEALs!"
	done

CinnabarGymGuideBeatBlaineText:
	text "<PLAYER>! You beat"
	line "that fire brand!"
	done

; Yellow ends both intros with `para ""` -- wait for A, then clear the box --
; which is exactly a GSC `prompt` followed by the question's writetext.
CinnabarGymQuizIntroText:
	text "#MON Quiz!"

	para "Get it right and"
	line "the door opens to"
	cont "the next room!"

	para "Get it wrong and"
	line "face the trainer"
	cont "blocking the way!"

	para "If you want to"
	line "conserve your"
	cont "#MON for the"
	cont "GYM LEADER..."

	para "Then get it right!"
	line "Here we go!"
	prompt

CinnabarGymQuizShortIntroText:
	text "#MON Quiz!"
	line "Test your skill!"
	prompt

CinnabarGymQuizQuestion1Text:
	text "CATERPIE evolves"
	line "into BUTTERFREE?"
	done

CinnabarGymQuizQuestion2Text:
	text "There are 9"
	line "certified #MON"
	cont "LEAGUE BADGEs?"
	done

CinnabarGymQuizQuestion3Text:
	text "POLIWAG evolves 3"
	line "times?"
	done

CinnabarGymQuizQuestion4Text:
	text "Are thunder moves"
	line "effective against"
	cont "ground element-"
	cont "type #MON?"
	done

CinnabarGymQuizQuestion5Text:
	text "#MON of the"
	line "same kind and"
	cont "level are not"
	cont "identical?"
	done

CinnabarGymQuizQuestion6Text:
	text "TM28 contains"
	line "TOMBSTONER?"
	done

; Yellow opens this text with `sound_get_item_1` (the item jingle) and ends it
; with text_promptbutton; GSC's TX_SOUND_ITEM is a text command, so it leads.
CinnabarGymQuizCorrectText:
	sound_item
	text "You're absolutely"
	line "correct!"

	para "Go on through!"
	prompt

CinnabarGymQuizIncorrectText:
	text "Sorry! Bad call!"
	prompt

CinnabarGym_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 16, 17, CINNABAR_ISLAND, 2
	warp_event 17, 17, CINNABAR_ISLAND, 2

	def_coord_events

	def_bg_events
; Yellow's hidden events, all SPRITE_FACING_UP: the statue and six quiz machines.
	bg_event 17, 13, BGEVENT_UP, CinnabarGymStatue
	bg_event 15,  7, BGEVENT_UP, CinnabarGymQuiz1
	bg_event 10,  1, BGEVENT_UP, CinnabarGymQuiz2
	bg_event  9,  7, BGEVENT_UP, CinnabarGymQuiz3
	bg_event  9, 13, BGEVENT_UP, CinnabarGymQuiz4
	bg_event  1, 13, BGEVENT_UP, CinnabarGymQuiz5
	bg_event  1,  7, BGEVENT_UP, CinnabarGymQuiz6

	def_object_events
; Yellow's nine objects at Yellow's coordinates, all standing facing DOWN with
; no sight (Yellow gives them no trainer headers).  Yellow draws the three
; BURGLARs with the SUPER NERD sprite, as the MANSION's (12k), and BLAINE on
; the bald-old-man sheet, our SPRITE_SILPH_PRESIDENT.
	object_event  3,  3, SPRITE_SILPH_PRESIDENT, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CinnabarGymBlaineScript, -1
	object_event 17,  2, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CinnabarGymTrainer0Script, -1
	object_event 17,  8, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CinnabarGymTrainer1Script, -1
	object_event 11,  4, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CinnabarGymTrainer2Script, -1
	object_event 11,  8, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CinnabarGymTrainer3Script, -1
	object_event 11, 14, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CinnabarGymTrainer4Script, -1
	object_event  3, 14, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CinnabarGymTrainer5Script, -1
	object_event  3,  8, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CinnabarGymTrainer6Script, -1
	object_event 16, 13, SPRITE_GYM_GUIDE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CinnabarGymGuideScript, -1
