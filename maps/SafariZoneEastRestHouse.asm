; Kanto hack: Yellow's EAST REST HOUSE (docs/M7-FUCHSIA.md 10m).  Shares
; maps/SafariZoneRestHouse.blk with the other three rest houses (D67); the three
; NPCs and their lines are Yellow's verbatim
; (vendor/pokeyellow/{data/maps/objects,text}/SafariZoneEastRestHouse.asm).
	object_const_def
	const SAFARIZONEEASTRESTHOUSE_SCIENTIST
	const SAFARIZONEEASTRESTHOUSE_ROCKER
	const SAFARIZONEEASTRESTHOUSE_SILPH_WORKER_M

SafariZoneEastRestHouse_MapScripts:
	def_scene_scripts

	def_callbacks

SafariZoneEastRestHouseScientistScript:
	jumptextfaceplayer SafariZoneEastRestHouseScientistText

SafariZoneEastRestHouseRockerScript:
	jumptextfaceplayer SafariZoneEastRestHouseRockerText

SafariZoneEastRestHouseSilphWorkerMScript:
	jumptextfaceplayer SafariZoneEastRestHouseSilphWorkerMText

SafariZoneEastRestHouseScientistText:
	text "How many did you"
	line "catch? I'm bushed"
	cont "from the work!"
	done

SafariZoneEastRestHouseRockerText:
	text "I caught a"
	line "CHANSEY!"

	para "That makes this"
	line "all worthwhile!"
	done

SafariZoneEastRestHouseSilphWorkerMText:
	text "Whew! I'm tired"
	line "from all the fun!"
	done

SafariZoneEastRestHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, SAFARI_ZONE_EAST, 5
	warp_event  3,  7, SAFARI_ZONE_EAST, 5

	def_coord_events

	def_bg_events

	def_object_events
	object_event  1,  3, SPRITE_SCIENTIST, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SafariZoneEastRestHouseScientistScript, -1
	object_event  4,  2, SPRITE_ROCKER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SafariZoneEastRestHouseRockerScript, -1
	object_event  5,  2, SPRITE_SILPH_WORKER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SafariZoneEastRestHouseSilphWorkerMScript, -1
