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

; Kanto hack (M5 8f): Yellow's Rock Tunnel 1F table
; (vendor/pokeyellow/data/wild/maps/RockTunnel1F.asm). Yellow rate 15/256 ==
; `6 percent`; no time of day, so morn = day = nite. Only three species, so
; the 10 -> 7 fold is nearly exact: dropping slots 3 (L19 ZUBAT), 4 (L18
; GEODUDE) and 6 (L21 ZUBAT) gives ZUBAT 50 / GEODUDE 40 / MACHOP 10 against
; Yellow's 50.0 / 39.5 / 10.6, and keeps both level extremes (L15 ZUBAT min,
; L21 MACHOP max). Gone: Crystal's CUBONE, MAROWAK, MACHOKE, HAUNTER, GOLBAT
; and its nite block -- CUBONE is Pokemon Tower only in Yellow (M6), and
; KANGASKHAN/MACHOKE/HAUNTER/GOLBAT are Gen 2 redistributions.
	def_grass_wildmons ROCK_TUNNEL_1F
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 15, ZUBAT
	db 16, GEODUDE
	db 17, ZUBAT
	db 20, GEODUDE
	db 17, MACHOP
	db 19, MACHOP
	db 21, MACHOP
	; day
	db 15, ZUBAT
	db 16, GEODUDE
	db 17, ZUBAT
	db 20, GEODUDE
	db 17, MACHOP
	db 19, MACHOP
	db 21, MACHOP
	; nite
	db 15, ZUBAT
	db 16, GEODUDE
	db 17, ZUBAT
	db 20, GEODUDE
	db 17, MACHOP
	db 19, MACHOP
	db 21, MACHOP
	end_grass_wildmons

; Kanto hack (M5 8f): Yellow's Rock Tunnel B1F table
; (vendor/pokeyellow/data/wild/maps/RockTunnelB1F.asm) -- a different table
; from 1F's: B1F is where ONIX lives and where the levels top out. Yellow rate
; 15/256 == `6 percent`; no time of day, so morn = day = nite. Dropping the
; three duplicated middles -- slots 4 (L22 ZUBAT), 5 (L21 GEODUDE) and 6 (L20
; MACHOP) -- fits all four species to within 0.6 points: ZUBAT 40 /
; GEODUDE 30 / MACHOP 20 / ONIX 10 against Yellow's 39.5 / 29.7 / 20.3 / 10.6,
; with all three of ONIX's levels kept so L14 min and L22 max both survive.
; Gone: Crystal's CUBONE, MAROWAK, KANGASKHAN, HAUNTER, GOLBAT and its nite
; block.
	def_grass_wildmons ROCK_TUNNEL_B1F
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 20, ZUBAT
	db 17, GEODUDE
	db 18, MACHOP
	db 21, ZUBAT
	db 14, ONIX
	db 18, ONIX
	db 22, ONIX
	; day
	db 20, ZUBAT
	db 17, GEODUDE
	db 18, MACHOP
	db 21, ZUBAT
	db 14, ONIX
	db 18, ONIX
	db 22, ONIX
	; nite
	db 20, ZUBAT
	db 17, GEODUDE
	db 18, MACHOP
	db 21, ZUBAT
	db 14, ONIX
	db 18, ONIX
	db 22, ONIX
	end_grass_wildmons

; Kanto hack (docs/M6-TOWER.md, 9b): Yellow's POKéMON TOWER tables
; (vendor/pokeyellow/data/wild/maps/PokemonTower{3..7}F.asm).  Gen 1 has no
; time of day, so morn = day = nite.  Yellow's encounter rates convert exactly:
; 10/256 == `4 percent` (3F, 4F), 15/256 == `6 percent` (5F, 6F), 20/256 ==
; `8 percent` (7F).  1F and 2F are rate 0 in Yellow and get NO table at all --
; a map absent from this list never rolls.
;
; These five floors are the only source of CUBONE in the game, exactly as in
; Yellow; hack/data/wild/kanto_grass.asm's ROCK_TUNNEL_1F comment (M5 8f)
; promised it here.
;
; The 10 -> 7 fold drops three of Yellow's duplicated middle GASTLY slots on
; every floor and keeps Yellow's order otherwise.  Gen 1 slot weights /256 are
; 51,51,39,25,25,25,13,13,10,4 (19.9/19.9/15.2/9.8/9.8/9.8/5.1/5.1/3.9/1.6 %)
; against GSC's 30/30/20/10/5/4/1.  Species shares land within half a point of
; Yellow's on every floor (3F/4F GASTLY 95 / HAUNTER 5 vs 94.6/5.5; 5F-7F
; GASTLY 90 / HAUNTER 5 / CUBONE 5 vs 89.5/5.5/5.1), and both level extremes
; survive on all five.
;
; They live here, in the dungeon cluster at the head of the file rather than in
; LAVENDER map-id order, because the engine's lookup is a linear scan: order
; carries no meaning, and the Tower belongs beside Mt. Moon and Rock Tunnel.
;
; 3F and 4F share one table in Yellow, byte for byte.  Dropped: slots 3 (22
; GASTLY), 5 (24 GASTLY) and 6 (19 GASTLY).
	def_grass_wildmons POKEMON_TOWER_3F
	db 4 percent, 4 percent, 4 percent ; encounter rates: morn/day/nite
	; morn
	db 20, GASTLY
	db 21, GASTLY
	db 23, GASTLY
	db 25, GASTLY
	db 18, GASTLY
	db 20, HAUNTER
	db 25, HAUNTER
	; day
	db 20, GASTLY
	db 21, GASTLY
	db 23, GASTLY
	db 25, GASTLY
	db 18, GASTLY
	db 20, HAUNTER
	db 25, HAUNTER
	; nite
	db 20, GASTLY
	db 21, GASTLY
	db 23, GASTLY
	db 25, GASTLY
	db 18, GASTLY
	db 20, HAUNTER
	db 25, HAUNTER
	end_grass_wildmons

