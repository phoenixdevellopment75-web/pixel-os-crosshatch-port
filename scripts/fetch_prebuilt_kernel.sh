#!/usr/bin/env bash
# scripts/fetch_prebuilt_kernel.sh
# Downloads the official Pixel 3 XL (crosshatch) prebuilt kernel from Google.
#
# Google publishes kernel binaries inside factory/OTA images.
# This script pulls Image.lz4-dtb + dtbo.img without needing to compile.
#
# Usage:  bash scripts/fetch_prebuilt_kernel.sh
#         (Run this from repo root BEFORE building)

set -e

DEVICE_PATH="device/google/crosshatch"
PREBUILT_DIR="${DEVICE_PATH}/prebuilt"
mkdir -p "$PREBUILT_DIR"

GREEN="\033[0;32m"; YELLOW="\033[1;33m"; RED="\033[0;31m"; NC="\033[0m"

log()  { echo -e "${GREEN}[✓]${NC} $1"; }
info() { echo -e "${YELLOW}[~]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }

# ── Option 1: Pull from TheMuppets vendor blobs ────────────────────────────
# TheMuppets already has the prebuilt kernel inside vendor/google/crosshatch
VENDOR_KERNEL="vendor/google/crosshatch/kernel/Image.lz4-dtb"
VENDOR_DTBO="vendor/google/crosshatch/kernel/dtbo.img"

if [ -f "$VENDOR_KERNEL" ]; then
    info "Found kernel in vendor blobs — copying..."
    cp "$VENDOR_KERNEL" "${PREBUILT_DIR}/Image.lz4-dtb"
    [ -f "$VENDOR_DTBO" ] && cp "$VENDOR_DTBO" "${PREBUILT_DIR}/dtbo.img"
    log "Prebuilt kernel installed from vendor blobs."
    exit 0
fi

# ── Option 2: Download from Google's factory image (latest Android 14) ────
info "Vendor blobs not found. Downloading from Google factory image..."

# Android 14 UP1.231005.007 for crosshatch
FACTORY_URL="https://dl.google.com/dl/android/aosp/crosshatch-up1.231005.007-factory-16f28aa4.zip"
FACTORY_ZIP="/tmp/crosshatch_factory.zip"

info "Downloading factory image (this is ~1.5 GB)..."
curl -L --progress-bar "$FACTORY_URL" -o "$FACTORY_ZIP"

info "Extracting image..."
cd /tmp
unzip -q "$FACTORY_ZIP" -d crosshatch_factory
cd crosshatch_factory/*/

unzip -q "image-crosshatch-*.zip" -d images
BOOT_IMG="images/boot.img"

if [ -f "$BOOT_IMG" ]; then
    info "Extracting kernel from boot.img..."
    # Use Android's unpackbootimg to extract kernel
    if command -v unpackbootimg &>/dev/null; then
        unpackbootimg -i "$BOOT_IMG" -o /tmp/boot_out/
        cp /tmp/boot_out/*-zImage "${OLDPWD}/${PREBUILT_DIR}/Image.lz4-dtb" 2>/dev/null || \
        cp /tmp/boot_out/*-kernel "${OLDPWD}/${PREBUILT_DIR}/Image.lz4-dtb"
    else
        # Fallback: raw kernel extraction (skip 2048-byte header)
        dd if="$BOOT_IMG" bs=1 skip=2048 of="${OLDPWD}/${PREBUILT_DIR}/Image.lz4-dtb" 2>/dev/null
    fi

    # Extract dtbo
    [ -f images/dtbo.img ] && \
        cp images/dtbo.img "${OLDPWD}/${PREBUILT_DIR}/dtbo.img"

    log "Kernel extracted to ${PREBUILT_DIR}/"
else
    err "Could not extract kernel from factory image."
    err "Please manually place Image.lz4-dtb in ${PREBUILT_DIR}/"
    exit 1
fi

# Cleanup
rm -rf /tmp/crosshatch_factory "$FACTORY_ZIP"
log "Done! Prebuilt kernel is ready."
