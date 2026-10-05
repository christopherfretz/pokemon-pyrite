; Kanto hack: Yellow's Bill's Sea Cottage (docs/M3-CERULEAN.md 3.6 / 6j).
; Sources: vendor/pokeyellow/scripts/BillsHouse.asm (the ten-state machine),
; vendor/pokeyellow/scripts/BillsHouse_2.asm (the plea, the yes/no and the
; S.S. TICKET hand-over), vendor/pokeyellow/text/BillsHouse.asm,
; vendor/pokeyellow/engine/events/hidden_events/bills_house_pc.asm (the PC:
; the cell separator's four-SFX sequence and BILL's favourite-#MON list) and
; vendor/pokeyellow/data/maps/objects/BillsHouse.asm.
;
; DELETED here: Crystal's BILLSHOUSE_GRAMPS and the whole BillsGrandpa
; show-me-a-#MON minigame (EVERSTONE / LEAF, WATER, FIRE and THUNDERSTONE).
; Its eleven EVENT_*_BILLS_GRANDPA flags were only ever referenced by this
; file; five are renamed in place for this map (see constants/event_flags.asm),
; the other six are left dead and free.  Johto's Bill (BillsFamilysHouse,
; Ecruteak, Goldenrod, EVENT_MET_BILL) is NOT touched - this map's beat is
; Kanto's and deliberately does not set EVENT_MET_BILL, which in Crystal is
; BillsFamilysHouse's object-hide flag and gates the Pokecenter 2F PC speech.
;
; MAP (BH1, operator report 2026-10-05): hack/maps/BillsHouse.blk is Yellow's
; own BillsHouse.blk byte for byte, on TILESET_KANTO_INTERIOR (Yellow's INTERIOR
; tileset, ported wholesale for SILPH CO. 11F in M8 11b), so the two-pod
; TELEPORTER, the console and the PC chair are Yellow's tiles and collision.
; (6j had re-cut the room from TILESET_HOUSE furniture, which has no pods, so
; BILL walked UP x3 into a bookshelf.)  The only collision override is the exit
; mat, block $0c -> WARP_CARPET_DOWN (scripts/kanto_interior_blk.py).  Every
; coordinate below is Yellow's (vendor/pokeyellow/data/maps/objects/
; BillsHouse.asm, scripts/BillsHouse.asm):
;   BILL-as-#MON at (6,5) walks UP x3 into the right pod at (6,2), or
;     RIGHT,UP,UP,LEFT,UP round a player standing on (6,4) facing DOWN
;   PC hidden event at (1,4), facing UP; the player stands on the chair (1,5)
;   BILL 1 pops out of the LEFT pod at (1,2) (Yellow's BillsHouseScript5
;     SetSpritePosition1; its object data says (4,4), which is only where he
;     ends up), walks DOWN,RIGHT,RIGHT,RIGHT,DOWN to (4,4); the player is then
;     shoved RIGHT x3 to (4,5), faces UP, BILL faces DOWN
;   BILL 2 replaces him at (6,5) on later visits
;
; SCENE/FLAG MACHINE (docs/PORTING.md 3.4): Yellow drives this with
; wBillsHouseCurScript plus a persistent ShowObject/HideObject toggle table,
; re-derived from Route 25 on every walk-in (Route25ToggleBillsScript).  The
; durable GSC idiom is to derive everything from one stored fact on every map
; load, so BillsHouseObjectsCallback recomputes the scene and all three object
; flags from EVENT_GOT_SS_TICKET alone.  That also gives Yellow's reset for
; free: leaving the house after agreeing but before using the PC puts BILL
; back on his tile with EVENT_BILL_SAID_USE_CELL_SEPARATOR cleared, exactly as
; Route25ToggleBillsScript does.
;
; REQUIRED (docs/M3-CERULEAN.md 6c.1): the ticket hand-over must
; `setevent EVENT_CERULEAN_GUARDS_STAND_ASIDE`.  Officer Jenny #2 stands on
; Cerulean's trashed-house door until it is set, and behind that door are the
; Rocket thief, TM_DIG, the south road, Route 5 and Route 9.
	object_const_def
	const BILLSHOUSE_BILL_POKEMON
	const BILLSHOUSE_BILL_1
	const BILLSHOUSE_BILL_2

