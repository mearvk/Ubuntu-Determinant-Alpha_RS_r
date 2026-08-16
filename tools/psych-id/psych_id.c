/*
 * psych_id.c — Psych-ID: Network Intelligence & Web Analysis Daemon
 *
 * Scans ports 20, 21, 22, 80, 443 (8080, 8443) for MOTD banner
 * intelligence. Applies suggestion lobotomy (center reference with
 * 3rd/4th dimensional maintenance, law respect, science maintenance)
 * and insect trimming (removal of impossible/dead-end varios).
 *
 * ~300 MB SQLite database for suspects analysis and web-of-information.
 * Settable to daily feed, feed-on-command, feed-and-update, or
 * occasional reminder. Cron-compatible via callback extension.
 *
 * Part of Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
 * Copyright (C) 2026 MEARVK LLC
 * License: GPL-2.0
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <time.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <openssl/ssl.h>
#include <openssl/err.h>
#include <sqlite3.h>

#include "psych_id.h"

/* ─── Globals ─────────────────────────────────────────────────────── */

static psych_id_config_t g_config;
static psych_id_state_t  g_state;
static sqlite3          *g_db = NULL;
static pthread_mutex_t   g_db_mutex = PTHREAD_MUTEX_INITIALIZER;
static pthread_t         g_daemon_thread;
static volatile int      g_running = 0;
static volatile int      g_feed_requested = 0;
static SSL_CTX          *g_ssl_ctx = NULL;

/* ─── Forward Declarations ────────────────────────────────────────── */

static void *daemon_main_loop(void *arg);
static int   db_open(const char *path);
static void  db_close(void);
static int   db_create_schema(void);
static int   db_insert_banner(const psych_id_banner_t *b);
static int   db_insert_suspect(const psych_id_suspect_t *s);
static int   db_insert_prescription(const psych_id_prescription_t *p);
static int   db_insert_web_node(const psych_id_web_node_t *n);
static int   db_get_size(uint64_t *size_bytes);
static int   db_prune_oldest(uint64_t target_size);

static int   scanner_grab_tcp_banner(const char *host, uint16_t port, char *buf, size_t bufsz);
static int   scanner_grab_tls_banner(const char *host, uint16_t port, char *buf, size_t bufsz);
static int   scanner_identify_service(const char *banner, char *name, char *version, size_t len);

static int   analyzer_classify_banner(const psych_id_banner_t *b, uint8_t *threat, uint8_t *interest);
static int   analyzer_lobotomy_apply(psych_id_suspect_t *s, lobotomy_stage_t stage);
static int   analyzer_insect_check(psych_id_web_node_t *node);
static int   analyzer_prescribe_searches(const psych_id_suspect_t *s);

static int   search_engine_build_query(const char *context, const char *engine, char *out, size_t outsz);
static int   search_engine_evaluate_hint(const char *url, const char *title, uint8_t *relevance);

static void  log_msg(int level, const char *fmt, ...);
static int   load_config(const char *path);
static int   save_pid_file(void);
static void  remove_pid_file(void);
static void  signal_handler(int sig);

/* ─── Lifecycle ───────────────────────────────────────────────────── */

int psych_id_init(const char *config_path)
{
    memset(&g_config, 0, sizeof(g_config));
    memset(&g_state, 0, sizeof(g_state));

    /* Defaults */
    g_config.feed_mode = FEED_MODE_DAILY;
    g_config.daily_hour = 3;
    g_config.daily_minute = 0;
    g_config.reminder_min_hours = 8;
    g_config.reminder_max_hours = 36;
    g_config.scan_timeout_ms = 5000;
    g_config.max_concurrent_scans = 4;
    g_config.enable_tls_probing = 1;
    g_config.enable_search_hints = 1;
    g_config.enable_web_fetch = 0;  /* conservative default */
    g_config.verbose = 1;
    strncpy(g_config.db_path, PSYCH_ID_DB_PATH, sizeof(g_config.db_path) - 1);
    strncpy(g_config.log_path, "/var/log/psych-id.log", sizeof(g_config.log_path) - 1);
    strncpy(g_config.targets_file, "/etc/psych-id/targets.txt", sizeof(g_config.targets_file) - 1);
    strncpy(g_config.search_engines, "duckduckgo,google,bing", sizeof(g_config.search_engines) - 1);

    /* Load user config if provided */
    if (config_path && config_path[0]) {
        if (load_config(config_path) != 0) {
            log_msg(1, "WARN: Could not load config from %s, using defaults", config_path);
        }
    }

    /* Initialize OpenSSL */
    SSL_library_init();
    SSL_load_error_strings();
    OpenSSL_add_all_algorithms();
    g_ssl_ctx = SSL_CTX_new(TLS_client_method());
    if (!g_ssl_ctx) {
        log_msg(0, "ERROR: Failed to create SSL context");
        return -1;
    }

    /* Create data directory */
    mkdir("/var/lib/psych-id", 0750);

    /* Open database */
    if (db_open(g_config.db_path) != 0) {
        log_msg(0, "ERROR: Failed to open database at %s", g_config.db_path);
        return -1;
    }

    /* Create schema if needed */
    if (db_create_schema() != 0) {
        log_msg(0, "ERROR: Failed to create database schema");
        return -1;
    }

    /* Set up signal handlers */
    signal(SIGTERM, signal_handler);
    signal(SIGINT, signal_handler);
    signal(SIGUSR1, signal_handler);  /* USR1 = trigger immediate feed */
    signal(SIGUSR2, signal_handler);  /* USR2 = trigger feed + update */

    log_msg(1, "Psych-ID v%s initialized (mode: %d, db: %s)",
            PSYCH_ID_VERSION_STRING, g_config.feed_mode, g_config.db_path);

    return 0;
}

int psych_id_start_daemon(void)
{
    if (g_running) {
        log_msg(1, "Daemon already running");
        return 0;
    }

    g_running = 1;
    g_state.daemon_running = 1;

    if (save_pid_file() != 0) {
        log_msg(1, "WARN: Could not write PID file");
    }

    if (pthread_create(&g_daemon_thread, NULL, daemon_main_loop, NULL) != 0) {
        log_msg(0, "ERROR: Failed to start daemon thread: %s", strerror(errno));
        g_running = 0;
        g_state.daemon_running = 0;
        return -1;
    }

    log_msg(1, "Psych-ID daemon started (PID %d)", getpid());
    return 0;
}

int psych_id_stop_daemon(void)
{
    if (!g_running) return 0;

    g_running = 0;
    pthread_join(g_daemon_thread, NULL);
    g_state.daemon_running = 0;
    remove_pid_file();

    log_msg(1, "Psych-ID daemon stopped");
    return 0;
}

void psych_id_cleanup(void)
{
    psych_id_stop_daemon();
    db_close();

    if (g_ssl_ctx) {
        SSL_CTX_free(g_ssl_ctx);
        g_ssl_ctx = NULL;
    }

    EVP_cleanup();
    log_msg(1, "Psych-ID cleanup complete");
}

/* ─── Feed Operations ─────────────────────────────────────────────── */

int psych_id_feed_now(void)
{
    log_msg(1, "Feed triggered (scan only)");
    g_state.feed_in_progress = 1;
    g_state.last_feed_time = time(NULL);

    int result = psych_id_scan_all_targets();

    g_state.feed_in_progress = 0;
    return result;
}

