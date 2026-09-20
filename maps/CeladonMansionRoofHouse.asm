; Kanto hack (docs/M6-CELADON.md, 9s): Yellow's CELADON MANSION ROOF HOUSE --
; the HIKER's room with the free EEVEE.  Yellow reuses the VIRIDIAN SCHOOL HOUSE
; room here (maps/CeladonMansionRoofHouse.blk is byte-for-byte
; maps/ViridianSchoolHouse.blk), so data/maps/blocks.asm points this map at the
; .blk we already ship for the school house; that is where the blackboard at
; (3,0)/(4,0) and the desks at (3..4, 3..4) come from.
;
; Yellow's three hidden events (data/events/hidden_events.asm) are bg_events
; here -- Yellow matches them against the tile IN FRONT of the player
; (engine/overworld/hidden_events.asm: CheckIfCoordsInFrontOfPlayerMatch), which
; is exactly what a GSC bg_event does.  Crystal's PHARMACIST, its bicycle ghost
; story and its TM03 CURSE are gone.
	object_const_def
	const CELADONMANSIONROOFHOUSE_HIKER
	const CELADONMANSIONROOFHOUSE_EEVEE_BALL

CeladonMansionRoofHouse_MapScripts:
	def_scene_scripts

	def_callbacks

CeladonMansionRoofHouseHikerScript:
	jumptextfaceplayer CeladonMansionRoofHouseHikerText

; Yellow: CeladonMansionRoofHouseEeveePokeballText --
;   lb bc, EEVEE, 25 / call GivePokemon / jr nc, .party_full
;   ld a, TOGGLE_CELADON_MANSION_EEVEE_GIFT / predef HideObject
; Yellow's GivePokemon prints "<PLAYER> got EEVEE!" itself, offers a nickname
; (AddPartyMon), falls back to the BOX when the party is full, and leaves the
; ball in place when the BOX is full too.  Crystal's `givepoke` does the same
; work but prints only the box message, and returns 2 when there is no room at
; all -- so the got-EEVEE line and its jingle are printed here, exactly as the
; VermilionCity OFFICER JENNY SQUIRTLE gift does (maps/VermilionCity.asm, 7e).
; OT is the player and the DVs are rolled the ordinary way, because `givepoke`
; with no trainer argument takes Crystal's wild-catch path (SetCaughtData), the
; same as Yellow's AddPartyMon.
;
; Yellow hides the ball through its toggleable-object list and stores no flag;
; GSC objects are hidden by an event flag, so this uses EVENT_GOT_EEVEE_CELADON
; (a dead const_skip renamed in place -- EVENT_GOT_EEVEE is Johto's Bill's-family
; EEVEE).  The flag is NOT set on the box-full path, so the ball stays.
; Note the party-full path skips the "<PLAYER> got EEVEE!" line and its jingle:
; Crystal's GivePoke prints its own "was sent to BILL's PC" message there.
CeladonMansionRoofHouseEeveeBall:
	opentext
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .ToBox
	writetext CeladonMansionRoofHouseGotEeveeText
	playsound SFX_CAUGHT_MON
	waitsfx
.ToBox:
	givepoke EEVEE, 25
	ifequal 2, .BoxIsFull
	; `disappear` both deletes the sprite now (Yellow's HideObject) and sets the
	; object's own hide flag, EVENT_GOT_EEVEE_CELADON, so the ball stays gone
	; across map loads -- `setevent` alone would only take effect on the next
	; reload and leave the ball standing there for the rest of the visit
	; (the ElmsLab starter-ball / DragonsDen DRAGON_FANG precedent).
	disappear CELADONMANSIONROOFHOUSE_EEVEE_BALL
	closetext
	end

.BoxIsFull:
	writetext CeladonMansionRoofHouseBoxIsFullText
	waitbutton
	closetext
	end

; Yellow's blackboard (engine/events/hidden_events/school_blackboard.asm:
; LinkCableHelp) is a bespoke four-item, one-column assembly menu in a
; TextBoxBorder of `lb bc, 8, 13` at 0,0.  This is the same Crystal `_2dmenu`
; blackboard the VIRIDIAN SCHOOL HOUSE uses (maps/ViridianSchoolHouse.asm, N1c),
; with Yellow's headings and Yellow's box (8x13 -> menu_coords 0, 0, 14, 9).
CeladonMansionRoofHouseBlackboard:
	opentext
	writetext CeladonMansionRoofHouseLinkCableHelpText
	promptbutton
