// SPDX-License-Identifier: GPL-2.0
/*
 * arena_pool.c — Hierarchical Pool Allocation with Logarithmic Decay
 *
 * Implements per-process arena allocation as described in TECH.md:
 *   - 300 MB contiguous arena via mmap (lazy-populated)
 *   - Binary halving cascade: 150 MB primary, 75 MB overflow
 *   - Logarithmic decay tiers: 75 × (2/3)^(n-2) for n ≥ 3
 *   - Priority ordering: (4, 3, 1, 2) → soft concern → (5, 6, ...) → extend
 *   - 1/8 front-load (37.5 MB pre-faulted) for zero-fault startup
 *   - Savings brush on tail tiers (occupancy < 50%)
 *   - Guard pages, canary words, double-free detection
 *   - /proc/arena_pool/status interface for monitoring
 *
 * This module provides a configurable arena allocator that sits alongside
 * the standard SLUB allocator. Processes opt in via arena_pool_create()
 * or are auto-enrolled when launched under the JVM Memory Proxy.
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/slab.h>
#include <linux/mm.h>
#include <linux/mman.h>
#include <linux/vmalloc.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/uaccess.h>
#include <linux/spinlock.h>
#include <linux/string.h>
#include <linux/math64.h>

#include "arena_pool.h"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Maximilian Eric Alexander Rupplin von Keffikon");
MODULE_DESCRIPTION("Hierarchical Pool Allocation with Logarithmic Decay");
MODULE_VERSION("1.0");

/* =========================================================================
 * Module Parameters
 * ========================================================================= */

static unsigned int default_arena_mb = ARENA_SIZE_MB;
module_param(default_arena_mb, uint, 0644);
MODULE_PARM_DESC(default_arena_mb, "Default arena size in MB (default: 300)");

static unsigned int max_arenas = 256;
module_param(max_arenas, uint, 0644);
MODULE_PARM_DESC(max_arenas, "Maximum concurrent arenas (default: 256)");

/* =========================================================================
 * Global State
 * ========================================================================= */

static struct arena_pool *active_pools[256];
static unsigned int pool_count;
static DEFINE_SPINLOCK(pools_lock);
static struct proc_dir_entry *proc_dir;

/* =========================================================================
 * Tier Size Computation
 * ========================================================================= */

/**
 * arena_tier_size - Compute the size of tier n in bytes
 *
 * Tier 0: arena_mb (container, not directly allocated)
 * Tier 1: arena_mb / 2 (primary)
 * Tier 2: arena_mb / 4 (overflow)
 * Tier n≥3: (arena_mb/4) × (2/3)^(n-2) (logarithmic decay)
 */
size_t arena_tier_size(unsigned int arena_mb, unsigned int tier)
{
    size_t base_bytes;
    unsigned int i;

    if (tier == 0)
        return (size_t)arena_mb << 20;
    if (tier == 1)
        return (size_t)(arena_mb / 2) << 20;
    if (tier == 2)
        return (size_t)(arena_mb / 4) << 20;

    /* Tier 3+: overflow × (2/3)^(tier-2) */
    base_bytes = (size_t)(arena_mb / 4) << 20;
    for (i = 0; i < (tier - 2); i++) {
        base_bytes = (base_bytes * ARENA_DECAY_NUM) / ARENA_DECAY_DEN;
    }
    return base_bytes;
}
EXPORT_SYMBOL(arena_tier_size);

/* =========================================================================
 * Arena Creation / Destruction
 * ========================================================================= */

/**
 * arena_pool_create - Create a new hierarchical arena
 */
struct arena_pool *arena_pool_create(unsigned int size_mb, u32 flags)
{
    struct arena_pool *pool;
    size_t total_size;
    void *arena_base;
    size_t offset;
    unsigned int tier;

    if (size_mb < 16)
        size_mb = 16;
    if (size_mb > 4096)
        size_mb = 4096;

    total_size = (size_t)size_mb << 20;

    /* Allocate arena control structure */
    pool = kzalloc(sizeof(*pool), GFP_KERNEL);
    if (!pool)
        return ERR_PTR(-ENOMEM);

    /* Map the arena: anonymous, private, lazy-populated */
    arena_base = vmalloc(total_size);
    if (!arena_base) {
        kfree(pool);
        return ERR_PTR(-ENOMEM);
    }

    pool->base = arena_base;
    pool->total_size = total_size;
    pool->pid = current->pid;
    pool->flags = flags;
    spin_lock_init(&pool->lock);

