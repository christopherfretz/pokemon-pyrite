; Places and People will not describe these trainers.

; Kanto hack (M11 14k, D161): in the Johto act the HoF bit is set and
; wKantoBadges is $ff, so only PnP_HiddenPeople_BeatKanto applies there: the
; show names the ELITE FOUR (LORELEI, BRUNO, AGATHA, LANCE), the Kanto
; leaders, and the rival as "LEADER <RIVAL>" (special-cased in PeoplePlaces4).
PnP_HiddenPeople:
	db LORELEI ; Kanto hack (M10 13i): Crystal WILL slot, renamed
	db BRUNO
	db AGATHA ; Crystal KAREN slot
	db LANCE_E4 ; Crystal E4 KOGA slot
	; fallthrough
PnP_HiddenPeople_BeatE4:
	db BROCK
	db MISTY
	db LT_SURGE
	db ERIKA
	db KOGA_LEADER
	db SABRINA
	db BLAINE
	db KANTO_CHAMPION ; the VIRIDIAN leader in the Johto act
	; fallthrough
PnP_HiddenPeople_BeatKanto:
	db RIVAL1
	db POKEMON_PROF
	db CAL
	db RIVAL2
	db RED
	; Kanto hack (M11 14k, D161): always hidden --
	db CHAMPION ; the Mt. Silver LANCE (class name "LANCE", a secret)
	db BLUE ; unused: the rival holds VIRIDIAN GYM
	db KANTO_RIVAL ; the rival again, shown once as KANTO_CHAMPION
	db JESSIE_JAMES ; party name empty
	db GIOVANNI ; party name empty
	db CUE_BALL ; party name empty
	db TAMER ; party name empty
	db SWIMMERM ; party name empty
	db BIKER ; party name empty
	db -1
