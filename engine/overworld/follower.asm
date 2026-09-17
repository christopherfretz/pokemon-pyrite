; Pikachu follower (docs/FOLLOWER.md).
; INCLUDEd from map_objects.asm so it shares that bank with NormalStep /
; JumpStep / the movement-function jumptable.

MovementFunction_PikaFollower:
; bc = wFollowerStruct. Runs every frame the follower is between steps.
; Keep the VRAM tile current: wUsedSprites is rebuilt on every map load.
	ld a, SPRITE_PIKACHU_FOLLOWER
	call GetSpriteVTile
	ld hl, OBJECT_SPRITE_TILE
	add hl, bc
	ld [hl], a

	ld a, [wPikaFollowFlags]
	bit FOLLOWER_ENABLED_F, a
	jr z, .hide

; Yellow: Pikachu only follows while the starter is in the party with HP
; left (deposited / fainted -> it waits, hidden, on the player's tile).
	push bc
	call IsStarterPikachuAliveInParty
	pop bc
	jr nc, .hide

; Bike / surf / anything but plain walking: ride along hidden on the
; player's tile so we re-emerge behind them on the first step afterwards.
	ld a, [wPlayerState]
	cp PLAYER_NORMAL
	jr nz, .hide

; Only move while the player is mid-step; the target is the tile they are
; leaving (their OBJECT_LAST_MAP_X/Y).
	ld a, [wPlayerWalking]
	cp STANDING
	jr z, .idle

	ld a, [wPlayerLastMapX]
	ld hl, OBJECT_MAP_X
	add hl, bc
	sub [hl]
	ld d, a ; dx
	ld a, [wPlayerLastMapY]
	ld hl, OBJECT_MAP_Y
	add hl, bc
	sub [hl]
	ld e, a ; dy
	or d
	jr z, .idle

	ld a, d
	and a
	jr z, .vertical
	ld a, e
	and a
	jr nz, .snap ; diagonal
	ld a, d
	cp 1
	jr z, .right
	cp -1
	jr z, .left
	jr .snap

.vertical
	ld a, e
	cp 1
	jr z, .down
	cp -1
	jr z, .up
	jr .snap

.down
	ld a, DOWN
	jr .step
.up
	ld a, UP
	jr .step
.left
	ld a, LEFT
	jr .step
.right
	ld a, RIGHT
.step
	ld d, a
; Ledge: the player is in the second half of a jump, so the tile they are
; "leaving" is the ledge itself. Hop two tiles at walking speed.
	ld a, [wPlayerStepType]
	cp STEP_TYPE_PLAYER_JUMP
	jr nz, .walk
	ld a, [wPlayerStepIndex]
	cp 2
	jr c, .walk
	call .Show
	ld a, STEP_WALK << 2
	or d
	jp JumpStep

.walk
	call .Show
; Match the player's speed nybble (slow / walk / bike).
	ld a, [wPlayerWalking]
	and %00001100
	or d
	jp NormalStep

.idle
	call .UpdateVisibility
	jr .stand

.hide
	ld hl, OBJECT_FLAGS1
	add hl, bc
	set INVISIBLE_F, [hl]
.snap
	call FollowerSnapToPlayer
	call .UpdateVisibility
.stand
	ld hl, OBJECT_WALKING
	add hl, bc
	ld [hl], STANDING
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], OBJECT_ACTION_STAND
	ret

.Show:
	ld hl, OBJECT_FLAGS1
	add hl, bc
	res INVISIBLE_F, [hl]
	ret

.UpdateVisibility:
; Invisible iff sharing the player's tile (or the feature is off).
	ld hl, OBJECT_FLAGS1
	add hl, bc
	set INVISIBLE_F, [hl]
	ld a, [wPikaFollowFlags]
	bit FOLLOWER_ENABLED_F, a
	ret z
	ld a, [wPlayerMapX]
	ld hl, OBJECT_MAP_X
	add hl, bc
	cp [hl]
	jr nz, .visible
	ld a, [wPlayerMapY]
	ld hl, OBJECT_MAP_Y
	add hl, bc
	cp [hl]
	ret z
