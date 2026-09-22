; Kanto hack (M9 12i/12j): Yellow's CINNABAR LAB Testing Room
; (vendor/pokeyellow/{data/maps/objects,scripts,text}/CinnabarLabFossilRoom.asm),
; cut wholesale onto Yellow's own 4x4 .blk and the new TILESET_KANTO_LAB (D95).
; The hall's east door (its warp 5) leads here; warps 1 and 2 are the exit mat
; on the bottom row -- see hack/maps/CinnabarLab.asm for the collision override.
; The big grey machine along the north wall (block $0f) is the Resurrection
; Machine.
;
; 12j: Scientist1 is the fossil revival, ported from Yellow's
; scripts/CinnabarLabFossilRoom.asm + engine/events/cinnabar_lab.asm:
;
;   * with no fossil in the bag he prints the opening line and "No! Is too
;     bad!" and that is that;
;   * with one or more fossils, Yellow's Lab4Script_GetFossilsInBag builds a
;     menu of just the fossils you are carrying, in the fixed order DOME,
;     HELIX, OLD AMBER, and lets you back out with B.  GSC has no dynamic
;     menu builder, so the seven possible subsets get seven static menu
;     headers below and four shared verticalmenu run branches -- exactly the
;     trick hack/maps/CeladonDeptStore6F.asm uses for the vending machine.
;     A one- or two-entry list can never return the index of a fossil that is
;     missing from it, so the branches are safe to share.
;     menu_coords 0, 0, 14, 2n+1 reproduces Yellow's box (TextBoxBorder b=2n,
;     c=$d at 0,0; text at 2,2) and leaves room for "HELIX FOSSIL" (12 chars);
;   * picking one asks Yellow's SeesFossil question, takes the fossil, sets
;     EVENT_GAVE_FOSSIL_TO_LAB + EVENT_LAB_STILL_REVIVING_FOSSIL and sends the
;     player away.  CINNABAR ISLAND's MAPCALLBACK_NEWMAP (12g) clears the
;     "still reviving" flag on every arrival -- that is Yellow's clock, a walk
;     out of the building and back;
;   * on the next visit the mon is handed over at L30, and all four flags are
;     cleared so the next fossil can go in.  Which fossil is in the machine is
;     remembered in EVENT_LAB_FOSSIL_IS_HELIX / _IS_AMBER (neither = DOME)
;     rather than Yellow's unsaved wFossilItem/wFossilMon -- see the comment
;     on those flags in constants/event_flags.asm.
;
; Scientist2 (7,6) is Yellow's third in-game trade, TRADE_FOR_STICKY
; (KANGASKHAN for MUK) -- note it is in THIS room, not the Meeting Room.
	object_const_def
	const CINNABARLABFOSSILROOM_SCIENTIST1
	const CINNABARLABFOSSILROOM_SCIENTIST2

CinnabarLabFossilRoom_MapScripts:
	def_scene_scripts

	def_callbacks

CinnabarLabFossilRoomScientist1Script:
	faceplayer
	opentext
	checkevent EVENT_GAVE_FOSSIL_TO_LAB
	iftrue .InTheMachine
	writetext CinnabarLabFossilRoomScientist1Text
	promptbutton
; Yellow's Lab4Script_GetFossilsInBag, unrolled: pick the menu that matches the
; fossils actually in the bag.  D = DOME, H = HELIX, A = OLD AMBER.
	checkitem DOME_FOSSIL
	iftrue .HasDome
	checkitem HELIX_FOSSIL
	iftrue .HasHelix
	checkitem OLD_AMBER
	iftrue .OnlyAmber
	writetext CinnabarLabFossilRoomScientist1NoFossilsText
	waitbutton
	closetext
	end

.HasDome:
	checkitem HELIX_FOSSIL
	iftrue .DomeAndHelix
	checkitem OLD_AMBER
	iftrue .DomeAndAmber
	loadmenu .MenuHeaderD
	sjump .RunDomeFirst

.DomeAndHelix:
	checkitem OLD_AMBER
	iftrue .AllThree
	loadmenu .MenuHeaderDH
	sjump .RunDomeFirst

.AllThree:
	loadmenu .MenuHeaderDHA
	; fallthrough

.RunDomeFirst:
; shared by the D, DH and DHA lists
	verticalmenu
	closewindow
	ifequal 1, .ChoseDome
	ifequal 2, .ChoseHelix
	ifequal 3, .ChoseAmber
	sjump .ComeAgain

.DomeAndAmber:
	loadmenu .MenuHeaderDA
	verticalmenu
	closewindow
	ifequal 1, .ChoseDome
	ifequal 2, .ChoseAmber
	sjump .ComeAgain

.HasHelix:
	checkitem OLD_AMBER
	iftrue .HelixAndAmber
	loadmenu .MenuHeaderH
	sjump .RunHelixFirst

.HelixAndAmber:
	loadmenu .MenuHeaderHA
	; fallthrough

