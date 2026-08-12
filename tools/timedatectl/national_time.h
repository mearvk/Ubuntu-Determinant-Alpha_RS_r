/* SPDX-License-Identifier: GPL-2.0 */
/*
 * national_time.h — National Time Reference for Ubuntu Determinant Alpha
 *
 * Provides a two-clock architecture:
 *
 *   1. SYSTEM CLOCK (admin clock)
 *      - What the kernel reports via clock_gettime(CLOCK_REALTIME)
 *      - Set by the administrator via timedatectl or NTP
 *      - May be in the past, future, or offset for testing/certification
 *      - Used for: scheduler, cron, file timestamps, kernel timers
 *
 *   2. NATIONAL CLOCK (reference clock)
 *      - Civil time as defined by national standard (NIST for US)
 *      - Sourced from: NTP (NIST servers), GPS, or manual admin override
 *      - Independent of system clock — survives admin clock changes
 *      - Used for: legal timestamps, financial records, audit trails,
 *        medical records, government filings, ACH windows
 *
 * Programs choose which clock to reference:
 *   - clock_gettime(CLOCK_REALTIME)        → system clock (unchanged)
 *   - national_time_now()                  → national reference clock
 *   - national_date_today()                → national civil date
 *
 * The admin clock is ALWAYS authoritative for system operation.
 * The national clock is a REFERENCE that programs MAY consult for compliance.
 * Neither overrides the other.
 *
 * Sync sources (priority order):
 *   1. GPS receiver (if hardware present) — authoritative, no network needed
 *   2. NIST NTP servers (time.nist.gov, time-a-wwv.nist.gov)
 *   3. pool.ntp.org (fallback)
 *   4. Admin manual override (/etc/national-time.conf)
 *   5. System clock (last resort — same as CLOCK_REALTIME)
 *
 * Drift handling:
 *   If national clock and system clock diverge by more than the configured
 *   threshold, the national time daemon logs a DRIFT_ALERT. It does NOT
 *   correct the system clock — that's the admin's prerogative.
 *
 * Legal compliance note:
 *   Programs that use national_time_now() for record-keeping get timestamps
 *   that are defensible in court as "referenced to national standard time."
 *   Programs that use CLOCK_REALTIME get timestamps that reflect the admin's
 *   operational clock (which may be intentionally offset).
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#ifndef __NATIONAL_TIME_H
#define __NATIONAL_TIME_H

#include <stdint.h>
#include <stdbool.h>
#include <time.h>

#ifdef __cplusplus
extern "C" {
#endif

/* ============================================================================
 * Types
 * ============================================================================ */

/**
 * National time value — microseconds since Unix epoch (UTC).
 * Same unit as systemd's usec_t for interoperability.
 */
typedef uint64_t national_usec_t;

/**
 * National date — civil calendar date in the national timezone.
 */
struct national_date {
    int      year;       /* 1970–28808 */
    int      month;      /* 1–12 */
    int      day;        /* 1–31 */
    int      hour;       /* 0–23 */
    int      minute;     /* 0–59 */
    int      second;     /* 0–59 */
    int      usec;       /* 0–999999 */
    int      day_of_week;/* 0=Sunday, 6=Saturday */
    int      day_of_year;/* 1–366 */
    int      utc_offset; /* Seconds east of UTC (e.g. -18000 for EST) */
    char     tz_name[32];/* "America/New_York", "UTC", etc. */
    char     tz_abbr[8]; /* "EST", "EDT", "UTC", etc. */
};

/**
 * Sync source — where the national clock is getting its reference.
 */
enum national_time_source {
    NTIME_SOURCE_GPS        = 0,  /* GPS hardware receiver (stratum 0) */
    NTIME_SOURCE_NIST       = 1,  /* NIST NTP servers (stratum 1) */
    NTIME_SOURCE_NTP_POOL   = 2,  /* pool.ntp.org (stratum 2+) */
    NTIME_SOURCE_ADMIN      = 3,  /* Manual admin override */
    NTIME_SOURCE_SYSTEM     = 4,  /* Fallback to system clock */
    NTIME_SOURCE_NONE       = 5,  /* Not synced (error state) */
};

/**
 * National time status — current state of the reference clock.
 */
struct national_time_status {
    bool                     synced;          /* Currently synced to a source? */
    enum national_time_source source;         /* Active sync source */
    national_usec_t          last_sync_usec;  /* When last successful sync occurred */
    int64_t                  drift_usec;      /* System clock - national clock (µs) */
    uint32_t                 stratum;         /* NTP stratum of current source */
    double                   precision_usec;  /* Estimated precision in µs */
    char                     server[128];     /* Current NTP server name/IP */
    char                     national_tz[64]; /* Configured national timezone */
};

/* ============================================================================
 * Core API — What programs call
 * ============================================================================ */

/**
 * Get current national time (UTC, microseconds since epoch).
 * This is the primary call for compliance-grade timestamps.
 *
 * Returns national reference time, NOT system clock.
 * If national clock is unavailable, falls back to system clock with a log warning.
 */
national_usec_t national_time_now(void);

/**
 * Get current national time as a broken-down civil date.
 * Uses the configured national timezone (default: America/New_York for US).
 */
int national_date_today(struct national_date *out);

