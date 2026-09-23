roms := \
	pokecrystal.gbc \
	pokecrystal11.gbc \
	pokecrystal_au.gbc \
	pokecrystal_debug.gbc \
	pokecrystal11_debug.gbc
patches := pokecrystal11.patch

rom_obj := \
	audio.o \
	home.o \
	main.o \
	ram.o \
	data/text/common.o \
	data/maps/map_data.o \
	data/pokemon/dex_entries.o \
	data/pokemon/egg_moves.o \
	data/pokemon/evos_attacks.o \
	engine/movie/credits.o \
	engine/overworld/events.o \
	gfx/misc.o \
	gfx/pics.o \
	gfx/sprites.o \
	gfx/tilesets.o \
	lib/mobile/main.o \
	lib/mobile/mail.o

pokecrystal_obj         := $(rom_obj:.o=.o)
pokecrystal11_obj       := $(rom_obj:.o=11.o)
pokecrystal_au_obj      := $(rom_obj:.o=_au.o)
pokecrystal_debug_obj   := $(rom_obj:.o=_debug.o)
pokecrystal11_debug_obj := $(rom_obj:.o=11_debug.o)
pokecrystal11_vc_obj    := $(rom_obj:.o=11_vc.o)


### Build tools

ifeq (,$(shell command -v sha1sum 2>/dev/null))
SHA1 := shasum
else
SHA1 := sha1sum
endif

RGBDS ?=
RGBASM  ?= $(RGBDS)rgbasm
RGBFIX  ?= $(RGBDS)rgbfix
RGBGFX  ?= $(RGBDS)rgbgfx
RGBLINK ?= $(RGBDS)rgblink

RGBASMFLAGS  ?= -Weverything -Wtruncation=1
RGBLINKFLAGS ?= -Weverything -Wtruncation=1
RGBFIXFLAGS  ?= -Weverything
RGBGFXFLAGS  ?= -Weverything


### Build targets

.SUFFIXES:
.SECONDEXPANSION:
.PRECIOUS:
.SECONDARY:
.PHONY: \
	all \
	crystal \
	crystal11 \
	crystal_au \
	crystal_debug \
	crystal11_debug \
	crystal11_vc \
	clean \
	tidy \
	compare \
	tools

PYTHON ?= python3

all: crystal
# The browser save editor (web/edit.html) reads web/tables.json: SRAM offsets,
# name tables and the ROM sha, all derived from this build.  The deployed site
# runs `make crystal` and nothing else, so tables.json has to be part of it.
crystal:         pokecrystal.gbc web/tables.json
crystal11:       pokecrystal11.gbc
crystal_au:      pokecrystal_au.gbc
crystal_debug:   pokecrystal_debug.gbc
crystal11_debug: pokecrystal11_debug.gbc
crystal11_vc:    pokecrystal11.patch

clean: tidy
	find gfx \
	     \( -name "*.[12]bpp" \
	        -o -name "*.lz" \
	        -o -name "*.gbcpal" \
	        -o -name "*.sgb.tilemap" \) \
	     -delete
	find gfx/pokemon -mindepth 1 \
	     ! -path "gfx/pokemon/unown/*" \
	     \( -name "bitmask.asm" \
	        -o -name "frames.asm" \
	        -o -name "front.animated.tilemap" \
	        -o -name "front.dimensions" \) \
	     -delete

tidy:
	$(RM) $(roms) \
	      $(roms:.gbc=.sym) \
	      $(roms:.gbc=.map) \
	      $(patches) \
	      $(patches:.patch=_vc.gbc) \
	      $(patches:.patch=_vc.sym) \
	      $(patches:.patch=_vc.map) \
	      $(patches:%.patch=vc/%.constants.sym) \
	      $(pokecrystal_obj) \
	      $(pokecrystal11_obj) \
	      $(pokecrystal11_vc_obj) \
	      $(pokecrystal_au_obj) \
	      $(pokecrystal_debug_obj) \
	      $(pokecrystal11_debug_obj) \
	      build_rev.txt \
	      web/tables.json \
	      rgbdscheck.o
	$(MAKE) clean -C tools/

compare: $(roms) $(patches)
	@$(SHA1) -c roms.sha1

tools:
	$(MAKE) -C tools/


RGBASMFLAGS += -Q8 -P includes.asm

