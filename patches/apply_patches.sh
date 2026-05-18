#!/usr/bin/env bash
# apply_patches.sh — Apply all crosshatch compatibility patches
# Run this after syncing sources but before building.

set -e

TOPDIR=$(pwd)
PATCH_DIR="${TOPDIR}/device/google/crosshatch/patches/crosshatch-compat"
KERNEL_PATCH_DIR="${TOPDIR}/device/google/crosshatch/patches/kernel"
FW_PATCH_DIR="${TOPDIR}/device/google/crosshatch/patches/frameworks"

GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

log_ok()   { echo -e "${GREEN}[✓]${NC} $1"; }
log_err()  { echo -e "${RED}[✗]${NC} $1"; }
log_info() { echo -e "${YELLOW}[~]${NC} $1"; }

apply_patch() {
    local repo_path="$1"
    local patch_file="$2"
    log_info "Applying: $(basename ${patch_file}) → ${repo_path}"
    if git -C "${TOPDIR}/${repo_path}" am --3way "${patch_file}" 2>/dev/null; then
        log_ok "Applied: $(basename ${patch_file})"
    else
        log_err "FAILED: $(basename ${patch_file})"
        git -C "${TOPDIR}/${repo_path}" am --abort 2>/dev/null || true
        exit 1
    fi
}

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║   PixelOS Crosshatch Port — Applying Patches             ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# ── Framework patches ─────────────────────────────────────────────────────────
log_info "Applying framework patches..."
apply_patch "frameworks/base" \
    "${PATCH_DIR}/0001-crosshatch-display-notch.patch"

apply_patch "frameworks/av" \
    "${PATCH_DIR}/0002-crosshatch-wireless-charging.patch"

apply_patch "frameworks/base" \
    "${PATCH_DIR}/0006-crosshatch-pixel-launcher.patch"

# ── Vendor / HAL patches ──────────────────────────────────────────────────────
log_info "Applying vendor/HAL patches..."
apply_patch "hardware/nxp/nfc" \
    "${PATCH_DIR}/0003-crosshatch-nfc-hal.patch"

apply_patch "hardware/google/camera" \
    "${PATCH_DIR}/0004-crosshatch-camera-gcam.patch"

apply_patch "hardware/qcom/audio-ar" \
    "${PATCH_DIR}/0005-crosshatch-audio-hal.patch"

apply_patch "vendor/qcom/opensource/core-utils" \
    "${PATCH_DIR}/0007-crosshatch-selinux-fix.patch"

apply_patch "hardware/google/pixel" \
    "${PATCH_DIR}/0008-crosshatch-thermal.patch"

apply_patch "hardware/google/pixel" \
    "${PATCH_DIR}/0009-crosshatch-vibrator.patch"

# ── Kernel patches ────────────────────────────────────────────────────────────
if [ -d "${TOPDIR}/kernel/google/crosshatch" ]; then
    log_info "Applying kernel patches..."
    for kpatch in "${KERNEL_PATCH_DIR}"/*.patch; do
        [ -f "$kpatch" ] || continue
        apply_patch "kernel/google/crosshatch" "$kpatch"
    done
else
    log_info "Kernel source not found, skipping kernel patches."
fi

echo ""
echo -e "${GREEN}All patches applied successfully!${NC}"
echo "You may now run: lunch pixelos_crosshatch-user && make bacon"
