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
