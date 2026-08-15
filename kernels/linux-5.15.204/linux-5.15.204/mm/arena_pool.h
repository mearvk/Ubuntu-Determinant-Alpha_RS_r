/* SPDX-License-Identifier: GPL-2.0 */
/*
 * arena_pool.h — Hierarchical Pool Allocation with Logarithmic Decay
 *
 * Per-process 300 MB arena with binary halving cascade and (2/3) logarithmic
 * decay tiers. Safe malloc/free from pre-mapped virtual address space.
 *
 * Architecture:
 *   Level 0:  300 MB  (full arena — never allocated directly)
 *   Level 1:  150 MB  (primary hot working set)
 *   Level 2:   75 MB  (warm overflow, spill when L1 > 80%)
 *   Level 3+:  75 × (2/3)^(n-2) MB  (logarithmic decay tiers)
 *
 * Priority order:     (4, 3, 1, 2) → soft concern → (5, 6, 7, ...) → extend
 * Startup front-load: 1/8 upfront (37.5 MB committed) → (2, 3, 1, 2) sequence
 *
 * Integration:
 *   - JVM Memory Proxy configurable via -Xguard:arena=SIZE
 *   - USB Dynamic RAM provides backing for decay tiers 5+ (priority -5)
 *   - Per-User Kernel Objects: per-user arena (Grain 1: 4 MB, Grain 3: 64 MB)
 *   - CPU Boost: boosted processes get pre-faulted upfront at fork
 *   - Integrity Guardian: verifies 1:1 / 1:2 grid alignment per tier
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#ifndef _LINUX_ARENA_POOL_H
#define _LINUX_ARENA_POOL_H

#include <linux/types.h>
#include <linux/spinlock.h>

/* =========================================================================
 * Constants
 * ========================================================================= */

#define ARENA_SIZE_MB           300
#define ARENA_SIZE_BYTES        ((size_t)ARENA_SIZE_MB << 20)
#define ARENA_PRIMARY_MB        (ARENA_SIZE_MB / 2)         /* 150 MB */
#define ARENA_OVERFLOW_MB       (ARENA_SIZE_MB / 4)         /*  75 MB */
#define ARENA_FRONTLOAD_FRAC_NUM  1
#define ARENA_FRONTLOAD_FRAC_DEN  8                         /* 1/8 = 37.5 MB */
#define ARENA_FRONTLOAD_BYTES   (ARENA_SIZE_BYTES / ARENA_FRONTLOAD_FRAC_DEN)

#define ARENA_MAX_TIERS         16
#define ARENA_GUARD_PAGE_SIZE   4096
#define ARENA_CACHE_LINE        64

#define ARENA_CANARY_HEAD       0xDEADC0DEBEEFCAFEULL
#define ARENA_CANARY_TAIL       0xCAFEBEEFC0DEDEADULL

#define ARENA_SOFT_CONCERN_PCT  80  /* Trigger soft concern at 80% occupancy */

/* Decay parameters: base = 2/3 (represented as numerator/denominator) */
#define ARENA_DECAY_NUM         2
#define ARENA_DECAY_DEN         3

/* Brush log base: 3/2 */
#define ARENA_BRUSH_NUM         3
#define ARENA_BRUSH_DEN         2

/* Block states */
#define ARENA_BLOCK_FREE        0x00
#define ARENA_BLOCK_ALLOCATED   0x01
#define ARENA_BLOCK_GUARD       0x02

/* =========================================================================
 * Data Structures
 * ========================================================================= */

/**
 * struct arena_block_hdr - Header for each allocated block within the arena
 * @canary_head:   Sentinel word for corruption detection
 * @state:         ARENA_BLOCK_FREE or ARENA_BLOCK_ALLOCATED
 * @tier:          Which tier this block belongs to (0-15)
 * @size:          User-requested size (bytes)
 * @alloc_size:    Actual size including alignment padding
 * @next_free:     Next block on per-tier free list (when FREE)
 */
struct arena_block_hdr {
    u64                     canary_head;
    u8                      state;
    u8                      tier;
    u16                     _reserved;
    u32                     size;
    u32                     alloc_size;
    u32                     _pad;
    struct arena_block_hdr *next_free;
};

