; Yellow's pikapic face-box engine (docs/PIKACHU-EMOTIONS.md A5 steps E3/E4),
; ported from vendor/pokeyellow/engine/pikachu/pikachu_pic_animation.asm.
;
; The bytecode, the object structs, the frame/tilemap walkers, the 8-slot GFX
; allocator and the $80-tile VRAM cap are Yellow's, instruction for
; instruction.  Only the calls into hardware Gen 2 does differently change:
;
;   hAutoBGTransferEnabled -> hBGMapMode (both push a third of the BG map per
;                             frame, so Delay3 == `ld c, 3 / call DelayFrames`)
;   CopyVideoDataAlternate -> Get2bpp        (same b:de -> hl, c tiles contract)
;   UncompressSpriteFromDE -> DecompressRequest2bpp (Crystal's LZ + sScratch)
;   vNPCSprites            -> vTiles0 (+ $80 * $10 = vTiles1, the font area,
;                             exactly what Pokepic borrows; VRAM bank 0)
;   JoypadLowSensitivity   -> GetJoypad + hJoyPressed
;   PlaySound/THUNDERBOLT  -> PlaySFX SFX_THUNDER
;   UpdateCGBPal_BGP       -> DmgToCgbBGPals (same "reinterpret a DMG BGP byte"
;                             job, so PikaPicAnimThunderboltPals is used verbatim)
;   PlayPikachuSoundClip   -> PlayPikachuVoiceClip (emotions.asm, same bank)
;
; Every wPikaPic* variable lives in WRAMX bank 2 (WRAM0 had 51 bytes free), so
; Pikapic holds rWBK at BANK(wPikaPicAnimTimer) for the whole run, the way
; SetUpPokeAnim does.  Everything VBlank touches is WRAM0, and the routines
; that do reach into WRAMX (UpdatePalsIfCGB, AnimateTileset, DmgToCgbBGPals)
; save and restore rWBK themselves.


Pikapic::
; Yellow's StarterPikachuEmotionCommand_pikapic + .RunPikapic.
; Runs the script selected by wPikaPicAnimNumber (WRAM0, set by E5's
; StarterPikachuEmotionCommand_pikapic) inside a 7x7 text box.
	ldh a, [hBGMapMode]
	push af
	ld a, [wStateFlags]
	and 1 << TEXT_STATE_F
	push af
	xor a
	ldh [hBGMapMode], a

	call OpenPikapicBox

	ldh a, [rWBK]
	push af
	ld a, BANK(wPikaPicAnimTimer)
	ldh [rWBK], a

	call ResetPikaPicAnimBuffer
	call LoadCurrentPikaPicAnimScriptPointer
	call ExecutePikaPicAnimScript

	pop af
	ldh [rWBK], a

	call ClosePikapicBox

; OpenPikapicBox re-anchors the BG map, which sets TEXT_STATE_F the way
; Crystal's OpenText does.  Put it back the way we found it.
	pop af
	ld hl, wStateFlags
	res TEXT_STATE_F, [hl]
	and a
	jr z, .text_was_closed
	set TEXT_STATE_F, [hl]
.text_was_closed

	pop af
	ldh [hBGMapMode], a
	ret


; === E4: the box ============================================================

OpenPikapicBox:
; Yellow's PlacePikapicTextBoxBorder + LoadOverworldPikachuFrontpicPalettes.
; The border tiles ('┌'..'┘', $79-$7f) live in vTiles2, so they survive the
; animation overwriting vTiles1; only the font has to be reloaded afterwards.
;
; DEVIATION: Crystal's overworld BG map is scroll-anchored (wBGMapAnchor, and
; hSCX/hSCY move as the player walks), so a full wTilemap -> BG map copy only
; lands where the tilemap says it does once the map has been re-anchored.
; Crystal's own OpenText does exactly this before drawing a textbox, and
; Pokepic gets it for free because `pokepic` always follows `opentext`.  The
; follower runs the emotion from a callasm with no text open, so do it here.
; It is invisible: the same view is redrawn at anchor 0 with hSCX/hSCY = 0.
	farcall ReanchorBGMap_NoOAMUpdate
	xor a
	ldh [hBGMapMode], a
	hlcoord PIKAPIC_BOX_X, PIKAPIC_BOX_Y
	lb bc, PIKAPIC_BOX_H - 2, PIKAPIC_BOX_W - 2
	call TextboxBorder
