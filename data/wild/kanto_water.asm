; Kanto Pokémon in water

KantoWaterWildMons:

	def_water_wildmons TOHJO_FALLS ; Kanto hack (M11 14a, D145): entry band Lv52-58 (Crystal Lv15-32 -> 52 + (old-20)/2, clamped)
	db 4 percent ; encounter rate
	db 52, GOLDEEN
	db 52, SLOWPOKE
	db 52, SEAKING
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
; Kanto hack (M5 8l): Yellow's Route 12 water table
; (vendor/pokeyellow/data/wild/maps/Route12.asm) -- SLOWPOKE L15 in eight of
; the ten slots (94.5%), SLOWBRO L15 (4.3%) and SLOWBRO L20 (1.2%). Crystal
; has three water slots weighted 60/30/10, so the eight SLOWPOKEs become the
; two commons and SLOWBRO takes the 10% slot: 90 / 10 against Yellow's
; 94.5 / 5.5. Both levels are Yellow's FLOOR, not its listed level, because
; ChooseWildEncounter (engine/overworld/wildmons.asm) rolls +0..+4 on any
; water encounter (35/30/20/10/5%): base 15 yields L15-19, covering Yellow's
; SLOWBRO L15 exactly and reaching its L20 rare without overshooting it.
; The rate byte is Yellow's own 3/256: the `percent` macro (`* $ff / 100`)
; cannot express it -- `1 percent` is 2, `2 percent` is 5 -- so it is written
; literally, as for ROUTE_6 above. Gone: Crystal's QWILFISH-era TENTACOOL/
; QUAGSIRE/TENTACRUEL at L25 (QUAGSIRE is a Gen 2 anachronism).
	def_water_wildmons ROUTE_12
	db 3 ; encounter rate: Yellow's own 3/256 (~1.2%)
	db 15, SLOWPOKE
	db 15, SLOWPOKE
	db 15, SLOWBRO
	end_water_wildmons

; Kanto hack (M7 10n): Yellow's Route 13 water table
; (vendor/pokeyellow/data/wild/maps/Route13.asm) is ROUTE_12's row for row --
; SLOWPOKE L15 in eight of the ten slots (94.5%), SLOWBRO L15 (4.3%) and
; SLOWBRO L20 (1.2%) -- so it folds the same way: the eight SLOWPOKEs become
; Crystal's two commons and SLOWBRO takes the 10% slot, 90 / 10 against
; Yellow's 94.5 / 5.5.  Levels are Yellow's FLOOR because ChooseWildEncounter
; rolls +0..+4 on water encounters, so base 15 yields L15-19 and reaches
; Yellow's L20 SLOWBRO rare without overshooting it.  The rate byte is
; Yellow's own 3/256: the `percent` macro (`* $ff / 100`) cannot express it --
; `1 percent` is 2 and `2 percent` is 5 -- so it is written literally, as for
; ROUTE_6 and ROUTE_12 above.  Gone: Crystal's TENTACOOL / QUAGSIRE /
; TENTACRUEL at L25 (QUAGSIRE is a Gen 2 anachronism).
	def_water_wildmons ROUTE_13
	db 3 ; encounter rate: Yellow's own 3/256 (~1.2%)
	db 15, SLOWPOKE
	db 15, SLOWPOKE
	db 15, SLOWBRO
	end_water_wildmons

; Kanto hack (M7 10n): ROUTE_14 and ROUTE_15 have no block here, and must not
; gain one: Yellow gives both `def_water_wildmons 0` with no entries
; (vendor/pokeyellow/data/wild/maps/Route14.asm, Route15.asm), and neither map
; has surfable water anyway.  Same for the four SAFARI_ZONE areas added to
; data/wild/kanto_grass.asm in M7 10n -- Yellow gives all four
; `def_water_wildmons 0`, so the Safari Zone has no surf encounters at all
; (its water is fishing-only; see FISHGROUP_KANTO_SAFARI* in
; data/maps/maps.asm).