; 4F is Yellow's 3F table repeated verbatim.
	def_grass_wildmons POKEMON_TOWER_4F
	db 4 percent, 4 percent, 4 percent ; encounter rates: morn/day/nite
	; morn
	db 20, GASTLY
	db 21, GASTLY
	db 23, GASTLY
	db 25, GASTLY
	db 18, GASTLY
	db 20, HAUNTER
	db 25, HAUNTER
	; day
	db 20, GASTLY
	db 21, GASTLY
	db 23, GASTLY
	db 25, GASTLY
	db 18, GASTLY
	db 20, HAUNTER
	db 25, HAUNTER
	; nite
	db 20, GASTLY
	db 21, GASTLY
	db 23, GASTLY
	db 25, GASTLY
	db 18, GASTLY
	db 20, HAUNTER
	db 25, HAUNTER
	end_grass_wildmons

; 5F: Yellow's rate rises to 15/256 and slot 7 becomes a CUBONE.  Dropped:
; slots 3 (24 GASTLY), 4 (25 GASTLY) and 5 (26 GASTLY); Yellow's slot 8
; (27 GASTLY) is promoted to keep the L27 ceiling.
	def_grass_wildmons POKEMON_TOWER_5F
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 22, GASTLY
	db 23, GASTLY
	db 27, GASTLY
	db 21, GASTLY
	db 20, CUBONE
	db 22, HAUNTER
	db 27, HAUNTER
	; day
	db 22, GASTLY
	db 23, GASTLY
	db 27, GASTLY
	db 21, GASTLY
	db 20, CUBONE
	db 22, HAUNTER
	db 27, HAUNTER
	; nite
	db 22, GASTLY
	db 23, GASTLY
	db 27, GASTLY
	db 21, GASTLY
	db 20, CUBONE
	db 22, HAUNTER
	db 27, HAUNTER
	end_grass_wildmons

; 6F: identical to 5F except Yellow's CUBONE is L22, not L20.
	def_grass_wildmons POKEMON_TOWER_6F
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 22, GASTLY
	db 23, GASTLY
	db 27, GASTLY
	db 21, GASTLY
	db 22, CUBONE
	db 22, HAUNTER
	db 27, HAUNTER
	; day
	db 22, GASTLY
	db 23, GASTLY
	db 27, GASTLY
	db 21, GASTLY
	db 22, CUBONE
	db 22, HAUNTER
	db 27, HAUNTER
	; nite
	db 22, GASTLY
	db 23, GASTLY
	db 27, GASTLY
	db 21, GASTLY
	db 22, CUBONE
	db 22, HAUNTER
	db 27, HAUNTER
	end_grass_wildmons

; 7F: Yellow's rate is 20/256 and every level is four higher than 5F's.
; Dropped: slots 3 (26 GASTLY), 4 (27 GASTLY) and 5 (28 GASTLY).
	def_grass_wildmons POKEMON_TOWER_7F
	db 8 percent, 8 percent, 8 percent ; encounter rates: morn/day/nite
	; morn
	db 24, GASTLY
	db 25, GASTLY
	db 29, GASTLY
	db 23, GASTLY
	db 24, CUBONE
	db 24, HAUNTER
	db 29, HAUNTER
	; day
	db 24, GASTLY
	db 25, GASTLY
	db 29, GASTLY
	db 23, GASTLY
	db 24, CUBONE
	db 24, HAUNTER
	db 29, HAUNTER
	; nite
	db 24, GASTLY
	db 25, GASTLY
	db 29, GASTLY
	db 23, GASTLY
	db 24, CUBONE
	db 24, HAUNTER
	db 29, HAUNTER
	end_grass_wildmons

; M9 12k: the POKeMON MANSION (vendor/pokeyellow/data/wild/maps/
; PokemonMansion*.asm).  Yellow's rate is 10/256 on every floor.  The maps are
; DUNGEON environment, so every floor tile rolls.  Ten Yellow slots fold into
; Crystal's seven (30/30/20/10/5/4/1) keeping Yellow's order; the dropped slots
; were picked to keep each species' share closest to Yellow's.
; 1F: dropped slots 5 (37 RATTATA), 6 (37 RATICATE) and 8 (26 GRIMER).
	def_grass_wildmons POKEMON_MANSION_1F
	db 4 percent, 4 percent, 4 percent ; encounter rates: morn/day/nite
	; morn
	db 34, RATTATA
	db 34, RATICATE
	db 23, GRIMER
	db 26, GROWLITHE
	db 30, GROWLITHE
	db 34, GROWLITHE
	db 38, GROWLITHE
	; day
	db 34, RATTATA
	db 34, RATICATE
	db 23, GRIMER
	db 26, GROWLITHE
	db 30, GROWLITHE
	db 34, GROWLITHE
	db 38, GROWLITHE
	; nite
	db 34, RATTATA
	db 34, RATICATE
	db 23, GRIMER
	db 26, GROWLITHE
	db 30, GROWLITHE
	db 34, GROWLITHE
	db 38, GROWLITHE
	end_grass_wildmons

; 2F: dropped slots 5 (40 RATTATA), 6 (40 RATICATE) and 8 (35 GRIMER).
	def_grass_wildmons POKEMON_MANSION_2F
	db 4 percent, 4 percent, 4 percent ; encounter rates: morn/day/nite
	; morn
	db 37, RATTATA
	db 37, RATICATE
	db 26, GRIMER
	db 29, GRIMER
	db 32, GRIMER
	db 35, MUK
	db 38, MUK
	; day
	db 37, RATTATA
	db 37, RATICATE
	db 26, GRIMER
	db 29, GRIMER
	db 32, GRIMER
	db 35, MUK
	db 38, MUK
	; nite
	db 37, RATTATA
	db 37, RATICATE
	db 26, GRIMER
	db 29, GRIMER
	db 32, GRIMER
	db 35, MUK
	db 38, MUK
	end_grass_wildmons

