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

### 10. Constants

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
```

---

### 11. Future Exploration

- **Adaptive arena sizing:** Measure first 10 seconds of allocation behavior, resize arena dynamically
- **NUMA-aware tiering:** Pin tiers to specific NUMA nodes on multi-socket systems
- **Compression tiers:** Decay tiers 7+ use zswap-style compression before USB spill
- **Formal verification:** Prove convergence and bounds via Coq/Lean theorem prover
- **Dave prediction:** ML model predicts tier exhaustion 30s ahead, pre-extends

---

*Document version: 1.0 — 2026-08-15*
*Authority: Installer Tech 9 architectural document*
*System: Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98*
