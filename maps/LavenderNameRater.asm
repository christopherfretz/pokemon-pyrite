; Kanto hack (M5 8h): Yellow's NAME_RATERS_HOUSE
; (vendor/pokeyellow/data/maps/objects/NameRatersHouse.asm).  The NAME RATER
; takes Yellow's own tile (5,3) facing LEFT; his SILPH_PRESIDENT sprite is
; SPRITE_GENTLEMAN per the substitution table (docs/M5-LAVENDER.md 2.17).
;
; Crystal's `special NameRater` is Yellow's NameRatersHouseNameRaterText
; rewritten as an engine special -- same flow, same OT check, same texts -- so
; it is kept as-is (3.4).  The dead scene script and the unreferenced bookshelf
; are deleted.  Music: Yellow gives this one house MUSIC_CITIES2 and every
; other Lavender interior MUSIC_LAVENDER; since the project collapses CITIES1
; and CITIES2 onto MUSIC_VIRIDIAN_CITY, being "faithful" here would play
; Viridian's theme inside Lavender, so the row keeps MUSIC_LAVENDER_TOWN
; (decision D11, docs/M5-LAVENDER.md 3.11).
	object_const_def
	const LAVENDERNAMERATER_NAME_RATER

LavenderNameRater_MapScripts:
	def_scene_scripts

	def_callbacks

LavenderNameRater:
	faceplayer
	opentext
	special NameRater
	waitbutton
	closetext
	end

LavenderNameRater_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, LAVENDER_TOWN, 6
	warp_event  3,  7, LAVENDER_TOWN, 6

	def_coord_events

	def_bg_events

	def_object_events
	object_event  5,  3, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, LavenderNameRater, -1
