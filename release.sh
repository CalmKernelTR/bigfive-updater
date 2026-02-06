#!/bin/bash
# BigFive Updater - Release Script
# Versiyon: Dev-V1.3.0
# Kullanım: ./release.sh [patch|minor|major] [-y] veya ./release.sh 4.2.0 -y

set -euo pipefail

RELEASE_SCRIPT_VERSION="Dev-V1.3.1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GUNCEL_FILE="$SCRIPT_DIR/guncel"

# Renk kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Varsayılan: onay iste
AUTO_CONFIRM=false
CHECK_COMMITS=false

# Cleanup state for rollback
CLEANUP_COMMIT=false
CLEANUP_TAG=""
ORIGINAL_VERSION=""

# Rollback function for partial failures
cleanup_on_error() {
  local exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    printf '%s\n' "" >&2
    printf '%b%s%b\n' "${RED}" "HATA: Release işlemi başarısız oldu, geri alınıyor..." "${NC}" >&2

    # Revert commit if made
    if [[ "$CLEANUP_COMMIT" == "true" ]]; then
      printf '%s\n' "Commit geri alınıyor..." >&2
      git reset --soft HEAD~1 2> /dev/null || true
    fi

    # Delete tag if created
    if [[ -n "$CLEANUP_TAG" ]]; then
      printf '%s\n' "Tag siliniyor: $CLEANUP_TAG" >&2
      git tag -d "$CLEANUP_TAG" 2> /dev/null || true
    fi

    # Restore original version in file
    if [[ -n "$ORIGINAL_VERSION" && -f "$GUNCEL_FILE" ]]; then
      printf '%s\n' "Versiyon geri yükleniyor: $ORIGINAL_VERSION" >&2
      sed -i "s/^VERSION=\"[^\"]*\"/VERSION=\"$ORIGINAL_VERSION\"/" "$GUNCEL_FILE" 2> /dev/null || true
    fi

    printf '%b%s%b\n' "${YELLOW}" "Rollback tamamlandı. Lütfen durumu kontrol edin: git status" "${NC}" >&2
  fi
}

# Validate semantic version format (X.Y.Z)
validate_version() {
  local version="$1"
  if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    printf '%b%s%b\n' "${RED}" "HATA: Geçersiz versiyon formatı: $version (beklenen: X.Y.Z)" "${NC}" >&2
    return 1
  fi
  return 0
}

# Check guncel file exists and is readable
check_guncel_file() {
  if [[ ! -f "$GUNCEL_FILE" ]]; then
    printf '%b%s%b\n' "${RED}" "HATA: guncel dosyası bulunamadı: $GUNCEL_FILE" "${NC}" >&2
    exit 1
  fi
  if [[ ! -r "$GUNCEL_FILE" ]]; then
    printf '%b%s%b\n' "${RED}" "HATA: guncel dosyası okunamıyor: $GUNCEL_FILE" "${NC}" >&2
    exit 1
  fi
  if [[ ! -w "$GUNCEL_FILE" ]]; then
    printf '%b%s%b\n' "${RED}" "HATA: guncel dosyası yazılamıyor: $GUNCEL_FILE" "${NC}" >&2
    exit 1
  fi
}

# Check for clean git state
check_git_state() {
  if ! git diff-index --quiet HEAD -- 2> /dev/null; then
    printf '%b%s%b\n' "${RED}" "HATA: Commit edilmemiş değişiklikler var. Önce commit/stash yapın." "${NC}" >&2
    git status --short >&2
    exit 1
  fi
}

# Check if tag already exists
check_tag_exists() {
  local tag="$1"
  if git rev-parse "$tag" > /dev/null 2>&1; then
    printf '%b%s%b\n' "${RED}" "HATA: Tag zaten mevcut: $tag" "${NC}" >&2
    exit 1
  fi
}