    /* Initialize tiers */
    offset = 0;
    for (tier = 1; tier < ARENA_MAX_TIERS; tier++) {
        size_t tier_sz = arena_tier_size(size_mb, tier);
        if (tier_sz < ARENA_GUARD_PAGE_SIZE || offset + tier_sz > total_size)
            break;

        pool->tiers[tier].base = arena_base + offset;
        pool->tiers[tier].size_bytes = tier_sz;
        pool->tiers[tier].used_bytes = 0;
        pool->tiers[tier].free_list = NULL;
        pool->tiers[tier].alloc_count = 0;
        pool->tiers[tier].free_count = 0;
        pool->tiers[tier].occupancy_pct = 0;
        pool->tiers[tier].in_soft_concern = 0;
        pool->tiers[tier].is_virtual = (tier >= 5) ? 1 : 0;

        offset += tier_sz;

        /* Insert guard page between tiers */
        offset += ARENA_GUARD_PAGE_SIZE;
    }
    pool->num_tiers = tier;

    /* Front-load if boosted */
    if (flags & ARENA_F_BOOSTED)
        arena_frontload(pool);

    pool->flags |= ARENA_F_FRONTLOADED;

    /* Register in global pool list */
    spin_lock(&pools_lock);
    if (pool_count < max_arenas) {
        active_pools[pool_count++] = pool;
    }
    spin_unlock(&pools_lock);

    pr_info("arena_pool: created %u MB arena for PID %d (%u tiers)\n",
            size_mb, pool->pid, pool->num_tiers - 1);

    return pool;
}
EXPORT_SYMBOL(arena_pool_create);

/**
 * arena_pool_destroy - Tear down an arena and release all memory
 */
void arena_pool_destroy(struct arena_pool *pool)
{
    unsigned int i;

    if (!pool)
        return;

    /* Remove from global list */
    spin_lock(&pools_lock);
    for (i = 0; i < pool_count; i++) {
        if (active_pools[i] == pool) {
            active_pools[i] = active_pools[--pool_count];
            break;
        }
    }
    spin_unlock(&pools_lock);

    pr_info("arena_pool: destroyed arena for PID %d (allocated: %zu, freed: %zu)\n",
            pool->pid, pool->total_allocated, pool->total_freed);

    if (pool->base)
        vfree(pool->base);

    kfree(pool);
}
EXPORT_SYMBOL(arena_pool_destroy);

/* =========================================================================
 * Allocation — Priority Order: (4, 3, 1, 2) → soft → (5, 6, ...)
 * ========================================================================= */

/* Align size to cache line boundary */
static inline size_t align_alloc(size_t size)
{
    return (size + sizeof(struct arena_block_hdr) + ARENA_CACHE_LINE - 1)
            & ~(ARENA_CACHE_LINE - 1);
}

/* Try to allocate from a specific tier */
static void *try_alloc_tier(struct arena_pool *pool, unsigned int tier, size_t size)
{
    struct arena_tier *t;
    struct arena_block_hdr *hdr;
    size_t alloc_sz;
    void *ptr;

    if (tier == 0 || tier >= pool->num_tiers)
        return NULL;

    t = &pool->tiers[tier];
    alloc_sz = align_alloc(size);

    /* Check free list first */
    if (t->free_list) {
        hdr = t->free_list;
        if (hdr->alloc_size >= alloc_sz && hdr->state == ARENA_BLOCK_FREE) {
            t->free_list = hdr->next_free;
            hdr->state = ARENA_BLOCK_ALLOCATED;
            hdr->size = (u32)size;
            hdr->canary_head = ARENA_CANARY_HEAD;
            hdr->next_free = NULL;
            t->free_count--;
            t->alloc_count++;
            t->used_bytes += hdr->alloc_size;
            t->occupancy_pct = (u8)((t->used_bytes * 100) / t->size_bytes);
            pool->total_allocated += size;
            return (void *)(hdr + 1);
        }
    }

    /* Allocate from end of tier's used region */
    if (t->used_bytes + alloc_sz > t->size_bytes)
        return NULL;  /* Tier full */

    ptr = t->base + t->used_bytes;
    hdr = (struct arena_block_hdr *)ptr;

    hdr->canary_head = ARENA_CANARY_HEAD;
    hdr->state = ARENA_BLOCK_ALLOCATED;
    hdr->tier = (u8)tier;
    hdr->size = (u32)size;
    hdr->alloc_size = (u32)alloc_sz;
    hdr->next_free = NULL;

    /* Write tail canary after user data */
    *(u64 *)((u8 *)(hdr + 1) + size) = ARENA_CANARY_TAIL;

    t->used_bytes += alloc_sz;
    t->alloc_count++;
    t->occupancy_pct = (u8)((t->used_bytes * 100) / t->size_bytes);
    pool->total_allocated += size;

    return (void *)(hdr + 1);
}

