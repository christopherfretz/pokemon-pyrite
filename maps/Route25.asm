	object_const_def
	const ROUTE25_YOUNGSTER1
	const ROUTE25_YOUNGSTER2
	const ROUTE25_COOLTRAINER_M
	const ROUTE25_COOLTRAINER_F1
	const ROUTE25_YOUNGSTER3
	const ROUTE25_COOLTRAINER_F2
	const ROUTE25_HIKER1
	const ROUTE25_HIKER2
	const ROUTE25_HIKER3
	const ROUTE25_TM_ROCK_SMASH

; Kanto hack: Yellow's Route 25, the cape trail up to Bill's Sea Cottage
; (docs/M3-CERULEAN.md 6i).  6a re-cut the map from Yellow's own .blk
; (hack/maps/Route25.blk is a block-id translation of
; vendor/pokeyellow/maps/Route25.blk), so every Yellow object coordinate
; transfers 1:1 with no offset; each tile was re-checked on
; `scripts/mapgrid.py Route25`.  Objects, facings, sight ranges and text are
; Yellow's (vendor/pokeyellow/data/maps/objects/Route25.asm, the
; Route25TrainerHeaders sight ranges in vendor/pokeyellow/scripts/Route25.asm,
; and vendor/pokeyellow/text/Route25.asm).
;
; Yellow's anonymous trainers get GSC names and Crystal classes
; (docs/M3-CERULEAN.md 5): YOUNGSTER -> YOUNGSTER, LASS -> LASS,
; JR_TRAINER_M -> CAMPER (Crystal has no JR.TRAINER), HIKER -> HIKER.
; Crystal has no SPRITE_HIKER, so the three hikers use SPRITE_POKEFAN_M, as
; Mt. Moon 1F's HIKER MARCOS already does (docs/M2-MTMOON.md 5c).  Yellow
; draws its two Route 25 lasses with SPRITE_COOLTRAINER_F; we keep that, the
; same call 6h made for Nugget Bridge's NORMA and PAULINE.
;
; Item substitution (docs/M3-CERULEAN.md 0.8 / 2): Yellow's TM39 SEISMIC TOSS
; has no Crystal equivalent, so the ball at (22,2) gives TM08 ROCK_SMASH.
;
; DELETED here (all Crystal content, none of it Yellow's):
;   * Crystal's eight trainers (SCHOOLBOY DUDLEY/JOE, LASS ELLEN/LAURA/SHANNON,
;     CAMPER LLOYD, SUPER_NERD PAT, COOLTRAINERM KEVIN - the Johto-side Nugget
;     Bridge "six-pack", whose real Yellow home is Route 24, shipped in 6h);
;   * Route25Protein, the PROTEIN itemball at (32,4);
;   * the SCENE_ROUTE25_MISTYS_DATE coord_events at (42,6)/(42,7), both Misty's
;     date scene scripts and the MISTY / boyfriend objects at (46,9)/(46,10).
;     That scene was the only thing in the game that cleared
;     EVENT_TRAINERS_IN_CERULEAN_GYM, which InitializeEventsScript sets at new
;     game - 6e had already rebuilt the gym with always-visible (-1) objects
;     because of it.  Its two stale `setevent`s in InitializeEventsScript
;     (EVENT_ROUTE_25_MISTY_BOYFRIEND, EVENT_TRAINERS_IN_CERULEAN_GYM) are
;     deleted with it; both flags are now dead and free to rename.
;     `SCENE_ROUTE25_NOOP`/`SCENE_ROUTE25_MISTYS_DATE` are gone too - unlike
;     CERULEAN_GYM's scene (6e.2) nothing outside this file named them.  The
;     `scene_var ROUTE_25` row in data/maps/scenes.asm and `wRoute25SceneID`
;     stay put so the WRAM layout is unchanged; an empty def_scene_scripts
;     leaves wCurMapSceneScriptCount at 0 and RunSceneScript bails immediately.
;
; KEPT from Crystal: the hidden POTION at (4,5).  Yellow's Route 25 has no
; hidden item, but docs/M3-CERULEAN.md 2/6 both list it as staying, it costs
; no flag beyond the one it already owns, and the grass tile it sits on is
; still grass after the re-cut.
;
; 6j: Bill's House is NOT touched here - the warp at (45,3) into BILLS_HOUSE
; and the Sea Cottage sign at (43,3) are all Route 25 owes it.  Bill's cutscene
; (hack/maps/BillsHouse.asm) sets EVENT_CERULEAN_GUARDS_STAND_ASIDE as he hands
; over the S.S. TICKET, which is what unblocks Cerulean's trashed house (6c,
; docs/M3-CERULEAN.md 6c.1).
;
; 6j also owns Yellow's Route25ToggleBillsScript.  Three of the four things it
; does are BILLS_HOUSE's own business and live in BillsHouseObjectsCallback
; (reset EVENT_BILL_SAID_USE_CELL_SEPARATOR, re-show BILL-as-#MON, swap BILL 1
; for BILL 2).  The fourth is cross-map and is the callback below: once you
; leave Bill's house with the ticket, Yellow HideObjects
; TOGGLE_NUGGET_BRIDGE_GUY, which
; vendor/pokeyellow/data/maps/toggleable_objects.asm resolves to
; ROUTE24_COOLTRAINER_M1 - the Rocket who ambushes you at the top of Nugget
; Bridge on Route 24, not anything on Route 25 (Route 25's only toggleable
; object is its TM ball, and nothing ever toggles it).  6h already keeps that
; Rocket on the bridge after he is beaten, on purpose - Yellow gives him a
; "the top leader" line and our Route24 object is a plain always-visible
; object with no hide flag - so there is deliberately nothing to hide and the
; callback only re-derives Route 25's own scene.
Route25_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_OBJECTS, Route25ObjectsCallback

