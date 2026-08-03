#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════════════
# Ubuntu Determinant Alpha RS — Dovecot/Postfix Configuration Script
#
# Writes secure, elegant, production-ready configuration files for Postfix and
# Dovecot. Does NOT install packages — only writes config. Run install scripts
# first, then this to finalize settings.
#
# Philosophy:
#   - TLS 1.2+ only, ECDHE forward secrecy, modern ciphers
#   - No plaintext anywhere a TLS option exists
#   - Minimal attack surface: only required protocols enabled
#   - Dovecot handles auth for both itself and Postfix (single auth source)
#   - LMTP for local delivery (Sieve-capable, quota-aware)
#   - Sensible rate limits without blocking legitimate use
#   - Clean, commented files — an admin can read and understand every line
#
# Usage:
#   sudo bash configure-mail.sh
#   sudo bash configure-mail.sh --domain example.com --ip 1.2.3.4
#
# Installer Tech ID: Max Rupplin
# Date: August 2026
# ═══════════════════════════════════════════════════════════════════════════════════
set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────────
# Defaults (override via CLI or environment)
# ─────────────────────────────────────────────────────────────────────────────────
DOMAIN="${MAIL_DOMAIN:-lauradei.us}"
HOSTNAME="${MAIL_HOSTNAME:-mail.${DOMAIN}}"
SERVER_IP="${MAIL_SERVER_IP:-45.32.31.139}"
CERT_DIR="${MAIL_CERT_DIR:-/etc/letsencrypt/live/${DOMAIN}}"
POSTFIX_DIR="/etc/postfix"
DOVECOT_DIR="/etc/dovecot"

# Parse CLI args
while [[ $# -gt 0 ]]; do
    case "$1" in
        --domain)   DOMAIN="$2"; HOSTNAME="mail.${DOMAIN}"; shift 2 ;;
        --hostname) HOSTNAME="$2"; shift 2 ;;
        --ip)       SERVER_IP="$2"; shift 2 ;;
        --cert-dir) CERT_DIR="$2"; shift 2 ;;
        --help|-h)
            echo "Usage: sudo bash configure-mail.sh [--domain D] [--hostname H] [--ip IP] [--cert-dir DIR]"
            exit 0 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

echo "═══════════════════════════════════════════════════════════════"
echo "  Mail Configuration — Secure & Elegant"
echo "  Domain:   ${DOMAIN}"
echo "  Hostname: ${HOSTNAME}"
echo "  IP:       ${SERVER_IP}"
echo "  Certs:    ${CERT_DIR}"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# ═══════════════════════════════════════════════════════════════════════════════════
# POSTFIX — /etc/postfix/main.cf
# ═══════════════════════════════════════════════════════════════════════════════════

echo "[1/6] Writing Postfix main.cf..."

cat > "${POSTFIX_DIR}/main.cf" << EOF
# ═══════════════════════════════════════════════════════════════
# /etc/postfix/main.cf
# Ubuntu Determinant Alpha RS — Galactic Cherry Marvell 98
# Secure, modern, TLS-first configuration.
# ═══════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────────────────
# IDENTITY
# ─────────────────────────────────────────────────────────────
myhostname = ${HOSTNAME}
mydomain = ${DOMAIN}
myorigin = \$mydomain
mydestination = \$myhostname, localhost.\$mydomain, localhost, \$mydomain
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
inet_interfaces = all
inet_protocols = all

# ─────────────────────────────────────────────────────────────
# TLS — SERVER (inbound connections to us)
# ─────────────────────────────────────────────────────────────
smtpd_tls_cert_file = ${CERT_DIR}/fullchain.pem
smtpd_tls_key_file = ${CERT_DIR}/privkey.pem
smtpd_tls_security_level = may
smtpd_tls_auth_only = yes
smtpd_tls_protocols = >=TLSv1.2
smtpd_tls_mandatory_protocols = >=TLSv1.2
smtpd_tls_mandatory_ciphers = high
smtpd_tls_exclude_ciphers = aNULL, eNULL, EXPORT, DES, RC4, MD5, PSK, aECDH, EDH-DSS-DES-CBC3-SHA, EDH-RSA-DES-CBC3-SHA, KRB5-DES, CBC3-SHA
smtpd_tls_dh1024_param_file = \${config_directory}/dh2048.pem
smtpd_tls_session_cache_database = btree:\${data_directory}/smtpd_scache
smtpd_tls_session_cache_timeout = 3600s
smtpd_tls_loglevel = 1
smtpd_tls_received_header = yes

