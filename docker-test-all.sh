#!/bin/bash
set -euo pipefail

PROJECT_DIR="/home/tahmet/projects/bigfive-updater"
LOG_DIR="/home/tahmet/Claude/temp"
mkdir -p "$LOG_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $*"; }
pass() { echo -e "${GREEN}[PASS]${NC} $*"; }
fail() { echo -e "${RED}[FAIL]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }

declare -A IMAGES=(
    [ubuntu]="ubuntu:24.04"
    [fedora]="fedora:40"
    [arch]="archlinux:latest"
    [opensuse]="opensuse/leap:15.6"
    [alpine]="alpine:3.20"
)

declare -A INSTALL_CMDS=(
    [ubuntu]="apt-get update && apt-get install -y curl sudo gawk"
    [fedora]="dnf install -y curl sudo gawk hostname procps-ng"
    [arch]="pacman -Sy --noconfirm curl sudo gawk"
    [opensuse]="zypper install -y curl sudo gawk hostname"
    [alpine]="apk add --no-cache curl bash sudo gawk"
)

run_test() {
    local distro="$1"
    local test_name="$2"
    local test_cmd="$3"
    local image="${IMAGES[$distro]}"
    local install="${INSTALL_CMDS[$distro]}"

    # Alpine doesn't have /bin/bash by default, use /bin/sh
    local shell="/bin/bash"
    [[ "$distro" == "alpine" ]] && shell="/bin/sh"

    log "[$distro] Running: $test_name"

    if docker run --rm \
        -v "${PROJECT_DIR}:/app:ro" \
        -w /app \
        "$image" \
        "$shell" -c "
            set -e
            $install >/dev/null 2>&1
            bash /app/install.sh --local >/dev/null 2>&1
            $test_cmd
        " 2>&1; then
        pass "[$distro] $test_name"
        return 0
    else
        fail "[$distro] $test_name"
        return 1
    fi
}

echo "=========================================="
echo "  BigFive Docker Multi-Distro Test Suite"
echo "  $(date)"
echo "=========================================="
echo ""

TOTAL=0
PASSED=0
FAILED=0

# Phase 1: Install + Help
echo ""
echo "=== PHASE 1: Installation & Help ==="
for distro in ubuntu fedora arch opensuse alpine; do
    ((++TOTAL))
    if run_test "$distro" "install+help" "guncel --help >/dev/null"; then
        ((++PASSED))
    else
        ((++FAILED))
    fi
done

# Phase 2: Dry-run Verbose
echo ""
echo "=== PHASE 2: Dry-run Verbose ==="
for distro in ubuntu fedora arch opensuse alpine; do
    ((++TOTAL))
    if run_test "$distro" "dry-run" "guncel --dry-run --verbose 2>&1 | head -50"; then
        ((++PASSED))
    else
        ((++FAILED))
    fi
done

# Phase 3: JSON Full Output
echo ""
echo "=== PHASE 3: JSON Full Output ==="
for distro in ubuntu fedora arch opensuse alpine; do
    ((++TOTAL))
    if run_test "$distro" "json-full" "guncel --json-full --dry-run 2>&1 | tail -20"; then
        ((++PASSED))
    else
        ((++FAILED))
    fi
done

# Summary
echo ""
echo "=========================================="
echo "               TEST SUMMARY"
echo "=========================================="
echo "Total:  $TOTAL"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"
echo "=========================================="

if [[ $FAILED -gt 0 ]]; then
    exit 1
fi
exit 0
