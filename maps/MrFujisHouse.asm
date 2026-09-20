; Kanto hack (M5 8h): Yellow's MR_FUJIS_HOUSE, the VOLUNTEER #MON HOUSE
; (vendor/pokeyellow/data/maps/objects/MrFujisHouse.asm,
; scripts/MrFujisHouse.asm, text/MrFujisHouse.asm).  The room was re-cut from
; Crystal's 5x4 to Yellow's 4x4 and now aliases maps/House1.blk, which matches
; Yellow's house block for block: all six of Yellow's objects land on Yellow's
; own tiles, including the POKEDEX prop on the table at (3,3) (the same tile
; BluesHouse uses on the same .blk) and the door at (2,7)/(3,7).
;
; Sprite substitutions (docs/M5-LAVENDER.md 2.17): LITTLE_GIRL -> SPRITE_TWIN,
; and the two adopted #MON are SPRITE_MONSTER, replacing the party-icon
; indexes (SPRITE_RHYDON / SPRITE_GROWLITHE / SPRITE_MOLTRES) Crystal's version
; of this map used.  Crystal's third #MON, a PIDGEY, is not on Yellow's list
; and is gone with the bookshelves.
;
; MR FUJI himself is only home once the player has cleared the #MON TOWER.
; Yellow branches on EVENT_RESCUED_MR_FUJI; GSC's object rows carry a HIDE flag
; (SET means hidden, engine/overworld/scripting.asm), which is the inverse, so
; the row's flag is the dedicated EVENT_MR_FUJIS_HOUSE_MR_FUJI_HIDDEN and the
; callback below derives it from the story flag on every map load.  That is the
; CeruleanCity idiom (docs/PORTING.md 3.1/3.4): it survives white-outs and is
; correct on saves made before the flag existed.
	object_const_def
	const MRFUJISHOUSE_SUPER_NERD
	const MRFUJISHOUSE_TWIN
	const MRFUJISHOUSE_PSYDUCK
	const MRFUJISHOUSE_NIDORINO
	const MRFUJISHOUSE_MR_FUJI
	const MRFUJISHOUSE_POKEDEX

MrFujisHouse_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_OBJECTS, MrFujisHouseObjectsCallback

MrFujisHouseObjectsCallback:
	checkevent EVENT_RESCUED_MR_FUJI
	iftrue .MrFujiIsHome
	setevent EVENT_MR_FUJIS_HOUSE_MR_FUJI_HIDDEN
	endcallback

.MrFujiIsHome:
	clearevent EVENT_MR_FUJIS_HOUSE_MR_FUJI_HIDDEN
	endcallback

; Yellow: MrFujisHouseSuperNerdText branches on EVENT_RESCUED_MR_FUJI.
MrFujisHouseSuperNerdScript:
	faceplayer
	opentext
	checkevent EVENT_RESCUED_MR_FUJI
	iftrue .HadBeenPraying
	writetext MrFujisHouseSuperNerdMrFujiIsntHereText
	waitbutton
	closetext
	end

.HadBeenPraying:
	writetext MrFujisHouseSuperNerdMrFujiHadBeenPrayingText
	waitbutton
	closetext
	end

; Yellow: MrFujisHouseLittleGirlText, same branch.
MrFujisHouseTwinScript:
	faceplayer
	opentext
	checkevent EVENT_RESCUED_MR_FUJI
	iftrue .NiceToHug
	writetext MrFujisHouseTwinThisIsMrFujisHouseText
	waitbutton
	closetext
	end

.NiceToHug:
	writetext MrFujisHouseTwinPokemonAreNiceToHugText
	waitbutton
	closetext
	end

MrFujisPsyduck:
	opentext
	writetext MrFujisPsyduckText
	cry PSYDUCK
	waitbutton
	closetext
	end

MrFujisNidorino:
	opentext
	writetext MrFujisNidorinoText
	cry NIDORINO
	waitbutton
	closetext
	end

