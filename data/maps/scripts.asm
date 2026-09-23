SECTION "Map Scripts 1", ROMX

INCLUDE "maps/GoldenrodGym.asm"
INCLUDE "maps/GoldenrodBikeShop.asm"
INCLUDE "maps/GoldenrodHappinessRater.asm"
INCLUDE "maps/BillsFamilysHouse.asm"
INCLUDE "maps/GoldenrodMagnetTrainStation.asm"
INCLUDE "maps/GoldenrodFlowerShop.asm"
INCLUDE "maps/GoldenrodPPSpeechHouse.asm"
INCLUDE "maps/GoldenrodNameRater.asm"
INCLUDE "maps/GoldenrodDeptStore1F.asm"
INCLUDE "maps/GoldenrodDeptStore2F.asm"
INCLUDE "maps/GoldenrodDeptStore3F.asm"
INCLUDE "maps/GoldenrodDeptStore4F.asm"
INCLUDE "maps/GoldenrodDeptStore5F.asm"
INCLUDE "maps/GoldenrodDeptStore6F.asm"
INCLUDE "maps/GoldenrodDeptStoreElevator.asm"
INCLUDE "maps/GoldenrodDeptStoreRoof.asm"
INCLUDE "maps/GoldenrodGameCorner.asm"


SECTION "Map Scripts 2", ROMX

INCLUDE "maps/RuinsOfAlphOutside.asm"
INCLUDE "maps/RuinsOfAlphHoOhChamber.asm"
INCLUDE "maps/RuinsOfAlphKabutoChamber.asm"
INCLUDE "maps/RuinsOfAlphOmanyteChamber.asm"
INCLUDE "maps/RuinsOfAlphAerodactylChamber.asm"
INCLUDE "maps/RuinsOfAlphInnerChamber.asm"
INCLUDE "maps/RuinsOfAlphResearchCenter.asm"
INCLUDE "maps/RuinsOfAlphHoOhItemRoom.asm"
INCLUDE "maps/RuinsOfAlphKabutoItemRoom.asm"
INCLUDE "maps/RuinsOfAlphOmanyteItemRoom.asm"
INCLUDE "maps/RuinsOfAlphAerodactylItemRoom.asm"
INCLUDE "maps/RuinsOfAlphHoOhWordRoom.asm"
INCLUDE "maps/RuinsOfAlphKabutoWordRoom.asm"
INCLUDE "maps/RuinsOfAlphOmanyteWordRoom.asm"
INCLUDE "maps/RuinsOfAlphAerodactylWordRoom.asm"
INCLUDE "maps/UnionCave1F.asm"
INCLUDE "maps/UnionCaveB1F.asm"
INCLUDE "maps/UnionCaveB2F.asm"
INCLUDE "maps/SlowpokeWellB1F.asm"
INCLUDE "maps/SlowpokeWellB2F.asm"
INCLUDE "maps/OlivineLighthouse1F.asm"
INCLUDE "maps/OlivineLighthouse2F.asm"
INCLUDE "maps/OlivineLighthouse3F.asm"
INCLUDE "maps/OlivineLighthouse4F.asm"


SECTION "Map Scripts 3", ROMX

INCLUDE "maps/NationalPark.asm"
INCLUDE "maps/NationalParkBugContest.asm"
INCLUDE "maps/RadioTower1F.asm"
INCLUDE "maps/RadioTower2F.asm"
INCLUDE "maps/RadioTower3F.asm"
INCLUDE "maps/RadioTower4F.asm"


SECTION "Map Scripts 4", ROMX

INCLUDE "maps/RadioTower5F.asm"
INCLUDE "maps/OlivineLighthouse5F.asm"
INCLUDE "maps/OlivineLighthouse6F.asm"
INCLUDE "maps/GoldenrodPokecenter1F.asm"
INCLUDE "maps/PokecomCenterAdminOfficeMobile.asm"
INCLUDE "maps/IlexForestAzaleaGate.asm"
INCLUDE "maps/Route34IlexForestGate.asm"
INCLUDE "maps/DayCare.asm"


SECTION "Map Scripts 5", ROMX

INCLUDE "maps/Route11.asm"
INCLUDE "maps/VioletMart.asm"
INCLUDE "maps/VioletGym.asm"
INCLUDE "maps/EarlsPokemonAcademy.asm"
INCLUDE "maps/VioletNicknameSpeechHouse.asm"
INCLUDE "maps/VioletPokecenter1F.asm"
INCLUDE "maps/VioletKylesHouse.asm"
INCLUDE "maps/Route32RuinsOfAlphGate.asm"
INCLUDE "maps/Route32Pokecenter1F.asm"
INCLUDE "maps/Route35GoldenrodGate.asm"
INCLUDE "maps/Route35NationalParkGate.asm"
INCLUDE "maps/Route36RuinsOfAlphGate.asm"
INCLUDE "maps/Route36NationalParkGate.asm"


