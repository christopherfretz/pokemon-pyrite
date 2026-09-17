	object_const_def
	const VIRIDIANMART_CLERK
	const VIRIDIANMART_LASS
	const VIRIDIANMART_COOLTRAINER_M

ViridianMart_MapScripts:
	def_scene_scripts
	scene_script ViridianMartParcelScene, SCENE_VIRIDIANMART_PARCEL
	scene_script ViridianMartNoopScene,   SCENE_VIRIDIANMART_NOOP

	def_callbacks

; Yellow's parcel beat (docs/M2-PARCEL.md): the first time the player walks
; in, the clerk calls them over and hands them OAK'S PARCEL.
ViridianMartParcelScene:
	sdefer ViridianMartParcelScript
	end

ViridianMartNoopScene:
	end

ViridianMartParcelScript:
	opentext
	writetext ViridianMartClerkFromPalletText
	waitbutton
	closetext
	readvar VAR_XCOORD
	ifequal 3, .Column3
	applymovement PLAYER, ViridianMart_PlayerStepRightMovement
.Column3:
	applymovement PLAYER, ViridianMart_PlayerToCounterMovement
	turnobject PLAYER, LEFT
	opentext
	writetext ViridianMartClerkParcelText
	promptbutton
	verbosegiveitem OAKS_PARCEL
	closetext
	setevent EVENT_GOT_OAKS_PARCEL
	setscene SCENE_VIRIDIANMART_NOOP
	end

ViridianMartClerkScript:
	checkevent EVENT_OAK_GOT_PARCEL
	iffalse .SayHiToOak
	opentext
	pokemart MARTTYPE_STANDARD, MART_VIRIDIAN
	closetext
	end

.SayHiToOak:
	jumptextfaceplayer ViridianMartClerkSayHiToOakText

ViridianMartLassScript:
	jumptextfaceplayer ViridianMartLassText

ViridianMartCooltrainerMScript:
	jumptextfaceplayer ViridianMartCooltrainerMText

ViridianMart_PlayerStepRightMovement:
	step RIGHT
	step_end

ViridianMart_PlayerToCounterMovement:
	step UP
	step UP
	step UP
	step UP
	step_end

ViridianMartClerkFromPalletText:
	text "Hey! You came from"
	line "PALLET TOWN?"
	done

ViridianMartClerkParcelText:
	text "You know PROF."
	line "OAK, right?"

	para "His order came in."
	line "Will you take it"
	cont "to him?"
	done

ViridianMartClerkSayHiToOakText:
	text "Okay! Say hi to"
	line "PROF.OAK for me!"
	done

ViridianMartLassText:
	text "This shop sells a"
	line "lot of PARLYZ"
	cont "HEALs."
	done

ViridianMartCooltrainerMText:
	text "The shop finally"
	line "has some POTIONs"
	cont "in stock."
	done

ViridianMart_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, VIRIDIAN_CITY, 4
	warp_event  3,  7, VIRIDIAN_CITY, 4

	def_coord_events

	def_bg_events

	def_object_events
	object_event  1,  3, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ViridianMartClerkScript, -1
	object_event  7,  2, SPRITE_LASS, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 2, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ViridianMartLassScript, -1
	object_event  1,  6, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ViridianMartCooltrainerMScript, -1
