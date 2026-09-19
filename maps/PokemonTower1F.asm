; Kanto hack (M5 8i): Yellow's POKEMON_TOWER_1F
; (vendor/pokeyellow/data/maps/objects/PokemonTower1F.asm,
; scripts/PokemonTower1F.asm, text/PokemonTower1F.asm).  8b registered the map
; (10x9, TILESET_KANTO_TOWER, Yellow's own PokemonTower1F.blk); 8i replaces
; Crystal's LAV RADIO TOWER cast, texts and bg_events with Yellow's.
;
; Yellow's 1F script is two instructions -- `EnableAutoTextBoxDrawing` / `ret`.
; There are no flags, no trainers, no items and no bg_events on this floor:
; five NPCs and a staircase, nothing else.
;
; Sprite substitutions (docs/M5-LAVENDER.md 2.12/2.17): MIDDLE_AGED_WOMAN ->
; SPRITE_POKEFAN_F, BALDING_GUY -> SPRITE_POKEFAN_M, GIRL -> SPRITE_LASS.
; LINK_RECEPTIONIST and the ported $76 SPRITE_CHANNELER are Yellow's own.
; Yellow's `STAY, NONE` is "stationary, faces down", which is
; SPRITEMOVEDATA_STANDING_DOWN plus the `faceplayer` every Kanto interior in
; this tree already uses (8g/8h house style).
;
; The Kanto-radio plot that used to live here -- the DJ, the MUSIC DIRECTOR,
; the EXPN CARD give, the floor directory and the "# FLUTE on CHANNEL 20"
; sign -- is deleted wholesale: Gen 2 anachronism, and Yellow's 1F has no
; bg_events at all.
;
; 2F-7F are M6's Silph Scope arc.  The staircase at (18,9) is drawn and is a
; LADDER tile, but carries NO warp_event (decision D8, docs/M5-LAVENDER.md
; 3.3); the TEMPORARY coord_event band below turns the player back with one
; line of invented text.  Everything marked TEMPORARY goes when M6 adds the
; 2F warp.
	object_const_def
	const POKEMONTOWER1F_RECEPTIONIST
	const POKEMONTOWER1F_MIDDLE_AGED_WOMAN
	const POKEMONTOWER1F_BALDING_GUY
	const POKEMONTOWER1F_GIRL
	const POKEMONTOWER1F_CHANNELER

PokemonTower1F_MapScripts:
	def_scene_scripts

	def_callbacks

PokemonTower1FReceptionistScript:
	jumptextfaceplayer PokemonTower1FReceptionistText

PokemonTower1FMiddleAgedWomanScript:
	jumptextfaceplayer PokemonTower1FMiddleAgedWomanText

PokemonTower1FBaldingGuyScript:
	jumptextfaceplayer PokemonTower1FBaldingGuyText

PokemonTower1FGirlScript:
	jumptextfaceplayer PokemonTower1FGirlText

PokemonTower1FChannelerScript:
	jumptextfaceplayer PokemonTower1FChannelerText

; TEMPORARY (M5 8i, D8) — delete in M6 with the 2F warp
; Yellow has no 1F->2F gate at all; the real gate is the SILPH SCOPE
; (IsGhostBattle) and the 6F MAROWAK.  Until M6 ships 2F-7F the staircase is a
; dead end, so this band gives it an in-world reason instead of a silent
; nothing.  Unconditional: no flag, no scene, nothing for M6 to migrate --
; delete the three coord_events, this script, the movement and the text.
PokemonTower1FStairsBlockScript:
	opentext
	writetext PokemonTower1FStairsBlockText
	waitbutton
	closetext
	applymovement PLAYER, PokemonTower1FStepBackMovement
	end

PokemonTower1FStepBackMovement:
	step LEFT
	step_end
; END TEMPORARY

PokemonTower1FReceptionistText:
	text "#MON TOWER was"
	line "erected in the"
	cont "memory of #MON"
	cont "that had died."
	done

PokemonTower1FMiddleAgedWomanText:
	text "Did you come to"
	line "pay respects?"
	cont "Bless you!"
	done

PokemonTower1FBaldingGuyText:
	text "I came to pray"
	line "for my CLEFAIRY."

	para "Sniff! I can't"
	line "stop crying…"
	done

PokemonTower1FGirlText:
	text "My GROWLITHE…"
	line "Why did you die?"
	done

PokemonTower1FChannelerText:
	text "I am a CHANNELER!"
	line "There are spirits"
	cont "up to mischief!"
	done

; TEMPORARY (M5 8i, D8) — delete in M6 with the 2F warp
PokemonTower1FStairsBlockText:
	text "A cold draft pours"
	line "down the stairs…"

	para "Your legs won't"
	line "carry you up."
	done
; END TEMPORARY

PokemonTower1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 10, 17, LAVENDER_TOWN, 2
	warp_event 11, 17, LAVENDER_TOWN, 2

	def_coord_events
; TEMPORARY (M5 8i, D8) — delete in M6 with the 2F warp
; The staircase tile (18,9) is reachable from (18,8), (18,10) AND (17,9) --
; it sits on the open east wall of the room, not in an alcove -- so the band
; covers the stair itself plus its two north/south approaches.  A band on the
; two approaches alone would let the player walk in sideways and stand on an
; inert staircase (docs/M5-LAVENDER.md "## 8i findings").
	coord_event 18,  8, -1, PokemonTower1FStairsBlockScript
	coord_event 18,  9, -1, PokemonTower1FStairsBlockScript
	coord_event 18, 10, -1, PokemonTower1FStairsBlockScript
; END TEMPORARY

	def_bg_events

	def_object_events
	object_event 15, 13, SPRITE_LINK_RECEPTIONIST, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, PokemonTower1FReceptionistScript, -1
	object_event  6,  8, SPRITE_POKEFAN_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, PokemonTower1FMiddleAgedWomanScript, -1
	object_event  8, 12, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, PokemonTower1FBaldingGuyScript, -1
	object_event 13,  7, SPRITE_LASS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, PokemonTower1FGirlScript, -1
	object_event 17,  7, SPRITE_CHANNELER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, PokemonTower1FChannelerScript, -1