; 3F: dropped slots 5 (43 RATTATA), 6 (43 RATICATE) and 8 (38 GRIMER).
	def_grass_wildmons POKEMON_MANSION_3F
	db 4 percent, 4 percent, 4 percent ; encounter rates: morn/day/nite
	; morn
	db 40, RATTATA
	db 40, RATICATE
	db 32, GRIMER
	db 35, GRIMER
	db 38, GRIMER
	db 38, MUK
	db 41, MUK
	; day
	db 40, RATTATA
	db 40, RATICATE
	db 32, GRIMER
	db 35, GRIMER
	db 38, GRIMER
	db 38, MUK
	db 41, MUK
	; nite
	db 40, RATTATA
	db 40, RATICATE
	db 32, GRIMER
	db 35, GRIMER
	db 38, GRIMER
	db 38, MUK
	db 41, MUK
	end_grass_wildmons

; B1F: dropped slots 2 (38 GRIMER), 6 (43 RATICATE) and 8 (46 RATICATE).  No
; fold keeps all four species near Yellow's shares (GRIMER/RATICATE ~40% each,
; MUK and DITTO ~10%); this one gives 30/50/10/10 and loses the L43/L46
; RATICATE and the L38 GRIMER.
	def_grass_wildmons POKEMON_MANSION_B1F
	db 4 percent, 4 percent, 4 percent ; encounter rates: morn/day/nite
	; morn
	db 35, GRIMER
	db 37, RATICATE
	db 40, RATICATE
	db 41, MUK
	db 24, DITTO
	db 18, DITTO
	db 12, DITTO
	; day
	db 35, GRIMER
	db 37, RATICATE
	db 40, RATICATE
	db 41, MUK
	db 24, DITTO
	db 18, DITTO
	db 12, DITTO
	; nite
	db 35, GRIMER
	db 37, RATICATE
	db 40, RATICATE
	db 41, MUK
	db 24, DITTO
	db 18, DITTO
	db 12, DITTO
	end_grass_wildmons

; M9 12o: SEAFOAM ISLANDS (vendor/pokeyellow/data/wild/maps/SeafoamIslands*.asm).
; Yellow's rates: 1F 15 -> 6 percent, B1F-B4F 10 -> 4 percent (both exact).
; CAVE environment, so every floor tile rolls.  Ten Yellow slots fold into
; Crystal's seven (30/30/20/10/5/4/1) keeping Yellow's order, never losing a
; species; the dropped slots keep each species' share closest to Yellow's
; (docs/M9-CINNABAR.md "12o findings" has the per-table deltas).
; SEAFOAM_ISLANDS_1F: dropped slots 3 (27 KRABBY), 5 (36 ZUBAT) and 8 (9 ZUBAT).
	def_grass_wildmons SEAFOAM_ISLANDS_1F
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 18, ZUBAT
	db 25, KRABBY
	db 27, ZUBAT
	db 28, SLOWPOKE
	db 30, SLOWPOKE
	db 27, GOLBAT
	db 36, GOLBAT
	; day
	db 18, ZUBAT
	db 25, KRABBY
	db 27, ZUBAT
	db 28, SLOWPOKE
	db 30, SLOWPOKE
	db 27, GOLBAT
	db 36, GOLBAT
	; nite
	db 18, ZUBAT
	db 25, KRABBY
	db 27, ZUBAT
	db 28, SLOWPOKE
	db 30, SLOWPOKE
	db 27, GOLBAT
	db 36, GOLBAT
	end_grass_wildmons

; SEAFOAM_ISLANDS_B1F: dropped slots 4 (28 KRABBY), 7 (18 ZUBAT) and 10 (26 SEEL).
	def_grass_wildmons SEAFOAM_ISLANDS_B1F
	db 4 percent, 4 percent, 4 percent ; encounter rates: morn/day/nite
	; morn
	db 27, ZUBAT
	db 26, KRABBY
	db 36, ZUBAT
	db 27, GOLBAT
	db 29, SLOWPOKE
	db 28, KINGLER
	db 22, SEEL
	; day
	db 27, ZUBAT
	db 26, KRABBY
	db 36, ZUBAT
	db 27, GOLBAT
	db 29, SLOWPOKE
	db 28, KINGLER
	db 22, SEEL
	; nite
	db 27, ZUBAT
	db 26, KRABBY
	db 36, ZUBAT
	db 27, GOLBAT
	db 29, SLOWPOKE
	db 28, KINGLER
	db 22, SEEL
	end_grass_wildmons

; SEAFOAM_ISLANDS_B2F: dropped slots 3 (36 ZUBAT), 7 (29 KRABBY) and 8 (36 GOLBAT).
	def_grass_wildmons SEAFOAM_ISLANDS_B2F
	db 4 percent, 4 percent, 4 percent ; encounter rates: morn/day/nite
	; morn
	db 27, ZUBAT
	db 27, KRABBY
	db 27, GOLBAT
	db 28, KINGLER
	db 24, SEEL
	db 31, SLOWPOKE
	db 31, SLOWBRO
	; day
	db 27, ZUBAT
	db 27, KRABBY
	db 27, GOLBAT
	db 28, KINGLER
	db 24, SEEL
	db 31, SLOWPOKE
	db 31, SLOWBRO
	; nite
	db 27, ZUBAT
	db 27, KRABBY
	db 27, GOLBAT
	db 28, KINGLER
	db 24, SEEL
	db 31, SLOWPOKE
	db 31, SLOWBRO
	end_grass_wildmons

