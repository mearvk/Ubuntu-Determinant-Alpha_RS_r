/* SPDX-License-Identifier: GPL-2.0 */
/*
 * time_access.h — Soft Access Control for System Time Operations
 *
 * Provides two soft-access mechanisms that bypass the full sudo_gate
 * ceremony while maintaining security:
 *
 *   1. TIME KEY (known secret)
 *      A passphrase hashed with SHA-256. If the operator knows the key,
 *      they can set the time without "sudo touch system". The key is
 *      stored as a hash — never plaintext on disk.
 *
 *   2. TIME PERMUTATION (mathematical proof-of-intent)
 *      A deterministic function of the current time and a seed.
 *      The operator must compute the correct permutation value to prove
 *      they are intentionally setting the time (not a script/accident).
 *      No errors in the math — the function is simple modular arithmetic.
 *
 *   3. DAVE (AI advisory + limited auto-correct)
 *      Dave can observe both clocks, detect drift, and:
 *        - Auto-correct within ±5 seconds (confidence 95%+, 5 voters agree)
 *        - Request admin correction for larger drifts
 *        - CANNOT set arbitrary time values
 *        - CANNOT override admin-set times
 *        - CANNOT disable NTP
 *
 * Philosophy:
 *   The gate (Grade 7) is the formal path. The key and permute are the
 *   "I know what I'm doing" paths — softer, but still authenticated.
 *   Dave is the careful steward — corrects small drifts silently,
 *   escalates large ones to a human.
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#ifndef __TIME_ACCESS_H
#define __TIME_ACCESS_H

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

/* ============================================================================
 * TIME KEY — Known Secret
 * ============================================================================
 *
 * The admin sets a time key at install time (or changes it later).
 * The key is stored as SHA-256(passphrase + salt) in /etc/time-key.hash.
 * To set time with the key:
 *
 *   timedatectl set-time --key "my passphrase" "2502-01-01 00:00:00"
 *
 * Or interactively:
 *   timedatectl set-time --key-prompt "2502-01-01 00:00:00"
 *   Enter time key: ********
 *
 * The key provides Grade 7 equivalent access for time operations ONLY.
 * It does not grant any other system privilege.
 */

/** Hash file location */
#define TIME_KEY_HASH_PATH  "/etc/time-key.hash"

/** Salt file (random 32 bytes, generated at install) */
#define TIME_KEY_SALT_PATH  "/etc/time-key.salt"

/**
 * Verify a time key passphrase against the stored hash.
 * Uses constant-time comparison — no timing side-channel.
 * Returns true if the key is correct.
 */
bool time_key_verify(const char *passphrase);

/**
 * Set/change the time key (requires Grade 7 to change the key itself).
 * Generates random salt, computes SHA-256(passphrase + salt), stores both.
 */
int time_key_set(const char *new_passphrase);

/**
 * Check if a time key is configured (hash file exists and is valid).
 */
bool time_key_configured(void);

/* ============================================================================
 * TIME PERMUTATION — Mathematical Proof-of-Intent
 * ============================================================================
 *
 * A simple, deterministic function that the operator computes mentally
 * or with a calculator. Proves they are intentionally invoking the
 * time change (not a runaway script or accident).
 *
 * The permutation function:
 *   permute(target_year, target_month, target_day, seed) =
 *       ((target_year × 31 + target_month × 7 + target_day) × seed) mod 9973
 *
 * 9973 is prime. The result is a 4-digit number (0000–9972).
 * The seed is stored in /etc/time-permute.seed (a small integer 1–9999).
 *
 * Usage:
 *   timedatectl set-time --permute 4821 "2502-06-15 12:00:00"
 *
 * The system computes the expected permutation for the target date and
 * compares. If they match, access is granted. If not: denied.
 *
 * Why this works:
 *   - A script that blindly calls set-time won't know the permute value
 *   - The operator computes it from the TARGET date (so they've read it)
 *   - The seed is per-system (so you can't pre-compute for all systems)
 *   - The math is trivial — no floating point, no rounding errors
 *   - Constant-time comparison — no partial-match leakage
 *
 * No errors in the math:
 *   - All integer arithmetic
 *   - Modular reduction (always yields 0..9972)
 *   - Multiplication is mod 2^64 safe (year×31 fits in 32 bits)
 *   - The prime 9973 is small enough for mental arithmetic
 */

/** Seed file location */
#define TIME_PERMUTE_SEED_PATH "/etc/time-permute.seed"

/** The prime modulus — result is always 0..9972 */
#define TIME_PERMUTE_MODULUS   9973

