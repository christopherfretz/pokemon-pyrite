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
