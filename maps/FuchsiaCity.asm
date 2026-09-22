; Kanto hack (docs/M7-FUCHSIA.md, 10f): FUCHSIA CITY re-cut to Yellow's layout.
; Objects, signs and warps are Yellow's (data/maps/objects/FuchsiaCity.asm),
; text is Yellow's (text/FuchsiaCity.asm) verbatim.  The six zoo enclosure
; #MON are Yellow's, on the substituted sprites named beside each one; their
; signs open the #dex entry the way Yellow's `DisplayPokedex` does, through
; the new ShowPokedexEntry special.  Every Crystal-era string (the SAFARI ZONE
; is closed / JANINE / no-littering set) is gone, and so is the Gen 2 fruit
; tree -- Yellow's cut has border trees at (8,1) (D66, same call as 10c).
;
; Warps 1-9 are Yellow's, in Yellow's order -- and now they are ALL the warps.
; M9 12c/D98 retired ROUTE_19_FUCHSIA_GATE: Yellow has no gate south of
; FUCHSIA, so the two gate warps (10/11, deliberately kept last by 10f) are
; deleted and nothing renumbers.  The south edge is Yellow's again -- plain
; FLOOR, walked off onto ROUTE 19 by the `connection south` at offset 5.
; Warp 9 (the
; good-rod house back door at 31,24) is the new $c5 metatile: art of Yellow's
; $38 with a LADDER quadrant, the Celadon-mansion-back-door trick, because a
; GSC warp needs a $7x collision and that door is the only way into the
; north-east yard.

	object_const_def
	const FUCHSIACITY_YOUNGSTER1
	const FUCHSIACITY_GAMBLER
	const FUCHSIACITY_ERIK
	const FUCHSIACITY_YOUNGSTER2
	const FUCHSIACITY_CHANSEY
	const FUCHSIACITY_VOLTORB
	const FUCHSIACITY_KANGASKHAN
	const FUCHSIACITY_SLOWPOKE
	const FUCHSIACITY_LAPRAS
	const FUCHSIACITY_FOSSIL

FuchsiaCity_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_NEWMAP, FuchsiaCityFlypointCallback

FuchsiaCityFlypointCallback:
	setflag ENGINE_FLYPOINT_FUCHSIA
	endcallback

FuchsiaCityYoungster1:
	jumptextfaceplayer FuchsiaCityYoungster1Text

FuchsiaCityGambler:
	jumptextfaceplayer FuchsiaCityGamblerText

FuchsiaCityErik:
	jumptextfaceplayer FuchsiaCityErikText

FuchsiaCityYoungster2:
	jumptextfaceplayer FuchsiaCityYoungster2Text

; The six zoo #MON all share Yellow's one-character "!" text.  They sit in
; sealed enclosures, exactly as in Yellow, so the player cannot reach them --
; the pens are read from outside, through the signs below.
FuchsiaCityChansey:
	jumptextfaceplayer FuchsiaCityPokemonText

FuchsiaCityVoltorb:
	jumptext FuchsiaCityPokemonText

FuchsiaCityKangaskhan:
	jumptextfaceplayer FuchsiaCityPokemonText

FuchsiaCitySlowpoke:
	jumptextfaceplayer FuchsiaCityPokemonText

FuchsiaCityLapras:
	jumptextfaceplayer FuchsiaCityPokemonText

FuchsiaCityFossil:
	jumptext FuchsiaCityPokemonText

FuchsiaCitySign:
	jumptext FuchsiaCitySignText

FuchsiaCitySafariGameSign:
	jumptext FuchsiaCitySafariGameSignText

FuchsiaCityWardensHomeSign:
	jumptext FuchsiaCityWardensHomeSignText

FuchsiaCitySafariZoneSign:
	jumptext FuchsiaCitySafariZoneSignText

FuchsiaCityGymSign:
	jumptext FuchsiaCityGymSignText

FuchsiaCityPokecenterSign:
	jumpstd PokecenterSignScript

FuchsiaCityMartSign:
	jumpstd MartSignScript

FuchsiaCityChanseySign:
	opentext
	writetext FuchsiaCityChanseySignText
	waitbutton
	setval CHANSEY
	special ShowPokedexEntry
	closetext
	end

