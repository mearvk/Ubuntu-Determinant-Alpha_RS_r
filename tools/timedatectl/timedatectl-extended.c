/* SPDX-License-Identifier: LGPL-2.1-or-later */
/*
 * timedatectl-extended.c — Modified timedatectl for year 28808 support
 *
 * This is a patched version of systemd's timedatectl that allows setting
 * the system time to any date up to year 28808 (the practical limit of
 * 64-bit microsecond timestamps for human-readable formatting).
 *
 * Changes from upstream systemd v255 (src/timedate/timedatectl.c):
 *   1. Includes time-util-extended.h to override USEC_TIMESTAMP_FORMATTABLE_MAX
 *   2. Modifies the set-time verb to validate against year 28808 (not 9999)
 *   3. Modifies format_timestamp output to handle 5-digit years
 *   4. Standalone binary — does not require full systemd rebuild
 *
 * This binary is a WRAPPER around the system's timedatectl for most operations.
 * For set-time specifically, it directly calls the D-Bus SetTime method with
 * the extended timestamp, bypassing the upstream year validation.
 *
 * Build:
 *   gcc -O2 -Wall -o timedatectl-extended timedatectl-extended.c \
 *       $(pkg-config --cflags --libs libsystemd) -lm
 *
 * Install:
 *   sudo cp timedatectl-extended /usr/local/bin/timedatectl
 *   (or replace /usr/bin/timedatectl with appropriate backup)
 *
 * Usage (same as standard timedatectl):
 *   timedatectl set-time "2502-06-15 12:00:00"
 *   timedatectl set-time "28808-01-01 00:00:00"
 *   timedatectl status
 *
 * Copyright (C) 2026 MEARVK LLC (this wrapper)
 * Original timedatectl: Copyright (C) systemd authors (LGPL-2.1-or-later)
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <errno.h>
#include <stdbool.h>
#include <stdint.h>
#include <inttypes.h>
#include <math.h>
#include <unistd.h>
#include <sys/types.h>
#include <systemd/sd-bus.h>

#include "time-util-extended.h"

/* ============================================================================
 * Constants
 * ============================================================================ */

#define USEC_PER_SEC  ((uint64_t) 1000000ULL)
#define USEC_PER_MIN  ((uint64_t) 60ULL * USEC_PER_SEC)
#define USEC_PER_HOUR ((uint64_t) 3600ULL * USEC_PER_SEC)
#define USEC_PER_DAY  ((uint64_t) 86400ULL * USEC_PER_SEC)

#define PROGRAM_NAME "timedatectl"
#define VERSION_STRING "255.4-extended-28808"

/* ============================================================================
 * Extended Timestamp Parser
 *
 * Parses timestamps in the format:
 *   YYYY-MM-DD HH:MM:SS
 *   YYYY-MM-DD HH:MM
 *   YYYY-MM-DD
 *
 * Supports years from 1970 to 28808.
 * ============================================================================ */

/**
 * Returns 1 if year is a leap year, 0 otherwise.
 */
static int is_leap_year(long year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
}

/**
 * Returns the number of days in a given month (1-based) for a given year.
 */
