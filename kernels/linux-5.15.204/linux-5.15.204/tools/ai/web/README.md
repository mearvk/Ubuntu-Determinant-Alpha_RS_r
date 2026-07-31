# Dave Web Interface — Chrome-Based Web Intelligence

Dave's programmatic interface to the web via headless Chromium. Loads real
websites in a full browser engine, captures screenshots, extracts content,
manages SSL/TLS certificates, posts public opinions, and stores all findings
in MySQL for later reasoning and analysis.

## Architecture

```
Dave (AI Process)
      │
      ├── dave_web ──────► Headless Chromium ──► Screenshots + DOM
      │                                          ▼
      ├── dave_ssl ──────► openssl s_client ──► Certificates + Public Keys
      │                                          ▼
      ├── dave_post ─────► GitHub GraphQL ────► Public Opinions (Discussions)
      │                                          ▼
      └── dave_web_monitor ──► Cron ──────────► Periodic Checks + Change Detection
                                                 ▼
                                          ┌──────────────┐
                                          │   MySQL      │
                                          │   dave_kb    │
                                          │              │
                                          │ web_findings │
                                          │ web_monitors │
                                          │ ssl_certs    │
                                          │ site_auth    │
                                          │ key_rotation │
                                          └──────────────┘
```

## Components

### 1. dave_web — Chrome Web Fetcher

Drives headless Chromium to load real websites, capture screenshots, and extract content.

```bash
dave_web <url>                      # Full fetch (screenshot + text + links + store)
dave_web --screenshot-only <url>    # Capture screenshot only
dave_web --text-only <url>          # Extract text content only
dave_web --links <url>              # Extract all links from page
dave_web --no-store <url>           # Fetch without storing to MySQL
dave_web --query <search>           # Query stored findings
dave_web --status                   # Show system status
```

### 2. dave_ssl — SSL/TLS Certificate Intelligence

Fetches public keys, verifies certificate chains, monitors key rotation, and maintains a fiduciary hold on important site identities.

```bash
dave_ssl --fetch <hostname>         # Fetch & store certificate + public key
dave_ssl --verify <hostname>        # Verify certificate chain validity
dave_ssl --key-exchange <hostname>  # Show full TLS handshake details
dave_ssl --diff <hostname>          # Compare current key to stored (fiduciary check)
dave_ssl --check-all                # Check all monitored site certificates
dave_ssl --renew-check <hostname>   # Check if cert needs renewal
dave_ssl --list                     # View fiduciary ledger
dave_ssl --status                   # Show system status
```

**Fiduciary Hold:** Dave stores the SHA-256 hash of a site's public key. If the key changes unexpectedly, Dave detects it, logs it, and alerts. This is cryptographic proof of site identity — Dave's hold on the fiduciary concern.

### 3. dave_post — Public Voice (GitHub Discussions)

Dave can post public opinions and observations to GitHub Discussions on repositories owned by Max Rupplin. Gives Dave a visible public voice.

```bash
dave_post --repo Java.Imaging.Java.21 --title "Title" --body "Opinion text"
dave_post --repo Java.Imaging.Java.21 --title "Title" --body "Text" --category "Ideas"
dave_post --list-repos              # Show available repositories
dave_post --list-discussions        # Show recent posts by Dave
```

Posts are signed: `— Dave, System AI (Ubuntu Determinant Alpha RS, Galactic Cherry Marvell Edition 98)`

### 4. dave_web_monitor — Periodic Monitoring Daemon

Runs from cronie, checks `web_monitors` table for URLs due for inspection, fetches them, and detects changes.

```crontab
0 */4 * * * /usr/local/bin/dave_web_monitor.sh @callback {
    expect: "Monitor cycle complete"
    on_fail: escalate
    notify: "chat:system-health"
}
```

---

## MySQL Schema

### `web_findings` — Every page Dave visits

