/* SPDX-License-Identifier: GPL-2.0 */
/*
 * linux/arena_pool.h — Public API for Hierarchical Pool Allocation
 *
 * Include this header from kernel modules or subsystems that want to
 * use per-process arena allocation with logarithmic decay tiering.
 *
 * See mm/arena_pool.h for full data structure definitions.
 * See mm/arena_pool.c for implementation.
 * See TECH.md for mathematical specification.
 *
 * Copyright (C) 2026 MEARVK LLC
 */

#ifndef _LINUX_INCLUDE_ARENA_POOL_H
#define _LINUX_INCLUDE_ARENA_POOL_H

#include <linux/types.h>

/* Forward declaration */
struct arena_pool;

/* Arena creation flags */
#define ARENA_F_BOOSTED     0x01   /* Pre-fault upfront region at creation */
#define ARENA_F_USB_BACKED  0x02   /* Decay tiers 5+ backed by USB swap */

/* Create/Destroy */
struct arena_pool *arena_pool_create(unsigned int size_mb, u32 flags);
void arena_pool_destroy(struct arena_pool *pool);

/* Allocation */
void *arena_malloc(struct arena_pool *pool, size_t size);
void  arena_free(struct arena_pool *pool, void *ptr);
void *arena_realloc(struct arena_pool *pool, void *ptr, size_t new_size);

/* Maintenance */
void arena_compact(struct arena_pool *pool);
void arena_frontload(struct arena_pool *pool);

/* Status */
void arena_get_status(struct arena_pool *pool,
                      size_t *total, size_t *used,
                      unsigned int *tiers, size_t *savings);

/* Tier math */
size_t arena_tier_size(unsigned int arena_mb, unsigned int tier);

#endif /* _LINUX_INCLUDE_ARENA_POOL_H */
