; Trainer-Fly - Gen 1's "Mew glitch", reproduced as a deliberate Easter egg.
;
; Full spec, derivation and risk register: docs/TRAINER-FLY.md (Part C).
; Short version, from the player's side:
;
;   1. Step into the sight line of a trainer who spots you from far away
;      (>= TRAINERFLY_MIN_DISTANCE tiles) and press START on EXACTLY the frame
;      the step lands - before the "!" is drawn. The Start menu opens; the
;      sighting is swallowed and latched instead.
;   2. FLY / TELEPORT / ESCAPE ROPE out of there. The "!" plays over the
;      departure: that is the confirmation the arm took.
;   3. Battle anything; the last enemy mon's Sp.Atk is the payload.
;   4. Come back to the map you armed on. A wild battle starts with the species
;      that stat selects, at level TRAINERFLY_LEVEL.
;
; None of Gen 1's memory corruption is reproduced - the species is computed and
; bounds-checked (C.5), never aliased - so ROM/save integrity is not at stake.
; The trainer's event flag is never touched, so he is still fightable
; afterwards and the trick is repeatable, exactly as in Gen 1 (C.2 step 6).


; ---------------------------------------------------------------------------
; Knobs. These are the whole difficulty/flavour surface; nothing else needs a
; source edit to retune the mechanic.
; ---------------------------------------------------------------------------

; Species rule (docs/TRAINER-FLY.md C.3).
DEF TRAINERFLY_RULE_A EQU 0 ; RAW: Sp.Atk low byte used directly as a Gen 2 index
DEF TRAINERFLY_RULE_B EQU 1 ; GEN1-MAPPED: index it through Pokered_MonIndices