static int days_in_month(long year, int month) {
    static const int days[] = {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    if (month == 2 && is_leap_year(year))
        return 29;
    return days[month];
}

/**
 * Convert a broken-down date/time to microseconds since Unix epoch.
 * Supports years 1970–28808.
 *
 * Returns 0 on success, -1 on error.
 */
static int datetime_to_usec(long year, int month, int day,
                            int hour, int minute, int second,
                            uint64_t *ret_usec) {
    /* Validate ranges */
    if (year < 1970 || year > TIMEDATECTL_MAX_YEAR) {
        fprintf(stderr, "Year %ld out of range (1970–%d).\n", year, TIMEDATECTL_MAX_YEAR);
        return -1;
    }
    if (month < 1 || month > 12) {
        fprintf(stderr, "Month %d out of range (1–12).\n", month);
        return -1;
    }
    if (day < 1 || day > days_in_month(year, month)) {
        fprintf(stderr, "Day %d out of range for %ld-%02d (max %d).\n",
                day, year, month, days_in_month(year, month));
        return -1;
    }
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59 || second < 0 || second > 59) {
        fprintf(stderr, "Time %02d:%02d:%02d out of range.\n", hour, minute, second);
        return -1;
    }

    /* Count days from epoch (1970-01-01) to the target date */
    uint64_t total_days = 0;

    /* Full years */
    for (long y = 1970; y < year; y++) {
        total_days += is_leap_year(y) ? 366 : 365;
    }

    /* Full months in the target year */
    for (int m = 1; m < month; m++) {
        total_days += days_in_month(year, m);
    }

    /* Days in the target month */
    total_days += (day - 1);

    /* Convert to microseconds */
    uint64_t usec = total_days * USEC_PER_DAY
                  + (uint64_t)hour * USEC_PER_HOUR
                  + (uint64_t)minute * USEC_PER_MIN
                  + (uint64_t)second * USEC_PER_SEC;

    /* Sanity check against our maximum */
    if (usec > USEC_TIMESTAMP_FORMATTABLE_MAX) {
        fprintf(stderr, "Timestamp exceeds maximum representable value (year %d max).\n",
                TIMEDATECTL_MAX_YEAR);
        return -1;
    }

    *ret_usec = usec;
    return 0;
}

/**
 * Parse a timestamp string into microseconds since epoch.
 * Accepts:
 *   "YYYY-MM-DD HH:MM:SS"
 *   "YYYY-MM-DD HH:MM"
 *   "YYYY-MM-DDTHH:MM:SS"
 *   "YYYY-MM-DD"
 */
static int parse_timestamp_extended(const char *str, uint64_t *ret_usec) {
    long year;
    int month, day, hour = 0, minute = 0, second = 0;
    int fields;

    /* Try full datetime with seconds */
    fields = sscanf(str, "%ld-%d-%d %d:%d:%d", &year, &month, &day, &hour, &minute, &second);
    if (fields < 3) {
        /* Try ISO 8601 T separator */
        fields = sscanf(str, "%ld-%d-%dT%d:%d:%d", &year, &month, &day, &hour, &minute, &second);
    }

    if (fields < 3) {
        fprintf(stderr, "Failed to parse timestamp: '%s'\n", str);
        fprintf(stderr, "Expected format: YYYY-MM-DD [HH:MM[:SS]]\n");
        fprintf(stderr, "Supported range: 1970-01-01 to %d-12-31\n", TIMEDATECTL_MAX_YEAR);
        return -1;
    }

    return datetime_to_usec(year, month, day, hour, minute, second, ret_usec);
}

/* ============================================================================
 * D-Bus Interface to systemd-timedated
 * ============================================================================ */

/**
 * Set the system time via D-Bus call to systemd-timedated.
 * This bypasses timedatectl's own year validation and sends the raw
 * microsecond timestamp directly to the timedated daemon.
 */
static int set_time_dbus(uint64_t usec) {
    sd_bus *bus = NULL;
    sd_bus_error error = SD_BUS_ERROR_NULL;
    int r;

    r = sd_bus_open_system(&bus);
    if (r < 0) {
        fprintf(stderr, "Failed to connect to system bus: %s\n", strerror(-r));
        return r;
    }

    /*
     * org.freedesktop.timedate1.SetTime(INT64 usec_utc, BOOLEAN relative, BOOLEAN interactive)
     *
     * usec_utc: Microseconds since epoch (absolute) or relative adjustment
     * relative: If true, usec_utc is added to current time
     * interactive: If true, polkit may prompt for authentication
     */
    r = sd_bus_call_method(
        bus,
        "org.freedesktop.timedate1",           /* service */
        "/org/freedesktop/timedate1",          /* path */
        "org.freedesktop.timedate1",           /* interface */
        "SetTime",                              /* method */
        &error,                                 /* error */
        NULL,                                   /* reply */
        "xbb",                                  /* signature: int64, bool, bool */
        (int64_t)usec,                          /* usec_utc (absolute) */
        false,                                  /* relative = false */
        true                                    /* interactive = true (allow polkit) */
    );

    if (r < 0) {
        fprintf(stderr, "Failed to set time: %s\n",
                error.message ? error.message : strerror(-r));
        sd_bus_error_free(&error);
        sd_bus_unref(bus);
        return r;
    }

    sd_bus_error_free(&error);
    sd_bus_unref(bus);
    return 0;
}

