/*
 * psych_id.h — Psych-ID: Network Intelligence & Web Analysis Module
 *
 * Scans ports 20, 21, 22, 80, 443 (8080, 8443) for MOTD banner
 * intelligence. Performs suggestion lobotomy and insect trimming
 * on gathered web information. Prescribes search engine queries
 * for further information hinting.
 *
 * Part of Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
 * Copyright (C) 2026 MEARVK LLC
 * License: GPL-2.0
 */

#ifndef PSYCH_ID_H
#define PSYCH_ID_H

#include <stdint.h>
#include <time.h>

/* ─── Version ─────────────────────────────────────────────────────── */

#define PSYCH_ID_VERSION_MAJOR   1
#define PSYCH_ID_VERSION_MINOR   0
#define PSYCH_ID_VERSION_PATCH   0
#define PSYCH_ID_VERSION_STRING  "1.0.0"

/* ─── Port Configuration ──────────────────────────────────────────── */

#define PSYCH_ID_PORT_FTP_DATA      20
#define PSYCH_ID_PORT_FTP_CTRL      21
#define PSYCH_ID_PORT_SSH           22
#define PSYCH_ID_PORT_HTTP          80
#define PSYCH_ID_PORT_HTTPS        443
#define PSYCH_ID_PORT_HTTP_ALT    8080
#define PSYCH_ID_PORT_HTTPS_ALT   8443

#define PSYCH_ID_NUM_PORTS          7

static const uint16_t PSYCH_ID_SCAN_PORTS[PSYCH_ID_NUM_PORTS] = {
    20, 21, 22, 80, 443, 8080, 8443
};

/* ─── Database Configuration ──────────────────────────────────────── */

#define PSYCH_ID_DB_PATH           "/var/lib/psych-id/suspects.db"
#define PSYCH_ID_DB_MAX_SIZE_MB    300
#define PSYCH_ID_DB_MAX_SIZE       (300ULL * 1024 * 1024)
#define PSYCH_ID_BANNER_MAX_LEN    4096
#define PSYCH_ID_URL_MAX_LEN       2048
#define PSYCH_ID_QUERY_MAX_LEN     512
#define PSYCH_ID_HINT_MAX_LEN      1024

/* ─── Feed Modes ──────────────────────────────────────────────────── */

typedef enum {
    FEED_MODE_DAILY          = 0,   /* Cron-compatible daily auto-feed */
    FEED_MODE_ON_COMMAND     = 1,   /* Feed only when explicitly asked */
    FEED_MODE_FEED_UPDATE    = 2,   /* Feed AND update DB on command */
    FEED_MODE_REMINDER       = 3    /* Occasional reminder (8-36h cycle) */
} psych_id_feed_mode_t;

/* ─── Analyzer Engine Types ───────────────────────────────────────── */

/*
 * SUGGESTION LOBOTOMY:
 *   Carry toward center reference but enough to include maintenance
 *   of 3rd and 4th dimension and with respect to law and law again
 *   but with respect to maintenance of science.
 *
 *   In practice: prune speculative branches toward verified center
 *   of knowledge, maintaining dimensional depth (3rd: spatial/relational,
 *   4th: temporal/causal) while respecting legal and scientific constraints.
 */
typedef enum {
    LOBOTOMY_NONE            = 0,   /* Raw, unprocessed suggestion */
    LOBOTOMY_CENTER          = 1,   /* Carry to center reference */
    LOBOTOMY_DIM3            = 2,   /* Maintain 3rd dimension (spatial) */
    LOBOTOMY_DIM4            = 3,   /* Maintain 4th dimension (temporal) */
    LOBOTOMY_LAW             = 4,   /* Respect to law */
    LOBOTOMY_LAW_AGAIN       = 5,   /* Respect to law again (reinforced) */
    LOBOTOMY_SCIENCE         = 6,   /* Maintenance of science */
    LOBOTOMY_FULL            = 7    /* All stages applied */
} lobotomy_stage_t;

/*
 * INSECT TRIMMING:
 *   Trim impossible or dead-end varios (variations).
 *   Remove branches of analysis that lead nowhere productive.
 */
typedef enum {
    INSECT_IMPOSSIBLE        = 0,   /* Path is logically impossible */
    INSECT_DEAD_END          = 1,   /* Path terminates without yield */
    INSECT_CIRCULAR          = 2,   /* Path loops back to origin */
    INSECT_CONTRADICTORY     = 3,   /* Path contradicts established fact */
    INSECT_EXPIRED           = 4,   /* Path's temporal window has closed */
    INSECT_SUPERCEDED        = 5    /* Path replaced by better route */
} insect_type_t;

/* ─── Banner Record ───────────────────────────────────────────────── */

typedef struct {
    uint64_t    record_id;
    char        target_host[256];
    uint16_t    target_port;
    char        banner[PSYCH_ID_BANNER_MAX_LEN];
    uint32_t    banner_len;
    time_t      first_seen;
    time_t      last_seen;
    uint32_t    seen_count;
    uint8_t     protocol;               /* 0=TCP, 1=TLS */
    char        service_name[64];       /* e.g. "OpenSSH 9.6", "nginx/1.24" */
    char        service_version[64];
    uint8_t     confidence;             /* 0-100 */
    uint8_t     threat_score;           /* 0-100 */
    uint8_t     interest_score;         /* 0-100: how interesting for analysis */
} psych_id_banner_t;

