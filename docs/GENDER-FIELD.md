# GF1 — An explicit gender field, separate from DVs (research only, no code)

> **Question (cfretz244, 2026-10-14):** *"This would change the layout of core structs, so it might
> destabilise the engine and add bugs I can't imagine. Could we track gender as an explicit field
> (not a computed one)? Gender would then have nothing to do with IVs."*
>
> This is a survey. Nothing here has been implemented. File:line references are to pyrite `ea5a211`.

## Executive summary

1. **Yes, it is possible.** No struct changes size, and existing saves keep loading.
2. **The only *safe* save-compatible home** is the 2 "time of day caught" bits (bits 7-6 of `CaughtLevel`) in every
   party and box mon. Today only the Cianwood Poké Seer reads them. Growing the 32-byte box struct breaks every save.
3. **Every Pokémon you own keeps its current gender.** A one-time pass on CONTINUE resets the field to "unset = derive
   from DVs as today". Only Pokémon created after the update get a gender rolled independently of their DVs.
4. **Cost:** two work items. GF2 is the engine and the migration; GF3 is eggs, gifts, the web tracker and editor, and
   tests. A forgotten site falls back to today's behaviour instead of breaking.
5. **Shiny hunt:** this affects only the 32 species with a 1-in-8 female ratio, **SNORLAX among them**. Today a shiny
   SNORLAX is *always male*. Afterwards 1 in 8 is female (1/65,536 per encounter). The shiny rate (1/8192) and every
   other species' shiny gender split are unchanged.
6. **Recommendation:** feasible, with moderate risk concentrated in the migration. Do it between hunts, not during one.

---

## 1. How gender is derived today

`GetGender` (`engine/pokemon/mon_stats.asm:124`) is unchanged from vanilla Crystal. It works in five steps:

1. It picks a DV source from `wMonType`:
   - `PARTYMON` → `wPartyMon1DVs`
   - `OTPARTYMON` → `wOTPartyMon1DVs`
   - `BOXMON` → `sBoxMon1DVs`, opening `BANK(sBox)`
   - `TEMPMON` → `wTempMonDVs`
   - anything else (wild or enemy) → `wEnemyMonDVs`
2. It builds `b = (AtkDV << 4) | SpdDV`.
3. It reads the species' ratio byte at `BaseData + BASE_GENDER` (indexed by `wCurPartySpecies`).
4. It applies the ratio:
   - `GENDER_UNKNOWN` ($FF) → genderless (carry set).
   - `GENDER_F0` → male.
   - `GENDER_F100` → female.
   - Otherwise, **female iff `b ≤ ratio`**.
5. It returns:
   - male: `a=1` (nz, nc)
   - female: `a=0` (z, nc)
   - genderless: carry

The ratios are in `constants/pokemon_data_constants.asm:35-41` (`percent` = `× $FF / 100`):

| Ratio | Value | Female iff | Species (of 251 + MISSINGNO.) |
|---|---|---|---|
| `GENDER_F0` | 0 | never | 8: NIDORAN♂ line, HITMONLEE/CHAN/TOP, TYROGUE, TAUROS |
| `GENDER_F12_5` | 31 | **Atk DV ≤ 1** | **32**: all 18 starters (Kanto and Johto lines), EEVEE + 5 evolutions, OMANYTE/OMASTAR/KABUTO/KABUTOPS/AERODACTYL, **SNORLAX**, TOGEPI, TOGETIC |
| `GENDER_F25` | 63 | Atk DV ≤ 3 | 12: ABRA and MACHOP lines, GROWLITHE/ARCANINE, ELEKID/ELECTABUZZ, MAGBY/MAGMAR |
| `GENDER_F50` | 127 | Atk DV ≤ 7 | 158: everything else that has a gender |
| `GENDER_F75` | 191 | Atk DV ≤ 11 | 11: CLEFFA/CLEFAIRY/CLEFABLE, IGGLYBUFF/JIGGLYPUFF/WIGGLYTUFF, VULPIX/NINETALES, SNUBBULL/GRANBULL, CORSOLA |
| `GENDER_F100` | 254 | always | 9: NIDORAN♀/NIDORINA/NIDOQUEEN, CHANSEY/BLISSEY, KANGASKHAN, SMOOCHUM/JYNX, MILTANK |
| `GENDER_UNKNOWN` | $FF | genderless | 22: DITTO, UNOWN, the legendaries, MAGNEMITE/MAGNETON, VOLTORB/ELECTRODE, STARYU/STARMIE, PORYGON/PORYGON2, MISSINGNO., … |

Every threshold is of the form `x_F`, so **only the Attack DV ever matters**. The Speed DV in `b` never decides the
result.

The shiny rule is `CheckShininess` (`engine/gfx/color.asm:3-44`). A Pokémon is shiny when Def, Spd and Spc are all
10 and the Atk DV has bit 1 set (`SHINY_ATK_MASK`). That means Atk ∈ {2, 3, 6, 7, 10, 11, 14, 15}, and
P(shiny) = 8/65536 = 1/8192.

### What this coupling does in practice

| Consequence | Why |
|---|---|
| **Female Pokémon have systematically lower Attack.** A female F50 Pokémon always has Atk DV ≤ 7, and a female starter, EEVEE or SNORLAX has Atk DV ≤ 1. A male always has the higher half. | Gender *is* the Attack DV |
| **No shiny of the 32 F12.5 species can be female.** Shiny needs Atk ≥ 2; female needs Atk ≤ 1. | Disjoint DV sets |
| For F25/F50/F75, the shiny gender split happens to match the species ratio (2/8, 4/8, 6/8 of the shiny Atk values). | Luck of the bit layout |
| A female shiny F50 always has Atk ∈ {2,3,6,7}, never the strong 10-15 values. | As above |
| Day-Care eggs inherit Def and Spc but keep their own Atk and Spd, so their gender is stable. A shiny parent gives 1/64 shiny eggs. | `daycare.asm` ~640-700 |
| Every NPC-trade, Odd Egg and trainer Pokémon has a fixed gender, because its DVs are fixed. | `data/events/npc_trades.asm`, `data/events/odd_eggs.asm`, `data/trainers/dvs.asm` |
| The red GYARADOS (`BATTLETYPE_FORCESHINY`, DVs `$EA $AA`) is always male. | Atk 14 |
| The starter PIKACHU takes the DVs of Oak's tutorial Pikachu (`PK1_StarterDVsOrRandom`, `move_mon.asm:1839`), and therefore its gender too. | Feature, not a bug |
| A Magikarp's length re-rolls its DVs (`core.asm` ~6327-6386), which loosely ties its gender to its length. | Same DV bits |

Gen 2 has no abilities, so there is no Cute Charm or Rivalry to worry about. The UNOWN letter and the Magikarp length
are computed from DVs, not from gender.

---

## 2. Every consumer of gender

All of them go through `GetGender`, except the web tracker and one dead routine. That makes `GetGender` the single
choke point.

| Consumer | File | Reads | What changes |
|---|---|---|---|
| Player battle HUD ♂/♀ | `engine/battle/core.asm:4841` | `PARTYMON`, `wCurBattleMon` | Nothing beyond `GetGender` |
| Enemy battle HUD ♂/♀ | `engine/battle/core.asm:4917` | wild/enemy → `wEnemyMonDVs`, or `wEnemyBackupDVs` when transformed | Enemy branch must read the in-battle gender byte (§3.3) |
| Attract (`CheckOppositeGender`) | `engine/battle/move_effects/attract.asm:35,58` | player: `PARTYMON`; enemy: copies DVs into `wTempMonDVs` and calls with `TEMPMON` | **Enemy half fabricates a TEMPMON from DVs alone.** It must use the enemy branch instead, or it will read stale `wTempMon` bits |
| Love Ball | `engine/items/item_effects.asm:1016,1030` | party mon and wild mon | Same enemy-branch change |
| Stats screen ♂/♀ | `engine/pokemon/stats_screen.asm:481` | `wMonType` of the viewed mon | Nothing |
| Party menu gender column (NPC trade and Day-Care pickers) | `engine/pokemon/party_menu.asm:459` | `PARTYMON` | Nothing |
| PC Pokémon info | `engine/pokemon/bills_pc.asm:1084` | `TEMPMON` (full struct copied in) | Check that the copy includes `CaughtLevel` (it copies the whole box struct) |
| Nickname screen symbol | `engine/menus/naming_screen.asm:107` | the caller's `wMonType` | The gender must be written **before** the naming screen on the catch path |
| NPC trade "wants a female" check | `engine/events/npc_trade.asm:82,87` (`CheckTradeGender`) | `PARTYMON` | Nothing |
| Hall of Fame display, and the PC HoF viewer | `engine/events/halloffame.asm:497` | `TEMPMON`, **DVs only** (`hof_mon` has no gender) | Clear `wTempMonCaughtLevel` first, or HoF genders stay DV-derived (§3.5) |
| Day-Care: which parent is the mother | `engine/events/daycare.asm:575` | breed mons | Nothing (`wBreedMon1/2` are box structs) |
| Day-Care: egg DV inheritance | `engine/events/daycare.asm:663` | egg's own gender via `TEMPMON`, **DVs only** | Roll and store the egg's gender first, then branch on the stored value (§4) |
| Breeding compatibility | `engine/pokemon/breeding.asm:13,29` | both breed mons | Nothing |
| Egg-move inheritance (Ditto case) | `engine/pokemon/breeding.asm:574,590` | breed mons | Nothing |
| GB Printer party / box | `engine/printer/print_party.asm:311`, `engine/printer/printer.asm:848` | party / temp | Nothing (effectively unused) |
| Mobile | `mobile/mobile_46.asm:6442` | — | Dead in pyrite |
| `LoadBoxMonListing` inline formula | `engine/pokemon/bills_pc_top.asm:349` | its own copy of the DV rule | **Unreferenced dead code.** Leave it, or delete it in GF2 |
| **Web hunt tracker** | `web/app.js:1875-1890` (`genderRatio`/`genderOf`), used at 2268, 2296, CSV 2318-2322, `kfDebug.hunt.gender` 2548 | re-implements `GetGender` from `wEnemyMonDVs` | Must read the in-battle gender byte. The 14-byte `wEnemyMon..wEnemyMonLevel` poll grows by 2 (`gen_tables.py` `hunt`, ~735-760) |
| **Web save editor** | `web/edit.js` (`newMon`, `recalcMon` ~421) | none (no gender UI) | `newMon` must write the new bits, ideally with a ♂/♀ toggle. Party only; there is no box editor |