BillsHouse_MapScripts:
	def_scene_scripts
	scene_script BillsHouseHealScene, SCENE_BILLSHOUSE_BILL_IS_A_POKEMON
	scene_script BillsHouseHealScene, SCENE_BILLSHOUSE_FINISHED

	def_callbacks
	callback MAPCALLBACK_OBJECTS, BillsHouseObjectsCallback

BillsHouseHealScene:
	callasm BillsHouseHealStaleBlocks
	iffalse .done
	refreshmap
.done
	end

; BH1 save compatibility.  A game saved INSIDE this house on a build before BH1
; carries the old room's block ids in wScreenSave (the 6x5 blocks round the
; player are part of the saved map data), and MapSetupScript_Continue writes
; them back over the freshly loaded .blk (LoadConnectionBlockData).  On the new
; tileset those ids are wrong art and wrong collision, and the exit mat is not a
; warp, so the player is stuck.  This map never edits its own blocks
; (no changeblock), so any difference from the ROM .blk is stale: reload the
; blocks, re-buffer wScreenSave so the next save is clean, and redraw.  Costs a
; 16-byte compare per overworld frame in this one room.
BillsHouseHealStaleBlocks:
	xor a
	ld [wScriptVar], a
	ld hl, wOverworldMapBlocks + (BILLS_HOUSE_WIDTH + 6) * 3 + 3
	ld a, [wMapBlocksPointer]
	ld e, a
	ld a, [wMapBlocksPointer + 1]
	ld d, a
	ld c, BILLS_HOUSE_HEIGHT
.row
	ld b, BILLS_HOUSE_WIDTH
.col
	push hl
	ld h, d
	ld l, e
	ld a, [wMapBlocksBank]
	call GetFarByte
	pop hl
	cp [hl]
	jr nz, .heal
	inc de
	inc hl
	dec b
	jr nz, .col
	ld a, l
	add 6
	ld l, a
	jr nc, .next
	inc h
.next
	dec c
	jr nz, .row
	ret

.heal
	call LoadBlockData
	call BufferScreen
	ld a, TRUE
	ld [wScriptVar], a
	ret

; Both scenes run only the heal above.  The stored scene is recomputed below on every load
; so a white-out or a save/reload can never desync it from the objects, and
; SCENE_BILLSHOUSE_BILL_IS_A_POKEMON arms the Pikachu coord_event (PE1).
BillsHousePikachuSceneScript:
; PE1 / A3 row 3: Yellow's BillsHouseScript0 (vendor/pokeyellow/scripts/
; BillsHouse.asm:41) runs BillsHousePikachuConfused on the frame the map comes
; up.  GSC has no per-frame map script, so -- exactly like the Fan Club's
; scene (maps/PokemonFanClub.asm) -- it is a coord_event on the two tiles in
; front of the doors, the player's first step in; Pikachu is on the door tile
; behind them.  The special does all of Yellow's gating (once per visit,
; starter out, no status) and plays emotion 23 itself.
	special BillsHousePikachuConfused
	end

BillsHouseObjectsCallback:
	checkevent EVENT_GOT_SS_TICKET
	iftrue .Helped
	setscene SCENE_BILLSHOUSE_BILL_IS_A_POKEMON
	clearevent EVENT_BILLS_HOUSE_BILL_POKEMON_HIDDEN
	setevent EVENT_BILLS_HOUSE_BILL_1_HIDDEN
	setevent EVENT_BILLS_HOUSE_BILL_2_HIDDEN
; Yellow's Route25ToggleBillsScript resets this on every walk-in, so a player
; who says yes and then walks out has to ask BILL again before the PC will run
; the separator.  Same here.  It doubles as the recovery path if the ticket
; could not be handed over (full KEY ITEMS pocket): BILL is a #MON again and
; the whole cutscene simply replays.
	clearevent EVENT_BILL_SAID_USE_CELL_SEPARATOR
