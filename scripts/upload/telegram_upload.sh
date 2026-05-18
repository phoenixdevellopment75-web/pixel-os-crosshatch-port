#!/usr/bin/env bash
# scripts/upload/telegram_upload.sh
# Upload ROM ZIP to Telegram channel and send build notification
#
# Requires secrets: TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID
# Set them in: GitHub repo → Settings → Secrets → Actions

set -e

ZIP_PATH="$1"
ZIP_NAME="$2"
ZIP_MD5="$3"
ZIP_SIZE="$4"

BOT_TOKEN="${TELEGRAM_BOT_TOKEN}"
CHAT_ID="${TELEGRAM_CHAT_ID}"

API="https://api.telegram.org/bot${BOT_TOKEN}"

if [ -z "$BOT_TOKEN" ] || [ -z "$CHAT_ID" ]; then
    echo "⚠️  Telegram secrets not set. Skipping upload."
    exit 0
fi

echo "📨 Sending Telegram notification..."

# ── Build message ─────────────────────────────────────────────────────────────
BUILD_DATE=$(date -u '+%Y-%m-%d %H:%M UTC')
MESSAGE="🔥 *PixelOS Android 14 — Pixel 3 XL*

📱 *Device:* Pixel 3 XL (crosshatch)
🗓️ *Date:* ${BUILD_DATE}
📦 *File:* \`${ZIP_NAME}\`
📏 *Size:* ${ZIP_SIZE}
🔑 *MD5:* \`${ZIP_MD5}\`

✅ NFC | ✅ Wireless Charging | ✅ GCam
✅ SELinux Enforcing | ✅ Play Integrity

⚡ Flash via TWRP — Wipe System+Data first!"

# ── Send message first ────────────────────────────────────────────────────────
MSG_RESPONSE=$(curl -s -X POST "${API}/sendMessage" \
    -d chat_id="${CHAT_ID}" \
    -d parse_mode="Markdown" \
    -d text="${MESSAGE}")

echo "Message response: $MSG_RESPONSE"

# ── Upload file (if under Telegram's 2GB limit) ───────────────────────────────
ZIP_BYTES=$(stat -c%s "$ZIP_PATH" 2>/dev/null || stat -f%z "$ZIP_PATH")
MAX_BYTES=$((2 * 1024 * 1024 * 1024))  # 2GB

if [ "$ZIP_BYTES" -lt "$MAX_BYTES" ]; then
    echo "📤 Uploading ZIP to Telegram (${ZIP_SIZE})..."
    UPLOAD_RESPONSE=$(curl -s -X POST "${API}/sendDocument" \
        -F chat_id="${CHAT_ID}" \
        -F document=@"${ZIP_PATH}" \
        -F caption="PixelOS 14 — crosshatch — ${BUILD_DATE}" \
        -F parse_mode="Markdown")
    echo "Upload response: $UPLOAD_RESPONSE"
else
    echo "⚠️  ZIP is larger than 2GB — Telegram file upload skipped."
    echo "    Use Google Drive upload instead."
fi

echo "✅ Telegram notification sent!"
