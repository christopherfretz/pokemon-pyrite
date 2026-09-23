; Kanto hack (M12b-3, docs/M12-STRETCH.md): the Surfing Pikachu minigame's
; Gen 1 sound effects, source-level ports of pokeyellow audio/sfx/surfing_*.asm
; and get_item2_4_2.asm (headers from audio/headers/sfxheaders4.asm).
; Translations: `toggle_sfx` -> `toggle_sfx`; `pitch_offset 1 ; Yellow: toggle_perfect_pitch` ->
; `pitch_offset 1`.  noise_note/square_note take the same arguments in both
; drivers (only the byte encoding differs).  PRESS_AB ($90 in Yellow) is not
; here: its only channel is byte-for-byte Crystal's SFX_READ_TEXT_2.

Sfx_SurfingJump:
	channel_count 1
	channel 8, Sfx_SurfingJump_Ch8

Sfx_SurfingFlip:
	channel_count 1
	channel 5, Sfx_SurfingFlip_Ch5

Sfx_SurfingCrash:
	channel_count 1
	channel 8, Sfx_SurfingCrash_Ch8

Sfx_SurfingLand:
	channel_count 1
	channel 8, Sfx_SurfingLand_Ch8

Sfx_GetItem2_4_2:
	channel_count 3
	channel 5, Sfx_GetItem2_4_2_Ch5
	channel 6, Sfx_GetItem2_4_2_Ch6
	channel 7, Sfx_GetItem2_4_2_Ch7

Sfx_SurfingJump_Ch8:
	noise_note 6, 15, 1, 17
	noise_note 7, 15, 2, 34
	noise_note 8, 15, 3, 51
	noise_note 9, 15, 4, 66
	noise_note 10, 15, 5, 51
	noise_note 11, 15, 6, 34
	noise_note 12, 15, 7, 17
	sound_ret

Sfx_SurfingFlip_Ch5:
	duty_cycle 2
	square_note 3, 12, 4, 1888
	square_note 0, 10, 4, 1856
	square_note 2, 12, 4, 1856
	square_note 0, 10, 4, 1888
	square_note 15, 12, 1, 1888
	sound_ret

Sfx_SurfingCrash_Ch8:
	noise_note 3, 15, 3, 102
	noise_note 3, 3, 3, 83
	noise_note 7, 15, 5, 81
	sound_ret

Sfx_SurfingLand_Ch8:
	noise_note 2, 15, 1, 50
	noise_note 2, 0, 0, 0
	noise_note 4, 14, 6, 33
	sound_ret

Sfx_GetItem2_4_2_Ch5:
	toggle_sfx
	tempo 256
	volume 7, 7
	duty_cycle 2
	pitch_offset 1 ; Yellow: toggle_perfect_pitch
	note_type 5, 11, 4
	octave 4
	note D_, 4
	note C_, 4
	octave 3
	note A_, 8
	note_type 5, 11, 2
	octave 4
	note D#, 2
	note D#, 2
	note D_, 2
	note C_, 2
	note C_, 2
	octave 3
	note A#, 2
	note_type 5, 11, 4
	octave 4
	note C_, 8
	sound_ret

Sfx_GetItem2_4_2_Ch6:
	toggle_sfx
	vibrato 8, 2, 7
	duty_cycle 2
	note_type 5, 12, 5
	octave 4
	note A_, 4
	note F_, 4
	note C_, 8
	note_type 5, 12, 2
	note A#, 2
	note A#, 2
	note A#, 2
	note G_, 2
	note G_, 2
	note A#, 2
	note_type 5, 12, 4
	note A_, 8
	sound_ret

Sfx_GetItem2_4_2_Ch7:
	toggle_sfx
	note_type 5, 1, 0
	octave 5
	note F_, 4
	note D#, 4
	note C_, 8
	note D#, 1
	rest 1
	note D#, 1
	rest 1
	note E_, 1
	rest 1
	note F_, 1
	rest 1
	note F_, 1
	rest 1
	note G_, 1
	rest 1
	note A_, 8
	sound_ret
