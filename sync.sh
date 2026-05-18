#!/usr/bin/env bash
# sync.sh — Repo sync helper with retry logic

set -e

JOBS=$(nproc --all)
MAX_RETRIES=3

echo "Syncing PixelOS sources (${JOBS} threads)..."

for i in $(seq 1 $MAX_RETRIES); do
    echo "Sync attempt $i/$MAX_RETRIES..."
    repo sync -c -j"${JOBS}" \
        --force-sync \
        --no-clone-bundle \
        --no-tags \
        --fail-fast && break

    if [ "$i" -eq "$MAX_RETRIES" ]; then
        echo "ERROR: Sync failed after $MAX_RETRIES attempts"
        exit 1
    fi
    echo "Sync failed, retrying in 10 seconds..."
    sleep 10
done

echo "Sync complete!"
