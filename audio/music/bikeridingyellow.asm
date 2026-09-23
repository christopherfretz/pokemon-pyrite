; Kanto hack (K6d, docs/K6-MUSIC.md): Yellow's BIKE RIDING theme, a source-level
; port of pokeyellow audio/music/bikeriding.asm (header from
; audio/headers/musicheaders3.asm).  Translations: `toggle_perfect_pitch` -> `pitch_offset 1` (ch1 toggles it back off: the second one -> `pitch_offset 0`); ch4 `drum_note N` -> `toggle_noise 1` + `drum_note N-7` (same noise data, see K6c); `::` -> `:`.
; Replaces Crystal's MUSIC_BICYCLE in the Kanto act (home/audio.asm, engine/events/overworld.asm).

Music_BikeRidingYellow:
	channel_count 4
	channel 1, Music_BikeRidingYellow_Ch1
	channel 2, Music_BikeRidingYellow_Ch2
	channel 3, Music_BikeRidingYellow_Ch3
	channel 4, Music_BikeRidingYellow_Ch4

Music_BikeRidingYellow_Ch1:
	tempo 144
	volume 7, 7
	duty_cycle 3
	vibrato 8, 1, 4
	note_type 12, 11, 5
	octave 3
	note G_, 2
.mainloop:
	octave 4
	note C_, 4
	note D_, 4
	note E_, 2
	note C_, 2
	note E_, 2
	note G_, 2
	note G_, 2
	note F_, 2
	note E_, 2
	note F_, 4
	note E_, 2
	note D_, 2
	note F_, 4
	note D_, 4
	octave 3
	note B_, 2
	octave 4
	note F_, 4
	note D_, 4
	note E_, 2
	note F_, 2
	note G_, 2
	note C_, 2
	note E_, 2
	note C_, 2
	note D_, 2
	note E_, 2
	note_type 12, 11, 6
	note F_, 10
	note_type 12, 10, 6
	note F_, 2
	note E_, 2
	note F_, 2
	note G_, 10
	note E_, 2
	note D_, 2
	note E_, 2
	note F_, 6
	pitch_offset 1 ; Yellow: toggle_perfect_pitch
	note_type 12, 11, 3
	note E_, 2
	note D_, 2
	note D_, 1
	note E_, 1
	note F_, 2
	note E_, 1
	note F_, 1
	pitch_offset 0 ; Yellow: toggle_perfect_pitch
	note_type 12, 11, 5
	note G_, 6
	note G_, 6
	note A_, 2
	note F_, 2
	note G_, 6
	note_type 12, 11, 4
	note G_, 2
	note F_, 4
	note_type 12, 10, 4
	note E_, 2
	note D_, 2
	note_type 12, 9, 3
	octave 3
	note A_, 2
	octave 4
	note C_, 4
	note C_, 2
	octave 3
	note B_, 2
	note A_, 1
	note B_, 1
	note A_, 2
	note B_, 2
	octave 4
	note C_, 2
	note C_, 4
	note C_, 2
	octave 3
	note A_, 2
	note B_, 2
	note B_, 2
	note A_, 2
	octave 4
	note C_, 4
	octave 3
	note A_, 2
	note B_, 1
	octave 4
	note C_, 1
	octave 3
	note B_, 2
	octave 4
	note D_, 4
	octave 3
	note B_, 2
	octave 4
	note C_, 4
	octave 3
	note B_, 1
	octave 4
	note C_, 1
	note D_, 1
	octave 3
	note B_, 1
	octave 4
	note C_, 4
	note_type 12, 3, -5
	note C_, 4
	note_type 12, 11, 4
	note F_, 6
	note G_, 4
	note F_, 1
	note G_, 1
	note F_, 4
	note E_, 6
	note F_, 2
	note E_, 2
	note D_, 1
	note E_, 1
	note D_, 2
	note C_, 2
	note_type 12, 11, 5
	octave 3
	note A_, 4
	octave 4
	note D_, 4
	octave 3
	note B_, 4
	octave 4
	note E_, 4
	note C_, 4
	note F_, 4
	note D_, 4
	note F#, 4
	vibrato 10, 2, 6
	note_type 12, 8, 0
	note G_, 16
	note G_, 4
	note_type 12, 8, 7
	note G_, 12
	note_type 12, 11, 5
	vibrato 8, 1, 4
	sound_loop 0, .mainloop

Music_BikeRidingYellow_Ch2:
	duty_cycle 2
	vibrato 6, 1, 5
	note_type 12, 12, 3
	octave 4
	note C_, 2
