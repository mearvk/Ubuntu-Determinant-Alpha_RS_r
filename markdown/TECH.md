# TECH.md — Memory Allocation Model

## Hierarchical Pool Allocation with Logarithmic Decay

### 1. Primary Arena: 300 MB Bulk Allocation

The system allocates a single contiguous 300 MB arena at process initialization via `mmap(MAP_ANONYMOUS | MAP_PRIVATE)`. All subsequent allocations are served from this arena — no further `brk()`/`mmap()` calls to the kernel under normal operation.

```
┌─────────────────────────────────────────────────────────┐
│                    ARENA: 300 MB                         │
│                                                         │
│  Base address: A₀                                       │
│  Ceiling:      A₀ + 300 × 2²⁰                          │
│  Page size:    4096 bytes (system page)                  │
│  Alignment:    64 bytes (cache-line)                     │
└─────────────────────────────────────────────────────────┘
```

**Why 300 MB:** Large enough for most application working sets. Small enough to avoid swap pressure on 2 GB+ systems. Committed on first touch (lazy population via page fault), so physical RAM cost is proportional to actual use.

---

### 2. Safe malloc() from the Arena

Internal allocator serves requests from the 300 MB pool:

```c
void *arena_malloc(size_t size);   // Returns pointer within arena
void  arena_free(void *ptr);       // Returns block to free list
```

**Safety guarantees:**
- Bounds checking: every returned pointer satisfies `A₀ ≤ ptr < A₀ + 300M`
- Guard pages: 4 KB no-access pages between major regions (SIGSEGV on overflow)
- Canary words: 8-byte sentinel before and after each allocation (detect corruption)
- Double-free detection: block header carries state flag (ALLOCATED / FREE)
- Thread safety: per-thread free lists (no global lock on fast path)

---

### 3. Halving Cascade: 150 MB → 75 MB

The arena is partitioned into a binary halving cascade for tiered allocation priority:

```
Level 0:  300 MB  (full arena)
Level 1:  150 MB  (primary working region)
Level 2:   75 MB  (secondary overflow region)
```

| Level | Size | Purpose | Allocation Policy |
|-------|------|---------|-------------------|
| 0 | 300 MB | Total arena | Never allocated directly |
| 1 | 150 MB | Hot working set | First-choice for all malloc |
| 2 | 75 MB | Warm overflow | Used when Level 1 > 80% full |

```
┌────────────────────────────────────────────────────────────────┐
│  Level 1: 150 MB (primary)  │  Level 2: 75 MB (overflow)  │ R │
│  [hot working set]          │  [warm overflow]             │ e │
│                             │                              │ s │
│  Allocations go here first  │  Spill when L1 > 80%        │ v │
└────────────────────────────────────────────────────────────────┘
                                                    Reserved: 75 MB
                                                    (guard + metadata)
```

---

### 4. Logarithmic Decay Function

Beyond the halving cascade, further subdivision follows a logarithmic decay with base parameters `3/2` and `2/3`:

#### Definition

Let `S(n)` be the size of tier `n`:

```
S(0) = 300 MB                          (arena)
S(1) = 150 MB = S(0) / 2               (half)
S(2) =  75 MB = S(1) / 2               (quarter)
S(n) = S(2) × (2/3)^(n-2)   for n ≥ 3 (logarithmic decay)
```

The decay factor `(2/3)` ensures each subsequent tier is 2/3 the size of the previous, producing a convergent series.

#### Tier Table

| Tier (n) | Formula | Size (MB) | Cumulative (MB) | Role |
|----------|---------|-----------|-----------------|------|
| 0 | 300 | 300.000 | — | Arena (container) |
| 1 | 300/2 | 150.000 | 150.000 | Primary hot |
| 2 | 150/2 | 75.000 | 225.000 | Warm overflow |
| 3 | 75 × (2/3)¹ | 50.000 | 275.000 | Soft target 1 |
| 4 | 75 × (2/3)² | 33.333 | 308.333* | Soft target 2 |
| 5 | 75 × (2/3)³ | 22.222 | 330.556* | Soft target 3 |
| 6 | 75 × (2/3)⁴ | 14.815 | 345.370* | Decay brush |
| 7 | 75 × (2/3)⁵ | 9.877 | 355.247* | Decay brush |
| 8 | 75 × (2/3)⁶ | 6.584 | 361.831* | Savings tail |

*Tiers beyond the 300 MB arena are virtual — backed by a secondary mmap or USB swap if available.

