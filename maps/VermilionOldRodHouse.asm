; Kanto hack: Yellow's VERMILION_OLD_ROD_HOUSE
; (vendor/pokeyellow/data/maps/objects/VermilionOldRodHouse.asm,
; scripts/VermilionOldRodHouse.asm, text/VermilionOldRodHouse.asm).  This map is
; Crystal's VERMILION_DIGLETTS_CAVE_SPEECH_HOUSE slot, renamed in 7e; Crystal's
; DIGLETT-tunnel gentleman is gone.
;
; Yellow's one object, the FISHING GURU, keeps his own tile (2,4) facing RIGHT.
; Yellow gates the gift on wStatusFlags1's BIT_GOT_OLD_ROD; ours is Crystal's
; existing EVENT_GOT_OLD_ROD -- the same "you already have the OLD ROD" bit that
; Crystal's ROUTE_32 fisher reads, so the rod is still given exactly once.
	object_const_def
	const VERMILIONOLDRODHOUSE_FISHING_GURU

VermilionOldRodHouse_MapScripts:
	def_scene_scripts

	def_callbacks

VermilionOldRodHouseFishingGuruScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_OLD_ROD
	iftrue .GotOldRod
	writetext VermilionOldRodHouseFishingGuruDoYouLikeToFishText
	yesorno
	iffalse .Refused
	writetext VermilionOldRodHouseFishingGuruTakeThisText
	promptbutton
	verbosegiveitem OLD_ROD
	iffalse .NoRoom
	setevent EVENT_GOT_OLD_ROD
	writetext VermilionOldRodHouseFishingGuruFishingIsAWayOfLifeText
	waitbutton
	closetext
	end

.Refused:
	writetext VermilionOldRodHouseFishingGuruThatsSoDisappointingText
	waitbutton
	closetext
	end

.NoRoom:
	writetext VermilionOldRodHouseFishingGuruNoRoomText
	waitbutton
	closetext
	end

.GotOldRod:
	writetext VermilionOldRodHouseFishingGuruHowAreTheFishBitingText
	waitbutton
	closetext
	end

VermilionOldRodHouseFishingGuruDoYouLikeToFishText:
	text "I'm the FISHING"
	line "GURU!"

	para "I simply Looove"
	line "fishing!"

	para "Do you like to"
	line "fish?"
	done

VermilionOldRodHouseFishingGuruTakeThisText:
	text "Grand! I like"
	line "your style!"

	para "Take this and"
	line "fish, young one!"
	done

; Yellow's _..TakeThisText ends with its own "<PLAYER> received an OLD ROD!"
; paragraph and a sound_get_item_1; here that line and the jingle are
; verbosegiveitem's shared _ReceivedItemText + specialsound (N1a already gave
; that string Yellow's voice), so this text picks up straight after the gift.
VermilionOldRodHouseFishingGuruFishingIsAWayOfLifeText:
	text "Fishing is a way"
	line "of life!"

	para "From the seas to"
	line "rivers, go out"
	cont "and land the big"
	cont "one, young one!"
	done

VermilionOldRodHouseFishingGuruThatsSoDisappointingText:
	text "Oh... That's so"
	line "disappointing..."
	done

VermilionOldRodHouseFishingGuruHowAreTheFishBitingText:
	text "Hello there,"
	line "<PLAYER>!"

	para "How are the fish"
	line "biting?"
	done

VermilionOldRodHouseFishingGuruNoRoomText:
	text "Oh no!"

	para "You have no room"
	line "for my gift!"
	done

VermilionOldRodHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, VERMILION_CITY, 9
	warp_event  3,  7, VERMILION_CITY, 9

	def_coord_events

	def_bg_events

	def_object_events
	object_event  2,  4, SPRITE_FISHING_GURU, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, VermilionOldRodHouseFishingGuruScript, -1