SECTION "Map Scripts 6", ROMX

INCLUDE "maps/Route8.asm"
INCLUDE "maps/MahoganyMart1F.asm"
INCLUDE "maps/TeamRocketBaseB1F.asm"
INCLUDE "maps/TeamRocketBaseB2F.asm"
INCLUDE "maps/TeamRocketBaseB3F.asm"
INCLUDE "maps/IlexForest.asm"


SECTION "Map Scripts 7", ROMX

; Kanto hack (M6 9o, docs/M6-CELADON.md D27): CELADON's indoor maps moved out
; of here into "Map Scripts 29" ($75), and the GAME CORNER pair into
; "Map Scripts 28" ($5b), to make room for ROCKET HIDEOUT.  What is left is
; LAKE OF RAGE plus the CELADON group's four route-side buildings.
INCLUDE "maps/LakeOfRage.asm"
INCLUDE "maps/Route16FuchsiaSpeechHouse.asm"
INCLUDE "maps/Route16Gate.asm"
INCLUDE "maps/Route7SaffronGate.asm"
INCLUDE "maps/Route17Route18Gate.asm"


SECTION "Map Scripts 8", ROMX

INCLUDE "maps/DiglettsCave.asm"
INCLUDE "maps/UndergroundPath.asm"
INCLUDE "maps/RockTunnel1F.asm"
INCLUDE "maps/RockTunnelB1F.asm"
; Kanto hack (docs/M5-LAVENDER.md, 8b): the two new Underground Path entrance
; rooms and the west-east corridor.
INCLUDE "maps/UndergroundPathWestEast.asm"
INCLUDE "maps/Route7UndergroundPathEntrance.asm"
INCLUDE "maps/Route8UndergroundPathEntrance.asm"
INCLUDE "maps/SafariZoneFuchsiaGateBeta.asm"
INCLUDE "maps/SafariZoneBeta.asm"
INCLUDE "maps/VictoryRoad1F.asm" ; M10 13f: Crystal's VictoryRoad re-cut to Yellow's 1F
INCLUDE "maps/OlivinePort.asm"
INCLUDE "maps/VermilionPort.asm"
INCLUDE "maps/FastShip1F.asm"
INCLUDE "maps/FastShipCabins_NNW_NNE_NE.asm"
INCLUDE "maps/FastShipCabins_SW_SSW_NW.asm"
INCLUDE "maps/FastShipCabins_SE_SSE_CaptainsCabin.asm"
INCLUDE "maps/FastShipB1F.asm"
INCLUDE "maps/OlivinePortPassage.asm"
INCLUDE "maps/TinTowerRoof.asm"


SECTION "Map Scripts 9", ROMX

INCLUDE "maps/Route34.asm"
INCLUDE "maps/ElmsLab.asm"
INCLUDE "maps/PlayersHouse1F.asm"
INCLUDE "maps/PlayersHouse2F.asm"
INCLUDE "maps/PlayersNeighborsHouse.asm"
INCLUDE "maps/ElmsHouse.asm"
INCLUDE "maps/Route26HealHouse.asm"
INCLUDE "maps/DayOfWeekSiblingsHouse.asm"
INCLUDE "maps/Route27SandstormHouse.asm"
INCLUDE "maps/Route29Route46Gate.asm"


SECTION "Map Scripts 10", ROMX

INCLUDE "maps/Route22.asm"
INCLUDE "maps/GoldenrodUnderground.asm"
INCLUDE "maps/GoldenrodUndergroundSwitchRoomEntrances.asm"
INCLUDE "maps/GoldenrodDeptStoreB1F.asm"
INCLUDE "maps/GoldenrodUndergroundWarehouse.asm"
INCLUDE "maps/MountMortar1FOutside.asm"
INCLUDE "maps/MountMortar1FInside.asm"
INCLUDE "maps/MountMortar2FInside.asm"
INCLUDE "maps/MountMortarB1F.asm"
INCLUDE "maps/IcePath1F.asm"
INCLUDE "maps/IcePathB1F.asm"
INCLUDE "maps/IcePathB2FMahoganySide.asm"
INCLUDE "maps/IcePathB2FBlackthornSide.asm"
INCLUDE "maps/IcePathB3F.asm"
INCLUDE "maps/LavenderPokecenter1F.asm"
INCLUDE "maps/LavenderPokecenter2FBeta.asm"
INCLUDE "maps/MrFujisHouse.asm"
INCLUDE "maps/LavenderCuboneHouse.asm"
INCLUDE "maps/LavenderNameRater.asm"
INCLUDE "maps/LavenderMart.asm"
INCLUDE "maps/SoulHouse.asm"
INCLUDE "maps/PokemonTower1F.asm"
INCLUDE "maps/Route8SaffronGate.asm"
INCLUDE "maps/Route12SuperRodHouse.asm"