; PE1 / E8a: Yellow draws this box with its own TextBoxBorder, i.e. Yellow's
; text-box frame (gfx/font/font_extra.png tiles $79-$7e: the double rule with
; a knob on each corner), not whichever of Crystal's eight frames the player
; picked in OPTION.  The tile ids are the same in both games ('┌'..'┘' =
; $79-$7e), so swap Yellow's frame into those six vTiles2 slots for the life
; of the box; ClosePikapicBox puts the player's frame back with LoadFrame.
	ld de, PikapicBorderGFX
	ld hl, vTiles2 tile '┌'
	lb bc, BANK(PikapicBorderGFX), TEXTBOX_FRAME_TILES
	call Get2bpp

; DEVIATION: Crystal's blank tile ' ' ($7f, in vTiles2) is plane0 = $ff /
; plane1 = $00 -- every pixel is colour 1.  Under PAL_BG_TEXT that reads white,
; but the box's attrmap slot holds Pikachu's palette, where colour 1 is yellow,
; so an unpainted interior flashed solid yellow.  Yellow's own blank is colour
; 0, so park an all-zero tile at the top of the borrowed font area (BG id $ff)
; and use that instead.  LoadStandardFont puts the font back over it on close,
; and CheckIfThereIsRoomForPikaPicAnimGFX stops at PIKAPIC_MAX_TILES so no blob
; can reach it.
	ld de, PikapicBlankTileGFX
	ld hl, vTiles1 + (PIKAPIC_BLANK_TILE - $80) * LEN_2BPP_TILE
	lb bc, BANK(PikapicBlankTileGFX), 1
	call Get2bpp
	hlcoord PIKAPIC_BOX_X + 1, PIKAPIC_BOX_Y + 1
	lb bc, PIKAPIC_BOX_H - 2, PIKAPIC_BOX_W - 2
	ld a, PIKAPIC_BLANK_TILE
	call FillBoxWithByte

	call UpdateSprites
	call ApplyTilemap
	ld b, SCGB_PIKAPIC
	call GetSGBLayout
; ReanchorBGMap leaves Crystal in "text mode": hWY = 0, so the window (LCDC
; bit 6 -> vBGMap1) covers the screen and everything we draw into vBGMap0 is
; hidden behind it.  The face box is not a textbox, so turn the window off
; again -- now that ApplyTilemap has put the map and the border into vBGMap0.
	ld a, $90
	ldh [hWY], a
	xor a
	ldh [hBGMapMode], a
	ret

ClosePikapicBox:
; Yellow gets the map back for free because the text engine redraws it; our
; follower runs this from a callasm, so do what ClosePokepic does.
	xor a
	ldh [hBGMapMode], a
; Empty the interior with the colour-0 blank, not ClearBox's ' ' -- and leave
; the border alone, so the box visibly empties and closes instead of turning
; into a bare square.  (ClearBox here also spanned the border, which is why the
; square lost its frame.)
	hlcoord PIKAPIC_BOX_X + 1, PIKAPIC_BOX_Y + 1
	lb bc, PIKAPIC_BOX_H - 2, PIKAPIC_BOX_W - 2
	ld a, PIKAPIC_BLANK_TILE
	call FillBoxWithByte
	call WaitBGMap
	call GetMemSGBLayout
	xor a
	ldh [hBGMapMode], a
	call LoadOverworldTilemapAndAttrmapPals
	farcall RestorePikapicMapPals
	call ApplyTilemap
	call UpdateSprites
	call LoadStandardFont
	farcall LoadFrame ; PE1 / E8a: the player's OPTION frame back over Yellow's
	ret


; === E3: the engine =========================================================

ResetPikaPicAnimBuffer:
	ld hl, wPikaPicAnimObjectDataBufferSize
	ld bc, wPikaPicAnimObjectDataBufferEnd - wPikaPicAnimObjectDataBufferSize
	xor a
	call ByteFill
	call ClearPikaPicUsedGFXBuffer
	ld hl, 100
	ld a, l
	ld [wPikaPicAnimTimer], a
	ld a, h
	ld [wPikaPicAnimTimer + 1], a
	xor a
	ld [wPikaPicAnimDelay], a
	ld a, PIKAPIC_BOX_X + 1
	ld [wPikaPicPikaDrawStartX], a
	ld a, PIKAPIC_BOX_Y + 1
	ld [wPikaPicPikaDrawStartY], a
	ret

