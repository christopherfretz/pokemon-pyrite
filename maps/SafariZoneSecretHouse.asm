; Kanto hack: Yellow's SECRET HOUSE (docs/M7-FUCHSIA.md 10m).  The prize at the
; far north-west corner of SAFARI ZONE WEST: a FISHING GURU who hands over HM03
; SURF, once, the first time anyone reaches him.  Every line is Yellow's
; verbatim (vendor/pokeyellow/{data/maps/objects,scripts,text}/
; SafariZoneSecretHouse.asm), including Yellow's ordering -- the first talk ends
; on "You have won!" plus the give, and the HM03 explanation is what he says on
; every talk AFTER that.
;
; The room is re-cut to Yellow's 4x4 on Crystal's LAB blockset (Yellow's LAB
; block ids do not map onto Crystal's one for one -- the 10g ruling), keeping
; Yellow's exact solid/floor footprint: a cabinet wall across the top, a cabinet
; flanking each side below it, and the door at Yellow's (2,7)/(3,7).  The
; FISHING GURU's tile (3,3) is floor.  BOTH door tiles return to SAFARI_ZONE_WEST
; warp 7, as Yellow does.
;
; The give reuses EVENT_GOT_HM03_SURF -- the flag Crystal's ECRUTEAK DANCE
; THEATRE giver already owns -- rather than adding a new one, exactly as 10g's
; WARDEN reuses EVENT_GOT_HM04_STRENGTH.  Consequence to re-route in Johto: the
; DANCE THEATRE Kimono Girls' HM03 hand-out is now dead code once the player has
; been here, so when Johto is re-routed that scene needs a different reward (see
; docs/M7-FUCHSIA.md "## 10m findings").
	object_const_def
	const SAFARIZONESECRETHOUSE_FISHING_GURU

SafariZoneSecretHouse_MapScripts:
	def_scene_scripts

	def_callbacks

SafariZoneSecretHouseFishingGuruScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_HM03_SURF
	iftrue .Explanation
	writetext SafariZoneSecretHouseYouHaveWonText
	promptbutton
	verbosegiveitem HM_SURF
	iffalse .NoRoom
	setevent EVENT_GOT_HM03_SURF
	closetext
	end

.NoRoom:
	writetext SafariZoneSecretHouseNoRoomText
	waitbutton
	closetext
	end

.Explanation:
	writetext SafariZoneSecretHouseHM03ExplanationText
	waitbutton
	closetext
	end

SafariZoneSecretHouseYouHaveWonText:
	text "Ah! Finally!"

	para "You're the first"
	line "person to reach"
	cont "the SECRET HOUSE!"

	para "I was getting"
	line "worried that no"
	cont "one would win our"
	cont "campaign prize."

	para "Congratulations!"
	line "You have won!"
	prompt

SafariZoneSecretHouseHM03ExplanationText:
	text "HM03 is SURF!"

	para "#MON will be"
	line "able to ferry you"
	cont "across water!"

	para "And, this HM isn't"
	line "disposable! You"
	cont "can use it over"
	cont "and over!"

	para "You're super lucky"
	line "for winning this"
	cont "fabulous prize!"
	done

SafariZoneSecretHouseNoRoomText:
	text "You don't have"
	line "room for this"
	cont "fabulous prize!"
	done

SafariZoneSecretHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, SAFARI_ZONE_WEST, 7
	warp_event  3,  7, SAFARI_ZONE_WEST, 7

	def_coord_events

	def_bg_events

	def_object_events
	object_event  3,  3, SPRITE_FISHING_GURU, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, SafariZoneSecretHouseFishingGuruScript, -1
