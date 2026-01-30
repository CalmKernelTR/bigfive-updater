#!/bin/sh
# BigFive Updater - Alpine Signing Key Setup
# Bu script bir kez çalıştırılır ve key'ler oluşturulur

set -e

KEY_NAME="bigfive@ahm3t0t"
KEY_DIR="${HOME}/.abuild"

echo "🔐 BigFive Updater Alpine Signing Key Setup"
echo "============================================"
echo ""

# Check if running on Alpine or has abuild
if ! command -v abuild-keygen >/dev/null 2>&1; then
    echo "❌ abuild-keygen bulunamadı."
    echo ""
    echo "Alpine'da:"
    echo "  apk add alpine-sdk"
    echo ""
    echo "Diğer distrolarda Docker kullan:"
    echo "  docker run -it --rm -v \$(pwd):/work alpine sh"
    echo "  apk add alpine-sdk"
    echo "  cd /work && sh setup-key.sh"
    exit 1
fi

# Create key directory
mkdir -p "$KEY_DIR"

# Check if key already exists
if [ -f "$KEY_DIR/${KEY_NAME}.rsa" ]; then
    echo "⚠️  Key zaten mevcut: $KEY_DIR/${KEY_NAME}.rsa"
    echo "Devam etmek mevcut key'i silecek."
    printf "Devam? [y/N] "
    read -r answer
    if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
        echo "İptal edildi."
        exit 0
    fi
    rm -f "$KEY_DIR/${KEY_NAME}.rsa" "$KEY_DIR/${KEY_NAME}.rsa.pub"
fi

# Generate key
echo ""
echo "📝 Key oluşturuluyor..."
abuild-keygen -a -n

# Find generated key
PRIV_KEY=$(find "$KEY_DIR" -name "*.rsa" ! -name "*.pub" -type f | head -1)
PUB_KEY="${PRIV_KEY}.pub"

if [ -z "$PRIV_KEY" ] || [ ! -f "$PRIV_KEY" ]; then
    echo "❌ Key oluşturulamadı!"
    exit 1
fi

echo ""
echo "✅ Key başarıyla oluşturuldu!"
echo ""
echo "📁 Dosyalar:"
echo "   Private: $PRIV_KEY"
echo "   Public:  $PUB_KEY"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Sonraki Adımlar:"
echo ""
echo "1️⃣  Public key'i repo'ya kopyala:"
echo "    cp $PUB_KEY packaging/alpine-repo/"
echo ""
echo "2️⃣  GitHub Secret ekle:"
echo "    - Repo → Settings → Secrets → Actions"
echo "    - New secret: ALPINE_PRIVATE_KEY"
echo "    - Value: (aşağıdaki içerik)"
echo ""
echo "━━━━━━━━━━ PRIVATE KEY (GitHub Secret için) ━━━━━━━━━━"
cat "$PRIV_KEY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "3️⃣  Değişiklikleri commit et:"
echo "    git add packaging/alpine-repo/*.rsa.pub"
echo "    git commit -m 'feat(alpine): signing key eklendi'"
echo ""
echo "⚠️  UYARI: Private key'i ASLA commit etme!"