; SEAFOAM_ISLANDS_B3F: dropped slots 4 (27 ZUBAT), 7 (31 KRABBY) and 10 (32 DEWGONG).
	def_grass_wildmons SEAFOAM_ISLANDS_B3F
	db 4 percent, 4 percent, 4 percent ; encounter rates: morn/day/nite
	; morn
	db 27, GOLBAT
	db 36, ZUBAT
	db 29, KRABBY
	db 30, KINGLER
	db 26, SEEL
	db 30, SEEL
	db 28, DEWGONG
	; day
	db 27, GOLBAT
	db 36, ZUBAT
	db 29, KRABBY
	db 30, KINGLER
	db 26, SEEL
	db 30, SEEL
	db 28, DEWGONG
	; nite
	db 27, GOLBAT
	db 36, ZUBAT
	db 29, KRABBY
	db 30, KINGLER
	db 26, SEEL
	db 30, SEEL
	db 28, DEWGONG
	end_grass_wildmons

; SEAFOAM_ISLANDS_B4F: dropped slots 7 (27 GOLBAT), 8 (45 ZUBAT) and 10 (34 DEWGONG).
	def_grass_wildmons SEAFOAM_ISLANDS_B4F
	db 4 percent, 4 percent, 4 percent ; encounter rates: morn/day/nite
	; morn
	db 36, GOLBAT
	db 36, ZUBAT
	db 30, KRABBY
	db 32, KINGLER
	db 28, SEEL
	db 32, SEEL
	db 30, DEWGONG
	; day
	db 36, GOLBAT
	db 36, ZUBAT
	db 30, KRABBY
	db 32, KINGLER
	db 28, SEEL
	db 32, SEEL
	db 30, DEWGONG
	; nite
	db 36, GOLBAT
	db 36, ZUBAT
	db 30, KRABBY
	db 32, KINGLER
	db 28, SEEL
	db 32, SEEL
	db 30, DEWGONG
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

; Kanto hack (M5 8k): Yellow's Route 7 table
; (vendor/pokeyellow/data/wild/maps/Route7.asm). Yellow rate 15/256 ==
; `6 percent`; no time of day, so morn = day = nite. Ten slots fold to seven
; by dropping the three duplicated middles: slot 1 (L22 PIDGEY), slot 4 (L19
; ABRA) and slot 9 (the third L24 JIGGLYPUFF). All five species survive and so
; do both level extremes (L15 ABRA min, L26 ABRA max). Gone: Crystal's
; SPEAROW, SNUBBULL, RATICATE and its separate MEOWTH/MURKROW/HOUNDOUR/PERSIAN
; nite block; Crystal's 10% rate drops to Yellow's 6%.
	def_grass_wildmons ROUTE_7
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 20, PIDGEY
	db 20, RATTATA
	db 15, ABRA
	db 24, PIDGEOTTO
	db 26, ABRA
	db 19, JIGGLYPUFF
	db 24, JIGGLYPUFF
	; day
	db 20, PIDGEY
	db 20, RATTATA
	db 15, ABRA
	db 24, PIDGEOTTO
	db 26, ABRA
	db 19, JIGGLYPUFF
	db 24, JIGGLYPUFF
	; nite
	db 20, PIDGEY
	db 20, RATTATA
	db 15, ABRA
	db 24, PIDGEOTTO
	db 26, ABRA
	db 19, JIGGLYPUFF
	db 24, JIGGLYPUFF
	end_grass_wildmons

; Kanto hack (M5 8j): Yellow's Route 8 table
; (vendor/pokeyellow/data/wild/maps/Route8.asm). Yellow rate 15/256 ==
; `6 percent`; no time of day, so morn = day = nite. Ten slots fold to seven
; by dropping the three duplicated middles: slot 1 (L22 PIDGEY), slot 4 (L19
; ABRA) and slot 7 (L24 JIGGLYPUFF). All six species survive and so do both
; level extremes (L15 ABRA min, L27 KADABRA max). Weights land PIDGEY 30 /
; RATTATA 30 / ABRA 20 / PIDGEOTTO 10 / JIGGLYPUFF 5 / KADABRA 5 against
; Yellow's 39.8 / 15.2 / 19.6 / 9.8 / 10.2 / 5.5: RATTATA doubles because it
; is Yellow's slot 2 and lands in Crystal's 30% bracket -- the same
; order-vs-weight cost recorded for ROUTE_11. Gone: Crystal's SNUBBULL,
; GROWLITHE, MEOWTH, NOCTOWL, HAUNTER and its nite block.
	def_grass_wildmons ROUTE_8
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 20, PIDGEY
	db 20, RATTATA
	db 15, ABRA
	db 24, PIDGEOTTO
	db 19, JIGGLYPUFF
	db 20, KADABRA
	db 27, KADABRA
	; day
	db 20, PIDGEY
	db 20, RATTATA
	db 15, ABRA
	db 24, PIDGEOTTO
	db 19, JIGGLYPUFF
	db 20, KADABRA
	db 27, KADABRA
	; nite
	db 20, PIDGEY
	db 20, RATTATA
	db 15, ABRA
	db 24, PIDGEOTTO
	db 19, JIGGLYPUFF
	db 20, KADABRA
	db 27, KADABRA
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

