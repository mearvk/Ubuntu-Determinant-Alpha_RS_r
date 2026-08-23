package com.securejdk.proffer;

public final class MonolithSurface {
    private final MonolithGeometry geometry;
    public MonolithSurface(MonolithGeometry geometry) { this.geometry = geometry; }
    public FallIntersection intersectVertical(Vec3 origin) {
        double r = Math.hypot(origin.x(), origin.y());
        if (r > geometry.radiusM()) return new FallIntersection(false, Vec3.ZERO, Double.NaN);
        double z = geometry.thicknessAt(r / geometry.radiusM());
        return new FallIntersection(true, new Vec3(origin.x(), origin.y(), z / 2.0), origin.z() - z / 2.0);
    }
}