; Rule B is the default: it preserves every classic Gen 1 route with no trainer
; edits at all (L17 SLOWPOKE / L16 SHELLDER -> Sp.Atk 21 -> MEW), whereas raw
; Sp.Atk mathematically cannot reach 151 at pre-Misty levels (C.3's table).
DEF TRAINERFLY_RULE EQU TRAINERFLY_RULE_B

; How many frames the START press is accepted for, counted from the frame the
; sight check first succeeds. 1 = Gen 1's real window (A.2), and at 1 the
; countdown code below is not assembled at all. > 1 defers the sighting for up
; to that many frames while it waits for the press.
DEF TRAINERFLY_WINDOW_FRAMES EQU 1

; "Long-range trainer", in Crystal terms: wSeenTrainerDistance >= this (C.1).
; 3 covers ~203 of the 348 trainer objects in the game and reads as "spotted
; from across the room". 1 would mean "any trainer sighting at all".
DEF TRAINERFLY_MIN_DISTANCE EQU 3

; Gen 1 always produced a level 7 Mew, because the level it read was the enemy's
; attack stat-mod byte, which is 7 (A.6). Keep the number.
DEF TRAINERFLY_LEVEL EQU 7

; Highest valid Gen 1 index: Pokered_MonIndices is `assert_table_length
; NUM_POKEMON + 1` = 252 entries, 1-based (ConvertMon_1to2 does `dec a`).
DEF TRAINERFLY_MAX_GEN1_INDEX EQU NUM_POKEMON + 1

; wTrainerFlyPending states.
DEF TRAINERFLY_IDLE     EQU 0
DEF TRAINERFLY_ARMED    EQU 1 ; latched, still standing on the map that armed it
DEF TRAINERFLY_DEPARTED EQU 2 ; the player has left; fires on return


; ---------------------------------------------------------------------------
; The one-frame window.
; ---------------------------------------------------------------------------

TrainerFlyHook::
; Called from CheckTrainerEvent the instant CheckTrainerBattle has succeeded -
; hLastTalked / wSeenTrainerDistance / wSeenTrainerDirection are populated and
; PLAYEREVENT_SEENBYTRAINER has NOT been returned yet, so nothing is drawn: this
; is strictly before `showemote EMOTE_SHOCK` (C.2 step 1).
;
; hJoyPressed is edge-detected and was refreshed by GetJoypad earlier in this
; same frame (B.2), so `bit B_PAD_START` here is a genuine new press on exactly
; this frame.
;
; Returns (farcall preserves the whole f register):
;   carry      - armed; a script is queued, caller returns PLAYEREVENT_MAPSCRIPT
;   nc + z     - swallow this frame's sighting, queue nothing
;   nc + nz    - not ours; let the trainer engage normally
	ld a, [wSeenTrainerDistance]
	cp TRAINERFLY_MIN_DISTANCE
	jr c, .not_ours

IF TRAINERFLY_WINDOW_FRAMES > 1
; Open a fresh window the first time this sighting is seen.
	ld a, [wTrainerFlyWindow]
	and a
	jr nz, .window_open
	ld a, TRAINERFLY_WINDOW_FRAMES
	ld [wTrainerFlyWindow], a
.window_open
ENDC

	ldh a, [hJoyPressed]
	and PAD_START
	jr nz, .arm

IF TRAINERFLY_WINDOW_FRAMES > 1
; No press yet. Hold the sighting back for the rest of the window.
	ld hl, wTrainerFlyWindow
	dec [hl]
	jr z, .not_ours
	xor a ; nc, z: swallow
	ret
ENDC

.not_ours
IF TRAINERFLY_WINDOW_FRAMES > 1
	xor a
	ld [wTrainerFlyWindow], a
ENDC
	ld a, 1
	and a ; nc, nz
	ret

.arm
IF TRAINERFLY_WINDOW_FRAMES > 1
	xor a
	ld [wTrainerFlyWindow], a
ENDC
	ldh a, [hLastTalked]
	ld [wTrainerFlyObject], a
	ld a, [wMapGroup]
	ld [wTrainerFlyMapGroup], a
	ld a, [wMapNumber]
	ld [wTrainerFlyMapNumber], a
	ld a, TRAINERFLY_ARMED
	ld [wTrainerFlyPending], a

; Open the Start menu ourselves rather than leaving it to CheckMenuOW later in
; this frame. CheckMenuOW would see the same hJoyPressed bit, but only if
; PlayerMovement reports no action first - and if it did not, the sighting we
; just swallowed would vanish with nothing to show for it (risks #10/#11).
; This is OWPlayerInput.Action's own sequence, done here.
	farcall StopPlayerForEvent
	ld a, BANK(StartMenuScript)
	ld hl, StartMenuScript
	jp CallScript ; sets carry


; ---------------------------------------------------------------------------
; The state machine: leave the map, come back, get the encounter.
; ---------------------------------------------------------------------------

TrainerFlyCheckPending::
; Called at the head of CheckTrainerEvent, i.e. once per free overworld frame
; (PlayerEvents is short-circuited while any script runs, so this can never
; fire inside a battle, a cutscene or a link session - risk #7).
;
; Returns carry if a wild-battle script has been queued.
	ld a, [wTrainerFlyPending]
	and a
	ret z

	cp TRAINERFLY_ARMED
	jr nz, .departed

; Armed. Wait for the player to leave - by FLY, TELEPORT, ESCAPE ROPE, a door,
; a map connection, anything. Detecting it here rather than in each field move
; is what makes the mechanic engine-global.
	call TrainerFlyOnStoredMap
	jr z, .nothing
	ld a, TRAINERFLY_DEPARTED
	ld [wTrainerFlyPending], a

.nothing
	xor a
	ret

.departed
	call TrainerFlyOnStoredMap
	jr nz, .nothing

; Back where it started. Fire, then forget - win, lose or run, the state is
; already clear, so the encounter happens exactly once per arm.
	xor a
	ld [wTrainerFlyPending], a
	call TrainerFlyGetSpecies
	jr nc, .nothing ; out of bounds: abort silently (C.5). Gen 1 often did too.
	ld [wTrainerFlySpecies], a
	ld a, BANK(TrainerFlyBattleScript)
	ld hl, TrainerFlyBattleScript
	jp CallScript

TrainerFlyOnStoredMap:
; z if the player is on the map that armed the pending encounter.
	ld a, [wMapGroup]
	ld hl, wTrainerFlyMapGroup
	cp [hl]
	ret nz
	ld a, [wMapNumber]
	ld hl, wTrainerFlyMapNumber
	cp [hl]
	ret


; ---------------------------------------------------------------------------
; The payload: the last enemy mon's Sp.Atk (C.4).
; ---------------------------------------------------------------------------

TrainerFlyGetSpecies:
; ExitBattle / CleanUpBattleRAM do not clear wEnemyMon, so the stat survives the
; battle it came from (B.4); ClearBattleRAM wipes it at the START of the next
; battle, which is why this is read before `startbattle`.
;
; Returns carry + the species in a, or no carry if the index is unusable.
	ld a, [wEnemyMonSpclAtk + 1] ; low byte of a big-endian 16-bit stat

IF TRAINERFLY_RULE == TRAINERFLY_RULE_B
; Gen 1 index -> Gen 2 species, the same table and the same 1-based indexing as
; ConvertMon_1to2 (engine/link/time_capsule_2.asm). Read far rather than
; farcall'd so wTempSpecies is left alone.
	and a
	jr z, .bad
	cp TRAINERFLY_MAX_GEN1_INDEX + 1
	jr nc, .bad
	dec a
	ld l, a
	ld h, 0
	ld de, Pokered_MonIndices
	add hl, de
	ld a, BANK(Pokered_MonIndices)
	call GetFarByte
ENDC

; The C.5 guard, applied to both rules. Species 0 indexes PokemonPicPointers at
; entry -1; 252 and 254-255 decompress a pic from bank $ff:$ffff and hand
; GetBaseData a garbage stat row; 253 is EGG. None of them may reach a battle,
; let alone the party (risks #1/#2/#4).
	and a
	jr z, .bad
	cp NUM_POKEMON + 1
	jr nc, .bad
	scf
	ret

.bad
	and a
	ret


; ---------------------------------------------------------------------------
; Firing it.
; ---------------------------------------------------------------------------

TrainerFlyBattleScript:
	callasm TrainerFlySetUpWildMon
	startbattle
	reloadmapafterbattle
	end

TrainerFlySetUpWildMon:
; What Script_loadwildmon does, with a species out of RAM instead of out of the
; script stream. wOtherTrainerClass = 0 is what makes LoadTrainerOrWildMonPic
; treat it as wild (B.5); wBattleType = BATTLETYPE_NORMAL keeps it catchable.
	ld a, 1 << 7
	ld [wBattleScriptFlags], a
	ld a, [wTrainerFlySpecies]
	ld [wTempWildMonSpecies], a
	ld a, TRAINERFLY_LEVEL
	ld [wCurPartyLevel], a
	xor a ; BATTLETYPE_NORMAL
	ld [wBattleType], a
	ld [wOtherTrainerClass], a
	ret


; ---------------------------------------------------------------------------
; The departure tell.
; ---------------------------------------------------------------------------

TrainerFlyArmedHere::
; `callasm` hook for FlyFunction.FlyScript, TeleportFunction.TeleportScript and
; EscapeRopeOrDig.UsedDigOrEscapeRopeScript. Sets wScriptVar to 1 if a live arm
; belongs to this map and its trainer is actually on screen, so the caller can
; `iffalse` past a `showemote EMOTE_SHOCK, LAST_TALKED, N`.
;
; In Gen 1 the "!" plays over the departure because BIT_FLY_WARP is only
; consumed on the next OverworldLoop pass, after RunMapScript (A.2). Crystal's
; field moves warp from inside their own script, so without this the "!" would
; never play at all and the player would get no confirmation that the arm took.
;
; This only draws; wTrainerFlyPending is left alone, so the ARMED -> DEPARTED
; promotion stays in TrainerFlyCheckPending where it covers every way of
; leaving a map, not just the three field moves.
	xor a
	ld [wScriptVar], a

	ld a, [wTrainerFlyPending]
	cp TRAINERFLY_ARMED
	ret nz
	call TrainerFlyOnStoredMap
	ret nz

	ld a, [wTrainerFlyObject]
	ldh [hLastTalked], a

; showemote drives the object through applymovementlasttalked, so it needs a
; loaded object struct. An unloaded one would hang the script.
	call GetMapObject
	ld hl, MAPOBJECT_OBJECT_STRUCT_ID
	add hl, bc
	ld a, [hl]
	cp -1
	ret z

	ld a, 1
	ld [wScriptVar], a
	ret
