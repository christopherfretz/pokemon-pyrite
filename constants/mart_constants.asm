; mart types (see engine/items/mart.asm)
	const_def
	const MARTTYPE_STANDARD
	const MARTTYPE_BITTER
	const MARTTYPE_BARGAIN
	const MARTTYPE_PHARMACY
	const MARTTYPE_ROOFTOP
DEF NUM_MART_TYPES EQU const_value

; Marts indexes (see data/items/marts.asm)
	const_def
	const MART_CHERRYGROVE
	const MART_CHERRYGROVE_DEX
	const MART_VIOLET
	const MART_AZALEA
	const MART_CIANWOOD
	const MART_GOLDENROD_2F_1
	const MART_GOLDENROD_2F_2
	const MART_GOLDENROD_3F
	const MART_GOLDENROD_4F
	const MART_GOLDENROD_5F_1
	const MART_GOLDENROD_5F_2
	const MART_GOLDENROD_5F_3
	const MART_GOLDENROD_5F_4
	const MART_OLIVINE
	const MART_ECRUTEAK
	const MART_MAHOGANY_1
	const MART_MAHOGANY_2
	const MART_BLACKTHORN
	const MART_VIRIDIAN
	const MART_PEWTER
	const MART_CERULEAN
	const MART_LAVENDER
	const MART_VERMILION
	const MART_CELADON_2F_1
	const MART_CELADON_2F_2
; Kanto hack (M6 9r): MART_CELADON_3F was here.  Yellow's CELADON MART 3F is the
; TV GAME SHOP -- it has no clerk and sells nothing.
	const MART_CELADON_4F
	const MART_CELADON_5F_1
	const MART_CELADON_5F_2
	const MART_FUCHSIA
	const MART_SAFFRON
	const MART_MT_MOON
	const MART_INDIGO_PLATEAU
	const MART_UNDERGROUND
; Kanto hack (M9 12h): Yellow's CINNABAR MART, appended so no existing
; index moves.
	const MART_CINNABAR
DEF NUM_MARTS EQU const_value
