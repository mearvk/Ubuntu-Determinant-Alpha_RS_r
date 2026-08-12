/* SPDX-License-Identifier: GPL-2.0 */
/*
 * time_access.c — Implementation of soft time access control
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#define _GNU_SOURCE
#define _DEFAULT_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include <time.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <errno.h>

#include "time_access.h"

/* ============================================================================
 * SHA-256 (minimal implementation — no external dependency)
 * ============================================================================
 * We include a minimal SHA-256 to avoid linking OpenSSL just for this.
 * For production, use the kernel's crypto API or libgcrypt.
 */

static uint32_t sha256_k[64] = {
    0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
    0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
    0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
    0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
    0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
    0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
    0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
    0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
};

#define RR(x,n) (((x)>>(n))|((x)<<(32-(n))))
#define CH(x,y,z) (((x)&(y))^(~(x)&(z)))
#define MAJ(x,y,z) (((x)&(y))^((x)&(z))^((y)&(z)))
#define S0(x) (RR(x,2)^RR(x,13)^RR(x,22))
#define S1(x) (RR(x,6)^RR(x,11)^RR(x,25))
#define s0(x) (RR(x,7)^RR(x,18)^((x)>>3))
#define s1(x) (RR(x,17)^RR(x,19)^((x)>>10))

static void sha256(const uint8_t *data, size_t len, uint8_t out[32]) {
    uint32_t h[8] = {
        0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,
        0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19
    };

    /* Pad message */
    size_t padded_len = ((len + 9 + 63) / 64) * 64;
    uint8_t *msg = calloc(padded_len, 1);
    if (!msg) return;
    memcpy(msg, data, len);
    msg[len] = 0x80;
    uint64_t bit_len = len * 8;
    for (int i = 0; i < 8; i++)
        msg[padded_len - 1 - i] = (uint8_t)(bit_len >> (i * 8));

    /* Process blocks */
    for (size_t blk = 0; blk < padded_len; blk += 64) {
        uint32_t w[64];
        for (int i = 0; i < 16; i++)
            w[i] = ((uint32_t)msg[blk+i*4]<<24)|((uint32_t)msg[blk+i*4+1]<<16)|
                   ((uint32_t)msg[blk+i*4+2]<<8)|msg[blk+i*4+3];
        for (int i = 16; i < 64; i++)
            w[i] = s1(w[i-2]) + w[i-7] + s0(w[i-15]) + w[i-16];

        uint32_t a=h[0],b=h[1],c=h[2],d=h[3],e=h[4],f=h[5],g=h[6],hh=h[7];
        for (int i = 0; i < 64; i++) {
            uint32_t t1 = hh + S1(e) + CH(e,f,g) + sha256_k[i] + w[i];
            uint32_t t2 = S0(a) + MAJ(a,b,c);
            hh=g; g=f; f=e; e=d+t1; d=c; c=b; b=a; a=t1+t2;
        }
        h[0]+=a; h[1]+=b; h[2]+=c; h[3]+=d; h[4]+=e; h[5]+=f; h[6]+=g; h[7]+=hh;
    }

    for (int i = 0; i < 8; i++) {
        out[i*4]   = (uint8_t)(h[i]>>24);
        out[i*4+1] = (uint8_t)(h[i]>>16);
        out[i*4+2] = (uint8_t)(h[i]>>8);
        out[i*4+3] = (uint8_t)(h[i]);
    }
    free(msg);
}

/* ============================================================================
 * Constant-time comparison (no timing side-channel)
 * ============================================================================ */

static bool constant_time_eq(const uint8_t *a, const uint8_t *b, size_t len) {
    volatile uint8_t diff = 0;
    for (size_t i = 0; i < len; i++) {
        diff |= a[i] ^ b[i];
    }
    return diff == 0;
}

/* ============================================================================
 * TIME KEY Implementation
 * ============================================================================ */

bool time_key_verify(const char *passphrase) {
    if (!passphrase) return false;

    /* Read salt */
    uint8_t salt[32];
    FILE *f = fopen(TIME_KEY_SALT_PATH, "rb");
    if (!f) return false;
    if (fread(salt, 1, 32, f) != 32) { fclose(f); return false; }
    fclose(f);

    /* Read stored hash */
    uint8_t stored_hash[32];
    f = fopen(TIME_KEY_HASH_PATH, "rb");
    if (!f) return false;
    if (fread(stored_hash, 1, 32, f) != 32) { fclose(f); return false; }
    fclose(f);

    /* Compute hash of passphrase + salt */
    size_t pass_len = strlen(passphrase);
    size_t total_len = pass_len + 32;
    uint8_t *input = malloc(total_len);
    if (!input) return false;
    memcpy(input, passphrase, pass_len);
    memcpy(input + pass_len, salt, 32);

    uint8_t computed_hash[32];
    sha256(input, total_len, computed_hash);

    /* Wipe passphrase from memory */
    memset(input, 0, total_len);
    free(input);

    /* Constant-time comparison */
    return constant_time_eq(stored_hash, computed_hash, 32);
}

