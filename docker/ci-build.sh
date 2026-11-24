#!/bin/bash
# Builds Icon Maker, then checks a forwarder made from the real template CIA
# on the PC. What the workflows run in the build image; works the same in the
# devcontainer:
#   bash docker/ci-build.sh
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# box art downloads need libcurl (the 3DS's own HTTPS can't reach GitHub)
[ -f "${DEVKITPRO:-/opt/devkitpro}/portlibs/3ds/lib/libcurl.a" ] || { echo "MISSING: 3ds-curl (dkp-pacman -S 3ds-curl)"; exit 1; }
bash "$ROOT/build-iconmaker.sh"

echo "=== Icon Maker forwarder test ==="
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
gcc -O2 -I"$ROOT/source" "$ROOT/test/fwdtest.c" "$ROOT/test/sha256.c" \
  "$ROOT/source/fwdcia.c" "$ROOT/source/banner.c" "$ROOT/source/deficon.c" -lm -o "$TMP/fwdtest"
# fwdtest writes its banner input to the current folder
cd "$TMP"
./fwdtest "$ROOT/out/template-gpsp3d.cia" fwd.cia 000400000F3D1234 \
  "sdmc:/roms/gba/Test Game.gba" "Test Game"
python3 "$ROOT/test/verify.py" fwd.cia
