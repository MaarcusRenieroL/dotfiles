#!/usr/bin/env bash
# Convert icons/apple/*.png into .icns files (icons/apple/icns/<Name>.icns).
# Usage: bash icons/make-icns.sh
set -euo pipefail
cd "$(dirname "$0")/apple"
mkdir -p icns
for png in *.png; do
  name="${png%.png}"
  set="$(mktemp -d)/$name.iconset"; mkdir -p "$set"
  for s in 16 32 128 256 512; do
    sips -z $s $s "$png" --out "$set/icon_${s}x${s}.png" >/dev/null
    sips -z $((s*2)) $((s*2)) "$png" --out "$set/icon_${s}x${s}@2x.png" >/dev/null
  done
  iconutil -c icns "$set" -o "icns/$name.icns"
done
echo "wrote $(ls icns | wc -l | tr -d ' ') icns files to icons/apple/icns"
