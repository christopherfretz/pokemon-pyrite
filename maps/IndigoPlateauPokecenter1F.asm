; Kanto hack (M10 13h): Yellow's INDIGO_PLATEAU_LOBBY
; (vendor/pokeyellow/data/maps/objects/IndigoPlateauLobby.asm,
; vendor/pokeyellow/scripts/IndigoPlateauLobby.asm,
; vendor/pokeyellow/text/IndigoPlateauLobby.asm), regrown to Yellow's 8x6
; blocks (16x12 tiles) on TILESET_POKECENTER (D128).  The layout is a hand cut
; (scripts/indigo_lobby_blk.py) whose walkable set matches Yellow's reachable
; tiles; see docs/M10-INDIGO.md "13h findings".
;
; Every object is Yellow's, at Yellow's coords: NURSE (7,5), CHANSEY (8,5),
; GYM GUIDE (4,9), COOLTRAINER_F (5,1), CLERK (0,5) and LINK RECEPTIONIST
; (13,6).  Yellow's hidden PC at (15,7) is a real PC tile here.
;
; Warps: Yellow's (7,11)/(8,11) forecourt door and (8,0) E4 door.  (0,11) is
; the POKECENTER_2F staircase every Kanto centre keeps (PORTING 15).  The E4
; door MUST stay warp 4: LoreleisRoom's back-warps target lobby warp 4.
;
; Crystal's leftovers are gone (C-8/D133): the Wednesday rival battle (scene
; script, both coord_events, the RIVAL object), the TELEPORT GUY + ABRA and
; their live warp to NEW BARK TOWN, and Crystal's COOLTRAINER_M.  The scene
; var / wIndigoPlateauPokecenter1FSceneID and the EVENT_TELEPORT_GUY /
; EVENT_INDIGO_PLATEAU_POKECENTER_RIVAL flags stay defined (dead) so no WRAM or
; flag numbering moves.
	object_const_def
	const INDIGOPLATEAUPOKECENTER1F_NURSE
	const INDIGOPLATEAUPOKECENTER1F_GYM_GUIDE
	const INDIGOPLATEAUPOKECENTER1F_COOLTRAINER_F
	const INDIGOPLATEAUPOKECENTER1F_CLERK
	const INDIGOPLATEAUPOKECENTER1F_LINK_RECEPTIONIST
	const INDIGOPLATEAUPOKECENTER1F_CHANSEY

IndigoPlateauPokecenter1F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_NEWMAP, IndigoPlateauPokecenter1FPrepareElite4Callback

; Crystal's reset, re-pointed at Yellow's rooms (13j).  Yellow's lobby script
; resets the E4 range only once BIT_STARTED_ELITE_4 is set, and resets the VR
; switch boulder; 13g's Route 23 load already resets VR, and clearing the E4
; room state on every entry is equivalent for the player.
;
; Post-E4 hook (operator ruling 2026-09-22): once EVENT_BEAT_KANTO_ELITE_FOUR
; is set the League is freely walkable, so nothing is re-locked -- the four
; rooms go straight to their open scenes (each room also checks the flag
; itself, so their door/beat flags no longer matter).  13k: CHAMPIONS_ROOM
; (empty, the rival has gone to VIRIDIAN) and HALL_OF_FAME (the ceremony runs
; once) go to their NOOP scenes too; before that they are re-armed.  OAK is
; hidden either way (he only appears inside the champion cutscene).
IndigoPlateauPokecenter1FPrepareElite4Callback:
	setevent EVENT_CHAMPIONS_ROOM_OAK_AND_MARY
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue .LeagueOpen
	setmapscene CHAMPIONS_ROOM, SCENE_CHAMPIONSROOM_ENTER
	setmapscene HALL_OF_FAME, SCENE_HALLOFFAME_ENTER
	setmapscene LORELEIS_ROOM, SCENE_LORELEISROOM_WALK_IN
	setmapscene BRUNOS_ROOM, SCENE_BRUNOSROOM_WALK_IN
	setmapscene AGATHAS_ROOM, SCENE_AGATHASROOM_WALK_IN
	setmapscene LANCES_ROOM, SCENE_LANCESROOM_WALK_IN
	clearevent EVENT_LORELEIS_ROOM_ENTRANCE_CLOSED
	clearevent EVENT_LORELEIS_ROOM_EXIT_OPEN
	clearevent EVENT_BRUNOS_ROOM_ENTRANCE_CLOSED
	clearevent EVENT_BRUNOS_ROOM_EXIT_OPEN
	clearevent EVENT_AGATHAS_ROOM_ENTRANCE_CLOSED
	clearevent EVENT_AGATHAS_ROOM_EXIT_OPEN
	clearevent EVENT_LANCES_ROOM_ENTRANCE_CLOSED
	clearevent EVENT_LANCES_ROOM_EXIT_OPEN
	clearevent EVENT_BEAT_ELITE_4_LORELEI
	clearevent EVENT_BEAT_ELITE_4_BRUNO
	clearevent EVENT_BEAT_ELITE_4_AGATHA
	clearevent EVENT_BEAT_ELITE_4_LANCE
	endcallback