#### Convergence

The infinite sum of the decay series:

```
Σ S(n) for n=3..∞ = 75 × Σ (2/3)^(n-2) for n=3..∞
                   = 75 × (2/3) / (1 - 2/3)
                   = 75 × (2/3) / (1/3)
                   = 75 × 2
                   = 150 MB
```

**Total theoretical capacity:** 150 + 75 + 150 = 375 MB (arena 300 MB + 75 MB virtual extension).

---

### 5. Ordering Sequence: (4, 3, 1, 2) → Soft → Next Target

The allocation priority within the decay tiers follows the ordering `(4, 3, 1, 2)`:

```
Priority 1st:  Tier 4 — 33.333 MB  (most aggressively reused)
Priority 2nd:  Tier 3 — 50.000 MB  (second choice)
Priority 3rd:  Tier 1 — 150.000 MB (fallback to primary)
Priority 4th:  Tier 2 — 75.000 MB  (last resort before soft concern)
```

**Rationale:** Smaller tiers are preferred first to preserve large contiguous regions for bulk allocations. If tiers 4 and 3 cannot satisfy a request, we fall back to the primary (1) before touching overflow (2).

After exhausting the (4, 3, 1, 2) sequence, the allocator enters **soft concern mode**:

```
SOFT CONCERN:
  - Log allocation pressure event
  - Trigger GC hint / compaction pass
  - Attempt next decay tier (5, 6, 7, ...)
  - If still unsatisfied → extend arena (USB swap backing)
```

---

### 6. Front-Loading: 1/8 Upfront + (2, 3, 1, 2) Sequence

For new process forks and module loads, a **1/8 front-load** strategy applies:

```
Upfront allocation = Arena / 8 = 300 / 8 = 37.5 MB
```

This 37.5 MB is immediately committed (pages touched, TLB warm) so the process has zero-fault startup for its initial working set.

After the upfront region is consumed, the secondary sequence `(2, 3, 1, 2)` governs growth:

| Step | Tier | Size Available | Meaning |
|------|------|---------------|---------|
| 1 (upfront) | 1/8 arena | 37.5 MB | Immediate, pre-faulted |
| 2 | Tier 2 | 75 MB | Overflow region |
| 3 | Tier 3 | 50 MB | First decay tier |
| 4 | Tier 1 | 150 MB | Full primary (remainder) |
| 5 | Tier 2 | (reuse freed) | Compact and reuse |

---

### 7. Logarithmic Wisdom: Savings Brush

The "savings brush" is the tail of the logarithmic decay — tiers 6+ where individual tier sizes fall below 15 MB. These tiers serve a different purpose: **memory savings accounting**.

```
Savings(n) = S(n) × occupancy(n)

Total savings = Σ Savings(n) for all n where occupancy < 50%
```

When a tier's occupancy drops below 50%, the allocator considers those pages "savings" — they can be:
1. `madvise(MADV_DONTNEED)` — released back to the kernel without unmapping
2. Offered to USB swap prefetch (pre-staged for next boot)
3. Reported to Dave as available headroom

The logarithm `log₃/₂(tier_count)` determines when the savings brush engages:

```
brush_threshold = ⌈log₃/₂(active_tiers)⌉

Example: 6 active tiers → log₃/₂(6) = ln(6)/ln(1.5) ≈ 4.42 → threshold = 5
  → Savings brush activates at tier 5+
```

---

### 8. Mathematical Summary

```
Arena:           A = 300 MB
Primary:         P = A/2 = 150 MB
Overflow:        O = A/4 = 75 MB
Decay(n):        D(n) = O × (2/3)^(n-2),  n ≥ 3
Convergence:     Σ D(n) = 150 MB
Total capacity:  A + Σ D(n≥5) = 300 + virtual extension
Front-load:      F = A/8 = 37.5 MB
Brush threshold: B = ⌈log₃/₂(N)⌉  where N = active tier count
Savings:         Σ D(n) × (1 - occ(n))  for occ(n) < 0.5

Priority order:  (4, 3, 1, 2) → soft concern → (5, 6, 7, ...) → extend
Startup order:   1/8 upfront → (2, 3, 1, 2) → decay tiers
```

---

### 9. Integration Points