SECTION "Map Scripts 11", ROMX

INCLUDE "maps/EcruteakTinTowerEntrance.asm"
INCLUDE "maps/WiseTriosRoom.asm"
INCLUDE "maps/EcruteakPokecenter1F.asm"
INCLUDE "maps/EcruteakLugiaSpeechHouse.asm"
INCLUDE "maps/DanceTheater.asm"
INCLUDE "maps/EcruteakMart.asm"
INCLUDE "maps/EcruteakGym.asm"
INCLUDE "maps/EcruteakItemfinderHouse.asm"
INCLUDE "maps/ViridianNicknameSpeechHouse.asm"
INCLUDE "maps/TrainerHouse1F.asm"
INCLUDE "maps/TrainerHouseB1F.asm"
INCLUDE "maps/ViridianMart.asm"
INCLUDE "maps/ViridianPokecenter1F.asm"
INCLUDE "maps/ViridianPokecenter2FBeta.asm"
INCLUDE "maps/Route2NuggetHouse.asm"
INCLUDE "maps/Route2Gate.asm"
INCLUDE "maps/VictoryRoadGate.asm"


SECTION "Map Scripts 12", ROMX

INCLUDE "maps/OlivinePokecenter1F.asm"
INCLUDE "maps/OlivineGym.asm"
INCLUDE "maps/OlivineTimsHouse.asm"
INCLUDE "maps/OlivineHouseBeta.asm"
INCLUDE "maps/OlivinePunishmentSpeechHouse.asm"
INCLUDE "maps/OlivineGoodRodHouse.asm"
INCLUDE "maps/OlivineCafe.asm"
INCLUDE "maps/OlivineMart.asm"
INCLUDE "maps/Route38EcruteakGate.asm"
INCLUDE "maps/Route39Barn.asm"
INCLUDE "maps/Route39Farmhouse.asm"
INCLUDE "maps/ManiasHouse.asm"
INCLUDE "maps/CianwoodGym.asm"
INCLUDE "maps/CianwoodPokecenter1F.asm"
INCLUDE "maps/CianwoodPharmacy.asm"
INCLUDE "maps/CianwoodPhotoStudio.asm"
INCLUDE "maps/CianwoodLugiaSpeechHouse.asm"
INCLUDE "maps/PokeSeersHouse.asm"
INCLUDE "maps/BattleTower1F.asm"
INCLUDE "maps/BattleTowerBattleRoom.asm"
INCLUDE "maps/BattleTowerElevator.asm"
INCLUDE "maps/BattleTowerHallway.asm"
INCLUDE "maps/Route40BattleTowerGate.asm"
INCLUDE "maps/BattleTowerOutside.asm"


SECTION "Map Scripts 13", ROMX

INCLUDE "maps/IndigoPlateauPokecenter1F.asm"
INCLUDE "maps/LoreleisRoom.asm"
INCLUDE "maps/BrunosRoom.asm"
INCLUDE "maps/AgathasRoom.asm"
INCLUDE "maps/LancesRoom.asm"
INCLUDE "maps/ChampionsRoom.asm"
INCLUDE "maps/HallOfFame.asm"


SECTION "Map Scripts 14", ROMX

INCLUDE "maps/CeruleanCity.asm"
INCLUDE "maps/SproutTower1F.asm"
INCLUDE "maps/SproutTower2F.asm"
INCLUDE "maps/SproutTower3F.asm"
INCLUDE "maps/TinTower1F.asm"
INCLUDE "maps/TinTower2F.asm"
INCLUDE "maps/TinTower3F.asm"
INCLUDE "maps/TinTower4F.asm"
INCLUDE "maps/TinTower5F.asm"
INCLUDE "maps/TinTower6F.asm"
INCLUDE "maps/TinTower7F.asm"
INCLUDE "maps/TinTower8F.asm"
INCLUDE "maps/TinTower9F.asm"
INCLUDE "maps/BurnedTower1F.asm"
INCLUDE "maps/BurnedTowerB1F.asm"

; Kanto hack (docs/M6-TOWER.md, 9a / D21): POKéMON TOWER 2F-7F.  1F is in
; "Map Scripts 10" (only ~2.9 KB free); this is the largest free section, and
; the six floors' finished scripts are estimated at ~4.8 KB.  If it ever
; overflows, move PokemonTower7F.asm to "Map Scripts 24".
INCLUDE "maps/PokemonTower2F.asm"
INCLUDE "maps/PokemonTower3F.asm"
INCLUDE "maps/PokemonTower4F.asm"
INCLUDE "maps/PokemonTower5F.asm"
INCLUDE "maps/PokemonTower6F.asm"
INCLUDE "maps/PokemonTower7F.asm"


