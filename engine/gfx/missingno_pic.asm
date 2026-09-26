; Kanto hack (OMG1): MISSINGNO.'s pics (docs/OLD-MAN-GLITCH.md).
;
; Front: Yellow's fossil Kabutops, 6x6, one static frame.
; Back:  none.  Gen 1 loads MISSINGNO.'s back pic from the *enemy's* back-pic
; pointer but in the fossil pics' bank, so the player's MISSINGNO. shows a
; different pile of garbage against every foe.  OMG_GarbageBackpic does the
; same: it takes the current enemy's back-pic address from PokemonPicPointers
; and LZ-decompresses whatever lives at that address in THIS bank.  Unlike the
; real decompressor it cannot run away: the output is pre-zeroed and capped at
; 7x7 tiles, the input stops at the end of ROMX, and copy commands only ever
; read back from the output buffer (anything else reads as 0).

MissingnoFrontpic:: INCBIN "gfx/pokemon/missingno/front.animated.2bpp.lz"

; LZ command set, as in home/decompress.asm (its DEFs are file-local)
DEF OMG_LZ_END       EQU $ff
DEF OMG_LZ_CMD       EQU %11100000
DEF OMG_LZ_LEN       EQU %00011111
DEF OMG_LZ_ITERATE   EQU 1 << 5
DEF OMG_LZ_ALTERNATE EQU 2 << 5
DEF OMG_LZ_ZERO      EQU 3 << 5
DEF OMG_LZ_RW        EQU 2 + 5
DEF OMG_LZ_FLIP      EQU 5 << 5
DEF OMG_LZ_REVERSE   EQU 6 << 5
DEF OMG_LZ_LONG      EQU 7 << 5
DEF OMG_LZ_LONG_HI   EQU %00000011

DEF OMG_BACKPIC_SIZE EQU 7 * 7 * LEN_2BPP_TILE
DEF OMG_BACKPIC_END EQUS "(wDecompressScratch + OMG_BACKPIC_SIZE)"
	assert LOW(wDecompressScratch) == 0

OMG_GarbageBackpic::
; Called from GetMonBackpic with WRAM bank BANK(wDecompressScratch) mapped.
	ld hl, wDecompressScratch
	ld bc, OMG_BACKPIC_SIZE
	xor a
	call ByteFill

	; source species: the enemy in battle, else MISSINGNO. itself.
	; Both live in WRAM bank 1, but our caller has the scratch bank mapped.
	assert BANK(wBattleMode) == BANK(wTempEnemyMonSpecies)
	ld a, BANK(wBattleMode)
	ldh [rWBK], a
	ld a, [wBattleMode]
	and a
	ld a, MISSINGNO
	jr z, .got_species
	ld a, [wTempEnemyMonSpecies]
	and a
	jr z, .fallback
	cp MISSINGNO + 1
	jr c, .got_species
.fallback
	ld a, MISSINGNO
.got_species
	ld b, a
	ld a, BANK(wDecompressScratch)
	ldh [rWBK], a
	ld a, b
	dec a
	ld hl, PokemonPicPointers + 4 ; back pic address (skip front dba + back bank)
	ld bc, 6
	call AddNTimes
	ld a, BANK(PokemonPicPointers)
	call GetFarWord ; hl = back pic address, read in this bank
	ld de, wDecompressScratch

.Main:
	; stop when the output is full, the input left ROMX, or on OMG_LZ_END
	ld a, d
	cp HIGH(OMG_BACKPIC_END)
	jr c, .room
	ret nz
	ld a, e
	cp LOW(OMG_BACKPIC_END)
	ret nc
.room
	ld a, h
	cp HIGH($8000)
	ret nc
	ld a, [hl]
	cp OMG_LZ_END
	ret z
	and OMG_LZ_CMD
	cp OMG_LZ_LONG
	jr nz, .short
	ld a, [hl]
	add a
	add a
	add a
	and OMG_LZ_CMD
	ld [wLZAddress], a
	ld a, [hli]
	and OMG_LZ_LONG_HI
	ld b, a
	call .Src
	ld c, a
	jr .command

