package com.securejdk.proffer;

public record FallVector(Vec3 origin, Vec3 direction, double magnitude) {
    public FallVector normalized() { return new FallVector(origin, direction.normalize(), magnitude); }
}
