#!/usr/bin/env bash
# Deploys build/web (the browser build, the full game since decision #56) to the "past" project on the OrcDev
# Vercel team (decision #50). Export first with tools/build/export.sh web.
# Usage: tools/build/deploy.sh [--prod]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
web="$ROOT/build/web"
vercel=(bunx vercel@63.1.2)

[[ -f "$web/index.pck" ]] || { echo "no web build; run tools/build/export.sh web" >&2; exit 1; }

# The export wipes build/web, and with it the project link. Linking writes a
# .env.local with an OIDC token, which must never be uploaded.
printf '.env*\n.gitignore\n.vercel\n' > "$web/.vercelignore"
[[ -f "$web/.vercel/project.json" ]] || "${vercel[@]}" link --cwd "$web" --scope orc-dev --project past --yes
"${vercel[@]}" deploy --cwd "$web" --yes "$@"
