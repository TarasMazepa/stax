#!/usr/bin/env bash
set -euo pipefail

# Run from the root of the repository

VERSION=$(cat VERSION | tr -d '\n')
echo "Using Stax version: $VERSION"

mkdir -p nix/hashes

OUTPUT_FILE="nix/hashes/${VERSION}.txt"
> "$OUTPUT_FILE"

declare -A assets=(
  ["x86_64-linux"]="linux-x64.zip"
  ["x86_64-darwin"]="macos-x64.zip"
  ["aarch64-darwin"]="macos-arm.zip"
)

# Fetch binaries and compute hashes for each system
for system in "${!assets[@]}"; do
  asset="${assets[$system]}"
  url="https://github.com/TarasMazepa/stax/releases/download/${VERSION}/${asset}"
  
  echo "Fetching and computing hash for $system ($asset)..."
  
  # Get the nix32 hash using nix-prefetch-url
  nix32_hash=$(nix-prefetch-url --unpack "$url" | tail -n1)
  
  # Convert to base64 format
  base64_hash=$(nix hash convert --hash-algo sha256 --from nix32 "$nix32_hash")
  
  # Format and store in the output file
  printf '"%s" = "%s";\n' "$system" "$base64_hash" >> "$OUTPUT_FILE"
done

echo "Hash file created: $OUTPUT_FILE"
