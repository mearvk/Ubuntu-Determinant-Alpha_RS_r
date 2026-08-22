/*
 * Copyright (c) 2026, MEARVK LLC. All rights reserved.
 *
 * Ubuntu Determinant Alpha Restricted — Galactic Cherry Edition
 * OpenJDK 28 Munction Native Pipeline Buffer
 *
 * This C file provides the native (JNI) backing for Munction's
 * arena-allocated message pipeline buffers. When the JVM runs on
 * a system with arena pool support, Munction pipelines are backed
 * by contiguous arena memory for zero-copy message passing.
 *
 * Build: Compiled as part of libjava.so via the OpenJDK build system.
 *        Requires: jni.h, jni_util.h
 *
 * Architecture:
 *   - Ring buffer for pipeline messages (fixed slots, wrapping)
 *   - Arena allocation for zero-copy between pipeline stages
 *   - Lock-free append for concurrent pipeline construction
 *   - Memory-mapped delivery for final-tier outputs
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdatomic.h>
#include <pthread.h>
#include <sys/mman.h>
#include <unistd.h>
#include <errno.h>

/* JNI headers — resolved at OpenJDK build time */
#include "jni.h"
#include "jni_util.h"

/* ═══════════════════════════════════════════════════════════════════
 * Constants
 * ═══════════════════════════════════════════════════════════════════ */

/** Maximum pipeline message payload size (bytes) */
#define MUNCTION_MAX_PAYLOAD_SIZE    4096

/** Number of message slots in the ring buffer */
#define MUNCTION_RING_CAPACITY       1024

/** Arena block size for allocation (64KB aligned) */
#define MUNCTION_ARENA_BLOCK_SIZE    (64 * 1024)

/** Maximum concurrent pipelines */
#define MUNCTION_MAX_PIPELINES       256

/** Magic number for arena validation */
#define MUNCTION_ARENA_MAGIC         0x4D554E43  /* "MUNC" */

/* ═══════════════════════════════════════════════════════════════════
 * Data Structures
 * ═══════════════════════════════════════════════════════════════════ */

/**
 * A single message slot in the ring buffer.
 * Fixed-size for cache-line alignment and predictable access patterns.
 */
typedef struct munction_message {
    char     payload[MUNCTION_MAX_PAYLOAD_SIZE];   /* message content */
    char     operation[64];                         /* operation name */
    int      tier;                                  /* 1=initial, 2=medium, 3=final */
    int      payload_len;                           /* actual payload length */
    long     timestamp_ns;                          /* nanosecond timestamp */
    _Atomic int ready;                              /* 1 = slot contains valid data */
} munction_message_t;

/**
 * Ring buffer for pipeline messages.
 * Lock-free single-producer, single-consumer.
 */
typedef struct munction_ring {
    munction_message_t  slots[MUNCTION_RING_CAPACITY];
    _Atomic long        write_pos;      /* next write position */
    _Atomic long        read_pos;       /* next read position */
    _Atomic long        total_written;  /* total messages ever written */
    _Atomic long        total_read;     /* total messages ever read */
    _Atomic int         active;         /* 1 = ring is active */
} munction_ring_t;

/**
 * Arena allocator for zero-copy message buffers.
 * Allocates from a contiguous mmap'd region.
 */
typedef struct munction_arena {
    unsigned int magic;           /* validation magic */
    void        *base;            /* base address of arena */
    size_t       capacity;        /* total arena capacity */
    _Atomic size_t offset;        /* current allocation offset */
    int          fd;              /* file descriptor for mmap (or -1 for anon) */
    _Atomic int  ref_count;       /* reference count for safe deallocation */
} munction_arena_t;

/**
 * Global pipeline registry.
 * Tracks active pipelines for monitoring and correlation.
 */
typedef struct munction_registry {
    munction_ring_t   *pipelines[MUNCTION_MAX_PIPELINES];
    munction_arena_t  *arena;
    _Atomic int        pipeline_count;
    _Atomic long       global_msg_count;
    pthread_mutex_t    registry_lock;
    _Atomic int        initialized;
} munction_registry_t;

/* Global registry — singleton */
static munction_registry_t g_registry = {
    .pipeline_count = 0,
    .global_msg_count = 0,
    .initialized = 0
};

/* ═══════════════════════════════════════════════════════════════════
 * Arena Allocator
 * ═══════════════════════════════════════════════════════════════════ */

/**
 * Creates a new arena allocator backed by anonymous mmap.
 *
 * @param capacity  the total arena size in bytes
 * @return pointer to the arena, or NULL on failure
 */
