#!/usr/bin/env bash
# ARCB Updater Installer v3.7.1 (Hotfix)
# Sync: v3.7.1 | Fix: Color codes and echo display issues

# 1. HATA YÖNETİMİ
set -Eeuo pipefail

# Renkler (printf uyumlu - $'...' ANSI-C quoting)
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
BLUE=$'\033[0;34m'
YELLOW=$'\033[1;33m'
BOLD=$'\033[1m'
NC=$'\033[0m'

INSTALL_PATH="/usr/local/bin/guncel"
REPO_URL="https://raw.githubusercontent.com/ahm3t0t/arcb-wider-updater/main/guncel"
LOGROTATE_REPO_URL="https://raw.githubusercontent.com/ahm3t0t/arcb-wider-updater/main/logrotate.d/arcb-wider-updater"
LOGROTATE_DEST="/etc/logrotate.d/arcb-wider-updater"

# --- SMART LOCAL FILE DETECTION ---
# 1. Scriptin kendi bulunduğu dizini bul (Pipe ile gelmiyorsa)
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}" )" &> /dev/null && pwd )" || true

# 2. Adaylar:
LOCAL_REPO_FILE="$SCRIPT_DIR/guncel"
LOCAL_CWD_FILE="./guncel"
LOCAL_LOGROTATE_FILE="$SCRIPT_DIR/logrotate.d/arcb-wider-updater"

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
TEMP_LOGROTATE="$(mktemp /tmp/logrotate_install_XXXXXX)"
trap 'rm -f "$TEMP_FILE" "$TEMP_LOGROTATE"' EXIT

# --- ROOT VE ORTAM KONTROLÜ ---
if [[ $EUID -ne 0 ]]; then
    if [[ -t 0 ]]; then
        printf "%s🔒 Root yetkisi gerekiyor, sudo isteniyor...%s\n" "$YELLOW" "$NC"
        exec sudo -E "$0" "$@"
    else
        printf "%s❌ Bu script root yetkisi gerektirir.%s\n" "$RED" "$NC"
        printf "%sLütfen komutu başına 'sudo' ekleyerek çalıştırın:%s\n" "$RED" "$NC"
        printf "%s   curl -fsSL https://raw.githubusercontent.com/ahm3t0t/arcb-wider-updater/main/install.sh | sudo bash%s\n" "$BLUE" "$NC"
        exit 1
    fi
fi

download_file() {
    local url="$1"
    local output="$2"
    local downloaded=false
    
    printf "➡️  İndiriliyor: %s\n" "$url"

    if command -v curl &> /dev/null; then
        if curl -fsSL "$url" -o "$output"; then
            downloaded=true
        else
            printf "%s⚠️  Curl başarısız, Wget deneniyor...%s\n" "$RED" "$NC"
        fi
    fi

    if [ "$downloaded" = "false" ] && command -v wget &> /dev/null; then
        if wget -qO "$output" "$url"; then
            downloaded=true
        fi
    fi

    if [ "$downloaded" = "false" ]; then
        printf "%s❌ İndirme yapılamadı! (Bağlantı yok veya URL hatalı)%s\n" "$RED" "$NC"
        exit 1
    fi
}

printf "\n%s>>> ARCB Wider Updater Kurulum (v3.7.1)%s\n" "$BLUE" "$NC"

# İndirme veya Kopyalama Mantığı
if [[ -n "$SOURCE_FILE" ]]; then
    printf "📂 Kaynak Bulundu: %s%s%s\n" "$YELLOW" "$SOURCE_TYPE" "$NC"
    printf "   Yol: %s\n" "$SOURCE_FILE"
    cp "$SOURCE_FILE" "$TEMP_FILE"
else
    # Yerel dosya yoksa indir
    download_file "$REPO_URL" "$TEMP_FILE"
fi

# 3. DOĞRULAMA (Güvenlik)
if [ ! -s "$TEMP_FILE" ]; then
    printf "%s❌ Kurulacak dosya boş!%s\n" "$RED" "$NC"
    exit 1
fi