.short
	ld [wLZAddress], a
	ld a, [hli]
	and OMG_LZ_LEN
	ld c, a
	ld b, 0

.command
	inc bc ; 1-1024 bytes
	ld a, [wLZAddress]
	bit OMG_LZ_RW, a
	jr nz, .rewrite
	cp OMG_LZ_ITERATE
	jr z, .Iter
	cp OMG_LZ_ALTERNATE
	jr z, .Alt
	cp OMG_LZ_ZERO
	jr z, .Zero

.Lit:
	call .Src
	call .Put
	dec bc
	ld a, b
	or c
	jr nz, .Lit
	jr .Main

.Zero:
	xor a
	jr .iset
.Iter:
	call .Src
.iset
	ld [wLZAddress + 1], a
.iloop
	ld a, [wLZAddress + 1]
	call .Put
	dec bc
	ld a, b
	or c
	jr nz, .iloop
	jr .Main

.Alt:
	call .Src
	ld [wLZAddress], a
	call .Src
	ld [wLZAddress + 1], a
.aloop
	ld a, [wLZAddress]
	call .Put
	dec bc
	ld a, b
	or c
	jp z, .Main
	ld a, [wLZAddress + 1]
	call .Put
	dec bc
	ld a, b
	or c
	jr nz, .aloop
	jp .Main

.rewrite
	call .Src
	bit 7, a
	jr z, .positive
	; negative 7-bit offset: ref = de - (a & $7f) - 1
	and %01111111
	cpl
	push hl
	add e
	ld l, a
	ld a, -1
	adc d
	ld h, a
	jr .dispatch

.positive
	; positive 15-bit offset from the start of the output
	ld [wLZAddress + 1], a
	call .Src
	push hl
	ld l, a
	ld a, [wLZAddress + 1]
	ld h, a
	push de
	ld de, wDecompressScratch
	add hl, de
	pop de

.dispatch
	ld a, [wLZAddress]
	cp OMG_LZ_FLIP
	jr z, .Flip
	cp OMG_LZ_REVERSE
	jr z, .Reverse

.Repeat: ; also OMG_LZ_LONG inside OMG_LZ_LONG, as in the real decompressor
	call .Ref
	inc hl
	call .Put
	dec bc
	ld a, b
	or c
	jr nz, .Repeat
	jr .donerw

.Flip:
	call .Ref
	inc hl
	push bc
	lb bc, 0, 8
.floop
	rra
	rl b
	dec c
	jr nz, .floop
	ld a, b
	pop bc
	call .Put
	dec bc
	ld a, b
	or c
	jr nz, .Flip
	jr .donerw

.Reverse:
	call .Ref
	dec hl
	call .Put
	dec bc
	ld a, b
	or c
	jr nz, .Reverse

.donerw
	pop hl
	jp .Main

.Src:
; a = next input byte (0 past the end of ROMX)
	ld a, h
	cp HIGH($8000)
	jr nc, .zero
	ld a, [hli]
	ret

.Ref:
; a = [hl] if hl is inside the output buffer, else 0
	ld a, h
	cp HIGH(wDecompressScratch)
	jr c, .zero
	cp HIGH(OMG_BACKPIC_END)
	jr c, .in_range
	jr nz, .zero
	ld a, l
	cp LOW(OMG_BACKPIC_END)
	jr nc, .zero
.in_range
	ld a, [hl]
	ret

.zero
	xor a
	ret

.Put:
; [de++] = a, dropped once the output is full; preserves a
	push af
	ld a, d
	cp HIGH(OMG_BACKPIC_END)
	jr c, .put
	jr nz, .full
	ld a, e
	cp LOW(OMG_BACKPIC_END)
	jr nc, .full
.put
	pop af
	ld [de], a
	inc de
	ret
.full
	pop af
	ret