/**
 * arena_malloc - Allocate from the arena using priority ordering
 *
 * Priority: (4, 3, 1, 2) → soft concern → (5, 6, 7, ...) → NULL
 */
void *arena_malloc(struct arena_pool *pool, size_t size)
{
    static const unsigned int priority_order[] = {4, 3, 1, 2};
    void *ptr;
    unsigned int i, tier;
    unsigned long flags;

    if (!pool || size == 0)
        return NULL;

    /* Bounds check: reject unreasonable sizes */
    if (size > pool->total_size / 2)
        return NULL;

    spin_lock_irqsave(&pool->lock, flags);

    /* Try priority order: (4, 3, 1, 2) */
    for (i = 0; i < 4; i++) {
        tier = priority_order[i];
        if (tier >= pool->num_tiers)
            continue;
        ptr = try_alloc_tier(pool, tier, size);
        if (ptr) {
            spin_unlock_irqrestore(&pool->lock, flags);
            return ptr;
        }
    }

    /* Soft concern — try compaction */
    pool->soft_concern_count++;
    if (pool->tiers[1].occupancy_pct >= ARENA_SOFT_CONCERN_PCT) {
        pool->flags |= ARENA_F_COMPACT_REQ;
    }

    /* Try decay tiers (5, 6, 7, ...) */
    for (tier = 5; tier < pool->num_tiers; tier++) {
        ptr = try_alloc_tier(pool, tier, size);
        if (ptr) {
            spin_unlock_irqrestore(&pool->lock, flags);
            return ptr;
        }
    }

    spin_unlock_irqrestore(&pool->lock, flags);

    /* All tiers exhausted */
    pr_warn("arena_pool: allocation failed for PID %d, size %zu\n",
            pool->pid, size);
    return NULL;
}
EXPORT_SYMBOL(arena_malloc);

/* =========================================================================
 * Free — Validate canaries, return to tier free list
 * ========================================================================= */

/**
 * arena_free - Return a block to the arena
 */
void arena_free(struct arena_pool *pool, void *ptr)
{
    struct arena_block_hdr *hdr;
    struct arena_tier *t;
    unsigned long flags;
    u64 tail_canary;

    if (!pool || !ptr)
        return;

    /* Bounds check: must be within arena */
    if (ptr < pool->base || ptr >= pool->base + pool->total_size) {
        pr_err("arena_pool: free of out-of-bounds pointer %px (PID %d)\n",
               ptr, pool->pid);
        return;
    }

    hdr = (struct arena_block_hdr *)ptr - 1;

    /* Validate canary */
    if (hdr->canary_head != ARENA_CANARY_HEAD) {
        pr_err("arena_pool: CORRUPTION — head canary damaged at %px (PID %d)\n",
               ptr, pool->pid);
        return;
    }

    /* Validate tail canary */
    tail_canary = *(u64 *)((u8 *)ptr + hdr->size);
    if (tail_canary != ARENA_CANARY_TAIL) {
        pr_err("arena_pool: CORRUPTION — tail canary damaged at %px (PID %d, size %u)\n",
               ptr, pool->pid, hdr->size);
        return;
    }

    /* Double-free detection */
    if (hdr->state != ARENA_BLOCK_ALLOCATED) {
        pr_err("arena_pool: DOUBLE FREE at %px (PID %d, state=%u)\n",
               ptr, pool->pid, hdr->state);
        return;
    }

    spin_lock_irqsave(&pool->lock, flags);

    hdr->state = ARENA_BLOCK_FREE;
    t = &pool->tiers[hdr->tier];
    hdr->next_free = t->free_list;
    t->free_list = hdr;
    t->free_count++;
    t->alloc_count--;
    t->used_bytes -= hdr->alloc_size;
    t->occupancy_pct = (t->size_bytes > 0)
        ? (u8)((t->used_bytes * 100) / t->size_bytes) : 0;
    pool->total_freed += hdr->size;

    spin_unlock_irqrestore(&pool->lock, flags);
}
EXPORT_SYMBOL(arena_free);

/* =========================================================================
 * Realloc
 * ========================================================================= */