# Check commit messages for conventional commits format
# Returns: 0 if all OK, 1 if issues found (report only, non-blocking)
check_commit_messages() {
  local last_tag bad_count=0

  # Find last tag
  last_tag=$(git describe --tags --abbrev=0 2> /dev/null || echo "")

  if [[ -z "$last_tag" ]]; then
    printf '%bUyarı: Önceki tag bulunamadı, tüm commit geçmişi kontrol edilemiyor%b\n' "${YELLOW}" "${NC}"
    return 0
  fi

  printf '%bCommit Hygiene Check%b (since %s)\n' "${BLUE}" "${NC}" "$last_tag"
  printf '%s\n' "─────────────────────────────────────────"

  # Conventional commits regex: type(scope): description OR type: description
  # Valid types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
  local conventional_pattern="^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\(.+\))?: .+"

  # Get commits since last tag
  while IFS= read -r line; do
    local hash msg
    hash=$(printf '%s' "$line" | cut -d' ' -f1)
    msg=$(printf '%s' "$line" | cut -d' ' -f2-)

    # Skip merge commits
    if [[ "$msg" =~ ^Merge ]]; then
      continue
    fi

    # Check against conventional commits pattern
    if [[ ! "$msg" =~ $conventional_pattern ]]; then
      if [[ $bad_count -eq 0 ]]; then
        printf '%bUyumsuz commit mesajları:%b\n' "${YELLOW}" "${NC}"
      fi
      printf '  %s %s\n' "$hash" "$msg"
      ((bad_count++)) || true
    fi
  done < <(git log "$last_tag"..HEAD --oneline 2> /dev/null)

  printf '%s\n' "─────────────────────────────────────────"

  if [[ $bad_count -eq 0 ]]; then
    printf '%b✓%b Tüm commit mesajları conventional formata uygun\n' "${GREEN}" "${NC}"
    return 0
  else
    printf '%b!%b %d commit mesajı conventional formata uymuyor\n' "${YELLOW}" "${NC}" "$bad_count"
    printf '%s\n' ""
    printf '%s\n' "Önerilen format: type(scope): description"
    printf '%s\n' "Tipler: feat, fix, docs, style, refactor, perf, test, build, ci, chore"
    printf '%s\n' ""
    printf '%s\n' "Düzeltmek için: git rebase -i $last_tag (dikkat: force push gerektirir)"
    return 1
  fi
}

# Mevcut versiyonu al (POSIX-compatible, grep -oP yerine)
get_current_version() {
  local version
  version=$(grep '^VERSION=' "$GUNCEL_FILE" | cut -d'"' -f2)
  if [[ -z "$version" ]]; then
    printf '%b%s%b\n' "${RED}" "HATA: VERSION değişkeni guncel dosyasında bulunamadı" "${NC}" >&2
    return 1
  fi
  printf '%s\n' "$version"
}

# Escape special characters for sed
escape_for_sed() {
  printf '%s\n' "$1" | sed 's/[&/\]/\\&/g'
}

# Versiyon bump
bump_version() {
  local current="$1"
  local bump_type="$2"

  IFS='.' read -r major minor patch <<< "$current"

  case "$bump_type" in
    major)
      printf '%s\n' "$((major + 1)).0.0"
      ;;
    minor)
      printf '%s\n' "${major}.$((minor + 1)).0"
      ;;
    patch)
      printf '%s\n' "${major}.${minor}.$((patch + 1))"
      ;;
    *)
      # Direkt versiyon numarası verilmiş
      printf '%s\n' "$bump_type"
      ;;
  esac
}

# Kullanım bilgisi
usage() {
  printf '%b%s%b (%s)\n' "${BLUE}" "BigFive Release Script" "${NC}" "$RELEASE_SCRIPT_VERSION"
  printf '\n'
  printf 'Kullanım: %s [patch|minor|major|X.Y.Z] [-y]\n' "$0"
  printf '\n'
  printf 'Seçenekler:\n'
  printf '  -y, --yes           Onay sormadan devam et (otomasyon için)\n'
  printf '  -c, --check-commits Commit mesajlarını kontrol et (conventional commits)\n'
  printf '  -v, --version       Script versiyonunu göster\n'
  printf '  -h, --help          Bu yardım mesajını göster\n'
  printf '\n'
  printf 'Örnekler:\n'
  printf '  %s patch            # 4.1.3 -> 4.1.4\n' "$0"
  printf '  %s minor            # 4.1.3 -> 4.2.0\n' "$0"
  printf '  %s major            # 4.1.3 -> 5.0.0\n' "$0"
  printf '  %s 4.2.0            # 4.1.3 -> 4.2.0\n' "$0"
  printf '  %s patch -y         # Onay sormadan patch release\n' "$0"
  printf '  %s --check-commits  # Release öncesi commit hygiene check\n' "$0"
  exit 1
}