# Bake the short commit hash into the ROM; the title screen prints it
# (engine/movie/title.asm), so a build pulled from the rolling release can be
# identified on sight.  Override with `make BUILD_REV=...`.
BUILD_REV ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo unknown)
RGBASMFLAGS += -D BUILD_REV=$(BUILD_REV)
# Create a sym/map for debug purposes if `make` run with `DEBUG=1`
ifeq ($(DEBUG),1)
RGBASMFLAGS += -E
endif

$(pokecrystal_obj):         RGBASMFLAGS +=
$(pokecrystal11_obj):       RGBASMFLAGS += -D _CRYSTAL11
$(pokecrystal_au_obj):      RGBASMFLAGS += -D _CRYSTAL11 -D _CRYSTAL_AU
$(pokecrystal_debug_obj):   RGBASMFLAGS += -D _DEBUG
$(pokecrystal11_debug_obj): RGBASMFLAGS += -D _CRYSTAL11 -D _DEBUG
$(pokecrystal11_vc_obj):    RGBASMFLAGS += -D _CRYSTAL11 -D _CRYSTAL11_VC

%.patch: %_vc.gbc %.gbc vc/%.patch.template
# Ignore the checksums added by tools/stadium at the end of the ROM
	tools/make_patch --ignore 0x1ffde0:0x220 $*_vc.sym $^ $@

rgbdscheck.o: rgbdscheck.asm
	$(RGBASM) -o $@ $<

# Build tools when building the rom.
# This has to happen before the rules are processed, since that's when scan_includes is run.
ifeq (,$(filter clean tidy tools,$(MAKECMDGOALS)))

$(info $(shell $(MAKE) -C tools))

# The dep rules have to be explicit or else missing files won't be reported.
# As a side effect, they're evaluated immediately instead of when the rule is invoked.
# It doesn't look like $(shell) can be deferred so there might not be a better way.
preinclude_deps := includes.asm $(shell tools/scan_includes includes.asm)
define DEP
$1: $2 $$(shell tools/scan_includes $2) $(preinclude_deps) | rgbdscheck.o
	$$(RGBASM) $$(RGBASMFLAGS) -o $$@ $$<
endef

# Dependencies for shared objects objects
$(foreach obj, $(pokecrystal_obj), $(eval $(call DEP,$(obj),$(obj:.o=.asm))))
$(foreach obj, $(pokecrystal11_obj), $(eval $(call DEP,$(obj),$(obj:11.o=.asm))))
$(foreach obj, $(pokecrystal_au_obj), $(eval $(call DEP,$(obj),$(obj:_au.o=.asm))))
$(foreach obj, $(pokecrystal_debug_obj), $(eval $(call DEP,$(obj),$(obj:_debug.o=.asm))))
$(foreach obj, $(pokecrystal11_debug_obj), $(eval $(call DEP,$(obj),$(obj:11_debug.o=.asm))))
$(foreach obj, $(pokecrystal11_vc_obj), $(eval $(call DEP,$(obj),$(obj:11_vc.o=.asm))))

# Only the objects built from main.asm embed BUILD_REV, so rebuild just those
# when HEAD moves.  build_rev.txt is rewritten only when the hash changes, so a
# rebuild with no new commit is still a no-op.
$(shell [ "`cat build_rev.txt 2>/dev/null`" = "$(BUILD_REV)" ] || echo "$(BUILD_REV)" > build_rev.txt)
main.o main11.o main_au.o main_debug.o main11_debug.o main11_vc.o: build_rev.txt

endif


RGBFIXFLAGS += -Cjv -t PM_CRYSTAL -k 01 -l 0x33 -m MBC3+TIMER+RAM+BATTERY -r 3 -p 0
pokecrystal.gbc:         RGBFIXFLAGS += -i BYTE -n 0
pokecrystal11.gbc:       RGBFIXFLAGS += -i BYTE -n 1
pokecrystal_au.gbc:      RGBFIXFLAGS += -i BYTU -n 0
pokecrystal_debug.gbc:   RGBFIXFLAGS += -i BYTE -n 0
pokecrystal11_debug.gbc: RGBFIXFLAGS += -i BYTE -n 1
pokecrystal11_vc.gbc:    RGBFIXFLAGS += -i BYTE -n 1

