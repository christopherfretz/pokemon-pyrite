; Yellow's Pikachu face-box ("pikapic") artwork, ported from
; vendor/pokeyellow/gfx/pikachu.asm (docs/PIKACHU-EMOTIONS.md A5 step E1).
;
; The PNGs are Yellow's, byte-for-byte: Crystal's catch-all `%.2bpp: %.png`
; rule is identical to Yellow's, so every .2bpp built here is identical to the
; one Yellow's build produces.  Yellow additionally ran `tools/pkmncompress`
; over 23 of them to make .pic blobs; we run Crystal's `tools/lzcompress`
; instead and keep the same 23 compressed (see E1 findings in the doc).
; Labels keep Yellow's names so PikaPicAnimGFXHeaders stays greppable.
;
; Yellow's split was 21 compressed + 36 raw / 2 + 2.  Crystal's lz is slightly
; less dense than Gen 1's sprite codec (17793 B vs 17142 B), and no Crystal bank
; has a 16 KB hole, so the cut moves: "Pikachu Graphics 1" holds the first 54
; blobs in Yellow's order (15550 B, bank $7f) and "Pikachu Graphics 2" the
; remaining 7 (2243 B, bank $78).  Membership is irrelevant at runtime:
; every blob is reached through a `dba` in PikaPicAnimGFXHeaders.

SECTION "Pikachu Graphics 1", ROMX, BANK[$7F]

Pic_e4000::
INCBIN "gfx/pikachu/unknown_e4000.2bpp.lz"
GFX_e40cc::
INCBIN "gfx/pikachu/unknown_e40cc.2bpp"
Pic_e411c::
INCBIN "gfx/pikachu/unknown_e411c.2bpp.lz"
GFX_e41d2::
INCBIN "gfx/pikachu/unknown_e41d2.2bpp"
Pic_e4272::
INCBIN "gfx/pikachu/unknown_e4272.2bpp.lz"
GFX_e4323::
INCBIN "gfx/pikachu/unknown_e4323.2bpp"
Pic_e4383::
INCBIN "gfx/pikachu/unknown_e4383.2bpp.lz"
GFX_e444b::
INCBIN "gfx/pikachu/unknown_e444b.2bpp"
Pic_e458b::
INCBIN "gfx/pikachu/unknown_e458b.2bpp.lz"
GFX_e463b::
INCBIN "gfx/pikachu/unknown_e463b.2bpp"
Pic_e467b::
INCBIN "gfx/pikachu/unknown_e467b.2bpp.lz"
GFX_e472e::
INCBIN "gfx/pikachu/unknown_e472e.2bpp"
Pic_e476e::
INCBIN "gfx/pikachu/unknown_e476e.2bpp.lz"
GFX_e4841::
INCBIN "gfx/pikachu/unknown_e4841.2bpp"
Pic_e49d1::
INCBIN "gfx/pikachu/unknown_e49d1.2bpp.lz"
GFX_e4a99::
INCBIN "gfx/pikachu/unknown_e4a99.2bpp"
Pic_e4b39::
INCBIN "gfx/pikachu/unknown_e4b39.2bpp.lz"
GFX_e4bde::
INCBIN "gfx/pikachu/unknown_e4bde.2bpp"
Pic_e4c3e::
INCBIN "gfx/pikachu/unknown_e4c3e.2bpp.lz"
GFX_e4ce0::
INCBIN "gfx/pikachu/unknown_e4ce0.2bpp"
GFX_e4e70::
INCBIN "gfx/pikachu/unknown_e4e70.2bpp"
Pic_e5000::
INCBIN "gfx/pikachu/unknown_e5000.2bpp.lz"
GFX_e50af::
INCBIN "gfx/pikachu/unknown_e50af.2bpp"
Pic_e523f::
INCBIN "gfx/pikachu/unknown_e523f.2bpp.lz"
GFX_e52fe::
INCBIN "gfx/pikachu/unknown_e52fe.2bpp"
Pic_e548e::
INCBIN "gfx/pikachu/unknown_e548e.2bpp.lz"
GFX_e5541::
INCBIN "gfx/pikachu/unknown_e5541.2bpp"
Pic_e56d1::
INCBIN "gfx/pikachu/unknown_e56d1.2bpp.lz"
GFX_e5794::
INCBIN "gfx/pikachu/unknown_e5794.2bpp"
Pic_e5924::
INCBIN "gfx/pikachu/unknown_e5924.2bpp.lz"
GFX_e59ed::
INCBIN "gfx/pikachu/unknown_e59ed.2bpp"
Pic_e5b7d::
INCBIN "gfx/pikachu/unknown_e5b7d.2bpp.lz"
GFX_e5c4d::
INCBIN "gfx/pikachu/unknown_e5c4d.2bpp"
Pic_e5ddd::
INCBIN "gfx/pikachu/unknown_e5ddd.2bpp.lz"
GFX_e5e90::
INCBIN "gfx/pikachu/unknown_e5e90.2bpp"
GFX_e6020::
INCBIN "gfx/pikachu/unknown_e6020.2bpp"
GFX_e61b0::
INCBIN "gfx/pikachu/unknown_e61b0.2bpp"
Pic_e6340::
INCBIN "gfx/pikachu/unknown_e6340.2bpp.lz"
GFX_e63f7::
INCBIN "gfx/pikachu/unknown_e63f7.2bpp"
Pic_e6587::
INCBIN "gfx/pikachu/unknown_e6587.2bpp.lz"
GFX_e6646::
INCBIN "gfx/pikachu/unknown_e6646.2bpp"
Pic_e67d6::
INCBIN "gfx/pikachu/unknown_e67d6.2bpp.lz"
GFX_e682f::
INCBIN "gfx/pikachu/unknown_e682f.2bpp"
GFX_e69bf::
INCBIN "gfx/pikachu/unknown_e69bf.2bpp"
GFX_e6b4f::
INCBIN "gfx/pikachu/unknown_e6b4f.2bpp"
GFX_e6cdf::
INCBIN "gfx/pikachu/unknown_e6cdf.2bpp"
GFX_e6e6f::
INCBIN "gfx/pikachu/unknown_e6e6f.2bpp"
GFX_e6fff::
INCBIN "gfx/pikachu/unknown_e6fff.2bpp"
GFX_e718f::
INCBIN "gfx/pikachu/unknown_e718f.2bpp"
GFX_e731f::
INCBIN "gfx/pikachu/unknown_e731f.2bpp"
GFX_e74af::
INCBIN "gfx/pikachu/unknown_e74af.2bpp"
GFX_e763f::
INCBIN "gfx/pikachu/unknown_e763f.2bpp"
Pic_e77cf::
INCBIN "gfx/pikachu/unknown_e77cf.2bpp.lz"
GFX_e7863::
INCBIN "gfx/pikachu/unknown_e7863.2bpp"


SECTION "Pikachu Graphics 2", ROMX, BANK[$78]

GFX_e79f3::
INCBIN "gfx/pikachu/unknown_e79f3.2bpp"
GFX_e7b83::
INCBIN "gfx/pikachu/unknown_e7b83.2bpp"
GFX_e7d13::
INCBIN "gfx/pikachu/unknown_e7d13.2bpp"
Pic_f0abf::
INCBIN "gfx/pikachu/unknown_f0abf.2bpp.lz"
GFX_f0b64::
INCBIN "gfx/pikachu/unknown_f0b64.2bpp"
Pic_f0cf4::
INCBIN "gfx/pikachu/unknown_f0cf4.2bpp.lz"
GFX_f0d82::
INCBIN "gfx/pikachu/unknown_f0d82.2bpp"