SECTION "Map Scripts 15", ROMX

INCLUDE "maps/CeruleanTrashedHouse.asm"
INCLUDE "maps/CeruleanMelaniesHouse.asm"
INCLUDE "maps/BikeShop.asm"
INCLUDE "maps/CeruleanPokecenter1F.asm"
INCLUDE "maps/CeruleanPokecenter2FBeta.asm"
INCLUDE "maps/CeruleanGym.asm"
INCLUDE "maps/CeruleanMart.asm"
INCLUDE "maps/Route10Pokecenter1F.asm"
INCLUDE "maps/Route10Pokecenter2FBeta.asm"
INCLUDE "maps/PowerPlant.asm"
INCLUDE "maps/BillsHouse.asm"
INCLUDE "maps/FightingDojo.asm"
INCLUDE "maps/SaffronGym.asm"
INCLUDE "maps/SaffronMart.asm"
INCLUDE "maps/SaffronPokecenter1F.asm"
INCLUDE "maps/SaffronPokecenter2FBeta.asm"
INCLUDE "maps/MrPsychicsHouse.asm"
INCLUDE "maps/SaffronPidgeyHouse.asm"
INCLUDE "maps/SilphCo1F.asm"
INCLUDE "maps/CopycatsHouse1F.asm"
INCLUDE "maps/CopycatsHouse2F.asm"
INCLUDE "maps/Route5UndergroundPathEntrance.asm"
INCLUDE "maps/Route5SaffronGate.asm"
INCLUDE "maps/Route5DayCare.asm"


SECTION "Map Scripts 16", ROMX

INCLUDE "maps/PewterCity.asm"
INCLUDE "maps/WhirlIslandNW.asm"
INCLUDE "maps/WhirlIslandNE.asm"
INCLUDE "maps/WhirlIslandSW.asm"
INCLUDE "maps/WhirlIslandCave.asm"
INCLUDE "maps/WhirlIslandSE.asm"
INCLUDE "maps/WhirlIslandB1F.asm"
INCLUDE "maps/WhirlIslandB2F.asm"
INCLUDE "maps/WhirlIslandLugiaChamber.asm"
INCLUDE "maps/SilverCaveRoom1.asm"
INCLUDE "maps/SilverCaveRoom2.asm"
INCLUDE "maps/SilverCaveRoom3.asm"
INCLUDE "maps/SilverCaveItemRooms.asm"
INCLUDE "maps/DarkCaveVioletEntrance.asm"
INCLUDE "maps/DarkCaveBlackthornEntrance.asm"
INCLUDE "maps/DragonsDen1F.asm"
INCLUDE "maps/DragonsDenB1F.asm"
INCLUDE "maps/DragonShrine.asm"
INCLUDE "maps/TohjoFalls.asm"
INCLUDE "maps/AzaleaPokecenter1F.asm"
INCLUDE "maps/CharcoalKiln.asm"
INCLUDE "maps/AzaleaMart.asm"
INCLUDE "maps/KurtsHouse.asm"
INCLUDE "maps/AzaleaGym.asm"


SECTION "Map Scripts 17", ROMX

INCLUDE "maps/MahoganyTown.asm"
INCLUDE "maps/Route32.asm"
INCLUDE "maps/VermilionPidgeyHouse.asm"
INCLUDE "maps/VermilionPokecenter1F.asm"
INCLUDE "maps/VermilionPokecenter2FBeta.asm"
INCLUDE "maps/PokemonFanClub.asm"
INCLUDE "maps/VermilionTradeHouse.asm"
INCLUDE "maps/VermilionMart.asm"
INCLUDE "maps/VermilionOldRodHouse.asm"
INCLUDE "maps/VermilionGym.asm"
INCLUDE "maps/Route6SaffronGate.asm"
INCLUDE "maps/Route6UndergroundPathEntrance.asm"
INCLUDE "maps/Pokecenter2F.asm"
INCLUDE "maps/TradeCenter.asm"
INCLUDE "maps/Colosseum.asm"
INCLUDE "maps/TimeCapsule.asm"
INCLUDE "maps/MobileTradeRoom.asm"
INCLUDE "maps/MobileBattleRoom.asm"


SECTION "Map Scripts 18", ROMX