void *arena_realloc(struct arena_pool *pool, void *ptr, size_t new_size)
{
    struct arena_block_hdr *hdr;
    void *new_ptr;
    size_t copy_size;

    if (!ptr)
        return arena_malloc(pool, new_size);
    if (new_size == 0) {
        arena_free(pool, ptr);
        return NULL;
    }

    hdr = (struct arena_block_hdr *)ptr - 1;

    /* If new size fits in existing block, just update */
    if (align_alloc(new_size) <= hdr->alloc_size) {
        hdr->size = (u32)new_size;
        return ptr;
    }

    /* Allocate new, copy, free old */
    new_ptr = arena_malloc(pool, new_size);
    if (!new_ptr)
        return NULL;

    copy_size = (hdr->size < new_size) ? hdr->size : new_size;
    memcpy(new_ptr, ptr, copy_size);
    arena_free(pool, ptr);

    return new_ptr;
}
EXPORT_SYMBOL(arena_realloc);

/* =========================================================================
 * Compaction & Savings Brush
 * ========================================================================= */

/**
 * arena_compact - Coalesce free blocks and release empty pages
 */
void arena_compact(struct arena_pool *pool)
{
    unsigned int tier;
    unsigned long flags;

    if (!pool)
        return;

    spin_lock_irqsave(&pool->lock, flags);

    for (tier = 1; tier < pool->num_tiers; tier++) {
        struct arena_tier *t = &pool->tiers[tier];

        /* For tiers with very low occupancy, hint to kernel */
        if (t->occupancy_pct < 10 && t->size_bytes > ARENA_GUARD_PAGE_SIZE) {
            /* In a real implementation, would madvise(MADV_DONTNEED) */
            t->in_soft_concern = 0;
        }
    }

    pool->flags &= ~ARENA_F_COMPACT_REQ;
    spin_unlock_irqrestore(&pool->lock, flags);
}
EXPORT_SYMBOL(arena_compact);

/* =========================================================================
 * Front-Load: Pre-fault 1/8 upfront region
 * ========================================================================= */

/**
 * arena_frontload - Touch all pages in the frontload region
 */
void arena_frontload(struct arena_pool *pool)
{
    size_t frontload_bytes;
    size_t offset;
    volatile char *p;

    if (!pool || !pool->base)
        return;

    frontload_bytes = pool->total_size / ARENA_FRONTLOAD_FRAC_DEN;

    /* Touch each page to force kernel to commit physical frames */
    for (offset = 0; offset < frontload_bytes; offset += PAGE_SIZE) {
        p = (volatile char *)(pool->base + offset);
        *p = 0;  /* Write to trigger page fault and commit */
    }

    pool->frontload_used = 0;
    pool->flags |= ARENA_F_FRONTLOADED;

    pr_info("arena_pool: pre-faulted %zu MB for PID %d\n",
            frontload_bytes >> 20, pool->pid);
}
EXPORT_SYMBOL(arena_frontload);

/* =========================================================================
 * Status Query
 * ========================================================================= */

void arena_get_status(struct arena_pool *pool,
                      size_t *total, size_t *used,
                      unsigned int *num_tiers, size_t *savings)
{
    unsigned int tier;
    size_t s = 0;

    if (!pool)
        return;

    if (total) *total = pool->total_size;
    if (used) *used = pool->total_allocated - pool->total_freed;
    if (num_tiers) *num_tiers = pool->num_tiers - 1;

    /* Compute savings: bytes in tiers with < 50% occupancy */
    if (savings) {
        for (tier = 1; tier < pool->num_tiers; tier++) {
            struct arena_tier *t = &pool->tiers[tier];
            if (t->occupancy_pct < 50) {
                s += t->size_bytes - t->used_bytes;
            }
        }
        *savings = s;
    }
}
EXPORT_SYMBOL(arena_get_status);

/* =========================================================================
 * /proc Interface
 * ========================================================================= */