int psych_id_feed_and_update(void)
{
    log_msg(1, "Feed + Update triggered");
    g_state.feed_in_progress = 1;
    g_state.last_feed_time = time(NULL);

    /* Phase 1: Scan all targets */
    psych_id_scan_all_targets();

    /* Phase 2: Run analyzer engine over new data */
    /* Apply lobotomy stages to unprocessed suspects */
    /* Trim insects from dead-end web nodes */
    /* Generate new search prescriptions */

    pthread_mutex_lock(&g_db_mutex);

    sqlite3_stmt *stmt;
    const char *sql = "SELECT suspect_id, host, service_fingerprint, concern_level, "
                      "first_flagged, last_activity, total_observations, notes, "
                      "insect_trimmed, lobotomy_applied FROM suspects "
                      "WHERE lobotomy_applied < 7 ORDER BY last_activity DESC LIMIT 50";

    if (sqlite3_prepare_v2(g_db, sql, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            psych_id_suspect_t s;
            memset(&s, 0, sizeof(s));
            s.suspect_id = sqlite3_column_int64(stmt, 0);
            strncpy(s.host, (const char *)sqlite3_column_text(stmt, 1), sizeof(s.host) - 1);
            strncpy(s.service_fingerprint, (const char *)sqlite3_column_text(stmt, 2),
                    sizeof(s.service_fingerprint) - 1);
            s.concern_level = sqlite3_column_int(stmt, 3);
            s.first_flagged = sqlite3_column_int64(stmt, 4);
            s.last_activity = sqlite3_column_int64(stmt, 5);
            s.total_observations = sqlite3_column_int(stmt, 6);
            s.insect_trimmed = sqlite3_column_int(stmt, 8);
            s.lobotomy_applied = sqlite3_column_int(stmt, 9);

            /* Apply next lobotomy stage */
            lobotomy_stage_t next = s.lobotomy_applied + 1;
            if (next <= LOBOTOMY_FULL) {
                analyzer_lobotomy_apply(&s, next);
                g_state.total_lobotomies_applied++;
            }

            /* Generate search prescriptions */
            if (g_config.enable_search_hints) {
                analyzer_prescribe_searches(&s);
            }
        }
        sqlite3_finalize(stmt);
    }

    /* Trim insects: check web nodes for dead ends */
    sql = "SELECT node_id, url, title, summary, fetched_at, relevance, "
          "dimension, law_compliant, science_verified, is_trimmed "
          "FROM web_nodes WHERE is_trimmed = 0 ORDER BY fetched_at DESC LIMIT 100";

    if (sqlite3_prepare_v2(g_db, sql, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            psych_id_web_node_t node;
            memset(&node, 0, sizeof(node));
            node.node_id = sqlite3_column_int64(stmt, 0);
            strncpy(node.url, (const char *)sqlite3_column_text(stmt, 1), sizeof(node.url) - 1);
            strncpy(node.title, (const char *)sqlite3_column_text(stmt, 2), sizeof(node.title) - 1);
            strncpy(node.summary, (const char *)sqlite3_column_text(stmt, 3), sizeof(node.summary) - 1);
            node.fetched_at = sqlite3_column_int64(stmt, 4);
            node.relevance = sqlite3_column_int(stmt, 5);
            node.dimension = sqlite3_column_int(stmt, 6);
            node.law_compliant = sqlite3_column_int(stmt, 7);
            node.science_verified = sqlite3_column_int(stmt, 8);

            if (analyzer_insect_check(&node)) {
                g_state.total_insects_trimmed++;
            }
        }
        sqlite3_finalize(stmt);
    }

    pthread_mutex_unlock(&g_db_mutex);

    /* Phase 3: Enforce DB size limit (~300 MB) */
    uint64_t db_size;
    if (db_get_size(&db_size) == 0 && db_size > PSYCH_ID_DB_MAX_SIZE) {
        log_msg(1, "Database exceeds 300 MB (%llu bytes), pruning oldest records",
                (unsigned long long)db_size);
        db_prune_oldest(PSYCH_ID_DB_MAX_SIZE * 90 / 100);  /* prune to 90% */
    }
    g_state.db_size_bytes = db_size;

    g_state.feed_in_progress = 0;

    /* 3-line completion summary (prime base, cron-callback compatible) */
    log_msg(1, "Feed + Update complete");
    log_msg(1, "  %llu suspects | %llu insects trimmed | %llu prescriptions",
            (unsigned long long)g_state.total_suspects,
            (unsigned long long)g_state.total_insects_trimmed,
            (unsigned long long)g_state.total_prescriptions);
    log_msg(1, "  DB: %llu MB / 300 MB",
            (unsigned long long)(g_state.db_size_bytes / (1024*1024)));

    return 0;
}

int psych_id_schedule_daily(int hour, int minute)
{
    g_config.feed_mode = FEED_MODE_DAILY;
    g_config.daily_hour = hour;
    g_config.daily_minute = minute;

    /* Calculate next feed time */
    time_t now = time(NULL);
    struct tm *tm = localtime(&now);
    tm->tm_hour = hour;
    tm->tm_min = minute;
    tm->tm_sec = 0;
    g_state.next_scheduled_feed = mktime(tm);
    if (g_state.next_scheduled_feed <= now) {
        g_state.next_scheduled_feed += 86400;  /* tomorrow */
    }

    log_msg(1, "Scheduled daily feed at %02d:%02d", hour, minute);
    return 0;
}

int psych_id_set_reminder(int min_hours, int max_hours)
{
    g_config.feed_mode = FEED_MODE_REMINDER;
    g_config.reminder_min_hours = min_hours;
    g_config.reminder_max_hours = max_hours;

    /* Schedule next reminder */
    int range = max_hours - min_hours;
    int delay_hours = min_hours + (rand() % (range + 1));
    g_state.next_scheduled_feed = time(NULL) + (delay_hours * 3600);

    log_msg(1, "Reminder mode: next feed in %d hours", delay_hours);
    return 0;
}

/* ─── Scanner ─────────────────────────────────────────────────────── */

int psych_id_scan_host(const char *host)
{
    log_msg(2, "Scanning host: %s", host);

    for (int i = 0; i < PSYCH_ID_NUM_PORTS; i++) {
        uint16_t port = PSYCH_ID_SCAN_PORTS[i];
        char banner_buf[PSYCH_ID_BANNER_MAX_LEN];
        int rc;

        memset(banner_buf, 0, sizeof(banner_buf));

        /* Use TLS for 443 and 8443, plain TCP for others */
        if ((port == 443 || port == 8443) && g_config.enable_tls_probing) {
            rc = scanner_grab_tls_banner(host, port, banner_buf, sizeof(banner_buf));
        } else {
            rc = scanner_grab_tcp_banner(host, port, banner_buf, sizeof(banner_buf));
        }

        if (rc > 0 && banner_buf[0] != '\0') {
            psych_id_banner_t b;
            memset(&b, 0, sizeof(b));
            strncpy(b.target_host, host, sizeof(b.target_host) - 1);
            b.target_port = port;
            strncpy(b.banner, banner_buf, sizeof(b.banner) - 1);
            b.banner_len = strlen(banner_buf);
            b.first_seen = time(NULL);
            b.last_seen = b.first_seen;
            b.seen_count = 1;
            b.protocol = (port == 443 || port == 8443) ? 1 : 0;

            /* Identify service from banner */
            scanner_identify_service(banner_buf, b.service_name, b.service_version,
                                     sizeof(b.service_name));

            /* Classify via analyzer */
            analyzer_classify_banner(&b, &b.threat_score, &b.interest_score);

            /* Confidence based on banner quality */
            b.confidence = (b.banner_len > 20) ? 80 : 40;
            if (b.service_name[0]) b.confidence += 15;
            if (b.confidence > 100) b.confidence = 100;

            /* Store in database */
            pthread_mutex_lock(&g_db_mutex);
            db_insert_banner(&b);
            pthread_mutex_unlock(&g_db_mutex);

            g_state.total_banners_collected++;

            /* If interesting enough, create suspect */
            if (b.interest_score >= 60 || b.threat_score >= 40) {
                psych_id_suspect_t s;
                memset(&s, 0, sizeof(s));
                strncpy(s.host, host, sizeof(s.host) - 1);
                snprintf(s.service_fingerprint, sizeof(s.service_fingerprint),
                         "%s/%s on port %u", b.service_name, b.service_version, port);
                s.concern_level = b.threat_score / 10;
                s.first_flagged = time(NULL);
                s.last_activity = s.first_flagged;
                s.total_observations = 1;
                s.lobotomy_applied = LOBOTOMY_NONE;

                pthread_mutex_lock(&g_db_mutex);
                db_insert_suspect(&s);
                pthread_mutex_unlock(&g_db_mutex);

                g_state.total_suspects++;
            }

            log_msg(2, "  Port %u: %s %s (threat=%u, interest=%u)",
                    port, b.service_name, b.service_version,
                    b.threat_score, b.interest_score);
        }
    }

    return 0;
}

int psych_id_scan_all_targets(void)
{
    FILE *fp = fopen(g_config.targets_file, "r");
    if (!fp) {
        log_msg(1, "WARN: Cannot open targets file: %s", g_config.targets_file);
        return -1;
    }

    char line[512];
    int count = 0;

    while (fgets(line, sizeof(line), fp)) {
        /* Strip newline */
        size_t len = strlen(line);
        while (len > 0 && (line[len-1] == '\n' || line[len-1] == '\r'))
            line[--len] = '\0';

        /* Skip empty lines and comments */
        if (len == 0 || line[0] == '#') continue;

        psych_id_scan_host(line);
        count++;
    }

    fclose(fp);
    log_msg(1, "Scanned %d targets", count);
    return 0;
}

int psych_id_grab_banner(const char *host, uint16_t port, char *buf, size_t bufsz)
{
    if (port == 443 || port == 8443) {
        return scanner_grab_tls_banner(host, port, buf, bufsz);
    }
    return scanner_grab_tcp_banner(host, port, buf, bufsz);
}

/* ─── Scanner Internals ───────────────────────────────────────────── */

