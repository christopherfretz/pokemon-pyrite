; Yellow's Pikachu emotion system (docs/PIKACHU-EMOTIONS.md).
; Ported from vendor/pokeyellow/constants/pikachu_emotion_constants.asm.

; DoStarterPikachuEmotions bytecode commands
	const_def
	const PIKAEMOTION_DUMMY1           ; $00
	const PIKAEMOTION_PRINTTEXT        ; $01
	const PIKAEMOTION_PLAYPCMSOUNDCLIP ; $02
	const PIKAEMOTION_DOEMOTIONBUBBLE  ; $03
	const PIKAEMOTION_MOVEMENT         ; $04
	const PIKAEMOTION_PIKAPIC          ; $05
	const PIKAEMOTION_SUBCMD           ; $06
	const PIKAEMOTION_DELAYFRAMES      ; $07
	const PIKAEMOTION_DUMMY2           ; $08
	const PIKAEMOTION_TURNAWAY         ; $09
	const PIKAEMOTION_DUMMY3           ; $0a
DEF NUM_PIKAEMOTION_COMMANDS EQU const_value
DEF PIKAEMOTION_END EQU $ff

; pikaemotion_subcmd arguments
	const_def
	const PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES ; 0
	const PIKAEMOTION_SUBCMD_LOADFONT             ; 1
	const PIKAEMOTION_SUBCMD_SHOWMAPVIEW          ; 2
	const PIKAEMOTION_SUBCMD_WAITBUTTONPRESS      ; 3
	const PIKAEMOTION_SUBCMD_CHECKPEWTERCENTER    ; 4
	const PIKAEMOTION_SUBCMD_CHECKLAVENDERTOWER   ; 5
	const PIKAEMOTION_SUBCMD_CHECKBILLSHOUSE      ; 6
DEF NUM_PIKAEMOTION_SUBCOMMANDS EQU const_value

