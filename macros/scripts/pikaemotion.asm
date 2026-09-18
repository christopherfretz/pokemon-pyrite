; Yellow's Pikachu emotion bytecode (docs/PIKACHU-EMOTIONS.md).
; Ported from vendor/pokeyellow/macros/pikachu.asm; the command names and
; operand widths are Yellow's, so the 34 emotion scripts are verbatim.

MACRO dpikaemotion
	db (\1_id - PikachuEmotionTable) / 2
ENDM

MACRO ldpikaemotion
	ld \1, (\2_id - PikachuEmotionTable) / 2
ENDM

MACRO dpikapic
	db \1
ENDM

MACRO dpikacry
	db \1
ENDM

MACRO pikaemotion_dummy1
	db PIKAEMOTION_DUMMY1
ENDM

MACRO pikaemotion_printtext
	db PIKAEMOTION_PRINTTEXT
	dw \1
ENDM

MACRO pikaemotion_pcm
	db PIKAEMOTION_PLAYPCMSOUNDCLIP
	IF _NARG > 0
		dpikacry \1
	ELSE
		db PIKACRY_NONE
	ENDC
ENDM

MACRO pikaemotion_emotebubble
	db PIKAEMOTION_DOEMOTIONBUBBLE
	db \1
ENDM

MACRO pikaemotion_movement
	db PIKAEMOTION_MOVEMENT
	dw \1
ENDM

MACRO pikaemotion_pikapic
	db PIKAEMOTION_PIKAPIC
	dpikapic \1
ENDM

MACRO pikaemotion_subcmd
	db PIKAEMOTION_SUBCMD
	db \1
ENDM

MACRO pikaemotion_delay
	db PIKAEMOTION_DELAYFRAMES
	db \1
ENDM

MACRO pikaemotion_dummy2
	db PIKAEMOTION_DUMMY2
ENDM

MACRO pikaemotion_9
	db PIKAEMOTION_TURNAWAY
ENDM

MACRO pikaemotion_dummy3
	db PIKAEMOTION_DUMMY3
ENDM


; Movement mini-interpreter.  `units` are Yellow's loop iterations (2 frames).

MACRO pikamove_init
	db PIKAMOVE_INIT
ENDM

MACRO pikamove_turn
; \1 = units; one clockwise quarter-turn per unit (Yellow's `db $39, \1 - 1`).
	db PIKAMOVE_TURN, \1
ENDM

MACRO pikamove_hold
; \1 = units (Yellow's `db $3e, \1 - 1`).
	db PIKAMOVE_HOLD, \1
ENDM

MACRO pikamove_hop
; \1 = units, \2 = arc stride into PikachuHopArc (Yellow's `db $3c, \1 - 1,
; (s << 4) | (16 - 1)`, where the phase advances 1 << s per unit and the whole
; half-sine spans $20; our table is sampled every 2 units of phase, so
; stride = 1 << s / 2 and \1 * \2 must be 16).
	db PIKAMOVE_HOP, \1, \2
ENDM

MACRO pikamove_turnevery
; \1 = units, \2 = units between counterclockwise quarter-turns
; (Yellow's `db $3b, \1 - 1, \2 - 1`).
	db PIKAMOVE_TURNEVERY, \1, \2
ENDM

MACRO pikamove_end
	db PIKAMOVE_END
ENDM
