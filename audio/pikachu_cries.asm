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


; M12b-3 (docs/M12-STRETCH.md): the Surfing Pikachu minigame's high-score cry
; (5386 B with the header).  Beside the static Pokedex entries in $6e.
SECTION "Pikachu Cry 34", ROMX, BANK[$6E] ; "Pokedex Entries 065-128"

PikachuPCM34::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_34.pcm"


; M12c (docs/M12-STRETCH.md): the "Pika!" of Yellow's title screen (2328 B),
; in the title's own bank, which lost Crystal's unused_title.asm and Suicune
; graphics to the Yellow title port.
SECTION "Pikachu Cry 1", ROMX, BANK[$43] ; "Title"

PikachuPCM1::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_1.pcm"

; M12d (docs/M12-STRETCH.md): cry 16 (5272 B), the one Yellow's intro scene
; plays (M12e wires the scene), in the title bank's free space.
SECTION "Pikachu Cry 16", ROMX, BANK[$43] ; "Title"

PikachuPCM16::
	pcm INCBIN "audio/pikachu_cries/pikachu_cry_16.pcm"
