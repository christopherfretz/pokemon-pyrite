	object_const_def
	const MTMOON1F_HIKER
	const MTMOON1F_YOUNGSTER
	const MTMOON1F_LASS1
	const MTMOON1F_SUPER_NERD
	const MTMOON1F_LASS2
	const MTMOON1F_BUG_CATCHER1
	const MTMOON1F_BUG_CATCHER2
	const MTMOON1F_POTION1
	const MTMOON1F_MOON_STONE
	const MTMOON1F_RARE_CANDY
	const MTMOON1F_ESCAPE_ROPE
	const MTMOON1F_POTION2
	const MTMOON1F_TM_RAIN_DANCE

; Kanto hack: Mt. Moon 1F, from vendor/pokeyellow/maps/MtMoon1F.blk (converted
; in 5a) and vendor/pokeyellow/data/maps/objects/MtMoon1F.asm (docs/M2-MTMOON.md).
; 5b registered the map and its five warps; 5e adds Yellow's 7 trainers, 6
; itemballs and the ZUBAT sign. Coordinates, facings and sight ranges are
; Yellow's (the object list plus each MtMoon1TrainerHeaderN in
; vendor/pokeyellow/scripts/MtMoon1F.asm); text is Yellow's, verbatim
; (vendor/pokeyellow/text/MtMoon1F.asm), with Gen 1 `prompt` -> GSC `done`.
; Yellow's 1F has no hidden items (data/events/hidden_item_coords.asm lists
; only two, both on B2F, which is 5f's).
;
; Sprites: Yellow draws both of its OPP_BUG_CATCHERs with the youngster
; overworld sprite; we use SPRITE_BUG_CATCHER so the overworld sprite matches
; the battle class, as Route 3 and Viridian Forest do. Crystal has no
; SPRITE_HIKER, so the HIKER uses SPRITE_POKEFAN_M - what Crystal's own hikers
; on Route 33/45 use. Mt. Moon is an INDOOR/CAVE map, so its sprites are loaded
; from this object list, not from a group list in data/maps/outdoor_sprites.asm;
; trim_outdoor_sprites.py does not apply here.
;
; Item substitution (docs/M2-MTMOON.md section 2): Yellow's TM12 WATER GUN has
; no GSC equivalent (GSC has no water TM), so the itemball at (5,32) gives
; TM_RAIN_DANCE (GSC TM18) per the operator decision of 2026-09-17. Every other
; item is Yellow's and exists in Crystal: POTION, MOON_STONE, RARE_CANDY,
; ESCAPE_ROPE.
;
; Names: Yellow's trainers are anonymous. HIKER 1 -> MARCOS, YOUNGSTER 3 ->
; DUSTIN, LASS 5/6 -> MELISSA/NADINE, BUG_CATCHER 7/8 -> TRAVIS/NEIL (all new
; constants, appended to their classes); SUPER_NERD 1 reuses Crystal's unused
; SUPER_NERD GREGG slot, rewritten in place with Yellow's party.
;
; Flags: five in-scope Crystal flags were renamed in place (the list is
; positional, so renaming keeps every later index and existing savestates
; valid): EVENT_BEAT_PICNICKER_HOPE -> EVENT_BEAT_HIKER_MARCOS,
; EVENT_BEAT_PICNICKER_SHARON -> EVENT_BEAT_YOUNGSTER_DUSTIN,
; EVENT_MT_MOON_RIVAL -> EVENT_MT_MOON_1F_MOON_STONE,
; EVENT_MT_MOON_SQUARE_ROCK -> EVENT_MT_MOON_1F_RARE_CANDY and
; EVENT_MOUNT_MOON_SQUARE_HIDDEN_MOON_STONE -> EVENT_MT_MOON_1F_TM_RAIN_DANCE.
; The other seven are new; SUPER_NERD GREGG keeps Crystal's own
; EVENT_BEAT_SUPER_NERD_GREGG, which nothing used.

MtMoon1F_MapScripts:
	def_scene_scripts

	def_callbacks

TrainerHikerMarcos:
	trainer HIKER, MARCOS, EVENT_BEAT_HIKER_MARCOS, HikerMarcosSeenText, HikerMarcosBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext HikerMarcosAfterBattleText
	waitbutton
	closetext
	end

TrainerYoungsterDustin:
	trainer YOUNGSTER, DUSTIN, EVENT_BEAT_YOUNGSTER_DUSTIN, YoungsterDustinSeenText, YoungsterDustinBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext YoungsterDustinAfterBattleText
	waitbutton
	closetext
	end

TrainerLassMelissa:
	trainer LASS, MELISSA, EVENT_BEAT_LASS_MELISSA, LassMelissaSeenText, LassMelissaBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassMelissaAfterBattleText
	waitbutton
	closetext
	end

TrainerSuperNerdGregg:
	trainer SUPER_NERD, GREGG, EVENT_BEAT_SUPER_NERD_GREGG, SuperNerdGreggSeenText, SuperNerdGreggBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SuperNerdGreggAfterBattleText
	waitbutton
	closetext
	end

TrainerLassNadine:
	trainer LASS, NADINE, EVENT_BEAT_LASS_NADINE, LassNadineSeenText, LassNadineBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext LassNadineAfterBattleText
	waitbutton
	closetext
	end