%.gbc: $$(%_obj) layout.link
	$(RGBLINK) $(RGBLINKFLAGS) -l layout.link -n $*.sym -m $*.map -o $@ $(filter %.o,$^)
	$(RGBFIX) $(RGBFIXFLAGS) $@
	tools/stadium $@

web/tables.json: web/gen_tables.py pokecrystal.gbc pokecrystal.sym \
                 $(wildcard constants/*.asm) \
                 data/maps/spawn_points.asm data/growth_rates.asm \
                 data/items/names.asm data/items/attributes.asm \
                 data/pokemon/names.asm data/moves/names.asm \
                 engine/math/get_square_root.asm
	$(PYTHON) web/gen_tables.py --root . --out $@

# pokecrystal.sym is a side effect of the link rule above.
pokecrystal.sym: pokecrystal.gbc
	@test -f $@


### LZ compression rules

# Delete this line if you don't care about matching and just want optimal compression.
include gfx/lz.mk

%.lz: %
	tools/lzcompress $(LZFLAGS) -- $< $@


### Pokemon pic animation rules

gfx/pokemon/%/front.animated.2bpp: gfx/pokemon/%/front.2bpp gfx/pokemon/%/front.dimensions
	tools/pokemon_animation_graphics -o $@ $^
gfx/pokemon/%/front.animated.tilemap: gfx/pokemon/%/front.2bpp gfx/pokemon/%/front.dimensions
	tools/pokemon_animation_graphics -t $@ $^
gfx/pokemon/%/bitmask.asm: gfx/pokemon/%/front.animated.tilemap gfx/pokemon/%/front.dimensions
	tools/pokemon_animation -b $^ > $@
gfx/pokemon/%/frames.asm: gfx/pokemon/%/front.animated.tilemap gfx/pokemon/%/front.dimensions
	tools/pokemon_animation -f $^ > $@


### Terrible hacks to match animations. Delete these rules if you don't care about matching.

# Dewgong has an unused tile id in its last frame. The tile itself is missing.
gfx/pokemon/dewgong/frames.asm: gfx/pokemon/dewgong/front.animated.tilemap gfx/pokemon/dewgong/front.dimensions
	tools/pokemon_animation -f $^ > $@
	echo "	db \$$4d" >> $@

# Lugia has two unused tile ids in its last frame. The tiles themselves are missing.
gfx/pokemon/lugia/frames.asm: gfx/pokemon/lugia/front.animated.tilemap gfx/pokemon/lugia/front.dimensions
	tools/pokemon_animation -f $^ > $@
	echo "	db \$$5e, \$$59" >> $@

# Girafarig has a redundant tile after the end. It is used in two frames, so it must be injected into the generated graphics.
# This is more involved, so it's hacked into pokemon_animation_graphics.
gfx/pokemon/girafarig/front.animated.2bpp: gfx/pokemon/girafarig/front.2bpp gfx/pokemon/girafarig/front.dimensions
	tools/pokemon_animation_graphics --girafarig -o $@ $^
gfx/pokemon/girafarig/front.animated.tilemap: gfx/pokemon/girafarig/front.2bpp gfx/pokemon/girafarig/front.dimensions
	tools/pokemon_animation_graphics --girafarig -t $@ $^


### Pikachu face-box (pikapic) rules
# The 23 blobs Yellow stored as Gen-1 .pic sprites: pkmncompress transposes
# tiles before compressing, so the in-game VRAM order of these 5x5 squares is
# column-major.  Build them with --columns so E3's loader is just
# FarDecompress + copy (docs/PIKACHU-EMOTIONS.md, E1/E2 findings).
PIKAPIC_COLUMN_2BPP := gfx/pikachu/unknown_e4000.2bpp gfx/pikachu/unknown_e411c.2bpp gfx/pikachu/unknown_e4272.2bpp gfx/pikachu/unknown_e4383.2bpp gfx/pikachu/unknown_e458b.2bpp gfx/pikachu/unknown_e467b.2bpp gfx/pikachu/unknown_e476e.2bpp gfx/pikachu/unknown_e49d1.2bpp gfx/pikachu/unknown_e4b39.2bpp gfx/pikachu/unknown_e4c3e.2bpp gfx/pikachu/unknown_e5000.2bpp gfx/pikachu/unknown_e523f.2bpp gfx/pikachu/unknown_e548e.2bpp gfx/pikachu/unknown_e56d1.2bpp gfx/pikachu/unknown_e5924.2bpp gfx/pikachu/unknown_e5b7d.2bpp gfx/pikachu/unknown_e5ddd.2bpp gfx/pikachu/unknown_e6340.2bpp gfx/pikachu/unknown_e6587.2bpp gfx/pikachu/unknown_e67d6.2bpp gfx/pikachu/unknown_e77cf.2bpp gfx/pikachu/unknown_f0abf.2bpp gfx/pikachu/unknown_f0cf4.2bpp
$(PIKAPIC_COLUMN_2BPP): RGBGFXFLAGS += --columns

### Pokemon and trainer sprite rules

gfx/pokemon/%/back.2bpp: RGBGFXFLAGS += --columns
gfx/pokemon/%/back.2bpp: gfx/pokemon/%/back.png gfx/pokemon/%/normal.gbcpal
	$(RGBGFX) $(RGBGFXFLAGS) --colors gbc:$(word 2,$^) -o $@ $<
gfx/pokemon/%/front.2bpp: gfx/pokemon/%/front.png gfx/pokemon/%/normal.gbcpal
	$(RGBGFX) $(RGBGFXFLAGS) --colors gbc:$(word 2,$^) -o $@ $<
gfx/pokemon/%/normal.gbcpal: gfx/pokemon/%/front.gbcpal gfx/pokemon/%/back.gbcpal
	tools/gbcpal $(tools/gbcpal) $@ $^

gfx/trainers/%.2bpp: RGBGFXFLAGS += --columns
gfx/trainers/%.2bpp: gfx/trainers/%.png gfx/trainers/%.gbcpal
	$(RGBGFX) $(RGBGFXFLAGS) --colors gbc:$(word 2,$^) -o $@ $<

# Kanto hack (B2): make only prefers the rule above over the catch-all
# `%.2bpp: %.png` (--colors dmg, at the bottom of this file) when the .gbcpal
# prerequisite already EXISTS or is an explicit target -- a pattern rule whose
# prerequisite would itself have to be made implicitly loses the first pass of
# make's implicit-rule search.  Every trainer palette is INCBIN'd by
# data/trainers/palettes.asm and so happens to be built first, EXCEPT janine's:
# M7 10h renamed JANINE's class slot to KOGA_LEADER and pointed its palette row
# at koga.gbcpal, while gfx/pics.asm still assembles JaninePic.  From a clean
# checkout that made gfx/trainers/janine.2bpp fall through to --colors dmg,
# which a colour trainer pic cannot satisfy ("it contains a non-gray color
# #f7947b"); a warm tree only built because a stale .2bpp was on disk.
# A static pattern rule makes every trainer palette an explicit target, so rule
# selection no longer depends on what else happens to reference the .gbcpal.
trainer_gbcpals := $(patsubst %.png,%.gbcpal,$(wildcard gfx/trainers/*.png))
$(trainer_gbcpals): %.gbcpal: %.png
	$(RGBGFX) -p $@ $<
	tools/gbcpal $(tools/gbcpal) $@ $@ || ($(RM) $@ && false)

# Egg does not have a back sprite, so it only uses front.gbcpal
gfx/pokemon/egg/front.2bpp: gfx/pokemon/egg/front.png gfx/pokemon/egg/front.gbcpal
gfx/pokemon/egg/front.2bpp: RGBGFXFLAGS += --colors gbc:$(word 2,$^)

# Unown letters share one normal.gbcpal
unown_pngs := $(wildcard gfx/pokemon/unown_*/front.png) $(wildcard gfx/pokemon/unown_*/back.png)
$(foreach png, $(unown_pngs),\
	$(eval $(png:.png=.2bpp): $(png) gfx/pokemon/unown/normal.gbcpal))
