; Kanto hack: Yellow's CINNABAR ISLAND (docs/M9-CINNABAR.md, 12g).  12a
; re-registered the CINNABAR group and 12b re-cut the .blk to Yellow's layout;
; this step replaces Crystal's Gen-2 town wholesale with Yellow's own objects --
; five warps, five signs, the GIRL and the GAMBLER -- at Yellow's coordinates
; (vendor/pokeyellow/data/maps/objects/CinnabarIsland.asm) with Yellow's text
; (vendor/pokeyellow/text/CinnabarIsland.asm).
;
; What Crystal had here and Yellow does not, all cut:
;   * BLUE and his volcano monologue (Yellow's island has no BLUE at all).
;   * CinnabarIslandGymSignText, the "CINNABAR GYM has relocated to SEAFOAM
;     ISLANDS" notice -- pure Gen 2 plot; the gym is on the island in Yellow and
;     12n builds it.  The sign at (13,3) is Yellow's real gym sign.
;   * The hidden RARE CANDY at (9,1).  Yellow has NO hidden item on CINNABAR
;     ISLAND (it is absent from vendor/pokeyellow/data/events/hidden_item_coords.asm
;     and from hidden_events.asm, whose only CINNABAR entries are the GYM, the
;     LAB FOSSIL ROOM and the POKeCENTRE).  EVENT_CINNABAR_ISLAND_HIDDEN_RARE_CANDY
;     stays in constants/event_flags.asm as a dead row (D49: never renumber).
;
; D97 -- (retired by M10 13b, D116.)  EVENT_VIRIDIAN_GYM_BLUE once hid BLUE in
; VIRIDIAN GYM until BLAINE's win cleared it; 12g parked that clearevent in this
; map's NEWMAP callback, 12n moved it to maps/CinnabarGym.asm, and 13b removed
; BLUE, the flag's new-game set and its clear.  The 7-badge door gates the gym.
;
; D91 -- 12m gave SECRET_KEY item id $80 (was MACHINE_PART); the locked gym
; door checks the item.  See CinnabarIslandGymDoor.

	object_const_def
	const CINNABARISLAND_GIRL
	const CINNABARISLAND_GAMBLER

CinnabarIsland_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_NEWMAP, CinnabarIslandNewMapCallback

; Yellow's CinnabarIsland_Script runs on every load of this map and resets two
; flags (vendor/pokeyellow/scripts/CinnabarIsland.asm:5-6):
;   * EVENT_MANSION_SWITCH_ON -- the POKeMON MANSION's statue switches are all
;     off again whenever you leave the island's neighbourhood (12l).
;   * EVENT_LAB_STILL_REVIVING_FOSSIL -- stepping back onto the island IS the
;     "go for a walk" timer for the fossil machine (gotcha G16; 12j).
; Both flags are appended by 12g and consumed by 12l / 12j.
CinnabarIslandNewMapCallback:
	setflag ENGINE_FLYPOINT_CINNABAR
	clearevent EVENT_MANSION_SWITCH_ON
	clearevent EVENT_LAB_STILL_REVIVING_FOSSIL
; D97's VIRIDIAN GYM clearevent lived here as a fallback until 12n; it is now
; in BLAINE's victory script (maps/CinnabarGym.asm).
	endcallback

; Yellow's CinnabarIslandDefaultScript: standing on the tile below the GYM door
; without the SECRET KEY prints "The door is locked..." and simulates one PAD_DOWN
; press, bouncing the player back off the door tile
; (vendor/pokeyellow/scripts/CinnabarIsland.asm:15-40).  Yellow faces the player
; UP for the box and leaves them facing DOWN afterwards; `turnobject` + the
; `step DOWN` below reproduce both.  Scene id -1 fires in every scene and on a
; map with no scene scripts at all (docs/PORTING.md 3.2), which is the same
; shape ViridianCity's own locked-gym door uses.
;
; D91/12m: Yellow tests `ld b, SECRET_KEY / call IsItemInBag`; so does this.
; With the key the tile is just a tile -- no text, as in Yellow.
; (EVENT_GOT_SECRET_KEY is only the MANSION B1F ball's hide flag.)
CinnabarIslandGymDoor:
	checkitem SECRET_KEY
	iftrue .Unlocked
	turnobject PLAYER, UP
	opentext
	writetext CinnabarIslandDoorIsLockedText
	waitbutton
	closetext
	applymovement PLAYER, CinnabarIslandPlayerStepDownMovement
.Unlocked:
	end

CinnabarIslandPlayerStepDownMovement:
	step DOWN
	step_end

CinnabarIslandGirlScript:
	jumptextfaceplayer CinnabarIslandGirlText

CinnabarIslandGamblerScript:
	jumptextfaceplayer CinnabarIslandGamblerText

CinnabarIslandSign:
	jumptext CinnabarIslandSignText

CinnabarIslandGymSign:
	jumptext CinnabarIslandGymSignText

CinnabarIslandPokemonLabSign:
	jumptext CinnabarIslandPokemonLabSignText

CinnabarIslandPokecenterSign:
	jumpstd PokecenterSignScript

CinnabarIslandMartSign:
	jumpstd MartSignScript

CinnabarIslandDoorIsLockedText:
	text "The door is"
	line "locked…"
	done

CinnabarIslandGirlText:
	text "CINNABAR GYM's"
	line "BLAINE is an odd"
	cont "man who has lived"
	cont "here for decades."
	done

CinnabarIslandGamblerText:
	text "Scientists conduct"
	line "experiments in"
	cont "the burned-out"
	cont "building."
	done

CinnabarIslandSignText:
	text "CINNABAR ISLAND"
	line "The Fiery Town of"
	cont "Burning Desire"
	done

CinnabarIslandPokemonLabSignText:
	text "#MON LAB"
	done

CinnabarIslandGymSignText:
	text "CINNABAR ISLAND"
	line "#MON GYM"
	cont "LEADER: BLAINE"

	para "The Hot-Headed"
	line "Quiz Master!"
	done

CinnabarIsland_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  6,  3, POKEMON_MANSION_1F, 2
	warp_event 18,  3, CINNABAR_GYM, 1
	warp_event  6,  9, CINNABAR_LAB, 1
	warp_event 11, 11, CINNABAR_POKECENTER_1F, 1
	warp_event 15, 11, CINNABAR_MART, 1

	def_coord_events
	coord_event 18,  4, -1, CinnabarIslandGymDoor

	def_bg_events
	bg_event  9,  5, BGEVENT_READ, CinnabarIslandSign
	bg_event 16, 11, BGEVENT_READ, CinnabarIslandMartSign
	bg_event 12, 11, BGEVENT_READ, CinnabarIslandPokecenterSign
	bg_event  9, 11, BGEVENT_READ, CinnabarIslandPokemonLabSign
	bg_event 13,  3, BGEVENT_READ, CinnabarIslandGymSign

	def_object_events
; Yellow's GIRL -> SPRITE_LASS and GAMBLER -> SPRITE_OLD_MAN are standing
; rulings (docs/AUDIT-M7-FUCHSIA-LEFTOVERS.md R-9 / X-3; FuchsiaCity.asm already
; ships the same GAMBLER substitution).  Yellow's `WALK, LEFT_RIGHT` is
; SPRITEMOVEDATA_WALK_LEFT_RIGHT with an x radius; `STAY, NONE` ($FF/$FF) is a
; sprite with no locked facing, i.e. SPRITEMOVEDATA_STANDING_DOWN.
	object_event 12,  5, SPRITE_LASS, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 2, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CinnabarIslandGirlScript, -1
	object_event 14,  6, SPRITE_OLD_MAN, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CinnabarIslandGamblerScript, -1