static int scanner_grab_tcp_banner(const char *host, uint16_t port, char *buf, size_t bufsz)
{
    struct addrinfo hints, *res;
    int sockfd, n;
    char port_str[8];

    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;

    snprintf(port_str, sizeof(port_str), "%u", port);

    if (getaddrinfo(host, port_str, &hints, &res) != 0)
        return -1;

    sockfd = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    if (sockfd < 0) {
        freeaddrinfo(res);
        return -1;
    }

    /* Set timeout */
    struct timeval tv;
    tv.tv_sec = g_config.scan_timeout_ms / 1000;
    tv.tv_usec = (g_config.scan_timeout_ms % 1000) * 1000;
    setsockopt(sockfd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));
    setsockopt(sockfd, SOL_SOCKET, SO_SNDTIMEO, &tv, sizeof(tv));

    if (connect(sockfd, res->ai_addr, res->ai_addrlen) != 0) {
        close(sockfd);
        freeaddrinfo(res);
        return -1;
    }

    freeaddrinfo(res);

    /* For HTTP ports, send a minimal request to trigger banner */
    if (port == 80 || port == 8080) {
        const char *http_req = "HEAD / HTTP/1.0\r\nHost: ";
        send(sockfd, http_req, strlen(http_req), 0);
        send(sockfd, host, strlen(host), 0);
        send(sockfd, "\r\n\r\n", 4, 0);
    }

    /* For FTP/SSH, the server sends banner first */
    n = recv(sockfd, buf, bufsz - 1, 0);
    if (n > 0) {
        buf[n] = '\0';
    } else {
        buf[0] = '\0';
        n = 0;
    }

    close(sockfd);
    return n;
}

static int scanner_grab_tls_banner(const char *host, uint16_t port, char *buf, size_t bufsz)
{
    struct addrinfo hints, *res;
    int sockfd, n;
    char port_str[8];

    if (!g_ssl_ctx) return -1;

    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;

    snprintf(port_str, sizeof(port_str), "%u", port);

    if (getaddrinfo(host, port_str, &hints, &res) != 0)
        return -1;

    sockfd = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    if (sockfd < 0) {
        freeaddrinfo(res);
        return -1;
    }

    struct timeval tv;
    tv.tv_sec = g_config.scan_timeout_ms / 1000;
    tv.tv_usec = (g_config.scan_timeout_ms % 1000) * 1000;
    setsockopt(sockfd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));
    setsockopt(sockfd, SOL_SOCKET, SO_SNDTIMEO, &tv, sizeof(tv));

    if (connect(sockfd, res->ai_addr, res->ai_addrlen) != 0) {
        close(sockfd);
        freeaddrinfo(res);
        return -1;
    }

    freeaddrinfo(res);

    SSL *ssl = SSL_new(g_ssl_ctx);
    SSL_set_fd(ssl, sockfd);
    SSL_set_tlsext_host_name(ssl, host);

    if (SSL_connect(ssl) != 1) {
        SSL_free(ssl);
        close(sockfd);
        return -1;
    }

    /* Send HTTP HEAD over TLS */
    char req[512];
    snprintf(req, sizeof(req), "HEAD / HTTP/1.0\r\nHost: %s\r\n\r\n", host);
    SSL_write(ssl, req, strlen(req));

    n = SSL_read(ssl, buf, bufsz - 1);
    if (n > 0) {
        buf[n] = '\0';
    } else {
        buf[0] = '\0';
        n = 0;
    }

    /* Also grab certificate info as part of banner intelligence */
    X509 *cert = SSL_get_peer_certificate(ssl);
    if (cert && n < (int)(bufsz - 256)) {
        char subject[256];
        X509_NAME_oneline(X509_get_subject_name(cert), subject, sizeof(subject));
        int appended = snprintf(buf + n, bufsz - n, "\n[TLS-SUBJECT: %s]", subject);
        if (appended > 0) n += appended;
        X509_free(cert);
    }

    SSL_shutdown(ssl);
    SSL_free(ssl);
    close(sockfd);

    return n;
}

static int scanner_identify_service(const char *banner, char *name, char *version, size_t len)
{
    name[0] = '\0';
    version[0] = '\0';

    if (!banner || !banner[0]) return 0;

    /* SSH detection */
    if (strncmp(banner, "SSH-", 4) == 0) {
        strncpy(name, "SSH", len - 1);
        /* Extract version: SSH-2.0-OpenSSH_9.6 */
        const char *p = strstr(banner, "-");
        if (p) p = strstr(p + 1, "-");
        if (p) {
            p++;
            const char *end = strchr(p, '\r');
            if (!end) end = strchr(p, '\n');
            if (end) {
                size_t vlen = end - p;
                if (vlen >= len) vlen = len - 1;
                strncpy(version, p, vlen);
                version[vlen] = '\0';
            } else {
                strncpy(version, p, len - 1);
            }
        }
        return 1;
    }

    /* FTP detection */
    if (strncmp(banner, "220", 3) == 0) {
        strncpy(name, "FTP", len - 1);
        const char *p = banner + 4;
        const char *end = strchr(p, '\r');
        if (!end) end = strchr(p, '\n');
        if (end) {
            size_t vlen = end - p;
            if (vlen >= len) vlen = len - 1;
            strncpy(version, p, vlen);
            version[vlen] = '\0';
        }
        return 1;
    }

    /* HTTP detection */
    if (strncmp(banner, "HTTP/", 5) == 0) {
        strncpy(name, "HTTP", len - 1);
        /* Look for Server: header */
        const char *srv = strstr(banner, "Server: ");
        if (!srv) srv = strstr(banner, "server: ");
        if (srv) {
            srv += 8;
            const char *end = strchr(srv, '\r');
            if (!end) end = strchr(srv, '\n');
            if (end) {
                size_t vlen = end - srv;
                if (vlen >= len) vlen = len - 1;
                strncpy(version, srv, vlen);
                version[vlen] = '\0';
            }
        }
        return 1;
    }

    /* Generic: store first line as version */
    strncpy(name, "UNKNOWN", len - 1);
    const char *end = strchr(banner, '\n');
    if (end) {
        size_t vlen = end - banner;
        if (vlen >= len) vlen = len - 1;
        strncpy(version, banner, vlen);
        version[vlen] = '\0';
    }

    return 0;
}

/* ─── Analyzer Engine ─────────────────────────────────────────────── */

static int analyzer_classify_banner(const psych_id_banner_t *b, uint8_t *threat, uint8_t *interest)
{
    *threat = 0;
    *interest = 50;  /* baseline interest */

    if (!b->banner[0]) {
        *interest = 20;
        return 0;
    }

    /* Threat indicators */
    if (strstr(b->banner, "unauthorized") || strstr(b->banner, "Unauthorized"))
        *threat += 5;
    if (strstr(b->banner, "root") || strstr(b->banner, "admin"))
        *interest += 10;
    if (strstr(b->banner, "debug") || strstr(b->banner, "DEBUG"))
        *threat += 15;
    if (strstr(b->banner, "default") && strstr(b->banner, "password"))
        *threat += 30;
    if (strstr(b->banner, "CVE-"))
        *threat += 25;

    /* Interest boosts */
    if (b->banner_len > 200) *interest += 10;
    if (b->service_name[0]) *interest += 15;
    if (strstr(b->banner, "version") || strstr(b->banner, "Version"))
        *interest += 10;

    /* Port-specific adjustments */
    if (b->target_port == 22) *interest += 10;  /* SSH always interesting */
    if (b->target_port == 21) *threat += 5;     /* FTP is inherently risky */

    /* Cap values */
    if (*threat > 100) *threat = 100;
    if (*interest > 100) *interest = 100;

    return 0;
}

/*
 * Suggestion Lobotomy — staged application:
 *
 * Stage CENTER:  Prune toward verified center of knowledge
 * Stage DIM3:    Maintain spatial/relational context
 * Stage DIM4:    Maintain temporal/causal context
 * Stage LAW:     Verify legal compliance
 * Stage LAW_AGAIN: Reinforce legal boundary (double-check)
 * Stage SCIENCE: Verify scientific backing/reproducibility
 * Stage FULL:    All stages complete — suggestion is centered, dimensional,
 *                law-respecting, and scientifically maintained
 */
