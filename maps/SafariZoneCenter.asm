; Kanto hack: Yellow's SAFARI ZONE CENTER AREA (docs/M7-FUCHSIA.md, 10l).
; Crystal has no counterpart at all -- the whole zone is four new maps (10a
; registered them, 10b converted Yellow's geometry) -- so every warp, sign and
; ball below is Yellow's own (vendor/pokeyellow/data/maps/objects/
; SafariZoneCenter.asm), in Yellow's order, on Yellow's tiles.
;
; THE AREAS ARE JOINED BY WARPS, NOT CONNECTIONS (docs/M7-FUCHSIA.md 0.6): the
; four maps are separate 15x13/20x18 rectangles that Yellow stitches with
; warp_events at the borders, and the pairings are not geometrically
; consistent, so map connections could not reproduce them.  Yellow lets a
; warp_event fire from any tile; GSC only checks for a warp when the tile you
; finish a step onto has collision $60/$68 or a high nybble of $7 (see
; CheckWarpCollision, engine/overworld/tile_events.asm).  So the eight border
; tiles below carry COLL_WARP_77, via the four clone metatiles $c6-$c9 that
; scripts/safari_blk.py appends and places (see its "M7 10l" section for why
; $77 and not one of the WARP_CARPET_* values).  The REST HOUSE door at
; (17,19) needs no such treatment: it sits on metatile $3c, whose bottom-right
; quadrant is already COLL_DOOR.
;
; Warps 1 and 2 are the way back down into the SAFARI ZONE GATE (10k warps in
; with `warpfacing UP, SAFARI_ZONE_CENTER, 15, 25`, i.e. onto warp 2's tile --
; arriving on a warp tile never re-fires it, because warps are only checked
; after a completed step).  Warp 9 is the CENTER REST HOUSE, whose interior is
; 10m's.
;
; NUGGET at (14,10) is Yellow's, on the land bridge across the central lake.
; Wild grass and water tables are 10n's, not here.
	object_const_def
	const SAFARIZONECENTER_POKE_BALL

SafariZoneCenter_MapScripts:
	def_scene_scripts

	def_callbacks

SafariZoneCenterRestHouseSign:
	jumptext SafariZoneCenterRestHouseSignText

SafariZoneCenterTrainerTipsSign:
	jumptext SafariZoneCenterTrainerTipsSignText

SafariZoneCenterNugget:
	itemball NUGGET

; Yellow's _SafariZoneCenterRestHouseSignText.
SafariZoneCenterRestHouseSignText:
	text "REST HOUSE"
	done

; Yellow's _SafariZoneCenterTrainerTipsSignText.  The START menu really does
; show the remaining steps -- StartMenu_PrintSafariGameStatus, M7 10j.
SafariZoneCenterTrainerTipsSignText:
	text "TRAINER TIPS"

	para "Press the START"
	line "Button to check"
	cont "remaining time!"
	done

SafariZoneCenter_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 14, 25, SAFARI_ZONE_GATE, 3
	warp_event 15, 25, SAFARI_ZONE_GATE, 4
	warp_event  0, 10, SAFARI_ZONE_WEST, 5
	warp_event  0, 11, SAFARI_ZONE_WEST, 6
	warp_event 14,  0, SAFARI_ZONE_NORTH, 5
	warp_event 15,  0, SAFARI_ZONE_NORTH, 6
	warp_event 29, 10, SAFARI_ZONE_EAST, 3
	warp_event 29, 11, SAFARI_ZONE_EAST, 4
	warp_event 17, 19, SAFARI_ZONE_CENTER_REST_HOUSE, 1

	def_coord_events

	def_bg_events
	bg_event 18, 20, BGEVENT_READ, SafariZoneCenterRestHouseSign
	bg_event 14, 22, BGEVENT_READ, SafariZoneCenterTrainerTipsSign

	def_object_events
	object_event 14, 10, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SafariZoneCenterNugget, EVENT_SAFARI_ZONE_CENTER_NUGGET