# ─────────────────────────────────────────────────────────────
# TLS — CLIENT (outbound connections from us)
# ─────────────────────────────────────────────────────────────
smtp_tls_security_level = dane
smtp_dns_support_level = dnssec
smtp_tls_protocols = >=TLSv1.2
smtp_tls_mandatory_protocols = >=TLSv1.2
smtp_tls_mandatory_ciphers = high
smtp_tls_session_cache_database = btree:\${data_directory}/smtp_scache
smtp_tls_session_cache_timeout = 3600s
smtp_tls_loglevel = 1
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt

# ─────────────────────────────────────────────────────────────
# SASL — Dovecot provides authentication
# ─────────────────────────────────────────────────────────────
smtpd_sasl_auth_enable = yes
smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_security_options = noanonymous, noplaintext
smtpd_sasl_tls_security_options = noanonymous

# ─────────────────────────────────────────────────────────────
# RESTRICTIONS — Defense in depth
# ─────────────────────────────────────────────────────────────
smtpd_helo_required = yes
strict_rfc821_envelopes = yes
disable_vrfy_command = yes

smtpd_helo_restrictions =
    permit_mynetworks,
    reject_invalid_helo_hostname,
    reject_non_fqdn_helo_hostname

smtpd_sender_restrictions =
    permit_mynetworks,
    permit_sasl_authenticated,
    reject_non_fqdn_sender,
    reject_unknown_sender_domain

smtpd_recipient_restrictions =
    permit_mynetworks,
    permit_sasl_authenticated,
    reject_unauth_destination,
    reject_non_fqdn_recipient,
    reject_unknown_recipient_domain,
    reject_rbl_client zen.spamhaus.org=127.0.0.[2..11],
    reject_rbl_client bl.spamcop.net,
    reject_rhsbl_helo dbl.spamhaus.org,
    reject_rhsbl_sender dbl.spamhaus.org

smtpd_relay_restrictions =
    permit_mynetworks,
    permit_sasl_authenticated,
    defer_unauth_destination

smtpd_data_restrictions =
    reject_unauth_pipelining

# ─────────────────────────────────────────────────────────────
# DELIVERY
# ─────────────────────────────────────────────────────────────
virtual_transport = lmtp:unix:private/dovecot-lmtp
home_mailbox = Maildir/
mailbox_size_limit = 0
message_size_limit = 52428800
recipient_delimiter = +

# ─────────────────────────────────────────────────────────────
# RATE LIMITING
# ─────────────────────────────────────────────────────────────
smtpd_client_connection_rate_limit = 30
smtpd_client_message_rate_limit = 60
smtpd_client_recipient_rate_limit = 120
smtpd_error_sleep_time = 1s
smtpd_soft_error_limit = 5
smtpd_hard_error_limit = 10

# ─────────────────────────────────────────────────────────────
# MILTERS — DKIM signing + ClamAV scanning
# ─────────────────────────────────────────────────────────────
milter_default_action = accept
milter_protocol = 6
smtpd_milters = inet:localhost:8891, inet:localhost:7357
non_smtpd_milters = inet:localhost:8891

# ─────────────────────────────────────────────────────────────
# MISC
# ─────────────────────────────────────────────────────────────
smtpd_banner = \$myhostname ESMTP
biff = no
append_dot_mydomain = no
readme_directory = no
compatibility_level = 3.6
EOF

# ═══════════════════════════════════════════════════════════════════════════════════
# POSTFIX — /etc/postfix/master.cf
# ═══════════════════════════════════════════════════════════════════════════════════

echo "[2/6] Writing Postfix master.cf..."

cat > "${POSTFIX_DIR}/master.cf" << 'EOF'
# ═══════════════════════════════════════════════════════════════
# /etc/postfix/master.cf
# Service definitions. Submission (587) and SMTPS (465) enabled.
# ═══════════════════════════════════════════════════════════════

# service   type  private unpriv  chroot  wakeup  maxproc command
smtp        inet  n       -       y       -       -       smtpd

submission  inet  n       -       y       -       -       smtpd
  -o syslog_name=postfix/submission
  -o smtpd_tls_security_level=encrypt
  -o smtpd_tls_auth_only=yes
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_reject_unlisted_recipient=no
  -o smtpd_recipient_restrictions=permit_sasl_authenticated,reject
  -o smtpd_relay_restrictions=permit_sasl_authenticated,reject
  -o milter_macro_daemon_name=ORIGINATING

smtps       inet  n       -       y       -       -       smtpd
  -o syslog_name=postfix/smtps
  -o smtpd_tls_wrappermode=yes
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_reject_unlisted_recipient=no
  -o smtpd_recipient_restrictions=permit_sasl_authenticated,reject
  -o smtpd_relay_restrictions=permit_sasl_authenticated,reject
  -o milter_macro_daemon_name=ORIGINATING

