; Kanto hack (M12b-4): the SUMMER BEACH HOUSE PRINTER's YES branch -- Yellow's
; Func_f23d0 + PrintSurfingMinigameHighScore (vendor/pokeyellow/scripts/
; SummerBeachHouse_2.asm, engine/printer/printer.asm) on Crystal's printer
; engine, in _PrintDiploma's shape.  Yellow: printer music, the Hi-Score card
; (engine/games/surfing_hiscore_card.asm), send 9 rows, B cancels; then the map
; music, the card closes back to the text box, and the script says "PRINT
; completed." or, if the print was cancelled, "PRINT error!".  With no printer
; attached (a phone, an emulator) Crystal's status line shows until B, so the
; answer is always "PRINT error!", as on a Yellow cartridge with no printer.

PrintSurfingHiScore::
; Special.  wScriptVar = FALSE: printed; TRUE: cancelled (Yellow's
; hCanceledPrinting).
	ld a, [wPrinterQueueLength]
	push af
	call LoadStandardMenuHeader ; Yellow: SaveScreenTilesToBuffer2
	call ClearSprites
	call DisableSpriteUpdates

	xor a
	ldh [hPrinter], a
	call Printer_PlayMusic ; Yellow: Printer_PlayPrinterMusic, before the card
	farcall SurfingHiScoreCard_Draw
	; VBlank_Serial updates no palettes, so let one normal VBlank apply the
	; card's MEWMON palette first (else the status screen stays white)
	call DelayFrame

	ldh a, [rIE]
	push af
	xor a
	ldh [rIF], a
	ld a, IE_SERIAL | IE_VBLANK
	ldh [rIE], a

	ld hl, hVBlank
	ld a, [hl]
	push af
	ld [hl], VBLANK_SERIAL

	ln a, 1, 3 ; to be loaded to wPrinterMargins: Yellow's wcae2 = $13
	call Printer_PrepareTilemapForPrint
	call Printer_ResetJoypadRegisters

	ld a, SCREEN_HEIGHT / 2
	ld [wPrinterQueueLength], a
	call SendScreenToPrinter
	ld a, FALSE
	jr nc, .done
	ld a, TRUE
.done
	ld [wScriptVar], a

	pop af
	ldh [hVBlank], a
	call Printer_CleanUpAfterSend
	; Yellow: Printer_CopyTileMapFromPrinterTileBuffer (the card again, without
	; the status line)
	call Printer_CopyBufferToTilemap

	xor a
	ldh [rIF], a
	pop af
	ldh [rIE], a
	call Printer_RestartMapMusic ; Yellow: Printer_PlayMapMusic

	pop af
	ld [wPrinterQueueLength], a
	; wGameboyPrinterRAM shares SECTION UNION "Overworld Map" with
	; wOverworldMapBlocks: rebuild the blocks before the map comes back
	; (MAPSETUP_SUBMENU: LoadBlockData + LoadConnectionBlockData, as
	; _PrintDiploma's Printer_ExitPrinter does)
	call ReturnToMapFromSubmenu
	farcall SurfingHiScoreCard_Close
	ret
