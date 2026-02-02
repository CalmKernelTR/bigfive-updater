#!/usr/bin/env bash
# BigFive Updater Installer Night-V1.4.2
# Sync: Night-V1.4.2 | wget fallback iyileştirmesi

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
# v1.2.1: Releases URL kullan (CDN cache sorunu önlenir)
REPO_URL="https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/guncel"
LOGROTATE_REPO_URL="https://raw.githubusercontent.com/CalmKernelTR/bigfive-updater/main/logrotate.d/bigfive-updater"
LOGROTATE_DEST="/etc/logrotate.d/bigfive-updater"

# GPG Doğrulama URL'leri (v1.1.0)
GPG_PUBKEY_URL="https://raw.githubusercontent.com/CalmKernelTR/bigfive-updater/main/pubkey.asc"
GPG_SHA256SUMS_URL="https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/SHA256SUMS"
GPG_SHA256SUMS_SIG_URL="https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/SHA256SUMS.asc"

# --- SMART LOCAL FILE DETECTION ---
# 1. Scriptin kendi bulunduğu dizini bul (Pipe ile gelmiyorsa)
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}" )" &> /dev/null && pwd )" || true

# 2. Adaylar:
LOCAL_REPO_FILE="$SCRIPT_DIR/guncel"
LOCAL_CWD_FILE="./guncel"
LOCAL_LOGROTATE_FILE="$SCRIPT_DIR/logrotate.d/bigfive-updater"

# 3. Kaynak Belirleme
SOURCE_FILE=""
if [[ -f "$LOCAL_REPO_FILE" && -s "$LOCAL_REPO_FILE" ]]; then
    SOURCE_FILE="$LOCAL_REPO_FILE"
    SOURCE_TYPE="Local (Repo/Script Dir)"
elif [[ -f "$LOCAL_CWD_FILE" && -s "$LOCAL_CWD_FILE" ]]; then
    SOURCE_FILE="$LOCAL_CWD_FILE"
    SOURCE_TYPE="Local (Current Dir)"
fi

# 2. TEMP DOSYALAR - v1.3.1 FIX: Tüm temp dosyaları trap'e eklendi
TEMP_FILE="$(mktemp /tmp/guncel_install_XXXXXX)"
TEMP_LOGROTATE="$(mktemp /tmp/logrotate_install_XXXXXX)"
TEMP_PUBKEY="$(mktemp /tmp/guncel_pubkey_XXXXXX)"
TEMP_SHA256SUMS="$(mktemp /tmp/guncel_sha256sums_XXXXXX)"
TEMP_SHA256SUMS_SIG="$(mktemp /tmp/guncel_sha256sums_sig_XXXXXX)"
TEMP_COMPLETION=""
TEMP_MAN=""
TEMP_LANG_TR=""
TEMP_LANG_EN=""
trap 'rm -f "$TEMP_FILE" "$TEMP_LOGROTATE" "$TEMP_PUBKEY" "$TEMP_SHA256SUMS" "$TEMP_SHA256SUMS_SIG" "$TEMP_COMPLETION" "$TEMP_MAN" "$TEMP_LANG_TR" "$TEMP_LANG_EN"' EXIT

# --- ROOT VE ORTAM KONTROLÜ ---
if [[ $EUID -ne 0 ]]; then
    if [[ -t 0 ]]; then
        printf "%s🔒 Root yetkisi gerekiyor, sudo isteniyor...%s\n" "$YELLOW" "$NC"
        exec sudo -E "$0" "$@"
    else
        printf "%s❌ Bu script root yetkisi gerektirir.%s\n" "$RED" "$NC"
        printf "%sLütfen komutu başına 'sudo' ekleyerek çalıştırın:%s\n" "$RED" "$NC"
        printf "%s   curl -fsSL https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/install.sh | sudo bash%s\n" "$BLUE" "$NC"
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
        # Try with --secure-protocol first, fallback to basic wget (older versions)
        if wget --secure-protocol=TLSv1_2 -qO "$output" "$url" 2>/dev/null || \
           wget -qO "$output" "$url" 2>/dev/null; then
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
    # Sadece "guncel" dosyasını bul (guncel.bash, guncel.8 değil)
    expected_hash=$(grep -E "  guncel$" "$TEMP_SHA256SUMS" 2>/dev/null | awk '{print $1}')
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

printf "\n%s>>> BigFive Updater Kurulum (Night-V1.4.2)%s\n" "$BLUE" "$NC"

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

