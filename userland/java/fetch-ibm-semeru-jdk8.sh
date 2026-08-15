#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# fetch-ibm-semeru-jdk8.sh - Fetch IBM Semeru Runtime Open Edition JDK 8
#
# Downloads the IBM Semeru Runtime (OpenJ9-based JDK 8) for Linux x64.
# Verifies download integrity via SHA256 checksum and GPG signature.
# Supports partial download resume via curl -C (continue-at).
#
# Source: https://github.com/ibmruntimes/semeru8-binaries
# License: GPLv2 with Classpath Exception
# JVM: Eclipse OpenJ9
#
# Copyright (C) 2026 MEARVK LLC

set -euo pipefail

# ═══════════════════════════════════════════════════════════════════════════════
# Configuration
# ═══════════════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TARGET_DIR="$REPO_ROOT/userland/semeru-openjdk-8"
TEMP_DIR="$TARGET_DIR/.download"

# IBM Semeru Runtime API (Adoptium-compatible)
API_BASE="https://ibm.com/semeru-runtimes/api/v3"
GITHUB_BASE="https://github.com/ibmruntimes/semeru8-binaries/releases"

# Target platform
JAVA_VERSION="8"
OS="linux"
ARCH="x64"
IMAGE_TYPE="jdk"
JVM_IMPL="openj9"
HEAP_SIZE="normal"

# Retry configuration
MAX_RETRIES=3
RETRY_DELAY=5

# ═══════════════════════════════════════════════════════════════════════════════
# Functions
# ═══════════════════════════════════════════════════════════════════════════════

log_step() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  STEP: $1"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

log_ok() {
    echo "  ✓ $1"
}

log_warn() {
    echo "  ⚠ $1"
}

log_fail() {
    echo "  ✗ $1"
}

log_info() {
    echo "  → $1"
}

die() {
    log_fail "$1"
    exit 1
}

# Check if a command exists
require_cmd() {
    if ! command -v "$1" &>/dev/null; then
        die "Required command not found: $1 — install it and retry."
    fi
    log_ok "Found: $1 ($(command -v "$1"))"
}

# Get remote file size via HTTP HEAD request (returns bytes or "unknown")
get_remote_size() {
    local url="$1"
    local size
    size=$(curl -sI -L "$url" | grep -i "^content-length:" | tail -1 | awk '{print $2}' | tr -d '\r')
    if [ -n "$size" ] && [ "$size" -gt 0 ] 2>/dev/null; then
        echo "$size"
    else
        echo "unknown"
    fi
}

# Get local file size (returns 0 if file doesn't exist)
get_local_size() {
    local file="$1"
    if [ -f "$file" ]; then
        stat --printf="%s" "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null || echo "0"
    else
        echo "0"
    fi
}

# Human-readable file size
human_size() {
    local bytes="$1"
    if [ "$bytes" = "unknown" ]; then
        echo "unknown"
        return
    fi
    if [ "$bytes" -ge 1073741824 ]; then
        echo "$(echo "scale=2; $bytes / 1073741824" | bc) GB"
    elif [ "$bytes" -ge 1048576 ]; then
        echo "$(echo "scale=1; $bytes / 1048576" | bc) MB"
    elif [ "$bytes" -ge 1024 ]; then
        echo "$(echo "scale=1; $bytes / 1024" | bc) KB"
    else
        echo "$bytes bytes"
    fi
}

# Download with resume support
download_with_resume() {
    local url="$1"
    local output="$2"
    local description="$3"
    local attempt=1

    while [ $attempt -le $MAX_RETRIES ]; do
        local local_size
        local_size=$(get_local_size "$output")

        if [ "$local_size" -gt 0 ]; then
            log_info "Resuming download from byte $local_size ($(human_size "$local_size") already downloaded)"
            # Use -C - to auto-resume from where we left off
            if curl -L -C - -o "$output" --progress-bar --fail \
                    --connect-timeout 30 --max-time 1800 "$url"; then
                log_ok "$description download complete"
                return 0
            fi
        else
            log_info "Starting fresh download: $description"
            if curl -L -o "$output" --progress-bar --fail \
                    --connect-timeout 30 --max-time 1800 "$url"; then
                log_ok "$description download complete"
                return 0
            fi
        fi

        # Download failed
        if [ $attempt -lt $MAX_RETRIES ]; then
            log_warn "Attempt $attempt/$MAX_RETRIES failed. Retrying in ${RETRY_DELAY}s..."
            sleep $RETRY_DELAY
        else
            log_fail "All $MAX_RETRIES attempts failed for: $description"
            return 1
        fi
        attempt=$((attempt + 1))
    done
    return 1
}

