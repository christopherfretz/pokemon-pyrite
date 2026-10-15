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
   Pikachu seen in Oak's tutorial battle is the one handed over, as in Yellow. Default; the operator has not objected.
2. **Odd Egg and red GYARADOS both roll** (operator: "why would they not roll?").
3. **Hall of Fame: option (b)** — bit 7 of the HoF entry's Level byte = "female, explicit", masked on display.
4. **Poké Seer loss accepted** ("much better than any of the alternatives").

Status: research only. GF2/GF3 are NOT scheduled; the operator and Jonathan will pick a between-hunts window first.
