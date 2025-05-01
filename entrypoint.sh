#!/usr/bin/env bash
set -euo pipefail

ART_NAME="$1"
TARGET_DIR="$2"
API="https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/artifacts"
TOKEN="${GITHUB_TOKEN:?GITHUB_TOKEN is required}"

echo "[INFO] Fetching artifact ID for '$ART_NAME'..."
ART_ID=$(curl -s -H "Authorization: Bearer $TOKEN" \
               -H "Accept: application/vnd.github+json" \
               "$API" \
         | jq -r --arg NAME "$ART_NAME" \
             '.artifacts[] | select(.name==$NAME) | .id' \
         | head -n1)

if [[ -z "$ART_ID" || "$ART_ID" == "null" ]]; then
  echo "::error::Artifact '$ART_NAME' not found"
  exit 1
fi

echo "[INFO] Downloading artifact #$ART_ID..."
curl -L -H "Authorization: Bearer $TOKEN" \
     -H "Accept: application/vnd.github+json" \
     "${API}/${ART_ID}/zip" \
  --output artifact.zip

echo "[INFO] Unzipping to '$TARGET_DIR'..."
mkdir -p "$TARGET_DIR"
unzip -q artifact.zip -d "$TARGET_DIR"

if [[ -f "$TARGET_DIR/artifact.tar" ]]; then
  echo "[INFO] Extracting nested artifact.tar..."
  tar -xzf "$TARGET_DIR/artifact.tar" -C "$TARGET_DIR"
  rm "$TARGET_DIR/artifact.tar"
fi

echo "[INFO] Artifact '$ART_NAME' extracted into '$TARGET_DIR/'"