gfx/pokemon/unown_%/back.2bpp: RGBGFXFLAGS += --colors gbc:$(word 2,$^)
gfx/pokemon/unown_%/front.2bpp: RGBGFXFLAGS += --colors gbc:$(word 2,$^)
gfx/pokemon/unown/normal.gbcpal: $(subst .png,.gbcpal,$(unown_pngs))
	tools/gbcpal $(tools/gbcpal) $@ $^


### Misc file-specific graphics rules

gfx/pokemon/egg/unused_front.2bpp: RGBGFXFLAGS += --columns

gfx/pokemon/spearow/normal.gbcpal: tools/gbcpal += --reverse
gfx/pokemon/fearow/normal.gbcpal: tools/gbcpal += --reverse
gfx/pokemon/farfetch_d/normal.gbcpal: tools/gbcpal += --reverse
gfx/pokemon/hitmonlee/normal.gbcpal: tools/gbcpal += --reverse
gfx/pokemon/scyther/normal.gbcpal: tools/gbcpal += --reverse
gfx/pokemon/jynx/normal.gbcpal: tools/gbcpal += --reverse
gfx/pokemon/porygon/normal.gbcpal: tools/gbcpal += --reverse
gfx/pokemon/porygon2/normal.gbcpal: tools/gbcpal += --reverse

