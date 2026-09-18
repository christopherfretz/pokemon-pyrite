; Yellow's pikapic graphics-header macro, transcribed from
; vendor/pokeyellow/data/pikachu/pikachu_pic_animation.asm:328-336
; (docs/PIKACHU-EMOTIONS.md A5 step E1).
;
; Two forms:
;   pikapicanimgfx <tiles>, <label>          ; defines <label>_id, dba <label>
;   pikapicanimgfx <tiles>, <bank>, <addr>   ; literal bank/address (entry 00)
; A tile count of -1 means "compressed": in Yellow that was a Gen 1 sprite
; blob decompressed through sSpriteBuffer0/1; here it is a Crystal .2bpp.lz
; blob decompressed with FarDecompress.  Every compressed blob in the shipped
; data is exactly 25 tiles (400 B) -- see the E1 findings in the doc.

; Entry 00's address operand is Crystal's own `NULL` label (home.asm's
; SECTION "NULL", ROM0[0]), which is $0000 -- same bytes as Yellow's NULL.

MACRO pikapicanimgfx
	IF _NARG == 2
	\2_id::
		db \1  ; size (-1 if compressed)
		dba \2 ; pointer
	ELSE
		db \1 ; size
		dbw \2, \3 ; bank, address
	ENDC
ENDM


; ----------------------------------------------------------------------------
; Yellow's pikapic animation bytecode, transcribed from
; vendor/pokeyellow/macros/pikachu.asm:1-100 (docs/PIKACHU-EMOTIONS.md A5 E2).
; The const ids MUST stay in this order: they index
; RunPikaPicAnimSetupScript.Jumptable ($00-$0e).
; ----------------------------------------------------------------------------

; Index into PikaPicAnimPointers (a dw table), i.e. the pikapic script id that
; pikaemotion_pikapic / StarterPikachuEmotionCommand_pikapic take.
MACRO dpikapic
	db (\1_id - PikaPicAnimPointers) / 2
ENDM

	const_def
	const pikapic_nop_command
MACRO pikapic_nop
	db pikapic_nop_command
ENDM

	const pikapic_writebyte_command
MACRO pikapic_writebyte
	db pikapic_writebyte_command
	db \1
ENDM

	const pikapic_loadgfx_command
MACRO pikapic_loadgfx
	db pikapic_loadgfx_command
	db (\1_id - PikaPicAnimGFXHeaders) / 4
ENDM

	const pikapic_animation_command
MACRO pikapic_animation
	; frameset pointer, starting vtile, y offset, x offset
	db pikapic_animation_command
	db (\1_id - PikaPicAnimBGFramesPointers) / 2
	db 0, \2, \3, \4
ENDM

	const pikapic_nop4_command
MACRO pikapic_nop4
	db pikapic_nop4_command
ENDM

	const pikapic_nop5_command
MACRO pikapic_nop5
	db pikapic_nop5_command
ENDM

	const pikapic_waitbgmapeleteobject_command
MACRO pikapic_waitbgmapeleteobject
	db pikapic_waitbgmapeleteobject_command
	db \1
ENDM

	const pikapic_nop7_command
MACRO pikapic_nop7
	db pikapic_nop7_command
ENDM

	const pikapic_nop8_command
MACRO pikapic_nop8
	db pikapic_nop8_command
ENDM

	const pikapic_jump_command
MACRO pikapic_jump ; 9
	db pikapic_jump_command
	dw \1
ENDM

	const pikapic_setduration_command
MACRO pikapic_setduration ; a
	db pikapic_setduration_command
	dw \1
ENDM

	const pikapic_cry_command
MACRO pikapic_cry ; b
	db pikapic_cry_command
	IF _NARG == 0
		db PIKACRY_NONE ; $ff -- "default cry"
	ELSE
		dpikacry \1
	ENDC
ENDM

	const pikapic_thunderbolt_command
MACRO pikapic_thunderbolt ; c
	db pikapic_thunderbolt_command
ENDM

	const pikapic_waitbgmap_command
MACRO pikapic_waitbgmap ; d
	db pikapic_waitbgmap_command
ENDM

	const pikapic_ret_command
MACRO pikapic_ret ; e
	db pikapic_ret_command
ENDM
DEF NUM_PIKAPIC_COMMANDS EQU const_value

MACRO pikapic_looptofinish
.loop\@
	pikapic_waitbgmap
	pikapic_jump .loop\@
ENDM


; Pointer-table entry macros.  Each defines <label>_id so that dpikapic /
; pikapic_animation / pikaframe can compute the table index.
MACRO pikapic_def
\1_id:
	dw \1
ENDM

MACRO pikaanim_def
\1_id:
	dw \1
ENDM

MACRO pikatilemap_def
\1_id:
	dw \1
ENDM

; One entry of a PikaPicAnimBGFrames_* frameset: tilemap index + duration.
MACRO pikaframe
	db (\1_id - PikaPicTilemapPointers) / 2, \2
ENDM

; A blank frame (tilemap index 0 = PikaAnimTilemap_0, "draw nothing").
DEF pikaframedelay EQUS "db 0,"
; Terminator.
DEF pikaframeend EQUS "db $e0"
