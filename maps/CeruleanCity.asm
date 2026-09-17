; 6b: Yellow's Cerulean City object list
; (vendor/pokeyellow/data/maps/objects/CeruleanCity.asm).  Crystal's own six
; objects and nine bg_events are gone; the seven statics below are Yellow's, on
; Yellow's tiles.  Yellow's other four objects belong to later sub-steps and are
; APPENDED at the end of both lists so these indexes never move:
;   6c: CERULEANCITY_ROCKET (30,8), CERULEANCITY_GUARD1 (28,12),
;       CERULEANCITY_GUARD2 (27,12)
;   6d: CERULEANCITY_RIVAL  (20,2)
	object_const_def
	const CERULEANCITY_COOLTRAINER_M
	const CERULEANCITY_SUPER_NERD1
	const CERULEANCITY_SUPER_NERD2
	const CERULEANCITY_COOLTRAINER_F1
	const CERULEANCITY_ELECTRODE
	const CERULEANCITY_COOLTRAINER_F2
	const CERULEANCITY_SUPER_NERD3
	; 6c appends CERULEANCITY_ROCKET / _GUARD1 / _GUARD2 here
	; 6d appends CERULEANCITY_RIVAL here

CeruleanCity_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_NEWMAP, CeruleanCityFlypointCallback

CeruleanCityFlypointCallback:
	setflag ENGINE_FLYPOINT_CERULEAN
	endcallback

CeruleanCityCooltrainerMScript:
	jumptextfaceplayer CeruleanCityCooltrainerMText

CeruleanCitySuperNerd1Script:
	jumptextfaceplayer CeruleanCitySuperNerd1Text

CeruleanCitySuperNerd2Script:
	jumptextfaceplayer CeruleanCitySuperNerd2Text

; Yellow picks one of three lines at random (hRandomAdd thresholds 180/100,
; i.e. 76/80/100 out of 256); GSC's `random 3` is the same idea.
CeruleanCityCooltrainerF1Script:
	faceplayer
	opentext
	random 3
	ifequal 0, .Punch
	ifequal 1, .Withdraw
	writetext CeruleanCityElectrodeSonicboomText
	waitbutton
	closetext
	end

.Punch:
	writetext CeruleanCityElectrodePunchText
	waitbutton
	closetext
	end

.Withdraw:
	writetext CeruleanCityElectrodeWithdrawText
	waitbutton
	closetext
	end

; Yellow's "ELECTRODE" gag: a SPRITE_POKE_BALL that talks.  Four lines at
; random (76/60/60/60 out of 256).
CeruleanCityElectrodeScript:
	opentext
	random 4
	ifequal 0, .Loafing
	ifequal 1, .TurnedAway
	ifequal 2, .IgnoredOrders
	writetext CeruleanCityElectrodeSnoozeText
	waitbutton
	closetext
	end

.Loafing:
	writetext CeruleanCityElectrodeLoafingText
	waitbutton
	closetext
	end

.TurnedAway:
	writetext CeruleanCityElectrodeTurnedAwayText
	waitbutton
	closetext
	end

.IgnoredOrders:
	writetext CeruleanCityElectrodeIgnoredOrdersText
	waitbutton
	closetext
	end

CeruleanCityCooltrainerF2Script:
	jumptextfaceplayer CeruleanCityCooltrainerF2Text

CeruleanCitySuperNerd3Script:
	jumptextfaceplayer CeruleanCitySuperNerd3Text

CeruleanCitySign:
	jumptext CeruleanCitySignText

CeruleanCityTrainerTips:
	jumptext CeruleanCityTrainerTipsText

CeruleanGymSign:
	jumptext CeruleanGymSignText

CeruleanBikeShopSign:
	jumptext CeruleanBikeShopSignText

CeruleanCityPokecenterSign:
	jumpstd PokecenterSignScript

CeruleanCityMartSign:
	jumpstd MartSignScript

CeruleanCityCooltrainerMText:
	text "You're a trainer"
	line "too? Collecting,"
	cont "fighting, it's a"
	cont "tough life."
	done

CeruleanCitySuperNerd1Text:
	text "That bush in"
	line "front of the shop"
	cont "is in the way."

	para "There might be a"
	line "way around."
	done

CeruleanCitySuperNerd2Text:
	text "You're making an"
	line "encyclopedia on"
	cont "#MON? That"
	cont "sounds amusing."
	done

CeruleanCityElectrodeSonicboomText:
	text "OK! ELECTRODE!"
	line "Use SONICBOOM!"
	cont "Please ELECTRODE,"
	cont "pay attention!"
	done

CeruleanCityElectrodePunchText:
	text "ELECTRODE, TACKLE!"
	line "No! You blew it"
	cont "again!"
	done

