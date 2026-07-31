#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# dave_web_monitor.sh — Periodic web monitoring daemon for Dave
#
# Checks dave_kb.web_monitors for URLs due for inspection,
# fetches them via dave_web, and stores findings.
#
# Designed to run from cronie with callback extension:
#
#   0 */4 * * * /usr/local/bin/dave_web_monitor.sh @callback {
#       expect: "Monitor cycle complete"
#       on_fail: escalate
#       notify: "chat:system-health"
#   }
#
# Copyright (C) 2026 MEARVK LLC

set -e

DAVE_WEB="/usr/local/bin/dave_web"
MYSQL_CMD="mysql -u dave_ai --socket=/run/mysqld/mysqld.sock dave_kb"
CHAT="/usr/local/bin/chat"
LOG="/var/lib/kernel-ai/web_monitor.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG"
    echo "$*"
}

# ============================================================
# Check prerequisites
# ============================================================

if [ ! -x "$DAVE_WEB" ]; then
    echo "ERROR: dave_web not found at $DAVE_WEB"
    exit 1
fi

# ============================================================
# Get pending checks from MySQL
# ============================================================

log "Starting web monitor cycle"

PENDING=$(echo "SELECT id, url FROM pending_web_checks LIMIT 10;" | $MYSQL_CMD -N 2>/dev/null)

if [ -z "$PENDING" ]; then
    log "No pending web checks. Monitor cycle complete."
    echo "Monitor cycle complete"
    exit 0
fi

COUNT=0
ERRORS=0

# ============================================================
# Process each pending URL
# ============================================================

while IFS=$'\t' read -r monitor_id url; do
    [ -z "$url" ] && continue

    log "Checking: $url (monitor #$monitor_id)"

    # Fetch with dave_web
    if $DAVE_WEB "$url" >> "$LOG" 2>&1; then
        # Update last_checked in web_monitors
        echo "UPDATE web_monitors SET last_checked = NOW() WHERE id = $monitor_id;" \
            | $MYSQL_CMD 2>/dev/null

        # Check for content changes (compare hashes)
        LATEST_HASH=$(echo "SELECT content_hash FROM web_findings WHERE url = '$url' ORDER BY fetched_at DESC LIMIT 1;" \
            | $MYSQL_CMD -N 2>/dev/null)
        PREV_HASH=$(echo "SELECT last_content_hash FROM web_monitors WHERE id = $monitor_id;" \
            | $MYSQL_CMD -N 2>/dev/null)

        if [ -n "$LATEST_HASH" ] && [ -n "$PREV_HASH" ] && [ "$LATEST_HASH" != "$PREV_HASH" ]; then
            log "CHANGE DETECTED on $url"
            echo "UPDATE web_monitors SET change_detected = TRUE, change_count = change_count + 1, last_content_hash = '$LATEST_HASH' WHERE id = $monitor_id;" \
                | $MYSQL_CMD 2>/dev/null

            # Notify via chat
            if [ -x "$CHAT" ]; then
                LABEL=$(echo "SELECT label FROM web_monitors WHERE id = $monitor_id;" \
                    | $MYSQL_CMD -N 2>/dev/null)
                $CHAT post system-health "[DAVE] Web change detected: $LABEL ($url)" 2>/dev/null || true
            fi
        elif [ -n "$LATEST_HASH" ]; then
            echo "UPDATE web_monitors SET last_content_hash = '$LATEST_HASH', change_detected = FALSE WHERE id = $monitor_id;" \
                | $MYSQL_CMD 2>/dev/null
        fi

        COUNT=$((COUNT + 1))
    else
        log "ERROR fetching $url"
        ERRORS=$((ERRORS + 1))
    fi

    # Rate limit: 5 seconds between fetches (be polite)
    sleep 5
done <<< "$PENDING"

# ============================================================
# Record session
# ============================================================

echo "INSERT INTO web_sessions (purpose, pages_visited, findings_stored, triggered_by, conclusion) VALUES ('Periodic monitoring check', $COUNT, $COUNT, 'monitoring', '$COUNT pages checked, $ERRORS errors');" \
    | $MYSQL_CMD 2>/dev/null

log "Monitor cycle complete: $COUNT checked, $ERRORS errors"
echo "Monitor cycle complete"
