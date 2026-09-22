; Kanto hack (M8 11j, docs/M8-SAFFRON.md 0.6 row 11j and D72): the one shared
; tail every SILPH CO. card-key door jumps into.
;
; The 20 doors (2F x2, 3F x2, 4F x2, 5F x3, 6F x1, 7F x3, 8F x1, 9F x4, 10F x1,
; 11F x1) are BGEVENT_READs on the door's two walled tiles, each running the
; `silph_card_key_door` macro (macros/scripts/card_key.asm).  The macro does the
; per-door part -- the flag, the CARD KEY test and the changeblock -- and
; sjumps here for the part that is identical everywhere.  This file is INCLUDEd
; at the head of SECTION "Map Scripts 31" (bank $7a), which holds SILPH CO.
; 2F-11F, so the sjumps are 2-byte same-bank jumps.
;
; Text and sounds are Yellow's: _CardKeySuccessText1/2 and _CardKeyFailText
; (vendor/pokeyellow/data/text/text_1.asm:1-14), the item jingle Yellow embeds
; in the success text as `sound_get_item_1`, and SFX_GO_INSIDE = our
; SFX_ENTER_DOOR (the same pairing maps/RadioTower3F.asm:139-149 already uses
; for Crystal's one card-key shutter).  Yellow prints the text first and only
; then swaps the block, so the macro's changeblock is invisible until the
; refreshmap below -- the player reads the line, then watches the door open.

SilphCoCardKeyOpenedScript:
	opentext
	writetext SilphCoCardKeyOpenedText
	waitbutton
	playsound SFX_ENTER_DOOR
	refreshmap
	closetext
	waitsfx
	end

SilphCoCardKeyLockedScript:
	opentext
	writetext SilphCoCardKeyLockedText
	waitbutton
	closetext
	end

SilphCoCardKeyOpenedText:
; Yellow splits this line around its sfx byte (_CardKeySuccessText1, $0b,
; _CardKeySuccessText2).  GSC's TX_SOUND_ITEM is a text COMMAND, not a
; character, so the first string has to be terminated with "@" and the second
; restarted with text_start -- exactly how Crystal writes its own
; "<PLAYER> received @..!" line (data/text/common_1.asm).  Leaving the macro
; inside the string prints tile $0f instead of playing anything.
	text "Bingo!@"
	sound_item
	text_start
	line "The CARD KEY"
	cont "opened the door!"
	done

SilphCoCardKeyLockedText:
	text "Darn! It needs a"
	line "CARD KEY!"
	done
