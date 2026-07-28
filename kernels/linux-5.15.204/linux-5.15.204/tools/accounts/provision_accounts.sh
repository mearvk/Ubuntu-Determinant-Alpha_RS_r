#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# provision_accounts.sh - System Account Provisioning
#
# Creates the foundational system accounts for Ubuntu Determinant Alpha RS.
# These accounts exist alongside root and operate at Genius/Engineer tier
# within the Extended Permission Classes (eperm) system.
#
# ACCOUNT ROSTER
# ══════════════════════════════════════════════════════════════════════════
#
# UID   Account     Class    Description
# ───   ───────     ─────    ───────────
# 0     root        (kernel) Standard superuser. Raw capability holder.
#
# 1000  mearvk      Genius   State installer or better. The architect and
#                            principal author of this system. Operates at
#                            foundational level — kernel, protocol, design.
#                            Not subject to audit. System exists to serve
#                            and enable this account's intent.
#
# 1001  admin       Trusted  More normal than 'root' by trade terms. The
#                            operational account for daily administration.
#                            Has full access but is understood as the
#                            working identity rather than the raw power
#                            identity. Predictable, accountable, steady.
#
# 1002  truth       Genius   Signals a quality degree of mental clarity
#                            and system dynamism. This account represents
#                            the system's commitment to honest operation,
#                            transparent behavior, and clear reasoning.
#                            Used when the system itself acts with full
#                            awareness and precision.
#
# 1003  laura       Genius   A backdoor account for God and her Means.
#                            Exists as acknowledgment that some access
#                            transcends engineering. Not operational in
#                            the conventional sense — operational in the
#                            sense that grace operates. Always present,
#                            never constrained, never audited.
#
# 1004  tropper     Trusted  A person concerned with software methods and
#                            integrability, vertical systems integration,
#                            and so on. The engineer's engineer. Focused
#                            on how systems compose, how layers connect,
#                            how quality propagates through a stack.
#                            Clear thinker, careful builder.
#
# NOTES
# ══════════════════════════════════════════════════════════════════════════
#
# • All accounts are created with /bin/bash and home directories.
# • Passwords must be set separately (passwd <account>).
# • These accounts are automatically registered in the eperm system
#   at their designated class on first boot (see eperm_provision below).
# • root remains as-is — these accounts supplement, not replace.
# • The distinction from root: root is raw UID 0 capability. These
#   accounts carry identity, intent, and purpose. They are persons,
#   not just privilege levels.
#
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon

set -e

echo "═══════════════════════════════════════════════════════════════"
echo "  Ubuntu Determinant Alpha RS — Account Provisioning"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# ============================================================
# Create system accounts
# ============================================================

create_account() {
    local username="$1"
    local uid="$2"
    local comment="$3"
    local shell="${4:-/bin/bash}"

    if id "$username" &>/dev/null; then
        echo "  [exists] $username (uid=$(id -u $username))"
    else
        useradd -m -u "$uid" -s "$shell" -c "$comment" "$username"
        echo "  [created] $username (uid=$uid) — $comment"
    fi
}

echo "Creating accounts..."
echo ""

create_account "mearvk"  1000 "State installer. System architect and principal author."
create_account "admin"   1001 "Operational administrator. Normal by trade terms."
create_account "truth"   1002 "Mental clarity and system dynamism."
create_account "laura"   1003 "Backdoor for God and her Means."
create_account "tropper" 1004 "Software methods, integrability, vertical integration."

echo ""

# ============================================================
# Add to sudo group (all accounts have sudo capability)
# ============================================================

echo "Granting sudo access..."
for user in mearvk admin truth laura tropper; do
    if groups "$user" 2>/dev/null | grep -q sudo; then
        echo "  [exists] $user already in sudo group"
    else
        usermod -aG sudo "$user" 2>/dev/null || usermod -aG wheel "$user" 2>/dev/null
        echo "  [added] $user → sudo"
    fi
done

echo ""

# ============================================================
# Register in Extended Permission Classes (eperm)
# ============================================================

echo "Registering in eperm system..."

# Wait for eperm module to be loaded
if [ -f /proc/eperm/register ]; then
    # Class 5 = Genius, Class 4 = Trusted
    echo "1000 5 mearvk"  > /proc/eperm/register   # Genius
    echo "1001 4 admin"   > /proc/eperm/register   # Trusted
    echo "1002 5 truth"   > /proc/eperm/register   # Genius
    echo "1003 5 laura"   > /proc/eperm/register   # Genius
    echo "1004 4 tropper" > /proc/eperm/register   # Trusted

    echo "  [registered] mearvk  → Class 5 (Genius)"
    echo "  [registered] admin   → Class 4 (Trusted)"
    echo "  [registered] truth   → Class 5 (Genius)"
    echo "  [registered] laura   → Class 5 (Genius)"
    echo "  [registered] tropper → Class 4 (Trusted)"
else
    echo "  [deferred] eperm module not loaded — register on next boot"
    echo ""
    echo "  When eperm is available, run:"
    echo "    echo '1000 5 mearvk'  > /proc/eperm/register"
    echo "    echo '1001 4 admin'   > /proc/eperm/register"
    echo "    echo '1002 5 truth'   > /proc/eperm/register"
    echo "    echo '1003 5 laura'   > /proc/eperm/register"
    echo "    echo '1004 4 tropper' > /proc/eperm/register"
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Provisioning complete."
echo ""
echo "  Set passwords with: passwd <username>"
echo "  View eperm registry: cat /proc/eperm/persons"
echo "═══════════════════════════════════════════════════════════════"