/* ============================================================================
 * Format Extended Timestamp (for display)
 * ============================================================================ */

/**
 * Format a usec timestamp into human-readable string.
 * Handles years up to 28808 (5-digit year field).
 */
static void format_usec_to_string(uint64_t usec, char *buf, size_t len) {
    /* Convert usec back to broken-down time */
    uint64_t total_seconds = usec / USEC_PER_SEC;
    uint64_t remaining_days = total_seconds / 86400;
    uint64_t day_seconds = total_seconds % 86400;

    int hour = (int)(day_seconds / 3600);
    int minute = (int)((day_seconds % 3600) / 60);
    int second = (int)(day_seconds % 60);

    /* Calculate year/month/day from days since epoch */
    long year = 1970;
    while (1) {
        int days_this_year = is_leap_year(year) ? 366 : 365;
        if (remaining_days < (uint64_t)days_this_year)
            break;
        remaining_days -= days_this_year;
        year++;
    }

    int month = 1;
    while (1) {
        int days_this_month = days_in_month(year, month);
        if (remaining_days < (uint64_t)days_this_month)
            break;
        remaining_days -= days_this_month;
        month++;
    }

    int day = (int)remaining_days + 1;

    snprintf(buf, len, "%ld-%02d-%02d %02d:%02d:%02d UTC", year, month, day, hour, minute, second);
}

/* ============================================================================
 * Privilege Enforcement — sudo_gate Grade 7+ Required
 * ============================================================================
 *
 * Setting, altering, or disabling the system clock is a Grade 7 (Critical System)
 * operation under the sudo_gate graded privilege system.
 *
 * Rationale:
 *   - Time is a foundational system primitive. All logs, cron, certificates,
 *     TLS handshakes, ACH windows, and legal filings depend on it.
 *   - A wrong time setting can invalidate TLS certificates (appear expired),
 *     break Kerberos authentication, cause financial transaction failures,
 *     and corrupt audit trails.
 *   - This is not a "maintenance" operation (Grade 3). It is critical.
 *
 * Required invocation:
 *   sudo touch system timedatectl set-time "2502-01-01 00:00:00"
 *   sudo touch system timedatectl set-ntp false
 *
 * NOT sufficient:
 *   sudo timedatectl set-time "..."     ← Grade 3 only, DENIED
 *   timedatectl set-time "..."          ← No privilege, DENIED
 *
 * Grade reference (from sudo_gate):
 *   Grade 5: Storage (mount, fdisk)
 *   Grade 6: Kernel (sysctl, modprobe)
 *   Grade 7: Critical System (visudo, passwd root, grub-install, timedatectl set-time)
 *   Grade 8: Gate/Irreversible (dd, mkfs, rm -rf /)
 *
 * The "set-time" and "set-ntp" verbs require Grade 7.
 * The "status" and "list-timezones" verbs require no privilege (read-only).
 * The "set-timezone" verb requires Grade 5 (operational, reversible).
 */

#define REQUIRED_GRADE_SET_TIME     7
#define REQUIRED_GRADE_SET_NTP      7
#define REQUIRED_GRADE_SET_TIMEZONE 5
#define REQUIRED_GRADE_STATUS       0  /* Anyone can read status */

/**
 * Check if the current invocation has the required sudo_gate grade.
 *
 * Detection method:
 *   sudo_gate sets environment variables when granting elevated access:
 *     SUDO_GATE_GRADE=7
 *     SUDO_GATE_COMMAND=timedatectl
 *     SUDO_GATE_INVOCATION=touch system
 *
 *   If these are absent, the user invoked with plain sudo (Grade 3 max)
 *   or without sudo at all (Grade 0).
 *
 * Returns: the current effective grade (0-8), or -1 on error.
 */
