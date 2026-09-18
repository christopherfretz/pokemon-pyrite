; Yellow's pikapic animation scripts, transcribed verbatim from
; vendor/pokeyellow/data/pikachu/pikachu_pic_animation.asm:1-327 plus
; PikaPicAnimPointers from vendor/pokeyellow/engine/pikachu/pikachu_pic_animation.asm
; (docs/PIKACHU-EMOTIONS.md A5 step E2).  The GFX header table that follows the
; scripts in Yellow's file is already ported as data/pikachu/pikapic_gfx_headers.asm.
;
; Only deviation: Yellow's `PikachuSprite` gfx label is `PikachuSpriteGFX` here
; (hack/gfx/sprites.asm).  Everything else, including the label aliases
; (PikaPicAnimScript0/1/29 share one body) and the two unreferenced bodies
; (Data_fe26b, Data_fe51f), is byte-for-byte Yellow.
;
; `pikapic_cry` with no argument emits $ff = "default cry" (PIKACRY_NONE).

; Screen-flash palette script for pikapic_thunderbolt: pairs of
; (duration in frames, DMG BGP value), terminated by -1.  These are Gen 1
; hardware BGP bytes (%11000000 = black/black/white/white, %11100100 = the
; normal ramp), written straight to rBGP by Yellow's .FlashScreen.
; TRANSCRIBED VERBATIM -- E3/E4 must reinterpret it for CGB (an ApplyPals
; flash over the pikapic BG palette); do not redesign it here.
PikaPicAnimThunderboltPals:
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db -1 ; end

Data_fe26b:
	pikapic_loadgfx Pic_e4000
	pikapic_loadgfx Pic_e49d1
	pikapic_loadgfx PikachuSpriteGFX
	pikapic_animation PikaPicAnimBGFrames_1, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_2, $b2, $5, $5
	pikapic_animation PikaPicAnimBGFrames_3, $b6, $5, $5
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript0:
PikaPicAnimScript1:
PikaPicAnimScript29:
	pikapic_setduration 40
	pikapic_loadgfx Pic_e4000
	pikapic_loadgfx GFX_e40cc
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_6, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry3
	pikapic_looptofinish

PikaPicAnimScript2:
	pikapic_setduration 44
	pikapic_loadgfx Pic_e411c
	pikapic_loadgfx GFX_e41d2
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_7, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript3:
	pikapic_setduration 80
	pikapic_loadgfx Pic_e4272
	pikapic_loadgfx GFX_e4323
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_8, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript4:
	pikapic_setduration 70
	pikapic_loadgfx Pic_e4383
	pikapic_loadgfx GFX_e444b
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_9, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript5:
	pikapic_setduration 32
	pikapic_loadgfx Pic_e458b
	pikapic_loadgfx GFX_e463b
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_10, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript6:
	pikapic_setduration 50
	pikapic_loadgfx Pic_e467b
	pikapic_loadgfx GFX_e472e
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_11, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry38
	pikapic_looptofinish

PikaPicAnimScript7:
	pikapic_setduration 58
	pikapic_loadgfx Pic_e476e
	pikapic_loadgfx GFX_e4841
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_12, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript8:
	pikapic_setduration 44
	pikapic_loadgfx Pic_e49d1
	pikapic_loadgfx GFX_e4a99
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_13, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript9:
	pikapic_setduration 56
	pikapic_loadgfx Pic_e4b39
	pikapic_loadgfx GFX_e4bde
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_14, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript10:
	pikapic_setduration 56
	pikapic_loadgfx Pic_e4c3e
	pikapic_loadgfx GFX_e4ce0
	pikapic_loadgfx GFX_e4e70
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_16, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript11:
	pikapic_setduration 100
	pikapic_loadgfx Pic_e5000
	pikapic_loadgfx GFX_e50af
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_17, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript12:
	pikapic_setduration 50
	pikapic_loadgfx Pic_e523f
	pikapic_loadgfx GFX_e52fe
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_18, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry25
	pikapic_looptofinish

PikaPicAnimScript13:
	pikapic_setduration 50
	pikapic_loadgfx Pic_e548e
	pikapic_loadgfx GFX_e5541
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_19, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript14:
	pikapic_setduration 40
	pikapic_loadgfx Pic_e56d1
	pikapic_loadgfx GFX_e5794
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_20, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript15:
	pikapic_setduration 50
	pikapic_loadgfx Pic_e5924
	pikapic_loadgfx GFX_e59ed
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_21, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript16:
	pikapic_setduration 32
	pikapic_loadgfx Pic_e5b7d
	pikapic_loadgfx GFX_e5c4d
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_22, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript17:
	pikapic_setduration 100
	pikapic_loadgfx Pic_e5ddd
	pikapic_loadgfx GFX_e5e90
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_23, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript18:
	pikapic_setduration 32
	pikapic_loadgfx GFX_e6020
	pikapic_loadgfx GFX_e61b0
	pikapic_animation PikaPicAnimBGFrames_5, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_24, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry18
	pikapic_looptofinish

