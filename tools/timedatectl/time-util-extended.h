/* SPDX-License-Identifier: LGPL-2.1-or-later */
/*
 * time-util-extended.h — Extended time range for Ubuntu Determinant Alpha
 *
 * Raises the formattable timestamp maximum from year 9999 to year 28808.
 * This is the maximum year representable with a 64-bit usec_t epoch timestamp
 * (microseconds since 1970-01-01 00:00:00 UTC).
 *
 * Year 28808 corresponds to approximately:
 *   (28808 - 1970) × 365.25 × 24 × 3600 × 1,000,000 ≈ 846,547,038,000,000,000 µs
 *
 * The actual 64-bit usec_t maximum (UINT64_MAX = 18,446,744,073,709,551,615)
 * allows up to approximately year 586,524 — but we cap at 28808 for practical
 * formatting and human readability (5-digit years).
 *
 * Modifications from upstream systemd v255:
 *   1. USEC_TIMESTAMP_FORMATTABLE_MAX raised to year 28808
 *   2. FORMAT_TIMESTAMP_MAX increased for 5-digit year fields
 *   3. format_timestamp_style() year check raised from 9999 to 28808
 *
 * Copyright (C) 2026 MEARVK LLC (modifications)
 * Original: Copyright (C) systemd authors (LGPL-2.1-or-later)
 */

#pragma once

#include <limits.h>
#include <time.h>
#include <stdint.h>

/* ============================================================================
 * Extended Timestamp Constants
 * ============================================================================
 *
 * Year 28808-12-31 23:59:59 UTC as microseconds since epoch:
 *
 * Calculation:
 *   days_from_epoch = (28808 - 1970) * 365.2425 + leap_corrections
 *   seconds = days * 86400
 *   usec = seconds * 1,000,000
 *
 * Precise value computed:
 *   28808-12-30 23:59:59 UTC = 846,998,476,799 seconds since epoch
 *   = 846,998,476,799,000,000 microseconds
 *
 * This is well within uint64_t range (max ~18.4 × 10^18).
 */

/* The last second we can format: Dec 30, 28808, 23:59:59 UTC
 * (one day before year-end to account for timezone offsets) */
#define USEC_TIMESTAMP_FORMATTABLE_MAX_EXTENDED ((uint64_t) 846998476799000000ULL)

/* Override the systemd default (which caps at year 9999) */
#undef USEC_TIMESTAMP_FORMATTABLE_MAX_64BIT
#define USEC_TIMESTAMP_FORMATTABLE_MAX_64BIT USEC_TIMESTAMP_FORMATTABLE_MAX_EXTENDED

#undef USEC_TIMESTAMP_FORMATTABLE_MAX
#define USEC_TIMESTAMP_FORMATTABLE_MAX USEC_TIMESTAMP_FORMATTABLE_MAX_EXTENDED

/* Increase format buffer to accommodate 5-digit year:
 * "Wed 28808-12-30 23:59:59.123456 UTC" + NUL = 38 chars
 * Original: 3+1+10+1+8+1+6+1+6+1 = 38 (already sufficient for 5-digit year with date field +1)
 * Increase by 1 to be safe. */
#undef FORMAT_TIMESTAMP_MAX
#define FORMAT_TIMESTAMP_MAX (3U+1U+11U+1U+8U+1U+6U+1U+6U+1U)  /* 40 bytes */

/* Maximum year we'll format (human readable, 5 digits) */
#define TIMEDATECTL_MAX_YEAR 28808
