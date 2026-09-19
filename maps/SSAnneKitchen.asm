; Kanto hack: Yellow's SS_ANNE_KITCHEN (docs/M4-VERMILION.md, 7h).  Yellow's
; seven cooks plus the three hidden_events 2.8/5.1 omit (see "## 7h findings",
; correction 2): two PrintTrashText tiles and a hidden GREAT BALL.
;   Yellow ( 1, 8) SPRITE_COOK, WALK UP_DOWN -> SPRITE_CLERK (5.4, as the waiters)
;   Yellow ( 5, 8) SPRITE_COOK, WALK UP_DOWN
;   Yellow ( 9, 7) SPRITE_COOK, WALK UP_DOWN
;   Yellow (13, 6) SPRITE_COOK, STAY NONE
;   Yellow (13, 8) SPRITE_COOK, STAY NONE
;   Yellow (13,10) SPRITE_COOK, STAY NONE
;   Yellow (11,13) SPRITE_COOK, STAY UP  -- le CHEF, three random main courses
;   Yellow hidden_event (13, 5) PrintTrashText
;   Yellow hidden_event (13, 7) PrintTrashText
;   Yellow hidden_event (13, 9) HiddenItems, GREAT_BALL
	object_const_def
	const SSANNEKITCHEN_COOK1
	const SSANNEKITCHEN_COOK2
	const SSANNEKITCHEN_COOK3
	const SSANNEKITCHEN_COOK4
	const SSANNEKITCHEN_COOK5
	const SSANNEKITCHEN_COOK6
	const SSANNEKITCHEN_COOK7

SSAnneKitchen_MapScripts:
	def_scene_scripts

	def_callbacks

SSAnneKitchenCook1Script:
	jumptextfaceplayer SSAnneKitchenCook1Text

SSAnneKitchenCook2Script:
	jumptextfaceplayer SSAnneKitchenCook2Text

SSAnneKitchenCook3Script:
	jumptextfaceplayer SSAnneKitchenCook3Text

SSAnneKitchenCook4Script:
	jumptextfaceplayer SSAnneKitchenCook4Text

SSAnneKitchenCook5Script:
	jumptextfaceplayer SSAnneKitchenCook5Text

SSAnneKitchenCook6Script:
	jumptextfaceplayer SSAnneKitchenCook6Text

; Yellow picks the main course from hRandomAdd: bit 7 set -> Salade de Salmon,
; else bit 4 set -> Eels au Barbecue, else Prime Beef Steak.  That is 1/2, 1/4,
; 1/4, which `random 4` reproduces exactly.
SSAnneKitchenCook7Script:
	faceplayer
	opentext
	writetext SSAnneKitchenCook7MainCourseIsText
	promptbutton
	random 4
	ifequal 2, .EelsAuBarbecue
	ifequal 3, .PrimeBeefSteak
	writetext SSAnneKitchenCook7SalmonDuSaladText
	waitbutton
	closetext
	end

.EelsAuBarbecue:
	writetext SSAnneKitchenCook7EelsAuBarbecueText
	waitbutton
	closetext
	end

.PrimeBeefSteak:
	writetext SSAnneKitchenCook7PrimeBeefSteakText
	waitbutton
	closetext
	end

SSAnneKitchenTrash:
	jumptext SSAnneKitchenTrashText

SSAnneKitchenHiddenGreatBall:
	hiddenitem GREAT_BALL, EVENT_SS_ANNE_KITCHEN_HIDDEN_GREAT_BALL

SSAnneKitchenCook1Text:
	text "You, mon petit!"
	line "We're busy here!"
	cont "Out of the way!"
	done

SSAnneKitchenCook2Text:
	text "I saw an odd ball"
	line "in the trash."
	done

SSAnneKitchenCook3Text:
	text "I'm so busy I'm"
	line "getting dizzy!"
	done

SSAnneKitchenCook4Text:
	text "Hum-de-hum-de-"
	line "ho…"

	para "I peel spuds"
	line "every day!"
	cont "Hum-hum…"
	done

SSAnneKitchenCook5Text:
	text "Did you hear about"
	line "SNORLAX?"

	para "All it does is"
	line "eat and sleep!"
	done

SSAnneKitchenCook6Text:
	text "Snivel…Sniff…"

	para "I only get to"
	line "peel onions…"
	cont "Snivel…"
	done

SSAnneKitchenCook7MainCourseIsText:
	text "Er-hem! Indeed I"
	line "am le CHEF!"

	para "Le main course is"
	done

SSAnneKitchenCook7SalmonDuSaladText:
	text "Salade de Salmon!"

	para "Les guests may"
	line "gripe it's fish"
	cont "again, however!"
	done

SSAnneKitchenCook7EelsAuBarbecueText:
	text "Eels au Barbecue!"

	para "Les guests will"
	line "mutiny, I fear."
	done

SSAnneKitchenCook7PrimeBeefSteakText:
	text "Prime Beef Steak!"

	para "But, have I enough"
	line "fillets du beef?"
	done

; Yellow's PrintTrashText, shared with the VERMILION GYM trash cans.
SSAnneKitchenTrashText:
	text "Nope, there's"
	line "only trash here."
	done

SSAnneKitchen_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  6,  0, SS_ANNE_1F, 11

	def_coord_events

	def_bg_events
	bg_event 13,  5, BGEVENT_READ, SSAnneKitchenTrash
	bg_event 13,  7, BGEVENT_READ, SSAnneKitchenTrash
	bg_event 13,  9, BGEVENT_ITEM, SSAnneKitchenHiddenGreatBall

	def_object_events
	object_event  1,  8, SPRITE_CLERK, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnneKitchenCook1Script, -1
	object_event  5,  8, SPRITE_CLERK, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnneKitchenCook2Script, -1
	object_event  9,  7, SPRITE_CLERK, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnneKitchenCook3Script, -1
	object_event 13,  6, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnneKitchenCook4Script, -1
	object_event 13,  8, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnneKitchenCook5Script, -1
	object_event 13, 10, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnneKitchenCook6Script, -1
	object_event 11, 13, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnneKitchenCook7Script, -1
