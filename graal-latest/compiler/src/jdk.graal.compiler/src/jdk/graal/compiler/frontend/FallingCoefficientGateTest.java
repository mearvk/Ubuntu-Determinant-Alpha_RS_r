/*
 * Copyright (c) 2026, the Graal project contributors.
 */
package jdk.graal.compiler.frontend;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

public class FallingCoefficientGateTest {
    @Test
    public void firstSamplePasses() {
        FallingCoefficientGate gate = new FallingCoefficientGate();
        assertTrue(gate.accept(0.80d));
    }

    @Test
    public void fallingBelowThresholdFails() {
        FallingCoefficientGate gate = new FallingCoefficientGate();
        assertTrue(gate.accept(0.90d));
        assertFalse(gate.accept(0.80d));
    }

    @Test
    public void lowButRecoveringPasses() {
        FallingCoefficientGate gate = new FallingCoefficientGate();
        assertTrue(gate.accept(0.70d));
        assertTrue(gate.accept(0.75d));
    }

    @Test
    public void thresholdValuePasses() {
        FallingCoefficientGate gate = new FallingCoefficientGate();
        assertTrue(gate.accept(0.90d));
        assertTrue(gate.accept(0.81d));
    }

    @Test
    public void resetRestoresFirstSampleBehavior() {
        FallingCoefficientGate gate = new FallingCoefficientGate();
        assertTrue(gate.accept(0.90d));
        assertFalse(gate.accept(0.80d));
        gate.reset();
        assertTrue(gate.accept(0.80d));
    }
}