; Yellow's MR FUJI hands over the POKE FLUTE here, the first time the player
; visits after the #MON TOWER rescue, and afterwards asks whether it helped.
; M5 ships only the afterwards line (Yellow's .HasMyFluteHelpedYouText): the
; give needs EVENT_GOT_POKE_FLUTE, which is M6 step 9l's flag append
; (docs/M5-LAVENDER.md 3.5, docs/M6-TOWER.md 3.9).
;
; ⚠ M6 9k now sets EVENT_RESCUED_MR_FUJI, so MR FUJI is home and this script IS
; reachable: until 9l lands he asks whether a FLUTE he never gave has helped.
; 9l replaces the body with Yellow's branch and nothing here blocks it.
MrFujisHouseMrFujiScript:
	jumptextfaceplayer MrFujisHouseMrFujiHasMyFluteHelpedYouText

MrFujisHousePokedexScript:
	jumptext MrFujisHousePokedexText

MrFujisHouseSuperNerdMrFujiIsntHereText:
	text "That's odd, MR.FUJI"
	line "isn't here."
	cont "Where'd he go?"
	done

MrFujisHouseSuperNerdMrFujiHadBeenPrayingText:
	text "MR.FUJI had been"
	line "praying alone for"
	cont "CUBONE's mother."
	done

MrFujisHouseTwinThisIsMrFujisHouseText:
	text "This is really"
	line "MR.FUJI's house."

	para "He's really kind!"

	para "He looks after"
	line "abandoned and"
	cont "orphaned #MON!"
	done

MrFujisHouseTwinPokemonAreNiceToHugText:
	text "It's so warm!"
	line "#MON are so"
	cont "nice to hug!"
	done

MrFujisPsyduckText:
	text "PSYDUCK: Gwappa!"
	done

MrFujisNidorinoText:
	text "NIDORINO: Gaoo!"
	done

MrFujisHouseMrFujiHasMyFluteHelpedYouText:
	text "MR.FUJI: Has my"
	line "FLUTE helped you?"
	done

; Kanto hack (M5 8n audit): Yellow hides three PrintMagazinesText hidden events
; in this room (data/events/hidden_events.asm:410-413, at (0,1), (1,1) and
; (7,1), all SPRITE_FACING_DOWN).  8h ported the room without them.  GSC has no
; hidden-event table, so they become BGEVENT_READ bg_events on the same tiles;
; a bg_event is checked before the tile-collision std script, so the (7,1) row
; also shadows House1.blk's COLL_RADIO, which was opening Crystal's POKeMON
; CHANNEL here (see docs/AUDIT-M5-LEFTOVERS.md Q for the project-wide case).
MrFujisHouseMagazines:
	jumptext MrFujisHouseMagazinesText

MrFujisHouseMagazinesText:
	text "#MON magazines!"

	para "#MON notebooks!"

	para "#MON graphs!"
	done

MrFujisHousePokedexText:
	text "#MON Monthly"
	line "Grand Prize"
	cont "Drawing!"

	para "The application"
	line "form is…"

	para "Gone! It's been"
	line "clipped out!"
	done

MrFujisHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, LAVENDER_TOWN, 3
	warp_event  3,  7, LAVENDER_TOWN, 3

	def_coord_events

	def_bg_events
	bg_event  0,  1, BGEVENT_READ, MrFujisHouseMagazines
	bg_event  1,  1, BGEVENT_READ, MrFujisHouseMagazines
	bg_event  7,  1, BGEVENT_READ, MrFujisHouseMagazines

	def_object_events
	object_event  3,  5, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, MrFujisHouseSuperNerdScript, -1
	object_event  6,  3, SPRITE_TWIN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, MrFujisHouseTwinScript, -1
	object_event  6,  4, SPRITE_MONSTER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, MrFujisPsyduck, -1
	object_event  1,  3, SPRITE_MONSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, MrFujisNidorino, -1
	object_event  3,  1, SPRITE_MR_FUJI, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, MrFujisHouseMrFujiScript, EVENT_MR_FUJIS_HOUSE_MR_FUJI_HIDDEN
	object_event  3,  3, SPRITE_POKEDEX, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, MrFujisHousePokedexScript, -1
