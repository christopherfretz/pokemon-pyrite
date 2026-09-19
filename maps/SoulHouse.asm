; Kanto hack (M5 8h): SOUL_HOUSE is a Crystal-only building.  Yellow's LAVENDER
; TOWN has six doors and Crystal's has seven, so 8g deleted this one from the
; town (decision D6) and 8h emptied the room: MR FUJI belongs in MR_FUJIS_HOUSE
; (he is the VOLUNTEER #MON HOUSE's owner in Yellow, hidden until the #MON
; TOWER rescue), and the three mourners have no Yellow counterpart -- the
; SOUL HOUSE is Crystal's stand-in for the #MON TOWER itself, which 8i ports
; for real.
;
; The map is kept (map constants are positional and savestate-visible) but is
; unreachable: no town warp points here, the header was re-cut from 5x4 to 4x4
; to alias maps/House1.blk like every other Lavender house, and the return
; warps sit on that .blk's door tiles only so the indexes are in range.
	object_const_def

SoulHouse_MapScripts:
	def_scene_scripts

	def_callbacks

SoulHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, LAVENDER_TOWN, 5
	warp_event  3,  7, LAVENDER_TOWN, 5

	def_coord_events

	def_bg_events

	def_object_events
