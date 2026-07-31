#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# dave_ssl.sh — Dave's SSL/TLS Certificate & Key Intelligence
#
# Dave uses this to:
#   1. Fetch and store public keys for important HTTPS sites
#   2. Verify certificate chains and expiration
#   3. Monitor certificate changes (key rotation detection)
#   4. Understand TLS handshake parameters (cipher, protocol, key exchange)
#   5. Maintain a trust ledger of fiduciary-important site certificates
#
# This gives Dave the ability to hold a fiduciary position on site identity.
# If a site's public key changes unexpectedly, Dave knows — and can alert.
#
# Usage:
#   dave_ssl --fetch <hostname>           Fetch and store site certificate + public key
#   dave_ssl --verify <hostname>          Verify cert chain and expiration
#   dave_ssl --check-all                  Check all monitored site certificates
#   dave_ssl --renew-check <hostname>     Check if cert is near expiration
#   dave_ssl --key-exchange <hostname>    Show TLS handshake details
#   dave_ssl --diff <hostname>            Compare current cert to stored cert
#   dave_ssl --list                       List all stored site certificates
#   dave_ssl --status                     Show system status
#
# Requires: openssl, curl, mysql (dave_ai)
#
# Copyright (C) 2026 MEARVK LLC

set -e

CERT_DIR="/var/lib/kernel-ai/certificates"
MYSQL_CMD="mysql -u dave_ai --socket=/run/mysqld/mysqld.sock dave_kb"
CHAT="/usr/local/bin/chat"
LOG="/var/lib/kernel-ai/ssl_monitor.log"

# ============================================================
# Helpers
# ============================================================

die() { echo "ERROR: $*" >&2; exit 1; }

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG" 2>/dev/null || true
    echo "$*"
}

ensure_dirs() {
    mkdir -p "$CERT_DIR/certs" "$CERT_DIR/pubkeys" "$CERT_DIR/chains" 2>/dev/null || true
}

# ============================================================
# Fetch site certificate and public key
# ============================================================