if ! head -n 1 "$TEMP_FILE" | grep -E -q "#!/(usr/)?bin/(env )?bash"; then
    printf "%s❌ Dosya geçerli bir Bash scripti değil!%s\n" "$RED" "$NC"
    exit 1
fi

if ! grep -q "ARCB Wider Updater" "$TEMP_FILE"; then
    printf "%s❌ Dosya imza doğrulaması başarısız!%s\n" "$RED" "$NC"
    exit 1
fi

# 4. KURULUM VE YEDEKLEME (v3.6.0: Basit .bak yedek)
if [ -f "$INSTALL_PATH" ]; then
    # Önce basit .bak yedek (rollback için)
    if cp "$INSTALL_PATH" "${INSTALL_PATH}.bak"; then
        printf "📦 Rollback yedeği: %s%s%s\n" "$YELLOW" "${INSTALL_PATH}.bak" "$NC"
    fi
    # Tarihli yedek de al (arşiv için)
    BACKUP_NAME="${INSTALL_PATH}.bak_$(date +%Y%m%d_%H%M%S)"
    cp "$INSTALL_PATH" "$BACKUP_NAME"
    printf "📦 Arşiv yedeği: %s%s%s\n" "$YELLOW" "$(basename "$BACKUP_NAME")" "$NC"
fi

if install -m 0755 -o root -g root "$TEMP_FILE" "$INSTALL_PATH"; then
    INSTALLED_VERSION=$(sed -n 's/^VERSION="\([^"]*\)".*/\1/p' "$INSTALL_PATH" | head -n1)
    printf "%s✅ Kurulum Başarılı! (v%s)%s\n" "$GREEN" "${INSTALLED_VERSION:-Bilinmiyor}" "$NC"
else
    printf "%s❌ Kurulum sırasında yazma hatası oluştu!%s\n" "$RED" "$NC"
    # Rollback attempt
    if [ -f "${INSTALL_PATH}.bak" ]; then
        printf "%sYedekten geri yükleme deneniyor...%s\n" "$YELLOW" "$NC"
        if cp "${INSTALL_PATH}.bak" "$INSTALL_PATH"; then
            printf "%sGeri yükleme başarılı.%s\n" "$GREEN" "$NC"
        fi
    fi
    exit 1
fi

# 5. LOGROTATE CONFIG KURULUMU (v3.7.0)
printf "\n%s>>> Logrotate Yapılandırması%s\n" "$BLUE" "$NC"

# Logrotate kurulu mu kontrol et
if command -v logrotate &> /dev/null; then
    # Yerel dosya var mı?
    if [[ -f "$LOCAL_LOGROTATE_FILE" ]]; then
        cp "$LOCAL_LOGROTATE_FILE" "$TEMP_LOGROTATE"
        printf "📂 Logrotate config: %sLocal%s\n" "$YELLOW" "$NC"
    else
        download_file "$LOGROTATE_REPO_URL" "$TEMP_LOGROTATE"
    fi
    
    if install -m 0644 -o root -g root "$TEMP_LOGROTATE" "$LOGROTATE_DEST"; then
        printf "%s✅ Logrotate config kuruldu: %s%s\n" "$GREEN" "$LOGROTATE_DEST" "$NC"
        printf "%sℹ️  Log dosyaları haftalık rotate edilecek, 4 hafta saklanacak.%s\n" "$BLUE" "$NC"
    else
        printf "%s⚠️  Logrotate config kurulamadı (opsiyonel).%s\n" "$YELLOW" "$NC"
    fi
else
    printf "%s⚠️  Logrotate bulunamadı. Log rotation için: apt install logrotate%s\n" "$YELLOW" "$NC"
fi

printf "%s\n" "--------------------------------------------------"
printf "%sℹ️  Not: flock bağımlılığı util-linux paketi ile gelir (genelde kurulu).%s\n" "$BLUE" "$NC"
printf "Komut: %sguncel%s [--auto] [--skip ...] [--only ...] [--help]\n" "$BOLD" "$NC"
printf "Loglar: %s/var/log/arcb-updater/%s (logrotate ile yönetilir)\n" "$BOLD" "$NC"
