package com.securejdk.proffer;

public record ProcessDiagonal(Vec3 start, Vec3 end, double processTime) {
    public Vec3 direction() { return end.sub(start).normalize(); }
}
