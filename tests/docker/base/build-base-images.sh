#!/bin/bash
#
# BigFive Updater - Base Image Builder
# Builds pre-configured images for faster testing
#
# Usage: ./build-base-images.sh [distro|all] [--pull]
#
# Options:
#   --pull    Pull from ghcr.io instead of building locally
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REGISTRY="ghcr.io/ahm3t0t"

declare -A DISTROS=(
    [ubuntu]="Dockerfile.ubuntu"
    [fedora]="Dockerfile.fedora"
    [arch]="Dockerfile.arch"
    [opensuse]="Dockerfile.opensuse"
    [alpine]="Dockerfile.alpine"
)

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

PULL_MODE=false

build_image() {
    local distro=$1
    local dockerfile="${DISTROS[$distro]}"
    local image_name="bigfive-base-${distro}"

    echo -e "${BLUE}Building ${image_name}...${NC}"

    docker build \
        -f "$SCRIPT_DIR/$dockerfile" \
        -t "$image_name" \
        "$SCRIPT_DIR" 2>&1 | tail -3

    echo -e "${GREEN}✓ ${image_name} built${NC}"
    echo ""
}

pull_image() {
    local distro=$1
    local image_name="bigfive-base-${distro}"
    local remote_image="${REGISTRY}/${image_name}:latest"

    echo -e "${BLUE}Pulling ${remote_image}...${NC}"

    docker pull "$remote_image" 2>&1 | tail -3
    docker tag "$remote_image" "$image_name"

    echo -e "${GREEN}✓ ${image_name} ready${NC}"
    echo ""
}

# Parse args
TARGET="all"
for arg in "$@"; do
    case $arg in
        --pull) PULL_MODE=true ;;
        -*) echo "Unknown option: $arg"; exit 1 ;;
        *) TARGET="$arg" ;;
    esac
done

if [[ "$TARGET" == "all" ]]; then
    if $PULL_MODE; then
        echo "Pulling all base images from ghcr.io..."
    else
        echo "Building all base images..."
    fi
    echo ""
    for distro in "${!DISTROS[@]}"; do
        if $PULL_MODE; then
            pull_image "$distro"
        else
            build_image "$distro"
        fi
    done
else
    if [[ -z "${DISTROS[$TARGET]:-}" ]]; then
        echo "Unknown distro: $TARGET"
        echo "Available: ${!DISTROS[*]} all"
        exit 1
    fi
    if $PULL_MODE; then
        pull_image "$TARGET"
    else
        build_image "$TARGET"
    fi
fi

echo "=== Base Images ==="
docker images | grep bigfive-base || true