FuchsiaCityVoltorbSign:
	opentext
	writetext FuchsiaCityVoltorbSignText
	waitbutton
	setval VOLTORB
	special ShowPokedexEntry
	closetext
	end

FuchsiaCityKangaskhanSign:
	opentext
	writetext FuchsiaCityKangaskhanSignText
	waitbutton
	setval KANGASKHAN
	special ShowPokedexEntry
	closetext
	end

FuchsiaCitySlowpokeSign:
	opentext
	writetext FuchsiaCitySlowpokeSignText
	waitbutton
	setval SLOWPOKE
	special ShowPokedexEntry
	closetext
	end

FuchsiaCityLaprasSign:
	opentext
	writetext FuchsiaCityLaprasSignText
	waitbutton
	setval LAPRAS
	special ShowPokedexEntry
	closetext
	end

; Yellow branches on EVENT_GOT_DOME_FOSSIL / EVENT_GOT_HELIX_FOSSIL, which it
; sets one-per-fossil in MT.MOON.  Our MT.MOON B2F clears BOTH object flags
; whichever fossil you take (the flags mean "that object is gone"), so they
; cannot say which one you own -- ask the bag instead, which is what Yellow's
; own CINNABAR LAB does.  Caveat: once the fossil is revived the item leaves
; the bag and this sign goes back to "...".
FuchsiaCityFossilSign:
	opentext
	checkitem DOME_FOSSIL
	iftrue .Omanyte
	checkitem HELIX_FOSSIL
	iftrue .Kabuto
	writetext FuchsiaCityFossilSignUndeterminedText
	waitbutton
	closetext
	end

.Omanyte:
	writetext FuchsiaCityFossilSignOmanyteText
	waitbutton
	setval OMANYTE
	special ShowPokedexEntry
	closetext
	end

.Kabuto:
	writetext FuchsiaCityFossilSignKabutoText
	waitbutton
	setval KABUTO
	special ShowPokedexEntry
	closetext
	end

FuchsiaCityYoungster1Text:
	text "Did you try the"
	line "SAFARI GAME? Some"
	cont "#MON can only"
	cont "be caught there."
	done

FuchsiaCityGamblerText:
	text "SAFARI ZONE has a"
	line "zoo in front of"
	cont "the entrance."

	para "Out back is the"
	line "SAFARI GAME for"
	cont "catching #MON."
	done

FuchsiaCityErikText:
	text "ERIK: Where's"
	line "SARA? I said I'd"
	cont "meet her here."
	done

FuchsiaCityYoungster2Text:
	text "That item ball in"
	line "there is really a"
	cont "#MON."
	done

FuchsiaCityPokemonText:
	text "!"
	done

FuchsiaCitySignText:
	text "FUCHSIA CITY"
	line "Behold! It's"
	cont "Passion Pink!"
	done

FuchsiaCitySafariGameSignText:
	text "SAFARI GAME"
	line "#MON-U-CATCH!"
	done

FuchsiaCityWardensHomeSignText:
	text "SAFARI ZONE"
	line "WARDEN's HOME"
	done

FuchsiaCitySafariZoneSignText:
	text "#MON PARADISE"
	line "SAFARI ZONE"
	done

FuchsiaCityGymSignText:
	text "FUCHSIA CITY"
	line "#MON GYM"
	cont "LEADER: KOGA"

	para "The Poisonous"
	line "Ninja Master!"
	done

FuchsiaCityChanseySignText:
	text "Name: CHANSEY"

	para "Catching one is"
	line "all up to chance."
	done

FuchsiaCityVoltorbSignText:
	text "Name: VOLTORB"

	para "The very image of"
	line "a # BALL."
	done

FuchsiaCityKangaskhanSignText:
	text "Name: KANGASKHAN"

	para "A maternal #MON"
	line "that raises its"
	cont "young in a pouch"
	cont "on its belly."
	done

FuchsiaCitySlowpokeSignText:
	text "Name: SLOWPOKE"

	para "Friendly and very"
	line "slow moving."
	done

FuchsiaCityLaprasSignText:
	text "Name: LAPRAS"

	para "A.K.A. the king"
	line "of the seas."
	done

FuchsiaCityFossilSignOmanyteText:
	text "Name: OMANYTE"

	para "A #MON that"
	line "was resurrected"
	cont "from a fossil."
	done

