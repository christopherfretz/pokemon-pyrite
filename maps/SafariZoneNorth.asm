; Kanto hack: Yellow's SAFARI ZONE AREA 2, the NORTH AREA (docs/M7-FUCHSIA.md,
; 10l) -- the big 20x18 one.  Warps, signs and balls are Yellow's own
; (vendor/pokeyellow/data/maps/objects/SafariZoneNorth.asm), in Yellow's order,
; on Yellow's tiles.  The eight border tiles carry COLL_WARP_77 through the
; clone metatiles $c6-$c9 (scripts/safari_blk.py); see maps/SafariZoneCenter.asm
; for why a Gen 1 warp_event on plain ground cannot fire in GSC.
;
; Warp 9 is the NORTH REST HOUSE, whose interior is 10m's; its door tile (35,3)
; is metatile $3c and already carries COLL_DOOR.
;
; TM_SKULL_BASH at (19,7) is our TM77 (Yellow's TM40; docs/TM-LEDGER.md).
; Wild grass and water tables are 10n's, not here.
	object_const_def
	const SAFARIZONENORTH_POKE_BALL1
	const SAFARIZONENORTH_POKE_BALL2

SafariZoneNorth_MapScripts:
	def_scene_scripts

	def_callbacks

SafariZoneNorthRestHouseSign:
	jumptext SafariZoneNorthRestHouseSignText

SafariZoneNorthTrainerTips1Sign:
	jumptext SafariZoneNorthTrainerTips1SignText

SafariZoneNorthAreaSign:
	jumptext SafariZoneNorthAreaSignText

SafariZoneNorthTrainerTips2Sign:
	jumptext SafariZoneNorthTrainerTips2SignText

SafariZoneNorthTrainerTips3Sign:
	jumptext SafariZoneNorthTrainerTips3SignText

SafariZoneNorthProtein:
	itemball PROTEIN

SafariZoneNorthTMSkullBash:
	itemball TM_SKULL_BASH

; Yellow's _SafariZoneNorthRestHouseSignText.
SafariZoneNorthRestHouseSignText:
	text "REST HOUSE"
	done

; Yellow's _SafariZoneNorthTrainerTips1Text.
SafariZoneNorthTrainerTips1SignText:
	text "TRAINER TIPS"

	para "The SECRET HOUSE"
	line "is still ahead!"
	done

; Yellow's _SafariZoneNorthSignText.
SafariZoneNorthAreaSignText:
	text "AREA 2"
	done

; Yellow's _SafariZoneNorthTrainerTips2Text.
SafariZoneNorthTrainerTips2SignText:
	text "TRAINER TIPS"

	para "#MON hide in"
	line "tall grass!"

	para "Zigzag through"
	line "grassy areas to"
	cont "flush them out."
	done

; Yellow's _SafariZoneNorthTrainerTips3Text.  The free HM is HM03 SURF, which
; the SECRET HOUSE's fishing guru hands over -- 10m's map.
SafariZoneNorthTrainerTips3SignText:
	text "TRAINER TIPS"

	para "Win a free HM for"
	line "finding the"
	cont "SECRET HOUSE!"
	done

SafariZoneNorth_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2, 35, SAFARI_ZONE_WEST, 1
	warp_event  3, 35, SAFARI_ZONE_WEST, 2
	warp_event  8, 35, SAFARI_ZONE_WEST, 3
	warp_event  9, 35, SAFARI_ZONE_WEST, 4
	warp_event 20, 35, SAFARI_ZONE_CENTER, 5
	warp_event 21, 35, SAFARI_ZONE_CENTER, 6
	warp_event 39, 30, SAFARI_ZONE_EAST, 1
	warp_event 39, 31, SAFARI_ZONE_EAST, 2
	warp_event 35,  3, SAFARI_ZONE_NORTH_REST_HOUSE, 1

	def_coord_events

	def_bg_events
	bg_event 36,  4, BGEVENT_READ, SafariZoneNorthRestHouseSign
	bg_event  4, 25, BGEVENT_READ, SafariZoneNorthTrainerTips1Sign
	bg_event 13, 31, BGEVENT_READ, SafariZoneNorthAreaSign
	bg_event 19, 33, BGEVENT_READ, SafariZoneNorthTrainerTips2Sign
	bg_event 26, 28, BGEVENT_READ, SafariZoneNorthTrainerTips3Sign

	def_object_events
	object_event 25,  1, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SafariZoneNorthProtein, EVENT_SAFARI_ZONE_NORTH_PROTEIN
	object_event 19,  7, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SafariZoneNorthTMSkullBash, EVENT_SAFARI_ZONE_NORTH_TM_SKULL_BASH