/**
 * Get current national time as a broken-down UTC date.
 */
int national_date_utc(struct national_date *out);

/**
 * Get national time for a specific timezone.
 */
int national_date_in_tz(const char *timezone, struct national_date *out);

/**
 * Get the raw offset between system clock and national clock.
 * Positive = system clock is AHEAD of national.
 * Negative = system clock is BEHIND national.
 * Zero = clocks agree (within precision bounds).
 */
int64_t national_time_drift(void);

/**
 * Get the current status of the national time subsystem.
 */
int national_time_status(struct national_time_status *out);

/**
 * Format a national_usec_t as an ISO 8601 string.
 * Output: "2026-08-11T23:45:00.000000-04:00"
 * Uses the configured national timezone.
 */
int national_time_format(national_usec_t t, char *buf, size_t len);

/**
 * Format as ISO 8601 in UTC.
 * Output: "2026-08-11T03:45:00.000000Z"
 */
int national_time_format_utc(national_usec_t t, char *buf, size_t len);

/* ============================================================================
 * Comparison API — For programs that need to know which clock to trust
 * ============================================================================ */

/**
 * Is the system clock within acceptable drift of national time?
 * threshold_usec: maximum acceptable drift (default: 1 second = 1,000,000 µs)
 * Returns true if |system_clock - national_clock| < threshold.
 */
bool national_time_clocks_agree(uint64_t threshold_usec);

/**
 * Get system clock time (same as clock_gettime CLOCK_REALTIME, for comparison).
 * Provided for convenience — programs can compare:
 *   national_time_now()  vs  system_time_now()
 */
national_usec_t system_time_now(void);

/* ============================================================================
 * Configuration API — For the admin/daemon
 * ============================================================================ */

/**
 * Initialize the national time subsystem.
 * Called once at boot by the national-timed daemon.
 * Reads config from /etc/national-time.conf.
 */
int national_time_init(void);

/**
 * Shut down — release resources, close NTP connections.
 */
void national_time_shutdown(void);

/**
 * Force a sync to the national time source NOW.
 * Normally sync happens on a schedule (every 60s from NTP).
 */
int national_time_sync_now(void);

/**
 * Set the national timezone (admin configuration).
 * Default for US: "America/New_York" (civil time of federal government).
 */
int national_time_set_timezone(const char *tz);

/**
 * Override national time manually (Grade 7+ admin only).
 * Used when no NTP/GPS source is available.
 * Sets a manual reference point that drifts with system clock.
 */
int national_time_set_manual(national_usec_t reference_usec);

/* ============================================================================
 * Program Registration (optional — for audit trail)
 * ============================================================================ */

/**
 * Register a program as using national time for compliance records.
 * This creates an audit entry: "program X is referencing national time
 * for its record-keeping as of timestamp Y."
 *
 * Not required for using national_time_now(), but recommended for
 * programs that need to demonstrate compliance.
 */
int national_time_register_program(const char *program_name,
                                    const char *compliance_domain);

/* Compliance domains */
#define NTIME_DOMAIN_FINANCIAL  "financial"   /* ACH, wire transfers, trading */
#define NTIME_DOMAIN_LEGAL      "legal"       /* Court filings, contracts */
#define NTIME_DOMAIN_MEDICAL    "medical"     /* Patient records, prescriptions */
#define NTIME_DOMAIN_GOVERNMENT "government"  /* Federal/state filings */
#define NTIME_DOMAIN_AUDIT      "audit"       /* General audit trail */
#define NTIME_DOMAIN_GENERAL    "general"     /* No specific compliance requirement */

/* ============================================================================
 * /proc Interface (kernel module)
 * ============================================================================ */

/*
 * /proc/national_time/now        — Current national time (µs since epoch)
 * /proc/national_time/date       — Current national date (human-readable)
 * /proc/national_time/drift      — System clock drift from national (µs)
 * /proc/national_time/status     — Full status (source, stratum, server)
 * /proc/national_time/config     — Current configuration
 * /proc/national_time/programs   — Registered programs
 * /proc/national_time/sync       — Write "1" to force sync
 */

/* ============================================================================
 * Constants
 * ============================================================================ */

/* Default sync interval (seconds) */
#define NTIME_DEFAULT_SYNC_INTERVAL    60

/* Default drift alert threshold (1 second) */
#define NTIME_DEFAULT_DRIFT_ALERT_USEC 1000000ULL

/* Maximum drift before national clock refuses to report (10 minutes) */
#define NTIME_MAX_DRIFT_USEC           (600ULL * 1000000ULL)

/* NIST NTP servers (US national standard) */
#define NTIME_NIST_SERVER_1  "time.nist.gov"
#define NTIME_NIST_SERVER_2  "time-a-wwv.nist.gov"
#define NTIME_NIST_SERVER_3  "time-b-wwv.nist.gov"
#define NTIME_NIST_SERVER_4  "time-c-wwv.nist.gov"

/* Configuration file path */
#define NTIME_CONFIG_PATH    "/etc/national-time.conf"

/* Audit log path */
#define NTIME_AUDIT_LOG      "/var/log/national-time.log"

#ifdef __cplusplus
}
#endif

#endif /* __NATIONAL_TIME_H */
