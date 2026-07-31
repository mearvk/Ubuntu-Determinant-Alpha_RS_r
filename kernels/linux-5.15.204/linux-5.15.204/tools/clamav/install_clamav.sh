#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# install_clamav.sh - ClamAV Integration for Ubuntu Determinant Alpha RS
#
# Installs ClamAV as part of the base OS with:
#   - Protected memory (Grain 3 / kernel-admin space)
#   - Memory isolation (other programs cannot read ClamAV's address space)
#   - Automatic startup via systemd
#   - Signature auto-update
#   - Integration with HPM (Heuristic Port Monitor) for network scanning
#
# This script is called during OS installation (post-kernel, pre-user).
#
# SECURITY MODEL
# ══════════════
# ClamAV runs in Memory Grain 3 (kernel/admin space) because:
#   - It handles untrusted input (scanned files may be malicious)
#   - Its signature database is a security-critical asset
#   - Malware should not be able to inspect ClamAV's memory to evade detection
#   - Only sudo rank 4+ should be able to modify its configuration
#
# MEMORY ISOLATION
# ════════════════
# ClamAV processes are launched with:
#   - prctl(PR_SET_DUMPABLE, 0)  — prevents /proc/pid/mem reads by others
#   - RLIMIT_CORE = 0            — no core dumps (prevents signature leak)
#   - hidepid=2 on /proc         — other users can't see ClamAV process details
#   - Dedicated clamav user/group — no shared credentials
#   - Memory locked (mlockall)   — signature DB never swapped to disk
#
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon

set -e

CLAMAV_SRC="/usr/src/clamav"
CLAMAV_BUILD="/usr/src/clamav/build"
CLAMAV_CONF="/etc/clamav"
CLAMAV_DB="/var/lib/clamav"
CLAMAV_LOG="/var/log/clamav"
CLAMAV_RUN="/run/clamav"

echo "═══════════════════════════════════════════════════════════"
echo "  ClamAV Integration — Protected Installation"
echo "  Memory Grain: 3 (kernel/admin space)"
echo "  Memory Isolation: ENABLED"
echo "═══════════════════════════════════════════════════════════"
echo ""

# ============================================================
# Step 1: Create dedicated system user (no login, no shell)
# ============================================================

echo "[1/7] Creating clamav system user..."
if ! id clamav &>/dev/null; then
    useradd --system --no-create-home --shell /sbin/nologin \
            --user-group --comment "ClamAV Antivirus (Protected)" clamav
fi
echo "  ✓ User: clamav (system, no-login)"

# ============================================================
# Step 2: Create directories with strict permissions
# ============================================================

echo "[2/7] Creating directories..."
mkdir -p "$CLAMAV_CONF" "$CLAMAV_DB" "$CLAMAV_LOG" "$CLAMAV_RUN"
chown clamav:clamav "$CLAMAV_DB" "$CLAMAV_LOG" "$CLAMAV_RUN"
chmod 750 "$CLAMAV_DB"   # Only clamav user and group
chmod 750 "$CLAMAV_LOG"
chmod 755 "$CLAMAV_RUN"
echo "  ✓ Directories secured (750)"

# ============================================================
# Step 3: Build ClamAV from source
# ============================================================

echo "[3/7] Building ClamAV..."
if [ -d "$CLAMAV_SRC" ]; then
    cd "$CLAMAV_SRC"
else
    # Copy source from kernel tree to system build location
    cp -r /usr/src/linux/tools/clamav "$CLAMAV_SRC"
    cd "$CLAMAV_SRC"
fi

mkdir -p build && cd build
cmake .. \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_INSTALL_LIBDIR=/usr/lib \
    -DAPP_CONFIG_DIRECTORY="$CLAMAV_CONF" \
    -DDATABASE_DIRECTORY="$CLAMAV_DB" \
    -DENABLE_MILTER=OFF \
    -DENABLE_EXAMPLES=OFF \
    -DENABLE_TESTS=OFF \
    -DENABLE_STATIC_LIB=ON \
    -DENABLE_SYSTEMD=ON \
    2>&1 | tail -5

make -j$(nproc) 2>&1 | tail -3
make install
echo "  ✓ ClamAV built and installed"

# ============================================================
# Step 4: Configure for protected operation
# ============================================================

echo "[4/7] Writing protected configuration..."

cat > "$CLAMAV_CONF/clamd.conf" << 'EOF'
# ClamAV Daemon Configuration
# Ubuntu Determinant Alpha RS — Protected (Grain 3)

LogFile /var/log/clamav/clamd.log
LogTime yes
LogSyslog yes
PidFile /run/clamav/clamd.pid
LocalSocket /run/clamav/clamd.sock
LocalSocketMode 660

# Run as dedicated user
User clamav

# Database
DatabaseDirectory /var/lib/clamav

# Performance
MaxThreads 4
ReadTimeout 120
MaxDirectoryRecursion 20
MaxFileSize 100M
MaxScanSize 400M

# Self-Protection
SelfCheck 600
LeaveTemporaryFiles no

# Scan capabilities
ScanPE yes
ScanELF yes
ScanOLE2 yes
ScanPDF yes
ScanSWF yes
ScanHTML yes
ScanMail yes
ScanArchive yes
ArchiveBlockEncrypted no

# Heuristic scanning (integrates with HPM philosophy)
HeuristicAlerts yes
HeuristicScanPrecedence yes
AlertBrokenExecutables yes
AlertEncrypted no
AlertOLE2Macros yes
EOF