fetch_cert() {
    local host="$1"
    local port="${2:-443}"

    ensure_dirs

    echo "[dave_ssl] Connecting to $host:$port..."

    # Fetch the full certificate chain
    local chain_file="$CERT_DIR/chains/${host}_chain.pem"
    local cert_file="$CERT_DIR/certs/${host}.pem"
    local pubkey_file="$CERT_DIR/pubkeys/${host}_pubkey.pem"
    local info_file="$CERT_DIR/certs/${host}_info.txt"

    # Get certificate(s) via openssl s_client
    echo | openssl s_client -connect "$host:$port" -servername "$host" \
        -showcerts 2>/dev/null > "$chain_file.tmp" || die "Connection failed to $host:$port"

    # Extract the server certificate (first one)
    openssl x509 -in "$chain_file.tmp" -out "$cert_file" 2>/dev/null || \
        die "Could not extract certificate"

    # Extract the full chain
    awk '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/' \
        "$chain_file.tmp" > "$chain_file"
    rm -f "$chain_file.tmp"

    # Extract public key
    openssl x509 -in "$cert_file" -pubkey -noout > "$pubkey_file" 2>/dev/null

    # Get certificate details
    {
        echo "=== Certificate Details: $host ==="
        echo "Fetched: $(date -Iseconds)"
        echo ""
        echo "--- Subject ---"
        openssl x509 -in "$cert_file" -noout -subject 2>/dev/null
        echo ""
        echo "--- Issuer ---"
        openssl x509 -in "$cert_file" -noout -issuer 2>/dev/null
        echo ""
        echo "--- Validity ---"
        openssl x509 -in "$cert_file" -noout -dates 2>/dev/null
        echo ""
        echo "--- Serial ---"
        openssl x509 -in "$cert_file" -noout -serial 2>/dev/null
        echo ""
        echo "--- Fingerprint (SHA-256) ---"
        openssl x509 -in "$cert_file" -noout -fingerprint -sha256 2>/dev/null
        echo ""
        echo "--- Public Key Info ---"
        openssl x509 -in "$cert_file" -noout -text 2>/dev/null | grep -A 4 "Public Key"
        echo ""
        echo "--- Subject Alternative Names ---"
        openssl x509 -in "$cert_file" -noout -text 2>/dev/null | grep -A 1 "Subject Alternative Name"
    } > "$info_file"

    # Compute hashes for change detection
    local pubkey_hash
    pubkey_hash=$(openssl x509 -in "$cert_file" -pubkey -noout 2>/dev/null | sha256sum | awk '{print $1}')

    local cert_hash
    cert_hash=$(openssl x509 -in "$cert_file" -outform DER 2>/dev/null | sha256sum | awk '{print $1}')

    # Get expiration
    local not_after
    not_after=$(openssl x509 -in "$cert_file" -noout -enddate 2>/dev/null | sed 's/notAfter=//')

    local not_before
    not_before=$(openssl x509 -in "$cert_file" -noout -startdate 2>/dev/null | sed 's/notBefore=//')

    # Get subject and issuer
    local subject
    subject=$(openssl x509 -in "$cert_file" -noout -subject 2>/dev/null | sed 's/subject=//')

    local issuer
    issuer=$(openssl x509 -in "$cert_file" -noout -issuer 2>/dev/null | sed 's/issuer=//')

    # Store in MySQL
    local esc_host esc_subject esc_issuer esc_pubkey_hash esc_cert_hash
    esc_host=$(echo "$host" | sed "s/'/''/g")
    esc_subject=$(echo "$subject" | sed "s/'/''/g")
    esc_issuer=$(echo "$issuer" | sed "s/'/''/g")

    echo "INSERT INTO ssl_certificates
        (hostname, port, subject, issuer, not_before, not_after,
         pubkey_hash, cert_hash, pubkey_path, cert_path, chain_path, fetched_at)
    VALUES
        ('$esc_host', $port, '$esc_subject', '$esc_issuer',
         STR_TO_DATE('$not_before', '%b %e %H:%i:%s %Y GMT'),
         STR_TO_DATE('$not_after', '%b %e %H:%i:%s %Y GMT'),
         '$pubkey_hash', '$cert_hash',
         '$pubkey_file', '$cert_file', '$chain_file', NOW())
    ON DUPLICATE KEY UPDATE
        subject = VALUES(subject),
        issuer = VALUES(issuer),
        not_before = VALUES(not_before),
        not_after = VALUES(not_after),
        pubkey_hash = VALUES(pubkey_hash),
        cert_hash = VALUES(cert_hash),
        fetched_at = NOW(),
        previous_pubkey_hash = pubkey_hash,
        check_count = check_count + 1;" | $MYSQL_CMD 2>/dev/null || true

    echo ""
    echo "[dave_ssl] ✓ Certificate fetched and stored for $host"
    echo ""
    echo "  Subject:     $subject"
    echo "  Issuer:      $issuer"
    echo "  Valid:       $not_before → $not_after"
    echo "  PubKey Hash: $pubkey_hash"
    echo "  Cert Hash:   $cert_hash"
    echo "  Files:"
    echo "    Certificate: $cert_file"
    echo "    Public Key:  $pubkey_file"
    echo "    Chain:       $chain_file"
    echo "    Details:     $info_file"
    echo ""

    log "Fetched cert for $host: pubkey_hash=$pubkey_hash expires=$not_after"
}

# ============================================================
# Verify certificate chain
# ============================================================

verify_cert() {
    local host="$1"
    local port="${2:-443}"

    echo "[dave_ssl] Verifying certificate chain for $host:$port..."
    echo ""

    # Live verification
    local result
    result=$(echo | openssl s_client -connect "$host:$port" -servername "$host" \
        -verify_return_error 2>&1)

    if echo "$result" | grep -q "Verify return code: 0"; then
        echo "  ✓ Certificate chain VALID"
    else
        local code
        code=$(echo "$result" | grep "Verify return code:" | head -1)
        echo "  ✗ Certificate chain INVALID"
        echo "    $code"
    fi

    # Show protocol and cipher
    local protocol cipher
    protocol=$(echo "$result" | grep "Protocol" | head -1 | awk '{print $NF}')
    cipher=$(echo "$result" | grep "Cipher" | head -1 | awk '{print $NF}')

    echo "  Protocol:    $protocol"
    echo "  Cipher:      $cipher"
    echo ""
}

