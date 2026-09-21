; Kanto hack: Yellow's WEST REST HOUSE (docs/M7-FUCHSIA.md 10m).  Shares
; maps/SafariZoneRestHouse.blk with the other three rest houses (D67); the three
; NPCs and their lines are Yellow's verbatim
; (vendor/pokeyellow/{data/maps/objects,text}/SafariZoneWestRestHouse.asm).
; The ROCK and BAIT hints describe the SAFARI ZONE battle menu 10i built, so
; they are live advice here, not flavour.
	object_const_def
	const SAFARIZONEWESTRESTHOUSE_SCIENTIST
	const SAFARIZONEWESTRESTHOUSE_COOLTRAINER_M
	const SAFARIZONEWESTRESTHOUSE_SILPH_WORKER_F

SafariZoneWestRestHouse_MapScripts:
	def_scene_scripts

	def_callbacks

SafariZoneWestRestHouseScientistScript:
	jumptextfaceplayer SafariZoneWestRestHouseScientistText

SafariZoneWestRestHouseCooltrainerMScript:
	jumptextfaceplayer SafariZoneWestRestHouseCooltrainerMText

SafariZoneWestRestHouseSilphWorkerFScript:
	jumptextfaceplayer SafariZoneWestRestHouseSilphWorkerFText

SafariZoneWestRestHouseScientistText:
	text "Tossing ROCKs at"
	line "#MON might"
	cont "make them run,"
	cont "but they'll be"
	cont "easier to catch."
	done

SafariZoneWestRestHouseCooltrainerMText:
	text "Using BAIT will"
	line "make #MON"
	cont "easier to catch."
	done

SafariZoneWestRestHouseSilphWorkerFText:
	text "I hiked a lot, but"
	line "I didn't see any"
	cont "#MON I wanted."
	done

SafariZoneWestRestHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, SAFARI_ZONE_WEST, 8
	warp_event  3,  7, SAFARI_ZONE_WEST, 8

	def_coord_events

	def_bg_events

	def_object_events
	object_event  4,  4, SPRITE_SCIENTIST, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SafariZoneWestRestHouseScientistScript, -1
	object_event  0,  2, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SafariZoneWestRestHouseCooltrainerMScript, -1
	object_event  6,  2, SPRITE_SILPH_WORKER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SafariZoneWestRestHouseSilphWorkerFScript, -1
