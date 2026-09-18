; Yellow's PikaPicAnimGFXHeaders, transcribed byte-for-byte from
; vendor/pokeyellow/data/pikachu/pikachu_pic_animation.asm:338-403
; (docs/PIKACHU-EMOTIONS.md A5 step E1).  63 entries ($00-$3e), 4 bytes each
; -- the doc's "62" was an off-by-one; $00-$3e inclusive is 63.
; Field 1 is the tile count, or -1 meaning "compressed" (all 23 compressed
; blobs decompress to exactly 25 tiles / 400 B).  Field 2 is a dba into
; gfx/pikachu.asm.  The `; 00` comment on entry $10 is Yellow's own typo,
; kept verbatim.
; Only deviation from Yellow: entry $3e points at Crystal's overworld Pikachu
; sheet, which we call PikachuSpriteGFX (gfx/sprites.asm) rather than
; Yellow's PikachuSprite.  Still 24 tiles (384 B).

PikaPicAnimGFXHeaders:
	pikapicanimgfx  1, $39, NULL     ; 00
	pikapicanimgfx -1, Pic_e4000     ; 01
	pikapicanimgfx  5, GFX_e40cc     ; 02
	pikapicanimgfx -1, Pic_e411c     ; 03
	pikapicanimgfx 10, GFX_e41d2     ; 04
	pikapicanimgfx -1, Pic_e4272     ; 05
	pikapicanimgfx  6, GFX_e4323     ; 06
	pikapicanimgfx -1, Pic_e4383     ; 07
	pikapicanimgfx 20, GFX_e444b     ; 08
	pikapicanimgfx -1, Pic_e458b     ; 09
	pikapicanimgfx  4, GFX_e463b     ; 0a
	pikapicanimgfx -1, Pic_e467b     ; 0b
	pikapicanimgfx  4, GFX_e472e     ; 0c
	pikapicanimgfx -1, Pic_e476e     ; 0d
	pikapicanimgfx 25, GFX_e4841     ; 0e
	pikapicanimgfx -1, Pic_e49d1     ; 0f
	pikapicanimgfx 10, GFX_e4a99     ; 00
	pikapicanimgfx -1, Pic_e4b39     ; 11
	pikapicanimgfx  6, GFX_e4bde     ; 12
	pikapicanimgfx -1, Pic_e4c3e     ; 13
	pikapicanimgfx 25, GFX_e4ce0     ; 14
	pikapicanimgfx 25, GFX_e4e70     ; 15
	pikapicanimgfx -1, Pic_e5000     ; 16
	pikapicanimgfx 25, GFX_e50af     ; 17
	pikapicanimgfx -1, Pic_e523f     ; 18
	pikapicanimgfx 25, GFX_e52fe     ; 19
	pikapicanimgfx -1, Pic_e548e     ; 1a
	pikapicanimgfx 25, GFX_e5541     ; 1b
	pikapicanimgfx -1, Pic_e56d1     ; 1c
	pikapicanimgfx 25, GFX_e5794     ; 1d
	pikapicanimgfx -1, Pic_e5924     ; 1e
	pikapicanimgfx 25, GFX_e59ed     ; 1f
	pikapicanimgfx -1, Pic_e5b7d     ; 20
	pikapicanimgfx 25, GFX_e5c4d     ; 21
	pikapicanimgfx -1, Pic_e5ddd     ; 22
	pikapicanimgfx 25, GFX_e5e90     ; 23
	pikapicanimgfx 25, GFX_e6020     ; 24
	pikapicanimgfx 25, GFX_e61b0     ; 25
	pikapicanimgfx -1, Pic_e6340     ; 26
	pikapicanimgfx 25, GFX_e63f7     ; 27
	pikapicanimgfx -1, Pic_e6587     ; 28
	pikapicanimgfx 25, GFX_e6646     ; 29
	pikapicanimgfx -1, Pic_e67d6     ; 2a
	pikapicanimgfx 25, GFX_e682f     ; 2b
	pikapicanimgfx 25, GFX_e69bf     ; 2c
	pikapicanimgfx 25, GFX_e6b4f     ; 2d
	pikapicanimgfx 25, GFX_e6cdf     ; 2e
	pikapicanimgfx 25, GFX_e6e6f     ; 2f
	pikapicanimgfx 25, GFX_e6fff     ; 30
	pikapicanimgfx 25, GFX_e718f     ; 31
	pikapicanimgfx 25, GFX_e731f     ; 32
	pikapicanimgfx 25, GFX_e74af     ; 33
	pikapicanimgfx 25, GFX_e763f     ; 34
	pikapicanimgfx -1, Pic_e77cf     ; 35
	pikapicanimgfx 25, GFX_e7863     ; 36
	pikapicanimgfx 25, GFX_e79f3     ; 37
	pikapicanimgfx 25, GFX_e7b83     ; 38
	pikapicanimgfx 25, GFX_e7d13     ; 39
	pikapicanimgfx -1, Pic_f0abf     ; 3a
	pikapicanimgfx 25, GFX_f0b64     ; 3b
	pikapicanimgfx -1, Pic_f0cf4     ; 3c
	pikapicanimgfx 25, GFX_f0d82     ; 3d
	pikapicanimgfx 24, PikachuSpriteGFX ; 3e
