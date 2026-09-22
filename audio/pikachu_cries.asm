; Yellow's sampled ("Pika!") Pikachu voice clips — A1-S1, Tier 1.
;
; Raw 1-bit PWM at 22050 Hz, 8 samples per byte, played by PlayPikachuPCM
; (home/pikachu_pcm.asm) bit-banging rAUD3LEVEL.  Ported verbatim from
; vendor/pokeyellow/audio/pikachu_cries.asm; the .pcm blobs are byte-for-byte
; copies of vendor/pokeyellow/audio/pikachu_cries/*.pcm (copied rather than
; INCBIN'd across the submodule boundary — the vendor tree is reference-only).
;
; Each clip is its OWN pinned section because the player just walks `ld a, [hli]`
; through $4000-$7fff: a clip that straddled a bank boundary would read garbage.
; A section is by definition contiguous inside one bank, so rgbasm enforces this
; for us.  Banks are pinned (docs/PIKA-PCM-CRY.md A1-D5) because a 4.6 KB blob is
; the least flexible thing in the ROM — let the small floaters pack around it.
; Growth banks are avoided: $01 (bank1), $0e (Enemy Trainers), $11 (Wild Mons),
; $3f (the Pikachu engine), and the "Map Blocks"/"Map Scripts"/"Tileset Data"/
; "Sprites" banks that every area port eats into.

MACRO pcm
; The stored length is one short of the file: the last byte is never processed
; (Yellow does the same — the loop counts down bc = length - 1).
	dw .End - .Start - 1
.Start
	\1
.End
ENDM


SECTION "Pikachu Cry 11", ROMX, BANK[$29] ; "Phone Text"

PikachuPCM11::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_11.pcm"


SECTION "Pikachu Cry 17", ROMX, BANK[$2F] ; "Phone Scripts 2"

PikachuPCM17::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_17.pcm"


SECTION "Pikachu Cry 37", ROMX, BANK[$36] ; "Font Inversed" / "Pic Animations 3"

PikachuPCM37::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_37.pcm"


SECTION "Pikachu Cry 4", ROMX, BANK[$35] ; "Pic Animations 2"

PikachuPCM4::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_4.pcm"


SECTION "Pikachu Cry 28", ROMX, BANK[$7D] ; "Mobile News Data"

PikachuPCM28::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_28.pcm"
