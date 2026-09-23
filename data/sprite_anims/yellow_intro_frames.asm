; Kanto hack (M12e): pokeyellow data/sprite_anims/intro_frames.asm, verbatim
; except frame/endanim/dorestart -> the surf_* macros (surfing_pikachu_frames.asm).

YellowIntro_AnimatedObjectFramesData:
	dw Unkn_fa100
	dw Unkn_fa103
	dw Unkn_fa10a
	dw Unkn_fa111
	dw Unkn_fa118
	dw Unkn_fa11b
	dw Unkn_fa11e
	dw Unkn_fa121
	dw Unkn_fa124
	dw Unkn_fa127
	dw Unkn_fa138

Unkn_fa100:
	surf_frame $00, 32
	surf_endanim

Unkn_fa103:
	surf_frame $01, 4
	surf_frame $02, 4
	surf_frame $03, 4
	surf_dorestart

Unkn_fa10a:
	surf_frame $04, 4
	surf_frame $05, 4
	surf_frame $06, 4
	surf_dorestart

Unkn_fa111:
	surf_frame $07, 4
	surf_frame $08, 4
	surf_frame $09, 4
	surf_dorestart

Unkn_fa118:
	surf_frame $0a, 32
	surf_endanim

Unkn_fa11b:
	surf_frame $0b, 32
	surf_endanim

Unkn_fa11e:
	surf_frame $0c, 32
	surf_endanim

Unkn_fa121:
	surf_frame $0d, 32
	surf_endanim

Unkn_fa124:
	surf_frame $0e, 32
	surf_endanim

Unkn_fa127:
	surf_frame $0f, 31
	surf_frame $11, 2
	surf_frame $0f, 2
	surf_frame $11, 2
	surf_frame $0f, 31
	surf_frame $11, 2
	surf_frame $0f, 23
	surf_frame $10, 32
	surf_endanim

Unkn_fa138:
	surf_frame $12, 4
	surf_frame $13, 4
	surf_dorestart
