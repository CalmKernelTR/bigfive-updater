#!/usr/bin/env bash
set -euo pipefail

APP_NAME="ARCB Wider Updater"
BIN_NAME="guncel"
REPO_RAW_BASE="https://raw.githubusercontent.com/ahm3t0t/arcb-wider-updater/main"

# Install target: prefer ~/.local/bin, fallback to ~/bin
TARGET_DIR="${HOME}/.local/bin"
mkdir -p "$TARGET_DIR" 2>/dev/null || true
if [[ ! -w "$TARGET_DIR" ]]; then
  TARGET_DIR="${HOME}/bin"
  mkdir -p "$TARGET_DIR"
fi

DST="${TARGET_DIR}/${BIN_NAME}"

need_cmd() { command -v "$1" >/dev/null 2>&1; }

# Pick downloader
DOWNLOADER=""
if need_cmd curl; then
  DOWNLOADER="curl"
elif need_cmd wget; then
  DOWNLOADER="wget"
else
  echo "HATA: curl veya wget bulunamadı. Önce birini kur."
  echo "Ubuntu/Debian: sudo apt-get update && sudo apt-get install -y curl"
  exit 1
fi

TMP="$(mktemp)"
cleanup(){ rm -f "$TMP" 2>/dev/null || true; }
trap cleanup EXIT

URL="${REPO_RAW_BASE}/${BIN_NAME}"
echo "⬇️  ${APP_NAME} indiriliyor: $URL"

if [[ "$DOWNLOADER" == "curl" ]]; then
  curl -fsSL "$URL" -o "$TMP"
else
  wget -qO "$TMP" "$URL"
fi

# Basic sanity check: must look like a bash script
if ! head -n 1 "$TMP" | grep -qE '^#!/usr/bin/env bash|^#!/bin/bash'; then
  echo "HATA: İndirilen dosya beklenen script değil gibi görünüyor."
  echo "URL: $URL"
  exit 1
fi

install -m 0755 "$TMP" "$DST"

echo "✅ ${APP_NAME} yüklendi: $DST"
echo
echo "Kullanım:"
echo "  ${BIN_NAME}                # Varsayılan: sessiz mod, GUI (zenity) açık"
echo "  ${BIN_NAME} --show-output  # Paket yöneticisi çıktıları ekrana basılır"
echo "  ${BIN_NAME} --no-gui       # Zenity olmadan, tamamen CLI çalışır"
echo
echo "İpucu:"
echo "  SHOW_OUTPUT=1 ${BIN_NAME}"
echo "  NO_GUI=1 ${BIN_NAME}"

# PATH hint
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$TARGET_DIR"; then
  echo
  echo "ℹ️ PATH içinde '$TARGET_DIR' yok gibi görünüyor."
  echo "   ~/.bashrc veya ~/.zshrc içine şunu ekleyebilirsin:"
  echo "   export PATH=\"$TARGET_DIR:\$PATH\""
fi