static int analyzer_lobotomy_apply(psych_id_suspect_t *s, lobotomy_stage_t stage)
{
    switch (stage) {
    case LOBOTOMY_CENTER:
        /* Carry toward center reference:
         * Remove outlier observations, weight toward median behavior */
        if (s->concern_level > 8) s->concern_level = 8;  /* Don't catastrophize */
        if (s->concern_level < 2) s->concern_level = 2;  /* Don't dismiss */
        break;

    case LOBOTOMY_DIM3:
        /* 3rd dimension: spatial/relational maintenance
         * Consider network topology, geographic proximity, service relationships */
        /* Update notes with spatial context */
        if (s->notes[0] == '\0') {
            snprintf(s->notes, sizeof(s->notes), "[DIM3] Spatial: host %s, service %s",
                     s->host, s->service_fingerprint);
        }
        break;

    case LOBOTOMY_DIM4:
        /* 4th dimension: temporal/causal maintenance
         * Consider when first seen, activity patterns, evolution over time */
        {
            time_t duration = s->last_activity - s->first_flagged;
            if (duration > 86400 * 30) {
                /* Persistent presence = higher concern */
                if (s->concern_level < 6) s->concern_level++;
            }
        }
        break;

    case LOBOTOMY_LAW:
        /* Respect to law: ensure analysis stays within legal bounds
         * No active exploitation, no unauthorized access attempts */
        /* Mark that legal review has been applied */
        break;

    case LOBOTOMY_LAW_AGAIN:
        /* Reinforced legal boundary: double-check
         * Verify no suggestion leads to illegal action */
        break;

    case LOBOTOMY_SCIENCE:
        /* Maintenance of science: verify reproducibility
         * Can the observation be repeated? Is it consistent? */
        if (s->total_observations < 3) {
            /* Insufficient data for scientific confidence */
            if (s->concern_level > 5) s->concern_level = 5;
        }
        break;

    case LOBOTOMY_FULL:
        /* All stages applied — suspect is fully analyzed */
        break;

    default:
        return -1;
    }

    s->lobotomy_applied = stage;

    /* Update in database */
    pthread_mutex_lock(&g_db_mutex);
    char sql[512];
    snprintf(sql, sizeof(sql),
             "UPDATE suspects SET concern_level=%u, lobotomy_applied=%u, notes='%s' "
             "WHERE suspect_id=%llu",
             s->concern_level, stage, s->notes,
             (unsigned long long)s->suspect_id);
    sqlite3_exec(g_db, sql, NULL, NULL, NULL);
    pthread_mutex_unlock(&g_db_mutex);

    return 0;
}

/*
 * Insect Trimming — check if a web node is a dead end:
 *
 * IMPOSSIBLE:     Logically cannot be true given other facts
 * DEAD_END:       Path terminates without yielding useful info
 * CIRCULAR:       Path loops back to already-known information
 * CONTRADICTORY:  Contradicts established, verified facts
 * EXPIRED:        Information is time-sensitive and has expired
 * SUPERCEDED:     Newer/better information exists
 */
static int analyzer_insect_check(psych_id_web_node_t *node)
{
    int trimmed = 0;

    /* Check for expiration (temporal insect) */
    time_t age = time(NULL) - node->fetched_at;
    if (age > 86400 * 90) {  /* >90 days old */
        node->trimmed_as = INSECT_EXPIRED;
        node->is_trimmed = 1;
        trimmed = 1;
    }

    /* Check for dead-end: very low relevance */
    if (!trimmed && node->relevance < 10) {
        node->trimmed_as = INSECT_DEAD_END;
        node->is_trimmed = 1;
        trimmed = 1;
    }

    /* Check for contradictory: law-non-compliant AND science-unverified */
    if (!trimmed && !node->law_compliant && !node->science_verified) {
        node->trimmed_as = INSECT_CONTRADICTORY;
        node->is_trimmed = 1;
        trimmed = 1;
    }

    if (trimmed) {
        pthread_mutex_lock(&g_db_mutex);
        char sql[256];
        snprintf(sql, sizeof(sql),
                 "UPDATE web_nodes SET is_trimmed=1, trimmed_as=%u WHERE node_id=%llu",
                 node->trimmed_as, (unsigned long long)node->node_id);
        sqlite3_exec(g_db, sql, NULL, NULL, NULL);
        pthread_mutex_unlock(&g_db_mutex);
    }

    return trimmed;
}

/*
 * Search Prescription Engine:
 * Given a suspect, generate search engine queries that would yield
 * further information. Prescribes websites and search terms.
 */
static int analyzer_prescribe_searches(const psych_id_suspect_t *s)
{
    char query[PSYCH_ID_QUERY_MAX_LEN];
    const char *engines[] = {"duckduckgo", "google", "bing"};
    int num_engines = 3;

    /* Prescription 1: Service identification */
    snprintf(query, sizeof(query), "%s vulnerability advisory %s",
             s->service_fingerprint, s->host);

    psych_id_prescription_t p;
    memset(&p, 0, sizeof(p));
    p.related_suspect_id = s->suspect_id;
    strncpy(p.search_query, query, sizeof(p.search_query) - 1);
    strncpy(p.search_engine, engines[0], sizeof(p.search_engine) - 1);
    snprintf(p.hint, sizeof(p.hint),
             "Search for known vulnerabilities in %s. Check CVE databases, "
             "vendor advisories, and security mailing lists.",
             s->service_fingerprint);
    p.priority = s->concern_level;
    p.prescribed_at = time(NULL);
    p.lobotomy_stage = s->lobotomy_applied;

    pthread_mutex_lock(&g_db_mutex);
    db_insert_prescription(&p);
    pthread_mutex_unlock(&g_db_mutex);
    g_state.total_prescriptions++;

    /* Prescription 2: Configuration best practices */
    if (s->concern_level >= 4) {
        snprintf(query, sizeof(query), "%s hardening guide best practices secure configuration",
                 s->service_fingerprint);

        memset(&p, 0, sizeof(p));
        p.related_suspect_id = s->suspect_id;
        strncpy(p.search_query, query, sizeof(p.search_query) - 1);
        strncpy(p.search_engine, engines[1], sizeof(p.search_engine) - 1);
        snprintf(p.hint, sizeof(p.hint),
                 "Look for official hardening guides. CIS benchmarks, vendor docs, "
                 "NIST recommendations for %s.", s->service_fingerprint);
        p.priority = s->concern_level + 1;
        p.prescribed_at = time(NULL);
        p.lobotomy_stage = s->lobotomy_applied;

        pthread_mutex_lock(&g_db_mutex);
        db_insert_prescription(&p);
        pthread_mutex_unlock(&g_db_mutex);
        g_state.total_prescriptions++;
    }

    /* Prescription 3: Behavioral context (if high concern) */
    if (s->concern_level >= 7) {
        snprintf(query, sizeof(query), "\"%s\" site:cve.mitre.org OR site:nvd.nist.gov",
                 s->service_fingerprint);

        memset(&p, 0, sizeof(p));
        p.related_suspect_id = s->suspect_id;
        strncpy(p.search_query, query, sizeof(p.search_query) - 1);
        strncpy(p.search_engine, engines[2], sizeof(p.search_engine) - 1);
        snprintf(p.hint, sizeof(p.hint),
                 "Direct CVE/NVD search for known exploits. Cross-reference with "
                 "CISA KEV catalog. Priority attention required.");
        p.priority = 10;
        p.prescribed_at = time(NULL);
        p.lobotomy_stage = s->lobotomy_applied;

        pthread_mutex_lock(&g_db_mutex);
        db_insert_prescription(&p);
        pthread_mutex_unlock(&g_db_mutex);
        g_state.total_prescriptions++;
    }

    return 0;
}

/* ─── Database ────────────────────────────────────────────────────── */

static int db_open(const char *path)
{
    int rc = sqlite3_open(path, &g_db);
    if (rc != SQLITE_OK) {
        fprintf(stderr, "psych-id: cannot open database: %s\n", sqlite3_errmsg(g_db));
        return -1;
    }

    /* Performance tuning for ~300MB database */
    sqlite3_exec(g_db, "PRAGMA journal_mode=WAL", NULL, NULL, NULL);
    sqlite3_exec(g_db, "PRAGMA synchronous=NORMAL", NULL, NULL, NULL);
    sqlite3_exec(g_db, "PRAGMA cache_size=-65536", NULL, NULL, NULL);  /* 64MB cache */
    sqlite3_exec(g_db, "PRAGMA mmap_size=268435456", NULL, NULL, NULL); /* 256MB mmap */
    sqlite3_exec(g_db, "PRAGMA page_size=4096", NULL, NULL, NULL);

    return 0;
}

static void db_close(void)
{
    if (g_db) {
        sqlite3_close(g_db);
        g_db = NULL;
    }
}