INCLUDE "maps/Route36.asm"
INCLUDE "maps/FuchsiaCity.asm"
INCLUDE "maps/BlackthornGym1F.asm"
INCLUDE "maps/BlackthornGym2F.asm"
INCLUDE "maps/BlackthornDragonSpeechHouse.asm"
INCLUDE "maps/BlackthornEmysHouse.asm"
INCLUDE "maps/BlackthornMart.asm"
INCLUDE "maps/BlackthornPokecenter1F.asm"
INCLUDE "maps/MoveDeletersHouse.asm"
INCLUDE "maps/FuchsiaMart.asm"
INCLUDE "maps/FuchsiaGym.asm"
INCLUDE "maps/BillsOlderSistersHouse.asm"
INCLUDE "maps/FuchsiaPokecenter1F.asm"
INCLUDE "maps/FuchsiaPokecenter2FBeta.asm"
INCLUDE "maps/Route15FuchsiaGate.asm"
INCLUDE "maps/CherrygroveMart.asm"
INCLUDE "maps/CherrygrovePokecenter1F.asm"
INCLUDE "maps/CherrygroveGymSpeechHouse.asm"
INCLUDE "maps/GuideGentsHouse.asm"
INCLUDE "maps/CherrygroveEvolutionSpeechHouse.asm"
INCLUDE "maps/Route30BerryHouse.asm"
INCLUDE "maps/MrPokemonsHouse.asm"
INCLUDE "maps/Route31VioletGate.asm"


SECTION "Map Scripts 19", ROMX

INCLUDE "maps/AzaleaTown.asm"
INCLUDE "maps/GoldenrodCity.asm"
INCLUDE "maps/SaffronCity.asm"
INCLUDE "maps/MahoganyRedGyaradosSpeechHouse.asm"
INCLUDE "maps/MahoganyGym.asm"
INCLUDE "maps/MahoganyPokecenter1F.asm"
INCLUDE "maps/Route42EcruteakGate.asm"
INCLUDE "maps/LakeOfRageHiddenPowerHouse.asm"
INCLUDE "maps/LakeOfRageMagikarpHouse.asm"
INCLUDE "maps/Route43MahoganyGate.asm"
INCLUDE "maps/Route43Gate.asm"
INCLUDE "maps/RedsHouse1F.asm"
INCLUDE "maps/RedsHouse2F.asm"
INCLUDE "maps/BluesHouse.asm"


SECTION "Map Scripts 20", ROMX

INCLUDE "maps/CherrygroveCity.asm"
INCLUDE "maps/Route35.asm"
INCLUDE "maps/Route43.asm"
INCLUDE "maps/Route44.asm"
INCLUDE "maps/Route45.asm"
INCLUDE "maps/Route25.asm"


SECTION "Map Scripts 21", ROMX

INCLUDE "maps/CianwoodCity.asm"
INCLUDE "maps/Route27.asm"
INCLUDE "maps/Route29.asm"
INCLUDE "maps/Route30.asm"
INCLUDE "maps/Route38.asm"
INCLUDE "maps/Route13.asm"
INCLUDE "maps/PewterNidoranSpeechHouse.asm"
INCLUDE "maps/PewterGym.asm"
INCLUDE "maps/PewterMart.asm"
INCLUDE "maps/PewterPokecenter1F.asm"
INCLUDE "maps/PewterPokecenter2FBeta.asm"
INCLUDE "maps/PewterSnoozeSpeechHouse.asm"


SECTION "Map Scripts 22", ROMX

INCLUDE "maps/EcruteakCity.asm"
INCLUDE "maps/BlackthornCity.asm"
INCLUDE "maps/Route26.asm"
INCLUDE "maps/Route28.asm"
INCLUDE "maps/Route31.asm"
INCLUDE "maps/Route39.asm"
INCLUDE "maps/Route40.asm"
INCLUDE "maps/Route41.asm"
INCLUDE "maps/Route12.asm"


SECTION "Map Scripts 23", ROMX

INCLUDE "maps/NewBarkTown.asm"
INCLUDE "maps/VioletCity.asm"
INCLUDE "maps/OlivineCity.asm"
INCLUDE "maps/Route37.asm"
INCLUDE "maps/Route42.asm"
INCLUDE "maps/Route46.asm"
INCLUDE "maps/ViridianCity.asm"
INCLUDE "maps/CeladonCity.asm"
INCLUDE "maps/Route15.asm"
INCLUDE "maps/VermilionCity.asm"
INCLUDE "maps/CinnabarPokecenter2FBeta.asm"
INCLUDE "maps/Route19FuchsiaGate.asm"
INCLUDE "maps/SeafoamGym.asm"


SECTION "Map Scripts 24", ROMX