LoadCurrentPikaPicAnimScriptPointer:
	ld a, [wPikaPicAnimNumber]
	cp $1d
	jr c, .valid
	ld a, $0
.valid
	ld e, a
	ld d, 0
	ld hl, PikaPicAnimPointers
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call UpdatePikaPicAnimPointer
	ret

ExecutePikaPicAnimScript:
.loop
	xor a
	ldh [hBGMapMode], a
	call RunPikaPicAnimSetupScript
	call AnimateCurrentPikaPicAnimFrame
	ld a, 1 ; BG Map 0 tiles
	ldh [hBGMapMode], a
	call PikaPicAnimTimerAndJoypad
	and a
	jr z, .loop
	ret

PikaPicAnimTimerAndJoypad:
; Yellow's Delay3: three frames is exactly one full pass of the BG map, in
; thirds, in both engines.
	ld c, 3
	call DelayFrames
	call CheckPikaPicAnimTimer
	and a
	ret nz
	call GetJoypad
	ldh a, [hJoyPressed]
	and A_BUTTON | B_BUTTON
	ret

CheckPikaPicAnimTimer:
	ld hl, wPikaPicAnimTimer
	dec [hl]
	jr nz, .not_done_yet
	inc hl
	ld a, [hl]
	and a
	jr z, .timer_expired
	dec [hl]
.not_done_yet
	xor a
	ret

.timer_expired
	ld a, $1
	ret

AnimateCurrentPikaPicAnimFrame:
	ld bc, wPikaPicAnimObjectDataBuffer
	ld a, 4
.loop
	push af
	push bc
	ld hl, 0 ; struct index
	add hl, bc
	ld a, [hli]
	and a
	jr z, .skip
	ld a, [hli]
	ld [wCurPikaPicAnimObjectScriptIdx], a
	ld a, [hli]
	ld [wCurPikaPicAnimObjectFrameIdx], a
	ld a, [hli]
	ld [wCurPikaPicAnimObjectFrameTimer], a
	ld a, [hli]
	ld [wCurPikaPicAnimObjectVTileOffset], a
	ld a, [hli]
	ld [wCurPikaPicAnimObjectXOffset], a
	ld a, [hli]
	ld [wCurPikaPicAnimObjectYOffset], a
	ld a, [hli]
	ld [wCurPikaPicAnimObject + 6], a
	push bc
	call LoadPikaPicAnimObjectData
	pop bc
	ld hl, 1 ; script index
	add hl, bc
	ld a, [wCurPikaPicAnimObjectScriptIdx]
	ld [hli], a
	ld a, [wCurPikaPicAnimObjectFrameIdx]
	ld [hli], a
	ld a, [wCurPikaPicAnimObjectFrameTimer]
	ld [hli], a
	ld a, [wCurPikaPicAnimObjectVTileOffset]
	ld [hli], a
	ld a, [wCurPikaPicAnimObjectXOffset]
	ld [hli], a
	ld a, [wCurPikaPicAnimObjectYOffset]
	ld [hli], a
	ld a, [wCurPikaPicAnimObject + 6]
	ld [hl], a
.skip
	pop bc
	ld hl, 8
	add hl, bc
	ld b, h
	ld c, l
	pop af
	dec a
	jr nz, .loop
	ret

PikaPicAnimCommand_object:
	ld hl, wPikaPicAnimObjectDataBuffer
	ld de, 8
	ld c, 4
.loop
	ld a, [hl]
	and a
	jr z, .found
	add hl, de
	dec c
	jr nz, .loop
	scf
	ret

.found
	ld a, [wPikaPicAnimObjectDataBufferSize]
	inc a
	ld [wPikaPicAnimObjectDataBufferSize], a
	ld [hli], a
	call GetPikaPicAnimByte
	ld [hli], a
	call GetPikaPicAnimByte
	ld [hl], a
	xor a
	ld [hli], a ; overloads
	ld [hli], a
	call GetPikaPicAnimByte
	ld [hli], a
	call GetPikaPicAnimByte
	ld [hli], a
	call GetPikaPicAnimByte
	ld [hli], a
	and a
	ret