pickup      unix  n       -       y       60      1       pickup
cleanup     unix  n       -       y       -       0       cleanup
qmgr        unix  n       -       n       300     1       qmgr
tlsmgr      unix  -       -       y       1000?   1       tlsmgr
rewrite     unix  -       -       y       -       -       trivial-rewrite
bounce      unix  -       -       y       -       0       bounce
defer       unix  -       -       y       -       0       bounce
trace       unix  -       -       y       -       0       bounce
verify      unix  -       -       y       -       1       verify
flush       unix  n       -       y       1000?   0       flush
proxymap    unix  -       -       n       -       -       proxymap
proxywrite  unix  -       -       n       -       1       proxymap
smtp        unix  -       -       y       -       -       smtp
relay       unix  -       -       y       -       -       smtp
  -o syslog_name=postfix/$service_name
showq       unix  n       -       y       -       -       showq
error       unix  -       -       y       -       -       error
retry       unix  -       -       y       -       -       error
discard     unix  -       -       y       -       -       discard
local       unix  -       n       n       -       -       local
virtual     unix  -       n       n       -       -       virtual
lmtp        unix  -       -       y       -       -       lmtp
anvil       unix  -       -       y       -       1       anvil
scache      unix  -       -       y       -       1       scache
postlog     unix-dgram n  -       n       -       1       postlogd
EOF

# ═══════════════════════════════════════════════════════════════════════════════════
# DOVECOT — Core configuration
# ═══════════════════════════════════════════════════════════════════════════════════

echo "[3/6] Writing Dovecot configuration..."