INCLUDE "maps/Route33.asm"
INCLUDE "maps/Route2.asm"
INCLUDE "maps/Route1.asm"
INCLUDE "maps/PalletTown.asm"
INCLUDE "maps/Route18.asm"
INCLUDE "maps/Route17.asm"
INCLUDE "maps/Route16.asm"
INCLUDE "maps/Route7.asm"
INCLUDE "maps/Route14.asm"
INCLUDE "maps/LavenderTown.asm"
INCLUDE "maps/Route6.asm"
INCLUDE "maps/Route5.asm"
INCLUDE "maps/Route24.asm"
INCLUDE "maps/Route3.asm"
INCLUDE "maps/Route4.asm"
INCLUDE "maps/IndigoPlateau.asm"
INCLUDE "maps/Route23.asm" ; Kanto hack (M10 13e-1)
INCLUDE "maps/SilverCavePokecenter1F.asm"
INCLUDE "maps/Route28SteelWingHouse.asm"


SECTION "Map Scripts 25", ROMX

INCLUDE "maps/OaksLab.asm" ; Kanto hack: moved from section 19, which overflowed
INCLUDE "maps/Route9.asm" ; Kanto hack: moved from section 23 (M5 8a), to
; leave that bank room for Lavender's and Rock Tunnel's scripts.
INCLUDE "maps/SilverCaveOutside.asm"
INCLUDE "maps/Route10.asm"


SECTION "Map Scripts 26", ROMX

; Kanto hack: Viridian Forest and its two gates (docs/M2-FOREST.md). They get
; their own section because section 11, which holds the rest of the Viridian
; group's Kanto maps, overflowed.
INCLUDE "maps/ViridianForest.asm"
INCLUDE "maps/ViridianForestSouthGate.asm"
INCLUDE "maps/ViridianForestNorthGate.asm"

; Kanto hack: Mt. Moon 1F/B1F/B2F and its Pokemon Center (docs/M2-MTMOON.md).
INCLUDE "maps/MtMoon1F.asm"
INCLUDE "maps/MtMoonB1F.asm"
INCLUDE "maps/MtMoonB2F.asm"
INCLUDE "maps/MtMoonPokecenter.asm"

; Kanto hack: the Pewter Museum, 1F and 2F (docs/M2-PEWTER.md, 4d).
INCLUDE "maps/Museum1F.asm"
INCLUDE "maps/Museum2F.asm"

; Kanto hack: Yellow's Route 2 trade house (docs/M2-PEWTER.md, 4f).
INCLUDE "maps/Route2TradeHouse.asm"

; Kanto hack: Yellow's fourth Cerulean house (docs/M3-CERULEAN.md, 6a).  The
; other three reuse Crystal's spare Cerulean house slots, so they stay in
; "Map Scripts 15".
INCLUDE "maps/CeruleanBadgeHouse.asm"

; Kanto hack: the Cerulean Cave stub behind it (docs/M3-CERULEAN.md, 6k).
INCLUDE "maps/CeruleanCave1F.asm"

; Kanto hack: Yellow's VIRIDIAN SCHOOL HOUSE (docs/AUDIT-NPC-TEXT.md, N1c), on
; the warp Crystal gave the TRAINER HOUSE.  Not in "Map Scripts 23" (bank $6a,
; the Viridian group) because that bank is the tightest one we have.
INCLUDE "maps/ViridianSchoolHouse.asm"

; Kanto hack: M4 step 7c (docs/M4-VERMILION.md) -- Route 11's gate and the two
; Diglett's Cave entrance rooms.  The ten S.S. ANNE maps started here too, but
; 7h's objects/trainers/text overflowed this bank by 1917 bytes, so they moved
; to "Map Scripts 27" below (docs/M4-VERMILION.md "## 7h findings", 7h.2).
INCLUDE "maps/Route11Gate1F.asm"
INCLUDE "maps/Route11Gate2F.asm"
INCLUDE "maps/Route12Gate1F.asm"
INCLUDE "maps/Route12Gate2F.asm"
INCLUDE "maps/DiglettsCaveRoute2.asm"
INCLUDE "maps/DiglettsCaveRoute11.asm"

ENDSECTION


SECTION "Map Scripts 27", ROMX

; Kanto hack: the ten S.S. ANNE maps (docs/M4-VERMILION.md, 7c shells filled in
; by 7h).  Their own section, pinned in layout.link to bank $74, because with
; 7h's objects, trainers and text they no longer fit in "Map Scripts 26"'s bank
; ($7b, shared with "Battle Tower Text").
INCLUDE "maps/SSAnne1F.asm"
INCLUDE "maps/SSAnne2F.asm"
INCLUDE "maps/SSAnne3F.asm"
INCLUDE "maps/SSAnneB1F.asm"
INCLUDE "maps/SSAnneBow.asm"
INCLUDE "maps/SSAnneKitchen.asm"
INCLUDE "maps/SSAnneCaptainsRoom.asm"
INCLUDE "maps/SSAnne1FRooms.asm"
INCLUDE "maps/SSAnne2FRooms.asm"
INCLUDE "maps/SSAnneB1FRooms.asm"

