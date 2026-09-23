; These lists determine the battle music and victory music, and whether to
; award HAPPINESS_GYMBATTLE for winning.

; Note: CHAMPION and RED are unused for battle music checks, since they are
; accounted for prior to the list check.

; Kanto hack (M7 10h): KANTO's fifth gym is FUCHSIA and KOGA leads it.  He is
; the KOGA_LEADER class (JANINE's slot, renamed -- see trainer_constants.asm),
; so he is already in KantoGymLeaders below and gets
; MUSIC_KANTO_GYM_LEADER_BATTLE like the other seven.  Crystal's ELITE FOUR KOGA
; keeps its own class and stays in GymLeaders, untouched.

; Kanto hack (M10 13i, C-14/D131): the ELITE FOUR are NOT gym leaders.  Yellow's
; PlayBattleMusic plays the gym-leader theme only when wGymLeaderNo is set (the
; eight gym scripts) or the opponent is OPP_LANCE; LORELEI, BRUNO and AGATHA get
; MUSIC_TRAINER_BATTLE, and TrainerBattleVictory plays MUSIC_DEFEATED_TRAINER
; for all four.  So LORELEI/BRUNO/AGATHA/LANCE_E4 are out of this list (no Johto
; gym music, no gym victory, no HAPPINESS_GYMBATTLE); LANCE_E4's gym-leader theme
; and KANTO_CHAMPION's champion music/victory are special-cased in
; engine/battle/start_battle.asm and PlayVictoryMusic (engine/battle/core.asm).

GymLeaders:
	db FALKNER
	db WHITNEY
	db BUGSY
	db MORTY
	db PRYCE
	db JASMINE
	db CHUCK
	db CLAIR
	db CHAMPION
	db RED
; fallthrough
KantoGymLeaders:
	db BROCK
	db MISTY
	db LT_SURGE
	db ERIKA
	db KOGA_LEADER
	db SABRINA
	db BLAINE
	db BLUE
	db -1
