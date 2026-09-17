; 6k: Yellow's CERULEAN_BADGE_HOUSE -- the badge-speech house that doubles as
; the pass-through corridor to the Cerulean Cave shelf
; (vendor/pokeyellow/scripts/CeruleanBadgeHouse.asm,
; data/maps/objects/CeruleanBadgeHouse.asm, text/CeruleanBadgeHouse.asm +
; text/CeruleanBadgeHouse_2.asm; docs/M3-CERULEAN.md 3.9 and "6k findings").
;
; 6a laid in the geometry: warp 1 is the gap in the back wall at OUR interior
; (2,0) -- Yellow's own badge house puts its back door at (2,0) too, so unlike
; the trashed house nothing had to move -- and warps 2/3 are the front door.
; The room is `House1Hole.blk`, SHARED with CERULEAN_TRASHED_HOUSE
; (hack/data/maps/blocks.asm), so it is deliberately left alone here: re-cutting
; a proper TILESET_HOUSE back door would need a new metatile and would move the
; trashed house's Rocket hole with it.
;
; The man is Yellow's `SPRITE_MIDDLE_AGED_MAN` at (5,3) facing RIGHT ->
; SPRITE_POKEFAN_M (survey 2).
;
; Yellow drives him with a SPECIALLISTMENU over a static list of all eight
; badges and prints whichever one you pick, owned or not.  GSC has no list menu
; that can render badges, so this is the survey's recommended shape: eight
; `checkflag ENGINE_*BADGE` branches that print Yellow's per-badge text for the
; badges you actually hold, in badge order, then Yellow's sign-off.  Two
; consequences, both deliberate:
;   * you can no longer read about a badge you have not earned;
;   * a zero-badge player gets a short "come back" line of our own, because
;     Yellow's greeting ("I see you have at least one") assumes at least one.
;     Unreachable in practice -- Pewter's youngster blocks the road east until
;     BOULDERBADGE -- but the harness can force it.
; Yellow's BOULDERBADGE/CASCADEBADGE text is accurate for this hack as shipped:
; FLASH is gated on ENGINE_BOULDERBADGE (M2 4e) and CUT on ENGINE_CASCADEBADGE
; (6e).  The other six describe Yellow's gating and are unchanged.
	object_const_def
	const CERULEANBADGEHOUSE_MIDDLE_AGED_MAN

CeruleanBadgeHouse_MapScripts:
	def_scene_scripts

	def_callbacks

CeruleanBadgeHouseMiddleAgedManScript:
	faceplayer
	opentext
	checkflag ENGINE_BOULDERBADGE
	iftrue .HasABadge
	checkflag ENGINE_CASCADEBADGE
	iftrue .HasABadge
	checkflag ENGINE_THUNDERBADGE
	iftrue .HasABadge
	checkflag ENGINE_RAINBOWBADGE
	iftrue .HasABadge
	checkflag ENGINE_SOULBADGE
	iftrue .HasABadge
	checkflag ENGINE_MARSHBADGE
	iftrue .HasABadge
	checkflag ENGINE_VOLCANOBADGE
	iftrue .HasABadge
	checkflag ENGINE_EARTHBADGE
	iftrue .HasABadge
	writetext CeruleanBadgeHouseNoBadgeText
	waitbutton
	closetext
	end

.HasABadge:
	writetext CeruleanBadgeHouseGreetingText
	waitbutton
	writetext CeruleanBadgeHouseNowThenText
	waitbutton
	checkflag ENGINE_BOULDERBADGE
	iffalse .NoBoulder
	writetext CeruleanBadgeHouseBoulderBadgeText
	waitbutton
.NoBoulder:
	checkflag ENGINE_CASCADEBADGE
	iffalse .NoCascade
	writetext CeruleanBadgeHouseCascadeBadgeText
	waitbutton
.NoCascade:
	checkflag ENGINE_THUNDERBADGE
	iffalse .NoThunder
	writetext CeruleanBadgeHouseThunderBadgeText
	waitbutton
.NoThunder:
	checkflag ENGINE_RAINBOWBADGE
	iffalse .NoRainbow
	writetext CeruleanBadgeHouseRainbowBadgeText
	waitbutton
