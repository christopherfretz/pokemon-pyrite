; Kanto Pokémon in grass

KantoGrassWildMons:

; Kanto hack (7m): Yellow's Diglett's Cave table
; (vendor/pokeyellow/data/wild/maps/DiglettsCave.asm). Yellow rate 20/256 ==
; `8 percent` exactly, and Gen 1 has no time of day, so morn = day = nite.
; Yellow's ten slots fold to Crystal's seven by dropping three duplicated
; middle DIGLETTs -- slot 3 (L20, 9.8%), slot 4 (L16, 9.8%) and slot 6
; (L21, 5.1%) -- which keeps Yellow's order, both species and both level
; extremes (L15 min, L22 max). Species weights land at DIGLETT 95% /
; DUGTRIO 5%, against Yellow's 94.9% / 5.1%.
	def_grass_wildmons DIGLETTS_CAVE
	db 8 percent, 8 percent, 8 percent ; encounter rates: morn/day/nite
	; morn
	db 18, DIGLETT
	db 19, DIGLETT
	db 17, DIGLETT
	db 15, DIGLETT
	db 22, DIGLETT
	db 29, DUGTRIO
	db 31, DUGTRIO
	; day
	db 18, DIGLETT
	db 19, DIGLETT
	db 17, DIGLETT
	db 15, DIGLETT
	db 22, DIGLETT
	db 29, DUGTRIO
	db 31, DUGTRIO
	; nite
	db 18, DIGLETT
	db 19, DIGLETT
	db 17, DIGLETT
	db 15, DIGLETT
	db 22, DIGLETT
	db 29, DUGTRIO
	db 31, DUGTRIO
	end_grass_wildmons

