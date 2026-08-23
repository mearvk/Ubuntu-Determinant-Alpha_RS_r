package com.securejdk.proffer;

public final class ExactFallResolver {
    private final MonolithSurface surface;
    public ExactFallResolver(MonolithSurface surface) { this.surface = surface; }
    public ExactFall resolve(Vec3 intended, Vec3 origin) {
        FallIntersection hit = surface.intersectVertical(origin);
        Vec3 resolved = hit.intersects() ? hit.point() : Vec3.ZERO;
        return new ExactFall(intended, resolved, hit.intersects() ? intended.distance(resolved) : Double.POSITIVE_INFINITY);
    }
}