# ============================================================
# Show TLS handshake / key exchange details
# ============================================================

key_exchange_info() {
    local host="$1"
    local port="${2:-443}"

    echo ""
    echo "╔══════════════════════════════════════════════════╗"
    echo "║  TLS Handshake Details: $host"
    echo "╚══════════════════════════════════════════════════╝"
    echo ""

    local result
    result=$(echo | openssl s_client -connect "$host:$port" -servername "$host" \
        -status -tlsextdebug 2>&1)

    # Protocol version
    echo "  Protocol:      $(echo "$result" | grep "Protocol  :" | awk -F': ' '{print $2}')"

    # Cipher suite
    echo "  Cipher Suite:  $(echo "$result" | grep "Cipher    :" | awk -F': ' '{print $2}')"

    # Key exchange
    local kex
    kex=$(echo "$result" | grep -i "Server Temp Key" | head -1)
    if [ -n "$kex" ]; then
        echo "  Key Exchange:  $(echo "$kex" | sed 's/.*Server Temp Key: //')"
    fi

    # Certificate key size
    local keysize
    keysize=$(echo "$result" | grep "Server public key" | head -1)
    [ -n "$keysize" ] && echo "  Server Key:    $(echo "$keysize" | sed 's/Server public key is //')"

    # Session info
    echo ""
    echo "  --- Session ---"
    echo "$result" | grep -E "Session-ID:|Master-Key:|TLS session ticket" | \
        sed 's/^/  /' | head -5

    # OCSP stapling
    echo ""
    if echo "$result" | grep -q "OCSP Response Status: successful"; then
        echo "  OCSP Stapling: ✓ Present (certificate status confirmed)"
    else
        echo "  OCSP Stapling: Not present"
    fi

    # Certificate expiry warning
    local not_after
    not_after=$(echo | openssl s_client -connect "$host:$port" -servername "$host" 2>/dev/null | \
        openssl x509 -noout -enddate 2>/dev/null | sed 's/notAfter=//')
    if [ -n "$not_after" ]; then
        local exp_epoch now_epoch days_left
        exp_epoch=$(date -d "$not_after" +%s 2>/dev/null || echo 0)
        now_epoch=$(date +%s)
        if [ "$exp_epoch" -gt 0 ]; then
            days_left=$(( (exp_epoch - now_epoch) / 86400 ))
            echo ""
            if [ "$days_left" -lt 14 ]; then
                echo "  ⚠ EXPIRATION WARNING: Certificate expires in $days_left days!"
            elif [ "$days_left" -lt 30 ]; then
                echo "  ⚡ Certificate expires in $days_left days (renewal recommended)"
            else
                echo "  Certificate valid for $days_left more days"
            fi
        fi
    fi

    echo ""
}

# ============================================================
# Check for certificate/key changes (fiduciary hold)
# ============================================================

diff_cert() {
    local host="$1"

    echo "[dave_ssl] Comparing current certificate for $host against stored..."

    # Get stored hash
    local stored_hash
    stored_hash=$(echo "SELECT pubkey_hash FROM ssl_certificates WHERE hostname = '$host' ORDER BY fetched_at DESC LIMIT 1;" | $MYSQL_CMD -N 2>/dev/null)

    if [ -z "$stored_hash" ]; then
        echo "  No stored certificate for $host. Fetching now..."
        fetch_cert "$host"
        return
    fi

    # Get current hash
    local current_hash
    current_hash=$(echo | openssl s_client -connect "$host:443" -servername "$host" 2>/dev/null | \
        openssl x509 -pubkey -noout 2>/dev/null | sha256sum | awk '{print $1}')

    echo ""
    if [ "$stored_hash" = "$current_hash" ]; then
        echo "  ✓ Public key UNCHANGED"
        echo "    Stored:  $stored_hash"
        echo "    Current: $current_hash"
        echo "    Fiduciary hold: INTACT"
    else
        echo "  ⚠ PUBLIC KEY CHANGED!"
        echo "    Stored:  $stored_hash"
        echo "    Current: $current_hash"
        echo "    Fiduciary hold: BROKEN — key rotation or compromise"
        echo ""
        echo "  Action: Re-fetch to update stored key and investigate."

        # Alert via chat
        if [ -x "$CHAT" ]; then
            $CHAT post admin-alerts "[DAVE] ⚠ SSL key change detected for $host. Previous pubkey_hash=$stored_hash → new=$current_hash. Investigate." 2>/dev/null || true
        fi

        # Update MySQL
        echo "UPDATE ssl_certificates SET key_changed = TRUE, key_change_detected_at = NOW() WHERE hostname = '$host' AND pubkey_hash = '$stored_hash';" | $MYSQL_CMD 2>/dev/null || true

        log "KEY CHANGE DETECTED: $host old=$stored_hash new=$current_hash"
    fi
    echo ""
}

