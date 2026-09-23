; Kanto hack: M4 step 7g (docs/M4-VERMILION.md).  VERMILION DOCK -- Yellow's 14x6
; quay, re-cut in 7b and warped in 7c.
;
; Yellow's `VermilionDock_Object` has NO object_events, NO bg_events and NO
; coord_events: you arrive at (14,0), walk two tiles south down the gangway and
; board at (14,2).  Crystal's FAST SHIP cast (the two sailors, the SUPER NERD,
; the hidden IRON and the `coord_event 4,1` boarding scene) is therefore deleted;
; the S.S. TICKET check lives on the CITY side, at `VermilionCityDockGateScript`
; (coord_event 18,30, ported in 7e).
;
; 7j: THE DEPARTURE.  Yellow's `VermilionDock_Script`
; (vendor/pokeyellow/scripts/VermilionDock.asm) runs on every map load: if
; EVENT_STARTED_WALKING_OUT_OF_DOCK is clear, EVENT_GOT_HM01 is set,
; EVENT_SS_ANNE_LEFT is clear and you arrived through warp 1 (i.e. off the ship,
; `wDestinationWarpID == 1` -- our warp 2), it sets EVENT_SS_ANNE_LEFT, plays the
; horn/slide animation, erases the ship and force-walks the player north out of
; the dock (EVENT_STARTED_WALKING_OUT_OF_DOCK / EVENT_WALKED_OUT_OF_DOCK).
;
; Our equivalent is a scene, armed by SSAnneCaptainsRoom.asm at the moment HM01
; is handed over -- which is exactly Yellow's EVENT_GOT_HM01 test, but resolved
; once instead of on every load -- and guarded here by `VAR_YCOORD == 2`, which
; is Yellow's `wDestinationWarpID == 1`: y 2 is the gangway warp, y 0 is the
; warp in from the city.  Arriving from the city leaves the scene armed, so a
; white-out mid-cruise (Yellow's other way back onto this map) behaves as it
; does in Yellow: nothing happens, you re-board, and the ship sails when you
; next step off the gangway.  The two events Yellow uses to sequence its
; simulated joypad walk have no analogue here; `applymovement` is synchronous.
;
; Yellow never touches the map blocks (VermilionDock_EraseSSAnne repairs VRAM by
; hand and its own comment says the block writes are pointless because the
; player walks north and never looks back).  We changeblock the four ship blocks
; away for real, here and in VermilionPortSSAnneGoneCallback, so the quay is
; right on any later load -- and so the gangway warp, whose LADDER quadrant goes
; with block $06, is sealed.  That is Yellow's transient `dec [wNumberOfWarps]`,
; made permanent.

VermilionPort_MapScripts:
	def_scene_scripts
	scene_script VermilionPortNoopScene,      SCENE_VERMILIONPORT_ASK_ENTER_SHIP
	scene_script VermilionPortAquaLeaveShipScene, SCENE_VERMILIONPORT_LEAVE_SHIP ; M11 14i
	scene_script VermilionPortSSAnneDepartsScene, SCENE_VERMILIONPORT_SS_ANNE_DEPARTS
; M11 14i: the S.S.AQUA is moored.  No table entry -- RunSceneScript skips a
; scene id >= the scene-script count -- so this emits no bytes; it only gates
; the boarding coord_event below.
	scene_const SCENE_VERMILIONPORT_AQUA_DOCKED

	def_callbacks
	callback MAPCALLBACK_NEWMAP, VermilionPortFlypointCallback
	callback MAPCALLBACK_TILES,  VermilionPortAquaTilesCallback ; M11 14i

VermilionPortNoopScene:
	end

; Kanto hack (7g) stub, now DEAD CODE: M11 14i repointed the LEAVE_SHIP table
; entry at VermilionPortAquaLeaveShipScene (after the MapEvents, so that this
; map's event pointers -- and every savestate taken on it -- stay put).
VermilionPortLeaveShipScene:
	setscene SCENE_VERMILIONPORT_ASK_ENTER_SHIP
	end

; Yellow: VermilionDockSSAnneLeavesScript.  Timings are Yellow's, measured in
; the vanilla harness (docs/M4-VERMILION.md, "## 7j findings"): 120 frames of
; nothing after the music change, 1024 frames of ship, 120 frames after the
; second horn.  `pause N` is 2N frames.
VermilionPortSSAnneDepartsScene:
	readvar VAR_YCOORD
	ifnotequal 2, .not_off_the_gangway
	setscene SCENE_VERMILIONPORT_ASK_ENTER_SHIP
	setevent EVENT_SS_ANNE_LEFT
; Yellow's EVENT_WALKED_PAST_GUARD_AFTER_SS_ANNE_LEFT: a one-shot latch that
; force-walks the player two tiles up off the pier on the first Vermilion City
; load after the ship goes.  A scene does the same job without a new flag.
	setmapscene VERMILION_CITY, SCENE_VERMILIONCITY_SS_ANNE_DEPARTED
; Yellow: StopAllMusic + MUSIC_SURFING, and the dock's own music never comes
; back -- the city's starts when the player warps out below.
	playmusic MUSIC_SURF
	pause 60
; Invisible until the refreshmap after the animation: changeblock only writes
; wOverworldMapBlocks.  $01 is the quay strip over open sea, $0d open sea, $18
; open sea that is not surfable, $17 the gangway foot with no hull under it.
	changeblock 10,  2, $01
	changeblock 12,  2, $18
	changeblock 14,  2, $17
	changeblock 16,  2, $01
	changeblock 10,  4, $0d
	changeblock 12,  4, $0d
	changeblock 14,  4, $0d
	changeblock 16,  4, $0d
	special SSAnneDeparture
	refreshmap
	playsound SFX_BOAT
	pause 60
	applymovement PLAYER, VermilionPortSSAnneWalkOutMovement
; 7n: `warp`, not `warpcheck` -- and the difference is a CRASH.
;
; `warpcheck` only ARMS the warp (Script_warpcheck -> EnableEvents); the map
; change happens a frame or two later, from the overworld loop, and
; DoPlayerMovement gets to run first.  That is fatal here because the walk-out
; ends on (14,0), the top row of a map with no north connection: the joypad
; byte the engine latched before the ~22-second cutscene is still UP (hJoyDown
; is only re-polled by the overworld loop, so UP held while stepping onto the
; SS ANNE 1F exit warp stays latched all the way through the departure), and
; `applymovement PLAYER` never re-runs GetMovementPermissions, so the
; collision cache still describes the gangway tile (14,2) this scene started
; on, where UP is open.  The player walks off the top of the map, wMapGroup
; goes to garbage and the ROM resets.  Measured in the harness: holding UP for
; 60+ frames across the SS ANNE 1F -> VERMILION PORT warp reproduces it every
; time.  `warp` does the map change inside the script, with no frame in which
; the player can move -- and it is what Crystal's own port scripts use
; (OlivinePort.asm, FastShip1F.asm).  VERMILION_CITY (18,31) is warp 6, the
; destination warp_event 1 below points at.
	warp VERMILION_CITY, 18, 31
.not_off_the_gangway:
	end

VermilionPortSSAnneWalkOutMovement:
	step UP
	step UP
	step_end

VermilionPortFlypointCallback:
	setflag ENGINE_FLYPOINT_VERMILION
	endcallback

; The ship does not come back.  Yellow never needs this -- the sailor at the
; pier gate turns the player away for the rest of the game -- but the blocks are
; the only thing standing between a re-entry and a moored S.S.ANNE.
VermilionPortSSAnneGoneCallback:
	checkevent EVENT_SS_ANNE_LEFT
	iffalse .done
	changeblock 10,  2, $01
	changeblock 12,  2, $18
	changeblock 14,  2, $17
	changeblock 16,  2, $01
	changeblock 10,  4, $0d
	changeblock 12,  4, $0d
	changeblock 14,  4, $0d
	changeblock 16,  4, $0d
.done
	endcallback

VermilionPort_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 14,  0, VERMILION_CITY, 6
	warp_event 14,  2, SS_ANNE_1F, 2 ; Kanto hack (docs/M4-VERMILION.md, 7c): Yellow's gangway.  In the JOHTO act the S.S.AQUA's boarding is the coord_event below (M11 14i, D156).

	def_coord_events
	coord_event 14,  1, SCENE_VERMILIONPORT_AQUA_DOCKED, VermilionPortAquaBoardScript

	def_bg_events

	def_object_events

; ---------------------------------------------------------------------------
; M11 14i: THE S.S.AQUA (docs/M11-JOHTO.md, D156).  Everything below lives
; after VermilionPort_MapEvents on purpose: the map's MapScripts/MapEvents
; addresses do not move, so no savestate taken on this map goes stale.
;
; In the JOHTO act (ENGINE_POKEGEAR) the FAST SHIP runs VERMILION <-> OLIVINE.
; Crystal's first voyage is always OLIVINE -> VERMILION (the grandpa and his
; granddaughter, the captain's cabin), and that arrival is what sets
; EVENT_FAST_SHIP_FIRST_TIME -- so the Vermilion side stays Yellow's empty,
; post-S.S.ANNE quay until the AQUA has actually brought the player here once.
; After that the ship is moored here (the S.S.ANNE's hull blocks stand in for
; it) and the pier gate in VERMILION CITY is Crystal's VermilionPort sailor:
; Wednesday/Sunday sailings, boarding yes/no, the S.S.TICKET.  In the KANTO act
; nothing below changes a byte of what the player sees.

; True (keep the ship) when: JOHTO act, the S.S.ANNE has sailed, and either the
; AQUA has already arrived once or it is arriving right now (LEAVE_SHIP).
VermilionPortAquaTilesCallback:
	checkflag ENGINE_POKEGEAR
	iffalse .kanto
	checkevent EVENT_SS_ANNE_LEFT
	iffalse .kanto
	checkscene
	ifequal SCENE_VERMILIONPORT_LEAVE_SHIP, .moored
	checkevent EVENT_FAST_SHIP_FIRST_TIME
	iffalse .kanto
	setscene SCENE_VERMILIONPORT_AQUA_DOCKED
.moored
	endcallback

.kanto
; A JOHTO-act-only scene can only be current here if the act flag was cleared
; (harness revert); disarm it so the boarding coord_event cannot fire.
	checkscene
	ifnotequal SCENE_VERMILIONPORT_AQUA_DOCKED, .gone
	setscene SCENE_VERMILIONPORT_ASK_ENTER_SHIP
.gone
	sjump VermilionPortSSAnneGoneCallback

VermilionPortAquaLeaveShipScene:
	sdefer VermilionPortAquaLeaveShipScript
	end

; Crystal: VermilionPortLeaveShipScript.  FastShip1F drops the player on the
; gangway foot (14,2); Crystal's sailor/TEMPORARY_UNTIL_MAP_RELOAD_1 re-board
; guard is unnecessary because the player is walked up the gangway and warped
; straight into the city, never getting control on this map (so Yellow's
; SS_ANNE_1F gangway warp at (14,2) is unreachable in the JOHTO act).  The
; city's SS_ANNE_DEPARTED scene then walks the player two steps up off the
; pier, exactly as when the S.S.ANNE left.
VermilionPortAquaLeaveShipScript:
	applymovement PLAYER, VermilionPortSSAnneWalkOutMovement
	setscene SCENE_VERMILIONPORT_AQUA_DOCKED
	setevent EVENT_FAST_SHIP_CABINS_SE_SSE_CAPTAINS_CABIN_TWIN_1
	setevent EVENT_FAST_SHIP_CABINS_SE_SSE_GENTLEMAN
	setevent EVENT_FAST_SHIP_PASSENGERS_FIRST_TRIP
	clearevent EVENT_OLIVINE_PORT_PASSAGE_POKEFAN_M
	setevent EVENT_FAST_SHIP_FIRST_TIME
	setevent EVENT_SS_ANNE_LEFT
	blackoutmod VERMILION_CITY
	setmapscene VERMILION_CITY, SCENE_VERMILIONCITY_SS_ANNE_DEPARTED
	warp VERMILION_CITY, 18, 31
	end

; Crystal: the eastbound half of VermilionPortSailorAtGangwayScript.  The ticket
; and the sailing day were checked by the pier gate in the city; stepping onto
; the gangway is boarding.
VermilionPortAquaBoardScript:
	applymovement PLAYER, VermilionPortAquaBoardMovement
	playsound SFX_EXIT_BUILDING
	special FadeOutToWhite
	waitsfx
	setevent EVENT_FAST_SHIP_PASSENGERS_EASTBOUND
	clearevent EVENT_FAST_SHIP_PASSENGERS_WESTBOUND
	clearevent EVENT_BEAT_POKEMANIAC_ETHAN
	clearevent EVENT_BEAT_BURGLAR_COREY
	clearevent EVENT_BEAT_BUG_CATCHER_KEN
	clearevent EVENT_BEAT_GUITARIST_CLYDE
	clearevent EVENT_BEAT_POKEFANM_JEREMY
	clearevent EVENT_BEAT_POKEFANF_GEORGIA
	clearevent EVENT_BEAT_SAILOR_KENNETH
	clearevent EVENT_BEAT_TEACHER_SHIRLEY
	clearevent EVENT_BEAT_SCHOOLBOY_NATE
	clearevent EVENT_BEAT_SCHOOLBOY_RICKY
	setevent EVENT_FAST_SHIP_DESTINATION_OLIVINE
	setmapscene FAST_SHIP_1F, SCENE_FASTSHIP1F_ENTER_SHIP
	warp FAST_SHIP_1F, 25, 1
	end

VermilionPortAquaBoardMovement:
	step DOWN
	step_end

; Reached from VermilionCity.asm's pier gate (.ShipDeparted, a size-neutral
; farsjump so VERMILION CITY's own events do not move).  The dialogue is
; already open.
VermilionCityDockGateDepartedScript:
	scall VermilionCityAquaRunsScript
	iffalse .set_sail
	readvar VAR_WEEKDAY
	ifequal MONDAY, .wednesday
	ifequal TUESDAY, .wednesday
	ifequal THURSDAY, .sunday
	ifequal FRIDAY, .sunday
	ifequal SATURDAY, .sunday
	writetext VermilionPortAquaAskBoardingText
	yesorno
	iffalse .come_again
	writetext VermilionPortAquaAskTicketText
	promptbutton
	checkitem S_S_TICKET
	iffalse .no_ticket
	writetext VermilionPortAquaSSTicketText
	waitbutton
	closetext
	end

.set_sail
; Yellow: the S.S.ANNE has set sail -- byte for byte the old .ShipDeparted.
	farwritetext VermilionCitySailorShipSetSailText
	sjump .turned_back

.wednesday
	writetext VermilionPortAquaSailWednesdayText
	sjump .turned_back

.sunday
	writetext VermilionPortAquaSailSundayText
	sjump .turned_back

.come_again
	writetext VermilionPortAquaComeAgainText
	sjump .turned_back

.no_ticket
	writetext VermilionPortAquaNoTicketText
.turned_back
	waitbutton
	closetext
	applymovement PLAYER, VermilionPortAquaTurnedBackMovement
	end

; The city's pier-gate SAILOR once the S.S.ANNE has gone (VermilionCity.asm
; VermilionCitySailor1Script .Departed, size-neutral farsjump).
VermilionCitySailor1DepartedScript:
	scall VermilionCityAquaRunsScript
	iftrue .aqua
	farwritetext VermilionCitySailorShipSetSailText
	sjump .done

.aqua
	writetext VermilionPortAquaSailorText
.done
	waitbutton
	closetext
	end

; scriptresult TRUE when the S.S.AQUA calls at this pier: JOHTO act, and it
; has made its first (OLIVINE -> VERMILION) crossing.
VermilionCityAquaRunsScript:
	checkflag ENGINE_POKEGEAR
	iffalse .no
	checkevent EVENT_FAST_SHIP_FIRST_TIME
	end

.no
	setval FALSE
	end

; = VermilionCityDockGateBlockMovement: back up off the gate tile.
VermilionPortAquaTurnedBackMovement:
	step UP
	step_end

; Crystal's VermilionPort texts, verbatim.
VermilionPortAquaAskBoardingText:
	text "Welcome to FAST"
	line "SHIP S.S.AQUA."

	para "Will you be board-"
	line "ing today?"
	done

VermilionPortAquaAskTicketText:
	text "May I see your"
	line "S.S.TICKET?"
	done

VermilionPortAquaComeAgainText:
	text "We hope to see you"
	line "again!"
	done

VermilionPortAquaSSTicketText:
	text "<PLAYER> flashed"
	line "the S.S.TICKET."

	para "That's it."
	line "Thank you!"
	done

VermilionPortAquaNoTicketText:
	text "<PLAYER> tried to"
	line "show the S.S."
	cont "TICKET…"

	para "…But no TICKET!"

	para "Sorry!"
	line "You may board only"

	para "if you have an"
	line "S.S.TICKET."
	done

VermilionPortAquaSailWednesdayText:
	text "The FAST SHIP will"
	line "sail on Wednesday."
	done

VermilionPortAquaSailSundayText:
	text "The FAST SHIP will"
	line "sail next Sunday."
	done

; New (14i): the gate SAILOR's greeting once the AQUA calls here, built from
; Crystal's own port lines (OlivinePortPassage's POKEFAN, the port sailors).
VermilionPortAquaSailorText:
	text "FAST SHIP S.S.AQUA"
	line "sails to OLIVINE"

	para "on Wednesdays and"
	line "Sundays."
	done
