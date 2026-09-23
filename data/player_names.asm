; Kanto hack (F4, docs/AUDIT-FULL-GAME-LEFTOVERS.md): Yellow's default player
; names NEW NAME / YELLOW / ASH / JACK (vendor/pokeyellow/constants/
; player_constants.asm PLAYERNAME1..3).  Yellow has no gender select; the girl
; keeps it (Q1 default) and gets the same list.

ChrisNameMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 10, TEXTBOX_Y - 1
	dw .MaleNames
	db 1 ; default option
	db 0 ; ???

.MaleNames:
	db STATICMENU_CURSOR | STATICMENU_PLACE_TITLE | STATICMENU_DISABLE_B ; flags
	db 4 ; items
	db "NEW NAME@"
MalePlayerNameArray:
	db "YELLOW@"
	db "ASH@"
	db "JACK@"
	db 2 ; title indent
	db " NAME @" ; title

KrisNameMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 10, TEXTBOX_Y - 1
	dw .FemaleNames
	db 1 ; default option
	db 0 ; ???

.FemaleNames:
	db STATICMENU_CURSOR | STATICMENU_PLACE_TITLE | STATICMENU_DISABLE_B ; flags
	db 4 ; items
	db "NEW NAME@"
FemalePlayerNameArray:
	db "YELLOW@"
	db "ASH@"
	db "JACK@"
	db 2 ; title indent
	db " NAME @" ; title
