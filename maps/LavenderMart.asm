; Kanto hack (M5 8h): Yellow's LAVENDER_MART
; (vendor/pokeyellow/data/maps/objects/LavenderMart.asm,
; scripts/LavenderMart.asm, text/LavenderMart.asm).  Yellow's BALDING_GUY (3,4)
; and COOLTRAINER_M (7,2) are on Yellow's own tiles -- Crystal's shared
; maps/Mart.blk happens to leave both free.  Yellow's CLERK stands at (0,5),
; which is a shelf block here: Crystal's counter is the vertical wall at x=2,
; so the clerk keeps Crystal's only serving tile (1,3) and Yellow's RIGHT
; facing.  The return warps stay on Crystal's door tiles (2,7)/(3,7) rather
; than Yellow's (3,7)/(4,7) for the same reason: the door block sits one block
; further left here, and all twelve marts share maps/Mart.blk, so matching
; Yellow would need a re-cut of every mart (docs/M5-LAVENDER.md, 8g findings).
;
; BALDING_GUY is SPRITE_POKEFAN_M per the substitution table (2.17).  Crystal's
; ROCKER (and his JOHTO/AZALEA custom-BALL text) is gone -- he is not on
; Yellow's list.  The stock is Yellow's nine items (data/items/marts.asm).
	object_const_def
	const LAVENDERMART_CLERK
	const LAVENDERMART_POKEFAN_M
	const LAVENDERMART_COOLTRAINER_M

LavenderMart_MapScripts:
	def_scene_scripts

	def_callbacks

LavenderMartClerkScript:
	opentext
	pokemart MARTTYPE_STANDARD, MART_LAVENDER
	closetext
	end

LavenderMartPokefanMScript:
	jumptextfaceplayer LavenderMartPokefanMText

; Yellow: LavenderMartCooltrainerMText branches on EVENT_RESCUED_MR_FUJI.
LavenderMartCooltrainerMScript:
	faceplayer
	opentext
	checkevent EVENT_RESCUED_MR_FUJI
	iftrue .Nugget
	writetext LavenderMartCooltrainerMReviveText
	waitbutton
	closetext
	end

.Nugget:
	writetext LavenderMartCooltrainerMNuggetText
	waitbutton
	closetext
	end

LavenderMartPokefanMText:
	text "I'm searching for"
	line "items that raise"
	cont "the abilities of"
	cont "#MON during a"
	cont "single battle."

	para "X ATTACK, X"
	line "DEFEND, X SPEED"
	cont "and X SPECIAL are"
	cont "what I'm after."

	para "Do you know where"
	line "I can get them?"
	done

LavenderMartCooltrainerMReviveText:
	text "You know REVIVE?"
	line "It revives any"
	cont "fainted #MON!"
	done

LavenderMartCooltrainerMNuggetText:
	text "I found a NUGGET"
	line "in the mountains."

	para "I thought it was"
	line "useless, but it"
	cont "sold for ¥5000!"
	done

LavenderMart_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, LAVENDER_TOWN, 4
	warp_event  3,  7, LAVENDER_TOWN, 4

	def_coord_events

	def_bg_events

	def_object_events
	object_event  1,  3, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, LavenderMartClerkScript, -1
	object_event  3,  4, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, LavenderMartPokefanMScript, -1
	object_event  7,  2, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, LavenderMartCooltrainerMScript, -1
