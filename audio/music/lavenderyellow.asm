; Kanto hack (K6c, docs/K6-MUSIC.md): Yellow's LAVENDER TOWN theme, a source-level
; port of pokeyellow audio/music/lavender.asm (header from
; audio/headers/musicheaders1.asm).  Translations: `toggle_perfect_pitch` -> `pitch_offset 1`; `::` -> `:`; ch4 `drum_note N` -> `toggle_noise 0` + `drum_note N` (same noise data, see K6c); ch3 wave 5 -> wave 10 (as K6a).
; Replaces the MUSIC_LAVENDER_TOWN (Crystal) stand-in on the Kanto Lavender maps.

Music_LavenderYellow:
	channel_count 4
	channel 1, Music_LavenderYellow_Ch1
	channel 2, Music_LavenderYellow_Ch2
	channel 3, Music_LavenderYellow_Ch3
	channel 4, Music_LavenderYellow_Ch4

Music_LavenderYellow_Ch1:
	tempo 152
	volume 7, 7
	duty_cycle 1
	pitch_offset 1 ; Yellow: toggle_perfect_pitch
	vibrato 0, 8, 8
	note_type 12, 8, 7
	rest 16
	rest 16
	rest 16
	rest 16
	note_type 12, 10, 7
.mainloop:
	octave 3
	note G_, 8
	note G_, 8
	note E_, 8
	note E_, 8
	note G_, 4
	note F#, 4
	note E_, 4
	note B_, 4
	note C#, 8
	note C#, 8
	note G_, 8
	note G_, 8
	note F#, 8
	note F#, 8
	note B_, 4
	note G_, 4
	note F#, 4
	note B_, 4
	octave 4
	note C_, 8
	note C_, 8
	octave 3
	note G_, 8
	note G_, 8
	note E_, 8
	note E_, 8
	note G_, 4
	note F#, 4
	note E_, 4
	note B_, 4
	note C#, 8
	note C#, 8
	note G_, 8
	note G_, 8
	note F#, 8
	note F#, 8
	note B_, 4
	note G_, 4
	note F#, 4
	note B_, 4
	note C_, 8
	note C_, 8
	rest 16
	rest 16
	rest 16
	rest 16
	sound_loop 0, .mainloop

Music_LavenderYellow_Ch2:
	vibrato 0, 3, 4
	duty_cycle 3
	note_type 12, 9, 1
.mainloop:
	octave 5
	note C_, 4
	note G_, 4
	note B_, 4
	note F#, 4
	sound_loop 0, .mainloop

Music_LavenderYellow_Ch3:
	vibrato 4, 1, 1
	note_type 12, 3, 10 ; Yellow: wave 5
	rest 16
	rest 16
	rest 16
	rest 16
	note_type 12, 2, 10 ; Yellow: wave 5
.mainloop:
	octave 4
	note E_, 16
	note D_, 16
	note C_, 16
	note E_, 4
	note C_, 4
	octave 3
	note B_, 4
	octave 4
	note E_, 4
	note E_, 16
	note D_, 16
	note C_, 16
	note E_, 4
	note C_, 4
	octave 3
	note B_, 4
	octave 4
	note E_, 4
	note E_, 16
	note D_, 16
	note C_, 16
	note E_, 4
	note C_, 4
	octave 3
	note B_, 4
	octave 4
	note E_, 4
	note_type 12, 3, 10 ; Yellow: wave 5
	octave 6
	note B_, 4
	note G_, 4
	note F#, 4
	note B_, 4
	note_type 12, 2, 10 ; Yellow: wave 5
	note B_, 4
	note G_, 4
	note F#, 4
	note B_, 4
	octave 7
	note B_, 4
	note G_, 4
	note F#, 4
	note B_, 4
	octave 4
	note E_, 4
	note G_, 4
	note F#, 4
	note B_, 4
	note E_, 16
	note D_, 16
	note C_, 16
	note E_, 4
	note C_, 4
	octave 3
	note B_, 4
	octave 4
	note E_, 4
	note E_, 16
	note D_, 16
	note C_, 16
	note E_, 4
	note C_, 4
	octave 3
	note B_, 4
	octave 4
	note E_, 4
	note E_, 16
	note D_, 16
	note C_, 16
	note E_, 4
	note C_, 4
	octave 3
	note B_, 4
	octave 4
	note E_, 4
	note_type 12, 2, 10 ; Yellow: wave 5
	octave 6
	note B_, 4
	note G_, 4
	note F#, 4
	note B_, 4
	octave 7
	note B_, 4
	note G_, 4
	note F#, 4
	note B_, 4
	octave 8
	note B_, 4
	note G_, 4
	note F#, 4
	note B_, 4
	octave 4
	note E_, 4
	note G_, 4
	note F#, 4
	note B_, 4
	sound_loop 0, .mainloop

Music_LavenderYellow_Ch4:
	toggle_noise 0 ; Gen 1 names noise instruments directly; Crystal indexes a drumkit
	drum_speed 12
	rest 16
	rest 16
	rest 16
	rest 16
.mainloop:
	drum_note 7, 8 ; Yellow: drum_note 7
	drum_note 7, 8 ; Yellow: drum_note 7
	sound_loop 0, .mainloop