static int get_current_gate_grade(void) {
    /* Check if running as root at all */
    if (getuid() != 0 && geteuid() != 0) {
        return 0; /* No privilege */
    }

    /* Check for sudo_gate environment */
    const char *grade_str = getenv("SUDO_GATE_GRADE");
    if (grade_str) {
        int grade = atoi(grade_str);
        if (grade >= 1 && grade <= 8) {
            return grade;
        }
    }

    /* Check for the sudo_gate invocation marker in process ancestry.
     * If /proc/self/environ contains SUDO_GATE_GRADE, trust it.
     * If only SUDO_USER is set (plain sudo), that's Grade 3 max. */
    const char *sudo_user = getenv("SUDO_USER");
    if (sudo_user) {
        /* Plain sudo without gate — this is Grade 3 (Maintenance) max */
        return 3;
    }

    /* Running as root directly (not via sudo) — could be init or login shell */
    if (getuid() == 0) {
        return 6; /* Kernel-level by default for direct root */
    }

    return 0;
}

/**
 * Enforce minimum grade requirement. Prints error and exits if insufficient.
 */
static void enforce_grade(int required, const char *operation) {
    int current = get_current_gate_grade();

    if (current >= required) {
        return; /* Sufficient privilege */
    }

    fprintf(stderr,
        "═══════════════════════════════════════════════════════════════\n"
        "  ACCESS DENIED — Insufficient sudo_gate grade\n"
        "═══════════════════════════════════════════════════════════════\n"
        "  Operation:  %s\n"
        "  Required:   Grade %d (%s)\n"
        "  Current:    Grade %d\n"
        "\n", operation, required,
        required == 7 ? "Critical System" :
        required == 5 ? "Storage/Network" : "Unknown",
        current);

    if (current == 0) {
        fprintf(stderr,
            "  You must use sudo with the appropriate gate:\n"
            "    sudo touch system timedatectl %s ...\n"
            "\n", operation);
    } else if (current <= 3) {
        fprintf(stderr,
            "  Plain 'sudo' provides Grade 3 (Maintenance) only.\n"
            "  Time operations require Grade %d (Critical System).\n"
            "\n"
            "  Correct invocation:\n"
            "    sudo touch system timedatectl %s ...\n"
            "\n"
            "  This is friction by design. Changing the system clock affects:\n"
            "    • TLS certificate validity\n"
            "    • Kerberos/SASL authentication\n"
            "    • ACH/financial processing windows\n"
            "    • All audit trail timestamps\n"
            "    • Cron job scheduling\n"
            "    • Log correlation across systems\n"
            "\n", required, operation);
    } else {
        fprintf(stderr,
            "  Your current grade (%d) is below the required grade (%d).\n"
            "  Escalate with: sudo touch system timedatectl %s ...\n"
            "\n", current, required, operation);
    }

    fprintf(stderr,
        "═══════════════════════════════════════════════════════════════\n");

    exit(77); /* Exit code 77 = permission denied by gate */
}

static int cmd_set_time(const char *timestr) {
    /* Grade 7 required: Critical System operation */
    enforce_grade(REQUIRED_GRADE_SET_TIME, "set-time");

    uint64_t usec;
    char formatted[64];
    int r;

    printf("Parsing: %s\n", timestr);

    r = parse_timestamp_extended(timestr, &usec);
    if (r < 0)
        return 1;

    format_usec_to_string(usec, formatted, sizeof(formatted));
    printf("Setting time to: %s (%" PRIu64 " µs since epoch)\n", formatted, usec);

    r = set_time_dbus(usec);
    if (r < 0)
        return 1;

    printf("Time set successfully.\n");
    return 0;
}

static int cmd_status(void) {
    /* For status, delegate to the system's timedatectl */
    return system("/usr/bin/timedatectl status");
}

static int cmd_set_timezone(const char *tz) {
    /* Grade 5 required: Network/operational setting (reversible) */
    enforce_grade(REQUIRED_GRADE_SET_TIMEZONE, "set-timezone");

    char cmd[512];
    snprintf(cmd, sizeof(cmd), "/usr/bin/timedatectl set-timezone '%s'", tz);
    return system(cmd);
}

