; SEAFOAM ISLANDS 1F.  Geometry cut from Yellow by scripts/seafoam_blk.py
; (M9 12d); warps, boulders and hidden items by 12e.
;
; Warps 1-7 are Yellow's own list, at Yellow's coordinates and in Yellow's
; order (vendor/pokeyellow/data/maps/objects/SeafoamIslands1F.asm), so every
; pair round-trips on Yellow's numbering.  Warps 8-9 are new: Yellow handles
; a hole with `IsPlayerOnDungeonWarp` + a DungeonWarpData landing coordinate,
; GSC handles it with an ordinary warp_event on the COLL_PIT tile pointing at
; an inert anchor warp on the floor below, which is what Crystal's own ICE
; PATH does.  The landing coordinates are Yellow's
; (vendor/pokeyellow/data/maps/special_warps.asm).
;
; The two boulders are Yellow's, and the hole mechanic is Crystal's
; CMDQUEUE_STONETABLE (engine/overworld/cmd_queue.asm, home/stone_queue.asm):
; when a SPRITEMOVEDATA_STRENGTH_BOULDER comes to rest on a pit tile that is
; also a warp_event, the (warp id, object) pair in .StoneTable runs its script.
; Zero engine bytes.  The script hides the boulder here and clears the HIDE
; flag of its twin on B1F, which is Yellow's HideObject/ShowObject pair.

	object_const_def
	const SEAFOAMISLANDS1F_BOULDER1
	const SEAFOAMISLANDS1F_BOULDER2

SeafoamIslands1F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_CMDQUEUE, SeafoamIslands1FSetUpStoneTableCallback

SeafoamIslands1FSetUpStoneTableCallback:
	writecmdqueue .CommandQueue
	endcallback

.CommandQueue:
	cmdqueue CMDQUEUE_STONETABLE, .StoneTable

.StoneTable:
	stonetable 8, SEAFOAMISLANDS1F_BOULDER1, .Boulder1
	stonetable 9, SEAFOAMISLANDS1F_BOULDER2, .Boulder2
	db -1 ; end

.Boulder1:
	disappear SEAFOAMISLANDS1F_BOULDER1
	clearevent EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B1F_1
	setevent EVENT_SEAFOAM_ISLANDS_1F_BOULDER_1_DOWN_HOLE
	sjump .FinishBoulder

.Boulder2:
	disappear SEAFOAMISLANDS1F_BOULDER2
	clearevent EVENT_BOULDER_IN_SEAFOAM_ISLANDS_B1F_2
	setevent EVENT_SEAFOAM_ISLANDS_1F_BOULDER_2_DOWN_HOLE
	sjump .FinishBoulder

; Yellow's boulder simply vanishes -- no sound, no earthquake and no "the
; boulder fell through." box (ICE PATH's GSC script has all three).  Faithful
; wins: the pause is only there so the sprite is not yanked mid-step.
.FinishBoulder:
	pause 15
	end

SeafoamIslands1FBoulder:
	jumpstd StrengthBoulderScript

SeafoamIslands1F_MapEvents:
	db 0, 0 ; filler

	; Yellow's warps 1-4: each ROUTE 20 mouth is two tiles wide, both halves
	; of the WARP_CARPET_DOWN pair on cave metatile $40 (cavern block $24).
	def_warp_events
	warp_event  4, 17, ROUTE_20, 1
	warp_event  5, 17, ROUTE_20, 1
	warp_event 26, 17, ROUTE_20, 2
	warp_event 27, 17, ROUTE_20, 2
	warp_event  7,  5, SEAFOAM_ISLANDS_B1F, 2
	warp_event 25,  3, SEAFOAM_ISLANDS_B1F, 7
	warp_event 23, 15, SEAFOAM_ISLANDS_B1F, 5
	warp_event 17,  6, SEAFOAM_ISLANDS_B1F, 8 ; hole
	warp_event 24,  6, SEAFOAM_ISLANDS_B1F, 9 ; hole

	def_coord_events

	def_bg_events

	def_object_events
	object_event 18, 10, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslands1FBoulder, EVENT_BOULDER_IN_SEAFOAM_ISLANDS_1F_1
	object_event 26,  7, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslands1FBoulder, EVENT_BOULDER_IN_SEAFOAM_ISLANDS_1F_2