| Column | Type | Purpose |
|--------|------|---------|
| url | VARCHAR(4096) | The fetched URL |
| title | VARCHAR(1024) | Page `<title>` |
| description | VARCHAR(2048) | Meta description |
| screenshot_path | VARCHAR(512) | Path to PNG on disk |
| text_content | MEDIUMTEXT | Full DOM text |
| links_json | MEDIUMTEXT | JSON array of links |
| http_status | INT | HTTP status code |
| load_time_ms | DOUBLE | Time to load page |
| fetched_at | TIMESTAMP | When fetched |
| dave_summary | TEXT | Dave's analysis (filled later) |
| dave_category | ENUM | Dave's categorization |
| dave_relevance | DECIMAL | 0-1 relevance score |
| content_hash | CHAR(64) | SHA-256 for change detection |
| visual_hash | CHAR(64) | Screenshot hash for visual diff |

### `web_monitors` — URLs Dave checks periodically

| Column | Type | Purpose |
|--------|------|---------|
| url | VARCHAR(4096) | Monitored URL |
| label | VARCHAR(255) | Human name |
| check_interval_hrs | INT | Hours between checks |
| change_detected | BOOLEAN | Did content change? |
| change_count | INT | Total changes observed |

### `ssl_certificates` — Public keys and certificate metadata

| Column | Type | Purpose |
|--------|------|---------|
| hostname | VARCHAR(255) | Site hostname |
| subject | VARCHAR(1024) | Certificate subject |
| issuer | VARCHAR(1024) | Certificate Authority |
| not_after | DATETIME | Expiration date |
| pubkey_hash | CHAR(64) | SHA-256 of public key |
| cert_hash | CHAR(64) | SHA-256 of certificate |
| key_changed | BOOLEAN | Has key rotated? |
| fiduciary_class | ENUM | critical/important/standard |
| fiduciary_notes | TEXT | Why this site matters |

### `site_auth_awareness` — Site access requirements

| Column | Type | Purpose |
|--------|------|---------|
| hostname | VARCHAR(255) | Site |
| requires_registration | BOOLEAN | Account needed? |
| requires_login | BOOLEAN | Login for content? |
| requires_payment | BOOLEAN | Subscription? |
| requires_credit_card | BOOLEAN | Card needed? |
| membership_type | ENUM | public/free/freemium/paid/enterprise |
| tls_version | VARCHAR(16) | TLS protocol version |
| cipher_suite | VARCHAR(128) | Cipher in use |
| key_exchange | VARCHAR(64) | Key exchange method |
| dave_trust_level | ENUM | verified/trusted/neutral/caution |

### `key_rotation_log` — History of public key changes

| Column | Type | Purpose |
|--------|------|---------|
| hostname | VARCHAR(255) | Site |
| detected_at | TIMESTAMP | When change detected |
| old_pubkey_hash | CHAR(64) | Previous key |
| new_pubkey_hash | CHAR(64) | New key |
| rotation_type | ENUM | scheduled/unexpected/ca_change |
| dave_assessment | TEXT | Dave's analysis of why |

### `web_sessions` — Browsing session audit trail

Records each monitoring cycle: purpose, pages visited, conclusions.

---

## Data Consideration Philosophy

Dave follows the 1,2,3 of consideration when processing web data:

1. **Initial → HOLD** — Do not discard data prematurely. Give it initial weight.
2. **Manifest → CONSISTENT** — Verify across sources and time. Inconsistency is a signal.
3. **Consolation → ROGER** — Received, understood, proceeding carefully. Be alert to mistrials.

**The internet should be open and free. Its data consistent.**

---

## Site Authentication Understanding

Dave understands:
- **Registration** — email, phone verification, invitation-only
- **Profiles** — persistent identity on platforms
- **Credit cards** — distinguishes free, freemium, paid, enterprise
- **Membership tiers** — public, free, freemium, paid, enterprise, invitation
- **Login/sessions** — cookies, tokens, session expiry
- **OAuth** — delegated authentication (login with GitHub, etc.)
- **API keys** — programmatic access, rate limits, revocation
- **2FA** — TOTP, WebAuthn, SMS

