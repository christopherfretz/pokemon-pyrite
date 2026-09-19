; Kanto hack: Yellow's VERMILION_CITY (docs/M4-VERMILION.md 7e).
; Objects, bg_events and scripts come from vendor/pokeyellow's
; data/maps/objects/VermilionCity.asm, scripts/VermilionCity.asm,
; scripts/VermilionCity_2.asm and text/VermilionCity.asm.  7b already re-cut the
; city from Yellow's .blk, so every warp and every coordinate below is Yellow's
; own, unmoved.
;
; Deleted with 7e: Crystal's SNORLAX set-piece (Yellow's Snorlax blocks ROUTE 12
; / ROUTE 16, never Vermilion), the Digglett's-Cave warp + sign (our DIGLETT's
; Cave entrance is not here), and the sixteen-badge HP_UP guy.  Crystal's hidden
; FULL_HEAL at (37,13) is re-homed to Yellow's hidden MAX_ETHER at (14,11)
; (vendor/pokeyellow/data/events/hidden_item_coords.asm), reachable by SURF off
; the west pond; (37,13) is Yellow's NOTICE sign instead.
;
; Sprites: Yellow's SPRITE_GAMBLER art is byte-identical to Crystal's
; gfx/sprites/old_man.png, so the two gamblers use SPRITE_OLD_MAN ($69), the
; sheet 4c already ported for Viridian.  SPRITE_MONSTER exists in Crystal ($4c)
; and its sheet is byte-identical to Yellow's gfx/sprites/monster.png, so the
; MACHOP is Yellow's own overworld sprite.  Officer Jenny uses SPRITE_OFFICER.
;
; The S.S.ANNE dock gate: Yellow polls every frame for "player at (18,30) facing
; DOWN" (VermilionCityDefaultScript) and simulates a PAD_UP press to push the
; player back.  GSC has no frame poll, but a coord_event fires on arrival, which
; is exactly when Yellow's check first passes, so the gate is a coord_event at
; (18,30) guarded by VAR_FACING == DOWN (so walking back up out of the port does
; not re-run it) plus an `applymovement PLAYER step UP` pushback.
	object_const_def
	const VERMILIONCITY_COOLTRAINER_F
	const VERMILIONCITY_GAMBLER1
	const VERMILIONCITY_SAILOR1
	const VERMILIONCITY_GAMBLER2
	const VERMILIONCITY_MACHOP
	const VERMILIONCITY_SAILOR2
	const VERMILIONCITY_OFFICER_JENNY

VermilionCity_MapScripts:
	def_scene_scripts
	scene_script VermilionCityNoopScene,         SCENE_VERMILIONCITY_NOTHING
	scene_script VermilionCityExitShipScene,     SCENE_VERMILIONCITY_SS_ANNE_DEPARTED

	def_callbacks
	callback MAPCALLBACK_NEWMAP, VermilionCityFlypointCallback

VermilionCityNoopScene:
	end

; 7j.  Yellow: VermilionCityLeftSSAnneCallbackScript ->
; SCRIPT_VERMILIONCITY_PLAYER_EXIT_SHIP (vendor/pokeyellow/scripts/VermilionCity.asm).
; On the first city load after the ship sails, Yellow ignores the joypad and
; simulates two PAD_UP presses so the player walks up off the pier instead of
; standing in the gate; EVENT_WALKED_PAST_GUARD_AFTER_SS_ANNE_LEFT is only the
; latch that makes it happen once.  A scene armed by the dock is the same latch.
VermilionCityExitShipScene:
	setscene SCENE_VERMILIONCITY_NOTHING
	applymovement PLAYER, VermilionCityExitShipMovement
	end

VermilionCityExitShipMovement:
	step UP
	step UP
	step_end

VermilionCityFlypointCallback:
	setflag ENGINE_FLYPOINT_VERMILION
