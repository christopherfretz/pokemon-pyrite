PhotoStudio:
	ld hl, .WhichMonPhotoText
	call PrintText
	farcall SelectMonFromParty
	jr c, .cancel
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg

	ld hl, .HoldStillText
	call PrintText
	call DisableSpriteUpdates
	farcall PrintPartymon
	call ReturnToMapWithSpeechTextbox
	ldh a, [hPrinter]
	and a
	jr nz, .cancel
	ld hl, .PrestoAllDoneText
	jr .print_text

.cancel
	ld hl, .NoPhotoText
	jr .print_text

.egg
	ld hl, .EggPhotoText

.print_text
	call PrintText
	ret

.WhichMonPhotoText:
	text_far _WhichMonPhotoText
	text_end

.HoldStillText:
	text_far _HoldStillText
	text_end

.PrestoAllDoneText:
	text_far _PrestoAllDoneText
	text_end

.NoPhotoText:
	text_far _NoPhotoText
	text_end

.EggPhotoText:
	text_far _EggPhotoText
	text_end

FanClubPhoto:
; Special.  Kanto hack (7f): the GB Printer half of Yellow's #MON FAN CLUB
; chairman (vendor/pokeyellow/scripts/PokemonFanClub.asm:196 .select_mon_to_print).
; Yellow has no "which #MON?" and no "hold still" line -- the offer itself is
; the question -- and it prints its own result text from hOaksAideResult, so
; this hands the three outcomes back in wScriptVar instead of printing
; anything.  Crystal's own PhotoStudio above is untouched.
	ld a, FANCLUB_PHOTO_NO_MON
	ld [wScriptVar], a
	farcall SelectMonFromParty
	ret c
	ld a, [wCurPartySpecies]
	cp EGG
	ret z ; Yellow has no EGGs; treat one like a cancel rather than print it
	call DisableSpriteUpdates
	farcall PrintPartymon
	call ReturnToMapWithSpeechTextbox
	ldh a, [hPrinter]
	and a
	ld a, FANCLUB_PHOTO_CANCELLED
	jr nz, .done
	ld a, FANCLUB_PHOTO_PRINTED
.done
	ld [wScriptVar], a
	ret
