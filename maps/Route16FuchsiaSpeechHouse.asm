; Kanto hack: Yellow's ROUTE 16 FLY HOUSE (docs/M6-CELADON.md, 9y).  The map
; const keeps Crystal's ROUTE_16_FUCHSIA_SPEECH_HOUSE name (renaming it would
; churn every table for nothing); the contents are Yellow's.
;
; vendor/pokeyellow/maps/Route16FlyHouse.blk is Yellow's stock 4x4 house, the
; same one Route12SuperRodHouse / MrFujisHouse use, so the existing House1.blk
; alias in data/maps/blocks.asm already matches it -- no .blk change.
;
; Yellow: BRUNETTE_GIRL (2,3) STAY RIGHT hands over HM02 FLY, BIRD (6,4) WALK
; ANY_DIR is a FEAROW that just cries.  docs/M6-CELADON.md 2.3 maps
; BRUNETTE_GIRL -> SPRITE_LASS and BIRD -> SPRITE_BIRD.
	object_const_def
	const ROUTE16FUCHSIASPEECHHOUSE_GIRL
	const ROUTE16FUCHSIASPEECHHOUSE_FEAROW

Route16FuchsiaSpeechHouse_MapScripts:
	def_scene_scripts

	def_callbacks

; Yellow's Route16FlyHouseBrunetteGirlText: give HM02 once, then explain it.
; The explanation only prints on a LATER talk, exactly as Yellow branches it.
Route16FlyHouseGirlScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_HM02_FLY
	iftrue .GotFly
	writetext Route16FlyHouseGirlSecretRetreatText
	promptbutton
	verbosegiveitem HM_FLY
	iffalse .Done
	setevent EVENT_GOT_HM02_FLY
	closetext
	end

.GotFly:
	writetext Route16FlyHouseGirlHM02ExplanationText
	waitbutton
.Done:
	closetext
	end

Route16FlyHouseFearowScript:
	opentext
	writetext Route16FlyHouseFearowText
	cry FEAROW
	waitbutton
	closetext
	end

Route16FuchsiaSpeechHouseBookshelf:
	jumpstd PictureBookshelfScript

; House1's (7,1) is a COLL_RADIO tile, which would otherwise drop the player
; into Crystal's Pokegear radio (docs/AUDIT-NPC-TEXT.md).  Shadowed with the
; same magazines text MrFujisHouse and CeladonChiefHouse use for this tile.
Route16FuchsiaSpeechHouseMagazines:
	jumptext Route16FuchsiaSpeechHouseMagazinesText

Route16FlyHouseGirlSecretRetreatText:
	text "Oh, you found my"
	line "secret retreat!"

	para "Please don't tell"
	line "anyone I'm here."
	cont "I'll make it up"
	cont "to you with this!"
	done

Route16FlyHouseGirlHM02ExplanationText:
	text "HM02 is FLY."
	line "It will take you"
	cont "back to any town."

	para "Put it to good"
	line "use!"
	done

Route16FlyHouseFearowText:
	text "FEAROW: Kyueen!"
	done

Route16FuchsiaSpeechHouseMagazinesText:
	text "#MON magazines!"

	para "#MON notebooks!"

	para "#MON graphs!"
	done

Route16FuchsiaSpeechHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, ROUTE_16, 9
	warp_event  3,  7, ROUTE_16, 9

	def_coord_events

	def_bg_events
	bg_event  0,  1, BGEVENT_READ, Route16FuchsiaSpeechHouseBookshelf
	bg_event  1,  1, BGEVENT_READ, Route16FuchsiaSpeechHouseBookshelf
	bg_event  7,  1, BGEVENT_READ, Route16FuchsiaSpeechHouseMagazines

	def_object_events
	object_event  2,  3, SPRITE_LASS, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route16FlyHouseGirlScript, -1
	object_event  6,  4, SPRITE_BIRD, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, Route16FlyHouseFearowScript, -1
