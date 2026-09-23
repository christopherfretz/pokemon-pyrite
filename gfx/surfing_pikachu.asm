; Kanto hack (M12b-2): Yellow's Surfing Pikachu minigame graphics
; (pokeyellow gfx/surfing_pikachu.asm), split across three banks with room.
; surfing_pikachu_2 (the results card / printer art) is M12b-4's.

SECTION "Surfing Pikachu Graphics 1", ROMX

SurfingPikachu1Graphics1:: INCBIN "gfx/surfing_pikachu/surfing_pikachu_1a.2bpp"

SECTION "Surfing Pikachu Graphics 2", ROMX

SurfingPikachu1Graphics2:: INCBIN "gfx/surfing_pikachu/surfing_pikachu_1b.2bpp"

SECTION "Surfing Pikachu Graphics 3", ROMX

SurfingPikachu1Graphics3:: INCBIN "gfx/surfing_pikachu/surfing_pikachu_1c.2bpp"