ENDSECTION


SECTION "Map Scripts 28", ROMX

; Kanto hack (M6 9o, docs/M6-CELADON.md D27): ROCKET HIDEOUT's five floors,
; plus the GAME CORNER and its PRIZE ROOM -- the hideout's front door and the
; two maps its scripts talk to most.  Pinned in layout.link to bank $5b.
; The five hideout maps are 9o skeletons; 9p-9w fill them in.
INCLUDE "maps/CeladonGameCorner.asm"
INCLUDE "maps/CeladonGameCornerPrizeRoom.asm"
INCLUDE "maps/RocketHideoutB1F.asm"
INCLUDE "maps/RocketHideoutB2F.asm"
INCLUDE "maps/RocketHideoutB3F.asm"
INCLUDE "maps/RocketHideoutB4F.asm"
INCLUDE "maps/RocketHideoutElevator.asm"

ENDSECTION


SECTION "Map Scripts 29", ROMX

; Kanto hack (M6 9o, docs/M6-CELADON.md D27): CELADON CITY's indoor maps,
; moved wholesale out of "Map Scripts 7", plus the four new interiors that are
; not part of the hideout.  Pinned in layout.link to bank $75 -- D27 said $73,
; but the block is 8294 bytes and $73 had only 9391 free; see "## 9o findings".
INCLUDE "maps/CeladonDeptStore1F.asm"
INCLUDE "maps/CeladonDeptStore2F.asm"
INCLUDE "maps/CeladonDeptStore3F.asm"
INCLUDE "maps/CeladonDeptStore4F.asm"
INCLUDE "maps/CeladonDeptStore5F.asm"
INCLUDE "maps/CeladonDeptStore6F.asm"
INCLUDE "maps/CeladonDeptStoreElevator.asm"
INCLUDE "maps/CeladonMansion1F.asm"
INCLUDE "maps/CeladonMansion2F.asm"
INCLUDE "maps/CeladonMansion3F.asm"
INCLUDE "maps/CeladonMansionRoof.asm"
INCLUDE "maps/CeladonMansionRoofHouse.asm"
INCLUDE "maps/CeladonPokecenter1F.asm"
INCLUDE "maps/CeladonPokecenter2FBeta.asm"
INCLUDE "maps/CeladonGym.asm"
INCLUDE "maps/CeladonCafe.asm"
INCLUDE "maps/CeladonChiefHouse.asm"
INCLUDE "maps/CeladonHotel.asm"
INCLUDE "maps/Route16Gate2F.asm"
INCLUDE "maps/Route18Gate2F.asm"

ENDSECTION


SECTION "Map Scripts 30", ROMX

; Kanto hack (M7 10a, docs/M7-FUCHSIA.md D47): the SAFARI ZONE -- its gate, its
; four areas, the four rest houses and the secret house -- plus the FUCHSIA
; interiors that grow in M7: the renamed FUCHSIA MEETING ROOM (Crystal called it
; SAFARI_ZONE_MAIN_OFFICE), the WARDEN's home and the GOOD ROD house.  All twelve
; new maps carry placeholder skeletons here; 10f-10h fill them in.  Pinned in
; layout.link to bank $76, one of the four wholly EMPTY banks ($75 $76 $79 $7a)
; the survey's cost table missed; an unpinned section bin-packs into bank $01,
; which has ~102 bytes free (G11).
INCLUDE "maps/FuchsiaMeetingRoom.asm"
INCLUDE "maps/SafariZoneWardensHome.asm"
INCLUDE "maps/FuchsiaGoodRodHouse.asm"
INCLUDE "maps/Route15Gate2F.asm"
INCLUDE "maps/SafariZoneGate.asm"
INCLUDE "maps/SafariZoneEast.asm"
INCLUDE "maps/SafariZoneNorth.asm"
INCLUDE "maps/SafariZoneWest.asm"
INCLUDE "maps/SafariZoneCenter.asm"
INCLUDE "maps/SafariZoneCenterRestHouse.asm"
INCLUDE "maps/SafariZoneSecretHouse.asm"
INCLUDE "maps/SafariZoneWestRestHouse.asm"
INCLUDE "maps/SafariZoneEastRestHouse.asm"
INCLUDE "maps/SafariZoneNorthRestHouse.asm"

; Kanto hack (M9 12a, docs/M9-CINNABAR.md 0.3): CINNABAR's quiet interiors --
; the four LAB rooms, the MART and the POKeCENTRE that regrows to Yellow's 7x4
; here.  0.3 budgets them ~3.2 KB against this bank's 10233 free, so they stay
; clear of the 11.6 KB that has to fit in "Map Scripts 32".
INCLUDE "maps/CinnabarPokecenter1F.asm"
INCLUDE "maps/CinnabarMart.asm"
INCLUDE "maps/CinnabarLab.asm"
INCLUDE "maps/CinnabarLabTradeRoom.asm"
INCLUDE "maps/CinnabarLabMetronomeRoom.asm"
INCLUDE "maps/CinnabarLabFossilRoom.asm"