; Kanto hack (M5 8l): Yellow's Route 12 grass table
; (vendor/pokeyellow/data/wild/maps/Route12.asm). Yellow rate 15/256 ==
; `6 percent`; no time of day, so morn = day = nite. Yellow lists exactly
; seven species, so the 10 -> 7 fold keeps every one: dropping slots 4 (L27
; ODDISH), 5 (L27 BELLSPROUT) and 8 (L26 FARFETCH_D) gives ODDISH 30 /
; BELLSPROUT 30 / PIDGEY 20 / PIDGEOTTO 10 / GLOOM 5 / WEEPINBELL 4 /
; FARFETCH_D 1 against Yellow's 29.7 / 29.7 / 15.2 / 9.8 / 5.1 / 5.1 / 5.5,
; and both level extremes survive (L25 min, L31 FARFETCH_D max -- which is why
; slot 8 goes and slot 9 stays). Yellow, unlike Red/Blue, gives BOTH ODDISH
; and BELLSPROUT here; both are kept.
	def_grass_wildmons ROUTE_12
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 25, ODDISH
	db 25, BELLSPROUT
	db 28, PIDGEY
	db 28, PIDGEOTTO
	db 29, GLOOM
	db 29, WEEPINBELL
	db 31, FARFETCH_D
	; day
	db 25, ODDISH
	db 25, BELLSPROUT
	db 28, PIDGEY
	db 28, PIDGEOTTO
	db 29, GLOOM
	db 29, WEEPINBELL
	db 31, FARFETCH_D
	; nite
	db 25, ODDISH
	db 25, BELLSPROUT
	db 28, PIDGEY
	db 28, PIDGEOTTO
	db 29, GLOOM
	db 29, WEEPINBELL
	db 31, FARFETCH_D
	end_grass_wildmons

; Kanto hack (M7 10n): Yellow's ROUTE 13 table
; (vendor/pokeyellow/data/wild/maps/Route13.asm).  Yellow rate 15/256 ==
; `6 percent` exactly, and Gen 1 has no time of day, so morn = day = nite.
; Yellow lists exactly seven species in its ten slots, so the 10 -> 7 fold
; keeps every one by dropping the three duplicated rows -- slot 5 (L27 ODDISH),
; slot 6 (L27 BELLSPROUT) and slot 9 (L26 FARFETCH_D) -- which gives
; ODDISH 30 / BELLSPROUT 30 / PIDGEOTTO 20 / PIDGEY 10 / GLOOM 5 /
; WEEPINBELL 4 / FARFETCH_D 1 against Yellow's aggregate 29.7 / 29.7 / 15.2 /
; 9.8 / 5.1 / 5.1 / 5.5, and both level extremes survive (L25 min, L31
; FARFETCH_D max -- which is why slot 9 goes and slot 10 stays).  This is the
; same shape as ROUTE_12 above, which shares the table almost row for row.
; Gone: Crystal's HOPPIP x3 / CHANSEY day table and its separate
; NOCTOWL / QUAGSIRE / VENOMOTH nite table (QUAGSIRE and NOCTOWL are Gen 2).
	def_grass_wildmons ROUTE_13
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 25, ODDISH
	db 25, BELLSPROUT
	db 28, PIDGEOTTO
	db 28, PIDGEY
	db 29, GLOOM
	db 29, WEEPINBELL
	db 31, FARFETCH_D
	; day
	db 25, ODDISH
	db 25, BELLSPROUT
	db 28, PIDGEOTTO
	db 28, PIDGEY
	db 29, GLOOM
	db 29, WEEPINBELL
	db 31, FARFETCH_D
	; nite
	db 25, ODDISH
	db 25, BELLSPROUT
	db 28, PIDGEOTTO
	db 28, PIDGEY
	db 29, GLOOM
	db 29, WEEPINBELL
	db 31, FARFETCH_D
	end_grass_wildmons

; Kanto hack (M7 10n): Yellow's ROUTE 14 table
; (vendor/pokeyellow/data/wild/maps/Route14.asm).  Yellow rate 15/256 ==
; `6 percent` exactly; morn = day = nite.  Seven species in ten slots again,
; so nothing is lost: dropping slot 5 (L28 ODDISH), slot 6 (L28 BELLSPROUT)
; and slot 9 (L27 VENONAT) leaves ODDISH 30 / BELLSPROUT 30 / VENONAT 20 /
; PIDGEOTTO 10 / GLOOM 5 / WEEPINBELL 4 / VENOMOTH 1 against Yellow's
; aggregate 29.7 / 29.7 / 19.5 / 9.8 / 5.1 / 5.1 / 1.2 -- the closest fit any
; of the Kanto tables gets.  Slot 3's L24 VENONAT is the map's level floor and
; slot 9's L27 is not, so slot 9 is the one that goes.  Gone: Crystal's
; HOPPIP / SKIPLOOM day table and its NOCTOWL / QUAGSIRE nite table.
	def_grass_wildmons ROUTE_14
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 26, ODDISH
	db 26, BELLSPROUT
	db 24, VENONAT
	db 30, PIDGEOTTO
	db 30, GLOOM
	db 30, WEEPINBELL
	db 30, VENOMOTH
	; day
	db 26, ODDISH
	db 26, BELLSPROUT
	db 24, VENONAT
	db 30, PIDGEOTTO
	db 30, GLOOM
	db 30, WEEPINBELL
	db 30, VENOMOTH
	; nite
	db 26, ODDISH
	db 26, BELLSPROUT
	db 24, VENONAT
	db 30, PIDGEOTTO
	db 30, GLOOM
	db 30, WEEPINBELL
	db 30, VENOMOTH
	end_grass_wildmons