/**
 * struct arena_tier - Per-tier metadata
 * @base:          Start address of this tier's region
 * @size_bytes:    Total capacity of this tier
 * @used_bytes:    Current allocation within this tier
 * @free_list:     Head of free block list
 * @alloc_count:   Number of active allocations
 * @free_count:    Number of blocks on free list
 * @occupancy_pct: Current occupancy (0-100)
 */
struct arena_tier {
    void                   *base;
    size_t                  size_bytes;
    size_t                  used_bytes;
    struct arena_block_hdr *free_list;
    u32                     alloc_count;
    u32                     free_count;
    u8                      occupancy_pct;
    u8                      in_soft_concern;
    u8                      is_virtual;     /* Backed by USB swap or secondary mmap */
    u8                      _reserved;
};

/**
 * struct arena_pool - Per-process arena allocator state
 * @base:              mmap'd base address of the 300 MB arena
 * @total_size:        Total arena size (300 MB default)
 * @num_tiers:         Number of active tiers
 * @tiers:             Array of tier metadata
 * @lock:              Spinlock for multi-threaded access (slow path)
 * @frontload_used:    Bytes consumed from the 1/8 upfront region
 * @total_allocated:   Sum of all active allocations
 * @total_freed:       Sum of all freed blocks (lifetime)
 * @soft_concern_count: Number of times soft concern triggered
 * @pid:               Owning process PID
 * @flags:             Arena flags (boosted, usb-backed, etc.)
 */
struct arena_pool {
    void                   *base;
    size_t                  total_size;
    unsigned int            num_tiers;
    struct arena_tier       tiers[ARENA_MAX_TIERS];
    spinlock_t              lock;
    size_t                  frontload_used;
    size_t                  total_allocated;
    size_t                  total_freed;
    u32                     soft_concern_count;
    pid_t                   pid;
    u32                     flags;
    struct arena_intensity  intensity;  /* Falling decay intensification tracking */
};

/* Arena flags */
#define ARENA_F_BOOSTED     0x01   /* Process has CPU Boost — pre-fault upfront */
#define ARENA_F_USB_BACKED  0x02   /* Decay tiers 5+ backed by USB swap */
#define ARENA_F_FRONTLOADED 0x04   /* 1/8 upfront region has been committed */
#define ARENA_F_COMPACT_REQ 0x08   /* Compaction requested (GC hint) */
#define ARENA_F_INTENSIFIED 0x10   /* Process is currently in intensification concern */
#define ARENA_F_THROTTLED   0x20   /* Process under intensification throttle */

/* =========================================================================
 * Intensification Concern — Falling Decay Memory (Clear-in-3)
 * =========================================================================
 *
 * Tracks processes that drive further intensification — repeated allocation
 * pressure, tier exhaustion, or soft concern escalation beyond normal use.
 *
 * Mechanism:
 *   Each intensification event increments an "intensity score" (0–255).
 *   Every monitoring interval (configurable, default 10s), the score decays
 *   by the falling decay constant (score = score × 2/3, integer division).
 *
 *   Clear-in-3 property:
 *     After the last intensification event, the score reaches zero within
 *     3 decay intervals if no further intensification occurs:
 *       Interval 0: score = N
 *       Interval 1: score = N × 2/3
 *       Interval 2: score = N × 4/9
 *       Interval 3: score = N × 8/27 (≈ 0.296 × N)
 *     For typical scores (N ≤ 10), this reaches 0 in 3 integer-decay steps:
 *       10 → 6 → 4 → 2 → (effectively cleared at threshold)
 *     The concern threshold is 3 — below 3, the process is considered clear.
 *
 *   Scaled response:
 *     - Score  0-2:  CLEAR — normal allocation, no concern
 *     - Score  3-7:  WATCH — allocations logged, soft priority reduction
 *     - Score  8-15: CONCERN — new allocations from lower-priority tiers only
 *     - Score 16-31: THROTTLE — allocations rate-limited (yield between calls)
 *     - Score 32+:   RESTRICT — hard deny from primary tiers, decay-only service
 *
 *   Intensification triggers:
 *     +1 per soft concern event
 *     +2 per tier exhaustion in priority order
 *     +3 per hard denial (all tiers full)
 *     +5 per fork/exec that inherits parent's high-pressure pool
 *
 *   The system is proportional: a process that briefly bursts and then
 *   goes quiet clears in 30 seconds (3 × 10s intervals). A process that
 *   continuously drives pressure accumulates and faces scaled restriction.
 */

