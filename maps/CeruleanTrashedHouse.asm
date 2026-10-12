; 6c: Yellow's CERULEAN_TRASHED_HOUSE, the robbed house whose back wall the
; Rocket thief smashed through (vendor/pokeyellow/scripts/CeruleanTrashedHouse.asm
; + text/CeruleanTrashedHouse.asm).
;
; CH1 (docs/M3-CERULEAN.md "## CH1 findings"): the room is now Yellow's own
; .blk on TILESET_KANTO_HOUSE (Yellow's HOUSE tileset, scripts/
; kanto_house_blk.py) -- footprints, junk and the broken gap in the back wall --
; instead of 6a's shared House1Hole.blk, which put a staircase-looking LADDER
; at (2,0).  So the hole, its warp and its bg_event are back at Yellow's (3,0),
; and the fishing guru is back at Yellow's (2,1), beside it (6a had mirrored
; him to (3,1) only because the hole had moved one tile left).
	object_const_def
	const CERULEANTRASHEDHOUSE_FISHING_GURU
	const CERULEANTRASHEDHOUSE_GIRL

CeruleanTrashedHouse_MapScripts:
	def_scene_scripts
	scene_script CeruleanTrashedHouseHealScene ; scene 0, the only one

	def_callbacks
	callback MAPCALLBACK_CMDQUEUE, CeruleanTrashedHouseSceneCallback

CeruleanTrashedHouseSceneCallback:
	callasm CeruleanPassHouseFindScene
	endcallback

CeruleanTrashedHouseHealScene:
	callasm CeruleanPassHouseHealStaleBlocks
	iffalse .guru
	refreshmap
.guru
; A pre-CH1 save also carries 6a's guru position, (3,1) -- right under the
; hole, where he would block the back exit until the next map load.  Put him
; back on Yellow's (2,1) as soon as the player is not standing there.
	callasm CeruleanTrashedHouseGuruStale
	iffalse .done
	disappear CERULEANTRASHEDHOUSE_FISHING_GURU
	moveobject CERULEANTRASHEDHOUSE_FISHING_GURU, 2, 1
	appear CERULEANTRASHEDHOUSE_FISHING_GURU
.done
	end

; CH1 save compatibility, BillsHouseHealStaleBlocks (hack/maps/BillsHouse.asm,
; docs/M3-CERULEAN.md "## BH1 findings") shared by both Cerulean pass-through
; houses.  A game saved INSIDE either house before CH1 carries the old
; House1Hole room's TILESET_HOUSE block ids in wScreenSave (the 6x5 blocks round
; the player are part of the saved map data), and MapSetupScript_Continue
; writes them back over the freshly loaded .blk (LoadConnectionBlockData).  On
; the new tilesets those ids are wrong art and wrong collision, and the back
; exit is not a warp.  Neither map ever edits its own blocks (no changeblock),
; so any difference from the ROM .blk is stale: reload the blocks, re-buffer
; wScreenSave so the next save is clean, and redraw.  Costs a 16-byte compare
; per overworld frame in these two rooms.
	assert CERULEAN_TRASHED_HOUSE_WIDTH == CERULEAN_BADGE_HOUSE_WIDTH
	assert CERULEAN_TRASHED_HOUSE_HEIGHT == CERULEAN_BADGE_HOUSE_HEIGHT
CeruleanPassHouseHealStaleBlocks::
	xor a
	ld [wScriptVar], a
	ld hl, wOverworldMapBlocks + (CERULEAN_TRASHED_HOUSE_WIDTH + 6) * 3 + 3
	ld a, [wMapBlocksPointer]
	ld e, a
	ld a, [wMapBlocksPointer + 1]
	ld d, a
	ld c, CERULEAN_TRASHED_HOUSE_HEIGHT
.row
	ld b, CERULEAN_TRASHED_HOUSE_WIDTH
.col
	push hl
	ld h, d
	ld l, e
	ld a, [wMapBlocksBank]
	call GetFarByte
	pop hl
	cp [hl]
	jr nz, .heal
	inc de
	inc hl
	dec b
	jr nz, .col
	ld a, l
	add 6
	ld l, a
	jr nc, .next
	inc h
.next
	dec c
	jr nz, .row
	ret

.heal
	call LoadBlockData
	call BufferScreen
	ld a, TRUE
	ld [wScriptVar], a
	ret