; Kanto hack (M7 10n): Yellow's ROUTE 15 table
; (vendor/pokeyellow/data/wild/maps/Route15.asm).  Identical to ROUTE 14 row
; for row except that slot 4's PIDGEOTTO is L32 rather than L30, so the same
; fold applies: drop slots 5, 6 and 9 (the duplicated L28 ODDISH, L28
; BELLSPROUT and L27 VENONAT) for ODDISH 30 / BELLSPROUT 30 / VENONAT 20 /
; PIDGEOTTO 10 / GLOOM 5 / WEEPINBELL 4 / VENOMOTH 1.  L24 min and L32 max
; both survive.  Gone: Crystal's HOPPIP / SKIPLOOM / NOCTOWL / QUAGSIRE rows.
	def_grass_wildmons ROUTE_15
	db 6 percent, 6 percent, 6 percent ; encounter rates: morn/day/nite
	; morn
	db 26, ODDISH
	db 26, BELLSPROUT
	db 24, VENONAT
	db 32, PIDGEOTTO
	db 30, GLOOM
	db 30, WEEPINBELL
	db 30, VENOMOTH
	; day
	db 26, ODDISH
	db 26, BELLSPROUT
	db 24, VENONAT
	db 32, PIDGEOTTO
	db 30, GLOOM
	db 30, WEEPINBELL
	db 30, VENOMOTH
	; nite
	db 26, ODDISH
	db 26, BELLSPROUT
	db 24, VENONAT
	db 32, PIDGEOTTO
	db 30, GLOOM
	db 30, WEEPINBELL
	db 30, VENOMOTH
	end_grass_wildmons

; Kanto hack (M6 9y): Yellow's ROUTE 16 table
; (vendor/pokeyellow/data/wild/maps/Route16.asm).  Yellow rate 25/256 ==
; `10 percent` exactly, and Gen 1 has no time of day, so morn = day = nite.
; Yellow's ten slots fold to Crystal's seven by dropping the three duplicated
; middle rows -- slot 4 (L24 DODUO, 10%), slot 5 (L24 RATTATA, 10%) and slot 7
; (L23 SPEAROW, 5%) -- which keeps Yellow's order, all five species and both
; level extremes (L22 min, L26 max).  Species weights land at SPEAROW 30% /
; DODUO 40% / RATTATA 20% / FEAROW 5% / RATICATE 5%, against Yellow's
; 25% / 39.5% / 25% / 5.1% / 5.5% (M6 9ab corrects the "35% / ... / 10%" this
; comment used to claim: Yellow's slot weights are 19.9 / 19.9 / 15.2 / 9.8 /
; 9.8 / 9.8 / 5.1 / 5.1 / 4.3 / 1.2, so DODUO is slots 2+4+6 and RATICATE only
; slots 9+10).  Yellow gives ROUTE 16 no water table.
	def_grass_wildmons ROUTE_16
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	db 22, SPEAROW
	db 22, DODUO
	db 23, RATTATA
	db 26, DODUO
	db 24, FEAROW
	db 25, RATICATE
	db 26, RATICATE
	; day
	db 22, SPEAROW
	db 22, DODUO
	db 23, RATTATA
	db 26, DODUO
	db 24, FEAROW
	db 25, RATICATE
	db 26, RATICATE
	; nite
	db 22, SPEAROW
	db 22, DODUO
	db 23, RATTATA
	db 26, DODUO
	db 24, FEAROW
	db 25, RATICATE
	db 26, RATICATE
	end_grass_wildmons

; Kanto hack (M6 9z): Yellow's ROUTE 17 table
; (vendor/pokeyellow/data/wild/maps/Route17.asm).  Yellow rate 25/256 ==
; `10 percent` exactly, and Gen 1 has no time of day, so morn = day = nite.
; Crystal's GRIMER/MUK/SLUGMA road is gone: the grass is only the small patch
; at the top of CYCLING ROAD (blocks 6-8, 4-9 -> tiles x 12-17, y 8-19).
; Yellow's ten slots fold to Crystal's seven by dropping the three slots whose
; species+level pair already appears -- slot 4 (L28 DODUO), slot 6 (L30
; PONYTA) and slot 8 (L28 DODUO) -- which keeps Yellow's order, all four
; species and both level extremes (L26 min, L32 max).  Species weights land at
; DODUO 50% / FEAROW 35% / PONYTA 14% / DODRIO 1%, against Yellow's
; 50% / 25% / 24% / 2%.  Yellow gives ROUTE 17 no water table.
	def_grass_wildmons ROUTE_17
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	db 26, DODUO
	db 27, FEAROW
	db 27, DODUO
	db 28, PONYTA
	db 29, FEAROW
	db 32, PONYTA
	db 29, DODRIO
	; day
	db 26, DODUO
	db 27, FEAROW
	db 27, DODUO
	db 28, PONYTA
	db 29, FEAROW
	db 32, PONYTA
	db 29, DODRIO
	; nite
	db 26, DODUO
	db 27, FEAROW
	db 27, DODUO
	db 28, PONYTA
	db 29, FEAROW
	db 32, PONYTA
	db 29, DODRIO
	end_grass_wildmons

; Kanto hack (M6 9aa): Yellow's ROUTE 18 table
; (vendor/pokeyellow/data/wild/maps/Route18.asm), which is BYTE-IDENTICAL to
; its ROUTE 16 one -- same rate (25/256 == `10 percent`), same ten slots.  So
; this is the ROUTE 16 fold above repeated verbatim: drop slot 4 (L24 DODUO),
; slot 5 (L24 RATTATA) and slot 7 (L23 SPEAROW), keeping Yellow's order, all
; five species and both level extremes (L22 min, L26 max).  Gen 1 has no time
; of day, so morn = day = nite.  Crystal's GRIMER/MUK/SLUGMA road is gone.
; Yellow gives ROUTE 18 no water table (`def_water_wildmons 0`).
	def_grass_wildmons ROUTE_18
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	db 22, SPEAROW
	db 22, DODUO
	db 23, RATTATA
	db 26, DODUO
	db 24, FEAROW
	db 25, RATICATE
	db 26, RATICATE
	; day
	db 22, SPEAROW
	db 22, DODUO
	db 23, RATTATA
	db 26, DODUO
	db 24, FEAROW
	db 25, RATICATE
	db 26, RATICATE
	; nite
	db 22, SPEAROW
	db 22, DODUO
	db 23, RATTATA
	db 26, DODUO
	db 24, FEAROW
	db 25, RATICATE
	db 26, RATICATE
	end_grass_wildmons

