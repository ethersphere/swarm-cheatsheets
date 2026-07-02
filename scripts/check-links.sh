#!/usr/bin/env bash
# Verify every URL a cheatsheet points at (QR data-url attributes + https hrefs)
# is still alive. A printed card is only as good as its links — run this before
# regenerating PDFs and on a schedule in CI.
# Usage: ./scripts/check-links.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

urls=$(grep -rhoE '(data-url="[^"]+"|https://[a-zA-Z0-9./_-]+)' "$ROOT"/src/cheatsheets/*/index.html \
  | sed -E 's/^data-url="//; s/"$//' \
  | sort -u)

fail=0
while IFS= read -r url; do
  # HEAD first; some servers reject HEAD, so fall back to a ranged GET.
  # curl emits %{http_code}=000 itself on connection failure; `|| true` only
  # keeps set -e from killing the loop.
  code=$(curl -sIL -o /dev/null -w '%{http_code}' --max-time 15 "$url" || true)
  code=${code:-000}
  if [[ "$code" == "000" || "$code" -ge 400 ]]; then
    code=$(curl -sL -o /dev/null -w '%{http_code}' --max-time 20 -r 0-0 "$url" || true)
    code=${code:-000}
  fi
  if [[ "$code" == "000" || "$code" == "404" || "$code" == "410" || "$code" -ge 500 ]]; then
    echo "BROKEN  $code  $url"
    fail=1
  else
    echo "ok      $code  $url"
  fi
done <<< "$urls"

if [[ $fail -ne 0 ]]; then
  echo; echo "Broken links found — a printed card would send people to a dead page." >&2
  exit 1
fi
echo; echo "All links alive."
