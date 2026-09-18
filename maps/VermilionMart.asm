; Kanto hack: Yellow's VERMILION_MART
; (vendor/pokeyellow/data/maps/objects/VermilionMart.asm,
; scripts/VermilionMart.asm, text/VermilionMart.asm).  Stock is Yellow's six
; items (data/items/marts.asm VermilionMartClerkText) in hack/data/items/marts.asm.
;
; Yellow's CLERK stands at (0,5) behind Gen 1's counter; Crystal's mart booth is
; the (1,3) niche every other Kanto mart already uses (4c, 6c, 7c).  Yellow's
; COOLTRAINER_M keeps his own tile (5,6).  Yellow's COOLTRAINER_F paces
; left/right from (3,3); Crystal's counter divider is a tile wider, which makes
; (3,3) the mouth of the only west-side gap in the shelf row, so she paces from
; (4,3) instead -- the same row, still crossing Yellow's tile.
	object_const_def
	const VERMILIONMART_CLERK
	const VERMILIONMART_COOLTRAINER_M
	const VERMILIONMART_COOLTRAINER_F

VermilionMart_MapScripts:
	def_scene_scripts

	def_callbacks

VermilionMartClerkScript:
	opentext
	pokemart MARTTYPE_STANDARD, MART_VERMILION
	closetext
	end

VermilionMartCooltrainerMScript:
	jumptextfaceplayer VermilionMartCooltrainerMText

VermilionMartCooltrainerFScript:
	jumptextfaceplayer VermilionMartCooltrainerFText

VermilionMartCooltrainerMText:
	text "There are evil"
	line "people who will"
	cont "use #MON for"
	cont "criminal acts."

	para "TEAM ROCKET"
	line "traffics in rare"
	cont "#MON."

	para "They also abandon"
	line "#MON that they"
	cont "consider not to"
	cont "be popular or"
	cont "useful."
	done

VermilionMartCooltrainerFText:
	text "I think #MON"
	line "can be good or"
	cont "evil. It depends"
	cont "on the trainer."
	done

VermilionMart_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, VERMILION_CITY, 3
	warp_event  3,  7, VERMILION_CITY, 3

	def_coord_events

	def_bg_events

	def_object_events
	object_event  1,  3, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VermilionMartClerkScript, -1
	object_event  5,  6, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, VermilionMartCooltrainerMScript, -1
	object_event  4,  3, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, VermilionMartCooltrainerFScript, -1
