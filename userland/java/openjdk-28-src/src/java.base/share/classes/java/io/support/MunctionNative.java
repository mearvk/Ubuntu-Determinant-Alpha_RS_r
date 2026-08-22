/*
 * Copyright (c) 2026, MEARVK LLC. All rights reserved.
 *
 * Ubuntu Determinant Alpha Restricted — Galactic Cherry Edition
 * OpenJDK 28 Munction Native Bridge
 *
 * JNI bridge to the native arena-backed ring buffer for Munction pipelines.
 * When running on systems with arena pool support, Munction uses native
 * memory for zero-copy message passing between pipeline stages.
 *
 * Falls back to pure Java (ArrayList-based) when native library is unavailable.
 */

package java.io.support;

/**
 * Native bridge for Munction arena-backed pipeline buffers.
 *
 * <p>Provides JNI access to the C-level ring buffer and arena allocator.
 * The native layer offers:
 * <ul>
 *   <li>Lock-free ring buffer for message append/read</li>
 *   <li>Arena allocation for zero-copy message passing</li>
 *   <li>Nanosecond-precision timestamps via clock_gettime</li>
 *   <li>Global pipeline registry for correlation</li>
 * </ul>
 *
 * <p>If the native library is not available (e.g., non-Linux platforms),
 * Munction operates in pure-Java mode with no degradation in API.
 *
 * @author Maximilian Eric Alexander Rupplin von Keffikon
 * @since 28
 */
final class MunctionNative {

    /** Whether native support is available */
    private static final boolean NATIVE_AVAILABLE;

    static {
        boolean loaded = false;
        try {
            System.loadLibrary("java");  // MunctionNative.c is part of libjava.so
            loaded = true;
        } catch (UnsatisfiedLinkError e) {
            // Native not available — fall back to pure Java
            loaded = false;
        }
        NATIVE_AVAILABLE = loaded;
    }

    /** Private constructor — static utility */
    private MunctionNative() {}

    /**
     * Returns whether native arena-backed buffers are available.
     */
    static boolean isAvailable() {
        return NATIVE_AVAILABLE;
    }

    // ═══════════════════════════════════════════════════════════════════
    // Native Methods (implemented in MunctionNative.c)
    // ═══════════════════════════════════════════════════════════════════

    /**
     * Creates a native ring buffer pipeline.
     * @return native handle (pointer), or 0 on failure
     */
    static native long nativeCreatePipeline();

    /**
     * Appends a message to the native ring buffer.
     * @param handle the pipeline handle
     * @param payload message content
     * @param operation the operation name
     * @param tier the processing tier (1, 2, or 3)
     * @return 0 on success, -1 on failure
     */
    static native int nativeAppend(long handle, String payload,
                                    String operation, int tier);

    /**
     * Returns pending message count in the ring.
     * @param handle the pipeline handle
     * @return number of unread messages
     */
    static native long nativePending(long handle);

    /**
     * Returns global message count across all native pipelines.
     * @return total messages processed
     */
    static native long nativeGlobalMessageCount();

    /**
     * Returns current arena memory usage in bytes.
     * @return bytes used
     */
    static native long nativeArenaUsage();

    /**
     * Returns total arena capacity in bytes.
     * @return total capacity
     */
    static native long nativeArenaCapacity();

    /**
     * Destroys a pipeline (marks ring inactive).
     * @param handle the pipeline handle
     */
    static native void nativeDestroyPipeline(long handle);

    /**
     * Resets the global arena — invalidates all pipelines.
     */
    static native void nativeResetArena();
}
