package com.securejdk.proffer;

public record MonolithGeometry(double areaM2, double nominalThicknessM, double minThicknessM, double maxThicknessM) {
    public static final MonolithGeometry DEFAULT = new MonolithGeometry(40.0, 3.0, 2.0, 4.0);
    public double radiusM() { return Math.sqrt(areaM2 / Math.PI); }
    public double thicknessAt(double normalizedRadius) {
        double r = Math.max(0, Math.min(1, normalizedRadius));
        return minThicknessM + (maxThicknessM - minThicknessM) * (1.0 - r);
    }
}
