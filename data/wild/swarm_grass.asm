; Pokémon swarms in grass

SwarmGrassWildMons:

; Dunsparce swarm
	map_id DARK_CAVE_VIOLET_ENTRANCE
	db 4 percent, 4 percent, 4 percent ; encounter rates: morn/day/nite
	; morn
	db 53, GEODUDE
	db 53, DUNSPARCE
	db 52, ZUBAT
	db 52, GEODUDE
	db 52, DUNSPARCE
	db 54, DUNSPARCE
	db 54, DUNSPARCE
	; day
	db 53, GEODUDE
	db 53, DUNSPARCE
	db 52, ZUBAT
	db 52, GEODUDE
	db 52, DUNSPARCE
	db 54, DUNSPARCE
	db 54, DUNSPARCE
	; nite
	db 53, GEODUDE
	db 53, DUNSPARCE
	db 52, ZUBAT
	db 52, GEODUDE
	db 52, DUNSPARCE
	db 54, DUNSPARCE
	db 54, DUNSPARCE

; Yanma swarm
	map_id ROUTE_35
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	db 62, NIDORAN_M
	db 62, NIDORAN_F
	db 62, YANMA
	db 64, YANMA
	db 64, PIDGEY
	db 60, DITTO
	db 60, DITTO
	; day
	db 62, NIDORAN_M
	db 62, NIDORAN_F
	db 62, YANMA
	db 64, YANMA
	db 64, PIDGEY
	db 60, DITTO
	db 60, DITTO
	; nite
	db 62, NIDORAN_M
	db 62, NIDORAN_F
	db 62, YANMA
	db 64, YANMA
	db 64, HOOTHOOT
	db 60, DITTO
	db 60, DITTO

	db -1 ; end
