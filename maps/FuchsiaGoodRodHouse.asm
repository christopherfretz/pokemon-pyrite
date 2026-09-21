; Kanto hack (docs/M7-FUCHSIA.md): the FISHING GURU and the GOOD ROD are 10g's,
; and so is the re-cut onto Yellow's SHIP-tileset layout.  10f adds only the
; warps FUCHSIA CITY needs, because the city's warp 9 (the back door at 31,24)
; has nowhere to land otherwise, and the city's north-east yard has no other way
; in -- in Yellow either.
;
; Yellow's back door is at (2,0).  The shared maps/House1.blk walls that tile in
; (WALL boxed by TV/TOWN_MAP), so 10f moves this map's blocks onto
; maps/House1Hole.blk -- House1 with block $25 (LADDER, FLOOR, FLOOR, FLOOR) in
; the back wall -- exactly as M3 6a did for CERULEAN's two pass-through houses.
; That puts a real LADDER warp tile at (2,0) at zero ROM cost.  10g may re-cut
; onto Yellow's SHIP art; keep warp 1 at 2,0 when it does.

FuchsiaGoodRodHouse_MapScripts:
	def_scene_scripts

	def_callbacks

FuchsiaGoodRodHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  0, FUCHSIA_CITY, 9 ; Yellow's back door, on House1Hole's $25 LADDER
	warp_event  2,  7, FUCHSIA_CITY, 8
	warp_event  3,  7, FUCHSIA_CITY, 8

	def_coord_events

	def_bg_events

	def_object_events
