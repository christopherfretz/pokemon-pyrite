; Kanto hack (N1a): the nurse keeps Crystal's clock fan-out (day/night is an
; engine feature the operator kept) but speaks Yellow's words.  Yellow's
; "Welcome to our #MON CENTER!" is the greeting; the rest of
; _PokemonCenterWelcomeText ("We heal your #MON back to perfect health!")
; lives in NurseAskHealText below, which is the box that follows.
; DELETED here: PokeComNurseMorn/Day/NiteText and PokeComNursePokerusText,
; the #MON COMMUNICATION CENTER variants.  They hung off
; EVENT_WELCOMED_TO_POKECOM_CENTER (renamed in place by M6 9z to EVENT_ROUTE_17_HIDDEN_PP_UP), which is set by nothing in the whole ROM,
; so a single stray setevent would have dropped a Gen-2 facility into a Kanto
; Pokecenter.  Restore from vendor/pokecrystal if the Johto act wants them.
NurseMornText:
	text "Good morning!"
	line "Welcome to our"
	cont "#MON CENTER!"
	done

NurseDayText:
	text "Hello!"
	line "Welcome to our"
	cont "#MON CENTER!"
	done

NurseNiteText:
	text "Good evening!"
	line "You're out late."

	para "Welcome to our"
	line "#MON CENTER!"
	done

NurseAskHealText:
; Yellow: _PokemonCenterWelcomeText tail + _ShallWeHealYourPokemonText
; (vendor/pokeyellow/data/text/text_7.asm:163,172).
	text "We heal your"
	line "#MON back to"
	cont "perfect health!"

	para "Shall we heal your"
	line "#MON?"
	done

NurseTakePokemonText:
; Yellow: _NeedYourPokemonText (vendor/pokeyellow/data/text/text_7.asm:177).
	text "OK. We'll need"
	line "your #MON."
	done

NurseReturnPokemonText:
; Yellow: _PokemonFightingFitText (vendor/pokeyellow/data/text/text_7.asm:182).
	text "Thank you!"
	line "Your #MON are"
	cont "fighting fit!"
	done

NurseGoodbyeText:
	text "We hope to see you"
	line "again."
	done

; not used
	text "We hope to see you"
	line "again."
	done

NursePokerusText:
; Kanto hack (N1a): Pokerus stays (operator ruling), but the Elm phone call
; that used to explain it does not exist in Kanto, so the nurse explains it
; herself at the counter.  The facts are Gen 2's own Pokerus lore; no
; professor, no #GEAR.  See hack/engine/events/std_scripts.asm .pokerus.
	text "Your #MON"
	line "appear to be"

	para "infected by tiny"
	line "life forms."

	para "Your #MON are"
	line "healthy and seem"
	cont "to be fine."

	para "We call it the"
	line "#RUS. It is"

	para "rare, and it is"
	line "good news--it"

	para "makes a #MON"
	line "grow stronger"
	cont "much faster."

	para "It fades in a day"
	line "or two, but any"

	para "#MON in your"
	line "BOX will keep it."
	done

; Kanto hack (N1a): Yellow drives every bookcase from one string,
; _PokemonBooksText (vendor/pokeyellow/data/text/text_2.asm:846).  Both std
; bookshelf scripts print it; the labels are kept so Johto can re-split them.
DifficultBookshelfText:
	text "Crammed full of"
	line "#MON books!"
	done

PictureBookshelfText:
	text "Crammed full of"
	line "#MON books!"
	done

MagazineBookshelfText:
	text "#MON magazines…"
	line "#MON PAL,"

	para "#MON HANDBOOK,"
	line "#MON GRAPH…"
	done

TeamRocketOathText:
	text "TEAM ROCKET OATH"

	para "Steal #MON for"
	line "profit!"

	para "Exploit #MON"
	line "for profit!"

	para "All #MON exist"
	line "for the glory of"
	cont "TEAM ROCKET!"
	done

IncenseBurnerText:
	text "What is this?"

	para "Oh, it's an"
	line "incense burner!"
	done

MerchandiseShelfText:
	text "Lots of #MON"
	line "merchandise!"
	done

LookTownMapText:
	text "It's the TOWN MAP."
	done

WindowText:
	text "My reflection!"
	line "Lookin' good!"
	done

TVText:
	text "It's a TV."
	done

HomepageText:
	text "#MON JOURNAL"
	line "HOME PAGE…"

	para "It hasn't been"
	line "updated…"
	done

; not used
	text "#MON RADIO!"

	para "Call in with your"
	line "requests now!"
	done

TrashCanText:
	text "There's nothing in"
	line "here…"
	done

; not used
	text "A #MON may be"
	line "able to move this."
	done

; not used
	text "Maybe a #MON"
	line "can break this."
	done

PokecenterSignText:
	text "Heal Your #MON!"
	line "#MON CENTER"
	done

MartSignText:
; Yellow: _MartSignText (vendor/pokeyellow/data/text/text_1.asm:49).
	text "All your item"
	line "needs fulfilled!"
	cont "#MON MART"
	done

