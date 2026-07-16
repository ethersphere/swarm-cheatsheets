#!/usr/bin/env bash
# Generate each cheatsheet's index.html (the hosted web page) from its
# cheatsheet.html (the self-contained, extractable card) plus the sibling
# chrome.css / toolbar.html / footer.html partials.
#
# index.html is a GENERATED, committed file — do NOT hand-edit it. Edit
# cheatsheet.html or the partials and rerun this script; CI enforces that the
# committed index.html matches (git diff --exit-code).
#
# Usage: ./scripts/build-web.sh            regenerate all cards
#        ./scripts/build-web.sh overview   regenerate a single card
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

shopt -s nullglob
cards=("$ROOT"/src/cheatsheets/${1:-*}/cheatsheet.html)
if [[ ${#cards[@]} -eq 0 ]]; then
  echo "error: no cards matched 'src/cheatsheets/${1:-*}/cheatsheet.html'" >&2
  exit 1
fi

for card in "${cards[@]}"; do
  dir="$(dirname "$card")"
  name="$(basename "$dir")"
  chrome="$dir/chrome.css"; toolbar="$dir/toolbar.html"; footer="$dir/footer.html"
  out="$dir/index.html"
  # Require each partial to be readable AND non-empty (-s): the awk splice reads
  # them with getline, which silently yields nothing on an unreadable or empty
  # file — and the anchor counter would still tick, so the guard alone wouldn't
  # catch it. Fail here instead.
  for f in "$chrome" "$toolbar" "$footer"; do
    [[ -r "$f" && -s "$f" ]] || { echo "error: $name: $(basename "$f") is missing, empty, or unreadable" >&2; exit 1; }
  done

  echo "→ $name"
  # Splice the three partials into cheatsheet.html at anchors that must each occur
  # exactly once: chrome CSS inline before </style>, toolbar after <body>, footers
  # before the QR <script>. The banner goes right after the doctype so nothing
  # precedes <!doctype html> (which would trip quirks mode). The END block asserts
  # every anchor fired exactly once, so a reformatted card fails loudly instead of
  # silently dropping or duplicating a partial.
  awk -v card="$card" -v chrome="$chrome" -v toolbar="$toolbar" -v footer="$footer" '
    tolower($0) ~ /^<!doctype html>/ {
      print
      print "<!-- GENERATED from cheatsheet.html by scripts/build-web.sh — do not edit. -->"
      next
    }
    /<\/style>/       { while ((getline < chrome)  > 0) print; css++;  print; next }
    /^<body>/         { print; print ""; while ((getline < toolbar) > 0) print; bar++; next }
    /qrcode\.min\.js/ { while ((getline < footer)  > 0) print; print ""; foot++; print; next }
    { print }
    END {
      if (css != 1 || bar != 1 || foot != 1) {
        printf "error: anchors in %s fired style=%d body=%d footer=%d (each must be 1)\n", \
               card, css, bar, foot > "/dev/stderr"
        exit 1
      }
    }
  ' "$card" > "$out"
  echo "   wrote $out"
done

echo "Done. index.html regenerated — commit it alongside the source."