gfx/trainers/swimmer_m.gbcpal: tools/gbcpal += --reverse

gfx/new_game/shrink1.2bpp: RGBGFXFLAGS += --columns
gfx/new_game/shrink2.2bpp: RGBGFXFLAGS += --columns

gfx/mail/dragonite.1bpp: tools/gfx += --remove-whitespace
gfx/mail/large_note.1bpp: tools/gfx += --remove-whitespace
gfx/mail/surf_mail_border.1bpp: tools/gfx += --remove-whitespace
gfx/mail/flower_mail_border.1bpp: tools/gfx += --remove-whitespace
gfx/mail/litebluemail_border.1bpp: tools/gfx += --remove-whitespace

### Kanto hack (M12b-2): Yellow trims the Surfing Pikachu intro sheet too
gfx/surfing_pikachu/surfing_pikachu_1c.2bpp: tools/gfx += --trim-whitespace

gfx/pokedex/pokedex.2bpp: tools/gfx += --trim-whitespace
gfx/pokedex/pokedex_sgb.2bpp: tools/gfx += --trim-whitespace
gfx/pokedex/question_mark.2bpp: RGBGFXFLAGS += --columns
gfx/pokedex/slowpoke.2bpp: tools/gfx += --trim-whitespace

gfx/pokegear/pokegear.2bpp: RGBGFXFLAGS += --trim-end 2
gfx/pokegear/pokegear_sprites.2bpp: tools/gfx += --trim-whitespace

gfx/mystery_gift/mystery_gift.2bpp: tools/gfx += --trim-whitespace

gfx/title/crystal.2bpp: tools/gfx += --interleave --png=$<
gfx/title/old_fg.2bpp: tools/gfx += --interleave --png=$<
gfx/title/logo.2bpp: RGBGFXFLAGS += --trim-end 4

gfx/trade/ball.2bpp: tools/gfx += --remove-whitespace
gfx/trade/game_boy.2bpp: tools/gfx += --remove-duplicates --preserve=0x23,0x27
gfx/trade/game_boy_cable.2bpp: gfx/trade/game_boy.2bpp gfx/trade/link_cable.2bpp ; cat $^ > $@

gfx/slots/slots_1.2bpp: tools/gfx += --trim-whitespace
gfx/slots/slots_2.2bpp: tools/gfx += --interleave --png=$<
gfx/slots/slots_3.2bpp: tools/gfx += --interleave --png=$< --remove-duplicates --keep-whitespace --remove-xflip

gfx/card_flip/card_flip_1.2bpp: tools/gfx += --trim-whitespace
gfx/card_flip/card_flip_2.2bpp: tools/gfx += --remove-whitespace

gfx/battle_anims/angels.2bpp: tools/gfx += --trim-whitespace
gfx/battle_anims/beam.2bpp: tools/gfx += --remove-xflip --remove-yflip --remove-whitespace
gfx/battle_anims/bubble.2bpp: tools/gfx += --trim-whitespace
gfx/battle_anims/charge.2bpp: tools/gfx += --trim-whitespace
gfx/battle_anims/egg.2bpp: tools/gfx += --remove-whitespace
gfx/battle_anims/explosion.2bpp: tools/gfx += --remove-whitespace
gfx/battle_anims/hit.2bpp: tools/gfx += --remove-whitespace
gfx/battle_anims/horn.2bpp: tools/gfx += --remove-whitespace
gfx/battle_anims/lightning.2bpp: tools/gfx += --remove-whitespace
gfx/battle_anims/misc.2bpp: tools/gfx += --remove-duplicates --remove-xflip
gfx/battle_anims/noise.2bpp: tools/gfx += --remove-whitespace
gfx/battle_anims/objects.2bpp: tools/gfx += --remove-whitespace --remove-xflip
gfx/battle_anims/pokeball.2bpp: tools/gfx += --remove-xflip --keep-whitespace
gfx/battle_anims/reflect.2bpp: tools/gfx += --remove-whitespace
gfx/battle_anims/rocks.2bpp: tools/gfx += --remove-whitespace
gfx/battle_anims/skyattack.2bpp: tools/gfx += --remove-whitespace
gfx/battle_anims/status.2bpp: tools/gfx += --remove-whitespace