; Kanto hack (M9 12o): ROUTES 19, 20 and 21 carry Yellow's one sea table
; (vendor/pokeyellow/data/wild/maps/Route19.asm, Route20.asm, Route21.asm:
; rate 5, TENTACOOL L5/10/15/5/10/15/20/30/35/40).  `percent` cannot express
; 5/256 (`2 percent` is 5, but reads as a rounding accident), so it is written
; literally as for ROUTE_6.  Crystal's three water slots (60/30/10) take
; Yellow's top three (L5/L10/L15, 19.9+19.9+15.2 of Yellow's odds); the
; dropped tail (L5/10/15 repeats, L20/30/35/40, ~45% of Yellow's odds but all
; TENTACOOL) costs only the high levels -- Crystal's +0..+4 surf level buff
; reaches L19.  Gone: Crystal's L30-35 TENTACOOL/TENTACRUEL (TENTACRUEL is not
; a Yellow surf encounter on these routes at all).
	def_water_wildmons ROUTE_19
	db 5 ; encounter rate: Yellow's own 5/256 (~2.0%)
	db 5, TENTACOOL
	db 10, TENTACOOL
	db 15, TENTACOOL
	end_water_wildmons

	def_water_wildmons ROUTE_20
	db 5 ; encounter rate: Yellow's own 5/256 (~2.0%)
	db 5, TENTACOOL
	db 10, TENTACOOL
	db 15, TENTACOOL
	end_water_wildmons

	def_water_wildmons ROUTE_21
	db 5 ; encounter rate: Yellow's own 5/256 (~2.0%)
	db 5, TENTACOOL
	db 10, TENTACOOL
	db 15, TENTACOOL
	end_water_wildmons

; Kanto hack (M9 12o): SEAFOAM ISLANDS B3F and B4F -- Yellow's only two Seafoam
; floors with surf encounters (SeafoamIslandsB3F.asm/B4F.asm: rate 5,
; TENTACOOL 25/30/20, STARYU 30, TENTACOOL 35, STARYU 30, TENTACOOL 40, STARYU
; 30/30/30; 1F/B1F/B2F are `def_water_wildmons 0`, so they get no table).
; A straight top-three (25/30/20 TENTACOOL) would drop STARYU, which is 30.1%
; of Yellow's odds, so the fold keeps the species split instead: 60% TENTACOOL
; L25 (slot 1), 30% STARYU L30 (slot 4), 10% TENTACOOL L30 (slot 2) = 70/30
; against Yellow's 69.9/30.1.
	def_water_wildmons SEAFOAM_ISLANDS_B3F
	db 5 ; encounter rate: Yellow's own 5/256 (~2.0%)
	db 25, TENTACOOL
	db 30, STARYU
	db 30, TENTACOOL
	end_water_wildmons

	def_water_wildmons SEAFOAM_ISLANDS_B4F
	db 5 ; encounter rate: Yellow's own 5/256 (~2.0%)
	db 25, TENTACOOL
	db 30, STARYU
	db 30, TENTACOOL
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

	def_water_wildmons ROUTE_26 ; Kanto hack (M11 14a, D145): entry band Lv52-58 (Crystal Lv15-32 -> 52 + (old-20)/2, clamped)
	db 6 percent ; encounter rate
	db 57, TENTACOOL
	db 54, TENTACOOL
	db 57, TENTACRUEL
	end_water_wildmons

	def_water_wildmons ROUTE_27 ; Kanto hack (M11 14a, D145): entry band Lv52-58 (Crystal Lv15-32 -> 52 + (old-20)/2, clamped)
	db 6 percent ; encounter rate
	db 52, TENTACOOL
	db 52, TENTACOOL
	db 52, TENTACRUEL
	end_water_wildmons

	def_water_wildmons ROUTE_28
	db 2 percent ; encounter rate
	db 90, POLIWAG
	db 85, POLIWAG
	db 90, POLIWHIRL
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

; Kanto hack (M7 10n): FUCHSIA_CITY's surf table is DELETED, not zeroed, for
; the same reason as VERMILION_CITY above (7m): Yellow has no
; data/wild/maps/FuchsiaCity.asm at all -- the city's water is fishing-only
; (FISHGROUP_KANTO_FUCHSIA, data/maps/maps.asm) -- and FindNest's .FindWater
; never reads the rate byte, so a 0-rate block would still list FUCHSIA CITY
; as a MAGIKARP habitat on the Pokedex AREA screen.  Gone with it: Crystal's
; `2 percent` MAGIKARP L20/L15/L10 surf rows.

; Kanto hack (M9 12o): CINNABAR_ISLAND's surf table is DELETED, not zeroed, for
; the same reason as FUCHSIA_CITY above: Yellow's CINNABAR_ISLAND is
; NothingWildMons (vendor/pokeyellow/data/wild/grass_water.asm) -- its water is
; fishing-only (FISHGROUP_KANTO_CINNABAR) -- and a 0-rate block would still list
; CINNABAR as a habitat on the Pokedex AREA screen.  Gone with it: Crystal's
; `6 percent` TENTACOOL L35/L30 / TENTACRUEL L35 rows.

	db -1 ; end