# ============================================================
# Check all monitored sites
# ============================================================

check_all() {
    echo ""
    echo "[dave_ssl] Checking all monitored certificates..."
    echo ""

    local sites
    sites=$(echo "SELECT hostname FROM ssl_certificates WHERE monitor_enabled = TRUE GROUP BY hostname;" | $MYSQL_CMD -N 2>/dev/null)

    if [ -z "$sites" ]; then
        echo "  No monitored sites. Use 'dave_ssl --fetch <host>' to add sites."
        return
    fi

    local count=0
    local changes=0

    while IFS= read -r host; do
        [ -z "$host" ] && continue
        printf "  %-40s " "$host"

        local stored current
        stored=$(echo "SELECT pubkey_hash FROM ssl_certificates WHERE hostname = '$host' ORDER BY fetched_at DESC LIMIT 1;" | $MYSQL_CMD -N 2>/dev/null)
        current=$(echo | openssl s_client -connect "$host:443" -servername "$host" 2>/dev/null | \
            openssl x509 -pubkey -noout 2>/dev/null | sha256sum | awk '{print $1}')

        if [ "$stored" = "$current" ]; then
            echo "✓ key intact"
        elif [ -z "$current" ]; then
            echo "✗ unreachable"
        else
            echo "⚠ KEY CHANGED"
            changes=$((changes + 1))
        fi

        count=$((count + 1))
        sleep 1  # Rate limit
    done <<< "$sites"

    echo ""
    echo "  Checked: $count sites | Changes: $changes"
    [ "$changes" -gt 0 ] && echo "  ⚠ Run 'dave_ssl --diff <host>' for details on changed keys"
    echo ""
}

# ============================================================
# Renewal check
# ============================================================

renew_check() {
    local host="$1"
    local port="${2:-443}"

    local not_after
    not_after=$(echo | openssl s_client -connect "$host:$port" -servername "$host" 2>/dev/null | \
        openssl x509 -noout -enddate 2>/dev/null | sed 's/notAfter=//')

    if [ -z "$not_after" ]; then
        die "Could not fetch certificate for $host"
    fi

    local exp_epoch now_epoch days_left
    exp_epoch=$(date -d "$not_after" +%s 2>/dev/null || echo 0)
    now_epoch=$(date +%s)
    days_left=$(( (exp_epoch - now_epoch) / 86400 ))

    echo ""
    echo "  Certificate for $host:"
    echo "  Expires:    $not_after"
    echo "  Days left:  $days_left"
    echo ""

    if [ "$days_left" -lt 7 ]; then
        echo "  ⚠ CRITICAL: Certificate expires in $days_left days!"
        echo "  Immediate renewal required."
    elif [ "$days_left" -lt 14 ]; then
        echo "  ⚠ WARNING: Certificate expires in $days_left days."
        echo "  Renewal should be initiated now."
    elif [ "$days_left" -lt 30 ]; then
        echo "  ⚡ NOTICE: Certificate expires in $days_left days."
        echo "  Plan renewal within the next 2 weeks."
    else
        echo "  ✓ Certificate is healthy ($days_left days remaining)."
    fi
    echo ""
}

# ============================================================
# List stored certificates
# ============================================================