if ! grep -q "BigFive Updater" "$TEMP_FILE"; then
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
    INSTALLED_EDITION=$(sed -n 's/^EDITION="\([^"]*\)".*/\1/p' "$INSTALL_PATH" | head -n1)
    INSTALLED_CODENAME=$(sed -n 's/^CODENAME="\([^"]*\)".*/\1/p' "$INSTALL_PATH" | head -n1)
    printf "%s✅ Kurulum Başarılı! (v%s - %s Edition - %s)%s\n" "$GREEN" "${INSTALLED_VERSION:-Bilinmiyor}" "${INSTALLED_EDITION:-}" "${INSTALLED_CODENAME:-}" "$NC"

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

    # 4.2 SYMLINK: bigfive alias (Uluslararası/marka ismi)
    BIGFIVE_SYMLINK="/usr/local/bin/bigfive"
    if [[ ! -e "$BIGFIVE_SYMLINK" ]]; then
        if ln -s "$INSTALL_PATH" "$BIGFIVE_SYMLINK" 2>/dev/null; then
            printf "%s🔗 Alias oluşturuldu: %sbigfive%s -> guncel%s\n" "$BLUE" "$BOLD" "$NC" "$NC"
        fi
    elif [[ -L "$BIGFIVE_SYMLINK" ]]; then
        # Zaten symlink, güncelle
        ln -sf "$INSTALL_PATH" "$BIGFIVE_SYMLINK" 2>/dev/null
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

# 6. BASH COMPLETION KURULUMU (v1.3.0)
printf "\n%s>>> Bash Completion%s\n" "$BLUE" "$NC"

BASH_COMPLETION_DIR="/usr/share/bash-completion/completions"
BASH_COMPLETION_URL="https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/guncel.bash"
LOCAL_COMPLETION_FILE="$SCRIPT_DIR/completions/guncel.bash"
TEMP_COMPLETION="$(mktemp /tmp/guncel_completion_XXXXXX)"

if [[ -d "$BASH_COMPLETION_DIR" ]]; then
    # Yerel dosya var mı?
    if [[ -f "$LOCAL_COMPLETION_FILE" ]]; then
        cp "$LOCAL_COMPLETION_FILE" "$TEMP_COMPLETION"
        printf "📂 Bash completion: %sLocal%s\n" "$YELLOW" "$NC"
    else
        if curl --proto '=https' --tlsv1.2 -fsSL "$BASH_COMPLETION_URL" -o "$TEMP_COMPLETION" 2>/dev/null || \
           wget --secure-protocol=TLSv1_2 -qO "$TEMP_COMPLETION" "$BASH_COMPLETION_URL" 2>/dev/null; then
            printf "➡️  İndiriliyor: %s\n" "$BASH_COMPLETION_URL"
        else
            printf "%s⚠️  Bash completion indirilemedi (opsiyonel).%s\n" "$YELLOW" "$NC"
            TEMP_COMPLETION=""
        fi
    fi

    if [[ -n "$TEMP_COMPLETION" && -s "$TEMP_COMPLETION" ]]; then
        if install -m 0644 -o root -g root "$TEMP_COMPLETION" "$BASH_COMPLETION_DIR/guncel"; then
            # Symlink'ler için de completion
            ln -sf "$BASH_COMPLETION_DIR/guncel" "$BASH_COMPLETION_DIR/updater" 2>/dev/null
            ln -sf "$BASH_COMPLETION_DIR/guncel" "$BASH_COMPLETION_DIR/bigfive" 2>/dev/null
            printf "%s✅ Bash completion kuruldu (guncel, updater, bigfive)%s\n" "$GREEN" "$NC"
            printf "%sℹ️  Tab tuşu ile seçenek tamamlama aktif (yeni terminal gerekir).%s\n" "$BLUE" "$NC"
        else
            printf "%s⚠️  Bash completion kurulamadı (opsiyonel).%s\n" "$YELLOW" "$NC"
        fi
    fi
    rm -f "$TEMP_COMPLETION" 2>/dev/null
else
    printf "%s⚠️  Bash completion dizini bulunamadı (%s).%s\n" "$YELLOW" "$BASH_COMPLETION_DIR" "$NC"
fi

# 6b. ZSH COMPLETION KURULUMU (v1.3.2)
ZSH_COMPLETION_DIR="/usr/share/zsh/site-functions"
LOCAL_ZSH_COMPLETION="$SCRIPT_DIR/completions/_guncel"

if [[ -d "$ZSH_COMPLETION_DIR" ]]; then
    if [[ -f "$LOCAL_ZSH_COMPLETION" ]]; then
        if install -m 0644 -o root -g root "$LOCAL_ZSH_COMPLETION" "$ZSH_COMPLETION_DIR/_guncel"; then
            printf "%s✅ Zsh completion kuruldu%s\n" "$GREEN" "$NC"
        else
            printf "%s⚠️  Zsh completion kurulamadı (opsiyonel).%s\n" "$YELLOW" "$NC"
        fi
    fi