# Ana akış
main() {
  local bump_type=""

  # Argümanları parse et
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -y | --yes)
        AUTO_CONFIRM=true
        shift
        ;;
      -c | --check-commits)
        CHECK_COMMITS=true
        shift
        ;;
      -v | --version)
        printf 'release.sh %s\n' "$RELEASE_SCRIPT_VERSION"
        exit 0
        ;;
      -h | --help)
        usage
        ;;
      -*)
        printf '%bBilinmeyen seçenek: %s%b\n' "${RED}" "$1" "${NC}"
        usage
        ;;
      *)
        if [[ -z "$bump_type" ]]; then
          bump_type="$1"
        else
          printf '%bFazla argüman: %s%b\n' "${RED}" "$1" "${NC}"
          usage
        fi
        shift
        ;;
    esac
  done

  # Handle --check-commits only mode
  if [[ "$CHECK_COMMITS" == "true" && -z "$bump_type" ]]; then
    check_commit_messages
    exit $?
  fi

  if [[ -z "$bump_type" ]]; then
    usage
  fi

  # Pre-flight checks
  check_guncel_file
  check_git_state

  # Run commit check if requested (non-blocking, informational)
  if [[ "$CHECK_COMMITS" == "true" ]]; then
    check_commit_messages || true
    printf '\n'
  fi

  local current_version
  current_version=$(get_current_version)

  # Validate current version
  if ! validate_version "$current_version"; then
    printf '%b%s%b\n' "${RED}" "HATA: Mevcut versiyon geçersiz format" "${NC}" >&2
    exit 1
  fi

  local new_version
  new_version=$(bump_version "$current_version" "$bump_type")

  # Validate new version
  if ! validate_version "$new_version"; then
    exit 1
  fi

  # Check tag doesn't already exist
  check_tag_exists "v$new_version"

  printf '%bMevcut versiyon:%b %s\n' "${YELLOW}" "${NC}" "$current_version"
  printf '%bYeni versiyon:%b    %s\n' "${GREEN}" "${NC}" "$new_version"
  printf '\n'

  # Onay iste (AUTO_CONFIRM değilse)
  if [[ "$AUTO_CONFIRM" != "true" ]]; then
    read -p "Devam edilsin mi? [y/N] " -n 1 -r
    printf '\n'
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      printf '%bİptal edildi.%b\n' "${RED}" "${NC}"
      exit 1
    fi
  else
    printf '%bOtomatik onay (-y) aktif, devam ediliyor...%b\n' "${BLUE}" "${NC}"
  fi

  # Set up rollback trap
  ORIGINAL_VERSION="$current_version"
  trap cleanup_on_error EXIT

  # Versiyonu güncelle (escaped for sed safety)
  local escaped_current escaped_new
  escaped_current=$(escape_for_sed "$current_version")
  escaped_new=$(escape_for_sed "$new_version")
  sed -i "s/^VERSION=\"${escaped_current}\"/VERSION=\"${escaped_new}\"/" "$GUNCEL_FILE"
  printf '%b✓%b guncel dosyası güncellendi\n' "${GREEN}" "${NC}"

  # Git işlemleri - GPG signed
  git add "$GUNCEL_FILE"
  git commit -S -m "Bump version to $new_version"
  CLEANUP_COMMIT=true
  printf '%b✓%b Commit oluşturuldu (GPG signed)\n' "${GREEN}" "${NC}"

  git tag -s "v$new_version" -m "v$new_version"
  CLEANUP_TAG="v$new_version"
  printf '%b✓%b Tag oluşturuldu: v%s (GPG signed)\n' "${GREEN}" "${NC}" "$new_version"

  git push
  git push origin "v$new_version"
  printf '%b✓%b Push tamamlandı\n' "${GREEN}" "${NC}"

  # Clear rollback state on success
  trap - EXIT
  CLEANUP_COMMIT=false
  CLEANUP_TAG=""
  ORIGINAL_VERSION=""

  printf '\n'
  printf '%bRelease v%s başarıyla oluşturuldu!%b\n' "${GREEN}" "$new_version" "${NC}"
  printf 'GitHub Actions workflow çalışıyor, birkaç saniye içinde release hazır olacak.\n'
  printf '\n'
  printf 'Release sayfası: https://github.com/CalmKernelTR/bigfive-updater/releases/tag/v%s\n' "$new_version"
}

main "$@"