The OT-gender bit is a different thing: the ♂/♀ beside the *trainer's* name. It lives in `CaughtLocation` bit 7 and
is read by `stats_screen.asm:810-822`, `poke_seer.asm` `GetCaughtGender`, `npc_trade.asm:162`,
`link.asm:1886,1933` and `trade_animation.asm:899,917`. It is untouched in the recommended design.

---

## 3. Where can the field live without changing a struct size? (the central question)

### 3.1 The structs (`macros/ram.asm`)

**`box_struct`** (32 bytes, `BOXMON_STRUCT_LENGTH`):

| Bytes | Field |
|---|---|
| 1 | Species |
| 1 | Item |
| 4 | Moves |
| 2 | ID |
| 3 | Exp |
| 10 | StatExp |
| 2 | DVs |
| 4 | PP |
| 1 | Happiness |
| 1 | PokerusStatus |
| 1 | CaughtTime\|CaughtLevel |
| 1 | CaughtGender\|CaughtLocation |
| 1 | Level |

**`party_struct`** (48 bytes) adds Status, *Unused*, HP, MaxHP and five stats.

**`battle_struct`** has `Status ds 2` and **no** caught or Pokérus bytes.

The SRAM boxes are packed back to back: 14 boxes in banks 2-3 plus `sBox` in bank 1, each `BOX_LENGTH` = $450.
Growing the struct by one byte moves every box, every OT name and every nickname in every existing save.

### 3.2 Candidate spare bits

| # | Location | Bits | Value in legacy saves | Who else reads it | Migration? | If a reader is missed | Verdict |
|---|---|---|---|---|---|---|---|
| **A** | `CaughtLevel` bits 7-6 (`CAUGHT_TIME_MASK`), the time of day caught (1-3; 0 = gift) | 2 | mostly non-zero | **only the Poké Seer** (`poke_seer.asm:181 GetCaughtTime`). Copied whole by `move_mon.asm`, so it already travels with the mon | yes, one pass (§5) | Seer names the wrong time of day | **Recommended** |
| B | `CaughtLocation` bit 7, the OT's gender | 1 | player gender, 0/1 | stats screen OT symbol, `GetCaughtGender` (Seer, NPC trade, link, trade animation) | yes | wrong OT ♂/♀ | Possible, but loses a feature and has 5 readers |
| C | `Exp` bits 22-23 (max exp is 1,250,000 = $1312D0) | 2 | **always 0** | ~15 refs in 7 files (`core.asm`, `experience.asm`, `stats_screen.asm`, `evolve.asm`, `happiness_egg.asm`, `daycare.asm`, Rare Candy) plus `edit.js recalcMon` | **none** | **A missed mask makes a Pokémon read as Lv100+ or corrupts its exp** | Rejected: catastrophic failure mode |
| D | `PokerusStatus` bit 3 (days are ≤ 4, so bit 3 is never set) | 1 (as "flip the DV gender") | **always 0** | 9 refs in 7 files: whole-byte `and a` in spread logic and in `core.asm:7244` stat-exp doubling, `and $f` in the daily tick and the stats screen | none | **Phantom Pokérus: doubled stat exp, wrong spread/immunity, the tick decrements into the bit** | Rejected: silent gameplay corruption |
| E | party `Unused` byte (after Status) | 8 | 0 | `core.asm:4003-4098` mirrors it into the battle `Status+1` | none | — | **Lost on deposit to the PC.** Not a home, but useful as an in-battle carrier (§3.3) |
| F | Parallel gender bitmap in the 464 free bytes at the end of SRAM banks 2/3 | 1 per slot | n/a | every deposit, withdraw, move, release, box switch, trade, Day-Care and clone path | yes | bitmap desyncs, so genders silently swap between Pokémon | Rejected |
| G | Grow `box_struct` to 33 B / `party_struct` to 49 B | 8 | n/a | everything | full SRAM repack converter for all 15 boxes, WRAM1 evictions (`wPartyMons` +6 B, and WRAM1 is full, `docs/HOUSEKEEPING.md` §3), HoF and link format, regenerated `tables.json` offsets | if the converter misses anything, the save is broken | Rejected: strictly worse than A |

Other bytes were checked and are fully used: Species, Item, Moves, ID, StatExp, DVs, Happiness, Level (MISSINGNO.
goes past 100), and PP (the top 2 bits are PP Ups, and current PP can reach 61). `CaughtLocation`'s low 7 bits are
fully used too: landmarks run to $61, plus `LANDMARK_GIFT` $7E and `LANDMARK_EVENT` $7F.

### 3.3 Recommended layout (option A)

Bits 7-6 of the byte at `MON_CAUGHTLEVEL`, in every box struct and party struct:

| Bits 7-6 | Meaning |
|---|---|
| `%00`, `%01` | **unset: derive from the DVs exactly as today** |
| `%10` | explicit male |
| `%11` | explicit female |

Bit 7 is the "explicit" flag and bit 6 is "female". With this encoding, a legacy byte damaged by the level-overflow
bug below (a Lv64-127 catch sets only bit 6) still reads as "unset".

**In battle**, the `battle_struct` has no caught byte. The enemy's gender is carried in **`wEnemyMonStatus + 1`**,
the second status byte. It is otherwise unused, and the catch code already copies it into the party `Unused` byte
(`move_mon.asm:315`). `LoadEnemyMon` writes the rolled gender there with the same encoding. Trainer Pokémon leave it
`$00`, so they derive from DVs as today. `BattleCommand_Transform` does not copy Status
(`move_effects/transform.asm:25-75`), so a transformed enemy keeps its own gender.

The player's active Pokémon is already read from its party struct (`PARTYMON`, `wCurBattleMon`).

GF2 must grep every write to `wEnemyMonStatus` and `wBattleMonStatus` and confirm none touches `+1`. Some clear
both bytes, and that would be fine.

**New `GetGender` logic:**
1. Read the ratio byte first. Genderless, F0 and F100 return exactly as today, ignoring the stored bits. This keeps
   a species change (evolution, the web editor) from creating an impossible "female NIDOKING".
2. For a mixed-ratio species, look at the struct's `MON_CAUGHTLEVEL` byte (party, OT party, box or temp), or at
   `wEnemyMonStatus+1` for the enemy branch.
3. If bit 7 is set, return bit 6.
4. Otherwise run the existing DV formula unchanged.

`GetGender` is a predef outside the Battle Core bank, which is $0F with ~115 B free and off limits.

### 3.4 Latent bug found on the way (fix it in GF2 regardless)

`SetBoxmonOrEggmonCaughtData` (`engine/pokemon/caught_data.asm:168`) does
`(wTimeOfDay+1) rrca rrca | wCurPartyLevel` **without masking the level to 6 bits**. Any catch at Lv64 or higher
already corrupts the time bits in today's game, and pyrite has Lv70 MEWTWO/MEW and a Lv80 CELEBI. Under option A this
would forge a gender, so GF2 must `and CAUGHT_LEVEL_MASK` the level before the OR. The Poké Seer already masks on
read, so it reports the level mod 64 today (vanilla behaviour).

### 3.5 Hall of Fame

`hof_mon` (`macros/ram.asm:233`) stores Species, ID, DVs, Level and Nickname, and has no gender. There are two
choices:
- **(a) Accept it.** HoF entries show the DV-derived gender, a cosmetic mismatch for a Pokémon with a rolled gender.
- **(b) Use Level bit 7 of the HoF entry** as "female, explicit", masked on display. Old entries have it clear.
  Watch MISSINGNO. levels, though it is genderless.

Recommendation: (b) in GF3 if cheap, otherwise (a). The halloffame.asm:497 caller must clear
`wTempMonCaughtLevel` either way, so that a stale `wTempMon` cannot leak a gender.

---

## 4. Generation points that would need a real gender roll

A rolled gender is one `Random` byte `r`, female iff `r ≤ ratio`. That reproduces the exact species ratio
((ratio+1)/256 = 1/8, 1/4, 1/2, 3/4). **Any site left unchanged writes `%00`, so it keeps today's DV-derived gender.
Missing a site is a feature gap, not a bug.**