#define ARENA_INTENSITY_CLEAR       0
#define ARENA_INTENSITY_WATCH       3
#define ARENA_INTENSITY_CONCERN     8
#define ARENA_INTENSITY_THROTTLE    16
#define ARENA_INTENSITY_RESTRICT    32
#define ARENA_INTENSITY_MAX         255

/* Decay: score = score × 2/3 per interval (same constants as tier decay) */
#define ARENA_INTENSITY_DECAY_NUM   2
#define ARENA_INTENSITY_DECAY_DEN   3

/* Clear threshold: below this, the process is considered fully clear */
#define ARENA_INTENSITY_CLEAR_THRESHOLD  3

/* Default monitoring interval in seconds */
#define ARENA_INTENSITY_INTERVAL_S  10

/* Increment weights for intensification triggers */
#define ARENA_INTENSITY_SOFT_CONCERN   1
#define ARENA_INTENSITY_TIER_EXHAUST   2
#define ARENA_INTENSITY_HARD_DENY      3
#define ARENA_INTENSITY_FORK_PRESSURE  5

/**
 * enum arena_intensity_level - Current intensification level
 */
#ifndef _ARENA_INTENSITY_LEVEL_DEFINED
#define _ARENA_INTENSITY_LEVEL_DEFINED
enum arena_intensity_level {
    ARENA_LEVEL_CLEAR    = 0,   /* No concern, normal service */
    ARENA_LEVEL_WATCH    = 1,   /* Logged, soft priority reduction */
    ARENA_LEVEL_CONCERN  = 2,   /* Lower-priority tier service only */
    ARENA_LEVEL_THROTTLE = 3,   /* Rate-limited allocations */
    ARENA_LEVEL_RESTRICT = 4,   /* Hard deny from primary, decay-only */
};
#endif

/**
 * struct arena_intensity - Per-arena intensification tracking
 * @score:           Current intensity score (0-255, decays × 2/3 per interval)
 * @level:           Derived level from score thresholds
 * @peak_score:      Highest score reached (lifetime diagnostic)
 * @events_total:    Total intensification events (lifetime)
 * @last_event_jiffies: Jiffies of most recent intensification event
 * @last_decay_jiffies: Jiffies of most recent decay pass
 * @decay_count:     Number of decay passes applied since last event
 * @clear_count:     Number of times the process has cleared from concern
 * @throttle_count:  Number of allocations delayed due to throttle
 * @restricted_count: Number of allocations denied due to restrict
 */
struct arena_intensity {
    u8                      score;
    u8                      level;
    u8                      peak_score;
    u8                      _reserved;
    u32                     events_total;
    unsigned long           last_event_jiffies;
    unsigned long           last_decay_jiffies;
    u32                     decay_count;
    u32                     clear_count;
    u32                     throttle_count;
    u32                     restricted_count;
};

/* =========================================================================
 * API
 * ========================================================================= */

/**
 * arena_pool_create - Create a new arena for a process
 * @size_mb:  Arena size in MB (default: 300, min: 16, max: 4096)
 * @flags:    Arena creation flags
 *
 * Returns pointer to arena_pool struct, or ERR_PTR on failure.
 * The arena is mmap'd with MAP_ANONYMOUS|MAP_PRIVATE|MAP_NORESERVE.
 * Pages are committed on first touch (lazy population).
 */
struct arena_pool *arena_pool_create(unsigned int size_mb, u32 flags);

/**
 * arena_pool_destroy - Destroy an arena and unmap all memory
 * @pool:  Arena to destroy
 *
 * All allocations within the arena become invalid.
 * Outstanding pointers must not be used after this call.
 */
void arena_pool_destroy(struct arena_pool *pool);