; Kanto hack (docs/M2-MTMOON.md): Yellow's three Mt. Moon floors, replacing
; Crystal's single MOUNT_MOON block that 5b deleted. Tables are Yellow's
; (vendor/pokeyellow/data/wild/maps/MtMoon{1F,B1F,B2F}.asm), rate 10/256 ==
; `4 percent` in all three columns, morn/day/nite identical (Gen 1 has no time
; of day). Yellow's ten slots squeeze into GSC's seven by dropping duplicated
; middle entries, keeping Yellow's order and every species; no PIKACHU.

	; Kanto hack: dropped Yellow's ZUBAT 7, ZUBAT 10 and the second GEODUDE 10
	def_grass_wildmons MT_MOON_1F
	db 4 percent, 4 percent, 4 percent ; encounter rates: morn/day/nite
	; morn
	db  8, ZUBAT
	db  9, ZUBAT
	db 10, GEODUDE
	db  6, ZUBAT
	db 11, ZUBAT
	db 12, SANDSHREW
	db 11, CLEFAIRY
	; day
	db  8, ZUBAT
	db  9, ZUBAT
	db 10, GEODUDE
	db  6, ZUBAT
	db 11, ZUBAT
	db 12, SANDSHREW
	db 11, CLEFAIRY
	; nite
	db  8, ZUBAT
	db  9, ZUBAT
	db 10, GEODUDE
	db  6, ZUBAT
	db 11, ZUBAT
	db 12, SANDSHREW
	db 11, CLEFAIRY
	end_grass_wildmons

	; Kanto hack: dropped Yellow's ZUBAT 10, GEODUDE 11 and PARAS 11
	def_grass_wildmons MT_MOON_B1F
	db 4 percent, 4 percent, 4 percent ; encounter rates: morn/day/nite
	; morn
	db  8, ZUBAT
	db  9, ZUBAT
	db 10, GEODUDE
	db 11, ZUBAT
	db  9, PARAS
	db 10, CLEFAIRY
	db 12, CLEFAIRY
	; day
	db  8, ZUBAT
	db  9, ZUBAT
	db 10, GEODUDE
	db 11, ZUBAT
	db  9, PARAS
	db 10, CLEFAIRY
	db 12, CLEFAIRY
	; nite
	db  8, ZUBAT
	db  9, ZUBAT
	db 10, GEODUDE
	db 11, ZUBAT
	db  9, PARAS
	db 10, CLEFAIRY
	db 12, CLEFAIRY
	end_grass_wildmons

	; Kanto hack: dropped Yellow's duplicate ZUBAT 11, ZUBAT 13 and CLEFAIRY 11
	def_grass_wildmons MT_MOON_B2F
	db 4 percent, 4 percent, 4 percent ; encounter rates: morn/day/nite
	; morn
	db 10, ZUBAT
	db 11, GEODUDE
	db 13, PARAS
	db 11, ZUBAT
	db 12, ZUBAT
	db  9, CLEFAIRY
	db 13, CLEFAIRY
	; day
	db 10, ZUBAT
	db 11, GEODUDE
	db 13, PARAS
	db 11, ZUBAT
	db 12, ZUBAT
	db  9, CLEFAIRY
	db 13, CLEFAIRY
	; nite
	db 10, ZUBAT
	db 11, GEODUDE
	db 13, PARAS
	db 11, ZUBAT
	db 12, ZUBAT
	db  9, CLEFAIRY
	db 13, CLEFAIRY
	end_grass_wildmons

	def_grass_wildmons ROCK_TUNNEL_1F
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 10, CUBONE
	db 11, GEODUDE
	db 12, MACHOP
	db 12, ZUBAT
	db 15, MACHOKE
	db 12, MAROWAK
	db 12, MAROWAK
	; day
	db 10, CUBONE
	db 11, GEODUDE
	db 12, MACHOP
	db 12, ZUBAT
	db 15, MACHOKE
	db 12, MAROWAK
	db 12, MAROWAK
	; nite
	db 12, ZUBAT
	db 11, GEODUDE
	db 12, GEODUDE
	db 17, HAUNTER
	db 15, ZUBAT
	db 15, ZUBAT
	db 15, ZUBAT
	end_grass_wildmons

	def_grass_wildmons ROCK_TUNNEL_B1F
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 12, CUBONE
	db 14, GEODUDE
	db 16, ONIX
	db 12, ZUBAT
	db 15, MAROWAK
	db 15, KANGASKHAN
	db 15, KANGASKHAN
	; day
	db 12, CUBONE
	db 14, GEODUDE
	db 16, ONIX
	db 12, ZUBAT
	db 15, MAROWAK
	db 15, KANGASKHAN
	db 15, KANGASKHAN
	; nite
	db 12, ZUBAT
	db 14, GEODUDE
	db 16, ONIX
	db 15, ZUBAT
	db 15, HAUNTER
	db 15, GOLBAT
	db 15, GOLBAT
	end_grass_wildmons

	def_grass_wildmons VICTORY_ROAD
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 34, GRAVELER
	db 32, RHYHORN
	db 33, ONIX
	db 34, GOLBAT
	db 35, SANDSLASH
	db 35, RHYDON
	db 35, RHYDON
	; day
	db 34, GRAVELER
	db 32, RHYHORN
	db 33, ONIX
	db 34, GOLBAT
	db 35, SANDSLASH
	db 35, RHYDON
	db 35, RHYDON
	; nite
	db 34, GOLBAT
	db 34, GRAVELER
	db 32, ONIX
	db 36, GRAVELER
	db 38, GRAVELER
	db 40, GRAVELER
	db 40, GRAVELER
	end_grass_wildmons

	def_grass_wildmons TOHJO_FALLS
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 22, ZUBAT
	db 22, RATICATE
	db 24, GOLBAT
	db 21, SLOWPOKE
	db 20, RATTATA
	db 23, SLOWPOKE
	db 23, SLOWPOKE
	; day
	db 22, ZUBAT
	db 22, RATICATE
	db 24, GOLBAT
	db 21, SLOWPOKE
	db 20, RATTATA
	db 23, SLOWPOKE
	db 23, SLOWPOKE
	; nite
	db 22, ZUBAT
	db 22, RATICATE
	db 24, GOLBAT
	db 21, SLOWPOKE
	db 20, RATTATA
	db 23, SLOWPOKE
	db 23, SLOWPOKE
	end_grass_wildmons

