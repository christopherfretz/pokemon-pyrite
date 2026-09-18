; Kanto hack: Yellow's DAYCARE (docs/M4-VERMILION.md, 7d; decision (c)).
; Yellow's map has exactly one object, a SPRITE_GENTLEMAN at (2,3) facing
; RIGHT, and no bg_events.  He is backed by Crystal's own day-care-man engine
; (`special DayCareMan`, hack/engine/events/daycare.asm), whose deposit /
; level-growth / retrieval-for-money flow is Yellow's, including the identical
; price formula (100 x levels grown + 100).
; There is deliberately NO day-care lady: Yellow's DAY-CARE has one slot, and
; with only wDayCareMan filled Crystal can never produce an EGG, so breeding
; stays out of Kanto (a ruled Gen 2 anachronism).  Johto's Route 34 DAY_CARE
; shares wDayCareMan and the DAYCARETEXT_* bodies -- see 7d.7.
	object_const_def
	const ROUTE5DAYCARE_GENTLEMAN

Route5DayCare_MapScripts:
	def_scene_scripts

	def_callbacks

Route5DayCareManScript:
	faceplayer
	opentext
	special DayCareMan
	waitbutton
	closetext
	end

Route5DayCare_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, ROUTE_5, 5
	warp_event  3,  7, ROUTE_5, 5

	def_coord_events

	def_bg_events

	def_object_events
	object_event  2,  3, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route5DayCareManScript, -1