| System Component | Integration |
|------------------|-------------|
| Memory Proxy (JVM) | Arena size configurable via `-Xguard:arena=300m` |
| USB Dynamic RAM | Decay tiers 5+ can spill to USB swap (priority -5) |
| Per-User Kernel Objects | Each user_ko gets its own arena (Grain 1: 4 MB cap, Grain 3: 64 MB cap) |
| CPU Boost | Boosted processes get pre-faulted upfront (37.5 MB committed at fork) |
| Dave | Monitors tier occupancy, predicts pressure, suggests compaction |
| Integrity Guardian | Verifies allocation ratios remain 1:1 or 1:2 grid-aligned within each tier |

---

### 10. Intensification Concern — Falling Decay Memory (Clear-in-3)

A proportional, time-decaying response to processes that drive sustained memory pressure beyond normal allocation patterns.

#### The Problem

Without intensification tracking, a badly-behaved process can:
- Repeatedly exhaust primary tiers, forcing compaction on every allocation
- Drive other processes into decay tiers unnecessarily
- Fork-bomb its way to arena extension, consuming USB-backed virtual memory
- Cause system-wide pressure through sustained churn

The solution must be **proportional** (brief bursts forgiven, sustained abuse restricted) and **self-healing** (clears automatically when the process goes quiet).

#### Mechanism

Each arena carries an `intensity` struct with a score (0–255). Events that indicate memory pressure increment the score by their weight. Every 10 seconds, a decay timer multiplies the score by 2/3 (integer division, floors toward zero).

**Clear-in-3 Property:**

For any score N ≤ 10, the integer decay reaches zero within 3 intervals:

```
Interval 0:  score = N
Interval 1:  score = ⌊N × 2/3⌋
Interval 2:  score = ⌊⌊N × 2/3⌋ × 2/3⌋
Interval 3:  score = ⌊⌊⌊N × 2/3⌋ × 2/3⌋ × 2/3⌋  →  < 3 (threshold)  →  CLEAR
```

Worked examples:
```
N=10:  10 → 6 → 4 → 2  (clear at interval 3)
N= 8:   8 → 5 → 3 → 2  (clear at interval 3)
N= 5:   5 → 3 → 2 → 1  (clear at interval 2-3)
N= 3:   3 → 2 → 1 → 0  (clear at interval 1-2)
N=32:  32 → 21 → 14 → 9 → 6 → 4 → 2  (clear at interval 6)
```

Higher scores (sustained abuse) take proportionally longer to clear. This is by design — the system remembers persistent offenders longer.

#### Event Weights

| Event | Weight | Triggered When |
|-------|--------|----------------|
| `ARENA_INTENSITY_SOFT_CONCERN` | +1 | Tier 1 occupancy exceeds 80% |
| `ARENA_INTENSITY_TIER_EXHAUST` | +2 | All priority-order tiers (4,3,1,2) full |
| `ARENA_INTENSITY_HARD_DENY` | +3 | All tiers including decay are exhausted |
| `ARENA_INTENSITY_FORK_PRESSURE` | +5 | Fork/exec inherits parent's high-pressure arena |

#### Response Levels

| Score Range | Level | Allocation Response |
|-------------|-------|---------------------|
| 0–2 | CLEAR | Normal service via priority order (4,3,1,2) |
| 3–7 | WATCH | Normal service + allocation logged |
| 8–15 | CONCERN | Skip primary tiers; serve from decay tiers only |
| 16–31 | THROTTLE | Yield (cpu_relax) before each allocation; decay tiers only |
| 32–255 | RESTRICT | Hard deny from primary tiers; decay-only if available |

#### Integration into arena_malloc()

```c
void *arena_malloc(struct arena_pool *pool, size_t size)
{
    int gate = arena_intensity_check_alloc(pool, size);

    if (gate == 2) {
        /* THROTTLE: yield before proceeding */
        cpu_relax();
    }

    if (gate <= 0 && gate != -1) {
        /* Normal path: try (4, 3, 1, 2) */
        for (...)
            if ((ptr = try_alloc_tier(pool, tier, size)))
                return ptr;
        /* Exhausted — record intensification */
        arena_intensity_event(pool, ARENA_INTENSITY_TIER_EXHAUST);
    }

    /* Concern/Throttle/Restrict: decay tiers only */
    for (tier = 5; tier < num_tiers; tier++)
        if ((ptr = try_alloc_tier(pool, tier, size)))
            return ptr;

    /* Total failure */
    arena_intensity_event(pool, ARENA_INTENSITY_HARD_DENY);
    return NULL;
}
```

