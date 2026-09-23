; Kanto hack (K6a, docs/K6-MUSIC.md): Yellow's "rival appears" theme RE-VOICED
; in the style of Crystal's own arrangements -- same notes and form as
; meetrivalyellow.asm (Yellow's pokeyellow audio/music/meetrival.asm), with the
; instrument choices of Crystal's MUSIC_RIVAL_ENCOUNTER / MUSIC_RIVAL_BATTLE:
;   ch1 (harmony): duty 1, Crystal-style delayed vibrato, pitch_offset 1,
;     panned right, a shorter decay (11,3 -> 11,2) on the staccato figures;
;   ch2 (lead): LookRival's vibrato 8,3,6, panned left;
;   ch3 (bass): wave 9 (Crystal's RivalBattle bass) instead of Yellow's wave 4;
;   ch4 (new): a drum part on Crystal drum kit 3, LookRival's groove, with the
;     intro's stabs doubled on the kit.
; Same four entry points as the Yellow port (intro / alt start / alt tempo /
; both), so either variant can stand in anywhere; see MUSIC_KANTO_RIVAL* in
; constants/music_constants.asm for the A/B switch.

Music_MeetRivalGSC:
	channel_count 4
	channel 1, Music_MeetRivalGSC_Ch1
	channel 2, Music_MeetRivalGSC_Ch2
	channel 3, Music_MeetRivalGSC_Ch3
	channel 4, Music_MeetRivalGSC_Ch4

Music_MeetRivalGSCAltStart:
	channel_count 4
	channel 1, Music_MeetRivalGSC_Ch1_AlternateStart
	channel 2, Music_MeetRivalGSC_Ch2_AlternateStart
	channel 3, Music_MeetRivalGSC_Ch3_AlternateStart
	channel 4, Music_MeetRivalGSC_Ch4_AlternateStart

Music_MeetRivalGSCAltTempo:
	channel_count 4
	channel 1, Music_MeetRivalGSC_Ch1_AlternateTempo
	channel 2, Music_MeetRivalGSC_Ch2
	channel 3, Music_MeetRivalGSC_Ch3
	channel 4, Music_MeetRivalGSC_Ch4

Music_MeetRivalGSCAltStartAndTempo:
	channel_count 4
	channel 1, Music_MeetRivalGSC_Ch1_AlternateStartAndTempo
	channel 2, Music_MeetRivalGSC_Ch2_AlternateStart
	channel 3, Music_MeetRivalGSC_Ch3_AlternateStart
	channel 4, Music_MeetRivalGSC_Ch4_AlternateStart

Music_MeetRivalGSC_Ch1_AlternateTempo:
	tempo 100
	sound_loop 0, Music_MeetRivalGSC_Ch1.body

Music_MeetRivalGSC_Ch1:
	tempo 112
.body:
	volume 7, 7
	duty_cycle 1 ; Yellow: 3
	vibrato 18, 1, 5 ; Yellow: 6, 3, 4
	pitch_offset 1
	stereo_panning FALSE, TRUE
	note_type 12, 11, 2 ; Yellow: 12, 11, 3
	octave 4
	note D_, 1
	note C#, 1
	note C_, 1
	octave 3
	note B_, 1
	note A#, 2
	note A_, 1
	note G#, 1
	note G_, 1
	note F#, 1
	note F_, 6
	note D_, 1
	rest 3
	note D_, 1
	rest 5
	note A_, 2
	note G_, 2
	note A_, 2
.mainloop:
	note B_, 4
	note A#, 2
	note A_, 4
	note G_, 2
	octave 4
	note C_, 4
	note D_, 2
	rest 4
	note D_, 4
	note C#, 2
	note C_, 2
	octave 3
	note B_, 2
	octave 4
	note C_, 4
	note E_, 2
	note D_, 4
	note C_, 2
	octave 3
	note B_, 4
	octave 4
	note C_, 2
	rest 4
	note G_, 4
	note G_, 2
	note F#, 2
	note E_, 2
	note D_, 2
	note F#, 2
	octave 3
	note A_, 2
	octave 4
	note D_, 2
	note F#, 2
	octave 3
	note A_, 2
	octave 4
	note D_, 2
	octave 3
	note D_, 2
	octave 4
	note D_, 2
	rest 2
	octave 3
	note D_, 2
	octave 4
	note C_, 4
	octave 3
	note B_, 2
	note A#, 2
	note B_, 2
	octave 4
	note C_, 2
	note F_, 2
	octave 3
	note G_, 2
	octave 4
	note C_, 2
	note F_, 2
	note D#, 2
	note C_, 2
	octave 3
	note A#, 2
	note G_, 2
	rest 4
	note A#, 4
	octave 4
	note C_, 2
	octave 3
	note A#, 2
	octave 4
	note C_, 2
	note_type 12, 10, 7 ; Yellow: 12, 11, 7
	octave 3
	note G_, 4
	note D_, 2
	note F_, 6
	note F#, 4
	note D_, 2
	rest 4
	note D_, 4
	note_type 12, 11, 2 ; Yellow: 12, 11, 3
	note A_, 2
	note G_, 2
	note A_, 2
	sound_loop 0, .mainloop

Music_MeetRivalGSC_Ch1_AlternateStartAndTempo:
	tempo 100
	sound_loop 0, Music_MeetRivalGSC_Ch1_AlternateStart.body

Music_MeetRivalGSC_Ch1_AlternateStart:
	tempo 112
.body:
	volume 7, 7
	duty_cycle 1 ; Yellow: 3
	vibrato 18, 1, 5 ; Yellow: 6, 3, 4
	pitch_offset 1
	stereo_panning FALSE, TRUE
	note_type 12, 11, 2 ; Yellow: 12, 11, 3
	octave 3
	note D_, 1
	rest 3
	note D_, 1
	rest 5
	note A_, 2
	note G_, 2
	note A_, 2
	sound_loop 0, Music_MeetRivalGSC_Ch1.mainloop

Music_MeetRivalGSC_Ch2:
	duty_cycle 3
	vibrato 8, 3, 6 ; Yellow: 10, 2, 6
	stereo_panning TRUE, FALSE
	note_type 12, 12, 7
	octave 4
	note B_, 1
	note A#, 1
	note A_, 1
	note G#, 1
	note G_, 2
	note F#, 1
	note F_, 1
	note E_, 1
	note D#, 1
	note D_, 6
	octave 3
	note G_, 1
	rest 3
	note G_, 1
	rest 3
	note D_, 1
	rest 1
	octave 4
	note D_, 2
	note F_, 2
	note F#, 2
.mainloop:
	note_type 12, 12, 7
	note G_, 4
	note D_, 2
	note F_, 6
	note F#, 4
	note G_, 2
	rest 4
	note G_, 4
	note G_, 2
	note A#, 2
	note B_, 2
	octave 5
	note C_, 4
	octave 4
	note G_, 2
	note A#, 6
	note B_, 4
	octave 5
	note C_, 2
	rest 4
	note C_, 4
	note C_, 2
	octave 4
	note B_, 2
	octave 5
	note C_, 2
	note_type 12, 11, 0
	note D_, 16
	note_type 12, 11, 5
	note D_, 6
	note_type 12, 12, 7
	note F_, 4
	note D_, 2
	note C_, 2
	note D_, 2
	note_type 12, 11, 0
	note C_, 8
	note_type 12, 12, 7
	note C_, 8
	octave 4
	note C_, 2
	rest 4
	note A#, 4
	note G_, 2
	note F_, 2
	note_type 12, 11, 0
	note G_, 16
	note_type 12, 11, 3
	note G_, 2
	octave 3
	note G_, 2
	rest 4
	note G_, 4
	octave 4
	note D_, 2
	note F_, 2
	note F#, 2
	sound_loop 0, .mainloop

Music_MeetRivalGSC_Ch2_AlternateStart:
	duty_cycle 3
	vibrato 8, 3, 6 ; Yellow: 10, 2, 6
	stereo_panning TRUE, FALSE
	note_type 12, 12, 7
	octave 3
	note G_, 1
	rest 3
	note G_, 1
	rest 3
	note D_, 1
	rest 1
	octave 4
	note D_, 2
	note F_, 2
	note F#, 2
	sound_loop 0, Music_MeetRivalGSC_Ch2.mainloop

Music_MeetRivalGSC_Ch3:
	note_type 12, 1, 9 ; Yellow: 12, 1, 4
	octave 5
	note D_, 2
	rest 2
	note C#, 2
	rest 2
	note C_, 2
	rest 2
	octave 4
	note B_, 2
	rest 2
	note G_, 1
	rest 3
	note G_, 1
	rest 3
	note G_, 1
	rest 1
	note G_, 1
	rest 1
	note G_, 1
	rest 1
	note G_, 1
	rest 1
.mainloop:
	note G_, 2
	octave 5
	note D_, 2
	octave 4
	note G_, 2
	rest 2
	octave 5
	note D_, 2
	octave 4
	note G_, 2
	rest 2
	octave 5
	note D_, 2
	octave 4
	note G_, 2
	rest 4
	octave 5
	note D_, 4
	octave 4
	note G_, 2
	note A#, 2
	note B_, 2
	note G_, 2
	octave 5
	note C_, 2
	octave 4
	note G_, 2
	rest 2
	octave 5
	note C_, 2
	octave 4
	note G_, 2
	rest 2
	note B_, 2
	octave 5
	note C_, 2
	rest 4
	note C_, 4
	note C_, 2
	octave 4
	note B_, 2
	note A_, 2
	note F#, 2
	note A_, 2
	rest 2
	note F#, 2
	note A_, 2
	note F#, 2
	rest 2
	note A_, 2
	note F#, 2
	note A_, 2
	rest 2
	note F#, 2
	note A_, 2
	note F#, 2
	octave 5
	note D_, 2
	octave 4
	note A_, 2
	note E_, 2
	octave 5
	note C_, 2
	rest 2
	octave 4
	note E_, 2
	octave 5
	note C_, 2
	octave 4
	note E_, 2
	note F_, 2
	note G_, 2
	note E_, 2
	rest 4
	note E_, 2
	octave 5
	note C_, 2
	octave 4
	note B_, 2
	note A#, 2
	note A_, 2
	note G_, 2
	note A#, 2
	rest 2
	note G_, 2
	note A#, 2
	note G_, 2
	rest 2
	note A#, 2
	note G_, 2
	octave 5
	note D_, 2
	octave 4
	note G_, 2
	rest 2
	octave 5
	note D_, 2
	octave 4
	note G_, 2
	rest 2
	octave 5
	note D_, 2
	sound_loop 0, .mainloop

Music_MeetRivalGSC_Ch3_AlternateStart:
	note_type 12, 1, 9 ; Yellow: 12, 1, 4
	octave 4
	note G_, 1
	rest 3
	note G_, 1
	rest 3
	note G_, 1
	rest 1
	note G_, 1
	rest 1
	note G_, 1
	rest 1
	note G_, 1
	rest 1
	sound_loop 0, Music_MeetRivalGSC_Ch3.mainloop

Music_MeetRivalGSC_Ch4:
	stereo_panning TRUE, FALSE
	toggle_noise 3
	drum_speed 12
	; intro bar 1: the chromatic run plays alone
	rest 16
	; intro bar 2 doubles the stabs: D . . . D . . . . . A . G . A .
	drum_note 4, 4
	drum_note 4, 6
	drum_note 3, 2
	drum_note 3, 2
	drum_note 3, 2
.mainloop:
	; LookRival's two-bar groove; 5 x 32 = the other channels' 160-unit loop
	drum_note 4, 4
	drum_note 3, 2
	drum_note 4, 4
	drum_note 4, 2
	drum_note 3, 4
	drum_note 4, 4
	drum_note 3, 2
	drum_note 4, 4
	drum_note 4, 2
	drum_note 3, 2
	drum_note 3, 2
	sound_loop 0, .mainloop

Music_MeetRivalGSC_Ch4_AlternateStart:
	stereo_panning TRUE, FALSE
	toggle_noise 3
	drum_speed 12
	; the one-bar pickup: D . . . D . . . . . A . G . A .
	drum_note 4, 4
	drum_note 4, 6
	drum_note 3, 2
	drum_note 3, 2
	drum_note 3, 2
	sound_loop 0, Music_MeetRivalGSC_Ch4.mainloop
