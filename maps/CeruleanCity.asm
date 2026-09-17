; 6b: Yellow's Cerulean City object list
; (vendor/pokeyellow/data/maps/objects/CeruleanCity.asm).  Crystal's own six
; objects and nine bg_events are gone; the seven statics below are Yellow's, on
; Yellow's tiles.  Yellow's other four objects belong to later sub-steps and are
; APPENDED at the end of both lists so these indexes never move:
;   6d: CERULEANCITY_RIVAL  (20,2)  -- DONE, appended below
;
; 6d: rival battle #2, Yellow's third (vendor/pokeyellow/scripts/CeruleanCity.asm,
; CeruleanCityDefaultScript's second half + CeruleanCityRivalBattleScript /
; ...RivalDefeatedScript / ...RivalCleanupScript; docs/M3-CERULEAN.md 3.2 and
; "6d findings").  The rival waits at (20,2), on the bridge planks at the south
; end of Nugget Bridge; Yellow's coord trigger CeruleanCityCoords2 =
; (20,6)/(21,6) is the pair of tiles you must cross to reach the bridge, so the
; beat cannot be skipped.  He walks three steps DOWN into your face, fights
; (Rival1Data #3), then steps around you and walks six tiles SOUTH into the city
; before vanishing -- he is on his way back from BILL's, which is what his
; after-battle text is about.
;
; 6c: the Rocket break-in (vendor/pokeyellow/scripts/CeruleanCity.asm,
; CeruleanCityDefaultScript + CeruleanCityRocketText + CeruleanCity_2.asm's
; CeruleanHideRocket; docs/M3-CERULEAN.md 3.1 and "6c findings").  The thief
; stands in the yard behind the trashed house at (30,8); Officer Jenny #2
; (27,12) physically blocks the house's front door at (27,11) and Officer Jenny
; #1 (28,12) is off the map until the guards stand aside.  Yellow's coord trigger
; CeruleanCityCoords1 = (30,7)/(30,9) force-faces the two of them and runs the
; thief's own text, which is also what talking to him does - so both paths go
; through one script here.  Losing is a plain GSC white-out: the flag is only
; set after `startbattle` returns, so the trigger re-arms exactly as Yellow's
; CeruleanCityClearScripts does.
;
; NOTE: the yard is only reachable through the trashed house's smashed back
; wall, so in Yellow (and here) the whole beat is gated behind Bill's S.S.
; Ticket, which is what moves Officer Jenny #2 off the door.  6i must
; `setevent EVENT_CERULEAN_GUARDS_STAND_ASIDE` when Bill hands the ticket over.
	object_const_def
	const CERULEANCITY_COOLTRAINER_M
	const CERULEANCITY_SUPER_NERD1
	const CERULEANCITY_SUPER_NERD2
	const CERULEANCITY_COOLTRAINER_F1
	const CERULEANCITY_ELECTRODE
	const CERULEANCITY_COOLTRAINER_F2
	const CERULEANCITY_SUPER_NERD3
	const CERULEANCITY_ROCKET
	const CERULEANCITY_GUARD1
	const CERULEANCITY_GUARD2
	const CERULEANCITY_RIVAL

CeruleanCity_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_NEWMAP, CeruleanCityFlypointCallback
	callback MAPCALLBACK_OBJECTS, CeruleanCityObjectsCallback

CeruleanCityFlypointCallback:
	setflag ENGINE_FLYPOINT_CERULEAN
	endcallback

; Yellow's guard swap (CeruleanHideRocket) is a one-shot ShowObject/HideObject
; pair, which a white-out could leave half-applied.  The durable GSC idiom
; (docs/PORTING.md 3.4) is to DERIVE both guards from one stored fact on every
; map load.  That fact is EVENT_CERULEAN_GUARDS_STAND_ASIDE, and Yellow sets it
; in two places: BillsHouse_2.asm when Bill hands over the S.S. Ticket (that is
; what unblocks the trashed house's door in the first place, and is the reason
; the thief is only reachable after Route 25 -- see "6c findings"), and
; CeruleanHideRocket after the thief is beaten.  6c owns the second; Bill's
; scene (6i) only has to `setevent` the same flag.  Guard 1 is therefore hidden
; by default even though its appended flag starts clear, and a pocket-full
; retry leaves the thief, guard 2 and the blocked door exactly as they were.
CeruleanCityObjectsCallback:
; 6d: the rival exists only until he has been beaten.  Same derivation rule as
; the guards below (and as Route22RivalCallback, docs/M2-ROUTE22.md): the stored
; fact is EVENT_BEAT_CERULEAN_RIVAL, and his object-visibility flag is recomputed
; from it on every map load, so losing the battle (a white-out) puts him back on
; the bridge with the trigger re-armed and nothing else to undo.
	checkevent EVENT_BEAT_CERULEAN_RIVAL
	iftrue .RivalGone
	clearevent EVENT_CERULEAN_RIVAL_HIDDEN
	sjump .Guards

.RivalGone:
	setevent EVENT_CERULEAN_RIVAL_HIDDEN

.Guards:
	checkevent EVENT_CERULEAN_GUARDS_STAND_ASIDE
	iftrue .GuardsAside
	setevent EVENT_CERULEAN_GUARD_1_HIDDEN
	clearevent EVENT_CERULEAN_GUARD_2_HIDDEN
	endcallback

.GuardsAside:
	clearevent EVENT_CERULEAN_GUARD_1_HIDDEN
	setevent EVENT_CERULEAN_GUARD_2_HIDDEN
	endcallback

CeruleanCityCooltrainerMScript:
	jumptextfaceplayer CeruleanCityCooltrainerMText

CeruleanCitySuperNerd1Script:
	jumptextfaceplayer CeruleanCitySuperNerd1Text

CeruleanCitySuperNerd2Script:
	jumptextfaceplayer CeruleanCitySuperNerd2Text

; Yellow picks one of three lines at random (hRandomAdd thresholds 180/100,
; i.e. 76/80/100 out of 256); GSC's `random 3` is the same idea.
CeruleanCityCooltrainerF1Script:
	faceplayer
	opentext
	random 3
	ifequal 0, .Punch
	ifequal 1, .Withdraw
	writetext CeruleanCityElectrodeSonicboomText
	waitbutton
	closetext
	end

.Punch:
	writetext CeruleanCityElectrodePunchText
	waitbutton
	closetext
	end

.Withdraw:
	writetext CeruleanCityElectrodeWithdrawText
	waitbutton
	closetext
	end

; Yellow's "ELECTRODE" gag: a SPRITE_POKE_BALL that talks.  Four lines at
; random (76/60/60/60 out of 256).
CeruleanCityElectrodeScript:
	opentext
	random 4
	ifequal 0, .Loafing
	ifequal 1, .TurnedAway
	ifequal 2, .IgnoredOrders
	writetext CeruleanCityElectrodeSnoozeText
	waitbutton
	closetext
	end

.Loafing:
	writetext CeruleanCityElectrodeLoafingText
	waitbutton
	closetext
	end

.TurnedAway:
	writetext CeruleanCityElectrodeTurnedAwayText
	waitbutton
	closetext
	end

.IgnoredOrders:
	writetext CeruleanCityElectrodeIgnoredOrdersText
	waitbutton
	closetext
	end

CeruleanCityCooltrainerF2Script:
	jumptextfaceplayer CeruleanCityCooltrainerF2Text

CeruleanCitySuperNerd3Script:
	jumptextfaceplayer CeruleanCitySuperNerd3Text

; Yellow's CeruleanCityCoords1.  wCoordIndex 1 = (30,7), i.e. the player is
; ABOVE the thief and both turn to face each other; anything else is (30,9),
; below him.  The scene id is -1 so it fires whatever CheckScenes returns
; (this map declares no scene scripts) - docs/PORTING.md 3.2.
CeruleanCityRocketSceneNorth:
	checkevent EVENT_BEAT_CERULEAN_ROCKET_THIEF
	iftrue .Done
	turnobject PLAYER, DOWN
	turnobject CERULEANCITY_ROCKET, UP
	sjump CeruleanCityRocketConfrontation

.Done:
	end

CeruleanCityRocketSceneSouth:
	checkevent EVENT_BEAT_CERULEAN_ROCKET_THIEF
	iftrue .Done
	turnobject PLAYER, UP
	turnobject CERULEANCITY_ROCKET, DOWN
	sjump CeruleanCityRocketConfrontation

.Done:
	end

; Walking up to the thief and pressing A is the same beat in Yellow (his object
; text IS the trigger text), so the object script funnels into the same place.
CeruleanCityRocketScript:
	faceplayer
	sjump CeruleanCityRocketConfrontation

CeruleanCityRocketConfrontation:
	checkevent EVENT_BEAT_CERULEAN_ROCKET_THIEF
	iftrue .GiveTM
	opentext
	writetext CeruleanCityRocketText
	waitbutton
	closetext
	winlosstext CeruleanCityRocketIGiveUpText, 0
	setlasttalked CERULEANCITY_ROCKET
	loadtrainer GRUNTM, GRUNTM_26
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_CERULEAN_ROCKET_THIEF

; Yellow gives the TM in the same breath as the defeat text, and will not let
; the thief leave until it lands - so a full TM pocket re-runs this branch on
; the next talk instead of stranding TM_DIG (verbosegiveitem prints its own
; "no room" page, docs/PORTING.md 6.1; Yellow's line follows it).
.GiveTM:
	opentext
	writetext CeruleanCityRocketIllReturnTheTMText
	promptbutton
	verbosegiveitem TM_DIG
	iffalse .NoRoom
	writetext CeruleanCityRocketBetterGetMovingText
	waitbutton
	closetext
	pause 15
	special FadeOutToBlack
	special ReloadSpritesNoPalettes
	disappear CERULEANCITY_ROCKET
	setevent EVENT_CERULEAN_GUARDS_STAND_ASIDE
	appear CERULEANCITY_GUARD1
	disappear CERULEANCITY_GUARD2
	pause 15
	special FadeInFromBlack
	end

.NoRoom:
	writetext CeruleanCityRocketNoRoomText
	waitbutton
	closetext
	end

; Yellow's CeruleanCityCoords2.  The two trigger tiles are the whole width of
; the road at the bridge's mouth, so one of them always fires.  Yellow reacts to
; which one by forcing the rival's map X to the player's column (`ld [hl], 25`
; = map x 21 + the +4 sprite-data bias) before he walks down, so that he always
; ends up directly in front of you.  GSC's `moveobject` only rewrites the
; MapObject spawn record (CopyDECoordsToMapObject, engine/overworld/player_object.asm),
; not the live object struct, so it does nothing to an already-visible NPC --
; the east trigger instead gives him one extra sideways step at the end of the
; walk-in, which looks like Yellow and needs no teleport.
CeruleanCityRivalSceneWest:
	checkevent EVENT_BEAT_CERULEAN_RIVAL
	iftrue .Done
	turnobject PLAYER, UP
	showemote EMOTE_SHOCK, CERULEANCITY_RIVAL, 15
	playmusic MUSIC_RIVAL_ENCOUNTER
	applymovement CERULEANCITY_RIVAL, CeruleanCity_RivalApproachWest
	turnobject CERULEANCITY_RIVAL, DOWN
	scall CeruleanCityRivalBattle
	applymovement CERULEANCITY_RIVAL, CeruleanCity_RivalExitEast
	sjump CeruleanCityRivalGone

.Done:
	end

CeruleanCityRivalSceneEast:
	checkevent EVENT_BEAT_CERULEAN_RIVAL
	iftrue .Done
	turnobject PLAYER, UP
	showemote EMOTE_SHOCK, CERULEANCITY_RIVAL, 15
	playmusic MUSIC_RIVAL_ENCOUNTER
	applymovement CERULEANCITY_RIVAL, CeruleanCity_RivalApproachEast
	turnobject CERULEANCITY_RIVAL, DOWN
	scall CeruleanCityRivalBattle
	applymovement CERULEANCITY_RIVAL, CeruleanCity_RivalExitWest
	sjump CeruleanCityRivalGone

.Done:
	end

; Losing is a plain GSC white-out, so nothing past `startbattle` runs, the beat
; flag stays clear and the OBJECTS callback re-arms the whole scene on the way
; back in -- exactly what Yellow's CeruleanCityClearScripts does by hand.
CeruleanCityRivalBattle:
	opentext
	writetext CeruleanCityRivalPreBattleText
	waitbutton
	closetext
	winlosstext CeruleanCityRivalDefeatedText, CeruleanCityRivalVictoryText
	setlasttalked CERULEANCITY_RIVAL
	loadtrainer KANTO_RIVAL, KANTO_RIVAL_3
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	setevent EVENT_BEAT_CERULEAN_RIVAL
	playmusic MUSIC_RIVAL_AFTER
	opentext
	writetext CeruleanCityRivalIWentToBillsText
	waitbutton
	closetext
	return

CeruleanCityRivalGone:
	disappear CERULEANCITY_RIVAL
	playmapmusic
	end

; Yellow's CeruleanCityRivalText is a text_asm that branches on
; EVENT_BEAT_CERULEAN_RIVAL, so the object carries both halves of the beat.  He
; is unreachable on foot before the trigger fires (the trigger tiles are the
; only way onto the bridge) and gone afterwards, but keep both branches.
CeruleanCityRivalScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_CERULEAN_RIVAL
	iftrue .AfterBattle
	writetext CeruleanCityRivalPreBattleText
	waitbutton
	closetext
	end

.AfterBattle:
	writetext CeruleanCityRivalIWentToBillsText
	waitbutton
	closetext
	end

; (20,2) -> (20,5), one tile above the player on (20,6).
CeruleanCity_RivalApproachWest:
	step DOWN
	step DOWN
	step DOWN
	step_end

; (20,2) -> (21,5), one tile above the player on (21,6).  Yellow teleports him
; to x=21 first and walks straight down; see the note above CeruleanCityRivalSceneWest.
CeruleanCity_RivalApproachEast:
	step DOWN
	step DOWN
	step DOWN
	step RIGHT
	step_end

; Yellow's CeruleanCityMovement4: around the player to the east, then six tiles
; south into the city.  (20,5) -> (21,5) -> (21,11).
CeruleanCity_RivalExitEast:
	step RIGHT
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step_end

; Yellow's CeruleanCityMovement3, mirrored: (21,5) -> (20,5) -> (20,11).
CeruleanCity_RivalExitWest:
	step LEFT
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	step_end

CeruleanCityGuard1Script:
	jumptextfaceplayer CeruleanCityGuardText

CeruleanCityGuard2Script:
	jumptextfaceplayer CeruleanCityGuardText

CeruleanCitySign:
	jumptext CeruleanCitySignText

CeruleanCityTrainerTips:
	jumptext CeruleanCityTrainerTipsText

CeruleanGymSign:
	jumptext CeruleanGymSignText

CeruleanBikeShopSign:
	jumptext CeruleanBikeShopSignText

CeruleanCityPokecenterSign:
	jumpstd PokecenterSignScript

CeruleanCityMartSign:
	jumpstd MartSignScript

CeruleanCityCooltrainerMText:
	text "You're a trainer"
	line "too? Collecting,"
	cont "fighting, it's a"
	cont "tough life."
	done

CeruleanCitySuperNerd1Text:
	text "That bush in"
	line "front of the shop"
	cont "is in the way."

	para "There might be a"
	line "way around."
	done

CeruleanCitySuperNerd2Text:
	text "You're making an"
	line "encyclopedia on"
	cont "#MON? That"
	cont "sounds amusing."
	done

CeruleanCityElectrodeSonicboomText:
	text "OK! ELECTRODE!"
	line "Use SONICBOOM!"
	cont "Please ELECTRODE,"
	cont "pay attention!"
	done

CeruleanCityElectrodePunchText:
	text "ELECTRODE, TACKLE!"
	line "No! You blew it"
	cont "again!"
	done

CeruleanCityElectrodeWithdrawText:
	text "ELECTRODE, SWIFT!"
	line "No! That's wrong!"

	para "Training #MON"
	line "is difficult!"

	para "Your #MON's"
	line "obedience depends"
	cont "on your abilities"
	cont "as a trainer!"
	done

CeruleanCityElectrodeSnoozeText:
	text "ELECTRODE took a"
	line "snooze…"
	done

CeruleanCityElectrodeLoafingText:
	text "ELECTRODE is"
	line "loafing around…"
	done

CeruleanCityElectrodeTurnedAwayText:
	text "ELECTRODE turned"
	line "away…"
	done

CeruleanCityElectrodeIgnoredOrdersText:
	text "ELECTRODE"
	line "ignored orders…"
	done

CeruleanCityCooltrainerF2Text:
	text "I want a bright"
	line "red BICYCLE!"

	para "I'll keep it at"
	line "home, so it won't"
	cont "get dirty!"
	done

CeruleanCitySuperNerd3Text:
	text "This is CERULEAN"
	line "CAVE! Horribly"
	cont "strong #MON"
	cont "live in there!"

	para "The #MON LEAGUE"
	line "champion is the"
	cont "only person who"
	cont "is allowed in!"
	done

CeruleanCityRocketText:
	text "Hey! Stay out!"
	line "It's not your"
	cont "yard! Huh? Me?"

	para "I'm an innocent"
	line "bystander! Don't"
	cont "you believe me?"
	done

CeruleanCityRocketIGiveUpText:
	text "Stop!"
	line "I give up! I'll"
	cont "leave quietly!"
	done

CeruleanCityRocketIllReturnTheTMText:
	text "OK! I'll return"
	line "the TM I stole!"
	done

CeruleanCityRocketBetterGetMovingText:
	text "I better get"
	line "moving! Bye!"
	done

CeruleanCityRocketNoRoomText:
	text "Make room for"
	line "this!"

	para "I can't run until"
	line "I give it to you!"
	done

CeruleanCityRivalPreBattleText:
	text "<RIVAL>: Yo!"
	line "<PLAYER>!"

	para "You're still"
	line "struggling along"
	cont "back here?"

	para "I'm doing great!"
	line "I caught a bunch"
	cont "of strong and"
	cont "smart #MON!"

	para "Here, let me see"
	line "what you caught,"
	cont "<PLAYER>!"
	done

CeruleanCityRivalDefeatedText:
	text "Hey!"
	line "Take it easy!"
	cont "You won already!"
	prompt

CeruleanCityRivalVictoryText:
	text "Heh!"
	line "You're no match"
	cont "for my genius!"
	prompt

CeruleanCityRivalIWentToBillsText:
	text "<RIVAL>: Hey,"
	line "guess what?"

	para "I went to BILL's"
	line "and got him to"
	cont "show me his rare"
	cont "#MON!"

	para "That added a lot"
	line "of pages to my"
	cont "#DEX!"

	para "After all, BILL's"
	line "world famous as a"
	cont "#MANIAC!"

	para "He invented the"
	line "#MON Storage"
	cont "System on PC!"

	para "Since you're using"
	line "his system, go"
	cont "thank him!"

	para "Well, I better"
	line "get rolling!"
	cont "Smell ya later!"
	done

; Yellow gives both Officer Jennys the same line (TEXT_CERULEANCITY_GUARD1 and
; _GUARD2 both point at _CeruleanCityGuardText).
CeruleanCityGuardText:
	text "These poor people"
	line "here were robbed."

	para "We're positive"
	line "that TEAM ROCKET"
	cont "is behind this"
	cont "terrible deed."

	para "Even our POLICE"
	line "FORCE has trouble"
	cont "with the ROCKETs!"
	done

CeruleanCitySignText:
	text "CERULEAN CITY"
	line "A Mysterious,"
	cont "Blue Aura"
	cont "Surrounds It"
	done

CeruleanCityTrainerTipsText:
	text "TRAINER TIPS"

	para "Pressing B Button"
	line "during evolution"
	cont "cancels the whole"
	cont "process."
	done

CeruleanBikeShopSignText:
	text "Grass and caves"
	line "handled easily!"
	cont "BIKE SHOP"
	done

CeruleanGymSignText:
	text "CERULEAN CITY"
	line "#MON GYM"
	cont "LEADER: MISTY"

	para "The Tomboyish"
	line "Mermaid!"
	done

CeruleanCity_MapEvents:
	db 0, 0 ; filler

; 6a: Yellow's ten warps, in Yellow's order (docs/M3-CERULEAN.md 1.4).  Warps 8
; and 10 are the "hole in the back wall" pass-throughs; they sit on metatile $96
; (FLOOR, FLOOR, FLOOR, LADDER), because GSC only fires a warp on a tile whose
; collision is in the $7x warp nybble while Gen 1 fires one anywhere.
	def_warp_events
	warp_event 27, 11, CERULEAN_TRASHED_HOUSE, 1
	warp_event 13, 15, CERULEAN_MELANIES_HOUSE, 1
	warp_event 19, 17, CERULEAN_POKECENTER_1F, 1
	warp_event 30, 19, CERULEAN_GYM, 1
	warp_event 13, 25, BIKE_SHOP, 1
	warp_event 25, 25, CERULEAN_MART, 1
	warp_event  4, 11, CERULEAN_BADGE_HOUSE, 2 ; 6k: -> CERULEAN_CAVE_1F, 1
	warp_event 27,  9, CERULEAN_TRASHED_HOUSE, 3
	warp_event  9, 11, CERULEAN_BADGE_HOUSE, 2
	warp_event  9,  9, CERULEAN_BADGE_HOUSE, 1

	def_coord_events
	coord_event 30,  7, -1, CeruleanCityRocketSceneNorth
	coord_event 30,  9, -1, CeruleanCityRocketSceneSouth
	coord_event 20,  6, -1, CeruleanCityRivalSceneWest
	coord_event 21,  6, -1, CeruleanCityRivalSceneEast

; 6b: Yellow's six signs, on Yellow's tiles, in Yellow's order.  Crystal's three
; extra bg_events (CERULEAN CAPE, the locked door, the hidden BERSERK_GENE at
; (2,12)) are gone -- Yellow has none of them.
	def_bg_events
	bg_event 23, 19, BGEVENT_READ, CeruleanCitySign
	bg_event 17, 29, BGEVENT_READ, CeruleanCityTrainerTips
	bg_event 26, 25, BGEVENT_READ, CeruleanCityMartSign
	bg_event 20, 17, BGEVENT_READ, CeruleanCityPokecenterSign
	bg_event 11, 25, BGEVENT_READ, CeruleanBikeShopSign
	bg_event 27, 21, BGEVENT_READ, CeruleanGymSign

	def_object_events
	object_event 31, 20, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeruleanCityCooltrainerMScript, -1
	object_event 15, 18, SPRITE_SUPER_NERD, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeruleanCitySuperNerd1Script, -1
	object_event  9, 21, SPRITE_SUPER_NERD, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeruleanCitySuperNerd2Script, -1
	object_event 29, 26, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeruleanCityCooltrainerF1Script, -1
	object_event 28, 26, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeruleanCityElectrodeScript, -1
	object_event  9, 27, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeruleanCityCooltrainerF2Script, -1
	object_event  4, 12, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeruleanCitySuperNerd3Script, -1
	object_event 30,  8, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeruleanCityRocketScript, EVENT_CERULEAN_ROCKET_THIEF_HIDDEN
	object_event 28, 12, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeruleanCityGuard1Script, EVENT_CERULEAN_GUARD_1_HIDDEN
	object_event 27, 12, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeruleanCityGuard2Script, EVENT_CERULEAN_GUARD_2_HIDDEN
	object_event 20,  2, SPRITE_KANTO_RIVAL, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeruleanCityRivalScript, EVENT_CERULEAN_RIVAL_HIDDEN
