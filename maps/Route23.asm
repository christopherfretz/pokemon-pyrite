; Kanto hack (M10 13e-1, docs/M10-INDIGO.md "## 13e-1 findings"): Yellow's
; ROUTE 23 (vendor/pokeyellow/data/maps/objects/Route23.asm, scripts/Route23.asm,
; text/Route23.asm), 10x72 on TILESET_KANTO_PLATEAU.  Crystal's ROUTE_23 map is
; INDIGO_PLATEAU now (renamed in 13e-1).
;
; The seven badge guards.  Yellow keeps one EVENT_PASSED_*BADGE_CHECK flag per
; guard and tests the player's row against Route23GuardsYCoords on every step
; (row 35 only for x < 14): the first time the row is entered it prints the
; check, then either refuses (SFX_DENIED, player stepped DOWN) or passes
; (item jingle) and sets the flag, so each check is shown exactly once.  The
; checks can only be met in one order (each row seals the route: the lake rows
; 72-103 are bounded, the row-35 pocket x 0-7 leads north only by VICTORY
; ROAD's (4,31) door, and x >= 14 is VICTORY ROAD 2F's exit), so here the seven
; flags are one counter: wRoute23SceneID = number of checks passed, 0-7.  A
; row's coord_events fire only while the scene equals that row's index, which
; is exactly "the flag is clear" -- no flags, no re-trigger on a passed row.
;
; A refused check steps the player DOWN (Yellow's simulated PAD_DOWN).  On row
; 119 the only tiles with a walkable tile below are x = 8/9 (the way up); on
; the others Yellow's simulated DOWN just bumps the wall, so ours only turns
; DOWN.  Talking to a guard re-runs his check, as Yellow's talk does; a talk
; refusal can only come from the tile below him, so it steps DOWN too.
Route23_MapScripts:
	def_scene_scripts
	scene_script Route23NoopScene, SCENE_ROUTE23_CASCADE_CHECK ; 0
	scene_script Route23NoopScene, SCENE_ROUTE23_THUNDER_CHECK
	scene_script Route23NoopScene, SCENE_ROUTE23_RAINBOW_CHECK
	scene_script Route23NoopScene, SCENE_ROUTE23_SOUL_CHECK
	scene_script Route23NoopScene, SCENE_ROUTE23_MARSH_CHECK
	scene_script Route23NoopScene, SCENE_ROUTE23_VOLCANO_CHECK
	scene_script Route23NoopScene, SCENE_ROUTE23_EARTH_CHECK
	scene_script Route23NoopScene, SCENE_ROUTE23_ALL_PASSED

	def_callbacks

Route23NoopScene:
	end

; row 136: CASCADEBADGE (Yellow's GUARD)
Route23CascadeCheckStepScript:
	getstring STRING_BUFFER_3, Route23CascadeBadgeName
	checkflag ENGINE_CASCADEBADGE
	iffalse Route23RefuseStepScript
	setscene SCENE_ROUTE23_THUNDER_CHECK
	sjump Route23PassScript

Route23CascadeGuardScript:
	faceplayer
	getstring STRING_BUFFER_3, Route23CascadeBadgeName
	checkflag ENGINE_CASCADEBADGE
	iffalse Route23RefuseStepScript
	checkscene
	ifnotequal SCENE_ROUTE23_CASCADE_CHECK, Route23PassScript
	setscene SCENE_ROUTE23_THUNDER_CHECK
	sjump Route23PassScript

; row 119: THUNDERBADGE (Yellow's GUARD)
Route23ThunderCheckStepScript:
	getstring STRING_BUFFER_3, Route23ThunderBadgeName
	checkflag ENGINE_THUNDERBADGE
	iffalse Route23RefuseStepScript
	setscene SCENE_ROUTE23_RAINBOW_CHECK
	sjump Route23PassScript

Route23ThunderCheckTurnScript:
	getstring STRING_BUFFER_3, Route23ThunderBadgeName
	checkflag ENGINE_THUNDERBADGE
	iffalse Route23RefuseTurnScript
	setscene SCENE_ROUTE23_RAINBOW_CHECK
	sjump Route23PassScript

Route23ThunderGuardScript:
	faceplayer
	getstring STRING_BUFFER_3, Route23ThunderBadgeName
	checkflag ENGINE_THUNDERBADGE
	iffalse Route23RefuseStepScript
	checkscene
	ifnotequal SCENE_ROUTE23_THUNDER_CHECK, Route23PassScript
	setscene SCENE_ROUTE23_RAINBOW_CHECK
	sjump Route23PassScript

; row 105: RAINBOWBADGE (Yellow's GUARD)
Route23RainbowCheckStepScript:
	getstring STRING_BUFFER_3, Route23RainbowBadgeName
	checkflag ENGINE_RAINBOWBADGE
	iffalse Route23RefuseStepScript
	setscene SCENE_ROUTE23_SOUL_CHECK
	sjump Route23PassScript

Route23RainbowGuardScript:
	faceplayer
	getstring STRING_BUFFER_3, Route23RainbowBadgeName
	checkflag ENGINE_RAINBOWBADGE
	iffalse Route23RefuseStepScript
	checkscene
	ifnotequal SCENE_ROUTE23_RAINBOW_CHECK, Route23PassScript
	setscene SCENE_ROUTE23_SOUL_CHECK
	sjump Route23PassScript

; row 96: SOULBADGE (Yellow's GUARD)
Route23SoulCheckStepScript:
	getstring STRING_BUFFER_3, Route23SoulBadgeName
	checkflag ENGINE_SOULBADGE
	iffalse Route23RefuseStepScript
	setscene SCENE_ROUTE23_MARSH_CHECK
	sjump Route23PassScript

Route23SoulGuardScript:
	faceplayer
	getstring STRING_BUFFER_3, Route23SoulBadgeName
	checkflag ENGINE_SOULBADGE
	iffalse Route23RefuseStepScript
	checkscene
	ifnotequal SCENE_ROUTE23_SOUL_CHECK, Route23PassScript
	setscene SCENE_ROUTE23_MARSH_CHECK
	sjump Route23PassScript

; row 85: MARSHBADGE (Yellow's GUARD)
Route23MarshCheckStepScript:
	getstring STRING_BUFFER_3, Route23MarshBadgeName
	checkflag ENGINE_MARSHBADGE
	iffalse Route23RefuseStepScript
	setscene SCENE_ROUTE23_VOLCANO_CHECK
	sjump Route23PassScript

Route23MarshGuardScript:
	faceplayer
	getstring STRING_BUFFER_3, Route23MarshBadgeName
	checkflag ENGINE_MARSHBADGE
	iffalse Route23RefuseStepScript
	checkscene
	ifnotequal SCENE_ROUTE23_MARSH_CHECK, Route23PassScript
	setscene SCENE_ROUTE23_VOLCANO_CHECK
	sjump Route23PassScript

; row 56: VOLCANOBADGE (Yellow's GUARD)
Route23VolcanoCheckStepScript:
	getstring STRING_BUFFER_3, Route23VolcanoBadgeName
	checkflag ENGINE_VOLCANOBADGE
	iffalse Route23RefuseStepScript
	setscene SCENE_ROUTE23_EARTH_CHECK
	sjump Route23PassScript

Route23VolcanoGuardScript:
	faceplayer
	getstring STRING_BUFFER_3, Route23VolcanoBadgeName
	checkflag ENGINE_VOLCANOBADGE
	iffalse Route23RefuseStepScript
	checkscene
	ifnotequal SCENE_ROUTE23_VOLCANO_CHECK, Route23PassScript
	setscene SCENE_ROUTE23_EARTH_CHECK
	sjump Route23PassScript

; row 35: EARTHBADGE (Yellow's GUARD)
Route23EarthCheckStepScript:
	getstring STRING_BUFFER_3, Route23EarthBadgeName
	checkflag ENGINE_EARTHBADGE
	iffalse Route23RefuseStepScript
	setscene SCENE_ROUTE23_ALL_PASSED
	sjump Route23PassScript

Route23EarthGuardScript:
	faceplayer
	getstring STRING_BUFFER_3, Route23EarthBadgeName
	checkflag ENGINE_EARTHBADGE
	iffalse Route23RefuseStepScript
	checkscene
	ifnotequal SCENE_ROUTE23_EARTH_CHECK, Route23PassScript
	setscene SCENE_ROUTE23_ALL_PASSED
	sjump Route23PassScript

Route23RefuseStepScript:
	opentext
	writetext Route23YouDontHaveTheBadgeYetText
	playsound SFX_WRONG
	waitsfx
	waitbutton
	closetext
	applymovement PLAYER, Route23StepDownMovement
	end

; row 119 off the x = 8/9 opening: the tile below is WALL, and Yellow's
; simulated DOWN only bumps it -- the player ends facing DOWN, unmoved.
Route23RefuseTurnScript:
	opentext
	writetext Route23YouDontHaveTheBadgeYetText
	playsound SFX_WRONG
	waitsfx
	waitbutton
	closetext
	turnobject PLAYER, DOWN
	end

Route23PassScript:
	opentext
	writetext Route23OhThatIsTheBadgeText
	waitbutton
	closetext
	end

Route23StepDownMovement:
	step DOWN
	step_end

Route23VictoryRoadGateSign:
	jumptext Route23VictoryRoadGateSignText

Route23HiddenFullRestore:
	hiddenitem FULL_RESTORE, EVENT_ROUTE_23_HIDDEN_FULL_RESTORE

Route23HiddenUltraBall:
	hiddenitem ULTRA_BALL, EVENT_ROUTE_23_HIDDEN_ULTRA_BALL

Route23HiddenMaxEther:
	hiddenitem MAX_ETHER, EVENT_ROUTE_23_HIDDEN_MAX_ETHER

; Yellow's BadgeTextPointers strings, verbatim.
Route23EarthBadgeName:
	db "EARTHBADGE@"

Route23VolcanoBadgeName:
	db "VOLCANOBADGE@"

Route23MarshBadgeName:
	db "MARSHBADGE@"

Route23SoulBadgeName:
	db "SOULBADGE@"

Route23RainbowBadgeName:
	db "RAINBOWBADGE@"

Route23ThunderBadgeName:
	db "THUNDERBADGE@"

Route23CascadeBadgeName:
	db "CASCADEBADGE@"

; Yellow's _Route23YouDontHaveTheBadgeYetText, verbatim (wNameBuffer ->
; wStringBuffer3).  Yellow plays SFX_DENIED after it; ours is SFX_WRONG, as in
; VICTORY ROAD GATE (13d).
Route23YouDontHaveTheBadgeYetText:
	text "You can pass here"
	line "only if you have"
	cont "the @"
	text_ram wStringBuffer3
	text "!"

	para "You don't have the"
	line "@"
	text_ram wStringBuffer3
	text " yet!"

	para "You have to have"
	line "it to get to"
	cont "#MON LEAGUE!"
	done

; Yellow's _Route23OhThatIsTheBadgeText + sound_get_item_1 +
; _Route23GoRightAheadText, verbatim.
Route23OhThatIsTheBadgeText:
	text "You can pass here"
	line "only if you have"
	cont "the @"
	text_ram wStringBuffer3
	text "!"

	para "Oh! That is the"
	line "@"
	text_ram wStringBuffer3
	text "!@"
	sound_item
	text_start

	para "OK then! Please,"
	line "go right ahead!"
	done

; Yellow's _Route23VictoryRoadGateSignText, verbatim.
Route23VictoryRoadGateSignText:
	text "VICTORY ROAD GATE"
	line "- #MON LEAGUE"
	done

Route23_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  7, 139, VICTORY_ROAD_GATE, 5 ; Yellow: ROUTE_22_GATE, 3
	warp_event  8, 139, VICTORY_ROAD_GATE, 6 ; Yellow: ROUTE_22_GATE, 4
	; Yellow: VICTORY_ROAD_1F, 1.  13f: Crystal's VICTORY_ROAD warp 1 is the
	; gate-side mouth; its own exit back leads to VICTORY_ROAD_GATE 5.
	warp_event  4,  31, VICTORY_ROAD, 1
	; Yellow: VICTORY_ROAD_2F, 2.  Interim (13e-2): paired with Crystal's
	; VICTORY_ROAD top exit (13,5), which used to open onto the old forecourt's
	; VR mouth; 13f re-points both to Yellow's VICTORY ROAD 2F.
	warp_event 14,  31, VICTORY_ROAD, 10
	; North edge: Yellow's connection to INDIGO PLATEAU (data/maps/attributes.asm).

	def_coord_events
	; row 136, CASCADEBADGE: x 6,7,8,9
	coord_event  6, 136, SCENE_ROUTE23_CASCADE_CHECK, Route23CascadeCheckStepScript
	coord_event  7, 136, SCENE_ROUTE23_CASCADE_CHECK, Route23CascadeCheckStepScript
	coord_event  8, 136, SCENE_ROUTE23_CASCADE_CHECK, Route23CascadeCheckStepScript
	coord_event  9, 136, SCENE_ROUTE23_CASCADE_CHECK, Route23CascadeCheckStepScript
	; row 119, THUNDERBADGE: x 1,2,3,4,5,6,8,9,11,12,13,14,16,17,18
	coord_event  1, 119, SCENE_ROUTE23_THUNDER_CHECK, Route23ThunderCheckTurnScript
	coord_event  2, 119, SCENE_ROUTE23_THUNDER_CHECK, Route23ThunderCheckTurnScript
	coord_event  3, 119, SCENE_ROUTE23_THUNDER_CHECK, Route23ThunderCheckTurnScript
	coord_event  4, 119, SCENE_ROUTE23_THUNDER_CHECK, Route23ThunderCheckTurnScript
	coord_event  5, 119, SCENE_ROUTE23_THUNDER_CHECK, Route23ThunderCheckTurnScript
	coord_event  6, 119, SCENE_ROUTE23_THUNDER_CHECK, Route23ThunderCheckTurnScript
	coord_event  8, 119, SCENE_ROUTE23_THUNDER_CHECK, Route23ThunderCheckStepScript
	coord_event  9, 119, SCENE_ROUTE23_THUNDER_CHECK, Route23ThunderCheckStepScript
	coord_event 11, 119, SCENE_ROUTE23_THUNDER_CHECK, Route23ThunderCheckTurnScript
	coord_event 12, 119, SCENE_ROUTE23_THUNDER_CHECK, Route23ThunderCheckTurnScript
	coord_event 13, 119, SCENE_ROUTE23_THUNDER_CHECK, Route23ThunderCheckTurnScript
	coord_event 14, 119, SCENE_ROUTE23_THUNDER_CHECK, Route23ThunderCheckTurnScript
	coord_event 16, 119, SCENE_ROUTE23_THUNDER_CHECK, Route23ThunderCheckTurnScript
	coord_event 17, 119, SCENE_ROUTE23_THUNDER_CHECK, Route23ThunderCheckTurnScript
	coord_event 18, 119, SCENE_ROUTE23_THUNDER_CHECK, Route23ThunderCheckTurnScript
	; row 105, RAINBOWBADGE: x 10,11,12,13,14,15
	coord_event 10, 105, SCENE_ROUTE23_RAINBOW_CHECK, Route23RainbowCheckStepScript
	coord_event 11, 105, SCENE_ROUTE23_RAINBOW_CHECK, Route23RainbowCheckStepScript
	coord_event 12, 105, SCENE_ROUTE23_RAINBOW_CHECK, Route23RainbowCheckStepScript
	coord_event 13, 105, SCENE_ROUTE23_RAINBOW_CHECK, Route23RainbowCheckStepScript
	coord_event 14, 105, SCENE_ROUTE23_RAINBOW_CHECK, Route23RainbowCheckStepScript
	coord_event 15, 105, SCENE_ROUTE23_RAINBOW_CHECK, Route23RainbowCheckStepScript
	; row 96, SOULBADGE: x 8,9,10,11,12,13
	coord_event  8,  96, SCENE_ROUTE23_SOUL_CHECK, Route23SoulCheckStepScript
	coord_event  9,  96, SCENE_ROUTE23_SOUL_CHECK, Route23SoulCheckStepScript
	coord_event 10,  96, SCENE_ROUTE23_SOUL_CHECK, Route23SoulCheckStepScript
	coord_event 11,  96, SCENE_ROUTE23_SOUL_CHECK, Route23SoulCheckStepScript
	coord_event 12,  96, SCENE_ROUTE23_SOUL_CHECK, Route23SoulCheckStepScript
	coord_event 13,  96, SCENE_ROUTE23_SOUL_CHECK, Route23SoulCheckStepScript
	; row 85, MARSHBADGE: x 4,5,6,7,8,9,10,11,12,13
	coord_event  4,  85, SCENE_ROUTE23_MARSH_CHECK, Route23MarshCheckStepScript
	coord_event  5,  85, SCENE_ROUTE23_MARSH_CHECK, Route23MarshCheckStepScript
	coord_event  6,  85, SCENE_ROUTE23_MARSH_CHECK, Route23MarshCheckStepScript
	coord_event  7,  85, SCENE_ROUTE23_MARSH_CHECK, Route23MarshCheckStepScript
	coord_event  8,  85, SCENE_ROUTE23_MARSH_CHECK, Route23MarshCheckStepScript
	coord_event  9,  85, SCENE_ROUTE23_MARSH_CHECK, Route23MarshCheckStepScript
	coord_event 10,  85, SCENE_ROUTE23_MARSH_CHECK, Route23MarshCheckStepScript
	coord_event 11,  85, SCENE_ROUTE23_MARSH_CHECK, Route23MarshCheckStepScript
	coord_event 12,  85, SCENE_ROUTE23_MARSH_CHECK, Route23MarshCheckStepScript
	coord_event 13,  85, SCENE_ROUTE23_MARSH_CHECK, Route23MarshCheckStepScript
	; row 56, VOLCANOBADGE: x 6,7,8,9,10,11,12,13
	coord_event  6,  56, SCENE_ROUTE23_VOLCANO_CHECK, Route23VolcanoCheckStepScript
	coord_event  7,  56, SCENE_ROUTE23_VOLCANO_CHECK, Route23VolcanoCheckStepScript
	coord_event  8,  56, SCENE_ROUTE23_VOLCANO_CHECK, Route23VolcanoCheckStepScript
	coord_event  9,  56, SCENE_ROUTE23_VOLCANO_CHECK, Route23VolcanoCheckStepScript
	coord_event 10,  56, SCENE_ROUTE23_VOLCANO_CHECK, Route23VolcanoCheckStepScript
	coord_event 11,  56, SCENE_ROUTE23_VOLCANO_CHECK, Route23VolcanoCheckStepScript
	coord_event 12,  56, SCENE_ROUTE23_VOLCANO_CHECK, Route23VolcanoCheckStepScript
	coord_event 13,  56, SCENE_ROUTE23_VOLCANO_CHECK, Route23VolcanoCheckStepScript
	; row 35, EARTHBADGE: x 0,1,2,3,4,5,6,7
	coord_event  0,  35, SCENE_ROUTE23_EARTH_CHECK, Route23EarthCheckStepScript
	coord_event  1,  35, SCENE_ROUTE23_EARTH_CHECK, Route23EarthCheckStepScript
	coord_event  2,  35, SCENE_ROUTE23_EARTH_CHECK, Route23EarthCheckStepScript
	coord_event  3,  35, SCENE_ROUTE23_EARTH_CHECK, Route23EarthCheckStepScript
	coord_event  4,  35, SCENE_ROUTE23_EARTH_CHECK, Route23EarthCheckStepScript
	coord_event  5,  35, SCENE_ROUTE23_EARTH_CHECK, Route23EarthCheckStepScript
	coord_event  6,  35, SCENE_ROUTE23_EARTH_CHECK, Route23EarthCheckStepScript
	coord_event  7,  35, SCENE_ROUTE23_EARTH_CHECK, Route23EarthCheckStepScript

	def_bg_events
	bg_event  3,  33, BGEVENT_READ, Route23VictoryRoadGateSign
	bg_event  9,  44, BGEVENT_ITEM, Route23HiddenFullRestore
	bg_event 19,  70, BGEVENT_ITEM, Route23HiddenUltraBall
	bg_event  8,  90, BGEVENT_ITEM, Route23HiddenMaxEther

	def_object_events
	; Yellow's order: GUARD1, GUARD2, SWIMMER1, SWIMMER2, GUARD3-5
	object_event  4,  35, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route23EarthGuardScript, -1
	object_event 10,  56, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route23VolcanoGuardScript, -1
	object_event  8,  85, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route23MarshGuardScript, -1
	object_event 11,  96, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route23SoulGuardScript, -1
	object_event 12, 105, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route23RainbowGuardScript, -1
	object_event  8, 119, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route23ThunderGuardScript, -1
	object_event  8, 136, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route23CascadeGuardScript, -1
