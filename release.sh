#!/bin/bash
# ARCB Wider Updater - Release Script
# Kullanım: ./release.sh [patch|minor|major] veya ./release.sh 4.2.0

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GUNCEL_FILE="$SCRIPT_DIR/guncel"

# Renk kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Mevcut versiyonu al
get_current_version() {
    grep -oP '^VERSION="\K[^"]+' "$GUNCEL_FILE"
}

# Versiyon bump
bump_version() {
    local current="$1"
    local bump_type="$2"

    IFS='.' read -r major minor patch <<< "$current"

    case "$bump_type" in
        major)
            echo "$((major + 1)).0.0"
            ;;
        minor)
            echo "${major}.$((minor + 1)).0"
            ;;
        patch)
            echo "${major}.${minor}.$((patch + 1))"
            ;;
        *)
            # Direkt versiyon numarası verilmiş
            echo "$bump_type"
            ;;
    esac
}

# Kullanım bilgisi
usage() {
    echo "Kullanım: $0 [patch|minor|major|X.Y.Z]"
    echo ""
    echo "Örnekler:"
    echo "  $0 patch     # 4.1.3 -> 4.1.4"
    echo "  $0 minor     # 4.1.3 -> 4.2.0"
    echo "  $0 major     # 4.1.3 -> 5.0.0"
    echo "  $0 4.2.0     # 4.1.3 -> 4.2.0"
    exit 1
}

# Ana akış
main() {
    if [[ $# -lt 1 ]]; then
        usage
    fi

    local bump_type="$1"
    local current_version
    current_version=$(get_current_version)

    local new_version
    new_version=$(bump_version "$current_version" "$bump_type")

    echo -e "${YELLOW}Mevcut versiyon:${NC} $current_version"
    echo -e "${GREEN}Yeni versiyon:${NC}    $new_version"
    echo ""

    # Onay iste
    read -p "Devam edilsin mi? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}İptal edildi.${NC}"
        exit 1
    fi

    # Versiyonu güncelle
    sed -i "s/^VERSION=\"$current_version\"/VERSION=\"$new_version\"/" "$GUNCEL_FILE"
    echo -e "${GREEN}✓${NC} guncel dosyası güncellendi"

    # Git işlemleri
    git add "$GUNCEL_FILE"
    git commit -m "Bump version to $new_version"
    echo -e "${GREEN}✓${NC} Commit oluşturuldu"

    git tag -a "v$new_version" -m "v$new_version"
    echo -e "${GREEN}✓${NC} Tag oluşturuldu: v$new_version"

    git push
    git push origin "v$new_version"
    echo -e "${GREEN}✓${NC} Push tamamlandı"

    echo ""
    echo -e "${GREEN}Release v$new_version başarıyla oluşturuldu!${NC}"
    echo "GitHub Actions workflow çalışıyor, birkaç saniye içinde release hazır olacak."
    echo ""
    echo "Release sayfası: https://github.com/ahm3t0t/arcb-wider-updater/releases/tag/v$new_version"
}

main "$@"