static munction_arena_t* munction_arena_create(size_t capacity) {
    munction_arena_t *arena = (munction_arena_t *)malloc(sizeof(munction_arena_t));
    if (!arena) return NULL;

    /* Align capacity to page size */
    long page_size = sysconf(_SC_PAGESIZE);
    capacity = ((capacity + page_size - 1) / page_size) * page_size;

    /* Anonymous mmap for contiguous memory */
    void *base = mmap(NULL, capacity, PROT_READ | PROT_WRITE,
                      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (base == MAP_FAILED) {
        free(arena);
        return NULL;
    }

    arena->magic = MUNCTION_ARENA_MAGIC;
    arena->base = base;
    arena->capacity = capacity;
    atomic_store(&arena->offset, 0);
    arena->fd = -1;
    atomic_store(&arena->ref_count, 1);

    return arena;
}

/**
 * Allocates memory from the arena (bump allocator).
 * Thread-safe via atomic fetch-add.
 *
 * @param arena  the arena to allocate from
 * @param size   bytes to allocate
 * @param align  alignment requirement (must be power of 2)
 * @return pointer to allocated memory, or NULL if exhausted
 */
static void* munction_arena_alloc(munction_arena_t *arena, size_t size, size_t align) {
    if (!arena || arena->magic != MUNCTION_ARENA_MAGIC) return NULL;

    size_t current, aligned, new_offset;
    do {
        current = atomic_load(&arena->offset);
        aligned = (current + align - 1) & ~(align - 1);
        new_offset = aligned + size;
        if (new_offset > arena->capacity) return NULL;
    } while (!atomic_compare_exchange_weak(&arena->offset, &current, new_offset));

    return (char *)arena->base + aligned;
}

/**
 * Resets the arena — all prior allocations become invalid.
 * Use only when all references to arena memory are released.
 */
static void munction_arena_reset(munction_arena_t *arena) {
    if (!arena || arena->magic != MUNCTION_ARENA_MAGIC) return;
    atomic_store(&arena->offset, 0);
}

/**
 * Destroys the arena and releases the mmap'd memory.
 */
static void munction_arena_destroy(munction_arena_t *arena) {
    if (!arena || arena->magic != MUNCTION_ARENA_MAGIC) return;
    if (atomic_fetch_sub(&arena->ref_count, 1) == 1) {
        munmap(arena->base, arena->capacity);
        arena->magic = 0;
        free(arena);
    }
}

/* ═══════════════════════════════════════════════════════════════════
 * Ring Buffer Operations
 * ═══════════════════════════════════════════════════════════════════ */

/**
 * Creates a new ring buffer for a pipeline.
 * If arena is available, allocates from arena; otherwise uses malloc.
 */
static munction_ring_t* munction_ring_create(munction_arena_t *arena) {
    munction_ring_t *ring;

    if (arena) {
        ring = (munction_ring_t *)munction_arena_alloc(
            arena, sizeof(munction_ring_t), 64);
    } else {
        ring = (munction_ring_t *)calloc(1, sizeof(munction_ring_t));
    }

    if (!ring) return NULL;

    memset(ring, 0, sizeof(munction_ring_t));
    atomic_store(&ring->write_pos, 0);
    atomic_store(&ring->read_pos, 0);
    atomic_store(&ring->total_written, 0);
    atomic_store(&ring->total_read, 0);
    atomic_store(&ring->active, 1);

    return ring;
}

/**
 * Appends a message to the ring buffer.
 * Lock-free for single producer.
 *
 * @return 0 on success, -1 if ring is full
 */
static int munction_ring_append(munction_ring_t *ring,
                                 const char *payload, int payload_len,
                                 const char *operation, int tier) {
    if (!ring || !atomic_load(&ring->active)) return -1;

    long wp = atomic_load(&ring->write_pos);
    long rp = atomic_load(&ring->read_pos);

    /* Check if ring is full */
    if (wp - rp >= MUNCTION_RING_CAPACITY) return -1;

    int slot_idx = (int)(wp % MUNCTION_RING_CAPACITY);
    munction_message_t *slot = &ring->slots[slot_idx];

    /* Write message to slot */
    int copy_len = payload_len < MUNCTION_MAX_PAYLOAD_SIZE - 1
                   ? payload_len : MUNCTION_MAX_PAYLOAD_SIZE - 1;
    memcpy(slot->payload, payload, copy_len);
    slot->payload[copy_len] = '\0';
    slot->payload_len = copy_len;

    int op_len = (int)strlen(operation);
    int op_copy = op_len < 63 ? op_len : 63;
    memcpy(slot->operation, operation, op_copy);
    slot->operation[op_copy] = '\0';

    slot->tier = tier;

    /* Timestamp: clock_gettime for nanosecond precision */
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    slot->timestamp_ns = (long)ts.tv_sec * 1000000000L + ts.tv_nsec;

    /* Publish: mark ready and advance write position */
    atomic_store(&slot->ready, 1);
    atomic_fetch_add(&ring->write_pos, 1);
    atomic_fetch_add(&ring->total_written, 1);

    return 0;
}

/**
 * Reads the next message from the ring buffer.
 *
 * @return pointer to the message slot, or NULL if empty
 */
static munction_message_t* munction_ring_read(munction_ring_t *ring) {
    if (!ring || !atomic_load(&ring->active)) return NULL;

    long rp = atomic_load(&ring->read_pos);
    long wp = atomic_load(&ring->write_pos);

    if (rp >= wp) return NULL;  /* empty */

    int slot_idx = (int)(rp % MUNCTION_RING_CAPACITY);
    munction_message_t *slot = &ring->slots[slot_idx];

    if (!atomic_load(&slot->ready)) return NULL;

    /* Advance read position */
    atomic_store(&slot->ready, 0);
    atomic_fetch_add(&ring->read_pos, 1);
    atomic_fetch_add(&ring->total_read, 1);

    return slot;
}

/**
 * Returns the number of pending (unread) messages.
 */
static long munction_ring_pending(munction_ring_t *ring) {
    if (!ring) return 0;
    return atomic_load(&ring->write_pos) - atomic_load(&ring->read_pos);
}

/* ═══════════════════════════════════════════════════════════════════
 * Registry Operations
 * ═══════════════════════════════════════════════════════════════════ */

/**
 * Initializes the global Munction registry.
 * Called once on first pipeline creation.
 */
static int munction_registry_init(void) {
    if (atomic_load(&g_registry.initialized)) return 0;

    pthread_mutex_init(&g_registry.registry_lock, NULL);

    /* Create global arena (16MB default) */
    g_registry.arena = munction_arena_create(16 * 1024 * 1024);
    if (!g_registry.arena) {
        fprintf(stderr, "[Munction/C] Failed to create arena\n");
        return -1;
    }

    memset(g_registry.pipelines, 0, sizeof(g_registry.pipelines));
    atomic_store(&g_registry.pipeline_count, 0);
    atomic_store(&g_registry.global_msg_count, 0);
    atomic_store(&g_registry.initialized, 1);

    return 0;
}

/**
 * Registers a new pipeline ring with the global registry.
 *
 * @return the pipeline index (slot), or -1 if registry is full
 */
static int munction_registry_add(munction_ring_t *ring) {
    if (!atomic_load(&g_registry.initialized)) {
        if (munction_registry_init() != 0) return -1;
    }

    pthread_mutex_lock(&g_registry.registry_lock);
    int count = atomic_load(&g_registry.pipeline_count);
    if (count >= MUNCTION_MAX_PIPELINES) {
        pthread_mutex_unlock(&g_registry.registry_lock);
        return -1;
    }

    g_registry.pipelines[count] = ring;
    atomic_fetch_add(&g_registry.pipeline_count, 1);
    pthread_mutex_unlock(&g_registry.registry_lock);

    return count;
}

/* ═══════════════════════════════════════════════════════════════════
 * JNI Native Methods
 * ═══════════════════════════════════════════════════════════════════ */

/*
 * Class:     java_io_support_MunctionNative
 * Method:    nativeCreatePipeline
 * Signature: ()J
 *
 * Creates a native ring buffer for a Munction pipeline.
 * Returns the native handle (pointer cast to long).
 */
JNIEXPORT jlong JNICALL
Java_java_io_support_MunctionNative_nativeCreatePipeline(JNIEnv *env, jclass cls) {
    if (!atomic_load(&g_registry.initialized)) {
        munction_registry_init();
    }

    munction_ring_t *ring = munction_ring_create(g_registry.arena);
    if (!ring) {
        JNU_ThrowOutOfMemoryError(env, "Failed to allocate Munction ring buffer");
        return 0;
    }

    int slot = munction_registry_add(ring);
    if (slot < 0) {
        /* Registry full — ring was arena-allocated, will be freed with arena */
        JNU_ThrowByName(env, "java/lang/IllegalStateException",
                        "Munction pipeline registry full");
        return 0;
    }

    return (jlong)(uintptr_t)ring;
}

/*
 * Class:     java_io_support_MunctionNative
 * Method:    nativeAppend
 * Signature: (JLjava/lang/String;Ljava/lang/String;I)I
 *
 * Appends a message to the native ring buffer.
 */
JNIEXPORT jint JNICALL
Java_java_io_support_MunctionNative_nativeAppend(JNIEnv *env, jclass cls,
                                                   jlong handle,
                                                   jstring payload,
                                                   jstring operation,
                                                   jint tier) {
    munction_ring_t *ring = (munction_ring_t *)(uintptr_t)handle;
    if (!ring) return -1;

    const char *payload_str = (*env)->GetStringUTFChars(env, payload, NULL);
    const char *op_str = (*env)->GetStringUTFChars(env, operation, NULL);

    if (!payload_str || !op_str) {
        if (payload_str) (*env)->ReleaseStringUTFChars(env, payload, payload_str);
        if (op_str) (*env)->ReleaseStringUTFChars(env, operation, op_str);
        return -1;
    }

    int payload_len = (int)strlen(payload_str);
    int result = munction_ring_append(ring, payload_str, payload_len, op_str, tier);

    (*env)->ReleaseStringUTFChars(env, payload, payload_str);
    (*env)->ReleaseStringUTFChars(env, operation, op_str);

    if (result == 0) {
        atomic_fetch_add(&g_registry.global_msg_count, 1);
    }

    return result;
}

/*
 * Class:     java_io_support_MunctionNative
 * Method:    nativePending
 * Signature: (J)J
 *
 * Returns the number of pending messages in the ring.
 */
JNIEXPORT jlong JNICALL
Java_java_io_support_MunctionNative_nativePending(JNIEnv *env, jclass cls,
                                                    jlong handle) {
    munction_ring_t *ring = (munction_ring_t *)(uintptr_t)handle;
    return (jlong)munction_ring_pending(ring);
}

/*
 * Class:     java_io_support_MunctionNative
 * Method:    nativeGlobalMessageCount
 * Signature: ()J
 *
 * Returns the global message count across all pipelines.
 */
JNIEXPORT jlong JNICALL
Java_java_io_support_MunctionNative_nativeGlobalMessageCount(JNIEnv *env, jclass cls) {
    return (jlong)atomic_load(&g_registry.global_msg_count);
}

/*
 * Class:     java_io_support_MunctionNative
 * Method:    nativeArenaUsage
 * Signature: ()J
 *
 * Returns current arena memory usage in bytes.
 */
JNIEXPORT jlong JNICALL
Java_java_io_support_MunctionNative_nativeArenaUsage(JNIEnv *env, jclass cls) {
    if (!g_registry.arena) return 0;
    return (jlong)atomic_load(&g_registry.arena->offset);
}

/*
 * Class:     java_io_support_MunctionNative
 * Method:    nativeArenaCapacity
 * Signature: ()J
 *
 * Returns total arena capacity in bytes.
 */
JNIEXPORT jlong JNICALL
Java_java_io_support_MunctionNative_nativeArenaCapacity(JNIEnv *env, jclass cls) {
    if (!g_registry.arena) return 0;
    return (jlong)g_registry.arena->capacity;
}

/*
 * Class:     java_io_support_MunctionNative
 * Method:    nativeDestroyPipeline
 * Signature: (J)V
 *
 * Marks a pipeline ring as inactive (arena memory freed on arena reset).
 */
JNIEXPORT void JNICALL
Java_java_io_support_MunctionNative_nativeDestroyPipeline(JNIEnv *env, jclass cls,
                                                            jlong handle) {
    munction_ring_t *ring = (munction_ring_t *)(uintptr_t)handle;
    if (ring) {
        atomic_store(&ring->active, 0);
    }
}

/*
 * Class:     java_io_support_MunctionNative
 * Method:    nativeResetArena
 * Signature: ()V
 *
 * Resets the global arena. All pipeline rings become invalid.
 * Only call when no pipelines are active.
 */
JNIEXPORT void JNICALL
Java_java_io_support_MunctionNative_nativeResetArena(JNIEnv *env, jclass cls) {
    if (!g_registry.arena) return;

    pthread_mutex_lock(&g_registry.registry_lock);

    /* Deactivate all pipelines */
    int count = atomic_load(&g_registry.pipeline_count);
    for (int i = 0; i < count; i++) {
        if (g_registry.pipelines[i]) {
            atomic_store(&g_registry.pipelines[i]->active, 0);
            g_registry.pipelines[i] = NULL;
        }
    }
    atomic_store(&g_registry.pipeline_count, 0);

    /* Reset arena memory */
    munction_arena_reset(g_registry.arena);

    pthread_mutex_unlock(&g_registry.registry_lock);
}
