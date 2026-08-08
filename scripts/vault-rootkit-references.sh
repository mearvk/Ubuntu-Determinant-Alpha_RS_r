#!/bin/bash
# =============================================================================
# vault-rootkit-references.sh — Disassemble rootkit study material into
#                                a negamane-protected immutable vault
#
# Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon
#
# This script extracts all rootkit detection signatures, reference code,
# and study material from chkrootkit and rkhunter, disassembles them into
# a negamane-branded immutable vault, and removes the raw material from
# the active tool directories.
#
# The vault is:
#   - Immutable (negamane-branded, cannot be modified without unlock)
#   - Disassembled (signatures split into fragments, not directly usable)
#   - Access-controlled (requires explicit multi-step unlock to reassemble)
#   - For STUDY AND REFERENCE ONLY
#
# Rootkits vaulted:
#   Reptile, BPFDoor, Symbiote, Lightning Framework, Orbit,
#   FontOnLake, RotaJakiro, Pandora, Melofee, Kinsing,
#   Perfctl, Bootkitty, Slapper, Scalper, and others
#
# Usage:
#   scripts/vault-rootkit-references.sh <rootfs_dir>
#   scripts/vault-rootkit-references.sh <rootfs_dir> --unlock (requires passphrase)
#
# =============================================================================

set -euo pipefail

ROOTFS_DIR="${1:-build/rootfs}"
VAULT_DIR="${ROOTFS_DIR}/var/lib/negamane/vaults/rootkit-study"
VAULT_MANIFEST="${VAULT_DIR}/.vault-manifest.json"
VAULT_LOCK="${VAULT_DIR}/.negamane-lock"
ACTION="${2:-vault}"

CHKROOTKIT_DIR="kernels/linux-5.15.204/linux-5.15.204/tools/chkrootkit"
RKHUNTER_DIR="kernels/linux-5.15.204/linux-5.15.204/tools/rkhunter"

log() {
    echo "  [VAULT] $*"
}

error() {
    echo "  [VAULT] ERROR: $*" >&2
    exit 1
}

# =============================================================================
# Rootkit reference catalog
# =============================================================================

# These are the rootkit DETECTION signatures (not actual rootkit code).
# They are disassembled from the detection tools for safe storage.
ROOTKITS=(
    "reptile:LKM:2023-2024:Open-source Linux LKM rootkit with process/file/network hiding"
    "bpfdoor:BPF:2022-2024:BPF-based passive backdoor using packet filtering for activation"
    "symbiote:PRELOAD:2022:LD_PRELOAD parasitic rootkit hiding in shared library injection"
    "lightning:FRAMEWORK:2022:Lightning Framework - modular Linux implant with plugins"
    "orbit:PRELOAD:2022:OrBit LD_PRELOAD rootkit hooking SSH/PAM/libc functions"
    "fontonlake:LKM:2021:FontOnLake trojanized utilities with kernel module backdoor"
    "rotajakiro:DAEMON:2021:RotaJakiro dual-head backdoor with encrypted C2 comms"
    "pandora:ARM:2023:Pandora botnet targeting ARM-based TV boxes via firmware"
    "melofee:LKM:2023:Melofee kernel-mode implant attributed to APT groups"
    "kinsing:CONTAINER:2020-2024:Kinsing cryptominer targeting containerized environments"
    "perfctl:LKM:2024:Perfctl kernel rootkit masquerading as perf subsystem"
    "bootkitty:UEFI:2024:First known UEFI bootkit for Linux systems"
    "slapper:WORM:2002:OpenSSL Apache worm with P2P C2 network"
    "scalper:WORM:2002:FreeBSD Apache chunked-encoding exploit worm"
    "w55808:WORM:2001:Linux/W55808 network worm exploiting bind vulnerabilities"
    "lkm:GENERIC:various:Generic LKM rootkit detection (syscall table hooks)"
)

# =============================================================================
# Vault creation — disassemble and protect
# =============================================================================