PikaPicAnimCommand_deleteobject:
	call GetPikaPicAnimByte
	ld b, a
	ld hl, wPikaPicAnimObjectDataBuffer
	ld de, 8
	ld c, 4
.search
	ld a, [hl]
	cp b
	jr z, .delete
	add hl, de
	dec c
	jr nz, .search
	scf
	ret

.delete
	xor a
	ld [hl], a
	ret

LoadPikaPicAnimObjectData:
.loop
	ld a, [wCurPikaPicAnimObjectScriptIdx]
	cp $23
	jr c, .valid
	ld a, $4
.valid
	ld e, a
	ld d, 0
	ld hl, PikaPicAnimBGFramesPointers
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wCurPikaPicAnimObjectFrameIdx]
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	cp $e0
	jr z, .end
	jr .init

.end
	xor a
	ld [wCurPikaPicAnimObjectFrameIdx], a
	ld [wCurPikaPicAnimObjectFrameTimer], a
	jr .loop

.init
	push hl
	call LoadCurPikaPicObjectTilemap
	pop hl
	ld a, [hl]
	and a
	jr z, .not_done ; lasts forever
	ld a, [wCurPikaPicAnimObjectFrameTimer]
	inc a
	ld [wCurPikaPicAnimObjectFrameTimer], a
	cp [hl]
	jr nz, .not_done
	xor a
	ld [wCurPikaPicAnimObjectFrameTimer], a
	ld a, [wCurPikaPicAnimObjectFrameIdx]
	inc a
	ld [wCurPikaPicAnimObjectFrameIdx], a
.not_done
	ret

LoadCurPikaPicObjectTilemap:
; a = tilemap index.  Tilemap 0 means "draw nothing".
	and a
	ret z
	ld e, a
	ld d, 0
	ld hl, PikaPicTilemapPointers
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [de]
	ld c, a ; height
	inc de
	ld a, [de]
	ld b, a ; width
	inc de
	push de
	push bc
	call .GetStartCoords
	pop bc
	pop de
.row
	push bc
	push hl
	ld a, [wCurPikaPicAnimObjectVTileOffset] ; tile id offset
	ld c, a
.col
	ld a, [de]
	inc de
	cp $ff
	jr z, .skip
	add c
	ld [hl], a
.skip
	inc hl
	dec b
	jr nz, .col
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec c
	jr nz, .row
	ret

.GetStartCoords:
	push bc
	ld a, [wCurPikaPicAnimObjectYOffset]
	ld b, a
	ld a, [wPikaPicPikaDrawStartY]
	add b
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH
	call AddNTimes
	ld a, [wCurPikaPicAnimObjectXOffset]
	ld c, a
	ld a, [wPikaPicPikaDrawStartX]
	add c
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
	ret

LoadPikaPicAnimGFXHeader:
; a = header index -> c = tile count ($ff if compressed), b = bank, de = address
	push hl
	ld e, a
	ld d, 0
	ld hl, PikaPicAnimGFXHeaders
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	pop hl
	ret

RunPikaPicAnimSetupScript:
	call .CheckAndAdvanceTimer
	ret c
	xor a
	ld [wPikaPicAnimPointerSetupFinished], a
.loop
	call GetPikaPicAnimByte
	ld e, a
	ld d, 0
	ld hl, .Jumptable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call _hl_
	ld a, [wPikaPicAnimPointerSetupFinished]
	and a
	jr z, .loop
	ret

.CheckAndAdvanceTimer:
	ld a, [wPikaPicAnimDelay]
	and a
	ret z
	dec a
	ld [wPikaPicAnimDelay], a
	scf
	ret