; 7f: Yellow's .vermilionCityScript_19869 (vendor/pokeyellow/scripts/VermilionCity.asm:69).
; Once the player is back out in the city carrying the BIKE VOUCHER, the
; #MON FAN CLUB chairman switches over to his GB Printer offer and both fans
; start talking about PRINTs.  Yellow tests it from the city's per-frame map
; script; MAPCALLBACK_NEWMAP runs on arrival, which is the first moment that
; test can pass.  (Yellow's same map script also clears
; BIT_PIKACHU_MAP_SCRIPT_ACTIVE; ours is wPikaFanClubSceneDone, cleared by
; SpawnFollower on every map load instead.)
	checkevent EVENT_LEFT_FANCLUB_AFTER_BIKE_VOUCHER
	iftrue .done
	checkevent EVENT_GOT_BIKE_VOUCHER
	iffalse .done
	setevent EVENT_LEFT_FANCLUB_AFTER_BIKE_VOUCHER
.done
	endcallback

; Yellow: VermilionCityDefaultScript / SSAnneTicketCheckCoords (18,30).
VermilionCityDockGateScript:
	readvar VAR_FACING
	ifnotequal DOWN, .Done
	opentext
	checkevent EVENT_SS_ANNE_LEFT
	iftrue .ShipDeparted
	writetext VermilionCitySailorDoYouHaveATicketText
	promptbutton
	checkitem S_S_TICKET
	iffalse .NoTicket
	writetext VermilionCitySailorFlashedTicketText
	waitbutton
	closetext
.Done:
	end

.NoTicket:
	writetext VermilionCitySailorYouNeedATicketText
	waitbutton
	closetext
	applymovement PLAYER, VermilionCityDockGateBlockMovement
	end

.ShipDeparted:
	writetext VermilionCitySailorShipSetSailText
	waitbutton
	closetext
	applymovement PLAYER, VermilionCityDockGateBlockMovement
	end

VermilionCityCooltrainerFScript:
	jumptextfaceplayer VermilionCityCooltrainerFText

; Yellow: VermilionCityGambler1Text.
VermilionCityGambler1Script:
	faceplayer
	opentext
	checkevent EVENT_SS_ANNE_LEFT
	iftrue .Departed
	writetext VermilionCityGambler1DidYouSeeText
	waitbutton
	closetext
	end

.Departed:
	writetext VermilionCityGambler1SSAnneDepartedText
	waitbutton
	closetext
	end

; Yellow: VermilionCitySailor1Text.  The ticket branch of Yellow's text script
; is only reachable from the map script (the player is never adjacent to the
; guard without either facing RIGHT or standing on (19,29)/(19,31)), so talking
; to him is the greeting, and the gate coord_event above does the ticket check.
VermilionCitySailor1Script:
	faceplayer
	opentext
	checkevent EVENT_SS_ANNE_LEFT
	iftrue .Departed
	writetext VermilionCitySailorWelcomeToSSAnneText
	waitbutton
	closetext
	end

.Departed:
	writetext VermilionCitySailorShipSetSailText
	waitbutton
	closetext
	end

VermilionCityGambler2Script:
	jumptextfaceplayer VermilionCityGambler2Text

; Yellow: VermilionCityMachopText -- the cry plays between Yellow's two
; paragraphs, and Gen 1's `para` is a PromptButton + clear exactly like ours.
VermilionCityMachopScript:
	opentext
	writetext VermilionCityMachopText
	cry MACHOP
	promptbutton
	writetext VermilionCityMachopStompingTheLandFlatText
	waitbutton
	closetext
	end

VermilionCitySailor2Script:
	jumptextfaceplayer VermilionCitySailor2Text

; Yellow: VermilionCityPrintOfficerJennyText (scripts/VermilionCity_2.asm).
; Yellow's GivePokemon boxes SQUIRTLE when the party is full, and so does
; Crystal's `givepoke` (engine/pokemon/move_mon.asm GivePoke: it prints
; "was sent to BILL's PC" and returns 1), so unlike Melanie's BULBASAUR in 6g
; this gift needs no invented party-full line -- only Yellow's "<PLAYER> got
; SQUIRTLE!" is suppressed on the box path, exactly as Yellow does, and the
; both-full case (GivePoke returns 2, silently) gets Yellow's BoxIsFullText.
VermilionCityOfficerJennyScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_SQUIRTLE_FROM_OFFICER_JENNY
	iftrue .AlreadyGave
	checkflag ENGINE_THUNDERBADGE
	iffalse .NoBadge
	writetext VermilionCityOfficerJennyOfferText
	yesorno
	iffalse .Refused
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .ToBox
	writetext VermilionCityOfficerJennyGotSquirtleText
	playsound SFX_CAUGHT_MON
	waitsfx