CeruleanCityElectrodeWithdrawText:
	text "ELECTRODE, SWIFT!"
	line "No! That's wrong!"

	para "Training #MON"
	line "is difficult!"

	para "Your #MON's"
	line "obedience depends"
	cont "on your abilities"
	cont "as a trainer!"
	done

CeruleanCityElectrodeSnoozeText:
	text "ELECTRODE took a"
	line "snooze…"
	done

CeruleanCityElectrodeLoafingText:
	text "ELECTRODE is"
	line "loafing around…"
	done

CeruleanCityElectrodeTurnedAwayText:
	text "ELECTRODE turned"
	line "away…"
	done

CeruleanCityElectrodeIgnoredOrdersText:
	text "ELECTRODE"
	line "ignored orders…"
	done

CeruleanCityCooltrainerF2Text:
	text "I want a bright"
	line "red BICYCLE!"

	para "I'll keep it at"
	line "home, so it won't"
	cont "get dirty!"
	done

CeruleanCitySuperNerd3Text:
	text "This is CERULEAN"
	line "CAVE! Horribly"
	cont "strong #MON"
	cont "live in there!"

	para "The #MON LEAGUE"
	line "champion is the"
	cont "only person who"
	cont "is allowed in!"
	done

CeruleanCitySignText:
	text "CERULEAN CITY"
	line "A Mysterious,"
	cont "Blue Aura"
	cont "Surrounds It"
	done

CeruleanCityTrainerTipsText:
	text "TRAINER TIPS"

	para "Pressing B Button"
	line "during evolution"
	cont "cancels the whole"
	cont "process."
	done

CeruleanBikeShopSignText:
	text "Grass and caves"
	line "handled easily!"
	cont "BIKE SHOP"
	done

CeruleanGymSignText:
	text "CERULEAN CITY"
	line "#MON GYM"
	cont "LEADER: MISTY"

	para "The Tomboyish"
	line "Mermaid!"
	done

CeruleanCity_MapEvents:
	db 0, 0 ; filler

; 6a: Yellow's ten warps, in Yellow's order (docs/M3-CERULEAN.md 1.4).  Warps 8
; and 10 are the "hole in the back wall" pass-throughs; they sit on metatile $96
; (FLOOR, FLOOR, FLOOR, LADDER), because GSC only fires a warp on a tile whose
; collision is in the $7x warp nybble while Gen 1 fires one anywhere.
	def_warp_events
	warp_event 27, 11, CERULEAN_TRASHED_HOUSE, 1
	warp_event 13, 15, CERULEAN_MELANIES_HOUSE, 1
	warp_event 19, 17, CERULEAN_POKECENTER_1F, 1
	warp_event 30, 19, CERULEAN_GYM, 1
	warp_event 13, 25, BIKE_SHOP, 1
	warp_event 25, 25, CERULEAN_MART, 1
	warp_event  4, 11, CERULEAN_BADGE_HOUSE, 2 ; 6k: -> CERULEAN_CAVE_1F, 1
	warp_event 27,  9, CERULEAN_TRASHED_HOUSE, 3
	warp_event  9, 11, CERULEAN_BADGE_HOUSE, 2
	warp_event  9,  9, CERULEAN_BADGE_HOUSE, 1

	def_coord_events
	; 6c appends the Rocket break-in trigger at (30,7)/(30,9)
	; 6d appends the rival trigger at (20,6)/(21,6)

; 6b: Yellow's six signs, on Yellow's tiles, in Yellow's order.  Crystal's three
; extra bg_events (CERULEAN CAPE, the locked door, the hidden BERSERK_GENE at
; (2,12)) are gone -- Yellow has none of them.
	def_bg_events
	bg_event 23, 19, BGEVENT_READ, CeruleanCitySign
	bg_event 17, 29, BGEVENT_READ, CeruleanCityTrainerTips
	bg_event 26, 25, BGEVENT_READ, CeruleanCityMartSign
	bg_event 20, 17, BGEVENT_READ, CeruleanCityPokecenterSign
	bg_event 11, 25, BGEVENT_READ, CeruleanBikeShopSign
	bg_event 27, 21, BGEVENT_READ, CeruleanGymSign

	def_object_events
	object_event 31, 20, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeruleanCityCooltrainerMScript, -1
	object_event 15, 18, SPRITE_SUPER_NERD, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeruleanCitySuperNerd1Script, -1
	object_event  9, 21, SPRITE_SUPER_NERD, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeruleanCitySuperNerd2Script, -1
	object_event 29, 26, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeruleanCityCooltrainerF1Script, -1
	object_event 28, 26, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeruleanCityElectrodeScript, -1
	object_event  9, 27, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeruleanCityCooltrainerF2Script, -1
	object_event  4, 12, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeruleanCitySuperNerd3Script, -1
	; 6c appends the Rocket thief (30,8) and the two Officer Jennys (28,12)/(27,12)
	; 6d appends the rival (20,2)
