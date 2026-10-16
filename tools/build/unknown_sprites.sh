#!/usr/bin/env bash
# Rebuilds Unknown's painted sprite set (plan 010) from the accepted Sol sheets
# named in art-source/work/characters/unknown2/painted.json:
#   1. the rig renders the pose guides came from (ignored by git; rendered
#      again from tools/blender/unknown.py when missing),
#   2. the painted frames (tools/past-art painted),
#   3. the sprite sheets and manifest (tools/past-art pack --style painted),
#   4. Godot's import, lossless, and the CharacterSprites resource.
# Usage: tools/build/unknown_sprites.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"
BLENDER=/Applications/Blender.app/Contents/MacOS/Blender
W=art-source/work/characters/unknown2
OLD=art-source/work/characters/unknown
SPRITES=content/characters/unknown/sprites

render() {  # render <out> <fps> [anims]
	local out=$1 fps=$2 anims=${3:-}
	[[ -f "$out/anchors.json" ]] && return
	"$BLENDER" -b --disable-autoexec -P tools/blender/unknown.py -- --out "$out" --fps "$fps" \
		${anims:+--anims "$anims"} --blend "$OLD/unknown.blend" | grep UNKNOWN_RENDER
}
render "$OLD/renders" 12
render "$W/renders-walk8" 8 walk
render "$W/renders-rig12" 12 pickup_low

tools/past-art painted "$W/painted.json" > "$W/painted-report.json"
tools/past-art pack --renders "$W/painted" --out-dir "$SPRITES" --manifest "$W/unknown_sprites.json" \
	--res-prefix "res://$SPRITES" --name unknown --shaded --style painted > /dev/null

# Painted ink blocks up under VRAM compression: the sheets import lossless.
tools/godot.sh --headless --import > /dev/null 2>&1 || true
for file in "$SPRITES"/*.png.import; do
	sed -i '' 's/^compress\/mode=.*/compress\/mode=0/' "$file"
done
tools/godot.sh --headless --import > /dev/null 2>&1 || true
tools/godot.sh --headless --script res://addons/past_tools/import_sprites.gd -- \
	--manifest="$W/unknown_sprites.json" --out=res://content/characters/unknown/unknown_sprites.tres
