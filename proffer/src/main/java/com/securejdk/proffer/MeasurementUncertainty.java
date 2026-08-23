package com.securejdk.proffer;

public record MeasurementUncertainty(double standardUncertainty, double coverageFactor) {
    public double expanded() { return Math.abs(coverageFactor) * standardUncertainty; }
}
