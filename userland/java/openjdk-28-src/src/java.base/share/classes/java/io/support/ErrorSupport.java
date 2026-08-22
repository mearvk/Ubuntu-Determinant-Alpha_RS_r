/*
 * Copyright (c) 2026, MEARVK LLC. All rights reserved.
 *
 * This code is part of the Ubuntu Determinant Alpha Restricted distribution.
 * Galactic Cherry Edition — OpenJDK 28 Extended Error Handling Support.
 *
 * ErrorSupport provides the error-level terminal reporting for structured
 * error handling. When all recovery attempts have been exhausted, the error
 * tier reports the final status through the network error intelligence
 * framework, enabling Dave AI and Observer Circuit to correlate system-wide
 * failure patterns.
 *
 * Integration: EPMP-aware error reporting; Dave AI correlation.
 */

package java.io.support;

/**
 * Error-level terminal reporting for structured I/O exception handling.
 *
 * <p>ErrorSupport operates at the final tier of the structured error handling
 * pipeline. After catch (Munction), handler (Goto), and system (SystemHelp)
 * tiers have processed the error, the error tier performs terminal reporting
 * to the network error intelligence framework.
 *
 * <p>The {@code net} method signature indicates network-aware error reporting,
 * suitable for distributed system error correlation.
 *
 * <p>Usage:
 * {@snippet lang=java :
 *     // error tier — terminal report to network intelligence
 *     ErrorSupport.net("587");
 * }
 *
 * @author Maximilian Eric Alexander Rupplin von Keffikon
 * @since 28
 */
public final class ErrorSupport {

    /** Last reported error code */
    private static volatile String lastReportedCode;

    /** Total error reports since JVM start */
    private static volatile long totalReports;

    /** Whether network reporting is enabled */
    private static volatile boolean networkEnabled = true;

    /** Private constructor — utility class */
    private ErrorSupport() {
        throw new UnsupportedOperationException("ErrorSupport is a static utility class");
    }

    /**
     * Reports a terminal error to the network error intelligence framework.
     *
     * <p>This is the final tier of structured error handling. The error code
     * is reported to the system's error correlation network, enabling:
     * <ul>
     *   <li>Dave AI pattern analysis across distributed nodes</li>
     *   <li>Observer Circuit real-time anomaly detection</li>
     *   <li>EPMP-aware error routing to management endpoints</li>
     * </ul>
     *
     * @param errorCode the terminal error code to report (e.g., "587" for I/O exhaustion)
     * @throws IllegalArgumentException if errorCode is null or empty
     */
    public static void net(String errorCode) {
        if (errorCode == null || errorCode.isEmpty()) {
            throw new IllegalArgumentException("Error code must not be null or empty");
        }
        lastReportedCode = errorCode;
        totalReports++;

        // Terminal error report to network intelligence
        System.err.println("[Error.support.net] Terminal error reported: " + errorCode);

        if (networkEnabled) {
            reportToNetwork(errorCode);
        }
    }

    /**
     * Reports a terminal error with the full exception chain for traceability.
     *
     * @param errorCode the terminal error code
     * @param cause the root exception
     */
    public static void net(String errorCode, Throwable cause) {
        net(errorCode);
        if (cause != null) {
            System.err.println("[Error.support.net] Root cause: "
                    + cause.getClass().getName() + ": " + cause.getMessage());
        }
    }

    /**
     * Reports a terminal error with context from all preceding tiers.
     *
     * @param errorCode the terminal error code
     * @param munctionCode the catch-tier classification code
     * @param handlerCode the handler-tier routing code
     * @param systemCode the system-tier help code
     */
    public static void net(String errorCode, String munctionCode,
                           String handlerCode, String systemCode) {
        System.err.println("[Error.support.net] Full pipeline report:");
        System.err.println("  Catch (Munction): " + munctionCode);
        System.err.println("  Handler (Goto):   " + handlerCode);
        System.err.println("  System (Help):    " + systemCode);
        net(errorCode);
    }

    /**
     * Sends error report to network intelligence framework.
     * In production, this routes to Dave AI via EPMP extended ports.
     */
    private static void reportToNetwork(String errorCode) {
        // Network intelligence endpoint integration point
        // In full deployment: EPMP port >65535 for internal error telemetry
        System.err.println("[Error.support.net] Network report queued for code: " + errorCode);
    }

    /**
     * Returns the last reported terminal error code.
     *
     * @return last error code, or null if none reported
     */
    public static String getLastReportedCode() {
        return lastReportedCode;
    }

    /**
     * Returns total error reports since JVM start.
     *
     * @return total report count
     */
    public static long getTotalReports() {
        return totalReports;
    }

    /**
     * Enables or disables network error reporting.
     *
     * @param enabled true to enable network reports, false for local-only
     */
    public static void setNetworkEnabled(boolean enabled) {
        networkEnabled = enabled;
    }

    /**
     * Clears error reporting state.
     */
    public static void clear() {
        lastReportedCode = null;
    }
}