; A pre-CH1 save made inside either house also carries wCurMapSceneScriptPointer
; = 0: these maps had no scene_var then, and that pointer lives in the saved
; player data.  Only HandleNewMap (a warp or connection) refreshes it;
; MapSetupScript_Continue goes straight to HandleContinueMap, so without this
; the heal scene above would never run on Continue (CheckScenes returns -1).
; HandleContinueMap's MAPCALLBACK_CMDQUEUE runs on both paths, so re-derive the
; pointer there.  On a normal entry HandleNewMap has just done the same thing,
; so the second call is a no-op.
CeruleanPassHouseFindScene::
	jp GetCurrentMapSceneID

; The guru's map object is saved too (MapSetupScript_Continue loads the map
; with LoadMapAttributes_SkipObjects), so a pre-CH1 save keeps him on (3,1).
; TRUE while he is still there and the player is off (2,1); a save made on (2,1)
; itself re-checks every frame and he moves once the player steps away.  Never
; TRUE on a post-CH1 save: the object_event puts him on (2,1) and he is
; SPRITEMOVEDATA_STANDING_DOWN.
CeruleanTrashedHouseGuruStale:
	xor a
	ld [wScriptVar], a
	ld a, [wMap1ObjectXCoord] ; CERULEANTRASHEDHOUSE_FISHING_GURU is map object 1
	cp 3 + 4
	ret nz
	ld a, [wMap1ObjectYCoord]
	cp 1 + 4
	ret nz
	ld a, [wXCoord]
	cp 2
	jr nz, .stale
	ld a, [wYCoord]
	cp 1
	ret z
.stale
	ld a, TRUE
	ld [wScriptVar], a
	ret

CeruleanTrashedHouseFishingGuruScript:
	faceplayer
	opentext
	checkitem TM_DIG
	iftrue .GotItBack
	writetext CeruleanTrashedHouseFishingGuruTheyStoleATMText
	waitbutton
	closetext
	end

.GotItBack:
	writetext CeruleanTrashedHouseFishingGuruWhatsLostIsLostText
	waitbutton
	closetext
	end

CeruleanTrashedHouseGirlScript:
	jumptextfaceplayer CeruleanTrashedHouseGirlText

CeruleanTrashedHouseWallHole:
	jumptext CeruleanTrashedHouseWallHoleText

CeruleanTrashedHouseFishingGuruTheyStoleATMText:
	text "Those miserable"
	line "ROCKETs!"

	para "Look what they"
	line "did here!"

	para "They stole a TM"
	line "for teaching"
	cont "#MON how to"
	cont "DIG holes!"

	para "That cost me a"
	line "bundle, it did!"
	done

CeruleanTrashedHouseFishingGuruWhatsLostIsLostText:
	text "I figure what's"
	line "lost is lost!"

	para "I decided to teach"
	line "DIGLETT how to"
	cont "DIG without a TM!"
	done

CeruleanTrashedHouseGirlText:
	text "TEAM ROCKET must"
	line "be trying to DIG"
	cont "their way into no"
	cont "good!"
	done

CeruleanTrashedHouseWallHoleText:
	text "TEAM ROCKET left"
	line "a way out!"
	done

; BG1Q1 (docs/BG1-BENCH-AND-SHELVES.md): Yellow prints BookOrSculptureText
; ("Crammed full of / #MON books!") facing UP on (0,1), (1,1)
; (engine/events/hidden_events/bookshelves.asm).  Every other bookshelf/TV/
; radio square here is silent, as in Yellow (engine/events/std_collision.asm).
CeruleanTrashedHouseBG1Q1Bookshelf:
	jumpstd PictureBookshelfScript

CeruleanTrashedHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, CERULEAN_CITY, 1
	warp_event  3,  7, CERULEAN_CITY, 1
	warp_event  3,  0, CERULEAN_CITY, 8 ; hole in the back wall (CH1: Yellow's 3, 0)

	def_coord_events

	def_bg_events
	bg_event  0,  1, BGEVENT_UP, CeruleanTrashedHouseBG1Q1Bookshelf ; BG1Q1
	bg_event  1,  1, BGEVENT_UP, CeruleanTrashedHouseBG1Q1Bookshelf ; BG1Q1
	bg_event  3,  0, BGEVENT_READ, CeruleanTrashedHouseWallHole

	def_object_events
	object_event  2,  1, SPRITE_FISHING_GURU, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeruleanTrashedHouseFishingGuruScript, -1
	object_event  5,  6, SPRITE_LASS, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeruleanTrashedHouseGirlScript, -1
