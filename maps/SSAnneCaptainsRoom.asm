; Kanto hack: Yellow's SS_ANNE_CAPTAINS_ROOM (docs/M4-VERMILION.md, 7h).
;   Yellow ( 4, 2) SPRITE_CAPTAIN, STAY UP -> SPRITE_CAPTAIN 1:1
;   Yellow bg_event ( 4, 1) TEXT_SSANNECAPTAINSROOM_TRASH
;   Yellow bg_event ( 1, 2) TEXT_SSANNECAPTAINSROOM_SEASICK_BOOK
; The CAPTAIN's scene (7i, 3.4): the back rub, HM01 CUT, and the "not sick
; anymore" line once he has handed it over.  Yellow sets BIT_NO_NPC_FACE_PLAYER
; in SSAnneCaptainsRoomEventScript for as long as EVENT_GOT_HM01 is clear, so
; the seasick CAPTAIN keeps facing UP -- away from the player -- through the
; whole rub; he only turns around from the talk after he has given you CUT.
; The GSC equivalent is simply where `faceplayer` sits: the pre-HM branch omits
; it, the post-HM branch has it.
	object_const_def
	const SSANNECAPTAINSROOM_CAPTAIN

SSAnneCaptainsRoom_MapScripts:
	def_scene_scripts

	def_callbacks

SSAnneCaptainsRoomCaptainScript:
	checkevent EVENT_GOT_HM01_CUT
	iftrue .NotSickAnymore
	opentext
	writetext SSAnneCaptainsRoomRubCaptainsBackText
	; Yellow plays MUSIC_PKMN_HEALED over the "Rub-rub..." box and spins until
	; the jingle has finished before restoring the map music.  MUSIC_HEAL is
	; Crystal's same piece (audio/music/healpokemon.asm, the Pokemon Center
	; heal jingle); it does not loop and runs 135 frames -- tempo 144,
	; note_type 12, 20 note units, i.e. 12 * 20 * 144 / 256 -- so `pause 140`
	; is Yellow's "wait for the channel to go quiet" with a small margin.
	playmusic MUSIC_HEAL
	pause 140
	special RestartMapMusic
	writetext SSAnneCaptainsRoomIFeelMuchBetterText
	promptbutton
	giveitem HM_CUT
	iffalse .NoRoom
	writetext SSAnneCaptainsRoomReceivedHM01Text
	playsound SFX_KEY_ITEM
	waitsfx
	promptbutton
	setevent EVENT_GOT_HM01_CUT
	closetext
	end

; Yellow's GiveItem failure branch.  It cannot fire here: GSC keeps TMs and HMs
; in a fixed wTMsHMs array rather than in the 20-slot bag, and ReceiveTMHM only
; refuses above 99 copies of the same TM/HM (engine/items/items.asm).  The line
; is ported anyway so the text is complete and the branch is not a silent drop.
.NoRoom:
	writetext SSAnneCaptainsRoomHM01NoRoomText
	waitbutton
	closetext
	end

.NotSickAnymore:
	faceplayer
	opentext
	writetext SSAnneCaptainsRoomNotSickAnymoreText
	waitbutton
	closetext
	end

SSAnneCaptainsRoomTrash:
	jumptext SSAnneCaptainsRoomTrashText

SSAnneCaptainsRoomSeasickBook:
	jumptext SSAnneCaptainsRoomSeasickBookText

SSAnneCaptainsRoomRubCaptainsBackText:
	text "CAPTAIN: Ooargh…"
	line "I feel hideous…"
	cont "Urrp! Seasick…"

	para "<PLAYER> rubbed"
	line "the CAPTAIN's"
	cont "back!"

	para "Rub-rub…"
	line "Rub-rub…"
	done

SSAnneCaptainsRoomIFeelMuchBetterText:
	text "CAPTAIN: Whew!"
	line "Thank you! I"
	cont "feel much better!"

	para "You want to see"
	line "my CUT technique?"

	para "I could show you"
	line "if I wasn't ill…"

	para "I know! You can"
	line "have this!"

	para "Teach it to your"
	line "#MON and you"
	cont "can see it CUT"
	cont "anytime!"
	prompt

; Yellow builds this from the item name at run time (text_ram wStringBuffer);
; `giveitem` fills no string buffer in GSC, and the project's idiom for a
; Yellow gift line is to spell the name out (OakGotPokedexText,
; VermilionCityOfficerJennyGotSquirtleText).  HM_CUT's name is "HM01".
SSAnneCaptainsRoomReceivedHM01Text:
	text "<PLAYER> got"
	line "HM01!"
	done

SSAnneCaptainsRoomNotSickAnymoreText:
	text "CAPTAIN: Whew!"

	para "Now that I'm not"
	line "sick anymore, I"
	cont "guess it's time."
	done

SSAnneCaptainsRoomHM01NoRoomText:
	text "Oh no! You have"
	line "no room for this!"
	done

SSAnneCaptainsRoomTrashText:
	text "Yuck! Shouldn't"
	line "have looked!"
	done

SSAnneCaptainsRoomSeasickBookText:
	text "How to Conquer"
	line "Seasickness…"
	cont "The CAPTAIN's"
	cont "reading this!"
	done

SSAnneCaptainsRoom_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  0,  7, SS_ANNE_2F, 9

	def_coord_events

	def_bg_events
	bg_event  4,  1, BGEVENT_READ, SSAnneCaptainsRoomTrash
	bg_event  1,  2, BGEVENT_READ, SSAnneCaptainsRoomSeasickBook

	def_object_events
	object_event  4,  2, SPRITE_CAPTAIN, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SSAnneCaptainsRoomCaptainScript, -1
