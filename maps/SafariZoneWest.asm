; Kanto hack: Yellow's SAFARI ZONE AREA 3, the WEST AREA (docs/M7-FUCHSIA.md,
; 10l) -- the one with the GOLD TEETH and the SECRET HOUSE.  Warps, signs, balls
; and the hidden REVIVE are Yellow's own (vendor/pokeyellow/data/maps/objects/
; SafariZoneWest.asm, data/events/hidden_item_coords.asm), in Yellow's order, on
; Yellow's tiles.  The six border tiles carry COLL_WARP_77 through the clone
; metatiles $c6-$c9 (scripts/safari_blk.py); see maps/SafariZoneCenter.asm for
; why a Gen 1 warp_event on plain ground cannot fire in GSC.
;
; Warp 7 is the SECRET HOUSE and warp 8 the WEST REST HOUSE, both 10m's
; interiors; their door tiles (3,3) and (11,11) are metatile $3c and already
; carry COLL_DOOR.  Yellow's SECRET HOUSE warps BOTH of its exit tiles back to
; warp 7, so you always come out onto (3,3) -- and because COLL_DOOR is in
; CheckWarpFacingDown, GSC then walks the player one tile south to (3,4),
; exactly where Yellow's own door-step leaves them.
;
; GOLD_TEETH at (19,7) is the WARDEN's, and SafariZoneWardensHome (10g) already
; checks and takes it.  TM_DOUBLE_TEAM at (9,7) is our TM32 -- Crystal's own
; TM32, the one number Yellow and Crystal agree on (docs/TM-LEDGER.md).
;
; The hidden REVIVE is Yellow's `hidden_item SAFARI_ZONE_WEST, 6, 5` (that macro
; writes x then y, so x=6 y=5).  (6,5) is the east wall of the SECRET HOUSE's
; fenced yard and the player reads it facing RIGHT from (5,5); Gen 1 hidden items
; are found with the same "press A at the tile in front of you" gesture that
; BGEVENT_ITEM implements, so the coordinate is Yellow's unchanged.
;
; Wild grass and water tables are 10n's, not here.
	object_const_def
	const SAFARIZONEWEST_POKE_BALL1
	const SAFARIZONEWEST_POKE_BALL2
	const SAFARIZONEWEST_POKE_BALL3
	const SAFARIZONEWEST_POKE_BALL4

SafariZoneWest_MapScripts:
	def_scene_scripts

	def_callbacks

SafariZoneWestRestHouseSign:
	jumptext SafariZoneWestRestHouseSignText

SafariZoneWestRequestNoticeSign:
	jumptext SafariZoneWestRequestNoticeSignText

SafariZoneWestTrainerTipsSign:
	jumptext SafariZoneWestTrainerTipsSignText

SafariZoneWestAreaSign:
	jumptext SafariZoneWestAreaSignText

SafariZoneWestMaxPotion:
	itemball MAX_POTION

SafariZoneWestTMDoubleTeam:
	itemball TM_DOUBLE_TEAM

SafariZoneWestMaxRevive:
	itemball MAX_REVIVE

SafariZoneWestGoldTeeth:
	itemball GOLD_TEETH

SafariZoneWestHiddenRevive:
	hiddenitem REVIVE, EVENT_SAFARI_ZONE_WEST_HIDDEN_REVIVE

; Yellow's _SafariZoneWestRestHouseSignText.
SafariZoneWestRestHouseSignText:
	text "REST HOUSE"
	done

; Yellow's _SafariZoneWestFindWardensTeethSignText.
SafariZoneWestRequestNoticeSignText:
	text "REQUEST NOTICE"

	para "Please find the"
	line "SAFARI WARDEN's"
	cont "lost GOLD TEETH."
	cont "They're around"
	cont "here somewhere."

	para "Reward offered!"
	line "Contact: WARDEN"
	done

; Yellow's _SafariZoneWestTrainerTipsText.
SafariZoneWestTrainerTipsSignText:
	text "TRAINER TIPS"

	para "Zone Exploration"
	line "Campaign!"

	para "The Search for"
	line "the SECRET HOUSE!"
	done

; Yellow's _SafariZoneWestSignText.
SafariZoneWestAreaSignText:
	text "AREA 3"
	line "EAST: CENTER AREA"
	done

SafariZoneWest_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 20,  0, SAFARI_ZONE_NORTH, 1
	warp_event 21,  0, SAFARI_ZONE_NORTH, 2
	warp_event 26,  0, SAFARI_ZONE_NORTH, 3
	warp_event 27,  0, SAFARI_ZONE_NORTH, 4
	warp_event 29, 22, SAFARI_ZONE_CENTER, 3
	warp_event 29, 23, SAFARI_ZONE_CENTER, 4
	warp_event  3,  3, SAFARI_ZONE_SECRET_HOUSE, 1
	warp_event 11, 11, SAFARI_ZONE_WEST_REST_HOUSE, 1

	def_coord_events

	def_bg_events
	bg_event 12, 12, BGEVENT_READ, SafariZoneWestRestHouseSign
	bg_event 17,  3, BGEVENT_READ, SafariZoneWestRequestNoticeSign
	bg_event 26,  4, BGEVENT_READ, SafariZoneWestTrainerTipsSign
	bg_event 24, 22, BGEVENT_READ, SafariZoneWestAreaSign
	bg_event  6,  5, BGEVENT_ITEM, SafariZoneWestHiddenRevive

	def_object_events
	object_event  8, 20, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SafariZoneWestMaxPotion, EVENT_SAFARI_ZONE_WEST_MAX_POTION
	object_event  9,  7, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SafariZoneWestTMDoubleTeam, EVENT_SAFARI_ZONE_WEST_TM_DOUBLE_TEAM
	object_event 18, 18, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SafariZoneWestMaxRevive, EVENT_SAFARI_ZONE_WEST_MAX_REVIVE
	object_event 19,  7, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SafariZoneWestGoldTeeth, EVENT_SAFARI_ZONE_WEST_GOLD_TEETH
