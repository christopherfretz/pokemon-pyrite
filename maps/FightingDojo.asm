; Kanto hack (M8 11d, docs/M8-SAFFRON.md 0.6 row 11d / D76): Yellow's FIGHTING
; DOJO.  Crystal had turned the room into an empty shrine with a FOCUS BAND on
; the floor and a BLACK BELT who points at MT.MORTAR; Yellow's dojo is a real
; five-trainer side dungeon that ends in the HITMONLEE / HITMONCHAN choice.
;
; The KARATE MASTER is not a sight-range trainer in Yellow: the map's default
; script polls the player's coordinates and fires when he stands at (4, 3), the
; one tile the corridor to the two balls passes through.  GSC can do exactly
; that with a scene-agnostic coord_event (scene id -1, as PokemonTower5F does),
; so the trigger is faithful down to the tile -- including Yellow turning the
; player to face RIGHT and the master to face LEFT before the battle.
	object_const_def
	const FIGHTINGDOJO_KARATE_MASTER
	const FIGHTINGDOJO_BLACKBELT1
	const FIGHTINGDOJO_BLACKBELT2
	const FIGHTINGDOJO_BLACKBELT3
	const FIGHTINGDOJO_BLACKBELT4
	const FIGHTINGDOJO_HITMONLEE_POKE_BALL
	const FIGHTINGDOJO_HITMONCHAN_POKE_BALL

FightingDojo_MapScripts:
	def_scene_scripts

	def_callbacks

FightingDojoKarateMasterTrigger:
	checkevent EVENT_DEFEATED_FIGHTING_DOJO
	iftrue FightingDojoKarateMasterTriggerDone
	turnobject PLAYER, RIGHT
	turnobject FIGHTINGDOJO_KARATE_MASTER, LEFT
	jump FightingDojoKarateMasterBattle

FightingDojoKarateMasterTriggerDone:
	end

FightingDojoKarateMasterScript:
	faceplayer
	checkevent EVENT_GOT_FIGHTING_DOJO_GIFT
	iftrue .StayAndTrain
	checkevent EVENT_DEFEATED_FIGHTING_DOJO
	iftrue .ChooseOne
	jump FightingDojoKarateMasterBattle

.ChooseOne:
	opentext
	writetext FightingDojoKarateMasterIWillGiveYouAPokemonText
	waitbutton
	closetext
	end

.StayAndTrain:
	opentext
	writetext FightingDojoKarateMasterStayAndTrainWithUsText
	waitbutton
	closetext
	end

FightingDojoKarateMasterBattle:
	opentext
	writetext FightingDojoKarateMasterText
	waitbutton
	closetext
	winlosstext FightingDojoKarateMasterDefeatedText, 0
	loadtrainer BLACKBELT_T, KARATE_MASTER
	startbattle
	reloadmapafterbattle
	; Yellow's SetEventRange EVENT_BEAT_KARATE_MASTER ..
	; EVENT_BEAT_FIGHTING_DOJO_TRAINER_3: beating the master retires the four
	; BLACKBELTs too, as CELADON and FUCHSIA GYM do for their trainers.
	setevent EVENT_DEFEATED_FIGHTING_DOJO
	setevent EVENT_BEAT_FIGHTING_DOJO_TRAINER_1
	setevent EVENT_BEAT_FIGHTING_DOJO_TRAINER_2
	setevent EVENT_BEAT_FIGHTING_DOJO_TRAINER_3
	setevent EVENT_BEAT_FIGHTING_DOJO_TRAINER_4
	opentext
	writetext FightingDojoKarateMasterIWillGiveYouAPokemonText
	waitbutton
	closetext
	end

TrainerBlackbeltDojo1:
	trainer BLACKBELT_T, BLACKBELT_DOJO_1, EVENT_BEAT_FIGHTING_DOJO_TRAINER_1, FightingDojoBlackbelt1SeenText, FightingDojoBlackbelt1BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext FightingDojoBlackbelt1AfterBattleText
	waitbutton
	closetext
	end

TrainerBlackbeltDojo2:
	trainer BLACKBELT_T, BLACKBELT_DOJO_2, EVENT_BEAT_FIGHTING_DOJO_TRAINER_2, FightingDojoBlackbelt2SeenText, FightingDojoBlackbelt2BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext FightingDojoBlackbelt2AfterBattleText
	waitbutton
	closetext
	end

TrainerBlackbeltDojo3:
	trainer BLACKBELT_T, BLACKBELT_DOJO_3, EVENT_BEAT_FIGHTING_DOJO_TRAINER_3, FightingDojoBlackbelt3SeenText, FightingDojoBlackbelt3BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext FightingDojoBlackbelt3AfterBattleText
	waitbutton
	closetext
	end

TrainerBlackbeltDojo4:
	trainer BLACKBELT_T, BLACKBELT_DOJO_4, EVENT_BEAT_FIGHTING_DOJO_TRAINER_4, FightingDojoBlackbelt4SeenText, FightingDojoBlackbelt4BeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext FightingDojoBlackbelt4AfterBattleText
	waitbutton
	closetext
	end

FightingDojoHitmonleeBall:
	opentext
	writetext FightingDojoHitmonleePokeBallText
	yesorno
	iffalse .Declined
	writetext FightingDojoReceivedHitmonleeText
	playsound SFX_CAUGHT_MON
	waitsfx
	givepoke HITMONLEE, 30
	ifequal 2, .Declined
	setevent EVENT_GOT_HITMONLEE
	setevent EVENT_GOT_FIGHTING_DOJO_GIFT
	disappear FIGHTINGDOJO_HITMONLEE_POKE_BALL
	disappear FIGHTINGDOJO_HITMONCHAN_POKE_BALL
