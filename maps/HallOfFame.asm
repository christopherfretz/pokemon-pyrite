; Kanto hack (M10 13k): Yellow's HALL_OF_FAME
; (vendor/pokeyellow/data/maps/objects/HallOfFame.asm, scripts/HallOfFame.asm,
; text/HallOfFame.asm), re-cut to Yellow's 5x4 on TILESET_KANTO_GYM.  The .blk
; is Yellow's except (2,3) = $90, a WARP_CARPET_DOWN twin of $6c
; (scripts/kanto_gym_blk.py), so the room can be left post-E4.
;
; Yellow: the player walks UP 5 from (4,7) to (4,2), beside OAK at (5,2); OAK
; faces LEFT, the player RIGHT; OAK's text; HallOfFamePC.  Here that is
; `halloffame` (Crystal's registration, credits, then the soft reset).
; This room sets ONLY EVENT_BEAT_KANTO_ELITE_FOUR (D109/D110): none of
; Crystal's Johto post-game flags (EVENT_BEAT_ELITE_FOUR, TELEPORT_GUY, RED at
; MT. SILVER, the Olivine port, Sprout Tower, the S.S. TICKET call).
; Post-E4: the ceremony is over; OAK is gone and the room is walkable.
	object_const_def
	const HALLOFFAME_OAK

HallOfFame_MapScripts:
	def_scene_scripts
	scene_script HallOfFameEnterScene, SCENE_HALLOFFAME_ENTER
	scene_script HallOfFameNoopScene,  SCENE_HALLOFFAME_NOOP

	def_callbacks

HallOfFameEnterScene:
	sdefer HallOfFameEnterScript
	end

HallOfFameNoopScene:
	end

HallOfFameEnterScript:
	checkevent EVENT_BEAT_KANTO_ELITE_FOUR
	iftrue .league_open
	applymovement PLAYER, HallOfFameEntryMovement
	turnobject HALLOFFAME_OAK, LEFT
	turnobject PLAYER, RIGHT
	opentext
	writetext HallOfFameOakText
	waitbutton
	closetext
	setscene SCENE_HALLOFFAME_NOOP
	setevent EVENT_BEAT_KANTO_ELITE_FOUR
	special HealParty
	halloffame
	end

.league_open:
	setscene SCENE_HALLOFFAME_NOOP
	end

HallOfFameEntryMovement:
	step UP
	step UP
	step UP
	step UP
	step UP
	step_end

HallOfFameOakText:
	text "OAK: Er-hem!"
	line "Congratulations,"
	cont "<PLAYER>!"

	para "This floor is the"
	line "#MON HALL OF"
	cont "FAME!"

	para "#MON LEAGUE"
	line "champions are"
	cont "honored for their"
	cont "exploits here!"

	para "Their #MON are"
	line "also recorded in"
	cont "the HALL OF FAME!"

	para "<PLAYER>! You have"
	line "endeavored hard"
	cont "to become the new"
	cont "LEAGUE champion!"

	para "Congratulations,"
	line "<PLAYER>, you and"
	cont "your #MON are"
	cont "HALL OF FAMERs!"
	done

HallOfFame_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4,  7, CHAMPIONS_ROOM, 3
	warp_event  5,  7, CHAMPIONS_ROOM, 4

	def_coord_events

	def_bg_events

	def_object_events
	object_event  5,  2, SPRITE_OAK, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_BEAT_KANTO_ELITE_FOUR ; post-E4: the ceremony is over