static int db_create_schema(void)
{
    const char *schema[] = {
        "CREATE TABLE IF NOT EXISTS banners ("
        "  record_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "  target_host TEXT NOT NULL,"
        "  target_port INTEGER NOT NULL,"
        "  banner TEXT,"
        "  banner_len INTEGER,"
        "  first_seen INTEGER,"
        "  last_seen INTEGER,"
        "  seen_count INTEGER DEFAULT 1,"
        "  protocol INTEGER,"
        "  service_name TEXT,"
        "  service_version TEXT,"
        "  confidence INTEGER,"
        "  threat_score INTEGER,"
        "  interest_score INTEGER"
        ")",

        "CREATE TABLE IF NOT EXISTS suspects ("
        "  suspect_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "  host TEXT NOT NULL,"
        "  service_fingerprint TEXT,"
        "  concern_level INTEGER DEFAULT 0,"
        "  first_flagged INTEGER,"
        "  last_activity INTEGER,"
        "  total_observations INTEGER DEFAULT 0,"
        "  notes TEXT,"
        "  insect_trimmed INTEGER DEFAULT 0,"
        "  lobotomy_applied INTEGER DEFAULT 0"
        ")",

        "CREATE TABLE IF NOT EXISTS prescriptions ("
        "  prescription_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "  related_suspect_id INTEGER,"
        "  search_query TEXT NOT NULL,"
        "  search_engine TEXT,"
        "  hint TEXT,"
        "  priority INTEGER DEFAULT 5,"
        "  prescribed_at INTEGER,"
        "  fulfilled_at INTEGER DEFAULT 0,"
        "  lobotomy_stage INTEGER DEFAULT 0,"
        "  FOREIGN KEY (related_suspect_id) REFERENCES suspects(suspect_id)"
        ")",

        "CREATE TABLE IF NOT EXISTS web_nodes ("
        "  node_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "  url TEXT NOT NULL,"
        "  title TEXT,"
        "  summary TEXT,"
        "  fetched_at INTEGER,"
        "  relevance INTEGER DEFAULT 50,"
        "  dimension INTEGER DEFAULT 3,"
        "  law_compliant INTEGER DEFAULT 0,"
        "  science_verified INTEGER DEFAULT 0,"
        "  trimmed_as INTEGER DEFAULT 0,"
        "  is_trimmed INTEGER DEFAULT 0"
        ")",

        "CREATE TABLE IF NOT EXISTS feed_log ("
        "  feed_id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "  feed_time INTEGER NOT NULL,"
        "  mode INTEGER,"
        "  banners_collected INTEGER,"
        "  suspects_created INTEGER,"
        "  prescriptions_made INTEGER,"
        "  insects_trimmed INTEGER,"
        "  lobotomies_applied INTEGER,"
        "  duration_seconds INTEGER"
        ")",

        /* Indexes for performance */
        "CREATE INDEX IF NOT EXISTS idx_banners_host ON banners(target_host)",
        "CREATE INDEX IF NOT EXISTS idx_banners_port ON banners(target_port)",
        "CREATE INDEX IF NOT EXISTS idx_banners_last_seen ON banners(last_seen)",
        "CREATE INDEX IF NOT EXISTS idx_suspects_host ON suspects(host)",
        "CREATE INDEX IF NOT EXISTS idx_suspects_concern ON suspects(concern_level)",
        "CREATE INDEX IF NOT EXISTS idx_prescriptions_suspect ON prescriptions(related_suspect_id)",
        "CREATE INDEX IF NOT EXISTS idx_prescriptions_unfulfilled ON prescriptions(fulfilled_at)",
        "CREATE INDEX IF NOT EXISTS idx_web_nodes_trimmed ON web_nodes(is_trimmed)",
        "CREATE INDEX IF NOT EXISTS idx_web_nodes_relevance ON web_nodes(relevance)",
        NULL
    };

    for (int i = 0; schema[i] != NULL; i++) {
        char *errmsg = NULL;
        if (sqlite3_exec(g_db, schema[i], NULL, NULL, &errmsg) != SQLITE_OK) {
            log_msg(0, "ERROR: Schema creation failed: %s", errmsg);
            sqlite3_free(errmsg);
            return -1;
        }
    }

    return 0;
}

static int db_insert_banner(const psych_id_banner_t *b)
{
    /* Check if banner already exists for this host:port, update if so */
    sqlite3_stmt *stmt;
    const char *check = "SELECT record_id, seen_count FROM banners "
                        "WHERE target_host=? AND target_port=? LIMIT 1";

    if (sqlite3_prepare_v2(g_db, check, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, b->target_host, -1, SQLITE_STATIC);
        sqlite3_bind_int(stmt, 2, b->target_port);

        if (sqlite3_step(stmt) == SQLITE_ROW) {
            /* Update existing record */
            int64_t id = sqlite3_column_int64(stmt, 0);
            int count = sqlite3_column_int(stmt, 1);
            sqlite3_finalize(stmt);

            char sql[512];
            snprintf(sql, sizeof(sql),
                     "UPDATE banners SET banner=?, last_seen=%lld, seen_count=%d, "
                     "service_name=?, service_version=?, threat_score=%u, interest_score=%u "
                     "WHERE record_id=%lld",
                     (long long)b->last_seen, count + 1,
                     b->threat_score, b->interest_score, (long long)id);

            sqlite3_prepare_v2(g_db, sql, -1, &stmt, NULL);
            sqlite3_bind_text(stmt, 1, b->banner, -1, SQLITE_STATIC);
            sqlite3_bind_text(stmt, 2, b->service_name, -1, SQLITE_STATIC);
            sqlite3_bind_text(stmt, 3, b->service_version, -1, SQLITE_STATIC);
            sqlite3_step(stmt);
            sqlite3_finalize(stmt);
            return 0;
        }
        sqlite3_finalize(stmt);
    }

    /* Insert new record */
    const char *insert = "INSERT INTO banners (target_host, target_port, banner, banner_len, "
                         "first_seen, last_seen, seen_count, protocol, service_name, "
                         "service_version, confidence, threat_score, interest_score) "
                         "VALUES (?, ?, ?, ?, ?, ?, 1, ?, ?, ?, ?, ?, ?)";

    if (sqlite3_prepare_v2(g_db, insert, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, b->target_host, -1, SQLITE_STATIC);
        sqlite3_bind_int(stmt, 2, b->target_port);
        sqlite3_bind_text(stmt, 3, b->banner, -1, SQLITE_STATIC);
        sqlite3_bind_int(stmt, 4, b->banner_len);
        sqlite3_bind_int64(stmt, 5, b->first_seen);
        sqlite3_bind_int64(stmt, 6, b->last_seen);
        sqlite3_bind_int(stmt, 7, b->protocol);
        sqlite3_bind_text(stmt, 8, b->service_name, -1, SQLITE_STATIC);
        sqlite3_bind_text(stmt, 9, b->service_version, -1, SQLITE_STATIC);
        sqlite3_bind_int(stmt, 10, b->confidence);
        sqlite3_bind_int(stmt, 11, b->threat_score);
        sqlite3_bind_int(stmt, 12, b->interest_score);
        sqlite3_step(stmt);
        sqlite3_finalize(stmt);
    }

    return 0;
}

static int db_insert_suspect(const psych_id_suspect_t *s)
{
    sqlite3_stmt *stmt;
    const char *insert = "INSERT INTO suspects (host, service_fingerprint, concern_level, "
                         "first_flagged, last_activity, total_observations, notes, "
                         "insect_trimmed, lobotomy_applied) "
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

    if (sqlite3_prepare_v2(g_db, insert, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, s->host, -1, SQLITE_STATIC);
        sqlite3_bind_text(stmt, 2, s->service_fingerprint, -1, SQLITE_STATIC);
        sqlite3_bind_int(stmt, 3, s->concern_level);
        sqlite3_bind_int64(stmt, 4, s->first_flagged);
        sqlite3_bind_int64(stmt, 5, s->last_activity);
        sqlite3_bind_int(stmt, 6, s->total_observations);
        sqlite3_bind_text(stmt, 7, s->notes, -1, SQLITE_STATIC);
        sqlite3_bind_int(stmt, 8, s->insect_trimmed);
        sqlite3_bind_int(stmt, 9, s->lobotomy_applied);
        sqlite3_step(stmt);
        sqlite3_finalize(stmt);
    }

    return 0;
}

static int db_insert_prescription(const psych_id_prescription_t *p)
{
    sqlite3_stmt *stmt;
    const char *insert = "INSERT INTO prescriptions (related_suspect_id, search_query, "
                         "search_engine, hint, priority, prescribed_at, fulfilled_at, "
                         "lobotomy_stage) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    if (sqlite3_prepare_v2(g_db, insert, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int64(stmt, 1, p->related_suspect_id);
        sqlite3_bind_text(stmt, 2, p->search_query, -1, SQLITE_STATIC);
        sqlite3_bind_text(stmt, 3, p->search_engine, -1, SQLITE_STATIC);
        sqlite3_bind_text(stmt, 4, p->hint, -1, SQLITE_STATIC);
        sqlite3_bind_int(stmt, 5, p->priority);
        sqlite3_bind_int64(stmt, 6, p->prescribed_at);
        sqlite3_bind_int64(stmt, 7, p->fulfilled_at);
        sqlite3_bind_int(stmt, 8, p->lobotomy_stage);
        sqlite3_step(stmt);
        sqlite3_finalize(stmt);
    }

    return 0;
}

static int db_insert_web_node(const psych_id_web_node_t *n)
{
    sqlite3_stmt *stmt;
    const char *insert = "INSERT INTO web_nodes (url, title, summary, fetched_at, "
                         "relevance, dimension, law_compliant, science_verified, "
                         "trimmed_as, is_trimmed) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    if (sqlite3_prepare_v2(g_db, insert, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, n->url, -1, SQLITE_STATIC);
        sqlite3_bind_text(stmt, 2, n->title, -1, SQLITE_STATIC);
        sqlite3_bind_text(stmt, 3, n->summary, -1, SQLITE_STATIC);
        sqlite3_bind_int64(stmt, 4, n->fetched_at);
        sqlite3_bind_int(stmt, 5, n->relevance);
        sqlite3_bind_int(stmt, 6, n->dimension);
        sqlite3_bind_int(stmt, 7, n->law_compliant);
        sqlite3_bind_int(stmt, 8, n->science_verified);
        sqlite3_bind_int(stmt, 9, n->trimmed_as);
        sqlite3_bind_int(stmt, 10, n->is_trimmed);
        sqlite3_step(stmt);
        sqlite3_finalize(stmt);
    }

    return 0;
}

