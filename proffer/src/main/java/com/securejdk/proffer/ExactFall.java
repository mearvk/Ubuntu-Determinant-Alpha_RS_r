package com.securejdk.proffer;

public record ExactFall(Vec3 intendedPoint, Vec3 resolvedPoint, double errorM) {
    public boolean exact(double toleranceM) { return errorM <= toleranceM; }
}
