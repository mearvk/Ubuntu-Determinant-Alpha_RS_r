package com.securejdk.proffer;

public final class AtomicResolutionModel {
    public static final double NOMINAL = 1000.01;
    public static final double PARTS = 10.01;
    public static final double RELATIVE_FRACTION = 0.0101;
    public AtomicResolution create(double center) {
        double half = Math.abs(center) * RELATIVE_FRACTION;
        return new AtomicResolution(center, center - half, center + half, RELATIVE_FRACTION);
    }
}