static int cmd_set_ntp(const char *val) {
    /* Grade 7 required: Disabling NTP has critical time implications */
    enforce_grade(REQUIRED_GRADE_SET_NTP, "set-ntp");

    char cmd[256];
    snprintf(cmd, sizeof(cmd), "/usr/bin/timedatectl set-ntp %s", val);
    return system(cmd);
}

static int cmd_list_timezones(void) {
    return system("/usr/bin/timedatectl list-timezones");
}

static void usage(void) {
    printf(
        "timedatectl — Extended Time Control (year 28808 support)\n"
        "Version: %s\n"
        "Ubuntu Determinant Alpha — Galactic Cherry Marvell Edition 98\n"
        "\n"
        "Usage:\n"
        "  timedatectl status                    Show current time settings\n"
        "  timedatectl set-time TIME             Set system time (up to year %d)\n"
        "  timedatectl set-timezone ZONE         Set system timezone\n"
        "  timedatectl set-ntp BOOL              Enable/disable NTP sync\n"
        "  timedatectl list-timezones            List available timezones\n"
        "  timedatectl --help                    Show this help\n"
        "\n"
        "Extended time range:\n"
        "  Standard timedatectl: years 1970–9999\n"
        "  This version:         years 1970–%d\n"
        "\n"
        "Examples:\n"
        "  timedatectl set-time \"2502-06-15 12:00:00\"\n"
        "  timedatectl set-time \"28808-01-01 00:00:00\"\n"
        "  timedatectl set-time \"2026-08-11 23:30:00\"\n"
        "\n"
        "Notes:\n"
        "  - NTP must be disabled before setting time manually:\n"
        "      timedatectl set-ntp false\n"
        "  - The kernel clock (time_t on 64-bit Linux) supports this full range\n"
        "  - 32-bit time_t systems are limited to year 2038 (Y2K38 problem)\n"
        "  - This system uses 64-bit time_t (no Y2K38 issue)\n"
        "\n"
        "Copyright (C) 2026 MEARVK LLC\n"
        "License: LGPL-2.1-or-later (systemd base) + GPL-2.0 (extensions)\n",
        VERSION_STRING, TIMEDATECTL_MAX_YEAR, TIMEDATECTL_MAX_YEAR
    );
}

/* ============================================================================
 * Main
 * ============================================================================ */

int main(int argc, char *argv[]) {
    if (argc < 2) {
        return cmd_status();
    }

    if (strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-h") == 0) {
        usage();
        return 0;
    }

    if (strcmp(argv[1], "--version") == 0) {
        printf("timedatectl %s\n", VERSION_STRING);
        return 0;
    }

    if (strcmp(argv[1], "status") == 0) {
        return cmd_status();
    }

    if (strcmp(argv[1], "set-time") == 0) {
        if (argc < 3) {
            fprintf(stderr, "Usage: timedatectl set-time \"YYYY-MM-DD HH:MM:SS\"\n");
            fprintf(stderr, "Supported range: 1970 to %d\n", TIMEDATECTL_MAX_YEAR);
            return 1;
        }
        return cmd_set_time(argv[2]);
    }

    if (strcmp(argv[1], "set-timezone") == 0) {
        if (argc < 3) {
            fprintf(stderr, "Usage: timedatectl set-timezone ZONE\n");
            return 1;
        }
        return cmd_set_timezone(argv[2]);
    }

    if (strcmp(argv[1], "set-ntp") == 0) {
        if (argc < 3) {
            fprintf(stderr, "Usage: timedatectl set-ntp true|false\n");
            return 1;
        }
        return cmd_set_ntp(argv[2]);
    }

    if (strcmp(argv[1], "list-timezones") == 0) {
        return cmd_list_timezones();
    }

    /* Unknown command — pass through to system timedatectl */
    char cmd[4096] = "/usr/bin/timedatectl";
    for (int i = 1; i < argc; i++) {
        strcat(cmd, " '");
        strncat(cmd, argv[i], 256);
        strcat(cmd, "'");
    }
    return system(cmd);
}
