RocketHideoutB1F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_TILES, RocketHideoutB1FDoorCallback

; Kanto hack (M6 9w, docs/M6-CELADON.md 3.4): Yellow's B1F door.
; RocketHideoutB1FDoorCallbackScript flips block (12, 8) -- Yellow writes
; `lb bc, 8, 12`, which is (y, x) -- between $54 (a shut door, WALL) and $0e
; (plain floor), sealing the corridor down to the lift until the fifth B1F
; Rocket is beaten.
;
; GSC's `changeblock` does NOT take block coordinates: Script_changeblock adds
; the 4-tile border to each argument and GetBlockLocation halves them, so the
; arguments are MAP TILE coordinates, the same space as warp_event, and Yellow
; block (12, 8) is `changeblock 24, 16` -- the two-tile gap in the wall along
; tile row 16, directly above the lift doors at (24,19)/(25,19).
;
; Yellow re-runs that on EVERY map load and replays SFX_GO_INSIDE each time --
; its own source flags that as a bug ("should be SetEvent to avoid the SFX
; playing every time you enter the map").  We keep the geometry and drop the
; bug: this callback only paints the block from the flag, so it is silent and
; idempotent, and the one-off "the door slid open" sound belongs on the actual
; transition, in the trainer's after-battle script.
;
; >>> M6 9x HOOK: when that Rocket's battle ends, his script must do
;         changeblock 24, 16, $0e
;         reloadmappart
;         playsound SFX_ENTER_DOOR   ; GSC has no SFX_GO_INSIDE (9u finding)
;         waitsfx
;     right after `setevent EVENT_BEAT_ROCKET_HIDEOUT_B1F_ROCKET_5`.  This
;     callback keeps the door open on every later visit.
RocketHideoutB1FDoorCallback:
	checkevent EVENT_BEAT_ROCKET_HIDEOUT_B1F_ROCKET_5
	iftrue .open
	changeblock 24, 16, $54 ; shut door
	endcallback

.open
	changeblock 24, 16, $0e ; floor
	endcallback

RocketHideoutB1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; Kanto hack (M6 9w): Yellow's warp table, tile for tile.  Warps 1 and 4 are
; the two staircases down to B2F, 2 is the staircase back up to the GAME
; CORNER (9u), 3 and 5 are the lift doors.  The elevator's own warps are -1,
; so which floor they land on is whatever the lift panel last chose.
	warp_event 23,  2, ROCKET_HIDEOUT_B2F, 1
	warp_event 21,  2, CELADON_GAME_CORNER, 3
	warp_event 24, 19, ROCKET_HIDEOUT_ELEVATOR, 1
	warp_event 21, 24, ROCKET_HIDEOUT_B2F, 4
	warp_event 25, 19, ROCKET_HIDEOUT_ELEVATOR, 2

	def_coord_events

	def_bg_events

	def_object_events
