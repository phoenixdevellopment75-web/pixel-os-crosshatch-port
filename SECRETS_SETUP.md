# GitHub Secrets Configuration Guide
# ─────────────────────────────────────────────────────────────────────────────
# Go to: GitHub Repo → Settings → Secrets and Variables → Actions → New Secret
# ─────────────────────────────────────────────────────────────────────────────

# ── REQUIRED FOR TELEGRAM UPLOAD ──────────────────────────────────────────────
#
# TELEGRAM_BOT_TOKEN
#   Your Telegram bot token.
#   How to get it:
#   1. Open Telegram and search for @BotFather
#   2. Send /newbot → follow prompts
#   3. Copy the token (looks like: 1234567890:ABCDEFabcdef...)
#   Value example: 1234567890:ABCDEFabcdef-GHIJK
#
# TELEGRAM_CHAT_ID
#   The ID of your Telegram channel or group to post to.
#   How to get it:
#   1. Add your bot as admin to your channel
#   2. Send a message in the channel
#   3. Visit: https://api.telegram.org/bot<TOKEN>/getUpdates
#   4. Look for "chat": {"id": -100XXXXXXXXX}
#   Value example: -1001234567890

# ── REQUIRED FOR GOOGLE DRIVE UPLOAD ──────────────────────────────────────────
#
# GDRIVE_SERVICE_ACCOUNT_JSON
#   Base64-encoded Google service account key JSON.
#   How to create:
#   1. https://console.cloud.google.com/iam-admin/serviceaccounts
#   2. Create project → Enable Google Drive API
#   3. Create service account → Create key (JSON)
#   4. Share your Drive folder with the service account email
#   5. Encode: base64 -w 0 your-key.json
#   Paste the base64 output as the secret value.
#
# GDRIVE_FOLDER_ID
#   The Google Drive folder ID where ROMs will be uploaded.
#   How to find it:
#   Open the folder in Drive → copy ID from the URL:
#   https://drive.google.com/drive/folders/THIS_IS_THE_FOLDER_ID
#   Value example: 1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgVE2upms

# ── AUTO-PROVIDED (no action needed) ─────────────────────────────────────────
#
# GITHUB_TOKEN
#   Automatically provided by GitHub Actions for creating releases.
#   You do NOT need to set this manually.
