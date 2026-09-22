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
	jp z, .hide

; Yellow: Pikachu only follows while the starter is in the party with HP
; left (deposited / fainted -> it waits, hidden, on the player's tile).
	push bc
	call IsStarterPikachuAliveInParty
	pop bc
	jr nc, .hide

; J3 (docs/JIGGLYPUFF.md): the Pewter JIGGLYPUFF SONG put Pikachu to sleep.
; Yellow's wPikachuOverworldStateFlags bit 1 makes SpawnPikachu_ take its
; "stand still" branch, so Pikachu simply stays on the tile it was on until it
; is woken or a map loads.  .idle is that branch for us: it stands the object
; without snapping it to the player, and only touches visibility (invisible
; iff the player is standing on it -- Pikachu can still be walked through).
	ld a, [wPikaAsleep]
	and a
	jp nz, .idle

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
; F5: a script is holding Pikachu off-screen (the healing machine).  This runs
; every frame of every script pause, so without the bit it would undo the hide
; the moment the follower's coords stopped matching the player's.
	bit FOLLOWER_SCRIPTHIDE_F, a
	ret nz
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
	ld d, a
	ld a, [wPlayerMapY]
	ld e, a
FollowerSnapToTile:
; Same, onto an arbitrary map tile d (x), e (y).  Clobbers a, hl; keeps bc.
	ld a, d
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

	ld a, e
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

	ld hl, wPikaFollowFlags
	res FOLLOWER_SCRIPTHIDE_F, [hl] ; never let a half-run script leave it set
; J3: Yellow's SchedulePikachuSpawnForAfterText calls
; EnablePikachuFollowingPlayer on every normal map load, so the Jigglypuff
; sleep can never outlive the map.  Clear it before the ENABLED early return
; so it is gone even when the follower feature is off.
	xor a
	ld [wPikaAsleep], a
; 7f: same deal for the FAN CLUB scene's "already played this visit" byte.
; Yellow clears BIT_PIKACHU_MAP_SCRIPT_ACTIVE from VERMILION_CITY's map script
; -- the only map the club opens onto -- so clearing it on every map load is
; the same thing, one map earlier.
	ld [wPikaFanClubSceneDone], a
	bit FOLLOWER_ENABLED_F, [hl]
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
; Playtest fix (2026-09-18): give the object its VRAM tile NOW.  The per-frame
; refresh in MovementFunction_PikaFollower only runs inside HandleObjectStep,
; and a script that spawns Pikachu visible and goes straight into text (Oak's
; Lab) never steps objects before the first draw -- the tile stayed 0 and
; Pikachu was drawn with the player's tiles.  AddFollowerSprite always puts
; the follower at FOLLOWER_VTILE, so this is what GetSpriteVTile would return.
	ld hl, OBJECT_SPRITE_TILE
	add hl, de
	ld [hl], FOLLOWER_VTILE

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
; Talking to Pikachu.  F3: Yellow's real 2-D mood x happiness emotion system
; (engine/pikachu/emotions.asm, docs/PIKACHU-EMOTIONS.md).
	callasm TalkToPikachu
	end

FollowerEmotionFrame::
; One "unit" of an emotion animation, farcall'd from the emotion interpreter in
; bank $3f.  Deliberately NOT HandleObjectStep: that runs the follower's own
; step function, and MovementFunction_PikaFollower forces OBJECT_ACTION_STAND
; on every idle frame, which would cancel the hop's walk cycle.
; HandleObjectAction alone turns OBJECT_DIRECTION + OBJECT_ACTION into
; OBJECT_FACING, which is all an in-place emotion needs.  Two DelayFrames,
; because one of Yellow's ExecutePikachuMovementCommand iterations is two frames.
	ld a, FOLLOWER_OBJECT
	ldh [hMapObjectIndex], a
	ld bc, wFollowerStruct
	call HandleObjectAction
	call UpdateSprites
	call DelayFrame
	jp DelayFrame

FollowerFacePlayer::
	ld a, [wPlayerDirection]
	and %00001100
	xor %00000100 ; DOWN <-> UP, LEFT <-> RIGHT
	ld [wFollowerDirection], a
	ld a, FOLLOWER_OBJECT
	ldh [hMapObjectIndex], a
	ld bc, wFollowerStruct
	call HandleObjectStep ; refresh OBJECT_FACING now
	jp UpdateSprites

FollowerSpawnEmote::
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

FollowerDespawnEmote::
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

SpawnFollowerVisible::
; Special.  F2, docs/FOLLOWER-FIXES.md section 2: like EnablePikaFollower, but
; Pikachu is *already standing* on the tile behind the player and facing it, so
; a script can talk about it before the player has taken a step (Oak's Lab).
; This is Yellow's spawn state $2: CalculatePikachuPlacementCoords's
; .check_player_facing2 (vendor/pokeyellow/engine/pikachu/pikachu_follow.asm:52-185)
; subtracts the player's facing vector -- facing UP puts Pikachu one tile below --
; and both facing paths that spawn state $2 can take (the copy-player branch of
; SchedulePikachuSpawnForAfterText, and ComputePikachuFacingDirection's .check_y
; at :1389) end up facing Pikachu straight back at the player, which for a tile
; directly behind is the player's own facing byte.
	call EnablePikaFollower
	ld a, [wPikaFollowFlags]
	bit FOLLOWER_ENABLED_F, a
	ret z

	ld bc, wFollowerStruct

; Face the player (see above: same byte as the player's own facing).
	ld a, [wPlayerDirection]
	and %00001100
	ld hl, OBJECT_DIRECTION
	add hl, bc
	ld [hl], a
	push af

; d, e = the tile behind the player.
	ld a, [wPlayerMapX]
	ld d, a
	ld a, [wPlayerMapY]
	ld e, a
	pop af
	cp OW_DOWN
	jr z, .behind_is_up
	cp OW_UP
	jr z, .behind_is_down
	cp OW_LEFT
	jr z, .behind_is_right
	dec d ; facing RIGHT
	jr .place
.behind_is_right
	inc d
	jr .place
.behind_is_up
	dec e
	jr .place
.behind_is_down
	inc e
.place
; Guard: an impassable or occupied tile falls back to the invisible spawn
; SpawnFollower already left us with (walks out on the first step as usual).
	push de
	call FollowerCanStandAt
	pop de
	ld bc, wFollowerStruct
	ret nc

	call FollowerSnapToTile
	ld hl, OBJECT_FLAGS1
	add hl, bc
	res INVISIBLE_F, [hl]
	ret

FollowerCanStandAt:
; d = map x, e = map y.  Carry if the follower may be placed there: plain land,
; and no other object standing on it.  Clobbers a, bc, hl; keeps de.
	push de
	call GetCoordTileCollision
	call GetTilePermission
	pop de
	and a ; LAND_TILE
	jr nz, .no
	ld bc, wObjectStructs
	xor a
	ldh [hMapObjectIndex], a
	call IsNPCAtCoord
	jr c, .no
	scf
	ret
.no
	and a
	ret

; --- F5 / F6: the Pokemon Center counter hop.  Design, and every measurement
; behind it, in docs/PIKACHU-EMOTIONS.md Part B; port notes in
; docs/FOLLOWER-FIXES.md.  Yellow: engine/events/pokecenter.asm.

FollowerHopToCounter::
; Special.  Yellow's `callfar PikachuWalksToNurseJoy`: Pikachu hops from the
; tile behind the player onto the counter tile the player is facing.
; Inert unless the follower is out and the faced tile really is a counter, so
; the shared PokecenterNurseScript behaves exactly as before everywhere else.
	ld a, [wPikaFollowFlags]
	bit FOLLOWER_ENABLED_F, a
	ret z
	call IsStarterPikachuAliveInParty
	ret nc
	call GetFacingTileCoord ; d, e = the faced tile; a = its collision
	call CheckCounterTile
	ret nz
; F6b.  Yellow picks its movement table from the side Pikachu is standing on,
; never from the player's facing (pikachu_emotions.asm .GetMovementData):
; trailing below or to the left it arrives from the left ($2b slide up-left then
; $34 hop up-right, or a bare $34), trailing to the RIGHT it arrives from the
; right ($33 hop up-left).  We only have one vertical jump, so the side lives in
; the sprite arc: remember which way to swing before the snap throws the
; follower's own x away.  d = the counter column = the player's column.
	ld hl, wPikaFollowFlags
	res FOLLOWER_HOPRIGHT_F, [hl]
	ld a, [wFollowerStruct + OBJECT_MAP_X]
	cp d
	jr c, .swing_left
	jr z, .swing_left
	set FOLLOWER_HOPRIGHT_F, [hl]
.swing_left
; A jump always covers exactly two tiles (StepFunction_NPCJump does one
; AddStepVector per phase), so it has to start two tiles below the landing
; tile -- which is exactly where the follower is standing after the player
; walks up to the counter.  Snap rather than test: it is a no-op when the
; follower is already there, and it fixes up LAST_MAP/INIT/SPRITE together
; for the rare sideways approach.  NOT FollowerCanStandAt -- the counter is a
; WALL_TILE and would be refused; no step function consults permissions.
	inc e
	inc e
	ld bc, wFollowerStruct
	call FollowerSnapToTile
	ld hl, OBJECT_FLAGS1
	add hl, bc
	res INVISIBLE_F, [hl]
	call FollowerJumpUp

; Animate it here and now.  Script `pause` is a blocking DelayFrames loop
; (Script_pause, engine/overworld/scripting.asm) and every text command blocks
; too, so HandleMap -- and with it HandleObjectStep -- does not run again until
; the whole nurse script has ended.  Measured: parked before the existing
; `pause 20`, the jump advanced two frames in 550.  Yellow's
; PikachuWalksToNurseJoy is a blocking routine for exactly the same reason.
; The jump needs 16 frames; the cap is only so a follower that HandleObjectStep
; refuses to tick (CheckObjectStillVisible's `ret c`) can never hang the script.
; Bailing out is harmless -- the overworld loop finishes the jump afterwards.
	ld d, 32
.animate
	push de
	ld a, FOLLOWER_OBJECT
	ldh [hMapObjectIndex], a
	ld bc, wFollowerStruct
	call HandleObjectStep
	call UpdateSprites
	call DelayFrame
	pop de
	ld a, [wFollowerStepType]
	cp STEP_TYPE_FOLLOWER_JUMP
	ret nz
	dec d
	jr nz, .animate
	ret

FollowerJumpUp:
; JumpStep (engine/overworld/movement.asm) minus SpawnShadow -- Yellow's counter
; hop throws no shadow -- and into our own step type, which adds the X arc.
; bc = wFollowerStruct.
	call ObjectStep_ZeroAnonJumptableIndex ; StepFunction_FromMovement usually
	ld a, STEP_WALK << 2 | UP              ; does this for us; we are a special
	call InitStep
	ld hl, OBJECT_JUMP_HEIGHT
	add hl, bc
	ld [hl], 0
	ld hl, OBJECT_FLAGS2
	add hl, bc
	res IN_GRASS_F, [hl]
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], OBJECT_ACTION_STEP
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld [hl], STEP_TYPE_FOLLOWER_JUMP
	ret

StepFunction_FollowerJump:
; StepTypesJumptable $1a.  A plain NPC jump plus a sideways bulge, so the two
; orthogonal tiles read as Yellow's diagonal hop *around* the player instead of
; a leap over his head: Yellow's Pikachu stands to the player's left and hops
; up-right, ours stands below him and swings out left before cutting back up
; and right onto the counter.  StepVectors has no diagonal entry, so the
; displacement is cosmetic (OBJECT_SPRITE_X_OFFSET) and the map coords still
; land dead on the counter tile, which is what the walk-off depends on.
	call .Arc ; before the jump code: UpdateJumpPosition bumps JUMP_HEIGHT
	call StepFunction_NPCJump
; .Land hands the object back to STEP_TYPE_FROM_MOVEMENT on the last frame.
	ld hl, OBJECT_STEP_TYPE
	add hl, bc
	ld a, [hl]
	cp STEP_TYPE_FOLLOWER_JUMP
	ret z
	xor a
	ld hl, OBJECT_SPRITE_X_OFFSET
	add hl, bc
	ld [hl], a
	ret

.Arc:
; OBJECT_JUMP_HEIGHT counts up by the speed nybble (2 at STEP_WALK), so it is
; 0, 2, 4 .. 30 across the 16 frames of the two phases -- the same index
; UpdateJumpPosition uses for its Y arc.
	ld hl, OBJECT_JUMP_HEIGHT
	add hl, bc
	ld a, [hl]
	srl a
	cp .x_offsets_end - .x_offsets
	ret nc
	ld e, a
	ld d, 0
	ld hl, .x_offsets
	add hl, de
	ld a, [hl]
; F6b: one table, mirrored for a follower that was standing to the player's
; right, so the hop swings out on the side Yellow's Pikachu would have come from.
	ld hl, wPikaFollowFlags
	bit FOLLOWER_HOPRIGHT_F, [hl]
	jr z, .signed
	cpl
	inc a
.signed
	ld hl, OBJECT_SPRITE_X_OFFSET
	add hl, bc
	ld [hl], a
	ret

.x_offsets:
	db   0,  -4,  -8, -11, -13, -14, -14, -13
	db -11,  -9,  -7,  -5,  -3,  -2,  -1,   0
.x_offsets_end:

FollowerHide::
; Special.  Yellow's DisablePikachuOverworldSpriteDrawing: take Pikachu off
; screen for the healing-machine animation.  HealMachineAnim writes the balls
; straight into wShadowOAMSprite32 and nothing reserves those structs, so the
; OAM rebuild has to happen HERE, before the balls exist -- nothing else
; redraws between this and `special HealMachineAnim`.
	ld hl, wPikaFollowFlags
	bit FOLLOWER_ENABLED_F, [hl]
	ret z
	set FOLLOWER_SCRIPTHIDE_F, [hl]
	ld hl, wFollowerStruct + OBJECT_FLAGS1
	set INVISIBLE_F, [hl]
	jp UpdateSprites

FollowerShow::
; Special.  Yellow's wPikachuSpawnState = 5 + EnablePikachuOverworldSpriteDrawing.
; Pikachu is still standing on the counter tile, so dropping the suppress bit is
; all it takes: .UpdateVisibility sees coords that differ from the player's and
; brings it back there, and the next step the player takes walks it off the
; counter onto the tile they vacate (exactly Yellow's measured walk-off).
	ld hl, wPikaFollowFlags
	res FOLLOWER_SCRIPTHIDE_F, [hl]
	res FOLLOWER_HOPRIGHT_F, [hl] ; the hop is over; leave the saved byte clean
; Only bring the sprite back if it was ours to hide: a disabled follower, or one
; another system is holding hidden (FOLLOWER_HIDDEN_F), must stay invisible --
; clearing INVISIBLE_F unconditionally would pop Pikachu onto the counter in a
; save where the feature is off.
	ld a, [hl]
	and 1 << FOLLOWER_ENABLED_F | 1 << FOLLOWER_HIDDEN_F
	cp 1 << FOLLOWER_ENABLED_F
	ret nz
	ld hl, wFollowerStruct + OBJECT_FLAGS1
	res INVISIBLE_F, [hl]
	jp UpdateSprites ; scripts block, so redraw now or it reappears late

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


; --- 7f: the POKeMON FAN CLUB Pikachu scene (docs/M4-VERMILION.md).
; Yellow: PokemonFanClubScript_59a44 + PokemonFanClubPikachuMovementData
; (vendor/pokeyellow/scripts/PokemonFanClub.asm:44).  Guards, bubble and face
; box live with the emotion engine (engine/pikachu/emotions.asm); this is the
; walk, which needs NormalStep and the object structs.

; Object structs carry map coordinates offset by 4 (CheckCurrentMapCoordEvents
; subtracts it again), so the Fan Club's tiles are written the same way here.
DEF FANCLUB_PIKACHU_X   EQU 7 + 4 ; the CLEFAIRY's column, Yellow's x=6
DEF FANCLUB_PIKACHU_ROW EQU 6 + 4 ; the aisle in front of the two doors
DEF FANCLUB_PIKACHU_Y   EQU 5 + 4 ; the landing tile, directly below the CLEFAIRY

FanClubPikachuWalk::
; Yellow's movement blob is `$26 $20 $20 $20 $1e`: slide up one, three steps
; right, one step up, from the door tile Pikachu is standing on.  Ours walks
; the same L a tile at a time instead of from a fixed list -- our room is two
; tiles wider than Yellow's and either door may be the one the player came
; through -- and the $26 slide is a plain walk, because our movement
; mini-interpreter only has Yellow's four in-place opcodes
; (constants/pikachu_emotion_constants.asm).
	ld bc, wFollowerStruct
	ld hl, OBJECT_FLAGS1
	add hl, bc
	res INVISIBLE_F, [hl]
.up_to_aisle
	ld a, [wFollowerMapY]
	cp FANCLUB_PIKACHU_ROW
	jr c, .rightward
	jr z, .rightward
	ld d, UP
	call FanClubPikachuStep
	jr c, .up_to_aisle
	jr .park
.rightward
	ld a, [wFollowerMapX]
	cp FANCLUB_PIKACHU_X
	jr nc, .up_to_clefairy
	ld d, RIGHT
	call FanClubPikachuStep
	jr c, .rightward
	jr .park
.up_to_clefairy
	ld a, [wFollowerMapY]
	cp FANCLUB_PIKACHU_Y
	jr c, .park
	jr z, .park
	ld d, UP
	call FanClubPikachuStep
	jr c, .up_to_clefairy
.park
; Yellow's DisablePikachuFollowingPlayer.  That is the same bit as the Pewter
; JIGGLYPUFF sleep in Yellow (home/pikachu.asm:47 is one `bit 1`), so it is our
; wPikaAsleep: Pikachu stands still and is walk-through until the player talks
; to it (emotion 30's CHECKLAVENDERTOWER subcommand clears it again) or the map
; reloads.
	ld a, TRUE
	ld [wPikaAsleep], a
	ret

FanClubPikachuStep:
; d = DOWN, UP, LEFT or RIGHT.  Walks the follower one tile, blocking until the
; step is finished the way FollowerHopToCounter animates its hop (a running
; script stops HandleMap, so nothing else would tick the object).  Carry if it
; moved.  (7f only needed UP/RIGHT; 12n's CINNABAR GYM step-aside adds DOWN and
; LEFT.)
	push de
	ld a, [wFollowerMapX]
	ld b, a
	ld a, [wFollowerMapY]
	ld c, a
	ld a, d
	and a ; DOWN
	jr nz, .not_down
	inc c
	jr .target
.not_down
	cp UP
	jr nz, .not_up
	dec c
	jr .target
.not_up
	cp LEFT
	jr nz, .rightward
	dec b
	jr .target
.rightward
	inc b
.target
	ld d, b
	ld e, c
	call FollowerCanStandAt
	pop de
	ret nc

	push de
	ld a, FOLLOWER_OBJECT
	ldh [hMapObjectIndex], a
	ld bc, wFollowerStruct
	call ObjectStep_ZeroAnonJumptableIndex
	pop de
	ld bc, wFollowerStruct
	ld a, STEP_WALK << 2
	or d
	call NormalStep

; The cap only exists so a follower HandleObjectStep refuses to tick can never
; hang the script; a walk at STEP_WALK is 16 frames.
	ld b, 40
.animate
	push bc
	ld a, FOLLOWER_OBJECT
	ldh [hMapObjectIndex], a
	ld bc, wFollowerStruct
	call HandleObjectStep
	call UpdateSprites
	call DelayFrame
	pop bc
	ld a, [wFollowerStepType]
	cp STEP_TYPE_NPC_WALK
	jr nz, .done
	dec b
	jr nz, .animate
.done
	scf
	ret


; --- 12n: CINNABAR GYM, a wrong quiz answer (docs/M9-CINNABAR.md 12n).
CinnabarGymPikachuStepAside::
; Special.  Yellow's CinnabarGymScript_74fa3 (vendor/pokeyellow/scripts/
; CinnabarGym.asm): just before the gate's trainer walks over to the player,
; Pikachu steps out of the tile the trainer is about to take -- but only when
; it is standing on that side of the player (GetPikachuFacingDirection, which
; compares the Y coordinates first and the X coordinates only on a tie).
;   wScriptVar 0: the gate-2 SUPER NERD, who arrives from BELOW.  If Pikachu
;     is below the player it does Yellow's $20 $1e $35 -- step right, step up,
;     look down.
;   wScriptVar 1: every other gate trainer, who arrives from the RIGHT.  If
;     Pikachu is to the player's right it does $1d $1f $38 -- step down, step
;     left, look right.
; A step onto a wall or an NPC is refused (FollowerCanStandAt) and the rest of
; the dance is skipped, rather than walking Pikachu into the scenery.
	ld a, [wPikaFollowFlags]
	and 1 << FOLLOWER_ENABLED_F | 1 << FOLLOWER_HIDDEN_F | 1 << FOLLOWER_SCRIPTHIDE_F
	cp 1 << FOLLOWER_ENABLED_F
	ret nz
	ld a, [wFollowerFlags] ; OBJECT_FLAGS1
	bit INVISIBLE_F, a
	ret nz
	ld a, [wPlayerMapY]
	ld b, a
	ld a, [wScriptVar]
	and a
	jr nz, .from_right
; from below: Yellow's SPRITE_FACING_DOWN = Pikachu's Y is greater
	ld a, [wFollowerMapY]
	cp b
	ret z
	ret c
	ld d, RIGHT
	call FanClubPikachuStep
	ret nc
	ld d, UP
	call FanClubPikachuStep
	ret nc
	ld a, OW_DOWN
	jr .face

.from_right
; SPRITE_FACING_RIGHT = same Y, Pikachu's X is greater
	ld a, [wFollowerMapY]
	cp b
	ret nz
	ld a, [wPlayerMapX]
	ld b, a
	ld a, [wFollowerMapX]
	cp b
	ret z
	ret c
	ld d, DOWN
	call FanClubPikachuStep
	ret nc
	ld d, LEFT
	call FanClubPikachuStep
	ret nc
	ld a, OW_RIGHT
.face
	ld [wFollowerDirection], a
	ld a, FOLLOWER_OBJECT
	ldh [hMapObjectIndex], a
	ld bc, wFollowerStruct
	call HandleObjectStep ; refresh OBJECT_FACING now
	jp UpdateSprites
