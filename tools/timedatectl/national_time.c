/* SPDX-License-Identifier: GPL-2.0 */
/*
 * national_time.c — National Time Reference Implementation
 *
 * Provides the national reference clock that programs can query independently
 * of the system clock. Syncs to NIST NTP servers by default.
 *
 * This is a userspace daemon library. It can operate as:
 *   1. A shared library (libnational_time.so) linked by programs
 *   2. A standalone daemon (national-timed) that serves /proc entries
 *
 * The national clock maintains its own timekeeping:
 *   - Periodically queries NIST NTP for authoritative time
 *   - Maintains an offset from system clock
 *   - If system clock changes, the offset adjusts (national stays stable)
 *   - If NTP is unreachable, holds last-known offset with drift estimation
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <pthread.h>
#include <errno.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>

#include "national_time.h"

/* ============================================================================
 * Internal State
 * ============================================================================ */

/* The offset between system clock and national time (in microseconds).
 * national_time = system_time + offset
 * If offset is 0, clocks agree.
 * If offset is positive, system is behind national.
 * If offset is negative, system is ahead of national. */
static int64_t g_offset_usec = 0;

/* Current sync source */
static enum national_time_source g_source = NTIME_SOURCE_NONE;

/* Last successful sync timestamp (system clock at time of sync) */
static national_usec_t g_last_sync = 0;

/* NTP stratum of current source */
static uint32_t g_stratum = 16; /* 16 = unsynchronized */

/* Precision estimate (microseconds) */
static double g_precision_usec = 1000000.0; /* 1 second until first sync */

/* Configured national timezone */
static char g_national_tz[64] = "America/New_York";

/* Current NTP server */
static char g_current_server[128] = "";

/* Sync thread */
static pthread_t g_sync_thread;
static bool g_running = false;
static pthread_mutex_t g_lock = PTHREAD_MUTEX_INITIALIZER;

/* Sync interval (seconds) */
static int g_sync_interval = NTIME_DEFAULT_SYNC_INTERVAL;

/* Drift alert threshold */
static uint64_t g_drift_alert_usec = NTIME_DEFAULT_DRIFT_ALERT_USEC;

/* Initialization flag */
static bool g_initialized = false;

/* Registered programs */
#define MAX_REGISTERED_PROGRAMS 64
static struct {
    char name[128];
    char domain[32];
    national_usec_t registered_at;
} g_programs[MAX_REGISTERED_PROGRAMS];
static int g_program_count = 0;

/* ============================================================================
 * NTP Client (Simplified SNTP — RFC 4330)
 * ============================================================================ */

/* NTP packet structure */
struct ntp_packet {
    uint8_t  li_vn_mode;
    uint8_t  stratum;
    uint8_t  poll;
    int8_t   precision;
    uint32_t root_delay;
    uint32_t root_dispersion;
    uint32_t ref_id;
    uint32_t ref_timestamp_sec;
    uint32_t ref_timestamp_frac;
    uint32_t orig_timestamp_sec;
    uint32_t orig_timestamp_frac;
    uint32_t recv_timestamp_sec;
    uint32_t recv_timestamp_frac;
    uint32_t xmit_timestamp_sec;
    uint32_t xmit_timestamp_frac;
};

/* NTP epoch offset: seconds between 1900-01-01 and 1970-01-01 */
#define NTP_EPOCH_OFFSET 2208988800ULL

/**
 * Query an NTP server and return the offset from our system clock.
 * Returns 0 on success, sets *offset_usec to (server_time - our_time) in µs.
 */