#### Decay Timer

The `arena_intensity_decay()` function is called every `ARENA_INTENSITY_INTERVAL_S` (10s) by a kernel timer or monitoring thread:

```c
void arena_intensity_decay(struct arena_pool *pool)
{
    pool->intensity.score = pool->intensity.score * 2 / 3;

    if (pool->intensity.score < ARENA_INTENSITY_CLEAR_THRESHOLD) {
        pool->intensity.score = 0;
        pool->intensity.level = ARENA_LEVEL_CLEAR;
        pool->flags &= ~(ARENA_F_INTENSIFIED | ARENA_F_THROTTLED);
    }
}
```

#### Procfs Visibility

```bash
cat /proc/arena_pool/status
```

Output includes per-arena intensification state:
```
  Arena [0] PID 1234
    Intensity:   score=4  level=WATCH  peak=12
    Events:      17 total (6 soft, 8 exhaust, 3 deny)
    Decay:       14 passes since last event
    Cleared:     3 times (lifetime)
    Throttled:   0 allocations delayed
    Restricted:  0 allocations denied
```

#### Design Philosophy

The intensification system is a **memory for misbehavior** that heals itself. It is:

- **Proportional:** Small burst → forgiven in 30s. Sustained abuse → longer restriction.
- **Self-healing:** No admin intervention needed. Clear-in-3 is automatic.
- **Non-destructive:** Never kills a process. Only restricts allocation paths.
- **Observable:** Full telemetry via `/proc/arena_pool/status`.
- **Integrated:** Wired directly into `arena_malloc()` — zero overhead at CLEAR level.

#### Mathematical Summary

```
decay(score) = ⌊score × 2/3⌋           (applied every 10s)
clear_threshold = 3                      (score < 3 → CLEAR)
clear_time(N) ≈ ⌈log₃/₂(N/3)⌉ × 10s   (time to clear from score N)
clear_time(10) = 3 intervals = 30s
clear_time(32) = 6 intervals = 60s
clear_time(255) = 14 intervals = 140s   (worst case: sustained max abuse)
```

---

### 11. Constants

```c
#define ARENA_SIZE_MB        300
#define PRIMARY_MB           (ARENA_SIZE_MB / 2)        // 150
#define OVERFLOW_MB          (ARENA_SIZE_MB / 4)        //  75
#define DECAY_BASE           (2.0 / 3.0)               //  0.6667
#define FRONTLOAD_FRAC       (1.0 / 8.0)               //  0.125
#define BRUSH_LOG_BASE       (3.0 / 2.0)               //  1.5
#define GUARD_PAGE_SIZE      4096
#define CANARY_WORD          0xDEADC0DEBEEFCAFE
#define MAX_TIERS            16
#define SOFT_CONCERN_THRESH  0.80                       //  80% occupancy

// Intensification (Falling Decay Memory)
#define INTENSITY_DECAY_NUM  2                          //  × 2/3 per interval
#define INTENSITY_DECAY_DEN  3
#define INTENSITY_INTERVAL_S 10                         //  10 seconds per decay pass
#define INTENSITY_CLEAR      3                          //  below 3 = cleared
#define INTENSITY_WATCH      3                          //  3-7:  watch
#define INTENSITY_CONCERN    8                          //  8-15: concern
#define INTENSITY_THROTTLE   16                         //  16-31: throttle
#define INTENSITY_RESTRICT   32                         //  32+: restrict
#define INTENSITY_MAX        255                        //  saturating ceiling
```

---

### 12. Future Exploration

- **Adaptive arena sizing:** Measure first 10 seconds of allocation behavior, resize arena dynamically
- **NUMA-aware tiering:** Pin tiers to specific NUMA nodes on multi-socket systems
- **Compression tiers:** Decay tiers 7+ use zswap-style compression before USB spill
- **Formal verification:** Prove convergence and bounds via Coq/Lean theorem prover
- **Dave prediction:** ML model predicts tier exhaustion 30s ahead, pre-extends
- **Intensification correlation:** Cross-reference intensity scores with process ancestry to detect fork-bomb pressure chains
- **Adaptive decay rate:** Adjust 2/3 factor based on system-wide memory pressure (faster decay under low load, slower under high)

---

*Document version: 1.1 — 2026-08-15*
*Authority: Installer Tech 9 architectural document*
*System: Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98*
*Change: Added Section 10 — Intensification Concern (Falling Decay Memory, Clear-in-3)*
