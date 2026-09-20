; Kanto hack (docs/M6-CELADON.md, 9s): Yellow's CELADON MANSION ROOF.  Yellow
; has zero objects up here and exactly one sign, immediately right of the roof
; house's door (Yellow (3,7), ours (3,5) -- our roof is 4x5 blocks against
; Yellow's 4x6).  Crystal's FISHER and its graffiti bg_event are gone.
;
; The roof is deliberately split in two by the COLL_RIGHT_WALL/COLL_LEFT_WALL
; column pair at x4/x5: only the west half (reached from 3F warp 1, i.e. the
; back-door staircase chain) can get to the roof house, exactly as in Yellow.
CeladonMansionRoof_MapScripts:
	def_scene_scripts

	def_callbacks

CeladonMansionRoofHouseSign:
	jumptext CeladonMansionRoofHouseSignText

CeladonMansionRoofHouseSignText:
	text "I KNOW EVERYTHING!"
	done

CeladonMansionRoof_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  1,  1, CELADON_MANSION_3F, 1
	warp_event  6,  1, CELADON_MANSION_3F, 4
	warp_event  2,  5, CELADON_MANSION_ROOF_HOUSE, 1

	def_coord_events

	def_bg_events
	bg_event  3,  5, BGEVENT_UP, CeladonMansionRoofHouseSign

	def_object_events