; M9 12o: Yellow's ROUTE 21 grass (vendor/pokeyellow/data/wild/maps/Route21.asm),
; replacing Crystal's TANGELA / MR__MIME table.  Yellow's rate 25 -> 10 percent
; (= 25).  Flat across morn/day/nite (Yellow has no time of day).  Ten slots
; fold into seven keeping Yellow's order; drops chosen to keep each species'
; share closest to Yellow's.
; ROUTE_21: dropped slots 4 (11 PIDGEY), 5 (17 PIDGEY) and 6 (15 RATTATA).
	def_grass_wildmons ROUTE_21
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	db 15, PIDGEY
	db 13, RATTATA
	db 13, PIDGEY
	db 15, RATICATE
	db 17, PIDGEOTTO
	db 19, PIDGEOTTO
	db 15, PIDGEOTTO
	; day
	db 15, PIDGEY
	db 13, RATTATA
	db 13, PIDGEY
	db 15, RATICATE
	db 17, PIDGEOTTO
	db 19, PIDGEOTTO
	db 15, PIDGEOTTO
	; nite
	db 15, PIDGEY
	db 13, RATTATA
	db 13, PIDGEY
	db 15, RATICATE
	db 17, PIDGEOTTO
	db 19, PIDGEOTTO
	db 15, PIDGEOTTO
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

; Kanto hack (M7 10n): the four SAFARI ZONE areas
; (vendor/pokeyellow/data/wild/maps/SafariZone{Center,East,North,West}.asm).
; These are not routes, so they sit after ROUTE_28 rather than in the numbered
; run above.  Yellow's rate is 30/256 for all four == `12 percent` exactly
; (12 * $ff / 100 = 30), by far the busiest grass in Kanto, and Gen 1 has no
; time of day, so morn = day = nite.
;
; Each area lists NINE distinct species across its ten slots, and Crystal has
; only seven, so each table loses two species as well as its one duplicated
; row.  The drops are chosen ZONE-WIDE, not per area: after the fold every
; species Yellow puts in the Safari Zone still has a wild nest in it except
; NIDORINO, NIDORINA and PARASECT.  NIDORINO and NIDORINA both keep their
; ROUTE_9 nest (already shipped, data/wild/kanto_grass.asm above) and both
; evolve from the NIDORAN that stays in all four areas; PARASECT evolves from
; the L27 PARAS kept in the CENTER area (PARAS evolves at L24) and is also a
; CERULEAN_CAVE_1F encounter in Yellow.  KANGASKHAN -- the one species unique
; to a single area -- is kept, and so are CHANSEY, SCYTHER, PINSIR, TANGELA,
; MAROWAK, TAUROS, CUBONE, RHYHORN and EXEGGCUTE.
;
; Yellow's ten slots are weighted 19.9 / 19.9 / 15.2 / 9.8 / 9.8 / 9.8 / 5.1 /
; 5.1 / 4.3 / 1.2 and Crystal's seven 30 / 30 / 20 / 10 / 5 / 4 / 1; the kept
; rows stay in Yellow's slot order, so the weights land by position.
; Nothing here has a surf table: Yellow gives all four areas
; `def_water_wildmons 0` with no entries, so data/wild/kanto_water.asm has no
; SAFARI_ZONE_* block at all (a 0-rate block would still show the areas as
; Pokedex AREA habitats -- FindNest's .FindWater ignores the rate byte).

; CENTER: drop slot 6 (L27 PARASECT), slot 8 (L32 PARASECT) and slot 5
; (L23 NIDORINO).  PARASECT is the zone-wide sacrifice; NIDORINO keeps its
; WEST-area L32 slot in Yellow but that slot is itself dropped below, so
; ROUTE_9 and NIDORAN_M carry it.  Result: NIDORAN_M 30 / NIDORAN_F 30 /
; EXEGGCUTE 20 / RHYHORN 10 / PARAS 5 / TANGELA 4 / CHANSEY 1 against
; Yellow's 19.9 / 19.9 / 15.2 / 9.8 / 5.1 / 4.3 / 1.2 (PARASECT's 14.9 is
; what the three dropped rows were worth).  Both extremes survive: the L7
; CHANSEY that makes this the lowest-level grass in Kanto, and the L36
; NIDORAN_F.
	def_grass_wildmons SAFARI_ZONE_CENTER
	db 12 percent, 12 percent, 12 percent ; encounter rates: morn/day/nite
	; morn
	db 14, NIDORAN_M
	db 36, NIDORAN_F
	db 24, EXEGGCUTE
	db 20, RHYHORN
	db 27, PARAS
	db 22, TANGELA
	db 7, CHANSEY
	; day
	db 14, NIDORAN_M
	db 36, NIDORAN_F
	db 24, EXEGGCUTE
	db 20, RHYHORN
	db 27, PARAS
	db 22, TANGELA
	db 7, CHANSEY
	; nite
	db 14, NIDORAN_M
	db 36, NIDORAN_F
	db 24, EXEGGCUTE
	db 20, RHYHORN
	db 27, PARAS
	db 22, TANGELA
	db 7, CHANSEY
	end_grass_wildmons