# ═══════════════════════════════════════════════════════════════════════════════
# Pre-flight checks
# ═══════════════════════════════════════════════════════════════════════════════

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  IBM Semeru Runtime Open Edition — JDK 8 Fetch              ║"
echo "║  Platform: Linux x86_64 | JVM: Eclipse OpenJ9              ║"
echo "║  License: GPLv2 + Classpath Exception                       ║"
echo "╚══════════════════════════════════════════════════════════════╝"

log_step "Pre-flight: Checking required tools"

require_cmd curl
require_cmd tar
require_cmd sha256sum
require_cmd jq
require_cmd grep
require_cmd awk

# Optional: GPG for signature verification
HAS_GPG=0
if command -v gpg &>/dev/null; then
    log_ok "Found: gpg (signature verification available)"
    HAS_GPG=1
else
    log_warn "gpg not found — signature verification will be skipped"
fi

# Optional: bc for human-readable sizes
if ! command -v bc &>/dev/null; then
    log_warn "bc not found — file sizes shown in bytes only"
    human_size() { echo "$1 bytes"; }
fi

log_step "Pre-flight: Checking disk space"

AVAILABLE_KB=$(df --output=avail "$SCRIPT_DIR" 2>/dev/null | tail -1 | tr -d ' ')
if [ -n "$AVAILABLE_KB" ] && [ "$AVAILABLE_KB" -lt 524288 ]; then
    die "Insufficient disk space. Need at least 512 MB free, have $(human_size $((AVAILABLE_KB * 1024)))."
fi
log_ok "Disk space: $(human_size $((AVAILABLE_KB * 1024))) available"

log_step "Pre-flight: Checking network connectivity"

if ! curl -sI --connect-timeout 10 "https://github.com" >/dev/null 2>&1; then
    die "Cannot reach github.com — check network connectivity."
fi
log_ok "Network: github.com reachable"

if ! curl -sI --connect-timeout 10 "https://ibm.com" >/dev/null 2>&1; then
    log_warn "Cannot reach ibm.com API — will use GitHub releases directly"
fi

log_step "Pre-flight: Checking for existing installation"

if [ -d "$TARGET_DIR" ] && [ -f "$TARGET_DIR/SEMERU_SOURCE_INFO" ]; then
    log_warn "IBM Semeru JDK 8 already exists at: $TARGET_DIR"
    if [ -f "$TARGET_DIR/bin/java" ]; then
        EXISTING_VERSION=$("$TARGET_DIR/bin/java" -version 2>&1 | head -1 || echo "unknown")
        log_info "Existing version: $EXISTING_VERSION"
    fi
    echo ""
    read -rp "  Re-download and replace? [y/N] " REPLY
    if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
        echo "  Aborted. Existing installation left untouched."
        exit 0
    fi
    log_info "Will replace existing installation after successful download."
fi

# ═══════════════════════════════════════════════════════════════════════════════
# Resolve latest JDK 8 release URL
# ═══════════════════════════════════════════════════════════════════════════════

log_step "Resolving latest IBM Semeru JDK 8 release"

# Try the IBM Adoptium-compatible API first
RELEASE_INFO=""
DOWNLOAD_URL=""
CHECKSUM_URL=""
SIGNATURE_URL=""
RELEASE_NAME=""
EXPECTED_SHA256=""

log_info "Querying IBM Semeru API for latest JDK 8 (Linux x64)..."

API_URL="${API_BASE}/assets/latest/${JAVA_VERSION}/hotspot?architecture=${ARCH}&image_type=${IMAGE_TYPE}&os=${OS}&vendor=ibm"
# The API endpoint format for Semeru uses the adoptium-compatible path:
API_URL="https://ibm.com/semeru-runtimes/api/v3/assets/latest/8/openj9?architecture=x64&image_type=jdk&os=linux"

RELEASE_INFO=$(curl -sL --connect-timeout 15 "$API_URL" 2>/dev/null || echo "")

if [ -n "$RELEASE_INFO" ] && echo "$RELEASE_INFO" | jq -e '.[0].binaries[0].package.link' &>/dev/null; then
    DOWNLOAD_URL=$(echo "$RELEASE_INFO" | jq -r '.[0].binaries[0].package.link')
    CHECKSUM_URL=$(echo "$RELEASE_INFO" | jq -r '.[0].binaries[0].package.checksum_link // empty')
    EXPECTED_SHA256=$(echo "$RELEASE_INFO" | jq -r '.[0].binaries[0].package.checksum // empty')
    RELEASE_NAME=$(echo "$RELEASE_INFO" | jq -r '.[0].release_name // "unknown"')
    SIGNATURE_URL=$(echo "$RELEASE_INFO" | jq -r '.[0].binaries[0].package.signature_link // empty')
    log_ok "API resolved: $RELEASE_NAME"