| Generation point | Where | Today | Proposed |
|---|---|---|---|
| **Wild encounter** (the hunt) | `LoadEnemyMon` `.RollDVs` (`engine/battle/core.asm:6586`, RN3 Feistel) / `.GenerateDVs` 6298 | DVs → gender | **Roll** into `wEnemyMonStatus+1` via a farcall (bank $0F is full) |
| Catch → party | `move_mon.asm` `TryAddMonToParty`/`GeneratePartyMonStats` (3/81), `.copywildmonDVs`; caught data via `SetBoxmonOrEggmonCaughtData` | — | Write `wEnemyMonStatus+1` bits 7-6 into `CaughtLevel` (masked level) |
| Catch → box | `SendMonIntoBox` (`move_mon.asm:950`) + `SetBoxMonCaughtData` | — | Same |
| Roamers (RAIKOU/ENTEI/SUICUNE) | `core.asm:6276`, `roam_struct` (no caught byte) | genderless | Nothing to do |
| Red GYARADOS (`BATTLETYPE_FORCESHINY`) | fixed DVs `$EA $AA` | always male | Roll (operator ruling: canon has no fixed gender) |
| Trainer Pokémon | `GetTrainerDVs`, `data/trainers/dvs.asm` | fixed per class | **Leave as is** (`%00`); OT party mons stay DV-derived |
| `givepoke` gifts | `GivePoke` (`move_mon.asm:1627`) + `SetGiftPartyMonCaughtData`/`SetGiftBoxMonCaughtData` (`caught_data.asm:209-238`) | DV-derived from random DVs | Roll. Covers starter PIKACHU (OaksLab), BULBASAUR (CeruleanMelaniesHouse), CHARMANDER (Route24), SQUIRTLE (VermilionCity), the two EEVEEs (BillsFamilysHouse, CeladonMansionRoofHouse), the fossils (CinnabarLabFossilRoom), LAPRAS (SilphCo7F), HITMONLEE/CHAN (FightingDojo, F0), the Game Corner prizes, MAGIKARP (MtMoonPokecenter), the Johto starters (ElmsLab), DRATINI (DragonShrine), TYROGUE (MountMortarB1F, F0), SPEAROW (Route35GoldenrodGate), SHUCKLE (`shuckle.asm`) |
| Starter PIKACHU | `PK1_StarterDVsOrRandom` | inherits the tutorial Pikachu's gender | **Ruling needed**: roll, or copy the tutorial Pikachu's gender (needs a byte; the Yellow tutorial battle mon is `wEnemyMon`, so `+1` of its Status) |
| Eggs: `giveegg` TOGEPI | `GiveEgg` (`move_mon.asm:1129`), `maps/VioletPokecenter1F` | DV-derived | Roll into the egg's struct |
| Eggs: Odd Egg | `special GiveOddEgg`, `data/events/odd_eggs.asm` | fixed DVs: all female except TYROGUE | Roll (with a ruling) or leave `%00` |
| Eggs: Day-Care | `DayCare_InitBreeding` (`engine/events/daycare.asm` ~526-720) into `wEggMon` | egg gender = its own Atk DV; female egg inherits DVs from the father, male from the mother | **Roll first, store in `wEggMonCaughtLevel`**, then pick the DV donor from the stored gender (the `daycare.asm:663` call) |
| Egg hatch | `engine/pokemon/breeding.asm:228` → `SetEggMonCaughtData` (`caught_data.asm:235`) → `SetBoxmonOrEggmonCaughtData` | rewrites the whole byte with time\|level | **Must preserve bits 7-6.** Otherwise every hatch erases the rolled gender |
| NPC trades | `data/events/npc_trades.asm`, `ComputeNPCTrademonStats` (`move_mon.asm:1381`) | fixed: MUSCLE ♀, ROCKY ♂, DORIS ♀, PAUL ♂, SPARKY ♂, MILES ♂, RICKY ♂, GURIO ♂, SPIKE ♂, BUFFY ♂, CEZANNE ♂, STICKY ♂; VOLTY and MAGGIE genderless | **Leave `%00`.** They are characters with a fixed gender |
| Bug-Catching Contest | `wContestMon` (party struct) and the contest caught-data path (keeps `CAUGHT_GENDER_MASK`, sets `LANDMARK_NATIONAL_PARK`) | DV-derived | Roll on catch, carry through to the award |
| MISSINGNO. (Old Man glitch) | `docs/OLD-MAN-GLITCH.md` | genderless | Nothing |
| Battle Tower opponents | `engine/events/battle_tower/battle_tower.asm:111` | fixed DVs | Leave |
| Link / Time Capsule trades | `engine/link/link.asm` | struct copied whole | See §5.4 |
| Web editor `newMon` | `web/edit.js` | DVs `$FF $FF`, so every mixed-ratio species comes out male | Write an explicit gender (GF3) |

---

## 5. Save migration plan

### 5.1 Why a migration is needed at all

Legacy saves hold time-of-day values 1-3 in bits 7-6. That is `%10` for DAY and `%11` for NITE. Read under the new
encoding, those would become "explicit male" and "explicit female". Before anything reads the field as a gender, each
legacy byte must be reset to `%00` ("derive from DVs"). After that reset **every existing Pokémon's gender is
unchanged**.

### 5.2 Eager, gated, idempotent: on CONTINUE

The model is `RefreshMapObjectScripts`: map setup command `$30`, run only from `MapSetupScript_Continue`, in bank $20
(`docs/M3-CERULEAN.md` "CH1b findings"). A new Continue-only setup step does the following:

1. **WRAM side** (`wPokemonData`, which is saved in the checksummed `sGameData`). If the event flag
   `EVENT_GENDER_FIELD_MIGRATED` is clear, AND bits 7-6 to zero (`and CAUGHT_LEVEL_MASK`) in these structs:
   - `wPartyMons` (6)
   - `wBreedMon1`, `wBreedMon2`
   - `wEggMon`
   - `wContestMon`

   Then set the flag. There are about 852 free `EVENT_` flags, so the flag costs no WRAM.
2. **SRAM side** (the 14 boxes in banks 2-3 plus `sBox` in bank 1, 300 Pokémon). If the SRAM marker is not set,
   clear bits 7-6 in every slot, then write the marker last. Use a fixed magic byte in the free tail of SRAM bank 1
   (that bank already holds `sBox`; it has $1A8 bytes free at $BE58-$BFFF per `pokecrystal.map`, and that tail is not covered by any checksum).

**Why two markers and not one event flag:** the box data and the party data roll back independently. A backup-save
restore (`sBackupGameData`) or a CHANGE BOX power cut (`docs/CLONE-GLITCH.md`, frames 141-152) can bring back an
*older* `sGameData` (with the flag clear) while the SRAM boxes stay new. With one event flag, the re-run would wipe
the **rolled** genders of Pokémon caught since the update. A female shiny SNORLAX in a box would quietly turn back
into a male. Keeping each marker beside the data it describes makes every container self-consistent:
- the party flag travels inside the same checksummed blob as the party;
- the box marker travels with the boxes.

**Checked:** `SaveChecksum`/`VerifyChecksum` (`engine/menus/save.asm:526,771`) cover only `sGameData`. The boxes and
`sBox` have no checksum, so editing them in place cannot trip "save file corrupted".

**Idempotent:** the pass only clears bits, and it runs only while its marker is unset. A power cut mid-pass re-runs it
cleanly next time, because no rolled genders can exist before the pass completes.

**Clones:** the clone glitch copies whole 32-byte structs, so a clone carries its gender bits. A clone made after the
update is an exact gender clone, and one made before it is legacy and gets migrated with everything else.

**Lazy alternative (rejected):** only the Poké Seer reads time, so the time bits could be left alone and
"%10/%11 = explicit" interpreted only on structs written by new code. Nothing in the byte distinguishes old from new,
though, so this cannot work without a marker per Pokémon. That marker would be a struct change.

### 5.3 Rollback and old ROMs

Loading a migrated save in an *older* pyrite release is harmless: the Poké Seer would name an odd time of day. Coming
*back* to the new ROM after catching Pokémon in the old one is the one bad path. Those catches carry time bits, the
markers are already set, so they get random-looking (but stable) genders. Release note: "don't downgrade after
updating".

### 5.4 Link and Time Capsule

Gen 1 (Time Capsule) Pokémon should arrive with caught data 0, meaning "derive", which is correct (GF3 should confirm this in `link.asm`). A Pokémon from
**vanilla** Crystal carries real time bits and would read them as gender, and pyrite cannot tell a vanilla partner from
a pyrite one. Mitigation: clear bits 7-6 on receipt when the OT ID is not the player's. The cost is that a
pyrite-to-pyrite trade then falls back to DV gender. Low priority, since nobody link-trades this ROM today.

### 5.5 Web editor and hunt tracker

- **`edit.js`** works on the party in the `.sav`, which sits inside the checksummed `sGameData`; the editor
  recomputes the checksum. The plan:
  - `newMon` should write bits 7-6 (default: a rolled gender, plus a ♂/♀ toggle for mixed-ratio species).
  - `recalcMon` must not overwrite `CaughtLevel` (today it touches only exp and PP: check this).
  - The editor must **set the migration event flag** when it writes into a save that has not been migrated yet, or
    its explicit genders will be wiped on the next CONTINUE.
- **`app.js`** hunt: `genderOf` reads `wEnemyMonStatus+1` (bit 7 → bit 6) and otherwise falls back to today's DV
  formula. `gen_tables.py` extends the poll window by 2 bytes, and `docs/WEB-HUNT.md` test #6 gains explicit-gender
  cases.

---

## 6. Shiny-hunt implications (for Jonathan)

**What does not change:** P(shiny) stays at 1/8192 per encounter, and the shininess rule is still read from the DVs.

**What changes:** P(female | shiny) now equals the species ratio for *every* species.

| Ratio class | Examples | P(female \| shiny) **today** | P(shiny ∧ female) **today** | **After** (independent gender) |
|---|---|---|---|---|
| F12.5 | **SNORLAX**, starters, EEVEE line, fossils, TOGEPI | **0** (impossible) | **0** | **1/8 → 1/65,536** |
| F25 | ABRA, MACHOP, GROWLITHE, ELEKID, MAGBY lines | 1/4 | 1/32,768 | 1/32,768 (same) |
| F50 | most species, PIKACHU | 1/2 | 1/16,384 | 1/16,384 (same) |
| F75 | CLEFAIRY, JIGGLYPUFF, VULPIX lines | 3/4 | ≈1/10,923 | ≈1/10,923 (same) |
| F0 / F100 / genderless | TAUROS, CHANSEY, DITTO… | fixed | fixed | fixed |

For SNORLAX in particular:
- **Any shiny:** median ≈ 5,678 encounters (unchanged, `docs/WEB-HUNT.md`).
- **Shiny and female:** today never. After the update the median is ≈ 45,400 encounters (65,536 × ln 2) and the mean
  is 65,536, so about eight times as long as the current hunt.
- **A shiny already caught keeps its gender.** It is a legacy Pokémon, so it stays male for good.
- **Mid-hunt:** the gender of a not-yet-shiny encounter does not matter, and the update does not change the shiny
  odds. The only change is that 1 in 8 of the shinies he finds after updating would be female.

Other side effects:
- **Day-Care breeding:** shiny-parent eggs stay at 1/64 (the DV inheritance is untouched). A female shiny EEVEE or
  starter is now possible by breeding too.
- **Gender no longer costs Attack.** Females get the full Attack DV range.

### RNG caveat (has to be tested before release)

RN3 (`docs/RN1-RNG.md`) mixes `(hRandomAdd, hRandomSub)` through a bijective 4-round Feistel to produce the DVs. All
16 bits of that state are "used up" by the DVs. A gender byte drawn by the *next* `Random` call depends only on that
same state plus a deterministic `rDIV` advance. In the fixed save-state regime (SNORLAX woken from the same save) the
gender of a shiny might therefore be **a fixed function of which seed produced it**. In the worst case, every shiny
reachable from a given save would come out male.

GF2 must re-run the RN3-style enumeration (the pooled 458,752-seed sweep that found 53 shinies) with the gender roll
included, and assert that roughly 1/8 of the shinies are female (≈ 6-7 of 53, with a sensible tolerance). If they are
not, fold an extra mixing round or `hRandomAdd` from a later frame into the gender byte.

---

## 7. Risk, effort and blast radius