.Jumptable:
; entries correspond to the pikapic_* command ids (macros/scripts/pikapic.asm)
	table_width 2
	dw PikaPicAnimCommand_nop          ; 00, 0 params
	dw PikaPicAnimCommand_writebyte    ; 01, 1 param
	dw PikaPicAnimCommand_loadgfx      ; 02, 1 param
	dw PikaPicAnimCommand_object       ; 03, 5 params
	dw PikaPicAnimCommand_nop4         ; 04, 0 params
	dw PikaPicAnimCommand_nop5         ; 05, 0 params
	dw PikaPicAnimCommand_deleteobject ; 06, 1 param
	dw PikaPicAnimCommand_nop7         ; 07, 0 params
	dw PikaPicAnimCommand_nop8         ; 08, 0 params
	dw PikaPicAnimCommand_jump         ; 09, 1 dw param
	dw PikaPicAnimCommand_setduration  ; 0a, 1 dw param
	dw PikaPicAnimCommand_cry          ; 0b, 1 param
	dw PikaPicAnimCommand_thunderbolt  ; 0c, 0 params
	dw PikaPicAnimCommand_run          ; 0d, 0 params
	dw PikaPicAnimCommand_ret          ; 0e, 0 params
	assert_table_length NUM_PIKAPIC_COMMANDS

PikaPicAnimCommand_nop:
PikaPicAnimCommand_nop4:
PikaPicAnimCommand_nop5:
PikaPicAnimCommand_nop7:
PikaPicAnimCommand_nop8:
	ret

PikaPicAnimCommand_ret:
	ld a, 1
	ld [wPikaPicAnimTimer], a
	xor a
	ld [wPikaPicAnimTimer + 1], a
	jr PikaPicAnimCommand_run

PikaPicAnimCommand_setduration:
	call GetPikaPicAnimByte
	ld [wPikaPicAnimTimer], a
	call GetPikaPicAnimByte
	ld [wPikaPicAnimTimer + 1], a
	ret

PikaPicAnimCommand_run:
	ld a, $ff
	ld [wPikaPicAnimPointerSetupFinished], a
	ret

PikaPicAnimCommand_writebyte:
	call GetPikaPicAnimByte
	ld [wPikaPicAnimDelay], a
	ret

PikaPicAnimCommand_jump:
	call GetPikaPicAnimByte
	ld l, a
	call GetPikaPicAnimByte
	ld h, a
	call UpdatePikaPicAnimPointer
	ret

GetPikaPicAnimByte:
	push hl
	ld hl, wPikaPicAnimPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	call UpdatePikaPicAnimPointer
	pop hl
	ret

UpdatePikaPicAnimPointer:
	push af
	ld a, l
	ld [wPikaPicAnimPointer], a
	ld a, h
	ld [wPikaPicAnimPointer + 1], a
	pop af
	ret

PikaPicAnimCommand_loadgfx:
	ldh a, [hOAMUpdate]
	push af
	ld a, 1
	ldh [hOAMUpdate], a
	ldh a, [hBGMapMode]
	push af
	xor a
	ldh [hBGMapMode], a
	ldh a, [hMapAnims]
	push af
	xor a
	ldh [hMapAnims], a

	call GetPikaPicAnimByte
	ld [wPikaPicAnimCurGraphicID], a
	call LoadPikaPicAnimGFXHeader
	ld a, c
	cp $ff
	jr z, .compressed
	call RequestPikaPicAnimGFX
	jr .done

.compressed
	call DecompressRequestPikaPicAnimGFX
.done
	pop af
	ldh [hMapAnims], a
	pop af
	ldh [hBGMapMode], a
	pop af
	ldh [hOAMUpdate], a
	ret

RequestPikaPicAnimGFX:
; b:de = raw 2bpp source, c = tile count.
	push de
	ld a, [wPikaPicAnimCurGraphicID]
	ld d, a
	ld e, c
	call CheckIfThereIsRoomForPikaPicAnimGFX
	pop de
	jr c, .failed
	call GetPikaPicVRAMAddressForNewGFX
	call Get2bpp ; c tiles from b:de to hl
	and a
.failed
	ret

DecompressRequestPikaPicAnimGFX:
; b:de = LZ source.  Yellow hardcodes 5*5 tiles here and every shipped blob is
; exactly that size (see the E1 findings), so the size stays hardcoded.
	push de
	ld a, [wPikaPicAnimCurGraphicID]
	ld d, a
	ld e, PIKAPIC_COMPRESSED_TILES
	call CheckIfThereIsRoomForPikaPicAnimGFX
	pop de
	jr c, .failed
	call GetPikaPicVRAMAddressForNewGFX
; DecompressRequest2bpp wants b:hl = source and de = destination, the opposite
; way round from Get2bpp.
	push hl
	ld h, d
	ld l, e
	pop de
	ld c, PIKAPIC_COMPRESSED_TILES
	call DecompressRequest2bpp
	and a