else
    # Fallback: query GitHub releases API directly
    log_warn "IBM API unavailable, falling back to GitHub releases..."

    GH_API="https://api.github.com/repos/ibmruntimes/semeru8-binaries/releases/latest"
    GH_RELEASE=$(curl -sL --connect-timeout 15 "$GH_API" 2>/dev/null || echo "")

    if [ -z "$GH_RELEASE" ] || ! echo "$GH_RELEASE" | jq -e '.assets' &>/dev/null; then
        # Try listing releases (latest tag might not be marked "latest")
        GH_API="https://api.github.com/repos/ibmruntimes/semeru8-binaries/releases?per_page=5"
        GH_RELEASE=$(curl -sL --connect-timeout 15 "$GH_API" 2>/dev/null || echo "")

        if [ -z "$GH_RELEASE" ] || ! echo "$GH_RELEASE" | jq -e '.[0].assets' &>/dev/null; then
            die "Cannot resolve download URL from GitHub API. Rate-limited or network issue."
        fi

        # Find the first release that has our target asset
        DOWNLOAD_URL=$(echo "$GH_RELEASE" | jq -r '
            [.[].assets[] |
             select(.name | test("jdk_x64_linux.*\\.tar\\.gz$")) |
             select(.name | test("\\.sig$") | not)
            ][0].browser_download_url // empty')
        RELEASE_NAME=$(echo "$GH_RELEASE" | jq -r '.[0].tag_name // "unknown"')
    else
        DOWNLOAD_URL=$(echo "$GH_RELEASE" | jq -r '
            [.assets[] |
             select(.name | test("jdk_x64_linux.*\\.tar\\.gz$")) |
             select(.name | test("\\.sig$") | not)
            ][0].browser_download_url // empty')
        RELEASE_NAME=$(echo "$GH_RELEASE" | jq -r '.tag_name // "unknown"')
    fi

    if [ -z "$DOWNLOAD_URL" ]; then
        die "Could not find Linux x64 JDK tar.gz in GitHub releases."
    fi

    # Derive checksum and signature URLs from download URL
    CHECKSUM_URL="${DOWNLOAD_URL}.sha256.txt"
    SIGNATURE_URL="${DOWNLOAD_URL}.sig"

    log_ok "GitHub resolved: $RELEASE_NAME"
fi

FILENAME=$(basename "$DOWNLOAD_URL")
log_info "Package: $FILENAME"
log_info "URL: $DOWNLOAD_URL"

# ═══════════════════════════════════════════════════════════════════════════════
# Check for partial downloads
# ═══════════════════════════════════════════════════════════════════════════════

log_step "Checking for partial downloads"

mkdir -p "$TEMP_DIR"
DOWNLOAD_FILE="$TEMP_DIR/$FILENAME"

REMOTE_SIZE=$(get_remote_size "$DOWNLOAD_URL")
LOCAL_SIZE=$(get_local_size "$DOWNLOAD_FILE")

log_info "Remote file size: $(human_size "$REMOTE_SIZE")"

if [ "$LOCAL_SIZE" -gt 0 ]; then
    log_info "Partial download found: $(human_size "$LOCAL_SIZE") of $(human_size "$REMOTE_SIZE")"

    if [ "$REMOTE_SIZE" != "unknown" ] && [ "$LOCAL_SIZE" -ge "$REMOTE_SIZE" ]; then
        log_ok "File already fully downloaded ($FILENAME)"
        log_info "Skipping download, proceeding to verification..."
    else
        if [ "$REMOTE_SIZE" != "unknown" ]; then
            PERCENT=$((LOCAL_SIZE * 100 / REMOTE_SIZE))
            log_info "Progress: ${PERCENT}% — will resume from byte $LOCAL_SIZE"
        else
            log_info "Will attempt resume from byte $LOCAL_SIZE"
        fi
    fi
else
    log_info "No partial download found. Starting fresh."
fi

# ═══════════════════════════════════════════════════════════════════════════════
# Download
# ═══════════════════════════════════════════════════════════════════════════════

log_step "Downloading IBM Semeru JDK 8"

# Only download if file is not already complete
NEEDS_DOWNLOAD=1
if [ "$LOCAL_SIZE" -gt 0 ] && [ "$REMOTE_SIZE" != "unknown" ] && [ "$LOCAL_SIZE" -ge "$REMOTE_SIZE" ]; then
    NEEDS_DOWNLOAD=0
fi

if [ "$NEEDS_DOWNLOAD" -eq 1 ]; then
    download_with_resume "$DOWNLOAD_URL" "$DOWNLOAD_FILE" "JDK tarball" || \
        die "Download failed after $MAX_RETRIES attempts."
fi

# Download checksum file
CHECKSUM_FILE="$TEMP_DIR/${FILENAME}.sha256.txt"
if [ -n "$CHECKSUM_URL" ]; then
    log_info "Fetching SHA256 checksum..."
    curl -sL -o "$CHECKSUM_FILE" "$CHECKSUM_URL" 2>/dev/null || true
fi

# Download signature file
SIGNATURE_FILE="$TEMP_DIR/${FILENAME}.sig"
if [ -n "$SIGNATURE_URL" ] && [ "$HAS_GPG" -eq 1 ]; then
    log_info "Fetching GPG signature..."
    curl -sL -o "$SIGNATURE_FILE" "$SIGNATURE_URL" 2>/dev/null || true
fi

# ═══════════════════════════════════════════════════════════════════════════════
# Verify integrity
# ═══════════════════════════════════════════════════════════════════════════════

log_step "Verifying download integrity"

# SHA256 verification
VERIFIED_SHA=0
ACTUAL_SHA256=$(sha256sum "$DOWNLOAD_FILE" | awk '{print $1}')
log_info "Computed SHA256: $ACTUAL_SHA256"

if [ -n "$EXPECTED_SHA256" ]; then
    # We got checksum from API
    if [ "$ACTUAL_SHA256" = "$EXPECTED_SHA256" ]; then
        log_ok "SHA256 matches (API-provided checksum)"
        VERIFIED_SHA=1
    else
        die "SHA256 MISMATCH! Expected: $EXPECTED_SHA256 Got: $ACTUAL_SHA256 — file may be corrupted or tampered."
    fi
elif [ -f "$CHECKSUM_FILE" ] && [ -s "$CHECKSUM_FILE" ]; then
    # Parse checksum file (format varies: could be just hash, or "hash  filename")
    FILE_SHA256=$(grep -oP '[a-f0-9]{64}' "$CHECKSUM_FILE" | head -1)
    if [ -n "$FILE_SHA256" ]; then
        if [ "$ACTUAL_SHA256" = "$FILE_SHA256" ]; then
            log_ok "SHA256 matches (checksum file)"
            VERIFIED_SHA=1
        else
            die "SHA256 MISMATCH! Expected: $FILE_SHA256 Got: $ACTUAL_SHA256 — file may be corrupted or tampered."
        fi
    else
        log_warn "Could not parse checksum file — skipping SHA256 verification"
    fi
else
    log_warn "No checksum available — SHA256 verification skipped"
    log_info "Recorded SHA256 for reference: $ACTUAL_SHA256"
fi

# GPG signature verification
if [ "$HAS_GPG" -eq 1 ] && [ -f "$SIGNATURE_FILE" ] && [ -s "$SIGNATURE_FILE" ]; then
    log_info "Verifying GPG signature..."
    # Import IBM Semeru signing key if not already present
    IBM_KEY_URL="https://github.com/ibmruntimes/semeru8-binaries/raw/master/public_key.gpg"
    curl -sL "$IBM_KEY_URL" | gpg --import 2>/dev/null || true

    if gpg --verify "$SIGNATURE_FILE" "$DOWNLOAD_FILE" 2>/dev/null; then
        log_ok "GPG signature verified"
    else
        log_warn "GPG signature verification failed (key may not be imported)"
        log_info "This does not necessarily indicate tampering if the signing key is unavailable."
    fi
else
    log_info "GPG signature verification skipped (no signature or no gpg)"
fi

# Basic sanity: check it's actually a gzip file
if ! file "$DOWNLOAD_FILE" | grep -q "gzip\|tar"; then
    # Check magic bytes manually
    MAGIC=$(xxd -l 2 -p "$DOWNLOAD_FILE" 2>/dev/null || od -A n -t x1 -N 2 "$DOWNLOAD_FILE" | tr -d ' ')
    if [ "$MAGIC" != "1f8b" ]; then
        die "Downloaded file does not appear to be a gzip archive (magic: $MAGIC). Corrupted download?"
    fi
fi
log_ok "File format: valid gzip archive"

# ═══════════════════════════════════════════════════════════════════════════════
# Extract
# ═══════════════════════════════════════════════════════════════════════════════

log_step "Extracting JDK"

# If target exists from a previous install, back it up
if [ -d "$TARGET_DIR" ] && [ -f "$TARGET_DIR/bin/java" ]; then
    BACKUP_DIR="${TARGET_DIR}.bak.$(date +%s)"
    log_info "Backing up existing installation to: $(basename "$BACKUP_DIR")"
    mv "$TARGET_DIR" "$BACKUP_DIR"
    mkdir -p "$TARGET_DIR"
fi

mkdir -p "$TARGET_DIR"

# Extract — IBM Semeru tarballs typically have a top-level directory like jdk8u*/
# We strip one component to flatten into our target directory.
log_info "Extracting to: $TARGET_DIR"
tar -xzf "$DOWNLOAD_FILE" -C "$TARGET_DIR" --strip-components=1

if [ ! -f "$TARGET_DIR/bin/java" ]; then
    # Extraction may have produced a nested dir — check
    NESTED=$(find "$TARGET_DIR" -maxdepth 2 -name "java" -path "*/bin/java" | head -1)
    if [ -n "$NESTED" ]; then
        NESTED_DIR=$(dirname "$(dirname "$NESTED")")
        log_info "Flattening nested directory: $(basename "$NESTED_DIR")"
        mv "$NESTED_DIR"/* "$TARGET_DIR/" 2>/dev/null || true
        rmdir "$NESTED_DIR" 2>/dev/null || true
    else
        die "Extraction succeeded but bin/java not found. Archive structure unexpected."
    fi
fi

log_ok "Extraction complete"

# ═══════════════════════════════════════════════════════════════════════════════
# Write provenance marker
# ═══════════════════════════════════════════════════════════════════════════════

log_step "Writing provenance marker"

JAVA_VERSION_STRING=$("$TARGET_DIR/bin/java" -version 2>&1 | head -3 || echo "unknown")

cat > "$TARGET_DIR/SEMERU_SOURCE_INFO" << EOF
IBM Semeru Runtime Open Edition — JDK 8
========================================
Repository: https://github.com/ibmruntimes/semeru8-binaries
Release: $RELEASE_NAME
Package: $FILENAME
License: GPLv2 with Classpath Exception
JVM: Eclipse OpenJ9
Platform: Linux x86_64
Fetched: $(date -u '+%Y-%m-%d %H:%M:%S UTC')
SHA256: $ACTUAL_SHA256
Verified: $([ "$VERIFIED_SHA" -eq 1 ] && echo "YES (SHA256 match)" || echo "NOT VERIFIED (no reference checksum)")

Version Output:
$JAVA_VERSION_STRING

This JDK is the IBM Semeru Runtime (Open Edition), which pairs
the OpenJDK class libraries with the Eclipse OpenJ9 JVM.
OpenJ9 provides excellent memory footprint and fast startup.

Distribution: Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
EOF

log_ok "Provenance written: $TARGET_DIR/SEMERU_SOURCE_INFO"

# ═══════════════════════════════════════════════════════════════════════════════
# Cleanup
# ═══════════════════════════════════════════════════════════════════════════════

log_step "Cleanup"

# Remove download temp files
if [ -d "$TEMP_DIR" ]; then
    log_info "Removing temp download files..."
    rm -rf "$TEMP_DIR"
    log_ok "Temp files removed"
fi

# Remove old backup if everything succeeded
if [ -n "${BACKUP_DIR:-}" ] && [ -d "${BACKUP_DIR:-}" ]; then
    log_info "Removing old backup: $(basename "$BACKUP_DIR")"
    rm -rf "$BACKUP_DIR"
    log_ok "Old backup removed"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# Summary
# ═══════════════════════════════════════════════════════════════════════════════

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  IBM Semeru JDK 8 — Installation Complete                   ║"
echo "╠══════════════════════════════════════════════════════════════╣"
echo "║                                                              ║"
printf "║  Location: %-47s ║\n" "$TARGET_DIR"
printf "║  Release:  %-47s ║\n" "$RELEASE_NAME"
printf "║  SHA256:   %-47s ║\n" "${ACTUAL_SHA256:0:47}"

INSTALLED_SIZE=$(du -sh "$TARGET_DIR" 2>/dev/null | cut -f1)
printf "║  Size:     %-47s ║\n" "$INSTALLED_SIZE"
echo "║                                                              ║"
echo "║  Usage:                                                      ║"
echo "║    export JAVA_HOME=$TARGET_DIR"
echo "║    export PATH=\$JAVA_HOME/bin:\$PATH                        ║"
echo "║    java -version                                             ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "$JAVA_VERSION_STRING"
echo ""
echo "Done."
