	object_const_def
	const ROUTE4_LASS1
	const ROUTE4_LASS2
	const ROUTE4_POKE_BALL

; Kanto hack: Yellow's Route 4 (docs/M2-MTMOON.md). The map was re-cut from
; Yellow in 5b (45x9, south to Route 3, east to Cerulean, the three Mt. Moon
; doors on the west plateau); 5d replaces Crystal's three trainers, HP_UP
; itemball and hidden ULTRA_BALL with Yellow's objects. Coordinates, facings
; and sight ranges are Yellow's (vendor/pokeyellow/data/maps/objects/Route4.asm
; + scripts/Route4.asm's trainer header + data/events/hidden_events.asm); text
; is Yellow's, verbatim. Yellow's anonymous LASS 4 gets the GSC name TAMARA;
; her party is Yellow's L31 PARAS/PARAS/PARASECT as-is (operator decision
; 2026-09-17) - she guards the east descent and is meant to be fought on the
; way back from Cerulean.
;
; KNOWN GAP, not a bug in this step: TAMARA's ledge plateau (tile rows 2-4,
; cols 61-79, plus the row-4 corridor out to the east edge) is a one-way drop.
; In Yellow you can only enter it from Cerulean at Route 4 (89,4); our .blk is
; byte-for-byte Yellow's, so that is still true here. But Cerulean is still
; Crystal's map, and our `connection east, CeruleanCity, CERULEAN_CITY, -5`
; (attributes.asm) maps Route 4 y=4 to Cerulean y=14, which is water on
; Crystal's west shore. Yellow uses -4 (y=4 -> Cerulean y=12, land) but that
; would land the main road (y=10/11) in Crystal's water at y=18/19, so no
; single offset serves both openings against Crystal's Cerulean. The fix is
; the Cerulean re-cut: with Yellow's Cerulean and offset -4 both openings line
; up exactly as they do in Yellow. Until then TAMARA is simply unreachable -
; no soft lock, nothing else on the map depends on her.
;
; Items (docs/M2-MTMOON.md section 2): the itemball at (57,3) is Yellow's TM04
; WHIRLWIND, which M3b (docs/M3B-TM-UNION.md) made a real TM item; it shipped
; as the stand-in TM_ROAR until then. The hidden item is Yellow's GREAT_BALL at
; (40,3) - the survey's section 2 claim that Route 4 has no hidden items was
; wrong, and its "hidden ULTRA_BALL" was Crystal's, not Yellow's.
;
; Flags: no new ones. EVENT_BEAT_BIRD_KEEPER_HANK -> EVENT_BEAT_LASS_TAMARA,
; EVENT_ROUTE_4_HP_UP -> EVENT_ROUTE_4_TM_WHIRLWIND and
; EVENT_ROUTE_4_HIDDEN_ULTRA_BALL -> EVENT_ROUTE_4_HIDDEN_GREAT_BALL, all
; renamed in place (the flag list is positional, so renaming keeps every later
; index and existing savestates valid).
Route4_MapScripts:
	def_scene_scripts

	def_callbacks

TrainerLassTamara:
	trainer LASS, TAMARA, EVENT_BEAT_LASS_TAMARA, LassTamaraSeenText, LassTamaraBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassTamaraAfterBattleText
	waitbutton
	closetext
	end

Route4LassScript:
	jumptextfaceplayer Route4LassText

Route4PokecenterSign:
	jumpstd PokecenterSignScript

Route4MtMoonSign:
	jumptext Route4MtMoonSignText

Route4Sign:
	jumptext Route4SignText

Route4TMWhirlwind:
	itemball TM_WHIRLWIND

Route4HiddenGreatBall:
	hiddenitem GREAT_BALL, EVENT_ROUTE_4_HIDDEN_GREAT_BALL

Route4LassText:
	text "Ouch! I tripped"
	line "over a rocky"
	cont "#MON, GEODUDE!"
	done

LassTamaraSeenText:
	text "I came to get my"
	line "mushroom #MON!"
	done

LassTamaraBeatenText:
	text "Oh! My cute"
	line "mushroom #MON!"
	done

LassTamaraAfterBattleText:
	text "There might not"
	line "be any more"
	cont "mushrooms here."

	para "I think I got"
	line "them all."
	done

Route4MtMoonSignText:
	text "MT.MOON"
	line "Tunnel Entrance"
	done

Route4SignText:
	text "ROUTE 4"
	line "MT.MOON -"
	cont "CERULEAN CITY"
	done

Route4_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 11,  5, MT_MOON_POKECENTER, 1
	warp_event 18,  5, MT_MOON_1F, 1
	warp_event 24,  5, MT_MOON_B1F, 8

	def_coord_events

	def_bg_events
	bg_event 12,  5, BGEVENT_READ, Route4PokecenterSign
	bg_event 17,  7, BGEVENT_READ, Route4MtMoonSign
	bg_event 27,  7, BGEVENT_READ, Route4Sign
	bg_event 40,  3, BGEVENT_ITEM, Route4HiddenGreatBall

	def_object_events
	object_event  9,  8, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route4LassScript, -1
	object_event 63,  3, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerLassTamara, -1
	object_event 57,  3, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route4TMWhirlwind, EVENT_ROUTE_4_TM_WHIRLWIND
