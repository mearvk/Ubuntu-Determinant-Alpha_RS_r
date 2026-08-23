/*
 * Copyright (c) 2026, the Graal project contributors.
 *
 * Experimental SecureJDK integration: falling-coefficient input gate.
 */
package jdk.graal.compiler.frontend;

/**
 * Stateful gate for an externally supplied normalized input coefficient.
 *
 * <p>The input fails only when its current coefficient is below the configured threshold and is
 * falling relative to the previous sample. The direction check is deliberately kept separate from
 * the threshold check so a low value that is recovering does not fail this gate.
 */
public final class FallingCoefficientGate {
    /** Default failure threshold requested by the SecureJDK integration. */
    public static final double DEFAULT_THRESHOLD = 0.81d;

    private final double threshold;
    private double previous;
    private boolean initialized;

    public FallingCoefficientGate() {
        this(DEFAULT_THRESHOLD);
    }

    public FallingCoefficientGate(double threshold) {
        if (!Double.isFinite(threshold)) {
            throw new IllegalArgumentException("threshold must be finite");
        }
        this.threshold = threshold;
    }

    /**
     * Accept the next coefficient sample.
     *
     * @return {@code true} when the input should pass the gate; {@code false} when it is below the
     *         threshold and falling.
     */
    public boolean accept(double coefficient) {
        if (!Double.isFinite(coefficient)) {
            throw new IllegalArgumentException("coefficient must be finite");
        }

        boolean falling = initialized && coefficient < previous;
        boolean fail = coefficient < threshold && falling;
        previous = coefficient;
        initialized = true;
        return !fail;
    }

    public double threshold() {
        return threshold;
    }

    public boolean initialized() {
        return initialized;
    }

    public double previous() {
        return previous;
    }

    /** Reset the directional state without changing the configured threshold. */
    public void reset() {
        initialized = false;
        previous = 0.0d;
    }
}
