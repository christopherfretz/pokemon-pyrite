; The bank-$3F half of Yellow's sampled-cry player.  Ported from
; vendor/pokeyellow/audio/pikachu_pcm.asm (bank $3c); the inner sample loop is
; in home/pikachu_pcm.asm because it has to bankswitch to the clip itself.
; Survey and decisions: docs/PIKA-PCM-CRY.md 0.4 / 0.6.

PlayPikachuSoundClip::
; e = a PikachuCryN id.  Plays Yellow's sampled clip for it and returns CARRY.
; Returns NO CARRY, having done nothing, if that id has no clip data (a null
; row in PikachuCriesPointerTable) -- the caller falls back to the synth cry.
;
; Blocks for the length of the clip (0.66 s - 1.70 s for Tier 1) with
; interrupts off, exactly as Yellow does: no VBlank means no OAM DMA, no BG-map
; transfer and no joypad for that window, so the screen holds one frame.  That
; is faithful, not a bug (A1-D6: Yellow does not mute the music either -- ch1/2/4
; simply hold their last note).
	ld d, 0
	ld hl, PikachuCriesPointerTable
	add hl, de
	add hl, de
	add hl, de
	ld b, [hl] ; bank of the clip data, or 0 for "not ported"
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, b
	and a
	ret z ; no carry: unported id

; Yellow waits 3 frames before the clip so the send-out animation settles.
	ld c, 4
.delay
	dec c
	jr z, .done_delay
	call DelayFrame
	jr .delay

.done_delay
; Crystal's sound driver runs from VBlank (home/vblank.asm), so di freezes it
; for the duration, and on ei the next frame rewrites rAUDVOL/rAUDTERM from
; wVolume/wSoundOutput (audio/engine.asm) -- no explicit restore needed.
	di
	push bc
	push hl
	ld a, $80
	ldh [rAUDENA], a
	ld a, $77
	ldh [rAUDVOL], a

; Fill channel 3's wave RAM with $ff, making it a constant full-scale source;
; rAUD3LEVEL is then toggled 100%/mute per bit, which is the 1-bit DAC.
; A1-D3: Yellow SAVES the old wave pattern here and restores it after the clip.
; We do not.  Crystal's driver reloads the pattern on every ch3 note attack
; (audio/engine.asm .ch3_noise_sampling -> .load_wave_pattern), unlike Yellow's,
; so the save/restore would be 16 B of WRAM and ~40 B of code for nothing.
	xor a
	ldh [rAUD3ENA], a
	ld hl, _AUD3WAVERAM
.fill_wave
	ld a, $ff
	ld [hli], a
	ld a, l
	cp LOW(_AUD3WAVERAM + AUD3WAVE_SIZE)
	jr nz, .fill_wave

	ld a, $80
	ldh [rAUD3ENA], a
	ldh a, [rAUDTERM]
	or $44 ; ch3 to both terminals
	ldh [rAUDTERM], a
	ld a, $ff
	ldh [rAUD3LEN], a
	ld a, $20
	ldh [rAUD3LEVEL], a
	ld a, $ff
	ldh [rAUD3LOW], a
	ld a, $87
	ldh [rAUD3HIGH], a
	pop hl
	pop bc
	call PlayPikachuPCM

; Silence channel 3 and hand it back to the driver.  Yellow restores its saved
; wave pattern here instead; ours is left full of $ff, so the DAC is switched
; off (rAUD3ENA = 0) rather than left holding DC until the next ch3 note.
	xor a
	ldh [rAUD3LEVEL], a
	ldh [rAUD3ENA], a
	ldh a, [rAUDTERM]
	and $bb
	ldh [rAUDTERM], a
	ld a, $80
	ldh [rAUDENA], a

; Yellow zeroes wChannelSoundIDs + CHAN5..CHAN8 here, cancelling any SFX that
; was playing; SFXChannelsOff is Crystal's equivalent.  Inside the di window,
; like Yellow's, so the driver cannot run mid-write.
	call SFXChannelsOff
	ei
	scf
	ret