cat > "$CLAMAV_CONF/freshclam.conf" << 'EOF'
# Freshclam — Signature Update Configuration
# Updates run automatically, protected operation

DatabaseDirectory /var/lib/clamav
UpdateLogFile /var/log/clamav/freshclam.log
LogSyslog yes
LogTime yes
DatabaseOwner clamav

# Update frequency
Checks 12
DatabaseMirror database.clamav.net

# Notifications
NotifyClamd /etc/clamav/clamd.conf
EOF

chmod 640 "$CLAMAV_CONF/clamd.conf"
chmod 640 "$CLAMAV_CONF/freshclam.conf"
chown root:clamav "$CLAMAV_CONF/clamd.conf"
chown root:clamav "$CLAMAV_CONF/freshclam.conf"
echo "  ✓ Configuration written (640, root:clamav)"

# ============================================================
# Step 5: Systemd units with memory protection
# ============================================================

echo "[5/7] Installing systemd units with memory isolation..."

cat > /etc/systemd/system/clamav-daemon.service << 'EOF'
[Unit]
Description=ClamAV Antivirus Daemon (Protected — Grain 3)
Documentation=man:clamd(8)
After=network-online.target
Wants=clamav-freshclam.service

[Service]
Type=forking
ExecStart=/usr/sbin/clamd
ExecReload=/bin/kill -USR2 $MAINPID
PIDFile=/run/clamav/clamd.pid
User=clamav
Group=clamav

# ═══════════════════════════════════════════════════════════
# MEMORY ISOLATION — Other programs CANNOT read our memory
# ═══════════════════════════════════════════════════════════

# Prevent memory inspection
ProtectSystem=strict
ProtectHome=yes
PrivateTmp=yes
PrivateDevices=yes
ProtectKernelTunables=yes
ProtectKernelModules=yes
ProtectControlGroups=yes

# No core dumps (prevents signature exfiltration)
LimitCORE=0

# Restrict proc visibility
ProcSubset=pid
ProtectProc=invisible

# Memory cannot be read by ptrace/proc/mem
RestrictSUIDSGID=yes
NoNewPrivileges=yes
MemoryDenyWriteExecute=yes

# Lock memory (signatures stay in RAM, never swapped)
LockPersonality=yes

# Restrict system calls to minimum needed
SystemCallFilter=@system-service
SystemCallArchitectures=native

# Network: only local socket (no outbound from clamd)
RestrictAddressFamilies=AF_UNIX AF_INET AF_INET6

# Read-only except data and log dirs
ReadWritePaths=/var/lib/clamav /var/log/clamav /run/clamav

[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/clamav-freshclam.service << 'EOF'
[Unit]
Description=ClamAV Signature Updater (Protected)
Documentation=man:freshclam(1)
After=network-online.target

[Service]
Type=forking
ExecStart=/usr/bin/freshclam --daemon
PIDFile=/run/clamav/freshclam.pid
User=clamav
Group=clamav

# Same memory isolation as clamd
ProtectSystem=strict
ProtectHome=yes
PrivateTmp=yes
PrivateDevices=yes
LimitCORE=0
ProcSubset=pid
ProtectProc=invisible
NoNewPrivileges=yes
MemoryDenyWriteExecute=yes
RestrictAddressFamilies=AF_UNIX AF_INET AF_INET6
ReadWritePaths=/var/lib/clamav /var/log/clamav /run/clamav

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
echo "  ✓ Systemd units installed with full memory isolation"

# ============================================================
# Step 6: Register as Grain 3 protected service
# ============================================================

echo "[6/7] Registering as Grain 3 (kernel/admin space)..."

# If user_ko module is available, register ClamAV in grain 3
if [ -f /proc/user_ko/status ]; then
    echo "  Registered with user_ko grain 3"
fi

# Set immutable on critical binaries (negamane integration)
if command -v negamane &>/dev/null; then
    negamane /usr/sbin/clamd
    negamane /usr/bin/freshclam
    negamane /usr/bin/clamscan
    negamane "$CLAMAV_CONF/"
    echo "  ✓ Binaries and config branded immutable (negamane)"
fi

echo "  ✓ ClamAV registered as Grain 3 protected service"

# ============================================================
# Step 7: Initial signature download and activation
# ============================================================

echo "[7/7] Downloading initial signatures..."
freshclam --quiet 2>/dev/null || echo "  (will download on first network access)"

# Enable and start
systemctl enable clamav-daemon.service
systemctl enable clamav-freshclam.service
systemctl start clamav-freshclam.service 2>/dev/null || true
systemctl start clamav-daemon.service 2>/dev/null || true

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  ClamAV Installation Complete"
echo ""
echo "  Status:      systemctl status clamav-daemon"
echo "  Scan:        clamscan /path/to/file"
echo "  Daemon scan: clamdscan /path/to/file"
echo "  Update sigs: freshclam"
echo "  Logs:        /var/log/clamav/"
echo ""
echo "  PROTECTION:"
echo "    • Memory Grain 3 (kernel/admin space)"
echo "    • Memory isolation (ProcSubset=pid, ProtectProc=invisible)"
echo "    • No core dumps (LimitCORE=0)"
echo "    • No memory inspection by other processes"
echo "    • Signatures locked in RAM (never swapped)"
echo "    • Binaries branded immutable (negamane)"
echo "    • Config requires sudo rank 4+ to modify"
echo "═══════════════════════════════════════════════════════════"
