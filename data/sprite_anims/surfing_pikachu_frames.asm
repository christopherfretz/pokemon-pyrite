; Kanto hack (M12b-2): Yellow's vendor/pokeyellow/data/sprite_anims/
; surfing_pikachu_frames.asm verbatim, except that Yellow's gfx_anims macros
; (frame/endanim/dorestart/dorepeat/delanim) are renamed surf_* here, because
; Crystal's pic_anims.asm owns those names with different encodings
; (Crystal $fe = setrepeat, Yellow $fe = dorestart).  Bytes are Yellow's.

MACRO surf_frame
	db \1
	DEF x = \2
	IF _NARG > 2
		REPT _NARG - 2
			DEF x |= \3 << 1
			shift
		ENDR
	ENDC
	db x
ENDM

MACRO surf_endanim
	db $ff
ENDM

MACRO surf_dorestart
	db $fe
ENDM

MACRO surf_dorepeat
	db $fd
	db \1 ; command offset to jump to
ENDM

MACRO surf_delanim
; Removes the object from the screen, as opposed to `endanim` which just stops all motion
	db $fc
ENDM

SurfingPikachuFrames:
	dw .SingleTile ; unused
	dw .SurfingAngle00
	dw .SurfingAngle01
	dw .SurfingAngle02
	dw .SurfingAngle03
	dw .SurfingAngle04
	dw .SurfingAngle05
	dw .SurfingAngle06
	dw .SurfingAngle07
	dw .SurfingAngle08
	dw .SurfingAngle09
	dw .SurfingAngle10
	dw .SurfingAngle11
	dw .SurfingAngle12
	dw .SurfingAngle13
	dw .SmallSplash
	dw .LargeSplash
	dw .StartText
	dw .GoalText ; unused
	dw .OhNoText
	dw .WaterSpray
	dw .Plus50Pts
	dw .Plus150Pts
	dw .Plus350Pts
	dw .Plus750Pts ; unused
	dw .Plus180Pts
	dw .Plus500Pts
	dw .IntroPikachu

.SingleTile:
	surf_frame $00, 32
	surf_endanim

.SurfingAngle00:
	surf_frame $01, 8
	surf_frame $02, 8
	surf_dorestart

.SurfingAngle01:
	surf_frame $03, 8
	surf_frame $04, 8
	surf_dorestart

.SurfingAngle02:
	surf_frame $05, 8
	surf_frame $06, 8
	surf_dorestart

.SurfingAngle03:
	surf_frame $07, 8
	surf_frame $08, 8
	surf_dorestart

.SurfingAngle04:
	surf_frame $09, 8
	surf_frame $0a, 8
	surf_dorestart

.SurfingAngle05:
	surf_frame $0b, 8
	surf_frame $0c, 8
	surf_dorestart

.SurfingAngle06:
	surf_frame $0d, 8
	surf_frame $0e, 8
	surf_dorestart

.SurfingAngle07:
	surf_frame $01, 8, OAM_XFLIP, OAM_YFLIP
	surf_frame $02, 8, OAM_XFLIP, OAM_YFLIP
	surf_dorestart

.SurfingAngle08:
	surf_frame $03, 8, OAM_XFLIP, OAM_YFLIP
	surf_frame $04, 8, OAM_XFLIP, OAM_YFLIP
	surf_dorestart

.SurfingAngle09:
	surf_frame $05, 8, OAM_XFLIP, OAM_YFLIP
	surf_frame $06, 8, OAM_XFLIP, OAM_YFLIP
	surf_dorestart

.SurfingAngle10:
	surf_frame $07, 8, OAM_XFLIP, OAM_YFLIP
	surf_frame $08, 8, OAM_XFLIP, OAM_YFLIP
	surf_dorestart

.SurfingAngle11:
	surf_frame $09, 8, OAM_XFLIP, OAM_YFLIP
	surf_frame $0a, 8, OAM_XFLIP, OAM_YFLIP
	surf_dorestart

.SurfingAngle12:
	surf_frame $0b, 8, OAM_XFLIP, OAM_YFLIP
	surf_frame $0c, 8, OAM_XFLIP, OAM_YFLIP
	surf_dorestart

.SurfingAngle13:
	surf_frame $0d, 8, OAM_XFLIP, OAM_YFLIP
	surf_frame $0e, 8, OAM_XFLIP, OAM_YFLIP
	surf_dorestart

.SmallSplash:
	surf_frame $11, 7
	surf_frame $12, 7
	surf_dorestart

.LargeSplash:
	surf_frame $13, 2
	surf_frame $14, 2
	surf_dorepeat 8
	surf_frame $15, 2
	surf_endanim

.StartText:
	surf_frame $16, 32
	surf_frame $16, 32
	surf_delanim

.GoalText:
	surf_frame $17, 32
	surf_frame $17, 32
	surf_delanim

.OhNoText:
	surf_frame $18, 32
	surf_endanim

.Plus50Pts:
	surf_frame $1a, 4
	surf_dorepeat 1
	surf_frame $1a, 3
	surf_dorepeat 1
	surf_frame $1a, 2
	surf_dorepeat 1
	surf_frame $1a, 1
	surf_delanim

.Plus150Pts:
	surf_frame $1b, 4
	surf_dorepeat 1
	surf_frame $1b, 3
	surf_dorepeat 1
	surf_frame $1b, 2
	surf_dorepeat 1
	surf_frame $1b, 1
	surf_delanim

.Plus350Pts:
	surf_frame $1c, 4
	surf_dorepeat 1
	surf_frame $1c, 3
	surf_dorepeat 1
	surf_frame $1c, 2
	surf_dorepeat 1
	surf_frame $1c, 1
	surf_delanim

.Plus750Pts:
	surf_frame $1d, 4
	surf_dorepeat 1
	surf_frame $1d, 3
	surf_dorepeat 1
	surf_frame $1d, 2
	surf_dorepeat 1
	surf_frame $1d, 1
	surf_delanim

.Plus180Pts:
	surf_frame $1e, 4
	surf_dorepeat 1
	surf_frame $1e, 3
	surf_dorepeat 1
	surf_frame $1e, 2
	surf_dorepeat 1
	surf_frame $1e, 1
	surf_delanim

.Plus500Pts:
	surf_frame $1f, 4
	surf_dorepeat 1
	surf_frame $1f, 3
	surf_dorepeat 1
	surf_frame $1f, 2
	surf_dorepeat 1
	surf_frame $1f, 1
	surf_delanim

.WaterSpray:
	surf_frame $19, 1
	surf_delanim

.IntroPikachu:
	surf_frame $20, 7
	surf_frame $21, 7
	surf_frame $22, 7
	surf_frame $23, 7
	surf_dorestart
