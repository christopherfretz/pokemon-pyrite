; Ported from Yellow (audio/music/jigglypuffsong.asm + headers/musicheaders3.asm).
; Verbatim source-level copy on the meetjessiejames.asm precedent: Gen 1 and
; Gen 2 share the tempo/volume/vibrato/duty_cycle/duty_cycle_pattern/note_type/
; octave/note/sound_ret macros byte for byte.  The one Gen 1 line with no Gen 2
; equivalent is `toggle_perfect_pitch` on channel 1, which adds 1 to the 11-bit
; frequency divider (vendor/pokeyellow/audio/engine_1.asm:841) -- well under a
; cent -- so it is dropped (docs/JIGGLYPUFF.md 0.2).  Only the header is new.
; The track deliberately does NOT loop: PewterJigglypuffSong spins the sprite
; until both channels go idle, exactly as Yellow's script does.
Music_JigglypuffSong:
	channel_count 2
	channel 1, Music_JigglypuffSong_Ch1
	channel 2, Music_JigglypuffSong_Ch2

Music_JigglypuffSong_Ch1:
	tempo 144
	volume 7, 7
	vibrato 8, 2, 4
	duty_cycle 2
	duty_cycle_pattern 2, 2, 1, 1
	note_type 13, 6, 7
	octave 4
	note E_, 8
	note_type 12, 6, 7
	note B_, 2
	note G#, 6
	note F#, 8
	note G#, 2
	note A_, 6
	note G#, 8
	note F#, 4
	note G#, 4
	note E_, 10
	sound_ret

Music_JigglypuffSong_Ch2:
	vibrato 5, 1, 5
	duty_cycle 2
	duty_cycle_pattern 0, 0, 2, 2
	note_type 12, 10, 7
	octave 4
	note E_, 8
	note B_, 2
	note G#, 6
	note F#, 8
	note G#, 2
	note A_, 6
	note G#, 8
	note F#, 4
	note G#, 4
	note E_, 10
	sound_ret