### Files touched (estimate)

| Work item | Files |
|---|---|
| **GF2: engine core and migration** | `engine/pokemon/mon_stats.asm` (`GetGender`); `engine/pokemon/caught_data.asm` (level mask, preserve bits 7-6, write gender); `engine/battle/core.asm` (one farcall in `LoadEnemyMon`, HUD enemy branch); `engine/battle/move_effects/attract.asm`; `engine/items/item_effects.asm` (Love Ball); `engine/pokemon/move_mon.asm` (catch paths); a new Continue map-setup step (bank $20 pattern) + `constants/event_flags.asm`; `engine/events/poke_seer.asm` (time → "can't tell" once migrated) |
| **GF3: generation points and tools** | `move_mon.asm` (`GivePoke`, `GiveEgg`), `engine/events/daycare.asm` (roll before inheritance), `engine/pokemon/breeding.asm` (hatch), the Odd Egg, the contest, `engine/events/halloffame.asm` (+ optional HoF bit), `engine/link/link.asm` (optional strip); `web/app.js`, `web/edit.js`, `web/gen_tables.py`, `docs/WEB-HUNT.md` |

Code size: tens of bytes in `GetGender`, about 60-100 bytes for the migration (loops over 3 SRAM banks), and a few
bytes per generation site. Nothing goes in Battle Core bank $0F except one `farcall`.

### Harness tests to write

1. **Legacy save round-trip:** load Jonathan-style long saves (current release) → CONTINUE → for every party and box
   Pokémon, the gender equals the DV-derived gender before the update. Run it twice to prove idempotence.
2. **Rollback simulations:**
   - restore `sBackupGameData`;
   - cut power during CHANGE BOX (reuse `scripts/clone_glitch.py`);
   - assert that no rolled gender is lost.
3. **Distribution:** 2,000 forced wild SNORLAX and 2,000 PIDGEY encounters → female share ≈ 12.5% and 50%,
   independent of the Atk DV.
4. **RN3 shiny/gender enumeration** (§6).
5. **Catch, box, withdraw, deposit, evolve, trade, hatch:** the gender survives every hop. Includes a Lv70 catch
   (the level-mask fix).
6. **Attract and Love Ball** against a wild Pokémon whose rolled gender disagrees with its DV gender, including a
   transformed enemy.
7. **Web:** the hunt tracker shows the rolled gender; an editor-made Pokémon survives CONTINUE.

### Bugs you can't imagine (now imagined)

- **The flag-rollback wipe** (§5.2): one shared event flag + a backup-save restore = rolled genders silently reset.
  Fixed by the per-container markers.
- **Stale `wTempMon` leaks:** Attract (enemy), Hall of Fame and the Day-Care egg build a `TEMPMON` from DVs alone. A
  new `GetGender` would read whatever `CaughtLevel` the last `wTempMon` user left behind.
- **Egg hatch erases the gender:** `SetEggMonCaughtData` rewrites the whole byte.
- **Lv64+ catch forges a gender:** the unmasked level OR (§3.4).
- **Species change through evolution or the editor:** handled by checking the ratio first (F0/F100/genderless
  ignore the bits).
- **Downgrade then upgrade:** stable but random-looking genders for the Pokémon caught in between (§5.3).
- **The RNG ties gender to seed** in the state-load hunt regime (§6).
- **Something writes `wEnemyMonStatus+1`:** that would change a wild Pokémon's gender mid-battle (GF2 grep).

### Effort

**Two work items, about the size of RN3 or CH1:**
- **GF2** (engine and migration, with harness tests 1-6): the risky one. It goes through the standing Opus read-only
  review for engine changes, and its release note has to state save compatibility.
- **GF3** (generation points, eggs, HoF, web tools): low risk, because each missed site falls back to today's
  behaviour.

### Recommendation

It is feasible, and option A is clean: one byte that already travels with every Pokémon, one real reader to retire,
and a fallback that is exactly today's behaviour. The real risk is concentrated in the migration (§5.2), and the
harness can test that exhaustively.

**Do it if** a female shiny of the F12.5 species, or "gender no longer costs Attack", is worth about two work items
to cfretz244 and Jonathan.

**Ship it between hunts**, not in the middle of one. Rulings needed before GF2:
1. Does the starter PIKACHU roll its gender, or copy the tutorial Pikachu's?
2. Do the Odd Egg and the red GYARADOS roll?
3. Is option (a) acceptable for the Hall of Fame?
4. Is it acceptable that the Poké Seer can no longer tell the time a Pokémon was caught?

---

## Rulings (cfretz244, 2026-10-15)

1. **Starter PIKACHU copies the tutorial Pikachu's rolled gender** (one extra byte from `wEnemyMonStatus+1`), so the
   Pikachu seen in Oak's tutorial battle is the one handed over, as in Yellow. **Confirmed by cfretz244 07:58 2026-10-15.**
2. **Odd Egg and red GYARADOS both roll** (operator: "why would they not roll?").
3. **Hall of Fame: option (b)** — bit 7 of the HoF entry's Level byte = "female, explicit", masked on display.
4. **Poké Seer loss accepted** ("much better than any of the alternatives").

Status: research only. GF2/GF3 are NOT scheduled: cfretz244 wants **Jonathan's sign-off** as well, then a between-hunts window.

---

## GF2 findings (implemented 2026-10-15, on top of pyrite f6a731c)

GF2 is the engine change and the save migration. GF3 covers the remaining generation points (see "Deferred" below).
Approved by cfretz244 and Jonathan on 2026-10-15. Because the change touches existing saves, cfretz244 asked for a
higher bar on save integrity. That bar is `scripts/gf2_save_integrity.py` in the context repo, and its output is
quoted at the end of this section.

### Encoding (option A, as planned in §3.3)

Bits 7-6 of a Pokémon's `CaughtLevel` byte (struct offset `MON_CAUGHTLEVEL` = 29):

| bits 7-6 | meaning |
|---|---|
| `%00`, `%01` | **unset**. The gender comes from the DVs, exactly as before GF2. `%01` is never written, and is read as unset. |
| `%10` | explicit male |
| `%11` | explicit female |

- Only mixed-ratio species (F12_5 … F75) read the bits. Genderless, F0 and F100 species ignore them entirely, so a
  stray bit there cannot change anything.
- The level sits in bits 5-0 and is **clamped to 63**. This fixes the §3.4 latent bug: a level-64+ catch (Lv70
  MEWTWO, Lv70 Johto legendaries, Mt. Silver) used to overflow into bits 7-6.
- In battle, the wild Pokémon's rolled gender is stored in `wEnemyMonStatus + 1` (the battle struct's unused byte),
  with the same encoding.
- Constants are in `constants/pokemon_data_constants.asm`: `CAUGHT_GENDER_EXPLICIT(_F)`, `CAUGHT_GENDER_FEMALE(_F)`,
  `CAUGHT_GENDER_BITS`, `CAUGHT_LEVEL_MAX`, `GENDER_MIGRATED_MAGIC_1/2` = `$C7,$5A`.

### What changed, and where it lives

