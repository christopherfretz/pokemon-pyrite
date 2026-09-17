	object_const_def
	const REDSHOUSE1F_REDS_MOM

RedsHouse1F_MapScripts:
	def_scene_scripts
	scene_script RedHouse1FNoopScene ; unusable

	def_callbacks

RedHouse1FNoopScene:
	end

RedsMom:
; yellowcrystal: Yellow's intro mom. First talk sends you to Oak; after that she heals.
	faceplayer
	opentext
	checkevent EVENT_MET_REDS_MOM
	iftrue .Heal
	writetext RedsHouse1FMomWakeUpText
	waitbutton
	closetext
	setevent EVENT_MET_REDS_MOM
	end
.Heal:
	writetext RedsHouse1FMomYouShouldRestText
	waitbutton
	special HealParty
	writetext RedsHouse1FMomLookingGreatText
	waitbutton
	closetext
	end

RedsHouse1FTV:
	jumptext RedsHouse1FTVText

RedsHouse1FBookshelf:
	jumpstd PictureBookshelfScript

RedsHouse1FMomWakeUpText:
	text "MOM: Right."
	line "All boys leave"
	cont "home someday."
	cont "It said so on TV."

	para "PROF.OAK, next"
	line "door, is looking"
	cont "for you."
	done

RedsHouse1FMomYouShouldRestText:
	text "MOM: <PLAYER>, if"
	line "you drive your"
	cont "#MON too hard,"
	cont "they'll dislike"
	cont "you."

	para "You should take a"
	line "rest."
	prompt

RedsHouse1FMomLookingGreatText:
	text "MOM: Oh good!"
	line "You and your"
	cont "#MON are"
	cont "looking great!"
	cont "Take care now!"
	done

RedsHouse1FTVText:
	text "There's a movie"
	line "on TV. Four boys"
	cont "are walking on"
	cont "railroad tracks."

	para "I better go too."
	done

RedsHouse1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, PALLET_TOWN, 1
	warp_event  3,  7, PALLET_TOWN, 1
	warp_event  7,  0, REDS_HOUSE_2F, 1

	def_coord_events

	def_bg_events
	bg_event  0,  1, BGEVENT_READ, RedsHouse1FBookshelf
	bg_event  1,  1, BGEVENT_READ, RedsHouse1FBookshelf
	bg_event  2,  1, BGEVENT_READ, RedsHouse1FTV

	def_object_events
	object_event  5,  3, SPRITE_REDS_MOM, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, RedsMom, -1
