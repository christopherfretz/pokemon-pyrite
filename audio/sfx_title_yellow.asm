; Kanto hack (M12c, docs/M12-STRETCH.md): the two Gen 1 sound effects of
; Yellow's title screen (plus, M12d, the GAME FREAK splash's shooting star), source-level ports of pokeyellow audio/sfx/intro_crash.asm
; and intro_whoosh.asm (headers from audio/headers/sfxheaders3.asm).
; noise_note takes the same arguments in both drivers (only the byte encoding
; differs), so the channel data is copied verbatim.  Yellow's whoosh is NOT
; Crystal's SFX_INTRO_WHOOSH ($cb, the Crystal-intro whoosh): different sound,
; hence the _YELLOW id.

Sfx_IntroCrash:
	channel_count 1
	channel 8, Sfx_IntroCrash_Ch8

Sfx_IntroWhooshYellow:
	channel_count 1
	channel 8, Sfx_IntroWhooshYellow_Ch8

Sfx_IntroCrash_Ch8:
	noise_note 2, 13, 2, 50
	noise_note 15, 15, 2, 67
	sound_ret

Sfx_IntroWhooshYellow_Ch8:
	noise_note 4, 2, -4, 32
	noise_note 3, 10, 0, 32
	noise_note 3, 11, 0, 33
	noise_note 3, 12, 0, 34
	noise_note 15, 13, 2, 36
	sound_ret

; M12d: pokeyellow audio/sfx/shooting_star.asm (header sfxheaders3.asm).
; duty_cycle_pattern, pitch_sweep and square_note take the same arguments in
; both drivers, so the channel is copied verbatim.
Sfx_ShootingStar:
	channel_count 1
	channel 5, Sfx_ShootingStar_Ch5

Sfx_ShootingStar_Ch5:
	duty_cycle_pattern 2, 0, 2, 0
	pitch_sweep 2, -7
	square_note 4, 4, 0, 2016
	square_note 4, 6, 0, 2016
	square_note 4, 8, 0, 2016
	square_note 8, 10, 0, 2016
	square_note 8, 10, 0, 2016
	square_note 8, 8, 0, 2016
	square_note 8, 6, 0, 2016
	square_note 8, 3, 0, 2016
	square_note 15, 1, 2, 2016
	pitch_sweep 0, 8
	sound_ret