fi

# 6c. FISH COMPLETION KURULUMU (v1.3.2)
FISH_COMPLETION_DIR="/usr/share/fish/vendor_completions.d"
LOCAL_FISH_COMPLETION="$SCRIPT_DIR/completions/guncel.fish"

if [[ -d "$FISH_COMPLETION_DIR" ]]; then
    if [[ -f "$LOCAL_FISH_COMPLETION" ]]; then
        if install -m 0644 -o root -g root "$LOCAL_FISH_COMPLETION" "$FISH_COMPLETION_DIR/guncel.fish"; then
            # Symlink'ler için de completion
            ln -sf "$FISH_COMPLETION_DIR/guncel.fish" "$FISH_COMPLETION_DIR/updater.fish" 2>/dev/null
            ln -sf "$FISH_COMPLETION_DIR/guncel.fish" "$FISH_COMPLETION_DIR/bigfive.fish" 2>/dev/null
            printf "%s✅ Fish completion kuruldu%s\n" "$GREEN" "$NC"
        else
            printf "%s⚠️  Fish completion kurulamadı (opsiyonel).%s\n" "$YELLOW" "$NC"
        fi
    fi
fi

# 7. MAN PAGE KURULUMU (v1.3.0)
printf "\n%s>>> Man Page%s\n" "$BLUE" "$NC"

MAN_DIR="/usr/share/man/man8"
MAN_URL="https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/guncel.8"
LOCAL_MAN_FILE="$SCRIPT_DIR/docs/guncel.8"
TEMP_MAN="$(mktemp /tmp/guncel_man_XXXXXX)"

if [[ -d "$MAN_DIR" ]]; then
    # Yerel dosya var mı?
    if [[ -f "$LOCAL_MAN_FILE" ]]; then
        cp "$LOCAL_MAN_FILE" "$TEMP_MAN"
        printf "📂 Man page: %sLocal%s\n" "$YELLOW" "$NC"
    else
        if curl --proto '=https' --tlsv1.2 -fsSL "$MAN_URL" -o "$TEMP_MAN" 2>/dev/null || \
           wget --secure-protocol=TLSv1_2 -qO "$TEMP_MAN" "$MAN_URL" 2>/dev/null; then
            printf "➡️  İndiriliyor: %s\n" "$MAN_URL"
        else
            printf "%s⚠️  Man page indirilemedi (opsiyonel).%s\n" "$YELLOW" "$NC"
            TEMP_MAN=""
        fi
    fi

    if [[ -n "$TEMP_MAN" && -s "$TEMP_MAN" ]]; then
        if install -m 0644 -o root -g root "$TEMP_MAN" "$MAN_DIR/guncel.8"; then
            # Symlink'ler için de man page
            ln -sf "$MAN_DIR/guncel.8" "$MAN_DIR/updater.8" 2>/dev/null
            ln -sf "$MAN_DIR/guncel.8" "$MAN_DIR/bigfive.8" 2>/dev/null
            # Man veritabanını güncelle
            mandb -q 2>/dev/null || true
            printf "%s✅ Man page kuruldu (man guncel)%s\n" "$GREEN" "$NC"
        else
            printf "%s⚠️  Man page kurulamadı (opsiyonel).%s\n" "$YELLOW" "$NC"
        fi
    fi
    rm -f "$TEMP_MAN" 2>/dev/null
else
    printf "%s⚠️  Man dizini bulunamadı (%s).%s\n" "$YELLOW" "$MAN_DIR" "$NC"
fi

# 7b. TÜRKÇE MAN PAGE KURULUMU (v1.4.1)
MAN_TR_DIR="/usr/share/man/tr/man8"
LOCAL_MAN_TR_FILE="$SCRIPT_DIR/docs/guncel.8.tr"

if [[ -f "$LOCAL_MAN_TR_FILE" ]]; then
    # Türkçe man dizini oluştur
    if mkdir -p "$MAN_TR_DIR" 2>/dev/null; then
        if install -m 0644 -o root -g root "$LOCAL_MAN_TR_FILE" "$MAN_TR_DIR/guncel.8"; then
            # Symlink'ler için de man page
            ln -sf "$MAN_TR_DIR/guncel.8" "$MAN_TR_DIR/updater.8" 2>/dev/null
            ln -sf "$MAN_TR_DIR/guncel.8" "$MAN_TR_DIR/bigfive.8" 2>/dev/null
            printf "%s✅ Türkçe man page kuruldu (LANG=tr_TR man guncel)%s\n" "$GREEN" "$NC"
        else
            printf "%s⚠️  Türkçe man page kurulamadı (opsiyonel).%s\n" "$YELLOW" "$NC"
        fi
    fi
