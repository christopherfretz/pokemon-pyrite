; Yellow's PikachuCriesPointerTable (audio/pikachu_cries_pointers.asm): one
; 3-byte bank+address row per voice clip, indexed by the PikachuCryN constants
; in constants/pikachu_emotion_constants.asm (id = N - 1).
;
; A1-D4: an UNPORTED clip is a null row, and PlayPikachuSoundClip returns no
; carry for it so PlayPikachuVoiceClip falls back to Crystal's synthesized
; PIKACHU cry.  That is what keeps every already-shipped Tier 2 call site
; (the emotion scripts, the face-box animations, the CELADON happiness rater)
; working today, and makes porting another clip a one-line data change: drop
; the .pcm in, add a section in audio/pikachu_cries.asm, swap the row here.
;
; Yellow links 42 clips; clip 42 is referenced nowhere, in Yellow or here.
; Tier 1 (A1-S1) ports 4, 11, 17, 28 and 37 -- docs/PIKA-PCM-CRY.md 0.2.

MACRO no_pikachu_pcm
	db 0 ; bank 0 is never a clip bank
	dw 0
ENDM

PikachuCriesPointerTable::
	dba PikachuPCM1 ; PikachuCry1 (M12c: the title screen)
	no_pikachu_pcm ; PikachuCry2
	no_pikachu_pcm ; PikachuCry3
	dba PikachuPCM4 ; PikachuCry4
	no_pikachu_pcm ; PikachuCry5
	no_pikachu_pcm ; PikachuCry6
	no_pikachu_pcm ; PikachuCry7
	no_pikachu_pcm ; PikachuCry8
	no_pikachu_pcm ; PikachuCry9
	no_pikachu_pcm ; PikachuCry10
	dba PikachuPCM11 ; PikachuCry11
	no_pikachu_pcm ; PikachuCry12
	no_pikachu_pcm ; PikachuCry13
	no_pikachu_pcm ; PikachuCry14
	no_pikachu_pcm ; PikachuCry15
	no_pikachu_pcm ; PikachuCry16
	dba PikachuPCM17 ; PikachuCry17
	no_pikachu_pcm ; PikachuCry18
	no_pikachu_pcm ; PikachuCry19
	no_pikachu_pcm ; PikachuCry20
	no_pikachu_pcm ; PikachuCry21
	no_pikachu_pcm ; PikachuCry22
	no_pikachu_pcm ; PikachuCry23
	no_pikachu_pcm ; PikachuCry24
	no_pikachu_pcm ; PikachuCry25
	no_pikachu_pcm ; PikachuCry26
	no_pikachu_pcm ; PikachuCry27
	dba PikachuPCM28 ; PikachuCry28
	no_pikachu_pcm ; PikachuCry29
	no_pikachu_pcm ; PikachuCry30
	no_pikachu_pcm ; PikachuCry31
	no_pikachu_pcm ; PikachuCry32
	no_pikachu_pcm ; PikachuCry33
	dba PikachuPCM34 ; PikachuCry34 (M12b-3: the Surfing Pikachu high-score cry)
	no_pikachu_pcm ; PikachuCry35
	no_pikachu_pcm ; PikachuCry36
	dba PikachuPCM37 ; PikachuCry37
	no_pikachu_pcm ; PikachuCry38
	no_pikachu_pcm ; PikachuCry39
	no_pikachu_pcm ; PikachuCry40
	no_pikachu_pcm ; PikachuCry41
	no_pikachu_pcm ; PikachuCry42
