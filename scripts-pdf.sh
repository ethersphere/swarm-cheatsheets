#!/bin/bash
# Generate A4 PDFs from each cheatsheet's index.html using headless Chrome.
# Usage: ./scripts-pdf.sh   (regenerates all cards into dist/)
set -e
CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
ROOT="$(cd "$(dirname "$0")" && pwd)"
for html in "$ROOT"/src/cheatsheets/*/index.html; do
  name="$(basename "$(dirname "$html")")"
  out="$ROOT/dist/swarm-${name}-cheatsheet.pdf"
  echo "→ $name"
  "$CHROME" --headless=new --disable-gpu --no-pdf-header-footer \
    --virtual-time-budget=4000 --run-all-compositor-stages-before-draw \
    --print-to-pdf="$out" "file://$html" 2>/dev/null
done
echo "Done. PDFs in dist/"
