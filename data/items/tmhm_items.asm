; Kanto hack (M3b TM union): TM item ids are no longer contiguous, so the
; item id <-> TM number conversion is a table lookup instead of arithmetic.
; See GetTMHMNumber / GetNumberedTMHM / IsTMHMItem in engine/items/items.asm.
;
; The add_tm, add_tm_id and add_hm macros in constants/item_constants.asm define
; the TM##_ITEM / HM##_ITEM aliases this table is generated from.
; Move tutors have no item id, so they are not in this table.

TMHMItems:
; entries correspond to *_TMNUM constants (see constants/item_constants.asm)
	table_width 1

; TMs
for n, 1, NUM_TMS + 1
	db TM{02d:n}_ITEM
endr
	assert_table_length NUM_TMS

; HMs
for n, 1, NUM_HMS + 1
	db HM{02d:n}_ITEM
endr
	assert_table_length NUM_TMS + NUM_HMS
