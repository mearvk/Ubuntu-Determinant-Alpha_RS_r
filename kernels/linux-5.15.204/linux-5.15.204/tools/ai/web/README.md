# Dave Web Interface — Chrome-Based Web Intelligence

Dave's programmatic interface to the web via headless Chromium. Loads real
websites in a full browser engine, captures screenshots, extracts content,
and stores findings in MySQL for later reasoning and analysis.

## Architecture

```
Dave (AI Process)
      │
      ▼
┌─────────────────────────────────────────────┐
│  dave_web (C binary)                         │
│  Drives Chrome via CLI + CDP                 │
│  Extracts: screenshot, DOM text, links, meta │
└─────────────────┬───────────────────────────┘
                  │
     ┌────────────┼────────────┐
     ▼            ▼            ▼
┌─────────┐ ┌──────────┐ ┌─────────────┐
│ Headless │ │ MySQL    │ │ Screenshot  │
│ Chromium │ │ dave_kb  │ │ /var/lib/   │
│ (CDP)    │ │          │ │ kernel-ai/  │
└─────────┘ └──────────┘ │ screenshots │
                          └─────────────┘
```

## How It Works

1. Dave invokes `dave_web <url>` (or the monitor daemon triggers it)
2. Headless Chromium launches with `--headless=new` mode
3. The page is loaded in a real browser (JavaScript executed, CSS rendered)
4. A 1920×1080 PNG screenshot is captured
5. DOM text is extracted (`--dump-dom`)
6. Title, meta description, and links are parsed
7. Everything is stored in `dave_kb.web_findings`
8. Dave can later query findings, compare screenshots, detect changes

## Usage

```bash
# Full fetch: screenshot + text + links → stored in MySQL
dave_web https://github.com/mearvk

# Screenshot only
dave_web --screenshot-only https://example.com

# Extract text content only
dave_web --text-only https://news.ycombinator.com

# Get all links from a page
dave_web --links https://golang.org

# Fetch without storing (dry-run)
dave_web --no-store https://example.com

# Query stored findings
dave_web --query "github"
dave_web --query "java web server"

# Check system status
dave_web --status
```

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
| last_checked | TIMESTAMP | When last fetched |
| change_detected | BOOLEAN | Did content change? |
| change_count | INT | Total changes observed |

### `web_sessions` — Browsing session audit trail

Records each monitoring cycle: purpose, pages visited, conclusions.

## Monitoring

Dave monitors specific URLs on a schedule. Default monitors:

| URL | Interval | Purpose |
|-----|----------|---------|
| github.com/mearvk | 24h | Track activity |
| Java.Web.Server repo | 12h | Track commits |
| Java.Web.Server README | 24h | Doc changes |

### Adding a monitor

```sql
INSERT INTO web_monitors (url, label, check_interval_hrs, added_by)
VALUES ('https://example.com', 'Example Site', 6, 'mearvk');
```

### Cron integration

```crontab
# Every 4 hours: check monitored URLs
0 */4 * * * /usr/local/bin/dave_web_monitor.sh @callback {
    expect: "Monitor cycle complete"
    on_fail: escalate
    notify: "chat:system-health"
}
```

## Screenshots

Screenshots are full 1920×1080 PNG renders of the page as Chrome sees it.
Dave can visually inspect what a website looks like — layout, colors,
content density, ads, broken elements.

Stored at: `/var/lib/kernel-ai/screenshots/`
Naming: `<timestamp>_<url_hash>.png`

## Security

- Chrome runs `--no-sandbox` in headless mode (already isolated as dave user)
- User data dir is `/var/lib/kernel-ai/chrome-data` (owned by dave, mode 700)
- No credentials stored in Chrome (no login sessions)
- Outbound only: ports 80/443 (as defined in dave_external_awareness.json)
- dave_ai MySQL user: socket auth, no password, SELECT/INSERT/UPDATE/DELETE only

## Dependencies

| Package | Purpose |
|---------|---------|
| chromium-browser | Headless web rendering |
| libcurl4-openssl-dev | HTTP client for CDP communication |
| libmysqlclient-dev | MySQL storage |
| cJSON (bundled, MIT) | JSON parsing |

## Build & Install

```bash
cd tools/ai/web
make              # Build dave_web
sudo make install # Install binary + create directories
sudo make schema  # Load MySQL tables
```

## Files

```
tools/ai/web/dave_web.c            - Main binary (C, ~650 lines)
tools/ai/web/dave_web_schema.sql   - MySQL schema extension
tools/ai/web/dave_web_monitor.sh   - Periodic monitoring daemon
tools/ai/web/Makefile              - Build/install
tools/ai/web/cjson/cJSON.h         - JSON library header (MIT, bundled)
tools/ai/web/cjson/cJSON.c         - JSON library (fetched at build time)
tools/ai/web/README.md             - This file
```

## Integration with Dave's Existing Capabilities

Dave's web interface extends his external awareness:

- **Before:** Dave could only read raw GitHub content via HTTP GET (curl)
- **After:** Dave renders full websites in Chrome, sees visual layout,
  captures screenshots, detects changes, and stores structured findings

This gives Dave **visual web intelligence** — he doesn't just read text,
he sees what a website actually looks like to a human user.
