#!/usr/bin/env bash
set -euo pipefail

APP_NAME="ARCB Wider Updater"
BIN_NAME="guncel"

# Install target: prefer ~/.local/bin, fallback to ~/bin
TARGET_DIR="${HOME}/.local/bin"
if [[ ! -d "$TARGET_DIR" ]]; then
  mkdir -p "$TARGET_DIR" 2>/dev/null || true
fi
if [[ ! -w "$TARGET_DIR" ]]; then
  TARGET_DIR="${HOME}/bin"
  mkdir -p "$TARGET_DIR"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="${SCRIPT_DIR}/${BIN_NAME}"
DST="${TARGET_DIR}/${BIN_NAME}"

if [[ ! -f "$SRC" ]]; then
  echo "HATA: '$SRC' bulunamadı. Repo kökünden çalıştır."
  exit 1
fi

install -m 0755 "$SRC" "$DST"

echo "✅ ${APP_NAME} yüklendi: $DST"

# Ensure PATH includes target dir
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$TARGET_DIR"; then
  echo
  echo "ℹ️ PATH içinde '$TARGET_DIR' yok gibi görünüyor."
  echo "   Aşağıdakini ~/.bashrc veya ~/.zshrc içine ekleyebilirsin:"
  echo "   export PATH=\"$TARGET_DIR:\$PATH\""
fi

echo
echo "Kullanım:"
echo "  $BIN_NAME"
echo "  $BIN_NAME --gui"