PikaPicAnimScript19:
	pikapic_setduration 44
	pikapic_loadgfx Pic_e6340
	pikapic_loadgfx GFX_e63f7
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_25, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript20:
	pikapic_setduration 50
	pikapic_loadgfx Pic_e6587
	pikapic_loadgfx GFX_e6646
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_26, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript21:
	pikapic_setduration 40
	pikapic_loadgfx Pic_e67d6
	pikapic_loadgfx GFX_e682f
	pikapic_loadgfx GFX_e69bf
	pikapic_loadgfx GFX_e6b4f
	pikapic_loadgfx GFX_e6cdf
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_27, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry20
	pikapic_looptofinish

PikaPicAnimScript22:
	pikapic_setduration 40
	pikapic_loadgfx GFX_e6e6f
	pikapic_loadgfx GFX_e6fff
	pikapic_animation PikaPicAnimBGFrames_5, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_28, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript23:
	pikapic_setduration 70
	pikapic_loadgfx GFX_e718f
	pikapic_loadgfx GFX_e731f
	pikapic_animation PikaPicAnimBGFrames_5, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_29, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript24:
	pikapic_setduration 60
	pikapic_loadgfx GFX_e74af
	pikapic_loadgfx GFX_e763f
	pikapic_animation PikaPicAnimBGFrames_5, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_30, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript25:
	pikapic_setduration 50
	pikapic_loadgfx Pic_e77cf
	pikapic_loadgfx GFX_e7863
	pikapic_loadgfx GFX_e79f3
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_31, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_writebyte 13
	pikapic_waitbgmap
	pikapic_thunderbolt
	pikapic_ret

Data_fe51f:
	pikapic_waitbgmap
PikaPicAnimScript26:
	pikapic_setduration 100
	pikapic_loadgfx Pic_e5000
	pikapic_loadgfx GFX_e50af
	pikapic_loadgfx GFX_e7b83
	pikapic_loadgfx GFX_e7d13
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_32, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript27:
	pikapic_setduration 30
	pikapic_loadgfx Pic_f0abf
	pikapic_loadgfx GFX_f0b64
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_33, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript28:
	pikapic_setduration 64
	pikapic_loadgfx Pic_f0cf4
	pikapic_loadgfx GFX_f0d82
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_34, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish


PikaPicAnimPointers:
	pikapic_def PikaPicAnimScript0  ; 00
	pikapic_def PikaPicAnimScript1  ; 01
	pikapic_def PikaPicAnimScript2  ; 02
	pikapic_def PikaPicAnimScript3  ; 03
	pikapic_def PikaPicAnimScript4  ; 04
	pikapic_def PikaPicAnimScript5  ; 05
	pikapic_def PikaPicAnimScript6  ; 06
	pikapic_def PikaPicAnimScript7  ; 07
	pikapic_def PikaPicAnimScript8  ; 08
	pikapic_def PikaPicAnimScript9  ; 09
	pikapic_def PikaPicAnimScript10 ; 0a
	pikapic_def PikaPicAnimScript11 ; 0b
	pikapic_def PikaPicAnimScript12 ; 0c
	pikapic_def PikaPicAnimScript13 ; 0d
	pikapic_def PikaPicAnimScript14 ; 0e
	pikapic_def PikaPicAnimScript15 ; 0f
	pikapic_def PikaPicAnimScript16 ; 10
	pikapic_def PikaPicAnimScript17 ; 11
	pikapic_def PikaPicAnimScript18 ; 12
	pikapic_def PikaPicAnimScript19 ; 13
	pikapic_def PikaPicAnimScript20 ; 14
	pikapic_def PikaPicAnimScript21 ; 15
	pikapic_def PikaPicAnimScript22 ; 16
	pikapic_def PikaPicAnimScript23 ; 17
	pikapic_def PikaPicAnimScript24 ; 18
	pikapic_def PikaPicAnimScript25 ; 19
	pikapic_def PikaPicAnimScript26 ; 1a
	pikapic_def PikaPicAnimScript27 ; 1b
	pikapic_def PikaPicAnimScript28 ; 1c
	pikapic_def PikaPicAnimScript29 ; 1d
