#!/usr/bin/env bash
# extract-files.sh — Extract proprietary blobs from a running Pixel 3 XL
# or from a factory image dump.
# Usage: ./extract-files.sh [PATH_TO_DUMP]

set -e

DEVICE="crosshatch"
VENDOR="google"
DUMP_DIR="${1:-}"

echo "Extracting proprietary blobs for Pixel 3 XL (crosshatch)..."

if [ -n "$DUMP_DIR" ] && [ -d "$DUMP_DIR" ]; then
    echo "Using dump directory: $DUMP_DIR"
    SRC="$DUMP_DIR"
else
    echo "No dump directory provided — extracting from connected device via ADB."
    SRC="adb"
    # Check device is connected
    if ! adb get-state 1>/dev/null 2>&1; then
        echo "ERROR: No ADB device connected. Connect your Pixel 3 XL or provide a dump directory."
        exit 1
    fi
    DEVICE_MODEL=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r')
    if [[ "$DEVICE_MODEL" != *"Pixel 3 XL"* ]]; then
        echo "WARNING: Connected device may not be Pixel 3 XL (detected: $DEVICE_MODEL)"
    fi
fi

VENDOR_OUT="../../vendor/${VENDOR}/${DEVICE}"
mkdir -p "${VENDOR_OUT}/proprietary"

extract_file() {
    local FILE="$1"
    local DEST="${VENDOR_OUT}/proprietary/${FILE}"
    mkdir -p "$(dirname ${DEST})"
    if [ "$SRC" == "adb" ]; then
        adb pull "/${FILE}" "${DEST}" 2>/dev/null && echo "  Pulled: $FILE" || echo "  MISSING: $FILE"
    else
        cp -f "${SRC}/${FILE}" "${DEST}" 2>/dev/null && echo "  Copied: $FILE" || echo "  MISSING: $FILE"
    fi
}

echo "Pulling blobs..."
while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" =~ ^#.*$ ]] && continue
    [[ -z "$line" ]] && continue
    extract_file "$line"
done < "proprietary-files.txt"

echo ""
echo "Generating vendor makefile..."
bash setup-makefiles.sh

echo "Done! Blobs extracted to ${VENDOR_OUT}"
