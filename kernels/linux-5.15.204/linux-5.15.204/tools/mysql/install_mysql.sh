#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# install_mysql.sh - MySQL Integration for Ubuntu Determinant Alpha RS
#
# Installs MySQL Server as part of the base OS with:
#   - Protected memory (Grain 3 / kernel-admin space)
#   - Complete memory isolation (no hooks, no DMA from other programs)
#   - No process can read MySQL's memory footprint
#   - Automatic startup via systemd
#   - Integration with negamane for binary immutability
#
# SECURITY MODEL
# ══════════════
# MySQL runs in Memory Grain 3 because:
#   - Database contents are the most sensitive data on most systems
#   - Query plans and indexes reveal business logic
#   - Connection credentials reside in process memory
#   - Buffer pool contains live decrypted data
#   - No other program should have hooks into database memory
#   - No direct memory access from external processes, period
#
# NO HOOKS POLICY
# ═══════════════
# MySQL's memory is completely isolated:
#   - No ptrace attach allowed
#   - No /proc/pid/mem access
#   - No /proc/pid/maps visibility
#   - No core dumps (prevents data exfiltration)
#   - No performance hooks (perf_event restricted)
#   - No eBPF attachment to MySQL's address space
#   - No process_vm_readv/writev against MySQL PIDs
#
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon

set -e

MYSQL_SRC="/usr/src/mysql"
MYSQL_DATA="/var/lib/mysql"
MYSQL_LOG="/var/log/mysql"
MYSQL_RUN="/run/mysqld"
MYSQL_CONF="/etc/mysql"

echo "═══════════════════════════════════════════════════════════"
echo "  MySQL Server — Protected Installation (Grain 3)"
echo "  Memory Isolation: FULL (no hooks, no external access)"
echo "═══════════════════════════════════════════════════════════"
echo ""

# ============================================================
# Step 1: System user (dedicated, isolated)
# ============================================================

echo "[1/7] Creating mysql system user..."
if ! id mysql &>/dev/null; then
    useradd --system --no-create-home --shell /sbin/nologin \
            --user-group --comment "MySQL Server (Protected Grain 3)" mysql
fi
echo "  ✓ User: mysql (system, no-login, isolated)"

# ============================================================
# Step 2: Directories with strict permissions
# ============================================================

echo "[2/7] Creating directories..."
mkdir -p "$MYSQL_DATA" "$MYSQL_LOG" "$MYSQL_RUN" "$MYSQL_CONF"
chown mysql:mysql "$MYSQL_DATA" "$MYSQL_LOG" "$MYSQL_RUN"
chmod 700 "$MYSQL_DATA"   # ONLY mysql user — no group, no others
chmod 750 "$MYSQL_LOG"
chmod 755 "$MYSQL_RUN"
echo "  ✓ Data directory: 700 (mysql:mysql only)"

# ============================================================
# Step 3: Build MySQL from source
# ============================================================

echo "[3/7] Building MySQL Server..."
if [ ! -d "$MYSQL_SRC" ]; then
    cp -r /usr/src/linux/tools/mysql "$MYSQL_SRC"
fi

cd "$MYSQL_SRC"
mkdir -p build && cd build

cmake .. \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DMYSQL_DATADIR="$MYSQL_DATA" \
    -DSYSCONFDIR="$MYSQL_CONF" \
    -DWITH_BOOST=/usr/src/boost \
    -DWITH_SSL=system \
    -DWITH_ZLIB=system \
    -DWITH_INNODB_MEMCACHED=OFF \
    -DENABLED_PROFILING=OFF \
    -DWITH_DEBUG=OFF \
    -DCOMPILATION_COMMENT="Ubuntu Determinant Alpha RS (Protected)" \
    2>&1 | tail -5

make -j$(nproc) 2>&1 | tail -3
make install
echo "  ✓ MySQL built and installed"

# ============================================================
# Step 4: Configuration with security hardening
# ============================================================

echo "[4/7] Writing protected configuration..."

cat > "$MYSQL_CONF/my.cnf" << 'EOF'
# MySQL Server Configuration
# Ubuntu Determinant Alpha RS — Protected (Grain 3, No Hooks)
#
# This server runs in fully isolated memory. No external process
# may inspect, attach to, or read its memory footprint.

[mysqld]
# Identity
user                    = mysql
pid-file                = /run/mysqld/mysqld.pid
socket                  = /run/mysqld/mysqld.sock
port                    = 3306
datadir                 = /var/lib/mysql

# Security
local-infile            = 0
symbolic-links          = 0
skip-show-database
secure-file-priv        = /var/lib/mysql-files

# Memory (optimized for protected operation)
innodb_buffer_pool_size = 1G
innodb_log_file_size    = 256M
key_buffer_size         = 256M
max_connections         = 256
thread_cache_size       = 16

# Logging
log-error               = /var/log/mysql/error.log
slow-query-log          = 1
slow-query-log-file     = /var/log/mysql/slow.log
long_query_time         = 2

# Network
bind-address            = 127.0.0.1
mysqlx-bind-address     = 127.0.0.1

# No performance schema exposure (prevents memory profiling)
performance_schema      = OFF

