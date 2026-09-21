; Kanto hack (M8 11d): MR.PSYCHIC hands over TM29 PSYCHIC, in Yellow's words
; (vendor/pokeyellow/{scripts,text}/MrPsychicsHouse.asm).  Yellow's three lines
; replace Crystal's: the "…" build-up becomes Yellow's "Wait! Don't say a word!",
; the explanation is Yellow's (it keeps Gen 1's "SPECIAL abilities" wording --
; faithful to the line, even though GSC splits the stat), and the bag-full
; branch gains Yellow's "Where do you plan to put this?", which Crystal had no
; text for.  Cast and coordinates already matched Yellow.
	object_const_def
	const MRPSYCHICSHOUSE_MR_PSYCHIC

MrPsychicsHouse_MapScripts:
	def_scene_scripts

	def_callbacks

MrPsychic:
	faceplayer
	opentext
	checkevent EVENT_GOT_TM29_PSYCHIC
	iftrue .AlreadyGotItem
	writetext MrPsychicYouWantedThisText
	promptbutton
	verbosegiveitem TM_PSYCHIC_M
	iffalse .NoRoom
	setevent EVENT_GOT_TM29_PSYCHIC
.AlreadyGotItem:
	writetext MrPsychicTM29ExplanationText
	waitbutton
	closetext
	end

.NoRoom:
	writetext MrPsychicTM29NoRoomText
	waitbutton
	closetext
	end

MrPsychicsHouseBookshelf:
	jumpstd DifficultBookshelfScript

MrPsychicYouWantedThisText:
	text "…Wait! Don't"
	line "say a word!"

	para "You wanted this!"
	done

MrPsychicTM29ExplanationText:
	text "TM29 is PSYCHIC!"

	para "It can lower the"
	line "target's SPECIAL"
	cont "abilities."
	done

MrPsychicTM29NoRoomText:
	text "Where do you plan"
	line "to put this?"
	done

MrPsychicsHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, SAFFRON_CITY, 8
	warp_event  3,  7, SAFFRON_CITY, 8

	def_coord_events

	def_bg_events
	bg_event  0,  1, BGEVENT_READ, MrPsychicsHouseBookshelf
	bg_event  1,  1, BGEVENT_READ, MrPsychicsHouseBookshelf

	def_object_events
	object_event  5,  3, SPRITE_FISHING_GURU, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, MrPsychic, -1
