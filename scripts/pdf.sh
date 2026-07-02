#!/usr/bin/env bash
# Generate A4 PDFs from each cheatsheet's index.html using headless Chrome.
# Usage: ./scripts/pdf.sh              regenerate all cards into dist/
#        ./scripts/pdf.sh overview     regenerate a single card
# Override the browser with: CHROME=/path/to/chrome ./scripts/pdf.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

find_chrome() {
  if [[ -n "${CHROME:-}" ]]; then echo "$CHROME"; return; fi
  local candidates=(
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    "/Applications/Chromium.app/Contents/MacOS/Chromium"
    "$(command -v google-chrome || true)"
    "$(command -v chromium || true)"
    "$(command -v chromium-browser || true)"
  )
  for c in "${candidates[@]}"; do
    [[ -n "$c" && -x "$c" ]] && { echo "$c"; return; }
  done
  echo "error: no Chrome/Chromium found. Set CHROME=/path/to/chrome" >&2
  exit 1
}

CHROME_BIN="$(find_chrome)"
mkdir -p "$ROOT/dist"

shopt -s nullglob
targets=("$ROOT"/src/cheatsheets/${1:-*}/index.html)
if [[ ${#targets[@]} -eq 0 ]]; then
  echo "error: no cheatsheets matched 'src/cheatsheets/${1:-*}/index.html'" >&2
  exit 1
fi

fail=0
for html in "${targets[@]}"; do
  name="$(basename "$(dirname "$html")")"
  out="$ROOT/dist/swarm-${name}-cheatsheet.pdf"
  echo "→ $name"
  if ! "$CHROME_BIN" --headless=new --disable-gpu --no-pdf-header-footer \
      --virtual-time-budget=10000 --run-all-compositor-stages-before-draw \
      --print-to-pdf="$out" "file://$html" 2>/dev/null \
     || [[ ! -s "$out" ]]; then
    echo "   FAILED: $name (rerun without 2>/dev/null to see Chrome output)" >&2
    fail=1
    continue
  fi
  echo "   $(du -h "$out" | cut -f1 | tr -d ' ')  $out"
done

[[ $fail -eq 0 ]] && echo "Done. PDFs in dist/" || { echo "Some cards failed." >&2; exit 1; }
