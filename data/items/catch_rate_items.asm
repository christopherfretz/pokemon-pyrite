; Pokémon traded from RBY do not have held items, so GSC usually interprets the
; catch rate as an item. However, if the catch rate appears in this table, the
; item associated with the table entry is used instead.

TimeCapsule_CatchRateItems:
	db OAKS_PARCEL, LEFTOVERS ; RBY catch rate $19 (was ITEM_19)
	db DOME_FOSSIL, BITTER_BERRY ; RBY catch rate $2d (was ITEM_2D)
	db HELIX_FOSSIL, GOLD_BERRY ; RBY catch rate $32 (was ITEM_32)
	db OLD_AMBER, BERRY ; RBY catch rate $5a (was ITEM_5A)
	db BIKE_VOUCHER, BERRY ; RBY catch rate $64 (was ITEM_64)
	db TM_MEGA_PUNCH, BERRY ; RBY catch rate $78 (was ITEM_78)
	db TM_RAZOR_WIND, BERRY ; RBY catch rate $87 (was ITEM_87)
	db TM_SOFTBOILED, BERRY ; RBY catch rate $be (was ITEM_BE)
	db TM_SKY_ATTACK, BERRY ; RBY catch rate $c3 (was ITEM_C3)
	db TM_THUNDER_WAVE, BERRY ; RBY catch rate $dc (was ITEM_DC)
	db TM_PSYWAVE, BERRY ; RBY catch rate $fa (was ITEM_FA)
	db -1,      BERRY
	db 0 ; end