; Route 25 has no objects left whose visibility depends on Bill (see above),
; so this only pins the scene to 0.  It exists as the documented hook: the
; `scene_var ROUTE_25` row and wRoute25SceneID survive from Crystal (6i), and
; an empty def_scene_scripts means wCurMapSceneScriptCount is 0 and
; RunSceneScript bails immediately, so scene 0 is the only legal value.
Route25ObjectsCallback:
	setscene 0
	endcallback

TrainerYoungsterGrant:
	trainer YOUNGSTER, GRANT, EVENT_BEAT_YOUNGSTER_GRANT, YoungsterGrantSeenText, YoungsterGrantBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext YoungsterGrantAfterBattleText
	waitbutton
	closetext
	end

TrainerYoungsterElmer:
	trainer YOUNGSTER, ELMER, EVENT_BEAT_YOUNGSTER_ELMER, YoungsterElmerSeenText, YoungsterElmerBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext YoungsterElmerAfterBattleText
	waitbutton
	closetext
	end

TrainerCamperWendell:
	trainer CAMPER, WENDELL, EVENT_BEAT_CAMPER_WENDELL, CamperWendellSeenText, CamperWendellBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext CamperWendellAfterBattleText
	waitbutton
	closetext
	end

TrainerLassJodie:
	trainer LASS, JODIE, EVENT_BEAT_LASS_JODIE, LassJodieSeenText, LassJodieBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassJodieAfterBattleText
	waitbutton
	closetext
	end

TrainerYoungsterOscar:
	trainer YOUNGSTER, OSCAR, EVENT_BEAT_YOUNGSTER_OSCAR, YoungsterOscarSeenText, YoungsterOscarBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext YoungsterOscarAfterBattleText
	waitbutton
	closetext
	end

TrainerLassTessa:
	trainer LASS, TESSA, EVENT_BEAT_LASS_TESSA, LassTessaSeenText, LassTessaBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassTessaAfterBattleText
	waitbutton
	closetext
	end

TrainerHikerGraham:
	trainer HIKER, GRAHAM, EVENT_BEAT_HIKER_GRAHAM, HikerGrahamSeenText, HikerGrahamBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext HikerGrahamAfterBattleText
	waitbutton
	closetext
	end

TrainerHikerArchie:
	trainer HIKER, ARCHIE, EVENT_BEAT_HIKER_ARCHIE, HikerArchieSeenText, HikerArchieBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext HikerArchieAfterBattleText
	waitbutton
	closetext
	end

TrainerHikerMorton:
	trainer HIKER, MORTON, EVENT_BEAT_HIKER_MORTON, HikerMortonSeenText, HikerMortonBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext HikerMortonAfterBattleText
	waitbutton
	closetext
	end

Route25TMRockSmash:
	itemball TM_ROCK_SMASH

BillsHouseSign:
	jumptext BillsHouseSignText

Route25HiddenPotion:
	hiddenitem POTION, EVENT_ROUTE_25_HIDDEN_POTION