int time_key_set(const char *new_passphrase) {
    if (!new_passphrase) return -1;

    /* Generate random salt */
    uint8_t salt[32];
    int fd = open("/dev/urandom", O_RDONLY);
    if (fd < 0) return -errno;
    if (read(fd, salt, 32) != 32) { close(fd); return -EIO; }
    close(fd);

    /* Compute hash */
    size_t pass_len = strlen(new_passphrase);
    size_t total_len = pass_len + 32;
    uint8_t *input = malloc(total_len);
    if (!input) return -ENOMEM;
    memcpy(input, new_passphrase, pass_len);
    memcpy(input + pass_len, salt, 32);

    uint8_t hash[32];
    sha256(input, total_len, hash);
    memset(input, 0, total_len);
    free(input);

    /* Write salt (mode 600 — root only) */
    FILE *f = fopen(TIME_KEY_SALT_PATH, "wb");
    if (!f) return -errno;
    fchmod(fileno(f), 0600);
    fwrite(salt, 1, 32, f);
    fclose(f);

    /* Write hash (mode 600 — root only) */
    f = fopen(TIME_KEY_HASH_PATH, "wb");
    if (!f) return -errno;
    fchmod(fileno(f), 0600);
    fwrite(hash, 1, 32, f);
    fclose(f);

    return 0;
}

bool time_key_configured(void) {
    return access(TIME_KEY_HASH_PATH, R_OK) == 0 &&
           access(TIME_KEY_SALT_PATH, R_OK) == 0;
}

/* ============================================================================
 * TIME PERMUTATION Implementation
 * ============================================================================ */

static uint32_t read_seed(void) {
    FILE *f = fopen(TIME_PERMUTE_SEED_PATH, "r");
    if (!f) return 1; /* Default seed = 1 if no file */
    uint32_t seed = 1;
    if (fscanf(f, "%u", &seed) != 1) seed = 1;
    fclose(f);
    if (seed == 0) seed = 1; /* Seed must be non-zero */
    return seed;
}

uint32_t time_permute_compute(int target_year, int target_month, int target_day) {
    uint32_t seed = read_seed();

    /*
     * The permutation function:
     *   result = ((year × 31 + month × 7 + day) × seed) mod 9973
     *
     * All integer arithmetic. No floating point. No rounding.
     * 9973 is prime — ensures good distribution.
     * Maximum intermediate: 28808 × 31 = 893,048 (fits in uint32_t easily).
     * 893,048 × 9999 (max seed) = 8,929,586,952 (fits in uint64_t).
     */
    uint64_t val = (uint64_t)target_year * 31 + (uint64_t)target_month * 7 + (uint64_t)target_day;
    val = (val * (uint64_t)seed) % TIME_PERMUTE_MODULUS;

    return (uint32_t)val;
}

bool time_permute_verify(uint32_t provided, int target_year, int target_month, int target_day) {
    uint32_t expected = time_permute_compute(target_year, target_month, target_day);

    /* Constant-time comparison (single uint32_t) */
    volatile uint32_t diff = provided ^ expected;
    return diff == 0;
}

uint32_t time_permute_get_seed(void) {
    return read_seed();
}

int time_permute_set_seed(uint32_t new_seed) {
    if (new_seed == 0 || new_seed > 9999) return -1;
    FILE *f = fopen(TIME_PERMUTE_SEED_PATH, "w");
    if (!f) return -errno;
    fchmod(fileno(f), 0600);
    fprintf(f, "%u\n", new_seed);
    fclose(f);
    return 0;
}

/* ============================================================================
 * DAVE Time Steward Implementation
 * ============================================================================ */

/* Daily correction accumulator */
static int64_t g_dave_daily_total_usec = 0;
static time_t  g_dave_daily_reset_time = 0;

/* Admin override flag — if true, Dave cannot correct */
static bool g_dave_locked_out = false;

void dave_time_observe(int64_t drift_usec) {
    /* Dave notes the drift. In the real implementation, this feeds into
     * his reasoning engine and MySQL knowledge base. Here we just track. */
    (void)drift_usec;
}

