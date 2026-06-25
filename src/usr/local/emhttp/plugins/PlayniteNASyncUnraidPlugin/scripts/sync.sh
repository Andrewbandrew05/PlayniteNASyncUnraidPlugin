#!/bin/bash
export PATH=/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin
LOG="/usr/local/emhttp/plugins/PlayniteNASyncUnraidPlugin/sync.log"

{
    echo "--- START $(date) ---"
    # Try to list the file to prove the user has access
    whoami
    ls -l /usr/local/emhttp/plugins/PlayniteNASyncUnraidPlugin/scripts/sync.sh
    echo "Running sync..."
    # Your sync command here
    echo "--- END $(date) ---"
} > "$LOG" 2>&1