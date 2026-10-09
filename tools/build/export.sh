#!/usr/bin/env bash
# Exports a build into build/<target>/ and fails if the export logs errors.
# Usage: tools/build/export.sh macos|web [release|debug]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
target="${1:?usage: export.sh macos|web [release|debug]}"
mode="${2:-release}"

case "$target" in
	macos) preset="macOS"; out="$ROOT/build/macos/Past.app" ;;
	web) preset="Web"; out="$ROOT/build/web/index.html" ;;
	*) echo "unknown target: $target" >&2; exit 2 ;;
esac

rm -rf "$(dirname "$out")"
mkdir -p "$(dirname "$out")"
log="$ROOT/build/export-$target.log"

"$ROOT/tools/godot.sh" --headless --import > "$log" 2>&1
"$ROOT/tools/godot.sh" --headless "--export-$mode" "$preset" "$out" >> "$log" 2>&1 || {
	cat "$log"
	exit 1
}
if grep -E "SCRIPT ERROR|^ERROR" "$log"; then
	echo "export logged errors; see $log" >&2
	exit 1
fi
echo "exported $target ($mode): $out"
