; HM moves can't be forgotten

IsHM::
; Return carry if item id a is an HM.
; HM01-HM07 are still contiguous ($f3-$f9), but the ids above them ($fa-$fe)
; are TM81-TM85 now (Kanto hack), so the range needs an upper bound too.
	cp HM01
	jr c, .NotHM
	cp HM01 + NUM_HMS
	jr nc, .NotHM
	scf
	ret
.NotHM:
	and a
	ret

IsHMMove::
	ld hl, .HMMoves
	ld de, 1
	jp IsInArray

.HMMoves:
	db CUT
	db FLY
	db SURF
	db STRENGTH
	db FLASH
	db WATERFALL
	db WHIRLPOOL
	db -1 ; end
