#!/usr/bin/env bash
# ARCB Updater Installer v3.3.6 (Diamond Polish)
set -Eeuo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

INSTALL_PATH="/usr/local/bin/guncel"
REPO_URL="https://raw.githubusercontent.com/ahm3t0t/arcb-wider-updater/main/guncel"
LOCAL_FILE="./guncel"

TEMP_FILE=$(mktemp)
trap 'rm -f "$TEMP_FILE"' EXIT

if [[ $EUID -ne 0 ]]; then
   if command -v sudo &> /dev/null; then
       exec sudo "$0" "$@"
   else
       echo -e "${RED}❌ Root yetkisi gerek.${NC}"
       exit 1
   fi
fi

download_file() {
    if command -v curl &> /dev/null; then
        curl -fsSL "$1" -o "$2"
    elif command -v wget &> /dev/null; then
        wget -qO "$2" "$1"
    else
        echo -e "${RED}❌ Curl veya Wget bulunamadı.${NC}"
        exit 1
    fi
}

echo -e "\n${BLUE}>>> ARCB Wider Updater Kurulum${NC}"

if [ -f "$LOCAL_FILE" ]; then
    echo "📂 Yerel dosya okunuyor..."
    cp "$LOCAL_FILE" "$TEMP_FILE"
else
    echo "☁️  GitHub'dan indiriliyor..."
    download_file "$REPO_URL" "$TEMP_FILE"
fi

if ! grep -q "ARCB Wider Updater" "$TEMP_FILE"; then
    echo -e "${RED}❌ Dosya bozuk veya geçersiz. Kurulum iptal.${NC}"
    exit 1
fi

if ! head -n 1 "$TEMP_FILE" | grep -E -q "#!/(usr/)?bin/(env )?bash"; then
    echo -e "${RED}❌ Geçersiz Shebang (Bash script değil). Kurulum iptal.${NC}"
    exit 1
fi

if [ -f "$INSTALL_PATH" ]; then
    cp "$INSTALL_PATH" "${INSTALL_PATH}.bak"
    echo "📦 Eski sürüm yedeklendi."
fi

if install -m 0755 -o root -g root "$TEMP_FILE" "$INSTALL_PATH"; then
    # FIX: Robust version parsing with sed
    INSTALLED_VERSION=$(sed -n 's/^VERSION="\([^"]*\)".*/\1/p' "$INSTALL_PATH" | head -n1)
    echo -e "${GREEN}✅ Kurulum Tamam! (v${INSTALLED_VERSION})${NC}"
    echo "Komut: guncel [--auto] [--help]"
else
    echo -e "${RED}❌ Kurulum sırasında hata oluştu!${NC}"
    exit 1
fi