list_certs() {
    echo ""
    echo "  Stored SSL Certificates (Fiduciary Ledger)"
    echo "  ══════════════════════════════════════════════════════════════════"
    printf "  %-30s %-20s %-12s %-8s %s\n" "Hostname" "Expires" "Days Left" "Checks" "Key Changed"
    printf "  %-30s %-20s %-12s %-8s %s\n" "──────────────────────────────" "────────────────────" "────────────" "────────" "───────────"

    echo "SELECT hostname,
            DATE_FORMAT(not_after, '%Y-%m-%d') AS expires,
            DATEDIFF(not_after, NOW()) AS days_left,
            check_count,
            CASE WHEN key_changed THEN '⚠ YES' ELSE '✓ no' END AS changed
          FROM ssl_certificates
          GROUP BY hostname
          HAVING fetched_at = MAX(fetched_at)
          ORDER BY days_left ASC;" | $MYSQL_CMD -N 2>/dev/null | \
        while IFS=$'\t' read -r host expires days checks changed; do
            printf "  %-30s %-20s %-12s %-8s %s\n" "$host" "$expires" "$days" "$checks" "$changed"
        done

    echo ""
}

# ============================================================
# Status
# ============================================================

show_status() {
    echo ""
    echo "╔══════════════════════════════════════════════════╗"
    echo "║  Dave SSL/TLS Certificate Intelligence          ║"
    echo "╚══════════════════════════════════════════════════╝"
    echo ""
    echo "  OpenSSL:       $(openssl version 2>/dev/null || echo 'NOT FOUND')"
    echo "  Cert store:    $CERT_DIR"
    echo ""

    if [ -d "$CERT_DIR/certs" ]; then
        local cert_count
        cert_count=$(find "$CERT_DIR/certs" -name "*.pem" 2>/dev/null | wc -l)
        echo "  Stored certs:  $cert_count"
    else
        echo "  Stored certs:  (directory not created)"
    fi

    # MySQL check
    local db_count
    db_count=$(echo "SELECT COUNT(DISTINCT hostname) FROM ssl_certificates;" | $MYSQL_CMD -N 2>/dev/null || echo "N/A")
    echo "  DB records:    $db_count unique hosts"
    echo ""
}

# ============================================================
# Usage
# ============================================================

usage() {
    echo ""
    echo "Dave SSL/TLS Certificate & Key Intelligence"
    echo ""
    echo "Usage:"
    echo "  dave_ssl --fetch <hostname>       Fetch & store certificate + public key"
    echo "  dave_ssl --verify <hostname>      Verify certificate chain"
    echo "  dave_ssl --key-exchange <host>    Show full TLS handshake details"
    echo "  dave_ssl --diff <hostname>        Compare current key to stored (fiduciary check)"
    echo "  dave_ssl --check-all              Check all monitored site certificates"
    echo "  dave_ssl --renew-check <host>     Check if cert needs renewal"
    echo "  dave_ssl --list                   List stored certificates"
    echo "  dave_ssl --status                 Show system status"
    echo ""
    echo "Fiduciary Hold:"
    echo "  Dave fetches and stores public keys for important sites."
    echo "  If a key changes unexpectedly, Dave detects it and alerts."
    echo "  This gives Dave a cryptographic hold on site identity."
    echo ""
}

# ============================================================
# Main
# ============================================================

case "${1:-}" in
    --fetch)
        [ -z "${2:-}" ] && die "Usage: dave_ssl --fetch <hostname>"
        fetch_cert "$2" "${3:-443}"
        ;;
    --verify)
        [ -z "${2:-}" ] && die "Usage: dave_ssl --verify <hostname>"
        verify_cert "$2" "${3:-443}"
        ;;
    --key-exchange|--kex)
        [ -z "${2:-}" ] && die "Usage: dave_ssl --key-exchange <hostname>"
        key_exchange_info "$2" "${3:-443}"
        ;;
    --diff)
        [ -z "${2:-}" ] && die "Usage: dave_ssl --diff <hostname>"
        diff_cert "$2"
        ;;
    --check-all)
        check_all
        ;;
    --renew-check|--renew)
        [ -z "${2:-}" ] && die "Usage: dave_ssl --renew-check <hostname>"
        renew_check "$2" "${3:-443}"
        ;;
    --list)
        list_certs
        ;;
    --status)
        show_status
        ;;
    --help|-h|"")
        usage
        ;;
    *)
        die "Unknown command: $1 (try --help)"
        ;;
esac
