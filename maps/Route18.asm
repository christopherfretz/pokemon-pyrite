; Kanto hack: Yellow's ROUTE 18, re-cut wholesale (docs/M6-CELADON.md, 9aa).
; Crystal's ROUTE 18 was a 10x9 stub (two invented BIRD KEEPERs, one sign, a
; west door into its own ROUTE 17/18 gate); this is Yellow's own 25x9 -- three
; BIRD KEEPERs, two signs and the two-storey gate hut that carries the CYCLING
; ROAD checkpoint.  The 9z seam stopgap in scripts/celadon_blk.py is gone with
; it: Yellow's row 0 is open road right across ROUTE 17's ledge run.
;
; Object order below is Yellow's own (data/maps/objects/Route18.asm) and the
; sight ranges are Yellow's trainer headers (scripts/Route18.asm): 3, 3, 4.
; Yellow gives ROUTE 18 no item balls and no hidden items.
;
; Class substitution: OPP_BIRD_KEEPER 8-10 -> BIRD_KEEPER 1-3 (BirdKeeperGroup
; rows 8/10/11, taken over from Crystal's never-referenced HANK and its now
; deleted BORIS/BOB).  The rows are nameless, so the battle intro reads
; "BIRD KEEPER" alone, as Gen 1 does.  Yellow draws all three with
; SPRITE_COOLTRAINER_M.
	object_const_def
	const ROUTE18_BIRD_KEEPER1
	const ROUTE18_BIRD_KEEPER2
	const ROUTE18_BIRD_KEEPER3

Route18_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_NEWMAP, Route18AlwaysOnBikeCallback

; The BICYCLE gate mechanic (docs/M6-CELADON.md 3.8, decision D38).
;
; Yellow re-arms the forced bike on the ROUTE 18 side of the gate hut:
;   force_bike_surf ROUTE_18, 33, 8
;   force_bike_surf ROUTE_18, 33, 9
; (vendor/pokeyellow/data/maps/force_bike_surf.asm) -- the two tiles you land
; on stepping out of the hut's WEST doors, i.e. the foot of CYCLING ROAD.  The
; hut is the only east-west crossing on this map, so everything west of it
; (x <= 33) is CYCLING ROAD and everything east of it is the FUCHSIA approach.
;
; GSC has no per-step hook, so this is the NEWMAP-callback version ROUTE 16
; already uses: HandleNewMap calls ResetBikeFlags before every
; MAPCALLBACK_NEWMAP (connections included), so the destination map re-asserts
; the flag itself.  Arriving at (33,8)/(33,9) from the hut's west doors, or
; walking down the north connection from ROUTE 17, both land in the box and
; set it; the east doors (40,8)/(40,9) and the FUCHSIA seam clear it.  ROUTE 18
; is flat, so ENGINE_DOWNHILL is NOT set here -- that is ROUTE 17's alone.
Route18AlwaysOnBikeCallback:
	readvar VAR_XCOORD
	ifgreater 33, .CanWalk
	setflag ENGINE_ALWAYS_ON_BIKE
	endcallback

.CanWalk:
	clearflag ENGINE_ALWAYS_ON_BIKE
	endcallback

TrainerBirdKeeper1:
	trainer BIRD_KEEPER, BIRD_KEEPER_1, EVENT_BEAT_ROUTE_18_BIRD_KEEPER_1, Route18BirdKeeper1SeenText, Route18BirdKeeper1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route18BirdKeeper1AfterBattleText
	waitbutton
	closetext
	end

TrainerBirdKeeper2:
	trainer BIRD_KEEPER, BIRD_KEEPER_2, EVENT_BEAT_ROUTE_18_BIRD_KEEPER_2, Route18BirdKeeper2SeenText, Route18BirdKeeper2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route18BirdKeeper2AfterBattleText
	waitbutton
	closetext
	end

TrainerBirdKeeper3:
	trainer BIRD_KEEPER, BIRD_KEEPER_3, EVENT_BEAT_ROUTE_18_BIRD_KEEPER_3, Route18BirdKeeper3SeenText, Route18BirdKeeper3BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext Route18BirdKeeper3AfterBattleText
	waitbutton
	closetext
	end

Route18Sign:
	jumptext Route18SignText

Route18CyclingRoadSign:
	jumptext Route18CyclingRoadSignText

Route18BirdKeeper1SeenText:
	text "I always check"
	line "every grassy area"
	cont "for new #MON."
	done

Route18BirdKeeper1BeatenText:
	text "Tch!"
	done

Route18BirdKeeper1AfterBattleText:
	text "I wish I had a"
	line "BIKE!"
	done

Route18BirdKeeper2SeenText:
	text "Kurukkoo!"
	line "How do you like"
	cont "my bird call?"
	done

Route18BirdKeeper2BeatenText:
	text "I"
	line "had to bug you!"
	done

Route18BirdKeeper2AfterBattleText:
	text "I also collect sea"
	line "#MON on"
	cont "weekends!"
	done

Route18BirdKeeper3SeenText:
	text "This is my turf!"
	line "Get out of here!"
	done

Route18BirdKeeper3BeatenText:
	text "Darn!"
	done

Route18BirdKeeper3AfterBattleText:
	text "This is my fave"
	line "#MON hunting"
	cont "area!"
	done

Route18SignText:
	text "ROUTE 18"
	line "CELADON CITY -"
	cont "FUCHSIA CITY"
	done

Route18CyclingRoadSignText:
	text "CYCLING ROAD"
	line "No pedestrians"
	cont "permitted!"
	done

Route18_MapEvents:
	db 0, 0 ; filler

	def_warp_events
; Yellow's four warps in Yellow's order: 1/2 are the hut's WEST doorway (the
; CYCLING ROAD side), 3/4 the EAST doorway (the FUCHSIA side).  Yellow points
; warps 2 and 4 at gate warps 1 and 3, not 2 and 4, exactly as here.
	warp_event 33,  8, ROUTE_17_ROUTE_18_GATE, 1
	warp_event 33,  9, ROUTE_17_ROUTE_18_GATE, 1
	warp_event 40,  8, ROUTE_17_ROUTE_18_GATE, 3
	warp_event 40,  9, ROUTE_17_ROUTE_18_GATE, 3

	def_coord_events

	def_bg_events
	bg_event 43,  7, BGEVENT_READ, Route18Sign
	bg_event 33,  5, BGEVENT_READ, Route18CyclingRoadSign

	def_object_events
	object_event 36, 11, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerBirdKeeper1, -1
	object_event 40, 15, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerBirdKeeper2, -1
	object_event 42, 13, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerBirdKeeper3, -1
