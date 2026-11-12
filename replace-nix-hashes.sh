#!/usr/bin/env bash
set -euo pipefail

# Run from the root of the repository

VERSION=$(cat VERSION | tr -d '\n')
echo "Using Stax version: $VERSION"

HASHES_FILE="nix/hashes/${VERSION}.txt"

if [ ! -f "$HASHES_FILE" ]; then
    echo "Error: Hashes file $HASHES_FILE not found"
    exit 1
fi

REPLACEMENT="
      /* replace with hashes */
$(cat "$HASHES_FILE")
      /* endreplace */"

awk '
BEGIN { p=1 }
/\/\* replace with hashes \*\// { p=0; print; next }
/\/\* endreplace \*\// { p=1; system("cat '"$HASHES_FILE"'"); print; next }
p { print }
' flake.nix > flake.nix.tmp && mv flake.nix.tmp flake.nix

echo "Successfully updated hashes in flake.nix"