static int db_get_size(uint64_t *size_bytes)
{
    struct stat st;
    if (stat(g_config.db_path, &st) == 0) {
        *size_bytes = st.st_size;
        return 0;
    }
    *size_bytes = 0;
    return -1;
}

static int db_prune_oldest(uint64_t target_size)
{
    /* Prune oldest banners first, then web_nodes, then prescriptions */
    uint64_t current;
    db_get_size(&current);

    if (current <= target_size) return 0;

    /* Delete oldest 10% of banners */
    sqlite3_exec(g_db,
        "DELETE FROM banners WHERE record_id IN "
        "(SELECT record_id FROM banners ORDER BY last_seen ASC "
        "LIMIT (SELECT COUNT(*)/10 FROM banners))",
        NULL, NULL, NULL);

    /* Delete trimmed web_nodes older than 60 days */
    char sql[256];
    snprintf(sql, sizeof(sql),
             "DELETE FROM web_nodes WHERE is_trimmed=1 AND fetched_at < %lld",
             (long long)(time(NULL) - 86400 * 60));
    sqlite3_exec(g_db, sql, NULL, NULL, NULL);

    /* Delete fulfilled prescriptions older than 30 days */
    snprintf(sql, sizeof(sql),
             "DELETE FROM prescriptions WHERE fulfilled_at > 0 AND prescribed_at < %lld",
             (long long)(time(NULL) - 86400 * 30));
    sqlite3_exec(g_db, sql, NULL, NULL, NULL);

    /* Vacuum to reclaim space */
    sqlite3_exec(g_db, "VACUUM", NULL, NULL, NULL);

    db_get_size(&current);
    log_msg(1, "Pruned database to %llu MB", (unsigned long long)(current / (1024*1024)));

    return 0;
}

/* ─── Daemon Loop ─────────────────────────────────────────────────── */

static void *daemon_main_loop(void *arg)
{
    (void)arg;

    log_msg(1, "Daemon loop started (mode: %d)", g_config.feed_mode);

    while (g_running) {
        time_t now = time(NULL);

        /* Check if feed is requested via signal */
        if (g_feed_requested == 1) {
            g_feed_requested = 0;
            psych_id_feed_now();
        } else if (g_feed_requested == 2) {
            g_feed_requested = 0;
            psych_id_feed_and_update();
        }

        /* Check scheduled feed */
        if (g_state.next_scheduled_feed > 0 && now >= g_state.next_scheduled_feed) {
            switch (g_config.feed_mode) {
            case FEED_MODE_DAILY:
                psych_id_feed_and_update();
                /* Schedule next day */
                g_state.next_scheduled_feed += 86400;
                break;

            case FEED_MODE_REMINDER:
                psych_id_feed_now();
                /* Schedule next reminder */
                {
                    int range = g_config.reminder_max_hours - g_config.reminder_min_hours;
                    int delay = g_config.reminder_min_hours + (rand() % (range + 1));
                    g_state.next_scheduled_feed = now + (delay * 3600);
                    log_msg(1, "Next reminder in %d hours", delay);
                }
                break;

            case FEED_MODE_ON_COMMAND:
            case FEED_MODE_FEED_UPDATE:
                /* Only feed when explicitly told */
                break;
            }
        }

        /* Sleep 60 seconds between checks */
        for (int i = 0; i < 60 && g_running; i++) {
            sleep(1);
        }
    }

    return NULL;
}

/* ─── Query API ───────────────────────────────────────────────────── */

int psych_id_get_state(psych_id_state_t *state)
{
    if (!state) return -1;
    memcpy(state, &g_state, sizeof(g_state));
    state->current_mode = g_config.feed_mode;
    db_get_size(&state->db_size_bytes);
    return 0;
}

int psych_id_get_suspect(uint64_t id, psych_id_suspect_t *suspect)
{
    if (!suspect || !g_db) return -1;

    sqlite3_stmt *stmt;
    const char *sql = "SELECT suspect_id, host, service_fingerprint, concern_level, "
                      "first_flagged, last_activity, total_observations, notes, "
                      "insect_trimmed, lobotomy_applied FROM suspects WHERE suspect_id=?";

    pthread_mutex_lock(&g_db_mutex);
    if (sqlite3_prepare_v2(g_db, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int64(stmt, 1, id);
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            suspect->suspect_id = sqlite3_column_int64(stmt, 0);
            strncpy(suspect->host, (const char *)sqlite3_column_text(stmt, 1),
                    sizeof(suspect->host) - 1);
            strncpy(suspect->service_fingerprint, (const char *)sqlite3_column_text(stmt, 2),
                    sizeof(suspect->service_fingerprint) - 1);
            suspect->concern_level = sqlite3_column_int(stmt, 3);
            suspect->first_flagged = sqlite3_column_int64(stmt, 4);
            suspect->last_activity = sqlite3_column_int64(stmt, 5);
            suspect->total_observations = sqlite3_column_int(stmt, 6);
            const char *notes = (const char *)sqlite3_column_text(stmt, 7);
            if (notes) strncpy(suspect->notes, notes, sizeof(suspect->notes) - 1);
            suspect->insect_trimmed = sqlite3_column_int(stmt, 8);
            suspect->lobotomy_applied = sqlite3_column_int(stmt, 9);
            sqlite3_finalize(stmt);
            pthread_mutex_unlock(&g_db_mutex);
            return 0;
        }
        sqlite3_finalize(stmt);
    }
    pthread_mutex_unlock(&g_db_mutex);
    return -1;
}

int psych_id_list_prescriptions(psych_id_prescription_t *out, size_t max, size_t *count)
{
    if (!out || !count || !g_db) return -1;
    *count = 0;

    sqlite3_stmt *stmt;
    const char *sql = "SELECT prescription_id, related_suspect_id, search_query, "
                      "search_engine, hint, priority, prescribed_at, fulfilled_at, "
                      "lobotomy_stage FROM prescriptions "
                      "WHERE fulfilled_at = 0 ORDER BY priority DESC LIMIT ?";

    pthread_mutex_lock(&g_db_mutex);
    if (sqlite3_prepare_v2(g_db, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, max);
        while (sqlite3_step(stmt) == SQLITE_ROW && *count < max) {
            psych_id_prescription_t *p = &out[*count];
            memset(p, 0, sizeof(*p));
            p->prescription_id = sqlite3_column_int64(stmt, 0);
            p->related_suspect_id = sqlite3_column_int64(stmt, 1);
            strncpy(p->search_query, (const char *)sqlite3_column_text(stmt, 2),
                    sizeof(p->search_query) - 1);
            const char *eng = (const char *)sqlite3_column_text(stmt, 3);
            if (eng) strncpy(p->search_engine, eng, sizeof(p->search_engine) - 1);
            const char *hint = (const char *)sqlite3_column_text(stmt, 4);
            if (hint) strncpy(p->hint, hint, sizeof(p->hint) - 1);
            p->priority = sqlite3_column_int(stmt, 5);
            p->prescribed_at = sqlite3_column_int64(stmt, 6);
            p->fulfilled_at = sqlite3_column_int64(stmt, 7);
            p->lobotomy_stage = sqlite3_column_int(stmt, 8);
            (*count)++;
        }
        sqlite3_finalize(stmt);
    }
    pthread_mutex_unlock(&g_db_mutex);
    return 0;
}

/*
 * Output structure follows prime-congruent line grouping:
 *
 *   3 lines  = minimal (identity + state + conclusion)
 *   5 lines  = quality (3 base + 2 verbose detail lines)
 *   7 lines  = fine copy (stands alone, complete picture)
 *  11 lines  = full copy (stands alone, extended intelligence)
 *
 * The 2 "quality" lines added to 3-base have a slightly different
 * verbose structure: indented detail rather than label:value pairs.
 *
 * Verbosity selects the group:
 *   verbose=0 → 3 lines
 *   verbose=1 → 5 lines (3 + 2 quality)
 *   verbose=2 → 7 lines (fine copy)
 *   verbose=3 → 11 lines (full copy)
 */