/**
 * arena_malloc - Allocate memory from the arena
 * @pool:  Arena pool
 * @size:  Requested allocation size (bytes)
 *
 * Returns pointer within the arena, or NULL on failure.
 * Allocation is cache-line aligned (64 bytes).
 * Priority order: (4, 3, 1, 2) → soft concern → (5, 6, ...) → extend
 *
 * Safety:
 *   - Bounds checked: A₀ ≤ ptr < A₀ + arena_size
 *   - Guard pages between tier regions
 *   - Canary words before/after allocation
 *   - Double-free detection via state flag
 */
void *arena_malloc(struct arena_pool *pool, size_t size);

/**
 * arena_free - Return a block to the arena free list
 * @pool:  Arena pool
 * @ptr:   Pointer previously returned by arena_malloc
 *
 * Validates canary words and state flag before freeing.
 * Logs corruption if canaries are damaged.
 */
void arena_free(struct arena_pool *pool, void *ptr);

/**
 * arena_realloc - Resize an allocation within the arena
 * @pool:     Arena pool
 * @ptr:      Existing allocation (or NULL for new allocation)
 * @new_size: New size in bytes
 *
 * If the new size fits within the existing block's alloc_size, returns
 * the same pointer. Otherwise allocates new, copies, frees old.
 */
void *arena_realloc(struct arena_pool *pool, void *ptr, size_t new_size);

/**
 * arena_compact - Trigger compaction pass on the arena
 * @pool:  Arena pool
 *
 * Coalesces adjacent free blocks. Called when soft concern triggers.
 * May also release pages via madvise(MADV_DONTNEED) for empty tiers.
 */
void arena_compact(struct arena_pool *pool);

/**
 * arena_get_status - Get arena usage statistics
 * @pool:  Arena pool
 * @total: Output: total arena size
 * @used:  Output: total bytes in use
 * @tiers: Output: number of active tiers
 * @savings: Output: bytes in savings brush (occupancy < 50%)
 */
void arena_get_status(struct arena_pool *pool,
                      size_t *total, size_t *used,
                      unsigned int *tiers, size_t *savings);

/**
 * arena_frontload - Pre-fault the 1/8 upfront region
 * @pool:  Arena pool
 *
 * Touches all pages in the frontload region to eliminate page faults
 * during initial process execution. Called at fork for boosted processes.
 */
void arena_frontload(struct arena_pool *pool);

/**
 * arena_tier_size - Compute the size of tier n
 * @arena_mb:  Total arena size in MB
 * @tier:      Tier number (0-15)
 *
 * Returns size in bytes according to the halving cascade + logarithmic decay.
 */
size_t arena_tier_size(unsigned int arena_mb, unsigned int tier);

/* =========================================================================
 * Intensification API
 * ========================================================================= */

/**
 * arena_intensity_event - Record an intensification event
 * @pool:    Arena pool
 * @weight:  Event weight (ARENA_INTENSITY_SOFT_CONCERN, etc.)
 *
 * Increments intensity score, updates level. Called internally when
 * allocation pressure is detected.
 */
void arena_intensity_event(struct arena_pool *pool, u8 weight);

/**
 * arena_intensity_decay - Apply one falling decay step (score × 2/3)
 * @pool:  Arena pool
 *
 * Called by monitoring timer every ARENA_INTENSITY_INTERVAL_S seconds.
 * Clears the process from concern if score falls below threshold.
 * Property: clears in 3 intervals if no further intensification.
 */
void arena_intensity_decay(struct arena_pool *pool);

/**
 * arena_intensity_level - Return the current intensification level
 * @pool:  Arena pool
 *
 * Returns: enum arena_intensity_level (CLEAR, WATCH, CONCERN, THROTTLE, RESTRICT)
 */
enum arena_intensity_level arena_intensity_get_level(struct arena_pool *pool);

/**
 * arena_intensity_check_alloc - Gate allocation based on intensity level
 * @pool:  Arena pool
 * @size:  Requested allocation size
 *
 * Returns:
 *   0    — proceed normally
 *   1    — proceed but from lower-priority tiers only (CONCERN)
 *   2    — yield first, then proceed from lower tiers (THROTTLE)
 *   -1   — deny allocation entirely (RESTRICT)
 */
int arena_intensity_check_alloc(struct arena_pool *pool, size_t size);

#endif /* _LINUX_ARENA_POOL_H */