static int ntp_query(const char *server, int64_t *offset_usec, uint32_t *out_stratum) {
    struct ntp_packet packet;
    struct sockaddr_in addr;
    struct hostent *host;
    int sock, r;
    struct timeval tv;

    memset(&packet, 0, sizeof(packet));
    /* LI=0, Version=4, Mode=3 (client) */
    packet.li_vn_mode = (0 << 6) | (4 << 3) | 3;

    /* Resolve server */
    host = gethostbyname(server);
    if (!host) return -1;

    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(123); /* NTP port */
    memcpy(&addr.sin_addr.s_addr, host->h_addr_list[0], 4);

    /* Create UDP socket */
    sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (sock < 0) return -errno;

    /* Set timeout (5 seconds) */
    tv.tv_sec = 5;
    tv.tv_usec = 0;
    setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));

    /* Record send time */
    struct timespec t1;
    clock_gettime(CLOCK_REALTIME, &t1);

    /* Send request */
    r = sendto(sock, &packet, sizeof(packet), 0, (struct sockaddr*)&addr, sizeof(addr));
    if (r < 0) { close(sock); return -errno; }

    /* Receive response */
    r = recv(sock, &packet, sizeof(packet), 0);
    close(sock);
    if (r < (int)sizeof(packet)) return -1;

    /* Record receive time */
    struct timespec t4;
    clock_gettime(CLOCK_REALTIME, &t4);

    /* Extract server transmit timestamp */
    uint64_t server_sec = ntohl(packet.xmit_timestamp_sec) - NTP_EPOCH_OFFSET;
    uint64_t server_frac = ntohl(packet.xmit_timestamp_frac);
    uint64_t server_usec = server_sec * 1000000ULL + (server_frac * 1000000ULL / 0x100000000ULL);

    /* Our send time in usec */
    uint64_t t1_usec = (uint64_t)t1.tv_sec * 1000000ULL + t1.tv_nsec / 1000;
    /* Our receive time in usec */
    uint64_t t4_usec = (uint64_t)t4.tv_sec * 1000000ULL + t4.tv_nsec / 1000;

    /* Simple offset calculation: offset = server_time - midpoint_of_our_times
     * (This is a simplified SNTP calculation — real NTP uses all 4 timestamps) */
    uint64_t midpoint = (t1_usec + t4_usec) / 2;
    *offset_usec = (int64_t)server_usec - (int64_t)midpoint;

    if (out_stratum)
        *out_stratum = packet.stratum;

    return 0;
}

/* ============================================================================
 * Sync Thread
 * ============================================================================ */

/* NTP servers to try (in priority order) */
static const char *ntp_servers[] = {
    NTIME_NIST_SERVER_1,
    NTIME_NIST_SERVER_2,
    NTIME_NIST_SERVER_3,
    NTIME_NIST_SERVER_4,
    "pool.ntp.org",
    NULL
};

static void *sync_thread_fn(void *arg) {
    (void)arg;

    while (g_running) {
        int64_t offset = 0;
        uint32_t stratum = 16;
        bool synced = false;

        /* Try each server in priority order */
        for (int i = 0; ntp_servers[i] != NULL; i++) {
            int r = ntp_query(ntp_servers[i], &offset, &stratum);
            if (r == 0) {
                pthread_mutex_lock(&g_lock);
                g_offset_usec = offset;
                g_stratum = stratum;
                g_source = (i < 4) ? NTIME_SOURCE_NIST : NTIME_SOURCE_NTP_POOL;
                g_last_sync = system_time_now();
                g_precision_usec = 1000.0; /* ~1ms precision after NTP sync */
                strncpy(g_current_server, ntp_servers[i], sizeof(g_current_server) - 1);
                pthread_mutex_unlock(&g_lock);
                synced = true;

                /* Check drift and alert if needed */
                int64_t drift = labs(offset);
                if ((uint64_t)drift > g_drift_alert_usec) {
                    fprintf(stderr, "[national-time] DRIFT ALERT: system clock is %+.3f seconds from national time\n",
                            (double)offset / 1000000.0);
                    fprintf(stderr, "[national-time]   Source: %s (stratum %u)\n",
                            ntp_servers[i], stratum);
                    fprintf(stderr, "[national-time]   Action: system clock NOT corrected (admin prerogative)\n");
                }

                break;
            }
        }

        if (!synced) {
            /* All servers failed — if we had a previous sync, keep using the offset.
             * The offset will drift with system clock inaccuracy (~100ppm worst case). */
            pthread_mutex_lock(&g_lock);
            if (g_source == NTIME_SOURCE_NONE) {
                /* Never synced — fall back to system clock (offset = 0) */
                g_offset_usec = 0;
                g_source = NTIME_SOURCE_SYSTEM;
            }
            /* else: keep last-known offset */
            pthread_mutex_unlock(&g_lock);
        }

        /* Sleep until next sync interval */
        sleep(g_sync_interval);
    }

    return NULL;
}

/* ============================================================================
 * Public API Implementation
 * ============================================================================ */

