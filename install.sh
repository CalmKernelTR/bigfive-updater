#!/usr/bin/env bash
# ARCB Updater Installer Night-V1.1.0
# Sync: Night-V1.1.0 | GPG imza doğrulama desteği eklendi

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

# GPG Doğrulama URL'leri (v1.1.0)
GPG_PUBKEY_URL="https://raw.githubusercontent.com/ahm3t0t/arcb-wider-updater/main/pubkey.asc"
GPG_SHA256SUMS_URL="https://github.com/ahm3t0t/arcb-wider-updater/releases/latest/download/SHA256SUMS"
GPG_SHA256SUMS_SIG_URL="https://github.com/ahm3t0t/arcb-wider-updater/releases/latest/download/SHA256SUMS.asc"

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

# 2. TEMP DOSYALAR
TEMP_FILE="$(mktemp /tmp/guncel_install_XXXXXX)"
TEMP_LOGROTATE="$(mktemp /tmp/logrotate_install_XXXXXX)"
TEMP_PUBKEY="$(mktemp /tmp/guncel_pubkey_XXXXXX)"
TEMP_SHA256SUMS="$(mktemp /tmp/guncel_sha256sums_XXXXXX)"
TEMP_SHA256SUMS_SIG="$(mktemp /tmp/guncel_sha256sums_sig_XXXXXX)"
trap 'rm -f "$TEMP_FILE" "$TEMP_LOGROTATE" "$TEMP_PUBKEY" "$TEMP_SHA256SUMS" "$TEMP_SHA256SUMS_SIG"' EXIT

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

    # TLS 1.2+ zorunlu (güvenlik için)
    if command -v curl &> /dev/null; then
        if curl --proto '=https' --tlsv1.2 -fsSL "$url" -o "$output"; then
            downloaded=true
        else
            printf "%s⚠️  Curl başarısız, Wget deneniyor...%s\n" "$RED" "$NC"
        fi
    fi

    if [ "$downloaded" = "false" ] && command -v wget &> /dev/null; then
        if wget --secure-protocol=TLSv1_2 -qO "$output" "$url"; then
            downloaded=true
        fi
    fi

    if [ "$downloaded" = "false" ]; then
        printf "%s❌ İndirme yapılamadı! (Bağlantı yok veya URL hatalı)%s\n" "$RED" "$NC"
        exit 1
    fi
}

