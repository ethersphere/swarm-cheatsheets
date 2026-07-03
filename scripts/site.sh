#!/usr/bin/env bash
# Assemble dist/site/ — a self-contained folder ready to upload to Swarm.
# Contains index.html (asset paths rewritten from ../../../ to local),
# the vendored fonts/QR lib/logos, and the generated PDF for the
# Download button. Upload the folder as-is; index.html is the entry point.
# Usage: ./scripts/site.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/dist/site"

# Make sure the PDF the Download button serves is fresh.
"$ROOT/scripts/pdf.sh"

rm -rf "$OUT"
mkdir -p "$OUT/assets"

cp -R "$ROOT/assets/fonts" "$ROOT/assets/vendor" "$OUT/assets/"
cp "$ROOT/assets/swarm-logo.svg" "$ROOT/assets/swarm-logo-white.svg" "$ROOT/assets/favicon.png" "$OUT/assets/"
cp "$ROOT/dist/swarm-overview-cheatsheet.pdf" "$OUT/"

# Rewrite repo-relative paths to site-local ones.
sed -e 's|\.\./\.\./\.\./assets/|assets/|g' \
    -e 's|\.\./\.\./\.\./dist/||g' \
    "$ROOT/src/cheatsheets/overview/index.html" > "$OUT/index.html"

echo
echo "Site assembled in dist/site/ — upload that folder to Swarm, e.g.:"
echo "  swarm-cli upload dist/site --stamp <BATCH_ID>"
echo "(check 'Multiple files in a folder' if uploading via Beeport)"