.Loop:
	writetext CeladonMansionRoofHouseWhichHeadingText
	loadmenu .MenuHeader
	_2dmenu
	closewindow
	ifequal 1, .HowToLink
	ifequal 2, .Colosseum
	ifequal 3, .TradeCenter
	closetext
	end

.HowToLink:
	writetext CeladonMansionRoofHouseHowToLinkText
	promptbutton
	sjump .Loop

.Colosseum:
	writetext CeladonMansionRoofHouseColosseumText
	promptbutton
	sjump .Loop

.TradeCenter:
	writetext CeladonMansionRoofHouseTradeCenterText
	promptbutton
	sjump .Loop

.MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 14, 9
	dw .MenuData
	db 1 ; default option

.MenuData:
	db STATICMENU_CURSOR ; flags
	dn 4, 1 ; rows, columns
	db 13 ; spacing
	dba .Text
	dbw BANK(@), NULL

.Text:
	db "HOW TO LINK@"
	db "COLOSSEUM@"
	db "TRADE CENTER@"
	db "STOP READING@"

CeladonMansionRoofHouseTMNotebook:
	jumptext CeladonMansionRoofHouseTMNotebookText

CeladonMansionRoofHouseHikerText:
	text "I know everything"
	line "about the world"
	cont "of #MON in"
	cont "your GAME BOY!"

	para "Get together with"
	line "your friends and"
	cont "trade #MON!"
	done

CeladonMansionRoofHouseGotEeveeText:
	text "<PLAYER> got"
	line "EEVEE!"
	done

; Yellow: _BoxIsFullText, printed by GivePokemon when party and box are both
; full.  Crystal's GivePoke returns 2 and prints nothing, so we print it here.
CeladonMansionRoofHouseBoxIsFullText:
	text "There's no more"
	line "room for #MON!"

	para "The #MON BOX"
	line "is full and can't"
	cont "accept any more!"
	done

CeladonMansionRoofHouseLinkCableHelpText:
	text "TRAINER TIPS"

	para "Using a Game Link"
	line "Cable"
	done

CeladonMansionRoofHouseWhichHeadingText:
	text "Which heading do"
	line "you want to read?"
	done

CeladonMansionRoofHouseHowToLinkText:
	text "When you have"
	line "linked your GAME"
	cont "BOY with another"
	cont "GAME BOY, talk to"
	cont "the attendant on"
	cont "the right in any"
	cont "#MON CENTER."
	done

CeladonMansionRoofHouseColosseumText:
	text "COLOSSEUM lets"
	line "you play against"
	cont "a friend."
	done

CeladonMansionRoofHouseTradeCenterText:
	text "TRADE CENTER is"
	line "used for trading"
	cont "#MON."
	done

CeladonMansionRoofHouseTMNotebookText:
	text "It's a pamphlet"
	line "on TMs."

	para "…"

	para "There are 50 TMs"
	line "in all."

	para "There are also 5"
	line "HMs that can be"
	cont "used repeatedly."

	para "SILPH CO."
	done

CeladonMansionRoofHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, CELADON_MANSION_ROOF, 3
	warp_event  3,  7, CELADON_MANSION_ROOF, 3

	def_coord_events

	def_bg_events
	bg_event  3,  0, BGEVENT_UP, CeladonMansionRoofHouseBlackboard
	bg_event  4,  0, BGEVENT_UP, CeladonMansionRoofHouseBlackboard
	bg_event  3,  4, BGEVENT_UP, CeladonMansionRoofHouseTMNotebook

	def_object_events
	object_event  2,  2, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, CeladonMansionRoofHouseHikerScript, -1
	object_event  4,  3, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeladonMansionRoofHouseEeveeBall, EVENT_GOT_EEVEE_CELADON