fi

# 8. DİL DOSYALARI KURULUMU (v6.0.0 - i18n)
printf "\n%s>>> Dil Dosyaları (i18n)%s\n" "$BLUE" "$NC"

LANG_INSTALL_DIR="/usr/share/bigfive-updater/lang"
LOCAL_LANG_TR="$SCRIPT_DIR/lang/tr.sh"
LOCAL_LANG_EN="$SCRIPT_DIR/lang/en.sh"
LANG_TR_URL="https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/tr.sh"
LANG_EN_URL="https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/en.sh"
TEMP_LANG_TR="$(mktemp /tmp/guncel_lang_tr_XXXXXX)"
TEMP_LANG_EN="$(mktemp /tmp/guncel_lang_en_XXXXXX)"

# Dizini oluştur
if ! mkdir -p "$LANG_INSTALL_DIR" 2>/dev/null; then
    printf "%s⚠️  Dil dizini oluşturulamadı (%s).%s\n" "$YELLOW" "$LANG_INSTALL_DIR" "$NC"
else
    LANG_INSTALLED=0

    # Türkçe dil dosyası
    if [[ -f "$LOCAL_LANG_TR" ]]; then
        cp "$LOCAL_LANG_TR" "$TEMP_LANG_TR"
        printf "📂 Türkçe dil dosyası: %sLocal%s\n" "$YELLOW" "$NC"
    else
        if curl --proto '=https' --tlsv1.2 -fsSL "$LANG_TR_URL" -o "$TEMP_LANG_TR" 2>/dev/null || \
           wget --secure-protocol=TLSv1_2 -qO "$TEMP_LANG_TR" "$LANG_TR_URL" 2>/dev/null; then
            printf "➡️  İndiriliyor: %s\n" "$LANG_TR_URL"
        else
            TEMP_LANG_TR=""
        fi
    fi

    if [[ -n "$TEMP_LANG_TR" && -s "$TEMP_LANG_TR" ]]; then
        if install -m 0644 -o root -g root "$TEMP_LANG_TR" "$LANG_INSTALL_DIR/tr.sh"; then
            LANG_INSTALLED=$((LANG_INSTALLED + 1))
        fi
    fi

    # İngilizce dil dosyası
    if [[ -f "$LOCAL_LANG_EN" ]]; then
        cp "$LOCAL_LANG_EN" "$TEMP_LANG_EN"
        printf "📂 İngilizce dil dosyası: %sLocal%s\n" "$YELLOW" "$NC"
    else
        if curl --proto '=https' --tlsv1.2 -fsSL "$LANG_EN_URL" -o "$TEMP_LANG_EN" 2>/dev/null || \
           wget --secure-protocol=TLSv1_2 -qO "$TEMP_LANG_EN" "$LANG_EN_URL" 2>/dev/null; then
            printf "➡️  İndiriliyor: %s\n" "$LANG_EN_URL"
        else
            TEMP_LANG_EN=""
        fi
    fi

    if [[ -n "$TEMP_LANG_EN" && -s "$TEMP_LANG_EN" ]]; then
        if install -m 0644 -o root -g root "$TEMP_LANG_EN" "$LANG_INSTALL_DIR/en.sh"; then
            LANG_INSTALLED=$((LANG_INSTALLED + 1))
        fi
    fi

    if [[ $LANG_INSTALLED -eq 2 ]]; then
        printf "%s✅ Dil dosyaları kuruldu (TR, EN)%s\n" "$GREEN" "$NC"
        printf "%sℹ️  Dil seçimi: guncel --lang tr|en veya BIGFIVE_LANG=en guncel%s\n" "$BLUE" "$NC"
    elif [[ $LANG_INSTALLED -gt 0 ]]; then
        printf "%s⚠️  Bazı dil dosyaları kurulamadı.%s\n" "$YELLOW" "$NC"
    else
        printf "%s⚠️  Dil dosyaları kurulamadı (opsiyonel - varsayılan mesajlar kullanılacak).%s\n" "$YELLOW" "$NC"
    fi
fi
rm -f "$TEMP_LANG_TR" "$TEMP_LANG_EN" 2>/dev/null

printf "%s\n" "--------------------------------------------------"
printf "%sℹ️  Not: flock bağımlılığı util-linux paketi ile gelir (genelde kurulu).%s\n" "$BLUE" "$NC"
printf "Komut: %sguncel%s | %supdater%s | %sbigfive%s [--auto] [--skip ...] [--only ...] [--help]\n" "$BOLD" "$NC" "$BOLD" "$NC" "$BOLD" "$NC"
printf "Loglar: %s/var/log/bigfive-updater/%s (logrotate ile yönetilir)\n" "$BOLD" "$NC"
