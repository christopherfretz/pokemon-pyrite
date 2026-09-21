; Kanto hack (M8 11d): Yellow's SAFFRON MART.  Both shoppers speak Yellow's
; lines verbatim (vendor/pokeyellow/text/SaffronMart.asm), the cast is Yellow's
; (data/maps/objects/SaffronMart.asm) and the stock is Yellow's
; SaffronMartClerkText list (data/items/marts.asm, MartSaffron).  Crystal's
; LAVENDER RADIO TOWER shopper is gone with the rest of the Gen 2 furniture.
; As in every other Kanto mart the clerk keeps Crystal's counter tile (1,3)
; rather than Yellow's (0,5), and the COOLTRAINER_F drops one row, (6,5) ->
; (6,6), because Yellow's (6,5) is a shelf in Crystal's MART art -- the FUCHSIA
; precedent (docs/M7-FUCHSIA.md 10g).
	object_const_def
	const SAFFRONMART_CLERK
	const SAFFRONMART_SUPER_NERD
	const SAFFRONMART_COOLTRAINER_F

SaffronMart_MapScripts:
	def_scene_scripts

	def_callbacks

SaffronMartClerkScript:
	opentext
	pokemart MARTTYPE_STANDARD, MART_SAFFRON
	closetext
	end

SaffronMartSuperNerdScript:
	jumptextfaceplayer SaffronMartSuperNerdText

SaffronMartCooltrainerFScript:
	jumptextfaceplayer SaffronMartCooltrainerFText

SaffronMartSuperNerdText:
	text "MAX REPEL lasts"
	line "longer than SUPER"
	cont "REPEL for keeping"
	cont "weaker #MON"
	cont "away!"
	done

SaffronMartCooltrainerFText:
	text "REVIVE is costly,"
	line "but it revives"
	cont "fainted #MON!"
	done

SaffronMart_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, SAFFRON_CITY, 5
	warp_event  3,  7, SAFFRON_CITY, 5

	def_coord_events

	def_bg_events

	def_object_events
	object_event  1,  3, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SaffronMartClerkScript, -1
	object_event  4,  2, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, SaffronMartSuperNerdScript, -1
	object_event  6,  6, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, SaffronMartCooltrainerFScript, -1