YoungsterGrantSeenText:
	text "Local trainers"
	line "come here to"
	cont "practice!"
	done

YoungsterGrantBeatenText:
	text "You're"
	line "decent."
	done

YoungsterGrantAfterBattleText:
	text "All #MON have"
	line "weaknesses. It's"
	cont "best to raise"
	cont "different kinds."
	done

YoungsterElmerSeenText:
	text "Dad took me to a"
	line "great party on"
	cont "S.S.ANNE at"
	cont "VERMILION CITY!"
	done

YoungsterElmerBeatenText:
	text "I'm"
	line "not mad!"
	done

YoungsterElmerAfterBattleText:
	text "On S.S.ANNE, I"
	line "saw trainers from"
	cont "around the world."
	done

CamperWendellSeenText:
	text "I'm a cool guy."
	line "I've got a girl"
	cont "friend!"
	done

CamperWendellBeatenText:
	text "Aww,"
	line "darn…"
	done

CamperWendellAfterBattleText:
	text "Oh well. My girl"
	line "will cheer me up."
	done

LassJodieSeenText:
	text "Hi! My boy"
	line "friend is cool!"
	done

LassJodieBeatenText:
	text "I'm in"
	line "a slump!"
	done

LassJodieAfterBattleText:
	text "I wish my guy was"
	line "as good as you!"
	done

YoungsterOscarSeenText:
	text "I knew I had to"
	line "fight you!"
	done

YoungsterOscarBeatenText:
	text "I knew"
	line "I'd lose too!"
	done

YoungsterOscarAfterBattleText:
	text "If your #MON"
	line "gets confused or"
	cont "falls asleep,"
	cont "switch it!"
	done

LassTessaSeenText:
	text "My friend has a"
	line "cute #MON."
	cont "I'm so jealous!"
	done

LassTessaBeatenText:
	text "I'm"
	line "not so jealous!"
	done

LassTessaAfterBattleText:
	text "You came from MT."
	line "MOON? May I have"
	cont "a CLEFAIRY?"
	done

HikerGrahamSeenText:
	text "I just got down"
	line "from MT.MOON,"
	cont "but I'm ready!"
	done

HikerGrahamBeatenText:
	text "You"
	line "worked hard!"
	done

HikerGrahamAfterBattleText:
	text "Drat!"
	line "A ZUBAT bit me"
	cont "back in there."
	done

HikerArchieSeenText:
	text "I'm off to see a"
	line "#MON collector"
	cont "at the cape!"
	done

HikerArchieBeatenText:
	text "You"
	line "got me."
	done

HikerArchieAfterBattleText:
	text "The collector has"
	line "many rare kinds"
	cont "of #MON."
	done

HikerMortonSeenText:
	text "You're going to"
	line "see BILL? First,"
	cont "let's fight!"
	done

HikerMortonBeatenText:
	text "You're"
	line "something."
	done

HikerMortonAfterBattleText:
	text "The trail below"
	line "is a shortcut to"
	cont "CERULEAN CITY."
	done

BillsHouseSignText:
	text "SEA COTTAGE"
	line "BILL lives here!"
	done

Route25_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 45,  3, BILLS_HOUSE, 1 ; 6a: Yellow's door tile (was 47, 5)

	def_coord_events

	def_bg_events
	bg_event 43,  3, BGEVENT_READ, BillsHouseSign ; 6a: was 45, 5
	bg_event  4,  5, BGEVENT_ITEM, Route25HiddenPotion

; Yellow's ten objects, in Yellow's order, on Yellow's tiles.  The trailing
; number before the script label is the sight range, taken from Yellow's
; Route25TrainerHeaders (2,3,3,2,4,4,3,2,2).
	def_object_events
	object_event 14,  2, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, TrainerYoungsterGrant, -1
	object_event 18,  5, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerYoungsterElmer, -1
	object_event 24,  4, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 3, TrainerCamperWendell, -1
	object_event 18,  8, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 2, TrainerLassJodie, -1
	object_event 32,  3, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 4, TrainerYoungsterOscar, -1
	object_event 37,  4, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 4, TrainerLassTessa, -1
	object_event  8,  4, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerHikerGraham, -1
	object_event 23,  9, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 2, TrainerHikerArchie, -1
	object_event 13,  7, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 2, TrainerHikerMorton, -1
	object_event 22,  2, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route25TMRockSmash, EVENT_ROUTE_25_TM_ROCK_SMASH