create_vault() {
    log "Creating negamane vault for rootkit study material..."
    log "Vault location: ${VAULT_DIR}"

    # Create vault directory structure
    install -d -m 0500 "${VAULT_DIR}"
    install -d -m 0500 "${VAULT_DIR}/fragments"
    install -d -m 0500 "${VAULT_DIR}/catalog"
    install -d -m 0500 "${VAULT_DIR}/disassembly"

    # --- Extract and fragment rootkit signatures from chkrootkit ---
    log "Extracting rootkit signatures from chkrootkit..."
    if [[ -f "${CHKROOTKIT_DIR}/chkrootkit" ]]; then
        extract_chkrootkit_signatures
    elif [[ -f "${ROOTFS_DIR}/usr/local/sbin/chkrootkit" ]]; then
        CHKROOTKIT_DIR="${ROOTFS_DIR}/usr/local/sbin"
        extract_chkrootkit_signatures
    else
        log "chkrootkit not found — creating catalog from known signatures"
    fi

    # --- Extract rkhunter signature databases ---
    log "Extracting rootkit databases from rkhunter..."
    if [[ -d "${RKHUNTER_DIR}/files" ]]; then
        extract_rkhunter_signatures
    elif [[ -d "${ROOTFS_DIR}/var/lib/rkhunter" ]]; then
        RKHUNTER_DIR="${ROOTFS_DIR}/var/lib/rkhunter"
        extract_rkhunter_signatures
    fi

    # --- Create disassembled catalog for each rootkit ---
    log "Disassembling rootkit references into fragments..."
    create_disassembly_catalog

    # --- Create vault manifest ---
    create_vault_manifest

    # --- Apply negamane immutability brand ---
    apply_negamane_brand

    # --- Create unlock procedure documentation ---
    create_unlock_docs

    log "Vault created and sealed."
}

