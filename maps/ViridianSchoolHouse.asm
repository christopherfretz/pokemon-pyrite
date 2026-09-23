; Kanto hack (docs/AUDIT-NPC-TEXT.md, N1c): Yellow's VIRIDIAN SCHOOL HOUSE,
; ported onto the Viridian warp Crystal gave the TRAINER HOUSE.  Map data is
; Yellow's 4x4 room byte-for-byte (maps/ViridianSchoolHouse.blk) on
; TILESET_HOUSE, which kept Yellow's blackboard and school-desk metatiles.
	object_const_def
	const VIRIDIANSCHOOLHOUSE_BRUNETTE_GIRL
	const VIRIDIANSCHOOLHOUSE_COOLTRAINER_F
	const VIRIDIANSCHOOLHOUSE_LITTLE_GIRL

ViridianSchoolHouse_MapScripts:
	def_scene_scripts

	def_callbacks

ViridianSchoolHouseBrunetteGirlScript:
	jumptextfaceplayer ViridianSchoolHouseBrunetteGirlText

ViridianSchoolHouseCooltrainerFScript:
	jumptextfaceplayer ViridianSchoolHouseCooltrainerFText

ViridianSchoolHouseLittleGirlScript:
	jumptextfaceplayer ViridianSchoolHouseLittleGirlText

; Yellow's blackboard (engine/events/hidden_events/school_blackboard.asm) is a
; bespoke two-column assembly menu.  Crystal reimplemented exactly that menu for
; Violet's EARL'S #MON ACADEMY, so this is Crystal's own `_2dmenu` blackboard
; (maps/EarlsPokemonAcademy.asm:63-115) with Yellow's headings, Yellow's column
; order (SLP/PSN/PAR | BRN/FRZ/QUIT), Yellow's box (TextBoxBorder 6x10 at 0,0 ->
; menu_coords 0,0,11,7) and Yellow's page text verbatim.
ViridianSchoolHouseBlackboard:
	opentext
	writetext ViridianSchoolBlackboardText1
	promptbutton
.Loop:
	writetext ViridianSchoolBlackboardText2
	loadmenu .MenuHeader
	_2dmenu
	closewindow
	; `_2dmenu` fills the grid row by row, so the item order below is
	; Yellow's two columns interleaved: SLP BRN / PSN FRZ / PAR QUIT.
	ifequal 1, .Sleep
	ifequal 2, .Burn
	ifequal 3, .Poison
	ifequal 4, .Frozen
	ifequal 5, .Paralysis
	closetext
	end

.Sleep:
	writetext ViridianBlackboardSleepText
	promptbutton
	sjump .Loop

.Poison:
	writetext ViridianBlackboardPoisonText
	promptbutton
	sjump .Loop

.Paralysis:
	writetext ViridianBlackboardPrlzText
	promptbutton
	sjump .Loop

.Burn:
	writetext ViridianBlackboardBurnText
	promptbutton
	sjump .Loop

.Frozen:
	writetext ViridianBlackboardFrozenText
	promptbutton
	sjump .Loop

.MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 11, 7
	dw .MenuData
	db 1 ; default option

.MenuData:
	db STATICMENU_CURSOR ; flags
	dn 3, 2 ; rows, columns
	db 5 ; spacing
	dba .Text
	dbw BANK(@), NULL

.Text:
	db "SLP@"
	db "BRN@"
	db "PSN@"
	db "FRZ@"
	db "PAR@"
	db "QUIT@"

ViridianSchoolHouseBrunetteGirlText:
	text "Whew! I'm trying"
	line "to memorize all"
	cont "my notes."
	done

ViridianSchoolHouseCooltrainerFText:
	text "Okay!"

	para "Be sure to read"
	line "the blackboard"
	cont "carefully!"
	done

ViridianSchoolHouseLittleGirlText:
	text "Sis says #MON"
	line "will become tame"
	cont "if you treat them"
	cont "nicely."
	done

ViridianSchoolBlackboardText1:
	text "The blackboard"
	line "describes #MON"
	cont "STATUS changes"
	cont "during battles."
	done

ViridianSchoolBlackboardText2:
	text "Which heading do"
	line "you want to read?"
	done

ViridianBlackboardSleepText:
	text "A #MON can't"
	line "attack if it's"
	cont "asleep!"

	para "#MON will stay"
	line "asleep even after"
	cont "battles."

	para "Use AWAKENING to"
	line "wake them up!"
	done

ViridianBlackboardPoisonText:
	text "When poisoned, a"
	line "#MON's health"
	cont "steadily drops."

	para "Poison lingers"
	line "after battles."

	para "Use an ANTIDOTE"
	line "to cure poison!"
	done

ViridianBlackboardPrlzText:
	text "Paralysis could"
	line "make #MON"
	cont "moves misfire!"

	para "Paralysis remains"
	line "after battles."

	para "Use PARLYZ HEAL"
	line "for treatment!"
	done

ViridianBlackboardBurnText:
	text "A burn reduces"
	line "power and speed."
	cont "It also causes"
	cont "ongoing damage."

	para "Burns remain"
	line "after battles."

	para "Use BURN HEAL to"
	line "cure a burn!"
	done

ViridianBlackboardFrozenText:
	text "If frozen, a"
	line "#MON becomes"
	cont "totally immobile!"

	para "It stays frozen"
	line "even after the"
	cont "battle ends."

	para "Use ICE HEAL to"
	line "thaw out #MON!"
	done

; BG1Q1 (docs/BG1-BENCH-AND-SHELVES.md): Yellow prints BookOrSculptureText
; ("Crammed full of / #MON books!") facing UP on (7,1)
; (engine/events/hidden_events/bookshelves.asm).  Every other bookshelf/TV/
; radio square here is silent, as in Yellow (engine/events/std_collision.asm).
ViridianSchoolHouseBG1Q1Bookshelf:
	jumpstd PictureBookshelfScript

ViridianSchoolHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, VIRIDIAN_CITY, 5
	warp_event  3,  7, VIRIDIAN_CITY, 5

	def_coord_events

	def_bg_events
	bg_event  7,  1, BGEVENT_UP, ViridianSchoolHouseBG1Q1Bookshelf ; BG1Q1
	bg_event  3,  0, BGEVENT_READ, ViridianSchoolHouseBlackboard

	def_object_events
	object_event  3,  5, SPRITE_LASS, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, ViridianSchoolHouseBrunetteGirlScript, -1
	object_event  4,  1, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ViridianSchoolHouseCooltrainerFScript, -1
	object_event  4,  5, SPRITE_TWIN, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ViridianSchoolHouseLittleGirlScript, -1
