IrwinRumorScript:
; Kanto hack (M11 14k): newest news first, in the Kanto-first order.  The
; KANTO act is over before IRWIN can be met, so Crystal's SNORLAX, MARSHBADGE
; ("a ruckus over in KANTO") and ELITE FOUR ("your mom in NEW BARK") rumors
; are gone; the "world championship" rumor waits for the MT.SILVER LANCE.
	checkevent EVENT_BEAT_LANCE_MT_SILVER
	iftrue .MtSilver
	checkflag ENGINE_RISINGBADGE
	iftrue .RisingBadge
	checkevent EVENT_CLEARED_RADIO_TOWER
	iftrue .RadioTower
	checkevent EVENT_CLEARED_ROCKET_HIDEOUT
	iftrue .RocketHideout
	checkevent EVENT_GOT_PASS_FROM_COPYCAT
	iftrue .TrainPass
; Kanto hack (M11 14i): ENGINE_FLYPOINT_VERMILION is set in the KANTO act,
; long before any ship; key "striding onto a ship" on the S.S.AQUA's first
; crossing instead.
	checkevent EVENT_FAST_SHIP_FIRST_TIME
	iftrue .VermilionCity
	checkevent EVENT_JASMINE_RETURNED_TO_GYM
	iftrue .JasmineReturned
	checkflag ENGINE_FOGBADGE
	iftrue .FogBadge
	checkflag ENGINE_PLAINBADGE
	iftrue .PlainBadge
	farwritetext IrwinCalledRightAwayText
	promptbutton
	sjump PhoneScript_HangUpText_Male

.PlainBadge:
	farwritetext IrwinPlainBadgeGossipText
	promptbutton
	sjump PhoneScript_HangUpText_Male

.JasmineReturned:
	farwritetext IrwinJasmineReturnedGossipText
	promptbutton
	sjump PhoneScript_HangUpText_Male

.RocketHideout:
	farwritetext IrwinRocketHideoutGossipText
	promptbutton
	sjump PhoneScript_HangUpText_Male

.RadioTower:
	farwritetext IrwinRadioTowerGossipText
	promptbutton
	sjump PhoneScript_HangUpText_Male

.RisingBadge:
	farwritetext IrwinRisingBadgeGossipText
	promptbutton
	sjump PhoneScript_HangUpText_Male


.VermilionCity:
	farwritetext IrwinVermilionCityGossipText
	promptbutton
	sjump PhoneScript_HangUpText_Male

.TrainPass:
	farwritetext IrwinTrainPassGossipText
	promptbutton
	sjump PhoneScript_HangUpText_Male


.MtSilver:
	farwritetext IrwinMtSilverGossipText
	promptbutton
	sjump PhoneScript_HangUpText_Male

.FogBadge:
	farwritetext IrwinFogBadgeGossipText
	promptbutton
	sjump PhoneScript_HangUpText_Male