ContestResults_ReadyToJudgeText:
	text "We will now judge"
	line "the #MON you've"
	cont "caught."

	para "<……>"
	line "<……>"

	para "We have chosen the"
	line "winners!"

	para "Are you ready for"
	line "this?"
	done

ContestResults_PlayerWonAPrizeText:
	text "<PLAYER>, the No.@"
	text_ram wStringBuffer3
	text_start
	line "finisher, wins"
	cont "@"
	text_ram wStringBuffer4
	text "!"
	done

ReceivedItemText:
	text "<PLAYER> received"
	line "@"
	text_ram wStringBuffer4
	text "."
	done

ContestResults_JoinUsNextTimeText:
	text "Please join us for"
	line "the next Contest!"
	done

ContestResults_ConsolationPrizeText:
	text "Everyone else gets"
	line "a BERRY as a con-"
	cont "solation prize!"
	done

ContestResults_DidNotWinText:
	text "We hope you do"
	line "better next time."
	done

ContestResults_ReturnPartyText:
	text "We'll return the"
	line "#MON we kept"

	para "for you."
	line "Here you go!"
	done

ContestResults_PartyFullText:
	text "Your party's full,"
	line "so the #MON was"

	para "sent to your BOX"
	line "in BILL's PC."
	done

; Kanto hack (N1a): Yellow's statues are one text each and both name the
; LEADER and the RIVAL (_GymStatueText1 / _GymStatueText2,
; vendor/pokeyellow/data/text/text_2.asm:142,155).  GymStatue_CityGymText is
; now the whole pre-badge statue, GymStatue_WinningTrainersText the whole
; post-badge one -- GymStatue2Script no longer prints both.
; wStringBuffer3 = city (getcurlandmarkname), wStringBuffer4 = leader
; (gettrainername, done by the gym map before the jumpstd).
GymStatue_CityGymText:
	text_ram wStringBuffer3
	text_start
	line "#MON GYM"
	cont "LEADER: @"
	text_ram wStringBuffer4
	text_start

	para "WINNING TRAINERS:"
	line "<RIVAL>"
	done

GymStatue_WinningTrainersText:
	text_ram wStringBuffer3
	text_start
	line "#MON GYM"
	cont "LEADER: @"
	text_ram wStringBuffer4
	text_start

	para "WINNING TRAINERS:"
	line "<RIVAL>"
	cont "<PLAYER>"
	done

; Kanto hack (M11 14c): Johto gyms' statues -- Silver has no player-given
; name, so "SILVER" is literal (<RIVAL> is Gary's wRivalName).
GymStatue_CityGymSilverText:
	text_ram wStringBuffer3
	text_start
	line "#MON GYM"
	cont "LEADER: @"
	text_ram wStringBuffer4
	text_start

	para "WINNING TRAINERS:"
	line "SILVER"
	done

GymStatue_WinningTrainersSilverText:
	text_ram wStringBuffer3
	text_start
	line "#MON GYM"
	cont "LEADER: @"
	text_ram wStringBuffer4
	text_start

	para "WINNING TRAINERS:"
	line "SILVER"
	cont "<PLAYER>"
	done

CoinVendor_WelcomeText:
	text "Welcome to the"
	line "GAME CORNER."
	done

CoinVendor_NoCoinCaseText:
	text "Do you need game"
	line "coins?"

	para "Oh, you don't have"
	line "a COIN CASE for"
	cont "your coins."
	done

CoinVendor_IntroText:
	text "Do you need some"
	line "game coins?"

	para "It costs ¥1000 for"
	line "50 coins. Do you"
	cont "want some?"
	done

CoinVendor_Buy50CoinsText:
	text "Thank you!"
	line "Here are 50 coins."
	done

CoinVendor_Buy500CoinsText:
	text "Thank you! Here"
	line "are 500 coins."
	done

CoinVendor_NotEnoughMoneyText:
	text "You don't have"
	line "enough money."
	done

CoinVendor_CoinCaseFullText:
	text "Whoops! Your COIN"
	line "CASE is full."
	done

CoinVendor_CancelText:
	text "No coins for you?"
	line "Come again!"
	done

BugContestPrizeNoRoomText:
	text "Oh? Your PACK is"
	line "full."

	para "We'll keep this"
	line "for you today, so"

	para "come back when you"
	line "make room for it."
	done

HappinessText3:
	text "Wow! You and your"
	line "#MON are really"
	cont "close!"
	done

HappinessText2:
	text "#MON get more"
	line "friendly if you"

	para "spend time with"
	line "them."
	done

HappinessText1:
	text "You haven't tamed"
	line "your #MON."

	para "If you aren't"
	line "nice, it'll pout."
	done

RegisteredNumber1Text:
	text "<PLAYER> registered"
	line "@"
	text_ram wStringBuffer3
	text "'s number."
	done

RegisteredNumber2Text:
	text "<PLAYER> registered"
	line "@"
	text_ram wStringBuffer3
	text "'s number."
	done
