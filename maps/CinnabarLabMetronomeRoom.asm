; Kanto hack (M9 12i): Yellow's CINNABAR LAB R-and-D Room
; (vendor/pokeyellow/{data/maps/objects,scripts,text}/CinnabarLabMetronomeRoom.asm),
; cut wholesale onto Yellow's own 4x4 .blk and the new TILESET_KANTO_LAB (D95).
; The hall's middle door (its warp 4) leads here; warps 1 and 2 are the exit mat
; on the bottom row -- see hack/maps/CinnabarLab.asm for the collision override.
;
; Scientist1 (7,2) hands out Yellow's TM35 METRONOME once.  M3b's TM union gave
; every Gen 1 move a real TM item, but the ones Crystal had no TM for were
; appended as TM51-TM85 in Yellow's order, so METRONOME is TM_METRONOME ($ba)
; and the pack shows it as TM74 -- the same trade M3b made for KOGA's TM06 and
; SURGE's TM24 (docs/TM-LEDGER.md, "shipped-faithful").  The one-shot flag is
; EVENT_GOT_TM35_METRONOME, a new event appended at the end of
; constants/event_flags.asm (Yellow's EVENT_GOT_TM35).  GSC's verbosegiveitem
; prints "<PLAYER> received TM74!" and plays the item fanfare, which is Yellow's
; _..ReceivedTM35Text with our TM number, so that text needs no separate port;
; the `iffalse` branch is Yellow's TM35NoRoomText.
;
; Both PC bg_events point at the same text in Yellow (the e-mail about the
; three legendary birds), so both point at the same script here.
	object_const_def
	const CINNABARLABMETRONOMEROOM_SCIENTIST1
	const CINNABARLABMETRONOMEROOM_SCIENTIST2

CinnabarLabMetronomeRoom_MapScripts:
	def_scene_scripts

	def_callbacks

CinnabarLabMetronomeRoomScientist1Script:
	faceplayer
	opentext
	checkevent EVENT_GOT_TM35_METRONOME
	iftrue .GotTM35
	writetext CinnabarLabMetronomeRoomScientist1Text
	promptbutton
	verbosegiveitem TM_METRONOME
	iffalse .NoRoomForTM
	setevent EVENT_GOT_TM35_METRONOME
.GotTM35:
	writetext CinnabarLabMetronomeRoomScientist1TM35ExplanationText
	waitbutton
	closetext
	end

.NoRoomForTM:
	writetext CinnabarLabMetronomeRoomScientist1TM35NoRoomText
	waitbutton
	closetext
	end

CinnabarLabMetronomeRoomScientist2Script:
	jumptextfaceplayer CinnabarLabMetronomeRoomScientist2Text

CinnabarLabMetronomeRoomPC:
	jumptext CinnabarLabMetronomeRoomPCText

CinnabarLabMetronomeRoomAmberPipe:
	jumptext CinnabarLabMetronomeRoomAmberPipeText

CinnabarLabMetronomeRoomScientist1Text:
	text "Tch-tch-tch!"
	line "I made a cool TM!"

	para "It can cause all"
	line "kinds of fun!"
	done

CinnabarLabMetronomeRoomScientist1TM35ExplanationText:
	text "Tch-tch-tch!"
	line "That's the sound"
	cont "of a METRONOME!"

	para "It tweaks your"
	line "#MON's brain"
	cont "into using moves"
	cont "it doesn't know!"
	done

CinnabarLabMetronomeRoomScientist1TM35NoRoomText:
	text "Your pack is"
	line "crammed full!"
	done

CinnabarLabMetronomeRoomScientist2Text:
	text "EEVEE can evolve"
	line "into 1 of 3 kinds"
	cont "of #MON."
	done

CinnabarLabMetronomeRoomPCText:
	text "There's an e-mail"
	line "message!"

	para "…"

	para "The 3 legendary"
	line "bird #MON are"
	cont "ARTICUNO, ZAPDOS"
	cont "and MOLTRES."

	para "Their whereabouts"
	line "are unknown."

	para "We plan to explore"
	line "the cavern close"
	cont "to CERULEAN."

	para "From: #MON"
	line "RESEARCH TEAM"

	para "…"
	done

CinnabarLabMetronomeRoomAmberPipeText:
	text "An amber pipe!"
	done

CinnabarLabMetronomeRoom_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, CINNABAR_LAB, 4
	warp_event  3,  7, CINNABAR_LAB, 4

	def_coord_events

	def_bg_events
	bg_event  0,  4, BGEVENT_READ, CinnabarLabMetronomeRoomPC
	bg_event  1,  4, BGEVENT_READ, CinnabarLabMetronomeRoomPC
	bg_event  2,  1, BGEVENT_READ, CinnabarLabMetronomeRoomAmberPipe

	def_object_events
	object_event  7,  2, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CinnabarLabMetronomeRoomScientist1Script, -1
	object_event  2,  3, SPRITE_SCIENTIST, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CinnabarLabMetronomeRoomScientist2Script, -1
