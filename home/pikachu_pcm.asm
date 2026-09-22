SECTION "Pikachu PCM", ROM0

PlayPikachuPCM::
; b = bank of the clip, hl = its address: a `dw length - 1` header followed by
; raw 1-bit PWM samples at 22050 Hz, 8 samples per byte, MSB first.
; Ported from vendor/pokeyellow/home/pikachu_cries.asm ($0150-$01aa).
;
; This MUST live in ROM0: it banks to the clip's bank itself, which would swap
; out its own caller.  It also walks `ld a, [hli]` straight through $4000-$7fff,
; so a clip may never straddle a bank boundary (each one is its own pinned
; section in audio/pikachu_cries.asm, which rgbasm guarantees is contiguous).
;
; The loop is HAND-TIMED: the two call/ret pairs per bit and the `ld a, $3` /
; `dec a` spins ARE the sample rate.  Do not restructure it, and never run it in
; double speed -- it would play an octave high.  Crystal is single speed
; everywhere outside lib/mobile (home/init.asm calls NormalSpeed), which
; PlayPikachuSoundClip asserts at assembly time.
;
; The caller must already have di'd; it also owns the channel-3 setup and
; teardown.  Yellow's `call BankswitchCommon` is inlined here as Crystal's
; two-register bankswitch -- that is outside the sample loop, so the rate is
; unaffected.
	ldh a, [hROMBank]
	push af
	ld a, b
	ldh [hROMBank], a
	ld [rROMB], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
.loop
	ld a, [hli]
	ld d, a
	ld a, $3
.playSingleSample
	dec a
	jr nz, .playSingleSample

rept 7
	call LoadNextSoundClipSample
	call PlaySoundClipSample
endr

	call LoadNextSoundClipSample
	dec bc
	ld a, c
	or b
	jr nz, .loop
	pop af
	ldh [hROMBank], a
	ld [rROMB], a
	ret

LoadNextSoundClipSample::
; Shift the top bit of d out into channel 3's output level: $20 (100%) for a
; 1 bit, $00 (mute) for a 0.  That is the whole 1-bit DAC.
	ld a, d
	and $80
	srl a
	srl a
	ldh [rAUD3LEVEL], a
	sla d
	ret

PlaySoundClipSample::
; Pure delay -- the other half of the bit period.
	ld a, $3
.loop
	dec a
	jr nz, .loop
	ret