; Kanto hack (L1, docs/AUDIT-KANTO-LEFTOVERS.md 2): Yellow's Route 1 table,
; vendor/pokeyellow/data/wild/maps/Route1.asm -- PIDGEY 70% / RATTATA 30%,
; L2-L7, no Johto species (ours was verbatim Crystal: SENTRET/FURRET/HOOTHOOT).
; Yellow's rate byte is 25 = `10 percent`; its ten slots fold to seven by
; dropping the duplicated middle entries (slot 4 RATTATA 3, slot 6 PIDGEY 3,
; slot 9 PIDGEY 6), keeping Yellow's order; morn = day = nite (Gen 1 has no
; time of day).
	def_grass_wildmons ROUTE_1
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	db 3, PIDGEY
	db 4, PIDGEY
	db 2, RATTATA
	db 2, PIDGEY
	db 5, PIDGEY
	db 4, RATTATA
	db 7, PIDGEY
	; day
	db 3, PIDGEY
	db 4, PIDGEY
	db 2, RATTATA
	db 2, PIDGEY
	db 5, PIDGEY
	db 4, RATTATA
	db 7, PIDGEY
	; nite
	db 3, PIDGEY
	db 4, PIDGEY
	db 2, RATTATA
	db 2, PIDGEY
	db 5, PIDGEY
	db 4, RATTATA
	db 7, PIDGEY
	end_grass_wildmons

; Kanto hack: Yellow's Route 2 table (docs/M2-ROUTE2.md). Yellow rate 25/256
; ~= 10 percent. Yellow has no time of day, so nite reuses the day column;
; the L6 NIDORANs take the rare slots on day/nite. No PIKACHU - the starter
; stays unique.
	def_grass_wildmons ROUTE_2
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	db 3, RATTATA
	db 3, PIDGEY
	db 4, RATTATA
	db 4, NIDORAN_M
	db 4, NIDORAN_F
	db 5, PIDGEY
	db 7, PIDGEY
	; day
	db 3, RATTATA
	db 3, PIDGEY
	db 4, RATTATA
	db 5, PIDGEY
	db 6, NIDORAN_M
	db 6, NIDORAN_F
	db 7, PIDGEY
	; nite
	db 3, RATTATA
	db 3, PIDGEY
	db 4, RATTATA
	db 5, PIDGEY
	db 6, NIDORAN_M
	db 6, NIDORAN_F
	db 7, PIDGEY
	end_grass_wildmons