; Emotion-bubble ids.  Decision C: `cmp` of all eight of Yellow's
; gfx/emotes/*.2bpp against ours found them byte-identical AND in the same
; order, so no new art is needed and Yellow's bubble id N *is* Crystal's
; EMOTE_* id N.  (Yellow's SKULL == Crystal's EMOTE_SAD, ZZZ == EMOTE_SLEEP.)
DEF EXCLAMATION_BUBBLE EQU EMOTE_SHOCK
DEF QUESTION_BUBBLE    EQU EMOTE_QUESTION
DEF SMILE_BUBBLE       EQU EMOTE_HAPPY
DEF SKULL_BUBBLE       EQU EMOTE_SAD
DEF HEART_BUBBLE       EQU EMOTE_HEART
DEF BOLT_BUBBLE        EQU EMOTE_BOLT
DEF ZZZ_BUBBLE         EQU EMOTE_SLEEP
DEF FISH_BUBBLE        EQU EMOTE_FISH
; Yellow's EmotionBubble holds the bubble up for this many frames.
DEF PIKAEMOTION_BUBBLE_FRAMES EQU 60

; pikapic animation script ids are no longer constants: E2 ported the real
; PikaPicAnimScript0-29 bodies and PikaPicAnimPointers into
; data/pikachu/pikapic_anims.asm, so `dpikapic PikaPicAnimScriptN` computes
; the table index from the label (still == N -- the table is in order).
DEF NUM_PIKAPIC_ANIM_SCRIPTS EQU 30

; Pikachu voice-clip ids.  Decision A: we have no PCM engine, so
; StarterPikachuEmotionCommand_pcm plays `cry PIKACHU` and hands the clip id to
; the PlayPikachuVoiceClip hook.  Yellow's dpikacry is
; (PikachuCryN_id - PikachuCriesPointerTable) / 3, i.e. simply N - 1.
	const_def
	const PikachuCry1
	const PikachuCry2
	const PikachuCry3
	const PikachuCry4
	const PikachuCry5
	const PikachuCry6
	const PikachuCry7
	const PikachuCry8
	const PikachuCry9
	const PikachuCry10
	const PikachuCry11
	const PikachuCry12
	const PikachuCry13
	const PikachuCry14
	const PikachuCry15
	const PikachuCry16
	const PikachuCry17
	const PikachuCry18
	const PikachuCry19
	const PikachuCry20
	const PikachuCry21
	const PikachuCry22
	const PikachuCry23
	const PikachuCry24
	const PikachuCry25
	const PikachuCry26
	const PikachuCry27
	const PikachuCry28
	const PikachuCry29
	const PikachuCry30
	const PikachuCry31
	const PikachuCry32
	const PikachuCry33
	const PikachuCry34
	const PikachuCry35
	const PikachuCry36
	const PikachuCry37
	const PikachuCry38
	const PikachuCry39
	const PikachuCry40
	const PikachuCry41
DEF NUM_PIKACHU_VOICE_CLIPS EQU const_value
DEF PIKACRY_NONE EQU $ff

; Movement mini-interpreter (see PikachuMovementData_* in data/pikachu/emotions.asm).
; Yellow drives Gen 1's sprite-state blocks through a 64-entry
; PikachuMovementDatabase; our follower is a Crystal object struct, so only the
; four opcodes the 34 emotion scripts can actually reach are implemented, with
; Yellow's own frame counts.  One "unit" is one of Yellow's loop iterations =
; 2 frames (ExecutePikachuMovementCommand delays twice per iteration).
	const_def
	const PIKAMOVE_INIT     ; $00: Yellow's $00, snapshot position, 1 unit
	const PIKAMOVE_TURN     ; $01: Yellow's $39, turn clockwise once per unit
	const PIKAMOVE_HOLD     ; $02: Yellow's $3e, hold the current facing
	const PIKAMOVE_HOP      ; $03: Yellow's $3c, one in-place sine hop
	const PIKAMOVE_TURNEVERY ; $04: Yellow's $3b, turn every n units
DEF PIKAMOVE_END EQU $3f ; Yellow's $3f
; Yellow's hop amplitude: PikaMovementFunc_Sine with (param2 & $f) + 1 == 16.
DEF PIKAMOVE_HOP_AMPLITUDE EQU 16

; Yellow's neutral mood, and Decision D's starting happiness for the gift
; Pikachu (docs/PIKACHU-EMOTIONS.md A6).
DEF PIKACHU_NEUTRAL_MOOD EQU 128
DEF PIKACHU_STARTER_HAPPINESS EQU 90
DEF PIKACHU_POSTBATTLE_MOOD_FLOOR EQU 130


; The pikapic face box (docs/PIKACHU-EMOTIONS.md A5 E4): Yellow's
; `hlcoord 6, 5 / lb bc, 5, 5`, i.e. a 7x7 textbox at (6, 5).  Shared by
; engine/pikachu/pikapic.asm and _CGB_Pikapic.
DEF PIKAPIC_BOX_X EQU 6
DEF PIKAPIC_BOX_Y EQU 5
DEF PIKAPIC_BOX_W EQU 7
DEF PIKAPIC_BOX_H EQU 7

; Every compressed pikapic blob is a 5x5 face (Yellow hardcodes 5 * 5 too).
DEF PIKAPIC_COMPRESSED_TILES EQU 5 * 5

; Crystal's blank tile ' ' ($7f) is plane0 = $ff / plane1 = $00, i.e. every
; pixel is colour 1.  That is white under PAL_BG_TEXT but yellow under the
; Pikachu palette the face box puts in its attrmap slot, where Yellow's own
; blank is colour 0 (white).  So the box uses its own all-zero tile, parked at
; the top of the borrowed font area, and the GFX allocator stops one tile short.
DEF PIKAPIC_BLANK_TILE EQU $ff
DEF PIKAPIC_MAX_TILES EQU PIKAPIC_BLANK_TILE - $80 ; $7f