; EAST: drop slot 7 (L26 EXEGGCUTE, the duplicate), slot 5 (L32 NIDORINA) and
; slot 6 (L19 CUBONE).  CUBONE keeps its NORTH and WEST nests; NIDORINA keeps
; ROUTE_9's.  Result: NIDORAN_M 30 / NIDORAN_F 30 / EXEGGCUTE 20 / TAUROS 10 /
; MAROWAK 5 / CHANSEY 4 / SCYTHER 1 against Yellow's 19.9 / 19.9 / 20.3 /
; 9.8 / 5.1 / 4.3 / 1.2 -- EXEGGCUTE's two rows fold into one 20% slot
; exactly.  The L15 SCYTHER floor survives; the area's ceiling drops from
; NIDORINA's L32 to NIDORAN_F's L29.
	def_grass_wildmons SAFARI_ZONE_EAST
	db 12 percent, 12 percent, 12 percent ; encounter rates: morn/day/nite
	; morn
	db 21, NIDORAN_M
	db 29, NIDORAN_F
	db 22, EXEGGCUTE
	db 21, TAUROS
	db 24, MAROWAK
	db 21, CHANSEY
	db 15, SCYTHER
	; day
	db 21, NIDORAN_M
	db 29, NIDORAN_F
	db 22, EXEGGCUTE
	db 21, TAUROS
	db 24, MAROWAK
	db 21, CHANSEY
	db 15, SCYTHER
	; nite
	db 21, NIDORAN_M
	db 29, NIDORAN_F
	db 22, EXEGGCUTE
	db 21, TAUROS
	db 24, MAROWAK
	db 21, CHANSEY
	db 15, SCYTHER
	end_grass_wildmons

; NORTH: drop slot 8 (L33 KANGASKHAN, the duplicate), slot 4 (L25 RHYHORN) and
; slot 5 (L23 NIDORINA).  RHYHORN keeps its CENTER nest, NIDORINA ROUTE_9's.
; Dropping slot 4 rather than a later row is deliberate: it promotes
; KANGASKHAN -- found nowhere else in the game -- into the 10% slot, the
; closest Crystal can get to Yellow's 14.9% for it.  Result: NIDORAN_M 30 /
; NIDORAN_F 30 / EXEGGCUTE 20 / KANGASKHAN 10 / CUBONE 5 / SCYTHER 4 /
; PINSIR 1 against Yellow's 19.9 / 19.9 / 15.2 / 14.9 / 5.1 / 4.3 / 1.2.
; L14 min and L36 max both survive.
	def_grass_wildmons SAFARI_ZONE_NORTH
	db 12 percent, 12 percent, 12 percent ; encounter rates: morn/day/nite
	; morn
	db 36, NIDORAN_M
	db 14, NIDORAN_F
	db 20, EXEGGCUTE
	db 28, KANGASKHAN
	db 16, CUBONE
	db 25, SCYTHER
	db 15, PINSIR
	; day
	db 36, NIDORAN_M
	db 14, NIDORAN_F
	db 20, EXEGGCUTE
	db 28, KANGASKHAN
	db 16, CUBONE
	db 25, SCYTHER
	db 15, PINSIR
	; nite
	db 36, NIDORAN_M
	db 14, NIDORAN_F
	db 20, EXEGGCUTE
	db 28, KANGASKHAN
	db 16, CUBONE
	db 25, SCYTHER
	db 15, PINSIR
	end_grass_wildmons

; WEST: drop slot 7 (L26 EXEGGCUTE, the duplicate), slot 5 (L32 NIDORINO) and
; slot 8 (L24 MAROWAK).  MAROWAK keeps its EAST nest; NIDORINO ROUTE_9's.
; Result: NIDORAN_M 30 / NIDORAN_F 30 / EXEGGCUTE 20 / TAUROS 10 / CUBONE 5 /
; PINSIR 4 / TANGELA 1 against Yellow's 19.9 / 19.9 / 20.3 / 9.8 / 9.8 /
; 4.3 / 1.2.  The L19 CUBONE floor survives; the ceiling drops from
; NIDORINO's L32 to NIDORAN_M's L29.
	def_grass_wildmons SAFARI_ZONE_WEST
	db 12 percent, 12 percent, 12 percent ; encounter rates: morn/day/nite
	; morn
	db 29, NIDORAN_M
	db 21, NIDORAN_F
	db 22, EXEGGCUTE
	db 21, TAUROS
	db 19, CUBONE
	db 25, PINSIR
	db 27, TANGELA
	; day
	db 29, NIDORAN_M
	db 21, NIDORAN_F
	db 22, EXEGGCUTE
	db 21, TAUROS
	db 19, CUBONE
	db 25, PINSIR
	db 27, TANGELA
	; nite
	db 29, NIDORAN_M
	db 21, NIDORAN_F
	db 22, EXEGGCUTE
	db 21, TAUROS
	db 19, CUBONE
	db 25, PINSIR
	db 27, TANGELA
	end_grass_wildmons

; Kanto hack (M10 13e-1): Yellow's Route 23 table, vendor/pokeyellow/data/wild/
; maps/Route23.asm.  Yellow's rate byte is 10 = `4 percent`; its ten slots fold
; to seven by dropping slots 4, 5 and 9 (1-based; L44 NIDORINO, L44 NIDORINA, L41
; PRIMEAPE) -- the duplicated middle entries, as in ROUTE_22's fold -- keeping Yellow's order
; and every species; morn = day = nite.  Yellow's water rate is 0: no surf table.
	def_grass_wildmons ROUTE_23
	db 4 percent, 4 percent, 4 percent ; encounter rates: morn/day/nite
	; morn
	db 41, NIDORINO
	db 41, NIDORINA
	db 36, MANKEY
	db 40, FEAROW
	db 41, MANKEY
	db 45, FEAROW
	db 46, PRIMEAPE
	; day
	db 41, NIDORINO
	db 41, NIDORINA
	db 36, MANKEY
	db 40, FEAROW
	db 41, MANKEY
	db 45, FEAROW
	db 46, PRIMEAPE
	; nite
	db 41, NIDORINO
	db 41, NIDORINA
	db 36, MANKEY
	db 40, FEAROW
	db 41, MANKEY
	db 45, FEAROW
	db 46, PRIMEAPE
	end_grass_wildmons

	db -1 ; end
