; Kanto hack (M12e, docs/M12-STRETCH.md): Yellow's Pikachu intro movie,
; replacing Crystal's CrystalIntro (Unown/Suicune).
;
; A port of pokeyellow engine/movie/intro_yellow.asm (PlayIntroScene, all 18
; scenes and their helpers) and PlayIntro's tail (engine/movie/intro.asm).
; Scene code, spawn tables, frame/OAM scripts, timers, sine waves and palette
; sequences are Yellow's verbatim.  Animation engine: Yellow's own
; animated-object engine (engine/games/animated_objects.asm, already ported
; for Surfing Pikachu), included a second time here with the YIntro_ label
; prefix so the movie runs the same frame scripts Yellow does, frame for frame.
; Engine translations:
; - VBlank: Crystal's VBLANK_NORMAL (OAM DMA, scroll registers, sound, joypad,
;   Serve2bppRequest).  Yellow's hVBlankCopy* requests (the scene-7 wave copy,
;   the scene-11 cloud tiles) -> wRequested2bpp*, served in the same VBlank.
;   Yellow's CopyVideoData (8 tiles a frame) -> YIntro_CopyVideoData, same
;   cadence.  hAutoBGTransferEnabled -> hBGMapMode 1 (the tilemap in thirds).
; - Raster (scenes 6-7): Crystal's LCD handler reads wLYOverrides in WRAM
;   bank 5, which stays mapped for the whole movie.  Yellow's 256-byte rotating
;   wave buffer (wLYOverridesBuffer, eight copies of a 32-byte wave shifted one
;   byte per frame) -> wLYOverridesBackup rebuilt from the wave at a phase
;   counter: byte for byte the same 112 lines (16-127) Yellow copies.
; - CGB palettes: Yellow's UpdateCGBPal_BGP/OBP0/OBP1, DMGPalToCGBPal,
;   InitCGBPalettes and YellowIntroPaletteAction, reimplemented here on the
;   same base palettes (CGBBasePalettes' ROUTE, MEWMON, PIKACHUS_BEACH) with
;   the same hardware timing: BG palettes are written after LY 144, OBJ
;   colours in HBlank (two per HBlank where Yellow writes one: see
;   YIntro_TransferCurPalData); "no change" skips against the last value written.
; - Frame timing: every scene starts on Yellow's VBlank (scripts/m12e_intro.py).
;   Yellow's frame drops are reproduced where pyrite's faster code would not
;   drop them (YellowIntro_Scene0Lag, the extra IF after DisableLCD).
;   The rBGP/rOBP0/rOBP1 bytes are kept in the DMG registers, as in Yellow.
; - SET_PAL_GENERIC's BlkPacket_WholeScreen -> the splash's BG attributes
;   (rows 11-13) are zeroed in VBlank.
;
; Yellow's intro plays no Pikachu cry (no PlayPikachuSoundClip), and no sound
; effects: only MUSIC_YELLOW_INTRO.

YellowIntro::
; Crystal glue around Yellow's PlayIntroScene: WRAM bank 5 (wLYOverrides) and
; VBLANK_NORMAL for the whole movie.
	ldh a, [rWBK]
	push af
	ld a, BANK(wLYOverrides)
	ldh [rWBK], a
	ldh a, [hVBlank]
	push af
	assert VBLANK_NORMAL == 0
	xor a
	ldh [hVBlank], a
	ldh [hMapAnims], a
	ldh [hBGMapMode], a
	ldh [hCGBPalUpdate], a
	ldh [hOAMUpdate], a
	ldh a, [rSTAT]
	push af
	ld a, LOW(vBGMap0)
	ldh [hBGMapAddress], a
	ld a, HIGH(vBGMap0)
	ldh [hBGMapAddress + 1], a
; Yellow's splash leaves these DMG palette bytes behind (m12e harness).
	ld a, $e4
	ldh [rBGP], a
	ld a, $e7
	ldh [rOBP0], a
	ld a, $a4
	ldh [rOBP1], a

	call YIntro_PlayIntroScene

; Yellow: PlayIntro's tail
	xor a
	ldh [hSCX], a
	ldh [hBGMapMode], a
	call ClearSprites
	call DelayFrame
; Yellow: Init's DisableLCD after PlayIntro waits out one more VBlank before
; PrepareTitleScreen (the screen is already blank)
	call DelayFrame

	pop af
	ldh [rSTAT], a
	pop af
	ldh [hVBlank], a
	pop af
	ldh [rWBK], a
	ret

YellowIntro_Scene0Lag:
; On hardware Yellow's first loop pass (scene 0: spawn Pikachu, three CGB
; palette conversions, the first RunObjectAnimations) overruns its frame by a
; few scanlines and misses a VBlank; pyrite's finishes ~5 lines early.  Drop
; the same frame here, so every scene after it starts on Yellow's frame.
; Scene 0 just ran exactly when the scene is 1 with its 130-frame timer unspent.
	ld a, [wYellowIntroCurrentScene]
	cp 1
	ret nz
	ld a, [wYellowIntroSceneTimer]
	cp 130
	ret nz
	jp DelayFrame

YIntro_PlayIntroScene:
	ldh a, [rIE]
	push af
	xor a
	ldh [rIF], a
	ld a, IE_VBLANK | IE_STAT | IE_TIMER | IE_SERIAL
	ldh [rIE], a
	ld a, STAT_MODE_0
	ldh [rSTAT], a
	call InitYellowIntroGFXAndMusic
	call DelayFrame
.loop
	ld a, [wYellowIntroCurrentScene]
	bit 7, a
	jr nz, .go_to_title_screen
