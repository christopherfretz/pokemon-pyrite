; Yellow's Pikachu emotion system (docs/PIKACHU-EMOTIONS.md A5 steps E5 + E6),
; ported from vendor/pokeyellow/engine/pikachu/pikachu_emotions.asm and
; .../pikachu_pic_animation.asm.  The 2-D mood x happiness lookup, the 34
; emotion scripts and the 11-command interpreter are Yellow's; only the four
; commands that touch hardware Gen 2 does differently are re-expressed:
;   emotebubble -> Crystal emote objects via FollowerSpawnEmote
;   pcm         -> cry PIKACHU + the PlayPikachuVoiceClip hook (Decision A)
;   movement    -> a mini-interpreter over wFollowerStruct (see below)
;   pikapic     -> engine/pikachu/pikapic.asm, the E3/E4 face box


TalkToPikachu::
; callasm target for PikachuFollowerScript (engine/overworld/follower.asm).
	farcall FollowerFacePlayer
	call MapSpecificPikachuExpression
	jr c, PlayPikachuEmotion
	call GetPikaPicAnimationScriptIndex
	jr PlayPikachuEmotion

PlaySpecificPikachuEmotion::
; e = emotion index.  Yellow passes it in e too, and it has to stay out of a:
; farcall loads the destination bank into a on the way in.
	ld a, e
PlayPikachuEmotion:
	ld [wPikaEmotionNumber], a
	ld hl, PikachuEmotionTable
	call DoStarterPikachuEmotions
	ret


