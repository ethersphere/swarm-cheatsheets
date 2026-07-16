#!/usr/bin/env bash
# Verify every URL a cheatsheet points at (QR data-url attributes + https hrefs)
# is still alive. A printed card is only as good as its links — run this before
# regenerating PDFs and on a schedule in CI.
# Usage: ./scripts/check-links.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Scan the SOURCE files (the card + its hosted-page partials), not the generated
# index.html — this stays correct even if index.html hasn't been regenerated yet.
# nullglob + an array so a missing partial type drops out instead of passing a
# literal '*' path to grep; the empty-guard stops grep from reading stdin (which
# would hang) if nothing matches. chrome.css is included so any URL added to card
# CSS is checked too.
shopt -s nullglob
cards=("$ROOT"/src/cheatsheets/*/cheatsheet.html)
src=("${cards[@]}" \
  "$ROOT"/src/cheatsheets/*/chrome.css \
  "$ROOT"/src/cheatsheets/*/toolbar.html \
  "$ROOT"/src/cheatsheets/*/footer.html)
if [[ ${#cards[@]} -eq 0 ]]; then
  echo "error: no cheatsheet.html found under src/cheatsheets/" >&2
  exit 1
fi
urls=$(grep -rhoE '(data-url="[^"]+"|https://[a-zA-Z0-9./_-]+)' "${src[@]}" \
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

# The install command pins a Bee release tag (TAG=vX.Y.Z). Verify the tag
# actually exists — a card printed before the release ships a broken command.
tags=$(grep -rhoE 'TAG=v[0-9]+\.[0-9]+\.[0-9]+' "${cards[@]}" | sed 's/TAG=//' | sort -u)
while IFS= read -r tag; do
  [[ -z "$tag" ]] && continue
  code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 15 \
    "https://api.github.com/repos/ethersphere/bee/releases/tags/$tag" || true)
  if [[ "${code:-000}" == "200" ]]; then
    echo "ok      bee release $tag exists"
  else
    echo "BROKEN  bee release $tag NOT published yet — do not print until it is"
    fail=1
  fi
done <<< "$tags"

if [[ $fail -ne 0 ]]; then
  echo; echo "Broken links found — a printed card would send people to a dead page." >&2
  exit 1
fi
echo; echo "All links alive."