/* ─── Suspect Record ──────────────────────────────────────────────── */

typedef struct {
    uint64_t    suspect_id;
    char        host[256];
    char        service_fingerprint[256];
    uint8_t     concern_level;          /* 0-10 */
    time_t      first_flagged;
    time_t      last_activity;
    uint32_t    total_observations;
    char        notes[1024];
    uint8_t     insect_trimmed;         /* bitmask of insect_type_t applied */
    lobotomy_stage_t lobotomy_applied;
} psych_id_suspect_t;

/* ─── Search Engine Prescription ──────────────────────────────────── */

typedef struct {
    uint64_t    prescription_id;
    uint64_t    related_suspect_id;
    char        search_query[PSYCH_ID_QUERY_MAX_LEN];
    char        search_engine[64];      /* "google", "duckduckgo", "bing", etc. */
    char        hint[PSYCH_ID_HINT_MAX_LEN];
    uint8_t     priority;               /* 1-10 */
    time_t      prescribed_at;
    time_t      fulfilled_at;           /* 0 if not yet fulfilled */
    uint8_t     lobotomy_stage;         /* which lobotomy stage generated this */
} psych_id_prescription_t;

/* ─── Web Information Node ────────────────────────────────────────── */

typedef struct {
    uint64_t    node_id;
    char        url[PSYCH_ID_URL_MAX_LEN];
    char        title[256];
    char        summary[1024];
    time_t      fetched_at;
    uint8_t     relevance;              /* 0-100 */
    uint8_t     dimension;              /* 3 or 4 (spatial or temporal) */
    uint8_t     law_compliant;          /* 1=yes, 0=unknown */
    uint8_t     science_verified;       /* 1=yes, 0=pending */
    insect_type_t trimmed_as;           /* if trimmed, why */
    uint8_t     is_trimmed;             /* 1=insect-trimmed, 0=active */
} psych_id_web_node_t;

/* ─── Analyzer Engine State ───────────────────────────────────────── */

typedef struct {
    uint64_t    total_banners_collected;
    uint64_t    total_suspects;
    uint64_t    total_prescriptions;
    uint64_t    total_web_nodes;
    uint64_t    total_insects_trimmed;
    uint64_t    total_lobotomies_applied;
    uint64_t    db_size_bytes;
    time_t      last_feed_time;
    time_t      next_scheduled_feed;
    psych_id_feed_mode_t current_mode;
    uint8_t     daemon_running;         /* 1=active, 0=stopped */
    uint8_t     feed_in_progress;       /* 1=busy, 0=idle */
} psych_id_state_t;

/* ─── Configuration ───────────────────────────────────────────────── */

typedef struct {
    psych_id_feed_mode_t feed_mode;
    uint32_t    daily_hour;             /* 0-23, when to feed in daily mode */
    uint32_t    daily_minute;           /* 0-59 */
    uint32_t    reminder_min_hours;     /* min hours between reminders */
    uint32_t    reminder_max_hours;     /* max hours between reminders */
    uint32_t    scan_timeout_ms;        /* per-port scan timeout */
    uint32_t    max_concurrent_scans;   /* parallel port scans */
    uint8_t     enable_tls_probing;     /* 1=probe TLS on 443/8443 */
    uint8_t     enable_search_hints;    /* 1=generate search prescriptions */
    uint8_t     enable_web_fetch;       /* 1=fetch prescribed URLs */
    uint8_t     verbose;                /* 0=quiet, 1=normal, 2=debug */
    char        db_path[512];
    char        log_path[512];
    char        targets_file[512];      /* file listing hosts to scan */
    char        search_engines[256];    /* comma-separated list */
} psych_id_config_t;

/* ─── API Functions ───────────────────────────────────────────────── */

/* Lifecycle */
int  psych_id_init(const char *config_path);
int  psych_id_start_daemon(void);
int  psych_id_stop_daemon(void);
void psych_id_cleanup(void);

/* Feed operations */
int  psych_id_feed_now(void);
int  psych_id_feed_and_update(void);
int  psych_id_schedule_daily(int hour, int minute);
int  psych_id_set_reminder(int min_hours, int max_hours);

/* Scanner */
int  psych_id_scan_host(const char *host);
int  psych_id_scan_all_targets(void);
int  psych_id_grab_banner(const char *host, uint16_t port, char *buf, size_t bufsz);

/* Analyzer engine */
int  psych_id_analyze_banner(const psych_id_banner_t *banner);
int  psych_id_apply_lobotomy(uint64_t suspect_id, lobotomy_stage_t stage);
int  psych_id_trim_insect(uint64_t node_id, insect_type_t reason);
int  psych_id_prescribe_search(uint64_t suspect_id, const char *query, const char *engine);

/* Query */
int  psych_id_get_state(psych_id_state_t *state);
int  psych_id_get_suspect(uint64_t id, psych_id_suspect_t *suspect);
int  psych_id_list_prescriptions(psych_id_prescription_t *out, size_t max, size_t *count);
int  psych_id_get_motd(char *buf, size_t bufsz);

/* Cron interface */
int  psych_id_cron_hook(const char *event, const char *payload);

#endif /* PSYCH_ID_H */
