#!/usr/bin/env bash
# check-nixpkgs.sh
# Checks package names against Nixpkgs and NUR; outputs a CSV.

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 [pacman.txt|aur.txt] ..." >&2
  exit 1
fi

for f in "$@"; do
  if [ ! -f "$f" ]; then
    echo "File not found: $f" >&2
    exit 1
  fi
done

echo "package,found_in_nixpkgs,found_in_nur,comment"

while read -r pkg; do
  # Skip blank lines & comments
  [[ -z "$pkg" ]] && continue
  [[ "$pkg" =~ ^# ]] && continue

  found_nixpkgs="no"
  found_nur="no"
  comment=""
  # Search in nixpkgs
  if nix search nixpkgs "$pkg" --json | grep -q "{"; then
    found_nixpkgs="yes"
  fi
  # Search in NUR, only if not found in main nixpkgs
  if nix search nur "$pkg" --json | grep -q "{" 2>/dev/null; then
    found_nur="yes"
  fi

  if [[ "$found_nixpkgs" != "yes" && "$found_nur" != "yes" ]]; then
    comment="MISSING"
  fi

  echo "$pkg,$found_nixpkgs,$found_nur,$comment"
done < <(cat "$@")
