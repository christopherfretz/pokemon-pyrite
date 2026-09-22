; Kanto hack (M9 12h): Yellow's CINNABAR MART.  Both shoppers speak Yellow's
; lines verbatim (vendor/pokeyellow/text/CinnabarMart.asm), the cast is
; Yellow's (data/maps/objects/CinnabarMart.asm) and the stock is Yellow's
; CinnabarMartClerkText list (data/items/marts.asm, MartCinnabar) -- seven
; items, the longest Kanto counter outside the INDIGO PLATEAU lobby.
; As in every other Kanto mart the clerk keeps Crystal's counter tile (1,3)
; rather than Yellow's (0,5), which is a shelf in Crystal's MART art and is
; talked to across the counter block at (2,3) -- the FUCHSIA precedent
; (docs/M7-FUCHSIA.md 10g), re-used by SAFFRON (M8 11d).  The SILPH WORKER F
; keeps Yellow's (6,2), which is walkable floor here; the SCIENTIST cannot keep
; Yellow's (3,4), because that tile is the ONE gap in the shelf wall that cuts
; Crystal's MART art in half, and a body standing on it seals the counter off
; so the shop cannot be used at all.  He goes two tiles up his own aisle to
; (3,2) -- the same minimal nudge FUCHSIA and SAFFRON gave their (6,5) shopper.
; 12a already pointed this map at Yellow's own mart .blk (Yellow's
; CinnabarMart.blk is byte-identical to its FuchsiaMart.blk, md5 94e260f2),
; so the door tiles are the ones M7 10g cut from Yellow.
	object_const_def
	const CINNABARMART_CLERK
	const CINNABARMART_SILPH_WORKER_F
	const CINNABARMART_SCIENTIST

CinnabarMart_MapScripts:
	def_scene_scripts

	def_callbacks

CinnabarMartClerkScript:
	opentext
	pokemart MARTTYPE_STANDARD, MART_CINNABAR
	closetext
	end

CinnabarMartSilphWorkerFScript:
	jumptextfaceplayer CinnabarMartSilphWorkerFText

CinnabarMartScientistScript:
	jumptextfaceplayer CinnabarMartScientistText

CinnabarMartSilphWorkerFText:
	text "Don't they have X"
	line "ATTACK? It's good"
	cont "for battles!"
	done

CinnabarMartScientistText:
	text "It never hurts to"
	line "have extra items!"
	done

CinnabarMart_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; CINNABAR ISLAND's MART door is its FIFTH warp (12g).  Yellow's own door
; tiles are (3,7)/(4,7); Crystal warps on a tile ATTRIBUTE rather than on a
; coordinate match, and the door block of the shared Yellow mart .blk sits one
; column west, so the Kanto marts all put their two door tiles on (2,7)/(3,7)
; -- FUCHSIA and SAFFRON ship exactly these rows.
	warp_event  2,  7, CINNABAR_ISLAND, 5
	warp_event  3,  7, CINNABAR_ISLAND, 5

	def_coord_events

	def_bg_events

	def_object_events
	object_event  1,  3, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CinnabarMartClerkScript, -1
	object_event  6,  2, SPRITE_SILPH_WORKER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CinnabarMartSilphWorkerFScript, -1
	object_event  3,  2, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CinnabarMartScientistScript, -1