.RunHelixFirst:
; shared by the H and HA lists
	verticalmenu
	closewindow
	ifequal 1, .ChoseHelix
	ifequal 2, .ChoseAmber
	sjump .ComeAgain

.OnlyAmber:
	loadmenu .MenuHeaderA
	verticalmenu
	closewindow
	ifequal 1, .ChoseAmber
	sjump .ComeAgain

.ChoseDome:
	getmonname STRING_BUFFER_3, KABUTO
	getitemname STRING_BUFFER_4, DOME_FOSSIL
	scall .AskForIt
	iffalse .ComeAgain
	takeitem DOME_FOSSIL
	clearevent EVENT_LAB_FOSSIL_IS_HELIX
	clearevent EVENT_LAB_FOSSIL_IS_AMBER
	sjump .HandedItOver

.ChoseHelix:
	getmonname STRING_BUFFER_3, OMANYTE
	getitemname STRING_BUFFER_4, HELIX_FOSSIL
	scall .AskForIt
	iffalse .ComeAgain
	takeitem HELIX_FOSSIL
	setevent EVENT_LAB_FOSSIL_IS_HELIX
	clearevent EVENT_LAB_FOSSIL_IS_AMBER
	sjump .HandedItOver

.ChoseAmber:
	getmonname STRING_BUFFER_3, AERODACTYL
	getitemname STRING_BUFFER_4, OLD_AMBER
	scall .AskForIt
	iffalse .ComeAgain
	takeitem OLD_AMBER
	clearevent EVENT_LAB_FOSSIL_IS_HELIX
	setevent EVENT_LAB_FOSSIL_IS_AMBER
	; fallthrough

.HandedItOver:
	writetext CinnabarLabFossilRoomScientist1TakesFossilText
	promptbutton
	setevent EVENT_GAVE_FOSSIL_TO_LAB
	setevent EVENT_LAB_STILL_REVIVING_FOSSIL
	writetext CinnabarLabFossilRoomScientist1GoForAWalkText
	waitbutton
	closetext
	end

.AskForIt:
	writetext CinnabarLabFossilRoomScientist1SeesFossilText
	yesorno
	end

.ComeAgain:
	writetext CinnabarLabFossilRoomScientist1ComeAgainText
	waitbutton
	closetext
	end

.InTheMachine:
; 12g's CinnabarIsland MAPCALLBACK_NEWMAP clears the "still reviving" flag the
; moment the player steps back outside, so this is Yellow's timer.
	checkevent EVENT_LAB_STILL_REVIVING_FOSSIL
	iffalse .BackToLife
	writetext CinnabarLabFossilRoomScientist1GoForAWalkText
	waitbutton
	closetext
	end

.BackToLife:
	checkevent EVENT_LAB_FOSSIL_IS_HELIX
	iftrue .ReviveOmanyte
	checkevent EVENT_LAB_FOSSIL_IS_AMBER
	iftrue .ReviveAerodactyl
	getmonname STRING_BUFFER_3, KABUTO
	scall .HandOverTheMon
	givepoke KABUTO, 30
	ifequal 2, .BoxIsFull
	sjump .Revived

.ReviveOmanyte:
	getmonname STRING_BUFFER_3, OMANYTE
	scall .HandOverTheMon
	givepoke OMANYTE, 30
	ifequal 2, .BoxIsFull
	sjump .Revived

.ReviveAerodactyl:
	getmonname STRING_BUFFER_3, AERODACTYL
	scall .HandOverTheMon
	givepoke AERODACTYL, 30
	ifequal 2, .BoxIsFull
	; fallthrough

.Revived:
	clearevent EVENT_GAVE_FOSSIL_TO_LAB
	clearevent EVENT_LAB_STILL_REVIVING_FOSSIL
	clearevent EVENT_LAB_FOSSIL_IS_HELIX
	clearevent EVENT_LAB_FOSSIL_IS_AMBER
	closetext
	end

.HandOverTheMon:
	writetext CinnabarLabFossilRoomScientist1FossilIsBackToLifeText
	promptbutton
; Yellow's GivePokemon prints "<PLAYER> got @!" on both the party and the box
; path; GSC's givepoke only prints the box one, so the party line goes here --
; the convention hack/maps/CeladonMansionRoofHouse.asm set for the gift mons.
	readvar VAR_PARTYCOUNT
	ifequal PARTY_LENGTH, .StraightToTheBox
	writetext CinnabarLabFossilRoomGotFossilMonText
	playsound SFX_CAUGHT_MON
	waitsfx
.StraightToTheBox:
	end

.BoxIsFull:
; Yellow returns nc here and leaves EVENT_GAVE_FOSSIL_TO_LAB set, so the mon is
; still owed and the player can come back for it once there is room.
	writetext CinnabarLabFossilRoomBoxIsFullText
	waitbutton
	closetext
	end