.Declined:
	closetext
	end

FightingDojoHitmonchanBall:
	opentext
	writetext FightingDojoHitmonchanPokeBallText
	yesorno
	iffalse .Declined
	writetext FightingDojoReceivedHitmonchanText
	playsound SFX_CAUGHT_MON
	waitsfx
	givepoke HITMONCHAN, 30
	ifequal 2, .Declined
	setevent EVENT_GOT_HITMONCHAN
	setevent EVENT_GOT_FIGHTING_DOJO_GIFT
	disappear FIGHTINGDOJO_HITMONLEE_POKE_BALL
	disappear FIGHTINGDOJO_HITMONCHAN_POKE_BALL
.Declined:
	closetext
	end

FightingDojoStatue:
	jumptext FightingDojoStatueText

FightingDojoSign1:
	jumptext FightingDojoSign1Text

FightingDojoSign2:
	jumptext FightingDojoSign2Text

FightingDojoKarateMasterText:
	text "Grunt!"

	para "I am the KARATE"
	line "MASTER! I am the"
	cont "LEADER here!"

	para "You wish to"
	line "challenge us?"
	cont "Expect no mercy!"

	para "Fwaaa!"
	done

FightingDojoKarateMasterDefeatedText:
	text "Hwa!"
	line "Arrgh! Beaten!"
	prompt

FightingDojoKarateMasterIWillGiveYouAPokemonText:
	text "Indeed, I have"
	line "lost!"

	para "But, I beseech"
	line "you, do not take"
	cont "our emblem as"
	cont "your trophy!"

	para "In return, I will"
	line "give you a prized"
	cont "fighting #MON!"

	para "Choose whichever"
	line "one you like!"
	done

FightingDojoKarateMasterStayAndTrainWithUsText:
	text "Ho!"

	para "Stay and train at"
	line "Karate with us!"
	done

FightingDojoBlackbelt1SeenText:
	text "Hoargh! Take your"
	line "shoes off!"
	done

FightingDojoBlackbelt1BeatenText:
	text "I give"
	line "up!"
	prompt

FightingDojoBlackbelt1AfterBattleText:
	text "You wait 'til you"
	line "see our Master!"

	para "I'm a small fry"
	line "compared to him!"
	done

FightingDojoBlackbelt2SeenText:
	text "I hear you're"
	line "good! Show me!"
	done

FightingDojoBlackbelt2BeatenText:
	text "Judge!"
	line "1 point!"
	prompt

FightingDojoBlackbelt2AfterBattleText:
	text "Our Master is a"
	line "pro fighter!"
	done

FightingDojoBlackbelt3SeenText:
	text "Nothing tough"
	line "frightens me!"

	para "I break boulders"
	line "for training!"
	done

FightingDojoBlackbelt3BeatenText:
	text "Yow!"
	line "Stubbed fingers!"
	prompt

FightingDojoBlackbelt3AfterBattleText:
	text "The only thing"
	line "that frightens us"
	cont "is psychic power!"
	done

FightingDojoBlackbelt4SeenText:
	text "Hoohah!"

	para "You're trespassing"
	line "in our FIGHTING"
	cont "DOJO!"
	done

FightingDojoBlackbelt4BeatenText:
	text "Oof!"
	line "I give up!"
	prompt

FightingDojoBlackbelt4AfterBattleText:
	text "The prime fighters"
	line "across the land"
	cont "train here."
	done

FightingDojoHitmonleePokeBallText:
	text "You want the"
	line "hard-kicking"
	cont "HITMONLEE?"
	done

FightingDojoReceivedHitmonleeText:
	text "<PLAYER> received"
	line "HITMONLEE!"
	done

FightingDojoHitmonchanPokeBallText:
	text "You want the"
	line "piston-punching"
	cont "HITMONCHAN?"
	done

FightingDojoReceivedHitmonchanText:
	text "<PLAYER> received"
	line "HITMONCHAN!"
	done

FightingDojoStatueText:
	text "FIGHTING DOJO"
	done

FightingDojoSign1Text:
	text "Enemies on every"
	line "side!"
	done

FightingDojoSign2Text:
	text "What goes around"
	line "comes around!"
	done

FightingDojo_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 11, SAFFRON_CITY, 2
	warp_event  5, 11, SAFFRON_CITY, 2

	def_coord_events
	coord_event  4,  3, -1, FightingDojoKarateMasterTrigger

	def_bg_events
	bg_event  4,  0, BGEVENT_READ, FightingDojoSign1
	bg_event  5,  0, BGEVENT_READ, FightingDojoSign2
	bg_event  3,  9, BGEVENT_READ, FightingDojoStatue
	bg_event  6,  9, BGEVENT_READ, FightingDojoStatue

	def_object_events
	object_event  5,  3, SPRITE_BLACK_BELT, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, FightingDojoKarateMasterScript, -1
	object_event  3,  4, SPRITE_BLACK_BELT, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerBlackbeltDojo1, -1
	object_event  3,  6, SPRITE_BLACK_BELT, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, TrainerBlackbeltDojo2, -1
	object_event  5,  5, SPRITE_BLACK_BELT, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerBlackbeltDojo3, -1
	object_event  5,  7, SPRITE_BLACK_BELT, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 3, TrainerBlackbeltDojo4, -1
	object_event  4,  1, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, FightingDojoHitmonleeBall, EVENT_GOT_FIGHTING_DOJO_GIFT
	object_event  5,  1, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, FightingDojoHitmonchanBall, EVENT_GOT_FIGHTING_DOJO_GIFT