; Kanto hack (M9 12k): the POKeMON MANSION's four floors.  They were parked in
; "Map Scripts 32" ($1c) as 12a skeletons; populated they are ~3.8 KB, and $1c
; is the bank that also has to hold ROUTES 19-21, CINNABAR ISLAND, the three
; SEAFOAM floors and the GYM.  $76 has the slack, so the four INCLUDEs move
; here now -- before the maps carry any *_MapEvents a savestate could pin
; (11n H-2: rehoming a populated map invalidates every savestate on it).
INCLUDE "maps/PokemonMansion1F.asm"
INCLUDE "maps/PokemonMansion2F.asm"
INCLUDE "maps/PokemonMansion3F.asm"
INCLUDE "maps/PokemonMansionB1F.asm"
; M10 13f: Yellow's VICTORY ROAD 2F/3F ($76 has the slack; 1F stays in
; "Map Scripts 8", where Crystal's VictoryRoad lived).
INCLUDE "maps/VictoryRoad2F.asm"
INCLUDE "maps/VictoryRoad3F.asm"

ENDSECTION


SECTION "Map Scripts 31", ROMX

; Kanto hack (M8 11a, docs/M8-SAFFRON.md D69): SILPH CO. 2F-11F and the lift.
; "Map Scripts 30" ($76) has no room for another twelve maps' worth of script,
; so M8 spends the last wholly EMPTY bank, $7a, pinned in layout.link.  All
; eleven maps carry placeholder skeletons with Yellow's stair/elevator warps;
; 11f-11h fill in the trainers, the item balls and the card-key doors.
; 11j: the 20 card-key doors' shared tail and texts.  It leads the section so
; every floor's per-door sjump stays a 2-byte same-bank jump.
INCLUDE "maps/SilphCoCardKeyDoors.asm"
INCLUDE "maps/SilphCo2F.asm"
INCLUDE "maps/SilphCo3F.asm"
INCLUDE "maps/SilphCo4F.asm"
INCLUDE "maps/SilphCo5F.asm"
INCLUDE "maps/SilphCo6F.asm"
INCLUDE "maps/SilphCo7F.asm"
INCLUDE "maps/SilphCo8F.asm"
INCLUDE "maps/SilphCo9F.asm"
INCLUDE "maps/SilphCo10F.asm"
INCLUDE "maps/SilphCo11F.asm"
INCLUDE "maps/SilphCoElevator.asm"

; Kanto hack (M9 12a, docs/M9-CINNABAR.md 0.3): the two SEAFOAM floors with no
; current and no ARTICUNO, ~730 B of the 5898 left in this bank.
INCLUDE "maps/SeafoamIslandsB1F.asm"
INCLUDE "maps/SeafoamIslandsB2F.asm"

; Kanto hack (M10 13a, docs/M10-INDIGO.md): VIRIDIAN GYM moves out of "Map
; Scripts 11" ($26, ~600 B free) ahead of 13b's eight trainers and GIOVANNI.
INCLUDE "maps/ViridianGym.asm"

ENDSECTION


SECTION "Map Scripts 32", ROMX

; Kanto hack (M9 12a, docs/M9-CINNABAR.md D93): M9's heavy maps.  0.3 puts the
; milestone's script+text bill at ~15.5 KB; "Map Scripts 30" ($76, 10233 free)
; and "Map Scripts 31" ($7a, 5898) would only just cover it with no slack for
; the leftover audit's fixes, so 12a opens a third home in $1c -- the largest
; tail left in the tree at 11242 bytes.  Pinned in layout.link; floating, it
; bin-packs into bank $01, which has 102 free bytes (G2).
;
; ROUTES 19-21 and CINNABAR ISLAND move here from "Map Scripts 20"/"24" while
; they are still Crystal-sized stubs: 12b and 12c multiply them and an
; already-populated map is far more expensive to rehome (moving a map's
; *_MapEvents block invalidates every savestate taken on it, 11n H-2).
INCLUDE "maps/Route19.asm"
INCLUDE "maps/Route20.asm"
INCLUDE "maps/Route21.asm"
INCLUDE "maps/CinnabarIsland.asm"
INCLUDE "maps/SeafoamIslands1F.asm"
INCLUDE "maps/SeafoamIslandsB3F.asm"
INCLUDE "maps/SeafoamIslandsB4F.asm"
INCLUDE "maps/CinnabarGym.asm"

ENDSECTION