FuchsiaCityFossilSignKabutoText:
	text "Name: KABUTO"

	para "A #MON that"
	line "was resurrected"
	cont "from a fossil."
	done

FuchsiaCityFossilSignUndeterminedText:
	text "…"
	done

FuchsiaCity_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  5, 13, FUCHSIA_MART, 2
	warp_event 11, 27, BILLS_OLDER_SISTERS_HOUSE, 1
	warp_event 19, 27, FUCHSIA_POKECENTER_1F, 1
	warp_event 27, 27, SAFARI_ZONE_WARDENS_HOME, 1
	warp_event 18,  3, SAFARI_ZONE_GATE, 1
	warp_event  5, 27, FUCHSIA_GYM, 1
	warp_event 22, 13, FUCHSIA_MEETING_ROOM, 1
	warp_event 31, 27, FUCHSIA_GOOD_ROD_HOUSE, 2
	warp_event 31, 24, FUCHSIA_GOOD_ROD_HOUSE, 1 ; the back door, on the $c5 LADDER metatile

	def_coord_events

	def_bg_events
	bg_event 15, 23, BGEVENT_READ, FuchsiaCitySign ; inaccessible in Yellow too
	bg_event 25, 15, BGEVENT_READ, FuchsiaCitySign
	bg_event 17,  5, BGEVENT_READ, FuchsiaCitySafariGameSign
	bg_event  6, 13, BGEVENT_READ, FuchsiaCityMartSign
	bg_event 20, 27, BGEVENT_READ, FuchsiaCityPokecenterSign
	bg_event 27, 29, BGEVENT_READ, FuchsiaCityWardensHomeSign
	bg_event 21, 15, BGEVENT_READ, FuchsiaCitySafariZoneSign
	bg_event  5, 29, BGEVENT_READ, FuchsiaCityGymSign
	bg_event 33,  7, BGEVENT_READ, FuchsiaCityChanseySign
	bg_event 27,  7, BGEVENT_READ, FuchsiaCityVoltorbSign
	bg_event 13,  7, BGEVENT_READ, FuchsiaCityKangaskhanSign
	bg_event 31, 13, BGEVENT_READ, FuchsiaCitySlowpokeSign
	bg_event 13, 15, BGEVENT_READ, FuchsiaCityLaprasSign
	bg_event  7,  7, BGEVENT_READ, FuchsiaCityFossilSign

	def_object_events
	object_event 10, 12, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, FuchsiaCityYoungster1, -1
	object_event 28, 17, SPRITE_OLD_MAN, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, FuchsiaCityGambler, -1 ; Yellow's GAMBLER
	object_event 30, 14, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, FuchsiaCityErik, -1
	object_event 24,  8, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, FuchsiaCityYoungster2, -1
	object_event 31,  5, SPRITE_CHANSEY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, FuchsiaCityChansey, -1
	object_event 25,  6, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, FuchsiaCityVoltorb, -1 ; Yellow's VOLTORB-as-item-ball
	object_event 12,  6, SPRITE_MONSTER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, FuchsiaCityKangaskhan, -1 ; KANGASKHAN
	object_event 30, 12, SPRITE_MONSTER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, FuchsiaCitySlowpoke, -1 ; SLOWPOKE
	; Yellow's SEEL is ANY_DIR and wanders its POND: Gen 1's one collision list
	; covers water, so a plain wandering NPC swims in it.  GSC splits the two
	; (CanObjectMoveInDirection -> WillObjectBumpIntoWater), so the faithful
	; movedata here is SWIM_WANDER -- WANDER plus the SWIMMING palette flag,
	; exactly what Crystal's own UNION CAVE B2F LAPRAS uses.  The vanilla
	; "swimming NPCs ignore their radius" bug is harmless: the pen's water is
	; closed, so WillObjectBumpIntoLand is the fence.
	object_event  8, 17, SPRITE_SEEL_OW, SPRITEMOVEDATA_SWIM_WANDER, 2, 2, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, FuchsiaCityLapras, -1 ; Yellow's SPRITE_SEEL is LAPRAS here
	object_event  6,  5, SPRITE_FOSSIL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, FuchsiaCityFossil, -1
