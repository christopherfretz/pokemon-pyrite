RedsHouse2F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_NEWMAP, RedsHouse2FInitializeEventsCallback

; Kanto hack: the game starts here instead of New Bark, so run the one-time
; event initialisation that PlayersHouse2F does in vanilla.
RedsHouse2FInitializeEventsCallback:
	checkevent EVENT_INITIALIZED_EVENTS
	iftrue .Skip
	jumpstd InitializeEventsScript
.Skip:
	endcallback

RedsHouse2FSNESScript:
	jumptext RedsHouse2FSNESText

; Yellow's bedroom PC is a working item-storage PC, so use Crystal's own
; player's-house PC script (the Kanto act gets Yellow's four-option menu --
; no MAIL BOX, no DECORATION -- from PCPC_CheckKantoAct).
RedsHouse2FPCScript:
	opentext
	special PlayersHousePC
	iftrue .Warp
	closetext
	end

.Warp:
	warp NONE, 0, 0
	end

RedsHouse2FSNESText:
	text "<PLAYER> is"
	line "playing the SNES!"
	cont "…Okay!"
	cont "It's time to go!"
	done

RedsHouse2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  7,  0, REDS_HOUSE_1F, 3

	def_coord_events

	def_bg_events
	bg_event  3,  5, BGEVENT_READ, RedsHouse2FSNESScript
	bg_event  0,  1, BGEVENT_UP, RedsHouse2FPCScript

	def_object_events