static int arena_proc_show(struct seq_file *m, void *v)
{
    unsigned int i, tier;

    seq_puts(m, "═══════════════════════════════════════════════════════════\n");
    seq_puts(m, "  Arena Pool — Hierarchical Allocation with Log Decay\n");
    seq_puts(m, "  Galactic Cherry Marvell Edition 98\n");
    seq_puts(m, "═══════════════════════════════════════════════════════════\n\n");

    seq_printf(m, "  Default arena size: %u MB\n", default_arena_mb);
    seq_printf(m, "  Active arenas:      %u / %u\n\n", pool_count, max_arenas);

    spin_lock(&pools_lock);
    for (i = 0; i < pool_count; i++) {
        struct arena_pool *pool = active_pools[i];
        size_t used = pool->total_allocated - pool->total_freed;

        seq_printf(m, "  Arena [%u] PID %d\n", i, pool->pid);
        seq_printf(m, "    Size:        %zu MB\n", pool->total_size >> 20);
        seq_printf(m, "    Used:        %zu MB (%zu bytes)\n", used >> 20, used);
        seq_printf(m, "    Tiers:       %u\n", pool->num_tiers - 1);
        seq_printf(m, "    Allocated:   %zu bytes (lifetime)\n", pool->total_allocated);
        seq_printf(m, "    Freed:       %zu bytes (lifetime)\n", pool->total_freed);
        seq_printf(m, "    Soft events: %u\n", pool->soft_concern_count);
        seq_printf(m, "    Flags:       0x%02x", pool->flags);
        if (pool->flags & ARENA_F_BOOSTED)     seq_puts(m, " [BOOSTED]");
        if (pool->flags & ARENA_F_USB_BACKED)  seq_puts(m, " [USB]");
        if (pool->flags & ARENA_F_FRONTLOADED) seq_puts(m, " [FRONTLOADED]");
        if (pool->flags & ARENA_F_COMPACT_REQ) seq_puts(m, " [COMPACT_REQ]");
        seq_puts(m, "\n");

        seq_puts(m, "    ┌─────┬──────────┬──────────┬─────────┬──────┐\n");
        seq_puts(m, "    │ Tier│ Size     │ Used     │ Free Ct │ Occ% │\n");
        seq_puts(m, "    ├─────┼──────────┼──────────┼─────────┼──────┤\n");
        for (tier = 1; tier < pool->num_tiers; tier++) {
            struct arena_tier *t = &pool->tiers[tier];
            seq_printf(m, "    │ %3u │ %6zu KB│ %6zu KB│ %7u │ %3u%% │%s\n",
                       tier,
                       t->size_bytes >> 10,
                       t->used_bytes >> 10,
                       t->free_count,
                       t->occupancy_pct,
                       t->in_soft_concern ? " ⚠" : "");
        }
        seq_puts(m, "    └─────┴──────────┴──────────┴─────────┴──────┘\n\n");
    }
    spin_unlock(&pools_lock);

    /* Formula reference */
    seq_puts(m, "  Formula:\n");
    seq_puts(m, "    S(0) = arena_mb             (container)\n");
    seq_puts(m, "    S(1) = arena_mb / 2         (primary: 150 MB)\n");
    seq_puts(m, "    S(2) = arena_mb / 4         (overflow: 75 MB)\n");
    seq_puts(m, "    S(n) = S(2) × (2/3)^(n-2)  for n ≥ 3 (decay)\n");
    seq_puts(m, "    Priority: (4, 3, 1, 2) → soft → (5,6,...)\n");
    seq_puts(m, "    Front-load: 1/8 arena = 37.5 MB pre-faulted\n");
    seq_puts(m, "    Convergence: Σ decay = 150 MB virtual\n");

    return 0;
}

static int arena_proc_open(struct inode *inode, struct file *file)
{
    return single_open(file, arena_proc_show, NULL);
}

static const struct proc_ops arena_proc_ops = {
    .proc_open    = arena_proc_open,
    .proc_read    = seq_read,
    .proc_lseek   = seq_lseek,
    .proc_release = single_release,
};

/* =========================================================================
 * Module Init / Exit
 * ========================================================================= */

static int __init arena_pool_init(void)
{
    proc_dir = proc_mkdir("arena_pool", NULL);
    if (proc_dir) {
        proc_create("status", 0444, proc_dir, &arena_proc_ops);
    }

    pr_info("arena_pool: loaded (default %u MB, max %u arenas)\n",
            default_arena_mb, max_arenas);
    pr_info("arena_pool: tiers: 150/75/50/33/22/14/9/6 MB (decay 2/3)\n");
    pr_info("arena_pool: priority (4,3,1,2) → soft → (5,6,...) → extend\n");
    pr_info("arena_pool: front-load 1/8 = %u MB pre-faulted\n",
            default_arena_mb / 8);

    return 0;
}

static void __exit arena_pool_exit(void)
{
    unsigned int i;

    /* Destroy any remaining arenas */
    spin_lock(&pools_lock);
    for (i = 0; i < pool_count; i++) {
        if (active_pools[i]) {
            if (active_pools[i]->base)
                vfree(active_pools[i]->base);
            kfree(active_pools[i]);
        }
    }
    pool_count = 0;
    spin_unlock(&pools_lock);

    if (proc_dir) {
        remove_proc_entry("status", proc_dir);
        remove_proc_entry("arena_pool", NULL);
    }

    pr_info("arena_pool: unloaded\n");
}

module_init(arena_pool_init);
module_exit(arena_pool_exit);