gfx/player/chris.2bpp: RGBGFXFLAGS += --columns
gfx/player/chris_back.2bpp: RGBGFXFLAGS += --columns
gfx/player/kris.2bpp: RGBGFXFLAGS += --columns
gfx/player/kris_back.2bpp: RGBGFXFLAGS += --columns

gfx/trainer_card/chris_card.2bpp: RGBGFXFLAGS += --columns
gfx/trainer_card/kris_card.2bpp: RGBGFXFLAGS += --columns
gfx/trainer_card/leaders.2bpp: tools/gfx += --trim-whitespace

gfx/overworld/chris_fish.2bpp: tools/gfx += --trim-whitespace
gfx/overworld/kris_fish.2bpp: tools/gfx += --trim-whitespace

gfx/sprites/big_onix.2bpp: tools/gfx += --remove-whitespace --remove-xflip

gfx/battle/dude.2bpp: RGBGFXFLAGS += --columns
gfx/battle/oak_back.2bpp: RGBGFXFLAGS += --columns
gfx/battle/old_man_back.2bpp: RGBGFXFLAGS += --columns

gfx/font/unused_bold_font.1bpp: tools/gfx += --trim-whitespace

gfx/sgb/sgb_border.2bpp: tools/gfx += --trim-whitespace
gfx/sgb/sgb_border.sgb.tilemap: gfx/sgb/sgb_border.bin ; tr < $< -d '\000' > $@

gfx/mobile/ascii_font.2bpp: tools/gfx += --trim-whitespace
gfx/mobile/dialpad.2bpp: tools/gfx += --trim-whitespace
gfx/mobile/dialpad_cursor.2bpp: tools/gfx += --trim-whitespace
gfx/mobile/electro_ball.2bpp: tools/gfx += --remove-duplicates --remove-xflip --preserve=0x39
gfx/mobile/mobile_splash.2bpp: tools/gfx += --remove-duplicates --remove-xflip
gfx/mobile/card.2bpp: tools/gfx += --trim-whitespace
gfx/mobile/card_2.2bpp: tools/gfx += --trim-whitespace
gfx/mobile/card_folder.2bpp: tools/gfx += --trim-whitespace
gfx/mobile/phone_tiles.2bpp: tools/gfx += --remove-whitespace
gfx/mobile/pichu_animated.2bpp: tools/gfx += --trim-whitespace
gfx/mobile/stadium2_n64.2bpp: tools/gfx += --trim-whitespace


# Kanto hack M6 9d: the POKéMON TOWER ghost frontpic.  Yellow's 6x6 sprite,
# pre-padded to the 7x7 box PadFrontpic would produce, so the loader is a plain
# Get2bpp -- which means it has to be assembled in the column-major order the
# frontpic pipeline uses (docs/M6-TOWER.md 9d findings).
gfx/battle/ghost.2bpp: RGBGFXFLAGS += --columns

### Catch-all graphics rules

%.2bpp: %.png
	$(RGBGFX) --colors dmg $(RGBGFXFLAGS) -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -o $@ $@ || $$($(RM) $@ && false))

%.1bpp: %.png
	$(RGBGFX) --colors dmg $(RGBGFXFLAGS) --depth 1 -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) --depth 1 -o $@ $@ || $$($(RM) $@ && false))

%.gbcpal: %.png
	$(RGBGFX) -p $@ $<
	tools/gbcpal $(tools/gbcpal) $@ $@ || $$($(RM) $@ && false)

%.dimensions: %.png
	tools/png_dimensions $< $@


### File extensions that are never generated and should be manually created

%.inc: ;
%.pal: ;
%.bin: ;
%.blk: ;
%.rle: ;
