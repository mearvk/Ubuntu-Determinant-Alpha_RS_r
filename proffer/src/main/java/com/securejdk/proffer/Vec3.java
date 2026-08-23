package com.securejdk.proffer;

public record Vec3(double x, double y, double z) {
    public static final Vec3 ZERO = new Vec3(0, 0, 0);
    public Vec3 add(Vec3 b) { return new Vec3(x + b.x, y + b.y, z + b.z); }
    public Vec3 sub(Vec3 b) { return new Vec3(x - b.x, y - b.y, z - b.z); }
    public Vec3 scale(double s) { return new Vec3(x * s, y * s, z * s); }
    public double norm() { return Math.sqrt(x*x + y*y + z*z); }
    public Vec3 normalize() { double n = norm(); return n == 0 ? ZERO : scale(1.0 / n); }
    public double distance(Vec3 b) { return sub(b).norm(); }
}