.LeagueOpen:
	setmapscene LORELEIS_ROOM, SCENE_LORELEISROOM_POST_E4
	setmapscene BRUNOS_ROOM, SCENE_BRUNOSROOM_POST_E4
	setmapscene AGATHAS_ROOM, SCENE_AGATHASROOM_POST_E4
	setmapscene LANCES_ROOM, SCENE_LANCESROOM_NOOP
	setmapscene CHAMPIONS_ROOM, SCENE_CHAMPIONSROOM_NOOP
	setmapscene HALL_OF_FAME, SCENE_HALLOFFAME_NOOP
	endcallback

IndigoPlateauPokecenter1FShelfScript: ; BG2
	jumpstd KantoMerchandiseShelfScript

IndigoPlateauPokecenter1FNurseScript:
	jumpstd PokecenterNurseScript

; Yellow: PokecenterChanseyText (engine/events/pokecenter_chansey.asm).
IndigoPlateauPokecenter1FChanseyScript:
	opentext
	writetext IndigoPlateauPokecenter1FChanseyText
	cry CHANSEY
	waitbutton
	closetext
	end

IndigoPlateauPokecenter1FGymGuideScript:
	jumptextfaceplayer IndigoPlateauPokecenter1FGymGuideText

IndigoPlateauPokecenter1FCooltrainerFScript:
	jumptextfaceplayer IndigoPlateauPokecenter1FCooltrainerFText

; Yellow: script_mart ULTRA_BALL, GREAT_BALL, FULL_RESTORE, MAX_POTION,
; FULL_HEAL, REVIVE, MAX_REPEL (MART_INDIGO_PLATEAU, reordered to Yellow's).
IndigoPlateauPokecenter1FClerkScript:
	opentext
	pokemart MARTTYPE_STANDARD, MART_INDIGO_PLATEAU
	closetext
	end

; Yellow: script_cable_club_receptionist -> CableClubNPC
; (engine/link/cable_club_npc.asm).  With a POKEDEX and Pikachu awake (always,
; this far into the game) Yellow prints the welcome, polls the link port for
; 90 frames and, with no cable, prints the "reserved" line.  That no-link path
; is ported as text; the real Cable Club stays upstairs on POKECENTER_2F.
IndigoPlateauPokecenter1FLinkReceptionistScript:
	faceplayer
	opentext
	writetext IndigoPlateauPokecenter1FCableClubWelcomeText
	pause 90
	writetext IndigoPlateauPokecenter1FCableClubReservedText
	waitbutton
	closetext
	end

IndigoPlateauPokecenter1FChanseyText:
	text "CHANSEY: Chaaan"
	line "sey!"
	done

; Yellow: _IndigoPlateauLobbyGymGuideText.
IndigoPlateauPokecenter1FGymGuideText:
	text "Yo! Champ in"
	line "making!"

	para "At #MON LEAGUE,"
	line "you have to face"
	cont "the ELITE FOUR in"
	cont "succession."

	para "If you lose, you"
	line "have to start all"
	cont "over again! This"
	cont "is it! Go for it!"
	done

; Yellow: _IndigoPlateauLobbyCooltrainerFText.
IndigoPlateauPokecenter1FCooltrainerFText:
	text "From here on, you"
	line "face the ELITE"
	cont "FOUR one by one!"

	para "If you win, a"
	line "door opens to the"
	cont "next trainer!"
	cont "Good luck!"
	done

; Yellow: _CableClubNPCWelcomeText.
IndigoPlateauPokecenter1FCableClubWelcomeText:
	text "Welcome to the"
	line "Cable Club!"
	done

; Yellow: _CableClubNPCAreaReservedFor2FriendsLinkedByCableText (a copy of
; Pokecenter2F's Text_CableClubAreaReserved, which lives in another bank).
IndigoPlateauPokecenter1FCableClubReservedText:
	text "This area is"
	line "reserved for 2"
	cont "friends who are"
	cont "linked by cable."
	done

IndigoPlateauPokecenter1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  7, 11, INDIGO_PLATEAU, 1
	warp_event  8, 11, INDIGO_PLATEAU, 2
	warp_event  0, 11, POKECENTER_2F, 1
	warp_event  8,  0, LORELEIS_ROOM, 1 ; Yellow: LORELEIS_ROOM 1

	def_coord_events

	def_bg_events
; BG2: Yellow's MART shelf tiles $54/$55 on (0,9)-(3,9) say PokemonStuffText,
; facing UP only (bookshelf_tile_ids.asm); here they are plain walls.
	bg_event  0,  9, BGEVENT_UP, IndigoPlateauPokecenter1FShelfScript
	bg_event  1,  9, BGEVENT_UP, IndigoPlateauPokecenter1FShelfScript
	bg_event  2,  9, BGEVENT_UP, IndigoPlateauPokecenter1FShelfScript
	bg_event  3,  9, BGEVENT_UP, IndigoPlateauPokecenter1FShelfScript

	def_object_events
	object_event  7,  5, SPRITE_NURSE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, IndigoPlateauPokecenter1FNurseScript, -1
	object_event  4,  9, SPRITE_GYM_GUIDE, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, IndigoPlateauPokecenter1FGymGuideScript, -1
	object_event  5,  1, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, IndigoPlateauPokecenter1FCooltrainerFScript, -1
	object_event  0,  5, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, IndigoPlateauPokecenter1FClerkScript, -1
	object_event 13,  6, SPRITE_LINK_RECEPTIONIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, IndigoPlateauPokecenter1FLinkReceptionistScript, -1
	object_event  8,  5, SPRITE_CHANSEY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, IndigoPlateauPokecenter1FChanseyScript, -1