; Kanto hack (N1e): Yellow's PC has a SECOND guard, EVENT_USED_CELL_SEPARATOR
; (vendor/pokeyellow/engine/events/hidden_events/bills_house_pc.asm:6-11), so
; the machine can't be run twice in a row.  Cleared here beside the first guard
; so leaving and re-entering still replays the whole beat.
	clearevent EVENT_USED_CELL_SEPARATOR_ON_BILL
	endcallback

.Helped:
	setscene SCENE_BILLSHOUSE_FINISHED
	setevent EVENT_BILLS_HOUSE_BILL_POKEMON_HIDDEN
	setevent EVENT_BILLS_HOUSE_BILL_1_HIDDEN
	clearevent EVENT_BILLS_HOUSE_BILL_2_HIDDEN
	endcallback

; BILL, merged with a #MON (Yellow's BillsHousePrintBillPokemonText).  The
; yes/no is cosmetic in Yellow too: "no" just gets you the "come on, you gotta
; help a guy in deep trouble" page and then carries straight on.
BillsHouseBillPokemonScript:
	faceplayer
	opentext
	writetext BillsHouseBillImNotAPokemonText
	yesorno
	iftrue .Agreed
	writetext BillsHouseBillNoYouGottaHelpText
	promptbutton
.Agreed:
	writetext BillsHouseBillUseSeparationSystemText
	waitbutton
	closetext
; Yellow's BillsHouseScript2: if you are facing DOWN you are standing on
; (6,4), between BILL and the teleporter, so he walks around you instead.
	readvar VAR_FACING
	ifequal DOWN, .AroundPlayer
	applymovement BILLSHOUSE_BILL_POKEMON, BillsHouseBillToCellSeparator
	sjump .InThePod
.AroundPlayer:
	applymovement BILLSHOUSE_BILL_POKEMON, BillsHouseBillAroundPlayer
.InThePod:
	disappear BILLSHOUSE_BILL_POKEMON
; PE1: Yellow's BillsHouseScript3 -- a parked Pikachu follows BILL to the
; machine and plays emotion 32.  No-op while Pikachu follows the player.
	special BillsHousePikachuIntoPod
	setevent EVENT_BILL_SAID_USE_CELL_SEPARATOR
	end

BillsHouseBillToCellSeparator:
	step UP
	step UP
	step UP
	step_end

BillsHouseBillAroundPlayer:
	step RIGHT
	step UP
	step UP
	step LEFT
	step UP
	step_end

; The cell separator console (Yellow's BillsHousePC hidden event, which is
; also gated on facing UP - BGEVENT_UP is the GSC spelling of Yellow's
; `hidden_event x, y, Script, SPRITE_FACING_UP`, docs/PORTING.md 3.2).
BillsHousePCScript:
	opentext
	checkevent EVENT_GOT_SS_TICKET
	iftrue .PokemonList
; Yellow checks EVENT_USED_CELL_SEPARATOR before EVENT_BILL_SAID_USE_CELL_
; SEPARATOR, so once the machine has been run the console goes back to its
; plain monitor text instead of running the cutscene again.
	checkevent EVENT_USED_CELL_SEPARATOR_ON_BILL
	iftrue .Monitor
	checkevent EVENT_BILL_SAID_USE_CELL_SEPARATOR
	iftrue .CellSeparator
.Monitor:
	writetext BillsHouseMonitorText
	waitbutton
	closetext
	end

; Yellow's BillsHousePokemonList is a hand-rolled four-item menu that calls
; DisplayPokedex on EEVEE / FLAREON / JOLTEON / VAPOREON.  GSC has no script
; command for "open the dex at species N" and no engine special to borrow, so
; this is the text-only port (docs/M3-CERULEAN.md "6j findings"): BILL's list
; is printed, the dex pictures are not.
.PokemonList:
	writetext BillsHousePokemonListText
	waitbutton
	closetext
	end