# GPG doğrulama fonksiyonu (v1.1.0)
verify_gpg_signature() {
    local file="$1"
    local skip_gpg=false

    # GPG kurulu mu?
    if ! command -v gpg &> /dev/null; then
        printf "%s⚠️  GPG bulunamadı, imza doğrulama atlanıyor.%s\n" "$YELLOW" "$NC"
        printf "%s   Kurulum için: apt install gnupg%s\n" "$BLUE" "$NC"
        return 0
    fi

    printf "%s🔐 GPG imza doğrulaması başlatılıyor...%s\n" "$BLUE" "$NC"

    # Public key'i indir ve import et (TLS 1.2+)
    if curl --proto '=https' --tlsv1.2 -fsSL "$GPG_PUBKEY_URL" -o "$TEMP_PUBKEY" 2>/dev/null || \
       wget --secure-protocol=TLSv1_2 -qO "$TEMP_PUBKEY" "$GPG_PUBKEY_URL" 2>/dev/null; then
        if gpg --import "$TEMP_PUBKEY" 2>/dev/null; then
            printf "%s   ✓ Public key import edildi%s\n" "$GREEN" "$NC"
        else
            printf "%s⚠️  Public key import edilemedi, GPG doğrulama atlanıyor.%s\n" "$YELLOW" "$NC"
            skip_gpg=true
        fi
    else
        printf "%s⚠️  Public key indirilemedi, GPG doğrulama atlanıyor.%s\n" "$YELLOW" "$NC"
        skip_gpg=true
    fi

    if [[ "$skip_gpg" == "true" ]]; then
        return 0
    fi

    # SHA256SUMS ve imzasını indir (TLS 1.2+)
    if ! curl --proto '=https' --tlsv1.2 -fsSL "$GPG_SHA256SUMS_URL" -o "$TEMP_SHA256SUMS" 2>/dev/null && \
       ! wget --secure-protocol=TLSv1_2 -qO "$TEMP_SHA256SUMS" "$GPG_SHA256SUMS_URL" 2>/dev/null; then
        printf "%s⚠️  SHA256SUMS indirilemedi, GPG doğrulama atlanıyor.%s\n" "$YELLOW" "$NC"
        return 0
    fi

    if ! curl --proto '=https' --tlsv1.2 -fsSL "$GPG_SHA256SUMS_SIG_URL" -o "$TEMP_SHA256SUMS_SIG" 2>/dev/null && \
       ! wget --secure-protocol=TLSv1_2 -qO "$TEMP_SHA256SUMS_SIG" "$GPG_SHA256SUMS_SIG_URL" 2>/dev/null; then
        printf "%s⚠️  SHA256SUMS.asc indirilemedi, GPG doğrulama atlanıyor.%s\n" "$YELLOW" "$NC"
        return 0
    fi

    # GPG imza doğrulama
    if gpg --verify "$TEMP_SHA256SUMS_SIG" "$TEMP_SHA256SUMS" 2>/dev/null; then
        printf "%s   ✓ GPG imzası doğrulandı%s\n" "$GREEN" "$NC"
    else
        printf "%s❌ GPG imza doğrulaması başarısız!%s\n" "$RED" "$NC"
        printf "%s   Dosya değiştirilmiş olabilir. Kurulum iptal edildi.%s\n" "$RED" "$NC"
        exit 1
    fi

    # SHA256 checksum doğrulama
    local expected_hash
    expected_hash=$(grep "guncel" "$TEMP_SHA256SUMS" 2>/dev/null | awk '{print $1}')
    local actual_hash
    actual_hash=$(sha256sum "$file" | awk '{print $1}')

    if [[ -n "$expected_hash" && "$expected_hash" == "$actual_hash" ]]; then
        printf "%s   ✓ SHA256 checksum doğrulandı%s\n" "$GREEN" "$NC"
    elif [[ -n "$expected_hash" ]]; then
        printf "%s❌ SHA256 checksum uyuşmuyor!%s\n" "$RED" "$NC"
        printf "%s   Beklenen: %s%s\n" "$RED" "$expected_hash" "$NC"
        printf "%s   Bulunan:  %s%s\n" "$RED" "$actual_hash" "$NC"
        exit 1
    else
        printf "%s⚠️  SHA256SUMS dosyasında 'guncel' bulunamadı, checksum atlanıyor.%s\n" "$YELLOW" "$NC"
    fi

    return 0
}

printf "\n%s>>> ARCB Wider Updater Kurulum (Night-V1.1.0)%s\n" "$BLUE" "$NC"

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

# 3.1 GPG DOĞRULAMA (v1.1.0) - Uzaktan indirme durumunda
if [[ -z "$SOURCE_FILE" ]]; then
    verify_gpg_signature "$TEMP_FILE"
else
    printf "%s📂 Yerel dosya kullanılıyor, GPG doğrulama atlandı.%s\n" "$YELLOW" "$NC"
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
    INSTALLED_CODENAME=$(sed -n 's/^CODENAME="\([^"]*\)".*/\1/p' "$INSTALL_PATH" | head -n1)
    printf "%s✅ Kurulum Başarılı! (v%s - %s)%s\n" "$GREEN" "${INSTALLED_VERSION:-Bilinmiyor}" "${INSTALLED_CODENAME:-}" "$NC"

    # 4.1 SYMLINK: updater alias (İngilizce kullanıcılar için)
    SYMLINK_PATH="/usr/local/bin/updater"
    if [[ ! -e "$SYMLINK_PATH" ]]; then
        if ln -s "$INSTALL_PATH" "$SYMLINK_PATH" 2>/dev/null; then
            printf "%s🔗 Alias oluşturuldu: %supdater%s -> guncel%s\n" "$BLUE" "$BOLD" "$NC" "$NC"
        fi
    elif [[ -L "$SYMLINK_PATH" ]]; then
        # Zaten symlink, güncelle
        ln -sf "$INSTALL_PATH" "$SYMLINK_PATH" 2>/dev/null
    fi
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
