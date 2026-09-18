; wPrinterStatus
	const_def 1
	const PRINTER_STATUS_CHECKING     ; 1
	const PRINTER_STATUS_TRANSMITTING ; 2
	const PRINTER_STATUS_PRINTING     ; 3
	const PRINTER_ERROR_1             ; 4
	const PRINTER_ERROR_2             ; 5
	const PRINTER_ERROR_3             ; 6
	const PRINTER_ERROR_4             ; 7

; wPrinterStatusFlags
	const_def 5
	shift_const PRINTER_STATUS_ERROR_3 ; 5
	shift_const PRINTER_STATUS_ERROR_4 ; 6
	shift_const PRINTER_STATUS_ERROR_1 ; 7

; wPrinterConnectionOpen
	const_def
	const PRINTER_CONNECTION_OPEN
	const PRINTER_CONNECTION_SUCCESS

; Kanto hack (7f): wScriptVar out of the FanClubPhoto special
; (engine/events/print_photo.asm).  Yellow's chairman branches on
; hOaksAideResult after PrintFanClubPortrait; our script needs the party-menu
; cancel told apart from the printer's own refusal, so it is a three-way.
	const_def
	const FANCLUB_PHOTO_NO_MON   ; 0: the party menu was cancelled ("No? That's really disappointing.")
	const FANCLUB_PHOTO_PRINTED  ; 1: hOaksAideResult == 0 ("OK, I'm done.")
	const FANCLUB_PHOTO_CANCELLED ; 2: hOaksAideResult != 0 ("Maybe we won't PRINT this now.")
