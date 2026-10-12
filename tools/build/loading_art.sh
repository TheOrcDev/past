#!/usr/bin/env bash
# Makes the browser loading screen's pictures (web/loading/) from the cathedral
# nave's two eras: the ruin it opens on, the past that blooms from the rose
# window while the game loads, and the rose window as the tab's icon.
# Usage: tools/build/loading_art.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
art="$ROOT/content/rooms/cathedral_nave/art"
out="$ROOT/web/loading"
mkdir -p "$out"

cwebp -quiet -q 72 -m 6 -metadata none "$art/bg_now.png" -o "$out/now.webp"
cwebp -quiet -q 74 -m 6 -metadata none "$art/bg_then.png" -o "$out/then.webp"
magick "$art/bg_then.png" -crop 270x270+1337+114 +repage -resize 128x128 \
	\( -size 128x128 xc:none -fill white -draw "circle 64,64 64,1" \) -compose DstIn -composite \
	"$out/icon.png"
ls -l "$out"
