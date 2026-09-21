; Kanto hack: Yellow's NORTH REST HOUSE (docs/M7-FUCHSIA.md 10m).  Shares
; maps/SafariZoneRestHouse.blk with the other three rest houses (D67); the three
; NPCs and their lines are Yellow's verbatim
; (vendor/pokeyellow/{data/maps/objects,text}/SafariZoneNorthRestHouse.asm).
; The SAFARI ZONE WORKER's "you will win a prize" line is the in-game pointer to
; the SECRET HOUSE and its HM03 SURF, so it stays exactly as Yellow wrote it.
	object_const_def
	const SAFARIZONENORTHRESTHOUSE_SCIENTIST
	const SAFARIZONENORTHRESTHOUSE_SAFARI_ZONE_WORKER
	const SAFARIZONENORTHRESTHOUSE_GENTLEMAN

SafariZoneNorthRestHouse_MapScripts:
	def_scene_scripts

	def_callbacks

SafariZoneNorthRestHouseScientistScript:
	jumptextfaceplayer SafariZoneNorthRestHouseScientistText

SafariZoneNorthRestHouseSafariZoneWorkerScript:
	jumptextfaceplayer SafariZoneNorthRestHouseSafariZoneWorkerText

SafariZoneNorthRestHouseGentlemanScript:
	jumptextfaceplayer SafariZoneNorthRestHouseGentlemanText

SafariZoneNorthRestHouseScientistText:
	text "You can keep any"
	line "item you find on"
	cont "the ground here."

	para "But, you'll run"
	line "out of time if"
	cont "you try for all"
	cont "of them at once!"
	done

SafariZoneNorthRestHouseSafariZoneWorkerText:
	text "Go to the deepest"
	line "part of the"
	cont "SAFARI ZONE. You"
	cont "will win a prize!"
	done

SafariZoneNorthRestHouseGentlemanText:
	text "My EEVEE evolved"
	line "into FLAREON!"

	para "But, a friend's"
	line "EEVEE turned into"
	cont "a VAPOREON!"
	cont "I wonder why?"
	done

SafariZoneNorthRestHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, SAFARI_ZONE_NORTH, 9
	warp_event  3,  7, SAFARI_ZONE_NORTH, 9

	def_coord_events

	def_bg_events

	def_object_events
	object_event  6,  3, SPRITE_SCIENTIST, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SafariZoneNorthRestHouseScientistScript, -1
	object_event  3,  4, SPRITE_SAFARI_ZONE_WORKER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, SafariZoneNorthRestHouseSafariZoneWorkerScript, -1
	object_event  1,  5, SPRITE_GENTLEMAN, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SafariZoneNorthRestHouseGentlemanScript, -1