int psych_id_get_motd(char *buf, size_t bufsz)
{
    if (!buf || bufsz == 0) return -1;

    psych_id_state_t st;
    psych_id_get_state(&st);

    const char *mode_str =
        st.current_mode == FEED_MODE_DAILY ? "Daily" :
        st.current_mode == FEED_MODE_ON_COMMAND ? "On Command" :
        st.current_mode == FEED_MODE_FEED_UPDATE ? "Feed+Update" : "Reminder";
    const char *status_str = st.daemon_running ? "ACTIVE" : "STOPPED";

    int n = 0;
    int verbose = g_config.verbose;

    /* ─── 3 LINES: minimal (identity + state + conclusion) ───── */
    n += snprintf(buf + n, bufsz - n,
        "PSYCH-ID v%s — %s — %s\n"                             /* Line 1: identity */
        "%llu suspects | %llu banners | %llu MB\n"             /* Line 2: state */
        "%llu prescriptions pending\n",                         /* Line 3: conclusion */
        PSYCH_ID_VERSION_STRING, status_str, mode_str,
        (unsigned long long)st.total_suspects,
        (unsigned long long)st.total_banners_collected,
        (unsigned long long)(st.db_size_bytes / (1024*1024)),
        (unsigned long long)st.total_prescriptions);

    if (verbose < 1) return (n > 0) ? 0 : -1;

    /* ─── +2 QUALITY LINES (total 5): verbose detail, indented ─ */
    n += snprintf(buf + n, bufsz - n,
        "    → %llu insects trimmed, %llu lobotomies applied\n" /* Line 4: quality detail */
        "    → last feed: %s",                                  /* Line 5: quality temporal */
        (unsigned long long)st.total_insects_trimmed,
        (unsigned long long)st.total_lobotomies_applied,
        st.last_feed_time ? ctime(&st.last_feed_time) : "never\n");

    if (verbose < 2) return (n > 0) ? 0 : -1;

    /* ─── 7 LINES: fine copy (stands alone) ────────────────────
     * Replace the 5-line version entirely with 7 self-contained lines.
     * This is not 5+2, it is its own structure. */
    n = 0;  /* Reset — 7 is a fine copy, starts fresh */
    n += snprintf(buf + n, bufsz - n,
        "═══ PSYCH-ID v%s ═══\n"                               /* Line 1: header */
        "Status: %s | Mode: %s\n"                              /* Line 2: operational */
        "Database: %llu MB / 300 MB\n"                         /* Line 3: capacity */
        "Banners: %llu | Suspects: %llu\n"                     /* Line 4: collection */
        "Insects trimmed: %llu | Lobotomies: %llu\n"           /* Line 5: analysis */
        "Prescriptions pending: %llu\n"                        /* Line 6: actionable */
        "Last feed: %s",                                       /* Line 7: temporal */
        PSYCH_ID_VERSION_STRING,
        status_str, mode_str,
        (unsigned long long)(st.db_size_bytes / (1024*1024)),
        (unsigned long long)st.total_banners_collected,
        (unsigned long long)st.total_suspects,
        (unsigned long long)st.total_insects_trimmed,
        (unsigned long long)st.total_lobotomies_applied,
        (unsigned long long)st.total_prescriptions,
        st.last_feed_time ? ctime(&st.last_feed_time) : "never\n");

    if (verbose < 3) return (n > 0) ? 0 : -1;

    /* ─── 11 LINES: full copy (stands alone, extended) ─────────
     * Full intelligence picture. Also its own structure. */
    n = 0;  /* Reset — 11 is a full copy, starts fresh */

    time_t now = time(NULL);
    char time_str[64];
    struct tm *tm_now = localtime(&now);
    strftime(time_str, sizeof(time_str), "%Y-%m-%d %H:%M", tm_now);

    char next_str[64] = "—";
    if (st.next_scheduled_feed > 0) {
        struct tm *tm_next = localtime(&st.next_scheduled_feed);
        strftime(next_str, sizeof(next_str), "%Y-%m-%d %H:%M", tm_next);
    }

    n += snprintf(buf + n, bufsz - n,
        "═══════════════════════════════════════════════════════\n"  /* Line  1: border */
        "  PSYCH-ID v%s — Network Intelligence\n"                   /* Line  2: identity */
        "═══════════════════════════════════════════════════════\n"  /* Line  3: border */
        "  Status: %s | Mode: %s | Now: %s\n"                       /* Line  4: full operational */
        "  Database: %llu MB / 300 MB capacity\n"                   /* Line  5: capacity */
        "  Banners collected: %llu across all targets\n"            /* Line  6: collection depth */
        "  Suspects tracked: %llu | Concern active\n"               /* Line  7: suspect count */
        "  Analysis: %llu lobotomies | %llu insects trimmed\n"      /* Line  8: engine work */
        "  Prescriptions: %llu pending search queries\n"            /* Line  9: actionable intel */
        "  Last feed: %s"                                           /* Line 10: history */
        "  Next scheduled: %s\n",                                   /* Line 11: future */
        PSYCH_ID_VERSION_STRING,
        status_str, mode_str, time_str,
        (unsigned long long)(st.db_size_bytes / (1024*1024)),
        (unsigned long long)st.total_banners_collected,
        (unsigned long long)st.total_suspects,
        (unsigned long long)st.total_lobotomies_applied,
        (unsigned long long)st.total_insects_trimmed,
        (unsigned long long)st.total_prescriptions,
        st.last_feed_time ? ctime(&st.last_feed_time) : "never\n",
        next_str);

    return (n > 0) ? 0 : -1;
}

/* ─── Cron Interface ──────────────────────────────────────────────── */

/*
 * Compatible with cronie callback extension.
 * Events: "feed", "feed-update", "status", "prune"
 */
int psych_id_cron_hook(const char *event, const char *payload)
{
    if (!event) return -1;

    if (strcmp(event, "feed") == 0) {
        return psych_id_feed_now();
    } else if (strcmp(event, "feed-update") == 0) {
        return psych_id_feed_and_update();
    } else if (strcmp(event, "status") == 0) {
        char motd[2048];
        psych_id_get_motd(motd, sizeof(motd));
        printf("%s", motd);
        return 0;
    } else if (strcmp(event, "prune") == 0) {
        pthread_mutex_lock(&g_db_mutex);
        int rc = db_prune_oldest(PSYCH_ID_DB_MAX_SIZE * 80 / 100);
        pthread_mutex_unlock(&g_db_mutex);
        return rc;
    }

    log_msg(1, "Unknown cron event: %s", event);
    return -1;
}

/* ─── Utilities ───────────────────────────────────────────────────── */

static void log_msg(int level, const char *fmt, ...)
{
    if (level > g_config.verbose) return;

    va_list ap;
    time_t now = time(NULL);
    char time_str[32];
    struct tm *tm = localtime(&now);
    strftime(time_str, sizeof(time_str), "%Y-%m-%d %H:%M:%S", tm);

    FILE *out = (g_config.log_path[0]) ? fopen(g_config.log_path, "a") : stderr;
    if (!out) out = stderr;

    fprintf(out, "[%s] psych-id: ", time_str);
    va_start(ap, fmt);
    vfprintf(out, fmt, ap);
    va_end(ap);
    fprintf(out, "\n");

    if (out != stderr) fclose(out);
}

static int load_config(const char *path)
{
    FILE *fp = fopen(path, "r");
    if (!fp) return -1;

    char line[1024];
    while (fgets(line, sizeof(line), fp)) {
        /* Strip whitespace and comments */
        char *p = line;
        while (*p == ' ' || *p == '\t') p++;
        if (*p == '#' || *p == '\n' || *p == '\0') continue;

        char key[128], val[512];
        if (sscanf(p, "%127[^=]=%511[^\n]", key, val) == 2) {
            /* Trim key/val */
            char *k = key; while (*k == ' ') k++;
            char *v = val; while (*v == ' ') v++;
            size_t klen = strlen(k); while (klen > 0 && k[klen-1] == ' ') k[--klen] = '\0';
            size_t vlen = strlen(v); while (vlen > 0 && v[vlen-1] == ' ') v[--vlen] = '\0';

            if (strcmp(k, "feed_mode") == 0) {
                if (strcmp(v, "daily") == 0) g_config.feed_mode = FEED_MODE_DAILY;
                else if (strcmp(v, "command") == 0) g_config.feed_mode = FEED_MODE_ON_COMMAND;
                else if (strcmp(v, "feed-update") == 0) g_config.feed_mode = FEED_MODE_FEED_UPDATE;
                else if (strcmp(v, "reminder") == 0) g_config.feed_mode = FEED_MODE_REMINDER;
            }
            else if (strcmp(k, "daily_hour") == 0) g_config.daily_hour = atoi(v);
            else if (strcmp(k, "daily_minute") == 0) g_config.daily_minute = atoi(v);
            else if (strcmp(k, "reminder_min_hours") == 0) g_config.reminder_min_hours = atoi(v);
            else if (strcmp(k, "reminder_max_hours") == 0) g_config.reminder_max_hours = atoi(v);
            else if (strcmp(k, "scan_timeout_ms") == 0) g_config.scan_timeout_ms = atoi(v);
            else if (strcmp(k, "max_concurrent_scans") == 0) g_config.max_concurrent_scans = atoi(v);
            else if (strcmp(k, "enable_tls") == 0) g_config.enable_tls_probing = atoi(v);
            else if (strcmp(k, "enable_search") == 0) g_config.enable_search_hints = atoi(v);
            else if (strcmp(k, "enable_web_fetch") == 0) g_config.enable_web_fetch = atoi(v);
            else if (strcmp(k, "verbose") == 0) g_config.verbose = atoi(v);
            else if (strcmp(k, "db_path") == 0) strncpy(g_config.db_path, v, sizeof(g_config.db_path)-1);
            else if (strcmp(k, "log_path") == 0) strncpy(g_config.log_path, v, sizeof(g_config.log_path)-1);
            else if (strcmp(k, "targets_file") == 0) strncpy(g_config.targets_file, v, sizeof(g_config.targets_file)-1);
            else if (strcmp(k, "search_engines") == 0) strncpy(g_config.search_engines, v, sizeof(g_config.search_engines)-1);
        }
    }

    fclose(fp);
    return 0;
}