/**
 * Compute the expected permutation value for a target date.
 * This is what the operator should compute and provide.
 */
uint32_t time_permute_compute(int target_year, int target_month, int target_day);

/**
 * Verify a permutation value against the target date.
 * Returns true if the provided permute matches the expected value.
 * Constant-time comparison.
 */
bool time_permute_verify(uint32_t provided, int target_year, int target_month, int target_day);

/**
 * Get the current seed (for the operator to use in their calculation).
 * This is not secret — it's just per-system. Displayed by:
 *   timedatectl permute-info
 */
uint32_t time_permute_get_seed(void);

/**
 * Set a new permutation seed (Grade 7 required to change).
 */
int time_permute_set_seed(uint32_t new_seed);

/* ============================================================================
 * DAVE — AI Time Steward
 * ============================================================================
 *
 * Dave's relationship to system time:
 *
 * CAN DO (autonomously, no human needed):
 *   - Read system clock and national clock
 *   - Detect drift between the two
 *   - Auto-correct drift within ±5 seconds (if all 5 voters agree at 95%+)
 *   - Log all time observations and corrections
 *   - Alert admin via chat when drift exceeds threshold
 *
 * CAN DO (with admin acknowledgment via chat):
 *   - Correct drift up to ±60 seconds
 *   - Switch NTP servers if current is unreachable
 *   - Adjust sync interval based on drift pattern
 *
 * CANNOT DO (requires human Grade 7 gate):
 *   - Set time to an arbitrary value
 *   - Set time to the future (beyond current + 60s)
 *   - Disable NTP
 *   - Override admin-set time
 *   - Change the time key or permute seed
 *
 * CONTROL LIMITS:
 *   dave_max_correction_usec: Maximum one-shot correction (±5,000,000 µs = ±5s)
 *   dave_max_daily_correction_usec: Maximum total correction per day (±30s)
 *   dave_confidence_threshold: Minimum confidence for auto-correction (0.95)
 *   dave_voter_agreement: All 5 voters must agree (safety, correctness, ethics,
 *                         performance, elegance)
 */

/** Maximum single correction Dave can apply (microseconds) */
#define DAVE_MAX_CORRECTION_USEC       (5ULL * 1000000)   /* ±5 seconds */

/** Maximum total correction Dave can apply in 24 hours */
#define DAVE_MAX_DAILY_CORRECTION_USEC (30ULL * 1000000)  /* ±30 seconds */

/** Minimum confidence threshold for auto-correction */
#define DAVE_CONFIDENCE_THRESHOLD      0.95

/** Dave's correction must be toward national time (not away from it) */
#define DAVE_DIRECTION_TOWARD_NATIONAL true

/**
 * Dave's time correction request.
 */
struct dave_time_request {
    int64_t  correction_usec;    /* Signed: positive = advance, negative = retard */
    double   confidence;         /* 0.0–1.0 */
    bool     voters[5];          /* safety, correctness, ethics, performance, elegance */
    char     reason[256];        /* Why Dave wants to correct */
    uint64_t national_time_usec; /* What national clock says */
    uint64_t system_time_usec;   /* What system clock says */
    int64_t  observed_drift;     /* system - national (µs) */
};

/**
 * Dave requests a time correction.
 * Returns 0 if applied, -1 if denied (exceeds limits or low confidence).
 *
 * This function enforces:
 *   1. |correction| ≤ DAVE_MAX_CORRECTION_USEC
 *   2. Daily total ≤ DAVE_MAX_DAILY_CORRECTION_USEC
 *   3. confidence ≥ DAVE_CONFIDENCE_THRESHOLD
 *   4. All 5 voters agree
 *   5. Correction moves system clock TOWARD national time (not away)
 *   6. Audit logged
 */
int dave_time_correct(const struct dave_time_request *request);

/**
 * Dave observes the current drift (no correction, just logging).
 * Called every monitoring cycle (~285 times/minute).
 */
void dave_time_observe(int64_t drift_usec);

/**
 * Get Dave's cumulative daily correction total (for limit tracking).
 */
int64_t dave_time_daily_total(void);

/**
 * Reset Dave's daily counter (called at midnight UTC).
 */
void dave_time_daily_reset(void);

/**
 * Check if Dave is allowed to make a correction right now.
 * Returns true if within daily budget and not admin-overridden.
 */
bool dave_time_can_correct(int64_t proposed_correction_usec);

#ifdef __cplusplus
}
#endif

#endif /* __TIME_ACCESS_H */
