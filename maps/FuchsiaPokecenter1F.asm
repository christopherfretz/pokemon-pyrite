; Kanto hack: Yellow's FUCHSIA #MON CENTER (docs/M7-FUCHSIA.md 10g).  Yellow's
; cast and every line are Yellow's (vendor/pokeyellow/{data/maps/objects,text}/
; FuchsiaPokecenter.asm) minus the cable-club receptionist: Crystal keeps the
; cable club upstairs on POKECENTER_2F, which warp 3 already leads to
; (docs/PORTING.md §15), the same call Pewter and Viridian made.  Crystal's
; JANINE-impersonator set piece and its two Johto-act gossips are gone (D65).
;
; Two positions move.  The ROCKER goes (4,3) -> (5,3): Yellow parks him directly
; in front of the CHANSEY at (4,1), which makes CHANSEY's line unreachable
; across the counter -- the same Yellow quirk Pewter and Viridian already fixed
; the same way.  The COOLTRAINER_F keeps Yellow's (6,5); Crystal's bench sits on
; (7,5), so her LEFT_RIGHT beat is (5,5)<->(6,5) instead of Yellow's three tiles
; -- a wall shortening a walk radius is normal in Crystal and is cheaper than
; moving her.  10a widened the room to Yellow's 7x4, so the east half is
; Yellow's footprint with Crystal's cable-club desk left out.
	object_const_def
	const FUCHSIAPOKECENTER1F_NURSE
	const FUCHSIAPOKECENTER1F_ROCKER
	const FUCHSIAPOKECENTER1F_COOLTRAINER_F
	const FUCHSIAPOKECENTER1F_CHANSEY

FuchsiaPokecenter1F_MapScripts:
	def_scene_scripts

	def_callbacks

FuchsiaPokecenter1FNurseScript:
	jumpstd PokecenterNurseScript

FuchsiaPokecenter1FRockerScript:
	jumptextfaceplayer FuchsiaPokecenter1FRockerText

FuchsiaPokecenter1FCooltrainerFScript:
	jumptextfaceplayer FuchsiaPokecenter1FCooltrainerFText

; Yellow's PokecenterChanseyText -- one line plus the cry (N1c/N1d).
FuchsiaPokecenter1FChanseyScript:
	opentext
	writetext FuchsiaPokecenter1FChanseyText
	cry CHANSEY
	waitbutton
	closetext
	end

FuchsiaPokecenter1FRockerText:
	text "You can't win"
	line "with just one"
	cont "strong #MON."

	para "It's tough, but"
	line "you have to raise"
	cont "them evenly."
	done

FuchsiaPokecenter1FCooltrainerFText:
	text "There's a narrow"
	line "trail west of"
	cont "VIRIDIAN CITY."

	para "It goes to #MON"
	line "LEAGUE HQ."
	cont "The HQ governs"
	cont "all trainers."
	done

FuchsiaPokecenter1FChanseyText:
	text "CHANSEY: Chaaan"
	line "sey!"
	done

FuchsiaPokecenter1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, FUCHSIA_CITY, 3
	warp_event  4,  7, FUCHSIA_CITY, 3
	warp_event  0,  7, POKECENTER_2F, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  3,  1, SPRITE_NURSE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, FuchsiaPokecenter1FNurseScript, -1
	object_event  5,  3, SPRITE_ROCKER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, FuchsiaPokecenter1FRockerScript, -1
	object_event  6,  5, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, FuchsiaPokecenter1FCooltrainerFScript, -1
	object_event  4,  1, SPRITE_CHANSEY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, FuchsiaPokecenter1FChanseyScript, -1
