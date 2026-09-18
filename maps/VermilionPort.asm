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
; 7j OWNS THE DEPARTURE.  Yellow's `VermilionDock_Script`
; (vendor/pokeyellow/scripts/VermilionDock.asm) runs on every map load: if
; EVENT_GOT_HM01 is set and you arrived through warp 1 (i.e. off the ship,
; `wDestinationWarpID == 1` -- our warp 2), it sets EVENT_SS_ANNE_LEFT, plays the
; smoke/horn animation, erases the ship and force-walks the player north out of
; the dock (EVENT_STARTED_WALKING_OUT_OF_DOCK / EVENT_WALKED_OUT_OF_DOCK).
; NOTHING here sets EVENT_SS_ANNE_LEFT yet -- it needs HM01, which arrives with
; 7i.  The hook belongs in a MAPCALLBACK_NEWMAP callback next to
; `VermilionPortFlypointCallback` below, gated on EVENT_GOT_HM01_CUT.

VermilionPort_MapScripts:
	def_scene_scripts
	scene_script VermilionPortNoopScene,      SCENE_VERMILIONPORT_ASK_ENTER_SHIP
	scene_script VermilionPortLeaveShipScene, SCENE_VERMILIONPORT_LEAVE_SHIP

	def_callbacks
	callback MAPCALLBACK_NEWMAP, VermilionPortFlypointCallback

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

VermilionPortFlypointCallback:
	setflag ENGINE_FLYPOINT_VERMILION
	endcallback

VermilionPort_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 14,  0, VERMILION_CITY, 6
	warp_event 14,  2, SS_ANNE_1F, 2 ; Kanto hack (docs/M4-VERMILION.md, 7c): Yellow's gangway.  The Johto FAST SHIP link is decided in the Johto milestone (decision (b)).

	def_coord_events

	def_bg_events

	def_object_events
