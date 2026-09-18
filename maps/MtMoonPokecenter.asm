; Kanto hack: the Mt. Moon Pokemon Center on Route 4 (docs/M2-MTMOON.md).
; It uses Crystal's shared maps/Pokecenter1F.blk, so the two door tiles and the
; 2F staircase are Crystal's, not Yellow's.  Yellow's 7x4 map is wider than
; Crystal's 5x4 one, so the NPCs are re-placed (see "5g findings"); Yellow's
; CLIPBOARD (blank text) and LINK_RECEPTIONIST (Crystal's cable club lives on
; POKECENTER_2F) are dropped.  N1e restored Yellow's CHANSEY at its own (4,1):
; Crystal does ship SPRITE_CHANSEY, and (4,1) is reachable across the counter
; from (4,3), the same pattern N1c/N1d used at Viridian and Pewter.
; The PC needs no object: Crystal drives it from the tile collision.

	object_const_def
	const MTMOONPOKECENTER_NURSE
	const MTMOONPOKECENTER_YOUNGSTER
	const MTMOONPOKECENTER_GENTLEMAN
	const MTMOONPOKECENTER_MAGIKARP_SALESMAN
	const MTMOONPOKECENTER_CHANSEY

DEF MTMOONPOKECENTER_MAGIKARP_PRICE EQU 500

MtMoonPokecenter_MapScripts:
	def_scene_scripts

	def_callbacks

MtMoonPokecenterNurseScript:
	jumpstd PokecenterNurseScript

MtMoonPokecenterYoungsterScript:
	jumptextfaceplayer MtMoonPokecenterYoungsterText

MtMoonPokecenterGentlemanScript:
	jumptextfaceplayer MtMoonPokecenterGentlemanText

; Kanto hack (N1e): Yellow's PokecenterChanseyText -- one line plus the cry.
MtMoonPokecenterChanseyScript:
	opentext
	writetext MtMoonPokecenterChanseyText
	cry CHANSEY
	waitbutton
	closetext
	end

; Yellow's MAGIKARP salesman (scripts/MtMoonPokecenter_2.asm): a L5 MAGIKARP
; for Y500, once.  Crystal's givepoke would silently box the mon if the party
; is full, so - like MountMortarB1F and the Game Corner prize room - the party
; is checked BEFORE any money changes hands.
MtMoonPokecenterMagikarpSalesmanScript:
	faceplayer
	opentext
	checkevent EVENT_BOUGHT_MAGIKARP
	iftrue .AlreadyBought
	writetext MtMoonPokecenterMagikarpSalesmanIGotADealText
	yesorno
	iffalse .Refused
	checkmoney YOUR_MONEY, MTMOONPOKECENTER_MAGIKARP_PRICE
	ifequal HAVE_LESS, .NoMoney
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .PartyFull
	takemoney YOUR_MONEY, MTMOONPOKECENTER_MAGIKARP_PRICE
	waitsfx
	playsound SFX_TRANSACTION
	waitsfx
	writetext MtMoonPokecenterMagikarpSalesmanSoldText
	promptbutton
	playsound SFX_CAUGHT_MON
	waitsfx
	givepoke MAGIKARP, 5
	setevent EVENT_BOUGHT_MAGIKARP
	closetext
	end

.Refused:
	writetext MtMoonPokecenterMagikarpSalesmanNoText
	waitbutton
	closetext
	end

.NoMoney:
	writetext MtMoonPokecenterMagikarpSalesmanNoMoneyText
	waitbutton
	closetext
	end

.PartyFull:
	writetext MtMoonPokecenterMagikarpSalesmanPartyFullText
	waitbutton
	closetext
	end

.AlreadyBought:
	writetext MtMoonPokecenterMagikarpSalesmanNoRefundsText
	waitbutton
	closetext
	end

MtMoonPokecenterYoungsterText:
	text "I've 6 # BALLs"
	line "set in my belt."

	para "At most, you can"
	line "carry 6 #MON."
	done

MtMoonPokecenterGentlemanText:
	text "TEAM ROCKET"
	line "attacks CERULEAN"
	cont "citizens…"

	para "TEAM ROCKET is"
	line "always in the"
	cont "news!"
	done

MtMoonPokecenterMagikarpSalesmanIGotADealText:
	text "MAN: Hello, there!"
	line "Have I got a deal"
	cont "just for you!"

	para "I'll let you have"
	line "a swell MAGIKARP"
	cont "for just ¥500!"
	cont "What do you say?"
	done

MtMoonPokecenterMagikarpSalesmanSoldText:
	text "MAN: Thanks, kid!"
	line "You won't regret"
	cont "it!"
	done

MtMoonPokecenterMagikarpSalesmanNoText:
	text "No? I'm only"
	line "doing this as a"
	cont "favor to you!"
	done

MtMoonPokecenterMagikarpSalesmanNoMoneyText:
	text "You'll need more"
	line "money than that!"
	done

; Not in Yellow (Gen 1 has no party check here); written in the salesman's
; voice so a full party is refused before he takes the money.
MtMoonPokecenterMagikarpSalesmanPartyFullText:
	text "MAN: Hold on, your"
	line "party's full!"

	para "Make some room,"
	line "then we'll talk"
	cont "business!"
	done

MtMoonPokecenterMagikarpSalesmanNoRefundsText:
	text "MAN: Well, I don't"
	line "give refunds!"
	done

MtMoonPokecenterChanseyText:
	text "CHANSEY: Chaaan"
	line "sey!"
	done

MtMoonPokecenter_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, ROUTE_4, 1
	warp_event  4,  7, ROUTE_4, 1
	warp_event  0,  7, POKECENTER_2F, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  3,  1, SPRITE_NURSE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, MtMoonPokecenterNurseScript, -1
	object_event  1,  4, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, MtMoonPokecenterYoungsterScript, -1
	object_event  6,  2, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, MtMoonPokecenterGentlemanScript, -1
	object_event  7,  6, SPRITE_POKEFAN_M, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, MtMoonPokecenterMagikarpSalesmanScript, -1
	object_event  4,  1, SPRITE_CHANSEY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, MtMoonPokecenterChanseyScript, -1