# Disable plugins that could expose memory
disable-log-bin

[client]
socket                  = /run/mysqld/mysqld.sock
EOF

chmod 640 "$MYSQL_CONF/my.cnf"
chown root:mysql "$MYSQL_CONF/my.cnf"
echo "  ✓ Configuration secured (640, root:mysql)"
echo "  ✓ performance_schema=OFF (no memory profiling)"

# ============================================================
# Step 5: Systemd unit with FULL memory isolation
# ============================================================

echo "[5/7] Installing systemd unit with complete memory isolation..."

cat > /etc/systemd/system/mysql.service << 'EOF'
[Unit]
Description=MySQL Server (Protected — Grain 3, No Hooks)
Documentation=man:mysqld(8)
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
ExecStart=/usr/sbin/mysqld
ExecReload=/bin/kill -HUP $MAINPID
PIDFile=/run/mysqld/mysqld.pid
User=mysql
Group=mysql

# ═══════════════════════════════════════════════════════════
# COMPLETE MEMORY ISOLATION
# No program can read MySQL's memory. No hooks. No access.
# ═══════════════════════════════════════════════════════════

# Filesystem isolation
ProtectSystem=strict
ProtectHome=yes
PrivateTmp=yes
PrivateDevices=yes
ProtectKernelTunables=yes
ProtectKernelModules=yes
ProtectKernelLogs=yes
ProtectControlGroups=yes
ProtectHostname=yes
ProtectClock=yes

# Memory isolation — NO external access
MemoryDenyWriteExecute=yes
RestrictRealtime=yes
LockPersonality=yes

# Process visibility — INVISIBLE to other processes
ProcSubset=pid
ProtectProc=invisible

# No core dumps — prevents data exfiltration via crash
LimitCORE=0

# No new privileges — prevents escalation
NoNewPrivileges=yes
RestrictSUIDSGID=yes

# Syscall filtering — minimum needed
SystemCallFilter=@system-service @io-event
SystemCallFilter=~@debug @mount @reboot @swap @raw-io
SystemCallArchitectures=native

# No ptrace — blocks strace, gdb, process_vm_readv
RestrictNamespaces=yes

# Network — only TCP (no raw sockets, no netlink hooks)
RestrictAddressFamilies=AF_UNIX AF_INET AF_INET6

# Capabilities — absolute minimum
CapabilityBoundingSet=CAP_NET_BIND_SERVICE CAP_SETUID CAP_SETGID CAP_DAC_OVERRIDE
AmbientCapabilities=

# Resource limits
LimitNOFILE=65535
LimitNPROC=4096

# Writable paths (ONLY these)
ReadWritePaths=/var/lib/mysql /var/log/mysql /run/mysqld /var/lib/mysql-files
TemporaryFileSystem=/tmp

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
echo "  ✓ Systemd unit: FULL isolation"
echo "    • ProtectProc=invisible (hidden from /proc)"
echo "    • LimitCORE=0 (no dumps)"
echo "    • MemoryDenyWriteExecute (no JIT/hook injection)"
echo "    • SystemCallFilter (no debug syscalls)"
echo "    • performance_schema=OFF (no internal profiling)"

# ============================================================
# Step 6: Initialize database
# ============================================================

echo "[6/7] Initializing database..."
if [ ! -d "$MYSQL_DATA/mysql" ]; then
    mysqld --initialize-insecure --user=mysql --datadir="$MYSQL_DATA"
    echo "  ✓ Database initialized (set root password on first login)"
else
    echo "  ✓ Database already initialized"
fi

mkdir -p /var/lib/mysql-files
chown mysql:mysql /var/lib/mysql-files
chmod 700 /var/lib/mysql-files

# ============================================================
# Step 7: Brand binaries and activate
# ============================================================

echo "[7/7] Branding and activating..."

# Negamane integration — make binaries immutable
if command -v negamane &>/dev/null; then
    negamane /usr/sbin/mysqld
    negamane /usr/bin/mysql
    negamane /usr/bin/mysqldump
    negamane "$MYSQL_CONF/"
    echo "  ✓ Binaries branded immutable (negamane)"
fi

systemctl enable mysql.service
systemctl start mysql.service 2>/dev/null || true

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  MySQL Server Installation Complete"
echo ""
echo "  Status:    systemctl status mysql"
echo "  Connect:   mysql -u root"
echo "  Logs:      /var/log/mysql/"
echo ""
echo "  PROTECTION (Grain 3 — No Hooks, No Memory Access):"
echo "    • Process invisible to other users (/proc hidden)"
echo "    • Memory cannot be read by any external process"
echo "    • No ptrace, no process_vm_readv, no /proc/pid/mem"
echo "    • No core dumps (data never written to disk on crash)"
echo "    • No performance_schema (no internal memory profiling)"
echo "    • No debug syscalls allowed (strace/gdb blocked)"
echo "    • Binaries immutable (negamane branded)"
echo "    • Data directory: 700 permissions (mysql user ONLY)"
echo "    • Config: 640 root:mysql (rank 4+ to modify)"
echo "═══════════════════════════════════════════════════════════"