TrainerBugCatcherTravis:
	trainer BUG_CATCHER, TRAVIS, EVENT_BEAT_BUG_CATCHER_TRAVIS, BugCatcherTravisSeenText, BugCatcherTravisBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BugCatcherTravisAfterBattleText
	waitbutton
	closetext
	end

TrainerBugCatcherNeil:
	trainer BUG_CATCHER, NEIL, EVENT_BEAT_BUG_CATCHER_NEIL, BugCatcherNeilSeenText, BugCatcherNeilBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BugCatcherNeilAfterBattleText
	waitbutton
	closetext
	end

MtMoon1FPotion1:
	itemball POTION

MtMoon1FMoonStone:
	itemball MOON_STONE

MtMoon1FRareCandy:
	itemball RARE_CANDY

MtMoon1FEscapeRope:
	itemball ESCAPE_ROPE

MtMoon1FPotion2:
	itemball POTION

MtMoon1FTMRainDance:
	itemball TM_RAIN_DANCE

MtMoon1FZubatSign:
	jumptext MtMoon1FZubatSignText

HikerMarcosSeenText:
	text "WHOA! You shocked"
	line "me! Oh, you're"
	cont "just a kid!"
	done

HikerMarcosBeatenText:
	text "Wow!"
	line "Shocked again!"
	done

HikerMarcosAfterBattleText:
	text "Kids like you"
	line "shouldn't be"
	cont "here!"
	done

YoungsterDustinSeenText:
	text "Did you come to"
	line "explore too?"
	done

YoungsterDustinBeatenText:
	text "Losing"
	line "stinks!"
	done

YoungsterDustinAfterBattleText:
	text "I came down here"
	line "to show off to"
	cont "girls."
	done

LassMelissaSeenText:
	text "Wow! It's way"
	line "bigger in here"
	cont "than I thought!"
	done

LassMelissaBeatenText:
	text "Oh!"
	line "I lost it!"
	done

LassMelissaAfterBattleText:
	text "How do you get"
	line "out of here?"
	done

SuperNerdGreggSeenText:
	text "What! Don't sneak"
	line "up on me!"
	done

SuperNerdGreggBeatenText:
	text "My"
	line "#MON won't do!"
	done

SuperNerdGreggAfterBattleText:
	text "I have to find"
	line "stronger #MON."
	done

LassNadineSeenText:
	text "What? I'm waiting"
	line "for my friends to"
	cont "find me here."
	done

LassNadineBeatenText:
	text "I lost?"
	done

LassNadineAfterBattleText:
	text "I heard there are"
	line "some very rare"
	cont "fossils here."
	done

BugCatcherTravisSeenText:
	text "Suspicious men"
	line "are in the cave."
	cont "What about you?"
	done

BugCatcherTravisBeatenText:
	text "You"
	line "got me!"
	done

BugCatcherTravisAfterBattleText:
	text "I saw them! I'm"
	line "sure they're from"
	cont "TEAM ROCKET!"
	done

BugCatcherNeilSeenText:
	text "Go through this"
	line "cave to get to"
	cont "CERULEAN CITY!"
	done

BugCatcherNeilBeatenText:
	text "I"
	line "lost."
	done

BugCatcherNeilAfterBattleText:
	text "ZUBAT is tough!"
	line "But, it can be"
	cont "useful if you"
	cont "catch one."
	done

MtMoon1FZubatSignText:
	text "Beware! ZUBAT is"
	line "a bloodsucker!"
	done

MtMoon1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 14, 35, ROUTE_4, 2
	warp_event 15, 35, ROUTE_4, 2
	warp_event  5,  5, MT_MOON_B1F, 1
	warp_event 17, 11, MT_MOON_B1F, 3
	warp_event 25, 15, MT_MOON_B1F, 4

	def_coord_events

	def_bg_events
	bg_event 15, 23, BGEVENT_READ, MtMoon1FZubatSign

	def_object_events
	object_event  5,  6, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 2, TrainerHikerMarcos, -1
	object_event 12, 16, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerYoungsterDustin, -1
	object_event 30,  4, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerLassMelissa, -1
	object_event 24, 31, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerSuperNerdGregg, -1
	object_event 16, 23, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerLassNadine, -1
	object_event  7, 22, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerBugCatcherTravis, -1
	object_event 30, 27, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerBugCatcherNeil, -1
	object_event  2, 20, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, MtMoon1FPotion1, EVENT_MT_MOON_1F_POTION_1
	object_event  2,  2, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, MtMoon1FMoonStone, EVENT_MT_MOON_1F_MOON_STONE
	object_event 35, 31, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, MtMoon1FRareCandy, EVENT_MT_MOON_1F_RARE_CANDY
	object_event 36, 23, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, MtMoon1FEscapeRope, EVENT_MT_MOON_1F_ESCAPE_ROPE
	object_event 20, 33, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, MtMoon1FPotion2, EVENT_MT_MOON_1F_POTION_2
	object_event  5, 32, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, MtMoon1FTMRainDance, EVENT_MT_MOON_1F_TM_RAIN_DANCE