; Yellow: StopAllMusic, then SFX_SWITCH, SFX_TINK, SFX_SHRINK, SFX_TINK,
; SFX_GET_ITEM_1 with DelayFrames 16/60/32/80/48/32 between them, then
; PlayDefaultMusic.  Crystal has none of those five SFX ids under those names;
; the nearest equivalents (docs/PORTING.md 8) are SFX_CHOOSE_PC_OPTION,
; SFX_PUSH_BUTTON, SFX_WARP_TO, SFX_PUSH_BUTTON, SFX_ITEM.  `playsound` +
; `waitsfx` + `pause` is a straight transcription - no engine special needed.
.CellSeparator:
	writetext BillsHouseInitiatedText
	waitbutton
	closetext
	playmusic MUSIC_NONE
	pause 16
	playsound SFX_CHOOSE_PC_OPTION
	waitsfx
	pause 60
	playsound SFX_PUSH_BUTTON
	waitsfx
	pause 32
	playsound SFX_WARP_TO
	waitsfx
	pause 80
	playsound SFX_PUSH_BUTTON
	waitsfx
	pause 48
	playsound SFX_ITEM
	waitsfx
	pause 32
	special RestartMapMusic
; Yellow's BillsHouseScript5: BILL appears in the LEFT pod at (1,2) facing
; DOWN (his object_event tile), DelayFrames 8, then walks out DOWN, RIGHT x3,
; DOWN to (4,4).  Script7/8: the player is shoved RIGHT x3 from the chair to
; (4,5), faces UP, BILL faces DOWN, and the S.S. TICKET text runs.
	appear BILLSHOUSE_BILL_1
	pause 8
; PE1: Yellow's BillsHouseScript5 -- a parked Pikachu looks LEFT, gets the
; EXCLAMATION_BUBBLE and plays emotion 27.  With Pikachu following, Yellow shows
; no bubble at all (the old stand-in "!" over the player is gone).
	special BillsHousePikachuSurprised
	applymovement BILLSHOUSE_BILL_1, BillsHouseBillExitMachine
	applymovement PLAYER, BillsHousePlayerStepAside
	turnobject PLAYER, UP
	turnobject BILLSHOUSE_BILL_1, DOWN
	setevent EVENT_USED_CELL_SEPARATOR_ON_BILL
	sjump BillsHouseBillThanks

BillsHouseBillExitMachine:
	step DOWN
	step RIGHT
	step RIGHT
	step RIGHT
	step DOWN
	step_end

; Yellow's forced walk is a simulated joypad (RLE_1e219 = PAD_RIGHT x3).  GSC's
; equivalent is applymovement PLAYER, which used to FREEZE the Pikachu follower
; for the duration and snap it back afterwards; F1 (docs/FOLLOWER-FIXES.md
; "F1 findings") unfreezes the follower struct inside ApplyMovement, so Pikachu
; now walks the three tiles one at a time behind the player, as in Yellow.
BillsHousePlayerStepAside:
	step RIGHT
	step RIGHT
	step RIGHT
	step_end

; BILL, separated (Yellow's BillsHousePrintBillSSTicketText).  Entered either
; by falling out of the cell-separator script above or by talking to him
; afterwards, which is why the faceplayer is on its own entry point.
BillsHouseBillScript:
	faceplayer
BillsHouseBillThanks:
	opentext
	checkevent EVENT_GOT_SS_TICKET
	iftrue .GotTicket
	writetext BillsHouseBillThankYouText
	promptbutton
	verbosegiveitem S_S_TICKET
	iffalse .NoRoom
	setevent EVENT_GOT_SS_TICKET
; REQUIRED, see the header: this is the only thing in the game that moves
; Officer Jenny #2 off Cerulean's trashed-house door (docs/M3-CERULEAN.md
; 6c.1).  Yellow does the same here, as a ShowObject/HideObject pair on the
; two guards; CeruleanCityObjectsCallback derives them from this one flag.
	setevent EVENT_CERULEAN_GUARDS_STAND_ASIDE
	setscene SCENE_BILLSHOUSE_FINISHED