national_usec_t national_time_now(void) {
    struct timespec ts;
    clock_gettime(CLOCK_REALTIME, &ts);
    uint64_t sys_usec = (uint64_t)ts.tv_sec * 1000000ULL + ts.tv_nsec / 1000;

    pthread_mutex_lock(&g_lock);
    int64_t offset = g_offset_usec;
    pthread_mutex_unlock(&g_lock);

    /* National time = system time + offset */
    if (offset >= 0)
        return sys_usec + (uint64_t)offset;
    else
        return sys_usec - (uint64_t)(-offset);
}

national_usec_t system_time_now(void) {
    struct timespec ts;
    clock_gettime(CLOCK_REALTIME, &ts);
    return (uint64_t)ts.tv_sec * 1000000ULL + ts.tv_nsec / 1000;
}

int national_date_today(struct national_date *out) {
    return national_date_in_tz(g_national_tz, out);
}

int national_date_utc(struct national_date *out) {
    return national_date_in_tz("UTC", out);
}

int national_date_in_tz(const char *timezone, struct national_date *out) {
    if (!out) return -1;

    national_usec_t now = national_time_now();
    time_t seconds = (time_t)(now / 1000000ULL);

    /* Set timezone temporarily */
    char *old_tz = getenv("TZ");
    char *saved_tz = old_tz ? strdup(old_tz) : NULL;

    setenv("TZ", timezone, 1);
    tzset();

    struct tm tm;
    localtime_r(&seconds, &tm);

    /* Restore timezone */
    if (saved_tz) {
        setenv("TZ", saved_tz, 1);
        free(saved_tz);
    } else {
        unsetenv("TZ");
    }
    tzset();

    /* Fill output structure */
    out->year = tm.tm_year + 1900;
    out->month = tm.tm_mon + 1;
    out->day = tm.tm_mday;
    out->hour = tm.tm_hour;
    out->minute = tm.tm_min;
    out->second = tm.tm_sec;
    out->usec = (int)(now % 1000000ULL);
    out->day_of_week = tm.tm_wday;
    out->day_of_year = tm.tm_yday + 1;
    out->utc_offset = (int)tm.tm_gmtoff;
    strncpy(out->tz_name, timezone, sizeof(out->tz_name) - 1);
    if (tm.tm_zone)
        strncpy(out->tz_abbr, tm.tm_zone, sizeof(out->tz_abbr) - 1);

    return 0;
}

int64_t national_time_drift(void) {
    pthread_mutex_lock(&g_lock);
    int64_t drift = g_offset_usec;
    pthread_mutex_unlock(&g_lock);
    return -drift; /* Return system_clock - national_clock */
}

int national_time_status(struct national_time_status *out) {
    if (!out) return -1;

    pthread_mutex_lock(&g_lock);
    out->synced = (g_source != NTIME_SOURCE_NONE);
    out->source = g_source;
    out->last_sync_usec = g_last_sync;
    out->drift_usec = -g_offset_usec; /* system - national */
    out->stratum = g_stratum;
    out->precision_usec = g_precision_usec;
    strncpy(out->server, g_current_server, sizeof(out->server) - 1);
    strncpy(out->national_tz, g_national_tz, sizeof(out->national_tz) - 1);
    pthread_mutex_unlock(&g_lock);

    return 0;
}

bool national_time_clocks_agree(uint64_t threshold_usec) {
    int64_t drift = national_time_drift();
    return (uint64_t)labs(drift) < threshold_usec;
}

int national_time_format(national_usec_t t, char *buf, size_t len) {
    if (!buf || len < 40) return -1;

    time_t seconds = (time_t)(t / 1000000ULL);
    int usec = (int)(t % 1000000ULL);

    char *old_tz = getenv("TZ");
    char *saved_tz = old_tz ? strdup(old_tz) : NULL;
    setenv("TZ", g_national_tz, 1);
    tzset();

    struct tm tm;
    localtime_r(&seconds, &tm);

    if (saved_tz) { setenv("TZ", saved_tz, 1); free(saved_tz); }
    else unsetenv("TZ");
    tzset();

    int offset_h = (int)(tm.tm_gmtoff / 3600);
    int offset_m = abs((int)(tm.tm_gmtoff % 3600) / 60);

    snprintf(buf, len, "%04d-%02d-%02dT%02d:%02d:%02d.%06d%+03d:%02d",
             tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
             tm.tm_hour, tm.tm_min, tm.tm_sec, usec,
             offset_h, offset_m);
    return 0;
}

