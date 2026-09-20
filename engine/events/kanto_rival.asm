; Kanto hack (M6 step 9e, docs/M6-TOWER.md 5.4): Yellow's rival-starter rule,
; re-derived from event flags.
;
; Yellow stores one saved byte, wRivalStarter, holding RIVAL_STARTER_JOLTEON /
; _FLAREON / _VAPOREON (1/2/3).  It is written in exactly two places --
; OaksLab.asm:230-231 and :381 (JOLTEON when the rival takes the ball, then
; FLAREON if the player WON the lab battle, VAPOREON if not) and
; Route22.asm:151-156 (FLAREON -> JOLTEON when the player wins ROUTE 22; it only
; fires on a win and only upgrades FLAREON, so a lab loss stays VAPOREON for the
; rest of the game).  Four scripts read it back: PokemonTower2F.asm:150,
; SilphCo7F.asm:187, ChampionsRoom.asm:73 and Route22.asm:35.
;
; This project has no wRivalStarter.  WRAM1 is full (HANDOFF "Budgets"), and the
; two win/loss facts are already stored as flags, so the rule is a pure function
; of the pair -- the authoritative statement is the comment block in
; constants/event_flags.asm above EVENT_BEAT_OAKS_LAB_RIVAL:
;
;   EVENT_BEAT_OAKS_LAB_RIVAL + EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE -> JOLTEON
;   EVENT_BEAT_OAKS_LAB_RIVAL alone                                 -> FLAREON
;   neither (the lab battle was lost)                               -> VAPOREON
;
; INTERFACE (this is the piece rival battles #5-#7 reuse -- SILPH CO. 7F, the
; CHAMPION's room, and Yellow's second ROUTE 22 fight):
;
;   special GetKantoRivalStarter
;   ifequal RIVAL_STARTER_JOLTEON, .Jolteon
;   ifequal RIVAL_STARTER_FLAREON, .Flareon
;   ; fall through: RIVAL_STARTER_VAPOREON
;
; wScriptVar comes back holding 1, 2 or 3, exactly Yellow's wRivalStarter value,
; and the caller picks its own party row with `loadtrainer KANTO_RIVAL, <const>`.
;
; ⚠ It must be the ROW that is chosen, never a post-`loadtrainer` patch of
; wOTPartyMon5Species: `loadtrainer` only records wOtherTrainerClass /
; wOtherTrainerID, and the party is not built until InitEnemyTrainer ->
; ReadTrainerParty at battle start (engine/battle/core.asm:8144-8152), which
; zeroes wOTPartyMons first and then derives level-up moves, stats, DVs, types
; and the front pic from the ROM species byte (TrainerType1,
; engine/battle/read_trainer_party.asm:90).  Anything written into wOTPartyMon*
; before `startbattle` is erased; anything written after it would leave an
; EEVEE's moves and stats on a JOLTEON.

GetKantoRivalStarter::
	ld a, RIVAL_STARTER_VAPOREON
	ld [wScriptVar], a
	ld de, EVENT_BEAT_OAKS_LAB_RIVAL
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	and a
	ret z ; lab battle lost -> VAPOREON

	ld a, RIVAL_STARTER_FLAREON
	ld [wScriptVar], a
	ld de, EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	and a
	ret z ; lab won, ROUTE 22 not won -> FLAREON

	ld a, RIVAL_STARTER_JOLTEON
	ld [wScriptVar], a
	ret