; Yellow: JoypadLowSensitivity on the input VBlank read (VBlank_Normal
; runs UpdateJoypad, as Yellow's VBlank runs ReadJoypad)
	call GetJoypad
	ldh a, [hJoyPressed]
	and PAD_A | PAD_B | PAD_START
	jr nz, .go_to_title_screen
	call YellowIntro_RunScene
	ld a, $0
	ld [wCurrentAnimatedObjectOAMBufferOffset], a
	call YIntro_RunObjectAnimations
	ld a, [wYellowIntroCurrentScene]
	cp $7
	call z, YellowIntro_Scene7OAMPals
	cp $b
	call z, YellowIntro_Scene11OAMPals
	call YellowIntro_Scene0Lag
	call DelayFrame
	jr .loop

.go_to_title_screen
	call YellowIntro_BlankPalettes
	xor a
	ldh [hLCDCPointer], a
	call DelayFrame
	xor a
	ldh [rIF], a
	pop af
	ldh [rIE], a
	ld a, $90
	ldh [hWY], a
	call YIntro_ClearObjectAnimationBuffers
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	call ByteFill
	call YellowIntro_BlankOAMBuffer
	call YellowIntro_AutoBGTransfer
	ret

YellowIntro_AutoBGTransfer:
; Yellow: hAutoBGTransferEnabled for three frames (Delay3). Yellow's
; hAutoBGTransferPortion is 2 when the movie starts and every Delay3 moves it
; round the full cycle, so each transfer runs bottom, top, middle.
	ld a, 2
	ldh [hBGMapThird], a
	ld a, 1
	ldh [hBGMapMode], a
	call DelayFrame
	call DelayFrame
	call DelayFrame
	xor a
	ldh [hBGMapMode], a
	ret

YellowIntro_Scene7OAMPals: ; Yellow: Func_f98a2
	ld a, [wShadowOAMSprite08Attributes]
	or $1
	ld [wShadowOAMSprite08Attributes], a
	ld a, [wShadowOAMSprite14Attributes]
	or $1
	ld [wShadowOAMSprite14Attributes], a
	ld a, [wShadowOAMSprite16Attributes]
	or $1
	ld [wShadowOAMSprite16Attributes], a
	ld a, [wShadowOAMSprite18Attributes]
	or $1
	ld [wShadowOAMSprite18Attributes], a
	ld a, [wShadowOAMSprite19Attributes]
	or $1
	ld [wShadowOAMSprite19Attributes], a
	ret

YellowIntro_Scene11OAMPals: ; Yellow: Func_f98cb
	ld a, [wShadowOAMSprite18Attributes]
	or $1
	ld [wShadowOAMSprite18Attributes], a
	ld a, [wShadowOAMSprite19Attributes]
	or $1
	ld [wShadowOAMSprite19Attributes], a
	ld a, [wShadowOAMSprite20Attributes]
	or $1
	ld [wShadowOAMSprite20Attributes], a
	ld a, [wShadowOAMSprite25Attributes]
	or $1
	ld [wShadowOAMSprite25Attributes], a
	ld a, [wShadowOAMSprite26Attributes]
	or $1
	ld [wShadowOAMSprite26Attributes], a
	ld a, [wShadowOAMSprite28Attributes]
	or $1
	ld [wShadowOAMSprite28Attributes], a
	ret

YellowIntro_RunScene: ; Yellow: Func_f98fc
	ld a, [wYellowIntroCurrentScene]
	ld hl, YellowIntro_SceneJumptable
	call YellowIntro_GetJumptableEntry
	jp hl

YellowIntro_SceneJumptable:
	dw YellowIntroScene0 ; running pika 1
	dw YellowIntroScene1 ; wait last
	dw YellowIntroScene2 ; pikachu kick
	dw YellowIntroScene3 ; wait last
	dw YellowIntroScene4 ; running pika 2
	dw YellowIntroScene5 ; wait last
	dw YellowIntroScene6 ; surfing pika
	dw YellowIntroScene7 ; wait last
	dw YellowIntroScene8 ; running pika 3
	dw YellowIntroScene9 ; wait last
	dw YellowIntroScene10 ; flying pika
	dw YellowIntroScene11 ; wait last
	dw YellowIntroScene12 ; pika close up
	dw YellowIntroScene13 ; wait last
	dw YellowIntroScene14 ; pika thunderbolt
	dw YellowIntroScene15 ; wait last
	dw YellowIntroScene16 ; fade to white
	dw YellowIntroScene17 ; wait and quit

YellowIntro_NextScene:
	ld hl, wYellowIntroCurrentScene
	inc [hl]
	ret

YellowIntroScene0:
	xor a
	ldh [hLCDCPointer], a
	lb de, $58, $58
	ld a, $1
	call YellowIntro_SpawnAnimatedObjectAndSavePointer
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	ld a, $90
	ldh [hWY], a
	ld a, $e4
	ldh [rBGP], a
	ldh [rOBP0], a
	ld a, $c4
	ldh [rOBP1], a
	call YIntro_UpdateCGBPal_BGP
	call YIntro_UpdateCGBPal_OBP0
	call YIntro_UpdateCGBPal_OBP1
	ld a, 130
	ld [wYellowIntroSceneTimer], a
	call YellowIntro_NextScene
	ret

YellowIntroScene1:
	call YellowIntro_CheckFrameTimerDecrement
	ret nc
	call YellowIntro_MaskCurrentAnimatedObjectStruct
	call YellowIntro_NextScene
	ret

YellowIntroScene2:
	call YellowIntro_BlankPalsDelay2AndDisableLCD
	ld c, $8
	call YellowIntro_UpdateMusicCTimes
	xor a
	ldh [hLCDCPointer], a
	ld hl, vBGMap0
	ld bc, $400
	xor a
	call ByteFill
	call YellowIntroScene2_PlaceGraphic
	lb de, $58, $b8 ; overloaded
	ld a, $4 ; overloaded
	call LoadYellowIntroFlyingSpeedBars
	ld a, $1
	call YellowIntro_SetUpScene
	call YellowIntro_SetTimerFor128Frames
	call YellowIntro_NextScene
	ret

YellowIntroScene2_PlaceGraphic:
	ld hl, $98d4 ; (20, 6)
	ld de, $20
	ld b, $6
	ld a, $90
.row
	ld c, $6
	push af
	push hl
.col
	ld [hli], a
	inc a
	dec c
	jr nz, .col
	pop hl
	add hl, de
	pop af
	add $10
	dec b
	jr nz, .row
; We can actually set palettes!
	ld hl, $98d4 ; (20, 6)
	ld de, $20
	ld b, $6
	ld a, $1
	ldh [rVBK], a
.attr_row
	ld c, $6
	push hl
.attr_col
	ld [hli], a
	dec c
	jr nz, .attr_col
	pop hl
	add hl, de
	dec b
	jr nz, .attr_row
	xor a
	ldh [rVBK], a
	ret

LoadYellowIntroFlyingSpeedBars:
	ld hl, YellowIntroFlyingSpeedBarData
	ld a, $8
.loop
; Spawn object $8 at indicated coordinates with indicated speeds
	push af
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld a, [hli]
	push hl
	push af
	ld a, $8
	call YIntro_SpawnAnimatedObject
	pop af
	ld hl, $b
	add hl, bc
	ld [hl], a
	pop hl
	pop af
	dec a
	jr nz, .loop
	ret

YellowIntroFlyingSpeedBarData:
	; y, x, speed
	db $d0, $20, $02
	db $f0, $30, $04
	db $d0, $40, $06
	db $c0, $50, $08
	db $e0, $60, $08
	db $c0, $70, $06
	db $e0, $80, $04
	db $f0, $90, $02

YellowIntroScene3:
	call YellowIntro_CheckFrameTimerDecrement
	jr c, .expired
	ldh a, [hSCX]
	cp $68
	ret z
	add $4
	ldh [hSCX], a
	ret

.expired
	call YIntro_MaskAllAnimatedObjectStructs
	call YellowIntro_NextScene
	ret

YellowIntroScene4:
	call YellowIntro_BlankPalsDelay2AndDisableLCD
	ld c, $5
	call YellowIntro_UpdateMusicCTimes
	ld hl, $98d4
	ld de, $20
	ld b, $6
	ld a, $1
	ldh [rVBK], a
	xor a
.attr_row
	ld c, $6
	push hl
.attr_col
	ld [hli], a
	dec c
	jr nz, .attr_col
	pop hl
	add hl, de
	dec b
	jr nz, .attr_row
	xor a
	ldh [rVBK], a
	xor a
	ldh [hLCDCPointer], a
	call YellowIntro_DrawBlackBars
	lb de, $58, $58
	ld a, $2
	call YellowIntro_SpawnAnimatedObjectAndSavePointer
	xor a
	call YellowIntro_SetUpScene
	call YellowIntro_SetTimerFor128Frames
	call YellowIntro_NextScene
	ret

YellowIntroScene5:
	call YellowIntro_CheckFrameTimerDecrement
	ret nc
	call YellowIntro_MaskCurrentAnimatedObjectStruct
	call YellowIntro_NextScene
	ret

YellowIntroScene6:
	call YellowIntro_BlankPalsDelay2AndDisableLCD
	ld c, $5
	call YellowIntro_UpdateMusicCTimes
	ld a, LOW(rSCY)
	ldh [hLCDCPointer], a
	call YellowIntro_Copy8BitSineWave
	ld hl, vBGMap0
	ld bc, $60
	xor a
	call ByteFill
	ld hl, $9860
	ld c, $10
	ld a, $20
.loop
	ld [hli], a
	inc a
	ld [hli], a
	dec a
	dec c
	jr nz, .loop
	ld hl, $9880
	ld bc, $300
	ld a, $10
	call ByteFill
	lb de, $40, $f8
	ld a, $5
	call YellowIntro_SpawnAnimatedObjectAndSavePointer
	ld a, $1
	call YellowIntro_SetUpScene
	call YellowIntro_SetTimerFor88Frames
	call YellowIntro_NextScene
	ret

YellowIntroScene7:
	call YellowIntro_CheckFrameTimerDecrement
	jr c, .expired
	ld hl, hSCX
	inc [hl]
	inc [hl]
; Yellow rotates its 256-byte wave buffer left by one byte
	ld hl, wYIntroSinePhase
	inc [hl]
	call YellowIntro_BuildWave
	call YellowIntro_RequestWaveTransfer
	ret

.expired
	call YellowIntro_MaskCurrentAnimatedObjectStruct
	call YellowIntro_NextScene
	ret

YellowIntroScene8:
	call YellowIntro_BlankPalsDelay2AndDisableLCD
	ld c, $5
	call YellowIntro_UpdateMusicCTimes
	xor a
	ldh [hLCDCPointer], a
	call YellowIntro_DrawBlackBars
	lb de, $58, $58
	ld a, $3
	call YellowIntro_SpawnAnimatedObjectAndSavePointer
	xor a
	call YellowIntro_SetUpScene
	call YellowIntro_SetTimerFor128Frames
	call YellowIntro_NextScene
	ret

YellowIntroScene9:
	call YellowIntro_CheckFrameTimerDecrement
	ret nc
	call YellowIntro_MaskCurrentAnimatedObjectStruct
	call YellowIntro_NextScene
	ret

YellowIntroScene10:
	call YellowIntro_BlankPalsDelay2AndDisableLCD
	ld c, $5
	call YellowIntro_UpdateMusicCTimes
	xor a
	ldh [hLCDCPointer], a
	ld hl, vBGMap0
	ld bc, $400
	xor a
	call ByteFill
	ld hl, vBGMap0
	ld bc, $100
	ld a, $2
	call ByteFill
	ld hl, $9900
	ld de, YellowIntroSkyTilemap
	lb bc, 6, 20
	call .FillBGMapBox
	ld hl, $988c
	ld de, YellowIntroCloudTilemap1
	lb bc, 3, 4
	call .FillBGMapBox
	ld hl, $98e3
	ld de, YellowIntroCloudTilemap2
	lb bc, 2, 2
	call .FillBGMapBox
	lb de, $98, $58
	ld a, $6
	call YellowIntro_SpawnAnimatedObjectAndSavePointer
	ld a, $1
	call YellowIntro_SetUpScene
	call YellowIntro_SetTimerFor128Frames
	call YellowIntro_NextScene
	ret

.FillBGMapBox:
.fill_row
	push bc
	push hl
.fill_col
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .fill_col
	pop hl
	ld bc, $20
	add hl, bc
	pop bc
	dec b
	jr nz, .fill_row
	ret

YellowIntroSkyTilemap:     INCBIN "gfx/intro/unknown_f9b6e.tilemap"
YellowIntroCloudTilemap1:  INCBIN "gfx/intro/unknown_f9be6.tilemap"
YellowIntroCloudTilemap2:  INCBIN "gfx/intro/unknown_f9bf2.tilemap"

YellowIntroScene11:
	call YellowIntro_CheckFrameTimerDecrement
	jr c, .expired
	ld a, [wYellowIntroSceneTimer]
	and $7
	ret nz
	ld a, [wYellowIntroSceneTimer]
	and $8
	sla a
	sla a
	sla a
	ld e, a
	ld d, $0
	ld hl, YellowIntroCloudGFX
	add hl, de
; Yellow: hVBlankCopy 4 tiles to vChars2 tile $60
	ld a, l
	ld [wRequested2bppSource], a
	ld a, h
	ld [wRequested2bppSource + 1], a
	xor a
	ld [wRequested2bppDest], a
	ld a, $96
	ld [wRequested2bppDest + 1], a
	ld a, $4
	ld [wRequested2bppSize], a
	ret

.expired
	call YellowIntro_MaskCurrentAnimatedObjectStruct
	call YellowIntro_NextScene
	ret

YellowIntroCloudGFX: INCBIN "gfx/intro/clouds.2bpp"

YellowIntroScene12:
	call YellowIntro_BlankPalsDelay2AndDisableLCD
	ld c, $5
	call YellowIntro_UpdateMusicCTimes
	xor a
	ldh [hLCDCPointer], a
	ld hl, vBGMap0
	ld bc, $80
	ld a, $1
	call ByteFill
	ld hl, $9880
	ld bc, $140
	xor a
	call ByteFill
	ld hl, $99c0
	ld bc, $80
	ld a, $1
	call ByteFill

	; paste 8x12 graphic into vBGMap0 at (5, 6) starting at tile 4, skipping 4 vtiles at the end of each row
	ld hl, $98c5
	ld de, $20
	ld a, $4
	ld b, 8
.row
	ld c, 12
	push hl
.col
	ld [hli], a
	inc a
	dec c
	jr nz, .col
	pop hl
	add hl, de
	add $4
	dec b
	jr nz, .row

	ld hl, $98c4 ; (4, 6)
	ld [hl], $3
	ld hl, $98e4 ; (4, 7)
	ld [hl], $74
	ld hl, $99a5 ; (5, 5)
	ld [hl], $0
	lb de, $60, $58
	ld a, $9
	call YellowIntro_SpawnAnimatedObjectAndSavePointer
	xor a
	call YellowIntro_SetUpScene
	call YellowIntro_SetTimerFor128Frames
	call YellowIntro_NextScene
	ret

YellowIntroScene13:
	call YellowIntro_CheckFrameTimerDecrement
	ret nc
	lb de, $68, $58
	ld a, $a
	call YIntro_SpawnAnimatedObject
	call YellowIntro_NextScene
	ret

YellowIntroScene14:
	ld de, YellowIntroPalSequence_Thunderbolt
	call YellowIntro_LoadDMGPalAndIncrementCounter
	jr c, .expired
	ldh [rBGP], a
	ldh [rOBP0], a
	and $f0
	ldh [rOBP1], a
	call YIntro_UpdateCGBPal_BGP
	call YIntro_UpdateCGBPal_OBP0
	call YIntro_UpdateCGBPal_OBP1
	ret

.expired
	call YIntro_MaskAllAnimatedObjectStructs
	call YellowIntro_BlankOAMBuffer
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * 4
	ld a, $1
	call ByteFill
	hlcoord 0, 4
	ld bc, SCREEN_WIDTH * 10
	xor a
	call ByteFill
	hlcoord 0, 14
	ld bc, SCREEN_WIDTH * 4
	ld a, $1
	call ByteFill
	call YellowIntro_AutoBGTransfer
	ld a, $e4
	ldh [rOBP0], a
	ldh [rBGP], a
	call YIntro_UpdateCGBPal_BGP
	call YIntro_UpdateCGBPal_OBP0
	lb de, $58, $58
	ld a, $7
	call YellowIntro_SpawnAnimatedObjectAndSavePointer
	call YellowIntro_NextScene
	ld a, $28
	ld [wYellowIntroSceneTimer], a
	ret

YellowIntroScene15:
	call YellowIntro_CheckFrameTimerDecrement
	jr c, .expired
	ld a, [wYellowIntroSceneTimer]
	and $3
	ret nz
	ldh a, [rOBP0]
	xor $ff
	ldh [rOBP0], a
	ldh a, [rBGP]
	xor $3
	ldh [rBGP], a
	call YIntro_UpdateCGBPal_BGP
	call YIntro_UpdateCGBPal_OBP0
	ret

.expired
	xor a
	ldh [hLCDCPointer], a
	ld a, $e4
	ldh [rBGP], a
	ldh [rOBP0], a
	call YIntro_UpdateCGBPal_BGP
	call YIntro_UpdateCGBPal_OBP0
	call YellowIntro_NextScene
YellowIntroScene16:
	ld de, YellowIntroPalSequence_FadeOut
	call YellowIntro_LoadDMGPalAndIncrementCounter
	jr c, .expired
	ldh [rOBP0], a
	ldh [rBGP], a
	call YIntro_UpdateCGBPal_BGP
	call YIntro_UpdateCGBPal_OBP0
	ret

.expired
	call YellowIntro_NextScene
	ret

YellowIntroPalSequence_Thunderbolt: ; Yellow: YellowIntroPalSequence_f9dd6
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $ff

YellowIntroPalSequence_FadeOut: ; Yellow: YellowIntroPalSequence_f9e0a
	db $e4, $90, $90, $40
	db $40, $00, $00, $ff

YellowIntroScene17:
	ld c, 64
	call DelayFrames
	ld hl, wYellowIntroCurrentScene
	set 7, [hl]
	ret

YellowIntro_SpawnAnimatedObjectAndSavePointer:
	call YIntro_SpawnAnimatedObject
	ld a, c
	ld [wYellowIntroAnimatedObjectStructPointer], a
	ld a, b
	ld [wYellowIntroAnimatedObjectStructPointer + 1], a
	ret

YellowIntro_MaskCurrentAnimatedObjectStruct:
	ld a, [wYellowIntroAnimatedObjectStructPointer]
	ld c, a
	ld a, [wYellowIntroAnimatedObjectStructPointer + 1]
	ld b, a
	call YIntro_MaskCurrentAnimatedObjectStruct
	ret

YellowIntro_SetTimerFor128Frames:
	ld a, 128
	ld [wYellowIntroSceneTimer], a
	ret

YellowIntro_SetTimerFor88Frames:
	ld a, 88
	ld [wYellowIntroSceneTimer], a
	ret

YellowIntro_CheckFrameTimerDecrement:
	ld hl, wYellowIntroSceneTimer
	ld a, [hl]
	and a
	jr z, .expired
	dec [hl]
	and a
	ret

.expired
	scf
	ret

YellowIntro_LoadDMGPalAndIncrementCounter:
	ld hl, wYellowIntroSceneTimer
	ld a, [hl]
	inc [hl]
	ld l, a
	ld h, $0
	add hl, de
	ld a, [hl]
	cp $ff
	jr z, .done
	and a
	ret

.done
	scf
	ret

YellowIntro_DrawBlackBars: ; Yellow: Func_f9e5f
	ld hl, vBGMap0
	ld bc, $80
	ld a, $1
	call ByteFill
	ld hl, $9880
	ld bc, $140
	xor a
	call ByteFill
	ld hl, $99c0
	ld bc, $80
	ld a, $1
	call ByteFill
	ret

YellowIntro_BlankPalsDelay2AndDisableLCD:
	xor a
	ldh [rBGP], a
	ldh [rOBP0], a
	ldh [rOBP1], a
	call YIntro_UpdateCGBPal_BGP
	call YIntro_UpdateCGBPal_OBP0
	call YIntro_UpdateCGBPal_OBP1
	call DelayFrame
	call DelayFrame
	call DisableLCD
; Yellow's DisableLCD leaves the VBlank it masked pending in rIF, so its VBlank
; handler runs once more (music tick included) right after the LCD goes off.
; pyrite's clears rIF; re-raise it so the intro keeps Yellow's timing.
	ldh a, [rIF]
	or IE_VBLANK
	ldh [rIF], a
	ret

YellowIntro_UpdateMusicCTimes:
; Yellow: UpdateMusicCTimes (catch the music up on the frames the LCD is off)
.loop
	call UpdateSound
	dec c
	jr nz, .loop
	ret

YellowIntro_SetUpScene: ; Yellow: Func_f9e9a
	ld e, a
	call YellowIntroPaletteAction
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	ld a, $90
	ldh [hWY], a
	ld a, LCDC_DEFAULT ; Yellow: $e3
	ldh [rLCDC], a
	ld a, $e4
	ldh [rBGP], a
	ldh [rOBP0], a
	ld a, $e0
	ldh [rOBP1], a
	call YIntro_UpdateCGBPal_BGP
	call YIntro_UpdateCGBPal_OBP0
	call YIntro_UpdateCGBPal_OBP1
	ret

YellowIntro_Copy8BitSineWave:
; Yellow copies the wave into its 256-byte wLYOverridesBuffer eight times;
; here the buffer is rebuilt from the wave at a phase each frame.  Lines 0-15
; and 128-143 stay 0 (Yellow never writes them either).
	xor a
	ld [wYIntroSinePhase], a
	ld hl, wLYOverrides
	ld bc, wLYOverridesEnd - wLYOverrides
	call ByteFill
	ld hl, wLYOverridesBackup
	ld bc, wLYOverridesBackupEnd - wLYOverridesBackup
	xor a
	call ByteFill
	; fallthrough
YellowIntro_BuildWave:
; wLYOverridesBackup[i] = wave[(i + phase) & 31] for lines 16-127
	ld a, [wYIntroSinePhase]
	add $10
	ld c, a
	ld de, wLYOverridesBackup + $10
	ld b, $80 - $10
.loop
	ld a, c
	and $1f
	add LOW(YellowIntro_SineWave)
	ld l, a
	ld a, 0
	adc HIGH(YellowIntro_SineWave)
	ld h, a
	ld a, [hl]
	ld [de], a
	inc de
	inc c
	dec b
	jr nz, .loop
	ret

YellowIntro_SineWave:
; a sine wave with amplitude 4
	db  0,  0,  1,  2,  2,  3,  3,  3
	db  4,  3,  3,  3,  2,  2,  1,  0
	db  0,  0, -1, -2, -2, -3, -3, -3
	db -4, -3, -3, -3, -2, -2, -1,  0

YellowIntro_RequestWaveTransfer: ; Yellow: Request7TileTransferFromC810ToC710
	ld a, LOW(wLYOverridesBackup + $10)
	ld [wRequested2bppSource], a
	ld a, HIGH(wLYOverridesBackup + $10)
	ld [wRequested2bppSource + 1], a
	ld a, LOW(wLYOverrides + $10)
	ld [wRequested2bppDest], a
	ld a, HIGH(wLYOverrides + $10)
	ld [wRequested2bppDest + 1], a
	ld a, $7
	ld [wRequested2bppSize], a
	ret

InitYellowIntroGFXAndMusic:
	xor a
	ldh [hBGMapMode], a
	ldh [hSCX], a
	ldh [hSCY], a
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, $1
	call ByteFill
	hlcoord 0, 4
	ld bc, SCREEN_WIDTH * 10
	xor a
	call ByteFill
	call YellowIntro_AutoBGTransfer
	ld de, YellowIntroGraphics2
	ld hl, vTiles0
	ld c, (YellowIntroGraphics2End - YellowIntroGraphics2 - $10) / $10
	call YIntro_CopyVideoData
	ld de, YellowIntroGraphics1
	ld hl, vTiles2
	ld c, (YellowIntroGraphics1End - YellowIntroGraphics1) / $10
	call YIntro_CopyVideoData
	call YIntro_ClearObjectAnimationBuffers
	call LoadYellowIntroObjectAnimationDataPointers
; Yellow: RunPaletteCommand SET_PAL_GENERIC
	ld e, 0
	call YellowIntroPaletteAction
	call YellowIntro_ClearSplashAttrs
	call DelayFrame
	call DelayFrame
	call DelayFrame
	xor a
	ld hl, wYellowIntroCurrentScene
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld de, MUSIC_YELLOW_INTRO
	call PlayMusic
	ret

YIntro_CopyVideoData:
; Yellow: CopyVideoData -- c tiles from de to hl, 8 a frame in VBlank
	ld a, e
	ld [wRequested2bppSource], a
	ld a, d
	ld [wRequested2bppSource + 1], a
	ld a, l
	ld [wRequested2bppDest], a
	ld a, h
	ld [wRequested2bppDest + 1], a
.loop
	ld a, c
	cp 8
	jr nc, .eight
	ld [wRequested2bppSize], a
	jr .wait
.eight
	ld a, 8
	ld [wRequested2bppSize], a
.wait
	call DelayFrame
	ld a, [wRequested2bppSize]
	and a
	jr nz, .wait
	ld a, c
	sub 8
	ret c
	ret z
	ld c, a
	jr .loop

YellowIntro_ClearSplashAttrs:
; Yellow: BlkPacket_WholeScreen (the splash's attributes, rows 11-13 -> 0)
	ld hl, vBGMap0 + 11 * TILEMAP_WIDTH
	ld a, 1
	ldh [rVBK], a
	di
.wait
	ldh a, [rLY]
	cp LY_VBLANK
	jr nz, .wait
	ld b, 3
.row
	ld c, SCREEN_WIDTH
	xor a
.col
	ld [hli], a
	dec c
	jr nz, .col
	ld de, TILEMAP_WIDTH - SCREEN_WIDTH
	add hl, de
	dec b
	jr nz, .row
	xor a
	ldh [rVBK], a
	ei
	ret

LoadYellowIntroObjectAnimationDataPointers:
	ld a, LOW(YellowIntro_AnimatedObjectSpawnStateData)
	ld [wAnimatedObjectSpawnStateDataPointer], a
	ld a, HIGH(YellowIntro_AnimatedObjectSpawnStateData)
	ld [wAnimatedObjectSpawnStateDataPointer + 1], a
	ld a, LOW(YellowIntro_AnimatedObjectJumptable)
	ld [wAnimatedObjectJumptablePointer], a
	ld a, HIGH(YellowIntro_AnimatedObjectJumptable)
	ld [wAnimatedObjectJumptablePointer + 1], a
	ld a, LOW(YellowIntro_AnimatedObjectOAMData)
	ld [wAnimatedObjectOAMDataPointer], a
	ld a, HIGH(YellowIntro_AnimatedObjectOAMData)
	ld [wAnimatedObjectOAMDataPointer + 1], a
	ld a, LOW(YellowIntro_AnimatedObjectFramesData)
	ld [wAnimatedObjectFramesDataPointer], a
	ld a, HIGH(YellowIntro_AnimatedObjectFramesData)
	ld [wAnimatedObjectFramesDataPointer + 1], a
	ret

YellowIntro_BlankOAMBuffer:
	ld hl, wShadowOAM
	ld bc, wShadowOAMEnd - wShadowOAM
	xor a
	call ByteFill
	ret

YellowIntro_BlankPalettes:
	xor a
	ldh [rBGP], a
	ldh [rOBP0], a
	ldh [rOBP1], a
	call YIntro_UpdateCGBPal_BGP
	call YIntro_UpdateCGBPal_OBP0
	call YIntro_UpdateCGBPal_OBP1
	ret

; Yellow's CGB palette layer (engine/gfx/palettes.asm, home/cgb_palettes.asm)

YellowIntroPaletteAction:
; e = 0: PalPacket_Generic (MEWMON, ROUTE, ROUTE, ROUTE)
; e = 1: PalPacket_PikachusBeach, then BG palette 1 (and base palette 1) from
;        PalPacket_Generic's first palette (MEWMON), as in Yellow
	ld a, e
	and a
	jr nz, .beach
	ld hl, YIntroPalPacket_Generic
	jp YIntro_InitCGBPalettes

.beach
	ld hl, YIntroPalPacket_PikachusBeach
	call YIntro_InitCGBPalettes
	ld de, YIntroPal_Mewmon
	ld a, e
	ld [wYIntroBasePals + 2], a
	ld a, d
	ld [wYIntroBasePals + 2 + 1], a
	ldh a, [rBGP]
	ld [wYIntroLastBGP], a
	ld b, a
	call YIntro_DMGPalToCGBPal
	ld a, 1
	jp YIntro_TransferCurBGPData

YIntroPalPacket_Generic:
	dw YIntroPal_Mewmon, YIntroPal_Route, YIntroPal_Route, YIntroPal_Route
YIntroPalPacket_PikachusBeach:
	dw YIntroPal_PikachusBeach, YIntroPal_PikachusBeach, YIntroPal_PikachusBeach, YIntroPal_PikachusBeach

; Yellow's CGBBasePalettes entries
YIntroPal_Route:
	RGB 31,31,31, 16,31,04, 11,23,31, 03,03,03
YIntroPal_Mewmon:
	RGB 31,31,31, 31,31,00, 31,01,01, 03,03,03
YIntroPal_PikachusBeach:
	RGB 31,31,31, 31,31,00, 11,23,31, 03,03,03

YIntro_InitCGBPalettes:
; hl = four base palette pointers.  Yellow: InitCGBPalettes
	ld de, wYIntroBasePals
	ld bc, 4 * 2
	call CopyBytes
	ld c, 0
.loop
	push bc
	ld a, c
	call YIntro_GetBasePal
	push de
	ldh a, [rBGP]
	ld [wYIntroLastBGP], a
	ld b, a
	call YIntro_DMGPalToCGBPal
	pop de
	pop bc
	push bc
	ld a, c
	call YIntro_TransferCurBGPData
	pop bc
	push bc
	push de
	ldh a, [rOBP0]
	ld [wYIntroLastOBP0], a
	ld b, a
	call YIntro_DMGPalToCGBPal
	pop de
	pop bc
	push bc
	ld a, c
	call YIntro_TransferCurOBPData
	pop bc
	push bc
	ldh a, [rOBP1]
	ld [wYIntroLastOBP1], a
	ld b, a
	call YIntro_DMGPalToCGBPal
	pop bc
	push bc
	ld a, c
	add 4
	call YIntro_TransferCurOBPData
	pop bc
	inc c
	ld a, c
	cp 4
	jr nz, .loop
	ret

YIntro_GetBasePal:
; de = base palette pointer a
	add a
	add LOW(wYIntroBasePals)
	ld l, a
	ld a, 0
	adc HIGH(wYIntroBasePals)
	ld h, a
	ld e, [hl]
	inc hl
	ld d, [hl]
	ret

YIntro_DMGPalToCGBPal:
; wYIntroCGBPal = base palette de remapped by DMG palette byte b
	ld hl, wYIntroCGBPal
	ld c, PAL_COLORS
.loop
	push de
	ld a, b
	and %11
	add a
	add e
	ld e, a
	ld a, 0
	adc d
	ld d, a
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	pop de
	rrc b
	rrc b
	dec c
	jr nz, .loop
	ret

YIntro_TransferCurBGPData:
; Copy wYIntroCGBPal to BG palette a (one colour per blanking period).
	add a
	add a
	add a
	or BGPI_AUTOINC
	ldh [rBGPI], a
	ld c, LOW(rBGPD)
	jr YIntro_TransferCurPalData

YIntro_TransferCurOBPData:
	add a
	add a
	add a
	or OBPI_AUTOINC
	ldh [rOBPI], a
	ld c, LOW(rOBPD)
YIntro_TransferCurPalData:
; Kanto hack (M12e): two colours per blanking period where Yellow writes one.
; Pyrite's VBlank handler ends ~4 lines later than Yellow's, and on the first
; frame of scene 10 that pushed YIntro_RunObjectAnimations past line 144 and
; cost a frame; this wins back the lines so every later scene keeps Yellow's
; frame. 2 colours = 16 M-cycles, well inside a mode-0 period.
	ld hl, wYIntroCGBPal
	ld b, PAL_COLORS / 2
.loop
	ldh a, [rLCDC]
	bit B_LCDC_ENABLE, a
	jr z, .write
; Yellow: TransferPalColorLCDEnabled -- wait out any blanking period, then
; wait for the next one
.wait_not_blank
	ldh a, [rSTAT]
	and %10
	jr z, .wait_not_blank
.wait_blank
	ldh a, [rSTAT]
	and %10
	jr nz, .wait_blank
.write
	ld a, [hli]
	ldh [c], a
	ld a, [hli]
	ldh [c], a
	ld a, [hli]
	ldh [c], a
	ld a, [hli]
	ldh [c], a
	dec b
	jr nz, .loop
	ret

YIntro_UpdateCGBPal_BGP:
; Yellow: UpdateCGBPal_BGP / _UpdateCGBPal_BGP / TransferBGPPals
	push af
	push bc
	push de
	push hl
	ldh a, [rBGP]
	ld hl, wYIntroLastBGP
	cp [hl]
	jr z, .done
	ld [hl], a
	ld c, 0
.loop
	push bc
	ld a, c
	call YIntro_GetBasePal
	ldh a, [rBGP]
	ld b, a
	call YIntro_DMGPalToCGBPal
	pop bc
	push bc
	ld a, c
	add a
	add a
	add a
	add LOW(wYIntroBGPBuffer)
	ld e, a
	ld a, 0
	adc HIGH(wYIntroBGPBuffer)
	ld d, a
	ld hl, wYIntroCGBPal
	ld bc, 1 palettes
	call CopyBytes
	pop bc
	inc c
	ld a, c
	cp 4
	jr nz, .loop
; TransferBGPPals: all four at once, after LY 144 if the LCD is on
	ldh a, [rLCDC]
	bit B_LCDC_ENABLE, a
	jr z, .transfer
	di
.wait
	ldh a, [rLY]
	cp LY_VBLANK
	jr c, .wait
.transfer
	ld a, BGPI_AUTOINC
	ldh [rBGPI], a
	ld hl, wYIntroBGPBuffer
	ld c, 4 palettes
.copy
	ld a, [hli]
	ldh [rBGPD], a
	dec c
	jr nz, .copy
	ei
.done
	pop hl
	pop de
	pop bc
	pop af
	ret

YIntro_UpdateCGBPal_OBP0:
	push af
	push bc
	push de
	push hl
	ldh a, [rOBP0]
	ld hl, wYIntroLastOBP0
	ld c, 0
	jr YIntro_UpdateCGBPal_OBP

YIntro_UpdateCGBPal_OBP1:
	push af
	push bc
	push de
	push hl
	ldh a, [rOBP1]
	ld hl, wYIntroLastOBP1
	ld c, 4
	; fallthrough
YIntro_UpdateCGBPal_OBP:
; Yellow: _UpdateCGBPal_OBP (OBP0 -> OBJ palettes 0-3, OBP1 -> 4-7)
	cp [hl]
	jr z, .done
	ld [hl], a
	ld b, a
	ld a, c
	add 4
	ld c, a
.loop
	push bc
	ld a, c
	and 3
	call YIntro_GetBasePal
	call YIntro_DMGPalToCGBPal
	pop bc
	push bc
	ld a, c
	sub 4
	call YIntro_TransferCurOBPData
	pop bc
	inc c
	ld a, c
	and 3
	jr nz, .loop
.done
	pop hl
	pop de
	pop bc
	pop af
	ret

YellowIntro_GetJumptableEntry: ; Yellow: Func_fa06e
	ld e, a
	ld d, $0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

YellowIntro_AnimatedObjectSpawnStateData:
	db $00, $00, $00
	db $01, $01, $00
	db $02, $01, $00
	db $03, $01, $00
	db $04, $02, $00
	db $05, $03, $00
	db $06, $04, $00
	db $07, $01, $00
	db $08, $05, $00
	db $09, $01, $00
	db $0a, $01, $00

YellowIntro_AnimatedObjectJumptable:
	dw Func_fa007
	dw Func_fa007
	dw Func_fa008
	dw Func_fa014
	dw Func_fa02b
	dw Func_fa062

Func_fa007:
	ret

Func_fa008:
	ld hl, $4
	add hl, bc
	ld a, [hl]
	cp $58
	ret z
	sub $4
	ld [hl], a
	ret

Func_fa014:
	ld hl, $4
	add hl, bc
	ld a, [hl]
	cp $58
	jr z, .asm_fa020
	add $4
	ld [hl], a
.asm_fa020
	ld hl, $5
	add hl, bc
	cp $58
	ret z
	add $1
	ld [hl], a
	ret

Func_fa02b:
	ld hl, $b
	add hl, bc
	ld e, [hl]
	ld d, $0
	ld hl, Jumptable_fa03b
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

Jumptable_fa03b:
	dw Func_fa03f
	dw Func_fa051

Func_fa03f:
	ld hl, $5
	add hl, bc
	ld a, [hl]
	cp $58
	jr z, .asm_fa04c
	sub $2
	ld [hl], a
	ret

.asm_fa04c
	ld hl, $b
	add hl, bc
	inc [hl]
Func_fa051:
	ld hl, $c
	add hl, bc
	ld a, [hl]
	inc [hl]
	ld d, $8
	call Func_fa079
	ld hl, $7
	add hl, bc
	ld [hl], a
	ret

Func_fa062:
	ld hl, $b
	add hl, bc
	ld a, [hl]
	ld hl, $4
	add hl, bc
	add [hl]
	ld [hl], a
	ret

Func_fa079:
	and $3f
	cp $20
	jr nc, .asm_fa084
	call Func_fa08e
	ld a, h
	ret

.asm_fa084
	and $1f
	call Func_fa08e
	ld a, h
	xor $ff
	inc a
	ret

Func_fa08e:
	ld e, a
	ld a, d
	ld d, $0
	ld hl, Unkn_fa0aa
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $0
.asm_fa09d
	srl a
	jr nc, .asm_fa0a2
	add hl, de
.asm_fa0a2
	sla e
	rl d
	and a
	jr nz, .asm_fa09d
	ret

Unkn_fa0aa:
	sine_table 32

INCLUDE "data/sprite_anims/yellow_intro_frames.asm"
INCLUDE "data/sprite_anims/yellow_intro_oam.asm"

YellowIntroGraphics1: INCBIN "gfx/intro/yellow_intro_1.2bpp"
YellowIntroGraphics1End::
YellowIntroGraphics2: INCBIN "gfx/intro/yellow_intro_2.2bpp"
YellowIntroGraphics2End::
