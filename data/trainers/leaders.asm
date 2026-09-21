; These lists determine the battle music and victory music, and whether to
; award HAPPINESS_GYMBATTLE for winning.

; Note: CHAMPION and RED are unused for battle music checks, since they are
; accounted for prior to the list check.

; Kanto hack (M7 10h): KANTO's fifth gym is FUCHSIA and KOGA leads it.  He is
; the KOGA_LEADER class (JANINE's slot, renamed -- see trainer_constants.asm),
; so he is already in KantoGymLeaders below and gets
; MUSIC_KANTO_GYM_LEADER_BATTLE like the other seven.  Crystal's ELITE FOUR KOGA
; keeps its own class and stays in GymLeaders, untouched.

GymLeaders:
	db FALKNER
	db WHITNEY
	db BUGSY
	db MORTY
	db PRYCE
	db JASMINE
	db CHUCK
	db CLAIR
	db WILL
	db BRUNO
	db KAREN
	db KOGA
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