; Kanto hack: Yellow's Viridian Forest table (docs/M2-FOREST.md). Yellow rate
; 25/256 ~= 10 percent, no time of day, so all three columns are the same.
; Yellow's ten slots squeeze into Crystal's seven: CATERPIE 3/4, METAPOD 4,
; PIDGEY 4/6, CATERPIE 6 and the 1 percent PIDGEOTTO 9. No PIKACHU - the
; starter stays unique (Yellow's forest has none either).
	def_grass_wildmons VIRIDIAN_FOREST
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	db 3, CATERPIE
	db 4, METAPOD
	db 4, CATERPIE
	db 4, PIDGEY
	db 6, CATERPIE
	db 6, PIDGEY
	db 9, PIDGEOTTO
	; day
	db 3, CATERPIE
	db 4, METAPOD
	db 4, CATERPIE
	db 4, PIDGEY
	db 6, CATERPIE
	db 6, PIDGEY
	db 9, PIDGEOTTO
	; nite
	db 3, CATERPIE
	db 4, METAPOD
	db 4, CATERPIE
	db 4, PIDGEY
	db 6, CATERPIE
	db 6, PIDGEY
	db 9, PIDGEOTTO
	end_grass_wildmons

; Kanto hack: Yellow's Route 3 table (docs/M2-MTMOON.md). Yellow rate 20/256
; ~= 8 percent, no time of day, so all three columns are the same. Yellow's
; ten slots squeeze into Crystal's seven: the duplicated middle SPEAROW 10,
; SPEAROW 11 and SANDSHREW 10 are dropped, keeping Yellow's order and all
; four species (SPEAROW/MANKEY/SANDSHREW/RATTATA, L8-12). No EKANS/ARBOK/
; RATICATE/CLEFAIRY (Crystal's own table) and no PIKACHU.
	def_grass_wildmons ROUTE_3
	db 8 percent, 8 percent, 8 percent ; encounter rates: morn/day/nite
	; morn
	db  8, SPEAROW
	db  9, SPEAROW
	db  9, MANKEY
	db  8, SANDSHREW
	db 10, RATTATA
	db 12, RATTATA
	db 12, SPEAROW
	; day
	db  8, SPEAROW
	db  9, SPEAROW
	db  9, MANKEY
	db  8, SANDSHREW
	db 10, RATTATA
	db 12, RATTATA
	db 12, SPEAROW
	; nite
	db  8, SPEAROW
	db  9, SPEAROW
	db  9, MANKEY
	db  8, SANDSHREW
	db 10, RATTATA
	db 12, RATTATA
	db 12, SPEAROW
	end_grass_wildmons

	def_grass_wildmons ROUTE_4
	db 8 percent, 8 percent, 8 percent ; encounter rates: morn/day/nite
	; morn
	db  8, SPEAROW
	db  9, SPEAROW
	db  9, MANKEY
	db  8, SANDSHREW
	db 10, RATTATA
	db 12, RATTATA
	db 12, SPEAROW
	; day
	db  8, SPEAROW
	db  9, SPEAROW
	db  9, MANKEY
	db  8, SANDSHREW
	db 10, RATTATA
	db 12, RATTATA
	db 12, SPEAROW
	; nite
	db  8, SPEAROW
	db  9, SPEAROW
	db  9, MANKEY
	db  8, SANDSHREW
	db 10, RATTATA
	db 12, RATTATA
	db 12, SPEAROW
	end_grass_wildmons

; Kanto hack (7m): Yellow's Route 5 table
; (vendor/pokeyellow/data/wild/maps/Route5.asm). Yellow rate 15/256 ==
; `6 percent` exactly; no time of day, so morn = day = nite. Yellow's ten
; slots fold to seven by dropping the three duplicated middle entries
; PIDGEY 16 (slot 3, 9.8%), RATTATA 16 (slot 4, 9.8%) and JIGGLYPUFF 5
; (slot 8, 3.9%), which keeps Yellow's order, all five species and both level
; extremes (L3 JIGGLYPUFF, L17 PIDGEY/PIDGEOTTO). Resulting species weights
; PIDGEY 40 / RATTATA 30 / ABRA 20 / PIDGEOTTO 5 / JIGGLYPUFF 5, against
; Yellow's 39.1 / 29.3 / 14.8 / 5.1 / 10.2. Gone: Crystal's SNUBBULL,
; HOOTHOOT, MEOWTH, NOCTOWL. No PIKACHU -- the starter stays unique.
	def_grass_wildmons ROUTE_5
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 15, PIDGEY
	db 14, RATTATA
	db  7, ABRA
	db 17, PIDGEY
	db 17, PIDGEOTTO
	db  3, JIGGLYPUFF
	db  7, JIGGLYPUFF
	; day
	db 15, PIDGEY
	db 14, RATTATA
	db  7, ABRA
	db 17, PIDGEY
	db 17, PIDGEOTTO
	db  3, JIGGLYPUFF
	db  7, JIGGLYPUFF
	; nite
	db 15, PIDGEY
	db 14, RATTATA
	db  7, ABRA
	db 17, PIDGEY
	db 17, PIDGEOTTO
	db  3, JIGGLYPUFF
	db  7, JIGGLYPUFF
	end_grass_wildmons

; Kanto hack (7m): Yellow's Route 6 grass table is byte-identical to Route 5's
; (vendor/pokeyellow/data/wild/maps/Route6.asm) -- same rate 15, same ten
; slots -- so the same conversion applies. Gone: Crystal's SNUBBULL,
; MAGNEMITE, GRANBULL, MEOWTH, DROWZEE, PSYDUCK, RATICATE.
	def_grass_wildmons ROUTE_6
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 15, PIDGEY
	db 14, RATTATA
	db  7, ABRA
	db 17, PIDGEY
	db 17, PIDGEOTTO
	db  3, JIGGLYPUFF
	db  7, JIGGLYPUFF
	; day
	db 15, PIDGEY
	db 14, RATTATA
	db  7, ABRA
	db 17, PIDGEY
	db 17, PIDGEOTTO
	db  3, JIGGLYPUFF
	db  7, JIGGLYPUFF
	; nite
	db 15, PIDGEY
	db 14, RATTATA
	db  7, ABRA
	db 17, PIDGEY
	db 17, PIDGEOTTO
	db  3, JIGGLYPUFF
	db  7, JIGGLYPUFF
	end_grass_wildmons

	def_grass_wildmons ROUTE_7
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	db 17, RATTATA
	db 17, SPEAROW
	db 18, SNUBBULL
	db 18, RATICATE
	db 18, JIGGLYPUFF
	db 16, ABRA
	db 16, ABRA
	; day
	db 17, RATTATA
	db 17, SPEAROW
	db 18, SNUBBULL
	db 18, RATICATE
	db 18, JIGGLYPUFF
	db 16, ABRA
	db 16, ABRA
	; nite
	db 17, MEOWTH
	db 17, MURKROW
	db 18, HOUNDOUR
	db 18, PERSIAN
	db 18, JIGGLYPUFF
	db 16, ABRA
	db 16, ABRA
	end_grass_wildmons

	def_grass_wildmons ROUTE_8
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	db 17, SNUBBULL
	db 19, PIDGEOTTO
	db 16, ABRA
	db 17, GROWLITHE
	db 16, JIGGLYPUFF
	db 18, KADABRA
	db 18, KADABRA
	; day
	db 17, SNUBBULL
	db 19, PIDGEOTTO
	db 16, ABRA
	db 17, GROWLITHE
	db 16, JIGGLYPUFF
	db 18, KADABRA
	db 18, KADABRA
	; nite
	db 17, MEOWTH
	db 20, NOCTOWL
	db 16, ABRA
	db 17, HAUNTER
	db 16, JIGGLYPUFF
	db 18, KADABRA
	db 18, KADABRA
	end_grass_wildmons

; Kanto hack (M5): Yellow's Route 9 table
; (vendor/pokeyellow/data/wild/maps/Route9.asm). Yellow rate 15/256 ==
; `6 percent` exactly; no time of day, so morn = day = nite. Yellow lists
; EIGHT species in ten slots and Crystal has only seven slots, so one species
; must go: the two duplicated L18 NIDORANs (slots 3-4) and FEAROW (slot 9,
; 1.2% -- Yellow's rarest slot anywhere, and still obtainable by evolving the
; SPEAROW that stays). Weights land NIDORAN_M 30 / NIDORAN_F 30 / RATTATA 20 /
; SPEAROW 10 / NIDORINO 5 / NIDORINA 4 / RATICATE 1 against Yellow's
; 29.7 / 29.7 / 15.2 / 9.8 / 5.1 / 5.1 / 4.3, and both level extremes (L16
; min, L20 RATICATE max) survive. Gone: Crystal's VENONAT, VENOMOTH, ZUBAT,
; MAROWAK and its nite block.
	def_grass_wildmons ROUTE_9
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 16, NIDORAN_M
	db 16, NIDORAN_F
	db 18, RATTATA
	db 17, SPEAROW
	db 18, NIDORINO
	db 18, NIDORINA
	db 20, RATICATE
	; day
	db 16, NIDORAN_M
	db 16, NIDORAN_F
	db 18, RATTATA
	db 17, SPEAROW
	db 18, NIDORINO
	db 18, NIDORINA
	db 20, RATICATE
	; nite
	db 16, NIDORAN_M
	db 16, NIDORAN_F
	db 18, RATTATA
	db 17, SPEAROW
	db 18, NIDORINO
	db 18, NIDORINA
	db 20, RATICATE
	end_grass_wildmons

; Kanto hack (M5 8d): Yellow's Route 10 table
; (vendor/pokeyellow/data/wild/maps/Route10.asm).  Yellow rate 15/256 ==
; `6 percent`; Gen 1 has no time of day, so morn = day = nite.  8b merged our
; two halves back into Yellow's single 10x36 ROUTE_10, so there is one table.
; Ten Yellow slots fold to seven by dropping the duplicated middle MAGNEMITEs
; at slots 2 (L18) and 3 (L20) plus the duplicated MACHOP at slot 9 (L18),
; which keeps slot 0 (L16) and slot 6 (L22) and so both of Yellow's level
; extremes.  Gone: Crystal's VOLTORB, ELECTABUZZ, MAROWAK, SPEAROW, FEAROW,
; VENONAT, VENOMOTH, ZUBAT and its nite block.
	def_grass_wildmons ROUTE_10
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 16, MAGNEMITE
	db 18, RATTATA
	db 17, NIDORAN_M
	db 17, NIDORAN_F
	db 22, MAGNEMITE
	db 20, RATICATE
	db 16, MACHOP
	; day
	db 16, MAGNEMITE
	db 18, RATTATA
	db 17, NIDORAN_M
	db 17, NIDORAN_F
	db 22, MAGNEMITE
	db 20, RATICATE
	db 16, MACHOP
	; nite
	db 16, MAGNEMITE
	db 18, RATTATA
	db 17, NIDORAN_M
	db 17, NIDORAN_F
	db 22, MAGNEMITE
	db 20, RATICATE
	db 16, MACHOP
	end_grass_wildmons

; Kanto hack (7m): Yellow's Route 11 table
; (vendor/pokeyellow/data/wild/maps/Route11.asm). Yellow rate 15/256 ==
; `6 percent` exactly; no time of day, so morn = day = nite. Yellow's ten
; slots fold to seven by dropping RATTATA 17 (slot 4, 9.8%), PIDGEOTTO 18
; (slot 6, 5.1%) and DROWZEE 19 (slot 8, 3.9%) -- the three duplicated middle
; entries whose species survive elsewhere -- keeping Yellow's order, all five
; species and both level extremes (L15 min, L20 PIDGEOTTO max). NOTE the
; distribution cost of keeping Yellow's *order*: Yellow puts PIDGEY in slots 0
; and 2, which Crystal weights 30% + 20%, so PIDGEY rises 34.4 -> 50 and
; DROWZEE falls 23.5 -> 15 (RATTATA 30, PIDGEOTTO 4, RATICATE 1 are within a
; point). Swapping this table's slots 2 and 3 would restore DROWZEE at the
; cost of Yellow's literal order -- an open question in
; docs/AUDIT-M4-LEFTOVERS.md. Gone: Crystal's HOPPIP, MAGNEMITE, MEOWTH,
; NOCTOWL, HYPNO.
	def_grass_wildmons ROUTE_11
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 16, PIDGEY
	db 15, RATTATA
	db 18, PIDGEY
	db 15, DROWZEE
	db 17, DROWZEE
	db 20, PIDGEOTTO
	db 17, RATICATE
	; day
	db 16, PIDGEY
	db 15, RATTATA
	db 18, PIDGEY
	db 15, DROWZEE
	db 17, DROWZEE
	db 20, PIDGEOTTO
	db 17, RATICATE
	; nite
	db 16, PIDGEY
	db 15, RATTATA
	db 18, PIDGEY
	db 15, DROWZEE
	db 17, DROWZEE
	db 20, PIDGEOTTO
	db 17, RATICATE
	end_grass_wildmons

	def_grass_wildmons ROUTE_13
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	db 23, NIDORINO
	db 23, NIDORINA
	db 25, PIDGEOTTO
	db 25, HOPPIP
	db 27, HOPPIP
	db 27, HOPPIP
	db 25, CHANSEY
	; day
	db 23, NIDORINO
	db 23, NIDORINA
	db 25, PIDGEOTTO
	db 25, HOPPIP
	db 27, HOPPIP
	db 27, HOPPIP
	db 25, CHANSEY
	; nite
	db 23, VENONAT
	db 23, QUAGSIRE
	db 25, NOCTOWL
	db 25, VENOMOTH
	db 25, QUAGSIRE
	db 25, QUAGSIRE
	db 25, CHANSEY
	end_grass_wildmons

	def_grass_wildmons ROUTE_14
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	db 26, NIDORINO
	db 26, NIDORINA
	db 28, PIDGEOTTO
	db 28, HOPPIP
	db 30, SKIPLOOM
	db 30, SKIPLOOM
	db 28, CHANSEY
	; day
	db 26, NIDORINO
	db 26, NIDORINA
	db 28, PIDGEOTTO
	db 28, HOPPIP
	db 30, SKIPLOOM
	db 30, SKIPLOOM
	db 28, CHANSEY
	; nite
	db 26, VENONAT
	db 26, QUAGSIRE
	db 28, NOCTOWL
	db 28, VENOMOTH
	db 28, QUAGSIRE
	db 28, QUAGSIRE
	db 28, CHANSEY
	end_grass_wildmons

	def_grass_wildmons ROUTE_15
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	db 23, NIDORINO
	db 23, NIDORINA
	db 25, PIDGEOTTO
	db 25, HOPPIP
	db 27, HOPPIP
	db 27, HOPPIP
	db 25, CHANSEY
	; day
	db 23, NIDORINO
	db 23, NIDORINA
	db 25, PIDGEOTTO
	db 25, HOPPIP
	db 27, HOPPIP
	db 27, HOPPIP
	db 25, CHANSEY
	; nite
	db 23, VENONAT
	db 23, QUAGSIRE
	db 25, NOCTOWL
	db 25, VENOMOTH
	db 25, QUAGSIRE
	db 25, QUAGSIRE
	db 25, CHANSEY
	end_grass_wildmons

	def_grass_wildmons ROUTE_16
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	db 26, GRIMER
	db 27, FEAROW
	db 28, GRIMER
	db 29, FEAROW
	db 29, FEAROW
	db 30, MUK
	db 30, MUK
	; day
	db 26, GRIMER
	db 27, FEAROW
	db 28, GRIMER
	db 29, FEAROW
	db 29, SLUGMA
	db 30, MUK
	db 30, MUK
	; nite
	db 26, GRIMER
	db 27, GRIMER
	db 28, GRIMER
	db 29, MURKROW
	db 29, MURKROW
	db 30, MUK
	db 30, MUK
	end_grass_wildmons

	def_grass_wildmons ROUTE_17
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	db 30, FEAROW
	db 29, GRIMER
	db 31, GRIMER
	db 32, FEAROW
	db 33, GRIMER
	db 33, MUK
	db 33, MUK
	; day
	db 30, FEAROW
	db 29, SLUGMA
	db 29, GRIMER
	db 32, FEAROW
	db 32, SLUGMA
	db 33, MUK
	db 33, MUK
	; nite
	db 30, GRIMER
	db 29, GRIMER
	db 31, GRIMER
	db 32, GRIMER
	db 33, GRIMER
	db 33, MUK
	db 33, MUK
	end_grass_wildmons

	def_grass_wildmons ROUTE_18
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	db 26, GRIMER
	db 27, FEAROW
	db 28, GRIMER
	db 29, FEAROW
	db 29, FEAROW
	db 30, MUK
	db 30, MUK
	; day
	db 26, GRIMER
	db 27, FEAROW
	db 28, GRIMER
	db 29, FEAROW
	db 29, SLUGMA
	db 30, MUK
	db 30, MUK
	; nite
	db 26, GRIMER
	db 27, GRIMER
	db 28, GRIMER
	db 29, GRIMER
	db 29, GRIMER
	db 30, MUK
	db 30, MUK
	end_grass_wildmons

	def_grass_wildmons ROUTE_21
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 30, TANGELA
	db 25, RATTATA
	db 35, TANGELA
	db 20, RATICATE
	db 30, MR__MIME
	db 28, MR__MIME
	db 28, MR__MIME
	; day
	db 30, TANGELA
	db 25, RATTATA
	db 35, TANGELA
	db 20, RATICATE
	db 28, MR__MIME
	db 30, MR__MIME
	db 30, MR__MIME
	; nite
	db 30, TANGELA
	db 25, RATTATA
	db 35, TANGELA
	db 20, RATICATE
	db 30, TANGELA
	db 28, TANGELA
	db 28, TANGELA
	end_grass_wildmons

; Kanto hack (L1, docs/AUDIT-KANTO-LEFTOVERS.md 2): Yellow's Route 22 table,
; vendor/pokeyellow/data/wild/maps/Route22.asm -- NIDORAN_M / NIDORAN_F /
; MANKEY / RATTATA / SPEAROW, L2-L6 (ours was verbatim Crystal, with a L7
; FEAROW and a L6 PONYTA on the route the player walks before Viridian Forest
; with a L5 starter; this is also the set the rival's first battle is balanced
; around, docs/M2-ROUTE22.md).  Yellow's rate byte is 25 = `10 percent`; its ten
; slots fold to seven by dropping the duplicated middle entries (NIDORAN_M 4,
; NIDORAN_F 4, SPEAROW 4), keeping Yellow's order; morn = day = nite.
	def_grass_wildmons ROUTE_22
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	db 2, NIDORAN_M
	db 2, NIDORAN_F
	db 3, MANKEY
	db 3, RATTATA
	db 5, MANKEY
	db 2, SPEAROW
	db 6, SPEAROW
	; day
	db 2, NIDORAN_M
	db 2, NIDORAN_F
	db 3, MANKEY
	db 3, RATTATA
	db 5, MANKEY
	db 2, SPEAROW
	db 6, SPEAROW
	; nite
	db 2, NIDORAN_M
	db 2, NIDORAN_F
	db 3, MANKEY
	db 3, RATTATA
	db 5, MANKEY
	db 2, SPEAROW
	db 6, SPEAROW
	end_grass_wildmons

; Kanto hack (6h): Yellow's Route 24 table, vendor/pokeyellow/data/wild/maps/
; Route24.asm.  Yellow's rate byte is 25 = `10 percent`; its ten slots fold to
; seven by dropping the duplicated middle entries (15 PIDGEY, 16 VENONAT,
; 17 PIDGEY), keeping Yellow's order and relative weights; morn = day = nite.
	def_grass_wildmons ROUTE_24
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	db 12, ODDISH
	db 12, BELLSPROUT
	db 13, PIDGEY
	db 14, ODDISH
	db 14, BELLSPROUT
	db 13, VENONAT
	db 17, PIDGEOTTO
	; day
	db 12, ODDISH
	db 12, BELLSPROUT
	db 13, PIDGEY
	db 14, ODDISH
	db 14, BELLSPROUT
	db 13, VENONAT
	db 17, PIDGEOTTO
	; nite
	db 12, ODDISH
	db 12, BELLSPROUT
	db 13, PIDGEY
	db 14, ODDISH
	db 14, BELLSPROUT
	db 13, VENONAT
	db 17, PIDGEOTTO
	end_grass_wildmons

	def_grass_wildmons ROUTE_25
; Kanto hack (6i): Yellow's Route 25 table.  Yellow rate 15 -> 6 percent
; (docs/PORTING.md).  Yellow has ten slots and no time of day, so the two
; duplicate PIDGEY (15/17) and the duplicate VENONAT (16) are dropped to fit
; GSC's seven, and morn/day/nite are identical.  Same species list as Route 24
; (6h), which is exactly what Yellow does.
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 12, ODDISH
	db 12, BELLSPROUT
	db 13, PIDGEY
	db 14, ODDISH
	db 14, BELLSPROUT
	db 13, VENONAT
	db 17, PIDGEOTTO
	; day
	db 12, ODDISH
	db 12, BELLSPROUT
	db 13, PIDGEY
	db 14, ODDISH
	db 14, BELLSPROUT
	db 13, VENONAT
	db 17, PIDGEOTTO
	; nite
	db 12, ODDISH
	db 12, BELLSPROUT
	db 13, PIDGEY
	db 14, ODDISH
	db 14, BELLSPROUT
	db 13, VENONAT
	db 17, PIDGEOTTO
	end_grass_wildmons

	def_grass_wildmons ROUTE_26
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	db 28, DODUO
	db 28, SANDSLASH
	db 32, PONYTA
	db 30, RATICATE
	db 30, DODUO
	db 30, ARBOK
	db 30, ARBOK
	; day
	db 28, DODUO
	db 28, SANDSLASH
	db 32, PONYTA
	db 30, RATICATE
	db 30, DODUO
	db 30, ARBOK
	db 30, ARBOK
	; nite
	db 28, NOCTOWL
	db 28, RATICATE
	db 32, NOCTOWL
	db 30, RATICATE
	db 30, QUAGSIRE
	db 30, QUAGSIRE
	db 30, QUAGSIRE
	end_grass_wildmons

	def_grass_wildmons ROUTE_27
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	db 28, DODUO
	db 28, ARBOK
	db 30, RATICATE
	db 30, DODUO
	db 32, PONYTA
	db 30, DODRIO
	db 30, DODRIO
	; day
	db 28, DODUO
	db 28, ARBOK
	db 30, RATICATE
	db 30, DODUO
	db 32, PONYTA
	db 30, DODRIO
	db 30, DODRIO
	; nite
	db 28, QUAGSIRE
	db 28, NOCTOWL
	db 30, RATICATE
	db 30, QUAGSIRE
	db 32, NOCTOWL
	db 32, NOCTOWL
	db 32, NOCTOWL
	end_grass_wildmons

	def_grass_wildmons ROUTE_28
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	db 39, TANGELA
	db 40, PONYTA
	db 40, RAPIDASH
	db 42, ARBOK
	db 41, DODUO
	db 43, DODRIO
	db 43, DODRIO
	; day
	db 39, TANGELA
	db 40, PONYTA
	db 40, RAPIDASH
	db 42, ARBOK
	db 41, DODUO
	db 43, DODRIO
	db 43, DODRIO
	; nite
	db 39, TANGELA
	db 40, POLIWHIRL
	db 40, GOLBAT
	db 40, POLIWHIRL
	db 42, GOLBAT
	db 42, GOLBAT
	db 42, GOLBAT
	end_grass_wildmons

	db -1 ; end
