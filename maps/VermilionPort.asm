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
	scene_script VermilionPortLeaveShipScene, SCENE_VERMILIONPORT_LEAVE_SHIP
	scene_script VermilionPortSSAnneDepartsScene, SCENE_VERMILIONPORT_SS_ANNE_DEPARTS

	def_callbacks
	callback MAPCALLBACK_NEWMAP, VermilionPortFlypointCallback
	callback MAPCALLBACK_TILES,  VermilionPortSSAnneGoneCallback

VermilionPortNoopScene:
	end

; Kanto hack (7g): stub.  Johto's untouched FAST SHIP maps (FastShip1F.asm,
; FastShipCabins_SE_SSE_CaptainsCabin.asm) still `setmapscene VERMILION_PORT,
; SCENE_VERMILIONPORT_LEAVE_SHIP`, and both scene constants are DEFINED by the
; `scene_script` lines above, so they must stay for those maps to assemble.
; The Johto FAST SHIP link is decision (b) -- re-routed in the Johto milestone.
; Until then this scene only disarms itself; it can never run in the Kanto act.
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
	warp_event 14,  2, SS_ANNE_1F, 2 ; Kanto hack (docs/M4-VERMILION.md, 7c): Yellow's gangway.  The Johto FAST SHIP link is decided in the Johto milestone (decision (b)).

	def_coord_events

	def_bg_events

	def_object_events
