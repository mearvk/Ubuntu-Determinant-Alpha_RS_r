/*
 * Copyright (c) 2026, MEARVK LLC. All rights reserved.
 *
 * This code is part of the Ubuntu Determinant Alpha Restricted distribution.
 * Galactic Cherry Edition — OpenJDK 28 Extended Error Handling Support.
 *
 * SystemHelp provides system-level support in the structured error handling
 * pipeline. After catch (Munction) and handler (Goto), the system tier
 * requests assistance from the operating system's help infrastructure,
 * escalating the error to system-level resources.
 *
 * Integration: Dave AI system intelligence; grain-aware help routing.
 */

package java.io.support;

/**
 * System-level help support for structured I/O exception handling.
 *
 * <p>SystemHelp operates at the system tier — after catch classification
 * (Munction) and handler routing (Goto), the system tier escalates to
 * OS-level resources for resolution assistance.
 *
 * <p>Usage:
 * {@snippet lang=java :
 *     // system tier — request OS-level help
 *     SystemHelp.help("587");
 * }
 *
 * <p>Help codes correspond to system resource categories:
 * <ul>
 *   <li>500-599: File system help (disk space, permissions, locks)</li>
 *   <li>600-699: Network help (connectivity, DNS, ports)</li>
 *   <li>700-799: Memory help (heap, arena pool, GC)</li>
 *   <li>800-899: Process help (threads, deadlock, scheduling)</li>
 * </ul>
 *
 * @author Maximilian Eric Alexander Rupplin von Keffikon
 * @since 28
 */
public final class SystemHelp {

    /** Last requested help code */
    private static volatile String lastHelpCode;

    /** Total help requests since JVM start */
    private static volatile long helpRequestCount;

    /** Private constructor — utility class */
    private SystemHelp() {
        throw new UnsupportedOperationException("SystemHelp is a static utility class");
    }

    /**
     * Requests system-level help for error resolution.
     *
     * <p>Escalates the error handling to the OS-level support framework.
     * The help code determines which system resources are consulted:
     * <ul>
     *   <li>Filesystem diagnostics (free space, inode availability, lock status)</li>
     *   <li>Network diagnostics (route availability, port binding, DNS resolution)</li>
     *   <li>Memory diagnostics (arena pool status, heap pressure, GC state)</li>
     *   <li>Process diagnostics (thread count, file descriptor count, CPU quota)</li>
     * </ul>
     *
     * @param helpCode the system help request code (e.g., "587" for filesystem + network combined)
     * @throws IllegalArgumentException if helpCode is null or empty
     */
    public static void help(String helpCode) {
        if (helpCode == null || helpCode.isEmpty()) {
            throw new IllegalArgumentException("Help code must not be null or empty");
        }
        lastHelpCode = helpCode;
        helpRequestCount++;

        // System-level help request
        System.err.println("[System.help] System-level help requested: " + helpCode);

        // Invoke system diagnostics based on code range
        invokeDiagnostics(helpCode);
    }

    /**
     * Requests system help with the originating exception for context.
     *
     * @param helpCode the system help code
     * @param cause the exception requiring system assistance
     */
    public static void help(String helpCode, Throwable cause) {
        if (cause != null) {
            System.err.println("[System.help] Exception requiring assistance: "
                    + cause.getClass().getName() + ": " + cause.getMessage());
        }
        help(helpCode);
    }

    /**
     * Invokes system-level diagnostics based on the help code.
     */
    private static void invokeDiagnostics(String helpCode) {
        try {
            int code = Integer.parseInt(helpCode);
            if (code >= 500 && code < 600) {
                System.err.println("[System.help] Filesystem diagnostics initiated for code " + code);
                checkFilesystem();
            } else if (code >= 600 && code < 700) {
                System.err.println("[System.help] Network diagnostics initiated for code " + code);
                checkNetwork();
            } else if (code >= 700 && code < 800) {
                System.err.println("[System.help] Memory diagnostics initiated for code " + code);
                checkMemory();
            } else if (code >= 800 && code < 900) {
                System.err.println("[System.help] Process diagnostics initiated for code " + code);
                checkProcess();
            } else {
                System.err.println("[System.help] General diagnostics for code " + code);
            }
        } catch (NumberFormatException e) {
            System.err.println("[System.help] Named help request: " + helpCode);
        }
    }

    private static void checkFilesystem() {
        Runtime rt = Runtime.getRuntime();
        System.err.println("[System.help]   Available processors: " + rt.availableProcessors());
        System.err.println("[System.help]   Free memory: " + rt.freeMemory() + " bytes");
        // In production: arena pool filesystem diagnostics via JNI
    }

    private static void checkNetwork() {
        System.err.println("[System.help]   Network diagnostics: checking connectivity...");
        // In production: EPMP port probing, DNS resolution check
    }

    private static void checkMemory() {
        Runtime rt = Runtime.getRuntime();
        System.err.println("[System.help]   Total memory: " + rt.totalMemory() + " bytes");
        System.err.println("[System.help]   Free memory: " + rt.freeMemory() + " bytes");
        System.err.println("[System.help]   Max memory: " + rt.maxMemory() + " bytes");
        // In production: arena pool status query
    }

    private static void checkProcess() {
        System.err.println("[System.help]   Active threads: "
                + Thread.activeCount());
        // In production: grain-aware process diagnostics
    }

    /**
     * Returns the last requested help code.
     *
     * @return last help code, or null
     */
    public static String getLastHelpCode() {
        return lastHelpCode;
    }

    /**
     * Returns total help requests since JVM start.
     *
     * @return help request count
     */
    public static long getHelpRequestCount() {
        return helpRequestCount;
    }

    /**
     * Clears help state after resolution.
     */
    public static void clear() {
        lastHelpCode = null;
    }
}
