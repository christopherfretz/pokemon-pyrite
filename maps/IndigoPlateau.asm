; Kanto hack (M10 13e-2): Yellow's INDIGO PLATEAU forecourt (10x9 blocks on
; TILESET_KANTO_PLATEAU, maps/IndigoPlateau.blk verbatim via
; scripts/kanto_plateau_blk.py).  Yellow's map has two warps (the lobby door),
; no signs and no people; it connects south to ROUTE 23
; (data/maps/attributes.asm).  Deleted from Crystal's forecourt: the VICTORY
; ROAD mouth warps (9,13)/(10,13), the "INDIGO PLATEAU / The Ultimate Goal for
; Trainers!" sign at (11,7) (Yellow has no bg_event here), and 13e-1's interim
; ROUTE 23 arrival warps (9,12)/(10,12).
IndigoPlateau_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_NEWMAP, IndigoPlateauFlypointCallback

IndigoPlateauFlypointCallback:
	setflag ENGINE_FLYPOINT_INDIGO_PLATEAU
	endcallback

IndigoPlateau_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  9,  5, INDIGO_PLATEAU_POKECENTER_1F, 1
	warp_event 10,  5, INDIGO_PLATEAU_POKECENTER_1F, 2

	def_coord_events

	def_bg_events

	def_object_events