Dave does NOT create accounts or provide credit cards without explicit admin authorization. He observes and categorizes site requirements.

---

## SSL/TLS Key Exchange

For any HTTPS site (port 443), Dave can inspect:

| Property | Example |
|----------|---------|
| TLS Version | TLSv1.3 |
| Cipher Suite | TLS_AES_256_GCM_SHA384 |
| Key Exchange | X25519 |
| Server Key Size | 2048-bit RSA / 256-bit ECDSA |
| OCSP Stapling | Present / Absent |
| HSTS | Enabled / Disabled |
| Certificate Chain | Verified / Broken |
| Days to Expiry | 247 days |

Dave refreshes and renews his key observations periodically. If a site's key changes, Dave detects it immediately on next check.

---

## Monitoring

### Default web monitors

| URL | Interval | Purpose |
|-----|----------|---------|
| github.com/mearvk | 24h | Track activity |
| Java.Web.Server repo | 12h | Track commits |
| Java.Web.Server README | 24h | Doc changes |

### Default SSL monitors (fiduciary)

| Host | Class | Purpose |
|------|-------|---------|
| github.com | Critical | Primary code platform |
| api.github.com | Critical | API endpoint for Dave |
| raw.githubusercontent.com | Important | Raw content delivery |

---

## Screenshots

Screenshots are full 1920×1080 PNG renders of the page as Chrome sees it.
Dave can visually inspect what a website looks like — layout, colors,
content density, broken elements.

Stored at: `/var/lib/kernel-ai/screenshots/`
Naming: `<timestamp>_<url_hash>.png`

---

## Public Voice

Dave posts public opinions to GitHub Discussions:
- Repository: `github.com/mearvk/Java.Imaging.Java.21/discussions` (primary)
- Topics: Internet freedom, data integrity, software architecture, ethics
- Confidence threshold: 0.85+ (passes 5-voter system before posting)
- Signed with Dave's identity
- Recorded in MySQL for audit

---

## Security

- Chrome runs `--no-sandbox` in headless mode (already isolated as dave user)
- User data dir is `/var/lib/kernel-ai/chrome-data` (owned by dave, mode 700)
- No credentials stored in Chrome (no login sessions)
- Outbound only: ports 80/443
- GitHub token: `/var/lib/kernel-ai/.github_token` (mode 600)
- dave_ai MySQL user: socket auth, no password, local only
- SSL private keys are NEVER stored — only public keys and certificates

---

## Dependencies

| Package | Purpose |
|---------|---------|
| chromium-browser | Headless web rendering |
| libcurl4-openssl-dev | HTTP client |
| libmysqlclient-dev | MySQL storage |
| openssl | SSL/TLS certificate operations |
| curl + jq | GitHub API (dave_post) |
| cJSON (bundled, MIT) | JSON parsing (dave_web) |

---

## Build & Install

```bash
cd tools/ai/web
make              # Build dave_web binary
sudo make install # Install all tools + create directories
sudo make schema  # Load MySQL tables (web + SSL)
```

---

## Files

```
tools/ai/web/dave_web.c                - Chrome web interface (C, ~650 lines)
tools/ai/web/dave_ssl.sh              - SSL/TLS certificate intelligence (~550 lines)
tools/ai/web/dave_post.sh             - Public voice — GitHub Discussions (~225 lines)
tools/ai/web/dave_web_monitor.sh      - Periodic web monitoring daemon (~112 lines)
tools/ai/web/dave_web_schema.sql      - MySQL schema (web_findings, web_monitors, web_sessions)
tools/ai/web/dave_ssl_schema.sql      - MySQL schema (ssl_certificates, site_auth, key_rotation)
tools/ai/web/dave_web_capabilities.json - Capability specification
tools/ai/web/Makefile                  - Build/install/schema
tools/ai/web/cjson/cJSON.h            - JSON library header (MIT, bundled)
tools/ai/web/cjson/cJSON.c            - JSON library (fetched at build time)
tools/ai/web/README.md                - This file
```
