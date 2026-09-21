; Kanto hack: Yellow's SAFARI ZONE AREA 1, the EAST AREA (docs/M7-FUCHSIA.md,
; 10l).  Warps, signs and balls are Yellow's own (vendor/pokeyellow/data/maps/
; objects/SafariZoneEast.asm), in Yellow's order, on Yellow's tiles.  The four
; border tiles carry COLL_WARP_77 through the clone metatiles $c6-$c9
; (scripts/safari_blk.py); see maps/SafariZoneCenter.asm for why.
;
; ⚠ YELLOW'S WARP QUIRK, REPRODUCED (docs/M7-FUCHSIA.md D68): warps 3 AND 4 --
; the two tiles of the west border crossing, (0,22) and (0,23) -- BOTH name
; SAFARI_ZONE_CENTER warp 7.  Yellow's own data says so, and the effect is
; visible in game: leaving the EAST AREA along the lower tile still puts you on
; CENTER (29,10), the upper tile of the pair, so the player slides one tile
; north across the border.  CENTER's own warps 7 and 8 are the normal mutual
; pair back to (0,22) and (0,23).  It is a Yellow bug, it is harmless, and the
; guiding star says keep it.
;
; Warp 5 is the EAST REST HOUSE, whose interior is 10m's; its door tile (25,9)
; is metatile $3c and already carries COLL_DOOR.
;
; The four balls are Yellow's, including the one Yellow's object const calls
; MAX_RESTORE while the object itself gives MAX_POTION -- the item is what
; ships.  TM_EGG_BOMB is our TM76 (Yellow's TM37; docs/TM-LEDGER.md).
; Wild grass and water tables are 10n's, not here.
	object_const_def
	const SAFARIZONEEAST_POKE_BALL1
	const SAFARIZONEEAST_POKE_BALL2
	const SAFARIZONEEAST_POKE_BALL3
	const SAFARIZONEEAST_POKE_BALL4

SafariZoneEast_MapScripts:
	def_scene_scripts

	def_callbacks

SafariZoneEastRestHouseSign:
	jumptext SafariZoneEastRestHouseSignText

SafariZoneEastTrainerTipsSign:
	jumptext SafariZoneEastTrainerTipsSignText

SafariZoneEastAreaSign:
	jumptext SafariZoneEastAreaSignText

SafariZoneEastFullRestore:
	itemball FULL_RESTORE

SafariZoneEastMaxPotion:
	itemball MAX_POTION

SafariZoneEastCarbos:
	itemball CARBOS

SafariZoneEastTMEggBomb:
	itemball TM_EGG_BOMB

; Yellow's _SafariZoneEastRestHouseSignText.
SafariZoneEastRestHouseSignText:
	text "REST HOUSE"
	done

; Yellow's _SafariZoneEastTrainerTipsText.
SafariZoneEastTrainerTipsSignText:
	text "TRAINER TIPS"

	para "The remaining time"
	line "declines only"
	cont "while you walk!"
	done

; Yellow's _SafariZoneEastSignText.
SafariZoneEastAreaSignText:
	text "CENTER AREA"
	line "NORTH: AREA 2"
	done

SafariZoneEast_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  0,  4, SAFARI_ZONE_NORTH, 7
	warp_event  0,  5, SAFARI_ZONE_NORTH, 8
	warp_event  0, 22, SAFARI_ZONE_CENTER, 7
; Yellow's duplicate: warp 4 names CENTER warp 7 as well, not warp 8 (D68).
	warp_event  0, 23, SAFARI_ZONE_CENTER, 7
	warp_event 25,  9, SAFARI_ZONE_EAST_REST_HOUSE, 1

	def_coord_events

	def_bg_events
	bg_event 26, 10, BGEVENT_READ, SafariZoneEastRestHouseSign
	bg_event  6,  4, BGEVENT_READ, SafariZoneEastTrainerTipsSign
	bg_event  5, 23, BGEVENT_READ, SafariZoneEastAreaSign

	def_object_events
	object_event 21, 10, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SafariZoneEastFullRestore, EVENT_SAFARI_ZONE_EAST_FULL_RESTORE
	object_event  3,  7, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SafariZoneEastMaxPotion, EVENT_SAFARI_ZONE_EAST_MAX_POTION
	object_event 20, 13, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SafariZoneEastCarbos, EVENT_SAFARI_ZONE_EAST_CARBOS
	object_event 15, 12, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SafariZoneEastTMEggBomb, EVENT_SAFARI_ZONE_EAST_TM_EGG_BOMB
