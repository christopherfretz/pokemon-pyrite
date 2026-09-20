; Kanto hack M6 9d -- POKéMON TOWER ghost battles (docs/M6-TOWER.md 3.4, D10).
;
; Yellow spreads this over five files; here everything except six small hooks
; lives in one section so the tight battle banks ($0d/$0f) pay almost nothing.
; Reached exclusively by `farcall`, so `a` is the only clobbered register the
; hooks have to care about.
;
; Yellow reference:
;   engine/battle/core.asm            IsGhostBattle / PrintGhostText
;   engine/battle/init_battle.asm     InitWildBattle (ghost pic + "GHOST" nick)
;   engine/battle/common_text.asm     PrintBeginningBattleText (.pokemonTower)
;   engine/items/item_effects.asm     ItemUseBall (can't-be-caught)

DEF GHOST_PIC_TILES EQU 7 * 7

CheckGhostBattle::
; Hook: StartBattle, before BattleIntro.
; Yellow: IsGhostBattle -- wild only, POKéMON TOWER 1F-7F, no SILPH SCOPE.
; wBattleMode is not set up yet at this point, so use wOtherTrainerClass (the
; same discriminator LoadTrainerOrWildMonPic uses) for "is this a wild battle".
	ld a, [wOtherTrainerClass]
	and a
	ret nz

	ld a, [wBattleType]
	and a ; BATTLETYPE_NORMAL
	ret nz

	call IsInPokemonTower
	ret nc

	call HasSilphScope
	ret c

	ld a, BATTLETYPE_GHOST
	ld [wBattleType], a
	ret

IsInPokemonTower::
; Carry if the player is on a POKéMON TOWER floor.
; D24: 1F is map id 12 and 2F-7F are 17-22, so this cannot be a range test.
	ld a, [wMapGroup]
	cp GROUP_POKEMON_TOWER_1F
	jr nz, .nope
	ld a, [wMapNumber]
	cp MAP_POKEMON_TOWER_1F
	jr z, .yep
	cp MAP_POKEMON_TOWER_2F
	jr c, .nope
	cp MAP_POKEMON_TOWER_7F + 1
	jr nc, .nope
.yep
	scf
	ret
.nope
	and a
	ret

HasSilphScope::
; Carry if SILPH SCOPE is in the bag (KEY ITEMS pocket; _CheckItem dispatches
; on the item's attribute, so wNumItems is the right generic entry point).
	push hl
	push de
	ld a, [wCurItem]
	ld d, a
	ld a, SILPH_SCOPE
	ld [wCurItem], a
	ld hl, wNumItems
	call CheckItem
	ld a, d
	ld [wCurItem], a ; neither restore touches the carry flag
	pop de
	pop hl
	ret

GhostSubstitution::
; Hook: InitEnemyWildmon, right after the enemy frontpic is drawn.
; Yellow: InitWildBattle swaps in GhostPic and writes "GHOST@" to the nickname.
; We let the normal load happen and overwrite it, which keeps wEnemyMon* (and
; therefore the Pokédex-seen flag LoadEnemyMon sets -- Yellow does the same)
; completely intact.
	ld a, [wBattleType]
	cp BATTLETYPE_GHOST
	ret nz

	ld hl, GhostMonName
	ld de, wEnemyMonNickname
	ld bc, GhostMonNameEnd - GhostMonName
	call CopyBytes

	; fallthrough

LoadGhostFrontpic:
; Overwrite the 7x7 enemy frontpic in vTiles2 with the GHOST pic.
; gfx/battle/ghost.png is Yellow's 6x6 sprite pre-padded to 7x7 and assembled
; --columns, so it is already in the exact layout PadFrontpic would produce.
	ld hl, vTiles2
	ld de, GhostPic
	ld c, GHOST_PIC_TILES
	ld b, BANK(GhostPic)
	call Get2bpp
	ret

GhostMonName:
	db "GHOST@"
GhostMonNameEnd:

GhostBattleStartMessage::
; Hook: BattleStartMessage, .wild.
; Yellow: PrintBeginningBattleText's .pokemonTower branch prints
; EnemyAppearedText + GhostCantBeIDdText with no cry and no shininess check.
	farcall BattleStart_TrainerHuds
	ld hl, GhostAppearedText
	call StdBattleTextbox
	ld hl, GhostCantBeIDdText
	call StdBattleTextbox
	ret

GhostTurn::
; Hook: DoTurn, before CheckTurn. Carry = the turn was consumed by the ghost.
; Yellow: PrintGhostText. The player's side falls through to the normal status
; handling when the mon is frozen or asleep; the enemy's side never does.
	ld a, [wBattleType]
	cp BATTLETYPE_GHOST
	jr nz, .not_a_ghost

	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy

	ld a, [wBattleMonStatus]
	and 1 << FRZ | SLP_MASK
	jr nz, .not_a_ghost
	ld hl, GhostScaredText
	jr .print

.enemy
	ld hl, GhostGetOutText

.print
	call StdBattleTextbox
	ld a, 1
	ld [wTurnEnded], a
	scf
	ret

.not_a_ghost
	and a
	ret

GhostCantBeCaught::
; Hook: PokeBallEffect. Carry = force the "broke free" path.
; Yellow forces the $10 "can't be caught" value in two places:
;   * any unidentified ghost (callfar IsGhostBattle), and
;   * POKEMON_TOWER_6F + RESTLESS_SOUL, which has no Scope check at all and so
;     still applies after the reveal (docs/M6-TOWER.md 3.6).
	ld a, [wBattleType]
	cp BATTLETYPE_GHOST
	jr z, .cant

	call IsInPokemonTower
	ret nc
	ld a, [wMapNumber]
	cp MAP_POKEMON_TOWER_6F
	ret nz
	ld a, [wEnemyMonSpecies]
	cp MAROWAK
	ret nz
.cant
	scf
	ret

RevealGhost::
; D25 / docs/M6-TOWER.md 3.6 -- designed here, wired by 9i.
; Call with the battle screen up and wTempEnemyMonSpecies holding the real
; species: restores the real nickname in wEnemyMonNickname, swaps the GHOST pic
; for the species pic and runs the normal front-pic animation (which plays the
; cry). The caller still owns the surrounding text and must redraw the enemy
; HUD afterwards if it wants the new name on screen.
	ld a, [wTempEnemyMonSpecies]
	ld [wNamedObjectIndex], a
	call GetPokemonName
	ld hl, wStringBuffer1
	ld de, wEnemyMonNickname
	ld bc, MON_NAME_LENGTH
	call CopyBytes

	ld a, [wTempEnemyMonSpecies]
	ld [wCurSpecies], a
	ld [wCurPartySpecies], a
	ld hl, wEnemyMonDVs
	predef GetUnownLetter
	ld de, vTiles2
	predef GetAnimatedFrontpic
	xor a
	ld [wTrainerClass], a
	ldh [hGraphicStartTile], a
	hlcoord 12, 0
	lb bc, 7, 7
	predef PlaceGraphic

	hlcoord 12, 0
	ld d, $0
	ld e, ANIM_MON_NORMAL
	predef AnimateFrontpic
	ret

GhostPic:
INCBIN "gfx/battle/ghost.2bpp"