.visible
	ld hl, OBJECT_FLAGS1
	add hl, bc
	res INVISIBLE_F, [hl]
	ret

FollowerSnapToPlayer:
; Put the follower (bc) on the player's current tile and recompute its
; screen position from map coords (same formula as CopyTempObjectToObjectStruct).
	ld a, [wPlayerMapX]
	ld hl, OBJECT_MAP_X
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_LAST_MAP_X
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_INIT_X
	add hl, bc
	ld [hl], a
	ld hl, wXCoord
	sub [hl]
	and $f
	swap a
	ld hl, wPlayerBGMapOffsetX
	sub [hl]
	ld hl, OBJECT_SPRITE_X
	add hl, bc
	ld [hl], a

	ld a, [wPlayerMapY]
	ld hl, OBJECT_MAP_Y
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_LAST_MAP_Y
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_INIT_Y
	add hl, bc
	ld [hl], a
	ld hl, wYCoord
	sub [hl]
	and $f
	swap a
	ld hl, wPlayerBGMapOffsetY
	sub [hl]
	ld hl, OBJECT_SPRITE_Y
	add hl, bc
	ld [hl], a

	xor a
	ld hl, OBJECT_SPRITE_Y_OFFSET
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_FLAGS2
	add hl, bc
	res IN_GRASS_F, [hl]
	ret

SpawnFollower:
; Map setup command. (Re)creates the follower object on the player's tile,
; hidden; it walks out behind the player on their first step.
	ld hl, wFollowerStruct
	ld bc, OBJECT_LENGTH
	xor a
	call ByteFill

	ld a, [wPikaFollowFlags]
	bit FOLLOWER_ENABLED_F, a
	ret z

	ld de, wFollowerStruct
	ld a, SPRITEMOVEDATA_PIKA_FOLLOWER
	call CopySpriteMovementData

	ld hl, OBJECT_SPRITE
	add hl, de
	ld [hl], SPRITE_PIKACHU_FOLLOWER
	ld hl, OBJECT_MAP_OBJECT_INDEX
	add hl, de
	ld [hl], -1

	ld a, SPRITE_PIKACHU_FOLLOWER
	call GetSpritePalette
	ld hl, OBJECT_PALETTE
	add hl, de
	or [hl]
	ld [hl], a

	ld hl, OBJECT_STEP_TYPE
	add hl, de
	ld [hl], STEP_TYPE_RESET
	ld hl, OBJECT_FACING
	add hl, de
	ld [hl], STANDING
	ld hl, OBJECT_FLAGS1
	add hl, de
	set INVISIBLE_F, [hl]
	set WONT_DELETE_F, [hl]

	ld b, d
	ld c, e
	jp FollowerSnapToPlayer

CheckFacingFollower::
; Returns carry if the player is facing the (visible, standing) follower.
	ld a, [wPikaFollowFlags]
	bit FOLLOWER_ENABLED_F, a
	jr z, .no
	ld a, [wFollowerFlags] ; OBJECT_FLAGS1
	bit INVISIBLE_F, a
	jr nz, .no
	ld a, [wFollowerWalking]
	cp STANDING
	jr nz, .no
	call GetFacingTileCoord
	ld a, [wFollowerMapX]
	cp d
	jr nz, .no
	ld a, [wFollowerMapY]
	cp e
	jr nz, .no
	scf
	ret
.no
	and a
	ret

PikachuFollowerScript::
; Talking to Pikachu (Yellow: it turns, cries and shows how it feels).
; Happiness-dependent emotions come later; always happy for now.
	callasm FollowerFacePlayer
	loademote EMOTE_HAPPY
	callasm FollowerSpawnEmote
	cry PIKACHU
	pause 20
	callasm FollowerDespawnEmote
	end

FollowerFacePlayer:
	ld a, [wPlayerDirection]
	and %00001100
	xor %00000100 ; DOWN <-> UP, LEFT <-> RIGHT
	ld [wFollowerDirection], a
	ld a, FOLLOWER_OBJECT
	ldh [hMapObjectIndex], a
	ld bc, wFollowerStruct
	call HandleObjectStep ; refresh OBJECT_FACING now
	jp UpdateSprites

