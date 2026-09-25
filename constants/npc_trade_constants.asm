; npctrade struct members (see data/events/npc_trades.asm)
rsreset
DEF NPCTRADE_DIALOG   rb
DEF NPCTRADE_GIVEMON  rb
DEF NPCTRADE_GETMON   rb
DEF NPCTRADE_NICKNAME rb MON_NAME_LENGTH
DEF NPCTRADE_DVS      rw
DEF NPCTRADE_ITEM     rb
DEF NPCTRADE_OT_ID    rw
DEF NPCTRADE_OT_NAME  rb NAME_LENGTH
DEF NPCTRADE_GENDER   rb
                      rb_skip
DEF NPCTRADE_STRUCT_LENGTH EQU _RS

; NPCTrades indexes (see data/events/npc_trades.asm)
	const_def
	const NPC_TRADE_MIKE   ; 0
	const NPC_TRADE_KYLE   ; 1
	const NPC_TRADE_TIM    ; 2
	const NPC_TRADE_EMY    ; 3
	const NPC_TRADE_CHRIS  ; 4
	const NPC_TRADE_KIM    ; 5 ; Kanto hack (A251): Crystal's ROUTE 14 trade was deleted with TEACHER Kim (M7 10d); the row now pays a foreign-OT PIKACHU in CHERRYGROVE (the RAICHU route).
	const NPC_TRADE_FOREST ; 6
	const NPC_TRADE_MILES  ; 7 ; Kanto hack (docs/M2-PEWTER.md, 4f)
	const NPC_TRADE_RICKY  ; 8 ; Kanto hack (docs/M4-VERMILION.md, 7d)
	const NPC_TRADE_GURIO  ; 9 ; Kanto hack (docs/M4-VERMILION.md, 7l)
	const NPC_TRADE_SPIKE  ; 10 ; Kanto hack (docs/M6-CELADON.md, 9aa)
	const NPC_TRADE_BUFFY   ; 11 ; Kanto hack (docs/M9-CINNABAR.md, 12i)
	const NPC_TRADE_CEZANNE ; 12 ; Kanto hack (docs/M9-CINNABAR.md, 12i)
	const NPC_TRADE_STICKY  ; 13 ; Kanto hack (docs/M9-CINNABAR.md, 12i)
DEF NUM_NPC_TRADES EQU const_value

; trade gender limits
	const_def
	const TRADE_GENDER_EITHER
	const TRADE_GENDER_MALE
	const TRADE_GENDER_FEMALE

; TradeTexts indexes (see engine/events/npc_trade.asm)

; trade dialogs
	const_def
	const TRADE_DIALOG_INTRO
	const TRADE_DIALOG_CANCEL
	const TRADE_DIALOG_WRONG
	const TRADE_DIALOG_COMPLETE
	const TRADE_DIALOG_AFTER
DEF NUM_TRADE_DIALOGS EQU const_value

; trade dialog sets
	const_def
	const TRADE_DIALOGSET_COLLECTOR
	const TRADE_DIALOGSET_HAPPY
	const TRADE_DIALOGSET_NEWBIE
	const TRADE_DIALOGSET_GIRL
	const TRADE_DIALOGSET_CASUAL ; Kanto hack: Yellow's CASUAL trader voice
	const TRADE_DIALOGSET_YELLOW_HAPPY ; Kanto hack: Yellow's HAPPY trader voice (7d)
	const TRADE_DIALOGSET_YELLOW_EVOLUTION ; Kanto hack: Yellow's EVOLUTION trader voice (12i, D108)
DEF NUM_TRADE_DIALOGSETS EQU const_value
