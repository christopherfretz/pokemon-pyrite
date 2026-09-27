#!/usr/bin/env bash
# Rebuild the vendored emulator core (binjgb.js + binjgb.wasm in this folder)
# from source.  Nothing needs this to *run* the page -- the artefacts are
# committed -- it is here so the committed blobs are reproducible.
#
# Source: the git submodule ../binjgb-src, the fork
#   https://github.com/christopherfretz/binjgb  branch pyrite-rtc
# = upstream binji/binjgb c60e138d + one commit that exports an MBC3 RTC
# getter/setter (emulator_get_rtc_seconds_f64 / emulator_set_rtc_seconds_f64).
#
# Toolchain: Emscripten 5.0.7, the version upstream used for its own
# docs/binjgb.{js,wasm} (commit 4fd2ad0).  Either have emcc on PATH (source
# emsdk_env.sh) or set EMSDK to an emsdk checkout.  In the pokemon-romhack-
# helper workspace: `PROVISION_EMSDK=1 scripts/provision.sh` installs it into
# tools/emsdk.
#
# Build flags: exactly upstream's `make demo` (= `make wasm`): CMake Release,
# -DWASM=true -DWERROR=ON, RGBDS_LIVE and GBSTUDIO off; the link flags are the
# ones in the fork's CMakeLists.txt (MODULARIZE, EXPORT_NAME=Binjgb, emmalloc,
# fixed heap, EXPORTED_FUNCTIONS from src/emscripten/exported.json).  One
# addition: -ffile-prefix-map, so assert()'s __FILE__ strings say
# binjgb/src/... instead of the absolute checkout path -- that keeps the wasm
# byte-identical wherever the tree is checked out.
#
# Usage:  web/vendor/binjgb/build.sh [path-to-binjgb-source]
# After a rebuild: update VERSION.txt (hashes) and, if the fork commit
# changed, CORE_COMMIT in web/app.js.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="${1:-$HERE/../binjgb-src}"
EMSCRIPTEN_WANT=5.0.7

if [ ! -f "$SRC/CMakeLists.txt" ]; then
  # The submodule was never initialised (a plain clone of pyrite).
  REPO="$(git -C "$HERE" rev-parse --show-toplevel)"
  git -C "$REPO" submodule update --init web/vendor/binjgb-src
fi

if ! command -v emcc >/dev/null; then
  : "${EMSDK:?emcc not on PATH and EMSDK not set -- install emsdk $EMSCRIPTEN_WANT}"
  # shellcheck disable=SC1091
  source "$EMSDK/emsdk_env.sh" >/dev/null
fi
got="$(emcc --version | head -1 | sed -n 's/.* \([0-9][0-9.]*\) (.*/\1/p')"
[ "$got" = "$EMSCRIPTEN_WANT" ] || echo "build.sh: WARNING emcc $got, artefacts were built with $EMSCRIPTEN_WANT" >&2

EMCMAKE_DIR="$(dirname "$(command -v emcc)")"
OUT="$(mktemp -d "${TMPDIR:-/tmp}/binjgb-build.XXXXXX")"
trap 'rm -rf -- "$OUT"' EXIT
cmake -S "$SRC" -B "$OUT" \
  -DCMAKE_TOOLCHAIN_FILE="$EMCMAKE_DIR/cmake/Modules/Platform/Emscripten.cmake" \
  -DCMAKE_BUILD_TYPE=Release -DWERROR=ON -DWASM=true \
  -DCMAKE_C_FLAGS="-ffile-prefix-map=$(cd "$SRC" && pwd)=binjgb" >/dev/null
cmake --build "$OUT" -j"$(nproc 2>/dev/null || echo 2)" >/dev/null
cp "$OUT/binjgb.js" "$OUT/binjgb.wasm" "$HERE/"
echo "source: $(git -C "$SRC" rev-parse HEAD 2>/dev/null || echo '?')  emcc $got"
( cd "$HERE" && sha256sum binjgb.js binjgb.wasm )
