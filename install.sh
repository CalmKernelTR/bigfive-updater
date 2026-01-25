#!/usr/bin/env bash
# ARCB Updater Installer v3.6.0 (Configurable)
# Sync: v3.6.0 | Feature: Smart Local File Detection + .bak Backup

# 1. HATA YÖNETİMİ
set -Eeuo pipefail

# Renkler
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
NC='\033[0m'

INSTALL_PATH="/usr/local/bin/guncel"
REPO_URL="https://raw.githubusercontent.com/ahm3t0t/arcb-wider-updater/main/guncel"

# --- SMART LOCAL FILE DETECTION ---
# 1. Scriptin kendi bulunduğu dizini bul (Pipe ile gelmiyorsa)
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}" )" &> /dev/null && pwd )" || true

# 2. Adaylar:
LOCAL_REPO_FILE="$SCRIPT_DIR/guncel"
LOCAL_CWD_FILE="./guncel"

# 3. Kaynak Belirleme
SOURCE_FILE=""
if [[ -f "$LOCAL_REPO_FILE" && -s "$LOCAL_REPO_FILE" ]]; then
    SOURCE_FILE="$LOCAL_REPO_FILE"
    SOURCE_TYPE="Local (Repo/Script Dir)"
elif [[ -f "$LOCAL_CWD_FILE" && -s "$LOCAL_CWD_FILE" ]]; then
    SOURCE_FILE="$LOCAL_CWD_FILE"
    SOURCE_TYPE="Local (Current Dir)"
fi

# 2. TEMP DOSYA
TEMP_FILE="$(mktemp /tmp/guncel_install_XXXXXX)"
trap 'rm -f "$TEMP_FILE"' EXIT

# --- ROOT VE ORTAM KONTROLÜ ---
if [[ $EUID -ne 0 ]]; then
    if [[ -t 0 ]]; then
        echo -e "${YELLOW}🔒 Root yetkisi gerekiyor, sudo isteniyor...${NC}"
        exec sudo -E "$0" "$@"
    else
        echo -e "${RED}❌ Bu script root yetkisi gerektirir.${NC}"
        echo -e "${RED}Lütfen komutu başına 'sudo' ekleyerek çalıştırın:${NC}"
        echo -e "${BLUE}   curl -fsSL https://raw.githubusercontent.com/ahm3t0t/arcb-wider-updater/main/install.sh | sudo bash${NC}"
        exit 1
    fi
fi

download_file() {
    local url="$1"
    local output="$2"
    local downloaded=false
    
    echo -e "➡️  İndiriliyor: $url"

    if command -v curl &> /dev/null; then
        if curl -fsSL "$url" -o "$output"; then
            downloaded=true
        else
            echo -e "${RED}⚠️  Curl başarısız, Wget deneniyor...${NC}"
        fi
    fi

    if [ "$downloaded" = "false" ] && command -v wget &> /dev/null; then
        if wget -qO "$output" "$url"; then
            downloaded=true
        fi
    fi

    if [ "$downloaded" = "false" ]; then
        echo -e "${RED}❌ İndirme yapılamadı! (Bağlantı yok veya URL hatalı)${NC}"
        exit 1
    fi
}

echo -e "\n${BLUE}>>> ARCB Wider Updater Kurulum (v3.6.0)${NC}"

# İndirme veya Kopyalama Mantığı
if [[ -n "$SOURCE_FILE" ]]; then
    echo -e "📂 Kaynak Bulundu: ${YELLOW}$SOURCE_TYPE${NC}"
    echo "   Yol: $SOURCE_FILE"
    cp "$SOURCE_FILE" "$TEMP_FILE"
else
    # Yerel dosya yoksa indir
    download_file "$REPO_URL" "$TEMP_FILE"
fi

# 3. DOĞRULAMA (Güvenlik)
if [ ! -s "$TEMP_FILE" ]; then
    echo -e "${RED}❌ Kurulacak dosya boş!${NC}"
    exit 1
fi

if ! head -n 1 "$TEMP_FILE" | grep -E -q "#!/(usr/)?bin/(env )?bash"; then
    echo -e "${RED}❌ Dosya geçerli bir Bash scripti değil!${NC}"
    exit 1
fi

if ! grep -q "ARCB Wider Updater" "$TEMP_FILE"; then
    echo -e "${RED}❌ Dosya imza doğrulaması başarısız!${NC}"
    exit 1
fi

# 4. KURULUM VE YEDEKLEME (v3.6.0: Basit .bak yedek)
if [ -f "$INSTALL_PATH" ]; then
    # Önce basit .bak yedek (rollback için)
    if cp "$INSTALL_PATH" "${INSTALL_PATH}.bak"; then
        echo -e "📦 Rollback yedeği: ${YELLOW}${INSTALL_PATH}.bak${NC}"
    fi
    # Tarihli yedek de al (arşiv için)
    BACKUP_NAME="${INSTALL_PATH}.bak_$(date +%Y%m%d_%H%M%S)"
    cp "$INSTALL_PATH" "$BACKUP_NAME"
    echo -e "📦 Arşiv yedeği: ${YELLOW}$(basename "$BACKUP_NAME")${NC}"
fi

if install -m 0755 -o root -g root "$TEMP_FILE" "$INSTALL_PATH"; then
    INSTALLED_VERSION=$(sed -n 's/^VERSION="\([^"]*\)".*/\1/p' "$INSTALL_PATH" | head -n1)
    echo -e "${GREEN}✅ Kurulum Başarılı! (v${INSTALLED_VERSION:-Bilinmiyor})${NC}"
    echo -e "${BLUE}ℹ️  Not: flock bağımlılığı util-linux paketi ile gelir (genelde kurulu).${NC}"
    echo "--------------------------------------------------"
    echo -e "Komut: ${BOLD}guncel${NC} [--auto] [--skip ...] [--only ...] [--help]"
else
    echo -e "${RED}❌ Kurulum sırasında yazma hatası oluştu!${NC}"
    # Rollback attempt
    if [ -f "${INSTALL_PATH}.bak" ]; then
        echo -e "${YELLOW}Yedekten geri yükleme deneniyor...${NC}"
        if cp "${INSTALL_PATH}.bak" "$INSTALL_PATH"; then
            echo -e "${GREEN}Geri yükleme başarılı.${NC}"
        fi
    fi
    exit 1
fi
