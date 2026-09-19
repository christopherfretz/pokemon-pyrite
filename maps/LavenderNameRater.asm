; Kanto hack (M5 8h): Yellow's NAME_RATERS_HOUSE
; (vendor/pokeyellow/data/maps/objects/NameRatersHouse.asm).  The NAME RATER
; takes Yellow's own tile (5,3) facing LEFT; his SILPH_PRESIDENT sprite is
; SPRITE_GENTLEMAN per the substitution table (docs/M5-LAVENDER.md 2.17).
;
; Crystal's `special NameRater` is Yellow's NameRatersHouse flow rewritten as an
; engine special: same steps and the same OT check, but NOT the same words --
; Crystal rewrote all seven boxes ("Hello, hello! I'm / the NAME RATER." vs
; Yellow's "Hello, hello! / I am the official / NAME RATER!", and so on through
; data/text/common_2.asm:11-90 vs vendor/pokeyellow/text/NameRatersHouse.asm).
; The special is shared with maps/GoldenrodNameRater.asm, so re-voicing it to
; Yellow would change Johto's NAME RATER too; the wording is therefore recorded
; as a permanent deviation (docs/AUDIT-M5-LEFTOVERS.md Q3) and kept as-is (3.4).
; The dead scene script and the unreferenced bookshelf are deleted.  Music: Yellow gives this one house MUSIC_CITIES2 and every
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