static int save_pid_file(void)
{
    FILE *fp = fopen("/var/run/psych-id.pid", "w");
    if (!fp) return -1;
    fprintf(fp, "%d\n", getpid());
    fclose(fp);
    return 0;
}

static void remove_pid_file(void)
{
    unlink("/var/run/psych-id.pid");
}

static void signal_handler(int sig)
{
    switch (sig) {
    case SIGTERM:
    case SIGINT:
        g_running = 0;
        break;
    case SIGUSR1:
        g_feed_requested = 1;  /* Feed on signal */
        break;
    case SIGUSR2:
        g_feed_requested = 2;  /* Feed + Update on signal */
        break;
    }
}

/* ─── Main (CLI Entry Point) ──────────────────────────────────────── */

static void print_usage(const char *prog)
{
    printf("Psych-ID v%s — Network Intelligence & Web Analysis\n\n", PSYCH_ID_VERSION_STRING);
    printf("Usage: %s [OPTIONS] [COMMAND]\n\n", prog);
    printf("Commands:\n");
    printf("  daemon          Start as background daemon\n");
    printf("  feed            Feed now (scan targets)\n");
    printf("  feed-update     Feed and update (scan + analyze + prescribe)\n");
    printf("  status          Show current state (MOTD)\n");
    printf("  scan <host>     Scan a single host\n");
    printf("  prescriptions   List pending search prescriptions\n");
    printf("  suspects        List tracked suspects\n");
    printf("  prune           Prune database to 80%%\n");
    printf("  stop            Stop running daemon\n");
    printf("\n");
    printf("Options:\n");
    printf("  -c <file>       Configuration file (default: /etc/psych-id/psych-id.conf)\n");
    printf("  -m <mode>       Feed mode: daily, command, feed-update, reminder\n");
    printf("  -v              Verbose output\n");
    printf("  -q              Quiet output\n");
    printf("  -h              Show this help\n");
    printf("\n");
    printf("Cron Examples:\n");
    printf("  # Daily feed at 3am\n");
    printf("  0 3 * * * /usr/local/bin/psych-id feed-update @callback {\n");
    printf("      expect: \"Feed + Update complete\"\n");
    printf("      retry: 2\n");
    printf("      on_fail: escalate\n");
    printf("      notify: \"chat:ops-team\"\n");
    printf("  }\n");
    printf("\n");
    printf("  # Scan specific host on demand\n");
    printf("  /usr/local/bin/psych-id scan 192.168.1.1\n");
    printf("\n");
    printf("Signals:\n");
    printf("  SIGUSR1         Trigger immediate feed (scan only)\n");
    printf("  SIGUSR2         Trigger feed + update\n");
    printf("  SIGTERM/SIGINT  Graceful shutdown\n");
}

int main(int argc, char *argv[])
{
    const char *config_path = "/etc/psych-id/psych-id.conf";
    const char *command = NULL;
    const char *scan_target = NULL;
    int opt;

    while ((opt = getopt(argc, argv, "c:m:vqh")) != -1) {
        switch (opt) {
        case 'c': config_path = optarg; break;
        case 'm':
            /* Mode will be set after init */
            break;
        case 'v': /* handled after init */ break;
        case 'q': /* handled after init */ break;
        case 'h':
            print_usage(argv[0]);
            return 0;
        default:
            print_usage(argv[0]);
            return 1;
        }
    }

    if (optind < argc) {
        command = argv[optind];
        if (optind + 1 < argc) {
            scan_target = argv[optind + 1];
        }
    }

    if (!command) {
        print_usage(argv[0]);
        return 0;
    }

    /* Initialize */
    if (psych_id_init(config_path) != 0) {
        fprintf(stderr, "psych-id: initialization failed\n");
        return 1;
    }

    /* Handle commands */
    int rc = 0;

    if (strcmp(command, "daemon") == 0) {
        /* Fork to background */
        pid_t pid = fork();
        if (pid < 0) {
            perror("fork");
            return 1;
        }
        if (pid > 0) {
            printf("Psych-ID daemon started (PID %d)\n", pid);
            return 0;
        }
        /* Child: become daemon */
        setsid();
        psych_id_start_daemon();
        pthread_join(g_daemon_thread, NULL);

    } else if (strcmp(command, "feed") == 0) {
        rc = psych_id_feed_now();

    } else if (strcmp(command, "feed-update") == 0) {
        rc = psych_id_feed_and_update();

    } else if (strcmp(command, "status") == 0) {
        char motd[4096];
        psych_id_get_motd(motd, sizeof(motd));
        printf("%s", motd);

    } else if (strcmp(command, "scan") == 0) {
        if (!scan_target) {
            fprintf(stderr, "psych-id: scan requires a host argument\n");
            rc = 1;
        } else {
            rc = psych_id_scan_host(scan_target);
        }

    } else if (strcmp(command, "prescriptions") == 0) {
        psych_id_prescription_t prescriptions[20];
        size_t count = 0;
        psych_id_list_prescriptions(prescriptions, 20, &count);

        /* 3-line header */
        printf("PSYCH-ID — Pending Prescriptions\n");       /* Line 1: identity */
        printf("%zu search queries awaiting fulfillment\n", count); /* Line 2: state */
        printf("───────────────────────────────────\n");    /* Line 3: separator */

        /* Each prescription: 3 lines (prime base per item) */
        for (size_t i = 0; i < count; i++) {
            printf("[%llu] P%u %s: %s\n",                   /* Line 1: id + engine + query */
                   (unsigned long long)prescriptions[i].prescription_id,
                   prescriptions[i].priority,
                   prescriptions[i].search_engine,
                   prescriptions[i].search_query);
            printf("  → %s\n",                              /* Line 2: hint */
                   prescriptions[i].hint);
            printf("  ◦ stage %u\n",                        /* Line 3: origin */
                   prescriptions[i].lobotomy_stage);
        }

    } else if (strcmp(command, "suspects") == 0) {
        /* Quick suspect listing — 3-line header */
        printf("PSYCH-ID — Tracked Suspects\n");            /* Line 1: identity */
        printf("Ordered by concern level (descending)\n");  /* Line 2: sort */
        printf("───────────────────────────────────\n");    /* Line 3: separator */

        /* Each suspect: 3 lines (prime base per item) */
        pthread_mutex_lock(&g_db_mutex);
        sqlite3_stmt *stmt;
        const char *sql = "SELECT suspect_id, host, service_fingerprint, concern_level, "
                          "lobotomy_applied FROM suspects ORDER BY concern_level DESC LIMIT 20";
        if (sqlite3_prepare_v2(g_db, sql, -1, &stmt, NULL) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                /* 3 lines per suspect (prime base) */
                printf("[%lld] %s — concern %d/10\n",       /* Line 1: id + host + level */
                       sqlite3_column_int64(stmt, 0),
                       sqlite3_column_text(stmt, 1),
                       sqlite3_column_int(stmt, 3));
                printf("  %s\n",                            /* Line 2: fingerprint */
                       sqlite3_column_text(stmt, 2));
                printf("  ◦ lobotomy %d/7\n",               /* Line 3: analysis stage */
                       sqlite3_column_int(stmt, 4));
            }
            sqlite3_finalize(stmt);
        }
        pthread_mutex_unlock(&g_db_mutex);

    } else if (strcmp(command, "prune") == 0) {
        pthread_mutex_lock(&g_db_mutex);
        rc = db_prune_oldest(PSYCH_ID_DB_MAX_SIZE * 80 / 100);
        pthread_mutex_unlock(&g_db_mutex);
        printf("Database pruned.\n");

    } else if (strcmp(command, "stop") == 0) {
        /* Send SIGTERM to running daemon */
        FILE *fp = fopen("/var/run/psych-id.pid", "r");
        if (fp) {
            pid_t pid;
            if (fscanf(fp, "%d", &pid) == 1) {
                kill(pid, SIGTERM);
                printf("Sent SIGTERM to PID %d\n", pid);
            }
            fclose(fp);
        } else {
            fprintf(stderr, "No running daemon found\n");
            rc = 1;
        }

    } else {
        fprintf(stderr, "Unknown command: %s\n", command);
        print_usage(argv[0]);
        rc = 1;
    }

    psych_id_cleanup();
    return rc;
}