; === The 2-D lookup (Yellow's GetPikaPicAnimationScriptIndex, verbatim) ======

GetPikaPicAnimationScriptIndex:
; Returns the emotion index in a.  `dpikapic PikaPicAnimScriptN` == N ==
; `dpikaemotion PikachuEmotionN`, which is why Yellow reuses one table for both.
; Yellow reads wPikachuHappiness inline here; ours comes from a farcall that
; clobbers de, so it has to happen before e holds the mood column.
	call GetStarterPikachuHappinessByte
	push af
	ld hl, PikachuMoodLookupTable
	ld a, [wPikaMood]
	ld d, a
.get_mood_param
	ld a, [hli]
	inc hl
	cp d
	jr c, .get_mood_param
	dec hl
	ld e, [hl]
	pop af
	ld d, a
	ld hl, PikaPicAnimationScriptPointerLookupTable
	ld bc, 6
.get_happiness_param
	ld a, [hl]
	cp d
	jr nc, .got_animation
	add hl, bc
	jr .get_happiness_param

.got_animation
	ld d, 0
	add hl, de
	ld a, [hl]
	ret

PikachuMoodLookupTable:
; First byte: mood threshold.  Second byte: column index (1-5).
	db  40, 1
	db 127, 2
	db 128, 3
	db 210, 4
	db 255, 5

PikaPicAnimationScriptPointerLookupTable:
; First byte: happiness threshold.  Remaining five: one per mood column.
	db 50
	dpikapic PikaPicAnimScript14
	dpikapic PikaPicAnimScript14
	dpikapic PikaPicAnimScript6
	dpikapic PikaPicAnimScript13
	dpikapic PikaPicAnimScript13

	db 100
	dpikapic PikaPicAnimScript9
	dpikapic PikaPicAnimScript9
	dpikapic PikaPicAnimScript5
	dpikapic PikaPicAnimScript12
	dpikapic PikaPicAnimScript12

	db 130
	dpikapic PikaPicAnimScript3
	dpikapic PikaPicAnimScript3
	dpikapic PikaPicAnimScript1
	dpikapic PikaPicAnimScript8
	dpikapic PikaPicAnimScript8

	db 160
	dpikapic PikaPicAnimScript3
	dpikapic PikaPicAnimScript3
	dpikapic PikaPicAnimScript4
	dpikapic PikaPicAnimScript15
	dpikapic PikaPicAnimScript15

	db 200
	dpikapic PikaPicAnimScript17
	dpikapic PikaPicAnimScript17
	dpikapic PikaPicAnimScript7
	dpikapic PikaPicAnimScript2
	dpikapic PikaPicAnimScript2

	db 250
	dpikapic PikaPicAnimScript17
	dpikapic PikaPicAnimScript17
	dpikapic PikaPicAnimScript16
	dpikapic PikaPicAnimScript10
	dpikapic PikaPicAnimScript10

	db 255
	dpikapic PikaPicAnimScript17
	dpikapic PikaPicAnimScript17
	dpikapic PikaPicAnimScript19
	dpikapic PikaPicAnimScript20
	dpikapic PikaPicAnimScript20


; === Map / status / modifier overrides (Yellow's MapSpecificPikachuExpression)

MapSpecificPikachuExpression:
; Returns carry with the emotion index in a if something overrides the
; mood x happiness lookup.
	ld bc, GROUP_POKEMON_FAN_CLUB << 8 | MAP_POKEMON_FAN_CLUB
	call PikachuCheckCurMap
	jr nz, .not_fan_club
; Yellow branches on wPikachuMapScriptFlags' BIT_PIKACHU_MAP_SCRIPT_ACTIVE
; (7f / A3 row 10): before the club's Pikachu scene has played this visit it is
; emotion 29 -- which is the face the scene itself puts up, via
; InitializePikachuTextID -- and afterwards emotion 30, but only while Pikachu
; is still parked by the CLEFAIRY.  Yellow's second test is
; CheckPikachuFollowingPlayer, i.e. the same bit the Pewter JIGGLYPUFF sleep
; uses, which is our wPikaAsleep.
	ld a, [wPikaFanClubSceneDone]
	and a
	ldpikaemotion a, PikachuEmotion29
	jr z, .play_emotion
	ld a, [wPikaAsleep]
	and a
	ldpikaemotion a, PikachuEmotion30
	jr nz, .play_emotion
	jr .check_pikachu_status

.not_fan_club
	ld bc, GROUP_PEWTER_POKECENTER_1F << 8 | MAP_PEWTER_POKECENTER_1F
	call PikachuCheckCurMap
	jr nz, .not_pewter_pokecenter
; J5 bug fix: Yellow's CheckPikachuFollowingPlayer returns NZ when Pikachu is
; *not* following, i.e. when the Jigglypuff song has put it to sleep; ours
; returns carry when the follower is OUT, which is the opposite, so emotion 26
; (the wake-up face) used to play on EVERY talk in this Pokemon Center.  The
; real predicate is our sleep flag.
	ld a, [wPikaAsleep]
	and a
	ldpikaemotion a, PikachuEmotion26
	jr nz, .play_emotion
	jr .check_pikachu_status

.not_pewter_pokecenter
	call BillsHouse_CheckPikachuEmotion
	ld a, e
	cp $ff
	jr nz, .play_emotion

.check_pikachu_status
	call GetStarterPikachuStatus
	and SLP_MASK
	ldpikaemotion a, PikachuEmotion11
	jr nz, .play_emotion
	call GetStarterPikachuStatus
	and a
	ldpikaemotion a, PikachuEmotion28
	jr nz, .play_emotion
; Yellow follows with POKEMON_TOWER_1F..POKEMON_TOWER_7F -> emotion 22.
; TODO A3 row 2: Lavender Town is not ported yet, so there is no map constant
; to compare against.  Reinstate this when POKEMON_TOWER_* exists:
;	ld a, [wMapNumber]
;	cp MAP_POKEMON_TOWER_1F
;	jr c, .not_in_lavender_tower
;	cp POKEMON_TOWER_7F + 1
;	ldpikaemotion a, PikachuEmotion22
;	jr c, .play_emotion
;.not_in_lavender_tower
	call GetPikachuEmotionModifier
	and a
	jr z, .mood_based_emotion
	dec a
	ld c, a
	ld b, 0
	ld hl, .Emotions
	add hl, bc
	ld a, [hl]
	jr .play_emotion

.mood_based_emotion
	and a
	ret

.play_emotion
	scf
	ret

.Emotions:
	dpikaemotion PikachuEmotion18 ; 1: caught a Pokemon
	dpikaemotion PikachuEmotion21 ; 2: used a fishing rod
	dpikaemotion PikachuEmotion23 ; 3: refused an evolution stone
	dpikaemotion PikachuEmotion24 ; 4: learned THUNDERBOLT
	dpikaemotion PikachuEmotion25 ; 5: learned THUNDER

PikachuCheckCurMap:
; b = map group, c = map number.  Returns z if the player is on that map.
; Crystal addresses maps by (group, number); Yellow had a flat wCurMap.
	ld a, [wMapGroup]
	cp b
	ret nz
	ld a, [wMapNumber]
	cp c
	ret

BillsHouse_CheckPikachuEmotion:
; A3 row 3, ported from vendor/pokeyellow/scripts/BillsHouse_2.asm.  Yellow's
; SCRIPT_BILLSHOUSE_SCRIPT0/5 arms belong to its map-script state machine, which
; Crystal's scene system does not mirror; those two only fire mid-scene, so the
; two event-driven arms are what a player can actually reach.
	ld e, $ff
	ld bc, GROUP_BILLS_HOUSE << 8 | MAP_BILLS_HOUSE
	call PikachuCheckCurMap
	ret nz
	call CheckPikachuFollowingPlayer
	ret nc
; Yellow: EVENT_MET_BILL_2, set at the end of the cell-separator scene, which is
; our EVENT_USED_CELL_SEPARATOR_ON_BILL (docs/M3-CERULEAN.md 6j).
	ld de, EVENT_USED_CELL_SEPARATOR_ON_BILL
	ld b, CHECK_FLAG
	call EventFlagAction
	ldpikaemotion e, PikachuEmotion32
	ret z
	ldpikaemotion e, PikachuEmotion31
	ret


; === Helpers ===============================================================

CheckPikachuFollowingPlayer:
; Yellow's home/pikachu.asm routine.  Returns carry if Pikachu is out.
	ld a, [wPikaFollowFlags]
	bit FOLLOWER_ENABLED_F, a
	jr z, .no
	farcall IsStarterPikachuAliveInParty
	ret
.no
	and a
	ret

GetStarterPikachuHappinessByte:
; Returns MON_HAPPINESS in a (0 if the starter Pikachu is not in the party).
	farcall GetStarterPikachuHappiness
	ld a, [wScriptVar]
	ret

FindStarterPikachuInParty:
; Returns carry and hl = the starter Pikachu's MON_OT_ID + 1, or no carry if it
; is not in the party.
	ld a, [wPartyCount]
	and a
	ret z ; and a cleared carry
	ld e, a
	ld d, 0
.loop
	ld c, d
	farcall IsStarterPikachuInSlot ; preserves de; hl = that mon's MON_OT_ID + 1
	ret c
	inc d
	dec e
	jr nz, .loop
	and a
	ret

GetStarterPikachuStatus:
; Returns the starter Pikachu's MON_STATUS in a (0 if it is not in the party).
; Yellow splits this into IsPlayerPikachuAsleepInParty and
; CheckPikachuStatusCondition; one walk of the party answers both.
	call FindStarterPikachuInParty
	jr c, .found
	xor a
	ret

.found
	ld bc, MON_STATUS - MON_OT_ID - 1
	add hl, bc
	ld a, [hl]
	ret

GetPikachuEmotionModifier::
; Returns Yellow's wPikachuEmotionModifier (0-5) in a.  Ours is packed into the
; top three bits of the saved wPikaFollowFlags byte.
	ld a, [wPikaFollowFlags]
	and FOLLOWER_EMOTION_MASK
	swap a
	srl a
	ret

SetPikachuEmotionModifier::
; c = the new modifier (0-5).  Yellow's `ld [wPikachuEmotionModifier], a`.
	ld a, [wPikaFollowFlags]
	and ~FOLLOWER_EMOTION_MASK & $ff
	ld b, a
	ld a, c
	add a
	swap a
	and FOLLOWER_EMOTION_MASK
	or b
	ld [wPikaFollowFlags], a
	ret


; === The interpreter (Yellow's DoStarterPikachuEmotions, verbatim) ==========

DoStarterPikachuEmotions:
; a = index into the hl pointer table.
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
.loop
	ld a, [de]
	inc de
	cp PIKAEMOTION_END
	jr z, .done
	ld c, a
	ld b, 0
	ld hl, StarterPikachuEmotionsJumptable
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call .jump_to_address
	jr .loop

.done
	ret

.jump_to_address
	jp hl

StarterPikachuEmotionsJumptable:
	table_width 2
	dw StarterPikachuEmotionCommand_nop      ; 0
	dw StarterPikachuEmotionCommand_text     ; 1
	dw StarterPikachuEmotionCommand_pcm      ; 2
	dw StarterPikachuEmotionCommand_emote    ; 3
	dw StarterPikachuEmotionCommand_movement ; 4
	dw StarterPikachuEmotionCommand_pikapic  ; 5
	dw StarterPikachuEmotionCommand_subcmd   ; 6
	dw StarterPikachuEmotionCommand_delay    ; 7
	dw StarterPikachuEmotionCommand_nop2     ; 8
	dw StarterPikachuEmotionCommand_9        ; 9
	dw StarterPikachuEmotionCommand_nop3     ; a
	assert_table_length NUM_PIKAEMOTION_COMMANDS

StarterPikachuEmotionCommand_nop:
StarterPikachuEmotionCommand_nop2:
; Yellow's dummy2: a _DEBUG-only "print the expression number" in Red's room.
StarterPikachuEmotionCommand_nop3:
	ret

StarterPikachuEmotionCommand_text:
; No shipped emotion script uses this -- Yellow's Pewter / Bill's House lines
; come from the subcommands -- but it is part of the bytecode, so it is here.
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	inc de
	push de
	call PrintText
	pop de
	ret

StarterPikachuEmotionCommand_pcm:
	ld a, [de]
	inc de
	push de
	ld e, a
	call PlayPikachuVoiceClip
	pop de
	ret

PlayPikachuVoiceClip::
; e = the Yellow voice-clip id, or PIKACRY_NONE.  The id is kept in e and NOT
; in a on purpose: farcall loads the callee's bank into a, so every hook site
; outside this bank can still reach us with the id intact.
;
; A1-S1: ids whose .pcm is linked in (Tier 1: 4, 11, 17, 28, 37) play Yellow's
; sampled clip; every other id still falls back to Crystal's synthesized
; PIKACHU cry, which is what PlayPikachuSoundClip's no-carry return means.
; Porting another clip is a data-only change -- data/pikachu/cry_pointers.asm.
	ld a, e
	cp PIKACRY_NONE
	ret z
	call PlayPikachuSoundClip
	ret c
	ld a, PIKACHU
	call PlayMonCry
	ret

StarterPikachuEmotionCommand_emote:
; Yellow: ShowPikachuEmoteBubble -> predef EmotionBubble, which blocks for 60
; frames and cleans up after itself.  Ours spawns a real Crystal emote object
; on the follower, waits the same 60 frames and despawns it.  Decision C: the
; eight bubble graphics are byte-identical between the two games and in the
; same order, so Yellow's bubble id is already an EMOTE_* id.
	ld a, [de]
	inc de
	push de
	ld c, a
	farcall LoadEmote
	farcall FollowerSpawnEmote
	ld c, PIKAEMOTION_BUBBLE_FRAMES
	call DelayFrames
	farcall FollowerDespawnEmote
	pop de
	ret

StarterPikachuEmotionCommand_movement:
	ld a, [de]
	inc de
	ld l, a
	ld a, [de]
	inc de
	ld h, a
	push de
	call ApplyPikachuMovementData
	pop de
	ret

StarterPikachuEmotionCommand_pikapic:
; Yellow's .RunPikapic: open the face box, run the selected PikaPicAnimScript,
; close it again.  engine/pikachu/pikapic.asm (E3/E4) does all three.
	ld a, [de]
	inc de
	ld [wPikaPicAnimNumber], a
	push de
	call Pikapic
	pop de
	ret

StarterPikachuEmotionCommand_delay:
	ld a, [de]
	inc de
	push de
	ld c, a
	call DelayFrames
	pop de
	ret

StarterPikachuEmotionCommand_subcmd:
	ld a, [de]
	inc de
	push de
	ld e, a
	ld d, 0
	ld hl, .Subcommands
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call .jump_to_address
	pop de
	ret

.jump_to_address
	jp hl

.Subcommands:
	table_width 2
	dw .LoadExtraPikaSprites
	dw .LoadFont
	dw .ShowMapView
	dw .WaitButtonPress
	dw .CheckPewterCenter
	dw .CheckLavenderTower
	dw .CheckBillsHouse
	assert_table_length NUM_PIKAEMOTION_SUBCOMMANDS

.LoadExtraPikaSprites:
; Yellow's LoadPikachuSpriteIntoVRAM.  Our follower keeps a reserved VRAM tile
; (FOLLOWER_VTILE, docs/FOLLOWER.md) that MovementFunction_PikaFollower
; refreshes every frame, so there is nothing to load.
	ret

.LoadFont:
	call LoadStandardFont
	ret

.ShowMapView:
; Yellow's LoadCurrentMapView + three-frame pause.  ClosePikapicBox already
; restores the map after a face box, so this only has to matter for the four
; scripts that use the subcommand on its own; doing the restore here as well
; is idempotent and keeps Yellow's timing.
;
; J9 fix (operator playtest, 2026-09-19): ApplyTilemap LEAVES hBGMapMode = 1,
; and in Crystal's overworld that is poison.  The overworld runs at
; hBGMapMode = 0 and scrolls by writing single rows/columns into the BG map at
; wBGMapAnchor; with mode 1 latched on, VBlank instead re-copies the frozen
; wTilemap over vBGMap0 in thirds, every frame, while the anchor and hSCX/hSCY
; walk away from it -- the "map bugs out" symptom (black rows, stale objects)
; that lasted until the next map load re-anchored everything.  Unlike Pikapic,
; which brackets its whole run, this subcommand had no save/restore, so it was
; the last writer before the script handed control back to the overworld.
; Yellow has the same shape and no hazard (its overworld runs with
; hAutoBGTransferEnabled on), so giving the caller its mode back is both the
; minimal and the faithful fix.  Emotion 26 -- the Pewter JIGGLYPUFF wake -- is
; the only *reachable* user today, which is why only the sleep path showed it.
	ldh a, [hBGMapMode]
	push af
	call LoadOverworldTilemapAndAttrmapPals
	call ApplyTilemap
	call UpdateSprites
	ld c, 3
	call DelayFrames
	pop af
	ldh [hBGMapMode], a
	ret

.WaitButtonPress:
	call WaitPressAorB_BlinkCursor
	ret

.CheckPewterCenter:
; Yellow's PikachuPewterPokecenterCheck
; (vendor/pokeyellow/engine/pikachu/pikachu_movement.asm:973): clear the sleep
; and turn away from the player.  The dispatcher pushes de around this call.
	ld bc, GROUP_PEWTER_POKECENTER_1F << 8 | MAP_PEWTER_POKECENTER_1F
	call PikachuCheckCurMap
	ret nz
	xor a
	ld [wPikaAsleep], a
	jp StarterPikachuEmotionCommand_9

.CheckLavenderTower:
; Yellow's PikachuFanClubCheck (vendor/pokeyellow/engine/pikachu/pikachu_movement.asm:981)
; -- mis-named in Yellow's own subcommand table, and kept mis-named here so the
; two files line up.  It ends emotion 30: talking to the Pikachu the Fan Club
; scene parked by the CLEFAIRY sends it back to following the player, facing
; away again.  Same shape as .CheckPewterCenter above.
	ld bc, GROUP_POKEMON_FAN_CLUB << 8 | MAP_POKEMON_FAN_CLUB
	call PikachuCheckCurMap
	ret nz
	xor a
	ld [wPikaAsleep], a
	jp StarterPikachuEmotionCommand_9

.CheckBillsHouse:
; TODO A3 row 3 (scene half): Yellow's PikachuBillsHouseCheck runs
; BillsHousePikachuConfused, which walks Pikachu around the player with the
; diagonal step opcodes we did not port.  The emotion itself still plays.
	ret

StarterPikachuEmotionCommand_9:
; Yellow: turn away from the player.
	push de
	ld a, [wPlayerDirection]
	and %00001100
	xor %00000100 ; Yellow's `xor $4` -- same flip FollowerFacePlayer uses
	ld [wFollowerDirection], a
	call FollowerEmotionStepFrame
	pop de
	ret


; === Movement (see constants/pikachu_emotion_constants.asm) =================

ApplyPikachuMovementData:
; hl = a PikachuMovementData_* blob in this bank.
; Yellow swaps the player's and Pikachu's Gen 1 sprite-state blocks and drives
; the movement through the *player's* slot; our follower is a real Crystal map
; object, so we drive wFollowerStruct directly.  One Yellow loop iteration
; ("unit") is two frames, which is what FollowerEmotionStepFrame delays.
.loop
	ld a, [hli]
	cp PIKAMOVE_END
	ret z
	push af
	ld a, [hl]
	ld e, a
	inc hl
	pop af
	cp PIKAMOVE_INIT
	jr z, .init
	cp PIKAMOVE_TURN
	jr z, .turn
	cp PIKAMOVE_HOLD
	jr z, .hold
	cp PIKAMOVE_HOP
	jr z, .hop
	; PIKAMOVE_TURNEVERY
	ld a, [hli]
	ld d, a
	call .TurnEvery
	jr .loop

.init:
; Yellow's $00 costs one unit and resets the sprite offsets.
	dec hl ; no operand
	xor a
	ld [wFollowerStruct + OBJECT_SPRITE_Y_OFFSET], a
	ld [wFollowerStruct + OBJECT_SPRITE_X_OFFSET], a
	ld [wFollowerStruct + OBJECT_STEP_FRAME], a
	ld a, OBJECT_ACTION_STAND
	ld [wFollowerStruct + OBJECT_ACTION], a
	call FollowerEmotionStepFrame
	jr .loop

.turn:
; e units, one clockwise quarter-turn each.
	push hl
.turn_loop
	call TurnFollowerClockwise
	call FollowerEmotionStepFrame
	dec e
	jr nz, .turn_loop
	pop hl
	jr .loop

.hold:
; e units holding the current facing.
	push hl
.hold_loop
	call FollowerEmotionStepFrame
	dec e
	jr nz, .hold_loop
	pop hl
	jr .loop

.hop:
; e units, arc stride [hl].  Yellow animates the walk frames through the hop
; (PikaMovementFunc2_UpdateJump advances the image index every 4 units), which
; is exactly what OBJECT_ACTION_STEP does for a Crystal object.
	ld a, [hli]
	ld d, a
	push hl
	ld a, OBJECT_ACTION_STEP
	ld [wFollowerStruct + OBJECT_ACTION], a
	ld c, 0
.hop_loop
	ld a, c
	add d
	ld c, a
	dec a ; the arc table starts at phase 1
	ld b, 0
	push bc
	ld c, a
	ld hl, PikachuHopArc
	add hl, bc
	ld a, [hl]
	cpl
	inc a ; negate: up is -y
	ld [wFollowerStruct + OBJECT_SPRITE_Y_OFFSET], a
	call FollowerEmotionStepFrame
	pop bc
	dec e
	jr nz, .hop_loop
	xor a
	ld [wFollowerStruct + OBJECT_SPRITE_Y_OFFSET], a
	ld [wFollowerStruct + OBJECT_STEP_FRAME], a
	ld a, OBJECT_ACTION_STAND
	ld [wFollowerStruct + OBJECT_ACTION], a
	pop hl
	jp .loop

.TurnEvery:
; e units, one counterclockwise quarter-turn every d units.
	push hl
	ld c, d
.turnevery_loop
	dec c
	jr nz, .no_turn
	ld c, d
	call TurnFollowerCounterclockwise
.no_turn
	call FollowerEmotionStepFrame
	dec e
	jr nz, .turnevery_loop
	pop hl
	ret

PikachuHopArc:
; Yellow's PikaMovementFunc_Sine at amplitude 16 over a half period of $20,
; sampled every two phase units: 16 * sin(pi * i / 32) for i = 2, 4 .. 32.
	db  3,  6,  8, 11, 13, 14, 15, 16
	db 15, 14, 13, 11,  8,  6,  3,  0

TurnFollowerClockwise:
; Yellow's Data_fd731 read forwards: DOWN -> LEFT -> UP -> RIGHT -> DOWN.
	ld hl, .Clockwise
	jr TurnFollower

.Clockwise:
	db OW_LEFT  ; from DOWN
	db OW_RIGHT ; from UP
	db OW_UP    ; from LEFT
	db OW_DOWN  ; from RIGHT

TurnFollowerCounterclockwise:
	ld hl, .Counterclockwise
	jr TurnFollower

.Counterclockwise:
	db OW_RIGHT ; from DOWN
	db OW_LEFT  ; from UP
	db OW_DOWN  ; from LEFT
	db OW_UP    ; from RIGHT

TurnFollower:
	ld a, [wFollowerDirection]
	and %00001100
	rrca
	rrca
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [wFollowerDirection], a
	ret

FollowerEmotionStepFrame:
; One Yellow movement unit: refresh the follower's facing from its direction /
; action, redraw, and wait two frames.  Scripts block HandleMap, so nothing
; else would tick the object (docs/FOLLOWER.md).
	push hl
	push de
	push bc
	farcall FollowerEmotionFrame
	pop bc
	pop de
	pop hl
	ret


; === The Pewter #MON Center JIGGLYPUFF set-piece (docs/JIGGLYPUFF.md J4) =====

PewterJigglypuffSong::
; `special` body for PewterJigglypuff (maps/PewterPokecenter1F.asm), ported
; from vendor/pokeyellow/scripts/PewterPokecenter_2.asm:10-79.  The text box is
; already open and stays open for the whole beat, exactly as Yellow's
; wDoNotWaitForButtonPressAfterDisplayingText does.  Crystal's script engine
; cannot wait on the sound driver, so the whole thing is asm like Yellow's.
;
; Yellow's timing, measured in the vanilla harness (docs/JIGGLYPUFF.md 1.5):
; text -> StopAllMusic -> 32 frames of silence -> the song -> one facing flip
; every 24 frames until BOTH music channels go idle -> 48 frames -> map music.
	ld de, MUSIC_NONE
	call PlayMusic ; Yellow's StopAllMusic
	ld c, 32
	call DelayFrames
	ld de, MUSIC_JIGGLYPUFF_SONG
	call PlayMusic

; b counts ring slots.  Yellow seeds the ring at the sprite's CURRENT facing and
; writes it unchanged on the first pass, so the first visible turn lands 24
; frames after the music starts; ours starts at DOWN because the object_event is
; SPRITEMOVEDATA_STANDING_DOWN and nothing turns it (the script has no
; faceplayer), which is the same thing.
	ld b, 0
.spin
	push bc
	ld a, b
	and %00000011
	ld c, a
	ld b, 0
	ld hl, .FacingRing
	add hl, bc
	ld e, [hl]
	ldh a, [hLastTalked]
	ld d, a
	farcall ApplyObjectFacing ; farcall clobbers a, keeps de
	ld c, 24
	call DelayFrames
	call .MusicPlaying
	pop bc
	inc b
	jr c, .spin

	ld c, 48
	call DelayFrames
	call RestartMapMusic

; The sleep, behind Yellow's two gates: the starter Pikachu has to actually be
; out (BIT_PIKACHU_SPAWN_STARTER) and free of any status condition
; (CheckPikachuStatusCondition / ret c).  Note both gates guard only the SLEEP:
; Yellow plays the song unconditionally, so talking again always sings again.
	call CheckPikachuFollowingPlayer
	ret nc
	call GetStarterPikachuStatus
	and a
	ret nz
	ld a, TRUE
	ld [wPikaAsleep], a
	ret

.MusicPlaying:
; Carry if either of the song's two channels is still running.  Modelled on
; _CheckSFX (audio/engine.asm) with channels 1-2 in place of 5-8.
	ld hl, wChannel1Flags1
	bit SOUND_CHANNEL_ON, [hl]
	jr nz, .playing
	ld hl, wChannel2Flags1
	bit SOUND_CHANNEL_ON, [hl]
	jr nz, .playing
	and a
	ret

.playing
	scf
	ret

.FacingRing:
; Yellow's .FacingDirections: down, left, up, right.  ApplyObjectFacing wants
; the direction pre-shifted (Script_turnobject does `add a / add a`).
	db DOWN << 2
	db LEFT << 2
	db UP << 2
	db RIGHT << 2

FanClubPikachuScene::
; Special.  Yellow's PokemonFanClubScript_59a44
; (vendor/pokeyellow/scripts/PokemonFanClub.asm:44), minus the dice roll and
; the "has it run before" bookkeeping, which the map script does with
; EVENT_POKEMON_FAN_CLUB_PIKACHU_SCENE.  wScriptVar comes back TRUE only if the
; scene actually played, so the caller knows whether to turn the CLEFAIRY.
	ld a, FALSE
	ld [wScriptVar], a
; Yellow: BIT_PIKACHU_SPAWN_STARTER, i.e. Pikachu is out and following.
	ld a, [wPikaFollowFlags]
	bit FOLLOWER_ENABLED_F, a
	ret z
	farcall IsStarterPikachuAliveInParty
	ret nc
; Never restage it on top of itself, and never wake the Pewter sleep with it.
	ld a, [wPikaFanClubSceneDone]
	and a
	ret nz
	ld a, [wPikaAsleep]
	and a
	ret nz
; Yellow: `callfar CheckPikachuStatusCondition / ret c` -- a sick Pikachu does
; not run off to admire the CLEFAIRY.
	call GetStarterPikachuStatus
	and a
	ret nz

; Yellow: EXCLAMATION_BUBBLE over sprite $f (Pikachu), through predef
; EmotionBubble, which holds for 60 frames.  Same body as
; StarterPikachuEmotionCommand_emote.
	ld c, EXCLAMATION_BUBBLE
	farcall LoadEmote
	farcall FollowerSpawnEmote
	ld c, PIKAEMOTION_BUBBLE_FRAMES
	call DelayFrames
	farcall FollowerDespawnEmote

	farcall FanClubPikachuWalk
	ld a, TRUE
	ld [wPikaFanClubSceneDone], a
	ld [wScriptVar], a
	ret

FanClubPikachuFace::
; Special.  Yellow's `callfar InitializePikachuTextID` at the end of the same
; routine: the face box goes up straight away, without the player talking to
; Pikachu.  MapSpecificPikachuExpression would pick emotion 29 here anyway, but
; Yellow names the script, so name it.
	ldpikaemotion e, PikachuEmotion29
	jp PlaySpecificPikachuEmotion

CheckPikachuAsleep::
; Special.  wScriptVar = TRUE while the JIGGLYPUFF SONG has Pikachu asleep.
; Yellow spells this `call CheckPikachuFollowingPlayer` (home/pikachu.asm:47),
; which is literally `bit 1, [wPikachuOverworldStateFlags]` -- the sleep bit --
; and it gates NURSE JOY in the Pewter #MON Center (J6 finding, see
; docs/JIGGLYPUFF.md: engine/events/pokecenter.asm:1-9 refuses to heal at all
; while Pikachu sleeps).  The caller decides what to do about it.
	ld a, [wPikaAsleep]
	and a
	ld a, FALSE
	jr z, .done
	ld a, TRUE
.done
	ld [wScriptVar], a
	ret


; === The scripts ===========================================================

MACRO pikaemotion_def
\1_id::
	dw \1
ENDM

PikachuEmotionTable::
	table_width 2
	pikaemotion_def PikachuEmotion0
	pikaemotion_def PikachuEmotion1
	pikaemotion_def PikachuEmotion2
	pikaemotion_def PikachuEmotion3
	pikaemotion_def PikachuEmotion4
	pikaemotion_def PikachuEmotion5
	pikaemotion_def PikachuEmotion6
	pikaemotion_def PikachuEmotion7
	pikaemotion_def PikachuEmotion8
	pikaemotion_def PikachuEmotion9
	pikaemotion_def PikachuEmotion10
	pikaemotion_def PikachuEmotion11
	pikaemotion_def PikachuEmotion12
	pikaemotion_def PikachuEmotion13
	pikaemotion_def PikachuEmotion14
	pikaemotion_def PikachuEmotion15
	pikaemotion_def PikachuEmotion16
	pikaemotion_def PikachuEmotion17
	pikaemotion_def PikachuEmotion18
	pikaemotion_def PikachuEmotion19
	pikaemotion_def PikachuEmotion20
	pikaemotion_def PikachuEmotion21 ; used a fishing rod
	pikaemotion_def PikachuEmotion22
	pikaemotion_def PikachuEmotion23
	pikaemotion_def PikachuEmotion24
	pikaemotion_def PikachuEmotion25
	pikaemotion_def PikachuEmotion26 ; wake up Pikachu in the Pewter Pokemon Center
	pikaemotion_def PikachuEmotion27
	pikaemotion_def PikachuEmotion28
	pikaemotion_def PikachuEmotion29
	pikaemotion_def PikachuEmotion30
	pikaemotion_def PikachuEmotion31
	pikaemotion_def PikachuEmotion32
	pikaemotion_def PikachuEmotion33
DEF NUM_PIKACHU_EMOTIONS EQU 34
	assert_table_length NUM_PIKACHU_EMOTIONS

PikachuEmotion33:
	db PIKAEMOTION_END

INCLUDE "data/pikachu/emotions.asm"


InitStarterPikachuMood::
; callasm from the Oak's Lab gift.  Yellow's new-game setup seeds
; wPikachuHappiness = 90 (Decision D) and wPikachuMood = 128 (neutral); ours
; live in the starter's MON_HAPPINESS and wPikaMood.
	ld a, PIKACHU_NEUTRAL_MOOD
	ld [wPikaMood], a
	ld c, 0
	call SetPikachuEmotionModifier
	call FindStarterPikachuInParty ; hl = that mon's MON_OT_ID + 1
	ret nc
	ld bc, MON_HAPPINESS - MON_OT_ID - 1
	add hl, bc
	ld [hl], PIKACHU_STARTER_HAPPINESS
	ret


; === Mood plumbing (Yellow's pikachu_happiness.asm / poison.asm) ===========

SetPikachuMoodAndModifier::
; b = Yellow's wPikachuEmotionModifier value (1-5), c = its wPikachuMood value.
; Yellow writes the pair together at every one of its modifier sites.
	ld a, c
	ld [wPikaMood], a
	ld c, b
	jp SetPikachuEmotionModifier

StepPikachuMood::
; Yellow's UpdatePikachuHappinessAndMood tail
; (vendor/pokeyellow/engine/events/poison.asm:137-156): on every counted step
; the mood converges one unit toward 128, and the step that reaches 128 clears
; the emotion modifier.  Yellow's other half -- a 50% chance of
; PIKAHAPPY_WALKING every 256 steps -- is already covered by Crystal's
; StepHappiness (docs/PIKACHU-EMOTIONS.md A4.1 note 3).
	ld hl, wPikaMood
	ld a, [hl]
	cp PIKACHU_NEUTRAL_MOOD
	jr z, .clear_modifier
	jr c, .increase
	dec a
	dec a
.increase
	inc a
	ld [hl], a
	cp PIKACHU_NEUTRAL_MOOD
	ret nz
.clear_modifier
	ld c, 0
	jp SetPikachuEmotionModifier

UpdatePikachuMoodAfterBattle::
; Yellow's UpdatePikachuMoodAfterBattle (pikachu_status.asm:117), which is only
; ever called with d = $82, i.e. "after a won battle the mood is at least 130".
; Yellow's d < 128 arm is unreachable, so it is not ported.
	farcall IsStarterPikachuAliveInParty
	ret nc
	ld a, [wPikaMood]
	cp PIKACHU_POSTBATTLE_MOOD_FLOOR
	ret nc
	ld a, PIKACHU_POSTBATTLE_MOOD_FLOOR
	ld [wPikaMood], a
	ret

ApplyStarterPikachuMood::
; c = the HAPPINESS_* reason ChangeHappiness was called with; it applies to
; wCurPartyMon.  Yellow's ModifyPikachuHappiness tail
; (vendor/pokeyellow/engine/events/pikachu_happiness.asm:57-87): a raising
; target only raises and is suppressed while an emotion modifier is pending; a
; lowering target only lowers; 128 means "no change".
	ld a, [wCurPartyMon]
	push bc
	ld c, a
	farcall IsStarterPikachuInSlot
	pop bc
	ret nc
	ld a, c
	and a
	ret z
	dec a
	cp NUM_HAPPINESS_CHANGES
	ret nc
	ld c, a
	ld b, 0
	ld hl, PikachuMoods
	add hl, bc
	ld b, [hl]
	ld a, b
	cp PIKACHU_NEUTRAL_MOOD
	ret z
	ld a, [wPikaMood]
	jr c, .lowering
	cp b
	ret nc
	call GetPikachuEmotionModifier
	and a
	ret nz
	jr .update

.lowering
	cp b
	ret c

.update
	ld a, b
	ld [wPikaMood], a
	ret

PikachuMoods:
; Yellow's PikachuMoods (pikachu_happiness.asm:105) re-indexed onto Crystal's
; 19 HAPPINESS_* reasons.  $80 = leave the mood alone, which is what every row
; Yellow does not have gets.  (Yellow's PIKAHAPPY_DEPOSITED $62 and
; PIKAHAPPY_TRADE $00 have no Crystal reason: Crystal changes no happiness on
; deposit, and the starter cannot be traded -- docs/FOLLOWER.md.)
	table_width 1, PikachuMoods
	db $8a ; Gained a level            (Yellow PIKAHAPPY_LEVELUP)
	db $83 ; Vitamin                   (Yellow PIKAHAPPY_USEDITEM)
	db $80 ; X Item                    (Yellow PIKAHAPPY_USEDXITEM)
	db $80 ; Battled a Gym Leader      (Yellow PIKAHAPPY_GYMLEADER)
	db $94 ; Learned a move            (Yellow PIKAHAPPY_USEDTMHM)
	db $6c ; Lost to an enemy          (Yellow PIKAHAPPY_FAINTED)
	db $62 ; Fainted due to poison     (Yellow PIKAHAPPY_PSNFNT)
	db $6c ; Lost to a stronger enemy  (Yellow PIKAHAPPY_CARELESSTRAINER)
	db $80 ; Haircut (older) 1
	db $80 ; Haircut (older) 2
	db $80 ; Haircut (older) 3
	db $80 ; Haircut (younger) 1
	db $80 ; Haircut (younger) 2
	db $80 ; Haircut (younger) 3
	db $80 ; Heal Powder / EnergyPowder
	db $80 ; Energy Root
	db $80 ; Revival Herb
	db $80 ; Grooming
	db $8a ; Gained a level where caught
	assert_table_length NUM_HAPPINESS_CHANGES

PikachuCaughtMonMood::
; A3 row 4 (vendor/pokeyellow/engine/items/item_effects.asm:563-567).
	ld bc, 1 << 8 | $85
	jp SetPikachuMoodAndModifier

PikachuUsedRodMood::
; A3 row 5 (vendor/pokeyellow/engine/items/item_effects.asm:2125-2129).
	ld bc, 2 << 8 | $81
	jp SetPikachuMoodAndModifier

PikachuRefusedStoneMood::
; A3 row 6 (vendor/pokeyellow/engine/items/item_effects.asm:820-824).  Our
; refusal is EvoStoneEffect's "won't have any effect" path, which non-starter
; mons also reach, hence the starter check Yellow gets for free.
	ld a, [wCurPartyMon]
	ld c, a
	farcall IsStarterPikachuInSlot
	ret nc
	ld bc, 4 << 8 | $82
	jp SetPikachuMoodAndModifier

PikachuLearnedMoveMood::
; A3 row 7 (vendor/pokeyellow/engine/pokemon/evos_moves.asm:374-377 and
; item_effects.asm:2508-2512).  Yellow hooks the level-up learner and the TM
; separately; one hook at the end of Crystal's LearnMove covers both, plus the
; move tutor.  M4 7a moved THUNDERBOLT to TM86, so this keys off the move id.
	ld a, [wPutativeTMHMMove]
	cp THUNDERBOLT
	jr z, .thunder
	cp THUNDER
	ret nz

.thunder
	ld a, [wCurPartyMon]
	ld c, a
	farcall IsStarterPikachuInSlot
	ret nc
	ld bc, 5 << 8 | $85
	jp SetPikachuMoodAndModifier
