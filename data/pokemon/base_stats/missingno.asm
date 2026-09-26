	db MISSINGNO ; 252

	; OMG1: Red/Blue MISSINGNO. -- Gen 1 base stats 33/136/0/29/6 (special 6
	; split into sat/sdf), types BIRD/NORMAL, catch rate 29, base exp 143.
	; No held items, no TMs.  BIRD has no TypeMatchups rows, so it is neutral.
	db  33, 136,   0,  29,   6,   6
	;   hp  atk  def  spd  sat  sdf

	db BIRD, NORMAL ; type
	db 29 ; catch rate
	db 143 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_UNKNOWN ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/missingno/front.dimensions"
	dw NULL, NULL ; unused (beta front/back pics)
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_NONE, EGG_NONE ; egg groups

	; tm/hm learnset
	tmhm
	; end