.ToBox:
	givepoke SQUIRTLE, 10
	ifequal 2, .NoRoom
	setevent EVENT_GOT_SQUIRTLE_FROM_OFFICER_JENNY
	writetext VermilionCityOfficerJennyTreatItRightText
	waitbutton
	closetext
	end

.NoRoom:
	writetext VermilionCityOfficerJennyBoxIsFullText
	waitbutton
	closetext
	end

.NoBadge:
	writetext VermilionCityOfficerJennyCaughtSquirtleText
	waitbutton
	closetext
	end

.Refused:
	writetext VermilionCityOfficerJennyWhatAmIToDoText
	waitbutton
	closetext
	end

.AlreadyGave:
	writetext VermilionCityOfficerJennyHowIsSquirtleText
	waitbutton
	closetext
	end

VermilionCitySign:
	jumptext VermilionCitySignText

VermilionCityNoticeSign:
	jumptext VermilionCityNoticeSignText

VermilionGymSign:
	jumptext VermilionGymSignText

PokemonFanClubSign:
	jumptext PokemonFanClubSignText

VermilionCityHarborSign:
	jumptext VermilionCityHarborSignText

VermilionCityPokecenterSign:
	jumpstd PokecenterSignScript

VermilionCityMartSign:
	jumpstd MartSignScript

VermilionCityHiddenMaxEther:
	hiddenitem MAX_ETHER, EVENT_VERMILION_CITY_HIDDEN_MAX_ETHER

VermilionCityDockGateBlockMovement:
	step UP
	step_end

VermilionCityCooltrainerFText:
	text "We're careful"
	line "about pollution!"

	para "We've heard GRIMER"
	line "multiplies in"
	cont "toxic sludge!"
	done

VermilionCityGambler1DidYouSeeText:
	text "Did you see S.S."
	line "ANNE moored in"
	cont "the harbor?"
	done

VermilionCityGambler1SSAnneDepartedText:
	text "So, S.S.ANNE has"
	line "departed!"

	para "She'll be back in"
	line "about a year."
	done

VermilionCitySailorWelcomeToSSAnneText:
	text "Welcome to S.S."
	line "ANNE!"
	done

VermilionCitySailorDoYouHaveATicketText:
	text "Welcome to S.S."
	line "ANNE!"

	para "Excuse me, do you"
	line "have a ticket?"
	prompt

VermilionCitySailorFlashedTicketText:
	text "<PLAYER> flashed"
	line "the S.S.TICKET!"

	para "Great! Welcome to"
	line "S.S.ANNE!"
	done

VermilionCitySailorYouNeedATicketText:
	text "<PLAYER> doesn't"
	line "have the needed"
	cont "S.S.TICKET."

	para "Sorry!"

	para "You need a ticket"
	line "to get aboard."
	done

VermilionCitySailorShipSetSailText:
	text "The ship set sail."
	done

VermilionCityGambler2Text:
	text "I'm putting up a"
	line "building on this"
	cont "plot of land."

	para "My #MON is"
	line "tamping the land."
	done

VermilionCityMachopText:
	text "MACHOP: Guoh!"
	line "Gogogoh!"
	prompt

VermilionCityMachopStompingTheLandFlatText:
	text "A MACHOP is"
	line "stomping the land"
	cont "flat."
	done

VermilionCitySailor2Text:
	text "S.S.ANNE is a"
	line "famous luxury"
	cont "cruise ship."

	para "We visit VERMILION"
	line "once a year."
	done

VermilionCityOfficerJennyCaughtSquirtleText:
	text "I just caught a"
	line "SQUIRTLE that was"
	cont "always getting"
	cont "into mischief."

	para "I think it needs a"
	line "good trainer to"
	cont "set it straight."
	done