.GotTicket:
	writetext BillsHouseBillWhyDontYouGoInsteadOfMeText
	waitbutton
	closetext
	end

.NoRoom:
	writetext BillsHouseSSTicketNoRoomText
	waitbutton
	closetext
	end

BillsHouseBill2Script:
	jumptextfaceplayer BillsHouseBillCheckOutMyRarePokemonText

BillsHouseBillImNotAPokemonText:
	text "Hiya! I'm a"
	line "#MON…"
	cont "…No I'm not!"

	para "Call me BILL!"
	line "I'm a true blue"
	cont "#MANIAC! Hey!"
	cont "What's with that"
	cont "skeptical look?"

	para "I'm not joshing"
	line "you, I screwed up"
	cont "an experiment and"
	cont "got combined with"
	cont "a #MON!"

	para "So, how about it?"
	line "Help me out here!"
	done

BillsHouseBillNoYouGottaHelpText:
	text "No!? Come on, you"
	line "gotta help a guy"
	cont "in deep trouble!"

	para "What do you say,"
	line "chief? Please?"
	cont "OK? All right!"
	prompt

BillsHouseBillUseSeparationSystemText:
	text "When I'm in the"
	line "TELEPORTER, go to"
	cont "my PC and run the"
	cont "Cell Separation"
	cont "System!"
	done

BillsHouseMonitorText:
	text "TELEPORTER is"
	line "displayed on the"
	cont "PC monitor."
	done

BillsHouseInitiatedText:
	text "<PLAYER> initiated"
	line "TELEPORTER's Cell"
	cont "Separator!"
	done

BillsHouseBillThankYouText:
	text "BILL: Yeehah!"
	line "Thanks, bud! I"
	cont "owe you one!"

	para "So, did you come"
	line "to see my #MON"
	cont "collection?"
	cont "You didn't?"
	cont "That's a bummer."

	para "I've got to thank"
	line "you… Oh here,"
	cont "maybe this'll do."
	prompt

BillsHouseSSTicketNoRoomText:
	text "You've got too"
	line "much stuff, bud!"
	done

BillsHouseBillWhyDontYouGoInsteadOfMeText:
	text "That cruise ship,"
	line "S.S.ANNE, is in"
	cont "VERMILION CITY."
	cont "Its passengers"
	cont "are all trainers!"

	para "They invited me"
	line "to their party,"
	cont "but I can't stand"
	cont "fancy do's. Why"
	cont "don't you go"
	cont "instead of me?"
	done

BillsHouseBillCheckOutMyRarePokemonText:
	text "BILL: Look, bud,"
	line "just check out"
	cont "some of my rare"
	cont "#MON on my PC!"
	done

; Yellow's BillsHousePokemonList menu, as text (see .PokemonList above).
BillsHousePokemonListText:
	text "BILL's favorite"
	line "#MON list!"

	para "EEVEE, FLAREON,"
	line "JOLTEON and"
	cont "VAPOREON!"

	para "Look at all those"
	line "rare #MON!"
	done

BillsHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, ROUTE_25, 1
	warp_event  3,  7, ROUTE_25, 1

	def_coord_events
	coord_event  2,  6, SCENE_BILLSHOUSE_BILL_IS_A_POKEMON, BillsHousePikachuSceneScript
	coord_event  3,  6, SCENE_BILLSHOUSE_BILL_IS_A_POKEMON, BillsHousePikachuSceneScript

	def_bg_events
	bg_event  1,  4, BGEVENT_UP, BillsHousePCScript ; Yellow's hidden_event 1, 4, SPRITE_FACING_UP

	def_object_events
	object_event  6,  5, SPRITE_MONSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, BillsHouseBillPokemonScript, EVENT_BILLS_HOUSE_BILL_POKEMON_HIDDEN
	object_event  1,  2, SPRITE_BILL, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, BillsHouseBillScript, EVENT_BILLS_HOUSE_BILL_1_HIDDEN
	object_event  6,  5, SPRITE_BILL, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, BillsHouseBill2Script, EVENT_BILLS_HOUSE_BILL_2_HIDDEN
