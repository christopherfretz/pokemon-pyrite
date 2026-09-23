; M13-Q5: the Crystal intro SFX (Unown 1-3, Suicune 1-4, Pichu) were dead
; after the M12 Yellow-boot port; their SFX ids stay and point here.
Sfx_DeadCrystalIntro:
	channel_count 1
	channel 5, Sfx_DeadCrystalIntro_Ch5

Sfx_DeadCrystalIntro_Ch5:
	sound_ret

Sfx_DittoPopUp:
	channel_count 1
	channel 5, Sfx_DittoPopUp_Ch5

Sfx_DittoPopUp_Ch5:
	duty_cycle 2
	pitch_sweep 1, -6
	square_note 3, 8, 2, 1792
	square_note 1, 3, 1, 1793
	pitch_sweep 1, 6
	square_note 4, 11, 1, 1600
	square_note 16, 3, 1, 1601
	sound_ret

Sfx_DittoTransform:
	channel_count 1
	channel 5, Sfx_DittoTransform_Ch5

Sfx_DittoTransform_Ch5:
	duty_cycle 1
	pitch_sweep 2, 6
	square_note 20, 3, -3, 1088
	square_note 4, 9, 7, 1216
	square_note 4, 6, 7, 1217
	square_note 4, 4, 2, 1218
	sound_ret

Sfx_DittoBounce:
	channel_count 1
	channel 5, Sfx_DittoBounce_Ch5

Sfx_DittoBounce_Ch5:
	duty_cycle 2
	pitch_sweep 2, -4
	square_note 2, 8, 2, 1200
	square_note 0, 3, 1, 1200
	pitch_sweep 3, 4
	square_note 16, 11, 1, 1056
	sound_ret

Sfx_GameFreakPresents:
	channel_count 1
	channel 5, Sfx_GameFreakPresents_Ch5

Sfx_GameFreakPresents_Ch5:
	toggle_sfx
	duty_cycle 2
	note_type 2, 11, 1
	pitch_sweep 15, -7
	transpose 1, 10
	octave 5
	note C_, 2
	note E_, 2
	note G_, 2
	octave 6
	note C_, 2
	note E_, 2
	note G_, 3
	volume_envelope 8, 1
	note G_, 3
	volume_envelope 5, 1
	note G_, 3
	volume_envelope 3, 1
	note G_, 3
	sound_ret

Sfx_Tingle:
	channel_count 1
	channel 5, Sfx_Tingle_Ch5

Sfx_Tingle_Ch5:
	toggle_sfx
	duty_cycle 1
	transpose 0, 11
	note_type 1, 11, 1
.loop1:
	octave 5
	note C_, 3
	octave 6
	note G_, 2
	octave 5
	note C_, 3
	rest 2
	sound_loop 2, .loop1
	note C_, 2
	volume_envelope 10, 1
	note G_, 13
	sound_ret

Sfx_TwoPcBeeps:
	channel_count 1
	channel 5, Sfx_TwoPcBeeps_Ch5

Sfx_TwoPcBeeps_Ch5:
	duty_cycle 2
	square_note 2, 14, 8, 1986
	square_note 2, 2, 8, 1986
	square_note 2, 14, 8, 1986
	square_note 2, 2, 8, 1986
	sound_ret

Sfx_4NoteDitty:
	channel_count 3
	channel 5, Sfx_4NoteDitty_Ch5
	channel 6, Sfx_4NoteDitty_Ch6
	channel 7, Sfx_4NoteDitty_Ch7

Sfx_4NoteDitty_Ch5:
	toggle_sfx
	duty_cycle 2
	note_type 2, 14, 8
	transpose 0, 2
	octave 4
	note C_, 2
	volume_envelope 4, 8
	note C_, 2
	volume_envelope 14, 8
	note G_, 2
	volume_envelope 4, 8
	note G_, 2
	octave 5
	volume_envelope 14, 8
	note E_, 2
	volume_envelope 4, 8
	note E_, 2
	octave 6
	volume_envelope 14, 8
	note C_, 2
	volume_envelope 4, 3
	note C_, 16
	sound_ret

Sfx_4NoteDitty_Ch6:
	toggle_sfx
	note_type 2, 11, 8
	rest 9
	rest 16
	sound_ret

Sfx_4NoteDitty_Ch7:
	toggle_sfx
	note_type 2, 11, 8
	rest 9
	rest 16
	sound_ret

Sfx_Twinkle:
	channel_count 1
	channel 5, Sfx_Twinkle_Ch5

Sfx_Twinkle_Ch5:
	toggle_sfx
	duty_cycle 0
	transpose 0, 2
	note_type 2, 14, 1
	octave 3
	note G_, 2
	volume_envelope 11, 1
	octave 4
	note D_, 2
	volume_envelope 14, 1
	note B_, 2
	volume_envelope 11, 1
	note G_, 2
	volume_envelope 14, 1
	octave 5
	note D_, 2
	volume_envelope 11, 1
	octave 4
	note B_, 2
	volume_envelope 14, 1
	octave 5
	note G_, 6
	sound_ret