.MenuHeaderDHA:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 14, 7
	dw .MenuDataDHA
	db 1 ; default option

.MenuDataDHA:
	db STATICMENU_CURSOR ; flags
	db 3 ; items
	db "DOME FOSSIL@"
	db "HELIX FOSSIL@"
	db "OLD AMBER@"

.MenuHeaderDH:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 14, 5
	dw .MenuDataDH
	db 1 ; default option

.MenuDataDH:
	db STATICMENU_CURSOR ; flags
	db 2 ; items
	db "DOME FOSSIL@"
	db "HELIX FOSSIL@"

.MenuHeaderDA:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 14, 5
	dw .MenuDataDA
	db 1 ; default option

.MenuDataDA:
	db STATICMENU_CURSOR ; flags
	db 2 ; items
	db "DOME FOSSIL@"
	db "OLD AMBER@"

.MenuHeaderHA:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 14, 5
	dw .MenuDataHA
	db 1 ; default option

.MenuDataHA:
	db STATICMENU_CURSOR ; flags
	db 2 ; items
	db "HELIX FOSSIL@"
	db "OLD AMBER@"

.MenuHeaderD:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 14, 3
	dw .MenuDataD
	db 1 ; default option

.MenuDataD:
	db STATICMENU_CURSOR ; flags
	db 1 ; items
	db "DOME FOSSIL@"

.MenuHeaderH:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 14, 3
	dw .MenuDataH
	db 1 ; default option

.MenuDataH:
	db STATICMENU_CURSOR ; flags
	db 1 ; items
	db "HELIX FOSSIL@"

.MenuHeaderA:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 14, 3
	dw .MenuDataA
	db 1 ; default option

.MenuDataA:
	db STATICMENU_CURSOR ; flags
	db 1 ; items
	db "OLD AMBER@"

CinnabarLabFossilRoomScientist2Script:
	faceplayer
	opentext
	trade NPC_TRADE_STICKY
	waitbutton
	closetext
	end

CinnabarLabFossilRoomScientist1Text:
	text "Hiya!"

	para "I am important"
	line "doctor!"

	para "I study here rare"
	line "#MON fossils!"

	para "You! Have you a"
	line "fossil for me?"
	done

CinnabarLabFossilRoomScientist1NoFossilsText:
	text "No! Is too bad!"
	done

CinnabarLabFossilRoomScientist1SeesFossilText:
	text "Oh! That is"
	line "@"
	text_ram wStringBuffer4
	text "!"

	para "It is fossil of"
	line "@"
	text_ram wStringBuffer3
	text ", a"
	cont "#MON that is"
	cont "already extinct!"

	para "My Resurrection"
	line "Machine will make"
	cont "that #MON live"
	cont "again!"
	done

CinnabarLabFossilRoomScientist1TakesFossilText:
	text "So! You hurry and"
	line "give me that!"

	para "<PLAYER> handed"
	line "over @"
	text_ram wStringBuffer4
	text "!"
	done

CinnabarLabFossilRoomScientist1GoForAWalkText:
	text "I take a little"
	line "time!"

	para "You go for walk a"
	line "little while!"
	done

CinnabarLabFossilRoomScientist1ComeAgainText:
	text "Aiyah! You come"
	line "again!"
	done

CinnabarLabFossilRoomScientist1FossilIsBackToLifeText:
	text "Where were you?"

	para "Your fossil is"
	line "back to life!"

	para "It was @"
	text_ram wStringBuffer3
	text_start
	line "like I think!"
	done

CinnabarLabFossilRoomGotFossilMonText:
	text "<PLAYER> got"
	line "@"
	text_ram wStringBuffer3
	text "!"
	done

CinnabarLabFossilRoomBoxIsFullText:
	text "There's no more"
	line "room for #MON!"

	para "The #MON BOX"
	line "is full and can't"
	cont "accept any more!"
	done

; Yellow's two `hidden_event 0/2, 4, OpenPokemonCenterPC, SPRITE_FACING_UP`
; (data/events/hidden_events.asm) -- full #MON Center PCs, as GSC bg_events
; (the SilphCo11F / CeladonMansion2F precedent: `jumpstd PCScript`).  12p.
CinnabarLabFossilRoomPC:
	jumpstd PCScript

CinnabarLabFossilRoom_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, CINNABAR_LAB, 5
	warp_event  3,  7, CINNABAR_LAB, 5

	def_coord_events

	def_bg_events
	bg_event  0,  4, BGEVENT_UP, CinnabarLabFossilRoomPC ; Yellow's OpenPokemonCenterPC hidden event
	bg_event  2,  4, BGEVENT_UP, CinnabarLabFossilRoomPC ; Yellow's OpenPokemonCenterPC hidden event

	def_object_events
	object_event  5,  2, SPRITE_SCIENTIST, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CinnabarLabFossilRoomScientist1Script, -1
	object_event  7,  6, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CinnabarLabFossilRoomScientist2Script, -1