**Readers**
- `GetGender` (`engine/pokemon/mon_stats.asm`, bank $14 = #20). For party, box and temp Pokémon it reads the byte at
  `DVs + 8`. For `WILDMON` it reads `wEnemyMonStatus + 1`. An explicit gender wins; otherwise it falls back to the DV
  rule.
- The new `GetEnemyMonGender` gives the battle HUD and Attract the enemy's gender. It uses the backup DVs while the
  enemy is transformed, plus the rolled byte, so a stale `wTempMonCaughtLevel` can never leak in.
- Everything that builds a temporary Pokémon from DVs alone now also copies or clears the CaughtLevel byte:
  - Day-Care compatibility (`breeding.asm`) and the Day-Care man's text (`daycare.asm`) copy it.
  - The egg's gender for inheritance (`breeding.asm`) clears it, because the egg has no explicit gender yet.
  - Hall of Fame (`halloffame.asm`) clears it: HoF entries keep only DVs, so the gender stays DV-derived until GF3.
  - Bill's PC (`bills_pc.asm`) and the printer (`printer.asm`) copy it.
- The Poké Seer (`poke_seer.asm`) masks bits 7-6 out of the caught level it reports, and always gives vanilla's
  "unknown time" answer (ruling 4).
- The player's own battle HUD (`core.asm`) copies the party Pokémon's CaughtLevel byte into its TEMPMON.

**Generation (wild only in GF2)**
- `RollWildGender` (bank $14, 54 B) is farcalled from `LoadEnemyMon` (bank $0F) right after the status byte. It
  makes one `Random` call and takes `r = swap(hRandomSub) xor hRandomAdd` (see RNG below for why it isn't the
  plain return value). The Pokémon is female iff `r <= ratio`, so F12_5 is 32/256 = 1/8, F50 1/2 and F75 3/4.
- The roll is left unset (`%00`, DV-derived as before) for:
  - trainer Pokémon, and anything `LoadEnemyMon` builds outside a wild battle (gifts through GivePoke);
  - the catch tutorial and roamers, because a roamer's struct has nowhere to keep a roll between encounters;
  - genderless, F0 and F100 species.
- The forced-shiny red GYARADOS rolls (ruling 2).
- Catching: `TryAddMonToParty` and `SendMonIntoBox` (`move_mon.asm`) write the rolled bits into the new Pokémon's
  CaughtLevel byte. `SetCaughtData`/`SetBoxMonCaughtData` (`caught_data.asm`) keep an explicit gender that is
  already there, turn a non-explicit `%01` into `%00`, and add the level, clamped.
- After a successful throw, `PokeBallEffect` re-runs `LoadEnemyMon` (vanilla, for a transformed DITTO). GF2 saves
  and restores the rolled byte around that call, so whatever is caught (party, box or contest Pokémon) keeps the
  gender shown in battle.
- Hatching: `SetEggMonCaughtData` keeps the bits, so an egg hatches with the gender it carries. Eggs from the
  Day-Care get unset bits in GF2.

**Migration** (`engine/pokemon/gender_migration.asm`, bank $20 = #32, 198 B)

A legacy save's time-of-day bits (`%01` MORN, `%10` DAY, `%11` NITE) would read as genders. On Continue, every stored
Pokémon has them cleared to `%00`, which gives exactly the DV gender it already had. There is one marker per
container, and each marker travels with the data it covers:

| Marker | Where | Covers | Written |
|---|---|---|---|
| `wGenderFieldMigrated` (2 B, `$C7,$5A`) | WRAMX 1 `$DE88`, in what was the zero padding at the end of `wPokemonData`. It is saved and checksummed with the party, so its battery bytes are at `sPokemonData`+offset (+`$2A12` primary, +`$1C12` backup). | party ×6, both Day-Care Pokémon, the Day-Care egg, the contest Pokémon | by `MigrateGenderField` after the party pass, and by `NewGame` (`SetGenderFieldPartyMarker`) |
| `sGenderFieldMigrated` (2 B, `$C7,$5A`) | SRAM bank 1 `$BE58`, previously unused space with no checksum. An old battery may hold `$00`, `$FF` or random bytes there (uninitialised SRAM); anything but exactly `C7 5A` (1 in 65,536) reads as "not migrated", the safe direction. It has its own `"SRAM Gender Marker"` section, so `sBox`, `sBackup*` and Boxes 1-14 do not move. | `sBox` plus Boxes 1-14 in banks 2-3 (all 20 slots, stale ones included), edited in place | **last**, after every box is clean, by `MigrateGenderField`; also by `ErasePreviousSave` (`SetGenderFieldBoxMarker`) for a new file |

- `Continue` (`intro_menu.asm`) farcalls `MigrateGenderField` once the save is loaded and before `JumpRoamMons`,
  which is before anything can be saved.
- Either pass only clears bits and only runs while its marker is unset, so a power cut mid-pass just repeats it.
- The WRAM party pass re-runs on every Continue until the player saves. That is harmless, because nothing explicit can
  exist in that container before its marker is saved.

**Deviations from §5.2, and why**
1. The migration is a direct farcall from `Continue`, not a map-setup command, so it runs before any map script or
   roamer code.
2. The party marker is 2 bytes of `wPokemonData`'s padding, not an event flag. It sits inside `wPokemonData`, so it
   is saved by every path that saves the party, including `SaveAfterLinkTrade`, which does not save the event flags.

**Bytes and banks.** Free space is from `TOTAL EMPTY` in `pokecrystal.map`, before → after:

| bank | Δ free | what |
|---|---|---|
| #1 ($01) | −12 | `Continue` / `NewGame` farcalls (`intro_menu.asm`) |
| #3 ($03) | −15 | catch: `PokeBallEffect` (`item_effects.asm`), `TryAddMonToParty` / `SendMonIntoBox` (`move_mon.asm`) copy the rolled bits |
| #5 ($05) | −40 | Day-Care / breeding temp-mon copies (`daycare.asm`, `breeding.asm`), `ErasePreviousSave` farcall (`save.asm`) |
| #13 ($0D) | +26 | Attract calls `GetEnemyMonGender` instead of building a TEMPMON inline |
| #15 ($0F) | +12 | the same in `core.asm` (HUD); `LoadEnemyMon`'s roll is one farcall |
| #19 ($13) | +33 | Poké Seer time-of-day code removed, minus the `SetCaughtData` / `SetBoxMonCaughtData` keep-and-clamp |
| #20 ($14) | −113 | `GetGender` explicit path, `GetEnemyMonGender`, `RollWildGender` (54 B), `CopyMonToTempMon` |
| #32 ($20) | −198 | `gender_migration.asm` ($6562-$6627, exactly 198 B) |
| #33 ($21) | −12 | printer and Hall of Fame temp-mon copies |
| #56 ($38) | −18 | Bill's PC temp-mon copies |
| SRAM 1 | −2 | `sGenderFieldMigrated` |
| WRAM | 0 | the 2-byte marker reuses existing padding (`ds 22` → marker + `ds 20`) |

Net ROM: −337 B. There is no new code in $01 or $0F beyond farcalls, and no SRAM or WRAM symbol moved. The
integrity suite's T0 compares all 11,417 SRAM/`wPlayerData`/`wPokemonData` symbols: 0 moved.

### Edge cases (deliberate, tested where marked)
- **Backup restore** (T4a). Both builds take the same path. An unmigrated backup party is migrated, and boxes already
  migrated keep their explicit bits, because their marker is set. A hybrid restore is tested too.
- **CHANGE BOX power cut, frames 130-160** (T4b). Frames 141-144 take the primary path and 145-152 the backup path.
  No cut forges an explicit gender, and in every cut battery the box marker is set.
- **Downgrade then upgrade** (T5). A GF2 save loads in an older build with no checksum failure; the older build has no
  explicit-gender code, so it shows DV genders (the harness prints that, it is not asserted: it cannot fail). Saving it there and coming back restores every explicit gender.
  - Not a bug, but a known limit: a Pokémon **caught while downgraded** gets the old build's time bits, and the
    markers are already set, so on return it reads as a fixed (stable, but arbitrary) gender. The release note says
    not to downgrade.
- **Same-ID new game over an unmigrated file** (corrected in GF3, review L1). The GF2 text said `ErasePreviousSave`
  sets the box marker. It does not always run: a New Game whose random trainer ID equals the existing save's
  (1 in 65,536) skips it (`save.asm` 181-207), so the old file's boxes, time bits and all, would stay unmarked and the
  next Continue would clear the new file's rolled box genders. GF3's `NewGameGenderField` (called from `NewGame`)
  sets the party marker and runs the **box half** of `MigrateGenderField`. On a marked battery that is a no-op. On an
  unmarked one it is the same in-place edit a Continue would make. Tested by `gf3_gender.py` L1.
- **Link trades**. The CaughtLevel byte travels with the struct. GF3 masks bits 7-6 of every incoming mon (see
  "GF3 findings").
- **Corrupt input** (T6):
  - bit 6 without bit 7 reads as unset (DV gender);
  - bit 7 on genderless, F0 or F100 is ignored;
  - garbage in either marker (`c700`, `005a`, `5ac7`, `ffff`, `c75b`, plus a random 20-byte tail) runs the pass and
    gives DV genders;
  - only one of the two markers set migrates only the other container.
- **Hall of Fame** stays DV-derived until GF3 adds the bit (ruling 3, option (b)).

### RNG (F5: does the gender roll correlate with shininess?)

**Short answer: no, gender does not correlate with shininess, and it never did. But the first version of the
roll had a different flaw, which F5 found, so the shipped roll is a fixed version.**

**Method.** The ROUTE 12 SNORLAX reload hunt from RN3 (`scripts/rn1_reset_dvs.py`; SNORLAX is F12_5).
- Each "DIV phase" `k` presses A `k` frames later.
- At each phase, all 65,536 `(hRandomAdd, hRandomSub)` seeds are set at the frame before the DV roll. For each seed
  the harness records the DVs and the byte `RollWildGender` stores. The roll lands one frame after the DVs, because
  `LoadEnemyMon` spans a VBlank.
- A roll has to be fair on **two** axes, not just on average:
  1. over seeds at one button timing (the hunter presses on the same frame, the RNG state differs);
  2. over timings at one seed (the RNG state is fixed, the press drifts by a frame or two).

**First roll: `r` = `Random`'s return value (`hRandomSub`).** Its average was right and it showed no shiny
correlation. Over phases 0-3 × 65,536 seeds:
- 33 shiny seeds, 6 of them female (4.5 ± 2.0 expected);
- the DV-nibble chi-square p-values were 0.97 / 0.72 / 0.46 / 0.98.

It still failed both axes. The DV roll a frame earlier had already consumed the RNG state, so at a fixed phase
`hRandomSub` took only a few values in its top 3 bits, whatever the seed.
- Phases 0-3 gave 0.118 / 0.049 / 0.250 / 0.125 female.
- In a 64-phase sweep, **8 of 64 phases could never roll a female** and others rolled 1/4.
- Per seed across 64 phases, 145 of 1,024 random seeds never rolled female. With fair coins, about 0.2 would be
  expected.
- F50 and F75 species swung the same way, from 25% to 70% female depending on the frame.

**Candidates, scored offline.** Raw `(b, c, roll, hRandomAdd, hRandomSub)` were captured at
`RollWildGender.store` for 64 phases × 1,536 seeds: 1,024 random seeds plus `add` ∈ {$00, $AA} × all 256 `sub`.
Binomial sd is 0.010 per phase and 0.041 per seed.

| roll byte `r` | per-phase rate (axis 1): min-max, sd | per-seed rate over 64 phases (axis 2): sd, seeds never female | DV-nibble p (Atk/Def/Spd/Spc) |
|---|---|---|---|
| `sub` (first roll) | 0.000-0.238, 0.073 | 0.081, 145/1024 | 0.40 / 0.21 / 0.079 / 0.44 |
| `add` | 0.027-0.203, 0.056 | 0.075, 110/1024 | 0.042 / 0.27 / 0.12 / 0.094 |
| `add xor sub` | 0.076-0.161, 0.026 | 0.111, 178/1024 | 0.02 / 0.45 / 0.033 / 0.0014 |
| `add + sub` | 0.126-0.133, 0.001 | 0.329, 870/1024 | 0.022 / 0.66 / 0.25 / 0.89 |
| `add - sub` | 0.075-0.167, 0.025 | 0.082, 128/1024 | 0.018 / 0.78 / 0.59 / 0.00016 |
| **`swap(sub) xor add`** | **0.104-0.157, 0.011** | **0.043, 0/1024** | **0.31 / 0.30 / 0.14 / 0.33** |

- `add + sub` is nearly conserved by `Random` (`add += DIV+carry`, `sub -= DIV+carry`). It is perfect on axis 1
  and blind to timing on axis 2, where 85% of seeds can never get a female.
- `swap(sub) xor add` is at binomial spread on both axes, and it stays there at F25, F50 and F75 too:
  - per-phase sd 0.011-0.012 against a binomial 0.014-0.016;
  - per-seed sd 0.053-0.055 against 0.054-0.062;
  - no seed always or never female.
- Why it works: the swapped low nibble of `sub` varies with each frame's `DIV`, and xor-ing in `add` decorrelates
  seeds. The cost is 6 more bytes in bank $14. (Corrected after the GF2 review: `RollWildGender` itself makes one
  `Random` call, so every wild encounter now advances the RNG once more than release BV did. The DVs drawn at a given
  timing are unchanged, because the roll comes after them; what can shift is the RNG state the next event sees.)

**Shipped roll, `swap(hRandomSub) xor hRandomAdd`, re-verified on the rebuilt ROM.** These numbers come from
`gf2_gender.py` (F5), not the offline capture:
- Full enumeration, phases 0-3 × 65,536 seeds: female 0.1246 / 0.1268 / 0.1249 / 0.1236, and 32,760/262,144 =
  0.1250 pooled. Every seed rolled an explicit gender.
- **Shiny seeds: 33, of which 3 are female** (4.1 ± 1.9 expected at 1/8). SPD/SPC = $AA seeds: 121/1,053 = 0.1149
  female against 0.1250 for the rest (z = −0.99).
- DV-nibble independence, chi-square over 16 values: p = Atk 0.013, Def 0.94, Spd 0.98, Spc 0.90, all above the 0.001
  bar.
  - The Atk value is the lowest of four tests. It is not a structural dependence: its per-value rates span only
    0.120-0.132.
- 64-phase sweep, 1,024 seeds per phase:
  - axis 1: per-phase rate 0.113-0.140 (mean 0.1270, sd 0.0072 against a binomial 0.0103), with no phase outside
    1/8 ± 1/16;
  - axis 2: per-seed rate across the 64 phases 0.016-0.297, sd 0.0452 against a binomial 0.0413, and **0 of 1,024
    seeds never roll female** (0.2 expected).

The brief's criterion was "fix the roll if it correlates with shininess". The roll never correlated with shininess.
It was changed anyway because the first roll made a female shiny unreachable at some timings. On a cartridge, the
frame you press on is the hunt, so that was a real flaw.

### Harness (context repo; `tools/venv/bin/python`)
- `scripts/gf2_gender.py`. Each check prints PASS/FAIL, and the script exits 0 only if all pass. It covers:
  - F1: a BU-era Continue;
  - F2: at least 256 wild F12_5 encounters, plus MASTER BALL catches against the opposite DVs and a Lv70 catch into
    `sBox`;
  - F3: the real Lv70 MEWTWO;
  - F4: hatching;
  - F5: the RNG enumeration and the two-axis phase sweep above.
- `scripts/gf2_save_integrity.py` (T0-T6) runs OLD (ea5a211) against NEW on the 58 presets and 3 stress fixtures of
  290 Pokémon each.
  - The stress fixtures cover every caught-time pattern, a full party with an egg, the Day-Care, the egg and contest
    Pokémon, and all 15 boxes.
  - Both builds are pinned to the same frame at `DelayFrame` after `JumpRoamMons`, and the pin zeroes the RNG, DIV,
    the clock and the dead stack. After that, the two builds' RAM differs only in GF2 bytes, so any other SRAM
    difference after a SAVE is a real finding, not timing noise.
  - The classifier is strict. A byte may differ only if it is:
    - a CaughtLevel byte whose bits 7-6 were cleared (bits 5-0 identical);
    - one of the 2 marker bytes, holding exactly the magic;
    - a checksum that is valid for its data.
  - The primary and backup regions are both checked.
- `scripts/gf2_lib.py` holds the shared helpers. `scripts/dex_obtainability.py` still reports 251/251.

### Deferred to GF3
- The tutorial PIKACHU roll, copied to the starter (ruling 1).
- Gift Pokémon (GivePoke), `GiveEgg`, the Odd Egg (ruling 2), and the Day-Care egg roll at egg creation.
- Roamers: they need a stored roll.
- The Hall of Fame female bit (ruling 3, option (b)).
- Masking incoming link and Time Capsule Pokémon.
- The web editor and hunt tracker (§5.5).

Until GF3, every one of these is **unset**, so it keeps the DV gender it would have had before GF2. Nothing breaks.

### Save compatibility statement

**A save from build ≤ f6a731c loads in GF2, and every Pokémon's gender is unchanged.** After Continue and a SAVE, the
battery is byte-identical to the same file saved by the old build, except for:

1. the CaughtLevel bytes of Pokémon caught in the DAY or NITE (and MORN, `%01`): bits 7-6 cleared, level bits
   identical;
2. the 2-byte box marker at `sGenderFieldMigrated` (SRAM bank 1, `$BE58`);
3. the 2-byte party marker inside `sPokemonData`, in primary and backup;
4. the two save checksums that cover it, in primary and backup.

`scripts/gf2_save_integrity.py`:

```
PASS  T0 11417 SRAM/wPlayerData/wPokemonData symbols: 0 moved or removed
PASS  T0 base gender ratios identical in OLD and NEW (251 species)
PASS  T1 58/58 presets: 116 bytes differ NEW vs OLD after Continue, 684 after Continue+SAVE; + 3/3 stress fixtures: 797 / 1437 in all; all classified  -- 0 unclassified
PASS  T2 1012 mons: OLD GetGender before == NEW GetGender after == DV rule  -- 0 mismatches
PASS  T3 61 files: 2nd and 3rd Continue change 0 bytes (box pass 0x, WRAM party pass re-runs since unsaved), Continue of the NEW-saved file changes 0 bytes and runs 0 passes, re-SAVE leaves every CaughtLevel/marker byte as is  -- 0 files failed
PASS  T4a(i) unmigrated save, primary checksum broken: both builds restore the backup; 310 genders OLD==NEW; saved diff 251 bytes, all classified; markers set  -- path old=backup new=backup bad=[] unc=[] markers=((199, 90), (199, 90, 199, 90, 199, 90))
PASS  T4a(ii) hybrid restore (migrated boxes + explicit box3/1, unmigrated backup party): 310 genders as expected (explicit kept, legacy party = DV), passes(box,party)=(0, 1)  -- path=backup bad=[] marker=(199, 90)
PASS  T4b 31 power cuts (frames 130-160): no forged explicit gender, every RATTATA copy explicit F, every other mon = DV gender, box marker set in every cut battery, no pass re-run
PASS  T5a NEW save with 4 explicit-gender catches loads in the OLD build: path=primary (no checksum failure), OLD shows the DV genders  -- ok=True bad=[] expl=['box1/1', 'party2', 'party3', 'sBox/1']
PASS  T5b saved again in OLD, reloaded in NEW: explicit bytes unchanged by OLD, 4 explicit genders back (box1/1=F,party2=F,party3=M,sBox/1=F), all other mons as in OLD, no migration pass  -- changed=[] bad=[] others=[] passes=(0, 0)
PASS  T6 (a) bit 6 set, bit 7 clear on 320 bytes of a migrated file -> DV gender: 310 mons checked, Continue+SAVE+Continue ok, passes(box,party)=(0, 0)
PASS  T6 (b) bit 7 set on 135 genderless/F0/F100 mons -> fixed gender: 310 mons checked, Continue+SAVE+Continue ok, passes(box,party)=(0, 0)
PASS  T6 (c) garbage markers c700 + random 20-byte tail on an unmigrated file -> DV gender: 310 mons checked, Continue+SAVE+Continue ok, passes(box,party)=(15, 1)
PASS  T6 (c) garbage markers 005a + random 20-byte tail on an unmigrated file -> DV gender: 310 mons checked, Continue+SAVE+Continue ok, passes(box,party)=(15, 1)
PASS  T6 (c) garbage markers 5ac7 + random 20-byte tail on an unmigrated file -> DV gender: 310 mons checked, Continue+SAVE+Continue ok, passes(box,party)=(15, 1)
PASS  T6 (c) garbage markers ffff + random 20-byte tail on an unmigrated file -> DV gender: 310 mons checked, Continue+SAVE+Continue ok, passes(box,party)=(15, 1)
PASS  T6 (c) garbage markers c75b + random 20-byte tail on an unmigrated file -> DV gender: 310 mons checked, Continue+SAVE+Continue ok, passes(box,party)=(15, 1)
PASS  T6 (d1) party marker set + explicit party bits, legacy boxes + no box marker: 310 mons checked, Continue+SAVE+Continue ok, passes(box,party)=(15, 0)
PASS  T6 (d2) box marker set + explicit box bits, legacy party + no party marker: 310 mons checked, Continue+SAVE+Continue ok, passes(box,party)=(0, 1)
SUMMARY 19/19 checks passed (102 s)
```

Per preset, a Continue alone changes 2 bytes, the box marker, because the box pass edits the battery in place. A
Continue plus SAVE changes 10-16 bytes:
- the party marker and the `sGameData` checksum, ×2 each for primary and backup;
- the box marker;
- 2 bytes per party or Day-Care Pokémon caught in the DAY or NITE, primary and backup.

The 116 / 684 totals are over all 58 presets. The three 290-Pokémon stress fixtures add the rest of the
797 / 1437. Every one of those bytes is classified.


---

## GF3 findings (implemented 2026-10-15, on top of pyrite e4cf41a)

GF3 gives every remaining generation point a real gender. It also folds in the GF2 review's fixes (context repo
`docs/REVIEW-GF2.md`: L1-L4, M1 and the harness items). The rules are unchanged from GF2:
- `%10` is explicit male, `%11` explicit female, and anything else means "from the DVs";
- the roll is `RollWildGender`'s, `swap(Random) xor hRandomAdd` against the species' ratio;
- genderless, F0 and F100 species never get bits, because the species decides.

### Per site

| site | what happens now | where |
|---|---|---|
| GivePoke gifts (party or box) | rolled before the caught data, so the nickname prompt already shows it. The level part is as before (12 for a party gift in the test, 20 for the boxed EEVEE). | `SetGivenPartyMonCaughtData`, `SetGivenBoxMonCaughtData`, `GivenMonGenderBits` (`caught_data.asm`), called from `move_mon.asm` |
| GiveShuckle and the other `SetGift*CaughtData` gifts | rolled, with the level left at 0 ("unknown") as for every gift | `SetGiftPartyMonCaughtDataRolled`, `SetGiftBoxMonCaughtDataRolled` |
| **Starter PIKACHU** | gets **the gender of the PIKACHU Oak catches** in the tutorial. The tutorial battle now rolls like a wild one (`mon_stats.asm` `.roll`). `OakCatchTutorial` stores the roll in `wPK1StarterGender` next to the DVs PK1 already keeps. `PK1_StarterDVsOrRandom` leaves the state byte at `PK1_STARTER_GENDER_PENDING` once it has used the DVs. `GivenMonGenderBits` then hands that roll to the OAK'S LAB gift and clears the state, so it fires once. | `catch_tutorial.asm`, `move_mon.asm`, `caught_data.asm`; `wPK1StarterGender` at WRAM0 `$CFDB` (free tail, unsaved, like the PK1 DVs) |
| `giveegg` (TOGEPI) | the egg rolls when it is given; hatching keeps the bits (GF2 F4) | `GiveEggGender` |
| Odd Egg | rolls only the bits. The table's DVs, and so its shininess odds, are kept. | `OddEggGender`, `odd_egg.asm` |
| Day-Care egg | **rolled first**. The stored gender, not the fresh DVs, then picks which parent donates the DEF/SPC DVs, so an egg whose own DVs say the other gender inherits correctly. The Nidoran line keeps the species rule (NIDORAN F or M, no bits). | `DayCareEggGender`, `daycare.asm` |
| Red GYARADOS (forced shiny) | rolls like any wild mon; the shiny DVs `$EAAA` are kept | GF2's `RollWildGender`, verified in D |
| Bug Contest catch | keeps its rolled bits. `GeneratePartyMonStats` copies the battle roll, and `SetCaughtData` keeps an explicit gender. | by inspection (GF2 path) |
| Roamers | nothing needed: each encounter rolls in `LoadEnemyMon` | |
| Link trade / Time Capsule receive (review L2) | bits 7-6 of the incoming mon are **masked to `%00`** right before `AddTempmonToParty`, so a vanilla Gen 2 partner's time of day is never read as a gender. The Time Capsule uses the same receive path. | `link.asm` |
| Link / Battle Tower battle HUD and Attract (review L3) | `LinkEnemyMonGender` puts the OT mon's explicit gender (or `%00`) into `wEnemyMonStatus + 1`, so a pyrite opponent's mon has the same gender on both Game Boys. Battle Tower data has 0 there, so it uses the DVs. | `core.asm` (InitEnemyMon), `caught_data.asm` |
| New Game (review L1) | `NewGameGenderField` sets the party marker and runs the **box half** of `MigrateGenderField`. This covers the 1-in-65,536 same-ID New Game that skips `ErasePreviousSave` (see the corrected edge case above). | `gender_migration.asm`, `intro_menu.asm` |

### Hall of Fame bit (ruling 3, option (b), refined)

`hof_mon` has no gender byte, so bit 7 of its level byte carries it. It is a **flip** bit, not a "female" bit: it is
set only for a mixed-ratio mon whose explicit gender is the **opposite** of what its DVs give
(`HOF_GenderFlipBit`). On display, `HOF_DecodeLevelGender` strips the bit from the level and turns it back into an
explicit gender for `GetGender`. The reason for the flip encoding: a plain "female" bit cannot store an explicit
male whose DVs say female. With the flip encoding, every entry written before GF3 (bit clear) still means "as the
DVs say", which is exactly what it always showed. A level of 128 or more never occurs legitimately.

### A real bug the harness found: `farcall` does not return `a`

The first Day-Care hook did `farcall GenderBitsForCurPartySpecies` and stored `a`. `ReturnFarCall` reloads `a`, so
the egg got a garbage CaughtLevel (`$20`). The gf3 harness caught it in C. The fix is the bank-local wrapper
`DayCareEggGender`, which writes the result to `wTempMonCaughtLevel`/`wEggMonCaughtLevel` itself. Every other GF3
farcall site was audited: none uses `a` after the call (GiveEgg's `and a` only clears carry).

### Web (`hack/web/`)

- `gen_tables.py`: `tables.json` gains
  - `hunt.wEnemyMonGender` (= `wEnemyMonStatus + 1`);
  - `genderField` {explicit, female, bits, levelMask, magic};
  - the fields `wGenderFieldMigrated` and the Day-Care, egg and contest CaughtLevel bytes.
- `edit.js` (save editor):
  - a **Gender** field on each party card. Mixed ratio: ♂ / ♀ / "as DVs (♂ or ♀)". Fixed ratio: read-only.
  - `newMon` rolls a gender as a gift does.
  - On load it runs **the party half of the migration** on an unmigrated save: clear bits 7-6 of the 6 party
    structs, Day-Care, egg and contest mon, and set the marker. Without that, the next Continue would wipe a gender
    set in the editor, and legacy time bits would be shown as genders.
  - The boxes are left to the game.
- `app.js` (hunt tracker):
  - reads the gender byte with the enemy struct;
  - `genderOf(species, dv, gbits)` prefers an explicit gender;
  - the byte is appended as a 7th log column, so older records and the IndexedDB/localStorage keys and formats are
    unchanged and still use the DV rule.
- Checks:
  - `web_offline_check.py` 39 PASS / 0 FAIL;
  - `web_layout_check.py` unchanged (scale 5/7/2/2, no pill overlap);
  - `kfDebug.hunt.gender` spot checks (context repo `docs/WEB-HUNT.md`).
  - `scripts/gf3_web_editor_check.py`:

```
PASS  unmigrated preset (party CaughtLevel ['85', '85', '00']): no legacy time bits shown as a gender, every mixed-ratio selector reads 'as DVs'  -- [{"sel": "", "opts": ["♂ male", "♀ female", "as DVs (♀)"]}, {"sel": "", "opts": ["♂ male", "♀ female", "as DVs (♂)"]}, {"sel": "", "opts": ["♂ male", "♀ female", "as DVs (♂)"]}]
PASS  party1 (species 25, DVs say F) set explicit M against its DVs in the editor: download Continues on the primary copy, CaughtLevel $85 after Continue, party marker C7 5A in both copies  -- path=primary
PASS  party1 (species 25, DVs say F) set explicit F same as its DVs in the editor: download Continues on the primary copy, CaughtLevel $c5 after Continue, party marker C7 5A in both copies  -- path=primary
SUMMARY 3/3 checks passed
```

### Harness (context repo)

`scripts/gf3_gender.py`, parts A-F plus L1 (`tools/venv/bin/python scripts/gf3_gender.py`):

```
PASS  A 1024 GenderBitsForCurPartySpecies rolls (via DayCareEggGender), BULBASAUR F12_5: only $80/$C0, female 103/1024 (expected 128.0 +- 10.6, 3 sigma)  -- others=[] (0s)
PASS  A 1024 GenderBitsForCurPartySpecies rolls (via DayCareEggGender), PIKACHU F50: only $80/$C0, female 505/1024 (expected 512.0 +- 16.0, 3 sigma)  -- others=[] (0s)
PASS  A genderless/F0/F100 species (MAGNEMITE, HITMONLEE, CHANSEY, NIDORAN F/M) roll %00 (species decides)  -- {81: {0}, 106: {0}, 113: {0}, 29: {0}, 32: {0}}
PASS  A 24 real GivePoke gifts into the party (PIKACHU, EEVEE, MAGNEMITE, CHANSEY): mixed-ratio ones explicit (both genders seen), fixed ones %00, CaughtLevel level = 12, GetGender = the bits
PASS  A GivePoke with a full party -> sBox: EEVEE, CaughtLevel $94 (explicit M, level 20)  -- sBox 0->1 sp=133
PASS  A GiveShuckle x8: CaughtLevel $80/$C0 only (explicit, gift level 0), both seen: $c0 $80 $c0 $c0 $80 $80 $80 $80
PASS  A SetGiftBoxMonCaughtDataRolled x8 (EEVEE): sBoxMon1 CaughtLevel $80/$C0 only: $80 $c0 $80 $80 $80 $80 $80 $80
PASS  B 5 new intros: the OAK'S LAB PIKACHU's gender bits == the tutorial PIKACHU's roll (forced F over male DVs, forced M over female DVs, 3 unforced), DVs copied, stash state cleared
PASS  C GiveEgg TOGEPI x8: an EGG, explicit bits (both genders seen), level part kept: $80 $80 $80 $80 $c0 $80 $80 $80
PASS  C 40 Odd Eggs (5 species): DVs kept from the table, level part kept, mixed-ratio species explicit, F0/F100 %00
PASS  C 48 Day-Care eggs (PIKACHU M x F, both slot orders): PICHU, explicit bits (26 F / 22 M), DEF/SPC DVs from the opposite-gender parent of the STORED gender, incl. the 27 eggs whose own DVs say the other gender
PASS  C NIDORAN Day-Care eggs x8: NIDORAN F and M both seen, gender bits %00 (the species decides)  -- [(29, 0), (29, 0), (32, 0), (32, 0), (29, 0), (29, 0), (32, 0), (29, 0)]
PASS  D 32 forced-shiny GYARADOS encounters: explicit roll every time, both genders (16 F), shiny DVs $EAAA kept
PASS  E LinkEnemyMonGender: OT CaughtLevel -> wEnemyMonStatus+1 $c5->$c0 $85->$80 $45->$00 $05->$00 $ff->$c0 $3f->$00
PASS  E LinkTrade masks the received mon's CaughtLevel (ld a,[wTempMonCaughtLevel] / and $3F / ld) right before predef AddTempmonToParty (also the Time Capsule's receive path): at ['0a:4e0b']  -- hits=[167435]
PASS  F 6 HoF entries: flip bit set only for the 2 explicit-vs-DV mismatches, level and gender round-trip (GetGender TEMPMON after HOF_DecodeLevelGender == party GetGender)
PASS  F pre-GF3 HoF entries (bit 7 clear) decode to the DV gender, level kept: [('M', 'M', 55), ('F', 'F', 55), ('F', 'F', 55)]
PASS  L1 NEW GAME over an unmigrated battery: NewGameGenderField ran once, box pass 15x, 0 box CaughtLevel bytes with bits 7-6 left, box marker set, the old file's game data (primary + backup) untouched  -- hits={'NewGameGenderField': 1, 'MigrateGenderField.ClearBox': 15, 'ErasePreviousSave': 0} left=0 marker=(199, 90) same=True
PASS  L1 same-ID SAVE (no ErasePreviousSave) then Continue: no migration pass, a box-3 mon (species 67) keeps its explicit F against its DVs  -- erase=0 hits={'MigrateGenderField.ClearBox': 0, 'SetGenderFieldPartyMarker': 0} caught=$c7 G=F
SUMMARY 19/19 checks passed (9 s)
```

`scripts/gf2_gender.py --skip-f5 --n 512` (F1-F4, regression on the GF3 ROM):

```
PASS  F1 310 mons (party, Day-Care, egg, contest, sBox, 14 boxes): GetGender after Continue == the DV rule  -- 0 mismatches []
PASS  F1 box bytes (sBox + 14 boxes, 16530 B): 300 differ, all CaughtLevel bytes with only bits 7-6 cleared  -- 0 others []
PASS  F1 2nd Continue of the migrated battery: 0 bytes change, box pass not re-run  -- diff=0 hits={'MigrateGenderField.ClearBox': 0}
PASS  F2 512 wild BULBASAUR: explicit bit set on every roll ($80/$C0 only)  -- explicit=512 unset-path=0
PASS  F2 female 44/512 = 0.0859 (expected 64.0 +- 7.5, i.e. 32/256 = 1/8; within 3 sigma)
PASS  F2 MASTER BALL catches keep the rolled gender over the DVs: forced F (DVs say M) -> party2 caught $c4 GetGender F; forced M (DVs say F) -> party3 caught $84 GetGender M
PASS  F2 Lv70 CHARMANDER forced F with a full party -> sBox/1 caught byte $ff (= explicit F + level 63)  -- {'where': 'sBox/1', 'caught': 255, 'rolled': 192, 'species': 4}
PASS  F3 Lv70 MEWTWO caught -> party2: CaughtLevel byte $3f = level 63, gender bits %00 (genderless, roll unset $00)  -- species=150
PASS  F4 4 eggs hatched (explicit F, explicit M, 2 unset): gender bits kept, level byte = 1, GetGender = the stored bits (explicit) or the DVs (unset)
SUMMARY 9/9 checks passed (15 s)
```

`scripts/gf2_save_integrity.py`, full, on the final GF2+GF3 ROM. Changes from the GF2 run:
- **M1**: the 3 stress fixtures are generated deterministically by the script (`gf2_lib.stress_fixture`, seeds
  1-3, sha256 printed). Each fills sBox and all 14 boxes (300 boxed), sets legacy time bits in every live slot,
  covers all 7 ratio classes, and has both markers absent.
- **T4c** is new: power cuts during the first SAVE after migrating an old file, and during the box pass itself.
- **T5a**: the old build's DV display is now printed rather than claimed.
- **T4b and T5a** count the starter's legitimate explicit gender. The first full run on the GF3 ROM failed both,
  22/24: the regenerated playtest states now carry the GF3 starter's copied gender. The tests were wrong, not the
  ROM.

```
PASS  T0 11417 SRAM/wPlayerData/wPokemonData symbols: 0 moved or removed
PASS  T0 base gender ratios identical in OLD and NEW (251 species)
PASS  M1 stress_kanto_complete: sBox + 14 boxes full (300 boxed), 320/320 live mons with legacy time bits (patterns [1, 2, 3]), ratio classes 00:45/1F:47/3F:47/7F:46/BF:45/FE:45/FF:45, markers party/backup/box ((0, 0), (0, 0), (255, 255))  -- box counts [20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20]
PASS  M1 stress_johto_complete: sBox + 14 boxes full (300 boxed), 320/320 live mons with legacy time bits (patterns [1, 2, 3]), ratio classes 00:45/1F:47/3F:47/7F:46/BF:45/FE:45/FF:45, markers party/backup/box ((0, 0), (0, 0), (255, 255))  -- box counts [20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20]
PASS  M1 stress_pallet: sBox + 14 boxes full (300 boxed), 320/320 live mons with legacy time bits (patterns [1, 2, 3]), ratio classes 00:45/1F:47/3F:47/7F:46/BF:45/FE:45/FF:45, markers party/backup/box ((0, 0), (0, 0), (255, 255))  -- box counts [20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20]
PASS  T1 58/58 presets: 116 bytes differ NEW vs OLD after Continue, 684 after Continue+SAVE; + 3/3 stress fixtures: 1022 / 1674 in all; all classified  -- 0 unclassified
PASS  T2 1012 mons: OLD GetGender before == NEW GetGender after == DV rule  -- 0 mismatches
PASS  T3 61 files: 2nd and 3rd Continue change 0 bytes (box pass 0x, WRAM party pass re-runs since unsaved), Continue of the NEW-saved file changes 0 bytes and runs 0 passes, re-SAVE leaves every CaughtLevel/marker byte as is  -- 0 files failed
PASS  T4a(i) unmigrated save, primary checksum broken: both builds restore the backup; 310 genders OLD==NEW; saved diff 330 bytes, all classified; markers set  -- path old=backup new=backup bad=[] unc=[] markers=((199, 90), (199, 90, 199, 90, 199, 90))
PASS  T4a(ii) hybrid restore (migrated boxes + explicit box3/1, unmigrated backup party): 310 genders as expected (explicit kept, legacy party = DV), passes(box,party)=(0, 1)  -- path=backup bad=[] marker=(199, 90)
PASS  T4b 31 power cuts (frames 130-160): no forged explicit gender, every RATTATA copy explicit F, the starter keeps its copied gender (1), every other mon = DV gender, box marker set in every cut battery, no pass re-run
PASS  T4c(i) 13 power cuts during the first SAVE after migrating a legacy file (entry of every _SaveGameData step + after): every cut Continues, every mon = DV gender, no gender bits survive, box marker set, box pass never re-runs, party marker set
PASS  T4c(ii) 12 power cuts inside Continue's box pass (sBox, boxes 1/4/7/14, before the marker): the next Continue re-runs the box pass (15 boxes), every mon = DV gender, and the battery is byte-identical to a clean migration's
PASS  T5a NEW save with 5 explicit-gender mons (catches party2, party3, sBox/1 + its box copy; starter party1) loads in the OLD build: path=primary (no checksum failure)  -- ok=True expl=['box1/1', 'party1', 'party2', 'party3', 'sBox/1']
PASS  T5b saved again in OLD, reloaded in NEW: explicit bytes unchanged by OLD, 5 explicit genders back (box1/1=F,party1=M,party2=F,party3=M,sBox/1=F), all other mons as in OLD, no migration pass  -- changed=[] bad=[] others=[] passes=(0, 0)
PASS  T6 (a) bit 6 set, bit 7 clear on 320 bytes of a migrated file -> DV gender: 310 mons checked, Continue+SAVE+Continue ok, passes(box,party)=(0, 0)
PASS  T6 (b) bit 7 set on 135 genderless/F0/F100 mons -> fixed gender: 310 mons checked, Continue+SAVE+Continue ok, passes(box,party)=(0, 0)
PASS  T6 (c) garbage markers c700 + random 20-byte tail on an unmigrated file -> DV gender: 310 mons checked, Continue+SAVE+Continue ok, passes(box,party)=(15, 1)
PASS  T6 (c) garbage markers 005a + random 20-byte tail on an unmigrated file -> DV gender: 310 mons checked, Continue+SAVE+Continue ok, passes(box,party)=(15, 1)
PASS  T6 (c) garbage markers 5ac7 + random 20-byte tail on an unmigrated file -> DV gender: 310 mons checked, Continue+SAVE+Continue ok, passes(box,party)=(15, 1)
PASS  T6 (c) garbage markers ffff + random 20-byte tail on an unmigrated file -> DV gender: 310 mons checked, Continue+SAVE+Continue ok, passes(box,party)=(15, 1)
PASS  T6 (c) garbage markers c75b + random 20-byte tail on an unmigrated file -> DV gender: 310 mons checked, Continue+SAVE+Continue ok, passes(box,party)=(15, 1)
PASS  T6 (d1) party marker set + explicit party bits, legacy boxes + no box marker: 310 mons checked, Continue+SAVE+Continue ok, passes(box,party)=(15, 0)
PASS  T6 (d2) box marker set + explicit box bits, legacy party + no party marker: 310 mons checked, Continue+SAVE+Continue ok, passes(box,party)=(0, 1)
SUMMARY 24/24 checks passed (109 s)
```

`scripts/dex_obtainability.py`: obtainable 251/251. `make -C hack crystal` builds clean. `scripts/gen_states.sh`
completed with 0 FAIL on every chain (`m11_chain` 375 ok; `kanto_complete -> johto_complete` PASS).

### Bank deltas (bytes used, against e4cf41a)

| bank | Δ | free before → after | what |
|---|---|---|---|
| $03 | +7 | $199 → $192 | `GiveEgg` hook (GivePoke's swaps are size-neutral) |
| $05 | +4 | $133 → $12F | Day-Care egg hook |
| $0A | +8 | $19E → $196 | link receive mask |
| $0F | +6 | $7F → $79 | one `farcall LinkEnemyMonGender` in `InitEnemyMon` (a farcall only, no code) |
| $13 | +216 | $537 → $45F | `caught_data.asm` routines |
| $20 | +6 | $19D8 → $19D2 | `NewGameGenderField` (`gender_migration.asm`) |
| $21 | +130 | $168B → $1609 | Hall of Fame bit |
| $7E | +6 | $758 → $752 | Odd Egg hook |

$01 is unchanged: the GiveShuckle and NewGame call sites swap one farcall target for another. `layout.link` is unchanged.

### Save compatibility

**Existing saves keep working, and no Pokémon changes gender on update.**
- `T0`: 0 of 11,417 SRAM/`wPlayerData`/`wPokemonData` symbols moved. The only new RAM is `wPK1StarterGender`, in
  free WRAM0 that is not saved.
- No event flag, map object, warp or map-event block changed.
- A GF2 or older save Continues exactly as under GF2: T1-T6 and M1 pass with 0 unclassified bytes.
- The GF3 sites only act on Pokémon created after the update.
- Hall of Fame entries written before GF3 decode to their old level and DV gender (gf3 F).
- A GF3 save still loads in an older build (T5a), and its explicit genders come back on return (T5b). The "don't
  downgrade" note from GF2 still applies.

### Deferred / known limits
- **Pyrite-to-pyrite trades** lose a rolled gender: the receiver masks it, because a vanilla partner cannot be told
  apart. Link battles do show it (`LinkEnemyMonGender`).
- **Mixed-build link battles**: a vanilla Gen 2 opponent's time bits read as an explicit gender on the pyrite side's
  HUD. This is cosmetic and nobody links this ROM today. Outgoing pyrite mons look like a time of day to a vanilla
  partner's Poké Seer.
- **NPC in-game trades** keep their DV gender (`npc_trade.asm` still uses `SetGiftPartyMonCaughtData`). Their OT
  gender tables already fix what the player sees.
- **Mobile paths** (Battle Tower uploads, mobile trades) were not touched.
- The **save editor** edits only the party. Boxes are migrated by the game's next Continue.
