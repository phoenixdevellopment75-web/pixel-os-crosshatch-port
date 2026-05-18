#!/usr/bin/env bash
# scripts/upload/gdrive_upload.sh
# Upload ROM ZIP to Google Drive using a service account
#
# Requires secrets:
#   GDRIVE_SERVICE_ACCOUNT_JSON  — Service account key JSON (base64 encoded)
#   GDRIVE_FOLDER_ID             — Google Drive folder ID to upload into
#
# How to set up service account:
# 1. Go to: https://console.cloud.google.com/iam-admin/serviceaccounts
# 2. Create a service account
# 3. Download key as JSON
# 4. Base64 encode: base64 -w 0 key.json
# 5. Add as GitHub secret: GDRIVE_SERVICE_ACCOUNT_JSON

set -e

ZIP_PATH="$1"

if [ -z "$GDRIVE_SERVICE_ACCOUNT_JSON" ] || [ -z "$GDRIVE_FOLDER_ID" ]; then
    echo "⚠️  Google Drive secrets not set. Skipping upload."
    exit 0
fi

echo "☁️  Uploading to Google Drive..."

# Decode service account JSON
echo "$GDRIVE_SERVICE_ACCOUNT_JSON" | base64 -d > /tmp/gdrive_sa.json

# Install gdrive tool
pip3 install -q --upgrade google-auth google-auth-httplib2 google-api-python-client

# Upload via Python script
python3 << 'PYEOF'
import os, sys, json
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload
from google.oauth2 import service_account

ZIP_PATH    = sys.argv[1] if len(sys.argv) > 1 else os.environ.get("ZIP_PATH")
FOLDER_ID   = os.environ["GDRIVE_FOLDER_ID"]
SA_KEY_FILE = "/tmp/gdrive_sa.json"

SCOPES = ["https://www.googleapis.com/auth/drive.file"]
creds  = service_account.Credentials.from_service_account_file(SA_KEY_FILE, scopes=SCOPES)
drive  = build("drive", "v3", credentials=creds)

file_name = os.path.basename(ZIP_PATH)
file_size = os.path.getsize(ZIP_PATH)

print(f"Uploading: {file_name} ({file_size / 1024**3:.2f} GB)")

file_metadata = {
    "name":    file_name,
    "parents": [FOLDER_ID],
}
media = MediaFileUpload(ZIP_PATH, mimetype="application/zip", resumable=True)
file  = drive.files().create(body=file_metadata, media_body=media, fields="id,webViewLink").execute()

print(f"✅ Uploaded! File ID: {file.get('id')}")
print(f"🔗 Link: {file.get('webViewLink')}")
PYEOF

echo "✅ Google Drive upload complete!"