bool dave_time_can_correct(int64_t proposed_correction_usec) {
    if (g_dave_locked_out) return false;

    /* Check daily reset */
    time_t now = time(NULL);
    struct tm tm;
    gmtime_r(&now, &tm);
    time_t today_start = now - tm.tm_hour * 3600 - tm.tm_min * 60 - tm.tm_sec;
    if (today_start > g_dave_daily_reset_time) {
        g_dave_daily_total_usec = 0;
        g_dave_daily_reset_time = today_start;
    }

    /* Check single-correction limit */
    if ((uint64_t)llabs(proposed_correction_usec) > DAVE_MAX_CORRECTION_USEC)
        return false;

    /* Check daily budget */
    int64_t projected = g_dave_daily_total_usec + llabs(proposed_correction_usec);
    if ((uint64_t)llabs(projected) > DAVE_MAX_DAILY_CORRECTION_USEC)
        return false;

    return true;
}

int dave_time_correct(const struct dave_time_request *request) {
    if (!request) return -1;

    /* 1. Confidence check */
    if (request->confidence < DAVE_CONFIDENCE_THRESHOLD) {
        fprintf(stderr, "[Dave:Time] DENIED: Confidence %.2f < %.2f threshold\n",
                request->confidence, DAVE_CONFIDENCE_THRESHOLD);
        return -1;
    }

    /* 2. All 5 voters must agree */
    for (int i = 0; i < 5; i++) {
        if (!request->voters[i]) {
            const char *voter_names[] = {"safety", "correctness", "ethics", "performance", "elegance"};
            fprintf(stderr, "[Dave:Time] DENIED: Voter '%s' disagreed\n", voter_names[i]);
            return -1;
        }
    }

    /* 3. Correction size limit */
    if ((uint64_t)llabs(request->correction_usec) > DAVE_MAX_CORRECTION_USEC) {
        fprintf(stderr, "[Dave:Time] DENIED: Correction %+.3fs exceeds ±5s limit\n",
                (double)request->correction_usec / 1000000.0);
        fprintf(stderr, "[Dave:Time] For larger corrections, alert admin via chat.\n");
        return -1;
    }

    /* 4. Direction check: must move TOWARD national time */
    if (DAVE_DIRECTION_TOWARD_NATIONAL) {
        /* drift = system - national.
         * If drift > 0 (system ahead), correction should be negative (retard).
         * If drift < 0 (system behind), correction should be positive (advance). */
        if (request->observed_drift > 0 && request->correction_usec > 0) {
            fprintf(stderr, "[Dave:Time] DENIED: System is AHEAD but correction is positive (wrong direction)\n");
            return -1;
        }
        if (request->observed_drift < 0 && request->correction_usec < 0) {
            fprintf(stderr, "[Dave:Time] DENIED: System is BEHIND but correction is negative (wrong direction)\n");
            return -1;
        }
    }

    /* 5. Daily budget check */
    if (!dave_time_can_correct(request->correction_usec)) {
        fprintf(stderr, "[Dave:Time] DENIED: Daily correction budget exhausted (±30s/day)\n");
        return -1;
    }

    /* 6. APPROVED — apply correction */
    fprintf(stderr, "[Dave:Time] APPROVED: Correcting system clock by %+.6fs\n",
            (double)request->correction_usec / 1000000.0);
    fprintf(stderr, "[Dave:Time]   Reason: %s\n", request->reason);
    fprintf(stderr, "[Dave:Time]   Confidence: %.3f (all 5 voters agree)\n", request->confidence);
    fprintf(stderr, "[Dave:Time]   Observed drift: %+.6fs\n",
            (double)request->observed_drift / 1000000.0);

    /* Apply via adjtime (gradual slew, not step — less disruptive) */
    struct timeval delta;
    delta.tv_sec = (long)(request->correction_usec / 1000000);
    delta.tv_usec = (long)(request->correction_usec % 1000000);
    if (adjtime(&delta, NULL) != 0) {
        fprintf(stderr, "[Dave:Time] ERROR: adjtime() failed: %s\n", strerror(errno));
        fprintf(stderr, "[Dave:Time] Note: Requires root/CAP_SYS_TIME. Dave operates via national-timed daemon.\n");
        return -1;
    }

    /* Update daily accumulator */
    g_dave_daily_total_usec += llabs(request->correction_usec);

    /* Audit log */
    fprintf(stderr, "[Dave:Time] LOGGED: Correction applied. Daily total: %+.3fs / ±30s\n",
            (double)g_dave_daily_total_usec / 1000000.0);

    return 0;
}

int64_t dave_time_daily_total(void) {
    return g_dave_daily_total_usec;
}

void dave_time_daily_reset(void) {
    g_dave_daily_total_usec = 0;
    g_dave_daily_reset_time = time(NULL);
}