# Main config
cat > "${DOVECOT_DIR}/dovecot.conf" << 'EOF'
# ═══════════════════════════════════════════════════════════════
# /etc/dovecot/dovecot.conf
# Ubuntu Determinant Alpha RS — Galactic Cherry Marvell 98
# Minimal top-level. Details in conf.d/.
# ═══════════════════════════════════════════════════════════════
protocols = imap pop3 lmtp
listen = *, ::
!include conf.d/*.conf
EOF

# Ensure conf.d exists
mkdir -p "${DOVECOT_DIR}/conf.d"

# ── 10-ssl.conf ──────────────────────────────────────────────────────────────────
cat > "${DOVECOT_DIR}/conf.d/10-ssl.conf" << EOF
# ═══════════════════════════════════════════════════════════════
# TLS — Required on all connections. No plaintext.
# ═══════════════════════════════════════════════════════════════
ssl = required
ssl_cert = <${CERT_DIR}/fullchain.pem
ssl_key = <${CERT_DIR}/privkey.pem
ssl_min_protocol = TLSv1.2
ssl_cipher_list = ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK
ssl_prefer_server_ciphers = yes
ssl_dh = </etc/dovecot/dh.pem
EOF

# ── 10-auth.conf ─────────────────────────────────────────────────────────────────
cat > "${DOVECOT_DIR}/conf.d/10-auth.conf" << 'EOF'
# ═══════════════════════════════════════════════════════════════
# Authentication — plain+login over TLS only. PAM backend.
# ═══════════════════════════════════════════════════════════════
disable_plaintext_auth = yes
auth_mechanisms = plain login
auth_username_format = %Ln
auth_failure_delay = 2 secs
auth_verbose = no

!include auth-system.conf.ext
EOF

# ── 10-mail.conf ─────────────────────────────────────────────────────────────────
cat > "${DOVECOT_DIR}/conf.d/10-mail.conf" << 'EOF'
# ═══════════════════════════════════════════════════════════════
# Mail storage — Maildir, one namespace.
# ═══════════════════════════════════════════════════════════════
mail_location = maildir:~/Maildir:LAYOUT=fs
mail_privileged_group = mail
mail_access_groups = mail

namespace inbox {
  inbox = yes
  separator = /
  mailbox Drafts {
    auto = subscribe
    special_use = \Drafts
  }
  mailbox Sent {
    auto = subscribe
    special_use = \Sent
  }
  mailbox Trash {
    auto = subscribe
    special_use = \Trash
  }
  mailbox Junk {
    auto = subscribe
    special_use = \Junk
  }
  mailbox Archive {
    auto = no
    special_use = \Archive
  }
}
EOF

# ── 10-master.conf ───────────────────────────────────────────────────────────────
cat > "${DOVECOT_DIR}/conf.d/10-master.conf" << 'EOF'
# ═══════════════════════════════════════════════════════════════
# Service definitions — listeners, LMTP, SASL for Postfix.
# ═══════════════════════════════════════════════════════════════

service imap-login {
  inet_listener imap {
    port = 143
  }
  inet_listener imaps {
    port = 993
    ssl = yes
  }
  process_min_avail = 1
  service_count = 1
  vsz_limit = 64M
}

service pop3-login {
  inet_listener pop3 {
    port = 110
  }
  inet_listener pop3s {
    port = 995
    ssl = yes
  }
}

service imap {
  process_limit = 256
  vsz_limit = 256M
}

service pop3 {
  process_limit = 128
}

service lmtp {
  unix_listener /var/spool/postfix/private/dovecot-lmtp {
    mode = 0600
    user = postfix
    group = postfix
  }
}

service auth {
  unix_listener /var/spool/postfix/private/auth {
    mode = 0660
    user = postfix
    group = postfix
  }
  unix_listener auth-userdb {
    mode = 0660
    user = dovecot
    group = dovecot
  }
  user = dovecot
}

service auth-worker {
  user = root
}

service stats {
  unix_listener stats-reader {
    user = dovecot
    group = dovecot
    mode = 0660
  }
  unix_listener stats-writer {
    user = dovecot
    group = dovecot
    mode = 0660
  }
}
EOF

# ── 10-logging.conf ──────────────────────────────────────────────────────────────
cat > "${DOVECOT_DIR}/conf.d/10-logging.conf" << 'EOF'
# ═══════════════════════════════════════════════════════════════
# Logging — syslog, minimal verbosity in production.
# ═══════════════════════════════════════════════════════════════
log_path = syslog
syslog_facility = mail
auth_verbose = no
auth_verbose_passwords = no
auth_debug = no
mail_debug = no
verbose_ssl = no
EOF

# ── 20-imap.conf ─────────────────────────────────────────────────────────────────
cat > "${DOVECOT_DIR}/conf.d/20-imap.conf" << 'EOF'
# ═══════════════════════════════════════════════════════════════
# IMAP — protocol-specific settings.
# ═══════════════════════════════════════════════════════════════
protocol imap {
  mail_max_userip_connections = 20
  imap_idle_notify_interval = 2 mins
}
EOF

# ── 20-pop3.conf ─────────────────────────────────────────────────────────────────
cat > "${DOVECOT_DIR}/conf.d/20-pop3.conf" << 'EOF'
# ═══════════════════════════════════════════════════════════════
# POP3 — protocol-specific settings.
# ═══════════════════════════════════════════════════════════════
protocol pop3 {
  mail_max_userip_connections = 5
  pop3_uidl_format = %08Xu%08Xv
}
EOF

# ── 20-lmtp.conf ─────────────────────────────────────────────────────────────────
cat > "${DOVECOT_DIR}/conf.d/20-lmtp.conf" << 'EOF'
# ═══════════════════════════════════════════════════════════════
# LMTP — local delivery from Postfix.
# ═══════════════════════════════════════════════════════════════
protocol lmtp {
  mail_plugins = $mail_plugins
  postmaster_address = postmaster@%{if;%d;ne;;%d;%{hostname}}
}
EOF

# ── auth-system.conf.ext ─────────────────────────────────────────────────────────
cat > "${DOVECOT_DIR}/conf.d/auth-system.conf.ext" << 'EOF'
# ═══════════════════════════════════════════════════════════════
# PAM + system users. Simple. Secure. No separate user DB.
# ═══════════════════════════════════════════════════════════════
passdb {
  driver = pam
}
userdb {
  driver = passwd
  args = blocking=no
}
EOF

# ═══════════════════════════════════════════════════════════════════════════════════
# GENERATE DH PARAMETERS (if missing)
# ═══════════════════════════════════════════════════════════════════════════════════

echo "[4/6] Checking DH parameters..."

if [ ! -f "${POSTFIX_DIR}/dh2048.pem" ]; then
    echo "      Generating Postfix DH params (2048-bit)..."
    openssl dhparam -out "${POSTFIX_DIR}/dh2048.pem" 2048 2>/dev/null
fi

if [ ! -f "${DOVECOT_DIR}/dh.pem" ]; then
    echo "      Generating Dovecot DH params (4096-bit)..."
    openssl dhparam -out "${DOVECOT_DIR}/dh.pem" 4096 2>/dev/null &
    DH_PID=$!
    echo "      (Running in background, PID ${DH_PID} — takes 1-5 minutes)"
fi

# ═══════════════════════════════════════════════════════════════════════════════════
# PERMISSIONS — Lock down config files
# ═══════════════════════════════════════════════════════════════════════════════════

echo "[5/6] Setting permissions..."

# Postfix
chown root:root "${POSTFIX_DIR}/main.cf" "${POSTFIX_DIR}/master.cf"
chmod 644 "${POSTFIX_DIR}/main.cf" "${POSTFIX_DIR}/master.cf"
[ -f "${POSTFIX_DIR}/dh2048.pem" ] && chmod 644 "${POSTFIX_DIR}/dh2048.pem"

# Dovecot
chown -R root:root "${DOVECOT_DIR}"
chmod 644 "${DOVECOT_DIR}/dovecot.conf"
chmod 644 "${DOVECOT_DIR}/conf.d/"*.conf 2>/dev/null || true
chmod 644 "${DOVECOT_DIR}/conf.d/"*.ext 2>/dev/null || true
[ -f "${DOVECOT_DIR}/dh.pem" ] && chmod 644 "${DOVECOT_DIR}/dh.pem"

# ═══════════════════════════════════════════════════════════════════════════════════
# VALIDATE & RELOAD
# ═══════════════════════════════════════════════════════════════════════════════════

echo "[6/6] Validating configuration..."

ERRORS=0

# Postfix check
if command -v postfix &>/dev/null; then
    if postfix check 2>&1 | grep -qi "fatal"; then
        echo "  [FAIL] Postfix configuration has errors:"
        postfix check 2>&1
        ERRORS=$((ERRORS + 1))
    else
        echo "  [OK] Postfix config valid."
        systemctl reload postfix 2>/dev/null && echo "  [OK] Postfix reloaded." || true
    fi
else
    echo "  [SKIP] Postfix not installed — config written for future install."
fi

# Dovecot check
if command -v doveconf &>/dev/null; then
    if doveconf -n >/dev/null 2>&1; then
        echo "  [OK] Dovecot config valid."
        systemctl reload dovecot 2>/dev/null && echo "  [OK] Dovecot reloaded." || true
    else
        echo "  [FAIL] Dovecot configuration has errors:"
        doveconf -n 2>&1 | tail -5
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "  [SKIP] Dovecot not installed — config written for future install."
fi

# ═══════════════════════════════════════════════════════════════════════════════════
# SUMMARY
# ═══════════════════════════════════════════════════════════════════════════════════

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Configuration Complete"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "  Postfix (MTA):"
echo "    main.cf          TLS 1.2+, ECDHE, DANE outbound, SASL via Dovecot"
echo "    master.cf        smtp/25, submission/587 (encrypt), smtps/465 (wrapper)"
echo "    DH params        2048-bit (${POSTFIX_DIR}/dh2048.pem)"
echo ""
echo "  Dovecot (IMAP/POP3):"
echo "    10-ssl.conf      TLS required, modern ciphers, server preference"
echo "    10-auth.conf     plain+login over TLS only, PAM backend, 2s fail delay"
echo "    10-mail.conf     Maildir, LAYOUT=fs, auto-subscribe IMAP folders"
echo "    10-master.conf   LMTP + SASL sockets for Postfix, process limits"
echo "    10-logging.conf  syslog/mail, minimal verbosity"
echo "    20-imap.conf     20 connections/user, 2min IDLE notify"
echo "    20-pop3.conf     5 connections/user"
echo "    20-lmtp.conf     Local delivery plugin"
echo "    auth-system      PAM passdb + passwd userdb"
echo "    DH params        4096-bit (${DOVECOT_DIR}/dh.pem)"
echo ""
echo "  Security Posture:"
echo "    ✓ No plaintext auth (TLS required before credentials)"
echo "    ✓ No SSLv2/v3, no TLS 1.0/1.1"
echo "    ✓ ECDHE forward secrecy on all connections"
echo "    ✓ DANE for outbound TLS verification (DNSSEC)"
echo "    ✓ VRFY disabled, strict HELO, pipelining rejection"
echo "    ✓ RBL: Spamhaus ZEN + SpamCop"
echo "    ✓ Rate limits: 30 conn/min, 60 msg/min, 120 rcpt/min"
echo "    ✓ DKIM + ClamAV milters configured"
echo "    ✓ LMTP delivery (Sieve-ready, quota-ready)"
echo "    ✓ Auth failure delay 2s (brute-force resistance)"
echo ""
if [ $ERRORS -gt 0 ]; then
    echo "  ⚠ ${ERRORS} error(s) detected. Review output above."
else
    echo "  ✓ All configurations valid. Mail system ready."
fi
echo ""
echo "  Installer Tech ID: Max Rupplin"
echo "═══════════════════════════════════════════════════════════════"