.NoRainbow:
	checkflag ENGINE_SOULBADGE
	iffalse .NoSoul
	writetext CeruleanBadgeHouseSoulBadgeText
	waitbutton
.NoSoul:
	checkflag ENGINE_MARSHBADGE
	iffalse .NoMarsh
	writetext CeruleanBadgeHouseMarshBadgeText
	waitbutton
.NoMarsh:
	checkflag ENGINE_VOLCANOBADGE
	iffalse .NoVolcano
	writetext CeruleanBadgeHouseVolcanoBadgeText
	waitbutton
.NoVolcano:
	checkflag ENGINE_EARTHBADGE
	iffalse .NoEarth
	writetext CeruleanBadgeHouseEarthBadgeText
	waitbutton
.NoEarth:
	writetext CeruleanBadgeHouseVisitAnyTimeText
	waitbutton
	closetext
	end

CeruleanBadgeHouseGreetingText:
	text "#MON BADGEs"
	line "are owned only by"
	cont "skilled trainers."

	para "I see you have"
	line "at least one."

	para "Those BADGEs have"
	line "amazing secrets!"
	done

; Yellow: "Which of the 8 BADGEs should I describe?" -- there is nothing to
; pick from here, so he just runs down the ones you have.
CeruleanBadgeHouseNowThenText:
	text "Now then..."

	para "Let me tell you"
	line "about the BADGEs"
	cont "you've earned."
	done

; Ours, not Yellow's: Yellow cannot reach this state.
CeruleanBadgeHouseNoBadgeText:
	text "#MON BADGEs"
	line "are owned only by"
	cont "skilled trainers."

	para "You haven't got"
	line "even one yet!"

	para "Win a BADGE, then"
	line "come see me. I'll"
	cont "tell you all"
	cont "their secrets!"
	done

CeruleanBadgeHouseBoulderBadgeText:
	text "BOULDERBADGE..."

	para "The ATTACK of all"
	line "#MON increases"
	cont "a little bit."

	para "It also lets you"
	line "use FLASH any-"
	cont "time you desire."
	done

CeruleanBadgeHouseCascadeBadgeText:
	text "CASCADEBADGE..."

	para "#MON up to L30"
	line "will obey you."

	para "Any higher, they"
	line "become unruly!"

	para "It also lets you"
	line "use CUT outside"
	cont "of battle."
	done

CeruleanBadgeHouseThunderBadgeText:
	text "THUNDERBADGE..."

	para "The SPEED of all"
	line "#MON increases"
	cont "a little bit."

	para "It also lets you"
	line "use FLY outside"
	cont "of battle."
	done

CeruleanBadgeHouseRainbowBadgeText:
	text "RAINBOWBADGE..."

	para "#MON up to L50"
	line "will obey you."

	para "Any higher, they"
	line "become unruly!"

	para "It also lets you"
	line "use STRENGTH out-"
	cont "side of battle."
	done

CeruleanBadgeHouseSoulBadgeText:
	text "SOULBADGE..."

	para "The DEFENSE of all"
	line "#MON increases"
	cont "a little bit."

	para "It also lets you"
	line "use SURF outside"
	cont "of battle."
	done

CeruleanBadgeHouseMarshBadgeText:
	text "MARSHBADGE..."

	para "#MON up to L70"
	line "will obey you."

	para "Any higher, they"
	line "become unruly!"
	done

CeruleanBadgeHouseVolcanoBadgeText:
	text "VOLCANOBADGE..."

	para "Your #MON's"
	line "SPECIAL abilities"
	cont "increase a bit."
	done

CeruleanBadgeHouseEarthBadgeText:
	text "EARTHBADGE..."

	para "All #MON will"
	line "obey you!"
	done

CeruleanBadgeHouseVisitAnyTimeText:
	text "Come visit me any-"
	line "time you wish."
	done

CeruleanBadgeHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  0, CERULEAN_CITY, 10 ; gap in the back wall (Yellow: 2, 0 too)
	warp_event  2,  7, CERULEAN_CITY, 9
	warp_event  3,  7, CERULEAN_CITY, 9

	def_coord_events

	def_bg_events

	def_object_events
	object_event  5,  3, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, CeruleanBadgeHouseMiddleAgedManScript, -1
