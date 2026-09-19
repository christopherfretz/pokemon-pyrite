; Kanto hack (docs/RIVAL-NAMING.md): Yellow's rival default-name list, shown by
; ShowRivalNamingChoices during Oak's speech.  Yellow's entries are
; NEW NAME / BLUE / GARY / JOHN (vendor/pokeyellow/constants/player_constants.asm
; RIVALNAME1..3, listed by DefaultNamesRival), cursor parked on NEW NAME and B
; disabled, exactly like Crystal's own player-name menu.

RivalNameMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 10, TEXTBOX_Y - 1
	dw .RivalNames
	db 1 ; default option
	db 0 ; ???

.RivalNames:
	db STATICMENU_CURSOR | STATICMENU_PLACE_TITLE | STATICMENU_DISABLE_B ; flags
	db 4 ; items
	db "NEW NAME@"
	db "BLUE@"
	db "GARY@"
	db "JOHN@"
	db 2 ; title indent
	db " NAME @" ; title
