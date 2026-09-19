; Kanto Pokémon in water

KantoWaterWildMons:

	def_water_wildmons TOHJO_FALLS
	db 4 percent ; encounter rate
	db 20, GOLDEEN
	db 20, SLOWPOKE
	db 20, SEAKING
	end_water_wildmons

	def_water_wildmons VERMILION_PORT
	db 2 percent ; encounter rate
	db 35, TENTACOOL
	db 30, TENTACOOL
	db 35, TENTACRUEL
	end_water_wildmons

	def_water_wildmons ROUTE_4
	db 0 percent ; encounter rate: Yellow has none here (L1)
	db 10, GOLDEEN
	db 5, GOLDEEN
	db 10, SEAKING
	end_water_wildmons

; Kanto hack (7m): Yellow's Route 6 water table
; (vendor/pokeyellow/data/wild/maps/Route6.asm) -- PSYDUCK L15 in eight of the
; ten slots (94.9%), GOLDUCK L15 (3.9%) and GOLDUCK L20 (1.2%). Crystal has
; only three water slots, weighted 60/30/10, so the eight identical PSYDUCKs
; become the two commons and GOLDUCK takes the 10% slot: PSYDUCK 90 /
; GOLDUCK 10, against Yellow's 94.9 / 5.1.
; Both levels are Yellow's FLOOR, not its listed level, because Crystal adds
; surf level variety that Yellow has none of: ChooseWildEncounter
; (engine/overworld/wildmons.asm) rolls +0..+4 on the level of any *water*
; encounter (35/30/20/10/5%). So base 15 yields PSYDUCK L15-19 and GOLDUCK
; L15-19, which covers Yellow's GOLDUCK L15 exactly and reaches its L20 rare
; without overshooting it -- a base of 20 would hand out L20-24 GOLDUCKs that
; Yellow never has.
; The rate byte is Yellow's own 3/256: the `percent` macro (`* $ff / 100`)
; cannot express it -- `1 percent` is 2 and `2 percent` is 5 -- so it is
; written literally.
	def_water_wildmons ROUTE_6
	db 3 ; encounter rate: Yellow's own 3/256 (~1.2%)
	db 15, PSYDUCK
	db 15, PSYDUCK
	db 15, GOLDUCK
	end_water_wildmons

; Kanto hack (M5 8c/8d): ROUTE_9 and ROUTE_10 deleted -- Yellow gives both
; `def_water_wildmons 0` with no entries at all
; (vendor/pokeyellow/data/wild/maps/Route9.asm, Route10.asm).  The blocks must
; be DELETED, not zeroed: FindNest's .FindWater ignores the rate byte, so a
; zero-rate table still shows the map as a Pokedex AREA habitat.
	def_water_wildmons ROUTE_12
	db 6 percent ; encounter rate
	db 25, TENTACOOL
	db 25, QUAGSIRE
	db 25, TENTACRUEL
	end_water_wildmons

	def_water_wildmons ROUTE_13
	db 6 percent ; encounter rate
	db 25, TENTACOOL
	db 25, QUAGSIRE
	db 25, TENTACRUEL
	end_water_wildmons

	def_water_wildmons ROUTE_19
	db 6 percent ; encounter rate
	db 35, TENTACOOL
	db 30, TENTACOOL
	db 35, TENTACRUEL
	end_water_wildmons

	def_water_wildmons ROUTE_20
	db 6 percent ; encounter rate
	db 35, TENTACOOL
	db 30, TENTACOOL
	db 35, TENTACRUEL
	end_water_wildmons

	def_water_wildmons ROUTE_21
	db 6 percent ; encounter rate
	db 35, TENTACOOL
	db 30, TENTACOOL
	db 35, TENTACRUEL
	end_water_wildmons

	def_water_wildmons ROUTE_22
	db 0 percent ; encounter rate: Yellow has none here (L1)
	db 10, POLIWAG
	db 5, POLIWAG
	db 10, POLIWHIRL
	end_water_wildmons

; Kanto hack (6h): Yellow's Route 24 has `def_water_wildmons 0` -- no surfing
; encounters at all (vendor/pokeyellow/data/wild/maps/Route24.asm).  GSC's
; def_water_wildmons macro asserts exactly three entries, so the rows stay and
; the rate goes to 0: GetMapEncounterRate loads the byte into b and
; `call Random` / `cp b` can never carry when b is 0, so nothing ever spawns.
	def_water_wildmons ROUTE_24
	db 0 percent ; encounter rate: Yellow has none here
	db 10, GOLDEEN
	db 5, GOLDEEN
	db 10, SEAKING
	end_water_wildmons

	def_water_wildmons ROUTE_25
	db 0 percent ; encounter rate: Yellow has none here
	db 10, GOLDEEN
	db 5, GOLDEEN
	db 10, SEAKING
	end_water_wildmons

	def_water_wildmons ROUTE_26
	db 6 percent ; encounter rate
	db 30, TENTACOOL
	db 25, TENTACOOL
	db 30, TENTACRUEL
	end_water_wildmons

	def_water_wildmons ROUTE_27
	db 6 percent ; encounter rate
	db 20, TENTACOOL
	db 15, TENTACOOL
	db 20, TENTACRUEL
	end_water_wildmons

	def_water_wildmons ROUTE_28
	db 2 percent ; encounter rate
	db 40, POLIWAG
	db 35, POLIWAG
	db 40, POLIWHIRL
	end_water_wildmons

	def_water_wildmons PALLET_TOWN
	db 0 percent ; encounter rate: Yellow has none here (L1)
	db 35, TENTACOOL
	db 30, TENTACOOL
	db 35, TENTACRUEL
	end_water_wildmons

	def_water_wildmons VIRIDIAN_CITY
	db 0 percent ; encounter rate: Yellow has none here (L1)
	db 10, POLIWAG
	db 5, POLIWAG
	db 10, POLIWHIRL
	end_water_wildmons

	def_water_wildmons CERULEAN_CITY
	db 0 percent ; encounter rate: Yellow has none here (L1)
	db 10, GOLDEEN
	db 5, GOLDEEN
	db 10, SEAKING
	end_water_wildmons

; Kanto hack (7m): VERMILION_CITY's surf table is DELETED, not zeroed. Yellow
; has no data/wild/maps/VermilionCity.asm at all -- the city's water is
; fishing-only (FISHGROUP_OCEAN, data/maps/maps.asm) -- and unlike 6h's
; Route 24/25 the row cannot simply drop to `0 percent`, because FindNest
; (engine/overworld/wildmons.asm:79 `.FindWater`) never reads the rate byte:
; a 0-rate table still lists the map as a habitat on the Pokedex AREA screen.
; Deleting the whole block removes both the surf encounters and the bogus
; TENTACOOL/TENTACRUEL nest. (ROUTE_4, ROUTE_24, ROUTE_25 and CERULEAN_CITY
; above are still zeroed rather than deleted -- see docs/AUDIT-M4-LEFTOVERS.md.)

	def_water_wildmons CELADON_CITY
	db 2 percent ; encounter rate
	db 20, GRIMER
	db 15, GRIMER
	db 15, MUK
	end_water_wildmons

	def_water_wildmons FUCHSIA_CITY
	db 2 percent ; encounter rate
	db 20, MAGIKARP
	db 15, MAGIKARP
	db 10, MAGIKARP
	end_water_wildmons

	def_water_wildmons CINNABAR_ISLAND
	db 6 percent ; encounter rate
	db 35, TENTACOOL
	db 30, TENTACOOL
	db 35, TENTACRUEL
	end_water_wildmons

	db -1 ; end