FollowerSpawnEmote:
; Emote objects remember their parent's struct index in hMapObjectIndex.
; Script `pause`/`cry` only delay frames, so give the new emote object its
; first step here (MovementFunction_Emote sets it up) and redraw sprites.
	ld a, FOLLOWER_OBJECT
	ldh [hMapObjectIndex], a
	ld bc, wFollowerStruct
	call SpawnEmote
	call .FindEmote
	ret nc
	ldh [hMapObjectIndex], a
	call HandleObjectStep
	jp UpdateSprites

.FindEmote:
; Returns carry, a = index, bc = struct of the emote whose parent is the follower.
	ld bc, wObject1Struct
	ld a, 1
.loop
	ld hl, OBJECT_FLAGS1
	add hl, bc
	bit EMOTE_OBJECT_F, [hl]
	jr z, .next
	ld hl, OBJECT_RANGE
	add hl, bc
	ld l, [hl]
	ld h, a
	ld a, l
	cp FOLLOWER_OBJECT
	ld a, h
	jr nz, .next
	scf
	ret
.next
	ld hl, OBJECT_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	inc a
	cp FOLLOWER_OBJECT
	jr nz, .loop
	and a
	ret

FollowerDespawnEmote:
	ld a, FOLLOWER_OBJECT
	ldh [hMapObjectIndex], a
	call DespawnEmote
	jp UpdateSprites

IsStarterPikachuInSlot::
; c = party slot (not a: farcall hands the callee its bank in a). Returns
; carry if that mon is the starter Pikachu: species PIKACHU with the player's
; OT ID (Yellow's IsThisPartyMonStarterPikachu). Preserves de. Clobbers a, bc, hl.
	ld a, c
	ld hl, wPartyMon1Species
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld a, [hl]
	cp PIKACHU
	jr nz, .no
	ld bc, MON_OT_ID
	add hl, bc
	ld a, [wPlayerID]
	cp [hl]
	jr nz, .no
	inc hl
	ld a, [wPlayerID + 1]
	cp [hl]
	jr nz, .no
	scf
	ret
.no
	and a
	ret

IsStarterPikachuAliveInParty::
; Returns carry if the starter Pikachu is in the party with HP > 0.
; Clobbers a, bc, de, hl.
	ld a, [wPartyCount]
	and a
	ret z
	ld e, a
	ld d, 0
.loop
	ld c, d
	call IsStarterPikachuInSlot ; preserves de
	jr nc, .next
	ld bc, MON_HP - MON_OT_ID - 1
	add hl, bc
	ld a, [hli]
	or [hl]
	jr z, .next ; fainted
	scf
	ret
.next
	inc d
	dec e
	jr nz, .loop
	and a
	ret

EnablePikaFollower::
; Special. Turns the follower on mid-map (Oak's Lab, docs/M2-INTRO.md):
; sets the flag, reloads the used-sprite list so the follower's tiles are in
; VRAM (see AddFollowerSprite), and spawns the object on the player's tile.
	ld hl, wPikaFollowFlags
	set FOLLOWER_ENABLED_F, [hl]
	farcall RefreshSprites
	call SpawnFollower
	ret

GetStarterPikachuHappiness::
; Special. Returns the starter Pikachu's happiness byte in wScriptVar, or 0 if
; it is not in the party at all (Melanie's BULBASAUR gate, docs/M3-CERULEAN.md
; 6g). Yellow reads its dedicated wPikachuHappiness; our follower IS the starter
; party mon, so Crystal's MON_HAPPINESS is the same 0-255 number for the same
; Pokemon, and Yellow's >= 147 threshold carries over unchanged.
	xor a
	ld [wScriptVar], a
	ld a, [wPartyCount]
	and a
	ret z
	ld e, a
	ld d, 0
.loop
	ld c, d
	call IsStarterPikachuInSlot ; preserves de; hl = that mon's MON_OT_ID + 1
	jr nc, .next
	ld bc, MON_HAPPINESS - MON_OT_ID - 1
	add hl, bc
	ld a, [hl]
	ld [wScriptVar], a
	ret
.next
	inc d
	dec e
	jr nz, .loop
	ret