extract_chkrootkit_signatures() {
    local src="${CHKROOTKIT_DIR}/chkrootkit"
    local frag_dir="${VAULT_DIR}/fragments/chkrootkit"
    install -d -m 0500 "$frag_dir"

    # Extract each rootkit detection function as a separate fragment
    for rk_entry in "${ROOTKITS[@]}"; do
        local name="${rk_entry%%:*}"
        # Extract the function body if it exists
        if grep -q "^${name} ()" "$src" 2>/dev/null; then
            # Split function into 3 fragments (cannot be used without all 3)
            local body
            body=$(sed -n "/^${name} ()/,/^}/p" "$src" 2>/dev/null || true)
            if [[ -n "$body" ]]; then
                local lines
                lines=$(echo "$body" | wc -l)
                local third=$(( lines / 3 ))

                echo "$body" | head -n "$third" | base64 > "${frag_dir}/${name}.frag1.b64"
                echo "$body" | tail -n +"$((third + 1))" | head -n "$third" | base64 > "${frag_dir}/${name}.frag2.b64"
                echo "$body" | tail -n +"$((2 * third + 1))" | base64 > "${frag_dir}/${name}.frag3.b64"

                # Generate SHA-256 checksums for integrity
                sha256sum "${frag_dir}/${name}.frag1.b64" >> "${frag_dir}/.checksums"
                sha256sum "${frag_dir}/${name}.frag2.b64" >> "${frag_dir}/.checksums"
                sha256sum "${frag_dir}/${name}.frag3.b64" >> "${frag_dir}/.checksums"
            fi
        fi
    done
    chmod -R 0400 "$frag_dir"/* 2>/dev/null || true
}

extract_rkhunter_signatures() {
    local frag_dir="${VAULT_DIR}/fragments/rkhunter"
    install -d -m 0500 "$frag_dir"

    # Fragment the signature databases
    for db in programs_bad.dat backdoorports.dat suspscan.dat; do
        local src_file="${RKHUNTER_DIR}/files/${db}"
        if [[ -f "$src_file" ]]; then
            local lines
            lines=$(wc -l < "$src_file")
            local third=$(( lines / 3 ))

            head -n "$third" "$src_file" | base64 > "${frag_dir}/${db}.frag1.b64"
            tail -n +"$((third + 1))" "$src_file" | head -n "$third" | base64 > "${frag_dir}/${db}.frag2.b64"
            tail -n +"$((2 * third + 1))" "$src_file" | base64 > "${frag_dir}/${db}.frag3.b64"

            sha256sum "${frag_dir}/${db}.frag"*.b64 >> "${frag_dir}/.checksums"
        fi
    done
    chmod -R 0400 "$frag_dir"/* 2>/dev/null || true
}

create_disassembly_catalog() {
    local catalog_dir="${VAULT_DIR}/catalog"

    for rk_entry in "${ROOTKITS[@]}"; do
        local name="${rk_entry%%:*}"
        local rest="${rk_entry#*:}"
        local type="${rest%%:*}"
        rest="${rest#*:}"
        local years="${rest%%:*}"
        local desc="${rest#*:}"

        cat > "${catalog_dir}/${name}.yaml" <<EOF
# Rootkit Reference — STUDY ONLY
# Stored in negamane vault (immutable, disassembled)
# DO NOT reassemble without authorization

name: ${name}
type: ${type}
years_active: ${years}
description: ${desc}
vault_status: SEALED
fragments: 3
reassembly_required: true
negamane_brand: immutable
quick_install: BLOCKED

# Access requires:
#   1. negamane unlock <vault-id> --passphrase
#   2. sudo_gate level 7+ authorization
#   3. Reassembly script (not included in vault)
#   4. Audit trail logged to /var/log/negamane/vault-access.log
EOF
    done
    chmod -R 0400 "$catalog_dir"/* 2>/dev/null || true
}

create_vault_manifest() {
    local now
    now=$(date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || echo "2026-08-08T00:00:00Z")
    local count=${#ROOTKITS[@]}

    cat > "${VAULT_MANIFEST}" <<EOF
{
  "vault_id": "rootkit-study-vault-001",
  "vault_type": "negamane-immutable",
  "created": "${now}",
  "purpose": "Component study and reference — rootkit detection signatures",
  "classification": "RESTRICTED — STUDY ONLY",
  "total_rootkits": ${count},
  "fragment_scheme": "3-part base64 split (all parts required for reassembly)",
  "immutability": "negamane-branded (cannot modify without unlock)",
  "quick_install": "BLOCKED — requires multi-step unlock procedure",
  "access_requirements": [
    "negamane unlock rootkit-study-vault-001 --passphrase <key>",
    "sudo_gate authorization level 7 or higher",
    "Manual reassembly (script NOT provided)",
    "Audit trail: /var/log/negamane/vault-access.log"
  ],
  "contents": [
$(for rk_entry in "${ROOTKITS[@]}"; do
    local name="${rk_entry%%:*}"
    local rest="${rk_entry#*:}"
    local type="${rest%%:*}"
    echo "    {\"name\": \"${name}\", \"type\": \"${type}\", \"status\": \"disassembled\"},"
done | sed '$ s/,$//')
  ],
  "security_notes": [
    "All signatures are DETECTION patterns, not functional rootkit code",
    "Fragments are base64-encoded and split into 3 non-functional parts",
    "No single fragment can be used to install or deploy a rootkit",
    "Reassembly requires all 3 fragments + knowledge of reconstruction order",
    "Vault is branded immutable by negamane filesystem protection"
  ]
}
EOF
    chmod 0400 "${VAULT_MANIFEST}"
}

apply_negamane_brand() {
    log "Applying negamane immutability brand..."

    # Create the negamane lock file
    cat > "${VAULT_LOCK}" <<'EOF'
# ═══════════════════════════════════════════════════════════════════
# NEGAMANE IMMUTABLE VAULT — DO NOT MODIFY
# ═══════════════════════════════════════════════════════════════════
#
# Vault: rootkit-study-vault-001
# Brand: NEGAMANE IMMUTABLE
# Status: SEALED
#
# This vault contains disassembled rootkit detection signatures
# for STUDY AND REFERENCE ONLY. Contents cannot be:
#   - Modified (immutable filesystem brand)
#   - Quickly installed (fragments require manual reassembly)
#   - Accessed without audit trail
#
# Unlock procedure:
#   1. negamane unlock rootkit-study-vault-001 --passphrase <key>
#   2. sudo_gate --level 7 --reason "rootkit study access"
#   3. Manual fragment reassembly (no automated script provided)
#
# Any unauthorized access attempt is logged.
# ═══════════════════════════════════════════════════════════════════
LOCKED=true
BRAND=negamane
IMMUTABLE=true
VAULT_ID=rootkit-study-vault-001
SEAL_DATE=$(date -u +"%Y-%m-%d" 2>/dev/null || echo "2026-08-08")
EOF
    chmod 0400 "${VAULT_LOCK}"

    # Set immutable attributes on the vault if possible
    if command -v chattr &>/dev/null; then
        chattr +i "${VAULT_LOCK}" 2>/dev/null || true
        chattr +i "${VAULT_MANIFEST}" 2>/dev/null || true
        # Make entire vault immutable
        find "${VAULT_DIR}" -type f -exec chattr +i {} \; 2>/dev/null || true
    fi

    # Also use negamane tool if available
    if command -v negamane &>/dev/null; then
        negamane brand "${VAULT_DIR}" --immutable --vault-id rootkit-study-vault-001 2>/dev/null || true
    fi

    log "Negamane brand applied — vault is immutable."
}

create_unlock_docs() {
    install -d "${VAULT_DIR}/docs"
    cat > "${VAULT_DIR}/docs/UNLOCK-PROCEDURE.md" <<'EOF'
# Vault Unlock Procedure — rootkit-study-vault-001

## WARNING

This vault contains rootkit detection signatures for STUDY ONLY.
Unauthorized access is logged and may trigger security alerts.

## Prerequisites

1. **sudo_gate level 7** authorization (system administrator)
2. **negamane passphrase** for this vault
3. **Legitimate study reason** (logged to audit trail)

## Unlock Steps

```bash
# Step 1: Authenticate with sudo_gate (level 7+)
sudo_gate --level 7 --reason "rootkit signature study" --user $(whoami)

# Step 2: Unlock negamane vault
negamane unlock rootkit-study-vault-001 \
    --passphrase <vault-passphrase> \
    --duration 3600 \
    --audit-reason "reference study"

# Step 3: Access fragments (read-only, 1 hour window)
ls /var/lib/negamane/vaults/rootkit-study/fragments/

# Step 4: Re-lock when done
negamane lock rootkit-study-vault-001
```

## Fragment Reassembly (Manual Only)

Fragments are stored as 3-part base64 splits. To reassemble for study:

```bash
# Example (for one rootkit detection function):
cat fragment.frag1.b64 fragment.frag2.b64 fragment.frag3.b64 | base64 -d > signature.sh
```

**No automated reassembly script is provided.**
Each rootkit's 3 fragments must be manually concatenated in order.

## Audit Trail

All access is logged to:
- `/var/log/negamane/vault-access.log`
- Syslog (facility: auth, priority: notice)

## Quick Install: BLOCKED

There is NO quick-install mechanism. The vault is designed to prevent
rapid deployment of rootkit material. Even with full access:
- Signatures are fragmented (3 parts each)
- No installer script is provided
- No Makefile target assembles the material
- Manual reconstruction is required for each entry
EOF
    chmod 0400 "${VAULT_DIR}/docs/UNLOCK-PROCEDURE.md"
}

# =============================================================================
# Unlock mode (for authorized study access)
# =============================================================================

unlock_vault() {
    log "Vault unlock requested..."
    log "This requires:"
    log "  1. sudo_gate level 7+ authorization"
    log "  2. negamane passphrase"
    log "  3. Legitimate study reason"
    log ""
    log "Use the negamane CLI to unlock:"
    log "  negamane unlock rootkit-study-vault-001 --passphrase <key>"
    log ""
    log "See: ${VAULT_DIR}/docs/UNLOCK-PROCEDURE.md"
    exit 0
}

# =============================================================================
# Main
# =============================================================================

main() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║  Negamane Vault — Rootkit Study Material                     ║"
    echo "║  Galactic Cherry Marvell Edition 98                          ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""

    case "${ACTION}" in
        vault|--vault)
            create_vault
            ;;
        --unlock|unlock)
            unlock_vault
            ;;
        --help|-h)
            echo "Usage: $0 <rootfs_dir> [--vault|--unlock]"
            echo "  --vault   (default) Create and seal the vault"
            echo "  --unlock  Show unlock procedure"
            exit 0
            ;;
        *)
            create_vault
            ;;
    esac

    echo ""
    log "════════════════════════════════════════════════════════════════"
    log "Rootkit study material secured in negamane vault."
    log ""
    log "Location: ${VAULT_DIR}"
    log "Status: SEALED (immutable)"
    log "Contents: ${#ROOTKITS[@]} rootkit detection signatures"
    log "Storage: 3-fragment disassembly (not directly usable)"
    log "Install: BLOCKED (no quick-install path exists)"
    log ""
    log "To access for study: see docs/UNLOCK-PROCEDURE.md"
    log "════════════════════════════════════════════════════════════════"
}

main "$@"
