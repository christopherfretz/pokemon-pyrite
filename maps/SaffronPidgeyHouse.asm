; Kanto hack (M8 11a, docs/M8-SAFFRON.md D74): Yellow has no MAGNET TRAIN, and
; the house Crystal bulldozed for the station is the PIDGEY house -- the one
; whose TEACHER in the old station script says "before the MAGNET TRAIN STATION
; was built, there was a house there".  The map const, the map file and the
; SAFFRON CITY warp are repurposed in place; the Magnet Train itself is parked
; for the Johto act (the engine, the PASS and GOLDENROD's station are all still
; compiled).  Placeholder skeleton -- the BRUNETTE GIRL, the PIDGEY, the
; YOUNGSTER and the paper arrive in 11c.
SaffronPidgeyHouse_MapScripts:
	def_scene_scripts

	def_callbacks

SaffronPidgeyHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, SAFFRON_CITY, 6
	warp_event  3,  7, SAFFRON_CITY, 6

	def_coord_events

	def_bg_events

	def_object_events