.failed
	ret

ClearPikaPicUsedGFXBuffer:
	ld hl, wPikaPicUsedGFXCount
	ld bc, wPikaPicUsedGFXEnd - wPikaPicUsedGFXCount
	xor a
	call ByteFill
	ret

GetPikaPicVRAMAddressForNewGFX:
; a = tile offset ($80-$ff) -> hl = vTiles0 + a * $10, i.e. vTiles1 onwards.
; Yellow's vNPCSprites is its $8000, so this is the same arithmetic.
	push bc
	ld b, a
	and $f
	swap a
	ld c, a
	ld a, b
	and $f0
	swap a
	ld b, a
	ld hl, vTiles0
	add hl, bc
	pop bc
	ret

CheckIfThereIsRoomForPikaPicAnimGFX:
; d: graphic id, e: size in tiles.
; Returns the tile offset in a, carry set if there is no room.
; DEVIATION: Yellow's ".loop" overflow and ".found" exits `ret` without popping
; hl and bc first, which its own comment calls out as "the game will execute
; arbitrary code".  Both are fixed here to fall through to .pop_ret.  No
; shipped script reaches either path, so behaviour is unchanged.
	push bc
	push hl
	ld hl, wPikaPicUsedGFX
	ld c, 8
.loop
	ld a, [hl]
	and a
	jr z, .empty
	cp d
	jr z, .found
	inc hl
	inc hl
	dec c
	jr nz, .loop
	scf
	jr .pop_ret

.found
; Already loaded: hand back the offset it got last time and let the caller
; copy it again, which is what Yellow meant to do.
	inc hl
	ld a, [hl]
	and a ; clear carry (offsets are $80+, never 0)
	jr .pop_ret

.empty
	ld [hl], d
	inc hl
	ld a, [wPikaPicUsedGFXCount]
	add $80
	ld [hl], a
	ld a, [wPikaPicUsedGFXCount]
	add e
	ld [wPikaPicUsedGFXCount], a
; DEVIATION: Yellow's cap is $80 tiles ($80-$ff).  Ours is one lower so that
; BG id $ff stays the box's colour-0 blank (see OpenPikapicBox).  The largest
; shipped script needs 125 tiles, so nothing is turned away that Yellow accepts.
	cp PIKAPIC_MAX_TILES
	jr z, .okay
	jr nc, .failed
.okay
	ld a, [hl]
	and a
	jr .pop_ret

.failed
	scf
.pop_ret
	pop hl
	pop bc
	ret

PikaPicAnimCommand_cry:
	call GetPikaPicAnimByte
	cp PIKACRY_NONE
	ret z
	ld e, a
	call PlayPikachuVoiceClip
	ret

PikaPicAnimCommand_thunderbolt:
; Yellow mutes the music, plays the THUNDERBOLT move sound out of
; MoveSoundTable and flashes rBGP while it runs.  Crystal's PlaySFX already
; ducks the music for the duration of an SFX, so only the sound id differs.
	ld de, SFX_THUNDER
	call PlaySFX
	call .FlashScreen
	call WaitSFX
	ret

.FlashScreen:
	ld hl, PikaPicAnimThunderboltPals
.loop
	ld a, [hli]
	cp $ff
	ret z
	ld c, a
	ld b, [hl]
	inc hl
	push hl
	call .UpdatePal
	pop hl
	jr .loop

.UpdatePal:
; b = a Gen 1 BGP byte.  DmgToCgbBGPals writes it to rBGP and, on CGB,
; re-orders wBGPals1 into wBGPals2 through it -- exactly Yellow's
; UpdateCGBPal_BGP.  It preserves bc, so c stays the frame count.
	ld a, b
	call DmgToCgbBGPals
	call DelayFrames
	ret


PikapicBlankTileGFX:
; One all-zero tile: every pixel colour 0, the way Yellow's blank reads.
	ds LEN_2BPP_TILE, 0

PikapicBorderGFX:
; PE1 / E8a: Yellow's text-box frame, '┌' '─' '┐' '│' '└' '┘' (tiles $79-$7e of
; vendor/pokeyellow/gfx/font/font_extra.png), cropped verbatim.
INCBIN "gfx/pikachu/pikapic_border.2bpp"

