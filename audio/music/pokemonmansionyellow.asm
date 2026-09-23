; Kanto hack (K6d, docs/K6-MUSIC.md): Yellow's CINNABAR MANSION theme, a source-level
; port of pokeyellow audio/music/cinnabarmansion.asm (header from
; audio/headers/musicheaders3.asm).  Translations: `toggle_perfect_pitch` -> `pitch_offset 1`; ch4 `drum_note N` -> `toggle_noise 1` + `drum_note N-7` (same noise data, see K6c); `::` -> `:`.
; Replaces the MUSIC_LIGHTHOUSE stand-in on the four POKEMON MANSION maps.

Music_PokemonMansionYellow:
	channel_count 4
	channel 1, Music_PokemonMansionYellow_Ch1
	channel 2, Music_PokemonMansionYellow_Ch2
	channel 3, Music_PokemonMansionYellow_Ch3
	channel 4, Music_PokemonMansionYellow_Ch4

Music_PokemonMansionYellow_Ch1:
	tempo 144
	volume 7, 7
	vibrato 11, 2, 5
	duty_cycle 2
.mainloop:
.loop1:
	note_type 12, 6, 2
	octave 5
	note E_, 1
	note E_, 1
	octave 4
	note B_, 1
	note B_, 1
	note C_, 1
	rest 2
	octave 5
	note B_, 2
	note E_, 2
	octave 4
	note C_, 2
	note B_, 2
	note E_, 2
	note C_, 1
	octave 5
	note B_, 1
	rest 2
	sound_loop 14, .loop1
	note_type 12, 10, 5
	rest 16
	rest 16
	rest 15
	octave 4
	note C_, 1
	octave 5
	note B_, 1
	note B_, 2
	sound_loop 0, .mainloop

Music_PokemonMansionYellow_Ch2:
	duty_cycle 2
	pitch_offset 1 ; Yellow: toggle_perfect_pitch
	vibrato 10, 2, 4
	note_type 12, 12, 2
.introloop:
	rest 16
	rest 16
	sound_loop 4, .introloop
.mainloop:
	note_type 12, 12, 2
.loop1:
	sound_call .sub1
	sound_loop 3, .loop1
	octave 3
	note E_, 4
	note D#, 4
	note B_, 4
	note A#, 4
	note G_, 4
	note G#, 4
	rest 4
	note A#, 4
	note E_, 4
	note D#, 4
	note B_, 4
	note A#, 4
	note G_, 4
	note G#, 4
	note G_, 4
	note D#, 4
	sound_loop 0, .mainloop

.sub1:
	octave 3
	note E_, 4
	note D#, 4
	note B_, 4
	note A#, 4
	note G_, 4
	note G#, 4
	note A_, 4
	note A#, 4
	note E_, 4
	note D#, 4
	note B_, 4
	note A#, 4
	note G_, 4
	note G#, 4
	rest 4
	note A#, 4
	sound_ret

Music_PokemonMansionYellow_Ch3:
	note_type 12, 1, 1
.mainloop:
.loop1:
	octave 2
	note B_, 2
	rest 2
	octave 3
	note E_, 2
	rest 2
	note E_, 2
	rest 2
	note E_, 2
	rest 2
	note E_, 2
	rest 2
	note E_, 2
	rest 2
	note E_, 2
	rest 2
	note E_, 2
	rest 2
	note C_, 2
	rest 2
	octave 3
	note D#, 2
	rest 2
	note D#, 2
	rest 2
	note D#, 2
	rest 2
	note D#, 2
	rest 2
	note D#, 2
	rest 2
	note D#, 2
	rest 2
	note D#, 2
	rest 2
	sound_loop 8, .loop1
	note E_, 16
	note D#, 16
	note G_, 16
	note G#, 8
	note D#, 8
	sound_loop 0, .mainloop

Music_PokemonMansionYellow_Ch4:
	toggle_noise 1 ; Gen 1 names noise instruments directly; Crystal indexes a drumkit
	drum_speed 6
	rest 16
	rest 16
	rest 16
	rest 16
.mainloop:
	drum_note 5, 2 ; Yellow: drum_note 12
	drum_note 5, 2 ; Yellow: drum_note 12
	drum_note 6, 4 ; Yellow: drum_note 13
	drum_note 5, 2 ; Yellow: drum_note 12
	drum_note 5, 2 ; Yellow: drum_note 12
	drum_note 6, 4 ; Yellow: drum_note 13
	drum_note 5, 2 ; Yellow: drum_note 12
	drum_note 5, 2 ; Yellow: drum_note 12
	drum_note 6, 4 ; Yellow: drum_note 13
	drum_note 5, 2 ; Yellow: drum_note 12
	drum_note 5, 2 ; Yellow: drum_note 12
	drum_note 7, 4 ; Yellow: drum_note 14
	drum_note 5, 2 ; Yellow: drum_note 12
	drum_note 5, 2 ; Yellow: drum_note 12
	rest 2
	rest 10
	rest 8
	drum_note 7, 8 ; Yellow: drum_note 14
	sound_loop 0, .mainloop