.mainloop:
	note E_, 4
	note F_, 4
	note G_, 4
	octave 5
	note C_, 4
	octave 4
	note B_, 6
	note A_, 1
	note B_, 1
	note A_, 10
	note F_, 2
	note G_, 2
	note A_, 2
	octave 5
	note D_, 2
	note C_, 2
	octave 4
	note B_, 2
	note A_, 1
	note B_, 1
	octave 5
	note C_, 6
	octave 4
	note A_, 2
	note G_, 4
	duty_cycle 3
	note_type 12, 8, 4
	note A#, 6
	duty_cycle 2
	note_type 12, 12, 5
	octave 5
	note C_, 2
	octave 4
	note B_, 2
	octave 5
	note C_, 2
	octave 4
	note A_, 10
	octave 5
	note C_, 2
	octave 4
	note B_, 2
	octave 5
	note C_, 2
	octave 4
	note G_, 10
	note_type 12, 12, 3
	octave 5
	note C_, 4
	note E_, 2
	note D_, 2
	note C_, 2
	octave 4
	note B_, 2
	octave 5
	note C_, 2
	note_type 12, 11, 0
	note D_, 4
	note_type 12, 12, 7
	note D_, 10
	note D_, 1
	note C_, 1
	note_type 12, 11, 0
	octave 4
	note B_, 4
	note_type 12, 12, 7
	note B_, 12
	note_type 12, 12, 4
	note F_, 6
	note F_, 2
	note G_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note E_, 6
	note E_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note C_, 2
	note F_, 2
	note E_, 2
	note D_, 2
	note F_, 2
	note G_, 4
	note A_, 2
	note F_, 2
	note E_, 2
	note G_, 4
	note F_, 2
	note E_, 6
	note_type 6, 12, 2
	note F_, 1
	note G_, 1
	note A_, 1
	note B_, 1
	note_type 12, 12, 3
	octave 5
	note C_, 2
	octave 4
	note B_, 2
	note A_, 2
	octave 5
	note C_, 2
	octave 4
	note B_, 4
	note A_, 4
	note G_, 2
	note A#, 4
	note A_, 2
	note G_, 4
	note F_, 2
	note E_, 2
	note_type 8, 12, 4
	note A_, 4
	note G_, 4
	note F_, 4
	note B_, 4
	note A_, 4
	note G_, 4
	octave 5
	note C_, 4
	octave 4
	note B_, 4
	note A_, 4
	octave 5
	note D_, 4
	note E_, 4
	note C_, 4
	note_type 12, 12, 7
	note D_, 12
	note C_, 4
	note_type 12, 11, 0
	octave 4
	note B_, 4
	note_type 12, 12, 7
	note B_, 12
	note_type 12, 12, 3
	sound_loop 0, .mainloop

Music_BikeRidingYellow_Ch3:
	note_type 12, 1, 3
	rest 2
