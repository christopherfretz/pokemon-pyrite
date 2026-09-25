; Kanto hack (A251): Johto-act (ENGINE_POKEGEAR set) overrides for Kanto grass.
; _GrassWildmonLookup consults this list before KantoGrassWildMons once the
; Pokégear is in hand, so the Kanto act keeps Yellow's tables byte-for-byte and
; never shows a Gen 2 species.  Morn and day, and the encounter rates, are
; copied from the Yellow tables in kanto_grass.asm unchanged; only the nite
; column differs, putting back Crystal's own Kanto nite species
; (vendor/pokecrystal/data/wild/kanto_grass.asm ROUTE_7 / ROUTE_16).
; docs/A251-ALL-CATCHABLE.md in the context repo.

PostE4GrassWildMons:

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
	; nite: MURKROW and HOUNDOUR take PIDGEY's and RATTATA's 30% slots
	db 20, MURKROW
	db 20, HOUNDOUR
	db 15, ABRA
	db 24, PIDGEOTTO
	db 26, ABRA
	db 19, JIGGLYPUFF
	db 24, JIGGLYPUFF
	end_grass_wildmons

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
	; nite: SLUGMA takes the second DODUO's 10% slot
	db 22, SPEAROW
	db 22, DODUO
	db 23, RATTATA
	db 26, SLUGMA
	db 24, FEAROW
	db 25, RATICATE
	db 26, RATICATE
	end_grass_wildmons

	db -1 ; end
