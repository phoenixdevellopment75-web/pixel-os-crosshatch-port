#!/usr/bin/env bash
# build.sh — Full automated build script for PixelOS crosshatch port
# Usage: ./build.sh [user|userdebug|eng] [--clean]

set -e

VARIANT="${1:-user}"
CLEAN="${2:-}"

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"
NC="\033[0m"
BOLD="\033[1m"

banner() {
    echo ""
    echo -e "${CYAN}${BOLD}"
    echo "  ██████╗ ██╗██╗  ██╗███████╗██╗      ██████╗ ███████╗"
    echo "  ██╔══██╗██║╚██╗██╔╝██╔════╝██║     ██╔═══██╗██╔════╝"
    echo "  ██████╔╝██║ ╚███╔╝ █████╗  ██║     ██║   ██║███████╗"
    echo "  ██╔═══╝ ██║ ██╔██╗ ██╔══╝  ██║     ██║   ██║╚════██║"
    echo "  ██║     ██║██╔╝ ██╗███████╗███████╗╚██████╔╝███████║"
    echo "  ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚══════╝"
    echo -e "${NC}"
    echo -e "  ${BOLD}PixelOS Android 14 — Pixel 3 XL (crosshatch) Port${NC}"
    echo -e "  ${YELLOW}Build variant: ${VARIANT}${NC}"
    echo ""
}

check_prerequisites() {
    echo -e "${YELLOW}[~] Checking prerequisites...${NC}"
    local missing=0

    for cmd in java git repo python3 make; do
        if ! command -v "$cmd" &>/dev/null; then
            echo -e "${RED}[✗] Missing: $cmd${NC}"
            missing=$((missing + 1))
        else
            echo -e "${GREEN}[✓] Found: $cmd${NC}"
        fi
    done

    if [ "$missing" -gt 0 ]; then
        echo -e "${RED}Please install missing prerequisites before building.${NC}"
        exit 1
    fi

    # Check Java version (must be 11)
    JAVA_VER=$(java -version 2>&1 | grep "version" | awk -F '"' '{print $2}' | cut -d. -f1)
    if [ "$JAVA_VER" != "11" ]; then
        echo -e "${RED}[✗] Java 11 required (found: $JAVA_VER)${NC}"
        exit 1
    fi
    echo -e "${GREEN}[✓] Java 11 OK${NC}"

    # Check RAM
    TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
    if [ "$TOTAL_RAM" -lt 16 ]; then
        echo -e "${YELLOW}[!] Low RAM detected (${TOTAL_RAM}GB). 16GB+ recommended.${NC}"
    fi

    # Check disk space
    FREE_DISK=$(df -BG . | awk 'NR==2{print $4}' | tr -d 'G')
    if [ "$FREE_DISK" -lt 200 ]; then
        echo -e "${RED}[✗] Insufficient disk space (${FREE_DISK}GB free, need 200GB+)${NC}"
        exit 1
    fi
}

setup_ccache() {
    echo -e "${YELLOW}[~] Setting up ccache...${NC}"
    export USE_CCACHE=1
    export CCACHE_EXEC=$(which ccache)
    export CCACHE_DIR="$HOME/.ccache"
    ccache -M 50G
    echo -e "${GREEN}[✓] ccache configured (50GB)${NC}"
}

setup_environment() {
    echo -e "${YELLOW}[~] Setting up build environment...${NC}"
    source build/envsetup.sh
    lunch "pixelos_crosshatch-${VARIANT}"
    echo -e "${GREEN}[✓] Build environment ready${NC}"
}

apply_patches() {
    echo -e "${YELLOW}[~] Applying crosshatch compatibility patches...${NC}"
    bash device/google/crosshatch/patches/apply_patches.sh
    echo -e "${GREEN}[✓] All patches applied${NC}"
}

clean_build() {
    if [ "$CLEAN" == "--clean" ]; then
        echo -e "${YELLOW}[~] Cleaning previous build output...${NC}"
        make clobber
        echo -e "${GREEN}[✓] Clean done${NC}"
    fi
}

start_build() {
    echo ""
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}${BOLD}  Starting build — $(date)${NC}"
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    CPU_CORES=$(nproc --all)
    echo -e "${YELLOW}[~] Building with ${CPU_CORES} threads...${NC}"

    make bacon -j"${CPU_CORES}" 2>&1 | tee build_crosshatch.log
}

print_output() {
    echo ""
    echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${BOLD}  ✅ Build Complete!${NC}"
    echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    ZIP=$(ls out/target/product/crosshatch/PixelOS*.zip 2>/dev/null | tail -1)
    if [ -n "$ZIP" ]; then
        echo ""
        echo -e "  ${BOLD}ROM ZIP:${NC}  $ZIP"
        echo -e "  ${BOLD}Size:${NC}     $(du -sh "$ZIP" | cut -f1)"
        echo -e "  ${BOLD}MD5:${NC}      $(md5sum "$ZIP" | cut -d' ' -f1)"
        echo ""
        echo -e "  Flash with: ${CYAN}adb sideload $ZIP${NC}"
    fi
}

# ── Main ─────────────────────────────────────────────────────────────────────

banner
check_prerequisites
setup_ccache
apply_patches
setup_environment
clean_build
start_build
print_output