.mainloop:
	octave 4
	note C_, 1
	rest 1
	note E_, 1
	rest 1
	octave 3
	note G_, 1
	rest 1
	octave 4
	note E_, 1
	rest 1
	note C_, 1
	rest 1
	note E_, 1
	rest 1
	note C_, 1
	rest 1
	note G_, 1
	rest 1
	note F_, 1
	rest 1
	note A_, 1
	rest 1
	note C_, 1
	rest 1
	note A_, 1
	rest 1
	note F_, 1
	rest 1
	note A_, 1
	rest 1
	note E_, 1
	rest 1
	note A_, 1
	rest 1
	note D_, 1
	rest 1
	note F_, 1
	rest 1
	octave 3
	note A_, 1
	rest 1
	octave 4
	note F_, 1
	rest 1
	note D_, 1
	rest 1
	note F_, 1
	rest 1
	note E_, 1
	rest 1
	note F_, 1
	rest 1
	note E_, 1
	rest 1
	note G_, 1
	rest 1
	note C_, 1
	rest 1
	note G_, 1
	rest 1
	note E_, 1
	rest 1
	note G_, 1
	rest 1
	note E_, 1
	rest 1
	note G_, 1
	rest 1
	note F_, 1
	rest 1
	note A_, 1
	rest 1
	note C_, 1
	rest 1
	note A_, 1
	rest 1
	note F_, 1
	rest 1
	note G_, 1
	rest 1
	note A_, 1
	rest 1
	note G_, 1
	rest 1
	note E_, 1
	rest 1
	note G_, 1
	rest 1
	note C_, 1
	rest 1
	note G_, 1
	rest 1
	note E_, 1
	rest 1
	note G_, 1
	rest 1
	note E_, 1
	rest 1
	note G_, 1
	rest 1
	note D_, 1
	rest 1
	note F_, 1
	rest 1
	octave 3
	note A_, 1
	rest 1
	octave 4
	note F_, 1
	rest 1
	note D_, 1
	rest 1
	note F_, 1
	rest 1
	note D_, 1
	rest 1
	note F_, 1
	rest 1
	note G_, 1
	rest 1
	note C_, 1
	rest 1
	note D_, 1
	rest 1
	note G_, 1
	rest 1
	note D_, 1
	rest 1
	note G_, 1
	rest 1
	note D_, 1
	rest 1
	note G_, 1
	rest 1
	note D_, 1
	rest 1
	octave 3
	note B_, 1
	rest 1
	octave 4
	note D_, 1
	rest 1
	note G_, 1
	rest 1
	note D_, 1
	rest 1
	note G_, 1
	rest 1
	octave 3
	note B_, 1
	rest 1
	octave 4
	note G_, 1
	rest 1
	note D_, 1
	rest 1
	note F_, 1
	rest 1
	octave 3
	note A_, 1
	rest 1
	octave 4
	note F_, 1
	rest 1
	note D_, 1
	rest 1
	note F_, 1
	rest 1
	note D_, 1
	rest 1
	note F_, 1
	rest 1
	note E_, 1
	rest 1
	note G_, 1
	rest 1
	note C_, 1
	rest 1
	note G_, 1
	rest 1
	note E_, 1
	rest 1
	note G_, 1
	rest 1
	note E_, 1
	rest 1
	note G_, 1
	rest 1
	note D_, 1
	rest 1
	note F_, 1
	rest 1
	octave 3
	note A_, 1
	rest 1
	octave 4
	note F_, 1
	rest 1
	note F_, 1
	rest 1
	note E_, 1
	rest 1
	note D_, 1
	rest 1
	note F_, 1
	rest 1
	note E_, 1
	rest 1
	note C_, 1
	rest 1
	note G_, 1
	rest 1
	note C_, 1
	rest 1
	note E_, 1
	rest 1
	note G_, 1
	rest 1
	note E_, 1
	rest 1
	note G_, 1
	rest 1
	note F_, 1
	rest 1
	note A_, 1
	rest 1
	note C_, 1
	rest 1
	note A_, 1
	rest 1
	note F_, 1
	rest 1
	note A_, 1
	rest 1
	note A_, 1
	rest 1
	note F_, 1
	rest 1
	note G_, 1
	rest 1
	note A#, 1
	rest 1
	note E_, 1
	rest 1
	note A#, 1
	rest 1
	note G_, 1
	rest 1
	note A#, 1
	rest 1
	note A#, 1
	rest 1
	note G_, 1
	rest 1
	note F_, 1
	rest 1
	note D_, 1
	rest 1
	note F_, 1
	rest 1
	note A_, 1
	rest 1
	note G_, 1
	rest 1
	note E_, 1
	rest 1
	note G_, 1
	rest 1
	note B_, 1
	rest 1
	note A_, 1
	rest 1
	note F_, 1
	rest 1
	note A_, 1
	rest 1
	octave 5
	note C_, 1
	rest 1
	octave 4
	note B_, 1
	rest 1
	note A_, 1
	rest 1
	octave 5
	note C_, 1
	rest 1
	octave 4
	note A_, 1
	rest 1
	note G_, 1
	rest 1
	octave 5
	note C_, 1
	rest 1
	octave 4
	note G_, 1
	rest 1
	octave 5
	note C_, 1
	rest 1
	octave 4
	note G_, 1
	rest 1
	octave 5
	note C_, 1
	rest 1
	octave 4
	note G_, 1
	rest 1
	octave 5
	note C_, 1
	rest 1
	octave 4
	note G_, 1
	rest 1
	note B_, 1
	rest 1
	note G_, 1
	rest 1
	note B_, 1
	rest 1
	note F_, 1
	rest 1
	note A_, 1
	rest 1
	octave 3
	note B_, 1
	rest 1
	octave 4
	note F_, 1
	rest 1
	sound_loop 0, .mainloop

Music_BikeRidingYellow_Ch4:
	toggle_noise 1 ; Gen 1 names noise instruments directly; Crystal indexes a drumkit
	drum_speed 12
	rest 2
.mainloop:
	sound_call .sub1
	sound_call .sub2
	sound_call .sub1
	sound_call .sub3
	sound_call .sub2
	sound_call .sub2
	sound_call .sub1
	sound_call .sub1
	sound_call .sub1
	sound_call .sub1
	sound_call .sub2
	sound_call .sub1
	sound_call .sub3
	sound_call .sub1
	sound_call .sub2
	sound_call .sub1
	sound_call .sub1
	sound_call .sub1
	sound_call .sub1
	sound_loop 0, .mainloop

.sub1:
	rest 2
	drum_note 9, 2 ; Yellow: drum_note 16
	rest 2
	drum_note 9, 2 ; Yellow: drum_note 16
	rest 2
	drum_note 9, 2 ; Yellow: drum_note 16
	rest 2
	drum_note 9, 2 ; Yellow: drum_note 16
	sound_ret

.sub2:
	rest 2
	drum_note 9, 2 ; Yellow: drum_note 16
	rest 2
	drum_note 9, 2 ; Yellow: drum_note 16
	rest 2
	drum_note 9, 2 ; Yellow: drum_note 16
	drum_note 9, 2 ; Yellow: drum_note 16
	drum_note 9, 2 ; Yellow: drum_note 16
	sound_ret

.sub3:
	rest 2
	drum_note 9, 2 ; Yellow: drum_note 16
	rest 2
	drum_note 9, 2 ; Yellow: drum_note 16
	rest 2
	drum_note 9, 2 ; Yellow: drum_note 16
	rest 2
	drum_note 9, 1 ; Yellow: drum_note 16
	drum_note 9, 1 ; Yellow: drum_note 16
	sound_ret
