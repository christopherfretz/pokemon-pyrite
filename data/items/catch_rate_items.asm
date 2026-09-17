; Pokémon traded from RBY do not have held items, so GSC usually interprets the
; catch rate as an item. However, if the catch rate appears in this table, the
; item associated with the table entry is used instead.

TimeCapsule_CatchRateItems:
	db OAKS_PARCEL, LEFTOVERS ; RBY catch rate $19 (was ITEM_19)
	db DOME_FOSSIL, BITTER_BERRY ; RBY catch rate $2d (was ITEM_2D)
	db HELIX_FOSSIL, GOLD_BERRY ; RBY catch rate $32 (was ITEM_32)
	db OLD_AMBER, BERRY ; RBY catch rate $5a (was ITEM_5A)
	db ITEM_64, BERRY
	db ITEM_78, BERRY
	db ITEM_87, BERRY
	db ITEM_BE, BERRY
	db ITEM_C3, BERRY
	db ITEM_DC, BERRY
	db ITEM_FA, BERRY
	db -1,      BERRY
	db 0 ; end