VermilionCityOfficerJennyOfferText:
	text "You have the"
	line "THUNDERBADGE!?"

	para "You must be a"
	line "good trainer!"

	para "I just caught a"
	line "SQUIRTLE that was"
	cont "always getting"
	cont "into mischief."

	para "Would you take"
	line "good care of it?"
	done

VermilionCityOfficerJennyTreatItRightText:
	text "OK! Please treat"
	line "SQUIRTLE right!"
	done

VermilionCityOfficerJennyWhatAmIToDoText:
	text "Oh... What am I"
	line "to do now?"
	done

VermilionCityOfficerJennyHowIsSquirtleText:
	text "How is SQUIRTLE"
	line "doing?"
	done

VermilionCityOfficerJennyGotSquirtleText:
	text "<PLAYER> got"
	line "SQUIRTLE!"
	done

; Yellow: _BoxIsFullText, printed by GivePokemon when party and box are both
; full.  Crystal's GivePoke returns 2 and prints nothing, so we print it here.
VermilionCityOfficerJennyBoxIsFullText:
	text "There's no more"
	line "room for #MON!"

	para "The #MON BOX"
	line "is full and can't"
	cont "accept any more!"
	done

VermilionCitySignText:
	text "VERMILION CITY"
	line "The Port of"
	cont "Exquisite Sunsets"
	done

VermilionCityNoticeSignText:
	text "NOTICE!"

	para "ROUTE 12 may be"
	line "blocked off by a"
	cont "sleeping #MON."

	para "Detour through"
	line "ROCK TUNNEL to"
	cont "LAVENDER TOWN."

	para "VERMILION POLICE"
	done

PokemonFanClubSignText:
	text "#MON FAN CLUB"
	line "All #MON fans"
	cont "welcome!"
	done

VermilionGymSignText:
	text "VERMILION CITY"
	line "#MON GYM"
	cont "LEADER: LT.SURGE"

	para "The Lightning"
	line "American!"
	done

VermilionCityHarborSignText:
	text "VERMILION HARBOR"
	done

VermilionCity_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 11,  3, VERMILION_POKECENTER_1F, 1
	warp_event  9, 13, POKEMON_FAN_CLUB, 1
	warp_event 23, 13, VERMILION_MART, 2
	warp_event 12, 19, VERMILION_GYM, 1
	warp_event 23, 19, VERMILION_PIDGEY_HOUSE, 1
	warp_event 18, 31, VERMILION_PORT, 1
	warp_event 19, 31, VERMILION_PORT, 1
	warp_event 15, 13, VERMILION_TRADE_HOUSE, 1
	warp_event  7,  3, VERMILION_OLD_ROD_HOUSE, 1

	def_coord_events
	coord_event 18, 30, -1, VermilionCityDockGateScript

	def_bg_events
	bg_event 27,  3, BGEVENT_READ, VermilionCitySign
	bg_event 37, 13, BGEVENT_READ, VermilionCityNoticeSign
	bg_event 24, 13, BGEVENT_READ, VermilionCityMartSign
	bg_event 12,  3, BGEVENT_READ, VermilionCityPokecenterSign
	bg_event  7, 13, BGEVENT_READ, PokemonFanClubSign
	bg_event  7, 19, BGEVENT_READ, VermilionGymSign
	bg_event 29, 15, BGEVENT_READ, VermilionCityHarborSign
	bg_event 14, 11, BGEVENT_ITEM, VermilionCityHiddenMaxEther

	def_object_events
	object_event 19,  7, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, VermilionCityCooltrainerFScript, -1
	object_event 14,  6, SPRITE_OLD_MAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, VermilionCityGambler1Script, -1
	object_event 19, 30, SPRITE_SAILOR, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, VermilionCitySailor1Script, -1
	object_event 30,  7, SPRITE_OLD_MAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, VermilionCityGambler2Script, -1
	object_event 29,  9, SPRITE_MONSTER, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, VermilionCityMachopScript, -1
	object_event 25, 27, SPRITE_SAILOR, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, VermilionCitySailor2Script, -1
	object_event 19, 15, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, VermilionCityOfficerJennyScript, -1