int national_time_format_utc(national_usec_t t, char *buf, size_t len) {
    if (!buf || len < 30) return -1;

    time_t seconds = (time_t)(t / 1000000ULL);
    int usec = (int)(t % 1000000ULL);

    struct tm tm;
    gmtime_r(&seconds, &tm);

    snprintf(buf, len, "%04d-%02d-%02dT%02d:%02d:%02d.%06dZ",
             tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
             tm.tm_hour, tm.tm_min, tm.tm_sec, usec);
    return 0;
}

/* ============================================================================
 * Configuration / Lifecycle
 * ============================================================================ */

int national_time_init(void) {
    if (g_initialized) return 0;

    /* Read config file if present */
    FILE *f = fopen(NTIME_CONFIG_PATH, "r");
    if (f) {
        char line[256];
        while (fgets(line, sizeof(line), f)) {
            char key[64], val[128];
            if (sscanf(line, "%63s = %127[^\n]", key, val) == 2) {
                if (strcmp(key, "timezone") == 0)
                    strncpy(g_national_tz, val, sizeof(g_national_tz) - 1);
                else if (strcmp(key, "sync_interval") == 0)
                    g_sync_interval = atoi(val);
                else if (strcmp(key, "drift_alert_usec") == 0)
                    g_drift_alert_usec = strtoull(val, NULL, 10);
            }
        }
        fclose(f);
    }

    /* Start sync thread */
    g_running = true;
    if (pthread_create(&g_sync_thread, NULL, sync_thread_fn, NULL) != 0) {
        g_running = false;
        return -errno;
    }

    g_initialized = true;
    return 0;
}

void national_time_shutdown(void) {
    if (!g_initialized) return;
    g_running = false;
    pthread_join(g_sync_thread, NULL);
    g_initialized = false;
}

int national_time_sync_now(void) {
    /* Interrupt the sync thread's sleep by doing an immediate query */
    int64_t offset = 0;
    uint32_t stratum = 16;

    for (int i = 0; ntp_servers[i] != NULL; i++) {
        if (ntp_query(ntp_servers[i], &offset, &stratum) == 0) {
            pthread_mutex_lock(&g_lock);
            g_offset_usec = offset;
            g_stratum = stratum;
            g_source = (i < 4) ? NTIME_SOURCE_NIST : NTIME_SOURCE_NTP_POOL;
            g_last_sync = system_time_now();
            strncpy(g_current_server, ntp_servers[i], sizeof(g_current_server) - 1);
            pthread_mutex_unlock(&g_lock);
            return 0;
        }
    }
    return -1; /* All servers unreachable */
}

int national_time_set_timezone(const char *tz) {
    if (!tz) return -1;
    pthread_mutex_lock(&g_lock);
    strncpy(g_national_tz, tz, sizeof(g_national_tz) - 1);
    pthread_mutex_unlock(&g_lock);
    return 0;
}

int national_time_set_manual(national_usec_t reference_usec) {
    national_usec_t sys = system_time_now();
    pthread_mutex_lock(&g_lock);
    g_offset_usec = (int64_t)reference_usec - (int64_t)sys;
    g_source = NTIME_SOURCE_ADMIN;
    g_last_sync = sys;
    g_stratum = 0; /* Admin-set = authoritative */
    strncpy(g_current_server, "admin-manual", sizeof(g_current_server) - 1);
    pthread_mutex_unlock(&g_lock);
    return 0;
}

int national_time_register_program(const char *program_name,
                                    const char *compliance_domain) {
    if (g_program_count >= MAX_REGISTERED_PROGRAMS) return -1;

    pthread_mutex_lock(&g_lock);
    int idx = g_program_count++;
    strncpy(g_programs[idx].name, program_name, sizeof(g_programs[idx].name) - 1);
    strncpy(g_programs[idx].domain, compliance_domain, sizeof(g_programs[idx].domain) - 1);
    g_programs[idx].registered_at = national_time_now();
    pthread_mutex_unlock(&g_lock);

    /* Log registration */
    char ts[40];
    national_time_format(g_programs[idx].registered_at, ts, sizeof(ts));
    fprintf(stderr, "[national-time] Program registered: %s (domain: %s) at %s\n",
            program_name, compliance_domain, ts);

    return 0;
}
